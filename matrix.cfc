component accessors=true {

  property name="jGPIO";
  property name="jGPIOUtil";
  property name="jShift";

  property name="pData";
  property name="pClock";
  property name="pLatch";

  property name="matrix";
  property name="animations";

  function init( animation='' ) {
    jgpio = createObject( 'java', 'com.pi4j.wiringpi.Gpio')
    jgpioUtil = createObject( 'java', 'com.pi4j.wiringpi.GpioUtil')
    jshift = createObject( 'java', 'com.pi4j.wiringpi.Shift')
   
    jGpio.wiringPiSetup()
  
    pData = 15
    pClock = 16
    pLatch = 1
    
    jGpioUtil.export( pData, jGpioUtil.DIRECTION_OUT );
    jGpio.pinMode( pData, jGpio.OUTPUT );
  
    jGpioUtil.export( pClock, jGpioUtil.DIRECTION_OUT );
    jGpio.pinMode( pClock, jGpio.OUTPUT );
  
    jGpioUtil.export( pLatch, jGpioUtil.DIRECTION_OUT );
    jGpio.pinMode( pLatch, jGpio.OUTPUT );
  
    jgpio.digitalWrite( pData, false)
    jgpio.digitalWrite( pClock, false)
    jgpio.digitalWrite( pLatch, false)

    matrix = ''

    setAnimations( [] )
    loadAnimations( arguments.animation  )

  }
  
  function loadAnimations( animation=''  ) {
    if( len( animation ) ) {
        getAnimations().append( new Animation( this, '/home/pi/animations/' & arguments.animation ) )
    } else {
      var files = directoryList( '/home/pi/animations' )
      for( var file in files ) {
        getAnimations().append( new Animation( this, file ) )
      }
    }
  }

  public function run() {

    keepRefreshing = true
    threadName=createUUID()

    thread action="run" name=threadName priority="HIGH" {
      try {
        start=getTickCount()
        count = 0
          while( keepRefreshing ) {
            display( matrix  )
            count++
          }
          systemOutput(count/((getTickCount()-start)/1000))
          clear()
      } catch( any e ) {
         systemOutput( e.message, true )
      }
    }

    
    try {
      
      for( var oAnimation in getAnimations() ) {
        oAnimation.execute()
      }
  
    } finally {
      // Regardless of what errors happen, make sure the thread exits
      keepRefreshing = false;
      thread action="join" name=threadName;
    }
  }
  
  private function display( matrix ) {
    matrix = trim( matrix )
    var i = 1
    // Loop over each row and bang it in
    for( var row in listToArray( matrix, chr(13) & chr(10) )) {
      showRow( i++, row )
    }
  }
  
  private function showRow( col, rows ) {
    // Turn on the column. Represent 1, 2, 3, 4... as 1, 10, 11, 100... converted back to base 10, so 1, 2, 4, 8...
    var colBits = 2^(col-1)
  
    // Turn on the active rows.  Convert the bits (10101010) as base 10 (170)
    var rowBits = inputBaseN( rows, 2 )
  
    shiftOut( colBits, rowBits )
  }
  
  // byte is base 10 representation of 8 bits
  // Pass in at least one byte parameter
  private function shiftOut( byte ) {
  
    // Shift each byte in order
    for( var thisByte in arguments ) {
      jshift.shiftOut( pdata, pclock, jshift.MSBFIRST, arguments[ thisByte ] )
    }
  
    // Shift registers are full.  Latch it in!
    latch()
    sleep(1)
  }
  
  private function latch( ) {
    jgpio.digitalWrite( pLatch, true)
    jgpio.digitalWrite( pLatch, false)
  }
  
  private function clear() {
    // Shift out 2 bytes of zeros
    shiftOut( 0, 0 )
  }


}

component accessors=true {
  property name="matrix";
  property name="mode" default="frames";
  property name="loop" default="1";
  property name="delay" default="200";
  property name="frames";


  function init( required matrix matrix, animationPath  ) {
    setMatrix( arguments.matrix )
    setFrames( [] )
    
    if( fileExists( animationPath ) ) {
      var fileContents = listToArray( fileRead( animationPath ), chr( 10 ) )
      var i = 0
      while( ++i <= fileContents.len() ) {
        var line = fileContents[ i ]
        var cmd = trim( listFirst( line, ' ' ) )
        var value = listlast( line, ' ' )
        if( cmd == 'mode' ) {
          setMode( trim( value ) )
        } else if( cmd == 'loop' ) {
          setLoop( max( val( value ), 1 ) )
        } else if( cmd == 'delay' ) {
          setDelay( val( value ) )
        } else if( cmd == 'frame' ) {
          var frame = newFrame()
          loop from=1 to=8 index="local.j" {
            if( i < fileContents.len() ) {
              frame.frame = 	listAppend( frame.frame, fileContents[ ++i ], chr(10) )
            }
          }
          getFrames().append( frame )
        } 
      }
   } else {
     systemOutput( '[#animationPath#]  not found.', true )
   }
  }

  function newFrame() {
    return {
      delay : getDelay(),
      frame : ''
    }
  }

  function execute() {
    loop from=1 to="#getLoop()#" index="local.p" {
      for( var frame in getFrames() ) {
        getMatrix().setMatrix( frame.frame )
        sleep( frame.delay )
      }
    }
  }

}

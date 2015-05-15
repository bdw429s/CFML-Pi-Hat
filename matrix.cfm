<cfscript>
try {
  param name="$1" default="";
  oMatrix = new Matrix( $1  )

  oMatrix.run()
} catch( any e ) {
  systemOutput( serializeJSON( e ) )
}
</cfscript>

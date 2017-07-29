pushd "%~dp0"

mkdir "%programdata%\Propellerhead Software\Remote\Codecs\Lua Codecs\Catblack"
xcopy "Codecs\Lua Codecs\Catblack" "%programdata%\Propellerhead Software\Remote\Codecs\Lua Codecs\Catblack" /E

mkdir "%programdata%\Propellerhead Software\Remote\Maps\Catblack"
xcopy "Maps\Catblack" "%programdata%\Propellerhead Software\Remote\Maps\Catblack" /E

popd


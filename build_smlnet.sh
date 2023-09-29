echo "@$SMLNETPATH/lib/smlnj-lib/Util/Util" > algorithmd.smlnet
echo "@$SMLNETPATH/lib/mlyacc-lib/mlyacc-lib" >> algorithmd.smlnet
cat >> algorithmd.smlnet <<EOL
export Main
make
EOL

echo "" > Main.sml
mlton -stop f algorithmd.mlb \
    | grep -v ".mlb" \
    | grep -v "/lib/mlton/sml/" \
    | grep -v "/lib/mlton/targets/" \
    | while read line ; do \
     if [[ $line == *.mlton.sml ]] ; then \
       if [ -f "${line/%.mlton.sml/.polyml.sml}" ]; then \
         echo "${line/%.mlton.sml/.polyml.sml}" ; \
       elif [ -f "${line/%.mlton.sml/.default.sml}" ]; then \
         echo "${line/%.mlton.sml/.default.sml}" ; \
       elif [ -f "${line/%.mlton.sml/.common.sml}" ]; then \
         echo "${line/%.mlton.sml/.common.sml}" ; \
       elif [ -f "${line/%.mlton.sml/.sml}" ]; then \
         echo "${line/%.mlton.sml/.sml}" ; \
       fi \
     elif [[ $line == *.mlton.fun ]] ; then \
       if [ -f "${line/%.mlton.fun/.polyml.fun}" ]; then \
         echo "${line/%.mlton.fun/.polyml.fun}" ; \
       elif [ -f "${line/%.mlton.fun/.default.fun}" ]; then \
         echo "${line/%.mlton.fun/.default.fun}" ; \
       elif [ -f "${line/%.mlton.fun/.common.fun}" ]; then \
         echo "${line/%.mlton.fun/.common.fun}" ; \
       elif [ -f "${line/%.mlton.fun/.fun}" ]; then \
         echo "${line/%.mlton.fun/.fun}" ; \
       fi \
     elif [[ $line == *.mlton.sig ]] ; then \
       if [ -f "${line/%.mlton.sig/.polyml.sig}" ]; then \
         echo "${line/%.mlton.sig/.polyml.sig}" ; \
       elif [ -f "${line/%.mlton.sig/.default.sig}" ]; then \
         echo "${line/%.mlton.sig/.default.sig}" ; \
       elif [ -f "${line/%.mlton.sig/.common.sig}" ]; then \
         echo "${line/%.mlton.sig/.common.sig}" ; \
       elif [ -f "${line/%.mlton.sig/.sig}" ]; then \
         echo "${line/%.mlton.sig/.sig}" ; \
       fi \
     else\
       echo "$line" ; \
     fi \
    done \
  | while read line ; do cat $line >> Main.sml ; done

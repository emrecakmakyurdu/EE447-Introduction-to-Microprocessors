;LABEL	DIRECTIVE	VALUE	COMMENT
		AREA		main,READONLY,CODE
		THUMB
		EXTERN		OutChar
		EXTERN		InChar
		EXPORT		__main
			
__main
get		BL			InChar
		CMP			R5,#0x20
		NOP
		NOP
		NOP
		BEQ			done
		BL			OutChar
		B			get
done	B			done


		END
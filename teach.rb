Words=File.read('/Users/darren/Documents/words').split

#when type correctly skill++
#when type incorrectly skill--
#when have to wait for answer skill/=2
Decay=0.95 #decay of knowledge over time skill*=
Mastery_cutoff=5 #need all skill > 5

#keys to learn in this order
Teach="etaoinshrdlcu.,mwfgypbvkjxqz?!"
Mastery=[0]*Teach.length
#start already knowing this many
$know=($*[-1]||4).to_i #command line arg for how many know at start
Mastery[0...$know]=[Mastery_cutoff+1]*$know

Mapping = "# aroslyepxmhgujtndcwbq?ifkz.v^<";
Mapping2="#\nAROSLYEPXMHGUJTNDCWBQ!IFKZ,V_<";
Home_keys=['a','o','e','t']

#choose a word that maximizes our progression
def choose_word
	ordered=Words.sort_by{|word|
		word.bytes.map{|char|
			index=Teach.index(char)
	
			#only value lessons up to next unknown letter
			if index>$know+1
				-2
			elsif Mastery[index]<Mastery_cutoff+0.5
				1.5+Mastery_cutoff-Mastery[index]
			else
				(2.0*Mastery_cutoff-Mastery[index])/Mastery_cutoff/10
			end
		}.inject(:+)*1.0/word.length+rand/10
	}
	training=ordered[-3..-1]
	
	#teach punctuation
	if $know>=Teach.index('.') && (Mastery[Teach.index('.')]<Mastery_cutoff+0.5 || Mastery[Teach.index(',')]<Mastery_cutoff+0.5)
		training[2]+='.'
		training[0]+=','
	end
	if $know>=Teach.index('?') && (Mastery[Teach.index('?')]<Mastery_cutoff+0.5 || Mastery[Teach.index('!')]<Mastery_cutoff+0.5)
		training[2]+='?'
		training[0]+='!'
	end
	
	#teach shift
	if $know > 10
		training[0]=training[0][0,1].upcase+training[0][1..-1]
	end
	
	training*' '
end


def progress
	x=0
	Mastery.each{|i|
		if i>Mastery_cutoff
			x+=1
		else
			x+=1.0*i/Mastery_cutoff
		end
	}
	[0, x/Mastery.length].max
end

def cls
	puts "\n"*50
end

def show_progress
	cols=80
	prog=((cols-2)*progress).floor
	puts '|'+'='*prog+' '*(cols-2-prog)+'|'
end

def getch
#http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/2999
	begin
	  system("stty raw -echo")
	  str = STDIN.getc
	ensure
	  system("stty -raw echo")
	end
	str
end

def get_combo(mapping, letter)
	on_bits=mapping.index(letter.chr)
	hint=''
	1.upto(4){|i|
		if on_bits[i]==1
			hint+=Home_keys[i-1]
		else
			hint+='.'
		end
	}
	if on_bits[0]==1
		hint+=' space'
	end
	hint
end

def get_hint(cur,word)
	#if we have extra characters that are wrong suggest backspace
	if word.index(cur)!=0
		'all 5'
	#if need to capitalize next letter suggest shift+next letter
	elsif !Mapping.index(word[cur.length])
		'toea and then '+get_combo(Mapping2,word[cur.length])
	#otherwise suggest next letter
	else
		get_combo(Mapping,word[cur.length])
	end
end

Teach.each_char.to_a.sort.each{|i|puts [i, get_hint('',i)]*' '}
exit

def show_screen(cur,word)
	show_progress
	puts word
	print cur
end

while progress<1
	#choose a random word that maximizes progress
	
	word=choose_word
	cur=''
	
	while cur!=word
		hint=get_hint(cur,word)
		next_letter= hint=='all 5' ? nil : word[cur.length].chr.downcase
		
		#give hint right away if unseen
		if hint=='all 5' || (next_letter && Teach.index(next_letter) && Mastery[Teach.index(next_letter)]<=0)
			cls
			puts 'hint: "'+hint+'"'+"\n"
			t1 = nil	
			show_screen(cur,word)
		else
			cls
			show_screen(cur,word)	
			Thread.abort_on_exception = true
			t1 = Thread.new{
				sleep(3)
				system("stty -raw echo")
				cls
				puts 'hint: "'+hint+'"'+"\n"		
				show_screen(cur,word)
				if next_letter && Teach.index(next_letter)
					Mastery[Teach.index(next_letter)]=[0,Mastery[Teach.index(next_letter)]-3].max
				end
				system("stty raw -echo")
			}
		end
		
		key=getch()
		print key.chr
		t1.kill if t1
		
		if next_letter
			learn_index=Teach.index(next_letter)
			if learn_index
				if key==word[cur.length]
					puts "\n"+'Right!'
					Mastery[learn_index]+=1
				else
					puts "\n"+'Wrong :('
					Mastery[learn_index]=[0,Mastery[learn_index]-1].max
				end
			end
		end
		
		if key==127
			if !cur.empty?
				cur=cur[0...-1]
			end
		else
			cur=cur+key.chr
		end
	end
	
	#end of word, do decay
	Mastery.map!{|i|i*Decay}
	
	#see if we have mastered new letter
	while Mastery[$know] && Mastery[$know]>Mastery_cutoff
		$know+=1
	end
	
	#p Mastery
end

puts 'You have mastered the KeyDisembark!'

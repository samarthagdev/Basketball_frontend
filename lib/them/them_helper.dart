import 'package:basketball_frontend/login/facebook.dart';
import 'package:basketball_frontend/main.dart';
import 'package:basketball_frontend/main/mainhomepage.dart';
import 'package:basketball_frontend/login/gmail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart' as location1;
import 'package:showcaseview/showcaseview.dart';

class ThemeHelper {
  List<String> places = ['Abu', 'Achhnera', 'Adalaj', 'Adoni', 'Adoor', 'Adra', 'Adyar', 'Afzalpur', 'Agartala', 'Agra', 'Ahmadnagar', 'Ahmedabad', 'Aizawl', 'Ajmer', 'Akola', 'Akot', 'Alappuzha', 'Aligarh', 'Alipore', 'Alipur', 'Alipurduar', 'Alirajpur', 'Allinagaram', 'Almora', 'Aluva', 'Alwar', 'Alwar', 'Amalapuram', 'Amalner', 'Amaravathi', 'Amaravati', 'Ambala', 'Ambedkar', 'Ambejogai', 'Ambikapur', 'Amer', 'Amravati', 'Amreli', 'Amritsar', 'Amroha', 'Anakapalle', 'Anantapur', 'Anantnag', 'Angul', 'Anjangaon', 'Anjar', 'Ankleshwar', 'Ara', 'Arakkonam', 'Arambagh', 'Araria', 'Arcot', 'Arsikere', 'Aruppukkottai', 'Arvi', 'Arwal', 'Asansol', 'Asarganj', 'Ashok', 'Athni', 'Attili', 'Attingal', 'Aurangabad', 'Avinissery', 'Ayodhya', 'Azamgarh', 'Badami', 'Badrinath', 'Bagepalli', 'Bageshwar', 'Bagha', 'Baharampur', 'Bahraich', 'Bajpur', 'Balaghat', 'Balangir', 'Baleshwar', 'Ballari', 'Ballia', 'Bally', 'Balurghat', 'Banda', 'Banhatti', 'Banki', 'Bankura', 'Bapatla', 'Bara', 'Barahiya', 'Baramula', 'Baranagar', 'Barasat', 'Barauli', 'Barauni', 'Barbigha', 'Barbil', 'Bareilly', 'Bareli', 'Bargarh', 'Barh', 'Baripada', 'Barkot', 'Barmer', 'Barpeta', 'Barrackpore', 'Barwani', 'Basirhat', 'Basti', 'Batala', 'Bazar', 'Beawar', 'Begusarai', 'Behar', 'Belagavi', 'Bellampalle', 'Belonia', 'Bengaluru', 'Bettiah', 'Betul', 'Bhabua', 'Bhadrachalam', 'Bhadravati', 'Bhagalpur', 'Bhainsa', 'Bhandara', 'Bharatpur', 'Bharhut', 'Bharuch', 'Bhatapara', 'Bhatpara', 'Bhavnagar', 'Bhawan', 'Bhawanipatna', 'Bheemunipatnam', 'Bhilai', 'Bhilwara', 'Bhimtal', 'Bhind', 'Bhiwani', 'Bhojpur', 'Bhopal', 'Bhowali', 'Bhubaneshwar', 'Bhuj', 'Bhusawal', 'Bhusawar', 'Bhuvanagiri', 'Bid', 'Bidar', 'Bihar', 'Bijnor', 'Bikaner', 'Bilaspur', 'Bindki', 'Bishnupur', 'Bithur', 'Blair', 'Blair*', 'Bobbili', 'Bodh', 'Bodhan', 'Bokaro', 'Bongaigaon', 'Brahmapur', 'Budaun', 'Budge', 'Budhlada', 'Budruk', 'Bulandshahr', 'Buldhana', 'Bundi', 'Burdwan', 'Burhanpur', 'Buxar', 'Byasanagar', 'Cantonment', 'Cantt.', 'Chadchan', 'Chaibasa', 'Chakradharpur', 'Chalakudy', 'Challakere', 'Chamba', 'Chamoli', 'Champawat', 'Chandernagore', 'Chandigarh', 'Chandpara', 'Chandragiri', 'Chandrapur', 'Changanassery', 'Chapra', 'Charkhari', 'Charkhi', 'Charthaval', 'Chatra', 'Chengalpattu', 'Chengannur', 'Chennai', 'Cherrapunji', 'Cherthala', 'Chhapra', 'Chhatarpur', 'Chhindwara', 'Chidambaram', 'Chikkaballapur', 'Chikkamagaluru', 'Chintamani', 'Chirala', 'Chirkunda', 'Chirmiri', 'Chitradurga', 'Chittaurgarh', 'Chittoor', 'Chittur-Thathamangalam', 'Churu', 'City', 'Coimbatore', 'Cooch', 'Cuddalore', 'Cuttack', 'Dabhade', 'Dabra', 'Dabwali', 'Dadri', 'Dalhousie', 'Dalli-Rajhara', 'Daltonganj', 'Daman', 'Damoh', 'Darbhanga', 'Darjeeling', 'Datia', 'Daudnagar', 'Daulatabad', 'Davangere', 'Degana', 'Dehra', 
  'Dehri', 'Delhi', 'Deoghar', 'Deoria', 'Devprayag', 'Dewas', 'Dhamtari', 'Dhanbad', 'Dhar', 'Dharchula', 'Dharmanagar', 'Dharmapuri', 'Dharmshala', 'Dhaulpur', 'Dhenkanal', 'Dhone', 'Dhoraji', 'Dhubri', 'Dhuburi', 'Dhule', 'Dhuri', 'Diamond', 'Dibrugarh', 'Didihat', 'Dildarnagar', 'Dinapur', 'Dindigul', 'Dineshpur', 'Diphu', 'Dispur', 'Diu', 'Doda', 'Dogadda', 'Doiwala', 'Dowlaiswaram', 'Dr.', 'Duar', 'Dum', 'Dumka', 'Dumraon', 'Dun', 'Dungarpur', 'Durg', 'Durgapur', 'Dwarahat', 'Dwarka', 'Ellenabad', 'Eluru', 'Erode', 'Etah', 'Etawah', 'Faizabad', 'Faridabad', 'Faridkot', 'Farooqnagar', 'Farrukhabad', 'Farrukhabad-cum-Fatehgarh', 'Fatehabad', 'Fatehgarh', 'Fatehpur', 'Fazilka', 'Firozpur', 'Forbesganj', 'Gadarpur', 'Gadwal', 'Gandhinagar', 'Ganganagar', 'Gangarampur', 'Gangotri', 'Gangtok', 'Garhwa', 'Gavaravaram', 'Gaya', 'Ghaziabad', 'Ghazipur', 'Ghoti', 'Ghumarwin', 'Giridih', 'Goalpara', 'Gobichettipalayam', 'Gobindgarh', 'Gochar', 'Godhra', 'Gohana', 'Gokak', 'Golaghat', 'Gonda', 'Gooty', 'Gopalganj', 'Gopeshwar', 'Gorakhpur', 'Gowribidanur', 'Gudur', 'Gulmarg', 'Gumia', 'Guna', 'Guntur', 'Gunupur', 'Gurdaspur', 'Gurugram', 'Guruvayoor', 'Guwahati', 'Gwalior', 'Gyalshing', 'Hajipur', 'Halebid', 'Halisahar', 'Hamirpur', 'Hansi', 'Hanumangarh', 'Haora', 'Harbour', 'Hardoi', 'Haridwar', 'Haripura', 'Hassan', 'Hathras', 'Hazaribag', 'Herbertpur', 'Himatnagar', 'Hisar', 'Hoshangabad', 'Hoshiarpur', 'Hubballi-Dharwad', 'Hugli', 'Hyderabad', 'Ichgam', 'Idukki', 'Imphal', 'India', 'Indore', 'Ingraj', 'Inkollu', 'Islampur', 'Itanagar', 'Itarsi', 'Jabalpur', 'Jagdalpur', 'Jaggaiahpet', 'Jagraon', 'Jagtial', 'Jahanabad', 'Jaipur', 'Jaisalmer', 'Jalandhar', 'Jalaun', 'Jalgaon', 'Jalor', 'Jalpaiguri', 'Jamalpur', 'Jammalamadugu', 'Jammu', 'Jamnagar', 'Jamshedpur', 'Jamui', 'Jangaon', 'Janjgir', 'Jaspur', 'Jatani', 'Jaunpur', 'Jaynagar', 'Jhabrera', 'Jhabua', 'Jhalawar', 'Jhansi', 'Jhargram', 'Jharia', 'Jharsuguda', 'Jhirka', 'Jhumri', 'Jhunjhunu', 'Jind', 'Jodhpur', 'Jorhat', 'Joshimath', 'Junagadh', 'Junnardeo', 'Kadapa', 'Kadi', 'Kadiri', 'Kagaznagar', 'Kailasahar', 'Kaithal', 'Kakinada', 'Kalaburagi', 'Kaladhungi', 'Kalan', 'Kalimpong', 'Kallakurichi', 'Kalpi', 'Kalyan', 'Kamareddy', 'Kamarhati', 'Kanchipuram', 'Kanchrapara', 'Kandla', 'Kandukur', 'Kangeyam', 'Kangra', 'Kanhangad', 'Kanigiri', 'Kannauj', 'Kanniyakumari', 'Kannur', 'Kanpur', 'Kapadvanj', 'Kapura', 'Kapurthala', 'Karaikal', 'Kargil', 'Karimganj', 'Karimnagar', 'Karjat', 'Karli', 'Karnal', 'Karnaprayag', 'Karunagappally', 'Karur', 'Kasaragod', 'Kasba', 'Kasibugga', 'Kathua', 'Katihar', 'Kavali', 'Kayamkulam', 'Kedarnath', 'Kela', 'Kendrapara', 'Kendujhar', 'Keshod', 'Khairthal', 'Khajuraho', 'Khambhat', 'Khammam', 'Khand', 'Khanda', 'Khandwa', 'Kharagpur', 'Kharar', 'Khargone',
  'Khatima', 'Kheda', 'Khera', 'Kheraganj', 'Khodargama', 'Khowai', 'Ki', 'Kichha', 'Kirtinagar', 'Kishangarh', 'Kochi', 'Kodaikanal', 'Kodungallur', 'Kohima', 'Kokrajhar', 'Kolar', 'Kolhapur', 'Kolkata', 'Kollam', 'Konark', 'Kora', 'Koraput', 'Koratla', 'Kot', 'Kota', 'Kotdwar', 'Kothagudem', 'Kottayam', 'Kovvur', 'Koyilandy', 'Kozhikode', 'Krishnanagar', 'Kullu', 'Kulpahar', 'Kumarganj', 'Kumbakonam', 'Kunnamkulam', 'Kurnool', 'Kurukshetra', 'Kusmar', 'Kyathampalle', 'Lachhmangarh', 'Lachung', 'Ladnu', 'Ladwa', 'Lahar', 'Laharpur', 'Lakheri', 'Lakhimpur', 'Lakhisarai', 'Laksar', 'Lakshmeshwar', 'Lal', 'Lalganj', 'Lalgudi', 'Lalitpur', 'Lalkuan', 'Lalsot', 'Landhaura', 'Lanka', 'Lar', 'Lathi', 'Leh', 'Lilong', 'Limbdi', 'Lingsugur', 'Loha', 'Lohaghat', 'Lohardaga', 'Lonar', 'Lonavla', 'Longowal', 'Losal', 'Lucknow', 'Ludhiana', 'Lumding', 'Lunawada', 'Lunglei', 'Macherla', 'Machilipatnam', 'Maddur', 'Madgaon', 'Madhepura', 'Madhopur', 'Madhubani', 'Madhugiri', 'Madhupur', 'Madikeri', 'Madurai', 'Magadi', 'Mahabaleshwar', 'Mahad', 'Mahalingapura', 'Maharajganj', 'Maharajpur', 'Mahasamund', 'Mahbubnagar', 'Mahe', 'Mahemdabad', 'Mahendragarh', 'Mahesana', 'Maheshwar', 'Mahnar', 'Mahua', 'Maihar', 'Mainaguri', 'Mainpuri', 'Majilpur', 'Makhdumpur', 'Makrana', 'Malaj', 'Malavalli', 'Malda', 'Malegaon', 'Malkangiri', 'Malkapur', 'Malout', 'Malpura', 'Malur', 'Mamallapuram', 'Manachanallur', 'Manasa', 'Manavadar', 'Manawar', 'Mandalgarh', 'Mandamarri', 'Mandapeta', 'Mandawa', 'Mandi', 'Mandideep', 'Mandla', 'Mandsaur', 'Mandvi', 'Mandya', 'Manendragarh', 'Maner', 'Mangaldoi', 'Mangaluru', 'Mangalvedhe', 'Mangan', 
  'Manglaur', 'Mangrol', 'Mangrulpir', 'Maniharan', 'Manihari', 'Manipur', 'Manjlegaon', 'Mankachar', 'Manmad', 'Mansa', 'Manuguru', 'Manvi', 'Manwath', 'Mapusa', 'Margao', 'Margherita', 'Marhaura', 'Mariani', 'Marigaon', 'Markapur', 'Masaurhi', 'Mathabhanga', 'Matheran', 'Mathura', 'Mattancheri', 'Mattannur', 'Mauganj', 'Mavelikkara', 'Mavoor', 'Mayang', 'Medak', 'Meerut', 'Memari', 'Merta', 'Metpally', 'Mhaswad', 'Mhow', 'Mhow', 'Mhowgaon', 'Midnapore', 'Mihijam', 'Mirganj', 'Miryalaguda', 'Mirzapur-Vindhyachal', 'Modasa', 'Mokameh', 'Mokokchung', 'Mon', 'Monoharpur', 'Moradabad', 'Morbi', 'Morena', 'Morinda,', 'Morshi', 'Motihari', 'Motipur', 'Mount', 'Mudabidri', 'Mudalagi', 'Muddebihal', 'Mudhol', 'Mukerian', 'Mukhed', 'Muktsar', 'Mul', 'Mulbagal', 'Multai', 'Mumbai', 'Mundargi', 'Mundi', 'Mungeli', 'Munger', 'Muni', 'Murliganj', 'Murshidabad', 'Murtijapur', 'Murwara', 'Musabani', 'Mussoorie', 'Muvattupuzha', 'Muzaffarnagar', 'Muzaffarpur', 'Mysuru', 'Nabadwip', 'Nabarangapur', 'Nabha', 'Nadbai', 'Nadiad', 'Nagaon', 'Nagappattinam', 'Nagar', 'Nagari', 'Nagarjunakoṇḍa', 'Nagarkurnool', 'Nagaur', 'Nagercoil', 'Nagina', 'Nagla', 'Nagpur', 'Nahan', 'Naharlagun', 'Naidupet', 'Naila', 'Nainital', 'Nainpur', 'Najibabad', 'Nakodar', 'Nakur', 'Nalbari', 'Namagiripettai', 'Namakkal', 'Nandaprayag', 'Nanded', 'Nandgaon', 'Nandivaram-Guduvancheri', 'Nandura', 'Nangal', 'Nanjangud', 'Nanjikottai', 'Nanpara', 'Narasapuram', 'Naraura', 'Narayanpet', 'Narendranagar', 'Nargund', 'Narkatiaganj', 'Narkhed', 'Narnaul', 'Narsimhapur', 'Narsinghgarh', 'Narsipatnam', 'Narwana', 'Narwar', 'Nashik', 'Nasirabad', 'Natham', 'Nathdwara', 'Naugachhia', 'Naugawan', 'Naura', 'Nautanwa', 'Navalgund', 'Navsari', 'Nawabganj', 'Nawada', 'Nawanshahr', 'Nawapur', 'Nedumangad', 'Nedumbassery', 'Neem-Ka-Thana', 'Neemuch', 'Nehtaur', 'Nelamangala', 'Nellikuppam', 'Nepanagar', 'New', 'Newra', 'Neyyattinkara', 'Nidadavole', 'Nilambur', 'Nilanga', 'Nimbahera', 'Nindaura', 'Nirmal', 'Niwai', 'Niwari', 'Nizamabad', 'Nizamat', 'Nohar', 'Nokha', 'Nongstoin', 'Noorpur', 'North', 'Nowgong', 'Nowrozabad', 'Nuzvid', "O'", 'Obra', 'Oddanchatram', 'Okha', 'Orchha', 'Osmanabad', 'Ottappalam', 'Owk', 'Ozar', 'P.N.Patti', 'Pachora', 'Pachore', 'Pacode', 'Padmanabhapuram', 'Padra', 'Padrauna', 'Paithan', 'Pakaur', 'Palai', 'Palakkad', 'Palampur', 'Palani', 'Palanpur', 'Palasa', 'Palashi', 'Palayamkottai', 'Palghar', 'Pali', 'Palia', 'Palitana', 'Palladam', 'Pallapatti', 'Pallikonda', 'Palwancha', 'Panagar', 'Panagudi', 'Panaji', 'Panaji*', 'Panamattom', 'Panchla', 'Pandharkaoda', 'Pandharpur', 'Pandhurna', 'Pandua', 'Panihati', 'Panipat', 'Panna', 'Panniyannur', 'Panruti', 'Pappinisseri', 'Paradip', 'Paramakudi', 'Parangipettai', 'Parasi', 'Paravoor', 'Parbhani', 'Pardi', 'Parlakhemundi', 
  'Parli', 'Partapgarh', 'Partur', 'Parvathipuram', 'Pasan', 'Paschim', 'Pasighat', 'Patan', 'Pathanamthitta', 'Pathardi', 'Pathri', 'Patiala', 'Patna', 'Patratu', 'Pattamundai', 'Patti', 'Pattran', 'Pattukkottai', 'Patur', 'Pauni', 'Pauri', 'Pavagada', 'Pedana', 'Peddapuram', 'Pehowa', 'Pen', 'Perambalur', 'Peravurani', 'Peringathur', 'Perinthalmanna', 'Periyakulam', 'Periyasemur', 'Pernampattu', 'Perumbavoor', 'Petlad', 'Phalodi', 'Phaltan', 'Phek', 'Phillaur', 'Phul', 'Phulabani', 'Phulera', 'Phulpur', 'Pihani', 'Pilani', 'Piler', 'Pilibanga', 'Pilibhit', 'Pilkhuwa', 'Pindwara', 'Pipar', 'Piriyapatna', 'Piro', 'Pithampur', 'Pithapuram', 'Pithoragarh', 'Polur', 'Ponnani', 'Ponneri', 'Ponnur', 'Poonch', 'Porbandar', 'Porsa', 'Port', 'Powayan', 'Prantij', 'Pratapgarh', 'Prayagraj', 'Prithvipur', 'Puducherry', 'Pudukkottai', 'Pudupattinam', 'Pukhrayan', 'Pulgaon', 'Puliyankudi', 'Punalur', 'Punch', 'Pune', 'Punganur', 'Punjaipugalur', 'Punropara', 'Puranpur', 'Puri', 'Purna', 'Purnia', 'Purquazi', 'Purulia', 'Purwa', 'Pusa', 'Pusad', 'Pushkar', 'Puthuppally', 'Puttur', 'Qadian', 'RFC', 'Rabkavi', 'Radhanpur', 'Rae', 'Rafiganj', 'Raghogarh-Vijaypur', 'Raghunathpur', 'Rahatgarh', 'Rahuri', 'Raichur', 'Raiganj', 'Raikot', 'Raipur', 'Rairangpur', 'Raisen', 'Raisinghnagar', 'Rajagangapur', 'Rajahmundry', 'Rajakhera', 'Rajaldesar', 'Rajam', 'Rajapalayam', 'Rajauri', 'Rajepur', 'Rajesultanpur', 'Rajgarh', 'Rajgir', 'Rajkot', 'Rajmahal', 'Rajnandgaon', 'Rajouri', 'Rajpipla', 'Rajpura', 'Rajsamand', 'Rajula', 'Rajura', 'Ramachandrapuram', 'Ramanagaram', 'Ramanathapuram', 'Ramdurg', 'Rameshwaram', 'Ramganj', 'Ramnagar', 'Ramngarh', 'Rampur', 'Rampura', 'Rampurhat', 'Ramtek', 'Ranavav', 'Ranchi', 'Rangiya', 'Rania', 'Ranibennur', 'Rao', 'Rapar', 'Rasipuram', 'Rasra', 'Ratangarh', 'Rath', 'Ratia', 'Ratlam', 'Ratnagiri', 'Rau', 'Raver', 'Rawatbhata', 'Rawatsar', 'Raxaul', 'Rayachoti', 'Rayadurg', 'Rayagada', 'Reengus', 'Rehli', 'Renigunta', 'Renukoot', 'Reoti', 'Repalle', 'Reti', 'Revelganj', 'Rewa', 'Rewari', 'Rishikesh', 'Risod', 'Road', 'Robertsganj', 'Rohtak', 'Ron', 'Rosera', 'Rudauli', 'Rudraprayag', 'Rudrapur', 'Rupnagar', 'Sabalgarh', 'Sadabad', 'Sadasivpet', 'Sadat', 'Sadri', 'Sadulshahar', 'Safidon', 'Safipur', 'Sagar', 'Sagara', 'Sagwara', 'Saharanpur', 'Saharsa', 'Sahaspur','Sahaswan', 'Sahawar', 'Sahib', 'Sahibganj', 'Sahjanwa', 'Saidpur', 'Saiha', 'Sailu', 'Sainthia', 'Sakaleshapura', 'Sakti', 'Salaya', 'Salem', 'Salumbar', 'Salur', 'Samalkha', 'Samalkot', 'Samana', 'Samastipur', 'Sambalpur', 'Sambhal', 'Sambhar', 'Samdhan', 'Samthar', 'Sanand', 'Sanawad', 'Sanchore', 'Sandi', 'Sandila', 'Sanduru', 'Sangamner', 'Sangareddi', 'Sangareddy', 'Sangaria', 'Sangli', 'Sangole', 'Sangrur', 'Sanivarapupeta', 'Sankagiri', 'Sankarankovil', 'Sankeshwara', 'Santipur', 'Saraikela', 'Sarangpur', 'Sardarshahar', 'Sardhana', 'Sarni', 'Sarsawa', 'Sarsod', 'Sasaram', 'Sasvad', 'Satana', 'Satara', 'Sathyamangalam', 'Satna', 'Satrampadu', 'Sattenapalle', 'Sattur', 'Saunda', 'Saundatti-Yellamma', 'Sausar', 'Savanur', 'Savarkundla', 'Savner', 'Sawai', 'Sawantwadi', 'Sedam', 'Sehore', 'Sendhwa', 'Seohara', 'Seoni', 'Seoni-Malwa', 'Sevagram', 'Shahabad', 'Shahabad,', 'Shahade', 'Shahbad', 'Shahdol', 'Shahganj', 'Shahjahanpur', 'Shahpur', 'Shahpura', 'Shajapur', 'Shaktigarh', 'Shamgarh', 'Shamli', 'Shamsabad,', 'Shantiniketan', 'Sharif', 'Shegaon', 'Sheikhpura', 'Shendurjana', 'Shenkottai', 'Sheoganj', 'Sheohar', 'Sheopur', 'Sherghati', 'Sherkot', 'Shiggaon', 'Shikaripur', 'Shikarpur,', 'Shikohabad', 'Shillong', 'Shimla', 'Shirdi', 'Shirpur-Warwade', 'Shirur', 'Shishgarh', 'Shivamogga', 'Shivpuri', 'Sholavandan', 'Sholingur', 'Shoranur', 'Shravanabelagola', 'Shrigonda', 'Shrirampur', 'Shrirangapattana', 'Shujalpur', 'Siana', 'Sibsagar', 'Siddipet', 'Sidhi', 'Sidhpur', 'Sidlaghatta', 'Sihawa', 'Sihor', 'Sihora', 'Sikanderpur', 'Sikandra', 'Sikandrabad', 'Sikar', 'Sikri', 'Silao', 'Silapathar', 'Silchar', 'Siliguri', 'Sillod', 'Silvassa', 'Silvassa*', 'Simdega', 'Sindagi', 'Sindhagi', 'Sindhnur', 'Singhana', 'Sinnar', 'Sira', 'Sircilla', 'Sirhind', 'Sirkali', 'Sirohi', 'Sironj', 'Sirsa', 'Sirsaganj', 'Sirsi', 'Siruguppa', 'Sitamarhi', 'Sitapur', 'Sitarganj', 'Siuri', 'Sivaganga', 'Sivagiri', 'Sivasagar', 'Siwan', 'Sohagpur', 'Sohna', 'Sojat', 'Solan', 'Solapur', 'Sonamukhi', 'Sonepur', 'Songadh', 'Sonipat', 'Sopore', 'Soro', 'Soron', 'Soyagaon', 'Sri', 'Srikakulam', 'Srikalahasti', 'Srinagar', 'Srinagar,', 'Srinivaspur', 'Srirampore', 'Srisailam', 'Srivilliputhur', 'Suar', 'Sugauli', 'Sujangarh', 'Sujanpur', 'Sullurpeta', 'Sultanganj', 'Sultanpur', 'Sumerpur', 'Sunabeda', 'Sunam', 'Sundargarh', 'Sundarnagar', 'Supaul', 'Surandai', 'Surapura', 'Surat', 'Suratgarh', 'Surendranagar', 'Suri', 'Suriyampalayam', 'Suroth-Hindaun', 'Takhatgarh', 'Taki', 'Talaja', 'Talbehat', 'Talcher', 'Talegaon', 'Talikota', 'Taliparamba', 'Talode', 'Talwara', 'Tamluk', 'Tanakpur', 'Tanda', 'Tandur', 'Tanuku', 'Tarakeswar', 'Taran', 'Tarana', 'Taranagar', 'Taraori', 'Tarbha', 'Tarikere', 'Tarn', 'Tasgaon', 'Tehri', 'Tekkalakote', 'Tenkasi', 'Tenu', 'Terdal', 'Tezpur', 'Thakurdwara', 'Thalassery', 'Thammampatti', 'Thana', 'Thane', 'Thangadh', 'Thanjavur', 'Tharad', 'Tharamangalam', 'Tharangambadi', 'Theni', 'Thirumangalam', 'Thirupuvanam', 'Thiruthuraipoondi', 'Thiruvalla', 'Thiruvallur', 'Thiruvananthapuram', 'Thiruvarur', 'Thodupuzha', 'Thoothukudi', 'Thoubal', 'Thrippunithura', 'Thrissur', 'Thuraiyur', 'Tikamgarh', 'Tilaiya', 'Tilda', 'Tilhar', 'Tindivanam', 'Tinsukia', 'Tiptur', 'Tirora', 'Tiruchchirappalli', 'Tiruchendur', 'Tiruchengode', 'Tirukalukundram', 'Tirukkoyilur', 'Tirunelveli', 'Tirupathur', 'Tirupati', 'Tiruppur', 'Tirur', 'Tiruttani', 'Tiruvethipuram', 'Tiruvuru', 'Tirwaganj', 'Titagarh', 'Titlagarh', 'Tittakudi', 'Todabhim', 'Todaraisingh', 'Tohana', 'Tonk', 'Township', 'Tuensang', 'Tuljapur', 'Tulsipur', 'Tumakuru', 'Tumsar', 'Tundla', 'Tuni', 'Tura', 'Uchgaon', 'Udaipur', 'Udaipurwati', 'Udayagiri', 'Udhagamandalam', 'Udhampur', 'Udumalaipettai', 'Ujhani', 'Ujjain', 'Ulhasnagar', 'Umarga', 'Umargam', 'Umaria', 'Umarkhed', 'Umred', 'Umreth', 'Una', 'Unjha', 'Unnamalaikadai', 'Upleta', 'Uran', 'Uravakonda', 'Urmar', 'Usilampatti', 'Uthamapalayam', 'Uthiramerur', 'Utraula', 'Uttarakhand', 'Uttarkashi', 'Vadakkuvalliyur', 'Vadalur', 'Vadgaon', 'Vadnagar', 'Vaijapur', 'Vaikom', 'Valley', 'Valparai', 'Valsad', 'Vandavasi', 'Vaniyambadi', 'Vapi', 'Varanasi', 'Varandarappilly', 'Varkala', 'Vasai-Virar', 'Vatakara', 'Vedaranyam', 'Vellakoil', 'Vellore', 'Venkatagiri', 'Veraval', 'Vidisha', 'Vijainagar,', 'Vijapur', 'Vijayapura', 'Vijayawada', 'Vijaypur', 'Vikarabad', 'Vikasnagar', 'Vikramasingapuram', 'Viluppuram', 'Vinukonda', 'Viramgam', 'Virudhachalam', 'Virudhunagar', 'Visakhapatnam', 'Visnagar', 'Viswanatham', 'Vita', 'Vizianagaram', 'Vrindavan', 'Vuyyuru', 'Vyara', 'Wadgaon', 'Wadhwan', 'Wadi', 'Wai', 'Wanaparthy', 'Wani', 'Wankaner', 'Wara', 'Warangal', 'Wardha', 'Warhapur', 'Warisaliganj', 'Warora', 'Warud', 'Washim', 'Wokha', 'Yadgir', 'Yanam', 'Yavatmal', 'Yawal', 'Yellandu', 'Yemmiganur', 'Yerraguntla', 'Yevla', 'Zaidpur', 'Zamania', 'Zira', 'Zirakpur', 'Zunheboto', 'dam-cum-Kathhara', 'vasudevanallur'];
  List<String> searchFilter= [];
  List<String> filtered = [];
   Future<List<String>?>filter() async{
    return showDialog<List<String>?>(
      context: navigatorKey.currentContext!, 
      builder:(BuildContext context){
        return AlertDialog(
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              height: MediaQuery.of(context).size.height * .8,
              child: StatefulBuilder(
                builder: (context, innerstate) {
                  return Column(
                    children: <Widget>[
                      TextFormField(
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          fillColor: Color(0xFF7f7f7f),
                          filled: true,
                          labelText: 'Search your city',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 42, 41, 44),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                        onChanged: (value){
                          searchFilter.clear();
                          for (var x in places){
                            if((x.toLowerCase()).startsWith(value.toLowerCase())){
                              searchFilter.add(x);
                            }
                          }
                          innerstate((){
                          });
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        height: MediaQuery.of(context).size.height * .6,
                        child: ListView.builder(
                          itemCount: searchFilter.isEmpty ? places.length:searchFilter.length,
                          itemBuilder: (context, index) {
                            String e = searchFilter.isEmpty ? places[index]:searchFilter[index];
                            bool live = false;
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                              child: ListTile(
                                title: Text(e),
                                trailing: Checkbox(
                                  value: filtered.contains(e)?true:live,
                                  onChanged: (bool? value) {
                                    if(value!){
                                      innerstate((){
                                        filtered.add(e);
                                      });
                                    } else{
                                      innerstate((){
                                        filtered.remove(e);
                                      });
                                    }
                                  },
                                ),
                              )
                            );
                          }),
                        ),
                    ],
                  );
                }
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                filtered.clear();
                Navigator.pop(context);
              }, child: const Text("Reset all", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w700))),
            const SizedBox(width: 10,),
            TextButton(
              onPressed: (){
                Navigator.pop(context, filtered);
              }, child: const Text("Filter", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w700)))
          ],
        );
      });
  }
  
  void intro({required List<GlobalKey> s, required String boxName, required BuildContext context})async{
    var box = await Hive.openBox('guide');
    bool introduction = box.get(boxName, defaultValue: false);
    if(!introduction){
      ShowCaseWidget.of(context).startShowCase(s);
      box.put(boxName, true);
    }
  }


  InputDecoration textInputDecoration(IconData icon,
      [String lableText = "", String hintText = "", ]) {
    return InputDecoration(
      fillColor: const Color(0xFFffffff),
      filled: true,
      icon: Icon(icon),
      labelText: lableText,
      labelStyle: const TextStyle(
        color: Color.fromARGB(255, 42, 41, 44),
      ),
      // errorText: errorText,
      hintText: hintText,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }

  InputDecoration textInputDecoration1(
    IconData icon, [
    String lableText = "",
    String hintText = "",
  ]) {
    return InputDecoration(
      fillColor: const Color(0xFFffffff),
      filled: true,
      icon: Icon(icon),
      labelText: lableText,
      labelStyle: const TextStyle(
        color: Color.fromARGB(255, 42, 41, 44),
      ),
      // errorText: errorText,
      hintText: hintText,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }

  ElevatedButton outlinedbutton(BuildContext context,
      ButtonStyle raisedButtonStyle, String text, IconData icon,
      [String? email,
      String? name,
      String? username,
      String? number,
      String? password]) {
    return ElevatedButton (
        style: raisedButtonStyle,
        onPressed: () {
          if (text == 'Gmail') {
            signIn(context: context, loginMethod: 'Gmail');
          } else if (text == 'Facebook') {
            signIn(context: context, loginMethod: 'Facebook');
          }
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon),
          const SizedBox(
            width: 5,
          ),
          Text(text),
        ]));
  }


  Future signIn({required BuildContext context, required loginMethod}) async {
    final user = 'Gmail' == loginMethod
        ? await GoogleSignInApi.login()
        : await Facebook.login();
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Sign in Failded")));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MainHomePage(user: user, loginMethod: loginMethod),
          ));
    }
  }

  Future<String> location_() async {
    location1.Location location = location1.Location();
    bool _serviceEnabled;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // Provider.of<SignUpProvider>(navigatorKey.currentContext!, listen: false).errorMethod('Please Turn on the location to get your city name');
        return Future.error('Location service not enable');
      }
    }

    LocationPermission permission;

    if (!_serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    late String _currentAddress;
//geocoding
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      _currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      throw Exception(e);
    }

    return _currentAddress;
  }

  static Future signout(BuildContext context, method) async {
    if (method == 'Facebook') {
      await FacebookAuth.i.logOut();
    } else if (method == 'Gmail') {
      await GoogleSignInApi.logout();
    }
  }
}

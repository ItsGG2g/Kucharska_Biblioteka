import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MyApp());
}

 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kucharska Biblioteka',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kucharska Biblioteka'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 70.0),
            child: IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShoppingListScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Witaj w aplikacji Kucharska Biblioteka!',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 10),
              Text(
                'Ponad 5 tysięcy przepisów w jednym miejscu',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  // Przejście do strony rejestracji
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                ),
                child: Text(
                  'Zarejestruj',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Przejście do strony logowania
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                ),
                child: Text(
                  'Zaloguj',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Przejście do strony głównej
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                ),
                child: Text(
                  'Zacznij gotować',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<String> _shoppingItems = [];
  List<bool> _checkedItems = [];
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _shoppingItems = _prefs.getStringList('shoppingItems') ?? [];
      _checkedItems = _shoppingItems.map((item) {
        return _prefs.getBool(item) ?? false;
      }).toList();
    });
  }

  void _saveData() async {
    await _prefs.setStringList('shoppingItems', _shoppingItems);
    for (int i = 0; i < _shoppingItems.length; i++) {
      await _prefs.setBool(_shoppingItems[i], _checkedItems[i]);
    }
  }

  void _addItem(String item) {
    setState(() {
      _shoppingItems.add(item);
      _checkedItems.add(false);
      _saveData();
    });
  }

  void _toggleItem(int index) {
    setState(() {
      _checkedItems[index] = !_checkedItems[index];
      _saveData();
    });
  }

  void _removeItem(int index) {
    setState(() {
      _shoppingItems.removeAt(index);
      _checkedItems.removeAt(index);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista zakupów'),
      ),
      body: ListView.builder(
        itemCount: _shoppingItems.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(_shoppingItems[index]),
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    _removeItem(index);
                  },
                ),
              ],
            ),
            leading: Checkbox(
              value: _checkedItems[index],
              onChanged: (_) {
                _toggleItem(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String newItem = '';

              return AlertDialog(
                title: Text('Dodaj produkt'),
                content: TextField(
                  onChanged: (value) {
                    newItem = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _addItem(newItem);
                    },
                    child: Text('Dodaj'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mój Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 100,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsScreen()),
                );
              },
              child: Text('Regulamin'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              child: Text('Ustawienia'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                );
              },
              child: Text('Graj'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Wyloguj'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ustawienia'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Akcja dla przycisku "Konto"
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                'Konto',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10), // Odstęp 10 punktów
            ElevatedButton(
              onPressed: () {
                // Akcja dla przycisku "Prywatność"
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                'Prywatność',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10), // Odstęp 10 punktów
            ElevatedButton(
              onPressed: () {
                // Akcja dla przycisku "Email"
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                'Email',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10), // Odstęp 10 punktów
            ElevatedButton(
              onPressed: () {
                // Akcja dla przycisku "Ciasteczka"
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                'Ciasteczka',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


enum Player { none, human, computer }

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<Player> _board;
  late Player _currentPlayer;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _board = List.filled(9, Player.none);
    _currentPlayer = Player.human;
    _gameOver = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gra'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if (_board[index] == Player.none && !_gameOver) {
                        setState(() {
                          _board[index] = _currentPlayer;
                          _checkGameOver();
                          _switchPlayer();
                          if (_currentPlayer == Player.computer && !_gameOver) {
                            _makeComputerMove();
                          }
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: _buildPlayerIcon(_board[index]),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              _gameOver
  ? Text(
      _currentPlayer == Player.human ? 'Przegrałeś!' : _currentPlayer == Player.computer ? 'Wygrałeś!' : 'Remis!',
      style: TextStyle(fontSize: 24),
    )
  : SizedBox.shrink(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerIcon(Player player) {
    if (player == Player.human) {
      return Icon(Icons.clear, size: 72);
    } else if (player == Player.computer) {
      return Icon(Icons.radio_button_unchecked, size: 72);
    } else {
      return SizedBox.shrink();
    }
  }

 void _checkGameOver() {
  List<List<int>> winningCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8], // rows
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8], // columns
    [0, 4, 8],
    [2, 4, 6] // diagonals
  ];

  for (var combination in winningCombinations) {
    if (_board[combination[0]] == Player.human &&
        _board[combination[1]] == Player.human &&
        _board[combination[2]] == Player.human) {
      setState(() {
        _gameOver = true;
        _currentPlayer = Player.human;
      });
      return;
    } else if (_board[combination[0]] == Player.computer &&
        _board[combination[1]] == Player.computer &&
        _board[combination[2]] == Player.computer) {
      setState(() {
        _gameOver = true;
        _currentPlayer = Player.computer;
      });
      return;
    }
  }

  if (!_board.contains(Player.none)) {
    setState(() {
      _gameOver = true;
      _currentPlayer = Player.none;
    });
  }
}
  void _switchPlayer() {
    _currentPlayer =
        (_currentPlayer == Player.human) ? Player.computer : Player.human;
  }

  void _makeComputerMove() {
    List<int> availableMoves = [];

    for (var i = 0; i < _board.length; i++) {
      if (_board[i] == Player.none) {
        availableMoves.add(i);
      }
    }

    if (availableMoves.isNotEmpty) {
      Random random = Random();
      int randomIndex = random.nextInt(availableMoves.length);
      int computerMove = availableMoves[randomIndex];

      setState(() {
        _board[computerMove] = _currentPlayer;
        _checkGameOver();
        _switchPlayer();
      });
    }
  }
}




class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regulamin'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ac luctus mauris. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Sed id massa pharetra, lacinia sem eget, blandit dolor. Sed vestibulum odio vitae eleifend lacinia. Vivamus auctor elit dolor, nec lacinia purus consectetur ac. Ut nec augue sed nunc mattis posuere. Mauris vulputate lectus nec eleifend ullamcorper. Nunc auctor quam ut nisi gravida vulputate. In nec varius velit. Proin quis justo lorem. Nunc non tincidunt felis, nec luctus lectus.',
                style: TextStyle(fontSize: 16),
              ),
              // Dodaj suwak
              SizedBox(
                height: 400,
                child: Scrollbar(
                  child: ListView(
                    children: [
                      Text(
                        'Suspendisse quis neque sollicitudin, fringilla lorem sed, feugiat orci. Fusce placerat mi eget elit vulputate, sed interdum est tristique. Nunc venenatis ipsum id hendrerit semper. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aenean eu metus id magna feugiat egestas sed in dolor. Donec aliquam magna in ipsum convallis, eu semper orci tincidunt. Nam vitae nibh nec ex tempor efficitur. Proin et commodo risus. Donec et tristique mi, a venenatis tortor. Integer ut odio sollicitudin, efficitur lacus nec, sagittis lacus.',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Praesent aliquam neque metus, sed tempus nisl elementum eu. Integer et tortor vitae dui hendrerit finibus eu non ante. Vivamus in ipsum et tortor varius posuere in sed ex. Nullam eu mi pellentesque, pulvinar dolor in, elementum nulla. Nam eget dui at quam sodales scelerisque. Aliquam interdum eu nibh eget rhoncus. Proin suscipit purus nec orci rhoncus feugiat. Sed tincidunt aliquet massa, nec convallis tortor. Aliquam pellentesque ligula mauris, a placerat ligula ultricies eu. Etiam sed consequat lectus, sed lacinia mi. Phasellus pharetra congue eros, id dapibus nulla vestibulum ac. Fusce sit amet risus at nunc elementum congue id sed libero. Aenean laoreet orci ac leo semper ultricies.',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Praesent aliquam neque metus, sed tempus nisl elementum eu. Integer et tortor vitae dui hendrerit finibus eu non ante. Vivamus in ipsum et tortor varius posuere in sed ex. Nullam eu mi pellentesque, pulvinar dolor in, elementum nulla. Nam eget dui at quam sodales scelerisque. Aliquam interdum eu nibh eget rhoncus. Proin suscipit purus nec orci rhoncus feugiat. Sed tincidunt aliquet massa, nec convallis tortor. Aliquam pellentesque ligula mauris, a placerat ligula ultricies eu. Etiam sed consequat lectus, sed lacinia mi. Phasellus pharetra congue eros, id dapibus nulla vestibulum ac. Fusce sit amet risus at nunc elementum congue id sed libero. Aenean laoreet orci ac leo semper ultricies.',
                        style: TextStyle(fontSize: 16),
                      ),
                      
                      // Możesz dodać więcej tekstów lub innych widżetów, aby przetestować przewijanie
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rejestracja'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Text(
              'Aby przejść dalej proszę się zarejestrować.',
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center, 
            ),
            SizedBox(height: 8),
            Text(
              '(Jeśli masz już konto, wróć do strony głównej i zaloguj się.)',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 200),
            TextField(
              decoration: InputDecoration(
                labelText: 'Login',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Hasło',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Logika rejestracji

                // Przejście do strony głównej po zarejestrowaniu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
              child: Text('Zarejestruj'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logowanie'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Zaloguj się i zacznij gotować!',
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 200),
            TextField(
              decoration: InputDecoration(
                labelText: 'Login',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Hasło',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Logika logowania

                // Przejście do strony głównej po zalogowaniu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
              child: Text('Zaloguj'),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Przejście do strony rejestracji
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: Text('Zarejestruj'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Map<String, dynamic>> recipes = [
    {
      'name': 'Panierowane kotlety z kurczaka z parmezanem',
      'imagePath': 'assets/2.jpg',
      'description': 'Chrupiące i pyszne, panierowane kotlety z piersi kurczaka z parmezanem, czosnkiem i posiekaną natką pietruszki. Bardzo łatwe i szybkie do przygotowania kotlety z kurczaka - doskonałe na szybki obiad dla całej rodziny.',
      'ingredients': '2 duże piersi z kurczaka\n2 duże jajka\n1 łyżka posiekanej natki pietruszki\nokoło 1/2 szklanki tartego parmezanu\nmąka i bułka tarta lub Panko do panierowania kotletów\nsól, pieprz do smaku\nmielony czosnek do smaku\nolej do smażenia'
,
      'instructions': 'Krok 1.\n'
'Filety z kurczaka oczyścić i osuszyć papierowym ręcznikiem. Następnie każdy przekroić wzdłuż na pół, aby otrzymać 4 cieńsze kotlety. Kotleciki powinny być w miarę równej grubości - jeżeli potrzeba, można je delikatnie rozbić tłuczkiem do mięsa.\n\n'
'Krok 2.\n'
'Przygotować dwa płaskie talerzyki i jeden głęboki. Na pierwszy płaski talerz wsypać mąkę, do głębokiego talerza wbić dwa jajka, wsypać posiekaną natkę pietruszki i roztrzepać widelcem, na drugi płaski talerz wsypać bułkę tartą oraz parmezan (mniej więcej 1:1) i wymieszać.\n\n'
'Krok 3.\n'
'Przygotowane kotlety z piersi kurczaka oprószyć z każdej strony solą, pieprzem oraz mielonym czosnkiem. Kotleciki panierować najpierw w mące - nadmiar strzepać, następnie w jajku z natką pietruszki i na koniec w mieszance bułki tartej i parmezanu. Opanierowane kotleciki od razu kładziemy na rozgrzany olej i smażymy na średnim ogniu z obu stron, aż kotlety staną się złocistobrązowe, chrupiące z zewnątrz i w środku będą gotowe.\n\n'
'Usmażone kotlety układać na talerzu wyłożonym papierowym ręcznikiem.',
    },
    {
      'name': 'Kremowe puree ziemniaczane',
      'imagePath': 'assets/3.jpg',
      'description': 'Łatwy i pyszny przepis na puree ziemniaczane. Do ziemniaków dodajemy masło, mleko, kwaśną śmietanę oraz posiekany czosnek. To mój ulubiony przepis na puree z ziemniaków!',
      'ingredients': '1 kg obranych, umytych i pokrojonych w równą kostkę mącznych ziemniaków\nokoło 1/2 szklanki gorącego mleka\n1/3 szklanki miękkiego masła\n3-4 posiekane ząbki czosnku\n1/4 szklanki śmietany',
      'instructions': 'Krok 1. \n Umieścić ziemniaki w garnku z osoloną wodą (woda powinna sięgać około 1-2 cm ponad górną krawędź ziemniaków), zagotować, zmniejszyć ogień i gotować ziemniaki do miękkości przez około 15-20 minut.\nW międzyczasie rozgrzać masło na małej patelni, dodać posiekany czosnek i podsmażyć chwilę, aż zacznie ładnie pachnieć.\n\n Krok 2.\n Ugotowane ziemniaki odcedzić i odparować przez chwilę. Następnie starannie przetrzeć gorące ziemniaki za pomocą specjalnego sitka, tłuczka lub praski do ziemniaków. Pod koniec wlać gorące mleko, dodać masło z czosnkiem oraz śmietanę. Doprawić do smaku solą i wszystko razem dokładnie ze sobą połączyć. Niezbyt długo, gdyż ziemniaki mogą stać się kleiste.',
    },
    {
      'name': 'Sałata masłowa ze śmietaną',
      'imagePath': 'assets/4.jpg',
      'description': 'Łatwa i szybka sałata ze śmietaną i koperkiem do obiadu. Aby przygotować tą sałatkę potrzeba 10 minut i tylko kilku prostych składników.',
      'ingredients': '1 główka sałaty masłowej\n1/2 szklanki kwaśnej, gęstej śmietany\n2-3 łyżki posiekanego koperku\nsól, pieprz, cukier i sok z cytryny do smaku',
      'instructions': 'Krok 1\nZ sałaty usunąć wierzchnie, uszkodzone i zwiędłe liście. Zdrowe liście bardzo dokładnie umyć, osączyć i osuszyć na papierowym ręczniku.\nNastępnie liście sałaty porwać na mniejsze kawałki.\n\n Krok 2\nW miseczce wymieszać śmietanę z odrobiną cukru oraz sokiem z cytryny, doprawić do smaku solą i mielonym, czarnym pieprzem.\nDo sałaty wsypać posiekany koperek, następnie wlać śmietanę i wszystko razem wymieszać.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kucharska Biblioteka'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Wyszukaj przepis',
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Ostatnio oglądane przepisy',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var recipe in recipes)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailsScreen(
                                recipe['name'],
                                recipe['imagePath'],
                                recipe['description'],
                                recipe['ingredients'],
                                recipe['instructions'],
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(recipe['imagePath']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              recipe['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            FavoriteRecipeCheckbox(),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 80),
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PopularRecipesScreen(),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
  ),
  child: Text(
    'Lista przepisów',
    style: TextStyle(fontSize: 20),
  ),
),
SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class PopularRecipesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Najpopularniejsze przepisy'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _buildRecipeCard(
            context,
            'assets/5.jpg',
            'Sałatka jarzynowa',
            'Opis sałatki jarzynowej',
            'Składniki sałatki jarzynowej',
            'Instrukcja sałatki jarzynowej',
          ),
          _buildRecipeCard(
            context,
            'assets/6.jpg',
            'Sałatka jajeczna z awokado',
            'Opis sałatki jajecznej z awokado',
            'Składniki sałatki jajecznej z awokado',
            'Instrukcja sałatki jajecznej z awokado',
          ),
          _buildRecipeCard(
            context,
            'assets/7.jpg',
            'Najlepsza letnia sałatka z pomidorów',
            'Opis najlepszej letniej sałatki z pomidorów',
            'Składniki najlepszej letniej sałatki z pomidorów',
            'Instrukcja najlepszej letniej sałatki z pomidorów',
          ),
          _buildRecipeCard(
            context,
            'assets/8.jpg',
            'Prosta sałatka z tuńczykiem, pomidorami, ogórkiem i oliwą z oliwek',
            'Opis prostej sałatki z tuńczykiem, pomidorami, ogórkiem i oliwą z oliwek',
            'Składniki prostej sałatki z tuńczykiem, pomidorami, ogórkiem i oliwą z oliwek',
            'Instrukcja prostej sałatki z tuńczykiem, pomidorami, ogórkiem i oliwą z oliwek',
          ),
          _buildRecipeCard(
            context,
            'assets/9.jpg',
            'Zupa z kurczakiem i makaronem',
            'Opis zupy z kurczakiem i makaronem',
            'Składniki zupy z kurczakiem i makaronem',
            'Instrukcja zupy z kurczakiem i makaronem',
          ),
          _buildRecipeCard(
            context,
            'assets/10.jpg',
            'Sałatka z kurczakiem i mango',
            'Opis sałatki z kurczakiem i mango',
            'Składniki sałatki z kurczakiem i mango',
            'Instrukcja sałatki z kurczakiem i mango',
          ),
          _buildRecipeCard(
            context,
            'assets/11.jpg',
            'Najlepsze przepisy na dania z sezonowych warzyw',
            'Opis najlepszych przepisów na dania z sezonowych warzyw',
            'Składniki najlepszych przepisów na dania z sezonowych warzyw',
            'Instrukcja najlepszych przepisów na dania z sezonowych warzyw',
          ),
          _buildRecipeCard(
            context,
            'assets/12.jpg',
            'Kurczak z groszkiem i marchewką',
            'Opis kurczaka z groszkiem i marchewką',
            'Składniki kurczaka z groszkiem i marchewką',
            'Instrukcja kurczaka z groszkiem i marchewką',
          ),
          _buildRecipeCard(
            context,
            'assets/13.jpg',
            'Niedzielne ciasto drożdżowe z kruszonką',
            'Opis niedzielnego ciasta drożdżowego z kruszonką',
            'Składniki niedzielnego ciasta drożdżowego z kruszonką',
            'Instrukcja niedzielnego ciasta drożdżowego z kruszonką',
          ),
        ],
      ),
    );
  }

  void _navigateToRecipeDetails(
    BuildContext context,
    String recipeName,
    String imagePath,
    String description,
    String ingredients,
    String instructions,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailsScreen(
          recipeName,
          imagePath,
          description,
          ingredients,
          instructions,
        ),
      ),
    );
  }

  Widget _buildRecipeCard(
    BuildContext context,
    String imagePath,
    String recipeName,
    String description,
    String ingredients,
    String instructions,
  ) {
    return GestureDetector(
      onTap: () {
        _navigateToRecipeDetails(
          context,
          recipeName,
          imagePath,
          description,
          ingredients,
          instructions,
        );
      },
      child: Card(
        child: Row(
          children: [
            Container(
              width: 150,
              height: 100,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                recipeName,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDetailsScreen extends StatelessWidget {
  final String recipeName;
  final String imagePath;
  final String description;
  final String ingredients;
  final String instructions;

  RecipeDetailsScreen(this.recipeName, this.imagePath, this.description, this.ingredients, this.instructions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Szczegóły przepisu:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                description,
              ),
              SizedBox(height: 10),
              Text(
                'Składniki:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                ingredients,
              ),
              SizedBox(height: 10),
              Text(
                'Instrukcje:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                instructions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteRecipeCheckbox extends StatefulWidget {
  @override
  _FavoriteRecipeCheckboxState createState() => _FavoriteRecipeCheckboxState();
}

class _FavoriteRecipeCheckboxState extends State<FavoriteRecipeCheckbox> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}

class FavoriteRecipesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> recipes;

  FavoriteRecipesScreen(this.recipes);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> favoriteRecipes =
        recipes.where((recipe) => recipe['isFavorite']).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Ulubione przepisy'),
      ),
      body: ListView.builder(
        itemCount: favoriteRecipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(
              favoriteRecipes[index]['imagePath'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(favoriteRecipes[index]['name']),
            subtitle: Text(favoriteRecipes[index]['description']),
          );
        },
      ),
    );
  }
}
class SavedRecipesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> recipes;

  SavedRecipesScreen(this.recipes);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> savedRecipes =
        recipes.where((recipe) => recipe['isFavorite']).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Zapisane przepisy'),
      ),
      body: ListView.builder(
        itemCount: savedRecipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(
              savedRecipes[index]['imagePath'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(savedRecipes[index]['name']),
            subtitle: Text(savedRecipes[index]['description']),
          );
        },
      ),
    );
  }
}
const path = require('path');
const express = require('express');
const ejs = require('ejs');
const bodyParser = require('body-parser');
const mysql = require('mysql2');
const app = express();



var json = require('./env.json');
const connection=mysql.createConnection({
    host: json.host,
    user: json.user,
    password: json.password,
    database: json.database,
    port: json.port
});

connection.connect(function(error){
    if(error) console.log(error);
    else console.log('Database Connected!');
}); 

//set views file
app.set('views',path.join(__dirname,'views'));
			
//set view engine
app.set('view engine', 'ejs');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));



app.get('/',(req, res) => {
    // res.send('CRUD Operation using NodeJS / ExpressJS / MySQL');
    let sql = "SELECT * FROM `aluno`";
    let query = connection.query(sql, (err, rows) => {
        if(err) throw err;
        res.render('user_index', {
            title : 'Alunos na base de dados',
            users : rows
        });
    });
});




/////////////////////////////
//Rotas para a Tabela Local//
/////////////////////////////

// Read
app.get('/local',(req, res) => {
    let sql = "SELECT * FROM `local`";
    let query = connection.query(sql, (err, rows) => {
        if(err) throw err;
        res.render('local_index', {
            title : 'Endereços Cadastrados',
            locais : rows
        });
    });
});

// Create
app.get('/local_add',(req, res) => {
    res.render('local_add', {
        title : 'Adicionar informações de Endereço'
    });
});


app.post('/local_save',(req, res) => { 
    let data = {cep: req.body.cep, cidade: req.body.cidade, bairro: req.body.bairro, endereco: req.body.endereco, numero: req.body.numero};
    let sql = "INSERT INTO `local` SET ?";
    let query = connection.query(sql, data,(err, results) => {
        if(err) throw err;
        res.redirect('/local');
    });
});

// Update
app.get('/local_edit/:idlocal',(req, res) => {
    const localId = req.params.idlocal;
    let sql = `Select * from notebooks_para_todos.local where idlocal = ${localId}`;
    let query = connection.query(sql,(err, result) => {
        if(err) throw err;
        res.render('local_edit', {
            title : 'Editar Local',
            local : result[0]
        });
    });
});

app.post('/local_update',(req, res) => {
    const idlocal = req.body.idlocal;
    let sql = "update notebooks_para_todos.local SET cep='"+req.body.cep+"',  cidade='"+req.body.cidade+"',  bairro='"+req.body.bairro+"', endereco='"+req.body.endereco+"', numero='"+req.body.numero+"' where idlocal ="+idlocal;
    let query = connection.query(sql,(err, results) => {
        if(err) throw err;
        res.redirect('/local');
    });
});

// Delete
app.get('/local_delete/:idlocal',(req, res) => {
    const idlocal = req.params.idlocal;
    let sql = `DELETE from notebooks_para_todos.local where idlocal = ${idlocal}`;
    let query = connection.query(sql,(err, result) => {
        if(err) {
            if(err.errno == 1451){
                console.log("Local cadastrado está sendo utilizado por um ou mais Alunos")
                res.render('alert', {
                    title : 'Não é possível deletar',
                    msg: "Local está sendo utilizado por um ou mais Alunos"
                });
            } else {
                throw err;
            }
        } else {
            res.redirect('/local');
        }

    });
});

//////////////////////////////////////////////////
//Rotas para a Tabela de Cadastro Socioeconômico//
//////////////////////////////////////////////////

// Read
app.get('/socioeconomico',(req, res) => {
    let sql = "SELECT * FROM `socioeconomico`";
    let query = connection.query(sql, (err, rows) => {
        if(err) throw err;
        res.render('socioeconomico_index', {
            title : 'Cadastro Socioeconômico',
            cadastros : rows
        });
    });
});

// Create
app.get('/socioeconomico_add',(req, res) => {
    res.render('socioeconomico_add', {
        title : 'Adicionar Cadastro Socioecônomico'
    });
});


app.post('/socioeconomico_save',(req, res) => { 
    var pbf = (!req.body.programa_bolsa_familia) ? 0 : 1;
    var peti = (!req.body.programa_de_erradicacao_do_trabalho_infantil) ? 0 : 1;
    var ppa = (!req.body.programa_projovem_adolescente) ? 0 : 1;

    let data = {numero_de_membros_da_familia: req.body.numero_de_membros_da_familia, renda_per_capita: req.body.renda_per_capita, programa_bolsa_familia: pbf, programa_de_erradicacao_do_trabalho_infantil: peti, programa_projovem_adolescente: ppa};
    let sql = "INSERT INTO `socioeconomico` SET ?";
    let query = connection.query(sql, data,(err, results) => {
        if(err) throw err;
        res.redirect('/socioeconomico');
    });
});

// Update
app.get('/socioeconomico_edit/:id_socioeconomico',(req, res) => {
    const idsocioeconomico = req.params.id_socioeconomico;
    let sql = `Select * from notebooks_para_todos.socioeconomico where id_socioeconomico = ${idsocioeconomico}`;
    let query = connection.query(sql,(err, result) => {
        if(err) throw err;
        res.render('socioeconomico_edit', {
            title : 'Editar cadastro socioeconomico',
            socioeconomico : result[0]
        });
        //console.log(result[0].programa_bolsa_familia == 1);
    });
});

app.post('/socioeconomico_update',(req, res) => {
    var pbf = (!req.body.programa_bolsa_familia) ? 0 : 1;
    var peti = (!req.body.programa_de_erradicacao_do_trabalho_infantil) ? 0 : 1;
    var ppa = (!req.body.programa_projovem_adolescente) ? 0 : 1;

    const id_socioeconomico = req.body.id_socioeconomico;
    let sql = "update notebooks_para_todos.socioeconomico SET numero_de_membros_da_familia='"+req.body.numero_de_membros_da_familia+"',  renda_per_capita='"+req.body.renda_per_capita+"',  programa_bolsa_familia='"+pbf+"', programa_de_erradicacao_do_trabalho_infantil='"+peti+"', programa_projovem_adolescente='"+ppa+"' where id_socioeconomico ="+id_socioeconomico;
    let query = connection.query(sql,(err, results) => {
        if(err) throw err;
        res.redirect('/socioeconomico');
    });
});

// Delete
app.get('/socioeconomico_delete/:id_socioeconomico',(req, res) => {
    const id_socioeconomico = req.params.id_socioeconomico;
    let sql = `DELETE from notebooks_para_todos.socioeconomico where id_socioeconomico = ${id_socioeconomico}`;
    let query = connection.query(sql,(err, result) => {
        if(err) {
            if(err.errno == 1451){
                console.log("Cadastrado Socioeconômico está sendo utilizado por um ou mais Alunos")
                res.render('alert', {
                    title : 'Não é possível deletar',
                    msg: "Cadastrado Socioeconômico está sendo utilizado por um ou mais Alunos"
                });
            } else {
                throw err;
            }
        } else {
            res.redirect('/socioeconomico');
        }

    });
});

// Server Listening
app.listen(3000, () => {
    console.log('Server is running at port 3000');
});
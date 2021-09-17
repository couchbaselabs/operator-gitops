var couchbase = require('couchbase');

// Update this to match your cluster
const endpoint = 'couchbase://couchbase-couchbase-cluster-srv'

// Update your credentials for authentication
const username = 'Administrator'
const password = 'c21vd1ZR'

//update your bucket name
const bucketName = 'default'

// User Input ends here. //

// Initialize the Connection
var cluster = new couchbase.Cluster(endpoint, {
    username: username,
    password: password
});
var bucket = cluster.bucket(bucketName);
var collection = bucket.defaultCollection();

function start(){
  console.log('start');
  return new Promise( (resolve, reject) => { resolve(); });
}

async function run(){
   
  // Create and store a document
  try {
    await collection.upsert('user:king_arthur', {
        'name': 'Arthur', 'email': 'kingarthur@couchbase.com', 'interests': ['Holy Grail', 'African Swallows']
    });
  } catch (e) {
    throw(e);
  }

    // Load the Document and print it
    // Prints Content and Metadata of the stored Document
  try {
    let getResult = await collection .get('user:king_arthur');
    console.log('Got: ');
    console.log(getResult);
  } catch (e) {
    console.log(e);
    throw(e);
  }

}
start().then(run).then(() => { console.log("closing..."); cluster.close();});
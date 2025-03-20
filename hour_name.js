exports.handler = async (event) => {
    const date = new Date();
  
    const formatter = new Intl.DateTimeFormat('fr-FR', {
      hour: '2-digit',
      minute: '2-digit',
      timeZone: 'Europe/Paris'
    });
    const parisTime = formatter.format(date);
  
    const message = `Hello World ! Ici Julien et Pierre-Louis, à ${parisTime}`;
  
    return {
      statusCode: 200,
      body: JSON.stringify({ message })
    };
  };
  
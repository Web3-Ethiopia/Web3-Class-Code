import { useState } from "react";
// Use the JWT key
// import fs from 'fs';
// import pinataSDK from "@pinata/sdk";


export function FileUploader() {
  const [selectedFile, setSelectedFile] = useState();
  const changeHandler = (event) => {
    setSelectedFile(event.target.files[0]);
  };

  const handleSubmission = async () => {
    
    try {
     
      const pinata = new pinataSDK({ pinataJWTKey:import.meta.env.VITE_PINATA_JWT });
      const readableStreamForFile = fs.createReadStream(selectedFile);
      // const reada
      const formData = new FormData();
      formData.append("file", selectedFile);
      const metadata = JSON.stringify({
        name: "File name",
      //   keyvalues: {
      //     name: "customValue",
      //     image: "customValue2"
      // }

      });

      
      formData.append("pinataMetadata", metadata);

      const options = JSON.stringify({
        cidVersion: 0
      });
      // formData.append("pinataOptions", options);


      const pinataEndpoint=await pinata.pinFileToIPFS(readableStreamForFile,options)


      // const res = await fetch(
      //   "https://api.pinata.cloud/pinning/pinFileToIPFS",
      //   {
      //     method: "POST",
      //     headers: {
      //       Authorization: `Bearer ${import.meta.env.VITE_PINATA_JWT}`,
      //     },
      //     body: formData,
      //   }
      // );
      // const resData = await res.json();
      // console.log(resData.IpfsHash);

      // const metadataJson = {
      //   "name": "File",
      //   "image": `https://gateway.pinata.cloud/`
      // };
      // const formData2=new FormData()
      // formData2.append("pinataMetadata",metadataJson );
      // const options2 = JSON.stringify({
      //   cidVersion: 0,
      // });
      // formData2.append("pinataOptions", options2);

      // const res2 = await fetch(
      //   "https://api.pinata.cloud/data/pinList",
      //   {
      //     method: "POST",
      //     headers: {
      //       Authorization: `Bearer ${import.meta.env.VITE_PINATA_JWT}`,
      //     },
      //     body: formData
      //   }
      // );

      console.log(pinataEndpoint);
    } catch (error) {
      console.log(error);
    }
  };
  return (
    <>
      <label className="form-label"> Choose File</label>
      <input type="file" onChange={changeHandler} />
      <button onClick={handleSubmission}>Submit</button>
    </>
  );
}

import boto3

def detect_faces(photo, bucket):

    client=boto3.client('rekognition')

    response = client.detect_faces(Image={'S3Object':{'Bucket':bucket,'Name':photo}},Attributes=['ALL'])

    print('Detected faces: ' + photo)    
    for faceDetail in response['FaceDetails']:
        # print('Here are the other attributes:')
        # print(json.dumps(faceDetail, indent=4, sort_keys=True))

        print('Age Range: ' + str(faceDetail['AgeRange']['Low']) 
              + ' - ' + str(faceDetail['AgeRange']['High']) + ' years old')
        print("Gender: " + str(faceDetail['Gender']['Value']) + ' (' + str(round(faceDetail['Gender']['Confidence'], 2)) + '%)' )

    return len(response['FaceDetails'])

def compare_faces(bucket, sourceFile, targetFile):

    client=boto3.client('rekognition')

    response=client.compare_faces(SimilarityThreshold=80,
                                  SourceImage={'S3Object':{'Bucket':bucket,'Name':sourceFile}},
                                  TargetImage={'S3Object':{'Bucket':bucket,'Name':targetFile}})
    
    for faceMatch in response['FaceMatches']:
        similarity = str(faceMatch['Similarity'])
        print('The similarity of (' + sourceFile + ') and (' + targetFile + ') is ' + similarity + "%")

   
    return len(response['FaceMatches'])  

def list_faces_in_collection(collection_id):

    maxResults=2
    faces_count=0
    tokens=True

    client=boto3.client('rekognition')
    response=client.list_faces(CollectionId=collection_id,
                               MaxResults=maxResults)

    print('Collection: ' + collection_id)


    while tokens:

        faces=response['Faces']

        for face in faces:
            print (face)
            faces_count+=1
        if 'NextToken' in response:
            nextToken=response['NextToken']
            response=client.list_faces(CollectionId=collection_id,
                                       NextToken=nextToken,MaxResults=maxResults)
        else:
            tokens=False

    return faces_count   

def search_faces_in_image(bucket, photo, collection_id):

    threshold = 70
    maxFaces=2

    client=boto3.client('rekognition')


    response=client.search_faces_by_image(CollectionId=collection_id,
                                Image={'S3Object':{'Bucket':bucket,'Name':photo}},
                                FaceMatchThreshold=threshold,
                                MaxFaces=maxFaces)

                                
    faceMatches=response['FaceMatches']
    print ('Matching faces')
    for match in faceMatches:
            print ('FaceId:' + match['Face']['FaceId'])
            print ('Similarity: ' + "{:.2f}".format(match['Similarity']) + "%")
            print

    if not faceMatches:
        return False
    else:
        return True


def main():
    bucket='aws-s3-flutter143320-dev'
    collection_id='tom-hiddleston'
    photo='public/asian-girl-1.jpg'
    photo2='public/tom-1.jpg'
    photo3='public/tom-2.jpg'

    # To Dectect what attribute on a image
    # face_count=detect_faces(photo, bucket)

    # To Detect what are the similarity between two images
    # face_matches=compare_faces(bucket, photo2, photo3)

    # To List out the images in a collection
    # faces_count=list_faces_in_collection(collection_id)

    # To Search faces match in a collection
    print(search_faces_in_image(bucket, photo, collection_id))

if __name__ == "__main__":
    main()
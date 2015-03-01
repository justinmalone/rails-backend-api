
Create User
 curl -i --header "Accept: application/json" --header "Content-type: application/json" \
    -X POST -d '{"user":{"email":"test@abcd.com", "password":"abcd1234"}}' \
     http://127.0.0.1:3000/api/v1/users.json

Sign In User
curl -i --header "Accept: application/json" --header "Content-type: application/json" \
    -X POST -d '{"user":{"email":"test@abcd.com", "password":"abcd1234"}}' \
    http://127.0.0.1:3000/api/v1/users/sign_in.json

Show Authed User
curl -i --header "Accept: application/json" --header "Content-type: application/json" \
    --header "X-User-Email: test@abc2.com" --header "X-User-Token: 3GsbsPz2nZzmMZyzhxJS" \
    http://127.0.0.1:3000/api/v1/user.json

Sign Out User
curl -i --header "Accept: application/json" --header "Content-type: application/json" \
    --header "X-User-Email: test@abcd.com" --header "X-User-Token: EgyCxLzJSsEQwgmm74JH" \
    -X DELETE http://127.0.0.1:3000/api/v1/users/sign_out.json


Forgot Password
curl -i  --header "Accept: application/json" --header "Content-type: application/json" \
    -X POST -d '{"user":{"email":"test@abc.com"}}' \
    http://127.0.0.1:3000/api/v1/users/password.json
Thanks for downloading alertmailer!

Two things:

1. Make sure to change your email address and sender name.
fromaddr = '<from-address>@gmail.com'
fromname = '<email sender name>'


2. Make sure to base64 encode your password.
To do this, you can open IDLE, or Python via CLI:
python <cr>
import base64
base64.b64encode('buggerBoo123')
'YnVnZ2VyQm9vMTIz'

Now, in the alertmailer.py file, replace <super secret squirrel base64-encoded password> with the base64 encoded password.

Example:
obscurePass = base64.b64decode('<super secret squirrel base64-encoded password>')
Becomes:
obscurePass = base64.b64decode('YnVnZ2VyQm9vMTIz')



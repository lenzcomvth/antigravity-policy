#!/usr/bin/env python3
"""
Simple HTTP server that forwards prompts to agent_wrapper.py and returns its stdout.

Usage:
  python agent_wrapper_server.py
Then POST JSON {"prompt":"..."} to http://localhost:8080/prompt
"""
import json
import subprocess
from http.server import HTTPServer, BaseHTTPRequestHandler


class Handler(BaseHTTPRequestHandler):
    def _set_headers(self, code=200):
        self.send_response(code)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()

    def do_POST(self):
        if self.path != '/prompt':
            self._set_headers(404)
            self.wfile.write(json.dumps({'error': 'not found'}).encode())
            return
        length = int(self.headers.get('Content-Length', '0'))
        raw = self.rfile.read(length)
        try:
            data = json.loads(raw.decode('utf-8'))
            prompt = data.get('prompt', '')
        except Exception:
            self._set_headers(400)
            self.wfile.write(json.dumps({'error': 'invalid json'}).encode())
            return

        # call agent_wrapper.py with prompt on stdin
        try:
            p = subprocess.Popen(['python', 'agent_wrapper.py'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            out, err = p.communicate(prompt.encode('utf-8'))
            status = p.returncode
            if status != 0:
                resp = {'error': 'wrapper error', 'stderr': err.decode('utf-8', errors='replace')}
                self._set_headers(500)
            else:
                resp = {'output': out.decode('utf-8', errors='replace')}
                self._set_headers(200)
        except FileNotFoundError:
            self._set_headers(500)
            resp = {'error': 'agent_wrapper.py not found'}

        self.wfile.write(json.dumps(resp).encode('utf-8'))


def run(server_class=HTTPServer, handler_class=Handler, port=8080):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f'agent_wrapper_server running on http://localhost:{port}')
    httpd.serve_forever()


if __name__ == '__main__':
    run()

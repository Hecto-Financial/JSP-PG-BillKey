package com.settle.pg;

import java.io.IOException;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;

/**
 * TLS 1.2 이상만 활성화하는 JDK 7 호환 소켓 팩토리입니다.
 * JDK 7에서는 TLS 1.2를, TLS 1.3 지원 JVM에서는 1.2와 1.3을 허용합니다.
 */
public final class Tls12OrHigherSocketFactory extends SSLSocketFactory {
    private final SSLSocketFactory delegate;

    public Tls12OrHigherSocketFactory(SSLSocketFactory delegate) {
        if (delegate == null) {
            throw new IllegalArgumentException("delegate must not be null");
        }
        this.delegate = delegate;
    }

    public String[] getDefaultCipherSuites() {
        return delegate.getDefaultCipherSuites();
    }

    public String[] getSupportedCipherSuites() {
        return delegate.getSupportedCipherSuites();
    }

    public Socket createSocket() throws IOException {
        return enableTls12OrHigher(delegate.createSocket());
    }

    public Socket createSocket(Socket socket, String host, int port, boolean autoClose)
            throws IOException {
        return enableTls12OrHigher(delegate.createSocket(socket, host, port, autoClose));
    }

    public Socket createSocket(String host, int port)
            throws IOException, UnknownHostException {
        return enableTls12OrHigher(delegate.createSocket(host, port));
    }

    public Socket createSocket(String host, int port, InetAddress localHost, int localPort)
            throws IOException, UnknownHostException {
        return enableTls12OrHigher(delegate.createSocket(host, port, localHost, localPort));
    }

    public Socket createSocket(InetAddress host, int port) throws IOException {
        return enableTls12OrHigher(delegate.createSocket(host, port));
    }

    public Socket createSocket(InetAddress address, int port,
            InetAddress localAddress, int localPort) throws IOException {
        return enableTls12OrHigher(delegate.createSocket(address, port, localAddress, localPort));
    }

    private Socket enableTls12OrHigher(Socket socket) {
        if (!(socket instanceof SSLSocket)) {
            throw new IllegalStateException("Expected SSLSocket but got "
                    + socket.getClass().getName());
        }

        SSLSocket sslSocket = (SSLSocket) socket;
        String[] enabledProtocols = selectTls12OrHigher(sslSocket.getSupportedProtocols());
        if (enabledProtocols.length == 0) {
            throw new IllegalStateException("TLS 1.2 or higher is not supported by this JVM");
        }
        sslSocket.setEnabledProtocols(enabledProtocols);
        return sslSocket;
    }

    static String[] selectTls12OrHigher(String[] supportedProtocols) {
        List<String> selected = new ArrayList<String>();
        for (int i = 0; i < supportedProtocols.length; i++) {
            String protocol = supportedProtocols[i];
            if ("TLSv1.2".equals(protocol) || "TLSv1.3".equals(protocol)) {
                selected.add(protocol);
            }
        }
        return selected.toArray(new String[selected.size()]);
    }
}

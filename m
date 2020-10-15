Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D0728FAB9
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 23:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731359AbgJOVfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 17:35:34 -0400
Received: from mail-n.franken.de ([193.175.24.27]:43909 "EHLO drew.franken.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729756AbgJOVfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 17:35:34 -0400
Received: from [IPv6:2a02:8109:1140:c3d:14de:599e:5c6:fa0d] (unknown [IPv6:2a02:8109:1140:c3d:14de:599e:5c6:fa0d])
        (Authenticated sender: macmic)
        by drew.franken.de (Postfix) with ESMTPSA id 0E171721E281A;
        Thu, 15 Oct 2020 23:35:30 +0200 (CEST)
From:   Michael Tuexen <tuexen@fh-muenster.de>
Message-Id: <2EF3C673-B68F-4CA8-928E-07B72586434F@fh-muenster.de>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_70890405-61CD-4C8C-9FE7-3B633FFDDF53";
        protocol="application/pkcs7-signature";
        micalg=sha-256
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCHv3 net-next 16/16] sctp: enable udp tunneling socks
Date:   Thu, 15 Oct 2020 23:35:28 +0200
In-Reply-To: <a5ee7f3c99b14e43aac8938434fd9264@AcuMS.aculab.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gnault@redhat.com" <gnault@redhat.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
To:     David Laight <David.Laight@ACULAB.COM>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <afbaca39fa40eba694bd63c200050a49d8c8df81.1602574012.git.lucien.xin@gmail.com>
 <20201015174252.GB11030@localhost.localdomain>
 <a5ee7f3c99b14e43aac8938434fd9264@AcuMS.aculab.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=disabled version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on mail-n.franken.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Apple-Mail=_70890405-61CD-4C8C-9FE7-3B633FFDDF53
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

> On 15. Oct 2020, at 23:23, David Laight <David.Laight@ACULAB.COM> =
wrote:
>=20
> From: Marcelo Ricardo Leitner
>> Sent: 15 October 2020 18:43
>>=20
>> Actually..
>>=20
>> On Tue, Oct 13, 2020 at 03:27:41PM +0800, Xin Long wrote:
>> ...
>>> Also add sysctl udp_port to allow changing the listening
>>> sock's port by users.
>=20
> I've not read through this change...
>=20
> But surely the UDP port (or ports) that you need to use
> will depend on the remote system's configuration.
The local encapsulation port can be system wide, the remote =
encapsulation port
is per remote address. See =
https://tools.ietf.org/html/rfc6951#section-5.1

Best regards
Michael
>=20
> So they need to be a property of the socket, not a
> system-wide value.
>=20
> I can easily imagine my M3UA code connecting to different
> network providers which have decided to use different
> UDP port numbers.
>=20
> 	David
>=20
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, =
MK1 1PT, UK
> Registration No: 1397386 (Wales)
>=20


--Apple-Mail=_70890405-61CD-4C8C-9FE7-3B633FFDDF53
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEKow
ggUSMIID+qADAgECAgkA4wvV+K8l2YEwDQYJKoZIhvcNAQELBQAwgYIxCzAJBgNVBAYTAkRFMSsw
KQYDVQQKDCJULVN5c3RlbXMgRW50ZXJwcmlzZSBTZXJ2aWNlcyBHbWJIMR8wHQYDVQQLDBZULVN5
c3RlbXMgVHJ1c3QgQ2VudGVyMSUwIwYDVQQDDBxULVRlbGVTZWMgR2xvYmFsUm9vdCBDbGFzcyAy
MB4XDTE2MDIyMjEzMzgyMloXDTMxMDIyMjIzNTk1OVowgZUxCzAJBgNVBAYTAkRFMUUwQwYDVQQK
EzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVuIEZvcnNjaHVuZ3NuZXR6ZXMg
ZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNVBAMTJERGTi1WZXJlaW4gQ2VydGlmaWNhdGlv
biBBdXRob3JpdHkgMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMtg1/9moUHN0vqH
l4pzq5lN6mc5WqFggEcVToyVsuXPztNXS43O+FZsFVV2B+pG/cgDRWM+cNSrVICxI5y+NyipCf8F
XRgPxJiZN7Mg9mZ4F4fCnQ7MSjLnFp2uDo0peQcAIFTcFV9Kltd4tjTTwXS1nem/wHdN6r1ZB+Ba
L2w8pQDcNb1lDY9/Mm3yWmpLYgHurDg0WUU2SQXaeMpqbVvAgWsRzNI8qIv4cRrKO+KA3Ra0Z3qL
NupOkSk9s1FcragMvp0049ENF4N1xDkesJQLEvHVaY4l9Lg9K7/AjsMeO6W/VRCrKq4Xl14zzsjz
9AkH4wKGMUZrAcUQDBHHWekCAwEAAaOCAXQwggFwMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQU
k+PYMiba1fFKpZFK4OpL4qIMz+EwHwYDVR0jBBgwFoAUv1kgNgB5oKAia4zV8mHSuCzLgkowEgYD
VR0TAQH/BAgwBgEB/wIBAjAzBgNVHSAELDAqMA8GDSsGAQQBga0hgiwBAQQwDQYLKwYBBAGBrSGC
LB4wCAYGZ4EMAQICMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9wa2kwMzM2LnRlbGVzZWMuZGUv
cmwvVGVsZVNlY19HbG9iYWxSb290X0NsYXNzXzIuY3JsMIGGBggrBgEFBQcBAQR6MHgwLAYIKwYB
BQUHMAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMEgGCCsGAQUFBzAChjxodHRw
Oi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9UZWxlU2VjX0dsb2JhbFJvb3RfQ2xhc3NfMi5jZXIw
DQYJKoZIhvcNAQELBQADggEBAIcL/z4Cm2XIVi3WO5qYi3FP2ropqiH5Ri71sqQPrhE4eTizDnS6
dl2e6BiClmLbTDPo3flq3zK9LExHYFV/53RrtCyD2HlrtrdNUAtmB7Xts5et6u5/MOaZ/SLick0+
hFvu+c+Z6n/XUjkurJgARH5pO7917tALOxrN5fcPImxHhPalR6D90Bo0fa3SPXez7vTXTf/D6OWS
T1k+kEcQSrCFWMBvf/iu7QhCnh7U3xQuTY+8npTD5+32GPg8SecmqKc22CzeIs2LgtjZeOJVEqM7
h0S2EQvVDFKvaYwPBt/QolOLV5h7z/0HJPT8vcP9SpIClxvyt7bPZYoaorVyGTkwggWsMIIElKAD
AgECAgcbY7rQHiw9MA0GCSqGSIb3DQEBCwUAMIGVMQswCQYDVQQGEwJERTFFMEMGA1UEChM8VmVy
ZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYu
MRAwDgYDVQQLEwdERk4tUEtJMS0wKwYDVQQDEyRERk4tVmVyZWluIENlcnRpZmljYXRpb24gQXV0
aG9yaXR5IDIwHhcNMTYwNTI0MTEzODQwWhcNMzEwMjIyMjM1OTU5WjCBjTELMAkGA1UEBhMCREUx
RTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5n
c25ldHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9i
YWwgSXNzdWluZyBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ07eRxH3h+Gy8Zp
1xCeOdfZojDbchwFfylfS2jxrRnWTOFrG7ELf6Gr4HuLi9gtzm6IOhDuV+UefwRRNuu6cG1joL6W
LkDh0YNMZj0cZGnlm6Stcq5oOVGHecwX064vXWNxSzl660Knl5BpBb+Q/6RAcL0D57+eGIgfn5mI
TQ5HjUhfZZkQ0tkqSe3BuS0dnxLLFdM/fx5ULzquk1enfnjK1UriGuXtQX1TX8izKvWKMKztFwUk
P7agCwf9TRqaA1KgNpzeJIdl5Of6x5ZzJBTN0OgbaJ4YWa52fvfRCng8h0uwN89Tyjo4EPPLR22M
ZD08WkVKusqAfLjz56dMTM0CAwEAAaOCAgUwggIBMBIGA1UdEwEB/wQIMAYBAf8CAQEwDgYDVR0P
AQH/BAQDAgEGMCkGA1UdIAQiMCAwDQYLKwYBBAGBrSGCLB4wDwYNKwYBBAGBrSGCLAEBBDAdBgNV
HQ4EFgQUazqYi/nyU4na4K2yMh4JH+iqO3QwHwYDVR0jBBgwFoAUk+PYMiba1fFKpZFK4OpL4qIM
z+EwgY8GA1UdHwSBhzCBhDBAoD6gPIY6aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1nMi1jYS9wdWIvY3JsL2NhY3JsLmNybDBAoD6gPIY6aHR0cDovL2NkcDIucGNhLmRmbi5kZS9n
bG9iYWwtcm9vdC1nMi1jYS9wdWIvY3JsL2NhY3JsLmNybDCB3QYIKwYBBQUHAQEEgdAwgc0wMwYI
KwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBKBggrBgEF
BQcwAoY+aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1nMi1jYS9wdWIvY2FjZXJ0
L2NhY2VydC5jcnQwSgYIKwYBBQUHMAKGPmh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJv
b3QtZzItY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQCBeEWkTqR/
DlXwCbFqPnjMaDWpHPOVnj/z+N9rOHeJLI21rT7H8pTNoAauusyosa0zCLYkhmI2THhuUPDVbmCN
T1IxQ5dGdfBi5G5mUcFCMWdQ5UnnOR7Ln8qGSN4IFP8VSytmm6A4nwDO/afr0X9XLchMX9wQEZc+
lgQCXISoKTlslPwQkgZ7nu7YRrQbtQMMONncsKk/cQYLsgMHM8KNSGMlJTx6e1du94oFOO+4oK4v
9NsH1VuEGMGpuEvObJAaguS5Pfp38dIfMwK/U+d2+dwmJUFvL6Yb+qQTkPp8ftkLYF3sv8pBoGH7
EUkp2KgtdRXYShjqFu9VNCIaE40GMIIF4DCCBMigAwIBAgIMIRX9tDE2QqO3mVLXMA0GCSqGSIb3
DQEBCwUAMIGNMQswCQYDVQQGEwJERTFFMEMGA1UECgw8VmVyZWluIHp1ciBGb2VyZGVydW5nIGVp
bmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYDVQQLDAdERk4tUEtJMSUw
IwYDVQQDDBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5nIENBMB4XDTE5MDYwNDE0MjkxMFoXDTIy
MDYwMzE0MjkxMFowfDELMAkGA1UEBhMCREUxIDAeBgNVBAoMF0ZhY2hob2Noc2NodWxlIE11ZW5z
dGVyMTIwMAYDVQQLDClGYWNoYmVyZWljaCBFbGVrdHJvdGVjaG5payB1bmQgSW5mb3JtYXRpazEX
MBUGA1UEAwwOTWljaGFlbCBUdWV4ZW4wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDM
r8qQcPxLFCxzPtXvRyM9KeQaxyMA8gwUNc7IIiATs6mRQFe5ib/mvwT9nc0bAa+94go6HJDiD3FJ
NkTo4u8aBsIcTt5pJtdBQLm88PLakbe3+fp/00//n7xxbTh7mAtFVCf25LxDCKkrdGk/+jglRq/R
VdwhZZ3VpYCrx8YfI/hIzdRL3+4I4z/mnQ8K0X8d2MVVPG+9nBEngdnYGez5f/8wIVOgEYYBc21k
yvMnVXLu2Ing+LwBd0gDG9Vasv87MNHCOZfJTNBlLhI2UDei/uNg9Zd4ynlMpPWZ7v0oiDWvmv8E
OuD4oric8heyD0OYK2FL4qcVC4dn4pnyulfHAgMBAAGjggJOMIICSjA+BgNVHSAENzA1MA8GDSsG
AQQBga0hgiwBAQQwEAYOKwYBBAGBrSGCLAEBBAQwEAYOKwYBBAGBrSGCLAIBBAQwCQYDVR0TBAIw
ADAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQW
BBTxiodBVL/lA4p5iNesIsJRhhgd6zAfBgNVHSMEGDAWgBRrOpiL+fJTidrgrbIyHgkf6Ko7dDAg
BgNVHREEGTAXgRV0dWV4ZW5AZmgtbXVlbnN0ZXIuZGUwgY0GA1UdHwSBhTCBgjA/oD2gO4Y5aHR0
cDovL2NkcDEucGNhLmRmbi5kZS9kZm4tY2EtZ2xvYmFsLWcyL3B1Yi9jcmwvY2FjcmwuY3JsMD+g
PaA7hjlodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2Rmbi1jYS1nbG9iYWwtZzIvcHViL2NybC9jYWNy
bC5jcmwwgdsGCCsGAQUFBwEBBIHOMIHLMDMGCCsGAQUFBzABhidodHRwOi8vb2NzcC5wY2EuZGZu
LmRlL09DU1AtU2VydmVyL09DU1AwSQYIKwYBBQUHMAKGPWh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUv
ZGZuLWNhLWdsb2JhbC1nMi9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwSQYIKwYBBQUHMAKGPWh0dHA6
Ly9jZHAyLnBjYS5kZm4uZGUvZGZuLWNhLWdsb2JhbC1nMi9wdWIvY2FjZXJ0L2NhY2VydC5jcnQw
DQYJKoZIhvcNAQELBQADggEBABs3VlmIZ1VF3HkaQdjInZYmamRabbdgJ7cz6m6o/agKL7+Vhwx7
1BaaYs2gMa5Nu/GJ3YfdqIsUlYtKdl58Yhp/89E6xBfJkItS+rE8RFdf2XgklGlx7GmsvdA3tId5
b6K6r9a5wpVN0epxY6K8wwpzEib6fJLcHylybQXZ7JSOaLRLp6WU3QPoyTT7FpvAe/0b2MSCbPX4
fc53PCn2aGgXuRFVQeCn1SP1BF3QW1ppkFhcF6G+0JcUxYFAXE6r/71WZBvUHqoG/th2hAwQnS+Y
KhUYh4SZQH3/ursXXJYXQ5vyIhkN1FZlmtWA8+ofdCnoqSTbiSX2Aa/kKbTapwgxggOdMIIDmQIB
ATCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5l
cyBEZXV0c2NoZW4gRm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTElMCMG
A1UEAwwcREZOLVZlcmVpbiBHbG9iYWwgSXNzdWluZyBDQQIMIRX9tDE2QqO3mVLXMA0GCWCGSAFl
AwQCAQUAoIIBzzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEw
MTUyMTM1MjhaMC8GCSqGSIb3DQEJBDEiBCApxAXPJgknTMkS0wG2olEQdPzHwR4rfmXwqMD0RjKk
cjCBrwYJKwYBBAGCNxAEMYGhMIGeMIGNMQswCQYDVQQGEwJERTFFMEMGA1UECgw8VmVyZWluIHp1
ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYD
VQQLDAdERk4tUEtJMSUwIwYDVQQDDBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5nIENBAgwhFf20
MTZCo7eZUtcwgbEGCyqGSIb3DQEJEAILMYGhoIGeMIGNMQswCQYDVQQGEwJERTFFMEMGA1UECgw8
VmVyZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUu
IFYuMRAwDgYDVQQLDAdERk4tUEtJMSUwIwYDVQQDDBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5n
IENBAgwhFf20MTZCo7eZUtcwDQYJKoZIhvcNAQEBBQAEggEAJHMBZInznBFvkdzqn7MSw+NDBm1/
Nwn6qFr2aKxY3o4nR9+b7AzdmDoRN/GDmcXwoDMhkDlgRx0kmy2ST6hqMNsdxvzIPa1oSIIZcB3K
w/P5/gX56j70ytXy8Td8PLrTKB4oiuZEL4LeFNK4Ql15pxBVXtakfpD0yqgu59LLBNLL0b/UfNHS
W+gjbNnnPfyzGqH8pNfbDkB1cjxVW6S0gt+WuXpztJS7Q6U6tTgKIyxDBssQECjvkWSmDkRpEUYk
QoIjSHL03crBLM64WNv2dGPa+BqRRtenqg1zmy1SQW3MPA6j6AN4zfwkbNnNMSHlHRaGa8yAIrwC
jaRD47Ip3AAAAAAAAA==
--Apple-Mail=_70890405-61CD-4C8C-9FE7-3B633FFDDF53--

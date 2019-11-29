Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5BF410D1CB
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 08:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfK2HYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 02:24:31 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:36628 "EHLO
        faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725856AbfK2HYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 02:24:30 -0500
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Nov 2019 02:24:28 EST
Received: from [10.188.34.154] (i4laptop03.informatik.uni-erlangen.de [10.188.34.154])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: langer)
        by faui40.informatik.uni-erlangen.de (Postfix) with ESMTPSA id 90EC6548055;
        Fri, 29 Nov 2019 08:17:52 +0100 (CET)
Subject: Re: [i4passt] [PATCH 1/5] staging/qlge: remove initialising of static
 local variable
To:     Dorothea Ehrl <dorothea.ehrl@fau.de>, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc:     Vanessa Hack <vanessa.hack@fau.de>, linux-kernel@i4.cs.fau.de
References: <20191127123052.16424-1-dorothea.ehrl@fau.de>
From:   Tobias Langer <langer@cs.fau.de>
Message-ID: <cac212e9-2412-7919-223c-0193df74ba2a@cs.fau.de>
Date:   Fri, 29 Nov 2019 08:17:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191127123052.16424-1-dorothea.ehrl@fau.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080704000207010000040300"
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED=-1
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        faui40.informatik.uni-erlangen.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080704000207010000040300
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

the patch series looks fine to me, I think you can go ahead and send it
to the kernel.

Kind regards
Tobias

On 27.11.19 13:30, Dorothea Ehrl wrote:
> This patch fixes "ERROR: do not initialise statics to 0" by checkpatch.=
pl.
>=20
> Signed-off-by: Dorothea Ehrl <dorothea.ehrl@fau.de>
> Co-developed-by: Vanessa Hack <vanessa.hack@fau.de>
> Signed-off-by: Vanessa Hack <vanessa.hack@fau.de>
> ---
>  drivers/staging/qlge/qlge_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/ql=
ge_main.c
> index 6ad4515311f7..587102aa7fbf 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -4578,7 +4578,7 @@ static int qlge_probe(struct pci_dev *pdev,
>  {
>  	struct net_device *ndev =3D NULL;
>  	struct ql_adapter *qdev =3D NULL;
> -	static int cards_found =3D 0;
> +	static int cards_found;
>  	int err =3D 0;
>=20
>  	ndev =3D alloc_etherdev_mq(sizeof(struct ql_adapter),
> --
> 2.20.1
>=20


--------------ms080704000207010000040300
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCC
EckwggUSMIID+qADAgECAgkA4wvV+K8l2YEwDQYJKoZIhvcNAQELBQAwgYIxCzAJBgNVBAYT
AkRFMSswKQYDVQQKDCJULVN5c3RlbXMgRW50ZXJwcmlzZSBTZXJ2aWNlcyBHbWJIMR8wHQYD
VQQLDBZULVN5c3RlbXMgVHJ1c3QgQ2VudGVyMSUwIwYDVQQDDBxULVRlbGVTZWMgR2xvYmFs
Um9vdCBDbGFzcyAyMB4XDTE2MDIyMjEzMzgyMloXDTMxMDIyMjIzNTk1OVowgZUxCzAJBgNV
BAYTAkRFMUUwQwYDVQQKEzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVu
IEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNVBAMTJERG
Ti1WZXJlaW4gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgMjCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAMtg1/9moUHN0vqHl4pzq5lN6mc5WqFggEcVToyVsuXPztNXS43O+FZs
FVV2B+pG/cgDRWM+cNSrVICxI5y+NyipCf8FXRgPxJiZN7Mg9mZ4F4fCnQ7MSjLnFp2uDo0p
eQcAIFTcFV9Kltd4tjTTwXS1nem/wHdN6r1ZB+BaL2w8pQDcNb1lDY9/Mm3yWmpLYgHurDg0
WUU2SQXaeMpqbVvAgWsRzNI8qIv4cRrKO+KA3Ra0Z3qLNupOkSk9s1FcragMvp0049ENF4N1
xDkesJQLEvHVaY4l9Lg9K7/AjsMeO6W/VRCrKq4Xl14zzsjz9AkH4wKGMUZrAcUQDBHHWekC
AwEAAaOCAXQwggFwMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUk+PYMiba1fFKpZFK4OpL
4qIMz+EwHwYDVR0jBBgwFoAUv1kgNgB5oKAia4zV8mHSuCzLgkowEgYDVR0TAQH/BAgwBgEB
/wIBAjAzBgNVHSAELDAqMA8GDSsGAQQBga0hgiwBAQQwDQYLKwYBBAGBrSGCLB4wCAYGZ4EM
AQICMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9wa2kwMzM2LnRlbGVzZWMuZGUvcmwvVGVs
ZVNlY19HbG9iYWxSb290X0NsYXNzXzIuY3JsMIGGBggrBgEFBQcBAQR6MHgwLAYIKwYBBQUH
MAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMEgGCCsGAQUFBzAChjxodHRw
Oi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9UZWxlU2VjX0dsb2JhbFJvb3RfQ2xhc3NfMi5j
ZXIwDQYJKoZIhvcNAQELBQADggEBAIcL/z4Cm2XIVi3WO5qYi3FP2ropqiH5Ri71sqQPrhE4
eTizDnS6dl2e6BiClmLbTDPo3flq3zK9LExHYFV/53RrtCyD2HlrtrdNUAtmB7Xts5et6u5/
MOaZ/SLick0+hFvu+c+Z6n/XUjkurJgARH5pO7917tALOxrN5fcPImxHhPalR6D90Bo0fa3S
PXez7vTXTf/D6OWST1k+kEcQSrCFWMBvf/iu7QhCnh7U3xQuTY+8npTD5+32GPg8SecmqKc2
2CzeIs2LgtjZeOJVEqM7h0S2EQvVDFKvaYwPBt/QolOLV5h7z/0HJPT8vcP9SpIClxvyt7bP
ZYoaorVyGTkwggWsMIIElKADAgECAgcbY7rQHiw9MA0GCSqGSIb3DQEBCwUAMIGVMQswCQYD
VQQGEwJERTFFMEMGA1UEChM8VmVyZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hl
biBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYDVQQLEwdERk4tUEtJMS0wKwYDVQQDEyRE
Rk4tVmVyZWluIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IDIwHhcNMTYwNTI0MTEzODQwWhcN
MzEwMjIyMjM1OTU5WjCBjTELMAkGA1UEBhMCREUxRTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9l
cmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UE
CwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9iYWwgSXNzdWluZyBDQTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ07eRxH3h+Gy8Zp1xCeOdfZojDbchwFfylf
S2jxrRnWTOFrG7ELf6Gr4HuLi9gtzm6IOhDuV+UefwRRNuu6cG1joL6WLkDh0YNMZj0cZGnl
m6Stcq5oOVGHecwX064vXWNxSzl660Knl5BpBb+Q/6RAcL0D57+eGIgfn5mITQ5HjUhfZZkQ
0tkqSe3BuS0dnxLLFdM/fx5ULzquk1enfnjK1UriGuXtQX1TX8izKvWKMKztFwUkP7agCwf9
TRqaA1KgNpzeJIdl5Of6x5ZzJBTN0OgbaJ4YWa52fvfRCng8h0uwN89Tyjo4EPPLR22MZD08
WkVKusqAfLjz56dMTM0CAwEAAaOCAgUwggIBMBIGA1UdEwEB/wQIMAYBAf8CAQEwDgYDVR0P
AQH/BAQDAgEGMCkGA1UdIAQiMCAwDQYLKwYBBAGBrSGCLB4wDwYNKwYBBAGBrSGCLAEBBDAd
BgNVHQ4EFgQUazqYi/nyU4na4K2yMh4JH+iqO3QwHwYDVR0jBBgwFoAUk+PYMiba1fFKpZFK
4OpL4qIMz+EwgY8GA1UdHwSBhzCBhDBAoD6gPIY6aHR0cDovL2NkcDEucGNhLmRmbi5kZS9n
bG9iYWwtcm9vdC1nMi1jYS9wdWIvY3JsL2NhY3JsLmNybDBAoD6gPIY6aHR0cDovL2NkcDIu
cGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1nMi1jYS9wdWIvY3JsL2NhY3JsLmNybDCB3QYIKwYB
BQUHAQEEgdAwgc0wMwYIKwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1T
ZXJ2ZXIvT0NTUDBKBggrBgEFBQcwAoY+aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwt
cm9vdC1nMi1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwSgYIKwYBBQUHMAKGPmh0dHA6Ly9j
ZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtZzItY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0
MA0GCSqGSIb3DQEBCwUAA4IBAQCBeEWkTqR/DlXwCbFqPnjMaDWpHPOVnj/z+N9rOHeJLI21
rT7H8pTNoAauusyosa0zCLYkhmI2THhuUPDVbmCNT1IxQ5dGdfBi5G5mUcFCMWdQ5UnnOR7L
n8qGSN4IFP8VSytmm6A4nwDO/afr0X9XLchMX9wQEZc+lgQCXISoKTlslPwQkgZ7nu7YRrQb
tQMMONncsKk/cQYLsgMHM8KNSGMlJTx6e1du94oFOO+4oK4v9NsH1VuEGMGpuEvObJAaguS5
Pfp38dIfMwK/U+d2+dwmJUFvL6Yb+qQTkPp8ftkLYF3sv8pBoGH7EUkp2KgtdRXYShjqFu9V
NCIaE40GMIIG/zCCBeegAwIBAgIMH+UmdDCCl51BXwcTMA0GCSqGSIb3DQEBCwUAMIGNMQsw
CQYDVQQGEwJERTFFMEMGA1UECgw8VmVyZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRz
Y2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYDVQQLDAdERk4tUEtJMSUwIwYDVQQD
DBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5nIENBMB4XDTE4MTAxNjA5MDEyNloXDTIxMTAx
NTA5MDEyNlowgYcxCzAJBgNVBAYTAkRFMQ8wDQYDVQQIDAZCYXllcm4xETAPBgNVBAcMCEVy
bGFuZ2VuMTwwOgYDVQQKDDNGcmllZHJpY2gtQWxleGFuZGVyLVVuaXZlcnNpdGFldCBFcmxh
bmdlbi1OdWVybmJlcmcxFjAUBgNVBAMMDVRvYmlhcyBMYW5nZXIwggIiMA0GCSqGSIb3DQEB
AQUAA4ICDwAwggIKAoICAQCkEpfEHPcqSunVL3AZa5s78RuxtdiYwXOlZXd/7FupacTEF27z
cAKQSPixda8H6cTi54QlOd12rUMi533/zGthVe+abNEmt86vS1I071BxVmQOrwiCukFG+yxT
Hh53ijvGNIfnEmYFjmAtj9lZiqWBa+JLLPbErl8LwpelJ8uyHT5KHFOzHbM0qC4phZVw2XP8
lvv75krTJi096ZDxc8lo57oxJn9K6nDQjisHbgwz3Ba06c5JHrSGq7Aihi4MZ7gUoCpY9fXD
enYyn9peZf+WSWDPtyiFDjA2YvpdsqOqQVdrSUHlxAGLDzK9RC065Ti4i2hWZREQ8nSv2Qko
v5thudy2c1U9P1Lwr8o6ImijHHadMOqVP0uJhoYFGX800C3OAEjwbn+JMV2lDmUS++9MphNw
Lc+fwYhAE1yfzMWdL7CIfMGX7Ni80NoKOookSx9XrHOWidtYEjDsyKWncQv7fSeLO/0SlRFR
f+gfEGyP0VT0x2OCsS1Fd0qPPZZ8iVcueFDwMUZYvSycPJFaRlMUCEriqOW01Gqkkg8z/Bp3
RdYS1rwfbLFbhfYS6NY3WHOKFP98oeI4ivK1WcORi3zACw4wLEjyzDUmzrlmTjwutS+18H3W
StVvuMVzaTu0un27R5+0s4KPO0yMCfqXYK9KriIG6wFMSWyYXeqyOIqreQIDAQABo4ICYTCC
Al0wQAYDVR0gBDkwNzAPBg0rBgEEAYGtIYIsAQEEMBEGDysGAQQBga0hgiwBAQQDCDARBg8r
BgEEAYGtIYIsAgEEAwgwCQYDVR0TBAIwADAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYI
KwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQWBBQkI6El8omMxRHRj4zdAcDFM1a5uzAfBgNV
HSMEGDAWgBRrOpiL+fJTidrgrbIyHgkf6Ko7dDAxBgNVHREEKjAogRBsYW5nZXJAY3MuZmF1
LmRlgRR0b2JpYXMubGFuZ2VyQGZhdS5kZTCBjQYDVR0fBIGFMIGCMD+gPaA7hjlodHRwOi8v
Y2RwMS5wY2EuZGZuLmRlL2Rmbi1jYS1nbG9iYWwtZzIvcHViL2NybC9jYWNybC5jcmwwP6A9
oDuGOWh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZGZuLWNhLWdsb2JhbC1nMi9wdWIvY3JsL2Nh
Y3JsLmNybDCB2wYIKwYBBQUHAQEEgc4wgcswMwYIKwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBj
YS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBJBggrBgEFBQcwAoY9aHR0cDovL2NkcDEucGNh
LmRmbi5kZS9kZm4tY2EtZ2xvYmFsLWcyL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDBJBggrBgEF
BQcwAoY9aHR0cDovL2NkcDIucGNhLmRmbi5kZS9kZm4tY2EtZ2xvYmFsLWcyL3B1Yi9jYWNl
cnQvY2FjZXJ0LmNydDANBgkqhkiG9w0BAQsFAAOCAQEARKzW5ehUd8BQRZ0X/JaMQKoerCEC
FA+MnirgbzrWOd7RZCLBjO3XHZcByTPcYtlh5zMjruRkyrHAdZ/OPea7L+zodmE3T/dK4BaE
qX4mBf3t5/Xu1LRtPr12umVXozRhxWSDae8Vjt/Rv0czyd8X8X2/gtzNVxRhZyy3PYG23icV
ATv86QLP/64ADSPs7OgElAOVJoLvS45qh4TXvWwQSIVfv4+JMzpv9C9uW3debdTeJ32S115H
D1b60eaqj5U3CsQdqNTbHGRkUoWpL3IAZrCi7rm7AIR/meqv1U6MG7vAFdfJcYibl4A7mI6B
fCOXoBD0OxKAQBskqv8nENtnWDGCBSswggUnAgEBMIGeMIGNMQswCQYDVQQGEwJERTFFMEMG
A1UECgw8VmVyZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdz
bmV0emVzIGUuIFYuMRAwDgYDVQQLDAdERk4tUEtJMSUwIwYDVQQDDBxERk4tVmVyZWluIEds
b2JhbCBJc3N1aW5nIENBAgwf5SZ0MIKXnUFfBxMwDQYJYIZIAWUDBAIDBQCgggJdMBgGCSqG
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE5MTEyOTA3MTc1MlowTwYJ
KoZIhvcNAQkEMUIEQIRp9vrHLBDAAAcKazDeBQ5qT3S+UpRZmVoS2jET8KDmaC/TZsN+O9cZ
VaEd0LOigXyr93vHOrRzCEEJZRUC6VYwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASow
CwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIB
QDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBrwYJKwYBBAGCNxAEMYGhMIGeMIGNMQswCQYD
VQQGEwJERTFFMEMGA1UECgw8VmVyZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hl
biBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYDVQQLDAdERk4tUEtJMSUwIwYDVQQDDBxE
Rk4tVmVyZWluIEdsb2JhbCBJc3N1aW5nIENBAgwf5SZ0MIKXnUFfBxMwgbEGCyqGSIb3DQEJ
EAILMYGhoIGeMIGNMQswCQYDVQQGEwJERTFFMEMGA1UECgw8VmVyZWluIHp1ciBGb2VyZGVy
dW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYDVQQLDAdE
Rk4tUEtJMSUwIwYDVQQDDBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5nIENBAgwf5SZ0MIKX
nUFfBxMwDQYJKoZIhvcNAQEBBQAEggIAoZAT/5fz+XRHubZvRDyVFc6uWAOQXrrQXmTU54Xp
Ruhw9Ao5lOO2BmbK7+EizcTHubH9yd/WuPdO30qJUazjNMgM0aGW70hu38EmBIkJwh0csWmk
FyKT++3niuGjBoOyZOm1hfidVexhIL6Mf4QyV9Fb6+TLtg+u4Ge6ge/b95p6Te3fEbeLGTLq
5WjrnZ7QYho8SZ9digeBJPZTVhSDaQmjUV4PtL4rKqyZLqiv8GNDKTCL2mZvoKT9ahexuaYf
sQIx3oiG9W4ELA5cW5+RXYArFlJQ2QTl/tflanOaR1RSfyswztwuvb/oa+fkhu5gx5DkvySv
W9OBxg/QCLTrCDyr9Ekw958yGFBZRr277+0lOwlGZ7M8y9XMQR4Kanw/RirZIxNRRLj3rMtg
kGtRPPDHeWDgsX4Vu9WQvAyQF1dqBdBfo4itCHM+ObeJUutFB9HwW8orpkCpQ5A6xm19kL9c
udDvH/cdifwjNg8+T1wsO9t+wXHLZthudpAL9+KMx0pafjj/tqTLBNz3OJHOYB38fO8V8zEN
Vy9htwVPz6jp5aO1K62ZWcmmX2GUgnT4BDijMNi+Hrckqylk3Yw30lDlT7wkfAMdYbTm8XDL
un9QOagjxXhjbtVwcXhTffx1w+rf2S94tDkn9fkyFELQCQfjhf03oqo7OVUZFBngyQ0AAAAA
AAA=
--------------ms080704000207010000040300--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDCF95C2BE
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfGASPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:15:31 -0400
Received: from mout.web.de ([212.227.17.11]:33727 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfGASPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 14:15:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1562004914;
        bh=wjEl8FTofarDW/hjL3Oj6Vl3tT1Gdt2yjJVEwq+qa4A=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=E28VSRYokXR1w0lCVSNiOYtJe3VutTAzwyQuJoSWKauQheHkdbBmtQBUc06xIw0Ha
         XZ++P7BgF66Stl9xcysG5xDhg90FApMpzlx/5uVovVtpiO+rso8tclurW/6Eg2uwSt
         PfTqoOy0uTgNkiwVCXYwkUWOGTsTj62V0gbnc6GI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.3.114] ([46.59.214.39]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LetUp-1iKPZl1pSp-00qipZ; Mon, 01
 Jul 2019 20:15:14 +0200
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     nic_swsd@realtek.com, romieu@fr.zoreil.com, netdev@vger.kernel.org
References: <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
 <b104dbf2-6adc-2eee-0a1a-505c013787c0@gmail.com>
 <62684063-10d1-58ad-55ad-ff35b231e3b0@web.de> <20190630145511.GA5330@lunn.ch>
 <3825ebc5-15bc-2787-4d73-cccbfe96a0cc@web.de>
 <27dfc508-dee0-9dad-1e6b-2a5df93c3977@gmail.com>
 <173251e0-add7-b2f5-0701-0717ed4a9b04@web.de>
 <de38facc-37ed-313f-cf1e-1ec6de9810c8@gmail.com>
 <116e4be6-e710-eb2d-0992-a132f62a8727@web.de>
 <94b0f05e-2521-7251-ab92-b099a3cf99c9@gmail.com>
 <20190701133507.GB25795@lunn.ch>
From:   Karsten Wiborg <karsten.wiborg@web.de>
Message-ID: <672d3b3f-e55d-e2bb-1d8c-a83d0a0c057a@web.de>
Date:   Mon, 1 Jul 2019 20:15:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190701133507.GB25795@lunn.ch>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070106030603010202000800"
X-Provags-ID: V03:K1:z9qRMVHeMh2h5LGprMdaWqk9SQK1zbRIsSsRMQw5XI2GgAwMGy9
 Vp2MeR35aOJ9xLAegePZ5IWXAMU1aJsELtonN9rXRMgXUWP8yi7Jz6fYpucP7KTTjj09LeF
 91RtRJiTmvUrBJmWzv2mnmO0XXBD69yXFWpkMj0iRgEyDPhlFUx/qcoDPp7AsAbkNgjEIfH
 BhIWD8RMOwsbxva8RElng==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/2EfNXxSQRs=:jl0YpLU86naPJ9NybSA8FI
 kchz19J7ppzVGXpZt3b5rYYWQMaog7JhhuUdDwns3m4FwRAyPJXv6tcIGfheypwoersLps0+h
 TEty3fCXpJ0yUKCYx9gsI/xgvGZwfILvTfeKffRvxm0um9e9TA5PiudUVzcpAMgeaLmUCGJPi
 8bfGx4fnQEsz+DgZffNhY1U6C1bNGdxP1uoO2cFle/ISwEb4P2sIkop/WddEYPVmz9AdwP4qn
 SGVYj/Lm4YzH5AYW/Qp2v/W8jkr3PBQg8tDZ0Jo+VBF0lh/YJX9lkymwwxMq8SIxLXRvv5Ql1
 bFgmYSOWG5wREftfu0aV18wMhnJykpcN4a/A+bXweW6dwQi8YQP7PrsPwxKCmu+XdxtzclVHp
 6ORw4LZrLuIHnTulwlxFjle6XmLVMKk9+HBTL5K5C2kGgbEtccGlJvvrXt3GP6bCzlKC4Y/KG
 +AW0cnh6kwvpia3GfrEVYyqlVG6S5CxgMGGqnBiN/2yLMf64NxVVaZJ81BjAvfil5Di/R7oSk
 P4rUc/IlbMillkZsSjJwKd3Mt3BRLAXlNvkiNHkmaOE5szLa7NC00oHLB8LqzgU79KyjzgTQV
 Zq84/CHbNNU4NSw5Vi746vnW9E2ddbRjO9x4SV4TZcNddY7pa9CGjKJC67CVQsZMNN5oUD3Du
 z7xMphtHaycfio3JAFoIniSAnm+lxIdTWJ4fiqtJl60b2I0uhKmmoRA/BUePhPCwQxhXN0ioj
 P2QceJL1Yw4LM5k/OaVWJRb1/Sx6uYKQpRNzTTk8l4FPzvFPAGsuJNxH6N8hC7EPrABzziIfx
 BczzSFjxp9HNcfgd0xYspI3SUctPVXEHT5APe91JzMRCW/iu7Y6lEDeIyELSdrGryduDVI1VS
 tunx7JfT3eP0fVaOwQpPBVSWoIelskX4ptD4H5k2zr1yGhE9mCuWaMe0wXkPPpfrvCNsHTLWu
 RWedugWJPOWMEvcsfLc5PqaLkPOFbfzMyWcJXRysxArsv+gYB2TAv+totqF42YwqNEUocuIja
 vvlf6/KyPZ+2jvpknou3c1f3+3BeIPYJU2J/Cv+ZVWDJzIy57Wn9K1yixYE0LogjuJbhLp2mS
 jvvo8zg2zXS/v0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms070106030603010202000800
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Andrew, Heiner,

the device is a really small notebook. So detaching mains still leaves
the battery which is delicately built in. So can't currently remove
power completely.

Anyway can I deliver more debugging data to you guys which might add
support for the r8169 for this device?

Regards,
Karsten

On 01/07/2019 15:35, Andrew Lunn wrote:
>> When the vendor driver assigns a random MAC address, it writes it to t=
he
>> chip. The related registers may be persistent (can't say exactly due t=
o
>> missing documentation).
>=20
> If the device supports WOL, it could be it is powered using the
> standby supply, not the main supply. Try pulling the plug from the
> wall to really remove all power.
>=20
>      Andrew
>=20


--------------ms070106030603010202000800
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DL8wggVeMIIDRqADAgECAgMCtSAwDQYJKoZIhvcNAQENBQAwVDEUMBIGA1UEChMLQ0FjZXJ0
IEluYy4xHjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzEcMBoGA1UEAxMTQ0FjZXJ0
IENsYXNzIDMgUm9vdDAeFw0xNzA5MTkyMjIxNDFaFw0xOTA5MTkyMjIxNDFaMD8xFzAVBgNV
BAMTDkthcnN0ZW4gV2lib3JnMSQwIgYJKoZIhvcNAQkBFhVrYXJzdGVuLndpYm9yZ0B3ZWIu
ZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCxUcZmRqMxfrFV78BS7Qwg1EE1
eSX5VXBIZkRuDKGCqzs6xDj9HikNvq+KK7/U+OZza5hDD0NlfFkgrY0dCYQuLOD4iYWPjPJt
V1aTarzfCeNnzDAhZTK3ocWQ+d14ReuDO7RoVrhfthgXO5t/QPCrsb7L3J30QYRVI3Gumj3H
Bkwp59AeVLvmHSEGgo4/VP5PTHN7HKxGgV44DoyvWj+jk3zN5+ljE7PbK4htM/IIL9dhhdSo
t4pUPsX+CG6I+gel5ewfeDQwsc350jjHLMFr0Kex5ZC4VNziHFo+ttokcSlkKes0HPdRMnIq
7l6QMWDQAgf2zNak1x/nqLMFNJmdAgMBAAGjggFMMIIBSDAMBgNVHRMBAf8EAjAAMFYGCWCG
SAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUgZm9yIEZSRUUgaGVhZCBv
dmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8EBAMCA6gwQAYDVR0lBDkw
NwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEEAYI3CgMDBglghkgBhvhC
BAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8vb2NzcC5jYWNlcnQub3Jn
MDgGA1UdHwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuY2FjZXJ0Lm9yZy9jbGFzczMtcmV2b2tl
LmNybDAgBgNVHREEGTAXgRVrYXJzdGVuLndpYm9yZ0B3ZWIuZGUwDQYJKoZIhvcNAQENBQAD
ggIBABfkSQnvEpwjuIOOJnpM5dpQPTldD5c+PIxasWCo2infcPCrkxFJLvM0rN8v/OTquWAA
drUntI5izNgSEfX0eLeR/203c/trNIAXqsRmmY+vmXqw/ACUYC8yTXAkpRvNFMEqIIX1YsCB
k+U4mlzZTs0VZbO6JmEAuM4X/JQieXhaF3P83CACrpmGKbmIJC9w9sutUZj2M7+oXAAngI/j
xmSTO7C3JlSQiALpFu44cKr38ZZjRlUNc3VCsgTQ9fzNE4XEgsrM+veB9jHpb1iMN5GontKv
M11o0wsgc176jwH1NJlWPXxlnN1tJoNyS5B7VHk58h9uX/9gbTJDigoYfEKricMV2QKilx2K
RCQtAYil3Y/o7A/66l7Z17lD7aU/fLtjlZrzWZLGpGBDZIXp3ikga3UGvYIUyryDZHLkd2wo
FKuWkPOCWFMnTsA4Ycn82xdNNhtXRyLOtSKzBPBOytvcGiUbIMh7q9xrlxgfu+ET3mYleoam
K6Mlo9T9I/GQBw2yY3lZRHJB2YDTA22zr4H/J7XOZc+NxUSEsx0bgm6Pp/jRHcHusboGkqkU
h+3en/VKTmXLwKzE4B2PieCftrSw8KMEqEOb17uUgGinPV023ztXB2wxdumlMVJc9vC473iY
pc7JrBLL/d7cR6HPFQXNFhXJNE5dYcn7h6gy4W0CMIIHWTCCBUGgAwIBAgIDCkGKMA0GCSqG
SIb3DQEBCwUAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2Fj
ZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3
DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnMB4XDTExMDUyMzE3NDgwMloXDTIxMDUyMDE3NDgw
MlowVDEUMBIGA1UEChMLQ0FjZXJ0IEluYy4xHjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0
Lm9yZzEcMBoGA1UEAxMTQ0FjZXJ0IENsYXNzIDMgUm9vdDCCAiIwDQYJKoZIhvcNAQEBBQAD
ggIPADCCAgoCggIBAKtJNRFIfNImflOUz0Op3SjXQiqL84d4GVh8D57aiX3h++tykA10oZZk
q5+gJJlz2uJVdscXe/UErEa4w75/ZI0QbCTzYZzA8pD6Ueb1aQFjww9W4kpCz+JEjCUoqMV5
CX1GuYrz6fM0KQhF5Byfy5QEHIGoFLOYZcRD7E6CjQnRvapbjZLQ7N6QxX8KwuPr5jFaXnQ+
lzNZ6MMDPWAzv/fRb0fEze5ig1JuLgiapNkVGJGmhZJHsK5I6223IeyFGmhyNav/8BBdwPSU
p2rVO5J+TJAFfpPBLIukjmJ0FXFuC3ED6q8VOJrU0gVyb4z5K+taciX5OUbjchs+BMNkJyIQ
KopPWKcDrb60LhPtXapI19V91Cp7XPpGBFDkzA5CW4zt2/LP/JaT4NsRNlRiNDiPDGCbO5dW
OK3z0luLoFvqTpa4fNfVoIZwQNORKbeiPK31jLvPGpKK5DR7wNhsX+kKwsOnIJpa3yxdUly6
R9Wb7yQocDggL9V/KcCyQQNokszgnMyXS0XvOhAKq3A6mJVwrTWx6oUrpByAITGprmB6gCZI
ALgBwJNjVSKRPFbnr9s6JfOPMVTqJouBWfmh0VMRxXudA/Z0EeBtsSw/LIaRmXGapneLNGDR
FLQsrJ2vjBDTn8Rq+G8T/HNZ92ZCdB6K4/jc0m+YnMtHmJVABfvpAgMBAAGjggINMIICCTAd
BgNVHQ4EFgQUdahxYEyIE/B42Yl3tW3Fid+8sXowgaMGA1UdIwSBmzCBmIAUFrUyG9TH8+Dm
jvO90rA67rI5GNGhfaR7MHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93
d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8G
CSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnggEAMA8GA1UdEwEB/wQFMAMBAf8wXQYI
KwYBBQUHAQEEUTBPMCMGCCsGAQUFBzABhhdodHRwOi8vb2NzcC5DQWNlcnQub3JnLzAoBggr
BgEFBQcwAoYcaHR0cDovL3d3dy5DQWNlcnQub3JnL2NhLmNydDBKBgNVHSAEQzBBMD8GCCsG
AQQBgZBKMDMwMQYIKwYBBQUHAgEWJWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZy9pbmRleC5waHA/
aWQ9MTAwNAYJYIZIAYb4QgEIBCcWJWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZy9pbmRleC5waHA/
aWQ9MTAwUAYJYIZIAYb4QgENBEMWQVRvIGdldCB5b3VyIG93biBjZXJ0aWZpY2F0ZSBmb3Ig
RlJFRSwgZ28gdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMA0GCSqGSIb3DQEBCwUAA4ICAQAp
KIWuRKm5r6R5E/CooyuXYPNc7uMvwfbiZqARrjY3OnYVBFPqQvX56sAV2KaC2eRhrnILKVyQ
Q+hBsuF32wITRHhHVa9Y/MyY9kW50SD42CEH/m2qc9SzxgfpCYXMO/K2viwcJdVxjDm1Luq+
GIG6sJO4D+Pm1yaMMVpyA4RS5qb1MyJFCsgLDYq4Nm+QCaGrvdfVTi5xotSu+qdUK+s1jVq3
VIgv7nSf7UgWyg1I0JTTrKSi9iTfkuO960NAkW4cGI5WtIIS86mTn9S8nK2cde5alxuV53Qt
HA+wLJef+6kzOXrnAzqSjiL2jA3k2X4Ndhj3AfnvlpaiVXPAPHG0HRpWQ7fDCo1y/OIQCQtB
zoyUoPkD/XFzS4pXM+WOdH4VAQDmzEoc53+VGS3FpQyLu7XthbNc09+4ufLKxw0BFKxwWMWM
jTPUnWajGlCVI/xI4AZDEtnNp4Y5LzZyo4AQ5OHz0ctbGsDkgJp8E3MGT9ujayQKurMcvEp4
u+XjdTilSKeiHq921F73OIZWWonO1sOnebJSoMbxhbQljPI/lrMQ2Y1sVzufb4Y6GIIiNsiw
kTjbKqGTqoQ/9SdlrnPVyNXTd+pLncdBu8fA46A/5H2kjXPmEkvfoXNzczqA6NXLji/L6hOn
1kGLrPo8idck9U604GGSt/M3mMS+lqO3ijGCAzswggM3AgEBMFswVDEUMBIGA1UEChMLQ0Fj
ZXJ0IEluYy4xHjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzEcMBoGA1UEAxMTQ0Fj
ZXJ0IENsYXNzIDMgUm9vdAIDArUgMA0GCWCGSAFlAwQCAQUAoIIBsTAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xOTA3MDExODE1MTJaMC8GCSqGSIb3DQEJ
BDEiBCDw9TVwcoxi4PEJC1gjZpy98jEWpvTeMkeCMdtiSMtFnzBqBgkrBgEEAYI3EAQxXTBb
MFQxFDASBgNVBAoTC0NBY2VydCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5v
cmcxHDAaBgNVBAMTE0NBY2VydCBDbGFzcyAzIFJvb3QCAwK1IDBsBgkqhkiG9w0BCQ8xXzBd
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMGwGCyqGSIb3DQEJEAIL
MV2gWzBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNl
cnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgMCtSAwDQYJKoZIhvcNAQEB
BQAEggEARVLMRiNnwpIbDl68+6WxaASZYuhX5TlczUkQ13WroaXlcFqAu30Qc0JhbELdspq8
Ah+hqcZUtM1y11FLeImPBuhKIQN/47dBHh3CY5zrZjd2CaYKN44EStOLrVFtJKMepRqclcwV
cfXWXT9hdWS45+UzP0QE5Zu5pQLUilq4ve8aFrduU064H3QEEpf7LCM5NJvLmZ5aluf11AEO
Bn9poHlxK5x5sGaW1/cRKibJwk4Fkz5Jkoo9mxX2Mc0IU1u6Wy8ufMn29p5sVIMHOiUAEjza
TBgkQfLwMrv1QhvsF60OY2saK3UkmMFhpggokAOVmDWBG0Coyx7Wuy0/3laVQgAAAAAAAA==
--------------ms070106030603010202000800--

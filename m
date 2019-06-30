Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6225B21E
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 23:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfF3VoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 17:44:15 -0400
Received: from mout.web.de ([212.227.15.3]:51163 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbfF3VoP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 17:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561931043;
        bh=M6LI6jwty+x9TSCDK2x7/7InvOo8Wg4abihQkxzO+U8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=n8Xqj9jPj7Q2zPCpByxRfXgBDD9FhqzqFgZi3VVskPfjUiHR4KdDkW5t46NovV0AG
         4asM5/KVI0zngBoiMu2yIwgoZinMfym+hZxap+V9joMY2TlPEI+i62PFW3vA8GLz/E
         NjO4CxLHLYGLbG/a0gMosfkNb1jkhrLUfBnfUA44=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.3.114] ([134.101.192.247]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LlayN-1iIPTg0pqZ-00bJ7I; Sun, 30
 Jun 2019 23:44:03 +0200
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com,
        romieu@fr.zoreil.com, netdev@vger.kernel.org
References: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
 <85548ec0-350b-118f-a60c-4be2235d5e4e@gmail.com>
 <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
 <b104dbf2-6adc-2eee-0a1a-505c013787c0@gmail.com>
 <62684063-10d1-58ad-55ad-ff35b231e3b0@web.de> <20190630145511.GA5330@lunn.ch>
 <3825ebc5-15bc-2787-4d73-cccbfe96a0cc@web.de> <20190630175641.GB5330@lunn.ch>
From:   Karsten Wiborg <karsten.wiborg@web.de>
Message-ID: <8fa1c33c-0328-83e3-f4e7-896f7835de60@web.de>
Date:   Sun, 30 Jun 2019 23:44:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190630175641.GB5330@lunn.ch>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080301010506010500020603"
X-Provags-ID: V03:K1:HAKh39b237JAMk2DNB3xRKvLd1IvuSg7ZaaBOcC5z8XVyT1HySd
 S6uIAdqfXh9pRfuum6DfxXsf0ZHixQxEXrMzUPBChhENsISDzeBXu5ucbpjLlZKYHTORIDd
 Vd3OehiP4/YaJ4zpnVBlGe9q1FsRFV3yVgzGjKZ8XmE7Q3j6pa55u7kHr/gprsmtaWJD4ik
 FT82aTYcjLsjiX3fSWETg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1MeA/zhq3L0=:9AxnWbOeNi55DBMgAqODeT
 Ybt4RL1nbYFUAoZw58HfvIXuEY7V/8F91cebkT3Smd5gmVLcBPCjLCh/nysGZwRST5K5sukqb
 HkAD+IZRtGCehnE3kVloptNz9ri3pvbKwOQ1XCepxu79FGTAggaXplcf+V2ImxNpIEVP7J/uk
 kqizMmS7yUQyKD41GmNSufqXI4T9Q8qH0TNYLKHhkRGCJYV2DZzvCu3HGd4y45ZMZ9iqcDP1z
 Wl1y5fGb4Ryi79X+JWdIraNZ0vLhG4KlX8w0jPI5m6rQPCxmjp8+EuSQERQCyNEUQ4PraN/G2
 n+p8dLSANZ0+zkh0Zzpo/myGJtZ5K0azqthUAahz0iybu0vhiDKAPNLCqdnr7k6zBb79VX1ce
 uz3YWok6aoFVemeE80d7CuL/YszFZfuq8r28YPkKoFgTCPRvV6t3wPFfnMZ1/1/CuiSdBwWAZ
 7hK50vHQzNY9dwpeoiWex4qR9heIek1IKucLZnlVQ01O5o1sgfU3oj+uwhITTrROXgSfVBrot
 m4VQJMd2CcnQljL1378R4eWf7iG3I7X4BSW6dGrDDORdJxCeI3V+UExJ5BEU0bMjF+1BA8g47
 lIh4z8TEEDbH4dzsIukXH6e/zEHlkGLHtSLjngo4lKlv+1Nhl2PXlcq447Ot3sVW4bkj82QhS
 Es3dBEjS2yXtUXjaXfygN8dtn1ZTYE8WlWcgnQL6RV71PMkhXK+tcPJlvJAb+3KMytZptuMcm
 jxDH7iJl7ZMAXn58BWHEsZb9N5hsIniXCJK1RV3n2/YEBgyijFYENxRMprgARt1xEANxVVJ09
 2f75TIOfcqLVWpf3Sv3/g02gDCEtO6W2ICAH0p4k+dHitJgiRQRX80iU3KYbFchpMBJl+I4PI
 CWaAQ0NGKeFrT2U7jf5jCjK2qeXT8zLtc5+cG3/Ms2umHx5qqmTXxRDRQBaFgzUxiwn9LXlWy
 QBHfDrCpDU/VboG3+LZHI64oX2BkfjDavOKrnlgB4h9gF5hB6CJWmihhtpMQckVTCsKGSjqta
 j6gOVLFcORS+vVZI0DfNv9jNQ35XtMEluAiVbKg7CPkHwnsOM3x9Xuqc4Ho/pSqyAR6DiQSVX
 JrqkzHhyHdNzfw=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080301010506010500020603
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On 30/06/2019 19:56, Andrew Lunn wrote:
> 0x6e =3D 0110 1110b. Bit 1 is the Locally Administered bit. Meaning thi=
s
> is not an MAC address from a vendor pool, but one generated locally.
>=20
> http://www.noah.org/wiki/MAC_address
Didn't know that. Thanks for pointing that out.

> If linux were to generate a random MAC address it would also set bit
> 1.
>=20
> What is interesting is that you say you get the same value each
> time. So it most either be stored somewhere, or it is generated from
> something, the board serial number, etc.
Hmm, maybe I did make a mistake. Yes I just again got the same MAC
address again but the last poweron/offs were done with Hibernating where
I got the same IP-address with the same MAC.

Anyway I just did a complete Power-Off (shutdown) and I still got the
same MAC address and because of that the intended IP address.

I just naively did a recursive grep in /etc trying to find the MAC since
you implied that it has to be stored somewhere.
Also went through the AMI BIOS (Aptio Setup Utility) and couldn't find
anything related there. Only network-related setting seems to be:
"Network Stack Driver Support" which by default is disable. Other that
that it might of course be stored somewhere within the UEFI NVRAM.

Regards,
Karsten


--------------ms080301010506010500020603
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xOTA2MzAyMTQ0MDBaMC8GCSqGSIb3DQEJ
BDEiBCCHrOUjhUkWU10nvkZRupZckuYL13qLX66PEvr8qvGfpDBqBgkrBgEEAYI3EAQxXTBb
MFQxFDASBgNVBAoTC0NBY2VydCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5v
cmcxHDAaBgNVBAMTE0NBY2VydCBDbGFzcyAzIFJvb3QCAwK1IDBsBgkqhkiG9w0BCQ8xXzBd
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMGwGCyqGSIb3DQEJEAIL
MV2gWzBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNl
cnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgMCtSAwDQYJKoZIhvcNAQEB
BQAEggEAMMbbtMtM6zbj8FCf24Eo0bu+SlQ8MvRbhyd1xs7OgkF/sXAH5GfGKivOjjXDGvdi
+jNL2VXlbrFBMVZB0ZkGe37eqhEF9IBYHT4AEerQi6tKzPVSnz7hMFkRsJLunRL9aPKoNC4n
Ss20xpVOW/LAPDu+eyeM/snSoqEDXeG9OAV/2flHeqA/hpHdSqetJHZNR7AiStegxBo+lB7w
h8pBPphoxu9cIz+dGcbGqib9vfbUb5ZA2RdhH7yNQqqGw4aSUpp2Rb2fzyDc1F0JNwgC7ApE
mjjVLo0TOo/IL5CYhTWKHLtxEbHKL1vZlkmP+GklUdmKvnUFMuI3HKA+boY3ygAAAAAAAA==
--------------ms080301010506010500020603--

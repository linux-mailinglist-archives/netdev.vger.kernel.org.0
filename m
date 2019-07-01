Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0260B5C371
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 21:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfGATHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 15:07:36 -0400
Received: from mout.web.de ([217.72.192.78]:43267 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfGATHg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 15:07:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1562008042;
        bh=a8RqKJovBDs4kuhqdrhnKcg7uhG/Qm0bBTrXPfjf3ZU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=sEYiYsO2srs+ISZlLcRKPq+Nr1YMnNm64STVhKm7Kgb7D09bnw/n2i1L7lQqgW3Uy
         xOi25nzqVg29wFLO3czoBf3PiDnGOptyaQxwQ31iS5U/6isAdXPpQ4ccqUAl21YT6P
         BdwOWGMlkb5aSBXHw6kBuEfM2LYsNQIw9qxEUP6A=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.3.114] ([46.59.214.39]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MMVu6-1hbxNE2aJ4-008NuV; Mon, 01
 Jul 2019 21:07:22 +0200
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
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
 <672d3b3f-e55d-e2bb-1d8c-a83d0a0c057a@web.de>
 <d48eb3dd-be07-1422-4649-91f3461676c4@gmail.com>
From:   Karsten Wiborg <karsten.wiborg@web.de>
Message-ID: <2a3b8aaa-1046-4b09-6141-206a83b9c351@web.de>
Date:   Mon, 1 Jul 2019 21:07:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <d48eb3dd-be07-1422-4649-91f3461676c4@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070001030005020804010408"
X-Provags-ID: V03:K1:gEqXLgvJICRBV1qvu8i2a38jya4+bf9y4TJcMHrIwFD4YmHrydX
 vN0qtzvkNpiy5+QKtjWsLggfKyM6odL1azxTfMVumdvvPcPZCL0vwcIVih/A91gtS3b5CYs
 E5n3WLd/NGj7rFSDJKpZsi0a20LBPz+/gFeQOfXbiel86SwdocjYMY6Kahx8Gj8ZFzE5rBB
 y0ND76yKV8vrkhdB6whBw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kLsobFODOus=:6fu1pfHN0EIur41I4K1rZQ
 xynHPj1BYeARSgaMHRsMcxSOkHrA3gJRwauIeAc/9HsWmx1ZcPxicXA0b/wAV3GTO72bMOxdX
 DPk58ndv/JIQzTgqcBfGDPgTe6YyRZC55AbKC4eIfvHjWJPjOQqzzCBcBSgGZpL1YlK8VGc3Y
 cuhG+ijTVrgUR1OYH1CDz8XD2q8ClF2mgH8UTG3KobdM4enaHOHlrmejUrDygFjWpZnAPHs5l
 NWxn/pHgnFrPxaIFigbPd0xZgtXU6vAitkB5SMiEv7aGj1ZS0pTxMnj0kdrurJysEZZADjyHi
 okGOruFBekkCA7QbKZWPvZHT0HsT4kc+QW41QCtmLOF1fnKX/EWRvtto+Fxr3S94432iTO5p1
 r8w8fsOeFLZY9qhGCu2kafTPNGwhLbteytC94iTGjemIt5tII9CW1W5ADdblr5Y1H5IClabGo
 qFJXn1J3DKOn4e+DYHedDu30d008QUI6kMWxdkEvg5liuw1CGZsrtgsb8TtFjXkWJYyXnYqeC
 36rgln9rwlZVzJ8yNehbQYF+5nBxTqRMKf341eMB6So+sc7KF9aKQbCdXR5ZOh2P70Ym0mccM
 zGijCqN00zNPSvvEUWd3jVnpOIAPOlAOmcMIBSnxZRDdYsw/h3M9Z7cnElCaAhxWd6alqw5un
 RxppwXGe5j6lLROimLG+hu02WaaY3TH5WkMockDob4JgmwgW1MgmI7dRvkBlQGdclouOSA4cp
 hYr/OzAHHqs/1ku5fg/WfW7wsmc8Yk3448Yn4XdgScbvGQdEOsmj0Sl0YLdGbc/+1Gd92FPr4
 +Feqeg5tpRtyATl0XR87HbwTcFVbZlD7d4m13fmPBIxGsGD4i8fcFel2lpxl5N59FzSXzkXEo
 hzQFD3H/V33BhC0aNS9M05SqWv49tppXNV514ZvyV5DwH7/TAKn+mNOSPbSpa+vHjKm9VT4Si
 cHVRp7aFnb/TK+7Oze6R8hXPTfEJjJzgReXNaz8mfDl2lzLymzjJgHxAqBJFDq7G5b3YTdeZR
 OZWV8F9Wa3LDZzHKP5RFh6Wv1dgiQ54HoBA7n17jzumJ1X3nZODwSEGEyX/ntGtckFN2li3lM
 3etCa0IOk2FbXA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms070001030005020804010408
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Heiner,

that is very unfortunately regarding the state of the device. I guess
GPD won't really react. Anyway thank you very much for trying to contact
them.
Thanks also a lot for your help and input.

Best regards,
Karsten

On 01/07/2019 20:51, Heiner Kallweit wrote:
> On 01.07.2019 20:15, Karsten Wiborg wrote:
> The information is sufficient now. Still, using a random MAC address
> is an emergency fallback. The device is simply broken.
> I contacted GPD, let's see whether they respond something.
>=20
> In parallel I'll add a random MAC address as fallback to the
> mainline driver.


--------------ms070001030005020804010408
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xOTA3MDExOTA3MjBaMC8GCSqGSIb3DQEJ
BDEiBCAjtVeTSSZ7us70qMA+8pEOwBy8WUi2/3cKdoszvTiQsTBqBgkrBgEEAYI3EAQxXTBb
MFQxFDASBgNVBAoTC0NBY2VydCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5v
cmcxHDAaBgNVBAMTE0NBY2VydCBDbGFzcyAzIFJvb3QCAwK1IDBsBgkqhkiG9w0BCQ8xXzBd
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMGwGCyqGSIb3DQEJEAIL
MV2gWzBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNl
cnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgMCtSAwDQYJKoZIhvcNAQEB
BQAEggEAmOjXeF/rL5IssebM7TtzdaBzUmigAIbijRDs7FOILPA93gZ5wPujeQ48OuNUBOYl
HafRl8RgmdxtN7NUIaCXjMe0OgWgh/ACiycK/j9bYtD8PbqRftY9xgpoEfMFkazRE7i9KbGs
1KdwL2Vxm2q54m92GYdqGVHkTSKJq84SOJc/0RgGAAUWyNSbz0ggMD5cNTCGSFj71hwCTUXS
FlGrEDJUvVxY2EakhvCWNPAV23aQPpK1qlmGmkRQ1ih5ALGe66mu+0T+hfugowrTfTnNpFsS
UplwZA3q8ja/CnsMMj+4GHkY1YDJLdeL42Nbzffa3pixu93BcsF/vv+BLEhG3AAAAAAAAA==
--------------ms070001030005020804010408--

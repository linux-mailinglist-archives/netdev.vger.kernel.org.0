Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B685B239
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 00:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfF3WV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 18:21:28 -0400
Received: from mout.web.de ([212.227.15.3]:56845 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbfF3WV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 18:21:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561933274;
        bh=zizeY7tLD9j/wMjFX+deF5et0BobDbv3Dizf2/49VmA=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=azht1GH+dz/NdbCAB6LQCkJ5XVhfo+zzZIojzWVJtybcgRQQrw+Bo5L+8DYW7cyI3
         jLRGMwGjdwZD1+I40ydXNjMbn11AHrXUQ6W8rrJrHQhbWWBWJy5pwB9ujPlVJvTewJ
         ltNrtyEgWFB1GfhMiJAiUttkQKuILATFL6TI210s=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.3.114] ([134.101.192.247]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MI5yY-1hhAUm0o9O-003yKi; Mon, 01
 Jul 2019 00:21:14 +0200
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     nic_swsd@realtek.com, romieu@fr.zoreil.com, netdev@vger.kernel.org
References: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
 <85548ec0-350b-118f-a60c-4be2235d5e4e@gmail.com>
 <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
 <b104dbf2-6adc-2eee-0a1a-505c013787c0@gmail.com>
 <62684063-10d1-58ad-55ad-ff35b231e3b0@web.de> <20190630145511.GA5330@lunn.ch>
 <3825ebc5-15bc-2787-4d73-cccbfe96a0cc@web.de>
 <27dfc508-dee0-9dad-1e6b-2a5df93c3977@gmail.com>
 <173251e0-add7-b2f5-0701-0717ed4a9b04@web.de>
 <de38facc-37ed-313f-cf1e-1ec6de9810c8@gmail.com>
From:   Karsten Wiborg <karsten.wiborg@web.de>
Message-ID: <116e4be6-e710-eb2d-0992-a132f62a8727@web.de>
Date:   Mon, 1 Jul 2019 00:21:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <de38facc-37ed-313f-cf1e-1ec6de9810c8@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080100010304010305090002"
X-Provags-ID: V03:K1:yy2EGQVmKwsmIx1Wme4t9cjH/7nSEzGt3siCIWIQmn5UaBK9SWs
 84tpuHutqdaO4sTrfCJX3x2TRjfXvybuQ9pcCGkaGoCs4Q05ldDdMoii/hyTXOf+CLhyg+3
 Ur+HKDbpUdoyYOqss5nKIdQ+62UJAKekWbQbI/myas8zGh0OJXWQAFojylhLPMmk4MTYurz
 agzPASSe3QCUZeg8fvprg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:iRsZa/q1gYk=:b+7CiItd1Cx8NKYlV/3jmw
 TK/m1ADQwpl6cVe3LQOWWRtyEH6eNnii2wVuSj5ZbZzPyn4uDBIngorUyTNA2nWKnZHz7E3sl
 Rq+3Xi49pD9iddO+dotf6XskEqqpVLooYZZE7osP4hPHUMcgatb8BFb4LE1LESBlD6PngY8wY
 xrWqrTWTRdg1vgNROBs7facj9/QtIh7pgR3HPZWeUgv1NROG12B/IUbQi0dLyxzqQMo7OcGIb
 +u1cjFJ5Z1llu4ltixeXH3+J7WV1BtOcPTJECywPPwx6BHWriM83j5Vad56vjYasXiptvwn0l
 O+fMaTSpRTo5AkXZ24vYljLtEuD7WSpQ8urKpDHwtmUevCkthTHuktH9C8PCLxc3Cemr6ooC0
 hXto5dyB7B2dTvZr84FfIDlE8TggT4/lmJmSsUj50s8QpOLel3A/LCUSxS8VznOKKOtrYn7qS
 PqCGG29Bx50kiLGVMl3W9pGhmktlFA/vWh1W+HXlvCQSXFhr8TMuEbCU+0r1grck//vopody/
 TQgLw1NT8OJ8fbBXdmwNRSR93449YlC9cKS9EI3eD2Y0/zSDp33d5ZVdjMdkbsL6PVPqBYiG7
 rF3IBGjzsLMv11YNT6NzPISBEz3nsnKsaw61mRpm3o3hjXAXd04ASZdNmVof1B3eqtGECnVo/
 wbbALVYs6CQenE42pxaoeUnOUc4O78/4Z7oDIyytW0QmcoLNRpHPxloDFICQFFCk+Aksdn0T/
 3LAS7GlUsQdx6G6zZrEUrKFE19eI0wBb+ZrJD99Z6DJp/aX2FT79YF51dA7dm6i5SmDRTIqg9
 3oO09OVFfMDxb8RTMh3iS5oFDOCKWpLWmEo29LJtdj+RiJtroB3A1PZZ2xM/ligl3bNAcYdZ6
 SxPHslYcws4bKdufCfVNqXSAo72GxsR6zf320acxBzbm/7itUcf1uD4ydzrw7Mj3uxObemnmR
 UDYo6dIw+ZfxOfIlfY0yUdqk3arg/hedH2Dte+oZv7mlQnjOV4IozLBlMne2RfGtvCqzrExWt
 60CVIpEBAtPuGpzpb/uS4BueJzAnwo6sXQKgWUacEmffCJCBgsTkK2RT77UC3pycLPHPtcDqK
 2hRfE8nZeIYB78=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080100010304010305090002
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Heiner,

On 30/06/2019 23:55, Heiner Kallweit wrote:
> This one shows that the vendor driver (r8168) uses a random MAC address=
=2E
> Means the driver can't read a valid MAC address from the chip, maybe du=
e
> to a broken BIOS.
> Alternatively you could use r8169 and set a MAC address manually with
> ifconfig <if> hw ether <MAC address>
Hmm, did some more testing:
did a rmmod r8168 and (after "un"blacklisting the r8169) modprobed the
r8169. This time r8169 came up nicely but with a complete different MAC
(forgot to not than one though).
So I guess the vendor compilation did other stuff besides just compiling
the r8168 kernel module.

Did another test:
blacklisted the r8168, renamed r8168.ko to r8168.bak, depmod -a and
powercycled the system. Funny it came up with both r8168 and r8169
loaded and I got my intended IP address from. DHCP, so r8168 somewhat
got loaded and used his MAC.
Did another rmmod r8168, rmmod r8169 and then modprobe r8169.
Even though I did NOT configure a MAC address myself manually it came up
with a new MAC address and of course got a dynamich IP address.
So I don't know where the vendor somewhat changed something (with his
compiling/installing) to the effect that r8169 now works?!?

Regards,
Karsten


--------------ms080100010304010305090002
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xOTA2MzAyMjIxMTFaMC8GCSqGSIb3DQEJ
BDEiBCDytAhFpA1JH3RnTVI1DRlv1ZZDLX3Sj2lZiqucJO26TjBqBgkrBgEEAYI3EAQxXTBb
MFQxFDASBgNVBAoTC0NBY2VydCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5v
cmcxHDAaBgNVBAMTE0NBY2VydCBDbGFzcyAzIFJvb3QCAwK1IDBsBgkqhkiG9w0BCQ8xXzBd
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMGwGCyqGSIb3DQEJEAIL
MV2gWzBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNl
cnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgMCtSAwDQYJKoZIhvcNAQEB
BQAEggEANKq8I8whVAZZ1rHQNPbifCJWfmcSjBBW+QF27TyjMZP5wFC+brsmUYG7opIXgaOz
BcO1rB4v1pSowbSMGkrCTOfAcLUwfoHFn8ZEpTjTxpTOGA6dBBRvEEb/EcCXVKn2bvgOZ3Mz
cFgPzYzakP9i83xjeSMb77OTtMf+PDb4nzhLBTDdv4dsh6bCnSc9S4IHGWB1aIGDoR+YB3il
kkIJRh/XbvZv+L4UuYDB9bmf3+A6CSrCV+PjQWSTmQOSJmtEPpitdzFLp9u2q5NEjHcNh2ov
J8YFNlOcXaLhv30PJeOfBQvaJnc6i//Q0hNeKt2bmSAcmUm5j+radRkYUS29ZQAAAAAAAA==
--------------ms080100010304010305090002--

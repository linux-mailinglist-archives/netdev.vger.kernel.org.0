Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC8F5B20E
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 23:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfF3V3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 17:29:20 -0400
Received: from mout.web.de ([212.227.15.14]:34367 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbfF3V3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 17:29:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561930146;
        bh=ysw9tMGZE+5wyEfr/zhOBGrAyeFTbD7c8mCkK7EMnDs=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=fsRUrzamODBhrt8RSDD4LuVp2LicmqM7Hhw/r7iBI8uiZ0gdudcbiFYk4artTeKgB
         K0PXX8jhNZTuXUox6/yA+6WI9LXt1Yq2kXzQbYYHy/5J3orFDkhsYEOduXQ9k451TQ
         K21W/4qOjt9ioNeDI7cjNnbMzLBDzwgTjqDCay94=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.3.114] ([134.101.192.247]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0McWbQ-1hzMn40idU-00He8Z; Sun, 30
 Jun 2019 23:29:06 +0200
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
From:   Karsten Wiborg <karsten.wiborg@web.de>
Message-ID: <173251e0-add7-b2f5-0701-0717ed4a9b04@web.de>
Date:   Sun, 30 Jun 2019 23:29:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <27dfc508-dee0-9dad-1e6b-2a5df93c3977@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050208050808020908010708"
X-Provags-ID: V03:K1:ExAgbWM5e8PI78MZ8z14p2gxh11tS7cD7rolspuulNzemuMab6s
 rTmOWvpFq7N/yJgjLthFd8FfafxLwdkbDHSYet/Uys8GuvCZGKthFn2zu0LQ+8HxzL5MFVm
 YFLxFUNf58ElKvjDqgONWQF1FBsyAd5a30TNtrrtbu9ux5aNDCSb3LZncuF/uszPoPYQfGz
 nVmCKkQzYsUHi83Gh6KWA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qtrEaz5bOYg=:+bmXPgv19R/rJfMCr0G2Py
 gtdXF5lYkoNB0JV3/HXIMKuqsjHJVRaoBjgHKSiNgqp9faaLSUtUsfm59yGfa7wpBOOUPS4op
 bLdTLb1MOPokGDk8W7KCN3Tjz/sVoZHqLsrK2MjHdaKaejQE+YCyhZQNy1YAM94rJ2KdZRxz/
 XilmSrsqpiD4JnPg2TvFCApakkpX6Ps4aMxKREn+4KdOch/eNvVePacL9CmR9ZHQ8hZl7ymJj
 ywlCVcvfTiu2At0liCxu5blAipOfVOtJ8oUrVN+7vC//6I8l+gK4dW0xzzIQVwX4r7twW9a+q
 m0H4mVIXM7F+3f9D41+PaMYW4r5EBK4diFlk9Wqe2SnD+NlwLEbsfS0U1hg6P7wjNDsLZGlYY
 zilLHyw9vu8nVMeRIuX3zYQgOdv2A5u1db4kteTCtgWBdEQFVKdPAp7iooTJydFnG9CPJrivj
 r0MhCw1l4t+Y87iAFZwVXMWJfKhXRz1nN6hy/ZdxauloR/D+uNTXybTV+YgmeqAJkn2cQc9T4
 p+lY97szlYYpPqkpN1nlbJj2lfCS0H86zkVFZ4XRR60OHCbevrDFvHlAlN/Gvveu4oXziS5Wa
 qbz6QBWPizy+bAODfa0nwQ6iSn5zYQmr+7WyZYHoi6WnDGIqNlvJ77+45KmFyUPMEj5flyUB8
 /fryS6Am+xs9RURBK+AKpQF1x81H5eRiJrl5zPoNOLUUC5bn+hi2KKEWDisYoNJw8QL42RZ8Q
 Tycz/8eXAEg/VM+PyHQoHpqg1AI8CFQXbkp71qG1LUfX7F1xucruV3FrQgsKEtQ8ljhDFQgD+
 Tj9aBw2NfgMc9V8gX/rnNc1faYS03NRk/m+Vh1POmOxFwAYQNlylvIToK4EW3ygKw+kq9EPRf
 PinX6g4p2YbYbeQUfeKVY07E9Laf3Tj3rcMLaqQ5OjlKdIdGc24myV0dz43XRNFdqFUzHys1G
 jA3z9J2Ng+QRh7pBvXfUKbeMP3UA28Wc70wWlRXHype/tcgcw9gH8YAb5iWXoMUM9P2TzQ4ey
 D8I6qXCJD396dAjF5FE1Q4Ncpsflou+8yDnLMVsYYO96Z0ourOD2ge+fWkGgG80UtjuBP0fXi
 c2gCrfNNjTrs4U=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050208050808020908010708
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Heiner,

On 30/06/2019 19:42, Heiner Kallweit wrote:
> Vendor driver uses this code, do you see the related messages in syslog=
?
>=20
>         if (!is_valid_ether_addr(mac_addr)) {
>                 netif_err(tp, probe, dev, "Invalid ether addr %pM\n",
>                           mac_addr);
>                 eth_hw_addr_random(dev);
>                 ether_addr_copy(mac_addr, dev->dev_addr);
>                 netif_info(tp, probe, dev, "Random ether addr %pM\n",
>                            mac_addr);
>                 tp->random_mac =3D 1;
>         }
>=20

did the following:

# cat /var/log/messages |grep -i Invalid
Jun 30 08:54:00 praktifix kernel: [    0.229213] DMAR-IR: Queued
invalidation will be enabled to support x2apic and Intr-remapping.
Jun 30 08:54:00 praktifix kernel: [   23.864072] Invalid pltconfig,
ensure IPC1 device is enabled in BIOS
Jun 30 10:17:30 praktifix kernel: [    0.228662] DMAR-IR: Queued
invalidation will be enabled to support x2apic and Intr-remapping.
Jun 30 10:17:30 praktifix kernel: [   24.198033] Invalid pltconfig,
ensure IPC1 device is enabled in BIOS

But that does not relate to your error.

# cat /var/log/messages |grep -i random
Jun 30 08:54:00 praktifix kernel: [    0.228092] random: crng done
(trusting CPU's manufacturer)
Jun 30 10:17:30 praktifix kernel: [    0.227534] random: crng done
(trusting CPU's manufacturer)
Jun 30 10:25:53 praktifix kernel: [  527.540354] r8168 0000:02:00.0
(unnamed net_device) (uninitialized): Random ether addr 82:c2:81:10:6b:c2=


The last one probably results from my testing with r8169. The compiled
r8168 went online later. That also is the only message I found.

Thank you for your help in debugging.

Regards and greetings from Hamburg,
Karsten


--------------ms050208050808020908010708
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xOTA2MzAyMTI5MDRaMC8GCSqGSIb3DQEJ
BDEiBCCsuwrGBajCoh6b5bvr4Q9NCG9Z6IF1xa0fB/ZInIuGlDBqBgkrBgEEAYI3EAQxXTBb
MFQxFDASBgNVBAoTC0NBY2VydCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5v
cmcxHDAaBgNVBAMTE0NBY2VydCBDbGFzcyAzIFJvb3QCAwK1IDBsBgkqhkiG9w0BCQ8xXzBd
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMGwGCyqGSIb3DQEJEAIL
MV2gWzBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNl
cnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgMCtSAwDQYJKoZIhvcNAQEB
BQAEggEABk9xGBz5xdK/h6VsUFuqDh0AgHKDYeOq/mbrLfqoqM8VhGytgfSytBj8FQJW3fAS
ryk3n/nEl6ZmxD3ZWVd24KBOTDcHnWI+qR4SZwrpq3n2TI0rAxAoQ2HFmK8c0z8hC28283Ra
nG4u3yqHzY9tKmSczQrvuAXuoVUZoYIwV2i2xkMKXvlldUedFf8umdr5MfdUh+7mDIF1bRu6
zFW+THz4r7szQwCzO+ntGzlxxO7P2KQZgfU24J540NVApchGVBClBNyaL00RUhPEnSETtGej
eMkJruHt5FTbv3aAD8TDSI5iBXF8UfxeIOpOR2DK+lxA1e/hjLEbiposSc+tsAAAAAAAAA==
--------------ms050208050808020908010708--

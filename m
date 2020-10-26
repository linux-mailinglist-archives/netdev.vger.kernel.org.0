Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B63298FB9
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 15:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781897AbgJZOpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 10:45:07 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:35366 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1781893AbgJZOpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 10:45:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B02E82057B;
        Mon, 26 Oct 2020 15:45:03 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZBOaR8JnsObN; Mon, 26 Oct 2020 15:45:03 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2F61E20573;
        Mon, 26 Oct 2020 15:45:03 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 26 Oct 2020 15:45:02 +0100
Received: from [172.18.3.9] (172.18.3.9) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 26 Oct
 2020 15:45:02 +0100
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
From:   Christian Langrock <christian.langrock@secunet.com>
Autocrypt: addr=christian.langrock@secunet.com; prefer-encrypt=mutual;
 keydata=
 LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tClZlcnNpb246IEdudVBHIHYy
 CgptUUVOQkZlZTdqa0JDQUNrZU1JdXpadS9LQkExcTNrS0dyN2Q5aWlaR0Y1SXBKbklFOWRN
 aUszdWF6N3VNMjZWClNUSlZwNmpkR3VTR0dHbWI4MU9TTEVjSUVJc1lLWHZqYmxBS1VYMUE3
 NHQzV01SY2t5M013SmJtTjZBa044UWwKUDQ1bURkZHRQUmYxRWxCMlMzMmk5T3JFa3Z3OHhj
 dkhZUHdiYUhlblhpYzQvOGZIV0VoK3Z0ZC81LzVURFRJVQovYWc5dFFmUGVhMTNpeFhOMFB1
 Y2NNdWJGZVVNcHdGQ2czMjQrWjE5aUd2ZkRXV1ptUVFHbEJqYzNRNnowaFhPCmIvZGVXTC8r
 bFBTNHQrdFRncG1tWk80WGtJcysxOEtxeENWdWtDYm5xVjB5KzA0c2ozRzFHUS9EbEd2Wkh4
 d3kKd0JjZUFMN0J2bWRlWFFLQVMwS1JMNXpyZ2hJQkNnblV5dXREQUJFQkFBRzBNME5vY21s
 emRHbGhiaUJNWVc1bgpjbTlqYXlBOFkyaHlhWE4wYVdGdUxteGhibWR5YjJOclFITmxZM1Z1
 WlhRdVkyOXRQb2tCTndRVEFRZ0FJUVVDClY1N3VPUUliQXdVTENRZ0hBZ1lWQ0FrS0N3SUVG
 Z0lEQVFJZUFRSVhnQUFLQ1JDamVNZGZndXRyWHUza0NBQ0kKQng2VUhSZUJ0QmNpTlVQa1Az
 ZlJhR2VTT0FESXJxbDcyVktEOWZhTEFIVHQ2dzhrdnl6YjhDdHBhNzdqc3dKdAoyMWMzNDlt
 RjNtYVBscE50cHN3cUgyN2JUbFhZaE5jWHhjbUhQQ2JOdE4zeUdVeTBVdUlKZkJNWmM4UExx
 aXFZCm9ZNUdLRDN1aW1lVmJEWWpnTmhlYk8yZjFjVXZ3WTJ3VHdYNmIwdGdLVksweFlZVERw
 WEkxLzJNVkdzalhxYWsKN1BRb3FWcTBzRHUwZ0lBQWkxUU8wRmJiNmpJYUhqNkNFTTJocEJU
 Qms4cWJrUHMvTXFZR2RMbDRvWHZrV1RMZAp1UWptNmRNdGp4dkl0NldKV1pRYkxqVGVRSWZj
 MjFsdU5RS0RtZlQ2MjNwVlRQUE1NQWNpV2ZwZHc2M0ZibGZHCmNmQm5BS0NKOEpCajB6OVQ2
 L1BtdVFFTkJGZWU3amtCQ0FEUzdhbUpQYlkyZFdwZUd0RStJOXlMTDUzbFNyaVAKNEw2ckk5
 VW9Fd05NMU9ram5CN3dGbkg4ZG04TjY4SzJPSm9na0h3b1gyT256R2h4SjI4TkhSdUFoKysz
 aElZWQorZ1U0SE1MYVgzb25ESzFvcUFkWWN6aEo3ZjZVQ1BiWWFnaGt6SjZWZy9GRVdwQTh1
 NXZHL0JYNHkrRjMvWTk4Cmw2bXpBWDV3TG1UYXBSd2RmdVJDWFJBNmpsSUhJT3dQM05QS0s0
 UHoyRTd3aXRzaW1WMXVjTjR1WEZpWjM2Q1UKUEFpWFhsRVI5aVBablFVU3lDb2JxSk9KS200
 Qzd3VU5RMW5lZ0NYREJkM0tqU3l6VElhZncvb1lHNFJyV0d1bAppSTJpZy9xVFVDOGNaZEFK
 VE1CalVKUjZ1Z0phek1CMVJnMTdwMkdSRDBBelVPVjJxZHFZRnFRRkFCRUJBQUdKCkFSOEVH
 QUVJQUFrRkFsZWU3amtDR3d3QUNna1FvM2pIWDRMcmExN3Z0UWdBZzJnMEpFWFZUR1QzNkJE
 SmdWakkKVVkxZXZubTFmV3dUUHBjb2tQLzgvYU8ydWJtbHh0V1EyaFY1T1BmTDVuRGRheTJT
 NE5xNWoza3FRcStydlVyTwpSVm12VDRXeFlaTTFmcjJuaWJ1emFVYnNKdHhwaE5wamFocnNF
 Y0xMVHpCVzRDYkhUYUw0WVRUK1pEL0dEZUhvCnhBaDlKZk1rZE1CWEh5V1R1dytRU1AwcHA3
 V3ZOc0Rvc3VrS0Z5UTBydmU5UEgyZHJ5NkEwb0xQN1V4dEF6RUUKUlYyU2UwQnVlWlBRdVZu
 VTZDdmozWlN0SzI4SkRoTWp4SVBrWlBFNWtDVjhRTkY4T3Npd3ltQTNhb1BLZTVCdwowbE9j
 anV1Smt4UmE1YmF6eXV1Ylg5cElJZ1RlR3NlY2dwU2dwZkE5anNFSEtGcW9MdXhVQSs3N1ZR
 NWhTeWRWCmFRPT0KPU82RWEKLS0tLS1FTkQgUEdQIFBVQkxJQyBLRVkgQkxPQ0stLS0tLQo=
Subject: Subject: [PATCH net] drivers: net: ixgbe: Fix *_ipsec_offload_ok():,
 Use ip_hdr family
Message-ID: <1581f61a-f405-008a-8f31-e9e696667d5a@secunet.com>
Date:   Mon, 26 Oct 2020 15:44:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="83irB3y4xUYN8Gr0J6bU9Et2fudiR4f56"
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--83irB3y4xUYN8Gr0J6bU9Et2fudiR4f56
Content-Type: multipart/mixed; boundary="hcu4w2zUfmY0vnolCZjPYiBKobKVdJZ0R";
 protected-headers="v1"
From: Christian Langrock <christian.langrock@secunet.com>
To: davem@davemloft.net, netdev@vger.kernel.org, jesse.brandeburg@intel.com,
 anthony.l.nguyen@intel.com
Message-ID: <1581f61a-f405-008a-8f31-e9e696667d5a@secunet.com>
Subject: Subject: [PATCH net] drivers: net: ixgbe: Fix *_ipsec_offload_ok():,
 Use ip_hdr family

--hcu4w2zUfmY0vnolCZjPYiBKobKVdJZ0R
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Content-Language: de-DE

WGZybV9kZXZfb2ZmbG9hZF9vaygpIGlzIGNhbGxlZCB3aXRoIHRoZSB1bmVuY3J5cHRlZCBT
S0IuIFNvIGluIGNhc2Ugb2YKaW50ZXJmYW1pbHkgaXBzZWMgdHJhZmZpYyAoSVB2NC1pbi1J
UHY2IGFuZCBJUHY2IGluIElQdjQpIHRoZSBjaGVjawphc3N1bWVzIHRoZSB3cm9uZyBmYW1p
bHkgb2YgdGhlIHNrYiAoSVAgZmFtaWx5IG9mIHRoZSBzdGF0ZSkuCldpdGggdGhpcyBwYXRj
aCB0aGUgaXAgaGVhZGVyIG9mIHRoZSBTS0IgaXMgdXNlZCB0byBkZXRlcm1pbmUgdGhlCmZh
bWlseS4KClNpZ25lZC1vZmYtYnk6IENocmlzdGlhbiBMYW5ncm9jayA8Y2hyaXN0aWFuLmxh
bmdyb2NrQHNlY3VuZXQuY29tPgotLS0KwqBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9p
eGdiZS9peGdiZV9pcHNlYy5jIHwgMiArLQrCoGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2l4Z2JldmYvaXBzZWMuY8KgwqDCoMKgIHwgMiArLQrCoDIgZmlsZXMgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX2lwc2VjLmMKYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9peGdiZS9peGdiZV9pcHNlYy5jCmluZGV4IGVjYTczNTI2YWM4Ni4uMzYw
MWRkMjkzNDYzIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdi
ZS9peGdiZV9pcHNlYy5jCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2Jl
L2l4Z2JlX2lwc2VjLmMKQEAgLTgxMyw3ICs4MTMsNyBAQCBzdGF0aWMgdm9pZCBpeGdiZV9p
cHNlY19kZWxfc2Eoc3RydWN0IHhmcm1fc3RhdGUgKnhzKQrCoCAqKi8KwqBzdGF0aWMgYm9v
bCBpeGdiZV9pcHNlY19vZmZsb2FkX29rKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdAp4
ZnJtX3N0YXRlICp4cykKwqB7Ci3CoMKgwqDCoMKgwqAgaWYgKHhzLT5wcm9wcy5mYW1pbHkg
PT0gQUZfSU5FVCkgeworwqDCoMKgwqDCoMKgIGlmIChpcF9oZHIoc2tiKS0+dmVyc2lvbiA9
PSA0KSB7CsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBPZmZsb2FkIHdpdGgg
SVB2NCBvcHRpb25zIGlzIG5vdCBzdXBwb3J0ZWQgeWV0ICovCsKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBpZiAoaXBfaGRyKHNrYiktPmlobCAhPSA1KQrCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBmYWxzZTsKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JldmYvaXBzZWMuYwpiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JldmYvaXBzZWMuYwppbmRleCA1MTcwZGQ5
ZDg3MDUuLmIxZDcyZDVkMTc0NCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaXhnYmV2Zi9pcHNlYy5jCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2l4Z2JldmYvaXBzZWMuYwpAQCAtNDE4LDcgKzQxOCw3IEBAIHN0YXRpYyB2b2lkIGl4Z2Jl
dmZfaXBzZWNfZGVsX3NhKHN0cnVjdCB4ZnJtX3N0YXRlICp4cykKwqAgKiovCsKgc3RhdGlj
IGJvb2wgaXhnYmV2Zl9pcHNlY19vZmZsb2FkX29rKHN0cnVjdCBza19idWZmICpza2IsIHN0
cnVjdAp4ZnJtX3N0YXRlICp4cykKwqB7Ci3CoMKgwqDCoMKgwqAgaWYgKHhzLT5wcm9wcy5m
YW1pbHkgPT0gQUZfSU5FVCkgeworwqDCoMKgwqDCoMKgIGlmIChpcF9oZHIoc2tiKS0+dmVy
c2lvbiA9PSA0KSB7CsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBPZmZsb2Fk
IHdpdGggSVB2NCBvcHRpb25zIGlzIG5vdCBzdXBwb3J0ZWQgeWV0ICovCsKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoaXBfaGRyKHNrYiktPmlobCAhPSA1KQrCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBmYWxzZTsK
LS0gCjIuMjkuMS4xLmcyZTY3MzM1NmFlCgoKLS0gCkRpcGwuLUluZi4oRkgpIENocmlzdGlh
biBMYW5ncm9jawpTZW5pb3IgQ29uc3VsdGFudApOZXR3b3JrICYgQ2xpZW50IFNlY3VyaXR5
CkRpdmlzaW9uIFB1YmxpYyBBdXRob3JpdGllcwpzZWN1bmV0IFNlY3VyaXR5IE5ldHdvcmtz
IEFHIAoKClBob25lOiArNDkgMjAxIDU0NTQtMzgzMyAKRS1NYWlsOiBjaHJpc3RpYW4ubGFu
Z3JvY2tAc2VjdW5ldC5jb20KCkFtbW9uc3RyYcOfZSA3NCAKMDEwNjcgRHJlc2RlbiwgR2Vy
bWFueQp3d3cuc2VjdW5ldC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KClJlZ2lzdGVyZWQgYXQ6
IEt1cmZ1ZXJzdGVuc3RyYXNzZSA1OCwgNDUxMzggRXNzZW4sIEdlcm1hbnkgCkFtdHNnZXJp
Y2h0IEVzc2VuIEhSQiAxMzYxNQpNYW5hZ2VtZW50IEJvYXJkOiBEciBSYWluZXIgQmF1bWdh
cnQgKENFTyksIFRob21hcyBQbGVpbmVzIApDaGFpcm1hbiBvZiBTdXBlcnZpc29yeSBCb2Fy
ZDogUmFsZiBXaW50ZXJnZXJzdApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCgo=

--hcu4w2zUfmY0vnolCZjPYiBKobKVdJZ0R--

--83irB3y4xUYN8Gr0J6bU9Et2fudiR4f56
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJfluDtAAoJEKN4x1+C62teGrgH/jKEH8KW6Od67dWTo7fhkj/u
mTZ3gpyd+IJ8/exZ4qVCIP8U2pI3IJz9aMz2JYVb+0fY9nHAP8FnixZLf8GqYZE/
wT+KOQKUW+zcotG+QUlBwBtRmCLn+yTUeupAd5TJe4vBZgwrzbCq4tGx4z1G1Ua0
Pa3xID1AHVW51ZxYLtPFF4rIa83cTTFnayAcwJRfhIQ+LFUZaSMUD1dgd2pO1eCX
Y4IYtsTY6QegoKlj8Xqp1EQboe10fBHXNV6gitMW+Hrf0Pu+qiWcDtsPDtQe1Ada
tk1i1XWJth+ulnIs4HkVSMVDUqAC/XzFbFVQb+tFlvLzDr0En+0DdFaXaokWato=
=uM3l
-----END PGP SIGNATURE-----

--83irB3y4xUYN8Gr0J6bU9Et2fudiR4f56--

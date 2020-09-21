Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67BA271ACC
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 08:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgIUGWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 02:22:21 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:38486 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbgIUGWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 02:22:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 30506201D5;
        Mon, 21 Sep 2020 08:22:18 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rXX-K3gpBBjR; Mon, 21 Sep 2020 08:22:11 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 72CA4200AA;
        Mon, 21 Sep 2020 08:22:11 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Sep 2020 08:22:11 +0200
Received: from [172.18.3.9] (172.18.3.9) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 21 Sep
 2020 08:22:10 +0200
From:   Christian Langrock <christian.langrock@secunet.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jeffrey.t.kirsher@intel.com>, <kuba@kernel.org>,
        <borisp@nvidia.com>
References: <14366463-cf15-ceec-c3ee-17b5796ac59c@secunet.com>
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
Subject: Re: [PATCH net] drivers: net: Fix *_ipsec_offload_ok(): Use ip_hdr
 family
Message-ID: <234b8fbd-713d-5745-9a7b-ca9d002b95e1@secunet.com>
Date:   Mon, 21 Sep 2020 08:22:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <14366463-cf15-ceec-c3ee-17b5796ac59c@secunet.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="MEGaAd48N0RERuuPAbkbVdMiTosgShvla"
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MEGaAd48N0RERuuPAbkbVdMiTosgShvla
Content-Type: multipart/mixed; boundary="m4BVZtIl6OfaFrTREqeTOqK1nPWQAUVXe";
 protected-headers="v1"
From: Christian Langrock <christian.langrock@secunet.com>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
 jeffrey.t.kirsher@intel.com, kuba@kernel.org, borisp@nvidia.com
Message-ID: <234b8fbd-713d-5745-9a7b-ca9d002b95e1@secunet.com>
Subject: Re: [PATCH net] drivers: net: Fix *_ipsec_offload_ok(): Use ip_hdr
 family
References: <14366463-cf15-ceec-c3ee-17b5796ac59c@secunet.com>
In-Reply-To: <14366463-cf15-ceec-c3ee-17b5796ac59c@secunet.com>

--m4BVZtIl6OfaFrTREqeTOqK1nPWQAUVXe
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Content-Language: de-DE

SGVsbG8gRGF2aWQsCgpJIHNhdyB0aGUgc3RhdHVzIG9mIG15IHBhdGNoZWQgaGFzIGJlZW4g
Y2hhbmdlZCB0byAiQ2hhbmdlcyByZXF1ZXN0ZWQiLgoKQ2FuIHlvdSB0ZWxsIG1lIHdoYXQg
Y2FuIEkgZG8gdG8gZ2V0IHRoZSBwYXRjaCBhY2NlcHRlZD8KClRoYW5rIHlvdSBpbiBhZHZh
bmNlIQoKQlIsCgpDaHJpc3RpYW4KCkFtIDE3LjA5LjIwIHVtIDE0OjI3IHNjaHJpZWIgQ2hy
aXN0aWFuIExhbmdyb2NrOgo+IFhmcm1fZGV2X29mZmxvYWRfb2soKSBpcyBjYWxsZWQgd2l0
aCB0aGUgdW5lbmNyeXB0ZWQgU0tCLiBTbyBpbiBjYXNlIG9mCj4gaW50ZXJmYW1pbHkgaXBz
ZWMgdHJhZmZpYyAoSVB2NC1pbi1JUHY2IGFuZCBJUHY2IGluIElQdjQpIHRoZSBjaGVjawo+
IGFzc3VtZXMgdGhlIHdyb25nIGZhbWlseSBvZiB0aGUgc2tiIChJUCBmYW1pbHkgb2YgdGhl
IHN0YXRlKS4KPiBXaXRoIHRoaXMgcGF0Y2ggdGhlIGlwIGhlYWRlciBvZiB0aGUgU0tCIGlz
IHVzZWQgdG8gZGV0ZXJtaW5lIHRoZQo+IGZhbWlseS4KPgo+IFNpZ25lZC1vZmYtYnk6IENo
cmlzdGlhbiBMYW5ncm9jayA8Y2hyaXN0aWFuLmxhbmdyb2NrQHNlY3VuZXQuY29tPgo+IC0t
LQo+IMKgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfaXBzZWMuY8Kg
wqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaXhnYmV2Zi9pcHNlYy5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDIgKy0K
PiDCoGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9p
cHNlYy5jIHwgMiArLQo+IMKgMyBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMg
ZGVsZXRpb25zKC0pCj4KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaXhnYmUvaXhnYmVfaXBzZWMuYwo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aXhnYmUvaXhnYmVfaXBzZWMuYwo+IGluZGV4IGVjYTczNTI2YWM4Ni4uMzYwMWRkMjkzNDYz
IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2Jl
X2lwc2VjLmMKPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdi
ZV9pcHNlYy5jCj4gQEAgLTgxMyw3ICs4MTMsNyBAQCBzdGF0aWMgdm9pZCBpeGdiZV9pcHNl
Y19kZWxfc2Eoc3RydWN0IHhmcm1fc3RhdGUgKnhzKQo+IMKgICoqLwo+IMKgc3RhdGljIGJv
b2wgaXhnYmVfaXBzZWNfb2ZmbG9hZF9vayhzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QK
PiB4ZnJtX3N0YXRlICp4cykKPiDCoHsKPiAtwqDCoMKgwqDCoMKgIGlmICh4cy0+cHJvcHMu
ZmFtaWx5ID09IEFGX0lORVQpIHsKPiArwqDCoMKgwqDCoMKgIGlmIChpcF9oZHIoc2tiKS0+
dmVyc2lvbiA9PSA0KSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIE9m
ZmxvYWQgd2l0aCBJUHY0IG9wdGlvbnMgaXMgbm90IHN1cHBvcnRlZCB5ZXQgKi8KPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGlwX2hkcihza2IpLT5paGwgIT0gNSkK
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVy
biBmYWxzZTsKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhn
YmV2Zi9pcHNlYy5jCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZXZmL2lw
c2VjLmMKPiBpbmRleCA1MTcwZGQ5ZDg3MDUuLmIxZDcyZDVkMTc0NCAxMDA2NDQKPiAtLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZXZmL2lwc2VjLmMKPiArKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZXZmL2lwc2VjLmMKPiBAQCAtNDE4LDcg
KzQxOCw3IEBAIHN0YXRpYyB2b2lkIGl4Z2JldmZfaXBzZWNfZGVsX3NhKHN0cnVjdCB4ZnJt
X3N0YXRlICp4cykKPiDCoCAqKi8KPiDCoHN0YXRpYyBib29sIGl4Z2JldmZfaXBzZWNfb2Zm
bG9hZF9vayhzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QKPiB4ZnJtX3N0YXRlICp4cykK
PiDCoHsKPiAtwqDCoMKgwqDCoMKgIGlmICh4cy0+cHJvcHMuZmFtaWx5ID09IEFGX0lORVQp
IHsKPiArwqDCoMKgwqDCoMKgIGlmIChpcF9oZHIoc2tiKS0+dmVyc2lvbiA9PSA0KSB7Cj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIE9mZmxvYWQgd2l0aCBJUHY0IG9w
dGlvbnMgaXMgbm90IHN1cHBvcnRlZCB5ZXQgKi8KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgaWYgKGlwX2hkcihza2IpLT5paGwgIT0gNSkKPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBmYWxzZTsKPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2Vs
L2lwc2VjLmMKPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl9hY2NlbC9pcHNlYy5jCj4gaW5kZXggZDM5OTg5Y2RkZDkwLi5lM2E5YjMxM2IwMWYgMTAw
NjQ0Cj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vu
X2FjY2VsL2lwc2VjLmMKPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fYWNjZWwvaXBzZWMuYwo+IEBAIC00NjAsNyArNDYwLDcgQEAgdm9pZCBt
bHg1ZV9pcHNlY19jbGVhbnVwKHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2KQo+IMKgCj4gwqBz
dGF0aWMgYm9vbCBtbHg1ZV9pcHNlY19vZmZsb2FkX29rKHN0cnVjdCBza19idWZmICpza2Is
IHN0cnVjdAo+IHhmcm1fc3RhdGUgKngpCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoCBpZiAoeC0+
cHJvcHMuZmFtaWx5ID09IEFGX0lORVQpIHsKPiArwqDCoMKgwqDCoMKgIGlmIChpcF9oZHIo
c2tiKS0+dmVyc2lvbiA9PSA0KSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IC8qIE9mZmxvYWQgd2l0aCBJUHY0IG9wdGlvbnMgaXMgbm90IHN1cHBvcnRlZCB5ZXQgKi8K
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGlwX2hkcihza2IpLT5paGwg
PiA1KQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIGZhbHNlOwoKLS0gCkRpcGwuLUluZi4oRkgpIENocmlzdGlhbiBMYW5ncm9jawpT
ZW5pb3IgQ29uc3VsdGFudApOZXR3b3JrICYgQ2xpZW50IFNlY3VyaXR5CkRpdmlzaW9uIFB1
YmxpYyBBdXRob3JpdGllcwpzZWN1bmV0IFNlY3VyaXR5IE5ldHdvcmtzIEFHIAoKClBob25l
OiArNDkgMjAxIDU0NTQtMzgzMyAKRS1NYWlsOiBjaHJpc3RpYW4ubGFuZ3JvY2tAc2VjdW5l
dC5jb20KCkFtbW9uc3RyYcOfZSA3NCAKMDEwNjcgRHJlc2RlbiwgR2VybWFueQp3d3cuc2Vj
dW5ldC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KClJlZ2lzdGVyZWQgYXQ6IEt1cmZ1ZXJzdGVu
c3RyYXNzZSA1OCwgNDUxMzggRXNzZW4sIEdlcm1hbnkgCkFtdHNnZXJpY2h0IEVzc2VuIEhS
QiAxMzYxNQpNYW5hZ2VtZW50IEJvYXJkOiBEciBSYWluZXIgQmF1bWdhcnQgKENFTyksIFRo
b21hcyBQbGVpbmVzIApDaGFpcm1hbiBvZiBTdXBlcnZpc29yeSBCb2FyZDogUmFsZiBXaW50
ZXJnZXJzdApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCgo=

--m4BVZtIl6OfaFrTREqeTOqK1nPWQAUVXe--

--MEGaAd48N0RERuuPAbkbVdMiTosgShvla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJfaEaOAAoJEKN4x1+C62teG5MH/2E1g1oq6ySSUsdcSMRNt9pV
rZdoYt/Desyqa+Z4whPB4MtyqK5BR4v0i5b0diqKqXkXkrs4A3Ge4EoyTSPCVxN6
dhyFro4msGM+N2CAZjysvlhLPR/t6ZwFyMELdeqV/EtocSFVtXRn+jbGOoF3T8Ii
QAHkw+LUAcsh8f2pXFhOh2nd4j8Z8fA7XajrjaLIcXMZyfEU5AGsSEQczneS5i6T
daTvwHiVDJQMN1P4jZPCA8CLseTAE//1iy8v3nBdHywL+3z3fdquoRstdl+fJtq+
8U4eL21+bi+Iv1ygVcsv4ZIAotQaL/wjm2UImc6HpxD+tvemzWqqV9xjBgnUjJM=
=Ccm8
-----END PGP SIGNATURE-----

--MEGaAd48N0RERuuPAbkbVdMiTosgShvla--

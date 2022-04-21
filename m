Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F62D509987
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiDUHta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 03:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386141AbiDUHt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 03:49:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF26AE0BF
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 00:46:09 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-143-EY_ZALJrNMSPB3XotYphJA-1; Thu, 21 Apr 2022 08:46:06 +0100
X-MC-Unique: EY_ZALJrNMSPB3XotYphJA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Thu, 21 Apr 2022 08:46:06 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Thu, 21 Apr 2022 08:46:05 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexander Lobakin' <alobakin@pm.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 bpf 07/11] samples/bpf: fix uin64_t format literals
Thread-Topic: [PATCH v2 bpf 07/11] samples/bpf: fix uin64_t format literals
Thread-Index: AQHYVRiVJrq2qiQDe0mMJ5hGbTMRxaz5/N3g
Date:   Thu, 21 Apr 2022 07:46:05 +0000
Message-ID: <ca0733f123bf498a831324c4692a0df8@AcuMS.aculab.com>
References: <20220421003152.339542-1-alobakin@pm.me>
 <20220421003152.339542-8-alobakin@pm.me>
In-Reply-To: <20220421003152.339542-8-alobakin@pm.me>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQWxleGFuZGVyIExvYmFraW4NCj4gU2VudDogMjEgQXByaWwgMjAyMiAwMTo0MA0KPiAN
Cj4gVGhlcmUncyBhIGNvdXBsZSBwbGFjZXMgd2hlcmUgdWluNjRfdCBpcyBiZWluZyBwYXNzZWQg
YXMgYW4gJWx1DQo+IGZvcm1hdCBhcmd1bWVudC4gVGhhdCB0eXBlIGlzIGRlZmluZWQgYXMgdW5z
aWduZWQgbG9uZyBvbiA2NC1iaXQNCj4gc3lzdGVtcyBhbmQgYXMgdW5zaWduZWQgbG9uZyBsb25n
IG9uIDMyLWJpdCwgc28gbmVpdGhlciAlbHUgbm9yDQo+ICVsbHUgYXJlIG5vdCB1bml2ZXJzYWwu
DQo+IE9uZSBvZiB0aGUgb3B0aW9ucyBpcyAlUFJJdTY0LCBidXQgc2luY2UgaXQncyBhbHdheXMg
OC1ieXRlIGxvbmcsDQo+IGp1c3QgY2FzdCBpdCB0byB0aGUgX3Byb3Blcl8gX191NjQgYW5kIHBy
aW50IGFzICVsbHUuDQoNCklzIF9fdTY0IGd1YXJhbnRlZWQgdG8gYmUgJ3Vuc2lnbmVkIGxvbmcg
bG9uZycgPyBObyByZWFzb24gd2h5IGl0IHNob3VsZCBiZS4NCkkgdGhpbmsgeW91IG5lZWQgdG8g
Y2FzdCB0byAodW5zaWduZWQgbG9uZyBsb25nKS4NCg0KCURhdmlkDQoNCj4gRml4ZXM6IDUxNTcw
YTVhYjJiNyAoIkEgU2FtcGxlIG9mIHVzaW5nIHNvY2tldCBjb29raWUgYW5kIHVpZCBmb3IgdHJh
ZmZpYyBtb25pdG9yaW5nIikNCj4gRml4ZXM6IDAwZjY2MGVhZjM3OCAoIlNhbXBsZSBwcm9ncmFt
IHVzaW5nIFNPX0NPT0tJRSIpDQo+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRlciBMb2Jha2luIDxh
bG9iYWtpbkBwbS5tZT4NCj4gLS0tDQo+ICBzYW1wbGVzL2JwZi9jb29raWVfdWlkX2hlbHBlcl9l
eGFtcGxlLmMgfCAxMiArKysrKystLS0tLS0NCj4gIHNhbXBsZXMvYnBmL2x3dF9sZW5faGlzdF91
c2VyLmMgICAgICAgICB8ICA3ICsrKystLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0
aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9zYW1wbGVzL2JwZi9j
b29raWVfdWlkX2hlbHBlcl9leGFtcGxlLmMgYi9zYW1wbGVzL2JwZi9jb29raWVfdWlkX2hlbHBl
cl9leGFtcGxlLmMNCj4gaW5kZXggZjBkZjNkZGE0YjFmLi4yNjlmYWM1OGZkNWMgMTAwNjQ0DQo+
IC0tLSBhL3NhbXBsZXMvYnBmL2Nvb2tpZV91aWRfaGVscGVyX2V4YW1wbGUuYw0KPiArKysgYi9z
YW1wbGVzL2JwZi9jb29raWVfdWlkX2hlbHBlcl9leGFtcGxlLmMNCj4gQEAgLTIwNyw5ICsyMDcs
OSBAQCBzdGF0aWMgdm9pZCBwcmludF90YWJsZSh2b2lkKQ0KPiAgCQkJZXJyb3IoMSwgZXJybm8s
ICJmYWlsIHRvIGdldCBlbnRyeSB2YWx1ZSBvZiBLZXk6ICV1XG4iLA0KPiAgCQkJCWN1ck4pOw0K
PiAgCQl9IGVsc2Ugew0KPiAtCQkJcHJpbnRmKCJjb29raWU6ICV1LCB1aWQ6IDB4JXgsIFBhY2tl
dCBDb3VudDogJWx1LCINCj4gLQkJCQkiIEJ5dGVzIENvdW50OiAlbHVcbiIsIGN1ck4sIGN1ckVu
dHJ5LnVpZCwNCj4gLQkJCQljdXJFbnRyeS5wYWNrZXRzLCBjdXJFbnRyeS5ieXRlcyk7DQo+ICsJ
CQlwcmludGYoImNvb2tpZTogJXUsIHVpZDogMHgleCwgUGFja2V0IENvdW50OiAlbGx1LCBCeXRl
cyBDb3VudDogJWxsdVxuIiwNCj4gKwkJCSAgICAgICBjdXJOLCBjdXJFbnRyeS51aWQsIChfX3U2
NCljdXJFbnRyeS5wYWNrZXRzLA0KPiArCQkJICAgICAgIChfX3U2NCljdXJFbnRyeS5ieXRlcyk7
DQo+ICAJCX0NCj4gIAl9DQo+ICB9DQo+IEBAIC0yNjUsOSArMjY1LDkgQEAgc3RhdGljIHZvaWQg
dWRwX2NsaWVudCh2b2lkKQ0KPiAgCQlpZiAocmVzIDwgMCkNCj4gIAkJCWVycm9yKDEsIGVycm5v
LCAibG9va3VwIHNrIHN0YXQgZmFpbGVkLCBjb29raWU6ICVsdVxuIiwNCj4gIAkJCSAgICAgIGNv
b2tpZSk7DQo+IC0JCXByaW50ZigiY29va2llOiAlbHUsIHVpZDogMHgleCwgUGFja2V0IENvdW50
OiAlbHUsIg0KPiAtCQkJIiBCeXRlcyBDb3VudDogJWx1XG5cbiIsIGNvb2tpZSwgZGF0YUVudHJ5
LnVpZCwNCj4gLQkJCWRhdGFFbnRyeS5wYWNrZXRzLCBkYXRhRW50cnkuYnl0ZXMpOw0KPiArCQlw
cmludGYoImNvb2tpZTogJWxsdSwgdWlkOiAweCV4LCBQYWNrZXQgQ291bnQ6ICVsbHUsIEJ5dGVz
IENvdW50OiAlbGx1XG5cbiIsDQo+ICsJCSAgICAgICAoX191NjQpY29va2llLCBkYXRhRW50cnku
dWlkLCAoX191NjQpZGF0YUVudHJ5LnBhY2tldHMsDQo+ICsJCSAgICAgICAoX191NjQpZGF0YUVu
dHJ5LmJ5dGVzKTsNCj4gIAl9DQo+ICAJY2xvc2Uoc19zZW5kKTsNCj4gIAljbG9zZShzX3Jjdik7
DQo+IGRpZmYgLS1naXQgYS9zYW1wbGVzL2JwZi9sd3RfbGVuX2hpc3RfdXNlci5jIGIvc2FtcGxl
cy9icGYvbHd0X2xlbl9oaXN0X3VzZXIuYw0KPiBpbmRleCA0MzBhNGI3ZTM1M2UuLmM2ODJmYWE3
NWEyYiAxMDA2NDQNCj4gLS0tIGEvc2FtcGxlcy9icGYvbHd0X2xlbl9oaXN0X3VzZXIuYw0KPiAr
KysgYi9zYW1wbGVzL2JwZi9sd3RfbGVuX2hpc3RfdXNlci5jDQo+IEBAIC00NCw3ICs0NCw4IEBA
IGludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikNCj4gDQo+ICAJd2hpbGUgKGJwZl9tYXBf
Z2V0X25leHRfa2V5KG1hcF9mZCwgJmtleSwgJm5leHRfa2V5KSA9PSAwKSB7DQo+ICAJCWlmIChu
ZXh0X2tleSA+PSBNQVhfSU5ERVgpIHsNCj4gLQkJCWZwcmludGYoc3RkZXJyLCAiS2V5ICVsdSBv
dXQgb2YgYm91bmRzXG4iLCBuZXh0X2tleSk7DQo+ICsJCQlmcHJpbnRmKHN0ZGVyciwgIktleSAl
bGx1IG91dCBvZiBib3VuZHNcbiIsDQo+ICsJCQkJKF9fdTY0KW5leHRfa2V5KTsNCj4gIAkJCWNv
bnRpbnVlOw0KPiAgCQl9DQo+IA0KPiBAQCAtNjYsOCArNjcsOCBAQCBpbnQgbWFpbihpbnQgYXJn
YywgY2hhciAqKmFyZ3YpDQo+IA0KPiAgCWZvciAoaSA9IDE7IGkgPD0gbWF4X2tleSArIDE7IGkr
Kykgew0KPiAgCQlzdGFycyhzdGFyc3RyLCBkYXRhW2kgLSAxXSwgbWF4X3ZhbHVlLCBNQVhfU1RB
UlMpOw0KPiAtCQlwcmludGYoIiU4bGQgLT4gJS04bGQgOiAlLThsZCB8JS0qc3xcbiIsDQo+IC0J
CSAgICAgICAoMWwgPDwgaSkgPj4gMSwgKDFsIDw8IGkpIC0gMSwgZGF0YVtpIC0gMV0sDQo+ICsJ
CXByaW50ZigiJThsZCAtPiAlLThsZCA6ICUtOGxsZCB8JS0qc3xcbiIsDQo+ICsJCSAgICAgICAo
MWwgPDwgaSkgPj4gMSwgKDFsIDw8IGkpIC0gMSwgKF9fdTY0KWRhdGFbaSAtIDFdLA0KPiAgCQkg
ICAgICAgTUFYX1NUQVJTLCBzdGFyc3RyKTsNCj4gIAl9DQo+IA0KPiAtLQ0KPiAyLjM2LjANCj4g
DQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBG
YXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg==


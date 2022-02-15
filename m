Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BD64B72DF
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241484AbiBOQUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 11:20:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241470AbiBOQUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 11:20:30 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35109B8B4A;
        Tue, 15 Feb 2022 08:20:20 -0800 (PST)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JymWv4Dlyz67kVB;
        Wed, 16 Feb 2022 00:19:55 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 17:20:17 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Tue, 15 Feb 2022 17:20:17 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Shuah Khan <skhan@linuxfoundation.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 6/6] selftests/bpf: Add test for
 bpf_lsm_kernel_read_file()
Thread-Topic: [PATCH v2 6/6] selftests/bpf: Add test for
 bpf_lsm_kernel_read_file()
Thread-Index: AQHYImmRXWHSMGlI7Eid9Hu2hrMmoKyUt62AgAARXDA=
Date:   Tue, 15 Feb 2022 16:20:17 +0000
Message-ID: <509ea86d324445b59bedd4a93015d7c3@huawei.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
 <20220215124042.186506-7-roberto.sassu@huawei.com>
 <a06aaff2-2760-faff-db00-082543953bfe@linuxfoundation.org>
In-Reply-To: <a06aaff2-2760-faff-db00-082543953bfe@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.33]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBTaHVhaCBLaGFuIFttYWlsdG86c2toYW5AbGludXhmb3VuZGF0aW9uLm9yZ10NCj4g
U2VudDogVHVlc2RheSwgRmVicnVhcnkgMTUsIDIwMjIgNToxMSBQTQ0KPiBPbiAyLzE1LzIyIDU6
NDAgQU0sIFJvYmVydG8gU2Fzc3Ugd3JvdGU6DQo+ID4gVGVzdCB0aGUgYWJpbGl0eSBvZiBicGZf
bHNtX2tlcm5lbF9yZWFkX2ZpbGUoKSB0byBjYWxsIHRoZSBzbGVlcGFibGUNCj4gPiBmdW5jdGlv
bnMgYnBmX2ltYV9pbm9kZV9oYXNoKCkgb3IgYnBmX2ltYV9maWxlX2hhc2goKSB0byBvYnRhaW4g
YQ0KPiA+IG1lYXN1cmVtZW50IG9mIGEgbG9hZGVkIElNQSBwb2xpY3kuDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBSb2JlcnRvIFNhc3N1IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+DQo+ID4g
LS0tDQo+ID4gICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvaW1hX3NldHVwLnNoICAgICAg
fCAgMiArKw0KPiA+ICAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy90ZXN0X2ltYS5jICAg
ICAgIHwgIDMgKy0NCj4gPiAgIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9pbWEu
YyAgICAgICB8IDI4ICsrKysrKysrKysrKysrKystLS0NCj4gPiAgIDMgZmlsZXMgY2hhbmdlZCwg
MjggaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS90
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvaW1hX3NldHVwLnNoDQo+IGIvdG9vbHMvdGVzdGlu
Zy9zZWxmdGVzdHMvYnBmL2ltYV9zZXR1cC5zaA0KPiA+IGluZGV4IDhlNjI1ODExMTNhMy4uODI1
MzBmMTlmODVhIDEwMDc1NQ0KPiA+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9p
bWFfc2V0dXAuc2gNCj4gPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvaW1hX3Nl
dHVwLnNoDQo+ID4gQEAgLTUxLDYgKzUxLDcgQEAgc2V0dXAoKQ0KPiA+DQo+ID4gICAJZW5zdXJl
X21vdW50X3NlY3VyaXR5ZnMNCj4gPiAgIAllY2hvICJtZWFzdXJlIGZ1bmM9QlBSTV9DSEVDSyBm
c3V1aWQ9JHttb3VudF91dWlkfSIgPg0KPiAke0lNQV9QT0xJQ1lfRklMRX0NCj4gPiArCWVjaG8g
Im1lYXN1cmUgZnVuYz1CUFJNX0NIRUNLIGZzdXVpZD0ke21vdW50X3V1aWR9IiA+DQo+ICR7bW91
bnRfZGlyfS9wb2xpY3lfdGVzdA0KPiA+ICAgfQ0KPiA+DQo+ID4gICBjbGVhbnVwKCkgew0KPiA+
IEBAIC03NCw2ICs3NSw3IEBAIHJ1bigpDQo+ID4gICAJbG9jYWwgbW91bnRfZGlyPSIke3RtcF9k
aXJ9L21udCINCj4gPiAgIAlsb2NhbCBjb3BpZWRfYmluX3BhdGg9IiR7bW91bnRfZGlyfS8kKGJh
c2VuYW1lICR7VEVTVF9CSU5BUll9KSINCj4gPg0KPiA+ICsJZWNobyAke21vdW50X2Rpcn0vcG9s
aWN5X3Rlc3QgPiAke0lNQV9QT0xJQ1lfRklMRX0NCj4gPiAgIAlleGVjICIke2NvcGllZF9iaW5f
cGF0aH0iDQo+ID4gICB9DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvYnBmL3Byb2dfdGVzdHMvdGVzdF9pbWEuYw0KPiBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2JwZi9wcm9nX3Rlc3RzL3Rlc3RfaW1hLmMNCj4gPiBpbmRleCA2MmJmMGU4MzA0NTMuLmM0
YTYyZDdiNzBkZiAxMDA2NDQNCj4gPiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYv
cHJvZ190ZXN0cy90ZXN0X2ltYS5jDQo+ID4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMv
YnBmL3Byb2dfdGVzdHMvdGVzdF9pbWEuYw0KPiA+IEBAIC05Nyw4ICs5Nyw5IEBAIHZvaWQgdGVz
dF90ZXN0X2ltYSh2b2lkKQ0KPiA+ICAgCS8qDQo+ID4gICAJICogMSBzYW1wbGUgd2l0aCB1c2Vf
aW1hX2ZpbGVfaGFzaCA9IGZhbHNlDQo+ID4gICAJICogMiBzYW1wbGVzIHdpdGggdXNlX2ltYV9m
aWxlX2hhc2ggPSB0cnVlICguL2ltYV9zZXR1cC5zaCwgL2Jpbi90cnVlKQ0KPiA+ICsJICogMSBz
YW1wbGUgd2l0aCB1c2VfaW1hX2ZpbGVfaGFzaCA9IHRydWUgKElNQSBwb2xpY3kpDQo+ID4gICAJ
ICovDQo+ID4gLQlBU1NFUlRfRVEoZXJyLCAzLCAibnVtX3NhbXBsZXNfb3JfZXJyIik7DQo+ID4g
KwlBU1NFUlRfRVEoZXJyLCA0LCAibnVtX3NhbXBsZXNfb3JfZXJyIik7DQo+ID4gICAJQVNTRVJU
X05FUShpbWFfaGFzaF9mcm9tX2JwZiwgMCwgImltYV9oYXNoIik7DQo+ID4NCj4gPiAgIGNsb3Nl
X2NsZWFuOg0KPiA+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJv
Z3MvaW1hLmMNCj4gYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvaW1hLmMNCj4g
PiBpbmRleCA5YmI2M2Y5NmNmYzAuLjliNGMwM2YzMGExYyAxMDA2NDQNCj4gPiAtLS0gYS90b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvaW1hLmMNCj4gPiArKysgYi90b29scy90ZXN0
aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvaW1hLmMNCj4gPiBAQCAtMjAsOCArMjAsNyBAQCBjaGFy
IF9saWNlbnNlW10gU0VDKCJsaWNlbnNlIikgPSAiR1BMIjsNCj4gPg0KPiA+ICAgYm9vbCB1c2Vf
aW1hX2ZpbGVfaGFzaDsNCj4gPg0KPiA+IC1TRUMoImxzbS5zL2Jwcm1fY29tbWl0dGVkX2NyZWRz
IikNCj4gPiAtdm9pZCBCUEZfUFJPRyhpbWEsIHN0cnVjdCBsaW51eF9iaW5wcm0gKmJwcm0pDQo+
ID4gK3N0YXRpYyB2b2lkIGltYV90ZXN0X2NvbW1vbihzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gPiAg
IHsNCj4gPiAgIAl1NjQgaW1hX2hhc2ggPSAwOw0KPiA+ICAgCXU2NCAqc2FtcGxlOw0KPiA+IEBA
IC0zMSwxMCArMzAsMTAgQEAgdm9pZCBCUEZfUFJPRyhpbWEsIHN0cnVjdCBsaW51eF9iaW5wcm0g
KmJwcm0pDQo+ID4gICAJcGlkID0gYnBmX2dldF9jdXJyZW50X3BpZF90Z2lkKCkgPj4gMzI7DQo+
ID4gICAJaWYgKHBpZCA9PSBtb25pdG9yZWRfcGlkKSB7DQo+ID4gICAJCWlmICghdXNlX2ltYV9m
aWxlX2hhc2gpDQo+ID4gLQkJCXJldCA9IGJwZl9pbWFfaW5vZGVfaGFzaChicHJtLT5maWxlLT5m
X2lub2RlLA0KPiAmaW1hX2hhc2gsDQo+ID4gKwkJCXJldCA9IGJwZl9pbWFfaW5vZGVfaGFzaChm
aWxlLT5mX2lub2RlLCAmaW1hX2hhc2gsDQo+ID4gICAJCQkJCQkgc2l6ZW9mKGltYV9oYXNoKSk7
DQo+ID4gICAJCWVsc2UNCj4gPiAtCQkJcmV0ID0gYnBmX2ltYV9maWxlX2hhc2goYnBybS0+Zmls
ZSwgJmltYV9oYXNoLA0KPiA+ICsJCQlyZXQgPSBicGZfaW1hX2ZpbGVfaGFzaChmaWxlLCAmaW1h
X2hhc2gsDQo+ID4gICAJCQkJCQlzaXplb2YoaW1hX2hhc2gpKTsNCj4gPiAgIAkJaWYgKHJldCA8
IDAgfHwgaW1hX2hhc2ggPT0gMCkNCj4gDQo+IElzIHRoaXMgY29uc2lkZXJlZCBhbiBlcnJvcj8g
RG9lcyBpdCBtYWtlIHNlbnNlIGZvciB0aGlzIHRlc3QgdG8gYmUNCj4gdm9pZCB0eXBlIGFuZCBu
b3QgcmV0dXJuIHRoZSBlcnJvciB0byBpdHMgY2FsbGVycz8gT25lIG9mIHRoZSBjYWxsZXJzDQo+
IGJlbG93IHNlZW1zIHRvIGNhcmUgZm9yIHJldHVybiB2YWx1ZXMuDQoNClRoZSB1c2VyIHNwYWNl
IHNpZGUgb2YgdGhlIHRlc3QgKHRlc3RfaW1hLmMpIHNlZW1zIHRvIGNoZWNrIHRoZQ0KbnVtYmVy
IG9mIHNhbXBsZXMgb2J0YWluZWQgZnJvbSB0aGUgcmluZyBidWZmZXIuIEEgZmFpbHVyZSBoZXJl
DQp3b3VsZCByZXN1bHQgaW4gdGhlIHNhbXBsZSBub3QgYmVpbmcgc2VudCB0byB0aGF0IGNvbXBv
bmVudC4NCg0KQW5vdGhlciB0ZXN0LCBhcyB5b3Ugc3VnZ2VzdCwgY291bGQgYmUgdG8gZW5zdXJl
IHRoYXQgdGhlDQprZXJuZWxfcmVhZF9maWxlIGhvb2sgaXMgYWJsZSB0byBkZW55IG9wZXJhdGlv
bnMuIEkgd291bGQgY2hlY2sNCnRoaXMgaW4gYSBzZXBhcmF0ZSB0ZXN0Lg0KDQpUaGFua3MNCg0K
Um9iZXJ0bw0KDQpIVUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhSQiA1NjA2
Mw0KTWFuYWdpbmcgRGlyZWN0b3I6IExpIFBlbmcsIFpob25nIFJvbmdodWEgDQoNCj4gPiAgIAkJ
CXJldHVybjsNCj4gPiBAQCAtNDksMyArNDgsMjQgQEAgdm9pZCBCUEZfUFJPRyhpbWEsIHN0cnVj
dCBsaW51eF9iaW5wcm0gKmJwcm0pDQo+ID4NCj4gPiAgIAlyZXR1cm47DQo+ID4gICB9DQo+ID4g
Kw0KPiA+ICtTRUMoImxzbS5zL2Jwcm1fY29tbWl0dGVkX2NyZWRzIikNCj4gPiArdm9pZCBCUEZf
UFJPRyhpbWEsIHN0cnVjdCBsaW51eF9iaW5wcm0gKmJwcm0pDQo+ID4gK3sNCj4gPiArCWltYV90
ZXN0X2NvbW1vbihicHJtLT5maWxlKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArU0VDKCJsc20ucy9r
ZXJuZWxfcmVhZF9maWxlIikNCj4gPiAraW50IEJQRl9QUk9HKGtlcm5lbF9yZWFkX2ZpbGUsIHN0
cnVjdCBmaWxlICpmaWxlLCBlbnVtIGtlcm5lbF9yZWFkX2ZpbGVfaWQgaWQsDQo+ID4gKwkgICAg
IGJvb2wgY29udGVudHMpDQo+ID4gK3sNCj4gPiArCWlmICghY29udGVudHMpDQo+ID4gKwkJcmV0
dXJuIDA7DQo+ID4gKw0KPiA+ICsJaWYgKGlkICE9IFJFQURJTkdfUE9MSUNZKQ0KPiA+ICsJCXJl
dHVybiAwOw0KPiA+ICsNCj4gPiArCWltYV90ZXN0X2NvbW1vbihmaWxlKTsNCj4gDQo+IFRoaXMg
b25lIGhlcmUuDQo+IA0KPiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+ID4NCj4gDQo+
IHRoYW5rcywNCj4gLS0gU2h1YWgNCg==

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A965B4F462E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 01:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380338AbiDEUEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457131AbiDEQCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:02:46 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C60C1965CE;
        Tue,  5 Apr 2022 08:29:40 -0700 (PDT)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KXs1t6CNPz681Vp;
        Tue,  5 Apr 2022 23:26:42 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 5 Apr 2022 17:29:37 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Tue, 5 Apr 2022 17:29:37 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Casey Schaufler <casey@schaufler-ca.com>,
        Djalal Harouni <tixxdz@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF
 programs
Thread-Topic: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF
 programs
Thread-Index: AQHYQsxoL5kXhl8+JE6PJPNWV+NOTqzYppqAgABrSsCAAo7zgIAAEt0AgAOU8YCAALoz0IABTtSAgAAmCSA=
Date:   Tue, 5 Apr 2022 15:29:37 +0000
Message-ID: <0497bb46586c4f37b9bd01950ba9e6a5@huawei.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
        <20220331022727.ybj4rui4raxmsdpu@MBP-98dd607d3435.dhcp.thefacebook.com>
        <b9f5995f96da447c851f7c9db8232a9b@huawei.com>
        <20220401235537.mwziwuo4n53m5cxp@MBP-98dd607d3435.dhcp.thefacebook.com>
        <CACYkzJ5QgkucL3HZ4bY5Rcme4ey6U3FW4w2Gz-9rdWq0_RHvgA@mail.gmail.com>
        <CAEiveUcx1KHoJ421Cv+52t=0U+Uy2VF51VC_zfTSftQ4wVYOPw@mail.gmail.com>
        <c2e57f10b62940eba3cfcae996e20e3c@huawei.com>
 <385e4cf4-4cd1-8f41-5352-ea87a1f419ad@schaufler-ca.com>
In-Reply-To: <385e4cf4-4cd1-8f41-5352-ea87a1f419ad@schaufler-ca.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.221.206]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBDYXNleSBTY2hhdWZsZXIgW21haWx0bzpjYXNleUBzY2hhdWZsZXItY2EuY29tXQ0K
PiBTZW50OiBUdWVzZGF5LCBBcHJpbCA1LCAyMDIyIDQ6NTAgUE0NCj4gT24gNC80LzIwMjIgMTA6
MjAgQU0sIFJvYmVydG8gU2Fzc3Ugd3JvdGU6DQo+ID4+IEZyb206IERqYWxhbCBIYXJvdW5pIFtt
YWlsdG86dGl4eGR6QGdtYWlsLmNvbV0NCj4gPj4gU2VudDogTW9uZGF5LCBBcHJpbCA0LCAyMDIy
IDk6NDUgQU0NCj4gPj4gT24gU3VuLCBBcHIgMywgMjAyMiBhdCA1OjQyIFBNIEtQIFNpbmdoIDxr
cHNpbmdoQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiA+Pj4gT24gU2F0LCBBcHIgMiwgMjAyMiBhdCAx
OjU1IEFNIEFsZXhlaSBTdGFyb3ZvaXRvdg0KPiA+Pj4gPGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFp
bC5jb20+IHdyb3RlOg0KPiA+PiAuLi4NCj4gPj4+Pj4gUGlubmluZw0KPiA+Pj4+PiB0aGVtIHRv
IHVucmVhY2hhYmxlIGlub2RlcyBpbnR1aXRpdmVseSBsb29rZWQgdGhlDQo+ID4+Pj4+IHdheSB0
byBnbyBmb3IgYWNoaWV2aW5nIHRoZSBzdGF0ZWQgZ29hbC4NCj4gPj4+PiBXZSBjYW4gY29uc2lk
ZXIgaW5vZGVzIGluIGJwZmZzIHRoYXQgYXJlIG5vdCB1bmxpbmthYmxlIGJ5IHJvb3QNCj4gPj4+
PiBpbiB0aGUgZnV0dXJlLCBidXQgY2VydGFpbmx5IG5vdCBmb3IgdGhpcyB1c2UgY2FzZS4NCj4g
Pj4+IENhbiB0aGlzIG5vdCBiZSBhbHJlYWR5IGRvbmUgYnkgYWRkaW5nIGEgQlBGX0xTTSBwcm9n
cmFtIHRvIHRoZQ0KPiA+Pj4gaW5vZGVfdW5saW5rIExTTSBob29rPw0KPiA+Pj4NCj4gPj4gQWxz
bywgYmVzaWRlIG9mIHRoZSBpbm9kZV91bmxpbmsuLi4gYW5kIG91dCBvZiBjdXJpb3NpdHk6IG1h
a2luZw0KPiBzeXNmcy9icGZmcy8NCj4gPj4gcmVhZG9ubHkgYWZ0ZXIgcGlubmluZywgdGhlbiB1
c2luZyBicGYgTFNNIGhvb2tzDQo+ID4+IHNiX21vdW50fHJlbW91bnR8dW5tb3VudC4uLg0KPiA+
PiBmYW1pbHkgY29tYmluaW5nIGJwZigpIExTTSBob29rLi4uIGlzbid0IHRoaXMgZW5vdWdoIHRv
Og0KPiA+PiAxLiBSZXN0cmljdCB3aG8gY2FuIHBpbiB0byBicGZmcyB3aXRob3V0IHVzaW5nIGEg
ZnVsbCBNQUMNCj4gPj4gMi4gUmVzdHJpY3Qgd2hvIGNhbiBkZWxldGUgb3IgdW5tb3VudCBicGYg
ZmlsZXN5c3RlbQ0KPiA+Pg0KPiA+PiA/DQo+ID4gSSdtIHRoaW5raW5nIHRvIGltcGxlbWVudCBz
b21ldGhpbmcgbGlrZSB0aGlzLg0KPiA+DQo+ID4gRmlyc3QsIEkgYWRkIGEgbmV3IHByb2dyYW0g
ZmxhZyBjYWxsZWQNCj4gPiBCUEZfRl9TVE9QX09OQ09ORklSTSwgd2hpY2ggY2F1c2VzIHRoZSBy
ZWYgY291bnQNCj4gPiBvZiB0aGUgbGluayB0byBpbmNyZWFzZSB0d2ljZSBhdCBjcmVhdGlvbiB0
aW1lLiBJbiB0aGlzIHdheSwNCj4gPiB1c2VyIHNwYWNlIGNhbm5vdCBtYWtlIHRoZSBsaW5rIGRp
c2FwcGVhciwgdW5sZXNzIGENCj4gPiBjb25maXJtYXRpb24gaXMgZXhwbGljaXRseSBzZW50IHZp
YSB0aGUgYnBmKCkgc3lzdGVtIGNhbGwuDQo+ID4NCj4gPiBBbm90aGVyIGFkdmFudGFnZSBpcyB0
aGF0IG90aGVyIExTTXMgY2FuIGRlY2lkZQ0KPiA+IHdoZXRoZXIgb3Igbm90IHRoZXkgYWxsb3cg
YSBwcm9ncmFtIHdpdGggdGhpcyBmbGFnDQo+ID4gKGluIHRoZSBicGYgc2VjdXJpdHkgaG9vayku
DQo+ID4NCj4gPiBUaGlzIHdvdWxkIHdvcmsgcmVnYXJkbGVzcyBvZiB0aGUgbWV0aG9kIHVzZWQg
dG8NCj4gPiBsb2FkIHRoZSBlQlBGIHByb2dyYW0gKHVzZXIgc3BhY2Ugb3Iga2VybmVsIHNwYWNl
KS4NCj4gPg0KPiA+IFNlY29uZCwgSSBleHRlbmQgdGhlIGJwZigpIHN5c3RlbSBjYWxsIHdpdGgg
YSBuZXcNCj4gPiBzdWJjb21tYW5kLCBCUEZfTElOS19DT05GSVJNX1NUT1AsIHdoaWNoDQo+ID4g
ZGVjcmVhc3JlcyB0aGUgcmVmIGNvdW50IGZvciB0aGUgbGluayBvZiB0aGUgcHJvZ3JhbXMNCj4g
PiB3aXRoIHRoZSBCUEZfRl9TVE9QX09OQ09ORklSTSBmbGFnLiBJIHdpbGwgYWxzbw0KPiA+IGlu
dHJvZHVjZSBhIG5ldyBzZWN1cml0eSBob29rIChzb21ldGhpbmcgbGlrZQ0KPiA+IHNlY3VyaXR5
X2xpbmtfY29uZmlybV9zdG9wKSwgc28gdGhhdCBhbiBMU00gaGFzIHRoZQ0KPiA+IG9wcG9ydHVu
aXR5IHRvIGRlbnkgdGhlIHN0b3AgKHRoZSBicGYgc2VjdXJpdHkgaG9vaw0KPiA+IHdvdWxkIG5v
dCBiZSBzdWZmaWNpZW50IHRvIGRldGVybWluZSBleGFjdGx5IGZvcg0KPiA+IHdoaWNoIGxpbmsg
dGhlIGNvbmZpcm1hdGlvbiBpcyBnaXZlbiwgYW4gTFNNIHNob3VsZA0KPiA+IGJlIGFibGUgdG8g
ZGVueSB0aGUgc3RvcCBmb3IgaXRzIG93biBwcm9ncmFtcykuDQo+IA0KPiBXb3VsZCB5b3UgcGxl
YXNlIHN0b3AgcmVmZXJyaW5nIHRvIGEgc2V0IG9mIGVCUEYgcHJvZ3JhbXMNCj4gbG9hZGVkIGlu
dG8gdGhlIEJQRiBMU00gYXMgYW4gTFNNPyBDYWxsIGl0IGEgQlBGIHNlY3VyaXR5DQo+IG1vZHVs
ZSAoQlNNKSBpZiB5b3UgbXVzdCB1c2UgYW4gYWJicmV2aWF0aW9uLiBBbiBMU00gaXMgYQ0KPiBw
cm92aWRlciBvZiBzZWN1cml0eV8gaG9va3MuIEluIHlvdXIgY2FzZSB0aGF0IGlzIEJQRi4gV2hl
bg0KPiB5b3UgY2FsbCB0aGUgc2V0IG9mIGVCUEYgcHJvZ3JhbXMgYW4gTFNNIGl0IGlzIGxpa2Ug
Y2FsbGluZw0KPiBhbiBTRUxpbnV4IHBvbGljeSBhbiBMU00uDQoNCkFuIGVCUEYgcHJvZ3JhbSBj
b3VsZCBiZSBhIHByb3ZpZGVyIG9mIHNlY3VyaXR5XyBob29rcw0KdG9vLiBUaGUgYnBmIExTTSBp
cyBhbiBhZ2dyZWdhdG9yLCBzaW1pbGFybHkgdG8geW91cg0KaW5mcmFzdHJ1Y3R1cmUgdG8gbWFu
YWdlIGJ1aWx0LWluIExTTXMuIE1heWJlLCBjYWxsaW5nDQppdCBzZWNvbmQtbGV2ZWwgTFNNIG9y
IHNlY29uZGFyeSBMU00gd291bGQgYmV0dGVyDQpyZXByZXNlbnQgdGhpcyBuZXcgY2xhc3MuDQoN
ClRoZSBvbmx5IGRpZmZlcmVuY2VzIGFyZSB0aGUgcmVnaXN0cmF0aW9uIG1ldGhvZCwgKFNFQw0K
ZGlyZWN0aXZlIGluc3RlYWQgb2YgREVGSU5FX0xTTSksIGFuZCB3aGF0IHRoZSBob29rDQppbXBs
ZW1lbnRhdGlvbiBjYW4gYWNjZXNzLg0KDQpUaGUgaW1wbGVtZW50YXRpb24gb2YgYSBzZWN1cml0
eV8gaG9vayB2aWEgZUJQRiBjYW4NCmZvbGxvdyB0aGUgc2FtZSBzdHJ1Y3R1cmUgb2YgYnVpbHQt
aW4gTFNNcywgaS5lLiBpdCBjYW4gYmUNCnVuaXF1ZWx5IHJlc3BvbnNpYmxlIGZvciBlbmZvcmNp
bmcgYW5kIGJlIHBvbGljeS1hZ25vc3RpYywNCmFuZCBjYW4gcmV0cmlldmUgdGhlIGRlY2lzaW9u
cyBiYXNlZCBvbiBhIHBvbGljeSBmcm9tIGENCmNvbXBvbmVudCBpbXBsZW1lbnRlZCBzb21ld2hl
cmUgZWxzZS4NCg0KSG9wZWZ1bGx5LCBJIHVuZGVyc3Rvb2QgdGhlIGJhc2ljIHByaW5jaXBsZXMg
Y29ycmVjdGx5Lg0KSSBsZXQgdGhlIGVCUEYgbWFpbnRhaW5lcnMgY29tbWVudCBvbiB0aGlzLg0K
DQpUaGFua3MNCg0KUm9iZXJ0bw0KDQpIVUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdt
YkgsIEhSQiA1NjA2Mw0KTWFuYWdpbmcgRGlyZWN0b3I6IExpIFBlbmcsIFpob25nIFJvbmdodWEN
Cg0KPiA+IFdoYXQgZG8geW91IHRoaW5rPw0KPiA+DQo+ID4gVGhhbmtzDQo+ID4NCj4gPiBSb2Jl
cnRvDQo+ID4NCj4gPiBIVUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhSQiA1
NjA2Mw0KPiA+IE1hbmFnaW5nIERpcmVjdG9yOiBMaSBQZW5nLCBaaG9uZyBSb25naHVhDQoNCg==

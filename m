Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A324F1B08
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379408AbiDDVTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379593AbiDDRnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 13:43:53 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFA931DE7;
        Mon,  4 Apr 2022 10:41:56 -0700 (PDT)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KXJ2M5Zdkz683S6;
        Tue,  5 Apr 2022 01:40:11 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 4 Apr 2022 19:41:53 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Mon, 4 Apr 2022 19:41:53 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     KP Singh <kpsingh@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "corbet@lwn.net" <corbet@lwn.net>,
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
Thread-Index: AQHYQsxoL5kXhl8+JE6PJPNWV+NOTqzYppqAgABrSsCAAo7zgIAAEt0AgARYGMA=
Date:   Mon, 4 Apr 2022 17:41:53 +0000
Message-ID: <b702f57ee63640d987055438ec77a016@huawei.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
 <20220331022727.ybj4rui4raxmsdpu@MBP-98dd607d3435.dhcp.thefacebook.com>
 <b9f5995f96da447c851f7c9db8232a9b@huawei.com>
 <20220401235537.mwziwuo4n53m5cxp@MBP-98dd607d3435.dhcp.thefacebook.com>
 <CACYkzJ5QgkucL3HZ4bY5Rcme4ey6U3FW4w2Gz-9rdWq0_RHvgA@mail.gmail.com>
In-Reply-To: <CACYkzJ5QgkucL3HZ4bY5Rcme4ey6U3FW4w2Gz-9rdWq0_RHvgA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.208.245]
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

PiBGcm9tOiBLUCBTaW5naCBbbWFpbHRvOmtwc2luZ2hAa2VybmVsLm9yZ10NCj4gU2VudDogU2F0
dXJkYXksIEFwcmlsIDIsIDIwMjIgMzowMyBBTQ0KPiBPbiBTYXQsIEFwciAyLCAyMDIyIGF0IDE6
NTUgQU0gQWxleGVpIFN0YXJvdm9pdG92DQo+IDxhbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29t
PiB3cm90ZToNCj4gPg0KPiA+IE9uIFRodSwgTWFyIDMxLCAyMDIyIGF0IDA4OjI1OjIyQU0gKzAw
MDAsIFJvYmVydG8gU2Fzc3Ugd3JvdGU6DQo+ID4gPiA+IEZyb206IEFsZXhlaSBTdGFyb3ZvaXRv
diBbbWFpbHRvOmFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb21dDQo+ID4gPiA+IFNlbnQ6IFRo
dXJzZGF5LCBNYXJjaCAzMSwgMjAyMiA0OjI3IEFNDQo+ID4gPiA+IE9uIE1vbiwgTWFyIDI4LCAy
MDIyIGF0IDA3OjUwOjE1UE0gKzAyMDAsIFJvYmVydG8gU2Fzc3Ugd3JvdGU6DQo+ID4gPiA+ID4g
ZUJQRiBhbHJlYWR5IGFsbG93cyBwcm9ncmFtcyB0byBiZSBwcmVsb2FkZWQgYW5kIGtlcHQgcnVu
bmluZw0KPiB3aXRob3V0DQo+ID4gPiA+ID4gaW50ZXJ2ZW50aW9uIGZyb20gdXNlciBzcGFjZS4g
VGhlcmUgaXMgYSBkZWRpY2F0ZWQga2VybmVsIG1vZHVsZQ0KPiBjYWxsZWQNCj4gPiA+ID4gPiBi
cGZfcHJlbG9hZCwgd2hpY2ggY29udGFpbnMgdGhlIGxpZ2h0IHNrZWxldG9uIG9mIHRoZSBpdGVy
YXRvcnNfYnBmDQo+IGVCUEYNCj4gPiA+ID4gPiBwcm9ncmFtLiBJZiB0aGlzIG1vZHVsZSBpcyBl
bmFibGVkIGluIHRoZSBrZXJuZWwgY29uZmlndXJhdGlvbiwgaXRzDQo+IGxvYWRpbmcNCj4gPiA+
ID4gPiB3aWxsIGJlIHRyaWdnZXJlZCB3aGVuIHRoZSBicGYgZmlsZXN5c3RlbSBpcyBtb3VudGVk
ICh1bmxlc3MgdGhlDQo+IG1vZHVsZSBpcw0KPiA+ID4gPiA+IGJ1aWx0LWluKSwgYW5kIHRoZSBs
aW5rcyBvZiBpdGVyYXRvcnNfYnBmIGFyZSBwaW5uZWQgaW4gdGhhdCBmaWxlc3lzdGVtDQo+ID4g
PiA+ID4gKHRoZXkgd2lsbCBhcHBlYXIgYXMgdGhlIHByb2dzLmRlYnVnIGFuZCBtYXBzLmRlYnVn
IGZpbGVzKS4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEhvd2V2ZXIsIHRoZSBjdXJyZW50IG1lY2hh
bmlzbSwgaWYgdXNlZCB0byBwcmVsb2FkIGFuIExTTSwgd291bGQNCj4gbm90DQo+ID4gPiA+IG9m
ZmVyDQo+ID4gPiA+ID4gdGhlIHNhbWUgc2VjdXJpdHkgZ3VhcmFudGVlcyBvZiBMU01zIGludGVn
cmF0ZWQgaW4gdGhlIHNlY3VyaXR5DQo+ID4gPiA+IHN1YnN5c3RlbS4NCj4gPiA+ID4gPiBBbHNv
LCBpdCBpcyBub3QgZ2VuZXJpYyBlbm91Z2ggdG8gYmUgdXNlZCBmb3IgcHJlbG9hZGluZyBhcmJp
dHJhcnkgZUJQRg0KPiA+ID4gPiA+IHByb2dyYW1zLCB1bmxlc3MgdGhlIGJwZl9wcmVsb2FkIGNv
ZGUgaXMgaGVhdmlseSBtb2RpZmllZC4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IE1vcmUgc3BlY2lm
aWNhbGx5LCB0aGUgc2VjdXJpdHkgcHJvYmxlbXMgYXJlOg0KPiA+ID4gPiA+IC0gYW55IHByb2dy
YW0gY2FuIGJlIHBpbm5lZCB0byB0aGUgYnBmIGZpbGVzeXN0ZW0gd2l0aG91dCBsaW1pdGF0aW9u
cw0KPiA+ID4gPiA+ICAgKHVubGVzcyBhIE1BQyBtZWNoYW5pc20gZW5mb3JjZXMgc29tZSByZXN0
cmljdGlvbnMpOw0KPiA+ID4gPiA+IC0gcHJvZ3JhbXMgYmVpbmcgZXhlY3V0ZWQgY2FuIGJlIHRl
cm1pbmF0ZWQgYXQgYW55IHRpbWUgYnkgZGVsZXRpbmcNCj4gdGhlDQo+ID4gPiA+ID4gICBwaW5u
ZWQgb2JqZWN0cyBvciB1bm1vdW50aW5nIHRoZSBicGYgZmlsZXN5c3RlbS4NCj4gPiA+ID4NCj4g
PiA+ID4gU28gbWFueSB0aGluZ3MgdG8gdW50YW5nbGUgaGVyZS4NCj4gPiA+DQo+ID4gPiBIaSBB
bGV4ZWkNCj4gPiA+DQo+ID4gPiB0aGFua3MgZm9yIHRha2luZyB0aGUgdGltZSB0byBwcm92aWRl
IHN1Y2ggZGV0YWlsZWQNCj4gPiA+IGV4cGxhbmF0aW9uLg0KPiA+ID4NCj4gPiA+ID4gVGhlIGFi
b3ZlIHBhcmFncmFwaHMgYXJlIG1pc2xlYWRpbmcgYW5kIGluY29ycmVjdC4NCj4gPiA+ID4gVGhl
IGNvbW1pdCBsb2cgc291bmRzIGxpa2UgdGhlcmUgYXJlIHNlY3VyaXR5IGlzc3VlcyB0aGF0IHRo
aXMNCj4gPiA+ID4gcGF0Y2ggc2V0IGlzIGZpeGluZy4NCj4gPiA+ID4gVGhpcyBpcyBub3QgdHJ1
ZS4NCj4gDQo+ICsxIHRoZXNlIGFyZSBub3Qgc2VjdXJpdHkgaXNzdWVzLiBUaGV5IGFyZSBsaW1p
dGF0aW9ucyBvZiB5b3VyIE1BQyBwb2xpY3kuDQo+IA0KPiA+ID4NCj4gPiA+IEkgcmVpdGVyYXRl
IHRoZSBnb2FsOiBlbmZvcmNlIGEgbWFuZGF0b3J5IHBvbGljeSB3aXRoDQo+ID4gPiBhbiBvdXQt
b2YtdHJlZSBMU00gKGEga2VybmVsIG1vZHVsZSBpcyBmaW5lKSwgd2l0aCB0aGUNCj4gPiA+IHNh
bWUgZ3VhcmFudGVlcyBvZiBMU01zIGludGVncmF0ZWQgaW4gdGhlIHNlY3VyaXR5DQo+ID4gPiBz
dWJzeXN0ZW0uDQo+ID4NCj4gPiBUbyBtYWtlIGl0IDEwMCUgY2xlYXI6DQo+ID4gQW55IGluLWtl
cm5lbCBmZWF0dXJlIHRoYXQgYmVuZWZpdHMgb3V0LW9mLXRyZWUgbW9kdWxlIHdpbGwgYmUgcmVq
ZWN0ZWQuDQo+ID4NCj4gPiA+IFRoZSByb290IHVzZXIgaXMgbm90IHBhcnQgb2YgdGhlIFRDQiAo
aS5lLiBpcyB1bnRydXN0ZWQpLA0KPiA+ID4gYWxsIHRoZSBjaGFuZ2VzIHRoYXQgdXNlciB3YW50
cyB0byBtYWtlIG11c3QgYmUgc3ViamVjdA0KPiA+ID4gb2YgZGVjaXNpb24gYnkgdGhlIExTTSBl
bmZvcmNpbmcgdGhlIG1hbmRhdG9yeSBwb2xpY3kuDQo+ID4gPg0KPiA+ID4gSSB0aG91Z2h0IGFi
b3V0IGFkZGluZyBzdXBwb3J0IGZvciBMU01zIGZyb20ga2VybmVsDQo+ID4gPiBtb2R1bGVzIHZp
YSBhIG5ldyBidWlsdC1pbiBMU00gKGNhbGxlZCBMb2FkTFNNKSwgYnV0DQo+IA0KPiBLZXJuZWwg
bW9kdWxlcyBjYW5ub3QgaW1wbGVtZW50IExTTXMsIHRoaXMgaGFzIGFscmVhZHkgYmVlbg0KPiBw
cm9wb3NlZCBvbiB0aGUgbGlzdHMgYW5kIGhhcyBiZWVuIHJlamVjdGVkLg0KDQpMb29raW5nIGF0
IGNvbW1pdCBjYjgwZGRjNjcxNTIgKCJicGY6IENvbnZlcnQgYnBmX3ByZWxvYWQua28NCnRvIHVz
ZSBsaWdodCBza2VsZXRvbi4iKSwgSSBnb3QgdGhhdCBpdCBpcyB0aGUgbW9zdCBlZmZpY2llbnQg
d2F5DQp0byBsb2FkIGFuIGVCUEYgcHJvZ3JhbSAoZG9lcyBub3QgZXZlbiByZXF1aXJlIGxpYmJw
ZikuDQoNCkFub3RoZXIgYWR2YW50YWdlIHdhcyB0aGF0IHdlIGdldCBpbnRlZ3JpdHkgdmVyaWZp
Y2F0aW9uDQpmcm9tIHRoZSBtb2R1bGUgaW5mcmFzdHJ1Y3R1cmUuIFRoaXMgd291bGQgaGF2ZSBi
ZWVuIHRoZQ0Kb3B0aW1hbCBzb2x1dGlvbiBpbiB0ZXJtcyBvZiBkZXBlbmRlbmNpZXMuIEVuZm9y
Y2luZw0KaW50ZWdyaXR5IGNvdWxkIGJlIHR1cm5lZCBvbiB3aXRoIHRoZSBtb2R1bGUuc2lnX2Vu
Zm9yY2UNCmtlcm5lbCBvcHRpb24uDQoNCklmIHdlIHN3aXRjaCB0byB1c2VyIHNwYWNlLCB0aGUg
Y2hvaWNlIHdvdWxkIGJlIElNQS4NCkhvd2V2ZXIsIGluIG15IHVzZSBjYXNlIChESUdMSU0pIGl0
IHdvdWxkIGJlIHVzZWQganVzdA0KZm9yIHRoZSBwdXJwb3NlIG9mIGRvaW5nIGludGVncml0eSB2
ZXJpZmljYXRpb25zIHByZS1pbml0Lg0KDQpUaGlua2luZyB3aGljaCBwb2xpY3kgY291bGQgYmUg
aW1wbGVtZW50ZWQgZm9yIHN1Y2ggcHVycG9zZSwNCm1heWJlIHNvbWV0aGluZyBsaWtlIGFwcHJh
aXNlIGV2ZXJ5IHByb2Nlc3MgdGhhdCBpcyBub3QgbGlua2VkDQp0byBhbiBleGVjdXRhYmxlPyBB
bmQgc2luY2UgdGhlcmUgYXJlIG5vIHhhdHRycyBpbiB0aGUgaW5pdGlhbA0KcmFtIGRpc2ssIGNv
dWxkIEkgYXBwZW5kIGEgbW9kdWxlIHNpZ25hdHVyZSB0byBhbiBFTEYgYmluYXJ5Pw0KDQpUaGFu
a3MNCg0KUm9iZXJ0bw0KDQpIVUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhS
QiA1NjA2Mw0KTWFuYWdpbmcgRGlyZWN0b3I6IExpIFBlbmcsIFpob25nIFJvbmdodWENCg0KPiA+
IFN1Y2ggYXBwcm9hY2ggd2lsbCBiZSByZWplY3RlZC4gU2VlIGFib3ZlLg0KPiA+DQo+ID4gPiA+
IEkgc3VzcGVjdCB0aGVyZSBpcyBodWdlIGNvbmZ1c2lvbiBvbiB3aGF0IHRoZXNlIHR3byAicHJv
Z3MuZGVidWciDQo+ID4gPiA+IGFuZCAibWFwcy5kZWJ1ZyIgZmlsZXMgYXJlIGluIGEgYnBmZnMg
aW5zdGFuY2UuDQo+ID4gPiA+IFRoZXkgYXJlIGRlYnVnIGZpbGVzIHRvIHByZXR0eSBwcmluZyBs
b2FkZWQgbWFwcyBhbmQgcHJvZ3MgZm9yIGZvbGtzDQo+IHdobw0KPiA+ID4gPiBsaWtlIHRvIHVz
ZSAnY2F0JyB0byBleGFtaW5lIHRoZSBzdGF0ZSBvZiB0aGUgc3lzdGVtIGluc3RlYWQgb2YgJ2Jw
ZnRvb2wnLg0KPiA+ID4gPiBUaGUgcm9vdCBjYW4gcmVtb3ZlIHRoZXNlIGZpbGVzIGZyb20gYnBm
ZnMuDQo+ID4gPiA+DQo+ID4gPiA+IFRoZXJlIGlzIG5vIHJlYXNvbiBmb3Iga2VybmVsIG1vZHVs
ZSB0byBwaW4gaXRzIGJwZiBwcm9ncy4NCj4gPiA+ID4gSWYgeW91IHdhbnQgdG8gZGV2ZWxvcCBE
SUdMSU0gYXMgYSBrZXJuZWwgbW9kdWxlIHRoYXQgdXNlcyBsaWdodA0KPiBza2VsZXRvbg0KPiA+
ID4gPiBqdXN0IGRvOg0KPiA+ID4gPiAjaW5jbHVkZSA8bGludXgvaW5pdC5oPg0KPiA+ID4gPiAj
aW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQo+ID4gPiA+ICNpbmNsdWRlICJkaWdsaW0ubHNrZWwu
aCINCj4gPiA+ID4NCj4gPiA+ID4gc3RhdGljIHN0cnVjdCBkaWdsaW1fYnBmICpza2VsOw0KPiA+
ID4gPg0KPiA+ID4gPiBzdGF0aWMgaW50IF9faW5pdCBsb2FkKHZvaWQpDQo+ID4gPiA+IHsNCj4g
PiA+ID4gICAgICAgICBza2VsID0gZGlnbGltX2JwZl9fb3Blbl9hbmRfbG9hZCgpOw0KPiA+ID4g
PiAgICAgICAgIGVyciA9IGRpZ2xpbV9icGZfX2F0dGFjaChza2VsKTsNCj4gPiA+ID4gfQ0KPiA+
ID4gPiAvKiBkZXRhY2ggc2tlbCBpbiBfX2ZpbmkgKi8NCj4gPiA+ID4NCj4gPiA+ID4gSXQncyBy
ZWFsbHkgdGhhdCBzaG9ydC4NCj4gPiA+ID4NCj4gPiA+ID4gVGhlbiB5b3Ugd2lsbCBiZSBhYmxl
IHRvDQo+ID4gPiA+IC0gaW5zbW9kIGRpZ2xpbS5rbyAtPiB3aWxsIGxvYWQgYW5kIGF0dGFjaCBi
cGYgcHJvZ3MuDQo+ID4gPiA+IC0gcm1tb2QgZGlnbGltIC0+IHdpbGwgZGV0YWNoIHRoZW0uDQo+
ID4gPg0KPiA+ID4gcm9vdCBjYW4gc3RvcCB0aGUgTFNNIHdpdGhvdXQgY29uc3VsdGluZyB0aGUg
c2VjdXJpdHkNCj4gPiA+IHBvbGljeS4gVGhlIGdvYWwgb2YgaGF2aW5nIHJvb3QgdW50cnVzdGVk
IGlzIG5vdCBhY2hpZXZlZC4NCj4gDQo+IE9mY291cnNlLCB0aGlzIGlzIGFuIGlzc3VlLCBpZiB5
b3UgYXJlIHVzaW5nIEJQRiB0byBkZWZpbmUgYSBNQUMNCj4gcG9saWN5LCB0aGUgcG9saWN5DQo+
IG5lZWRzIHRvIGJlIGNvbXByZWhlbnNpdmUgdG8gcHJldmVudCBpdHNlbGYgZnJvbSBiZWluZyBv
dmVycmlkZGVuLiBUaGlzIGlzDQo+IHdoeQ0KPiBXZSBoYXZlIHNvIG1hbnkgTFNNIGhvb2tzLiBJ
ZiB5b3UgdGhpbmsgc29tZSBhcmUgbWlzc2luZywgbGV0J3MgYWRkIHRoZW0uDQo+IA0KPiBUaGlz
IGlzIHdoeSBpbXBsZW1lbnRpbmcgYSBwb2xpY3kgaXMgbm90IHRyaXZpYWwsIGJ1dCB3ZSBuZWVk
IHRvIGFsbG93DQo+IHVzZXJzIHRvIGJ1aWxkDQo+IHN1Y2ggcG9saWNpZXMgd2l0aCB0aGUgaGVs
cCBmcm9tIHRoZSBrZXJuZWwgYW5kIG5vdCBieSB1c2luZw0KPiBvdXQtb2YtdHJlZSBtb2R1bGVz
Lg0KPiANCj4gSSBkbyB0aGluayB3ZSBjYW4gYWRkIHNvbWUgbW9yZSBoZWxwZXJzIChlLmcuIGZv
ciBtb2RpZnlpbmcgeGF0dHJzDQo+IGZyb20gQlBGKSB0aGF0DQo+IHdvdWxkIGhlbHAgdXMgYnVp
bGQgY29tcGxleCBwb2xpY2llcy4NCj4gDQo+ID4NCj4gPiBPdXQtb2YtdHJlZSBtb2R1bGUgY2Fu
IGRvIGFueSBoYWNrLg0KPiA+IEZvciBleGFtcGxlOg0KPiA+IDEuIGRvbid0IGRvIGRldGFjaCBz
a2VsIGluIF9fZmluaQ0KPiA+ICAgcm1tb2Qgd2lsbCByZW1vdmUgdGhlIG1vZHVsZSwgYnV0IGJw
ZiBwcm9ncyB3aWxsIGtlZXAgcnVubmluZy4NCj4gPiAyLiBkbyBtb2R1bGVfZ2V0KFRISVNfTU9E
VUxFKSBpbiBfX2luaXQNCj4gPiAgIHJtbW9kIHdpbGwgcmV0dXJuIEVCVVNZDQo+ID4gICBhbmQg
aGF2ZSBzb21lIG91dC1vZi1iYW5kIHdheSBvZiBkcm9wcGluZyBtb2QgcmVmY250Lg0KPiA+IDMu
IGhhY2sgaW50byBzeXNfZGVsZXRlX21vZHVsZS4gaWYgbW9kdWxlX25hbWU9PWRpZ2xlbSByZXR1
cm4gRUJVU1kuDQo+ID4gNC4gYWRkIHByb3BlciBMU00gaG9vayB0byBkZWxldGVfbW9kdWxlDQo+
IA0KPiArMSBJIHJlY29tbWVuZCB0aGlzIChidXQgbm90IGZyb20gYW4gb3V0IG9mIHRyZWUgbW9k
dWxlKQ0KPiANCj4gPg0KPiA+ID4gTXkgcG9pbnQgd2FzIHRoYXQgcGlubmluZyBwcm9ncyBzZWVt
cyB0byBiZSB0aGUNCj4gPiA+IHJlY29tbWVuZGVkIHdheSBvZiBrZWVwaW5nIHRoZW0gcnVubmlu
Zy4NCj4gPg0KPiA+IE5vdCBxdWl0ZS4gYnBmX2xpbmsgcmVmY250IGlzIHdoYXQga2VlcHMgcHJv
Z3MgYXR0YWNoZWQuDQo+ID4gYnBmZnMgaXMgbWFpbmx5IHVzZWQgZm9yOg0KPiA+IC0gdG8gcGFz
cyBtYXBzL2xpbmtzIGZyb20gb25lIHByb2Nlc3MgdG8gYW5vdGhlcg0KPiA+IHdoZW4gcGFzc2lu
ZyBmZCBpcyBub3QgcG9zc2libGUuDQo+ID4gLSB0byBzb2x2ZSB0aGUgY2FzZSBvZiBjcmFzaGlu
ZyB1c2VyIHNwYWNlLg0KPiA+IFRoZSB1c2VyIHNwYWNlIGFnZW50IHdpbGwgcmVzdGFydCBhbmQg
d2lsbCBwaWNrIHVwIHdoZXJlDQo+ID4gaXQncyBsZWZ0IGJ5IHJlYWRpbmcgbWFwLCBsaW5rLCBw
cm9nIEZEcyBmcm9tIGJwZmZzLg0KPiA+IC0gcGlubmluZyBicGYgaXRlcmF0b3JzIHRoYXQgYXJl
IGxhdGVyIHVzZWQgdG8gJ2NhdCcgc3VjaCBmaWxlcy4NCj4gPiBUaGF0IGlzIHdoYXQgYnBmX3By
ZWxvYWQgaXMgZG9pbmcgYnkgY3JlYXRpbmcgdHdvIGRlYnVnDQo+ID4gZmlsZXMgIm1hcHMuZGVi
dWciIGFuZCAicHJvZ3MuZGVidWciLg0KPiA+DQo+ID4gPiBQaW5uaW5nDQo+ID4gPiB0aGVtIHRv
IHVucmVhY2hhYmxlIGlub2RlcyBpbnR1aXRpdmVseSBsb29rZWQgdGhlDQo+ID4gPiB3YXkgdG8g
Z28gZm9yIGFjaGlldmluZyB0aGUgc3RhdGVkIGdvYWwuDQo+ID4NCj4gPiBXZSBjYW4gY29uc2lk
ZXIgaW5vZGVzIGluIGJwZmZzIHRoYXQgYXJlIG5vdCB1bmxpbmthYmxlIGJ5IHJvb3QNCj4gPiBp
biB0aGUgZnV0dXJlLCBidXQgY2VydGFpbmx5IG5vdCBmb3IgdGhpcyB1c2UgY2FzZS4NCj4gDQo+
IENhbiB0aGlzIG5vdCBiZSBhbHJlYWR5IGRvbmUgYnkgYWRkaW5nIGEgQlBGX0xTTSBwcm9ncmFt
IHRvIHRoZQ0KPiBpbm9kZV91bmxpbmsgTFNNIGhvb2s/DQo+IA0KPiA+DQo+ID4gPiBPciBtYXli
ZSBJDQo+ID4gPiBzaG91bGQganVzdCBpbmNyZW1lbnQgdGhlIHJlZmVyZW5jZSBjb3VudCBvZiBs
aW5rcw0KPiA+ID4gYW5kIGRvbid0IGRlY3JlbWVudCBkdXJpbmcgYW4gcm1tb2Q/DQo+ID4NCj4g
PiBJIHN1Z2dlc3QgdG8gYWJhbmRvbiBvdXQtb2YtdHJlZSBnb2FsLg0KPiA+IE9ubHkgdGhlbiB3
ZSBjYW4gaGVscCBhbmQgY29udGludWUgdGhpcyBkaXNjdXNzaW9uLg0KPiANCj4gKzENCg==

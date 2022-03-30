Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615604EBBA9
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 09:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243797AbiC3HXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 03:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243820AbiC3HXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 03:23:22 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889351117E;
        Wed, 30 Mar 2022 00:21:06 -0700 (PDT)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KSyV73jh2z67ZHP;
        Wed, 30 Mar 2022 15:19:11 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 30 Mar 2022 09:21:03 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Wed, 30 Mar 2022 09:21:03 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, "Shuah Khan" <shuah@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Linux Doc Mailing List" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF
 programs
Thread-Topic: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF
 programs
Thread-Index: AQHYQsxoL5kXhl8+JE6PJPNWV+NOTqzW6KkAgACTnqA=
Date:   Wed, 30 Mar 2022 07:21:03 +0000
Message-ID: <7574e95fb2304db7b8d64be5d2553b20@huawei.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
 <CAEf4BzZNs-DYzQcE5LPxNzXDa+9A7QFszw99fnd2=cq9SuWsLg@mail.gmail.com>
In-Reply-To: <CAEf4BzZNs-DYzQcE5LPxNzXDa+9A7QFszw99fnd2=cq9SuWsLg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.209.190]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBBbmRyaWkgTmFrcnlpa28gW21haWx0bzphbmRyaWkubmFrcnlpa29AZ21haWwuY29t
XQ0KPiBTZW50OiBXZWRuZXNkYXksIE1hcmNoIDMwLCAyMDIyIDE6NTEgQU0NCj4gT24gTW9uLCBN
YXIgMjgsIDIwMjIgYXQgMTA6NTEgQU0gUm9iZXJ0byBTYXNzdQ0KPiA8cm9iZXJ0by5zYXNzdUBo
dWF3ZWkuY29tPiB3cm90ZToNCg0KWy4uLl0NCg0KPiA+IFBhdGNoZXMgMS0yIGV4cG9ydCBzb21l
IGRlZmluaXRpb25zLCB0byBidWlsZCBvdXQtb2YtdHJlZSBrZXJuZWwgbW9kdWxlcw0KPiA+IHdp
dGggZUJQRiBwcm9ncmFtcyB0byBwcmVsb2FkLiBQYXRjaGVzIDMtNCBhbGxvdyBlQlBGIHByb2dy
YW1zIHRvIHBpbg0KPiA+IG9iamVjdHMgYnkgdGhlbXNlbHZlcy4gUGF0Y2hlcyA1LTEwIGF1dG9t
YXRpY2FsbHkgZ2VuZXJhdGUgdGhlIG1ldGhvZHMNCj4gZm9yDQo+ID4gcHJlbG9hZGluZyBpbiB0
aGUgbGlnaHQgc2tlbGV0b24uIFBhdGNoZXMgMTEtMTQgbWFrZSBpdCBwb3NzaWJsZSB0byBwcmVs
b2FkDQo+ID4gbXVsdGlwbGUgZUJQRiBwcm9ncmFtcy4gUGF0Y2ggMTUgYXV0b21hdGljYWxseSBn
ZW5lcmF0ZXMgdGhlIGtlcm5lbA0KPiBtb2R1bGUNCj4gPiBmb3IgcHJlbG9hZGluZyBhbiBlQlBG
IHByb2dyYW0sIHBhdGNoIDE2IGRvZXMgYSBrZXJuZWwgbW91bnQgb2YgdGhlIGJwZg0KPiA+IGZp
bGVzeXN0ZW0sIGFuZCBmaW5hbGx5IHBhdGNoZXMgMTctMTggdGVzdCB0aGUgZnVuY3Rpb25hbGl0
eSBpbnRyb2R1Y2VkLg0KPiA+DQo+IA0KPiBUaGlzIGFwcHJvYWNoIG9mIG1vdmluZyB0b25zIG9m
IHByZXR0eSBnZW5lcmljIGNvZGUgaW50byBjb2RlZ2VuIG9mDQo+IGxza2VsIHNlZW1zIHN1Ym9w
dGltYWwuIFdoeSBzbyBtdWNoIGNvZGUgaGFzIHRvIGJlIGNvZGVnZW5lcmF0ZWQ/DQo+IEVzcGVj
aWFsbHkgdGhhdCB0aW55IG1vZHVsZSBjb2RlPw0KDQpIaSBBbmRyaWkNCg0KdGhlIG1haW4gZ29h
bCBvZiB0aGlzIHBhdGNoIHNldCBpcyB0byB1c2UgdGhlIHByZWxvYWRpbmcNCm1lY2hhbmlzbSB0
byBwbHVnIGluIHNlY3VyZWx5IExTTXMgaW1wbGVtZW50ZWQgYXMgZUJQRg0KcHJvZ3JhbXMuDQoN
CkkgaGF2ZSBhIHVzZSBjYXNlLCBJIHdhbnQgdG8gcGx1ZyBpbiBteSBlQlBGIHByb2dyYW0sDQpE
SUdMSU0gZUJQRi4NCg0KSSBzdGFydGVkIHRvIG1vZGlmeSB0aGUgcHJlbG9hZGluZyBjb2RlIG1h
bnVhbGx5LCBhbmQNCkkgcmVhbGl6ZWQgaG93IGNvbXBsaWNhdGVkIHRoZSBwcm9jZXNzIGlzIGlm
IHlvdSB3YW50DQp0byBhZGQgc29tZXRoaW5nIG1vcmUgdGhhbiB0aGUgZXhpc3RpbmcgaXRlcmF0
b3JzX2JwZg0KcHJvZ3JhbS4NCg0KRmlyc3QsIHlvdSBoYXZlIHRvIGxvb2sgYXQgd2hpY2ggb2Jq
ZWN0cyB5b3Ugd2FudCB0bw0KcHJlbG9hZCwgdGhlbiB3cml0ZSBjb2RlIGZvciBlYWNoIG9mIHRo
ZW0uIFRoaXMgcHJvY2Vzcw0KaXMgcmVwZXRpdGl2ZSBhbmQgZGV0ZXJtaW5pc3RpYywgdGhpcyBp
cyB3aHkgSSBpbW1lZGlhdGVseQ0KdGhvdWdodCB0aGF0IGl0IGlzIGEgZ29vZCBjYXNlIGZvciBh
dXRvbWF0aWMgY29kZQ0KZ2VuZXJhdGlvbi4NCg0KTXkgaWRlYSBpcyB0aGF0LCBpZiB0aGlzIG1l
Y2hhbmlzbSBpcyBhY2NlcHRlZCwgYW4NCmltcGxlbWVudGVyIG9mIGFuIExTTSB3aXNoaW5nIHRv
IGJlIHByZWxvYWRlZCBhdA0KdGhlIHZlcnkgYmVnaW5uaW5nLCBvbmx5IGhhcyB0byB3cml0ZSBo
aXMgZUJQRiBjb2RlLA0KdGhlIGtlcm5lbCBhbmQgYnBmdG9vbCB0YWtlIGNhcmUgb2YgdGhlIHJl
c3QuDQpHZW5lcmF0aW9uIG9mIHRoZSBwcmVsb2FkaW5nIGNvZGUgaXMgb3B0aW9uYWwsIGFuZA0K
bmVlZCB0byBiZSBlbmFibGVkIHdpdGggdGhlIC1QIG9wdGlvbiwgaW4gYWRkaXRpb24gdG8gLUwu
DQoNClRoZSBsaWdodCBza2VsZXRvbiBvZiBESUdMSU0gZUJQRiBsb29rcyBsaWtlOg0KDQpodHRw
czovL2dpdGh1Yi5jb20vcm9iZXJ0b3Nhc3N1L2xpbnV4L2Jsb2IvYnBmLXByZWxvYWQtdjEva2Vy
bmVsL2JwZi9wcmVsb2FkL2RpZ2xpbS9kaWdsaW0ubHNrZWwuaA0KDQpUaGUgcHJlbG9hZGluZyBp
bnRlcmZhY2UgaXMgdmVyeSBzaW1pbGFyIHRvIHRoZSBvbmUgdXNlZA0KYnkgdGhlIHNlY3VyaXR5
IHN1YnN5c3RlbTogYW4gb3JkZXJlZCBsaXN0IG9mIGVCUEYNCnByb2dyYW1zIHRvIHByZWxvYWQg
c2V0IGluIHRoZSBrZXJuZWwgY29uZmlndXJhdGlvbiwNCnRoYXQgY2FuIGJlIG92ZXJ3cml0dGVu
IHdpdGggdGhlIGtlcm5lbCBvcHRpb24NCmJwZl9wcmVsb2FkX2xpc3Q9Lg0KDQpUaGUgY2hhbmdl
cyB0aGF0IHdvdWxkIGJlIHJlcXVpcmVkIHRvIHByZWxvYWQgRElHTElNDQplQlBGIGxvb2sgbGlr
ZToNCg0KaHR0cHM6Ly9naXRodWIuY29tL3JvYmVydG9zYXNzdS9saW51eC9jb21taXQvYzA3ZTFh
Nzg1ODRlZTY4OGFlYjgxMmYwN2RjN2FiMzA2MGFjNjE1Mg0KDQpUaGFua3MNCg0KUm9iZXJ0bw0K
DQpIVUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhSQiA1NjA2Mw0KTWFuYWdp
bmcgRGlyZWN0b3I6IExpIFBlbmcsIFpob25nIFJvbmdodWENCiANCj4gQ2FuIHlvdSBwbGVhc2Ug
ZWxhYm9yYXRlIG9uIHdoeSBpdCBjYW4ndCBiZSBkb25lIGluIGEgd2F5IHRoYXQgZG9lc24ndA0K
PiByZXF1aXJlIHN1Y2ggZXh0ZW5zaXZlIGxpZ2h0IHNrZWxldG9uIGNvZGVnZW4gY2hhbmdlcz8N
Cj4gDQo+IA0KPiA+IFJvYmVydG8gU2Fzc3UgKDE4KToNCj4gPiAgIGJwZjogRXhwb3J0IGJwZl9s
aW5rX2luYygpDQo+ID4gICBicGYtcHJlbG9hZDogTW92ZSBicGZfcHJlbG9hZC5oIHRvIGluY2x1
ZGUvbGludXgNCj4gPiAgIGJwZi1wcmVsb2FkOiBHZW5lcmFsaXplIG9iamVjdCBwaW5uaW5nIGZy
b20gdGhlIGtlcm5lbA0KPiA+ICAgYnBmLXByZWxvYWQ6IEV4cG9ydCBhbmQgY2FsbCBicGZfb2Jq
X2RvX3Bpbl9rZXJuZWwoKQ0KPiA+ICAgYnBmLXByZWxvYWQ6IEdlbmVyYXRlIHN0YXRpYyB2YXJp
YWJsZXMNCj4gPiAgIGJwZi1wcmVsb2FkOiBHZW5lcmF0ZSBmcmVlX29ianNfYW5kX3NrZWwoKQ0K
PiA+ICAgYnBmLXByZWxvYWQ6IEdlbmVyYXRlIHByZWxvYWQoKQ0KPiA+ICAgYnBmLXByZWxvYWQ6
IEdlbmVyYXRlIGxvYWRfc2tlbCgpDQo+ID4gICBicGYtcHJlbG9hZDogR2VuZXJhdGUgY29kZSB0
byBwaW4gbm9uLWludGVybmFsIG1hcHMNCj4gPiAgIGJwZi1wcmVsb2FkOiBHZW5lcmF0ZSBicGZf
cHJlbG9hZF9vcHMNCj4gPiAgIGJwZi1wcmVsb2FkOiBTdG9yZSBtdWx0aXBsZSBicGZfcHJlbG9h
ZF9vcHMgc3RydWN0dXJlcyBpbiBhIGxpbmtlZA0KPiA+ICAgICBsaXN0DQo+ID4gICBicGYtcHJl
bG9hZDogSW1wbGVtZW50IG5ldyByZWdpc3RyYXRpb24gbWV0aG9kIGZvciBwcmVsb2FkaW5nIGVC
UEYNCj4gPiAgICAgcHJvZ3JhbXMNCj4gPiAgIGJwZi1wcmVsb2FkOiBNb3ZlIHBpbm5lZCBsaW5r
cyBhbmQgbWFwcyB0byBhIGRlZGljYXRlZCBkaXJlY3RvcnkgaW4NCj4gPiAgICAgYnBmZnMNCj4g
PiAgIGJwZi1wcmVsb2FkOiBTd2l0Y2ggdG8gbmV3IHByZWxvYWQgcmVnaXN0cmF0aW9uIG1ldGhv
ZA0KPiA+ICAgYnBmLXByZWxvYWQ6IEdlbmVyYXRlIGNvZGUgb2Yga2VybmVsIG1vZHVsZSB0byBw
cmVsb2FkDQo+ID4gICBicGYtcHJlbG9hZDogRG8ga2VybmVsIG1vdW50IHRvIGVuc3VyZSB0aGF0
IHBpbm5lZCBvYmplY3RzIGRvbid0DQo+ID4gICAgIGRpc2FwcGVhcg0KPiA+ICAgYnBmLXByZWxv
YWQvc2VsZnRlc3RzOiBBZGQgdGVzdCBmb3IgYXV0b21hdGljIGdlbmVyYXRpb24gb2YgcHJlbG9h
ZA0KPiA+ICAgICBtZXRob2RzDQo+ID4gICBicGYtcHJlbG9hZC9zZWxmdGVzdHM6IFByZWxvYWQg
YSB0ZXN0IGVCUEYgcHJvZ3JhbSBhbmQgY2hlY2sgcGlubmVkDQo+ID4gICAgIG9iamVjdHMNCj4g
DQo+IHBsZWFzZSB1c2UgcHJvcGVyIHByZWZpeGVzOiBicGYgKGZvciBrZXJuZWwtc2lkZSBjaGFu
Z2VzKSwgbGliYnBmLA0KPiBicGZ0b29sLCBzZWxmdGVzdHMvYnBmLCBldGMNCj4gDQo+IA0KPiA+
DQo+ID4gIC4uLi9hZG1pbi1ndWlkZS9rZXJuZWwtcGFyYW1ldGVycy50eHQgICAgICAgICB8ICAg
OCArDQo+ID4gIGZzL25hbWVzcGFjZS5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
ICAgMSArDQo+ID4gIGluY2x1ZGUvbGludXgvYnBmLmggICAgICAgICAgICAgICAgICAgICAgICAg
ICB8ICAgNSArDQo+ID4gIGluY2x1ZGUvbGludXgvYnBmX3ByZWxvYWQuaCAgICAgICAgICAgICAg
ICAgICB8ICAzNyArKw0KPiA+ICBpbml0L21haW4uYyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgIDIgKw0KPiA+ICBrZXJuZWwvYnBmL2lub2RlLmMgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAyOTUgKysrKysrKysrLS0NCj4gPiAga2VybmVsL2JwZi9wcmVsb2FkL0tj
b25maWcgICAgICAgICAgICAgICAgICAgIHwgIDI1ICstDQo+ID4gIGtlcm5lbC9icGYvcHJlbG9h
ZC9icGZfcHJlbG9hZC5oICAgICAgICAgICAgICB8ICAxNiAtDQo+ID4gIGtlcm5lbC9icGYvcHJl
bG9hZC9icGZfcHJlbG9hZF9rZXJuLmMgICAgICAgICB8ICA4NSArLS0tDQo+ID4gIGtlcm5lbC9i
cGYvcHJlbG9hZC9pdGVyYXRvcnMvTWFrZWZpbGUgICAgICAgICB8ICAgOSArLQ0KPiA+ICAuLi4v
YnBmL3ByZWxvYWQvaXRlcmF0b3JzL2l0ZXJhdG9ycy5sc2tlbC5oICAgfCA0NjYgKysrKysrKysr
KystLS0tLS0tDQo+ID4gIGtlcm5lbC9icGYvc3lzY2FsbC5jICAgICAgICAgICAgICAgICAgICAg
ICAgICB8ICAgMSArDQo+ID4gIC4uLi9icGYvYnBmdG9vbC9Eb2N1bWVudGF0aW9uL2JwZnRvb2wt
Z2VuLnJzdCB8ICAxMyArDQo+ID4gIHRvb2xzL2JwZi9icGZ0b29sL2Jhc2gtY29tcGxldGlvbi9i
cGZ0b29sICAgICB8ICAgNiArLQ0KPiA+ICB0b29scy9icGYvYnBmdG9vbC9nZW4uYyAgICAgICAg
ICAgICAgICAgICAgICAgfCAzMzEgKysrKysrKysrKysrKw0KPiA+ICB0b29scy9icGYvYnBmdG9v
bC9tYWluLmMgICAgICAgICAgICAgICAgICAgICAgfCAgIDcgKy0NCj4gPiAgdG9vbHMvYnBmL2Jw
ZnRvb2wvbWFpbi5oICAgICAgICAgICAgICAgICAgICAgIHwgICAxICsNCj4gPiAgdG9vbHMvdGVz
dGluZy9zZWxmdGVzdHMvYnBmL01ha2VmaWxlICAgICAgICAgIHwgIDMyICstDQo+ID4gIC4uLi9i
cGYvYnBmX3Rlc3Rtb2RfcHJlbG9hZC8uZ2l0aWdub3JlICAgICAgICB8ICAgNyArDQo+ID4gIC4u
Li9icGYvYnBmX3Rlc3Rtb2RfcHJlbG9hZC9NYWtlZmlsZSAgICAgICAgICB8ICAyMCArDQo+ID4g
IC4uLi9nZW5fcHJlbG9hZF9tZXRob2RzLmV4cGVjdGVkLmRpZmYgICAgICAgICB8ICA5NyArKysr
DQo+ID4gIC4uLi9icGYvcHJvZ190ZXN0cy90ZXN0X2dlbl9wcmVsb2FkX21ldGhvZHMuYyB8ICAy
NyArDQo+ID4gIC4uLi9icGYvcHJvZ190ZXN0cy90ZXN0X3ByZWxvYWRfbWV0aG9kcy5jICAgICB8
ICA2OSArKysNCj4gPiAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvZ2VuX3ByZWxvYWRfbWV0aG9k
cy5jIHwgIDIzICsNCj4gPiAgMjQgZmlsZXMgY2hhbmdlZCwgMTI0NiBpbnNlcnRpb25zKCspLCAz
MzcgZGVsZXRpb25zKC0pDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL2xpbnV4L2Jw
Zl9wcmVsb2FkLmgNCj4gPiAgZGVsZXRlIG1vZGUgMTAwNjQ0IGtlcm5lbC9icGYvcHJlbG9hZC9i
cGZfcHJlbG9hZC5oDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NA0KPiB0b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9icGYvYnBmX3Rlc3Rtb2RfcHJlbG9hZC8uZ2l0aWdub3JlDQo+ID4gIGNyZWF0ZSBt
b2RlIDEwMDY0NA0KPiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvYnBmX3Rlc3Rtb2RfcHJl
bG9hZC9NYWtlZmlsZQ0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4gdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvZ2VuX3ByZWxvYWRfbWV0aG9kcy5leHBlY3RlZC5kaWZm
DQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NA0KPiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYv
cHJvZ190ZXN0cy90ZXN0X2dlbl9wcmVsb2FkX21ldGhvZHMuYw0KPiA+ICBjcmVhdGUgbW9kZSAx
MDA2NDQNCj4gdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvdGVzdF9wcmVs
b2FkX21ldGhvZHMuYw0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4gdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvYnBmL3Byb2dzL2dlbl9wcmVsb2FkX21ldGhvZHMuYw0KPiA+DQo+ID4gLS0NCj4g
PiAyLjMyLjANCj4gPg0K

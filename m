Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAB06E7978
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbjDSMPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbjDSMPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:15:21 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB27A6A66
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:15:19 -0700 (PDT)
Received: from kwepemi100018.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Q1fq61PJ0z8wxY;
        Wed, 19 Apr 2023 20:14:26 +0800 (CST)
Received: from kwepemi500007.china.huawei.com (7.221.188.207) by
 kwepemi100018.china.huawei.com (7.221.188.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 20:15:17 +0800
Received: from kwepemi500007.china.huawei.com ([7.221.188.207]) by
 kwepemi500007.china.huawei.com ([7.221.188.207]) with mapi id 15.01.2507.023;
 Wed, 19 Apr 2023 20:15:17 +0800
From:   "pengyi (M)" <pengyi37@huawei.com>
To:     "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
CC:     Caowangbao <caowangbao@huawei.com>, liaichun <liaichun@huawei.com>,
        "Yanan (Euler)" <yanan@huawei.com>,
        "Fengtao (fengtao, Euler)" <fengtao40@huawei.com>,
        yujiaying <yujiaying@huawei.com>
Subject: Re: Re: Performance decrease in ipt_do_table
Thread-Topic: Re: Performance decrease in ipt_do_table
Thread-Index: AdlyuFb1G35YOUINRi+EoEeqtRJaLw==
Date:   Wed, 19 Apr 2023 12:15:17 +0000
Message-ID: <bfe4253ade16479dbb628d30871cc7a8@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.112.209]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmsgeW91IGZvciB0aGUgcmVwbHksIEkgaGF2ZSBhbm90aGVyIHF1ZXN0aW9uIGFib3V0IHRo
ZSBmaXhlZCBwYXRjaCBtZW50aW9uZWQgaW4gY29tbWl0IGQ0M2I3NWZiYzIzZi4gVGhlIGNvbW1p
dCA4YzljMjk2YWRmYWUodnJmOiBydW4gY29ubnRyYWNrIG9ubHkgaW4gY29udGV4dCBvZiBsb3dl
ci9waHlzZGV2IGZvciBsb2NhbGx5IGdlbmVyYXRlZCBwYWNrZXRzKSBhZGRlZCB0aGUgZnVuY3Rp
b24gdnJmX25mX3NldF91bnRyYWNrZWQoKSBhbmQgd2FzIGNhbGxlZCBpbiB2cmZfaXBfb3V0X2Rp
cmVjdCgpLCB0byBtYXJraW5nIHRoZSBwYWNrZXRzIGFzIHVudHJhY2suIEkgd2FzIHdvbmRlcmlu
ZyB3aHkgd2Ugc2hvdWxkIGNsZWFyIHRoZSBwYWNrZXRzIG91dCBvZiB0aGUgY29ubnRyYWNrIGlm
IHRoZSBwYWNrZXQgd291bGQgYmUgc2VudCBvdXQgZGlyZWN0bHksIGlzIGl0IGJlbmVmaWNpYWwg
dG8gdGhlIG5ldHdvcmsgcGVyZm9ybWFuY2U/IA0KDQpBbm90aGVyIGlzc3VlIGlzIHRoYXQgaWYg
dGhlIHBhY2tldCB3YXMgbWFya2VkIGFzICJ1bnRyYWNrIiwgdGhlIGlwdF9kb190YWJsZSgpIHdv
dWxkIHNwZW5kIG1vcmUgdGltZSBiZWNhdXNlIHdlIGRpZG4ndCByZWNvcmQgaXQgaW4gdGhlIGNv
bm50cmFjayBhbmQgaGFkIHRvIGFuYWx5c2l6ZSBpdC4gSSBkZWxldGVkIHRoZSAidnJmX25mX3Nl
dF91bnRyYWNrZWQoc2tiKTsiYW5kIGNvbXBhcmVkIHRoZSB0d28gc3RhY2tzLiBXZSBjb3VsZCBm
aW5kIHRoZSB0Y3BfbXQoKSB3b3VsZCBiZSBjYWxsZWQgYWZ0ZXIgdGhlIGNvbm50cmFja19tdF92
MyBhbmQgdGhlIHBlcmZvcm1hbmNlIGluY3JlYXNlZC4gQW55IHRob3VnaHRzIGFib3V0IHRoaXMg
Y29tbWl0IHdvdWxkIGJlIHZlcnkgdGhhbmtmdWwhDQoNCkhlcmUgYXR0YWNoZWQgdGhlIHN0YWNr
cyBiZWZvcmUgYW5kIGFmdGVyIHRoZSBjb21taXQ6DQojIE5vdCBkZWxldGluZyB2cmZfbmZfc2V0
X3VudHJhY2tlZChza2IpDQojIENQVSAgRFVSQVRJT04gICAgICAgICAgICAgICAgICBGVU5DVElP
TiBDQUxMUyAgICAgICAgICAgICAgICAgICAgDQojIHwgICAgIHwgICB8ICAgICAgICAgICAgICAg
ICAgICAgfCAgIHwgICB8ICAgfA0KICAwKSAgICAgICAgICAgICAgIHwgIGlwdF9kb190YWJsZSBb
aXBfdGFibGVzXSgpIHsNCiAgMCkgICAgICAgICAgICAgICB8ICAgIGNvbm50cmFja19tdF92MyBb
eHRfY29ubnRyYWNrXSgpIHsNCiAgMCkgICAwLjM2MCB1cyAgICB8ICAgICAgY29ubnRyYWNrX210
LmlzcmEuMCBbeHRfY29ubnRyYWNrXSgpOw0KICAwKSAgIDEuMDkwIHVzICAgIHwgICAgfQ0KICAw
KSAgIDAuMzcwIHVzICAgIHwgICAgdGNwX210KCk7DQogIDApICAgMC4zMDAgdXMgICAgfCAgICB0
Y3BfbXQoKTsNCiAgMCkgICAwLjMwMCB1cyAgICB8ICAgIHRjcF9tdCgpOw0KICAwKSAgIDAuMjkw
IHVzICAgIHwgICAgdGNwX210KCk7DQogIDApICAgMC4zMTAgdXMgICAgfCAgICB0Y3BfbXQoKTsN
CiAgMCkgICAwLjMwMCB1cyAgICB8ICAgIHRjcF9tdCgpOw0KDQojIERlbGV0aW5nIHZyZl9uZl9z
ZXRfdW50cmFja2VkKHNrYikNCiMgQ1BVICBEVVJBVElPTiAgICAgICAgICAgICAgICAgIEZVTkNU
SU9OIENBTExTDQojIHwgICAgIHwgICB8ICAgICAgICAgICAgICAgICAgICAgfCAgIHwgICB8ICAg
fA0KMTcpICAgICAgICAgICAgICAgfCAgaXB0X2RvX3RhYmxlIFtpcF90YWJsZXNdKCkgew0KMTcp
ICAgICAgICAgICAgICAgfCAgICBjb25udHJhY2tfbXRfdjMgW3h0X2Nvbm50cmFja10oKSB7DQox
NykgICAwLjgyMCB1cyAgICB8ICAgICAgY29ubnRyYWNrX210LmlzcmEuMSBbeHRfY29ubnRyYWNr
XSgpOw0KMTcpICAgMS42OTAgdXMgICAgfCAgICB9DQoxNykgICAwLjM0MCB1cyAgICB8ICAgIF9f
bG9jYWxfYmhfZW5hYmxlX2lwKCk7DQoxNykgICA1LjQ2MCB1cyAgICB8ICB9DQoxNykgICAgICAg
ICAgICAgICB8ICBpcHRfZG9fdGFibGUgW2lwX3RhYmxlc10oKSB7DQoxNykgICAgICAgICAgICAg
ICB8ICAgIGNvbm50cmFja19tdF92MyBbeHRfY29ubnRyYWNrXSgpIHsNCjE3KSAgIDAuNzIwIHVz
ICAgIHwgICAgICBjb25udHJhY2tfbXQuaXNyYS4xIFt4dF9jb25udHJhY2tdKCk7DQoxNykgICAx
LjY0MCB1cyAgICB8ICAgIH0NCjE3KSAgIDAuMzMwIHVzICAgIHwgICAgX19sb2NhbF9iaF9lbmFi
bGVfaXAoKTsNCjE3KSAgIDQuNDcwIHVzICAgIHwgIH0NCg0KQmVzdCB3aXNoZXMNCllpIFBlbmcN
Cg0KLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0K5Y+R5Lu25Lq6OiBOaWNvbGFzIERpY2h0ZWwgPG5p
Y29sYXMuZGljaHRlbEA2d2luZC5jb20+IA0K5Y+R6YCB5pe26Ze0OiAyMDIz5bm0NOaciDE55pel
IDA6MjgNCuaUtuS7tuS6ujogcGVuZ3lpIChNKSA8cGVuZ3lpMzdAaHVhd2VpLmNvbT47IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGRzYWhlcm5Aa2VybmVsLm9y
ZzsgcGFibG9AbmV0ZmlsdGVyLm9yZw0K5oqE6YCBOiBDYW93YW5nYmFvIDxjYW93YW5nYmFvQGh1
YXdlaS5jb20+OyBsaWFpY2h1biA8bGlhaWNodW5AaHVhd2VpLmNvbT47IFlhbmFuIChFdWxlcikg
PHlhbmFuQGh1YXdlaS5jb20+DQrkuLvpopg6IFJlOiBQZXJmb3JtYW5jZSBkZWNyZWFzZSBpbiBp
cHRfZG9fdGFibGUNCg0KTGUgMTgvMDQvMjAyMyDDoCAxNjozNywgcGVuZ3lpIChNKSBhIMOpY3Jp
dMKgOg0KPiBIaSwgSSBmb3VuZCBhZnRlciB0aGUgY29tbWl0IGQ0M2I3NWZiYzIzZiBbdnJmOiBk
b24ndCBydW4gY29ubnRyYWNrIG9uIHZyZiB3aXRoICFkZmx0IHFkaXNjXSBpbiB2cmYuYyAsIHRo
ZSBwZXJmb3JtYW5jZSBvZiBpcHRfZG9fdGFibGUgZGVjcmVhc2VkLiBJbiB2cmYuYywgdGhlIGxv
Y2FsbHkgZ2VuZXJhdGVkIHBhY2tldCB3YXMgbWFya2VkIGFzICJ1bnRyYWNrZWQiIGluIHZyZl9p
cF9vdXQsIGJlY2F1c2UgaXQgd29uJ3QgYmUgcHJvY2Vzc2VkIGJ5IHRoZSByb3V0ZXIoYWxzbyBt
ZW50aW9uZWQgaW4gY29tbWl0LiBkNDNiNzVmYmMyM2YpLiBBbmQgaXQgd2lsbCBhbHNvIG1hZGUg
dGhlIHN0YXRlYml0IHdhcyBzZXQgdG8gWFRfQ09OTlRSQUNLX1NUQVRFX1VOVFJBQ0tFRCBpbiBj
b25udHJhY2tfbXQsIHdoaWNoIG1lYW5zIHdlIGRpZG4ndCBoYWQgdGhlIGluZm9ybWF0aW9uIGFi
b3V0IGluIGNvbm50cmFjayBzbyB3ZSBoYWQgdG8gcmUtYW5hbHlzaXplIHRoZSBwYWNrZXQgYnkg
Y2FsbGluZyB0Y3BfbXQoKS4NCj4gDQo+IEhvd2V2ZXIsIGFmdGVyIHRoZSBjb21taXQgZDQzYjc1
ZmJjMjNmICwgYWxsIHBhY2tldHMgaW4gdnJmX2lwX291dCB3YXMgbWFya2VkIGFzICJ1bnRyYWNr
ZWQiLCB3aGljaCBtYWRlIG1vcmUgdGltZXMgb2YgY2FsbGluZyB0Y3BfbXQoKS4gSGVuY2UgdGhl
IHRpbWUgb2YgcHJvY2Vzc2luZyBhbGwgcGFja2V0cyBiZWNhbWUgbG9uZ2VyIGFuZCBpdCBhZmZl
Y3RlZCB0aGUgcGVyZm9ybWFuY2Ugb2YgaXB0X2RvX3RhYmxlKCkgaW4gdG90YWwuIEkgd29uZGVy
IGlzIGl0IGFuIGV4cGVjdGVkIGJlaGF2aW9yIHRvIHNlZSB0aGUgcGVyZm9ybWFuY2UgZGVjcmVh
c2UgYWZ0ZXIgdGhlIGNvbW1pdCBkNDNiNzVmYmMyM2YgPw0KSXQgd2FzIG5vdCB0aGUgZ29hbCBv
ZiB0aGlzIGNvbW1pdCA6KQ0KVGhlIHBlcmZvcm1hbmNlIHJlZ3Jlc3Npb24gc2VlbXMgdG8gYmUg
c3BlY2lmaWMgdG8geW91ciBydWxlIHNldC4NCkFzIGV4cGxhaW5lZCBpbiB0aGUgY29tbWl0IGxv
ZywgdGhlIGdvYWwgd2FzIHRvIGhhdmUgdGhlIHNhbWUgcGFja2V0IHByb2Nlc3NpbmcsIHdoYXRl
dmVyIHFkaXNjIGlzIGNvbmZpZ3VyZWQgb24gdGhlIHZyZiBpbnRlcmZhY2UuDQpCZWZvcmUgdGhp
cyBwYXRjaCwgeW91IHNob3VsZCBoYXZlIHRoZSBzYW1lIHBlcmZvcm1hbmNlIGxldmVsIChhcyBu
b3cpIGlmIGEgcWRpc2MgaXMgY29uZmlndXJlZC4NCg0KDQpSZWdhcmRzLA0KTmljb2xhcw0K

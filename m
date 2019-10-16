Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD566D9998
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436635AbfJPSyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 14:54:25 -0400
Received: from cvk-fw2.cvk.de ([194.39.189.12]:64106 "EHLO cvk-fw2.cvk.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731889AbfJPSyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 14:54:24 -0400
Received: from localhost (cvk-fw2 [127.0.0.1])
        by cvk-fw2.cvk.de (Postfix) with ESMTP id 46thKp4pVyz4wHf;
        Wed, 16 Oct 2019 20:54:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cvk.de; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from; s=
        mailcvk20190509; t=1571252062; x=1573066463; bh=1XTzqL6G644LUV3t
        XXewALTM822PWX+bJPPkkS3E7wU=; b=WJoDfuPmZ/1Fwlqx06GnRcfs1kKgJgYJ
        aZYJR8Ww4F6WuSn3dNbyFP4q5SwJ63qmasEeOclay9KZAy4i6oTHvQwJ5wqr78yQ
        Gt0tcod/v6fAGFyllw5WuWRs9QIlTj8PzelfyzshV7S0LDihRDE3YdnovDz57EKq
        uU1alvJcS6A/8nkIR8MkYg/5pjO/vflWX9qp86mIxK8SrrpnkgVxNT3h5X4oVAiY
        CH/j/4myaCiQC041+1rKBnUZpiOJZpJ2y7NziNy2SObT9WtLlQs1RqK71s51m073
        3C6x8exAvC5XOyMmKvONdZsKE9cdG5khx16pbsmol+Rmxc/H3r1jnQ==
X-Virus-Scanned: by amavisd-new at cvk.de
Received: from cvk-fw2.cvk.de ([127.0.0.1])
        by localhost (cvk-fw2.cvk.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Mcs6wWYCb44Q; Wed, 16 Oct 2019 20:54:22 +0200 (CEST)
Received: from cvk017.cvk.de (cvk017 [10.1.0.17])
        by cvk-fw2.cvk.de (Postfix) with ESMTP;
        Wed, 16 Oct 2019 20:54:22 +0200 (CEST)
Received: from cvk038.intra.cvk.de (cvk038.cvk.de [10.1.0.38])
        by cvk017.cvk.de (Postfix) with ESMTP id 4691C860DA5;
        Wed, 16 Oct 2019 20:54:22 +0200 (CEST)
Received: from CVK038.intra.cvk.de ([::1]) by cvk038.intra.cvk.de ([::1]) with
 mapi id 14.03.0468.000; Wed, 16 Oct 2019 20:54:15 +0200
From:   "Bartschies, Thomas" <Thomas.Bartschies@cvk.de>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        'David Ahern' <dsahern@gmail.com>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: AW: big ICMP requests get disrupted on IPSec tunnel activation
Thread-Topic: big ICMP requests get disrupted on IPSec tunnel activation
Thread-Index: AdWEITrKOt8CRlKURa6ZLEMgb4tszgABNN0AAABRz4AACrq6MA==
Date:   Wed, 16 Oct 2019 18:54:14 +0000
Message-ID: <EB8510AA7A943D43916A72C9B8F4181F62A0981D@cvk038.intra.cvk.de>
References: <EB8510AA7A943D43916A72C9B8F4181F62A096BF@cvk038.intra.cvk.de>
 <24354e08-fa07-9383-e8ba-7350b40d3171@gmail.com>
 <df90f3cf-69d6-dae6-a394-b92a3fc379bb@gmail.com>
In-Reply-To: <df90f3cf-69d6-dae6-a394-b92a3fc379bb@gmail.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.13.254]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-GBS-PROC: mBCtcOCtwCOp5vL6i/FxNfSYhputmR/d4gWcYBLMDUQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCkkgaGFkIHRvIGFkYXB0IHRoZSBzZWNvbmQgaGFsZiB0byBteSB0ZXN0IGtlcm5l
bC4gSnVzdCBoYWQgdG8gbWFrZSBzb21lIGd1ZXNzZXMsIHRlc3RlZC4gYW5kIGl0IHdvcmtzLg0K
WW91ciBjb25jbHVzaW9ucyBhcmUgY29ycmVjdC4gSSBhbHNvIHN1c3BlY3RlZCBzb21ldGhpbmcg
bGlrZSB0aGF0LCBidXQgd2l0aCBubyBrbm93bGVkZ2Ugb2YgdGhlIGlubmVyDQp3b3JraW5ncyBv
ZiB0aGUgaXAgc3RhY2sgSSBoYWQgdmVyeSBsaXR0bGUgY2hhbmNlcyB0byBmaW5kIHRoZSByaWdo
dCBmaXggYnkgbXlzZWxmLg0KDQpUaGFuayB5b3UgdmVyeSBtdWNoLiBXaWxsIHJldGVzdCBrbm93
IGZvciBhIHNlY29uZGFyeSBmb3J3YXJkaW5nIHByb2JsZW0gdGhhdCdzIG11Y2ggaGFyZGVyIHRv
IHJlcHJvZHVjZS4NCg0KUmVnYXJkcywNCi0tDQpUaG9tYXMgQmFydHNjaGllcw0KQ1ZLIElULVN5
c3RlbWUNCg0KLS0tLS1VcnNwcsO8bmdsaWNoZSBOYWNocmljaHQtLS0tLQ0KVm9uOiBFcmljIER1
bWF6ZXQgW21haWx0bzplcmljLmR1bWF6ZXRAZ21haWwuY29tXSANCkdlc2VuZGV0OiBNaXR0d29j
aCwgMTYuIE9rdG9iZXIgMjAxOSAxNzo0MQ0KQW46IEJhcnRzY2hpZXMsIFRob21hcyA8VGhvbWFz
LkJhcnRzY2hpZXNAY3ZrLmRlPjsgJ0RhdmlkIEFoZXJuJyA8ZHNhaGVybkBnbWFpbC5jb20+OyAn
bmV0ZGV2QHZnZXIua2VybmVsLm9yZycgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+DQpCZXRyZWZm
OiBSZTogYmlnIElDTVAgcmVxdWVzdHMgZ2V0IGRpc3J1cHRlZCBvbiBJUFNlYyB0dW5uZWwgYWN0
aXZhdGlvbg0KDQpPbiAxMC8xNi8xOSA4OjMxIEFNLCBFcmljIER1bWF6ZXQgd3JvdGU6DQo+IA0K
PiANCj4gT24gMTAvMTYvMTkgNTo1NyBBTSwgQmFydHNjaGllcywgVGhvbWFzIHdyb3RlOg0KPj4g
SGVsbG8sDQo+Pg0KPj4gZGlkIGFub3RoZXIgdGVzdC4gVGhpcyB0aW1lIEkndmUgY2hhbmdlZCB0
aGUgb3JkZXIuIEZpcnN0IHRyaWdnZXJlZCB0aGUgSVBTZWMgcG9saWN5IGFuZCB0aGVuIHRyaWVk
IHRvIHBpbmcgaW4gcGFyYWxsZWwgd2l0aCBhIGJpZyBwYWNrZXQgc2l6ZS4NCj4+IENvdWxkIGFs
c28gcmVwcm9kdWNlIHRoZSBpc3N1ZSwgYnV0IHRoZSB0cmFjZSB3YXMgY29tcGxldGVseSBkaWZm
ZXJlbnQuIE1heSBiZSB0aGlzIHRpbWUgSSd2ZSBnb3QgdGhlIHRyYWNlIGZvciB0aGUgcHJvYmxl
bWF0aWMgY29ubmVjdGlvbj8NCj4+DQo+IA0KPiBUaGlzIG9uZSB3YXMgcHJvYmFibHkgYSBmYWxz
ZSBwb3NpdGl2ZS4NCj4gDQo+IFRoZSBvdGhlciBvbmUsIEkgZmluYWxseSB1bmRlcnN0b29kIHdo
YXQgd2FzIGdvaW5nIG9uLg0KPiANCj4gWW91IHRvbGQgdXMgeW91IHJlbW92ZWQgbmV0ZmlsdGVy
LCBidXQgaXQgc2VlbXMgeW91IHN0aWxsIGhhdmUgdGhlIGlwIGRlZnJhZyBtb2R1bGVzIHRoZXJl
Lg0KPiANCj4gKEZvciBhIHB1cmUgZm93YXJkaW5nIG5vZGUsIG5vIHJlYXNzZW1ibHktZGVmcmFn
IHNob3VsZCBiZSBuZWVkZWQpDQo+IA0KPiBXaGVuIGlwX2ZvcndhcmQoKSBpcyB1c2VkLCBpdCBj
b3JyZWN0bHkgY2xlYXJzIHNrYi0+dHN0YW1wDQo+IA0KPiBCdXQgbGF0ZXIsIGlwX2RvX2ZyYWdt
ZW50KCkgbWlnaHQgcmUtdXNlIHRoZSBza2JzIGZvdW5kIGF0dGFjaGVkIHRvIA0KPiB0aGUgbWFz
dGVyIHNrYiBhbmQgd2UgZG8gbm90IGluaXQgcHJvcGVybHkgdGhlaXIgc2tiLT50c3RhbXANCj4g
DQo+IFRoZSBtYXN0ZXIgc2tiLT50c3RhbXAgc2hvdWxkIGJlIGNvcGllZCB0byB0aGUgY2hpbGRy
ZW4uDQo+IA0KPiBJIHdpbGwgc2VuZCBhIHBhdGNoIGFzYXAuDQo+IA0KPiBUaGFua3MuDQo+IA0K
DQpDYW4geW91IHRyeSA6DQoNCmRpZmYgLS1naXQgYS9uZXQvaXB2NC9pcF9vdXRwdXQuYyBiL25l
dC9pcHY0L2lwX291dHB1dC5jIGluZGV4IDI4ZmNhNDA4ODEyYzU1NzZmYzRlYTk1N2MxYzRkZWM5
N2VjOGZhZjMuLmM4ODAyMjlhMDE3MTJiYTVhOWVkNDEzZjhhYWIyYjU2ZGZlOTNjODIgMTAwNjQ0
DQotLS0gYS9uZXQvaXB2NC9pcF9vdXRwdXQuYw0KKysrIGIvbmV0L2lwdjQvaXBfb3V0cHV0LmMN
CkBAIC04MDgsNiArODA4LDcgQEAgaW50IGlwX2RvX2ZyYWdtZW50KHN0cnVjdCBuZXQgKm5ldCwg
c3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KICAgICAgICBpZiAoc2tiX2hh
c19mcmFnX2xpc3Qoc2tiKSkgew0KICAgICAgICAgICAgICAgIHN0cnVjdCBza19idWZmICpmcmFn
LCAqZnJhZzI7DQogICAgICAgICAgICAgICAgdW5zaWduZWQgaW50IGZpcnN0X2xlbiA9IHNrYl9w
YWdlbGVuKHNrYik7DQorICAgICAgICAgICAgICAga3RpbWVfdCB0c3RhbXAgPSBza2ItPnRzdGFt
cDsNCiANCiAgICAgICAgICAgICAgICBpZiAoZmlyc3RfbGVuIC0gaGxlbiA+IG10dSB8fA0KICAg
ICAgICAgICAgICAgICAgICAoKGZpcnN0X2xlbiAtIGhsZW4pICYgNykgfHwgQEAgLTg0Niw2ICs4
NDcsNyBAQCBpbnQgaXBfZG9fZnJhZ21lbnQoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3Qgc29jayAq
c2ssIHN0cnVjdCBza19idWZmICpza2IsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGlwX2ZyYWdsaXN0X3ByZXBhcmUoc2tiLCAmaXRlcik7DQogICAgICAgICAgICAgICAgICAgICAg
ICB9DQogDQorICAgICAgICAgICAgICAgICAgICAgICBza2ItPnRzdGFtcCA9IHRzdGFtcDsNCiAg
ICAgICAgICAgICAgICAgICAgICAgIGVyciA9IG91dHB1dChuZXQsIHNrLCBza2IpOw0KIA0KICAg
ICAgICAgICAgICAgICAgICAgICAgaWYgKCFlcnIpDQo=

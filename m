Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B05F3C6C3
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 10:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404802AbfFKI5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 04:57:11 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:55828 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403860AbfFKI5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 04:57:11 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 34A3A1C63823ED2928D3;
        Tue, 11 Jun 2019 16:57:08 +0800 (CST)
Received: from dggeme714-chm.china.huawei.com (10.1.199.110) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Jun 2019 16:56:58 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme714-chm.china.huawei.com (10.1.199.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 11 Jun 2019 16:56:57 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1591.008;
 Tue, 11 Jun 2019 16:56:57 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     "pablo@netfilter.org" <pablo@netfilter.org>,
        "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>
CC:     Mingfangsen <mingfangsen@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjNdIG5ldDogbmV0ZmlsdGVyOiBGaXggcnBmaWx0?=
 =?utf-8?Q?er_dropping_vrf_packets_by_mistake?=
Thread-Topic: [PATCH v3] net: netfilter: Fix rpfilter dropping vrf packets by
 mistake
Thread-Index: AQHU+20EJBRdmfpcd0eT0vsD259sj6aWb9Ew
Date:   Tue, 11 Jun 2019 08:56:57 +0000
Message-ID: <b943dcae6dc447f4ba72d632736b5b4f@huawei.com>
References: <212e4feb-39de-2627-9948-bbb117ff4d4e@huawei.com>
In-Reply-To: <212e4feb-39de-2627-9948-bbb117ff4d4e@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJpZW5kbHkgcGluZy4NCg0KLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0K5Y+R5Lu25Lq6OiBsaW51
eC1rZXJuZWwtb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bGludXgta2VybmVsLW93bmVy
QHZnZXIua2VybmVsLm9yZ10g5Luj6KGoIGxpbm1pYW9oZQ0K5Y+R6YCB5pe26Ze0OiAyMDE55bm0
NOaciDI15pelIDIxOjQ0DQrmlLbku7bkuro6IHBhYmxvQG5ldGZpbHRlci5vcmc7IGthZGxlY0Bi
bGFja2hvbGUua2ZraS5odTsgZndAc3RybGVuLmRlOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdXpu
ZXRAbXMyLmluci5hYy5ydTsgeW9zaGZ1amlAbGludXgtaXB2Ni5vcmc7IG5ldGZpbHRlci1kZXZl
bEB2Z2VyLmtlcm5lbC5vcmc7IGNvcmV0ZWFtQG5ldGZpbHRlci5vcmc7IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGRzYWhlcm5AZ21haWwuY29t
DQrmioTpgIE6IE1pbmdmYW5nc2VuIDxtaW5nZmFuZ3NlbkBodWF3ZWkuY29tPg0K5Li76aKYOiBb
UEFUQ0ggdjNdIG5ldDogbmV0ZmlsdGVyOiBGaXggcnBmaWx0ZXIgZHJvcHBpbmcgdnJmIHBhY2tl
dHMgYnkgbWlzdGFrZQ0KDQpGcm9tOiBNaWFvaGUgTGluIDxsaW5taWFvaGVAaHVhd2VpLmNvbT4N
Cg0KV2hlbiBmaXJld2FsbGQgaXMgZW5hYmxlZCB3aXRoIGlwdjQvaXB2NiBycGZpbHRlciwgdnJm
DQppcHY0L2lwdjYgcGFja2V0cyB3aWxsIGJlIGRyb3BwZWQgYmVjYXVzZSBpbiBkZXZpY2UgaXMg
dnJmIGJ1dCBvdXQgZGV2aWNlIGlzIGFuIGVuc2xhdmVkIGRldmljZS4gU28gZmFpbGVkIHdpdGgg
dGhlIGNoZWNrIG9mIHRoZSBycGZpbHRlci4NCg0KU2lnbmVkLW9mZi1ieTogTWlhb2hlIExpbiA8
bGlubWlhb2hlQGh1YXdlaS5jb20+DQotLS0NCiBuZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X3JwZmls
dGVyLmMgIHwgIDEgKyAgbmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfcnBmaWx0ZXIuYyB8IDEwICsr
KysrKysrKy0NCiAyIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkNCg0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L25ldGZpbHRlci9pcHRfcnBmaWx0ZXIuYyBiL25l
dC9pcHY0L25ldGZpbHRlci9pcHRfcnBmaWx0ZXIuYw0KaW5kZXggMGIxMGQ4ODEyODI4Li42ZTA3
Y2QwZWNiZWMgMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X3JwZmlsdGVyLmMN
CisrKyBiL25ldC9pcHY0L25ldGZpbHRlci9pcHRfcnBmaWx0ZXIuYw0KQEAgLTgxLDYgKzgxLDcg
QEAgc3RhdGljIGJvb2wgcnBmaWx0ZXJfbXQoY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3Ry
dWN0IHh0X2FjdGlvbl9wYXJhbSAqcGFyKQ0KIAlmbG93LmZsb3dpNF9tYXJrID0gaW5mby0+Zmxh
Z3MgJiBYVF9SUEZJTFRFUl9WQUxJRF9NQVJLID8gc2tiLT5tYXJrIDogMDsNCiAJZmxvdy5mbG93
aTRfdG9zID0gUlRfVE9TKGlwaC0+dG9zKTsNCiAJZmxvdy5mbG93aTRfc2NvcGUgPSBSVF9TQ09Q
RV9VTklWRVJTRTsNCisJZmxvdy5mbG93aTRfb2lmID0gbDNtZGV2X21hc3Rlcl9pZmluZGV4X3Jj
dSh4dF9pbihwYXIpKTsNCg0KIAlyZXR1cm4gcnBmaWx0ZXJfbG9va3VwX3JldmVyc2UoeHRfbmV0
KHBhciksICZmbG93LCB4dF9pbihwYXIpLCBpbmZvLT5mbGFncykgXiBpbnZlcnQ7ICB9IGRpZmYg
LS1naXQgYS9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dF9ycGZpbHRlci5jIGIvbmV0L2lwdjYvbmV0
ZmlsdGVyL2lwNnRfcnBmaWx0ZXIuYw0KaW5kZXggYzNjNmIwOWFjZGM0Li5hMjhjODEzMjIxNDgg
MTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dF9ycGZpbHRlci5jDQorKysgYi9u
ZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dF9ycGZpbHRlci5jDQpAQCAtNTgsNyArNTgsOSBAQCBzdGF0
aWMgYm9vbCBycGZpbHRlcl9sb29rdXBfcmV2ZXJzZTYoc3RydWN0IG5ldCAqbmV0LCBjb25zdCBz
dHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIAlpZiAocnBmaWx0ZXJfYWRkcl9saW5rbG9jYWwoJmlwaC0+
c2FkZHIpKSB7DQogCQlsb29rdXBfZmxhZ3MgfD0gUlQ2X0xPT0tVUF9GX0lGQUNFOw0KIAkJZmw2
LmZsb3dpNl9vaWYgPSBkZXYtPmlmaW5kZXg7DQotCX0gZWxzZSBpZiAoKGZsYWdzICYgWFRfUlBG
SUxURVJfTE9PU0UpID09IDApDQorCX0gZWxzZSBpZiAoKChmbGFncyAmIFhUX1JQRklMVEVSX0xP
T1NFKSA9PSAwKSB8fA0KKwkJICAgKG5ldGlmX2lzX2wzX21hc3RlcihkZXYpKSB8fA0KKwkJICAg
KG5ldGlmX2lzX2wzX3NsYXZlKGRldikpKQ0KIAkJZmw2LmZsb3dpNl9vaWYgPSBkZXYtPmlmaW5k
ZXg7DQoNCiAJcnQgPSAodm9pZCAqKWlwNl9yb3V0ZV9sb29rdXAobmV0LCAmZmw2LCBza2IsIGxv
b2t1cF9mbGFncyk7IEBAIC03Myw2ICs3NSwxMiBAQCBzdGF0aWMgYm9vbCBycGZpbHRlcl9sb29r
dXBfcmV2ZXJzZTYoc3RydWN0IG5ldCAqbmV0LCBjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0K
IAkJZ290byBvdXQ7DQogCX0NCg0KKwlpZiAobmV0aWZfaXNfbDNfbWFzdGVyKGRldikpIHsNCisJ
CWRldiA9IGRldl9nZXRfYnlfaW5kZXhfcmN1KGRldl9uZXQoZGV2KSwgSVA2Q0Ioc2tiKS0+aWlm
KTsNCisJCWlmICghZGV2KQ0KKwkJCWdvdG8gb3V0Ow0KKwl9DQorDQogCWlmIChydC0+cnQ2aV9p
ZGV2LT5kZXYgPT0gZGV2IHx8IChmbGFncyAmIFhUX1JQRklMVEVSX0xPT1NFKSkNCiAJCXJldCA9
IHRydWU7DQogIG91dDoNCi0tDQoyLjE5LjENCg0KDQo=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAB2177292
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 22:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGZUK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 16:10:56 -0400
Received: from mail-eopbgr50128.outbound.protection.outlook.com ([40.107.5.128]:32310
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726000AbfGZUKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 16:10:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/mawkMv2AlRvlSbFfcD40UCW5bZQmYuxcq5XsZvTurxw5aU+ragcwPkNu5bk01vr+WB9PcuZ3xQRu4pSrA+p5R/5LtM8LEnodRv+cVgxIi2o7tZoiFTuaSiDyUWZsubXgRl8Ps6aN/edXnHRCZqLAkcU+jqTqMb60UJBXtKLHXN5o1Vmem7TB4cccFWGqFGr3r/rFBVuBVYQQNIYyw7jCaLg+EhHSLIvPVNmtR13L5cu77KATuSwkxuYHbWfi9u84ktjj7tpBp7z0e4d63HMpAYZkDvf2Se5RIA4hP5/zmIq8QBHk3O4xc3BgvDQ6OdYm0KvEUpzp4dcRC8+SIXgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpF+G7/TPynfXVONp8ygT4kHP5Q+fjjw5yyE6c9Cgs0=;
 b=ZTGm8MYZ5eiYgdX+qUXS/aNSRKmNQ5rFwZjDDGuvFaWgUBgyhe3FutKCiKoVAb/XfWtjN3MZrAWPLAeBcLW/BkjlecNam6V0bOoKpEfM9furPmZlj5cbL+80SUAfaQSeLUot4L00LInfQ1U0h3Vw6tMiRMHGKzFvh+/iqKnZ9ZQWFLtr4PIwXPBopqLTNnf17qWVLnpKfmYIvZdby5+S/HIvYu5xCZsQeOxdODZa/7MkQJXO5mdkLWugLqEo2D4WvQ+bmIgcDWd9BNu3y1+kNE2d+ak3kvZNCkQPPE9rd+lHCD9Oqp7ERspZyaYc/CfH0st8XRmT9eCLI78ZwxJNxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=victronenergy.com;dmarc=pass action=none
 header.from=victronenergy.com;dkim=pass header.d=victronenergy.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpF+G7/TPynfXVONp8ygT4kHP5Q+fjjw5yyE6c9Cgs0=;
 b=g01DnGPmbBbHw6vFZyUvXv02DDRPs3QItg8dUMsEsNwdk/4c0VwlVDgoGfPH05qOqlcjV6zwZ27jAHZ2PDTXWju0Z7PaDr18Sdrd9TcNBhAlmv2lzpjknsm+7D6ajaWEKRSXSb4+WBd+ThySYp62gplJhwITJn+Ovy7nJGEqtZM=
Received: from VI1PR0702MB3661.eurprd07.prod.outlook.com (52.134.1.159) by
 VI1PR0702MB3662.eurprd07.prod.outlook.com (52.134.1.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.4; Fri, 26 Jul 2019 20:10:47 +0000
Received: from VI1PR0702MB3661.eurprd07.prod.outlook.com
 ([fe80::d98:1296:674c:4fa4]) by VI1PR0702MB3661.eurprd07.prod.outlook.com
 ([fe80::d98:1296:674c:4fa4%3]) with mapi id 15.20.2136.009; Fri, 26 Jul 2019
 20:10:47 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Anant Gole <anantgole@ti.com>, AnilKumar Ch <anilkumar@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] can: ti_hecc: use timestamp based rx-offloading
Thread-Topic: [PATCH] can: ti_hecc: use timestamp based rx-offloading
Thread-Index: AQHU/oOQxrziEdIHYkKLtad3jyL4gabdUycAgACMPIA=
Date:   Fri, 26 Jul 2019 20:10:47 +0000
Message-ID: <c52cda86-8889-63a7-ce10-e1d10444f6d2@victronenergy.com>
References: <1556539376-20932-1-git-send-email-jhofstee@victronenergy.com>
 <04bdda38-79fa-c266-2a3c-1229a1fd8229@pengutronix.de>
In-Reply-To: <04bdda38-79fa-c266-2a3c-1229a1fd8229@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [2001:1c01:3b04:4900::5]
x-clientproxiedby: AM0PR0202CA0031.eurprd02.prod.outlook.com
 (2603:10a6:208:1::44) To VI1PR0702MB3661.eurprd07.prod.outlook.com
 (2603:10a6:803:3::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 739f9bf5-b2b8-44bc-78b7-08d7120558f2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR0702MB3662;
x-ms-traffictypediagnostic: VI1PR0702MB3662:
x-microsoft-antispam-prvs: <VI1PR0702MB36628A087DE30E494CBDEAF7C0C00@VI1PR0702MB3662.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39850400004)(136003)(376002)(366004)(346002)(199004)(189003)(68736007)(102836004)(66476007)(66446008)(36756003)(66556008)(25786009)(14444005)(64756008)(256004)(81156014)(229853002)(8936002)(14454004)(81166006)(58126008)(66946007)(316002)(2501003)(486006)(53936002)(6436002)(110136005)(508600001)(4326008)(6116002)(6486002)(6512007)(305945005)(6246003)(46003)(31696002)(8676002)(476003)(99286004)(31686004)(65806001)(11346002)(86362001)(2616005)(186003)(5660300002)(446003)(386003)(76176011)(53546011)(71190400001)(64126003)(71200400001)(65956001)(2906002)(52116002)(6506007)(65826007)(54906003)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0702MB3662;H:VI1PR0702MB3661.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: J4f2YaMlfUaBY7LpreotO2KAH4qGCHzBVWXEgN4HLwBvbxIRv22XWlh38AUTHjaXmBMPR/ABOntsEI6/rLDTKLA1Nw254vDQJZnCh04VyF21RxJo72lQgROFtV4g5jyvXhpuVzpNn5x9Eml0w5UgrC4Amvsk9KTsw4uNaBN8KPdZYHAETOBbzRU5OIFwjLOLRyolX429a+HStEqDBt6pSwTjPb0VZlWr328xRnP5lhx/8FlfjH3/SrcJYRu5UWZw1HqkeNXslzsJnrqYNOGaE74MhI9WrY445tLgAodWjMTglR/NTP/xha9AAzVbsjkYovrtsgZrILCSGyC/5CMkETWCuCTJ2kgKXqW5brn4s8/jpHwIOdUn4N/BDkI5rMVGKqrcGdPyVHM+5ORHsul8U8DO299IyhHFjhNgTVWqZB0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <446F18C45B2B9D4EBEE768D3D7EE34C8@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739f9bf5-b2b8-44bc-78b7-08d7120558f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 20:10:47.4025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JHofstee@victronenergy.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0702MB3662
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gTWFyYywNCg0KT24gNy8yNi8xOSAxOjQ4IFBNLCBNYXJjIEtsZWluZS1CdWRkZSB3cm90
ZToNCj4gT24gNC8yOS8xOSAyOjAzIFBNLCBKZXJvZW4gSG9mc3RlZSB3cm90ZToNCj4NCj4+IEBA
IC03NDQsOCArNjUyLDggQEAgc3RhdGljIGlycXJldHVybl90IHRpX2hlY2NfaW50ZXJydXB0KGlu
dCBpcnEsIHZvaWQgKmRldl9pZCkNCj4+ICAgCXN0cnVjdCBuZXRfZGV2aWNlICpuZGV2ID0gKHN0
cnVjdCBuZXRfZGV2aWNlICopZGV2X2lkOw0KPj4gICAJc3RydWN0IHRpX2hlY2NfcHJpdiAqcHJp
diA9IG5ldGRldl9wcml2KG5kZXYpOw0KPj4gICAJc3RydWN0IG5ldF9kZXZpY2Vfc3RhdHMgKnN0
YXRzID0gJm5kZXYtPnN0YXRzOw0KPj4gLQl1MzIgbWJ4bm8sIG1ieF9tYXNrLCBpbnRfc3RhdHVz
LCBlcnJfc3RhdHVzOw0KPj4gLQl1bnNpZ25lZCBsb25nIGFjaywgZmxhZ3M7DQo+PiArCXUzMiBt
YnhubywgbWJ4X21hc2ssIGludF9zdGF0dXMsIGVycl9zdGF0dXMsIHN0YW1wOw0KPj4gKwl1bnNp
Z25lZCBsb25nIGZsYWdzLCByeF9wZW5kaW5nOw0KPj4gICANCj4+ICAgCWludF9zdGF0dXMgPSBo
ZWNjX3JlYWQocHJpdiwNCj4+ICAgCQkocHJpdi0+dXNlX2hlY2MxaW50KSA/IEhFQ0NfQ0FOR0lG
MSA6IEhFQ0NfQ0FOR0lGMCk7DQo+PiBAQCAtNzY5LDExICs2NzcsMTEgQEAgc3RhdGljIGlycXJl
dHVybl90IHRpX2hlY2NfaW50ZXJydXB0KGludCBpcnEsIHZvaWQgKmRldl9pZCkNCj4+ICAgCQkJ
c3Bpbl9sb2NrX2lycXNhdmUoJnByaXYtPm1ieF9sb2NrLCBmbGFncyk7DQo+PiAgIAkJCWhlY2Nf
Y2xlYXJfYml0KHByaXYsIEhFQ0NfQ0FOTUUsIG1ieF9tYXNrKTsNCj4+ICAgCQkJc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZSgmcHJpdi0+bWJ4X2xvY2ssIGZsYWdzKTsNCj4+IC0JCQlzdGF0cy0+dHhf
Ynl0ZXMgKz0gaGVjY19yZWFkX21ieChwcml2LCBtYnhubywNCj4+IC0JCQkJCQlIRUNDX0NBTk1D
RikgJiAweEY7DQo+PiArCQkJc3RhbXAgPSBoZWNjX3JlYWRfc3RhbXAocHJpdiwgbWJ4bm8pOw0K
Pj4gKwkJCXN0YXRzLT50eF9ieXRlcyArPSBjYW5fcnhfb2ZmbG9hZF9nZXRfZWNob19za2IoJnBy
aXYtPm9mZmxvYWQsDQo+PiArCQkJCQkJCQkJbWJ4bm8sIHN0YW1wKTsNCj4+ICAgCQkJc3RhdHMt
PnR4X3BhY2tldHMrKzsNCj4+ICAgCQkJY2FuX2xlZF9ldmVudChuZGV2LCBDQU5fTEVEX0VWRU5U
X1RYKTsNCj4+IC0JCQljYW5fZ2V0X2VjaG9fc2tiKG5kZXYsIG1ieG5vKTsNCj4+ICAgCQkJLS1w
cml2LT50eF90YWlsOw0KPj4gICAJCX0NCj4+ICAgDQo+PiBAQCAtNzg0LDEyICs2OTIsMTEgQEAg
c3RhdGljIGlycXJldHVybl90IHRpX2hlY2NfaW50ZXJydXB0KGludCBpcnEsIHZvaWQgKmRldl9p
ZCkNCj4+ICAgCQkoKHByaXYtPnR4X2hlYWQgJiBIRUNDX1RYX01BU0spID09IEhFQ0NfVFhfTUFT
SykpKQ0KPj4gICAJCQluZXRpZl93YWtlX3F1ZXVlKG5kZXYpOw0KPj4gICANCj4+IC0JCS8qIERp
c2FibGUgUlggbWFpbGJveCBpbnRlcnJ1cHRzIGFuZCBsZXQgTkFQSSByZWVuYWJsZSB0aGVtICov
DQo+PiAtCQlpZiAoaGVjY19yZWFkKHByaXYsIEhFQ0NfQ0FOUk1QKSkgew0KPj4gLQkJCWFjayA9
IGhlY2NfcmVhZChwcml2LCBIRUNDX0NBTk1JTSk7DQo+PiAtCQkJYWNrICY9IEJJVChIRUNDX01B
WF9UWF9NQk9YKSAtIDE7DQo+PiAtCQkJaGVjY193cml0ZShwcml2LCBIRUNDX0NBTk1JTSwgYWNr
KTsNCj4+IC0JCQluYXBpX3NjaGVkdWxlKCZwcml2LT5uYXBpKTsNCj4+ICsJCS8qIG9mZmxvYWQg
UlggbWFpbGJveGVzIGFuZCBsZXQgTkFQSSBkZWxpdmVyIHRoZW0gKi8NCj4+ICsJCXdoaWxlICgo
cnhfcGVuZGluZyA9IGhlY2NfcmVhZChwcml2LCBIRUNDX0NBTlJNUCkpKSB7DQo+PiArCQkJY2Fu
X3J4X29mZmxvYWRfaXJxX29mZmxvYWRfdGltZXN0YW1wKCZwcml2LT5vZmZsb2FkLA0KPj4gKwkJ
CQkJCQkgICAgIHJ4X3BlbmRpbmcpOw0KPj4gKwkJCWhlY2Nfd3JpdGUocHJpdiwgSEVDQ19DQU5S
TVAsIHJ4X3BlbmRpbmcpOw0KPiBDYW4gcHJlcGFyZSBhIHBhdGNoIHRvIG1vdmUgdGhlIFJNUCB3
cml0aW5nIGludG8gdGhlIG1haWxib3hfcmVhZCgpDQo+IGZ1bmN0aW9uLiBUaGlzIG1ha2VzIHRo
ZSBtYWlsYm94IGF2YWlsYWJsZSBhIGJpdCBlYXJsaWVyIGFuZCB3b3Jrcw0KPiBiZXR0ZXIgZm9y
IG1lbW9yeSBwcmVzc3VyZSBzaXR1YXRpb25zLCB3aGVyZSBubyBza2IgY2FuIGJlIGFsbG9jYXRl
ZC4NCg0KDQpGb3IgbXkgdW5kZXJzdGFuZGluZywgaXMgdGhlcmUgYW55IG90aGVyIHJlYXNvbiBm
b3IgYWxsb2NfY2FuX3NrYiwNCnRvIGZhaWwsIGJlc2lkZXMgYmVpbmcgb3V0IG9mIG1lbW9yeS4g
SSBjb3VsZG4ndCBlYXNpbHkgZmluZCBhbiBvdGhlcg0KbGltaXQgZW5mb3JjZWQgb24gaXQuDQoN
CklmIGl0IGlzIGFjdHVhbGx5IF9tb3ZlZF8sIGFzIHlvdSBzdWdnZXN0ZWQsIGl0IGRvZXMgbG9v
c2UgdGhlIGFiaWxpdHkgdG8NCmhhbmRsZSB0aGUgbmV3bHkgcmVjZWl2ZWQgbWVzc2FnZXMgd2hp
bGUgdGhlIG1lc3NhZ2VzIGFyZSByZWFkDQppbiB0aGUgc2FtZSBpbnRlcnJ1cHQsIHNvIGl0IG5l
ZWRzIHRvIGludGVycnVwdCBhZ2Fpbi4gVGhhdCB3aWxsIHdvcmssDQpidXQgc2VlbXMgYSBiaXQg
YSBzaWxseSB0aGluZyB0byBkby4NCg0KUGVyaGFwcyB3ZSBjYW4gZG8gYm90aD8gTWFyayB0aGUg
bWFpbGJveCBhcyBhdmFpbGFibGUgaW4NCm1haWxib3hfcmVhZCwgc28gaXQgaXMgYXZhaWxhYmxl
IGFzIHNvb24gYXMgcG9zc2libGUgYW5kIGNsZWFyDQp0aGVtIGFsbCBpbiB0aGUgaXJxICh1bmRl
ciB0aGUgYXNzdW1wdGlvbiB0aGF0IGFsbG9jX2Nhbl9za2INCmZhaWx1cmUgbWVhbnMgcmVhbCBi
aWcgdHJvdWJsZSwgd2h5IHdvdWxkIHdlIHdhbnQgdG8ga2VlcCB0aGUNCm9sZCBtZXNzYWdlcyBh
cm91bmQgYW5kIGV2ZW50dWFsbHkgaWdub3JlIHRoZSBuZXcgbWVzc2FnZXM/KS4NCg0KQW5vdGhl
ciBxdWVzdGlvbiwgbm90IHJlbGF0ZWQgdG8gdGhpcyBwYXRjaCwgYnV0IHRoaXMgZHJpdmVyLi4N
Ck1vc3Qgb2YgdGhlIHRpbWVzIHRoZSBpcnEgaGFuZGxlcyAxIG9yIHNvbWV0aW1lcyAyIG1lc3Nh
Z2VzLg0KRG8geW91IGhhcHBlbiB0byBrbm93IGlmIGl0IGlzIHBvc3NpYmxlIHRvIG9wdGlvbmFs
bHkgZGVsYXkgdGhlIGlycQ0KYSBiaXQgaW4gdGhlIG1pbGxpc2Vjb25kIHJhbmdlLCBzbyBtb3Jl
IHdvcmsgY2FuIGJlIGRvbmUgaW4gYSBzaW5nbGUNCmludGVycnVwdD8gU2luY2UgdGhlcmUgYXJl
IG5vdyAyOCByeCBoYXJkd2FyZSBtYWlsYm94ZXMgYXZhaWxhYmxlLA0KaXQgc2hvdWxkbid0IHJ1
biBvdXQgZWFzaWx5Lg0KDQpBbmQgYXMgbGFzdCwgSSBndWVzcyB5b3Ugd2FudCBhIHBhdGNoIHdo
aWNoIGFwcGxpZXMgdG8NCmxpbnV4LWNhbi1uZXh0L3Rlc3RpbmcsIHJpZ2h0Pw0KDQpXaXRoIGtp
bmQgcmVnYXJkcywNCg0KSmVyb2VuDQoNCg0K

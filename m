Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D432E2DA6
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 08:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgLZHzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 02:55:02 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2928 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgLZHzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 02:55:01 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4D2wzW5bBRz5848
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 15:53:27 +0800 (CST)
Received: from DGGEMM422-HUB.china.huawei.com (10.1.198.39) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Sat, 26 Dec 2020 15:54:13 +0800
Received: from DGGEMM513-MBS.china.huawei.com ([169.254.4.106]) by
 dggemm422-hub.china.huawei.com ([169.254.138.104]) with mapi id
 14.03.0509.000; Sat, 26 Dec 2020 15:54:05 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     liuyonglong <liuyonglong@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        xudingke <xudingke@huawei.com>
Subject: RE: [PATCH net] net: hns: fix return value check in
 __lb_other_process()
Thread-Topic: [PATCH net] net: hns: fix return value check in
 __lb_other_process()
Thread-Index: AQHW2qmv3QjIQUTpcU6aHumzjPDiMaoIaBKAgACalNA=
Date:   Sat, 26 Dec 2020 07:54:04 +0000
Message-ID: <34EFBCA9F01B0748BEB6B629CE643AE60DB97285@dggemm513-mbs.china.huawei.com>
References: <1608892525-21384-1-git-send-email-wangyunjian@huawei.com>
 <4b056799-b330-cff1-963c-24ca138817a2@huawei.com>
In-Reply-To: <4b056799-b330-cff1-963c-24ca138817a2@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.243.127]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaXV5b25nbG9uZw0KPiBTZW50
OiBTYXR1cmRheSwgRGVjZW1iZXIgMjYsIDIwMjAgMjozOSBQTQ0KPiBUbzogd2FuZ3l1bmppYW4g
PHdhbmd5dW5qaWFuQGh1YXdlaS5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBa
aHVhbmd5dXplbmcgKFlpc2VuKSA8eWlzZW4uemh1YW5nQGh1YXdlaS5jb20+OyBTYWxpbCBNZWh0
YQ0KPiA8c2FsaWwubWVodGFAaHVhd2VpLmNvbT47IExpbGlqdW4gKEplcnJ5KSA8amVycnkubGls
aWp1bkBodWF3ZWkuY29tPjsNCj4geHVkaW5na2UgPHh1ZGluZ2tlQGh1YXdlaS5jb20+DQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggbmV0XSBuZXQ6IGhuczogZml4IHJldHVybiB2YWx1ZSBjaGVjayBp
bg0KPiBfX2xiX290aGVyX3Byb2Nlc3MoKQ0KPiANCj4gDQo+IE9uIDIwMjAvMTIvMjUgMTg6MzUs
IHdhbmd5dW5qaWFuIHdyb3RlOg0KPiA+IEZyb206IFl1bmppYW4gV2FuZyA8d2FuZ3l1bmppYW5A
aHVhd2VpLmNvbT4NCj4gPg0KPiA+IFRoZSBmdW5jdGlvbiBza2JfY29weSgpIGNvdWxkIHJldHVy
biBOVUxMLCB0aGUgcmV0dXJuIHZhbHVlIG5lZWQgdG8gYmUNCj4gPiBjaGVja2VkLg0KPiA+DQo+
ID4gRml4ZXM6IGI1OTk2ZjExZWE1NCAoIm5ldDogYWRkIEhpc2lsaWNvbiBOZXR3b3JrIFN1YnN5
c3RlbSBiYXNpYw0KPiA+IGV0aGVybmV0IHN1cHBvcnQiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFl1
bmppYW4gV2FuZyA8d2FuZ3l1bmppYW5AaHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGRyaXZl
cnMvbmV0L2V0aGVybmV0L2hpc2lsaWNvbi9obnMvaG5zX2V0aHRvb2wuYyB8IDQgKysrKw0KPiA+
ICAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2hpc2lsaWNvbi9obnMvaG5zX2V0aHRvb2wuYw0KPiA+IGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2hucy9obnNfZXRodG9vbC5jDQo+ID4gaW5k
ZXggNzE2NWRhMGVlOWFhLi5hZDE4ZjBlMjBhMjMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvaGlzaWxpY29uL2hucy9obnNfZXRodG9vbC5jDQo+ID4gKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2hucy9obnNfZXRodG9vbC5jDQo+ID4gQEAgLTQxNSw2
ICs0MTUsMTAgQEAgc3RhdGljIHZvaWQgX19sYl9vdGhlcl9wcm9jZXNzKHN0cnVjdA0KPiBobnNf
bmljX3JpbmdfZGF0YSAqcmluZ19kYXRhLA0KPiA+ICAgCS8qIGZvciBtdXRsIGJ1ZmZlciovDQo+
ID4gICAJbmV3X3NrYiA9IHNrYl9jb3B5KHNrYiwgR0ZQX0FUT01JQyk7DQo+ID4gICAJZGV2X2tm
cmVlX3NrYl9hbnkoc2tiKTsNCj4gPiArCWlmICghbmV3X3NrYikgew0KPiANCj4gPiArCQluZGV2
LT5zdGF0cy5yeF9kcm9wcGVkKys7DQo+IFlvdSBjYW4gYWRkIGEgbmV3IGRyb3AgdHlwZSB0byBy
aW5nLT5zdGF0ZXMsIGFuZCB0aGVuIGFkZCBpdCB0bw0KPiBuZGV2LT5zdGF0cy5yeF9kcm9wcGVk
LA0KPiANCj4gdGhlbiB5b3UgY2FuIGtub3cgdGhhdCB0aGUgcnhfZHJvcHBlZCBpcyBmcm9tIHNr
Yl9jb3B5KCkgZmFpbGVkLg0KPiANCj4gVGhpcyBwcm9jZXNzIGlzIGZyb20gc2VsZi10ZXN0LCBt
YXliZSB5b3UgY2FuIGp1c3QgYWRkIGEgZXJyb3IgbWVzc2FnZSByYXRoZXINCj4gdGhhbiBpbmNy
ZWFzZQ0KDQpUaGFua3MgZm9yIHlvdXIgc3VnZ2VzdGlvbiwgSSB3aWxsIHVwZGF0ZSBpdCBpbiBu
ZXh0IHZlcnNpb24uDQoNCj4gDQo+IHRoZSBuZGV2LT5zdGF0cy5yeF9kcm9wcGVkLg0KPiANCj4g
DQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsJfQ0KPiA+ICAgCXNrYiA9IG5ld19za2I7DQo+ID4NCj4g
PiAgIAljaGVja19vayA9IDA7DQoNCg==

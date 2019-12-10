Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAAE3117E38
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 04:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfLJDhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 22:37:11 -0500
Received: from mail-eopbgr760131.outbound.protection.outlook.com ([40.107.76.131]:2742
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726890AbfLJDhJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 22:37:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+Vbuz5mgbk7JTcPtK7BZ1WKaPqEubAyYz5NI4cbZYxsD4QguR7WgcEhituIeAATg44johrKGo+7wCAPgecNPQReynw0QB3wpdAPsUWeQ9dioL31t/gZRvAC2MshSHtI8FE4dDdfue4Goy353MVH/zy455zOdIm/6XxtYoBhjVx/Xqx5BHswJg1rg455cVhX0QP7Q8+ZW83o2V5LMW5A4TfAqNmy4wZ6cLt5Lgk1HlWDStZsr0p4WWUQousZ4nVhW1X1yK5Zl5yKy+Al8vpBg0ahSFkgtvTlmUderYNpzl08Zvt+HeOt2veq/4LkPfaKPx6JLTj22Z/gE4lEIFeStw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gps5WYXhjtM/NfSp8Qhiu1bY6vFbcv6mKm+oXz2H+UQ=;
 b=JBhhUN5pxdYzsWDcCXsx2Rc4WUHuI6gfw8gWZiTU1MryDQbqc57QuGqQWhjjvX2YF9rIEhGa5hCL4gUwU9ePvLSUiOyoZ/yP4P6QQRiJkkwIPaz7DW/fSpjZH/AsPqeULXkuEutpS/OagwlJYgjqOn3PIOr/HfbP1Mdc5kSSMHSEyZiASGT1a427jhj2n76uAGKJHlG8A1+QtlbbqT/RHfOX02DrBdOpPpM4KlYch4GCfVhegziqcnLtWsuNAfe2TGDfWLdz3pqylPvyE2rjRHhl2MT7diPw8UhJPlZS+BN/oA4mTBaTjJagXvPnI6QScL7YU/okTk77kOmfsJyOfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gps5WYXhjtM/NfSp8Qhiu1bY6vFbcv6mKm+oXz2H+UQ=;
 b=a1ShOyIDwXmc4B/MCrwVnd1qUIQIETvXhmaz8XG+YWEHebhCzR1aOHlicru4DHbb6Vua9maAT5tQM1DoJlK7Y0u/XVr25kVeLDKy7zG9VnwheFNrDhrM2S5uFjE6EYYA5JRPwsEA1ou6nQnGCYzPd86LsC6KY0PZVbz1fLFr3+o=
Received: from CY4PR06MB2342.namprd06.prod.outlook.com (10.169.185.149) by
 CY4PR06MB2646.namprd06.prod.outlook.com (10.173.39.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Tue, 10 Dec 2019 03:37:07 +0000
Received: from CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d]) by CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d%3]) with mapi id 15.20.2538.012; Tue, 10 Dec 2019
 03:37:07 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Soeren Moch <smoch@web.de>, Kalle Valo <kvalo@codeaurora.org>
CC:     Stanley Hsu <Stanley.Hsu@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] brcmfmac: set F2 blocksize and watermark for 4359
Thread-Topic: [PATCH 2/8] brcmfmac: set F2 blocksize and watermark for 4359
Thread-Index: AQHVruFjv3ucH6ysDkuWKeHilwQoR6eyuGeA
Date:   Tue, 10 Dec 2019 03:37:07 +0000
Message-ID: <541616d9-78ca-81b2-d785-5ec389265bd1@cypress.com>
References: <20191209223822.27236-1-smoch@web.de>
 <20191209223822.27236-2-smoch@web.de>
In-Reply-To: <20191209223822.27236-2-smoch@web.de>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-clientproxiedby: BYAPR06CA0014.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::27) To CY4PR06MB2342.namprd06.prod.outlook.com
 (2603:10b6:903:13::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ce09ed2a-b304-4d9a-9c0a-08d77d223ae3
x-ms-traffictypediagnostic: CY4PR06MB2646:|CY4PR06MB2646:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR06MB26469A46C2A521BEAC8740DABB5B0@CY4PR06MB2646.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39860400002)(136003)(189003)(199004)(8936002)(36756003)(6512007)(316002)(2906002)(2616005)(3450700001)(305945005)(31696002)(81166006)(4326008)(81156014)(66446008)(186003)(31686004)(8676002)(64756008)(53546011)(66556008)(66476007)(66946007)(6506007)(478600001)(54906003)(52116002)(26005)(110136005)(229853002)(86362001)(6486002)(5660300002)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR06MB2646;H:CY4PR06MB2342.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h6HmoWeK+CGG+F3Wg3iTM+lknJNBfVsITyb0cdfJHa22YnQkhY2/CgWbI6+R3FLwT05L7coEoI2S9Yn0IWdt6kJpBHJXS2y0HA+6oZla5BNTxTc0Oegi0gpte04pc3Ef8wFaQFwQIULK+1Z1VJZGtZ5aABbaHGESpxSaqJRw9ZGBSy6rEEyL8yVi+TeOXp5dW1BMHCpbWWADaZq/J0L+T7hK0sVU6BQpAjcKbgb97UCU+qID+RVFBUNPQSR27yeJa2a6HnZlYJmwJDijZtyS7WYnT4YjLskNV1PHHs/6NM+g6CRnTQjLWzte3E7ZF0Fne7jHm/kXYI0E7euQyMJzc2cTcc7MYuiDvJ2W+N2rPSu0fkyEYbgmeOIi4yN4YKr7Z7UGfg8zEk3i59CEYBnBtsz/bl4Vyfs4L/YYH+DS66/UnTMyRmPDktMSyMSnZvCd
Content-Type: text/plain; charset="utf-8"
Content-ID: <D352CDE1AA4FFB48AA702BA45DBA288F@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce09ed2a-b304-4d9a-9c0a-08d77d223ae3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 03:37:07.1577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qoy8STYyUeiygFuyN5soMm2HEkDnv0WhVMGHC1q4eD9H/05INbaDZ9YQDnmTgmOxCg85KCGpeAVqIiZmyDNpxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR06MB2646
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEwLzIwMTkgNjozOCwgU29lcmVuIE1vY2ggd3JvdGU6DQo+IEZyb206IENodW5n
LUhzaWVuIEhzdSA8c3RhbmxleS5oc3VAY3lwcmVzcy5jb20+DQo+IA0KPiBTZXQgRjIgYmxvY2tz
aXplIHRvIDI1NiBieXRlcyBhbmQgd2F0ZXJtYXJrIHRvIDB4NDAgZm9yIDQzNTkuIEFsc28NCj4g
ZW5hYmxlIGFuZCBjb25maWd1cmUgRjEgTWVzQnVzeUN0cmwuIEl0IGZpeGVzIERNQSBlcnJvciB3
aGlsZSBoYXZpbmcNCj4gVURQIGJpLWRpcmVjdGlvbmFsIHRyYWZmaWMuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBDaHVuZy1Ic2llbiBIc3UgPHN0YW5sZXkuaHN1QGN5cHJlc3MuY29tPg0KPiBbc2xp
Z2h0bHkgYWRhcHRlZCBmb3IgcmViYXNlIG9uIG1haW5saW5lIGxpbnV4XQ0KPiBTaWduZWQtb2Zm
LWJ5OiBTb2VyZW4gTW9jaCA8c21vY2hAd2ViLmRlPg0KUmV2aWV3ZWQtYnk6IENoaS1Ic2llbiBM
aW4gPGNoaS1oc2llbi5saW5AY3lwcmVzcy5jb20+DQoNCj4gLS0tDQo+IENjOiBLYWxsZSBWYWxv
IDxrdmFsb0Bjb2RlYXVyb3JhLm9yZz4NCj4gQ2M6IEFyZW5kIHZhbiBTcHJpZWwgPGFyZW5kLnZh
bnNwcmllbEBicm9hZGNvbS5jb20+DQo+IENjOiBGcmFua3kgTGluIDxmcmFua3kubGluQGJyb2Fk
Y29tLmNvbT4NCj4gQ2M6IEhhbnRlIE1ldWxlbWFuIDxoYW50ZS5tZXVsZW1hbkBicm9hZGNvbS5j
b20+DQo+IENjOiBDaGktSHNpZW4gTGluIDxjaGktaHNpZW4ubGluQGN5cHJlc3MuY29tPg0KPiBD
YzogV3JpZ2h0IEZlbmcgPHdyaWdodC5mZW5nQGN5cHJlc3MuY29tPg0KPiBDYzogbGludXgtd2ly
ZWxlc3NAdmdlci5rZXJuZWwub3JnDQo+IENjOiBicmNtODAyMTEtZGV2LWxpc3QucGRsQGJyb2Fk
Y29tLmNvbQ0KPiBDYzogYnJjbTgwMjExLWRldi1saXN0QGN5cHJlc3MuY29tDQo+IENjOiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+
IC0tLQ0KPiAgIC4uLi93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvYmNtc2Ro
LmMgfCAgNiArKysrKy0NCj4gICAuLi4vd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21m
bWFjL3NkaW8uYyAgIHwgMTUgKysrKysrKysrKysrKysrDQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCAy
MCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNkaC5jIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNkaC5jDQo+
IGluZGV4IDk2ZmQ4ZTJiZjc3My4uNjhiYWYwMTg5MzA1IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvYmNtc2RoLmMNCj4gKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNk
aC5jDQo+IEBAIC00Myw2ICs0Myw3IEBADQo+IA0KPiAgICNkZWZpbmUgU0RJT19GVU5DMV9CTE9D
S1NJWkUJCTY0DQo+ICAgI2RlZmluZSBTRElPX0ZVTkMyX0JMT0NLU0laRQkJNTEyDQo+ICsjZGVm
aW5lIFNESU9fNDM1OV9GVU5DMl9CTE9DS1NJWkUJMjU2DQo+ICAgLyogTWF4aW11bSBtaWxsaXNl
Y29uZHMgdG8gd2FpdCBmb3IgRjIgdG8gY29tZSB1cCAqLw0KPiAgICNkZWZpbmUgU0RJT19XQUlU
X0YyUkRZCTMwMDANCj4gDQo+IEBAIC05MDMsNiArOTA0LDcgQEAgc3RhdGljIHZvaWQgYnJjbWZf
c2Rpb2RfaG9zdF9maXh1cChzdHJ1Y3QgbW1jX2hvc3QgKmhvc3QpDQo+ICAgc3RhdGljIGludCBi
cmNtZl9zZGlvZF9wcm9iZShzdHJ1Y3QgYnJjbWZfc2Rpb19kZXYgKnNkaW9kZXYpDQo+ICAgew0K
PiAgIAlpbnQgcmV0ID0gMDsNCj4gKwl1bnNpZ25lZCBpbnQgZjJfYmxrc3ogPSBTRElPX0ZVTkMy
X0JMT0NLU0laRTsNCj4gDQo+ICAgCXNkaW9fY2xhaW1faG9zdChzZGlvZGV2LT5mdW5jMSk7DQo+
IA0KPiBAQCAtOTEyLDcgKzkxNCw5IEBAIHN0YXRpYyBpbnQgYnJjbWZfc2Rpb2RfcHJvYmUoc3Ry
dWN0IGJyY21mX3NkaW9fZGV2ICpzZGlvZGV2KQ0KPiAgIAkJc2Rpb19yZWxlYXNlX2hvc3Qoc2Rp
b2Rldi0+ZnVuYzEpOw0KPiAgIAkJZ290byBvdXQ7DQo+ICAgCX0NCj4gLQlyZXQgPSBzZGlvX3Nl
dF9ibG9ja19zaXplKHNkaW9kZXYtPmZ1bmMyLCBTRElPX0ZVTkMyX0JMT0NLU0laRSk7DQo+ICsJ
aWYgKHNkaW9kZXYtPmZ1bmMyLT5kZXZpY2UgPT0gU0RJT19ERVZJQ0VfSURfQlJPQURDT01fNDM1
OSkNCj4gKwkJZjJfYmxrc3ogPSBTRElPXzQzNTlfRlVOQzJfQkxPQ0tTSVpFOw0KPiArCXJldCA9
IHNkaW9fc2V0X2Jsb2NrX3NpemUoc2Rpb2Rldi0+ZnVuYzIsIGYyX2Jsa3N6KTsNCj4gICAJaWYg
KHJldCkgew0KPiAgIAkJYnJjbWZfZXJyKCJGYWlsZWQgdG8gc2V0IEYyIGJsb2Nrc2l6ZVxuIik7
DQo+ICAgCQlzZGlvX3JlbGVhc2VfaG9zdChzZGlvZGV2LT5mdW5jMSk7DQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvc2Rpby5j
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3NkaW8u
Yw0KPiBpbmRleCAyNjRhZDYzMjMyZjguLjIxZTUzNTA3MmYzZiAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3NkaW8uYw0KPiAr
KysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvc2Rp
by5jDQo+IEBAIC00Miw2ICs0Miw4IEBADQo+ICAgI2RlZmluZSBERUZBVUxUX0YyX1dBVEVSTUFS
SyAgICAweDgNCj4gICAjZGVmaW5lIENZXzQzNzNfRjJfV0FURVJNQVJLICAgIDB4NDANCj4gICAj
ZGVmaW5lIENZXzQzMDEyX0YyX1dBVEVSTUFSSyAgICAweDYwDQo+ICsjZGVmaW5lIENZXzQzNTlf
RjJfV0FURVJNQVJLCTB4NDANCj4gKyNkZWZpbmUgQ1lfNDM1OV9GMV9NRVNCVVNZQ1RSTAkoQ1lf
NDM1OV9GMl9XQVRFUk1BUksgfCBTQlNESU9fTUVTQlVTWUNUUkxfRU5BQikNCj4gDQo+ICAgI2lm
ZGVmIERFQlVHDQo+IA0KPiBAQCAtNDIwNSw2ICs0MjA3LDE5IEBAIHN0YXRpYyB2b2lkIGJyY21m
X3NkaW9fZmlybXdhcmVfY2FsbGJhY2soc3RydWN0IGRldmljZSAqZGV2LCBpbnQgZXJyLA0KPiAg
IAkJCWJyY21mX3NkaW9kX3dyaXRlYihzZGlvZCwgU0JTRElPX0RFVklDRV9DVEwsIGRldmN0bCwN
Cj4gICAJCQkJCSAgICZlcnIpOw0KPiAgIAkJCWJyZWFrOw0KPiArCQljYXNlIFNESU9fREVWSUNF
X0lEX0JST0FEQ09NXzQzNTk6DQo+ICsJCQlicmNtZl9kYmcoSU5GTywgInNldCBGMiB3YXRlcm1h
cmsgdG8gMHgleCo0IGJ5dGVzXG4iLA0KPiArCQkJCSAgQ1lfNDM1OV9GMl9XQVRFUk1BUkspOw0K
PiArCQkJYnJjbWZfc2Rpb2Rfd3JpdGViKHNkaW9kLCBTQlNESU9fV0FURVJNQVJLLA0KPiArCQkJ
CQkgICBDWV80MzU5X0YyX1dBVEVSTUFSSywgJmVycik7DQo+ICsJCQlkZXZjdGwgPSBicmNtZl9z
ZGlvZF9yZWFkYihzZGlvZCwgU0JTRElPX0RFVklDRV9DVEwsDQo+ICsJCQkJCQkgICAmZXJyKTsN
Cj4gKwkJCWRldmN0bCB8PSBTQlNESU9fREVWQ1RMX0YyV01fRU5BQjsNCj4gKwkJCWJyY21mX3Nk
aW9kX3dyaXRlYihzZGlvZCwgU0JTRElPX0RFVklDRV9DVEwsIGRldmN0bCwNCj4gKwkJCQkJICAg
JmVycik7DQo+ICsJCQlicmNtZl9zZGlvZF93cml0ZWIoc2Rpb2QsIFNCU0RJT19GVU5DMV9NRVNC
VVNZQ1RSTCwNCj4gKwkJCQkJICAgQ1lfNDM1OV9GMV9NRVNCVVNZQ1RSTCwgJmVycik7DQo+ICsJ
CQlicmVhazsNCj4gICAJCWRlZmF1bHQ6DQo+ICAgCQkJYnJjbWZfc2Rpb2Rfd3JpdGViKHNkaW9k
LCBTQlNESU9fV0FURVJNQVJLLA0KPiAgIAkJCQkJICAgREVGQVVMVF9GMl9XQVRFUk1BUkssICZl
cnIpOw0KPiAtLQ0KPiAyLjE3LjENCj4gDQo+IC4NCj4gDQo=

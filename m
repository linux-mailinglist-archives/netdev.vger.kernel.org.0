Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138E8E03A
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfD2KFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:05:20 -0400
Received: from mail-eopbgr810055.outbound.protection.outlook.com ([40.107.81.55]:40164
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727428AbfD2KFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:05:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BmoivSjZyBAfKwDOP8AwwKF7QxqL+U/XjV2FrB3kPk=;
 b=nc/3yQ2zduHQGKbJQLDtc8tLPzW6c6iNKNVFYdknUKS8jhiPxYxaMZEi69zUSOx4KOr9Y2d1bhNJ0oN7Rs36z4KB+9bzS4F8C2JNMCpa0cYcyONFMcZ2/JqsbtzQzSVp30bVHyzm+QGoSWpPFZDn7f2RxUN3fLjYyV1OLpadCc4=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3644.namprd11.prod.outlook.com (20.178.230.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 10:04:33 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653%3]) with mapi id 15.20.1835.010; Mon, 29 Apr 2019
 10:04:33 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v4 net-next 00/15] net: atlantic: Aquantia driver updates
 2019-04
Thread-Topic: [PATCH v4 net-next 00/15] net: atlantic: Aquantia driver updates
 2019-04
Thread-Index: AQHU/nLxTOEJbku52ESen0jqxDkmHw==
Date:   Mon, 29 Apr 2019 10:04:33 +0000
Message-ID: <cover.1556531633.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0189.eurprd05.prod.outlook.com
 (2603:10a6:3:f9::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c0a0968-f206-4a74-3586-08d6cc8a13e0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3644;
x-ms-traffictypediagnostic: DM6PR11MB3644:
x-microsoft-antispam-prvs: <DM6PR11MB36445D71B13AA369A86EBF2698390@DM6PR11MB3644.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(376002)(396003)(39840400004)(189003)(199004)(6512007)(2906002)(5660300002)(71200400001)(6486002)(99286004)(53936002)(26005)(25786009)(44832011)(71190400001)(14454004)(50226002)(4326008)(3846002)(66556008)(64756008)(66446008)(36756003)(8936002)(73956011)(72206003)(66946007)(54906003)(66476007)(7736002)(6116002)(6436002)(81166006)(86362001)(6506007)(478600001)(81156014)(8676002)(97736004)(305945005)(107886003)(386003)(316002)(68736007)(102836004)(6916009)(476003)(186003)(2616005)(486006)(256004)(52116002)(66066001)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3644;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XIJleLhZPUgJYjnQDHo9ut3MXjyfbyxjrHwC9EqMDC7leCfhn5nHFUIwK39ghc5Ok6GitN1oCv7JJ96q+IIc0B1cPbooy7bfpR6CJwoHlLzKu4DBdOk3P9rJGpty6upJcM+ovM8ZlN9+Zjnz6s4p16siAaMlAJ+YkytTp745OGAIPe6xaqPq4PmYOutAlG2eecGzeTMRcj+tIEdmMYSt2awz7W5aEvRr3pYcRPZo5pWzBdcwtmmVBHZjeJu/4TwtIMTUmHFCLaKYA62C3usieHy7aGW+KKQBK6DAVRdOdxgm2VxnM+lleiBVLRZIlcadHK91MyE3H/GBT0+5iTL/4N3u9IK69Imk7k4n0i6HR2fudS/mbj0biEjdX6dla7EfwNcvSFzEwdqYB7ABGPipwZLJOD3u7bxFY68wRsHjrKo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c0a0968-f206-4a74-3586-08d6cc8a13e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 10:04:33.5161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3644
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBwYXRjaHNldCBjb250YWlucyB2YXJpb3VzIGltcHJvdmVtZW50czoNCg0KLSBXb3JrIHRh
cmdldGluZyBsaW5rIHVwIHNwZWVkdXBzOiBsaW5rIGludGVycnVwdCBpbnRyb2R1Y2VkLCBzb21l
IG90aGVyIA0KICBsb2dpYyBjaGFuZ2VzIHRvIGltcm92ZSB0aGlzLg0KLSBGVyBvcGVyYXRpb25z
IHNlY3VyaW5nIHdpdGggbXV0ZXgNCi0gQ291bnRlcnMgYW5kIHN0YXRpc3RpY3MgbG9naWMgaW1w
cm92ZWQgYnkgRG1pdHJ5DQotIHJlYWQgb3V0IG9mIGNoaXAgdGVtcGVyYXR1cmUgdmlhIGh3bW9u
IGludGVyZmFjZSBpbXBsZW1lbnRlZCBieQ0KICBZYW5hIGFuZCBOaWtpdGEuDQoNCnY0IGNoYW5n
ZXM6DQotIHJlbW92ZSBkcnZpbmZvX2V4aXQgbm9vcA0KLSA2NGJpdCBzdGF0cyBzaG91bGQgYmUg
cmVhZGVkIG91dCBzZXF1ZW50aWFsbHkgKGxzdywgdGhlbiBtc3cpDQogIGRlY2xhcmUgNjRiaXQg
cmVhZCBvcHMgZm9yIHRoYXQNCg0KdjMgY2hhbmdlczoNCi0gdGVtcCBvcHMgcmVuYW1lZCB0byBw
aHlfdGVtcCBvcHMNCi0gbXV0ZXggY29tbWl0cyBzcXVhc2hlZCBmb3IgYmV0dGVyIHN0cnVjdHVy
ZQ0KDQp2MiBjaGFuZ2VzOg0KLSB1c2UgdGhyZWFkZWQgaXJxIGZvciBsaW5rIHN0YXRlIGhhbmRs
aW5nDQotIHJld29yayBod21vbiB2aWEgZGV2bV9od21vbl9kZXZpY2VfcmVnaXN0ZXJfd2l0aF9p
bmZvDQpFeHRyYSBjb21tZW50cyBvbiByZXZpZXcgZnJvbSBBbmRyZXc6DQotIGRpcmVjdCBkZXZp
Y2UgbmFtZSBwb2ludGVyIGlzIHVzZWQgaW4gaHdtb24gcmVnaXN0cmF0aW9uLg0KICBUaGlzIGNh
dXNlcyBod21vbiBkZXZpY2UgdG8gZGVyaXZlIHBvc3NpYmxlIGludGVyZmFjZSBuYW1lIGNoYW5n
ZXMNCi0gV2lsbCBjb25zaWRlciBzYW5pdHkgY2hlY2tzIGZvciBmaXJtd2FyZSBtdXRleCBsb2Nr
IHNlcGFyYXRlbHkuDQogIFJpZ2h0IG5vdyB0aGVyZSBpcyBubyBzaW5nbGUgcG9pbnQgZXhzaXN0
cyB3aGVyZSBzdWNoIGNoZWNrIGNvdWxkDQogIGJlIGVhc2lseSBhZGRlZC4NCi0gVGhlcmUgaXMg
bm8gd2F5IG5vdyB0byBmZXRjaCBhbmQgY29uZmlndXJlIG1pbi9tYXgvY3JpdCB0ZW1wZXJhdHVy
ZXMNCiAgdmlhIEZXLiBXaWxsIGludmVzdGlnYXRlIHRoaXMgc2VwYXJhdGVseS4NCg0KRG1pdHJ5
IEJvZ2Rhbm92ICgzKToNCiAgbmV0OiBhcXVhbnRpYTogZmV0Y2ggdXAgdG8gZGF0ZSBzdGF0aXN0
aWNzIG9uIGV0aHRvb2wgcmVxdWVzdA0KICBuZXQ6IGFxdWFudGlhOiBnZXQgdG90YWwgY291bnRl
cnMgZnJvbSBETUEgYmxvY2sNCiAgbmV0OiBhcXVhbnRpYTogZml4dXBzIG9uIDY0Yml0IGRtYSBj
b3VudGVycw0KDQpJZ29yIFJ1c3NraWtoICg3KToNCiAgbmV0OiBhcXVhbnRpYTogYWRkIGxpbmsg
aW50ZXJydXB0IGZpZWxkcw0KICBuZXQ6IGFxdWFudGlhOiBsaW5rIGludGVycnVwdCBoYW5kbGlu
ZyBmdW5jdGlvbg0KICBuZXQ6IGFxdWFudGlhOiBsaW5rIHN0YXR1cyBpcnEgaGFuZGxpbmcNCiAg
bmV0OiBhcXVhbnRpYTogaW1wcm92ZSBpZnVwIGxpbmsgZGV0ZWN0aW9uDQogIG5ldDogYXF1YW50
aWE6IHVzZSBtYWNyb3MgZm9yIGJldHRlciB2aXNpYmlsaXR5DQogIG5ldDogYXF1YW50aWE6IHVz
ZXIgY29ycmVjdCBNU0kgaXJxIHR5cGUNCiAgbmV0OiBhcXVhbnRpYTogZXh0cmFjdCB0aW1lciBj
YiBpbnRvIHdvcmsgam9iDQoNCk5pa2l0YSBEYW5pbG92ICgzKToNCiAgbmV0OiBhcXVhbnRpYTog
Y3JlYXRlIGdsb2JhbCBzZXJ2aWNlIHdvcmtxdWV1ZQ0KICBuZXQ6IGFxdWFudGlhOiBpbnRyb2R1
Y2UgZndyZXEgbXV0ZXgNCiAgbmV0OiBhcXVhbnRpYTogcmVtb3ZlIG91dGRhdGVkIGRldmljZSBp
ZHMNCg0KWWFuYSBFc2luYSAoMik6DQogIG5ldDogYXF1YW50aWE6IGFkZCBpbmZyYXN0cnVjdHVy
ZSB0byByZWFkb3V0IGNoaXAgdGVtcGVyYXR1cmUNCiAgbmV0OiBhcXVhbnRpYTogaW1wbGVtZW50
IGh3bW9uIGFwaSBmb3IgY2hpcCB0ZW1wZXJhdHVyZQ0KDQogLi4uL25ldC9ldGhlcm5ldC9hcXVh
bnRpYS9hdGxhbnRpYy9NYWtlZmlsZSAgIHwgICAxICsNCiAuLi4vZXRoZXJuZXQvYXF1YW50aWEv
YXRsYW50aWMvYXFfY29tbW9uLmggICAgfCAgIDMgLQ0KIC4uLi9ldGhlcm5ldC9hcXVhbnRpYS9h
dGxhbnRpYy9hcV9kcnZpbmZvLmMgICB8IDEyNSArKysrKysrKysrKysrKysrKysNCiAuLi4vZXRo
ZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfZHJ2aW5mby5oICAgfCAgMTUgKysrDQogLi4uL2V0
aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2V0aHRvb2wuYyAgIHwgIDIyICsrLQ0KIC4uLi9u
ZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfaHcuaCAgICB8ICAgNCArDQogLi4uL2V0
aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2h3X3V0aWxzLmMgIHwgIDEyICsrDQogLi4uL2V0
aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2h3X3V0aWxzLmggIHwgICAxICsNCiAuLi4vbmV0
L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX21haW4uYyAgfCAgNDEgKysrKysrDQogLi4u
L25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9tYWluLmggIHwgICAyICsNCiAuLi4v
bmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX25pYy5jICAgfCAxMjAgKysrKysrKysr
KysrKy0tLS0NCiAuLi4vbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX25pYy5oICAg
fCAgIDYgKy0NCiAuLi4vZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfcGNpX2Z1bmMuYyAg
fCAgNDggKysrKy0tLQ0KIC4uLi9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9wY2lfZnVu
Yy5oICB8ICAgNyArLQ0KIC4uLi9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX2EwLmMg
ICAgICB8ICAgOCArLQ0KIC4uLi9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX2IwLmMg
ICAgICB8ICAxMyArLQ0KIC4uLi9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX2IwLmgg
ICAgICB8ICAgMyAtDQogLi4uL2FxdWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfbGxoLmMg
ICAgIHwgIDQxICsrLS0tLQ0KIC4uLi9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX2xs
aC5oICAgICB8ICAzMSArKy0tLQ0KIC4uLi9hdGxhbnRpYy9od19hdGwvaHdfYXRsX2xsaF9pbnRl
cm5hbC5oICAgICB8ICAgMyAtDQogLi4uL2FxdWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxf
dXRpbHMuYyAgIHwgIDEzICstDQogLi4uL2F0bGFudGljL2h3X2F0bC9od19hdGxfdXRpbHNfZncy
eC5jICAgICAgIHwgIDM2ICsrKysrDQogMjIgZmlsZXMgY2hhbmdlZCwgNDI3IGluc2VydGlvbnMo
KyksIDEyOCBkZWxldGlvbnMoLSkNCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfZHJ2aW5mby5jDQogY3JlYXRlIG1vZGUgMTAwNjQ0
IGRyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2RydmluZm8uaA0KDQot
LSANCjIuMTcuMQ0KDQo=

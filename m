Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1969B4DD4F
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 00:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfFTWOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 18:14:02 -0400
Received: from mail-eopbgr820119.outbound.protection.outlook.com ([40.107.82.119]:10528
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725906AbfFTWOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 18:14:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWzdlavCEd0P3JZYnoDm2oqib+erQfZHwIUxNVzNDoA=;
 b=ROirZebhxdy7w51Wqgtjo477v/2qENKxNVsiLph/GK2v+PyOMxKE4Z3fPeNxe+muIKDzYarD2diAydVl1DKNs9RYoZUw70zF1KuQWp0C1n7g+JG96LzobWd10gbdl0h/ktvP3X+MvCD3quiTHYtesW3ZQywaegkUoQSO3zw/VSE=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1391.namprd22.prod.outlook.com (10.172.62.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Thu, 20 Jun 2019 22:13:58 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40%2]) with mapi id 15.20.2008.007; Thu, 20 Jun 2019
 22:13:58 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     "Maciej W. Rozycki" <macro@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paul Burton <pburton@wavecomp.com>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] FDDI: defza: Include linux/io-64-nonatomic-lo-hi.h
Thread-Topic: [PATCH] FDDI: defza: Include linux/io-64-nonatomic-lo-hi.h
Thread-Index: AQHVJ7V1UXxjnCnLE027KWvd1IREUQ==
Date:   Thu, 20 Jun 2019 22:13:58 +0000
Message-ID: <20190620221224.27352-1-paul.burton@mips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0048.namprd08.prod.outlook.com
 (2603:10b6:a03:117::25) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.22.0
x-originating-ip: [73.93.153.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58195c12-72c0-4e4b-18aa-08d6f5cc9778
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1391;
x-ms-traffictypediagnostic: MWHPR2201MB1391:
x-microsoft-antispam-prvs: <MWHPR2201MB1391BC73B4635D016D3408DBC1E40@MWHPR2201MB1391.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(136003)(376002)(346002)(39840400004)(52314003)(199004)(189003)(14454004)(8676002)(2906002)(81166006)(73956011)(81156014)(68736007)(3846002)(6116002)(256004)(66446008)(14444005)(64756008)(66476007)(66946007)(66556008)(6436002)(2501003)(71190400001)(71200400001)(6486002)(4326008)(36756003)(478600001)(50226002)(8936002)(6512007)(53936002)(44832011)(42882007)(316002)(52116002)(5660300002)(186003)(66066001)(110136005)(1076003)(2616005)(476003)(99286004)(486006)(54906003)(102836004)(26005)(305945005)(6506007)(386003)(25786009)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1391;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cOKlyUGsen76MduLyC3kuj/PZRAWvZqNIlAfTqTNUbd5fKM0xjMHw7teUfqRoHM0v+ZjH5as56/3uf9DHrfa6CyjOEppLdgyO6X3mGaT02Gh5SGEMHNQpv4gu5d4uSbaH8i3GSHY7xGPjBEdjrt332KKfZQAu7+Kv1CGuqf/aOzYCqDbl5v5A5F3JMzfLOdxc5AQPAcYI8hL+T3cVp4+O32BBbiacKKwPKylQNm/3Xri5u6FazhF7CPCfYpNpIwjHc8gtwDnaDWIZea8lChQaYG/vxXmGCbph9JBNbnIP5un9teyEI6gY4MGTPhZm2tk9sUVlIhG8Rjl80ZeJSVr62+DffpteGm/BxIecIn5R0zMWMv13/ALggXcQ2V7XEiwEMm7xgT+VRB9scbqkUfl3yeRLb0oktR54L5oDmepf7Q=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58195c12-72c0-4e4b-18aa-08d6f5cc9778
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 22:13:58.6310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q3VycmVudGx5IGFyY2gvbWlwcy9pbmNsdWRlL2FzbS9pby5oIHByb3ZpZGVzIDY0YiBtZW1vcnkg
YWNjZXNzb3INCmZ1bmN0aW9ucyBzdWNoIGFzIHJlYWRxICYgd3JpdGVxIGV2ZW4gb24gTUlQUzMy
IHBsYXRmb3JtcyB3aGVyZSB0aG9zZQ0KYWNjZXNzb3JzIGNhbm5vdCBhY3R1YWxseSBwZXJmb3Jt
IGEgNjRiIG1lbW9yeSBhY2Nlc3MuIFRoZXkgaW5zdGVhZA0KQlVHKCkuIFRoaXMgaXMgdW5mb3J0
dW5hdGUgZm9yIGRyaXZlcnMgd2hpY2ggZWl0aGVyICNpZmRlZiBvbiB0aGUNCnByZXNlbmNlIG9m
IHRoZXNlIGFjY2Vzc29ycywgb3IgY2FuIGZ1bmN0aW9uIHdpdGggbm9uLWF0b21pYw0KaW1wbGVt
ZW50YXRpb25zIG9mIHRoZW0gZm91bmQgaW4gZWl0aGVyIGxpbnV4L2lvLTY0LW5vbmF0b21pYy1s
by1oaS5oIG9yDQpsaW51eC9pby02NC1ub25hdG9taWMtaGktbG8uaC4gQXMgc3VjaCB3ZSdyZSBw
cmVwYXJpbmcgdG8gcmVtb3ZlIHRoZQ0KZGVmaW5pdGlvbnMgb2YgdGhlc2UgNjRiIGFjY2Vzc29y
IGZ1bmN0aW9ucyBmb3IgTUlQUzMyIGtlcm5lbHMuDQoNCkluIHByZXBhcmF0aW9uIGZvciB0aGlz
LCBpbmNsdWRlIGxpbnV4L2lvLTY0LW5vbmF0b21pYy1sby1oaS5oIGluDQpkZWZ6YS5jIGluIG9y
ZGVyIHRvIHByb3ZpZGUgYSBub24tYXRvbWljIGltcGxlbWVudGF0aW9uIG9mIHRoZQ0KcmVhZHFf
cmVsYXhlZCAmIHdyaXRlcV9yZWxheGVkIGZ1bmN0aW9ucyB0aGF0IGFyZSB1c2VkIGJ5IHRoaXMg
Y29kZS4gSW4NCnByYWN0aWNlIHRoaXMgd2lsbCBoYXZlIG5vIHJ1bnRpbWUgZWZmZWN0LCBzaW5j
ZSB1c2Ugb2YgdGhlIDY0YiBhY2Nlc3Nvcg0KZnVuY3Rpb25zIGlzIGNvbmRpdGlvbmFsIHVwb24g
c2l6ZW9mKHVuc2lnbmVkIGxvbmcpID09IDgsIGllLiB1cG9uDQpDT05GSUdfNjRCSVQ9eS4gVGhp
cyBtZWFucyB0aGUgY2FsbHMgdG8gdGhlc2Ugbm9uLWF0b21pYyByZWFkcSAmIHdyaXRlcQ0KaW1w
bGVtZW50YXRpb25zIHdpbGwgYmUgb3B0aW1pemVkIG91dCBhbnl3YXksIGJ1dCB3ZSBuZWVkIHRo
ZWlyDQpkZWZpbml0aW9ucyB0byBrZWVwIHRoZSBjb21waWxlciBoYXBweS4NCg0KRm9yIDY0Yml0
IGtlcm5lbHMgdXNpbmcgdGhpcyBjb2RlIHRoaXMgY2hhbmdlIHNob3VsZCBhbHNvIGhhdmUgbm8g
ZWZmZWN0DQpiZWNhdXNlIGFzbS9pby5oIHdpbGwgY29udGludWUgdG8gcHJvdmlkZSB0aGUgZGVm
aW5pdGlvbnMgb2YNCnJlYWRxX3JlbGF4ZWQgJiB3cml0ZXFfcmVsYXhlZCwgd2hpY2ggbGludXgv
aW8tNjQtbm9uYXRvbWljLWxvLWhpLmgNCmNoZWNrcyBmb3IgYmVmb3JlIGRlZmluaW5nIGl0c2Vs
Zi4NCg0KU2lnbmVkLW9mZi1ieTogUGF1bCBCdXJ0b24gPHBhdWwuYnVydG9uQG1pcHMuY29tPg0K
Q2M6IFNlcmdlIFNlbWluIDxTZXJnZXkuU2VtaW5AdC1wbGF0Zm9ybXMucnU+DQpDYzogIk1hY2ll
aiBXLiBSb3p5Y2tpIiA8bWFjcm9AbGludXgtbWlwcy5vcmc+DQpDYzogIkRhdmlkIFMuIE1pbGxl
ciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQpDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KQ2M6
IGxpbnV4LW1pcHNAdmdlci5rZXJuZWwub3JnDQpDYzogbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZw0KLS0tDQpNYWNpZWosIERhdmlkLCBpZiB5b3UnZCBiZSBoYXBweSB0byBwcm92aWRlIGFu
IEFjayBzbyB0aGF0IEkgY2FuIHRha2UNCnRoaXMgdGhyb3VnaCB0aGUgbWlwcy1uZXh0IGJyYW5j
aCB0aGF0IHdvdWxkIGJlIGdyZWF0OyB0aGF0J2xsIGxldCBtZQ0KYXBwbHkgaXQgcHJpb3IgdG8g
dGhlIGFzbS9pby5oIGNoYW5nZS4NCi0tLQ0KIGRyaXZlcnMvbmV0L2ZkZGkvZGVmemEuYyB8IDEg
Kw0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZmRkaS9kZWZ6YS5jIGIvZHJpdmVycy9uZXQvZmRkaS9kZWZ6YS5jDQppbmRleCBjNWNh
ZThlNzRkYzQuLjA2MDcxMmM2NjZiZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2ZkZGkvZGVm
emEuYw0KKysrIGIvZHJpdmVycy9uZXQvZmRkaS9kZWZ6YS5jDQpAQCAtMzMsNiArMzMsNyBAQA0K
ICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+DQogI2luY2x1ZGUgPGxpbnV4L2ludGVycnVwdC5oPg0K
ICNpbmNsdWRlIDxsaW51eC9pby5oPg0KKyNpbmNsdWRlIDxsaW51eC9pby02NC1ub25hdG9taWMt
bG8taGkuaD4NCiAjaW5jbHVkZSA8bGludXgvaW9wb3J0Lmg+DQogI2luY2x1ZGUgPGxpbnV4L2tl
cm5lbC5oPg0KICNpbmNsdWRlIDxsaW51eC9saXN0Lmg+DQotLSANCjIuMjIuMA0KDQo=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 277E42B160
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 11:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfE0JgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 05:36:21 -0400
Received: from mail-eopbgr150118.outbound.protection.outlook.com ([40.107.15.118]:28801
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725973AbfE0JgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 05:36:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Aa47b3L+TwnlcL0hW+HPN14ixDJVRlDfebCUp7PA0Q=;
 b=ho2H+UZmoR2lV6P7ovfgC4JrmCfCA3QtJORRBk//HR1ZxrTcrXzyVEgrnIphzCh7NRw9jcv2fR83lwEV+SActK3U54+lX1NbURA5y53yPvqtOK7zhBVj9nqYS3uzwJDUDaIQs4ZOvJJoxjTV/OYhIN5BjgNkQnxirSv48esvXyY=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB1806.EURPRD10.PROD.OUTLOOK.COM (10.165.194.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.20; Mon, 27 May 2019 09:36:13 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 09:36:13 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>
Subject: reset value of MV88E6XXX_G1_IEEE_PRI
Thread-Topic: reset value of MV88E6XXX_G1_IEEE_PRI
Thread-Index: AQHVFG+fncWQ8lohfEiBAdvF6CsT7w==
Date:   Mon, 27 May 2019 09:36:13 +0000
Message-ID: <4e5592a2-bce3-127b-99e1-7fab00dc0511@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P189CA0015.EURP189.PROD.OUTLOOK.COM (2603:10a6:7:53::28)
 To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e0ac037-e923-45f4-466e-08d6e286c206
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB1806;
x-ms-traffictypediagnostic: VI1PR10MB1806:
x-microsoft-antispam-prvs: <VI1PR10MB1806431A4EED2F1E01B1F7978A1D0@VI1PR10MB1806.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(346002)(396003)(376002)(136003)(189003)(199004)(8936002)(8976002)(53936002)(386003)(6506007)(5660300002)(68736007)(31686004)(36756003)(110136005)(186003)(26005)(2906002)(42882007)(2616005)(476003)(52116002)(71200400001)(71190400001)(74482002)(486006)(6116002)(25786009)(478600001)(31696002)(81166006)(81156014)(7736002)(305945005)(316002)(256004)(99286004)(8676002)(102836004)(6512007)(66556008)(66476007)(73956011)(66946007)(6486002)(64756008)(66446008)(66066001)(6436002)(3846002)(14454004)(44832011)(4744005)(72206003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB1806;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KPgXkI63TE0ZdSUh0LrnGr4kkFx9BCI6yTpHprFVGcWqH2DbnKwLmEJTQtmmMdnikVHbt/whilXGUCK71KIN+oLSVLvXs3dIv0iPsnfBNaen+E1chsNtvpphA1dH9Urs24kpeGJI5k35dEytvsMP9LzVYF8cERCz45k+eZTF1dNp1qwXX6i11pKmY+KUwyPBNld2jVRzCml5Brxk14+L+fnDJ3/oZL9C+DYf0eU/arcy+KnqPG9ZYek1cBgd7RYwJn07bULkPnskBlivHQvgfspo/OT+hxxQNKeM5QRMU8vzDanUiFZqTc+1laLQ29SxBz5zhqDFczxYutNgY/LKDu1uqTT9vm0gIVu5aG7O8p1MGmGfdb+CR1sx14sM6BngCgqRPeoEa7imvtvhovX3mqzJlpMsmD9Kk8zDPDC0iGE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59EA931200400F46AD9AA9A00F87AF00@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e0ac037-e923-45f4-466e-08d6e286c206
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 09:36:13.2107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB1806
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkxvb2tpbmcgdGhyb3VnaCB0aGUgZGF0YSBzaGVldHMgY29tcGFyaW5nIHRoZSBtdjg4
ZTYyNDAgYW5kIDYyNTAsIEkNCm5vdGljZWQgdGhhdCB0aGV5IGhhdmUgdGhlIGV4YWN0IHNhbWUg
ZGVzY3JpcHRpb24gb2YgdGhlIEcxX0lFRUVfUFJJDQpyZWdpc3RlciAoZ2xvYmFsMSwgb2Zmc2V0
IDB4MTgpLiBIb3dldmVyLCB0aGUgY3VycmVudCBjb2RlIHVzZWQgYnkgNjI0MCBkb2VzDQoNCmlu
dCBtdjg4ZTYwODVfZzFfaWVlZV9wcmlfbWFwKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCkN
CnsNCgkvKiBSZXNldCB0aGUgSUVFRSBUYWcgcHJpb3JpdGllcyB0byBkZWZhdWx0cyAqLw0KCXJl
dHVybiBtdjg4ZTZ4eHhfZzFfd3JpdGUoY2hpcCwgTVY4OEU2WFhYX0cxX0lFRUVfUFJJLCAweGZh
NDEpOw0KfQ0KDQp3aGlsZSBpZiBteSByZWFkaW5nIG9mIHRoZSBkYXRhIHNoZWV0IGlzIGNvcnJl
Y3QsIHRoZSByZXNldCB2YWx1ZSBpcw0KcmVhbGx5IDB4ZmE1MCAoZmllbGRzIDc6NiBhbmQgNTo0
IGFyZSBSV1MgdG8gMHgxLCBmaWVsZCAzOjIgYW5kIDE6MCBhcmUNClJXUikgLSBhbmQgdGhpcyBp
cyBhbHNvIHRoZSB2YWx1ZSBJIHJlYWQgZnJvbSB0aGUgNjI1MCBvbiBvdXIgb2xkIEJTUA0Kd2l0
aCBhbiBvdXQtb2YtdHJlZSBkcml2ZXIgdGhhdCBkb2Vzbid0IHRvdWNoIHRoYXQgcmVnaXN0ZXIu
IFRoaXMgc2VlbXMNCnRvIGdvIHdheSBiYWNrIChhdCBsZWFzdCAzYjE1ODg1OTMwOTcpLiBTaG91
bGQgdGhpcyBiZSBsZWZ0IGFsb25lIGZvcg0Kbm90IHJpc2tpbmcgYnJlYWtpbmcgZXhpc3Rpbmcg
c2V0dXBzIChqdXN0IHVwZGF0aW5nIHRoZSBjb21tZW50KSwgb3IgY2FuDQp3ZSBtYWtlIHRoZSBj
b2RlIG1hdGNoIHRoZSBjb21tZW50PyBPciBhbSBJIGp1c3QgcmVhZGluZyB0aGlzIGFsbCB3cm9u
Zz8NCg0KUmFzbXVzDQoNCg0KDQo=

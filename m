Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55AE72FB5A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 14:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfE3MB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 08:01:27 -0400
Received: from mail-eopbgr50043.outbound.protection.outlook.com ([40.107.5.43]:28571
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726997AbfE3MB1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 08:01:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMzCp0apUdAXTtSr4avddEN1sqKahWfMp9L4dPAo4E0=;
 b=hkIc8s1DYE2gOPLd9g4LnUtgPwcHZTwyKsUePxEzuO4CTVIZccVM9v7NCutcrgaJPF99TcsU3RNZR7pXO4vcChs/L7ZVwZuzOPm3wMQ4yoMbYiZU7pGyeJ/V0G7Rt2Voz1+LZCnU0mUn8Ve7cDoYImlPSwZLck25P79dwy1hdbo=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB2607.eurprd03.prod.outlook.com (10.171.104.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Thu, 30 May 2019 12:01:22 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4%5]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 12:01:22 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Thread-Topic: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Thread-Index: AQHVFXdSefBuJXwkfU6scW4BRrDrCKaDGbSAgAB6J4A=
Date:   Thu, 30 May 2019 12:01:22 +0000
Message-ID: <7CB4D942-AB53-49B4-9630-B03B47683F50@darbyshire-bryant.me.uk>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
 <20190529.214409.2156776359120413200.davem@davemloft.net>
In-Reply-To: <20190529.214409.2156776359120413200.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1268:6500::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24c29766-1822-49ca-d7ea-08d6e4f688c3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7193020);SRVR:VI1PR0302MB2607;
x-ms-traffictypediagnostic: VI1PR0302MB2607:
x-microsoft-antispam-prvs: <VI1PR0302MB26071C9B64DECB22BA9666F9C9180@VI1PR0302MB2607.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(376002)(366004)(39830400003)(136003)(199004)(189003)(83716004)(2616005)(53546011)(102836004)(6506007)(476003)(8676002)(486006)(4326008)(81166006)(256004)(53936002)(25786009)(71200400001)(71190400001)(316002)(14444005)(36756003)(81156014)(8936002)(4744005)(99286004)(6246003)(5660300002)(86362001)(33656002)(186003)(68736007)(64756008)(66556008)(66476007)(66946007)(6436002)(76176011)(74482002)(2906002)(66446008)(6486002)(6116002)(6916009)(76116006)(446003)(11346002)(73956011)(14454004)(305945005)(6512007)(91956017)(7736002)(46003)(508600001)(82746002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2607;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ek3FWReRAuXjg/rKMzKprIj4YyRmQtGMUYOubGaJ3s+VEVsjaI1gtbizyvt1CfQ0tza+1hfcY70E8OgTPSc9OcriX9tq1Jpgln02NXPkDVwKOITGIF3sBWsNbZuLrkfYCDpJ2hwYtfFs67L9tUzORTWAp2wFNj2Sohmq5lFgTSIoXMC8l3FO+3j2AVL4sswf3z6X1q1BCiWALSmXFswbo8By/NfrHwC+dQoXZtJLL19CjxexoIH3yyAVUnc5X57yqeoMRP88fwumBy+HmJLuRxiAK0av+PV/OSU/FnePEUkoDaK8nuNYOzkuXFnK9KnLSnP8mK76pCVPAIVdUjDqSo8ECrkYM9PWgFEF7zRiSQmVqaEZbwjeAPigTozQYD/l8ZPEMdOpytpfnaRSqh5ckoDTnKWaPhBrHtOgsFI7b9k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D2AFFE098024B44A81423A42534A734E@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c29766-1822-49ca-d7ea-08d6e4f688c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 12:01:22.6237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2607
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMzAgTWF5IDIwMTksIGF0IDA1OjQ0LCBEYXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVt
bG9mdC5uZXQ+IHdyb3RlOg0KPiANCj4gRnJvbTogS2V2aW4gJ2xkaXInIERhcmJ5c2hpcmUtQnJ5
YW50IDxsZGlyQGRhcmJ5c2hpcmUtYnJ5YW50Lm1lLnVrPg0KPiBEYXRlOiBUdWUsIDI4IE1heSAy
MDE5IDE3OjAzOjUwICswMDAwDQo+IA0KPj4gY3RpbmZvIGlzIGEgbmV3IHRjIGZpbHRlciBhY3Rp
b24gbW9kdWxlLiAgSXQgaXMgZGVzaWduZWQgdG8gcmVzdG9yZQ0KPj4gaW5mb3JtYXRpb24gY29u
dGFpbmVkIGluIGZpcmV3YWxsIGNvbm50cmFjayBtYXJrcyB0byBvdGhlciBwYWNrZXQgZmllbGRz
DQo+PiBhbmQgaXMgdHlwaWNhbGx5IHVzZWQgb24gcGFja2V0IGluZ3Jlc3MgcGF0aHMuICBBdCBw
cmVzZW50IGl0IGhhcyB0d28NCj4+IGluZGVwZW5kZW50IHN1Yi1mdW5jdGlvbnMgb3Igb3BlcmF0
aW5nIG1vZGVzLCBEU0NQIHJlc3RvcmF0aW9uIG1vZGUgJg0KPj4gc2tiIG1hcmsgcmVzdG9yYXRp
b24gbW9kZS4NCj4gLi4uDQo+IA0KPiBBcHBsaWVkLCB0aGFuayB5b3UuDQoNClRoYW5rIHlvdS4g
VGhhbmtzIHRvIFRva2UgJiBDb25nIGFsc28gZm9yIHRoZWlyIGVuY291cmFnZW1lbnQgZXZlbiBp
ZiBJDQpkaWRu4oCZdCBzZWUgaXQgYXMgdGhhdCBhdCB0aGUgdGltZS4NCg0KQ2hlZXJzLA0KDQpL
ZXZpbg==

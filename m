Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54888488A9
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 18:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbfFQQQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 12:16:11 -0400
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:34309
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726215AbfFQQQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 12:16:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wR0HcazLafLkNPnj+pBxHlA4FxI9NiEJ4KxFHfwG40=;
 b=BcVh9b0bSJpS6y3P6fAdAeQsOckZNIyVA0HL1nSzkqvcaOCq5uZw/MWG2z/36EVwI6B2E5HbitFRfgrx9uKVs83r4ZUBkKjgNrCDWOBkWZ8JM+okwvzWY2Uip/dOPtd+w5O+u1KXATlsfi+OeyFa01j/u2MhW76MgB1d/UiURXU=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6329.eurprd05.prod.outlook.com (20.179.41.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Mon, 17 Jun 2019 16:16:07 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::50a0:251f:78ce:22c6]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::50a0:251f:78ce:22c6%6]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 16:16:07 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ran Rozenstein <ranro@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH net-next 0/2] net: ipv4: remove erroneous advancement of
 list pointer
Thread-Topic: [PATCH net-next 0/2] net: ipv4: remove erroneous advancement of
 list pointer
Thread-Index: AQHVJRbrHUrhwGqQr0+x3eZzc8WnvaagBb2A
Date:   Mon, 17 Jun 2019 16:16:07 +0000
Message-ID: <08e102a0-8051-e582-56c8-d721bfc9e8b9@mellanox.com>
References: <20190617140228.12523-1-fw@strlen.de>
In-Reply-To: <20190617140228.12523-1-fw@strlen.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR05CA0005.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::18) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa46a657-a7ae-4701-c0ee-08d6f33f1a37
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6329;
x-ms-traffictypediagnostic: DBBPR05MB6329:
x-microsoft-antispam-prvs: <DBBPR05MB632974CED808E35289090713AEEB0@DBBPR05MB6329.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(366004)(376002)(136003)(39860400002)(189003)(199004)(8676002)(486006)(229853002)(110136005)(68736007)(2501003)(25786009)(99286004)(186003)(53936002)(6246003)(76176011)(52116002)(6116002)(3846002)(4326008)(31686004)(66066001)(8936002)(54906003)(53546011)(316002)(86362001)(31696002)(66946007)(6436002)(6486002)(26005)(102836004)(66446008)(64756008)(66476007)(66556008)(73956011)(4744005)(36756003)(7736002)(71200400001)(71190400001)(256004)(305945005)(386003)(6506007)(11346002)(446003)(81166006)(2906002)(476003)(2616005)(81156014)(14454004)(478600001)(6512007)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6329;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Qz2hjuwTYnNz2b7sQREFKUy8uHFN5aiwR8lL01mKeL/1h3XLGsWNDOtxGCp8h3/R29Zgbny1Pc4TyfQWh0qPpho6zO8j1ako/0LWPUK9dlZvnUW4FUxDuioOvQxghfGlWNHVvJIRKErM7Vgl0wMu5Owm324t9foRcVpaZA6HkhMn7teWGIiwhCcCwjZJdodPeNgAW3rOcbCwfZTcIbW5Gw71Q7BWEqX2eGSVVZvtPXwVW3N/z4TIGD3M76tbUie4hgAirWVuU7Uws6uesq5fDsaNXKOQJ6R2yPCW/4a3J5rSOnbKA5fnJRorfatFIqCXSJ9sapeuQW9k06fy1MmWLCHjqFfnm7ckSNw001aXBCvSK1SHZRtkE3DTXXXX6GkAibYjSaPhY54WNbCtC7j6OdKW1cgmnakWd3jV4cjwcDs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C280CFDD1D1FE643B5ABE6EB86715302@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa46a657-a7ae-4701-c0ee-08d6f33f1a37
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 16:16:07.1872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6329
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMTcvMjAxOSA1OjAyIFBNLCBGbG9yaWFuIFdlc3RwaGFsIHdyb3RlOg0KPiBUYXJp
cSByZXBvcnRlZCBhIHNvZnQgbG9ja3VwIG9uIG5ldC1uZXh0IHRoYXQgTWVsbGFub3ggd2FzIGFi
bGUgdG8NCj4gYmlzZWN0IHRvIDI2MzhlYjhiNTBjZiAoIm5ldDogaXB2NDogcHJvdmlkZSBfX3Jj
dSBhbm5vdGF0aW9uIGZvciBpZmFfbGlzdCIpLg0KPiANCj4gV2hpbGUgcmV2aWV3aW5nIGFib3Zl
IHBhdGNoIEkgZm91bmQgYSByZWdyZXNzaW9uIHdoZW4gYWRkcmVzc2VzIGhhdmUgYQ0KPiBsaWZl
dGltZSBzcGVjaWZpZWQuDQo+IA0KPiBTZWNvbmQgcGF0Y2ggZXh0ZW5kcyBydG5ldGxpbmsuc2gg
dG8gdHJpZ2dlciBjcmFzaA0KPiAod2l0aG91dCBmaXJzdCBwYXRjaCBhcHBsaWVkKS4NCj4gDQoN
ClRoYW5rcyBGbG9yaWFuLg0KDQpSYW4sIGNhbiB5b3UgcGxlYXNlIHRlc3Q/DQoNCg==

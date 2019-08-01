Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB0817E328
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 21:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388441AbfHATOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:14:12 -0400
Received: from mail-eopbgr00079.outbound.protection.outlook.com ([40.107.0.79]:22023
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbfHATOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:14:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXE/wjChPrtfylL0GhIwjR75SPR5vAQvNgUqsrKGTrZBD3N+aSZ25ghSSY+pGaTIzNvzZj8gBHIiqJ8watPkq0iudh0GKBQW21PxhM/bnlV4CV3tqKNJQqE3XnVqkEBqqIzN4rqdYiPbcJxun1B/aPnrkQQEpFmnRc7k1WYwC8djVWKDIkJsDq7CNEFNKiXb+Jbnt+2eVQ0pCzruN9qLcj3bq6db/A2B+esXupCWDrUk+zH8669OdfrtnwMbFreGXFDvlcWwd0r9eKlO6TjhwOZoF2n5QCpjXjGgD4EZ3TZB29McFrCCKmljT2XL5cSQQNjKSfPibzJNU+WYcWmnyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1yOBExhz0r0Zq7uyvG2E4YlKgfKxhVTdcs/gqvQt4SQ=;
 b=bl9//NLxGGmE2c/h8LnDQgHwzaMQ2qtuSbA2uEGg1M6NAxczDcNUKeo0XkDrmJnUyA6lPxjHUuijpqvOb4gnOvKLAC/zCl7TXKCc0EaEWlO0CLwDSNFjK9EC7bQ4xQbMXiylZYTCP9hrC3T4ZuLMT6bhoM24A7rowhbsquRIb488d/6B/IR9xbXsi9Ork65BpoT3P/O1r7CJfYvlVX0j9p0DSBtyAqfZdixkzVHlTJkNYXqJaMWZ9YlLhDfJTONoy+L3LsAWve49scfYkvhp1wNQyK8PYyyixMP4Q9mP1GqlXxXpv4KWJ4Lycl5nYuEU9kZTKAtCNAiTc8n9xWAtlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1yOBExhz0r0Zq7uyvG2E4YlKgfKxhVTdcs/gqvQt4SQ=;
 b=MqDLe66wjYF5zV/SeYtbKClJF2vJ5XT5OvUsjOcwlwxOESlnMxqfBm7QTE3jgtUK2wPoU4jMn5/l5ixhUj8ZewZTkiGxkiOFatRV6eRov4XB7fNWh8AX5F7zJJjlbsp0/6r2KSWLNZCdyaKOXhDoUuJdyzC+japUYOL34lzraDU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2358.eurprd05.prod.outlook.com (10.168.57.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Thu, 1 Aug 2019 19:14:08 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:14:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Roi Dayan <roid@mellanox.com>,
        "xiangxia.m.yue@gmail.com" <xiangxia.m.yue@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Allow dropping specific tunnel
 packets
Thread-Topic: [PATCH net-next] net/mlx5e: Allow dropping specific tunnel
 packets
Thread-Index: AQHVSEvWD/oUWvNtuk2f+jPe1RT7tqbmqfiA
Date:   Thu, 1 Aug 2019 19:14:07 +0000
Message-ID: <ab681fc339702c10f83ea8da2aa124239c770855.camel@mellanox.com>
References: <1564648859-17369-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1564648859-17369-1-git-send-email-xiangxia.m.yue@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 594fabb4-9a3c-426c-316f-08d716b46d5a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB6PR0501MB2358;
x-ms-traffictypediagnostic: DB6PR0501MB2358:
x-microsoft-antispam-prvs: <DB6PR0501MB2358B64172ABE419DD808435BEDE0@DB6PR0501MB2358.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(199004)(189003)(305945005)(64756008)(7736002)(91956017)(76116006)(8676002)(66476007)(66556008)(66446008)(66946007)(6246003)(4326008)(229853002)(68736007)(6486002)(81166006)(81156014)(26005)(118296001)(14454004)(6436002)(186003)(76176011)(8936002)(58126008)(316002)(110136005)(36756003)(256004)(102836004)(5660300002)(478600001)(71200400001)(6116002)(66066001)(2906002)(86362001)(4744005)(3846002)(2616005)(53936002)(11346002)(476003)(6512007)(486006)(446003)(25786009)(99286004)(2501003)(71190400001)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2358;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zRhUDR/TwCSlEpB9VUhmNY68opstIlmH3ix2OQiqd87124K8bBzHrtsq/dt+xTl5dh0XZu0x1IJP0OCrKAHewQhgots5DvzKAcqvset2zpChs29xZVTUsOD3qL1Rk/MkeFjNSNjABitlmOkg495V4pM+6st/KTYodN9POHz9FrHqche1hr9mDPsyKEB+4V+GGBpGWjWkGJk/aIqMwhcueT4GYzxfMNmHlO82F9wKD+f1gzNj0xjhO53JXnjBqySfYPmej72ToiiI68xYt3zOiw1dsYjdowJcZgVG2tZ1kfVEDDHenp6W4s1bm5yKKmJZridviTlg0ST3rdXNTSuhqSvfmwyNBUH3NweqoGK+43AwZhykbBobzfFobl9HnZ6Z/tymOMjjnhcXIHJ8e0/nIdpnKBayk1E7dI6chUSo+C8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6D8929488B9984D9F70A9B8E51A769D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 594fabb4-9a3c-426c-316f-08d716b46d5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:14:07.6738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2358
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTAxIGF0IDE2OjQwICswODAwLCB4aWFuZ3hpYS5tLnl1ZUBnbWFpbC5j
b20gd3JvdGU6DQo+IEZyb206IFRvbmdoYW8gWmhhbmcgPHhpYW5neGlhLm0ueXVlQGdtYWlsLmNv
bT4NCj4gDQo+IEluIHNvbWUgY2FzZSwgd2UgZG9uJ3Qgd2FudCB0byBhbGxvdyBzcGVjaWZpYyB0
dW5uZWwgcGFja2V0cw0KPiB0byBob3N0IHRoYXQgY2FuIGF2b2lkIHRvIHRha2UgdXAgaGlnaCBD
UFUgKGUuZyBuZXR3b3JrIGF0dGFja3MpLg0KPiBCdXQgb3RoZXIgdHVubmVsIHBhY2tldHMgd2hp
Y2ggbm90IG1hdGNoZWQgaW4gaGFyZHdhcmUgd2lsbCBiZQ0KPiBzZW50IHRvIGhvc3QgdG9vLg0K
PiANCj4gICAgICQgdGMgZmlsdGVyIGFkZCBkZXYgdnhsYW5fc3lzXzQ3ODkgXA0KPiAJICAgIHBy
b3RvY29sIGlwIGNoYWluIDAgcGFyZW50IGZmZmY6IHByaW8gMSBoYW5kbGUgMSBcDQo+IAkgICAg
Zmxvd2VyIGRzdF9pcCAxLjEuMS4xMDAgaXBfcHJvdG8gdGNwIGRzdF9wb3J0IDgwIFwNCj4gCSAg
ICBlbmNfZHN0X2lwIDIuMi4yLjEwMCBlbmNfa2V5X2lkIDEwMCBlbmNfZHN0X3BvcnQgNDc4OSBc
DQo+IAkgICAgYWN0aW9uIHR1bm5lbF9rZXkgdW5zZXQgcGlwZSBhY3Rpb24gZHJvcA0KPiANCj4g
U2lnbmVkLW9mZi1ieTogVG9uZ2hhbyBaaGFuZyA8eGlhbmd4aWEubS55dWVAZ21haWwuY29tPg0K
DQpBcHBsaWVkIHRvIG5ldC1uZXh0LW1seDUuDQoNClRoYW5rcyENCg==

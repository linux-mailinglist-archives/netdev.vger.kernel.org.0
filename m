Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 020715714F
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfFZTFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:05:51 -0400
Received: from mail-eopbgr40040.outbound.protection.outlook.com ([40.107.4.40]:11235
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbfFZTFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:05:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=F/C/8LOcChNyfSz1QZN1SfGZWDh/afnOWS+WyUfF8GSJ+fdfWsKXzCZwrdi6ppG5QJZnLlXJQH8/JZB5kWLlgK7KDO3cky2USBIXBCnGdlPDRJ3WYfrEnUBDeEc92bc1TZwd//168rYRAVydJAc+Cg/JHsnpJ4AHEaKiBwHqdH0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXlGSA5zbqHGlrCN7LGvcCZPIymFDHsH5R7GmVzGhY0=;
 b=oU6FXQrNSK1e4aXACQEQqA/9aNoK5Hy44krfpVVe8Rlwqg6IOUWX8l9m30xmzE8ngz7DmML0WX7g80F0G8CWEOEFhAu/XvAaPpffPQ8cUvW6qOgbEcXUf0XsICwdmrGXtNOA/Xnf2ymOzIZ2Lzs7J+uAgJNGFs8HfQQwQXp6Ej4=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXlGSA5zbqHGlrCN7LGvcCZPIymFDHsH5R7GmVzGhY0=;
 b=Qo125apKcIrfe6557r8TMIorD8EGG7n3u8f5wcsrVRGKBnMtflFq7LoV+q668kxjN+aPpD/+CU4B9T2f5XuK21h9BYlw7eaNJZALk5/ozEB5pRVEmXXQdE1rFisH4NulfYc1ZtrPciuRZtZ6NDXx3CffOV8vKkBv5p2+fVaK4qY=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2566.eurprd05.prod.outlook.com (10.168.73.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Wed, 26 Jun 2019 19:05:46 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Wed, 26 Jun 2019
 19:05:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH V2 mlx5-next 00/13] Mellanox, mlx5 vport metadata matching
Thread-Topic: [PATCH V2 mlx5-next 00/13] Mellanox, mlx5 vport metadata
 matching
Thread-Index: AQHVK34a1Kbi2wF+mkOypz3S1XQRsaauTVIA
Date:   Wed, 26 Jun 2019 19:05:46 +0000
Message-ID: <773d05d69aa291631fd99425841a4c17a39e098f.camel@mellanox.com>
References: <20190625174727.20309-1-saeedm@mellanox.com>
In-Reply-To: <20190625174727.20309-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.3 (3.32.3-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0feb3c05-91a6-429a-dd6d-08d6fa694b5b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2566;
x-ms-traffictypediagnostic: DB6PR0501MB2566:
x-microsoft-antispam-prvs: <DB6PR0501MB25664C8F02E18223BF104041BEE20@DB6PR0501MB2566.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(136003)(39860400002)(396003)(346002)(189003)(199004)(229853002)(14454004)(2616005)(2906002)(476003)(486006)(6436002)(36756003)(99286004)(6486002)(7736002)(446003)(305945005)(11346002)(118296001)(6512007)(37006003)(58126008)(86362001)(6246003)(102836004)(6636002)(316002)(68736007)(6862004)(53936002)(81166006)(6506007)(81156014)(66066001)(4326008)(5660300002)(8676002)(8936002)(478600001)(450100002)(186003)(6116002)(256004)(25786009)(66476007)(76116006)(91956017)(66946007)(73956011)(64756008)(66556008)(66446008)(76176011)(71200400001)(71190400001)(54906003)(14444005)(3846002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2566;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: N9UqJCWG2kw48l4jeMirQxpQ9JVsSGMSARVuCkc19gflgguWcBKz1jIUZ2kqgzw6nWTetJ5xqfKjWaqEmAAPy+jO8d9eT/SHC7AIulRZYFKP6kTlKWFH+NpGYq9KYhfUWRZrcqNku+esQJmCzrRe5OLksTJtj3DE/1edXSQGUv9+D3rfeXilGVWizIZfPOfVbcSSGT3iIheJ9oy33Nsbrw8Gdvz/ViPprBP/6gJE8kciCAcJxorIUbJtuk3Dnm13bBrAU5ItRpgF+QM2SKQEnL+MGPtsxRo2B7Px6fuELak9QpQhUkTOKUAX588j19H1MP/t530N24zQSG9SaxPz6uBfUZJ4N1+B4ufEQxclkzMxKfLT9ydGvJfwt6/SdzNVh/qaXzvuveKGlAn6de5VvLFJB82l79fErMjQMDhjOTA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7FEE14955F237F4B96576E64223B55F3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0feb3c05-91a6-429a-dd6d-08d6fa694b5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 19:05:46.1815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2566
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTI1IGF0IDE3OjQ3ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gVGhpcyBzZXJpZXMgaW5jbHVkZXMgbWx4NSB1cGRhdGVzIGZvciBib3RoIHJkbWEgYW5kIG5l
dC1uZXh0IHRyZWVzLg0KPiBJbiBjYXNlIG9mIG5vIG9iamVjdGlvbiBpdCB3aWxsIGJlIGFwcGxp
ZWQgdG8gbWx4NS1uZXh0IGJyYW5jaCBhbmQNCj4gbGF0ZXINCj4gb24gd2lsbCBiZSBzZW50IGFz
IHB1bGwgcmVxdWVzdCB0byByZG1hIGFuZCBuZXQtbmV4dC4NCj4gDQo+IEZyb20gSmlhbmJvLCBW
cG9ydCBtZXRhIGRhdGEgbWF0Y2hpbmc6DQo+IA0KPiBIYXJkd2FyZSBzdGVlcmluZyBoYXMgbm8g
bm90aW9uIG9mIHZwb3J0IG51bWJlciwgYW5kIHZwb3J0IGlzIGFuDQo+IGFic3RyYWN0IGNvbmNl
cHQsIHNvIGZpcm13YXJlIG5lZWQgdG8gdHJhbnNsYXRlIHRoZSBzb3VyY2UgdnBvcnQNCj4gbWF0
Y2hpbmcgdG8gbWF0Y2ggb24gdGhlIFZIQ0EgSUQgKFZpcnR1YWwgSENBIElEKS4NCj4gDQo+IElu
IGR1YWwtcG9ydCBSb0NFLCB0aGUgZHVhbC1wb3J0IFZIQ0EgaXMgYWJsZSB0byBzZW5kIGFsc28g
b24gdGhlDQo+IHNlY29uZCBwb3J0IG9uIGJlaGFsZiBvZiB0aGUgYWZmaWxpYXRlZCB2cG9ydCwg
c28gbm93IHdlIGNhbuKAmXQgYXNzdW1lDQo+IGFueW1vcmUgdGhhdCB2cG9ydCBpcyByZXByZXNl
bnRlZCBieSBzaW5nbGUgVkhDQSBvbmx5Lg0KPiANCj4gVG8gcmVzb2x2ZSB0aGlzIGlzc3VlLCB3
ZSB1c2UgbWV0YWRhdGEgcmVnaXN0ZXIgYXMgc291cmNlIHBvcnQNCj4gaW5kaWNhdG9yIGluc3Rl
YWQuDQo+IA0KPiBXaGVuIGEgcGFja2V0IGVudGVycyB0aGUgZXN3aXRjaCwgZXN3aXRjaCBpbmdy
ZXNzIHRyYWZmaWMgcGFzc2VzIHRoZQ0KPiBpbmdyZXNzIEFDTCBmbG93IHRhYmxlcywgd2hlcmUg
d2UgdGFnIHRoZSBwYWNrZXRzICh2aWEgdGhlIG1ldGFkYXRhDQo+IHZhbHVlLCBpbiB0aGlzIGNh
c2UgUkVHX0MgYXQgaW5kZXggMCkgd2l0aCBhIHVuaXF1ZSB2YWx1ZSB3aGljaCB3aWxsDQo+IGFj
dCBhcyBhbiBhbGlhcyBvZiB0aGUgdnBvcnQuIEluIG9yZGVyIHRvIGd1YXJhbnRlZSB1bmlxdWVu
ZXNzLCB3ZQ0KPiB1c2UNCj4gdGhlIGVzd2l0Y2ggb3duZXIgdmhjYSBpZCBhbmQgdGhlIHZwb3J0
IG51bWJlciBhcyB0aGF0IHZhbHVlLg0KPiANCj4gVXN1YWxseSwgdGhlIHZwb3J0cyBhcmUgbnVt
YmVyZWQgaW4gZWFjaCBlc3dpdGNoIGFzIGZvbGxvd2VkOg0KPiAgICAgLSBQaHlzaWNhbCBGdW5j
dGlvbiAoUEYpIHZwb3J0LCB0aGUgbnVtYmVyIGlzIDAuDQo+ICAgICAtIFZpcnR1YWwgRnVuY3Rp
b24gKFZGKSB2cG9ydCwgc3RhcnRpbmcgZnJvbSAxLg0KPiAgICAgLSBVcGxpbmsgdnBvcnQsIHRo
ZSByZXNlcnZlZCB2cG9ydCBudW1iZXIgZm9yIGl0IGlzIDB4RkZGRi4NCj4gDQo+IFdpdGggdGhl
IG1ldGFkYXRhIGluIGVhY2ggcGFja2V0LCB3ZSBjYW4gdGhlbiBkbyBtYXRjaGluZyBvbiBpdCwg
aW4NCj4gYm90aCBmYXN0IHBhdGggYW5kIHNsb3cgcGF0aC4NCj4gDQo+IEZvciBzbG93IHBhdGgs
IHRoZXJlIGlzIGEgcmVwcmVzZW50b3IgZm9yIGVhY2ggdnBvcnQuIFBhY2tldCB0aGF0DQo+IG1p
c3NlcyBhbGwgb2ZmbG9hZGVkIHJ1bGVzIGluIEZEQiwgd2lsbCBiZSBmb3J3YXJkZWQgdG8gdGhl
IGVzd2l0Y2gNCj4gbWFuYWdlciB2cG9ydC4gSW4gaXRzIE5JQyBSWCwgaXQgdGhlbiB3aWxsIGJl
IHN0ZWVyZWQgdG8gdGhlIHJpZ2h0DQo+IHJlcHJlc2VudG9yLiBUaGUgcnVsZXMsIHdoaWNoIGRl
Y2lkZSB0aGUgZGVzdGluYXRpb24gcmVwcmVzZW50b3IsDQo+IHByZXZpb3VzbHkgd2VyZSBtYXRj
aGluZyBvbiBzb3VyY2UgcG9ydCwgd2lsbCBub3cgbWF0Y2ggbWV0YWRhdGENCj4gaW5zdGVhZC4N
Cj4gDQoNClNlcmllcyBhcHBsaWVkIHRvIG1seDUtbmV4dC4NCg0KVGhhbmtzIGV2ZXJ5b25lIQ0K
U2FlZWQuDQoNCg==

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427FA559A9
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfFYVHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:07:14 -0400
Received: from mail-eopbgr40041.outbound.protection.outlook.com ([40.107.4.41]:60801
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726040AbfFYVHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 17:07:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMHVliVV0OqYudeXhO8ghayH1JMuTIfCkZ3myOHWR6Q=;
 b=dDb9fO4vN4GLmk83cwNGppNrQdRCHCWfdjmkQhhaju6VwEYfpD7CgEx4ln7BBZKC43DpS8L9IQB7MOiI9eweu5PjTQXrhiKRLo9LbN4sfqTiCv0OJKQXUc97RA9qndTRkKKsBxAt1TDgJzT5U6DoUXkBfH3hR3P9QN2bShpN0k0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2760.eurprd05.prod.outlook.com (10.172.226.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 21:07:10 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 21:07:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dledford@redhat.com" <dledford@redhat.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        Leon Romanovsky <leonro@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][for-next V2 0/7] Generic DIM lib for netdev and
 RDMA
Thread-Topic: [pull request][for-next V2 0/7] Generic DIM lib for netdev and
 RDMA
Thread-Index: AQHVK5iYkivo34mkiUCAxIaWOP9/Xqas3LQA
Date:   Tue, 25 Jun 2019 21:07:10 +0000
Message-ID: <1303f91de924ebfc980a7e0464a84aa5373dd32a.camel@mellanox.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
In-Reply-To: <20190625205701.17849-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.3 (3.32.3-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0aca057a-88fe-4721-8511-08d6f9b116a5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2760;
x-ms-traffictypediagnostic: DB6PR0501MB2760:
x-microsoft-antispam-prvs: <DB6PR0501MB2760239EF52EE2A7CF19CE0BBEE30@DB6PR0501MB2760.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(376002)(346002)(366004)(199004)(189003)(71200400001)(53936002)(73956011)(66946007)(2906002)(71190400001)(76116006)(26005)(305945005)(76176011)(6246003)(8936002)(186003)(316002)(110136005)(81156014)(81166006)(14454004)(6506007)(8676002)(7736002)(99286004)(68736007)(54906003)(58126008)(6436002)(6512007)(2616005)(11346002)(446003)(486006)(64756008)(476003)(6486002)(66066001)(102836004)(36756003)(5660300002)(118296001)(229853002)(6116002)(66556008)(66476007)(86362001)(2201001)(3846002)(478600001)(91956017)(25786009)(256004)(2501003)(66446008)(14444005)(4744005)(4326008)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2760;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +eedZ6RhFf/+JyW2412l4kYU7/ChtQcB+9lNXE2AT1NroZPqaRJbPD9EmqQYTG7FD3RZNitsNG703WxzYbUtrPKsKP8hj/aC0s0+4YuKRgISlDBYMKC8IKRhO2uPfTdNs4B8mJvdFg6fs36uo2oxmG4+d+7fWInHTHMleepEZ5S8kUoKzk18zL26xkJOmHnwqSptkT9oX58gHcbC8Zyex8vKvAkyKBG9wRZLL5M1RoRUVd+oYoKxVIUAgQjcWmLAyOXYOKeKTVEkerTS245Vf0XoqR8QO31chlHVXy0T+mImP7MWjKPmOWbGYaq5thtl5c1+TQ4z+Wu5AXCCv9KINZ6A1LgfCMkflfPsZUk7KnHyj+ibrIKlPCEYJmKus52KgR28g5+oBR8+IxdtCbwBWNL92SfOsd/iHn8bIz12oPc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D78C728FD1B144ABF3D4D549F96E64A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aca057a-88fe-4721-8511-08d6f9b116a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 21:07:10.2866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2760
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTI1IGF0IDIwOjU3ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGkgRGF2ZSwgRG91ZyAmIEphc29uDQo+IA0KPiBUaGlzIHNlcmllcyBpbXByb3ZlcyBESU0g
LSBEeW5hbWljYWxseS10dW5lZCBJbnRlcnJ1cHQNCj4gTW9kZXJhdGlvbi0gdG8gYmUgZ2VuZXJp
YyBmb3IgbmV0ZGV2IGFuZCBSRE1BIHVzZS1jYXNlcy4NCj4gDQo+IEZyb20gVGFsIGFuZCBZYW1p
bjoNCj4gDQo+IEZpcnN0IDcgcGF0Y2hlcyBwcm92aWRlIHRoZSBuZWNlc3NhcnkgcmVmYWN0b3Jp
bmcgdG8gY3VycmVudCBuZXRfZGltDQo+IGxpYnJhcnkgd2hpY2ggYWZmZWN0IHNvbWUgbmV0IGRy
aXZlcnMgd2hvIGFyZSB1c2luZyB0aGUgQVBJLg0KPiANCj4gVGhlIGxhc3QgMyBwYXRjaGVzIHBy
b3ZpZGUgdGhlIFJETUEgaW1wbGVtZW50YXRpb24gZm9yIERJTS4NCj4gVGhlc2UgcGF0Y2hlcyBh
cmUgaW5jbHVkZWQgaW4gdGhpcyBwdWxsIHJlcXVlc3QgYW5kIHRoZXkgYXJlIHBvc3RlZA0KDQpj
b3JyZWN0aW9uOiBUaGUgbGFzdCAzIHBhdGNoZXMgYXJlICpOT1QqIGluY2x1ZGVkIGluIHRoaXMg
cHVsbCByZXF1ZXN0Lg0KDQpUaGUgaWRlYSBoZXJlIGlzIHRvIHB1bGwgdGhlIHJlLWZhY3Rvcmlu
ZyBBUEkgcGF0Y2hlcyB0aGF0IGVmZmVjdCBhbmQNCnRvdWNoICBuZXQgZHJpdmVycyBbMC03XSB0
byBib3RoIHRyZWVzIGFuZCBbOC0xMF0gd2lsbCBiZSBzZW50IGxhdGVyIHRvDQpyZG1hIHRyZWUg
b25seS4NCg0KDQpUaGFua3MsDQpTYWVlZC4NCg==

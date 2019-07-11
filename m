Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6D166014
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 21:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfGKTj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 15:39:58 -0400
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:33188
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfGKTj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 15:39:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FViZ5ThM9YkJbBixAk2BcaRqMAeW1D9T6MtlFsAvzrE=;
 b=TaVjC9wd5IhxOfrbf7TXjX82A6ogqyVxT1aPCrQlGdhwjbs7fzlLeMkQlsi00dBPLmKZ3b2X/6SlgF9ZwxY4ghNNtajkwcq2gBuK7RGNiuGS6xCPpLQBXA7cp9zYMVnIG6nsOMogvgg6PXzxxB9Fe4UYPp+FxYDX3/yV67AfL+U=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2851.eurprd05.prod.outlook.com (10.172.216.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Thu, 11 Jul 2019 19:39:53 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1%9]) with mapi id 15.20.2052.022; Thu, 11 Jul 2019
 19:39:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 0/3] Mellanox, mlx5 build fixes
Thread-Topic: [PATCH net-next 0/3] Mellanox, mlx5 build fixes
Thread-Index: AQHVOCBpjHGYf2xirEyTWUz0mKnmPw==
Date:   Thu, 11 Jul 2019 19:39:53 +0000
Message-ID: <20190711193937.29802-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR11CA0070.namprd11.prod.outlook.com
 (2603:10b6:a03:80::47) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c46f2e5-6e53-4d82-9dfe-08d706378b5e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2851;
x-ms-traffictypediagnostic: AM4PR0501MB2851:
x-microsoft-antispam-prvs: <AM4PR0501MB2851EFEA1787748F5ED6B902BEF30@AM4PR0501MB2851.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(199004)(189003)(66946007)(66066001)(4744005)(26005)(66446008)(71200400001)(66476007)(71190400001)(186003)(81156014)(8936002)(6506007)(5660300002)(1076003)(305945005)(66556008)(36756003)(99286004)(81166006)(86362001)(25786009)(14444005)(52116002)(102836004)(107886003)(64756008)(53936002)(8676002)(386003)(478600001)(6436002)(476003)(3846002)(54906003)(6486002)(6916009)(2906002)(2616005)(6116002)(6512007)(486006)(68736007)(256004)(4326008)(7736002)(316002)(14454004)(50226002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2851;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Fu9SIwvxgBxXwIK/9vrFHQFdv7ekWaB0uJqdfjmfeYaKKkbIChIgaKztDyR8dXcngvmrijIHoArwAj3dlHJnTrgZiJVSnXCCzd0kE+fFz7MbI5N3QoMMuWjGv6pOLrSBmUroO7bCvGF8beWWV1WqvP4aFi6/N/483Kxmz/n+SfUxWOsG3zIgCOUeR0e9mMgw5B+tSzmSa3HCcTqOggYN3D9huy2vNlO78HcqCf6yOWAZe93WJ9ZPCNFq5NdHRx90+Uju0DjZPrUJbAUS3Xujoz6T/2DUJQ2x6qHgv+rhhdl/sh8ftedG6PmEeE1gLQxAlfF9JN5vxqj5Zz6r0IMy0YWnQ6UxYtH7ML1qjhOClCNpXRADQclHa9BWxIO7nwuorkyFaX0T+uPXLFW6sWUsEiO2OLVtQ4VzedifWa7UaHg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA2D2970BD77F143AD566DE887BB0D36@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c46f2e5-6e53-4d82-9dfe-08d706378b5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 19:39:53.4093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2851
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2ZSwNCg0KSSBrbm93IG5ldC1uZXh0IGlzIGNsb3NlZCBidXQgdGhlc2UgcGF0Y2hlcyBh
cmUgZml4aW5nIHNvbWUgY29tcGlsZXINCmJ1aWxkIGFuZCB3YXJuaW5ncyBpc3N1ZXMgcGVvcGxl
IGhhdmUgYmVlbiBjb21wbGFpbmluZyBhYm91dC4NCg0KSSBob3BlIGl0IGlzIG5vdCB0b28gbGF0
ZSwgYnV0IGluIGNhc2UgaXQgaXMgYSBsb3Qgb2YgdHJvdWJsZSBmb3IgeW91LCBJDQpndWVzcyB0
aGV5IGNhbiB3YWl0Lg0KDQpUaGFua3MsDQpTYWVlZC4NCg0KLS0tDQoNClNhZWVkIE1haGFtZWVk
ICgyKToNCiAgbmV0L21seDVlOiBGaXggdW51c2VkIHZhcmlhYmxlIHdhcm5pbmcgd2hlbiBDT05G
SUdfTUxYNV9FU1dJVENIIGlzIG9mZg0KICBuZXQvbWx4NTogRS1Td2l0Y2gsIFJlZHVjZSBpbmdy
ZXNzIGFjbCBtb2RpZnkgbWV0YWRhdGEgc3RhY2sgdXNhZ2UNCg0KVGFyaXEgVG91a2FuICgxKToN
CiAgbmV0L21seDVlOiBGaXggY29tcGlsYXRpb24gZXJyb3IgaW4gVExTIGNvZGUNCg0KIGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9hY2NlbC90bHMuaCAgICAgICAgfCAy
ICstDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYyAg
ICAgICAgICB8IDUgKystLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZXN3aXRjaF9vZmZsb2Fkcy5jIHwgMiArLQ0KIDMgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRp
b25zKCspLCA1IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMjEuMA0KDQo=

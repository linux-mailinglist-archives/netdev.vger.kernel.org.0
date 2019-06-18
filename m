Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0574A110
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfFRMpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:45:39 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:57058
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbfFRMpj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 08:45:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59N4dmlZe6cpScQbFBk7EXsJRA50WQIB3fvKIaqV7tM=;
 b=kO6jnu1Uyq2LIPukP8WxEHQyyKRz7SSmVlO54GRCavI0mMN3y6qjksPjb1vqIpT7RkN1STCmwlDZ3hYBkuXB/+KjsCvqmi3SKsfZIYUm/7RbWxbfVFQZNY89T8EAFmjpjSn2CGoPMj6X9AwH5zRObv/nZb6wk2nM3v9J2njbOgk=
Received: from DB6PR0501MB2342.eurprd05.prod.outlook.com (10.168.56.21) by
 DB6PR0501MB2710.eurprd05.prod.outlook.com (10.172.226.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Tue, 18 Jun 2019 12:45:36 +0000
Received: from DB6PR0501MB2342.eurprd05.prod.outlook.com
 ([fe80::ec3d:c810:e8d8:8aef]) by DB6PR0501MB2342.eurprd05.prod.outlook.com
 ([fe80::ec3d:c810:e8d8:8aef%9]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 12:45:36 +0000
From:   Shalom Toledo <shalomt@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        "natechancellor@gmail.com" <natechancellor@gmail.com>
Subject: [PATCH net-next] mlxsw: spectrum_ptp: Fix compilation on 32-bit ARM
Thread-Topic: [PATCH net-next] mlxsw: spectrum_ptp: Fix compilation on 32-bit
 ARM
Thread-Index: AQHVJdO5Vqa3KL/fh0aPyKtUWOkShg==
Date:   Tue, 18 Jun 2019 12:45:35 +0000
Message-ID: <20190618124521.22612-1-shalomt@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR07CA0267.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::34) To DB6PR0501MB2342.eurprd05.prod.outlook.com
 (2603:10a6:4:4c::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3fbbc6d-719c-4ccc-9977-08d6f3eadbc8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB6PR0501MB2710;
x-ms-traffictypediagnostic: DB6PR0501MB2710:
x-microsoft-antispam-prvs: <DB6PR0501MB27104A3E2DA45716D355B82EC5EA0@DB6PR0501MB2710.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:221;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(376002)(366004)(136003)(346002)(189003)(199004)(52116002)(6512007)(2501003)(54906003)(186003)(6506007)(386003)(50226002)(316002)(6486002)(66446008)(64756008)(5660300002)(99286004)(14444005)(256004)(1076003)(6436002)(66556008)(26005)(66476007)(66946007)(68736007)(81156014)(102836004)(305945005)(8676002)(6916009)(7736002)(5640700003)(8936002)(73956011)(486006)(2616005)(2906002)(81166006)(3846002)(6116002)(478600001)(1730700003)(86362001)(14454004)(476003)(66066001)(71190400001)(71200400001)(53936002)(4326008)(2351001)(36756003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2710;H:DB6PR0501MB2342.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1uSoNUH3+PGvSeNSW04C0YQfVbxdV3J0O+Htg/tmzLCJf5CovsHyugnUw9TIbr9IF+8ZY+3UICbOxuEsg4/l5iRMt5uob31W8DEeeheEkAhdDIXcL60jpIUVCHzWXoh8j301lxMCKWzxNgIaR1S2LaNHeVHt0Hnl082AqEtDmaMfzpbdkWLsqYvU4IKW2SP2EecGRopZSYvSGZn92q7jDKNEPnVELwhu/L8Id9yzBvPCUeOoyEdgAd4z+3P5TD/TU/Esszir3xF1Lapakoe//PwFGqdZlkDpj3wHA/XcmuLLphga3nGJDt9Ec6vbbzany6GudNd1NU3uOWdzIxlfEzjxWiaQfgmbHiwe/sDDEsTjmR8OSmqB+fUqzI4BZBLczgjoecBEzXYJA3bvqtVpIhD7WdZWmej3RF4ZohexbyE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3fbbc6d-719c-4ccc-9977-08d6f3eadbc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 12:45:35.8450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shalomt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2710
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q29tcGlsYXRpb24gb24gMzItYml0IEFSTSBmYWlscyBhZnRlciBjb21taXQgOTkyYWE4NjRkY2Ew
ICgibWx4c3c6DQpzcGVjdHJ1bV9wdHA6IEFkZCBpbXBsZW1lbnRhdGlvbiBmb3IgcGh5c2ljYWwg
aGFyZHdhcmUgY2xvY2sgb3BlcmF0aW9ucyIpDQpiZWNhdXNlIG9mIDY0LWJpdCBkaXZpc2lvbjoN
Cg0KYXJtLWxpbnV4LWdudWVhYmktbGQ6DQpkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHhzdy9zcGVjdHJ1bV9wdHAubzogaW4gZnVuY3Rpb24NCmBtbHhzd19zcDFfcHRwX3BoY19zZXR0
aW1lJzogc3BlY3RydW1fcHRwLmM6KC50ZXh0KzB4MzljKTogdW5kZWZpbmVkDQpyZWZlcmVuY2Ug
dG8gYF9fYWVhYmlfdWxkaXZtb2QnDQoNCkZpeCBieSB1c2luZyBkaXZfdTY0KCkuDQoNCkZpeGVz
OiA5OTJhYTg2NGRjYTAgKCJtbHhzdzogc3BlY3RydW1fcHRwOiBBZGQgaW1wbGVtZW50YXRpb24g
Zm9yIHBoeXNpY2FsIGhhcmR3YXJlIGNsb2NrIG9wZXJhdGlvbnMiKQ0KU2lnbmVkLW9mZi1ieTog
U2hhbG9tIFRvbGVkbyA8c2hhbG9tdEBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogSWRvIFNj
aGltbWVsIDxpZG9zY2hAbWVsbGFub3guY29tPg0KUmVwb3J0ZWQtYnk6IE5hdGhhbiBDaGFuY2Vs
bG9yIDxuYXRlY2hhbmNlbGxvckBnbWFpbC5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHhzdy9zcGVjdHJ1bV9wdHAuYyB8IDUgKystLS0NCiAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4c3cvc3BlY3RydW1fcHRwLmMgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHhzdy9zcGVjdHJ1bV9wdHAuYw0KaW5kZXggMmE5YmJjOTAy
MjVlLi5iYjZjMGNiMjU3NzEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHhzdy9zcGVjdHJ1bV9wdHAuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4c3cvc3BlY3RydW1fcHRwLmMNCkBAIC04MSwxMyArODEsMTIgQEAgc3RhdGljIGlu
dA0KIG1seHN3X3NwMV9wdHBfcGhjX3NldHRpbWUoc3RydWN0IG1seHN3X3NwX3B0cF9jbG9jayAq
Y2xvY2ssIHU2NCBuc2VjKQ0KIHsNCiAJc3RydWN0IG1seHN3X2NvcmUgKm1seHN3X2NvcmUgPSBj
bG9jay0+Y29yZTsNCisJdTY0IG5leHRfc2VjLCBuZXh0X3NlY19pbl9uc2VjLCBjeWNsZXM7DQog
CWNoYXIgbXR1dGNfcGxbTUxYU1dfUkVHX01UVVRDX0xFTl07DQogCWNoYXIgbXRwcHNfcGxbTUxY
U1dfUkVHX01UUFBTX0xFTl07DQotCXU2NCBuZXh0X3NlY19pbl9uc2VjLCBjeWNsZXM7DQotCXUz
MiBuZXh0X3NlYzsNCiAJaW50IGVycjsNCiANCi0JbmV4dF9zZWMgPSBuc2VjIC8gTlNFQ19QRVJf
U0VDICsgMTsNCisJbmV4dF9zZWMgPSBkaXZfdTY0KG5zZWMsIE5TRUNfUEVSX1NFQykgKyAxOw0K
IAluZXh0X3NlY19pbl9uc2VjID0gbmV4dF9zZWMgKiBOU0VDX1BFUl9TRUM7DQogDQogCXNwaW5f
bG9jaygmY2xvY2stPmxvY2spOw0KLS0gDQoyLjIwLjENCg0K

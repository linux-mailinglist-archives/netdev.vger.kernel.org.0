Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0D54F5FC
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 15:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfFVNpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 09:45:19 -0400
Received: from mail-eopbgr790059.outbound.protection.outlook.com ([40.107.79.59]:57275
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726313AbfFVNpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jun 2019 09:45:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0obaLDXHpEREjET/DWjjerZKLeiZR+rcZ1XKMbgZoU=;
 b=aWviOFJWgzAvrwTd7mpt/GrZGIWzWp9tLBuOQnmB5WPFbsXuW6tP78I1gpKJKFDMON3h0ksz23vjtIQsb3mHexpYqfs9TH16urQcy0YK5pGCOWPdIVc+5lSGsoAGfjQkZsvMOKznqjDrGHdDZ7s+O/lsD00Y01wIS6wWZgIPApM=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1389.namprd11.prod.outlook.com (10.169.235.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Sat, 22 Jun 2019 13:45:17 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.014; Sat, 22 Jun 2019
 13:45:17 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 3/7] maintainers: declare aquantia atlantic driver
 maintenance
Thread-Topic: [PATCH net-next 3/7] maintainers: declare aquantia atlantic
 driver maintenance
Thread-Index: AQHVKQC5aeyIAnd2uU+mD2+tWuGpFg==
Date:   Sat, 22 Jun 2019 13:45:17 +0000
Message-ID: <83a97b48060f078beac0953cc6e8ced7112d03c1.1561210852.git.igor.russkikh@aquantia.com>
References: <cover.1561210852.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1561210852.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0402CA0022.eurprd04.prod.outlook.com
 (2603:10a6:3:d0::32) To MWHPR11MB1968.namprd11.prod.outlook.com
 (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68d45c58-a7ff-4b90-2f05-08d6f717dbef
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1389;
x-ms-traffictypediagnostic: MWHPR11MB1389:
x-microsoft-antispam-prvs: <MWHPR11MB1389FE4D82F38FE4FA3018EB98E60@MWHPR11MB1389.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-forefront-prvs: 0076F48C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(346002)(136003)(39840400004)(199004)(189003)(478600001)(68736007)(8676002)(486006)(7736002)(81166006)(2616005)(44832011)(81156014)(66066001)(3846002)(256004)(72206003)(6116002)(118296001)(50226002)(2906002)(99286004)(64756008)(66446008)(36756003)(86362001)(6916009)(66556008)(66476007)(73956011)(71190400001)(71200400001)(476003)(11346002)(446003)(66946007)(54906003)(76176011)(6486002)(53936002)(6512007)(4744005)(52116002)(386003)(6506007)(5660300002)(25786009)(107886003)(305945005)(6436002)(6306002)(316002)(8936002)(14454004)(4326008)(186003)(26005)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1389;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CwNcZvkSKhBqzRZj+LHjdGniWOmUJ+3ByzGzhNJIUQElLuPyQon7A1cgV8enZMKLbc34LQUsScP6REjRhUt6v5BAlU9jmNavN4hTv3BHQjyMav4rHFAT9c9M8sO0shh0vsqCq5tTkrtZgLNXOX3tPBFaIb6swp8pa+ZZVJvqKAalUYVC9MGNn9fM6W4sWnrQNeodHir/irXZhdz/vKuE9Zb0KV3qENZ0W35eUimOz0VaIXqpgEcNrRyR9FlIbPKEg2UdsslwOSgC9hQmMNud8MX9fuLsZodlQdezE7vo77eBPixVWq2/mBJ6hLaHK4a/PxFj4VKcm8wrXGC0ue8ZbpWUrtWonI5+SaJgpq0f7NoPC+AsqsOl3zxoa5aAoL8f9sjYyKzBcXg9LX+QX0rDhF2Fy3nYQY5GqXEZhxaRByQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d45c58-a7ff-4b90-2f05-08d6f717dbef
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2019 13:45:17.1652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1389
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXF1YW50aWEgaXMgcmVzcG9zaWJsZSBub3cgZm9yIGFsbCBuZXcgZmVhdHVyZXMgYW5kIGJ1Z2Zp
eGVzLg0KUmVmbGVjdCB0aGF0IGluIE1BSU5UQUlORVJTLg0KDQpTaWduZWQtb2ZmLWJ5OiBJZ29y
IFJ1c3NraWtoIDxpZ29yLnJ1c3NraWtoQGFxdWFudGlhLmNvbT4NCi0tLQ0KIE1BSU5UQUlORVJT
IHwgOCArKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKykNCg0KZGlmZiAt
LWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMNCmluZGV4IDBjNTViMGZlZGJlMi4uMGY1
MjVmMWExMmRkIDEwMDY0NA0KLS0tIGEvTUFJTlRBSU5FUlMNCisrKyBiL01BSU5UQUlORVJTDQpA
QCAtMTEzOSw2ICsxMTM5LDE0IEBAIEw6CWxpbnV4LW1lZGlhQHZnZXIua2VybmVsLm9yZw0KIFM6
CU1haW50YWluZWQNCiBGOglkcml2ZXJzL21lZGlhL2kyYy9hcHRpbmEtcGxsLioNCiANCitBUVVB
TlRJQSBFVEhFUk5FVCBEUklWRVIgKGF0bGFudGljKQ0KK006CUlnb3IgUnVzc2tpa2ggPGlnb3Iu
cnVzc2tpa2hAYXF1YW50aWEuY29tPg0KK0w6CW5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCitTOglT
dXBwb3J0ZWQNCitXOglodHRwOi8vd3d3LmFxdWFudGlhLmNvbQ0KK1E6CWh0dHA6Ly9wYXRjaHdv
cmsub3psYWJzLm9yZy9wcm9qZWN0L25ldGRldi9saXN0Lw0KK0Y6CWRyaXZlcnMvbmV0L2V0aGVy
bmV0L2FxdWFudGlhL2F0bGFudGljLw0KKw0KIEFSQyBGUkFNRUJVRkZFUiBEUklWRVINCiBNOglK
YXlhIEt1bWFyIDxqYXlhbGtAaW50d29ya3MuYml6Pg0KIFM6CU1haW50YWluZWQNCi0tIA0KMi4x
Ny4xDQoNCg==

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4E42E885
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfE2WuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:50:25 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:53283
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726501AbfE2WuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 18:50:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a91wnbv53FcxPded2Y4cRD2W1kNq5J0k0CnmrDNPLMk=;
 b=i98wsSH2VMRmEQbtBjzSHMXCicK9Li268e77FvKfIY8XMwc55DaA9TC4G1Uay4GqqTpGGGhbzRYhGvHC+gUoNDsiBRaG0AQPlYBZSYSBUsO26BglQkR6cqXxRigR8eDkfM0AFP6nPeSbaGYl4G0XYKKE6GRcb8OHYyAink6a8bo=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB4351.eurprd05.prod.outlook.com (52.133.12.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 22:50:20 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38%6]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 22:50:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 0/6] Mellanox, mlx5-next minor updates 2019-05-29
Thread-Topic: [PATCH mlx5-next 0/6] Mellanox, mlx5-next minor updates
 2019-05-29
Thread-Index: AQHVFnDkskX4c0eOQUCYixTy9S10vw==
Date:   Wed, 29 May 2019 22:50:20 +0000
Message-ID: <20190529224949.18194-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::23) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8890ea6b-bf35-481d-4ecd-08d6e48806a5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB4351;
x-ms-traffictypediagnostic: VI1PR05MB4351:
x-microsoft-antispam-prvs: <VI1PR05MB43518BC4217216BF0F6295DDBE1F0@VI1PR05MB4351.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(39860400002)(346002)(376002)(53754006)(199004)(189003)(66446008)(73956011)(66946007)(64756008)(186003)(305945005)(68736007)(66476007)(52116002)(86362001)(1076003)(50226002)(4326008)(15650500001)(450100002)(66556008)(85306007)(6636002)(99286004)(54906003)(53936002)(102836004)(478600001)(6506007)(36756003)(8936002)(6512007)(8676002)(81156014)(110136005)(476003)(3846002)(6486002)(2616005)(256004)(26005)(5660300002)(6436002)(486006)(25786009)(2906002)(71200400001)(71190400001)(386003)(316002)(14444005)(6116002)(66066001)(14454004)(7736002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4351;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0bZwzFUmiozyS0Ijhn3xbebzfAI78Ga7I0rEjGhTPEaOlO7gqjmAWxWhJqKFAHnFWjzxAYdFebdH7a2hSJ+hDDClDlYFReJhTEjTOzK8wzRPf+LYRHf44e0Jjex42FjYojVC3/fX+R06ln896BBmf8e61TZUeawVV2WQxTNQe8QQN+JLjMzokmlgDzF1ZQWFqaa4COEoX0IadgmOilsCI19KfG/PuNE2ZWGSwmwFKzcfKuiHMso1KhpAOyG7Lp7Ylea/ob9l11ZicNK5n6AQVGKgk093rNknML5g1S6N1Iire6auAcnwe3jU9bD+X1OqxIHOPhtxvDAu51vDbJ1APiscCZqZPIvIxBfiDLzGfvFz4rdK4SuHZpd5GzWH4UE48thttY+hyVQ7OB/ei7shiTlfx4n5omC8dteyixMxM9I=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8890ea6b-bf35-481d-4ecd-08d6e48806a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 22:50:20.6051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsLA0KDQpUaGlzIHNlcmllcyBwcm92aWRlcyBzb21lIGxvdyBsZXZlbCB1cGRhdGVzIGZv
ciBtbHg1IGRyaXZlciBuZWVkZWQgZm9yDQpib3RoIHJkbWEgYW5kIG5ldGRldiB0cmVlcy4NCg0K
RWxpIGFkZHMgdGVybWluYXRpb24gZmxvdyBzdGVlcmluZyB0YWJsZSBiaXRzIGFuZCBoYXJkd2Fy
ZSBkZWZpbml0aW9ucy4NCg0KTW9zaGUgaW50cm9kdWNlcyB0aGUgY29yZSBkdW1wIEhXIGFjY2Vz
cyByZWdpc3RlcnMgZGVmaW5pdGlvbnMuDQoNClBhcmF2IHJlZmFjdG9ycyBhbmQgY2xlYW5zLXVw
IFZGIHJlcHJlc2VudG9ycyBmdW5jdGlvbnMgaGFuZGxlcnMuDQoNClZ1IHJlbmFtZXMgaG9zdF9w
YXJhbXMgYml0cyB0byBmdW5jdGlvbl9jaGFuZ2VkIGJpdHMgYW5kIGFkZCB0aGUNCnN1cHBvcnQg
Zm9yIGVzd2l0Y2ggZnVuY3Rpb25zIGNoYW5nZSBldmVudCBpbiB0aGUgZXN3aXRjaCBnZW5lcmFs
IGNhc2UuDQooZm9yIGJvdGggbGVnYWN5IGFuZCBzd2l0Y2hkZXYgbW9kZXMpLg0KDQpJbiBjYXNl
IG9mIG5vIG9iamVjdGlvbiB0aGlzIHNlcmllcyB3aWxsIGJlIGFwcGxpZWQgdG8gbWx4NS1uZXh0
IGJyYW5jaC4NCg0KVGhhbmtzLA0KU2FlZWQuDQoNCkVsaSBCcml0c3RlaW4gKDEpOg0KICBuZXQv
bWx4NTogSW50cm9kdWNlIHRlcm1pbmF0aW9uIHRhYmxlIGJpdHMNCg0KTW9zaGUgU2hlbWVzaCAo
MSk6DQogIG5ldC9tbHg1OiBBZGQgY29yZSBkdW1wIHJlZ2lzdGVyIGFjY2VzcyBIVyBiaXRzDQoN
ClBhcmF2IFBhbmRpdCAoMik6DQogIHtJQixuZXR9L21seDU6IE5vIG5lZWQgdG8gdHlwZWNhc3Qg
ZnJvbSB2b2lkKiB0byBtbHg1X2liX2RldioNCiAge0lCLG5ldH0vbWx4NTogQ29uc3RpZnkgcmVw
IG9wcyBmdW5jdGlvbnMgcG9pbnRlcnMNCg0KVnUgUGhhbSAoMik6DQogIG5ldC9tbHg1OiBFLVN3
aXRjaCwgUmVwbGFjZSBob3N0X3BhcmFtcyBldmVudCB3aXRoIGZ1bmN0aW9uc19jaGFuZ2VkDQog
ICAgZXZlbnQNCiAgbmV0L21seDU6IEUtU3dpdGNoLCBIb25vciBlc3dpdGNoIGZ1bmN0aW9ucyBj
aGFuZ2VkIGV2ZW50IGNhcA0KDQogZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVwLmMg
ICAgICAgICAgIHwgIDE5ICsrLS0NCiBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAu
aCAgICAgICAgICAgfCAgIDIgKy0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvY21kLmMgfCAgIDQgKy0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lY3BmLmMgICAgfCAgMjcgLS0tLS0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lY3BmLmggICAgfCAgIDQgLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuX3JlcC5jICB8ICAxNSArLS0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbl9yZXAuaCAgfCAgIDIgKy0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZXEuYyAgfCAgIDUgKy0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lc3dpdGNoLmMgfCAgMzIgKysrKystDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZXN3aXRjaC5oIHwgIDIwICsrKy0NCiAuLi4vbWVsbGFub3gvbWx4NS9jb3JlL2Vz
d2l0Y2hfb2ZmbG9hZHMuYyAgICAgfCAxMDcgKysrKysrKysrKy0tLS0tLS0tDQogLi4uL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXZlbnRzLmMgIHwgICA0ICstDQogLi4uL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZnNfY21kLmMgIHwgICAzICsNCiBpbmNsdWRlL2xp
bnV4L21seDUvZGV2aWNlLmggICAgICAgICAgICAgICAgICAgfCAgIDIgKy0NCiBpbmNsdWRlL2xp
bnV4L21seDUvZHJpdmVyLmggICAgICAgICAgICAgICAgICAgfCAgIDEgKw0KIGluY2x1ZGUvbGlu
dXgvbWx4NS9lc3dpdGNoLmggICAgICAgICAgICAgICAgICB8ICAyMCArKy0tDQogaW5jbHVkZS9s
aW51eC9tbHg1L2ZzLmggICAgICAgICAgICAgICAgICAgICAgIHwgICAxICsNCiBpbmNsdWRlL2xp
bnV4L21seDUvbWx4NV9pZmMuaCAgICAgICAgICAgICAgICAgfCAgMzMgKysrKy0tDQogMTggZmls
ZXMgY2hhbmdlZCwgMTc3IGluc2VydGlvbnMoKyksIDEyNCBkZWxldGlvbnMoLSkNCg0KLS0gDQoy
LjIxLjANCg0K

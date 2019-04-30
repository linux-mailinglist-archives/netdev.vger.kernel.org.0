Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F16C7FF85
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfD3SNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:13:04 -0400
Received: from mail-eopbgr30088.outbound.protection.outlook.com ([40.107.3.88]:19134
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726926AbfD3SND (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 14:13:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Be5Z26DLu8VjthGUK0YN3emGoe6WQ9tAAO3Uk6YtSz0=;
 b=MSUQmeFtCTFN+0eCjL5VSakHsFeV+cN8fXN3Ia53qJmgtp7KRXmUzm1N7xsnM3ABdQVR4ByAEz9rqukb51CjP/frSEAZP4Ih71PLcLi3AvhWbMUtUN17ogDQIFPWO4eUxd5k+9NU8XPuS73vPWe5dZjXdAjUGp+y0R2FzQIX4P8=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5553.eurprd05.prod.outlook.com (20.177.119.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 18:12:49 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f%2]) with mapi id 15.20.1856.008; Tue, 30 Apr 2019
 18:12:49 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf-next v2 07/16] net/mlx5e: Replace deprecated
 PCI_DMA_TODEVICE
Thread-Topic: [PATCH bpf-next v2 07/16] net/mlx5e: Replace deprecated
 PCI_DMA_TODEVICE
Thread-Index: AQHU/4BRUAobwWOyoEi1BPBlf6gEBA==
Date:   Tue, 30 Apr 2019 18:12:48 +0000
Message-ID: <20190430181215.15305-8-maximmi@mellanox.com>
References: <20190430181215.15305-1-maximmi@mellanox.com>
In-Reply-To: <20190430181215.15305-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0250.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::22) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a853e6bd-0d60-4338-3d58-08d6cd9773ce
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5553;
x-ms-traffictypediagnostic: AM6PR05MB5553:
x-microsoft-antispam-prvs: <AM6PR05MB555368E71B685F55E1930F99D13A0@AM6PR05MB5553.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(6506007)(3846002)(26005)(478600001)(316002)(97736004)(6116002)(446003)(76176011)(4326008)(476003)(486006)(8676002)(110136005)(52116002)(81166006)(6436002)(50226002)(54906003)(8936002)(99286004)(11346002)(81156014)(2616005)(66946007)(66556008)(256004)(66476007)(64756008)(66446008)(73956011)(36756003)(305945005)(71200400001)(71190400001)(14444005)(107886003)(102836004)(68736007)(86362001)(4744005)(7736002)(186003)(66066001)(6486002)(1076003)(386003)(5660300002)(53936002)(25786009)(6512007)(14454004)(7416002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5553;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ipYCL0TcZ18J+n1gcaynPAtvX8rk6MSqnbu4/MCS+laGtd6nyQKZFKBMWwvtXpN7M2wcxI82oX2UnKZ3F8D9z3VF6R+l72C1CERhurJyiHMMYdcbx38lkwBt2rGE5Ri+BOldO6USMrvVzA5g0GGFAvN3wDGPQqcwFLoPds8loDB3pGcLPa75ND2w22iGzkIjpQo6thkQB2osqJXGkk9k8GT7v+gZD5VT46e2tb5v0U9+GRR3Jm/LOl4XFZ9HaPdy0edi6q6pY95ZuLTb4+ZjgMSV6pyHW8zYo+FRzaJMBM+3HyVBCHCS0yYmR1LVgKuU9btZ+KPmVJtHh3H4Gg6KGraSoXEuBbDLiPFIZIlrjBShZBZ51YUUyAmNGp/ko92fcregkGLXUp8iHRpGBBpS52Rfx1XIBd2/Y8Ad4ni/vA4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a853e6bd-0d60-4338-3d58-08d6cd9773ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 18:12:48.9928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5553
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIFBDSSBBUEkgZm9yIERNQSBpcyBkZXByZWNhdGVkLCBhbmQgUENJX0RNQV9UT0RFVklDRSBp
cyBqdXN0IGRlZmluZWQNCnRvIERNQV9UT19ERVZJQ0UgZm9yIGJhY2t3YXJkIGNvbXBhdGliaWxp
dHkuIEp1c3QgdXNlIERNQV9UT19ERVZJQ0UuDQoNClNpZ25lZC1vZmYtYnk6IE1heGltIE1pa2l0
eWFuc2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogVGFyaXEgVG91a2Fu
IDx0YXJpcXRAbWVsbGFub3guY29tPg0KQWNrZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1A
bWVsbGFub3guY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuL3hkcC5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBk
ZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuL3hkcC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuL3hkcC5jDQppbmRleCBlYjhlZjc4ZTU2MjYuLjVhOTAwYjcwYjIwMyAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94ZHAuYw0KKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hkcC5jDQpAQCAt
NjQsNyArNjQsNyBAQCBtbHg1ZV94bWl0X3hkcF9idWZmKHN0cnVjdCBtbHg1ZV94ZHBzcSAqc3Es
IHN0cnVjdCBtbHg1ZV9kbWFfaW5mbyAqZGksDQogCQlyZXR1cm4gZmFsc2U7DQogCXhkcGkuZG1h
X2FkZHIgPSBkaS0+YWRkciArICh4ZHBpLnhkcGYtPmRhdGEgLSAodm9pZCAqKXhkcGkueGRwZik7
DQogCWRtYV9zeW5jX3NpbmdsZV9mb3JfZGV2aWNlKHNxLT5wZGV2LCB4ZHBpLmRtYV9hZGRyLA0K
LQkJCQkgICB4ZHBpLnhkcGYtPmxlbiwgUENJX0RNQV9UT0RFVklDRSk7DQorCQkJCSAgIHhkcGku
eGRwZi0+bGVuLCBETUFfVE9fREVWSUNFKTsNCiAJeGRwaS5kaSA9ICpkaTsNCiANCiAJcmV0dXJu
IHNxLT54bWl0X3hkcF9mcmFtZShzcSwgJnhkcGkpOw0KLS0gDQoyLjE5LjENCg0K

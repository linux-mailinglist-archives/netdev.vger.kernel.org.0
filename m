Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D53D5FC45
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 19:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbfGDRK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 13:10:29 -0400
Received: from mail-eopbgr10064.outbound.protection.outlook.com ([40.107.1.64]:43049
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725882AbfGDRK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 13:10:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tz9+e1+OvDKFAQZ9IarfvfoGbTqM1r1/8yrhxP13/pk=;
 b=UAkd5hawm+VIOeDAWwp0S9h8vSi0Rd/Tlesxns0ZrQxS18Dne/bWib7slYSvF/ytEMuS4Tn78av6Qa8I+JN0H97ZKGke83OClJ4dkxYah+lQLO7KXdQ3UIBJs/6m0Zg71RI3jz8aEgsicFHnlxvK3h6LyUaDKmM7EON+bQj3RRk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2341.eurprd05.prod.outlook.com (10.168.57.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 17:10:25 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 17:10:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/5] Mellanox, mlx5 low level updates 2019-07-02
Thread-Topic: [PATCH mlx5-next 0/5] Mellanox, mlx5 low level updates
 2019-07-02
Thread-Index: AQHVMXJveOPdXjGEB0qnqkH/hqttvKa6s9IA
Date:   Thu, 4 Jul 2019 17:10:25 +0000
Message-ID: <5c85e7cd688cc8727f421e4592304e66ccd018c7.camel@mellanox.com>
References: <20190703073909.14965-1-saeedm@mellanox.com>
In-Reply-To: <20190703073909.14965-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.3 (3.32.3-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.148.53.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d597d207-9dbc-43b7-caa0-08d700a28168
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2341;
x-ms-traffictypediagnostic: DB6PR0501MB2341:
x-microsoft-antispam-prvs: <DB6PR0501MB2341EC5353C8F3A558EA2E4EBEFA0@DB6PR0501MB2341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(53754006)(189003)(199004)(68736007)(6246003)(4744005)(99286004)(6116002)(6436002)(6862004)(6486002)(14454004)(3846002)(66066001)(256004)(450100002)(53936002)(6636002)(76176011)(15650500001)(14444005)(36756003)(26005)(4326008)(102836004)(186003)(316002)(37006003)(66556008)(6506007)(6512007)(86362001)(66476007)(81156014)(476003)(66946007)(446003)(8936002)(11346002)(73956011)(54906003)(486006)(71200400001)(5660300002)(8676002)(25786009)(118296001)(76116006)(71190400001)(91956017)(64756008)(66446008)(7736002)(2906002)(229853002)(81166006)(305945005)(478600001)(58126008)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2341;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0XR5hXbuQ27oJg4j26yFK6l0bkba6P/LNJ2XfEH4qC4pYjqYUml1kc5YuGiCWuQeGahh+nVssCpczL6LJXN+rgRHhyVo7PRhUWNIK+T0bb+XGQjir+QXFLUHJ84ettsztSf4rkYfOC7BGkche5fW27Ez1h3+MImYG+kXvJ8z5OOVO+KL2TFD/F1/jctAIogLsEREoYR9V9xYfZOH+IFQYhJZGxHoy9IDJtWjwARE8Dp3S+vkNVNx+R33kqEYxkZ/xhfsHQ57kmP257TdeG9tziZpmA33zbBlSOQIl7UEvDbeY2eLll8sx7mMrFhobjpk94jW7gA1gREFsJ4OxBcBbR8LUfLMQMopDRmVFa3t7JPU0PTSm9tU7pi4AjXzkY4vm4SZilAvDcydnzTiJTp039sGAU6O2XyehZ9Njznet5k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FA4D00A57580C4B9579213C2863EAE8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d597d207-9dbc-43b7-caa0-08d700a28168
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 17:10:25.1074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA3LTAzIGF0IDA3OjM5ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGkgQWxsLA0KPiANCj4gVGhpcyBzZXJpZXMgaW5jbHVkZXMgc29tZSBsb3cgbGV2ZWwgdXBk
YXRlcyB0byBtbHg1IGRyaXZlciwgcmVxdWlyZWQNCj4gZm9yDQo+IHNoYXJlZCBtbHg1LW5leHQg
YnJhbmNoLg0KPiANCj4gVGFyaXEgZXh0ZW5kcyB0aGUgV1FFIGNvbnRyb2wgZmllbGRzIG5hbWVz
Lg0KPiBFcmFuIGFkZHMgdGhlIHJlcXVpcmVkIEhXIGRlZmluaXRpb25zIGFuZCBzdHJ1Y3R1cmVz
IGZvciB1cGNvbWluZyBUTFMNCj4gc3VwcG9ydC4NCj4gUGFyYXYgaW1wcm92ZXMgYW5kIHJlZmFj
dG9ycyB0aGUgRS1Td2l0Y2ggImZ1bmN0aW9uIGNoYW5nZWQiIGhhbmRsZXIuDQo+IA0KPiBJbiBj
YXNlIG9mIG5vIG9iamVjdGlvbnMgdGhlc2UgcGF0Y2hlcyB3aWxsIGJlIGFwcGxpZWQgdG8gbWx4
NS1uZXh0DQo+IGFuZA0KPiB3aWxsIGJlIHNlbnQgbGF0ZXIgYXMgcHVsbCByZXF1ZXN0IHRvIGJv
dGggcmRtYS1uZXh0IGFuZCBuZXQtbmV4dA0KPiB0cmVlcy4NCj4gDQo+IFRoYW5rcywNCj4gU2Fl
ZWQuDQoNCkFwcGxpZWQgdG8gbWx4NS1uZXh0Lg0KDQo=

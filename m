Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C0A44A22
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfFMSCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:02:23 -0400
Received: from mail-eopbgr60058.outbound.protection.outlook.com ([40.107.6.58]:24148
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726860AbfFMSCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 14:02:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ei14I7/r6LbptSKJMUvSfwIxuKYpTA+k+N+a/nCPrLo=;
 b=DzY/CnpEqA8RLbLm0hR1aM21BIcrVFHEBuIPPB+PHEyp1iKKsWenvt/jkE4OvSR6xqQef1ZWbX8UnZoizmHvABao4+ZobKthkrBob9EMx0T9vGXwdEFARyG7nQ645oG9vb/6merSycpg40wWc5K4MnLXOcFztr8Y1V9b16navmM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2214.eurprd05.prod.outlook.com (10.168.56.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Thu, 13 Jun 2019 18:02:19 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 18:02:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 00/16] Mellanox, mlx5 next updates 10-06-2019
Thread-Topic: [PATCH mlx5-next 00/16] Mellanox, mlx5 next updates 10-06-2019
Thread-Index: AQHVH+WQKUAaOLo+ckSVksYLubbYd6aZ5HkA
Date:   Thu, 13 Jun 2019 18:02:19 +0000
Message-ID: <c1c038bc012806e704a39b2debabe39f8d33796c.camel@mellanox.com>
References: <20190610233733.12155-1-saeedm@mellanox.com>
In-Reply-To: <20190610233733.12155-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 658d1079-1120-4ca4-f6f8-08d6f02946f4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2214;
x-ms-traffictypediagnostic: DB6PR0501MB2214:
x-microsoft-antispam-prvs: <DB6PR0501MB22148A2384112C42726B509EBEEF0@DB6PR0501MB2214.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(366004)(136003)(39860400002)(53754006)(189003)(199004)(11346002)(2616005)(446003)(476003)(478600001)(14454004)(486006)(71190400001)(6512007)(2906002)(73956011)(66946007)(86362001)(64756008)(66446008)(66476007)(6246003)(102836004)(3846002)(186003)(68736007)(26005)(53936002)(71200400001)(229853002)(6486002)(15650500001)(6116002)(66556008)(256004)(6436002)(6636002)(8936002)(76176011)(99286004)(8676002)(36756003)(7736002)(58126008)(37006003)(6862004)(316002)(4326008)(54906003)(5660300002)(76116006)(91956017)(4744005)(305945005)(81166006)(25786009)(81156014)(6506007)(118296001)(450100002)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2214;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AkuYJRMBRDi+tkqF/c1oFsUA3/bcjkOVYjGtQhKhbmtcw9JCnzGxZir7xygBM+dquiX8zakWv1bDheRiSUsLSExanqTYvF9DFkHI8kIJWXlEcPLOKjezW4GHX1id4z+oWFkHwg7vEC2SEha/72IRoNSm60PwHT9pMujfu7HJtN6pz9q+tbPFCaTw7ZPhdhYYu7jem0L4eDMwkrE+6I5tNmZ22n9lcexbbCI5f5BY6tK4uw+jJh7HiWrRvw9dfglaqhfwsasEqullaW/pal68Cj+pSj/9V2XNBmX8Luo9upUD8iten0XTQbNt/62FtkuKZm4EGOBYnT2lb5S9Z341YcKo0nQqL98kcW36gIpJoka4tevy7kRMTb1l503tMsuLz+eHJ+tnYut49En4L20k6c+l7XEKbKgd4iW1rNqlXn0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F27127C8E97B5C489F24E500EE4090E7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 658d1079-1120-4ca4-f6f8-08d6f02946f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 18:02:19.1766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2214
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTEwIGF0IDIzOjM4ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGkgQWxsLA0KPiANCj4gVGhpcyBzZXJpZXMgaXMgYWltZWQgbWx4NS1uZXh0IGJyYW5jaCwg
aXQgaW5jbHVkZXMgYSBjb3VwbGUgb2YgbG93DQo+IGxldmVsDQo+IHVwZGF0ZXMgZm9yIG1seDVf
Y29yZSBkcml2ZXIsIG5lZWRlZCBmb3IgYm90aCByZG1hIGFuZCBuZXQtbmV4dA0KPiB0cmVlcy4N
Cj4gDQo+IDEpIEJvZG9uZyByZWZhY3RvcnMgcXVlcnkgZXN3IGZ1bmN0aW9ucyBzbyBoZSBjb3Vs
ZCB1c2UgaXQgdG8gc3VwcG9ydA0KPiBxdWVyeWluZyBtYXggVkZzIGZyb20gZGV2aWNlLg0KPiAN
Cj4gMikgVnUsIGhhbmRsZXMgVkYgcmVwcmVzZW50b3JzIGNyZWF0aW9uIGZyb20gVkYgY3JlYXRp
b24gaGFuZGxlcg0KPiBjb250ZXh0Lg0KPiANCj4gMykgRGFuaWVsLCBpbmNyZWFzZWQgdGhlIGZ3
IGluaXRpYWxpemF0aW9uIHdhaXQgdGltZW91dCBmb3IgbGFyZ2UNCj4gc3Jpb3YNCj4gY29uZmln
dXJhdGlvbi4NCj4gDQo+IDQpIFl1dmFsLCByZWZhY3RvcnMgSVJRIHZlY3RvcnMgbWFuYWdlbWVu
dCBhbmQgc2VwYXJhdGVzIHRoZW0gZnJvbQ0KPiBFUXMsDQo+IHNvIElSUXMgY2FuIGJlIHNoYXJl
ZCBiZXR3ZWVuIGRpZmZlcmVudCBFUXMgdG8gc2F2ZSBzeXN0ZW0gcmVzb3VyY2VzLA0KPiBlc3Bl
Y2lhbGx5IG9uIFZNcyBhbmQgVkYgZnVuY3Rpb25zLg0KPiANCj4gNSkgQXJpZWwsIGV4cGxvaXRz
IFl1dmFsJ3Mgd29yayBhbmQgdXNlcyBvbmx5IG9uZSBJUlEgZm9yIHRoZSA0IGFzeW5jDQo+IEVR
cyB3ZSBoYXZlIHBlciBmdW5jdGlvbiAoU28gd2UgY2FuIHNhdmUgMyBJUlEgdmVjdG9ycyBwZXIg
ZnVuY3Rpb24pLg0KPiANCj4gVGhhbmtzLA0KPiBTYWVlZC4NCj4gDQoNCkFwcGxpZWQgdG8gbWx4
NS1uZXh0LA0KDQpUaGFua3MhDQoNCg==

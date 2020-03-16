Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6905F1874A0
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732703AbgCPVRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:17:06 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:35509
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732669AbgCPVRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 17:17:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SjvvG9J8UktW52IxrIKk5c19PdL4y+TXgzY4RqdcQFLbhX0VFVTY5Up5m1C7bpqkKHnMj11cbUY8iVYhoA4jutmAbnQD5PMjtlRKfFnE7WXuIdFhKPJ1EAKFMU75IbzN7EOIjYrnEvfGpIu16k4rYWqpRg6T7+V/BFlbSdXh3B/t91CMndWF8jXUM0rwBk0wNUZ3vuy5cQ5hx0CuAf6rn1V6L/Yd0Xry09GevCgXyEyk1kj87ooDxXjZiC70MCvy+UF51vK+5o9JLtp7CfSrp8ntK1shC9yDwbIgrOaj0Sv0jaNxV0wv+BI6j+jmWqnS4Wzkh+kLC4wFMxeeHNG8Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eruYCWB3rUiNNZSF8GMhcXMTybxrxAwahilPTpj5aIk=;
 b=dwaA756e+FJ1IoV42keAJ4v8bAx/qLJH5ydwF44y7wc5dKxyZuRqbBwqUjc9bJAyghlhGt0fls4qKpPzzyOVwvoVcTWWHykW++XvHjEB82j3GQfIbEDZAi2wg3g9Elyvgx3n+GXTWvrzmvvWgJv+tCnLwmIjA61frn51KIbQfbh15tVYrdxWKhYTBbbYzAV3pJTinK1yCgF4gb0CHyVsatncQ22SMOc6oEFpIysBVpqyuMq0m/R9DkClhhrAWhlr+PsZY3332gLs8Lo6sYefOxW2yI5+flB30vEfYUP58clEMPUXyD3rmw/6ayO9Vxk5YUejeyrq36TN/rxLFxQEpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eruYCWB3rUiNNZSF8GMhcXMTybxrxAwahilPTpj5aIk=;
 b=ASILV4Ddizk1SBn+ijRFPeVclXkPHHYqj/2mJfX0mB6oWAW81miNowIG+lsUHeMUrUMvoCgqiyh5wLXeOfLoJcvyaBssN+Z5WJoBgF7Yr0zZY3UFHlUjT9SLPJvOxfzZxbCGx9ngNO4bcGSo0XFDYeKj71LD2SfvvaE+sC8XEvI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4926.eurprd05.prod.outlook.com (20.177.52.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.22; Mon, 16 Mar 2020 21:17:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.023; Mon, 16 Mar 2020
 21:17:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "natechancellor@gmail.com" <natechancellor@gmail.com>,
        Paul Blakey <paulb@mellanox.com>
CC:     Oz Shlomo <ozsh@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vlad Buslov <vladbu@mellanox.com>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH -next] net/mlx5: Add missing inline to stub
 esw_add_restore_rule
Thread-Topic: [PATCH -next] net/mlx5: Add missing inline to stub
 esw_add_restore_rule
Thread-Index: AQHV+bJnGd9AuASRPUuoZqjIc8S+FKhLvPOA
Date:   Mon, 16 Mar 2020 21:17:00 +0000
Message-ID: <f56f1ce8c78810021e1946530eb1661bb425171f.camel@mellanox.com>
References: <1581847296-19194-8-git-send-email-paulb@mellanox.com>
         <20200314034019.3374-1-natechancellor@gmail.com>
In-Reply-To: <20200314034019.3374-1-natechancellor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7a8a8cf1-d529-48dd-911e-08d7c9ef5e48
x-ms-traffictypediagnostic: VI1PR05MB4926:|VI1PR05MB4926:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4926754105DC7D5C2761D46DBEF90@VI1PR05MB4926.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:46;
x-forefront-prvs: 03449D5DD1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(199004)(76116006)(110136005)(6486002)(2906002)(5660300002)(54906003)(8676002)(81156014)(81166006)(6636002)(478600001)(8936002)(91956017)(316002)(36756003)(66946007)(107886003)(186003)(66476007)(86362001)(26005)(71200400001)(6506007)(66446008)(4326008)(64756008)(66556008)(6512007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4926;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qRelJKcJRxRvDindhktOl979f0MlC/XPfFUK08og3gGORlFcTH6no4Yk4KokIeq8/pa7+u1iWAGA1F263LcBxuMja8yXqsPyqARYJEJmW618yPa3u6+1VCJIB5r7PK8LD/hfYpktbt0mivzOOhmvRw1ZrCNwCZSgPCX/7vwFuzF9Is5s/a2ZhzFfqVDqWuTlXyJJL5OBC+a8W3PAmtEtgGvepLRGyYJB9qg71vEaHabHiT4fE3uwfNcqRytujiZLEBs6GsVEtD23FvIYQzG5yxoKEnu35GjVyMmMiMRO3XbaHBjRQF0v7XOJYPrWNEeye/OWdG+ZiGjNMCsLxnbD3RC08CVLB5N1GZYmc+nvCXrWhI1jyh0U82F1I6Qg+72N7fb4n2BZLejyQ/HMVGALDtEl4pMhvgg3D5HGqGgSrY/FNDkJSG1Cig3L51W2P+BV
x-ms-exchange-antispam-messagedata: 3v4W1dqwck4BfEvm4W1lcctyv4ROWthl8zRlkC4uao7Ecvh8dtFMKObG3AOrotAeYnv0A6+fCHI6gK3UgomXxvE1ZkAtO4ZOZ0/v3NT1ZbJ1/I5qsVIzmuJZucQQba3hH4yGxGcDRAqOozWc/VXsZA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B53DD095D64374EBC46AFFA184CE55C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a8a8cf1-d529-48dd-911e-08d7c9ef5e48
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2020 21:17:01.0406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: inj6a4nbZw5Qu/yc3zwmzcBd0ianU/qoinbgS+DxAyUxQkY/0A9fIB0Cagm9R3J6LwJcgFh2u42JlYS1fW9LYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4926
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAzLTEzIGF0IDIwOjQwIC0wNzAwLCBOYXRoYW4gQ2hhbmNlbGxvciB3cm90
ZToNCj4gV2hlbiBDT05GSUdfTUxYNV9FU1dJVENIIGlzIHVuc2V0LCBjbGFuZyB3YXJuczoNCj4g
DQo+IEluIGZpbGUgaW5jbHVkZWQgZnJvbQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvbWFpbi5jOjU4Og0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZXN3aXRjaC5oOjY3MDoxOiB3YXJuaW5nOg0KPiB1bnVzZWQNCj4gZnVuY3Rpb24g
J2Vzd19hZGRfcmVzdG9yZV9ydWxlJyBbLVd1bnVzZWQtZnVuY3Rpb25dDQo+IGVzd19hZGRfcmVz
dG9yZV9ydWxlKHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdywgdTMyIHRhZykNCj4gXg0KPiAxIHdh
cm5pbmcgZ2VuZXJhdGVkLg0KPiANCj4gVGhpcyBzdHViIGZ1bmN0aW9uIGlzIG1pc3NpbmcgaW5s
aW5lOyBhZGQgaXQgdG8gc3VwcHJlc3MgdGhlIHdhcm5pbmcuDQo+IA0KPiBGaXhlczogMTFiNzE3
ZDYxNTI2ICgibmV0L21seDU6IEUtU3dpdGNoLCBHZXQgcmVnX2MwIHZhbHVlIG9uIENRRSIpDQo+
IFNpZ25lZC1vZmYtYnk6IE5hdGhhbiBDaGFuY2VsbG9yIDxuYXRlY2hhbmNlbGxvckBnbWFpbC5j
b20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vz
d2l0Y2guaCB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxl
dGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lc3dpdGNoLmgNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZXN3aXRjaC5oDQo+IGluZGV4IDJlMDQxN2RkOGNlMy4uNDcwYTE2ZTYzMjQyIDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3
aXRjaC5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
c3dpdGNoLmgNCj4gQEAgLTY2Niw3ICs2NjYsNyBAQCBzdGF0aWMgaW5saW5lIGNvbnN0IHUzMg0K
PiAqbWx4NV9lc3dfcXVlcnlfZnVuY3Rpb25zKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQo+
ICANCj4gIHN0YXRpYyBpbmxpbmUgdm9pZCBtbHg1X2Vzd2l0Y2hfdXBkYXRlX251bV9vZl92ZnMo
c3RydWN0DQo+IG1seDVfZXN3aXRjaCAqZXN3LCBjb25zdCBpbnQgbnVtX3Zmcykge30NCj4gIA0K
PiAtc3RhdGljIHN0cnVjdCBtbHg1X2Zsb3dfaGFuZGxlICoNCj4gK3N0YXRpYyBpbmxpbmUgc3Ry
dWN0IG1seDVfZmxvd19oYW5kbGUgKg0KPiAgZXN3X2FkZF9yZXN0b3JlX3J1bGUoc3RydWN0IG1s
eDVfZXN3aXRjaCAqZXN3LCB1MzIgdGFnKQ0KPiAgew0KPiAgCXJldHVybiBFUlJfUFRSKC1FT1BO
T1RTVVBQKTsNCg0KQXBwbGllZCB0byBuZXQtbmV4dC1tbHg1IA0KDQpUaGFua3MsDQpTYWVlZC4N
Cg==

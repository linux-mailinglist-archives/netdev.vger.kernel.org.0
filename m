Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFD7A4F55
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 08:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbfIBGpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 02:45:21 -0400
Received: from mail-eopbgr20051.outbound.protection.outlook.com ([40.107.2.51]:28077
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726375AbfIBGpV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 02:45:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GolJbpg5gynI/21smxlDwqlyc8qler8Ghf571FWKc7JHfyyOdLJaf6RI3JnEybv61CKV8iGtMqSRCr2auwEURO4nORy5sGdqj50OQz7GHQZrNDgY5RiLxvubG/HLRf9df0MhHfxwoQOdt6sUajl9qxFY/nZewxdIOQMSZrByujvYD631EMP9nPmmbtIcB/LqydJEvVkmGr0F5OhFeBpszegZ1nhPegkDtOaJNIB/YgxtoPxITIvmBs7z0hF1nRue+TFVmAb2vdd5FlbFsPjIL+tYbJ5gVjXjKjldssux2zkyzixS1Dr2tF88EfI3jO3QUXsuiwbUzvCresfSBL6P9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7p6uwxAc/QmU0EBU66q3qI3CTDJZ6Rmc6uYY/O2Dms=;
 b=GpsrVfybTVFAm/7VAqKvru9XVoolFZZG1TuGH/KlfxjZbup/e6K1doIsjJN6I9RBiwVzRa67gWtlKo7iYUdjuRF9LqfmGuSA/UYVswBz0ggwvbPAo08WVK5LIVyQnBJsUybzmqshqR6Sukr+wPoOwzg6CRyf/QiUH9lP0CA1t0w07ayt5qJkS3Wz1JUgRMdEa13Wk3ekg/Q2gE5aK1rXcYxEkxZRoXCVnCwMKwNiGx8tWZnwcz9Q32JQMJx9H1sKDQuon5Ka0SPc93I9TAQpNcadBHXJ3zt1HwdVA+qcILr0tO7Llm43YY60YVoOja0MzuFJ3P/XTSM64zzyCQ+DwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7p6uwxAc/QmU0EBU66q3qI3CTDJZ6Rmc6uYY/O2Dms=;
 b=UhJSWo2qY6zSZ9/ymeAUeIMnZQgU+iomJUqvbnt0CmwQg4+gWqjNVKCkJCaKKv7KCOd5tNBQGinxgbN7zNKITHAOPjXy2/aU/wIaA7CKseNN4UClFQBcugoBrl7WBJ+2iMWFqmZEDiT0zH0dgld2BlnJxJ5Zx6A5cKXJnpCdA/w=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2658.eurprd05.prod.outlook.com (10.172.219.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Mon, 2 Sep 2019 06:45:16 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 06:45:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/5] Mellanox, mlx5 next updates 2019-09-29
Thread-Topic: [PATCH mlx5-next 0/5] Mellanox, mlx5 next updates 2019-09-29
Thread-Index: AQHVXsNqTpgpI39FF0GNuR1TlVUVtKcX9msA
Date:   Mon, 2 Sep 2019 06:45:16 +0000
Message-ID: <bb7ef7672dc2ca50cb70338eb61743b7db035dce.camel@mellanox.com>
References: <20190829234151.9958-1-saeedm@mellanox.com>
In-Reply-To: <20190829234151.9958-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36c6ac52-288a-4bd1-3320-08d72f711d76
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2658;
x-ms-traffictypediagnostic: AM4PR0501MB2658:|AM4PR0501MB2658:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB265868B6E733970710D2906CBEBE0@AM4PR0501MB2658.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(53754006)(189003)(199004)(3846002)(316002)(66556008)(66446008)(64756008)(118296001)(76116006)(91956017)(53936002)(8936002)(66946007)(66476007)(476003)(86362001)(5660300002)(6116002)(25786009)(478600001)(6436002)(15650500001)(99286004)(4326008)(6862004)(6246003)(450100002)(81156014)(54906003)(486006)(37006003)(76176011)(26005)(71190400001)(71200400001)(6636002)(14454004)(58126008)(8676002)(6506007)(256004)(14444005)(4744005)(7736002)(229853002)(2906002)(66066001)(2616005)(36756003)(102836004)(11346002)(186003)(6486002)(446003)(81166006)(305945005)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2658;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wLADI1ooidBY4x4QLG7QuI1u+wqIkP5u3WR7FJeaSs11d7zoTBfI2fpw4mN94Paeh5Q7ho+YFdF5ybiClRRmmRaozlUCV3OCR/C0nzZOf/ffdWdWRL0oWVmwVDsW1VGUl/7kXBSfFrN6b7HZJM80CzDLxj0P0q7f1aceaVnM6NSddufeZ8SECxSqTRS1PHCmy8rnwwD+oRCw/k+dQTbdrhlWU3/fBjDa48hJhnHlN70pXvlMRXSngWK92KoDlFcZcH0DTgLhngcNSkfaX1j168aPS91vRGNTeNi6z//sMIRy1HTB8nGhCwg5flHqP9aoMiOXkHLhRQi5NviKKWe70bgSduHYjhq6uVHBvCjcEakUd0xtitVj8hPyozqs4eP+Bcnz9CP9VbX+kIqmw2uYvJT8opb3uxQtLjJxPMfYH0I=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29961281661ABC4C9F27183FB29894E0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36c6ac52-288a-4bd1-3320-08d72f711d76
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 06:45:16.7360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G/cxPVYxSoEHVrToMP8xIOjxEU++XEVTYvFlbBMNZtt1g1ZdJaRNum9mBVhX/hrZnkFRC1bF8kSOGoKGc2cNpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2658
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTI5IGF0IDIzOjQyICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGkgQWxsLA0KPiANCj4gVGhpcyBzZXJpZXMgaW5jbHVkZXMgbWlzYyB1cGRhdGVzIGZvciBt
bHg1LW5leHQgc2hhcmVkIGJyYW5jaA0KPiByZXF1aXJlZA0KPiBmb3IgdXBjb21pbmcgc29mdHdh
cmUgc3RlZXJpbmcgZmVhdHVyZS4NCj4gDQo+IDEpIEFsZXggYWRkcyBIVyBiaXRzIGFuZCBkZWZp
bml0aW9ucyByZXF1aXJlZCBmb3IgU1cgc3RlZXJpbmcNCj4gMikgQXJpZWwgbW92ZXMgZGV2aWNl
IG1lbW9yeSBtYW5hZ2VtZW50IHRvIG1seDVfY29yZSAoRnJvbSBtbHg1X2liKQ0KPiAzKSBNYW9y
LCBDbGVhbnVwcyBhbmQgZml4dXBzIGZvciBlc3dpdGNoIG1vZGUgYW5kIFJvQ0UNCj4gNCkgTWFy
LCBTZXQgb25seSBzdGFnIGZvciBtYXRjaCB1bnRhZ2dlZCBwYWNrZXRzDQo+IA0KPiBJbiBjYXNl
IG9mIG5vIG9iamVjdGlvbiB0aGlzIHNlcmllcyB3aWxsIGJlIGFwcGxpZWQgdG8gbWx4NS1uZXh0
DQo+IGJyYW5jaA0KPiBhbmQgc2VudCBsYXRlciBhcyBwdWxsIHJlcXVlc3QgdG8gYm90aCByZG1h
LW5leHQgYW5kIG5ldC1uZXh0DQo+IGJyYW5jaGVzLg0KPiANCg0KQXBwbGllZCB0byBtbHg1LW5l
eHQNClRoYW5rcywNClNhZWVkDQo=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5F5148FF8
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgAXVPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:15:42 -0500
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:11140
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725765AbgAXVPm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:15:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRS8IPRQRp8uuBR7HFeRQ638t7jmb6vtFd2kMGE7EEklsfLorItV0pDwtLjh2Ym9FeL0iIJG8h7Q7qduaJXBfHOBu2NZVqZ1GAs/80aqTZzPwUHwrktWIoUbDdddTUBVLIBpeWiU346KOCl/36QYZ57MwHoeam+UtLu0qZswBe6f3QGBwrmvQuQ3z3gEQfTbTxKq8tKOrfG55aQUIR4KCxuJLjknVyRZS0Z9EmMEjaWuYbnaTe1n6+ljp+MbTMCQ0VSUPuoHBnw9iYZZfHOEKRGeXt/7EmAhPPNmPcQOl39uZBfqrQ5Skcwum8LTosjOgfQjgEMyTC15afMAnQEaVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZgLpvIuesQbbZJZi1ZqwyPT20jg5xqu6tuzQwUA38s=;
 b=Bwg8HwxhgOP5qKKeGflSj7PyNN3247NSC6Y2xPPPbYOJND8RA7ozeeT+bTiPbFS0e/FFK+t3ULOhR3hhxgTM3Kr7fNb0vMCzRI6tfqhBamPKKoP/dPRurLD/OPqQWkd0DCObc9wtO9k1Dc+5drrUXpgrtad2TeziDq7B+FymAd0RPsCXjpbmgiuuU+5+DXW3VvoE1sv1UBTZtZ7SeMzIYW6QHz/YmQDL/UA7sMm4koV3JqHsJMdLmx6lTjqGoLytxLXfrN/idb6VNqqE1UcJMuLtvkcjfEVBxIRRyYKXNW3PTwHzkqgPqXuDUASe5vsj+TMCqtf5xHkvkOdNj+vuCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZgLpvIuesQbbZJZi1ZqwyPT20jg5xqu6tuzQwUA38s=;
 b=CftKR0I8VYnG0uhupkIetb3HKOKgTfeokaa1eFm1QjsyHWF+CdppFQUFn0c/tOHVUzX4i0VfDpPp52r+BWXX27aHLk5VrMohMZyDguL6DywFyMd3VXDeZ8PQE6ImuTDauy1LtXQcV3pXkst1uGrfVdXf9f+FgnzQTFhU/cNrAPE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5534.eurprd05.prod.outlook.com (20.177.203.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 21:15:38 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 21:15:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>
Subject: Re: [PATCH mlx5-next] net/mlx5: Add bit to indicate support for
 encap/decap in sw-steering managed tables
Thread-Topic: [PATCH mlx5-next] net/mlx5: Add bit to indicate support for
 encap/decap in sw-steering managed tables
Thread-Index: AQHV0bfildO3/fmBk0KPwytw+zNPB6f6U2cA
Date:   Fri, 24 Jan 2020 21:15:38 +0000
Message-ID: <66a3db5c32af1e93cbd066e9146975c65c29651c.camel@mellanox.com>
References: <20200123063904.685314-1-saeedm@mellanox.com>
In-Reply-To: <20200123063904.685314-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e16654e9-05d4-4274-6b80-08d7a1128fc2
x-ms-traffictypediagnostic: VI1PR05MB5534:|VI1PR05MB5534:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB55346E7E7155703DB6346484BE0E0@VI1PR05MB5534.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(366004)(39850400004)(396003)(199004)(189003)(8936002)(6486002)(6636002)(2616005)(6862004)(107886003)(36756003)(316002)(37006003)(66446008)(54906003)(4744005)(66556008)(76116006)(2906002)(81166006)(26005)(64756008)(81156014)(66476007)(66946007)(91956017)(8676002)(86362001)(6512007)(71200400001)(5660300002)(4326008)(478600001)(450100002)(6506007)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5534;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NT1yYGd2w6i1lPJUrB/HXAP6VFwheZVwrbmgBpKL1wNh1j7TKMj+4yRqil207aZlf8UQBgt0LM9HGcweX1NXbElAkwOW74cTF2IgrdGsZdZs4BA5dDi1NMgluKf5wq5XxERNLXksxo6Q5xSmcFozTR+71itUZ349PU5+NoCXUACfPz+BJnewHGrOf/8KdPMOiLm2SQ1HlgWhoeBEYpZLUZxw/Bprfhu648JV1WqT/ns191+z6VBZJ4bBtb3ZrFxtKhDPRTcPPGLvIOpn6DXD8UlMoILLpGnYeVqy01UuBfJPHoPu2i4gdaQ+IK6qK8wEpU9o9P2Is8u504wsv3DNyFBJVYewD9jSscM+IVspk+hDBO2BrUi/dk+3VxsxPysdxCOrvbEWPhdjoeO5UNu+jZxBBzcpQ7r0oyLGCAfIcyQyzf1k+M6kVYc15xjc68k+
Content-Type: text/plain; charset="utf-8"
Content-ID: <C80C5170D4D4B74EAAAD7FEAFBAB7EF0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e16654e9-05d4-4274-6b80-08d7a1128fc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:15:38.8361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cXat6vhnXcMmpmKtpHnrnsfa405OufB8zt9foUsQNrSLCnSOgmiBti/4YytFSeHuqZfyK/LmTdwNk9Hj3zQVuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAxLTIzIGF0IDA2OjM5ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gRnJvbTogRXJleiBTaGl0cml0IDxlcmV6c2hAbWVsbGFub3guY29tPg0KPiANCj4gV2hlbmV2
ZXIgc2V0LCB0aGUgRlcgYWxsb3dzIGRyaXZlciB0byBvcGVuIHN3LXN0ZWVyaW5nIHRhYmxlIHdp
dGgNCj4gZW5jYXAvZGVjYXAgYWJpbGl0eS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEVyZXogU2hp
dHJpdCA8ZXJlenNoQG1lbGxhbm94LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1l
ZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+IC0tLQ0KPiAgaW5jbHVkZS9saW51eC9tbHg1L21s
eDVfaWZjLmggfCA1ICsrKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pDQo+IA0KQXBwbGllZCB0byBtbHg1LW5leHQNCg0KVGhhbmtzLA0KU2FlZWQu
DQo=

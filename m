Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA9D1686C5
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgBUShy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:37:54 -0500
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:22082
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726066AbgBUShy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 13:37:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPgpeUYalIQQrr5Ky2wkxve4wW194YUf18NocRhYsjPyfhyOwxN0k8EcUmA05eHDLlc1PWfElAcW5QJfwhEJXrqNrE6xw0/wvnMYipOK0zl6t7lBKlr4rz6+DYavrcXwES+hiGyLH/i1kEEF6iyfYxvupkVNFmLjAZ2Qb2ZGdIelmGPlKBKqrnn6sCjfNqjAotSmVETtVER6bsPG0j9rQopCtyuLP1oPVaVEMY/FgI/kEFoII05vcYgw+hWRZl5r1yMQpS2hJ7/6YR8kNegoX2rEScboImChif1XuAmVsz5RPhZt1H0XPvxdo1JYdNdK17YcZP2KOGzz9tQbobPLAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSmglGTY9yUYZqBhk++xyWetha2tpbfuFMmUc0nSPR8=;
 b=nL8w5pVowVqz91aaS89U9hUFaB4c8yVKtqn/AojOidllr42k9mqsASB10rslPp66+1/mlAm8pV6/cqSOxPt4mjqgwaDyb88fnFOwxhsvZLy9ElVAwsCWQ1r0zatm1xe/frQHd9Wd2wRrz80nnk1bDhuzbozGA0xJbO0rL0xFXNrLYCPl/z5NHB+YqCKa5HV1+CMSLll5oenHs8GAE7KZln8HOZIU3WS+7pyy6cJe+1JGQvxzPFXFLYVnZ1DvJI9TEVVAzBDNSnNNfOBTlbLUIR7D/6cNbHGP7AJpnHXaEaKA3eS0WUeVO0hkne2gsqBjkdSEZVVbYPwBbM5XSeSUkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSmglGTY9yUYZqBhk++xyWetha2tpbfuFMmUc0nSPR8=;
 b=PuhoUDSgCBGUuNOl5xMQi7+iPd2Z+MpfiGOvdnm57UwPllaMRhDMPCiFOIA0S/XDQCAdPJ8RagN0JTDVJgA9MKW2u32eAgo0gUnxJr4N1vqlSOqlH/M2M2HjsBY2G/t0OKzdkOcVsrcEbMQZZDjeLUWdZfQA0ep4Jqk/MIIe2mE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5968.eurprd05.prod.outlook.com (20.178.127.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Fri, 21 Feb 2020 18:37:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 18:37:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "natechancellor@gmail.com" <natechancellor@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>, Aya Levin <ayal@mellanox.com>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: Fix header guard in rsc_dump.h
Thread-Topic: [PATCH net-next] net/mlx5: Fix header guard in rsc_dump.h
Thread-Index: AQHV6HdBTg8zQMdEMEKdK2dIQcVUnagl+xgA
Date:   Fri, 21 Feb 2020 18:37:50 +0000
Message-ID: <89dda0680320d0ce1b42093e59985313e2a1ac50.camel@mellanox.com>
References: <20200221052437.2884-1-natechancellor@gmail.com>
In-Reply-To: <20200221052437.2884-1-natechancellor@gmail.com>
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
x-ms-office365-filtering-correlation-id: f1d02762-97f9-4eed-7f72-08d7b6fd279e
x-ms-traffictypediagnostic: VI1PR05MB5968:|VI1PR05MB5968:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB596847E3E8232729EA728B43BE120@VI1PR05MB5968.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:229;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(396003)(376002)(39860400002)(189003)(199004)(5660300002)(36756003)(86362001)(2906002)(8936002)(4744005)(8676002)(71200400001)(81156014)(81166006)(6486002)(4326008)(6512007)(316002)(6506007)(186003)(26005)(110136005)(54906003)(66446008)(66476007)(91956017)(2616005)(76116006)(66946007)(66556008)(478600001)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5968;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0bzVXhFmKcH6Yglesvhqb1VKqOZGcrBL6qbpJ+5Uc2qNhp0KBT6Sg7b1cez39QbjKPsSWJ8fuv+6FaoIfQpNWBQSM8i+Fbm/bb1PR27UC6QFjTVnNZbMDy4g7htg+Ad1uv+v+CSvySgTIHOTSaxy3xU3RogvwnrsZiFqqWmiA7VFT+adJXV7EmYSoJUb9JjNXtd7HxjET2DwNWuC1PwXyn+aFpqkbGo9uiX/0SwL2ZpsHbLnnOREHOtux6PuWC+mZdduoYhTEc1yBPDr6BHS99cu/UUvI0zO5w7PrTFxwiQTIlToIYCvfp9jfReCR76KuYY1dbNwTaeband6a2iwnGbrgFveU63cjZ1azUvG/Lpf62SWuISrInJjggI+/eFhBykLc8ochJJhmHXa3gc4J3OqHg/gw6hu1Vv+fpGXXMPODJR4gY/yLkIPWHop+eR7
x-ms-exchange-antispam-messagedata: 3IKRUe4aCzIBgJioEnbTTCqO0LRMOoah26M1f/ShnICZoQOiwWLn55lCZ8jDkTW2dN6AmF8KFTlDm4r4lXNUsalpztCRH8XqzteUNuIhJJSvUkpAKu+DI4jSd6v8Z9gHHujDqFuh2R0qd7Ij5XO3/A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <C593F7259EC27949B0E1551062C5DA78@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d02762-97f9-4eed-7f72-08d7b6fd279e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 18:37:50.2605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gLWLO9GJGivOs0P8tzjCrOYrYmOIrwbGmylIjdDOxDUozawSIb2OLTOCUiNTtbH/kVyePJVz4sVkWh8P/w28Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAyLTIwIGF0IDIyOjI0IC0wNzAwLCBOYXRoYW4gQ2hhbmNlbGxvciB3cm90
ZToNCj4gQ2xhbmcgd2FybnM6DQo+IA0KPiAgSW4gZmlsZSBpbmNsdWRlZCBmcm9tDQo+ICAuLi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jOjczOg0KPiAgLi4v
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2RpYWcvcnNjX2R1bXAuaDo0
Ojk6DQo+IHdhcm5pbmc6DQo+ICAnX19NTFg1X1JTQ19EVU1QX0gnIGlzIHVzZWQgYXMgYSBoZWFk
ZXIgZ3VhcmQgaGVyZSwgZm9sbG93ZWQgYnkNCj4gI2RlZmluZQ0KPiAgb2YgYSBkaWZmZXJlbnQg
bWFjcm8gWy1XaGVhZGVyLWd1YXJkXQ0KPiAgI2lmbmRlZiBfX01MWDVfUlNDX0RVTVBfSA0KPiAg
ICAgICAgICBefn5+fn5+fn5+fn5+fn5+fg0KPiAgLi4vZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2RpYWcvcnNjX2R1bXAuaDo1Ojk6DQo+IG5vdGU6DQo+ICAnX19NTFg1
X1JTQ19EVU1QX19IJyBpcyBkZWZpbmVkIGhlcmU7IGRpZCB5b3UgbWVhbg0KPiAnX19NTFg1X1JT
Q19EVU1QX0gnPw0KPiAgI2RlZmluZSBfX01MWDVfUlNDX0RVTVBfX0gNCj4gICAgICAgICAgXn5+
fn5+fn5+fn5+fn5+fn5+DQo+ICAgICAgICAgIF9fTUxYNV9SU0NfRFVNUF9IDQo+ICAxIHdhcm5p
bmcgZ2VuZXJhdGVkLg0KPiANCj4gTWFrZSB0aGVtIG1hdGNoIHRvIGdldCB0aGUgaW50ZW5kZWQg
YmVoYXZpb3IgYW5kIHJlbW92ZSB0aGUgd2FybmluZy4NCg0KQXBwbGllZCB0byBuZXQtbmV4dC1t
bHg1DQoNClRoYW5rcyAhDQoNCg==

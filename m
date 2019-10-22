Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE0BE0B2F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbfJVSGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:06:18 -0400
Received: from mail-eopbgr60071.outbound.protection.outlook.com ([40.107.6.71]:36199
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727154AbfJVSGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 14:06:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTarC1YV9jIL1vQU1UJueEFBzEoMGBwCJujV1q2lFVVW4La2wO/0KPqwoB8PxgzahZfEGWNuRGqLSoCPsLDteWaepQxaq6vN5VRH8yXBo2iMY3CuNPXbvuPPTp7KW0mpw3m+DgwLjGqPmWl0iYOg+mRWSy5QuP9i6liEw/k5vMFFCGTSsvWDCCaJ8QasHJjJLh2z7oiH4dZhQJ0uLpsjTbhTI/xlcboX0e6BVLbt7bA7SqxYbf+D3lBZ+MNOx9bzzVsnunkY1IMcNg7pgxpNL9bpaDGctyCiGXvgYn+NfZvFEX7lQJcMuxW9W/6g1D7hIUxjHlL0CExPjcVPhT4EfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a96WdSw6hQDKbqWhTokV1GehYfeRmvSwcxOWNNuV9Ns=;
 b=SH6cAeoDcs7qLB0LeCEAD4CjE5U32cfCmrvfW6nYsVLOrlENnd2XvpF+Xvwd6tMDbEYH3vKUqsE9yo8AceJXzmAAjCIAPVKy6N5Hy8A/wkeE1++rKh0CT9MErYVanAE0jrYj5MAhM8X5vpAYKh2AmbX2KCa8fi5uogmh5+50Egioy6BWoOWZHU6onvaqMO2QvHrAiArSOJ3agpD5Af/cQ3VLtivNGxXr719K0NrhVglRgCWTDZHLn+xLEi++f/70oWWUIEkWMK06vt8o2rgW3jpnOjteG7rNeY6b4ApQc2aFkzwOBkImvCKp2bZHbjh4alcHMm0TGhXYEOTEevix+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a96WdSw6hQDKbqWhTokV1GehYfeRmvSwcxOWNNuV9Ns=;
 b=WscLEPikjNT5cF2PLEUn4Iiq94JURoIoDIPuJ5IHuKyq7ZN5No2OphSHyYNUrT8oTcUj2GY/Z5+U49y2p6eEL+d/oEPtI0VueeaYtMM1vgVHAcN7RaYuEd1lHcgaa+woqy69jqHMqUsV7WSKvNz5ULYPJbD1oV5l0TYLveAVFtg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3214.eurprd05.prod.outlook.com (10.175.243.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.21; Tue, 22 Oct 2019 18:06:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 18:06:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     Eran Ben Elisha <eranbe@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 04/15] net/mlx5e: kTLS, Size of a Dump WQE is fixed
Thread-Topic: [net 04/15] net/mlx5e: kTLS, Size of a Dump WQE is fixed
Thread-Index: AQHVheuSwzOlP/azmUesItL6CNiDzKdhB1YAgAXzlYA=
Date:   Tue, 22 Oct 2019 18:06:11 +0000
Message-ID: <9dfe7833e5b0a5f9a664c0207e79756c8a868e23.camel@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
         <20191018193737.13959-5-saeedm@mellanox.com>
         <20191018161302.7dffc832@cakuba.netronome.com>
In-Reply-To: <20191018161302.7dffc832@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 296fb97a-9072-4f5e-ee92-08d7571a85b8
x-ms-traffictypediagnostic: VI1PR05MB3214:|VI1PR05MB3214:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3214C81348DD0EC5D3DB1648BE680@VI1PR05MB3214.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(199004)(189003)(66066001)(229853002)(6512007)(4744005)(6246003)(6486002)(2351001)(5640700003)(6116002)(3846002)(107886003)(4326008)(7736002)(305945005)(25786009)(81166006)(81156014)(8676002)(8936002)(478600001)(14454004)(64756008)(118296001)(66556008)(66476007)(76116006)(91956017)(6916009)(66946007)(66446008)(6436002)(102836004)(316002)(54906003)(58126008)(446003)(11346002)(186003)(2616005)(476003)(5660300002)(486006)(36756003)(71200400001)(4001150100001)(86362001)(26005)(2501003)(256004)(99286004)(71190400001)(76176011)(6506007)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3214;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5pSMhN43G2ZN7qGx2clJ5H5XhHjWxb58ElcsbDeX7y9lhAU5eigpd0dfR3VOWMfOPfT05fwqL3/8eZcDSrJT6WHa6u544cWdMiZI8Ekxcz/u/pfpaAE9xk/VuBxMIabHmkyCxeScAhgC2kKGjoZOiIJfyT34GlEeNaFR9c3AoZqdS3fbKEy7B4sea0P5fVQ7hxfmshCLRPdztUUDPWx5Gennzx/5zui3hiL5zyrxpynt2GFICZ+u9i1aiWpqoCNPAYF9OAc/KQGnWv6FPJS9HSbWkPgbKY48zd0IurraC04CQy8leMELxxItvv4nmDHPX1DHChKBzUvyzGsB06ZUXcNXEwTu7y8R+p1Xsy3bUVtsQFoaQgzVzMD3lNnXJBNpOUrrvTJMpa9cWAdhQBp2YAdMzXyR4UVXV4UxO2ZcS5BfZg0N/RAW1u6NjxNbrJxa
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC695841B50A844F90AB62BB7FCA3E80@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 296fb97a-9072-4f5e-ee92-08d7571a85b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 18:06:11.8801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: At0HLeTYTQwNKKU4Uno7JQAXX1GLNDwETImC5x9g+EtVGzaMSO147xqqbN6uo7x+6IuulmoOI+WTIhUWfF2aGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3214
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTE4IGF0IDE2OjEzIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAxOCBPY3QgMjAxOSAxOTozODowOSArMDAwMCwgU2FlZWQgTWFoYW1lZWQgd3Jv
dGU6DQo+ID4gRnJvbTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPiA+IA0K
PiA+IE5vIEV0aCBzZWdtZW50LCBzbyBubyBkeW5hbWljIGlubGluZSBoZWFkZXJzLg0KPiA+IFRo
ZSBzaXplIG9mIGEgRHVtcCBXUUUgaXMgZml4ZWQsIHVzZSBjb25zdGFudHMgYW5kIHJlbW92ZQ0K
PiA+IHVubmVjZXNzYXJ5IGNoZWNrcy4NCj4gPiANCj4gPiBGaXhlczogZDJlYWQxZjM2MGU4ICgi
bmV0L21seDVlOiBBZGQga1RMUyBUWCBIVyBvZmZsb2FkIHN1cHBvcnQiKQ0KPiA+IFNpZ25lZC1v
ZmYtYnk6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4gPiBSZXZpZXdlZC1i
eTogRXJhbiBCZW4gRWxpc2hhIDxlcmFuYmVAbWVsbGFub3guY29tPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiANCj4gSXMgdGhpcyBh
IGZpeD8NCg0KDQpzb3J0IG9mLCB0aGlzIHBhdGNoIGZ1bmRhbWVudGFsbHkgY2hhbmdlcyB0aGUg
d2F5IG1seDUgdHJlYXRzIGtUTFMgVFgNCmRlc2NyaXB0b3JzLCB0byBtYWtlIGRvd25zdHJlYW0g
cGF0Y2hlcyBzaW1wbGVyIGFuZCBtb3JlIGNvcnJlY3QuDQo=

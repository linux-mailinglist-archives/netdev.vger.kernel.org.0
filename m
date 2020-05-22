Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8E31DF35F
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbgEVX67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:58:59 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:51552
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731169AbgEVX66 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 19:58:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHbj08OywvOt1PTfMaL4+TH+ivT8RPUx3rXo5gumC1AGlzCq6fdfagyVHaIWNyDQzDog/IJKmiqtV7GHwOpvX9DMUo+oGMkpBkynTP2wUyMQJiTDx18imqbJwOYD6MXmNpyBbWy+RFhmfv5aVNJr1cP6B3y7yLIPXJUxLI89pzkmNB5jHEeJZ0S0TV2mYxnpkVqFsRzBM0NqjdMSgaVSqKXO3AzhMyi4Ifd21dIWGHJxB2nRu1og47EjzXwAjSraEdDe6sMJTGxtpv0ry9SG+JcZtk+HTcwGxJ2p9Xj+0nG6ooZc+JTJybW2MW8zG/zVkpDJ0WhoMd6XDHGH9pLI4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRfqYeKdHak+NNF1F/r3U471DXHHXsTzB13LcD3Ajww=;
 b=fY/48SNBgN1mrn7UG9lFiRVqXdjXHbBjhgJvkMF0eKlKzEKDsZEWnIaoSsDCgocUw78vUDdFeNi5SLkjvHY24b4MxYR6xYM5wcvhyLFzfckhesMObqB9QBwUOnhZWXNVrEjPriu9MsxIDinQ8jZfOERmQwh7NOkTAq9znTXvPklB6A7VnjNx5O1i+ACWb1h3KNkQqD3dl108dFijFIZm31a4Csa08Fh78EuREj0nV1PBKZoVighkWdvRr2B8KoninY8pHcBZjXUEBIKxQ1gS/g4ELcR/jykkkfVeWEZafhjrV5oZXAjqvTNqCmQzcVb9lo7+EqWY/oWrNQYmQ6TL8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRfqYeKdHak+NNF1F/r3U471DXHHXsTzB13LcD3Ajww=;
 b=Ti/D6UMNh/SmSm4PNxRBc7JGqdAGHEbD5yTqV7/WNrAeDpmlVF8Oy1/9Ufq7GR4N2f0RrAwChNmPGWcZWEhKmncShb+T4xsrkbx9LGL46Mz1pu4VtZlEzesBitHOwikdbhcH+gee3A3996GjJjidgGtlw6NuqLzkd4jIE7PKzyI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5136.eurprd05.prod.outlook.com (2603:10a6:803:ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Fri, 22 May
 2020 23:58:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Fri, 22 May 2020
 23:58:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next 00/10] mlx5 updates 2020-05-22
Thread-Topic: [pull request][net-next 00/10] mlx5 updates 2020-05-22
Thread-Index: AQHWMJQB3QrkotHVWEqYmTvnRAZXkKi0yLsA
Date:   Fri, 22 May 2020 23:58:54 +0000
Message-ID: <c6ac542772b302383c8c16207aa7282603bff6ce.camel@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
In-Reply-To: <20200522235148.28987-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 97ceca87-3b86-4b62-f86d-08d7feac158f
x-ms-traffictypediagnostic: VI1PR05MB5136:
x-microsoft-antispam-prvs: <VI1PR05MB513678D1E5A662BB417B8FCCBEB40@VI1PR05MB5136.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04111BAC64
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4q3FsOyRocr/Lad6MGn72WfJj61GeSOsUaOYHkW/BBve3ZYMpganiNkyFHTlJ+DZEeR83eMPsyr8NV9ZFuf+o/d5B7CQsXptY6nPF74wpPBUMKlXC1ciznzbjxj0DUh5c807RAHLVXUDtkp3MWk2wtL1WJlgi6cSXCgUNDd0jDCZNZjqO79oGqhliNNR2nbMJjslAlLqINcd7DXBJAvwlIIHfBUSkfe///LIqcCVuxhk9sRFOj4HryrXvjGiJgWpQbXKXBIvW9TWVMzmzHayHnvRc7kbkz4unW23TLC32QNYx2t7pqTtvHU6/izcT9bK66/5lwC4qfhAOfqINOCzkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(4326008)(66946007)(86362001)(6506007)(2616005)(2906002)(8676002)(26005)(8936002)(186003)(316002)(76116006)(91956017)(6512007)(66476007)(15650500001)(110136005)(66556008)(66446008)(64756008)(71200400001)(5660300002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3SbCn3O/+8wM8h3p/AZ7RY8+KAwi7oRihPhqvdgyB66epAvkmUHhKAbQuzawfBiM7eP4vPFc1EwQeU0S11TZladJwS/Ll2rBLHSJvkxC+51+DakJ8K95DRd1zrdPi8Bsn/aCbFhIlF2Hh6VyJLXpVWpvzR17ZGyGiuMC4AzupL4p5iT2PVCjYF4LyzawOO0Yzupq95LwTrUTtuSjbPbTNql32KLSaafZeriSAMx8idHa72lR1+baDaNCnlih9HXwqZnPHdy/l97Ldbah+Yb02tsIeQugMRk0d5G2vn0zyhTu897zauC2wDoiLpjjPIfqhQ/8vdDMx/j1Y0biGa+vDdECwhWfaxVyHavMBEtDrNbaQYlC7t808zspUBpNAnwlvRN/mG+KZ3wav4XQCH3XRne8Fiv6owl+NzsBeQ/kGO7y7xxrol+6p8kCKB5QZZQl0EmD47qLkcVzBAmrnLIVknxbVigANdOSS/cPTf+exAc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F9F206797A43440A3757AF4D7007DEC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ceca87-3b86-4b62-f86d-08d7feac158f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2020 23:58:54.4142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +7zIbx9oO0m8/gwD0c4lutZhJqIfZm4zb/Bn3Qx8cMj3Pbxszn0/yqdNeMKjue7/gIR2RrLugamPFyP3dbxTzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA1LTIyIGF0IDE2OjUxIC0wNzAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGkgRGF2ZS9KYWt1Yg0KPiANCj4gVGhpcyBzZXJpZXMgYWRkcyBtaXNjIHVwZGF0ZXMgdG8g
bWx4NSBkcml2ZXIuDQo+IEZvciBtb3JlIGluZm9ybWF0aW9uIHBsZWFzZSBzZWUgdGFnIGxvZyBi
ZWxvdy4NCj4gDQo+IFBsZWFzZSBwdWxsIGFuZCBsZXQgbWUga25vdyBpZiB0aGVyZSBpcyBhbnkg
cHJvYmxlbS4NCj4gDQoNCkkgZm9yZ290IHRvIG1lbnRpb24gdGhhdCB0aGVyZSBpcyBhIHNsaWdo
dCB0b3VjaCBvdXQgc2lkZSBtbHg1IGluIHRoaXMNCnNlcmllcyB0byBpbmNsdWRlL25ldC9iYXJl
dWRwLmggdGhhdCBhZGRzOiAgbmV0aWZfaXNfYmFyZXVkcChuZXRkZXYpIA0Kc28gdGhlIG5ldCBk
ZXZpY2UgY2FuIGJlIGlkZW50aWZpZWQgYXMgYSBiYXJldWRwIG9uZS4gaXQgaXMgcHJldHR5DQpz
dHJhaWdodCBmb3J3YXJkLiAgIA0KDQpbLi4uXQ0KDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IG1seDUtdXBk
YXRlcy0yMDIwLTA1LTIyDQo+IA0KPiBUaGlzIHNlcmllcyBpbmNsdWRlcyB0d28gdXBkYXRlcyBh
bmQgb25lIGNsZWFudXAgcGF0Y2gNCj4gDQo+IDEpIFRhbmcgQmltLCBjbGVhbi11cCB3aXRoIElT
X0VSUigpIHVzYWdlDQo+IA0KPiAyKSBWbGFkIGludHJvZHVjZXMgYSBuZXcgbWx4NSBrY29uZmln
IGZsYWcgZm9yIFRDIHN1cHBvcnQNCj4gDQo+ICAgIFRoaXMgaXMgcmVxdWlyZWQgZHVlIHRvIHRo
ZSBoaWdoIHZvbHVtZSBvZiBjdXJyZW50IGFuZCB1cGNvbWluZw0KPiAgICBkZXZlbG9wbWVudCBp
biB0aGUgZXN3aXRjaCBhbmQgcmVwcmVzZW50b3JzIGFyZWFzIHdoZXJlIHNvbWUgb2YNCj4gdGhl
DQo+ICAgIGZlYXR1cmUgYXJlIFRDIGJhc2VkIHN1Y2ggYXMgdGhlIGRvd25zdHJlYW0gcGF0Y2hl
cyBvZiBNUExTb1VEUA0KPiBhbmQNCj4gICAgdGhlIGZvbGxvd2luZyByZXByZXNlbnRvciBib25k
aW5nIHN1cHBvcnQgZm9yIFZGIGxpdmUgbWlncmF0aW9uDQo+IGFuZA0KPiAgICB1cGxpbmsgcmVw
cmVzZW50b3IgZHluYW1pYyBsb2FkaW5nLg0KPiAgICBGb3IgdGhpcyBWbGFkIGtlcHQgVEMgc3Bl
Y2lmaWMgY29kZSBpbiB0Yy5jIGFuZCByZXAvdGMuYyBhbmQNCj4gICAgb3JnYW5pemVkIG5vbiBU
QyBjb2RlIGluIHJlcHJlc2VudG9ycyBzcGVjaWZpYyBmaWxlcy4NCj4gDQo+IDMpIEVsaSBDb2hl
biBhZGRzIHN1cHBvcnQgZm9yIE1QTFMgb3ZlciBVUEQgZW5jYXAgYW5kIGRlY2FwIFRDDQo+IG9m
ZmxvYWRzLg0KPiANCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBFbGkgQ29oZW4gKDUpOg0KPiAgICAgICBuZXQ6IEFk
ZCBuZXRpZl9pc19iYXJldWRwKCkgQVBJIHRvIGlkZW50aWZ5IGJhcmV1ZHAgZGV2aWNlcw0KPiAg
ICAgICBuZXQvbWx4NWU6IEFkZCBzdXBwb3J0IGZvciBodyBlbmNhcHN1bGF0aW9uIG9mIE1QTFMg
b3ZlciBVRFANCj4gICAgICAgbmV0L21seDVlOiBBbGxvdyB0byBtYXRjaCBvbiBtcGxzIHBhcmFt
ZXRlcnMNCj4gICAgICAgbmV0L21seDVlOiBBZGQgc3VwcG9ydCBmb3IgaHcgZGVjYXBzdWxhdGlv
biBvZiBNUExTIG92ZXIgVURQDQo+ICAgICAgIG5ldC9tbHg1ZTogU3VwcG9ydCBwZWRpdCBvbiBt
cGxzIG92ZXIgVURQIGRlY2FwDQo+IA0KPiBUYW5nIEJpbiAoMSk6DQo+ICAgICAgIG5ldC9tbHg1
ZTogVXNlIElTX0VSUigpIHRvIGNoZWNrIGFuZCBzaW1wbGlmeSBjb2RlDQo+IA0KPiBWbGFkIEJ1
c2xvdiAoNCk6DQo+ICAgICAgIG5ldC9tbHg1ZTogRXh0cmFjdCBUQy1zcGVjaWZpYyBjb2RlIGZy
b20gZW5fcmVwLmMgdG8gcmVwL3RjLmMNCj4gICAgICAgbmV0L21seDVlOiBFeHRyYWN0IG5laWdo
LXNwZWNpZmljIGNvZGUgZnJvbSBlbl9yZXAuYyB0bw0KPiByZXAvbmVpZ2guYw0KPiAgICAgICBu
ZXQvbWx4NWU6IE1vdmUgVEMtc3BlY2lmaWMgY29kZSBmcm9tIGVuX21haW4uYyB0byBlbl90Yy5j
DQo+ICAgICAgIG5ldC9tbHg1ZTogSW50cm9kdWNlIGtjb25maWcgdmFyIGZvciBUQyBzdXBwb3J0
DQo+IA0KDQpbLi4uXQ0K

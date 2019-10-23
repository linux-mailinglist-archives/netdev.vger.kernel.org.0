Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD980E2327
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387989AbfJWTKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:10:31 -0400
Received: from mail-eopbgr10046.outbound.protection.outlook.com ([40.107.1.46]:27774
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732777AbfJWTKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 15:10:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egx9JVdchHn/L9j+ieCRvFD6qINC9ghS04rcMEy8cOO9RaGTU2vM7+9v+iYIcg5BqmIy81Unuwe7xHy8JLieww1yondp5StzNJmz/LJ4kTIQGnt/0o/ok41OGP56UfT4b0k5vkp+LKfI14zwvR1HlV7RKLlNmAkWO6vmeuTpCl+K25dwfjfyGdPvxt0gNTW7j1kJbwsClAUeHyuzWL0/jEF/uS4ajLtULptvzqzKtv6CPDfU8GdnmK8qJDR8sfws3QBD3Hf9VM74/N5kf0FPPhoYJQcobkCvivyYVY0wETL9qTxkkEU/EKChZW/veoU4Yu4mXEWQ3JWivNTkA1V3+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zbD+Oa0KV/dZaMllCDQteHXKMYOPLa/0V52LrWACc5g=;
 b=CZ5DWh+iShrd8eug+5f6h61+9lrEHDsC0D8p17IYIf1LicyN2AAdlEZOC4ub+v1kmf9X0ZIT8YIpjYgJaq0JJnNLtNfnoD1d0hvNj6P4wKWMLO5A4FZEMEv73y8R7mAfkOPU+04KMmkwcybbyS0fiYazuAbhTMeANf0A12APuhkzSm3TdsQMTwZfbITgD3l62ZLjVIuju+oiXAsJD1FYc2fe6gtXQJtvuh/2EXPd2+ow0icm59ur9siH8zIntQLFAQiQFwm3PjjBo7AEo4oo554cICwk5E5te7QMiw5Fb0WjlGElL6B/EIasHJoa1WRsmm+ns9bdsZIqHFyu4swmSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zbD+Oa0KV/dZaMllCDQteHXKMYOPLa/0V52LrWACc5g=;
 b=P1+NbIpYqJ2yk5CTUqwWmddJfqXEh8Wy08a+lo5aF8X9FIEJkvCy4//oAQXeJBJSvJqXhLjZsiCoTp4OQJsCKBjuW3GxJ39wtPEKAUfTtRVks2iG2KPRAORIPEf28spL6XDh/rEd8PF+TFG41G1O01rKL4ie+RHwjm/5oU6ar/Q=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4541.eurprd05.prod.outlook.com (20.176.2.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 23 Oct 2019 19:10:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Wed, 23 Oct 2019
 19:10:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>
CC:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH net-next 0/4] page_pool: API for numa node change handling
Thread-Topic: [PATCH net-next 0/4] page_pool: API for numa node change
 handling
Thread-Index: AQHViJNcsaTCOjw+ME2eyW3PeeMs3qdoWcaAgABAHgA=
Date:   Wed, 23 Oct 2019 19:10:26 +0000
Message-ID: <3cc58cb162200165967ef9690af412e3f56af571.camel@mellanox.com>
References: <20191022044343.6901-1-saeedm@mellanox.com>
         <CAJ3xEMgXujHYyMrMdmDDEyWJ6SLw8uKrxHZw=aTRkn-RQUjfKw@mail.gmail.com>
In-Reply-To: <CAJ3xEMgXujHYyMrMdmDDEyWJ6SLw8uKrxHZw=aTRkn-RQUjfKw@mail.gmail.com>
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
x-ms-office365-filtering-correlation-id: 2b81e78a-5f89-40e8-9d96-08d757eca9aa
x-ms-traffictypediagnostic: VI1PR05MB4541:
x-microsoft-antispam-prvs: <VI1PR05MB4541DEC880A4FFC32687D7DCBE6B0@VI1PR05MB4541.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(199004)(189003)(102836004)(14454004)(76116006)(7736002)(86362001)(91956017)(446003)(486006)(8676002)(118296001)(2906002)(2351001)(66946007)(26005)(36756003)(99286004)(66066001)(81156014)(4744005)(186003)(81166006)(64756008)(66556008)(66446008)(8936002)(305945005)(2616005)(4001150100001)(66476007)(476003)(6116002)(3846002)(53546011)(54906003)(6436002)(25786009)(58126008)(14444005)(11346002)(316002)(256004)(6512007)(6486002)(2501003)(71190400001)(5660300002)(478600001)(71200400001)(6916009)(76176011)(5640700003)(1361003)(229853002)(4326008)(6246003)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4541;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ux1Aj8DkzFuYpv1TXscQfM5tqkpzukrVQXVEuf46tIBRnh1ncq9quPdPUGO12w48lUNg7Ibdm5goUkX0dVrhzKvwJkt0PRae3I/C9Lku/bZG9pPpZdU9UwYlSTB4dNSqd5zHEe83tSxTZRq26cGJdA8Q2Nkp2u/r8XjbEp8Q/4ZkbuLNYNbuaJtFOe5oZyYPKxpG5YP7r9YZsvljpZHBiAwN5VlIFE3PxYURrB1S0gx29HPXWJL+UGhUxSCSiGPN2Aa10FHDnVzJeVVugxe5dgp0pcuOo5Z3XRZbNnX2H/c1WD7nOW98ZLoycblz0T2JamO3ECAFU1xZATrunOmt4QVW6xHiHgDCduu4GfJyYNN+5eg58UIIxb6ZWzMLYYBun48+jCQshjUYjKP9cnyaSENPeBGn2nDnBjrI7QK2uKRFuv0dZuAN1ZE6ZAoHmbGG
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4549F9B41809848B57CA9DD1484BDC2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b81e78a-5f89-40e8-9d96-08d757eca9aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 19:10:26.6074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LVzp8KkaWisk1JBt1KLMa57s9Fx5pKSjfx14UX7QWRi0D5jadGOw/9myQtdIw6jX0ujsH5VCap/QFOD36uqF/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEwLTIzIGF0IDE4OjIwICswMzAwLCBPciBHZXJsaXR6IHdyb3RlOg0KPiBP
biBUdWUsIE9jdCAyMiwgMjAxOSBhdCA4OjA0IEFNIFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVs
bGFub3guY29tPg0KPiB3cm90ZToNCj4gDQo+ID4gQ1BVOiBJbnRlbChSKSBYZW9uKFIpIENQVSBF
NS0yNjAzIHY0IEAgMS43MEdIeg0KPiA+IE5JQzogTWVsbGFub3ggVGVjaG5vbG9naWVzIE1UMjc3
MDAgRmFtaWx5IFtDb25uZWN0WC00XSAoMTAwRykNCj4gPiANCj4gPiBYRFAgRHJvcC9UWCBzaW5n
bGUgY29yZToNCj4gPiBOVU1BICB8IFhEUCAgfCBCZWZvcmUgICAgfCBBZnRlcg0KPiA+IC0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+IENsb3NlIHwgRHJvcCB8IDEx
ICAgTXBwcyB8IDEwLjkgTXBwcw0KPiA+IEZhciAgIHwgRHJvcCB8IDQuNCAgTXBwcyB8IDUuOCAg
TXBwcw0KPiA+IA0KPiA+IENsb3NlIHwgVFggICB8IDYuNSBNcHBzICB8IDYuNSBNcHBzDQo+ID4g
RmFyICAgfCBUWCAgIHwgNCAgIE1wcHMgIHwgMy41ICBNcHBzDQo+ID4gDQo+ID4gSW1wcm92ZW1l
bnQgaXMgYWJvdXQgMzAlIGRyb3AgcGFja2V0IHJhdGUsIDE1JSB0eCBwYWNrZXQgcmF0ZSBmb3IN
Cj4gPiBudW1hIGZhciB0ZXN0Lg0KPiANCj4gc29tZSB0eXBvIGhlcmUsIHRoZSBUWCBmYXIgdGVz
dCByZXN1bHRzIGJlY29tZSB3b3JzZSwgd291bGQgYmUgZ29vZA0KPiB0bw0KPiBjbGFyaWZ5L2Zp
eCB0aGUgY292ZXIgbGV0dGVyDQoNCm5pY2UgY2F0Y2gsIHdpbGwgZml4IHRoZSBkb2N1bWVudGF0
aW9uICENCg0K

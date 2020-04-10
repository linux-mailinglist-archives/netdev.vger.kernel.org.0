Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC1E51A4A20
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 21:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgDJTEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 15:04:33 -0400
Received: from mail-eopbgr60062.outbound.protection.outlook.com ([40.107.6.62]:47049
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726203AbgDJTEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 15:04:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xh+zoKCxqI8Mf8cPX007AbeUwa3mZQpnVxm0WezUWcRwdCYr0vFxwBq5Smxe2W1a4pF1HGP+EPuVI+LAaidZC9I8QWjbYgGpzgWs6ZNWZE4vUEULLNILOLanMB8V52Bni8AD7GQXk+rg8RVVEqZRyy6g/FeTHZc+27f6udac5Ol/2Rdnfs+I0rgLaemAKoXwRdCghsmUPdSJK9/nnKleQWvdyXwL8t7VbIcUNBGO72xQsTEMhDfboaRSdMmwFpz3lSkto9vjJfXh6IsbJPcLNFhr2qFpTUvCe9iuOg0OH6S3NMYw5DYKp5CkkWm9H+XpiIEzoVwKAv57vSUXs28clg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qREnRW9ITHwIv0VmfQhKf0SU7+cAcX76d6f6wyC33Q0=;
 b=cqzbf9l1/ogm5fyfbeqmjVmHHGMM/BH0qdkYgkUCT5QIcD5khi1Hl8ToVMd44If6sT863+xDSr5x2WvojYCO+D+xb0oJ93kC5B1pLspJgiA/67HA7U+uBAOJyKu5aLc+eidR39UdXIp0f9EMr4ywAjO0tCCYay8uOD4qSPuma9THNFl7MeuxwlrAdoOar0GVKi0H+n90YyC2rMeje+4ZbaWMALyqj1sAMMJp5NkoIdlJjuyPu4lbqW/9dVjM8AcpsmGOFcKop+f+KHvLxUpHiHOyyOOiRlkUydlh2B7ZZpHY5QtWAnou3l2SJvfz5XD70LAG9bYFsDt1joSNAxr/wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qREnRW9ITHwIv0VmfQhKf0SU7+cAcX76d6f6wyC33Q0=;
 b=Da7wUhQLBzrVWdsbTF45GZB05me//iP7OIZsJ49df5+a2chZY3FJljWQLikCiW4ewhOjCFsktJpRL1HXe9uDX0PEWHiuNaxeh+S8G2muzPzangCJHvM4YcN5xO9esvpnYp+DaDnix8XJtVeDv2M6UojWSZb6TeXw7P02L/YiHkw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6464.eurprd05.prod.outlook.com (2603:10a6:803:f4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Fri, 10 Apr
 2020 19:04:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 19:04:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jgg@ziepe.ca" <jgg@ziepe.ca>
CC:     "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
Thread-Topic: [RFC 0/6] Regressions for "imply" behavior change
Thread-Index: AQHWDeQiJzc7TgrcN0yUMWAEU5j98qhvr4mAgAADKgCAAB92AIAAp0gAgAEtnwCAAPPSAIAAHv4A
Date:   Fri, 10 Apr 2020 19:04:27 +0000
Message-ID: <16441479b793077cdef9658f35773739038c39dc.camel@mellanox.com>
References: <20200408202711.1198966-1-arnd@arndb.de>
         <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
         <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
         <20200408224224.GD11886@ziepe.ca> <87k12pgifv.fsf@intel.com>
         <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com>
         <20200410171320.GN11886@ziepe.ca>
In-Reply-To: <20200410171320.GN11886@ziepe.ca>
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
x-ms-office365-filtering-correlation-id: 604cbf34-e6de-480d-3b6a-08d7dd81fdee
x-ms-traffictypediagnostic: VI1PR05MB6464:
x-microsoft-antispam-prvs: <VI1PR05MB64645727AC499AC722926512BEDE0@VI1PR05MB6464.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0369E8196C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(66946007)(71200400001)(478600001)(6512007)(36756003)(66476007)(2906002)(316002)(66446008)(66556008)(6486002)(81156014)(76116006)(91956017)(8936002)(2616005)(64756008)(8676002)(26005)(6506007)(4326008)(7416002)(6916009)(86362001)(186003)(5660300002)(54906003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sk7LWu09ZwoByjIkmEQvlLQxqiH4RnuIMEtq/nKvClwtDup+cg/MnOZeo3XzsmVxtjERbGPfXzf6oYuK37UG5LqOyyTn+bgLI030iA83xYLd2zDtcrLUvV86hNgTYXTgUiqcwjOOHu77v8f0NovbBVSfSnbE79N5R3L1iw3ZcqOgW4cFHt1Z7pxLZeVXtbEm1PA0mkXAQbKbMIvm+FbSIj4OXo9dKNjXD/xTWrKtVmhQUJglYayCmbt5SQ5BMsdGLCNl2ww4DJK476m9xoUaD7yPiUmEOoR720JX4m+a66OBsyOcOR44E7LBF55F7/euhU5ZVO5XI5gPa0ZodXqTl6M1gQ9QlQOAZXcl1JxQOZ0lPAvqsFPMmjkZLa/un7Hxv+pJC4C6yHMQPL5rpy+chuoRidHN9tMjyF0UOyRFAFG0JaBL1vsB1MCmjxApk2eN
x-ms-exchange-antispam-messagedata: fRQRQ8i7wmC+3vtBoyMYeekeUdQoSpgPVRQipw7kyIsHXSlOhW2jhWSnv4RBi2axI5vyBCdqO7xCaxauTeMDlsP2XrmTgkJnMhYDf3ja4fNNLQfSy8fHU/cdKo0ff2XyDDG1Ufb6NJdTZXOo3ugDJQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <127F1870F5B4654CB5433164FF4CFAA0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 604cbf34-e6de-480d-3b6a-08d7dd81fdee
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2020 19:04:27.5793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XSqGcjR4gDuk13O12RhpESN0GjCOS9QCAV6UySkbBvWeWDsTQ4NoiFvRJVRRO4+iiH7j27O5w0Plz65dwzXynw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA0LTEwIGF0IDE0OjEzIC0wMzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIEZyaSwgQXByIDEwLCAyMDIwIGF0IDAyOjQwOjQyQU0gKzAwMDAsIFNhZWVkIE1haGFt
ZWVkIHdyb3RlOg0KPiANCj4gPiBUaGlzIGFzc3VtZXMgdGhhdCB0aGUgbW9kdWxlIHVzaW5nIEZP
TyBoYXMgaXRzIG93biBmbGFnDQo+ID4gcmVwcmVzZW50aW5nDQo+ID4gRk9PIHdoaWNoIGlzIG5v
dCBhbHdheXMgdGhlIGNhc2UuDQo+ID4gDQo+ID4gZm9yIGV4YW1wbGUgaW4gbWx4NSB3ZSB1c2Ug
VlhMQU4gY29uZmlnIGZsYWcgZGlyZWN0bHkgdG8gY29tcGlsZQ0KPiA+IFZYTEFODQo+ID4gcmVs
YXRlZCBmaWxlczoNCj4gPiANCj4gPiBtbHg1L2NvcmUvTWFrZWZpbGU6DQo+ID4gDQo+ID4gb2Jq
LSQoQ09ORklHX01MWDVfQ09SRSkgKz0gbWx4NV9jb3JlLm8NCj4gPiANCj4gPiBtbHg1X2NvcmUt
eSA6PSBtbHg1X2NvcmUubw0KPiA+IG1seDVfY29yZS0kKFZYTEFOKSArPSBtbHg1X3Z4bGFuLm8N
Cj4gPiANCj4gPiBhbmQgaW4gbWx4NV9tYWluLm8gd2UgZG86DQo+IA0KPiBEb2VzIHRoaXMgd29y
ayBpZiBWWExBTiA9IG0gPw0KDQpZZXMsIGlmIFZYTEFOIElTX1JFQUNIQUJMRSB0byBNTFg1LCBt
bHg1X3Z4bGFuLm8gd2lsbCBiZQ0KY29tcGlsZWQvbGlua2VkLg0KDQo+IA0KPiA+IGlmIChJU19F
TkFCTEVEKFZYTEFOKSkNCj4gPiAgICAgICAgbWx4NV92eGxhbl9pbml0KCkNCj4gPiANCj4gPiBh
ZnRlciB0aGUgY2hhbmdlIGluIGltcGx5IHNlbWFudGljczoNCj4gPiBvdXIgb3B0aW9ucyBhcmU6
DQo+ID4gDQo+ID4gMSkgdXNlIElTX1JFQUNIQUJMRShWWExBTikgaW5zdGVhZCBvZiBJU19FTkFC
TEVEKFZYTEFOKQ0KPiA+IA0KPiA+IDIpIGhhdmUgTUxYNV9WWExBTiBpbiBtbHg1IEtjb25maWcg
YW5kIHVzZSBJU19FTkFCTEVEKE1MWDVfVlhMQU4pIA0KPiA+IGNvbmZpZyBNTFg1X1ZYTEFODQo+
ID4gCWRlcGVuZHMgb24gVlhMQU4gfHwgIVZYTEFODQo+ID4gCWJvb2wNCj4gDQo+IERvZXMgdGhp
cyB0cmljayB3b3JrIHdoZW4gdnhsYW4gaXMgYSBib29sIG5vdCBhIHRyaXN0YXRlPw0KPiANCj4g
V2h5IG5vdCBqdXN0IHB1dCB0aGUgVlhMQU4gfHwgIVZYTEFOIGRpcmVjdGx5IG9uIE1MWDVfQ09S
RT8NCj4gDQoNCnNvIGZvcmNlIE1MWDVfQ09SRSB0byBuIGlmIHZ4bGFuIGlzIG5vdCByZWFjaGFi
bGUgPyB3aHkgPyBtbHg1X2NvcmUgY2FuDQpwZXJmZWN0bHkgbGl2ZSB3aXRob3V0IHZ4bGFuIC4u
IGFsbCB3ZSBuZWVkIHRvIGtub3cgaXMgaWYgVlhMQU4gaXMNCnN1cHBvcnRlZCBhbmQgcmVhY2hh
YmxlLCBpZiBzbywgdGhlbiB3ZSB3YW50IHRvIGFsc28gc3VwcG9ydCB2eGxhbiBpbg0KbWx4NSAo
aS5lIGNvbXBpbGUgbWx4NV92eGxhbi5vKSANCg0KYW5kIGhvdyBkbyB3ZSBjb21waWxlIG1seDVf
dnhsYW4ubyB3aWhvdXQgYSBzaW5nbGUgZmxhZyANCmNhbiBpIGRvIGluIE1ha2VmaWxlIDoNCm1s
eDVfY29yZS0kKFZYTEFOIHx8ICFWWExBTikgKz0gbWx4NV92eGxhbi5vID8/IA0KDQoNCj4gSmFz
b24NCg==

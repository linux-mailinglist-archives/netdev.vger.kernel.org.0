Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14172CEF6
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfE1Swh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:52:37 -0400
Received: from mail-eopbgr140071.outbound.protection.outlook.com ([40.107.14.71]:25172
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726708AbfE1Swh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 14:52:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7a0cHDsrbN6H/WFOTBz3ZcbHLfUcZtkAAokMOcpQuQ=;
 b=p6DoyKHqTWamVg2acZ+itDZXoAppulvAhT+/ZH2qhmTEjUzn8C0reTJbP211QbYDIAO7EXBf3bXSVaU2miH9450pAWwaTCrsv7zLe6BBrZOnSN0FpMG4WYKYpzNNmqSHXoPqRFItWH71PXYW+ivgeT9xFNF4ccmeO7V0Or8AT/M=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB2767.eurprd03.prod.outlook.com (10.171.105.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Tue, 28 May 2019 18:52:33 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4%5]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 18:52:33 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Thread-Topic: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Thread-Index: AQHVFXdSefBuJXwkfU6scW4BRrDrCKaA1c+AgAAMRQA=
Date:   Tue, 28 May 2019 18:52:32 +0000
Message-ID: <70B35849-D2D4-4B4E-8D3E-8AF089B0947F@darbyshire-bryant.me.uk>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
 <87ef4itpsq.fsf@toke.dk>
In-Reply-To: <87ef4itpsq.fsf@toke.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1268:6500::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8dc2352-4e1f-4246-71cf-08d6e39da49b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR0302MB2767;
x-ms-traffictypediagnostic: VI1PR0302MB2767:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0302MB276753FD1812329033E89B7FC91E0@VI1PR0302MB2767.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(366004)(39830400003)(396003)(346002)(189003)(199004)(6116002)(6916009)(82746002)(4744005)(4326008)(5660300002)(25786009)(66476007)(66556008)(64756008)(66446008)(33656002)(91956017)(76116006)(316002)(73956011)(66574012)(256004)(36756003)(14454004)(86362001)(966005)(66946007)(53936002)(2906002)(476003)(6246003)(8936002)(8676002)(486006)(446003)(46003)(71200400001)(81166006)(71190400001)(76176011)(99286004)(229853002)(83716004)(6512007)(6306002)(6436002)(6486002)(53546011)(6506007)(7736002)(305945005)(102836004)(74482002)(186003)(508600001)(81156014)(11346002)(68736007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2767;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2wTBTsc4q89gy4gbyuBhuAb4KeuM1PXEuNThhKTZI0H1N991XCki0rysostbYvFsAd93aDID/z+Gd/CsHNmYLh3lMy6fouYMBQ9u0jj4SgyJYrG8iC4ZZqG4852e2sxgnIdp9WVgKJ0IY+VgcTEUJy5jbqqLEB308l2Nu+gfCinBHPLNxTYlSJ3arePOfo5nvqQT2pCTd1qYENc083qXVYTMYUizXqAj07pmX5DxpWyDF5P6jbze01G3aNprfqNDrC0irDEkoccMT9TNxpdnw84XDKZ9XtMtQiN+JHe29feHwUo0JxnyZ1CY2DmURK1y3Bz0FVo9nqhZcg6iNGlYmmRETnq3uekK8j54OtnChL1DWLl0GAr+Oc4K5FucVOI9GzTt95vm0ggJx0szH0r9QhXUME4xk8XwxLNGVcXnflc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8280DEFA8EA91B4E9D33DD0CFC787ED5@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: c8dc2352-4e1f-4246-71cf-08d6e39da49b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 18:52:32.8913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2767
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMjggTWF5IDIwMTksIGF0IDE5OjA4LCBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4g
PHRva2VAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPHN0dWZmIHNuaXBwZWQ+DQo+IA0KPiBUaGFu
ayB5b3UgZm9yIGRvaW5nIGFub3RoZXIgaXRlcmF0aW9uIQ0KPiANCj4gTm8gZnVydGhlciBjb21t
ZW50cyBvbiB0aGUgYWN0dWFsIGNvZGUsIGJ1dCBJIHN0aWxsIGdldCB0aGUgd2hpdGVzcGFjZQ0K
PiBpc3N1ZSB3aXRoIHRoZSBwYXRjaC4uLiBBbmQgbm93IGl0IHJlc3VsdHMgaW4gc3RyYXkgXk0g
Y2hhcmFjdGVycyBpbiB0aGUNCj4gS2NvbmZpZyBmaWxlLCB3aGljaCBtYWtlcyB0aGUgYnVpbGQg
YmxvdyB1cCA6Lw0KDQpUaGlzIGlzIHZlcnkgb2RkLiAgSSBwcm9kdWNlZCB0aGUgbGFzdCBwYXRj
aCAodjYpIGZyb20gd2l0aGluIGEgZGViaWFuIFZNDQphbmQgc2VudCBpdCBmcm9tIHRoZXJlIGFs
c28uICBObyB3ZWlyZCBsaW5lIGVuZGluZ3MgaW4gdGhlIGxvY2FsbHkgcHJvZHVjZWQNCnBhdGNo
IHRleHQgYW5kIGl0IGFwcGxpZWQgY2xlYW5seSB0byBhIGxvY2FsIHRyZWUuICBJ4oCZdmUgc2Vu
dCB0ZXN0IHBhdGNoZXMNCmludG8gdGhlIG9wZW53cnQgdHJlZSBhbmQgYXBwbGllZCB0aG9zZSBj
bGVhbmx5IGRpcmVjdCBmcm9tIHBhdGNod29yay4NCg0KU2ltaWxhcmx5IEnigJl2ZSBkb3dubG9h
ZGVkIHRoZSB2NSBwYXRjaCBmcm9tIG5ldGRldiBwYXRjaHdvcmsgaHR0cDovL3BhdGNod29yay5v
emxhYnMub3JnL3BhdGNoLzExMDU3NTUvbWJveC8gYW5kIGFwcGxpZWQgdGhhdCB3aXRoIGdpdA0K
YW0gd2l0aG91dCBwcm9ibGVtLg0KDQpBbSB0b3RhbGx5IGNvbmZ1c2VkIQ0KDQoNCkNoZWVycywN
Cg0KS2V2aW4gRC1CDQoNCmdwZzogMDEyQyBBQ0IyIDI4QzYgQzUzRSA5Nzc1ICA5MTIzIEIzQTIg
Mzg5QiA5REUyIDMzNEENCg0K

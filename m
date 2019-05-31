Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDE830A49
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfEaI3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:29:42 -0400
Received: from mail-eopbgr50066.outbound.protection.outlook.com ([40.107.5.66]:8166
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725963AbfEaI3m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/QhO0fv4KnqTvEGvqxQpl63AsWGXbHvqBRZFdYdCqs=;
 b=uNfk9a09t8wSEBGV3y7KYz/3HbR8ArNFBPMkm50a88ElDi48q0Q4g25IB46S/833az98rjh8AT5qoN1bQNmFLMWCp7iWGWH2UIXpgghBJJh0UaTIBw1bthZQ2wIxux77Yj7qnoL58DdsnABGjMyjRXM7beozzErNFSHkhcoxgig=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB2654.eurprd03.prod.outlook.com (10.171.104.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.17; Fri, 31 May 2019 08:29:38 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4%5]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 08:29:38 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH iproute2-next 1/1] tc: add support for act ctinfo
Thread-Topic: [RFC PATCH iproute2-next 1/1] tc: add support for act ctinfo
Thread-Index: AQHVFwbJ/p/rOXTiw0SyKMktH1aCdKaEFjUAgADRtIA=
Date:   Fri, 31 May 2019 08:29:38 +0000
Message-ID: <4C720F7E-5EA6-489F-8631-2DF2A4C55A01@darbyshire-bryant.me.uk>
References: <20190530164246.17955-1-ldir@darbyshire-bryant.me.uk>
 <20190530164246.17955-2-ldir@darbyshire-bryant.me.uk>
 <20190530125904.713e72b1@hermes.lan>
In-Reply-To: <20190530125904.713e72b1@hermes.lan>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1268:6500::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7075698-4a63-4e19-29ff-08d6e5a21ea3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR0302MB2654;
x-ms-traffictypediagnostic: VI1PR0302MB2654:
x-microsoft-antispam-prvs: <VI1PR0302MB265459E9331A54EEAD0EEB04C9190@VI1PR0302MB2654.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(366004)(39830400003)(199004)(189003)(52314003)(76176011)(68736007)(305945005)(99286004)(8936002)(8676002)(4326008)(6916009)(81166006)(508600001)(45080400002)(71190400001)(33656002)(81156014)(7736002)(83716004)(25786009)(71200400001)(6116002)(6486002)(446003)(73956011)(86362001)(486006)(74482002)(46003)(76116006)(4744005)(256004)(11346002)(6436002)(91956017)(14454004)(66476007)(66556008)(6246003)(6512007)(82746002)(64756008)(5660300002)(186003)(66946007)(316002)(229853002)(66446008)(53546011)(2906002)(2616005)(36756003)(6506007)(476003)(53936002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2654;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bUo7YS087uyqjsJVHLHydCnC8xvbmBWlFru+5uvUdUaM0g2YkuFHxWbAXAsRtvVr/ATRyL68D4FUb+JHxz59ucSogT1bIo3f5c/qw1y3Lhs3oVRy3EsaClm3IKJJrrAmH3fshLYAfnIfOHCEtt9rljspwHlWQF7lRNlT9stJRKmFdQN+eJq2rJrrjSiIn1rn2i5Gpwl/IdDfBAxuZ0C1xOkAHVQ+YdH+9pjyS9Rgxyu74t/b5hch0Pom31EhxLirp1LKw0vk9dZfpyA9CtM1OeEwUgz+xSRJyBxVEpgBUUUW3zGfGpZi6VAaO9lBQgNJbC5JQsMMdEw9d9Z/m3YwHYjV0PIP/B86mrdMmeTEzjblVu0yLKt6lV03jbqWeUe94Ok/2D+7UIAEh6L8MXPFtTSJzf1C+ykDWHRt8s+dE7k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EDA0C1321E965E48810CBC6415B4D273@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: a7075698-4a63-4e19-29ff-08d6e5a21ea3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 08:29:38.0245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2654
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMzAgTWF5IDIwMTksIGF0IDIwOjU5LCBTdGVwaGVuIEhlbW1pbmdlciA8c3RlcGhl
bkBuZXR3b3JrcGx1bWJlci5vcmc+IHdyb3RlOg0KPiANCj4gT24gVGh1LCAzMCBNYXkgMjAxOSAx
Njo0MzoyMCArMDAwMA0KPiBLZXZpbiAnbGRpcicgRGFyYnlzaGlyZS1CcnlhbnQgPGxkaXJAZGFy
YnlzaGlyZS1icnlhbnQubWUudWs+IHdyb3RlOg0KPiANCj4gUGxlYXNlIGRvbid0IHVzZSBIVE1M
IGVuY29kZWQgbWFpbC4gSS5lIG5vdCBleGNoYW5nZS4NCg0KQXMgZmFyIGFzIEkga25vdyBJ4oCZ
bSBub3Qgc2VuZGluZyBIVE1MIGVtYWlscywgb3IgSeKAmW0gdHJ5aW5nIGhhcmQgdG8gc2VuZA0K
cGxhaW4gdGV4dCBmcm9tIG1hYyBtYWlsLCBhbmQgdXNpbmcgZ2l0IHNlbmQtZW1haWwgdG8gc2Vu
ZCBwYXRjaGVzLg0KVGhlIG9mZmljZTM2NSBzbXRwIHNlcnZlciBhcHBlYXJzIHRvIGJlIG1hbmds
aW5nIHBhdGNoZXMgaW4gc29tZSB3YXksDQpzZW5kaW5nIHVzaW5nIGdpdCBzZW5kLWVtYWlsIHZp
YSBpY2xvdWQgdiBvZmZpY2UzNjUgcHJvZHVjZXMgZGlmZmVyZW50DQpyZXN1bHRzIGRlc3BpdGUg
c2V0dGluZyA4Yml0IGVuY29kaW5nIHJhdGhlciB0aGFuIGJhc2U2NC4gIFNvIEkgcmVtYWluDQpj
b25mdXNlZC4NCg0KQW55d2F5LCBoYXZlIHNlbnQgYSB2MiB2aWEgYW4gaWNsb3VkIHNtdHAgc2Vy
dmVyIGFmdGVyIHlvdXIgYWR2aWNlICYNCmNoZWNrcGF0Y2ggZXRjIGV0Yy4gIEhvcGVmdWxseSBp
bXByb3ZlZC4NCg0KDQo+IA0KPj4gKw0KPj4gKwlpZiAoYXJnYykgew0KPj4gKwkJaWYgKG1hdGNo
ZXMoKmFyZ3YsICJkc2NwIikgPT0gMCkgew0KPj4gKwkJCU5FWFRfQVJHKCk7DQo+PiArCQkJY2hh
ciAqc2xhc2g7DQo+PiArCQkJaWYgKChzbGFzaCA9IHN0cmNocigqYXJndiwgJy8nKSkpDQo+PiAr
CQkJCSpzbGFzaCA9ICdcMCc7DQo+IA0KPiBEb24ndCBtaXggYXNzaWdubWVudCBhbmQgY29uZGl0
aW9uYWwgb24gc2FtZSBsaW5lDQoNCkNoZWNrcGF0Y2ggZm91bmQgdGhhdCB0b28gOi0pDQoNCg==

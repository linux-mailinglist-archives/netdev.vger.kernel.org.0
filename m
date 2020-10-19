Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A542930AF
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387402AbgJSVnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:43:21 -0400
Received: from mail-eopbgr670064.outbound.protection.outlook.com ([40.107.67.64]:58080
        "EHLO CAN01-TO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733269AbgJSVnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:43:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cek/DRkFQBv/XLVgyzUS5DWO3BFYXPN5mBRt3NH4sgmStNAJ33WIt797bX+todZ0UkfGfo+/QzPJEk+3zX4n/Z6rldoeQui8iWROA40g4nEFO4ko/A3/v8LYZ23B53CUKhpY44aRd9IMjdwqgHWdB031yWcf6Ljq9nN9aq9nUFHbRGKIjNYx7lQrXH+/1fJye3R/mghTT9FO7y/Y0ljVgkSYArf4FReeBTPN/pwxjSk4TnL4cz212YvRhURNgmXMA9VIv8jjSVtsk9Pq8tWovYMpS5+9GYOI0uEph4zagZ025pawHA5IQ/bgNehufw9eKw78HT5m3Gj8K1QDiSk9jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Np+piGxM9DFjOTN5G4QT6ttLLdKEfIu4QEVJDqIKGD4=;
 b=KBSBk5K4IZ3hwX4QpaDozrSl5C7ZlM/Bj3JAtPSiQ8MIu9jsVpLRmWydvz9iBIeztVffUf5j0tYhwZ8Zq+47yrlyse0PAiK4VTLD1umd19ZCgxjF4LEhDHrK6hhAX5KnDXolbqn1qFFbPewWAS1xq3K9u4QU8cbBMIRMN3q+DBC8EisVKTVIiBT6vOUquAjhKEDL1TcE0I9hH0O+AC5eFbRbVhtnzlP8WcK7Fahp727gdVEk0ckUaa3xRVUChd/1xVNIstgaDme685Yuhddx8hC2LHdpLPTUKkNSQsHuGdDV/xs6Z6BEVXcM+Q4l3aWXmXYfWxrpJ+2S/tmgNleucA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Np+piGxM9DFjOTN5G4QT6ttLLdKEfIu4QEVJDqIKGD4=;
 b=Vy85VRm78PHmhe0w93oaRdyKYsUitf/Y9+4NLf+tRmzLOqtwOJJDT2CWAHohudK4xaguAb1oOI1Gj3Bc1OpD27xWAj1wzVawwe+AZCI674vU4He4d0aGs9DAo8/ouA/1Pe/zoUFh7TCbOxrfr6T7418ymnuAUc20AQEW+Gm/OWw=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTXPR0101MB2157.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Mon, 19 Oct
 2020 21:43:18 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 21:43:18 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Thread-Topic: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Thread-Index: AQHWpll91HNTpw9Y2UKmWJkWbB3A/amfaQWAgAAL/gA=
Date:   Mon, 19 Oct 2020 21:43:18 +0000
Message-ID: <e9214e305158b9b487862f89b7a88dd292beb824.camel@calian.com>
References: <20201019204913.467287-1-robert.hancock@calian.com>
         <20201019210023.GU139700@lunn.ch>
In-Reply-To: <20201019210023.GU139700@lunn.ch>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-12.el8) 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1900d6f-0714-45d0-5d8f-08d87477fe3e
x-ms-traffictypediagnostic: YTXPR0101MB2157:
x-microsoft-antispam-prvs: <YTXPR0101MB2157EB78B25734EAB30D880FEC1E0@YTXPR0101MB2157.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E5BXvG+DwOZ8fOKo9LcAEBMhX/1Dus/+UVJocVx3k1Rvw0IZCfkAGjYqAAMCI0adcZLdBTYSPKJ12lt1uyZjREJsGtxZVrz4x8T+sA8+pm+o6CQdwGkoidLR98RYlpFcfsCm2BZMe21d4XIyKQKYPP1FywNThg+EVUTA70kzFqkoxeSzC8eXIHGfKWvqw0urF9/3o3SUTG9e+Fk9UW3zlXy7uaa8Vdh4ixPgDXQAvZwqijcHzmf4LaY/5+QEdVXjj9qeWsVVN95ohHfd7OebLdqYcgbzLlrMcpNTIM1dFea8JyRfDaTowx8b7xEid0kCewjKHNrrUHM4pRbpt2TzgLKtxx5LHsEGj9MS2z1McPoIQV49RQYdD7XGWFDmpy/yb4X8Im1CgVZjYwJ0IwwxdkKbhI1g2vxNhBfasXciZ2CPaNkiguCvQt1AFtpt6+7BG7rXWWbUjA2I9nQOEYW4QnEgVHkGyeJVIYyXZ+cN0II=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(136003)(396003)(366004)(186003)(8676002)(6506007)(36756003)(86362001)(66946007)(66556008)(66476007)(4326008)(316002)(76116006)(26005)(83380400001)(91956017)(66446008)(2906002)(5660300002)(478600001)(2616005)(64756008)(6916009)(54906003)(44832011)(4001150100001)(15974865002)(6512007)(6486002)(71200400001)(8936002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hMBgN4eCbw2zYwPBKVZe7dVLqhaRAOnNLFvXs/KB3IVOXwM/2Ghkdt4VHl+3c4sA8A7IyshmPqiF1ARE+sxJ6NF/TPcVYsBJQq9WCRbe7boN4TwIhKLbiFElMTOpnmL+CvFDR56eHnqq8ysx9GD6Ijc6R6fMmi/ajb3GYQZ276zmWav1yaYoLQiljmsySDJQ2alLf5DC3D9hSNNM+9HTwhNZRtchfCsqY0nodtKztU8PBO0I7hVreUzzBCp30Q5EXUM5uNJAdgTX1HsH+8rAizefEhzPTpL7Hq9QLwnBWIchW7UeWKYjuAv+yqXyUTrc8unp2TwQoPexp+7RiJ/60ErEBvQW2q199fDDn4YlTsqalKYXQRBMt/S7NavzaF4Gu5rC07RnDdGiYES1LU/1Zxna4ka/nOywS+Yekk9+NI6aYnVdfzA9oMcyx9jPA+4IQ9S/IZ9Zbub078cSNPypASKWvZFBCUsk/MsvsHiGpxjBRdzV47PgIfJifxT1OlG2kaXxys1ZzQ/t4xwT4U88YLODOBiiQHQyZ4CPTmEL9c7fGJTPj5chIBOV9qNmXdRsZAHmVCkREz5T5RywnxuyUd4YqThd5Qgu6EJ/XqYrA8x/p34A0hQ8HmjGC9/V8b2TnKxHq6puCnBEhF5f5Nlp+Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BC23A30BD479D47BA48DD83D3B96CE7@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b1900d6f-0714-45d0-5d8f-08d87477fe3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 21:43:18.7116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XbAd7U1//sjv6pRklsBaKLpwgpcviDVECdmJBp8uPi1wMTpoGftRJmkXsTNr6rv4udGBoYqTWEK2e9S1K+0/gn974HM7UT5AiEynpd+0sFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB2157
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEwLTE5IGF0IDIzOjAwICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiArc3RhdGljIGludCBtODhlMTExMV9maW5pc2FyX2NvbmZpZ19pbml0KHN0cnVjdCBwaHlfZGV2
aWNlICpwaHlkZXYpDQo+ID4gK3sNCj4gPiArCWludCBlcnI7DQo+ID4gKwlpbnQgZXh0c3IgPSBw
aHlfcmVhZChwaHlkZXYsIE1JSV9NMTExMV9QSFlfRVhUX1NSKTsNCj4gPiArDQo+ID4gKwlpZiAo
ZXh0c3IgPCAwKQ0KPiA+ICsJCXJldHVybiBleHRzcjsNCj4gPiArDQo+ID4gKwkvKiBJZiB1c2lu
ZyAxMDAwQmFzZVggYW5kIDEwMDBCYXNlWCBhdXRvLW5lZ290aWF0aW9uIGlzDQo+ID4gZGlzYWJs
ZWQsIGVuYWJsZSBpdCAqLw0KPiA+ICsJaWYgKHBoeWRldi0+aW50ZXJmYWNlID09IFBIWV9JTlRF
UkZBQ0VfTU9ERV8xMDAwQkFTRVggJiYNCj4gPiArCSAgICAoZXh0c3IgJiBNSUlfTTExMTFfSFdD
RkdfTU9ERV9NQVNLKSA9PQ0KPiA+ICsJICAgIE1JSV9NMTExMV9IV0NGR19NT0RFX0NPUFBFUl8x
MDAwQlhfTk9BTikgew0KPiA+ICsJCWVyciA9IHBoeV9tb2RpZnkocGh5ZGV2LCBNSUlfTTExMTFf
UEhZX0VYVF9TUiwNCj4gPiArCQkJCSBNSUlfTTExMTFfSFdDRkdfTU9ERV9NQVNLIHwNCj4gPiAr
CQkJCSBNSUlfTTExMTFfSFdDRkdfU0VSSUFMX0FOX0JZUEFTUywNCj4gPiArCQkJCSBNSUlfTTEx
MTFfSFdDRkdfTU9ERV9DT1BQRVJfMTAwMEJYX0FODQo+ID4gfA0KPiA+ICsJCQkJIE1JSV9NMTEx
MV9IV0NGR19TRVJJQUxfQU5fQllQQVNTKTsNCj4gPiArCQlpZiAoZXJyIDwgMCkNCj4gPiArCQkJ
cmV0dXJuIGVycjsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwlyZXR1cm4gbTg4ZTExMTFfY29uZmln
X2luaXQocGh5ZGV2KTsNCj4gPiArfQ0KPiANCj4gSGkgUm9iZXJ0DQo+IA0KPiBJcyB0aGlzIHJl
YWxseSBzcGVjaWZpYyB0byB0aGUgRmluaXNhcj8gSXQgc2VlbXMgbGlrZSBhbnkgYXBwbGljYXRp
b24NCj4gb2YgdGhlIG04OGUxMTExIGluIDEwMDBCYXNlWCB3b3VsZCBiZW5lZml0IGZyb20gdGhp
cz8NCg0KSSBzdXBwb3NlIHRoYXQgcGFydCB3b3VsZCBiZSBwcmV0dHkgaGFybWxlc3MsIGFzIHlv
dSB3b3VsZCBsaWtlbHkgd2FudA0KdGhhdCBiZWhhdmlvciB3aGVuZXZlciB0aGF0IGlmIGNvbmRp
dGlvbiB3YXMgdHJpZ2dlcmVkLiBTbw0KbTg4ZTExMTFfZmluaXNhcl9jb25maWdfaW5pdCBjb3Vs
ZCBsaWtlbHkgYmUgbWVyZ2VkIGludG8NCm04OGUxMTExX2NvbmZpZ19pbml0Lg0KDQpNYWlubHkg
d2hhdCBzdG9wcGVkIG1lIGZyb20gbWFraW5nIGFsbCBvZiB0aGVzZSBjaGFuZ2VzIGdlbmVyaWMg
dG8gYWxsDQo4OEUxMTExIGlzIHRoYXQgSSdtIGEgYml0IGxlc3MgY29uZmlkZW50IGluIHRoZSBk
aWZmZXJlbnQgY29uZmlnX2FuZWcNCmJlaGF2aW9yLCBpdCBtaWdodCBiZSBtb3JlIHNwZWNpZmlj
IHRvIHRoaXMgU0ZQIGNvcHBlciBtb2R1bGUgY2FzZT8gDQoNCi0tIA0KUm9iZXJ0IEhhbmNvY2sN
ClNlbmlvciBIYXJkd2FyZSBEZXNpZ25lciwgQWR2YW5jZWQgVGVjaG5vbG9naWVzIA0Kd3d3LmNh
bGlhbi5jb20NCg==

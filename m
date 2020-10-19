Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8902930F7
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 00:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387920AbgJSWLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 18:11:34 -0400
Received: from mail-eopbgr670060.outbound.protection.outlook.com ([40.107.67.60]:48063
        "EHLO CAN01-TO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387914AbgJSWLe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 18:11:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXpoO+CnGmHDoFePjLfhlFo/Flu6ytsjiE8p3fFv8LMTvBAeeAlWW7akpkNpZg2wBV8TRbkqXiXO6HD9GDDOSjvOK+8orZcm/ZWbgBGuT/nJ8NwMeOhk5JFrq8ls/0MP4pa10x7XM6/ZeSJ5XFmYxI1wHUbGkiQWGBWcCGvPtQ625tY5LzVleWgxeCNYjcDOYvGRb50H0zyfmcPO3q7OdiUPOH9iTjvC9gRY8/lFArN7NElO0Fwup7cVOOF16uQeIg0JN9LiAMp2r+66aNc92Fn2ZTYmBec8PfutAWgtNPdj6AYEIEUQpIP4kz9YboqOFTZ6J8YsTb5SkKI1gL1tZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bk0xAvXN1Z/6Ll0PhFYhZGSSp7F8xo6Rs5ZBNNHUbuk=;
 b=Qsv1nnkL4VE3f0XGDDmAu7BpUr9HuzW7wUz2ldYdwHqfd4NJY1mMs9ur6cnsNyw05ZIJDNaiWIvao2JE6Da/mbpWUDttSXJOXSn0BcZh1tQ5KJoAZfGH/ujv+rKPu/NPJ8kK8JOFvuxmlJIyVl/WKD7CJD1sMaZqqF3pQBll2Rz5t/Mb3bkKDsujugPteOYHSIDAfD6pv4EL8oiWbVRij2w0DP0G6VFreoBE9cJUcSatuV3VdA5hvLerr6cJCEhe6JOw2ZH8U6cHnHKkcVvBjaYS3QKxOlyhWljb17y8xY6uWAaSJP0CDKcpiC9yMMM16Ek8JWWA52BeiJB7vyRVXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bk0xAvXN1Z/6Ll0PhFYhZGSSp7F8xo6Rs5ZBNNHUbuk=;
 b=4wo7vZXMijmnzt7laLOPn1w5orN7Vud1lkUIYNUneT+ftsPwVaT16MfnrdEpTLF76M+Eo4lQD2CwkaxkCPkhwwSFhBKhJGW7VtPzn63DWYVU20Edc8iQAGZpW+OVHx+zvWoHJLdGcaSjlBn/EezFQHqSg1/BbAxHh3cADjj1y1o=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB3871.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Mon, 19 Oct
 2020 22:11:32 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 22:11:32 +0000
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
Thread-Index: AQHWpll91HNTpw9Y2UKmWJkWbB3A/amfaQWAgAAL/gCAAASXAIAAA0uA
Date:   Mon, 19 Oct 2020 22:11:32 +0000
Message-ID: <9b4102af1c7c19822a9b29f4a9c84da56c9269dd.camel@calian.com>
References: <20201019204913.467287-1-robert.hancock@calian.com>
         <20201019210023.GU139700@lunn.ch>
         <e9214e305158b9b487862f89b7a88dd292beb824.camel@calian.com>
         <20201019215944.GZ139700@lunn.ch>
In-Reply-To: <20201019215944.GZ139700@lunn.ch>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-12.el8) 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ab39be7-72d9-473f-b753-08d8747bef9d
x-ms-traffictypediagnostic: YTBPR01MB3871:
x-microsoft-antispam-prvs: <YTBPR01MB38718C3C951DB0995CF3ACF0EC1E0@YTBPR01MB3871.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P4MFgQHG3TzqEltU1L2lYm/jljin0PP2g7beYLBlFh+y/ZrHUIhNG8rE0OMTB+0XQJ+L2lLVH8VBeFMa/oK4SEvMagdriwG6hBNpemoipcdleoVsyMRjb4myxTjuRyyK9kMTMo/HdKWAc7Nrhj+DnYoPnGYaHlCmnEkJfwfN6K3cNrBXSyF5kvwdn9J8zuPMDnpaRMabK2s3axbBytAyE/zC3WrwmAipllZiHfOcEqm31+rVifmvjzBm5gF/kiq4XqzPRQZk8PhbUWhtkIIaCL3kzer1Myxwn5K8ukOJ+iqdcrEwgZexJhvd2Mv4urwGIxG+MFb5ZSuDvI3mGzjvu5FXqjfp95tkmJVTzap08por2AOYZ9ZgouQPwxboOLVlIwC8XvLGoU6yEywMUogCTqC87flVAwCW4m1/KCgfaVDeCcsz7WgX2JCVbp3LcON1Jtkp7lpAoxIEFet29OL5yLbsoeem2m40bLhDATRfmzA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39850400004)(366004)(376002)(66446008)(66476007)(91956017)(66556008)(64756008)(76116006)(66946007)(6506007)(6486002)(186003)(36756003)(4326008)(316002)(478600001)(6512007)(5660300002)(8936002)(2616005)(54906003)(6916009)(15974865002)(44832011)(8676002)(86362001)(71200400001)(4001150100001)(26005)(2906002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: haqGFoC8+FGFH7bGyiBnRcEuZ78eOOTa7myxbyefqI4yS+pBXTyPNZsSyzyc6tIbpG8ChFLRDSxxPJ9155Te66ipkdNmWgJICy+l7NpdmLSzQxxaX8Iw5oUAD/zvrAVwEO0VEGKBn8Mk/tleoxxEEYj8+2q+42Jun4wQIPy1UrgN/D+JV1x05aWXSwydPnIGZnSK3WLB4rMh3+W+oZUEJR+IOUoaBeHn9XFwmSBjuA+YudYBkffeut2Cyzy2ZuqnGDquJdpaHeoDV8/FaxdgKso8ZkjNXrs4wp8kfl4aUqTLR9VodMN/JwJr60ERkGZV4MpsapYCL3OIxOUn9CIpwWjWEEi/v4/qCgnEefHFYGUhR6dzlN6ic6sES/E4GesAytvywztmaMeEPRJtRsL6jjL4/kl+b7i3foV1RGdgh36pitc3l+bPf5yWEIw9AuS7o0BfDpRRn31rDIFHSTOYBnK3YJUCZDn56r2xcdk033RJyFgB90BwovI5pbEN7yFhqoX/E332uZN9AnqGyv38qvcEeBYp6Mp34SRID/B3xKi/0lgkStr21OhgiBboGldzrs3vyxBmTuxkfzyfuyrEP2saTTE04m6yHXA28LGdEhX2LEkOxjpbhziE+bgBwibRfQqvsM6K2OLdzInmxCh2lQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5E392DE2DD62647A93E57D205F1BCC9@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ab39be7-72d9-473f-b753-08d8747bef9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 22:11:32.1735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wAKCawht2Ln/DygQCrFr30WF5+m5MR6MEf+xdUciAFGPyV6EFwQ6j3nkgoAwe4FajqiN+O75UY9WEUHrx4A6FeXza/H9ukiUkHmOe0kFjqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3871
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEwLTE5IGF0IDIzOjU5ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiBJIHN1cHBvc2UgdGhhdCBwYXJ0IHdvdWxkIGJlIHByZXR0eSBoYXJtbGVzcywgYXMgeW91IHdv
dWxkIGxpa2VseQ0KPiA+IHdhbnQNCj4gPiB0aGF0IGJlaGF2aW9yIHdoZW5ldmVyIHRoYXQgaWYg
Y29uZGl0aW9uIHdhcyB0cmlnZ2VyZWQuIFNvDQo+ID4gbTg4ZTExMTFfZmluaXNhcl9jb25maWdf
aW5pdCBjb3VsZCBsaWtlbHkgYmUgbWVyZ2VkIGludG8NCj4gPiBtODhlMTExMV9jb25maWdfaW5p
dC4NCj4gDQo+IEkgdGhpbmsgc28gYXMgd2VsbC4NCj4gDQo+ID4gTWFpbmx5IHdoYXQgc3RvcHBl
ZCBtZSBmcm9tIG1ha2luZyBhbGwgb2YgdGhlc2UgY2hhbmdlcyBnZW5lcmljIHRvDQo+ID4gYWxs
DQo+ID4gODhFMTExMSBpcyB0aGF0IEknbSBhIGJpdCBsZXNzIGNvbmZpZGVudCBpbiB0aGUgZGlm
ZmVyZW50DQo+ID4gY29uZmlnX2FuZWcNCj4gPiBiZWhhdmlvciwgaXQgbWlnaHQgYmUgbW9yZSBz
cGVjaWZpYyB0byB0aGlzIFNGUCBjb3BwZXIgbW9kdWxlDQo+ID4gY2FzZT8gDQo+IA0KPiBXZWxs
LCBmb3IgMTAwMEJhc2VYLCBpIGRvbid0IHRoaW5rIHdlIGN1cnJlbnRseSBoYXZlIGFuIFNGUCBk
ZXZpY2VzDQo+IHVzaW5nIGl0LCBzaW5jZSBwaHlsaW5rIGRvZXMgbm90IHN1cHBvcnQgaXQuIFNv
IGl0IGlzIGEgcXVlc3Rpb24gYXJlDQo+IHRoZXJlIGFueSBub25lLVNGUCBtODhlMTExMSBvdXQg
dGhlcmUgeW91IG1pZ2h0IGJyZWFrPw0KDQpZZWFoLCBJIGRvbid0IHJlYWxseSBrbm93IHRoZSBh
bnN3ZXIgdG8gdGhhdCBxdWVzdGlvbiBhcyBJJ20gbm90DQpmYW1pbGlhciB3aXRoIGFsbCB0aGUg
b3RoZXIgc2V0dXBzIHdoZXJlIHRoaXMgcGFydCB3b3VsZCBiZSB1c2VkLiBTbw0KSSdtIGluY2xp
bmVkIHRvIGxlYXZlIHRoYXQgcGFydCBzcGVjaWZpYyB0byB0aGlzIElELg0KDQotLSANClJvYmVy
dCBIYW5jb2NrDQpTZW5pb3IgSGFyZHdhcmUgRGVzaWduZXIsIEFkdmFuY2VkIFRlY2hub2xvZ2ll
cyANCnd3dy5jYWxpYW4uY29tDQo=

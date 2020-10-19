Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896B02930DA
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387728AbgJSV7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:59:12 -0400
Received: from mail-eopbgr660046.outbound.protection.outlook.com ([40.107.66.46]:45082
        "EHLO CAN01-QB1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729197AbgJSV7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:59:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRNb9gAH0SHhvwvcfe1APhA+LoQKFTnVZuIOnhVkFFkr4mhDBSRXdWPGlHkS7ZqPdJ0b/Ta1GSuNUxALqiJm+Zcl+6cbJyVW9Hzy+2sd7nFC4XrgqTGEL+aQrlJSdQGWhDdHUwi+fMZ4S65uScrw/KcRei/Que/wm+GmGUjFUsL10EptVrlLY+M8+e3ehIj+PmTLWb9/WH5IobRryra/uMhhVSOS3QwMKlDSO16rFpMiRoYBQ6/Oks4SBUT0xGzKyes5uVW8XKsiLDaEWZIzwSIH9+F2NNaupypxU07B/ClOo2z1rjcznOY1GCBPSfQbkOE2RCcd6fQka9y6hPcs8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sazjiwy6QBc0SgS7h+O6p+JN3XBzxoKMZSNG7UXLOwM=;
 b=npzWnm+u9Nz1P5/7/bthhS2Z8SbyG4nqsnVYWIURWBS8aFfOph1ffU5iU5EteRPoEf1wYilDLAwqF26K/YwvqcLfUYYfh7pznwCr+vw0wqMiyukNehozkgy2GgNPx70pfERuCCyv9POBrsdKbcXfwFD+gx08cF8FfUhazJ3BaMnTUPkI/KBQ5a/5kNTKV4Ug1BMf39/u2Y0Rlkn0XsqVYutUAct98ryDzZlhrL41UDUJlHP1CwJ09TulRzElgFQbYAyWPeDyl1hVmPFlXZXN20MXCzGBD5WLpZKzSIHHYFzNG6RlD1c3fLiG4fq32QqvDPBf3yhRSYC/XkEkvhWq5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sazjiwy6QBc0SgS7h+O6p+JN3XBzxoKMZSNG7UXLOwM=;
 b=JEosnREY0FgVU+g/5DZvVIMcDare2oV8ToCsBbKuoSq+EzVz144nAeutxLBnAkPgcwRB8lnYW3qT0z7n2M/u5jWKcHt57CwCD29x9hp/kgsUVnH/l4cx1AkJp3CyXbUjnsnme576x2MoAgQAwGEyZTagFtIbzIolHx82nXMoJNQ=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT1PR01MB2619.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Mon, 19 Oct
 2020 21:59:09 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 21:59:09 +0000
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
Thread-Index: AQHWpll91HNTpw9Y2UKmWJkWbB3A/amfa2WAgAAGtgCAAAONAIAAA8gA
Date:   Mon, 19 Oct 2020 21:59:09 +0000
Message-ID: <1f3243e15a8600dd9876b97410b450029674c50c.camel@calian.com>
References: <20201019204913.467287-1-robert.hancock@calian.com>
         <20201019210852.GW1551@shell.armlinux.org.uk>
         <30161ca241d03c201e801af7089dada5b6481c24.camel@calian.com>
         <20201019214536.GX139700@lunn.ch>
In-Reply-To: <20201019214536.GX139700@lunn.ch>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-12.el8) 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7579d09-cbd7-42b9-cdcb-08d8747a34ba
x-ms-traffictypediagnostic: YT1PR01MB2619:
x-microsoft-antispam-prvs: <YT1PR01MB26191BDCF444F9582D61392FEC1E0@YT1PR01MB2619.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AfxqsyGG6Ld1H48WPKT/wYiJPYvMhxRqRh7/UNc1AR+Ely4h/43YYYntVPS1CawjdSYiKCj/ZYkX5LhondaYgzQj+okGXuxHKH++hOOQKSUueA6Zxs876LPeO9N436B2om2o0cdlgB6niXQGykKqRsPO179n6J1UTgZR/QoYiV7aZwxLX52GJfkwSg27sWDnIF65qIof/TeVj+MnnJwp8nMuOHwGb/gY6EcZBvJ0UfXATb/F/HO1RO/ogNv/pZNb/M93/q354ANan3v7vUWTHMKhhkSjjpBx0wi5L8wXVmlpULTq1d73ZD6u5Ltio45y1r3jlN/2fyGL3jQ57IicyMGemoHAND9msvVL1NnWREh7nSTlZ4oOwKDM2RlMZQb9scBFZB0KqWVIJ6FIq4dEQveYRba9ZSpWbq0DofN3cGTl5gsUem7cGckzuu6vseJeeaZ4Mnvbm5TVTXWXkCelhmCMKBpkWF5NQ4k+ly9a/RM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(396003)(346002)(376002)(366004)(186003)(4001150100001)(6512007)(8936002)(8676002)(6916009)(4326008)(478600001)(6486002)(6506007)(2616005)(26005)(15974865002)(86362001)(5660300002)(54906003)(64756008)(76116006)(44832011)(66556008)(66446008)(2906002)(91956017)(36756003)(66946007)(66476007)(71200400001)(316002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: GDQ+vHPkQDXUoAMUFeKLuJjNO32Gggq2wS/1WYTuK1UVNMI4WYGGwJGmP82WeDh+KlYNVOMx2+mAxHVNQ30EOXSypnV3Dme3W2dXHG8KZDK+mLQrtdKDLImeDC15KadWs/iaIfSXjmRqvAE0ddr0aflxNFhCJD7lDeRLjh7nkgSzcd1ceorKBfQc/BLUop1909LNgV8Oit6KjA6bZs+tw65bmFPrTLsD19NM7c87WSdxgDQaE11aqClePvi41eEPtIEx0f8BVdFTl8YhcMt7yvGsE8v1pB6B1sb6q2GOD0MAP7OIYZc7nVUo1OSTfatN7dRHBVD+/RIO7MWdQ6tnACfZERvsbtP6bfMUWKXa8PwaxHT1jTZKKe0XIff+Q1EocEDah8ZxcdAUnxizgA7GO9+cMs9GvfAqQIT9ZOpsG79r2ciBPDi/kogSRkQ7uTDJt+uVJjG4V12UadlzHjUp08WS7sVFIjLt7/D8fnnifBAxIMs8Y2hy9IH255E9ILe728QX1NR8qjOsSHsFrZ8qvV9xiUD61Fmsn10mr2OqkniKUxEOCh9n9to3fHbnRu1cNPxpxbjdzK0/+LPMkxHnlenn5eO4oXCMTAVSVl10gwReigtFEBrBl9UAUtlGgjzjH50X9ZlpNBT71ZKgkoq3JQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5A0521776287E4F9ACF119E91CFF60F@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a7579d09-cbd7-42b9-cdcb-08d8747a34ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 21:59:09.1655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pB3FxDkWhmNYB+KY9OmmfmIAYpg2oVUSPv0F9E18m+n2ZJwurhB6B9FOdgVN9SZOUiVO/+Z1t3Iu31z8QJ0sKzXQUm0l9wWYx7bDx3BPVLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB2619
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEwLTE5IGF0IDIzOjQ1ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiBJIGhhdmUgYSBsb2NhbCBwYXRjaCB0aGF0IGp1c3QgZmFsbHMgYmFjayB0byB0cnlpbmcgMTAw
MEJhc2VYIG1vZGUNCj4gPiBpZiB0aGUgZHJpdmVyIHJlcG9ydHMgU0dNSUkgaXNuJ3Qgc3VwcG9y
dGVkIGFuZCBpdCBzZWVtcyBsaWtlIGl0DQo+ID4gbWlnaHQgYmUgYSBjb3BwZXIgbW9kdWxlLCBi
dXQgdGhhdCBpcyBhIGJpdCBvZiBhIGhhY2sgdGhhdCBtYXkgbmVlZA0KPiA+IHRvIGJlIGhhbmRs
ZWQgZGlmZmVyZW50bHkuDQo+IA0KPiBEbyB5b3UgYWxzbyBtb2RpZnkgd2hhdCB0aGUgUEhZIGlz
IGFkdmVydGlzaW5nIHRvIHJlbW92ZSB0aGUgbW9kZXMNCj4geW91ciBjYW5ub3Qgc3VwcG9ydD8N
Cg0KSSB0aGluayBpbiBteSBjYXNlIHRob3NlIGV4dHJhIG1vZGVzIG9ubHkgc3VwcG9ydGVkIGlu
IFNHTUlJIG1vZGUsIGxpa2UNCjEwIGFuZCAxMDBNYnBzIG1vZGVzLCBlZmZlY3RpdmVseSBnZXQg
ZmlsdGVyZWQgb3V0IGJlY2F1c2UgdGhlIE1BQw0KZG9lc24ndCBzdXBwb3J0IHRoZW0gaW4gdGhl
IDEwMDBCYXNlWCBtb2RlIGVpdGhlci4gQnV0IHllcywgdGhhdA0KcHJvYmFibHkgc2hvdWxkIGJl
IGZpeGVkIHVwIGluIHRoZSBQSFkgY2FwYWJpbGl0aWVzIGluIGEgInByb3BlciINCnNvbHV0aW9u
Lg0KDQpUaGUgYXV0by1uZWdvdGlhdGlvbiBpcyBhIGJpdCBvZiBhIHdlaXJkIHRoaW5nIGluIHRo
aXMgY2FzZSwgYXMgdGhlcmUNCmFyZSB0d28gbmVnb3RpYXRpb25zIG9jY3VycmluZywgdGhlIDEw
MDBCYXNlWCBiZXR3ZWVuIHRoZSBQQ1MvUE1BIFBIWQ0KYW5kIHRoZSBtb2R1bGUgUEhZLCBhbmQg
dGhlIDEwMDBCYXNlVCBiZXR3ZWVuIHRoZSBtb2R1bGUgUEhZIGFuZCB0aGUNCmNvcHBlciBsaW5r
IHBhcnRuZXIuIEkgYmVsaWV2ZSB0aGUgODhFMTExMSBoYXMgc29tZSBzbWFydHMgdG8gZGVsYXkg
dGhlDQpjb3BwZXIgbmVnb3RpYXRpb24gdW50aWwgaXQgZ2V0cyB0aGUgYWR2ZXJ0aXNlbWVudCBv
dmVyIDEwMDBCYXNlWCwgdXNlcw0KdGhvc2UgdG8gZmlndXJlIG91dCBpdHMgYWR2ZXJ0aXNlbWVu
dCwgYW5kIHRoZW4gdXNlcyB0aGUgY29wcGVyIGxpbmsNCnBhcnRuZXIncyByZXNwb25zZSB0byBk
ZXRlcm1pbmUgdGhlIDEwMDBCYXNlWCByZXNwb25zZS4NCg0KLS0gDQpSb2JlcnQgSGFuY29jaw0K
U2VuaW9yIEhhcmR3YXJlIERlc2lnbmVyLCBBZHZhbmNlZCBUZWNobm9sb2dpZXMgDQp3d3cuY2Fs
aWFuLmNvbQ0K

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 498BA1CC04
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 17:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfENPhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 11:37:10 -0400
Received: from mail-eopbgr700098.outbound.protection.outlook.com ([40.107.70.98]:12000
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725916AbfENPhK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 11:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYR/D8pgHuU0QzCgyexGssxtHP1H0m9VtIOvybhYoaY=;
 b=dTq/wZDxIm9KteIOHh6ancED6VtHvYZF7HJw5RmEDydq+YoU8DrP1Hn+i4Qzv7jNIs0/rjJQzy9kwWAACDJew2MfSgAM0Wco4s9hAcZ5B0uo12L1fErZ08NOBMru5nRFKS/jruQjgBxSDPSYy5IyQUmD2sGFJgClRJVbS/ZQq/w=
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3611.namprd06.prod.outlook.com (10.167.236.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Tue, 14 May 2019 15:37:05 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876%2]) with mapi id 15.20.1878.024; Tue, 14 May 2019
 15:37:05 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 5/5] net: phy: dp83867: Use unsigned variables to store
 unsigned properties
Thread-Topic: [PATCH 5/5] net: phy: dp83867: Use unsigned variables to store
 unsigned properties
Thread-Index: AQHVB3nKLczzbyv1Ekyx8+zOFp2aoKZlvT2AgAAe/wCAA6E4AIAABBwAgAAJa4CAAAsdgIAABMUAgAEr8gA=
Date:   Tue, 14 May 2019 15:37:05 +0000
Message-ID: <1557848224.4229.48.camel@impinj.com>
References: <20190510214550.18657-1-tpiepho@impinj.com>
         <20190510214550.18657-5-tpiepho@impinj.com>
         <49c6afc4-6c5b-51c9-74ab-9a6e8c2460a5@gmail.com>
         <3a42c0cc-4a4b-e168-c03e-1cc13bd2f5d4@gmail.com>
         <1557777496.4229.13.camel@impinj.com>
         <b246b18d-5523-7b8b-9cd0-b8ccb8a511e9@gmail.com>
         <20190513204641.GA12345@lunn.ch> <1557782787.4229.36.camel@impinj.com>
         <20190513214332.GB12345@lunn.ch>
In-Reply-To: <20190513214332.GB12345@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tpiepho@impinj.com; 
x-originating-ip: [216.207.205.253]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9712d24-9785-47f3-60f5-08d6d88204be
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3611;
x-ms-traffictypediagnostic: MWHPR0601MB3611:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR0601MB3611F270CD25B524E79BE3CED3080@MWHPR0601MB3611.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(346002)(136003)(396003)(376002)(189003)(199004)(76176011)(8936002)(1730700003)(68736007)(8676002)(53936002)(4326008)(316002)(2906002)(6506007)(66066001)(14454004)(73956011)(102836004)(91956017)(76116006)(66946007)(6116002)(54906003)(71190400001)(71200400001)(81156014)(66476007)(3846002)(66556008)(64756008)(81166006)(256004)(99286004)(7736002)(2501003)(103116003)(66446008)(25786009)(5660300002)(486006)(6486002)(2351001)(476003)(2616005)(186003)(6436002)(6916009)(36756003)(478600001)(6512007)(26005)(6246003)(5640700003)(86362001)(446003)(229853002)(6306002)(966005)(305945005)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3611;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: impinj.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e7UtgXZWShb8Lbkme6FMR6RS553Mu8CEtgGKZMC0w/h9QHFbcMwi4iIeBi3Zqld7LJeSIhZrnC9si7OcjNa/ymU73CAc8NX3NHu7kr5nPhMLzZYfxw0TR1VdOMYmDdudFYhnvChDSE/tGg/a93orrlPHHVvNUrm/wyXebWv9xWF6XR//ZXhTr1BcIaxF/0TibiNEwRafZiNse0N8cW4pyiUv8viVfXLzJxCSQBUJli84fPsKS17kkL7ssD7sGs0syw6Y5b2nddfkFxV2ztx8zbq875S63Bsd5R1hD5prePYs3vHKbQ+3CO0vN5c5JIETL0cV0jOMd4jNI2QVumcgSB2ctf2dTcmv3ivhsUP2L10D1sQk4mlAV/db0pJGrKxQ9SFFRfPLN+vVvt0YDVxizVr1kqI7lwz0OyJBFMnfX2c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CA5BB3B1991E448ACEA897DA5A98120@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9712d24-9785-47f3-60f5-08d6d88204be
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 15:37:05.4215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3611
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA1LTEzIGF0IDIzOjQzICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiA+IA0KPiA+ID4gQXJlIHRoZXJlIGFueSBpbiB0cmVlIHVzZXJzIG9mIERQODM4NjdfQ0xLX09f
U0VMX1JFRl9DTEs/IFdlIGhhdmUgdG8NCj4gPiA+IGJlIGNhcmVmdWwgY2hhbmdpbmcgaXRzIG1l
YW5pbmcuIEJ1dCBpZiBub2JvZHkgaXMgYWN0dWFsbHkgdXNpbmcgaXQuLi4NCj4gPiANCj4gPiBO
b3BlLiAgSSBkb3VidCB0aGlzIHdpbGwgYWZmZWN0IGFueW9uZS4gIFRoZXknZCBuZWVkIHRvIHN0
cmFwIHRoZSBwaHkNCj4gPiB0byBnZXQgYSBkaWZmZXJlbnQgY29uZmlndXJhdGlvbiwgYW5kIHRo
ZSBleHBsaWNpdGx5IGFkZCBhIHByb3BlcnR5LA0KPiA+IHdoaWNoIGlzbid0IGluIHRoZSBleGFt
cGxlIERUUyBmaWxlcywgdG8gY2hhbmdlIHRoZSBjb25maWd1cmF0aW9uIHRvDQo+ID4gc29tZXRo
aW5nIHRoZXkgZGlkbid0IHdhbnQsIGFuZCB0aGVuIGRlcGVuZCBvbiBhIGRyaXZlciBidWcgaWdu
b3JpbmcNCj4gPiB0aGUgZXJyb25lb3VzIHNldHRpbmcgdGhleSBhZGRlZC4NCj4gDQo+IE8uSywg
dGhlbiB0aGlzIHBhdGNoIGlzIE8uSy4gRG9lcyB0aGUgYmluZGluZyBkb2N1bWVudGF0aW9uIG5l
ZWQNCj4gdXBkYXRpbmc/DQoNCkRldmljZSB0cmVlIGJpbmRpbmcgcGF0Y2ggd2FzIHNwbGl0IG91
dCBvZiB0aGUgY29tbWl0IGFuZCB3YXMgcGF0Y2ggMg0Kb2YgdGhlIHNlcmllcywgaHR0cHM6Ly9w
YXRjaHdvcmsub3psYWJzLm9yZy9wYXRjaC8xMDk4MzQ5Lw0KDQo+ID4gPiBQYXRjaCA0Og0KPiA+
ID4gDQo+ID4gPiBUaGlzIGlzIGhhcmRlci4gSWRlYWxseSB3ZSB3YW50IHRvIGZpeCB0aGlzLiBB
dCBzb21lIHBvaW50LCBzb21lYm9keQ0KPiA+ID4gaXMgZ29pbmcgdG8gd2FudCAncmdtaWknIHRv
IGFjdHVhbGx5IG1lYW4gJ3JnbWlpJywgYmVjYXVzZSB0aGF0IGlzDQo+ID4gPiB3aGF0IHRoZWly
IGhhcmR3YXJlIG5lZWRzLg0KPiA+ID4gDQo+ID4gPiBDb3VsZCB5b3UgYWRkIGEgV0FSTl9PTigp
IGZvciAncmdtaWknIGJ1dCB0aGUgUEhZIGlzIGFjdHVhbGx5IGFkZGluZyBhDQo+ID4gPiBkZWxh
eT8gQW5kIGFkZCBhIGNvbW1lbnQgYWJvdXQgc2V0dGluZyB0aGUgY29ycmVjdCB0aGluZyBpbiBk
ZXZpY2UNCj4gPiA+IHRyZWU/ICBIb3BlZnVsbHkgd2Ugd2lsbCB0aGVuIGdldCBwYXRjaGVzIGNv
cnJlY3RpbmcgRFQgYmxvYnMuIEFuZCBpZg0KPiA+ID4gd2UgbGF0ZXIgZG8gbmVlZCB0byBmaXgg
J3JnbWlpJywgd2Ugd2lsbCBicmVhayBsZXNzIGJvYXJkLg0KPiA+IA0KPiA+IFllcyBJIGNhbiBk
byB0aGlzLiAgU2hvdWxkIGl0IHdhcm4gb24gYW55IHVzZSBvZiAicmdtaWkiPw0KPiANCj4gTm8s
IGkgd291bGQgb25seSB3YXJuIHdoZW4gdGhlcmUgaXMgYSBkZWxheSBjb25maWd1cmVkIGJ5DQo+
IHN0cmFwcGluZy4gSWYgeW91IHdhbnQgdGhlIFBIWSB0byBiZSBsZWZ0IGFsb25lLCB5b3Ugc2hv
dWxkIHVzZQ0KPiBQSFlfSU5URVJGQUNFX01PREVfTkEsIHdoaWNoIHNob3VsZCBiZSB0aGUgZGVm
YXVsdCBpZiB0aGVyZSBpcyBubw0KPiBwaHktbW9kZSBwcm9wZXJ0eS4gSWYgRFQgYWN0dWFsbHkg
YXNrZWQgZm9yICJyZ21paSIsIGl0IGVpdGhlciBtZWFucw0KPiBpdCBpcyB3cm9uZyBhbmQgcmdt
aWktaWQgc2hvdWxkIGJlIHVzZWQgdG8gbWF0Y2ggdGhlIHN0cmFwcGluZywgb3INCj4gYm90aCB0
aGUgc3RyYXBwaW5nIGFuZCB0aGUgRFQgaXMgd3JvbmcgYW5kIHNvbWVib2R5IHJlYWxseSBkb2Vz
IHdhbnQNCj4gInJnbWlpIi4NCg0KT2ssIHNlZW1zIHJlYXNvbmFibGUuICBJJ3ZlIHB1dCBpbiBh
IHBoeWRldl93YXJuKCkgd2hlbiB0aGUgaW50ZXJmYWNlDQppcyAncmdtaWknIGFuZCB0aGUgc3Ry
YXBwaW5nIGlzIHNldCB0byBoYXZlIGEgZGVsYXkuICBJJ20gY2hlY2tpbmcgdGhlDQpzdHJhcHBp
bmcgY29uZmlnIHJlZ2lzdGVyIGZvciB0aGlzLCByYXRoZXIgdGhhbiB0aGUgY3VycmVudCBwaHkN
CmNvbmZpZ3VyYXRpb24gb2YgZGVsYXkgdmFsdWVzLiAgVGhlIHByZXZpb3VzIGJlaGF2aW9yIG9m
ICdyZ21paScgbW9kZQ0Kd2FzICJrZWVwIHN0cmFwcGluZyBkZWZhdWx0IiwgcmF0aGVyIHRoYW4g
ImtlZXAgY3VycmVudCBwaHkNCmNvbmZpZ3VyYXRpb24iLCB3aGljaCBpc24ndCBleGFjdGx5IHRo
ZSBzYW1lIHRoaW5nLg0KDQpIZXJlIGlzIHRoZSBtZXNzYWdlOg0KDQpwaHlkZXZfd2FybihwaHlk
ZXYsDQogICAgICAgICAgICAiUEhZIGhhcyBkZWxheXMgdmlhIHBpbiBzdHJhcHBpbmcsIGJ1dCBw
aHktbW9kZSA9ICdyZ21paSdcbiINCiAgICAgICAgICAgICJTaG91bGQgYmUgJ3JnbWlpLWlkJyB0
byB1c2UgaW50ZXJuYWwgZGVsYXlzXG4iKTsgICANCg0K

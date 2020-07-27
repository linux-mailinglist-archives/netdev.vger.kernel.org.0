Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9CA22F86C
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgG0StD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:49:03 -0400
Received: from mail-am6eur05on2073.outbound.protection.outlook.com ([40.107.22.73]:38080
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726879AbgG0StD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 14:49:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjJU/UOhXR/YHGnXDKNaJalUfF0MHLoYr6L5hPS166GWIuzhXNdcaBYAWtOevtOl+Hu4hbYU841ABz+gh2/qyxg4xvGSufv2T+WVFFNOKYpc1Wx0brVgcUQavGF3DU4EYr2O3kFQ9P1MF5KPbdkbubEV+lK4NAEydAmaCqRkhV+hVPnA/su8DKDsLDlTnvre+ucpeVQx8S2uUz+XNLOP7frMAvUzYN1eeP3tTgOxcL8ZeRlWDCpQX4jQ6H+mBqYcR9HVNO0i62mqbVrpSZbzKmJdxvCn0K8Bbe6h6QIoa09BFwx4hPBlDNRO1YmB+aaO7PxMd94S6qgyFA9yEKD7cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXB2U9UumDyOlnW32oPv3CyGXAgzMJTZ6MrcpiHpoQc=;
 b=EVaaVhQ7v/R/tDxLX37ZMYsDmxh4UnsUpfa/GDeFYLZO9uYELghG0eNLuLrQToW25IlMVBNm0g35DDvhy8R4LthmzoIh5yXW5tdrkQ+yO6JKaRwdX2+psbjeVxOjOf6qLGOdPObibHutwos7oBbeRWF3wJc9kACW2B/XbxbuWJZWi6+YXU4JE4XMdmU6ILXaTLMdDVeIGIF3wF4XsnSDZZCtkXAV28DnM8075SnrY8yeuyj7s7ou4qhyl5XHvG0X6671H480ku2KTj4jKqIvXVF3Q9Zf7dKDr2Lqw8afVG92UPNHF652xImoXfuQ7bYox59GS4g5a0TaGrFKNY6QUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXB2U9UumDyOlnW32oPv3CyGXAgzMJTZ6MrcpiHpoQc=;
 b=mtHP8pjWLzxkPrrTkmpAo9hczRpzoyyGb9yzxIok3auRoXVxN1axoZSWKE+O49S5WWCSYUXnQ6TuUc9OIj4JvHxQJ6npezdVD1ytB1N4PUf/7Y8g0Rh5hVdb1RDAongjuMZcLx2+c1xE204WKOApnydKnykeB5hlj2hM5Xnh2wo=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB3245.eurprd04.prod.outlook.com
 (2603:10a6:802:6::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Mon, 27 Jul
 2020 18:48:58 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 18:48:58 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Subject: RE: [PATCH net-next v4 0/5] net: phy: add Lynx PCS MDIO module
Thread-Topic: [PATCH net-next v4 0/5] net: phy: add Lynx PCS MDIO module
Thread-Index: AQHWYZC4YCXOCeCZEUertSpJGVnGvakbxKmAgAADRzA=
Date:   Mon, 27 Jul 2020 18:48:58 +0000
Message-ID: <VI1PR0402MB387150745E6EB735F5A4D538E0720@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200724080143.12909-1-ioana.ciornei@nxp.com>
 <400c65b5-718e-64f5-a2a2-3b26108a93d5@gmail.com>
In-Reply-To: <400c65b5-718e-64f5-a2a2-3b26108a93d5@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.95.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7a77d9af-0098-4c96-986e-08d8325db8a2
x-ms-traffictypediagnostic: VI1PR04MB3245:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB324548D695B3F742DE2F140CE0720@VI1PR04MB3245.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HzdK75MEwxZbMTnDNFaP9/bEybWitlM1ftKpfdDwOUFG3kEhR4TNBKuoAmWiclAi9WYrc66MsnPk33uG/IcdefMnKYepMelVS+ZNEOZPzi78yiFc/Axm3f+/1dmTNMEYDi+Jo8K1eFVT+kNameZQzA4HNzOaQzDY1EGML3Kn9gxoojCN4Ji9zHlIILZ/YedgJjPBzVgwZLINw0pDHyYp7YeEXLows3uihzrRZpf8hgsx+V5vQt/BdnTS2BeiBYdAypE54EfUgIy43AaRSwEFnBtzRQyjjhPzjLBmFKrOVtrT32HqahUtFyArl5c2I/ZQ1564EXMBuGNPkUdyrrY5XQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(396003)(346002)(39860400002)(53546011)(83380400001)(86362001)(55016002)(71200400001)(8936002)(6506007)(33656002)(66446008)(8676002)(7696005)(64756008)(66556008)(66476007)(316002)(44832011)(186003)(54906003)(9686003)(478600001)(26005)(5660300002)(52536014)(4326008)(110136005)(76116006)(2906002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: x1ihLkePFrbL0jffeCAlnJNHHurTmg5CTbMlj0rSrvIlfuPdCL4z+TN94EbN6FxBdSq3y4orWICK34Of5uKiUjLQDTRVHNVyUQvbVQ8pNbSZKA+WcA1l9ZAUvY68MIktsuEjRhaCy77X1xC04p6QSXRirGnohKBmmEdereJzOQkWLK5VujnYhz8opyj+oieCsjncZWp9/xoVESAWXSzpqe89onkPZO7UM3zSvEe8qAz/PSb7gFuudzpFlLPzb8Bdeuokp7U91HO0bfy7UD3tXxOh9F+2GRCxYJp08tOYO+zb8/egPx0kzfyC1SoANI8eD27M5OJ446zIbad0+ubF7QFy+6AZsMnSDS6lOH8maZEhc97GMAEGlo9eA0mnu3h+dFiM3MlBvM7dPSwq959VXwSSjoJATO3Wax3GGulJIFhSbYNSOSZG3jCqj5Nrp6hN1ovguxPqdTGlZV2r4sGq3N4yUq/xaxLinEhuQwXumRc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a77d9af-0098-4c96-986e-08d8325db8a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 18:48:58.2776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X5QCfXh5NNnPy1TUG0oRUGOCU0PG3xHb9toZtllQhx/DYDb+qelccBLOmdCtLfvbfs00hBn75h0CSSI0knTFPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3245
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IHY0IDAvNV0gbmV0OiBwaHk6IGFkZCBMeW54
IFBDUyBNRElPIG1vZHVsZQ0KPiANCj4gDQo+IA0KPiBPbiA3LzI0LzIwMjAgMTowMSBBTSwgSW9h
bmEgQ2lvcm5laSB3cm90ZToNCj4gPiBBZGQgc3VwcG9ydCBmb3IgdGhlIEx5bnggUENTIGFzIGEg
c2VwYXJhdGUgbW9kdWxlIGluIGRyaXZlcnMvbmV0L3BoeS8uDQo+ID4gVGhlIGFkdmFudGFnZSBv
ZiB0aGlzIHN0cnVjdHVyZSBpcyB0aGF0IG11bHRpcGxlIGV0aGVybmV0IG9yIHN3aXRjaA0KPiA+
IGRyaXZlcnMgdXNlZCBvbiBOWFAgaGFyZHdhcmUgKEVORVRDLCBTZXZpbGxlLCBGZWxpeCBEU0Eg
c3dpdGNoIGV0YykNCj4gPiBjYW4gc2hhcmUgdGhlIHNhbWUgaW1wbGVtZW50YXRpb24gb2YgUENT
IGNvbmZpZ3VyYXRpb24gYW5kIHJ1bnRpbWUNCj4gPiBtYW5hZ2VtZW50Lg0KPiA+DQo+ID4gVGhl
IG1vZHVsZSBpbXBsZW1lbnRzIHBoeWxpbmtfcGNzX29wcyBhbmQgZXhwb3J0cyBhIHBoeWxpbmtf
cGNzDQo+ID4gKGluY29ycG9yYXRlZCBpbnRvIGEgbHlueF9wY3MpIHdoaWNoIGNhbiBiZSBkaXJl
Y3RseSBwYXNzZWQgdG8gcGh5bGluaw0KPiA+IHRocm91Z2ggcGh5bGlua19wY3Nfc2V0Lg0KPiA+
DQo+ID4gVGhlIGZpcnN0IDMgcGF0Y2hlcyBhZGQgc29tZSBtaXNzaW5nIHBpZWNlcyBpbiBwaHls
aW5rIGFuZCB0aGUgbG9ja2VkDQo+ID4gbWRpb2J1cyB3cml0ZSBhY2Nlc3Nvci4gTmV4dCwgdGhl
IEx5bnggUENTIE1ESU8gbW9kdWxlIGlzIGFkZGVkIGFzIGENCj4gPiBzdGFuZGFsb25lIG1vZHVs
ZS4gVGhlIG1ham9yaXR5IG9mIHRoZSBjb2RlIGlzIGV4dHJhY3RlZCBmcm9tIHRoZQ0KPiA+IEZl
bGl4IERTQSBkcml2ZXIuIFRoZSBsYXN0IHBhdGNoIG1ha2VzIHRoZSBuZWNlc3NhcnkgY2hhbmdl
cyBpbiB0aGUNCj4gPiBGZWxpeCBhbmQgU2V2aWxsZSBkcml2ZXJzIGluIG9yZGVyIHRvIHVzZSB0
aGUgbmV3IGNvbW1vbiBQQ1MgaW1wbGVtZW50YXRpb24uDQo+ID4NCj4gPiBBdCB0aGUgbW9tZW50
LCBVU1hHTUlJIChvbmx5IHdpdGggaW4tYmFuZCBBTiksIFNHTUlJLCBRU0dNSUkgKHdpdGggYW5k
DQo+ID4gd2l0aG91dCBpbi1iYW5kIEFOKSBhbmQgMjUwMEJhc2UtWCAob25seSB3L28gaW4tYmFu
ZCBBTikgYXJlIHN1cHBvcnRlZA0KPiA+IGJ5IHRoZSBMeW54IFBDUyBNRElPIG1vZHVsZSBzaW5j
ZSB0aGVzZSB3ZXJlIGFsc28gc3VwcG9ydGVkIGJ5IEZlbGl4DQo+ID4gYW5kIG5vIGZ1bmN0aW9u
YWwgY2hhbmdlIGlzIGludGVuZGVkIGF0IHRoaXMgdGltZS4NCj4gPg0KPiA+IENoYW5nZXMgaW4g
djI6DQo+ID4gICogZ290IHJpZCBvZiB0aGUgbWRpb19seW54X3BjcyBzdHJ1Y3R1cmUgYW5kIGRp
cmVjdGx5IGV4cG9ydGVkIHRoZQ0KPiA+IGZ1bmN0aW9ucyB3aXRob3V0IHRoZSBuZWVkIG9mIGFu
IGluZGlyZWN0aW9uDQo+ID4gICogbWFkZSB0aGUgbmVjZXNzYXJ5IGFkanVzdG1lbnRzIGZvciB0
aGlzIGluIHRoZSBGZWxpeCBEU0EgZHJpdmVyDQo+ID4gICogc29sdmVkIHRoZSBicm9rZW4gYWxs
bW9kY29uZmlnIGJ1aWxkIHRlc3QgYnkgbWFraW5nIHRoZSBtb2R1bGUNCj4gPiB0cmlzdGF0ZSBp
bnN0ZWFkIG9mIGJvb2wNCj4gPiAgKiBmaXhlZCBhIG1lbW9yeSBsZWFrYWdlIGluIHRoZSBGZWxp
eCBkcml2ZXIgKHRoZSBwY3Mgc3RydWN0dXJlIHdhcw0KPiA+IGFsbG9jYXRlZCB0d2ljZSkNCj4g
Pg0KPiA+IENoYW5nZXMgaW4gdjM6DQo+ID4gICogYWRkZWQgc3VwcG9ydCBmb3IgUEhZTElOSyBQ
Q1Mgb3BzIGluIERTQSAocGF0Y2ggNS85KQ0KPiA+ICAqIGNsZWFudXAgaW4gRmVsaXggUEhZTElO
SyBvcGVyYXRpb25zIGFuZCBtaWdyYXRlIHRvDQo+ID4gIHBoeWxpbmtfbWFjX2xpbmtfdXAoKSBi
ZWluZyB0aGUgY2FsbGJhY2sgb2YgY2hvaWNlIGZvciBhcHBseWluZyBNQUMNCj4gPiBjb25maWd1
cmF0aW9uIChwYXRjaGVzIDYtOCkNCj4gPg0KPiA+IENoYW5nZXMgaW4gdjQ6DQo+ID4gICogdXNl
IHRoZSBuZXdseSBpbnRyb2R1Y2VkIHBoeWxpbmsgUENTIG1lY2hhbmlzbQ0KPiA+ICAqIGluc3Rh
bGwgdGhlIHBoeWxpbmtfcGNzIGluIHRoZSBwaHlsaW5rX21hY19jb25maWcgRFNBIG9wcw0KPiA+
ICAqIHJlbW92ZSB0aGUgZGlyZWN0IGltcGxlbWVudGF0aW9ucyBvZiB0aGUgUENTIG9wcw0KPiA+
ICAqIGRvIG5vIHVzZSB0aGUgU0dNSUlfIHByZWZpeCB3aGVuIHJlZmVycmluZyB0byB0aGUgSUZf
TU9SRSByZWdpc3Rlcg0KPiA+ICAqIGFkZCBhIHBoeWxpbmsgaGVscGVyIHRvIGRlY29kZSB0aGUg
VVNYR01JSSBjb2RlIHdvcmQNCj4gPiAgKiByZW1vdmUgY2xlYW51cCBwYXRjaGVzIGZvciBGZWxp
eCAodGhlc2UgaGF2ZSBiZWVuIGFscmVhZHkgYWNjZXB0ZWQpDQo+ID4gICogU2V2aWxsZSAocmVj
ZW50bHkgaW50cm9kdWNlZCkgbm93IGhhcyBQQ1Mgc3VwcG9ydCB0aHJvdWdoIHRoZSBzYW1lDQo+
ID4gTHlueCBQQ1MgbW9kdWxlDQo+ID4NCj4gPiBJb2FuYSBDaW9ybmVpICg1KToNCj4gPiAgIG5l
dDogcGh5bGluazogYWRkIGhlbHBlciBmdW5jdGlvbiB0byBkZWNvZGUgVVNYR01JSSB3b3JkDQo+
ID4gICBuZXQ6IHBoeWxpbms6IGNvbnNpZGVyIFFTR01JSSBpbnRlcmZhY2UgbW9kZSBpbg0KPiA+
ICAgICBwaHlsaW5rX21paV9jMjJfcGNzX2dldF9zdGF0ZQ0KPiA+ICAgbmV0OiBtZGlvYnVzOiBh
ZGQgY2xhdXNlIDQ1IG1kaW9idXMgd3JpdGUgYWNjZXNzb3INCj4gPiAgIG5ldDogcGh5OiBhZGQg
THlueCBQQ1MgbW9kdWxlDQo+ID4gICBuZXQ6IGRzYTogb2NlbG90OiB1c2UgdGhlIEx5bnggUENT
IGhlbHBlcnMgaW4gRmVsaXggYW5kIFNldmlsbGUNCj4gPg0KPiA+ICBNQUlOVEFJTkVSUyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA3ICsNCj4gPiAgZHJpdmVycy9uZXQvZHNhL29j
ZWxvdC9LY29uZmlnICAgICAgICAgICB8ICAgMSArDQo+ID4gIGRyaXZlcnMvbmV0L2RzYS9vY2Vs
b3QvZmVsaXguYyAgICAgICAgICAgfCAgMjggKy0NCj4gPiAgZHJpdmVycy9uZXQvZHNhL29jZWxv
dC9mZWxpeC5oICAgICAgICAgICB8ICAyMCArLQ0KPiA+ICBkcml2ZXJzL25ldC9kc2Evb2NlbG90
L2ZlbGl4X3ZzYzk5NTkuYyAgIHwgMzc0ICsrLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gIGRy
aXZlcnMvbmV0L2RzYS9vY2Vsb3Qvc2V2aWxsZV92c2M5OTUzLmMgfCAgMjEgKy0NCj4gPiAgZHJp
dmVycy9uZXQvcGh5L0tjb25maWcgICAgICAgICAgICAgICAgICB8ICAgNiArDQo+ID4gIGRyaXZl
cnMvbmV0L3BoeS9NYWtlZmlsZSAgICAgICAgICAgICAgICAgfCAgIDEgKw0KPiA+ICBkcml2ZXJz
L25ldC9waHkvcGNzLWx5bnguYyAgICAgICAgICAgICAgIHwgMzE0ICsrKysrKysrKysrKysrKysr
KysNCj4gDQo+IEkgYmVsaWV2ZSBBbmRyZXcgaGFkIGEgcGxhbiB0byBjcmVhdGUgYSBiZXR0ZXIg
b3JnYW5pemF0aW9uIHdpdGhpbg0KPiBkcml2ZXJzL25ldC9waHksIHdoaWxlIHRoaXMgaGFwcGVu
cywgbWF5YmUgeW91IGNhbiBhbHJlYWR5IGNyZWF0ZQ0KPiBkcml2ZXJzL25ldC9waHkvcGNzLyBy
ZWdhcmRsZXNzIG9mIHRoZSBzdGF0ZSBvZiBBbmRyZXcncyB3b3JrPw0KPiANCg0KSSBnb3QgdGhl
IGltcHJlc3Npb24gZnJvbSBBbmRyZXcgdGhhdCB0aGUgcGxhbiB3YXMgdG8gZG8gdGhpcyBhdCBh
IGxhdGVyIHN0YWdlDQp0b2dldGhlciB3aXRoIHRoZSBTeW5vcHN5cyBYUENTLiBJIGNvdWxkIGNl
cnRhaW5seSBkbyB3aGF0IHlvdSBzYXksIEkgYW0ganVzdA0Kbm90IHZlcnkga2VlbiB0byBhZGQg
c3VjaCB0aGluZ3MgaW50byB0aGlzIHBhdGNoIHNldC4gDQoNCklvYW5hDQoNCj4gPiAgZHJpdmVy
cy9uZXQvcGh5L3BoeWxpbmsuYyAgICAgICAgICAgICAgICB8ICA0NCArKysNCj4gPiAgaW5jbHVk
ZS9saW51eC9tZGlvLmggICAgICAgICAgICAgICAgICAgICB8ICAgNiArDQo+ID4gIGluY2x1ZGUv
bGludXgvcGNzLWx5bnguaCAgICAgICAgICAgICAgICAgfCAgMjEgKysNCj4gDQo+IEFuZCBsaWtl
d2lzZSBmb3IgdGhpcyBoZWFkZXIuDQo+IC0tDQo+IEZsb3JpYW4NCg==

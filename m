Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C1D22E437
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 05:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgG0DIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 23:08:20 -0400
Received: from mail-eopbgr20046.outbound.protection.outlook.com ([40.107.2.46]:5718
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbgG0DIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 23:08:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6llj5HUvzZftqBM1nexRbdcwDGS+e7QgjS0HoU3u1j2WfZRdlVr4jywo62Pk99zM03Eca9vdS0DVEnA/lnhvVDO6R6VTQJ2cKV2iMdSwx6imujuFcmP32l3R2N7+llWdBvoUKO6qHFcvqzNgF47mSH+d+4QvTxlnGIhjYZOxk/+H5DjdnnXdX1GKr6kkOUj2/eo7jaqDeg7M+p4NtLXRLQ6UdGhc2JQ2ITeymjlAYHbjNzShOzyK7AGWJUe2bQfF73LB7kaJ9UgbFyrohkmCRLg9Br1ifkVkvDGzBRhpNTiZ6Rb7J2xZKan9txwZhlqNkYkHgfvv2U8fpotQLI6Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXRVjSZvBzMVJiNNjQ4dgPFh9MMizQ25Ayx2njslMfQ=;
 b=dvhzbW6tcLREPjK6+d7uk96vqx0P+qOXqSyR5kaYuxbux2U6/7QZPgaUSXXaeM/6U1wXx+f/Llx+2oI/lCA4KT/R0URlgXgYnhS0D2kKj5OwEBlH1GUeyGjeoKkIpOMHu97TIFUOOflPYP2cx7Yvrh5nyy8GGN02IiUju8SBdWNBEwpc/WlEDehczAyyWS4Zm/iMQQ2Xzp/dhbbEjnirXgVSQLnnky2v2DRj0p1dwgrCEQG+Hlu1gJSQ2vP9DVrIOlP0UgXmCe7cXUTwaKKA8SCv2J1yZ/JIj1GwCJAOY/5zxMEq/0jaLBYv39s9VBQM3Do57G/uRCQ521VrnlhxgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXRVjSZvBzMVJiNNjQ4dgPFh9MMizQ25Ayx2njslMfQ=;
 b=BFfx4KMxNWAGn+1xd37XJ7+k8VT4u636tdnOM/GfCQyl3hV5SMdmebGHPN0DZMQsR2oUD/ABox6uJm6Umn/qeW/MAfukFVqaL+uOX4wnBzt3ffRfgX9t+C6MFoQQzSfGJ0S16gPDSr2gJ3VYyVeM92owSE0C1+HQCB9zwQIbUyE=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM5PR04MB3298.eurprd04.prod.outlook.com
 (2603:10a6:206:f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Mon, 27 Jul
 2020 03:08:15 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f%5]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 03:08:15 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Chris Healy <cphealy@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>
Subject: RE: [EXT] Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert
 "net: ethernet: fec: Replace interrupt driven MDIO with polled IO"
Thread-Topic: [EXT] Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec:
 Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO"
Thread-Index: AQHWHJ35TIhHNJvOOU6ZoGvu1J9lW6kbL/IAgAAL6YCAAAI9AIAABTUAgAAAwICAAAE2gIAABe6AgAABaKA=
Date:   Mon, 27 Jul 2020 03:08:15 +0000
Message-ID: <AM6PR0402MB36075CE615B74A3B299D53FDFF720@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
 <20200727012354.GT28704@pendragon.ideasonboard.com>
 <20200727020631.GW28704@pendragon.ideasonboard.com>
 <20200727021432.GM1661457@lunn.ch>
 <20200727023310.GA23988@pendragon.ideasonboard.com>
 <CAFXsbZrf11Nj4rzLJfisPr-fFo-+stt-G3-XQ_Mwus_2z0nsAg@mail.gmail.com>
 <CAFXsbZrysb6SGisEhgXHzj8NZ5o_EjY-rtiqg3gypgr0w-d-dw@mail.gmail.com>
 <CAFXsbZpBP_kzsC_dLYezJWo7+dQufoRmaFpJgKJbnn6T=sc5QA@mail.gmail.com>
In-Reply-To: <CAFXsbZpBP_kzsC_dLYezJWo7+dQufoRmaFpJgKJbnn6T=sc5QA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aad9b6a7-be11-4d4b-8d90-08d831da4de7
x-ms-traffictypediagnostic: AM5PR04MB3298:
x-microsoft-antispam-prvs: <AM5PR04MB3298398A95336E626D276021FF720@AM5PR04MB3298.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uIZ4LuqfbWXpCoyL3itHiILhXdYAgxUQ8BXTfkw6owdYykj6ec1/f+0oMcTaB+YPKVP0pGc0YeApO0USN4qRxm5vRSQ9JzRB35Xqbyv9GN6mUkVG8cWbBFW/o5W6Is/TUyiTcAjm97/5/XQ29mcKGstiwsxf9t5eQjLf7e2MnV+v19eEsLrbHoyNwgZAYKipnWqO2418kjRhMwubh4IAjYLivGIa/MMMy+qQrk7jaSSbu9Cv1L/ENlZtw/XXXkCZnWQCK4GMZC7zRouldDg/U/DxVjXYvXAqK0LaM3cptP4zupvaekkV6Ulqpo65fYQ7fYMOceD3JZESkj/zjfgImAaL89T3mUDrhJdLhcgiLU2rfeR7auJG5VmDzGANmQak
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(52536014)(76116006)(478600001)(66946007)(110136005)(54906003)(86362001)(316002)(5660300002)(26005)(9686003)(186003)(8676002)(2906002)(55016002)(33656002)(83380400001)(66476007)(64756008)(66556008)(53546011)(6506007)(66446008)(4326008)(71200400001)(8936002)(7696005)(101420200001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 5pMc/tziKR/QkSs11QOX4sPwQa49J/QRSExMQMqpRiPhorpDHoykbGY20j8ufOiVaD168Xgy4hiGplGClvjWG5Ao8k8u2Q3Wxgn5Fqj/d7w9UeITPzpYVzNH/m09QGMiDo41dV7Xr6t1Y0JSg1rOx/HpvOTBGxUypTCT2NTeK7PYKWc6mhdX/cfn2DkLDGePjIVrLWTqnxI9uG9nibclBiK5JKjTbw3b10aRpboTR2DiENnGi8rN6PzzoNAd6vVhkEM/BZvdX3gkE3oUZbOpMsdq/sALU/vS0C422yVnFLk2evR19wrZ4kbk/JllhFNQU+Sf/R+4GZsUk6vu8RV3FSJg2GG76RHYDSW7EHFRqRxMsshRLr2Zataw/bmjliyTD53X+cUKUq6Dx37yJOq3AWRweP6L4z2Cne9/cOoa8lsmjc4XOFmJQvVfJW3cDnwE6bTrhkiv+TYGIQuKl1t1CrF0QXj7W85FXXqLtfbMcFU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad9b6a7-be11-4d4b-8d90-08d831da4de7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 03:08:15.0578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 16Edr5JPzfvugJ5pWFPNjdBZsSUXOmP4qZNqDfmo7k5iORVSdR966aiHS8WQHS9uf1UWBOpc8EfHXGTTntSTNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3298
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXMgSGVhbHkgPGNwaGVhbHlAZ21haWwuY29tPiBTZW50OiBNb25kYXksIEp1bHkg
MjcsIDIwMjAgMTE6MDEgQU0NCj4gSXQgYXBwZWFycyBxdWl0ZSBhIGZldyBib2FyZHMgd2VyZSBh
ZmZlY3RlZCBieSB0aGlzIG1pY3JlbCBQSFkgZHJpdmVyIGNoYW5nZToNCj4gDQo+IDJjY2IwMTYx
YTBlOWViMDZmNTM4NTU3ZDM4OTg3ZTQzNmZjMzliOGQNCj4gODBiZjcyNTk4NjYzNDk2ZDA4YjNj
MDIzMTM3N2RiNmE5OWQ3ZmQ2OA0KPiAyZGUwMDQ1MGMwMTI2ZWM4ODM4ZjcyMTU3NTc3NTc4ZTg1
Y2FlNWQ4DQo+IDgyMGY4YTg3MGY2NTc1YWNkYTFiZjdmMWEwM2M3MDFjNDNlZDVkNzkNCj4gDQo+
IEkganVzdCB1cGRhdGVkIHRoZSBwaHktbW9kZSB3aXRoIG15IGJvYXJkIGZyb20gcmdtaWkgdG8g
cmdtaWktaWQgYW5kDQo+IGV2ZXJ5dGhpbmcgc3RhcnRlZCB3b3JraW5nIGZpbmUgd2l0aCBuZXQt
bmV4dCBhZ2FpbjoNCj4gDQo+IGV0aDAgICAgICBMaW5rIGVuY2FwOkV0aGVybmV0ICBIV2FkZHIg
RTY6ODU6NDg6OEY6OTM6NjQNCj4gICAgICAgICAgIGluZXQgYWRkcjoxNzIuMTYuMS4xICBCY2Fz
dDoxNzIuMTYuMjU1LjI1NSAgTWFzazoyNTUuMjU1LjAuMA0KPiAgICAgICAgICAgVVAgQlJPQURD
QVNUIFJVTk5JTkcgTVVMVElDQVNUICBNVFU6MTUwMCAgTWV0cmljOjENCj4gICAgICAgICAgIFJY
IHBhY2tldHM6NDY0MzY5MCBlcnJvcnM6MCBkcm9wcGVkOjAgb3ZlcnJ1bnM6MCBmcmFtZTowDQo+
ICAgICAgICAgICBUWCBwYWNrZXRzOjc2MTc4IGVycm9yczowIGRyb3BwZWQ6MCBvdmVycnVuczow
IGNhcnJpZXI6MA0KPiAgICAgICAgICAgY29sbGlzaW9uczowIHR4cXVldWVsZW46MTAwMA0KPiAg
ICAgICAgICAgUlggYnl0ZXM6Mjc2Mjg0NTUwMiAoMi41IEdpQikgIFRYIGJ5dGVzOjUwMjYzNzYg
KDQuNyBNaUIpDQo+IA0KPiANCg0KSXQgaXMgcmVhc29uYWJsZSB0byBjaGFuZ2UgcGh5LW1vZGUg
dG8gInJnbWlpLWlkIiB0byBsZXQgUEhZIHN1cHBseQ0KVHgvcnggc2tldyBzaW5jZSBNQUMgZG9l
c24ndCBzdXBwb3J0IGRlbGF5Lg0KDQoNClJlZ2FyZHMsDQpGdWdhbmcNCj4gDQo+IE9uIFN1biwg
SnVsIDI2LCAyMDIwIGF0IDc6NDAgUE0gQ2hyaXMgSGVhbHkgPGNwaGVhbHlAZ21haWwuY29tPiB3
cm90ZToNCj4gPg0KPiA+IEFjdHVhbGx5LCBJIHdhcyBhIGxpdHRsZSBxdWljayB0byBzYXkgaXQg
d2VudCBmcm9tIGJyb2tlbiB0byB3b3JraW5nLg0KPiA+DQo+ID4gV2l0aCBuZXQtbmV4dCwgSSdt
IGdldHRpbmcgQ1JDIGVycm9ycyBvbiAxMDAlIG9mIGluYm91bmQgcGFja2V0cy4NCj4gPiBXaXRo
IGJjZjM0NDBjNmRkNzhiZmU1ODM2ZWMwOTkwZmUzNmQ3YjRiYjdkMjAgcmV2ZXJ0ZWQsIEkgZHJv
cCBkb3duIHRvDQo+ID4gYSAxJSBlcnJvciByYXRlLg0KPiA+DQo+ID4gVGhpcyB2ZXJ5IG11Y2gg
ZmVlbHMgbGlrZSBhIEtTWjkwMzEgUkdNSUkgdGltaW5nIGlzc3VlIHRvIG1lLi4uDQo+ID4NCj4g
PiBPbiBTdW4sIEp1bCAyNiwgMjAyMCBhdCA3OjM1IFBNIENocmlzIEhlYWx5IDxjcGhlYWx5QGdt
YWlsLmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+ID4gSGkgTGF1cmVudCwNCj4gPiA+DQo+ID4gPiBJ
IGhhdmUgdGhlIGV4YWN0IHNhbWUgY29wcGVyIFBIWS4gIEkganVzdCByZXZlcnRlZCBhIHBhdGNo
IHNwZWNpZmljDQo+ID4gPiB0byB0aGlzIFBIWSBhbmQgd2VudCBmcm9tIGJyb2tlbiB0byB3b3Jr
aW5nLiAgR2l2ZSB0aGlzIGEgdHJ5Og0KPiA+ID4NCj4gPiA+IGdpdCByZXZlcnQgYmNmMzQ0MGM2
ZGQ3OGJmZTU4MzZlYzA5OTBmZTM2ZDdiNGJiN2QyMA0KPiA+ID4NCj4gPiA+IFJlZ2FyZHMsDQo+
ID4gPg0KPiA+ID4gQ2hyaXMNCj4gPiA+DQo+ID4gPiBPbiBTdW4sIEp1bCAyNiwgMjAyMCBhdCA3
OjMzIFBNIExhdXJlbnQgUGluY2hhcnQNCj4gPiA+IDxsYXVyZW50LnBpbmNoYXJ0QGlkZWFzb25i
b2FyZC5jb20+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBIaSBBbmRyZXcsDQo+ID4gPiA+DQo+
ID4gPiA+IE9uIE1vbiwgSnVsIDI3LCAyMDIwIGF0IDA0OjE0OjMyQU0gKzAyMDAsIEFuZHJldyBM
dW5uIHdyb3RlOg0KPiA+ID4gPiA+IE9uIE1vbiwgSnVsIDI3LCAyMDIwIGF0IDA1OjA2OjMxQU0g
KzAzMDAsIExhdXJlbnQgUGluY2hhcnQgd3JvdGU6DQo+ID4gPiA+ID4gPiBPbiBNb24sIEp1bCAy
NywgMjAyMCBhdCAwNDoyNDowMkFNICswMzAwLCBMYXVyZW50IFBpbmNoYXJ0IHdyb3RlOg0KPiA+
ID4gPiA+ID4gPiBPbiBNb24sIEFwciAyNywgMjAyMCBhdCAxMDowODowNFBNICswODAwLCBGdWdh
bmcgRHVhbiB3cm90ZToNCj4gPiA+ID4gPiA+ID4gPiBUaGlzIHJldmVydHMgY29tbWl0DQo+IDI5
YWU2YmQxYjBkOGE1N2Q3YzAwYWIxMmNiYjk0OWZjNDE5ODZlZWYuDQo+ID4gPiA+ID4gPiA+ID4N
Cj4gPiA+ID4gPiA+ID4gPiBUaGUgY29tbWl0IGJyZWFrcyBldGhlcm5ldCBmdW5jdGlvbiBvbiBp
Lk1YNlNYLCBpLk1YN0QsDQo+ID4gPiA+ID4gPiA+ID4gaS5NWDhNTSwgaS5NWDhNUSwgYW5kIGku
TVg4UVhQIHBsYXRmb3Jtcy4gQm9vdCB5b2N0bw0KPiA+ID4gPiA+ID4gPiA+IHN5c3RlbSBieSBO
RlMgbW91bnRpbmcgcm9vdGZzIHdpbGwgYmUgZmFpbGVkIHdpdGggdGhlIGNvbW1pdC4NCj4gPiA+
ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gSSdtIGFmcmFpZCB0aGlzIGNvbW1pdCBicmVha3MgbmV0
d29ya2luZyBvbiBpLk1YN0QgZm9yIG1lDQo+ID4gPiA+ID4gPiA+IDotKCBNeSBib2FyZCBpcyBj
b25maWd1cmVkIHRvIGJvb3Qgb3ZlciBORlMgcm9vdCB3aXRoIElQDQo+ID4gPiA+ID4gPiA+IGF1
dG9jb25maWd1cmF0aW9uIHRocm91Z2ggREhDUC4gVGhlIERIQ1AgcmVxdWVzdCBnb2VzIG91dCwN
Cj4gPiA+ID4gPiA+ID4gdGhlIHJlcGx5IGl0IHNlbnQgYmFjayBieSB0aGUgc2VydmVyLCBidXQg
bmV2ZXIgbm90aWNlZCBieSB0aGUgZmVjDQo+IGRyaXZlci4NCj4gPiA+ID4gPiA+ID4NCj4gPiA+
ID4gPiA+ID4gdjUuNyB3b3JrcyBmaW5lLiBBcyAyOWFlNmJkMWIwZDhhNTdkN2MwMGFiMTJjYmI5
NDlmYzQxOTg2ZWVmDQo+ID4gPiA+ID4gPiA+IHdhcyBtZXJnZWQgZHVyaW5nIHRoZSB2NS44IG1l
cmdlIHdpbmRvdywgSSBzdXNwZWN0IHNvbWV0aGluZw0KPiA+ID4gPiA+ID4gPiBlbHNlIGNyb3Bw
ZWQgaW4gYmV0d2Vlbg0KPiA+ID4gPiA+ID4gPiAyOWFlNmJkMWIwZDhhNTdkN2MwMGFiMTJjYmI5
NDlmYzQxOTg2ZWVmIGFuZCB0aGlzIHBhdGNoIHRoYXQNCj4gPiA+ID4gPiA+ID4gbmVlZHMgdG8g
YmUgcmV2ZXJ0ZWQgdG9vLiBXZSdyZSBjbG9zZSB0byB2NS44IGFuZCBpdCB3b3VsZA0KPiA+ID4g
PiA+ID4gPiBiZSBhbm5veWluZyB0byBzZWUgdGhpcyByZWdyZXNzaW9uIGVuZGluZyB1cCBpbiB0
aGUgcmVsZWFzZWQNCj4gPiA+ID4gPiA+ID4ga2VybmVsLiBJIGNhbiB0ZXN0IHBhdGNoZXMsIGJ1
dCBJJ20gbm90IGZhbWlsaWFyIGVub3VnaCB3aXRoDQo+ID4gPiA+ID4gPiA+IHRoZSBkcml2ZXIg
KG9yIHRoZSBuZXR3b3JraW5nDQo+ID4gPiA+ID4gPiA+IHN1YnN5c3RlbSkgdG8gZml4IHRoZSBp
c3N1ZSBteXNlbGYuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gSWYgaXQgY2FuIGJlIG9mIGFu
eSBoZWxwLCBJJ3ZlIGNvbmZpcm1lZCB0aGF0LCB0byBnZXQgdGhlDQo+ID4gPiA+ID4gPiBuZXR3
b3JrIGJhY2sgdG8gdXNhYmxlIHN0YXRlIGZyb20gdjUuOC1yYzYsIEkgaGF2ZSB0byByZXZlcnQN
Cj4gPiA+ID4gPiA+IGFsbCBwYXRjaGVzIHVwIHRvIHRoaXMgb25lLiBUaGlzIGlzIHRoZSB0b3Ag
b2YgbXkgYnJhbmNoLCBvbiB0b3Agb2YNCj4gdjUuOC1yYzY6DQo+ID4gPiA+ID4gPg0KPiA+ID4g
PiA+ID4gNWJiZTgwYzllZmVhIFJldmVydCAibmV0OiBldGhlcm5ldDogZmVjOiBSZXZlcnQgIm5l
dDogZXRoZXJuZXQ6IGZlYzoNCj4gUmVwbGFjZSBpbnRlcnJ1cHQgZHJpdmVuIE1ESU8gd2l0aCBw
b2xsZWQgSU8iIg0KPiA+ID4gPiA+ID4gNTQ2Mjg5NmEwOGMxIFJldmVydCAibmV0OiBldGhlcm5l
dDogZmVjOiBSZXBsYWNlIGludGVycnVwdCBkcml2ZW4NCj4gTURJTyB3aXRoIHBvbGxlZCBJTyIN
Cj4gPiA+ID4gPiA+IDgyNGE4MmUyYmRmYSBSZXZlcnQgIm5ldDogZXRoZXJuZXQ6IGZlYzogbW92
ZSBHUFIgcmVnaXN0ZXIgb2Zmc2V0DQo+IGFuZCBiaXQgaW50byBEVCINCj4gPiA+ID4gPiA+IGJm
ZTMzMDU5MWNhYiBSZXZlcnQgIm5ldDogZmVjOiBkaXNhYmxlIGNvcnJlY3QgY2xrIGluIHRoZSBl
cnIgcGF0aCBvZg0KPiBmZWNfZW5ldF9jbGtfZW5hYmxlIg0KPiA+ID4gPiA+ID4gMTA5OTU4Y2Fk
NTc4IFJldmVydCAibmV0OiBldGhlcm5ldDogZmVjOiBwcmV2ZW50IHR4IHN0YXJ2YXRpb24gdW5k
ZXINCj4gaGlnaCByeCBsb2FkIg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gT0suDQo+ID4gPiA+ID4N
Cj4gPiA+ID4gPiBXaGF0IFBIWSBhcmUgeW91IHVzaW5nPyBBIE1pY3JlbD8NCj4gPiA+ID4NCj4g
PiA+ID4gS1NaOTAzMVJOWElBDQo+ID4gPiA+DQo+ID4gPiA+ID4gQW5kIHdoaWNoIERUIGZpbGU/
DQo+ID4gPiA+DQo+ID4gPiA+IEl0J3Mgb3V0IG9mIHRyZWUuDQo+ID4gPiA+DQo+ID4gPiA+ICZm
ZWMxIHsNCj4gPiA+ID4gICAgICAgICBwaW5jdHJsLW5hbWVzID0gImRlZmF1bHQiOw0KPiA+ID4g
PiAgICAgICAgIHBpbmN0cmwtMCA9IDwmcGluY3RybF9lbmV0MT47DQo+ID4gPiA+ICAgICAgICAg
YXNzaWduZWQtY2xvY2tzID0gPCZjbGtzIElNWDdEX0VORVQxX1RJTUVfUk9PVF9TUkM+LA0KPiA+
ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgIDwmY2xrcw0KPiBJTVg3RF9FTkVUMV9USU1F
X1JPT1RfQ0xLPjsNCj4gPiA+ID4gICAgICAgICBhc3NpZ25lZC1jbG9jay1wYXJlbnRzID0gPCZj
bGtzDQo+IElNWDdEX1BMTF9FTkVUX01BSU5fMTAwTV9DTEs+Ow0KPiA+ID4gPiAgICAgICAgIGFz
c2lnbmVkLWNsb2NrLXJhdGVzID0gPDA+LCA8MTAwMDAwMDAwPjsNCj4gPiA+ID4gICAgICAgICBw
aHktbW9kZSA9ICJyZ21paSI7DQo+ID4gPiA+ICAgICAgICAgcGh5LWhhbmRsZSA9IDwmZXRocGh5
MD47DQo+ID4gPiA+ICAgICAgICAgcGh5LXJlc2V0LWdwaW9zID0gPCZncGlvMSAxMyBHUElPX0FD
VElWRV9MT1c+Ow0KPiA+ID4gPiAgICAgICAgIHBoeS1zdXBwbHkgPSA8JnJlZ18zdjNfc3c+Ow0K
PiA+ID4gPiAgICAgICAgIGZzbCxtYWdpYy1wYWNrZXQ7DQo+ID4gPiA+ICAgICAgICAgc3RhdHVz
ID0gIm9rYXkiOw0KPiA+ID4gPg0KPiA+ID4gPiAgICAgICAgIG1kaW8gew0KPiA+ID4gPiAgICAg
ICAgICAgICAgICAgI2FkZHJlc3MtY2VsbHMgPSA8MT47DQo+ID4gPiA+ICAgICAgICAgICAgICAg
ICAjc2l6ZS1jZWxscyA9IDwwPjsNCj4gPiA+ID4NCj4gPiA+ID4gICAgICAgICAgICAgICAgIGV0
aHBoeTA6IGV0aGVybmV0LXBoeUAwIHsNCj4gPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
cmVnID0gPDE+Ow0KPiA+ID4gPiAgICAgICAgICAgICAgICAgfTsNCj4gPiA+ID4NCj4gPiA+ID4g
ICAgICAgICAgICAgICAgIGV0aHBoeTE6IGV0aGVybmV0LXBoeUAxIHsNCj4gPiA+ID4gICAgICAg
ICAgICAgICAgICAgICAgICAgcmVnID0gPDI+Ow0KPiA+ID4gPiAgICAgICAgICAgICAgICAgfTsN
Cj4gPiA+ID4gICAgICAgICB9Ow0KPiA+ID4gPiB9Ow0KPiA+ID4gPg0KPiA+ID4gPiBJIGNhbiBw
cm92aWRlIHRoZSBmdWxsIERUIGlmIG5lZWRlZC4NCj4gPiA+ID4NCj4gPiA+ID4gLS0NCj4gPiA+
ID4gUmVnYXJkcywNCj4gPiA+ID4NCj4gPiA+ID4gTGF1cmVudCBQaW5jaGFydA0K

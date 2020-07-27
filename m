Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33E422E88F
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgG0JNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:13:43 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:52124 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgG0JNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595841222; x=1627377222;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RBIcVvvHOhACoec6nqnlljs4W+nZY/fsnZJ9+QPbptU=;
  b=cHAyiXuIwuUJwfAK2X4aCl8hBm3lGyXxNgenItZ71md9w0ccb2D3Qa4S
   NT21xte29AiBorlE1kIH8RoYbu3Qj0Ez3l4fITAOTuW+TUgAznRPDTiQz
   GW81KIMWueiJOjkptOMcRXeF3vU/qiBkZcXLjuU0QbXudsZkOUAysyJGC
   oLZN1tx/ISvug3n9kFEjvchMwkuje2eSxMmPOQHLaWtjI7AVe7sZgPpXk
   5wiF9R/3rk6ciUcTCtLwqZI1sBf8i+0f1w5sRzsJVzvLY4w64ycuXrxzZ
   v/H+Fi3o1x2KrnPj0/8/ZI61xLevkMNqDG3ojA7dV3jzmnV1rkFVyYgtk
   A==;
IronPort-SDR: ZAf7rJE2m7uNpqNldFqu6OYYh2aLf6yDiFFWiyLWbUn02z8bVjBU2cahCJ7KhEWSPvSm6AwxBm
 w4m7j+T0p6m2TausbgTk48sTzPrMy7ozFEsyav8H8l839fTjoG78hsNgzpSxPFAGvCD00kE59b
 fN51UxQ5QiXBtLNKuARCN/PccorRskiZbnuISEhIeXYCcrK/PraYlLA/QDFzImeobwgB1l9cTk
 /sSUICS2kdjOCeGelz6Xek6B0d6nkT7gdFDFldww84VvrPRvwiq0KhULWcTUFicMcq4/F4vPmC
 Kro=
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="85480400"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jul 2020 02:13:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 02:12:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 27 Jul 2020 02:13:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=blzVs51Gb+kPaGrRA+vjRoyYkFPNYYVYgGyFX2hMeXk9adjU4vyvNE7AkjK1SmjwMp0gNkr5P/snLb5i4mfpXK0K2jLZ2+MigvLJes1uisvSt68gP3SZX91Suxek2m/0BBtKWaowK1q7O/Eg3SslRRYxUkCzL7Z++dGyFhMS8dRayAdc9FhqrYk1h/TML6w1T2edzmD7WeKtKcqtxhu6QiEeAGkcylwRXRynuejbS+DCL9EC9hnx0a14D1lVZvzYdg6LjeQ+cFmxWzq8V/+v8/hW8INmc6d8+V0YDsCNkhzkTPQojAO7wK+EGh8QqeY9/5ZunW71sFz+NiYxoo4wIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBIcVvvHOhACoec6nqnlljs4W+nZY/fsnZJ9+QPbptU=;
 b=HhF0UW/dmSepfWje5xzgXjo5pHmZeyhlzyQAMKoqkLJl04ubube1ZaC8ZFamYLrGIfnHyF6eOp8FLchHgGB+SH99WytAlUv5JZ3CyylsNUdWk3OGbX5iXMJUtePYsbyc9azHMyhPk0ocXwFWbjO6l2PopQlBO8MUZfQjIqPaWzXStf+0M3+V6m3HGf/D4L5BqGR2pIGK+cgNjnMPsgsbAWEI8II2LFXi7U9wd6X5O24qVc1ew9fWpJy/pWfWaosb4BzMzkiNZ+JxwNkTf3FMihRUlkCrdhOyWsd9Ro7RNzEEBxGFw8E3RQYZDwjIIh4W3uFvMEmomGVW8bsmw0vO5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBIcVvvHOhACoec6nqnlljs4W+nZY/fsnZJ9+QPbptU=;
 b=ipNmroRPYhwFeCx/DbIrCmPB48Jn8SbY7sk0c/Q+X5/AJxlBKoAX87Ale9Q4Cz5fHe+Fc37Y7AlrZeRnxepN5328vIf/TLu0KMSMovq9W4KUIjW7wwXQwVvf1KfYY4i6A5gRqolxLDZzx2dwZ/wCEHD06E1lYfVbbLBlkae0h/A=
Received: from SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17)
 by SN6PR11MB2911.namprd11.prod.outlook.com (2603:10b6:805:d2::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Mon, 27 Jul
 2020 09:13:38 +0000
Received: from SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0]) by SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 09:13:38 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <Claudiu.Beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <robh+dt@kernel.org>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH net-next v3 3/7] net: macb: parse PHY nodes found under an
 MDIO node
Thread-Topic: [PATCH net-next v3 3/7] net: macb: parse PHY nodes found under
 an MDIO node
Thread-Index: AQHWYahS/VghvsgOykq39sOvGT3GJ6kW/9UAgAQpRYA=
Date:   Mon, 27 Jul 2020 09:13:38 +0000
Message-ID: <89383e2e-5232-b983-ec67-565ff49821d9@microchip.com>
References: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
 <20200724105033.2124881-4-codrin.ciubotariu@microchip.com>
 <426a15dd-62de-9ffb-baed-c527b9aa9b70@gmail.com>
In-Reply-To: <426a15dd-62de-9ffb-baed-c527b9aa9b70@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [84.232.220.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce414a61-8b78-4ec8-6215-08d8320d5952
x-ms-traffictypediagnostic: SN6PR11MB2911:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB29119136637B6C03DBF038F8E7720@SN6PR11MB2911.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xQfNScNIyTgKjykaLHGljd4C4JJRKyr+PV8J/VVRMN9gDEOg1CJRWhdv2k04rALiIHRx/HF39pimDAHTHwf1lOTKyt0s1FofTZIhIkqMwjSXKLIIlX5DJFXLy2pBzv9SfGEs2huUXRygmiUHk1er9EIASoxHaZhiCJd7piQaSRpiD2BRqdqD+zFCHhmvIaPujuwjwud2qLI3pCUfNZ2eHJbZmgmWw75sr3s168xaw5n/1WMvpgTkv8mCdOlTAFVsGjxVNBnLvk7Uxes2H2MdBL9jfA6cIhj+0zrzhiCehii6nqW79IenrDxl9SoBtcojP+oMVkXaC1Y4BMZfEmDc/HLPRQFosGhV3V2JtmFBDm0O6IMURJHIxUASkIwTJ3bm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3504.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(136003)(366004)(376002)(346002)(6486002)(53546011)(6506007)(36756003)(86362001)(110136005)(2616005)(316002)(4326008)(54906003)(31686004)(71200400001)(5660300002)(76116006)(66946007)(2906002)(107886003)(66476007)(66556008)(64756008)(7416002)(91956017)(66446008)(6512007)(478600001)(186003)(8676002)(26005)(8936002)(31696002)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: PXnplecwurIU4kiFwjwXW6UCwbfm9PyiLMj+djg0jVhie+al/ZaoGuJ6Rzks1aXir2UxVSOVOklvte1x+wUw5nSDudp1fPnyE6yF3WfTS8DBsXt1YjNFrCG/n2QKCwKxzMs4TQWh6ugg5zr3NZpss9wLLgnuBwNGfcu09Uj5Rhh/Gp7RHVOrms6e3e+qDJLCPyHX5ElzJkhSo7NP/W5A0xlB1MMsjyCi/Y7whZtC5KQwHcdZfAm5zAfH5tuJ5NfhCOp/O1ecqaQgX/T9Gdx2Ldi02oKeGxF1Hoxhx6EUmFsiP/AhhCVzPrSoRy5FHb/bm31AGCR1RlQpxA36pUdb0unFQikS3rO3OOW4Tetf9+fac2Wzv4nM4GolNUs//GP5ZQ+Y0r1b1slh1foE21kAjIVtZoL7Qn0rcpUi9uZ3kdVzc9LLanei/o1G4tZOZ0pHwvGwHlMh8HNF8HNDK/7aXdgPNzuCafxhjGUYrqvYoia0KB/21lRP0iKJAiz0zYK7
Content-Type: text/plain; charset="utf-8"
Content-ID: <871E5D73095B2644A43D8FA49E208E08@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3504.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce414a61-8b78-4ec8-6215-08d8320d5952
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 09:13:38.5911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F5WbU2RNLWOwGmhXBoFE+MPvILdU2z9mWYlOYgJx02a3QqF0q4dwsNMgejcWidywlkDf7MJoX6uJnt/3mmVNYqzE2a4kO2k8vAGvF8jyxB0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2911
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjQuMDcuMjAyMCAyMDo0MCwgRmxvcmlhbiBGYWluZWxsaSB3cm90ZToNCj4gRVhURVJOQUwg
RU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Ug
a25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiA3LzI0LzIwIDM6NTAgQU0sIENvZHJp
biBDaXVib3Rhcml1IHdyb3RlOg0KPj4gVGhlIE1BQ0IgZW1iZWRzIGFuIE1ESU8gYnVzIGNvbnRy
b2xsZXIuIEZvciB0aGlzIHJlYXNvbiwgdGhlIFBIWSBub2Rlcw0KPj4gd2VyZSByZXByZXNlbnRl
ZCBhcyBzdWItbm9kZXMgaW4gdGhlIE1BQ0Igbm9kZS4gR2VuZXJhbGx5LCB0aGUNCj4+IEV0aGVy
bmV0IGNvbnRyb2xsZXIgaXMgZGlmZmVyZW50IHRoYW4gdGhlIE1ESU8gY29udHJvbGxlciwgc28g
dGhlIFBIWXMNCj4+IGFyZSBwcm9iZWQgYnkgYSBzZXBhcmF0ZSBNRElPIGRyaXZlci4gU2luY2Ug
YWRkaW5nIHRoZSBQSFkgbm9kZXMgZGlyZWN0bHkNCj4+IHVuZGVyIHRoZSBFVEggbm9kZSBiZWNh
bWUgZGVwcmVjYXRlZCwgd2UgYWRqdXN0IHRoZSBNQUNCIGRyaXZlciB0byBsb29rDQo+PiBmb3Ig
YW4gTURJTyBub2RlIGFuZCByZWdpc3RlciB0aGUgc3Vibm9kZSBNRElPIGRldmljZXMuDQo+Pg0K
Pj4gU2lnbmVkLW9mZi1ieTogQ29kcmluIENpdWJvdGFyaXUgPGNvZHJpbi5jaXVib3Rhcml1QG1p
Y3JvY2hpcC5jb20+DQo+PiAtLS0NCj4+DQo+PiBDaGFuZ2VzIGluIHYzOg0KPj4gICAtIG1vdmVk
IHRoZSBjaGVjayBmb3IgdGhlIG1kaW8gbm9kZSBhdCB0aGUgYmVnaW5uZ2luZyBvZg0KPj4gICAg
IG1hY2JfbWRpb2J1c19yZWdpc3RlcigpLiBUaGlzIHdheSwgdGhlIG1kaW8gZGV2aWNlcyB3aWxs
IGJlIHByb2JlZCBldmVuDQo+PiAgICAgaWYgbWFjYiBpcyBhIGZpeGVkLWxpbmsNCj4+DQo+PiBD
aGFuZ2VzIGluIHYyOg0KPj4gICAtIHJlYWRkZWQgbmV3bGluZSByZW1vdmVkIGJ5IG1pc3Rha2U7
DQo+Pg0KPj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgMTAg
KysrKysrKysrKw0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPj4gaW5kZXggODlmZTdh
ZjVlNDA4Li5jYjBiMzYzNzY1MWMgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRl
bmNlL21hY2JfbWFpbi5jDQo+PiBAQCAtNzQwLDYgKzc0MCwxNiBAQCBzdGF0aWMgaW50IG1hY2Jf
bWlpX3Byb2JlKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+PiAgIHN0YXRpYyBpbnQgbWFjYl9t
ZGlvYnVzX3JlZ2lzdGVyKHN0cnVjdCBtYWNiICpicCkNCj4+ICAgew0KPj4gICAgICAgIHN0cnVj
dCBkZXZpY2Vfbm9kZSAqY2hpbGQsICpucCA9IGJwLT5wZGV2LT5kZXYub2Zfbm9kZTsNCj4+ICsg
ICAgIHN0cnVjdCBkZXZpY2Vfbm9kZSAqbWRpb19ub2RlOw0KPj4gKyAgICAgaW50IHJldDsNCj4+
ICsNCj4+ICsgICAgIC8qIGlmIGFuIE1ESU8gbm9kZSBpcyBwcmVzZW50LCBpdCBzaG91bGQgY29u
dGFpbiB0aGUgUEhZIG5vZGVzICovDQo+PiArICAgICBtZGlvX25vZGUgPSBvZl9nZXRfY2hpbGRf
YnlfbmFtZShucCwgIm1kaW8iKTsNCj4+ICsgICAgIGlmIChtZGlvX25vZGUpIHsNCj4+ICsgICAg
ICAgICAgICAgcmV0ID0gb2ZfbWRpb2J1c19yZWdpc3RlcihicC0+bWlpX2J1cywgbWRpb19ub2Rl
KTsNCj4+ICsgICAgICAgICAgICAgb2Zfbm9kZV9wdXQobWRpb19ub2RlKTsNCj4+ICsgICAgICAg
ICAgICAgcmV0dXJuIHJldDsNCj4+ICsgICAgIH0NCj4gDQo+IFRoaXMgZG9lcyB0YWtlIGNhcmUg
b2YgcmVnaXN0ZXJpbmcgdGhlIE1ESU8gYnVzIGNvbnRyb2xsZXIgd2hlbiBwcmVzZW50DQo+IGFz
IGEgc3ViLW5vZGUsIGhvd2V2ZXIgaWYgeW91IGFsc28gcGxhbiBvbiBtYWtpbmcgdXNlIG9mIGZp
eGVkLWxpbmssIHdlDQo+IHdpbGwgaGF2ZSBhbHJlYWR5IHJldHVybmVkLg0KPiANCj4+DQo+PiAg
ICAgICAgaWYgKG9mX3BoeV9pc19maXhlZF9saW5rKG5wKSkNCj4+ICAgICAgICAgICAgICAgIHJl
dHVybiBtZGlvYnVzX3JlZ2lzdGVyKGJwLT5taWlfYnVzKTsNCj4+DQo+IA0KPiBSZWFsbHkgbm90
IHN1cmUgd2hhdCB0aGlzIGlzIGFjaGlldmluZywgYmVjYXVzZSB3ZSBzdGFydCBvZmYgYXNzdW1p
bmcNCj4gdGhhdCB3ZSBoYXZlIGFuIE9GIGRyaXZlbiBjb25maWd1cmF0aW9uLCBidXQgbGF0ZXIg
b24gd2UgcmVnaXN0ZXIgdGhlDQo+IE1ESU8gYnVzIHdpdGggbWRpb2J1c19yZWdpc3RlcigpIChh
bmQgbm90IG9mX21kaW9idXNfcmVnaXN0ZXIoKSksIHNvIG5vDQo+IHNjYW5uaW5nIG9mIHRoZSBN
RElPIGJ1cyB3aWxsIGhhcHBlbi4NCg0KSSBhZ3JlZSB0aGF0IHJldHVybmluZyBtZGlvYnVzX3Jl
Z2lzdGVyKCkgaGVyZSBtYWtlcyBubyBzZW5zZSBzaW5jZSANCnRoZXJlIGFyZSBubyBvdGhlciBQ
SFkgZGV2aWNlcyB0byBzY2FuIGZvciBhbmQgcHJvYmUuIEkgY2FuIHJlcGxhY2UgdGhpcyANCndp
dGggTlVMTC4NClRoZSByZWFzb24gZm9yIGZpeGVkLWxpbmsgY2hlY2sgaGVyZSBpcyB0byBza2lw
IHRoZSBmb2xsb3dpbmcgbG9vcDoNCmZvcl9lYWNoX2F2YWlsYWJsZV9jaGlsZF9vZl9ub2RlKG5w
LCBjaGlsZCkNCgkJaWYgKG9mX21kaW9idXNfY2hpbGRfaXNfcGh5KGNoaWxkKSkgew0KCQkJb2Zf
bm9kZV9wdXQoY2hpbGQpOw0KCQkJcmV0dXJuIG9mX21kaW9idXNfcmVnaXN0ZXIoYnAtPm1paV9i
dXMsIG5wKTsNCgkJfQ0Kb2ZfbWRpb2J1c19jaGlsZF9pc19waHkoKSByZXR1cm5zIHRydWUgd2hl
biBpdCBmaW5kcyB0aGUgZml4ZWQtbGluayANCm5vZGUsIGJlY2F1c2UgaXQgaGFzIG5vIGNvbXBh
dGlibGUuDQoNCj4gDQo+IEhvdyBkb2VzIHRoZSBkcml2ZXIgY3VycmVudGx5IHN1cHBvcnQgYmVp
bmcgcHJvdmlkZWQgYSBmaXhlZC1saW5rDQo+IHByb3BlcnR5PyBTaG91bGQgbm90IHdlIGF0IGxl
YXN0IGhhdmUgdGhpcyBwYXR0ZXJuOg0KPiANCj4gICAgICAgICAgICovDQo+ICAgICAgICAgIGlm
IChvZl9waHlfaXNfZml4ZWRfbGluayhkbikpIHsNCj4gICAgICAgICAgICAgICAgICByZXQgPSBv
Zl9waHlfcmVnaXN0ZXJfZml4ZWRfbGluayhkbik7DQo+ICAgICAgICAgICAgICAgICAgaWYgKHJl
dCkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+IA0KPiAgICAgICAg
ICAgICAgICAgIHByaXYtPnBoeV9kbiA9IGRuOw0KPiAgICAgICAgICB9DQo+IA0KPiBJdCBkb2Vz
IG5vdCBsb29rIGxpa2UgeW91IGFyZSBicmVha2luZyBhbnl0aGluZyBoZXJlLCBiZWNhdXNlIGl0
IGRvZXMNCj4gbm90IGxvb2sgbGlrZSB0aGlzIHdvcmtzIGF0IGFsbC4NCg0KIEZyb20gd2hhdCBJ
IHVuZGVyc3RhbmQsIHRoZSBuZXcgcGh5bGluayhfY3JlYXRlKSBoYW5kbGVzIHRoZSBmaXhlZC1s
aW5rIA0KY2FzZSwgc28gdGhlcmUgaXMgbm90IHJlYXNvbiB0byBleHBsaWNpdGx5IHJlZ2lzdGVy
IHRoZSBmaXhlZC1saW5rLg0KDQpCZXN0IHJlZ2FyZHMsDQpDb2RyaW4NCg0KPiAtLQ0KPiBGbG9y
aWFuDQo+IA0KDQo=

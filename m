Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB709136F93
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgAJOfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:35:51 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:35812 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727581AbgAJOfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 09:35:50 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 947DDC0519;
        Fri, 10 Jan 2020 14:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578666949; bh=aKnriC17g38j33vCDUZ4tT0fICNWx7V/vrTCQYMgyM4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=lPM1RkFu68mGRntRtoawN7FqwbH5riaq+noEHzP+PAx9Wi0G51LrrOrk9R9KzVvD5
         G3QCTD8Iqy9RFutfhF0Fh33COsB2SLja2e/Ia52bSuH2X1+URVjifcMsx4InbAVz0M
         E76x8QDYrTqhea4y/AAHcri8uL7bkhJefuUOatFYASuEtJC5YNRo6lTdj9yYvTAU87
         TDmNnExWeLQBTC0Az3g7K/xwswb99ysORcV+TQZL70w6+0JGarPuwvdhSGkhKLe2br
         rJxusySLKoY0WCOPF9tqc1YCdDsQD4qtvDl8rA58IydTSDvyvs1Lo1Bm3VV8lUg3L/
         uxqBpK1f1PfqA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7422AA0083;
        Fri, 10 Jan 2020 14:35:43 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 10 Jan 2020 06:35:43 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 10 Jan 2020 06:35:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCcXD0BgZfuKE+0Qk5splpmrMmUpv9NoO/Gp+eXlmESf2wdxfV3R+5D17Vbg8daYIcbG1w+09a6blEQL5zlhzTbAuI4FaUDjHJdzZWoLWHkabb338T7JfhApHhKO/McDfI3CUZDA5u1Ge1BvSx4EoQ5a/orLhaJHrpdhj5jzBi5HWmhhJEU8CystF/6d7yV5ha1N8Akj8u0l9zwFKoUTBB8b3RcCzBDy4LpjzSJn183Qvyv9ETBOJuaG+dKpJE5nMKesrBOtfYlb3LiHmZlhzimRc8hddH4/pU6AO8JCFgFds5sfPN+ug1jDpbgAAuOW/NxSTvIw2iO1bflvG/Q+JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKnriC17g38j33vCDUZ4tT0fICNWx7V/vrTCQYMgyM4=;
 b=Bxqd2/EtkatprrIJLsIAEfqL6rYTbQi0x9OLThcuexIgggB1xViZ1G5OB67l2RY8A4cAexG5X47rj9gErmdTlne3dXjb3ROu2Je+ARBSBi+VS0MQjyLw0yKwb8bUAVPGKM1TcLlwy4OMKBbusUysw2Q8YVXpxYpp8pgehYf131ffOo/Hr4ThdpPX33UMS09Nafab9+iDIcsjtSBjYtJ1U1bN4PMy64NadoK1KnjpOrwJsqHUu/cj1hhu/rMNzOz+QcP+fUB60RHY1tO04KP1RfIyvd7lkQLoKt6uemVO7YMzVGB1/O+3feXno4eltTz6V3oPftkhooko6ITncvgdqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKnriC17g38j33vCDUZ4tT0fICNWx7V/vrTCQYMgyM4=;
 b=kbIrSoubv9G4t7f4lh2U8TpYMAZ3+zXGw4cOV2Pv9VkIBFHw5RQM34HC98uxhTqQe0wN864++9Qz02joXuebEhDeVGJWKO/Vb4IM2fsd6/nfSu3BFSOB8TYjK5VJywSA5LDONh5/Mo4jhuOLeLcgaiVmIE9/8ibKXq9/oRwvujY=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3508.namprd12.prod.outlook.com (20.179.66.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Fri, 10 Jan 2020 14:35:41 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2623.010; Fri, 10 Jan 2020
 14:35:41 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andre Guedes <andre.guedes@linux.intel.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     Po Liu <po.liu@nxp.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>
Subject: RE: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
Thread-Topic: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
Thread-Index: AQHVpQlV0arssjH64ECVUQFpoidQiae0UhKAgAfLu0CAAUwKgIADVrkAgAAT1YCAEke6AIAOrCuAgACCOSCAAJoCgIABV0sw
Date:   Fri, 10 Jan 2020 14:35:41 +0000
Message-ID: <BN8PR12MB3266E532328C6FD4D9473144D3380@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
 <157603276975.18462.4638422874481955289@pipeline>
 <VE1PR04MB6496CEA449E9B844094E580492510@VE1PR04MB6496.eurprd04.prod.outlook.com>
 <87eex43pzm.fsf@linux.intel.com> <20191219004322.GA20146@khorivan>
 <87lfr9axm8.fsf@linux.intel.com>
 <b7e1cb8b-b6b1-c0fa-3864-4036750f3164@ti.com>
 <157853205713.36295.17877768211004089754@aguedesl-mac01.jf.intel.com>
 <BN8PR12MB32663AE71CBF7CF0258C86D7D3390@BN8PR12MB3266.namprd12.prod.outlook.com>
 <157859309589.47157.8012794523971663624@aguedesl-mac01.local>
In-Reply-To: <157859309589.47157.8012794523971663624@aguedesl-mac01.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96c40df0-2f5f-43c2-9f75-08d795da5e98
x-ms-traffictypediagnostic: BN8PR12MB3508:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB350811AB795CAA5C04296AE1D3380@BN8PR12MB3508.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(346002)(376002)(396003)(136003)(199004)(189003)(55016002)(7696005)(8936002)(81156014)(81166006)(8676002)(9686003)(6506007)(26005)(5660300002)(4326008)(54906003)(52536014)(478600001)(107886003)(110136005)(316002)(86362001)(186003)(33656002)(7416002)(2906002)(66556008)(66946007)(64756008)(66446008)(66476007)(71200400001)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3508;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tV57uQVC2hAAR2Xk7nQoTyJ5xLQy/sqqG8XW3nqjnYGZWN64X/IdOdkg6HNW3aDpgsbn+dzvuVnNskAhdtAlceN6hQuWnrUSuP5d0J9mlqR6CeikHBcaH4LNLHrMmE3amZcMMjED10LbVPqqBTzk35HCUKO6zYYIcZwqMqN8U14lx1+xRMviO32gJ+JR7UJoFIk0cQ70LWcd/qgytBKlko88yJLF6ku1uQYXOiAAbBef1mc76kBFI5Lyp545hkS9hbw6TVcpTQZQMPzQqgoocz7jHiqUtKYr4X3Xtk++k0mxOJmiDnN0SwXF3s0dOg56NpOK5RorTQcPMFwkfLrt0CCz3SauzqVtYnAUWRKwERLbKWlTlRn5I12VEHkxWp13owZfM0Ih6KHlG+fQwQz3n1ubOrKeizNJREOCp5KMC8dP8HQxMuePIq0SAu0tk1Po
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c40df0-2f5f-43c2-9f75-08d795da5e98
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 14:35:41.7355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TjE7Sr2+UoIE45As9utcBEHDLYkTx4qk/lFka8jozlKU+N+o9dd4kwU+7HZkDQ0V/sr7RnUL2EBOEuPrkDcYgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3508
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQW5kcmUgR3VlZGVzIDxhbmRyZS5ndWVkZXNAbGludXguaW50ZWwuY29tPg0KRGF0ZTog
SmFuLzA5LzIwMjAsIDE4OjA0OjU1IChVVEMrMDA6MDApDQoNCj4gUXVvdGluZyBKb3NlIEFicmV1
ICgyMDIwLTAxLTA5IDAwOjU5OjI0KQ0KPiA+IEZyb206IEFuZHJlIEd1ZWRlcyA8YW5kcmUuZ3Vl
ZGVzQGxpbnV4LmludGVsLmNvbT4NCj4gPiBEYXRlOiBKYW4vMDkvMjAyMCwgMDE6MDc6MzcgKFVU
QyswMDowMCkNCj4gPiANCj4gPiA+IEFmdGVyIHJlYWRpbmcgYWxsIHRoaXMgZ3JlYXQgZGlzY3Vz
c2lvbiBhbmQgcmV2aXNpdGluZyB0aGUgODAyLjFRIGFuZCA4MDIuM2JyDQo+ID4gPiBzcGVjcywg
SSdtIG5vdyBsZWFuaW5nIHRvd2FyZHMgdG8gbm90IGNvdXBsaW5nIEZyYW1lIFByZWVtcHRpb24g
c3VwcG9ydCB1bmRlcg0KPiA+ID4gdGFwcmlvIHFkaXNjLiBCZXNpZGVzIHdoYXQgaGF2ZSBiZWVu
IGRpc2N1c3NlZCwgQW5uZXggUy4yIGZyb20gODAyLjFRLTIwMTgNCj4gPiA+IGZvcmVzZWVzIEZQ
IHdpdGhvdXQgRVNUIHNvIGl0IG1ha2VzIG1lIGZlZWwgbGlrZSB3ZSBzaG91bGQga2VlcCB0aGVt
IHNlcGFyYXRlLg0KPiA+IA0KPiA+IEkgYWdyZWUgdGhhdCBFU1QgYW5kIEZQIGNhbiBiZSB1c2Vk
IGluZGl2aWR1YWxseS4gQnV0IGhvdyBjYW4geW91IA0KPiA+IHNwZWNpZnkgdGhlIGhvbGQgYW5k
IHJlbGVhc2UgY29tbWFuZHMgZm9yIGdhdGVzIHdpdGhvdXQgY2hhbmdpbmcgdGFwcmlvIHFkaXNj
IHVzZXIgc3BhY2UgQVBJID8NCj4gDQo+IFRoZSAnaG9sZCcgYW5kICdyZWxlYXNlJyBhcmUgb3Bl
cmF0aW9ucyBmcm9tIHRoZSBHQ0wsIHdoaWNoIGlzIHBhcnQgb2YgRVNULiBTbw0KPiB0aGV5IHNo
b3VsZCBzdGlsbCBiZSBzcGVjaWZpZWQgdmlhIHRhcHJpby4gTm8gY2hhbmdpbmcgaW4gdGhlIHVz
ZXIgc3BhY2UgQVBJIGlzDQo+IHJlcXVpcmVkIHNpbmNlIHRoZXNlIG9wZXJhdGlvbnMgYXJlIGFs
cmVhZHkgc3VwcG9ydGVkIGluIHRhcHJpbyBBUEkuIFdoYXQgaXMNCj4gbWlzc2luZyB0b2RheSBp
cyBqdXN0IHRoZSAndGMnIHNpZGUgb2YgaXQsIHdoaWNoIHlvdSBhbHJlYWR5IGhhdmUgYSBwYXRj
aCBmb3INCj4gaXQuDQoNCk9LLiBTaG91bGQgd2UgYXNrIHRvIG1lcmdlIGl0IGFzLWlzIHRoZW4g
Pw0KDQo+ID4gPiBSZWdhcmRpbmcgdGhlIEZQIGNvbmZpZ3VyYXRpb24ga25vYnMsIHRoZSBmb2xs
b3dpbmcgc2VlbXMgcmVhc29uYWJsZSB0byBtZToNCj4gPiA+ICAgICAqIEVuYWJsZS9kaXNhYmxl
IEZQIGZlYXR1cmUNCj4gPiA+ICAgICAqIFByZWVtcHRhYmxlIHF1ZXVlIG1hcHBpbmcNCj4gPiA+
ICAgICAqIEZyYWdtZW50IHNpemUgbXVsdGlwbGllcg0KPiA+ID4gDQo+ID4gPiBJJ20gbm90IHN1
cmUgYWJvdXQgdGhlIGtub2IgJ3RpbWVycyAoaG9sZC9yZWxlYXNlKScgZGVzY3JpYmVkIGluIHRo
ZSBxdW90ZXMNCj4gPiA+IGFib3ZlLiBJIGNvdWxkbid0IGZpbmQgYSBtYXRjaCBpbiB0aGUgc3Bl
Y3MuIElmIGl0IHJlZmVycyB0byAnaG9sZEFkdmFuY2UnIGFuZA0KPiA+ID4gJ3JlbGVhc2VBZHZh
bmNlJyBwYXJhbWV0ZXJzIGRlc2NyaWJlZCBpbiA4MDIuMVEtMjAxOCwgSSBiZWxpZXZlIHRoZXkg
YXJlIG5vdA0KPiA+ID4gY29uZmlndXJhYmxlLiBEbyB3ZSBrbm93IGFueSBoYXJkd2FyZSB3aGVy
ZSB0aGV5IGFyZSBjb25maWd1cmFibGU/DQo+ID4gDQo+ID4gU3lub3BzeXMnIEhXIHN1cHBvcnRz
IHJlY29uZmlndXJpbmcgdGhlc2UgcGFyYW1ldGVycy4gVGhleSBhcmUsIGhvd2V2ZXIsIA0KPiA+
IGZpeGVkIGluZGVwZW5kZW50bHkgb2YgUXVldWVzLiBpLmUuIGFsbCBxdWV1ZXMgd2lsbCBoYXZl
IHNhbWUgaG9sZEFkdmFuY2UgLyByZWxlYXNlQWR2YW5jZS4NCj4gDQo+IEdvb2QgdG8ga25vdy4g
SXMgdGhlIGRhdGFzaGVldCBwdWJsaWNseSBhdmFpbGFibGU/IElmIHNvLCBjb3VsZCB5b3UgcGxl
YXNlDQo+IHBvaW50IG1lIHRvIGl0PyAgSSdkIGxpa2UgdG8gbGVhcm4gbW9yZSBhYm91dCB0aGUg
RlAga25vYnMgcHJvdmlkZWQgYnkNCj4gZGlmZmVyZW50IEhXLg0KDQpJJ20gYWZyYWlkIGl0cyBu
b3QgYXZhaWxhYmxlIHVubGVzcyB5b3UgYXJlIGEgU3lub3BzeXMgY3VzdG9tZXIuIFlvdSANCnNo
b3VsZCBob3dldmVyIGJlIGFibGUgdG8gZmlndXJlIG91dCB0aGUgYmVoYXZpb3IgYnkgcmVhZGlu
ZyBteSBwYXRjaCANCnRoYXQgYWRkcyBzdXBwb3J0IGZvciBGUEUgaW4gWEdNQUMgYW5kIFFvUyBj
b3Jlcy4gSSBjYW4gY2xhcmlmeSBhbnkgDQpkb3VidHMuDQoNCi0tLQ0KVGhhbmtzLA0KSm9zZSBN
aWd1ZWwgQWJyZXUNCg==

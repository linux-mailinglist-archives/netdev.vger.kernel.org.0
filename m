Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451331AD1EA
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 23:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgDPVcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 17:32:53 -0400
Received: from mail-am6eur05on2072.outbound.protection.outlook.com ([40.107.22.72]:24640
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726330AbgDPVcw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 17:32:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cT8EOLYzZD+cFWrvAXzVZ7NzAZW4hj1bNDgyRyvlMyuF+j8u58pLnUZE8iy1aVanEZnuwOfF6VQhCgWZcetpGtiPSTewDrjfNzlXdCnkbKYaLbE5J34ku2yl656N0SX3VqhL7XzSHq2+UICtRvKFyNCuKvhIqmz+TD0vk4Nd2TN0FKWjbxGq0ltDSqwMKY5TLsNPDlCWKBC2cStZ9Y/iDgUmw/o66drRzFV9H7L2y4Rhuepxem0JgKnAnoTjrB3ikvUNK7KO9zwnqlZZ/2KTWyF2/A14HUylJmqCE28ax6ruW6+gVQIQ6kTg7Y8ASDhl71O8+Gc3zGYPCFDwlBLQ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKjgwTxVgq8vK1qC0PR6lu6eQlO8+sO3JISfP6aVlNo=;
 b=OKKtMuIn46kZJ5cn5HpFVZ1xPCYZhwuySMitqMJ9sRa6+TtOSu04/c9ZbNG4UEvboBovPRP902NImWWMEnBOOMEodetH7HMex3mI4HKl8jrDMOjezb3hk31oYoKKSsHm5yi40LQZ/Xw+wRqralnilmkoJkkVG51zTIWjl0P+7cFx3/iWwFuCVQ6VQak4gCi6A+KgW5dZknj1oxygECbnfvQK7ufwZi395Z1MYaXPEoxDIpo82zJRXn3E1uSz/gyQLaIwIiHkiZ1ryNm67+4JoUfVArem1MZXy25fnZpWnEU13nMAFEi326lPMutUQGcMmHzG4iJ1VP4eXxQmAefQ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKjgwTxVgq8vK1qC0PR6lu6eQlO8+sO3JISfP6aVlNo=;
 b=au4eZnWTMDmrIu19eeGKBM8Tsqzd2yCu4fc9T6jJZuGhEXPQopYO9dgbAUxtuvW5eeoZZfZ0q8QNE3Vv/vavH04/6CSYbJrJR51ZtfvJBSk/u1LaW1iMylCCm0hrSTX4bkw1xPhlbNlplCoLNPKkYaqx3vhR2DLtONN7d1YrvFA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3215.eurprd05.prod.outlook.com (2603:10a6:802:25::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Thu, 16 Apr
 2020 21:32:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.028; Thu, 16 Apr 2020
 21:32:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sashal@kernel.org" <sashal@kernel.org>
CC:     "ecree@solarflare.com" <ecree@solarflare.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Topic: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Index: AQHWEFb6WRVOJO0/j0GE4IB+QkA/0qh1Ei4AgAC1ZICAAheSAIAAjYWAgAAM6ICAADp+AIAAE8gAgABWOICAAURNAIAAgPKAgADlNYCAAD1UgIAAJLSAgAAGLYCAABu7AA==
Date:   Thu, 16 Apr 2020 21:32:47 +0000
Message-ID: <829c2b8807b4e6c59843b3ab85ca3ccc6cae8373.camel@mellanox.com>
References: <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
         <20200414110911.GA341846@kroah.com>
         <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
         <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
         <20200414205755.GF1068@sasha-vm>
         <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
         <20200416000009.GL1068@sasha-vm>
         <CAJ3xEMjfWL=c=voGqV4pUCzWXmiTn-R6mrRi82UAVHMVysKU1g@mail.gmail.com>
         <20200416172001.GC1388618@kroah.com>
         <b8651ce6d7d6c6dcb8b2d66f07148413892b48d0.camel@mellanox.com>
         <20200416195329.GO1068@sasha-vm>
In-Reply-To: <20200416195329.GO1068@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0dad56d7-5cf9-4d5f-106a-08d7e24db4f1
x-ms-traffictypediagnostic: VI1PR05MB3215:
x-microsoft-antispam-prvs: <VI1PR05MB321582728FD30CDDA1847465BED80@VI1PR05MB3215.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:459;
x-forefront-prvs: 0375972289
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(76116006)(2906002)(71200400001)(478600001)(36756003)(8936002)(81156014)(64756008)(54906003)(5660300002)(86362001)(8676002)(4326008)(2616005)(26005)(186003)(91956017)(66446008)(316002)(66946007)(66556008)(66476007)(6916009)(6506007)(6486002)(6512007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WsDCddiwSavFNkvzvCGm19zTN51viPfY5C7amiJnXhLMFu9lGcaX/mRyVzG8Qs6XG2cxS01m3+slSGw/ipT9DSyOJ1yL9iZj+aMCEY3bkvpccNPmGi8/mMH5OFj6W8rnklZIz7AT3sARGUcxhSOnwlRhGLZ4DTzx/2JeFiBhzfJUp5cpVV9MfIef8wzlhqfYwPZTADdRP518DHjO8X/H6NyEmRELLejNoY06G1E0ulJ0Vi5lAy2veIf28oqhdjwo+R55cVl1ZD/w/3sH7Zhn4xK68NHP+zCYhpD6xwzFOe1+hfv1jiUeYRSgy3HNFPmUgL/Hsy3fDAZaQbYIzcoB+k4XtALbxlCsvMxTaB67PwaKRCpL6uW9hhT4fc2JoAdCwSv5sIkbPswo1ZPjLrN/MM8rWUnG2pb8DGYS4l5wGTLWcQppU83oTPva6Mr5f8zp
x-ms-exchange-antispam-messagedata: VOujaYhVWy/JfhPqff3qsV3nKy6lqMG2/RzKyN1vKPufj9BLIFVpZMCxSooms6Koz03zlZGx++bOPJ9m+jj6nmashg1AngP96M2qybTMaXfv0X37cJf0qXp2GmalyUhLSeBKfrkWboFURGpRKaPLpw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <18ABED6F8E01F145B99268194600EB10@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dad56d7-5cf9-4d5f-106a-08d7e24db4f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2020 21:32:47.1231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EO8DBNF8q3j9QyHoekRHZqCQFEn0IbWonismBkdTw3G2T9f0wqp+LvZDZjWHqDss0PCJjgZH03Ha4mB+Z0jRAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTE2IGF0IDE1OjUzIC0wNDAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4g
T24gVGh1LCBBcHIgMTYsIDIwMjAgYXQgMDc6MzE6MjVQTSArMDAwMCwgU2FlZWQgTWFoYW1lZWQg
d3JvdGU6DQo+ID4gT24gVGh1LCAyMDIwLTA0LTE2IGF0IDE5OjIwICswMjAwLCBHcmVnIEtIIHdy
b3RlOg0KPiA+ID4gU28gZmFyIHRoZSBBVVRPU0VMIHRvb2wgaGFzIGZvdW5kIHNvIG1hbnkgcmVh
bCBidWdmaXhlcyB0aGF0IGl0DQo+ID4gPiBpc24ndA0KPiA+ID4gZnVubnkuICBJZiB5b3UgZG9u
J3QgbGlrZSBpdCwgZmluZSwgYnV0IGl0IGhhcyBwcm92ZW4gaXRzZWxmDQo+ID4gPiBfd2F5Xw0K
PiA+ID4gYmV5b25kIG15IHdpbGRlc3QgaG9wZXMgYWxyZWFkeSwgYW5kIGl0IGp1c3Qga2VlcHMg
Z2V0dGluZw0KPiA+ID4gYmV0dGVyLg0KPiA+ID4gDQo+ID4gDQo+ID4gTm93IGkgcmVhbGx5IGRv
bid0IGtub3cgd2hhdCB0aGUgcmlnaHQgYmFsYW5jZSBoZXJlLCBpbiBvbiBvbmUNCj4gPiBoYW5k
LA0KPiA+IGF1dG9zZWwgaXMgZG9pbmcgYSBncmVhdCBqb2IsIG9uIHRoZSBvdGhlciBoYW5kIHdl
IGtub3cgaXQgY2FuDQo+ID4gc2NyZXcgdXANCj4gPiBpbiBzb21lIGNhc2VzLCBhbmQgd2Uga25v
dyBpdCB3aWxsLg0KPiA+IA0KPiA+IFNvIHdlIGRlY2lkZWQgdG8gbWFrZSBzYWNyaWZpY2VzIGZv
ciB0aGUgZ3JlYXRlciBnb29kID8gOikNCj4gDQo+IGF1dG9zZWwgaXMgZ29pbmcgdG8gc2NyZXcg
dXAsIEknbSBnb2luZyB0byBzY3JldyB1cCwgeW91J3JlIGdvaW5nIHRvDQo+IHNjcmV3IHVwLCBh
bmQgTGludXMgaXMgZ29pbmcgc2NyZXcgdXAuIFRoZSBleGlzdGVuY2Ugb2YgdGhlIHN0YWJsZQ0K
PiB0cmVlcw0KPiBhbmQgYSAiRml4ZXM6IiB0YWcgaXMgYW4gYWRtaXNzaW9uIHdlIGFsbCBzY3Jl
dyB1cCwgcmlnaHQ/DQo+IA0KDQpSaWdodCwgc28gZml4IHRoaXMgQUkgYW5kIHdlIGdldCBvbmUg
bGVzcyByZWFzb24gdG8gc2NyZXcgdXAgPw0KDQo+IElmIHlvdSdyZSB3aWxsaW5nIHRvIGFjY2Vw
dCB0aGF0IHdlIGFsbCBtYWtlIG1pc3Rha2VzLCB5b3Ugc2hvdWxkDQo+IGFsc28NCj4gYWNjZXB0
IHRoYXQgd2UncmUgbWFraW5nIG1pc3Rha2VzIGV2ZXJ5d2hlcmU6IHdlIHdyaXRlIGJ1Z2d5IGNv
ZGUsIHdlDQo+IGZhaWwgYXQgcmV2aWV3cywgd2UgZm9yZ2V0IHRhZ3MsIGFuZCB3ZSBzdWNrIGF0
IGJhY2twb3J0aW5nIHBhdGNoZXMuDQo+IA0KPiBJZiB3ZSBhZ3JlZSBzbyBmYXIsIHRoZW4gd2h5
IGRvIHlvdSBhc3N1bWUgdGhhdCB0aGUgc2FtZSBwZW9wbGUgd2hvDQo+IGRvDQo+IHRoZSBhYm92
ZSBhbHNvIHBlcmZlY3RseSB0YWcgdGhlaXIgY29tbWl0cywgYW5kIGRvIHBlcmZlY3Qgc2VsZWN0
aW9uDQo+IG9mDQo+IHBhdGNoZXMgZm9yIHN0YWJsZT8gIkknbSBhbHdheXMgcmlnaHQgZXhjZXB0
IHdoZW4gSSdtIHdyb25nIi4NCg0KSSBhbSB3ZWxsaW5nIHRvIGFjY2VwdCBwZW9wbGUgbWFraW5n
IG1pc3Rha2VzLCBidXQgbm90IHRoZSBBSS4uIA0KDQpJIGFtIG5vdCBzYXlpbmcgcGVvcGxlIHNo
b3VsZCBiZSAxMDAlIGZsYXdsZXNzLCBidXQgaSBhbSBhc3N1bWluZyBBSSBpcw0KMTAwJSBmbGF3
bGVzcy4gaWYgSSBmaW5kIGEgYnVnIGluIEFJIEkgZml4LiBzYW1lIGdvZXMgZm9yIGF1dG9zZWwg
QUksDQppdCBtdXN0IGdldCBmaXhlZC4NCg0KV2hhdCB5b3UgYXJlIHJlYWxseSBzYXlpbmc6IEkg
ZG9uJ3QgbGlrZSBidWdzLCBzbyBpIHdyb3RlIGFuIEFJIHRoYXQNCmZpeGVzIGJ1Z3MgYnV0IGFs
c28gY2FuIG1ha2UgYnVncyBpdHNlbGYuDQoNCj4gDQo+IE15IHZpZXcgb2YgdGhlIHRoZSBwYXRo
IGZvcndhcmQgd2l0aCBzdGFibGUgdHJlZXMgaXMgdGhhdCB3ZSBoYXZlIHRvDQo+IGJlZWYgdXAg
b3VyIHZhbGlkYXRpb24gYW5kIHRlc3Rpbmcgc3RvcnkgdG8gYmUgYWJsZSB0byBjYXRjaCB0aGVz
ZQ0KPiBpc3N1ZXMgYmV0dGVyLCByYXRoZXIgdGhhbiBwbGFjZSBhcmJpdHJhcnkgbGltaXRhdGlv
bnMgb24gcGFydHMgb2YNCj4gdGhlDQo+IHByb2Nlc3MuIFRvIG1lIHlvdXIgc3VnZ2VzdGlvbnMg
YXJvdW5kIHRoZSBGaXhlczogdGFnIHNvdW5kIGxpa2UNCj4gIk5ldmVyDQo+IHVzZSBrbWFsbG9j
KCkgYmVjYXVzZSBwZW9wbGUgb2Z0ZW4gZm9yZ2V0IHRvIGZyZWUgbWVtb3J5ISIgd2lsbCBpdA0K
PiBwcmV2ZW50IG1lbW9yeSBsZWFrcz8gc3VyZSwgYnV0IGl0J2xsIGFsc28gcHJldmVudCB1c2Vm
dWwgcGF0Y2hlcw0KPiBmcm9tDQo+IGNvbWluZyBpdC4uLg0KPiANCg0KTm8sIEkgd2lsbCBsZXQg
cGVvcGxlIGRvIHdoYXQgcGVvcGxlIGRvIGJlc3QgKG1ha2UgbW9yZSBidWdzKSB0aGlzIGlzDQpt
b3JlIHRoYW4gZmluZS4NCg0KaWYgaXQgaXMgbmVjZXNzYXJ5IGFuZCB3ZSBoYXZlIGEgbWFnaWNh
bCBzb2x1dGlvbiwgaSB3aWxsIHdyaXRlIGdvb2QgQUkNCndpdGggbm8gZmFsc2UgcG9zaXRpdmVz
IHRvIGZpeCBvciBoZWxwIGF2b2lkIG1lbWxlYWNrcy4NCg0KQlVUIGlmIGkgY2FuJ3QgYWNoaWV2
ZSAxMDAlIHN1Y2Nlc3MgcmF0ZSwgYW5kIGkgbWlnaHQgZW5kIHVwDQppbnRyb2R1Y2luZyBtZW1s
ZWFjayB3aXRoIG15IEFJLCB0aGVuIEkgd291bGRuJ3QgdXNlIEFJIGF0IGFsbC4NCg0KV2UgaGF2
ZSBkaWZmZXJlbnQgdmlld3Mgb24gdGhpbmdzLi4gaWYgaSBrbm93IEFJIGlzIHVzaW5nIGttYWxs
b2MNCndyb25nbHksIEkgZml4IGl0LCBlbmQgb2Ygc3RvcnkgOikuDQoNCmZhY3Q6IFlvdXIgQUkg
aXMgYnJva2VuLCBjYW4gaW50cm9kdWNlIF9uZXdfIHVuLWNhbGxlZCBmb3IgYnVncywgZXZlbg0K
aXQgaXMgdmVyeSB2ZXJ5IHZlcnkgZ29vZCA5OS45OSUgb2YgdGhlIGNhc2VzLiANCg0KWW91IGFy
ZSB3ZWxsaW5nIHRvIHJvbGwgdGhlIGRpY2UsIGkgYW0gbm90IC4uIA0KDQo+IEhlcmUncyBteSBz
dWdnZXN0aW9uOiBnaXZlIHVzIGEgdGVzdCByaWcgd2UgY2FuIHJ1biBvdXIgc3RhYmxlDQo+IHJl
bGVhc2UNCj4gY2FuZGlkYXRlcyB0aHJvdWdoLiBTb21ldGhpbmcgdGhhdCBzaW11bGF0ZXMgInJl
YWwiIGxvYWQgdGhhdA0KPiBjdXN0b21lcnMNCj4gYXJlIHVzaW5nLiBXZSBwcm9taXNlIHRoYXQg
d2Ugd29uJ3QgcmVsZWFzZSBhIHN0YWJsZSBrZXJuZWwgaWYgeW91cg0KPiB0ZXN0cyBhcmUgZmFp
bGluZy4NCj4gDQoNCkkgd2lsbCBiZSBtb3JlIHRoYW4gZ2xhZCB0byBkbyBzbywgaXMgdGhlcmUg
YSBmb3JtYWwgcHJvY2VzcyBmb3Igc3VjaA0KdGhpbmcgPw0KDQo=

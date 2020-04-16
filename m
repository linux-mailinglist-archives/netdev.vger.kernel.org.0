Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC811AD1B7
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 23:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgDPVIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 17:08:12 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:4274
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725928AbgDPVIM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 17:08:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PG9a9HFaI0poY9GDmMiZ0DdxA9OjVCmOA4GGoooL+x7OPImFIAaMgeAq5VTsIorJR0jyskIlQM/yPMB2u7PCNzaLCVsGp66fIw+1SV0pNOVKFLVoooa9rE+brreBdKvR+nxKLAAqBTzMaxoo/RrMTkFIfeBm19GHohHxF7ej9r/KvXLosy24+PB/MaAlOtWUCaMPI/GhmLnk55HqFRKpn1kkRZI0C8gW6lDd1fSCdSG7MtHCG9+QrnoV1XttAPDPZ4/R8OFJh/VI5MWQReMDOA+/LVe722zDEIdYZXzSLvwHzf0V4xRplt1R9lKQJCDZDGhx0++qBr/8EIx21CrTSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Id8/BmrD8/qi0sEdKkKx9tKWdwdz9uDa9K7668VNJ7A=;
 b=RazsMYxkuU0ZEEtMAjc0XPw/7iUWxK7e0XYPe+LxlOIkVUVHerzWwRVKXdWLE3abV4qlgjAN5LtySjLi1VcD/cSEou3auU2XVSak+npIJKFlQ7rnykPOYyPiBLXxA52TT2ZOaZAxE604hl3fjYgPmY+BIY5+GSuQSWt3q1WooinmK7lVr2My11ONVbAXz1mZFR0SVFENqSrcLa0Ue/59GHxJTCAe7Ssob0N4D8Xn27MrDhmBAz88d5Q+nTBWryXKZtXXJ+/LF1VG6e1J/KQWw/0pnm3zRF8kM6ExAm6ye3BZJN93o8SlPhKD99IZ30emY16dvptIuwh/BzGzYfvinA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Id8/BmrD8/qi0sEdKkKx9tKWdwdz9uDa9K7668VNJ7A=;
 b=N9kaODGwR7APrOXjR92bxv3Te5g7PRrptrw1zXLjkIlMT4WbEYHKpOnesx9gI3ArGcSrJfs7JR4Sh/YnVBQavSq45bvBDH+I+dd+Jy1XhSZww8xgnBtSqEoASpkvVPpzXXJwvTsbZ7QgEU6eX46AF+blPkW/wVy4ebDFGBqZCO4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5599.eurprd05.prod.outlook.com (2603:10a6:803:9c::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26; Thu, 16 Apr
 2020 21:08:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.028; Thu, 16 Apr 2020
 21:08:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sashal@kernel.org" <sashal@kernel.org>
CC:     "ecree@solarflare.com" <ecree@solarflare.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Topic: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Index: AQHWEFb6WRVOJO0/j0GE4IB+QkA/0qh1Ei4AgAC1ZICAAheSAIAAjYWAgAAM6ICAADp+AIAAE8gAgABWOICAAURNAIAAgPKAgABFSICAABU+gIAAh8CAgABeMwCAAA56gIAAE00A
Date:   Thu, 16 Apr 2020 21:08:06 +0000
Message-ID: <3226e1df60666c0c4e3256ec069fee2d814d9a03.camel@mellanox.com>
References: <20200414110911.GA341846@kroah.com>
         <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
         <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
         <20200414205755.GF1068@sasha-vm>
         <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
         <20200416000009.GL1068@sasha-vm>
         <434329130384e656f712173558f6be88c4c57107.camel@mellanox.com>
         <20200416052409.GC1309273@unreal> <20200416133001.GK1068@sasha-vm>
         <550d615e14258c744cb76dd06c417d08d9e4de16.camel@mellanox.com>
         <20200416195859.GP1068@sasha-vm>
In-Reply-To: <20200416195859.GP1068@sasha-vm>
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
x-ms-office365-filtering-correlation-id: 985ca462-0e28-405d-30cd-08d7e24a428b
x-ms-traffictypediagnostic: VI1PR05MB5599:
x-microsoft-antispam-prvs: <VI1PR05MB55994910041092753A39E4A8BED80@VI1PR05MB5599.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0375972289
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(6486002)(66446008)(64756008)(66556008)(76116006)(91956017)(66476007)(66946007)(54906003)(316002)(5660300002)(6512007)(8676002)(86362001)(8936002)(6916009)(966005)(478600001)(45080400002)(2906002)(81156014)(53546011)(6506007)(36756003)(2616005)(71200400001)(186003)(26005)(4326008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1A7lxXEQ4yCcLkVf+oyickxrrTHdRzT1PQxWAS+/hViN8jbCTTFcRO4N5Lci1MQwZaOIIupqm8KhzLH3LQz1GNBowJQm3rOER9tNjqFmisSR7RQ/I/c0F/JxQOxtVAk9I3tA0ZJdgrkwOqetTBYUj18HSmvbATbSCTtMJRKedNbj7HlYpyYAIk2DG1Erg8rAwmwVJ8Cyc9F4E2N12AmQ92g1bo9WWpiJphl2jbhWyEenVhrDEkflJ3HpGJMHgM9EcnaHZ1L88Ozxnry4ZOLAMs8J5w0MdpI4f005IIaIeIfUz4/Sg/VnGoLRTF9euTef5b/W42zljo2qJsDSuzBaU8zZgGKbzQM51h+gmGdnVfsvavKd50pSAt9SJH2CulM8h5dWJm2uvK4AZsZvy17XPCgktLmS/Exe03iBisi3kyNuwEjMl1SuwG17LxGrJfiNj0asPpkcimtoDSrwaqTZikEh2U09YlG7PF0JcT4pkp/lGnirQHSsH8DGEXI+3nOs8rnsPWwz5SNg3cHmZlxQ7Q==
x-ms-exchange-antispam-messagedata: 7jm8040WhWfX8hc3AKia4EN8Kvgskvjzd0Pi5TUYHkwcQHFVoMWvuSD1J9HLgMmync372ikg8i4k1fMNi1nRSTgB3ehROR/ZyvlWVwbwCIam5/lJmDVg3FDBCwabXMFDJApdjqIUiT2uBaZ29H/TDw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B065A215E6F4ED4197B067A1D7EFCF99@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 985ca462-0e28-405d-30cd-08d7e24a428b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2020 21:08:06.6830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KaqHPey7zZvrMzP6joR7frVJfSQX5vzMiSAFhM3KhLMKdgdzskQqKSxaN8Pl09kPgHmOXnpluLEXDuRVPzpBkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5599
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTE2IGF0IDE1OjU4IC0wNDAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4g
T24gVGh1LCBBcHIgMTYsIDIwMjAgYXQgMDc6MDc6MTNQTSArMDAwMCwgU2FlZWQgTWFoYW1lZWQg
d3JvdGU6DQo+ID4gT24gVGh1LCAyMDIwLTA0LTE2IGF0IDA5OjMwIC0wNDAwLCBTYXNoYSBMZXZp
biB3cm90ZToNCj4gPiA+IE9uIFRodSwgQXByIDE2LCAyMDIwIGF0IDA4OjI0OjA5QU0gKzAzMDAs
IExlb24gUm9tYW5vdnNreSB3cm90ZToNCj4gPiA+ID4gT24gVGh1LCBBcHIgMTYsIDIwMjAgYXQg
MDQ6MDg6MTBBTSArMDAwMCwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+ID4gPiA+ID4gT24gV2Vk
LCAyMDIwLTA0LTE1IGF0IDIwOjAwIC0wNDAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4gPiA+ID4g
PiA+IE9uIFdlZCwgQXByIDE1LCAyMDIwIGF0IDA1OjE4OjM4UE0gKzAxMDAsIEVkd2FyZCBDcmVl
DQo+ID4gPiA+ID4gPiB3cm90ZToNCj4gPiA+ID4gPiA+ID4gRmlyc3RseSwgbGV0IG1lIGFwb2xv
Z2lzZTogbXkgcHJldmlvdXMgZW1haWwgd2FzIHRvbw0KPiA+ID4gPiA+ID4gPiBoYXJzaA0KPiA+
ID4gPiA+ID4gPiBhbmQgdG9vDQo+ID4gPiA+ID4gPiA+ICBhc3NlcnRpdmVhYm91dCB0aGluZ3Mg
dGhhdCB3ZXJlIHJlYWxseSBtb3JlIHVuY2VydGFpbg0KPiA+ID4gPiA+ID4gPiBhbmQNCj4gPiA+
ID4gPiA+ID4gdW5jbGVhci4NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IE9uIDE0LzA0
LzIwMjAgMjE6NTcsIFNhc2hhIExldmluIHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+IEkndmUgcG9p
bnRlZCBvdXQgdGhhdCBhbG1vc3QgNTAlIG9mIGNvbW1pdHMgdGFnZ2VkIGZvcg0KPiA+ID4gPiA+
ID4gPiA+IHN0YWJsZSBkbw0KPiA+ID4gPiA+ID4gPiA+IG5vdA0KPiA+ID4gPiA+ID4gPiA+IGhh
dmUgYSBmaXhlcyB0YWcsIGFuZCB5ZXQgdGhleSBhcmUgZml4ZXMuIFlvdSByZWFsbHkNCj4gPiA+
ID4gPiA+ID4gPiBkZWR1Y2UNCj4gPiA+ID4gPiA+ID4gPiB0aGluZ3MgYmFzZWQNCj4gPiA+ID4g
PiA+ID4gPiBvbiBjb2luIGZsaXAgcHJvYmFiaWxpdHk/DQo+ID4gPiA+ID4gPiA+IFllcywgYnV0
IGZhciBsZXNzIHRoYW4gNTAlIG9mIGNvbW1pdHMgKm5vdCogdGFnZ2VkIGZvcg0KPiA+ID4gPiA+
ID4gPiBzdGFibGUNCj4gPiA+ID4gPiA+ID4gaGF2ZQ0KPiA+ID4gPiA+ID4gPiBhIGZpeGVzDQo+
ID4gPiA+ID4gPiA+ICB0YWcuICBJdCdzIG5vdCBhYm91dCBoYXJkLWFuZC1mYXN0IEFyaXN0b3Rl
bGlhbg0KPiA+ID4gPiA+ID4gPiAiZGVkdWN0aW9ucyIsIGxpa2UNCj4gPiA+ID4gPiA+ID4gInRo
aXMNCj4gPiA+ID4gPiA+ID4gIGRvZXNuJ3QgaGF2ZSBGaXhlczosIHRoZXJlZm9yZSBpdCBpcyBu
b3QgYSBzdGFibGUNCj4gPiA+ID4gPiA+ID4gY2FuZGlkYXRlIiwgaXQncw0KPiA+ID4gPiA+ID4g
PiBhYm91dA0KPiA+ID4gPiA+ID4gPiAgcHJvYmFiaWxpc3RpYyAiaW5kdWN0aW9uIi4NCj4gPiA+
ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gIml0IGRvZXMgaW5jcmVhc2UgdGhlIGFtb3VudCBv
ZiBjb3VudGVydmFpbGluZyBldmlkZW5jZQ0KPiA+ID4gPiA+ID4gPiA+IG5lZWRlZCB0bw0KPiA+
ID4gPiA+ID4gPiA+IGNvbmNsdWRlIGEgY29tbWl0IGlzIGEgZml4IiAtIFBsZWFzZSBleHBsYWlu
IHRoaXMNCj4gPiA+ID4gPiA+ID4gPiBhcmd1bWVudA0KPiA+ID4gPiA+ID4gPiA+IGdpdmVuDQo+
ID4gPiA+ID4gPiA+ID4gdGhlDQo+ID4gPiA+ID4gPiA+ID4gYWJvdmUuDQo+ID4gPiA+ID4gPiA+
IEFyZSB5b3UgZmFtaWxpYXIgd2l0aCBCYXllc2lhbiBzdGF0aXN0aWNzPyAgSWYgbm90LCBJJ2QN
Cj4gPiA+ID4gPiA+ID4gc3VnZ2VzdA0KPiA+ID4gPiA+ID4gPiByZWFkaW5nDQo+ID4gPiA+ID4g
PiA+ICBzb21ldGhpbmcgbGlrZSBodHRwOi8veXVka293c2t5Lm5ldC9yYXRpb25hbC9iYXllcy8N
Cj4gPiA+ID4gPiA+ID4gd2hpY2gNCj4gPiA+ID4gPiA+ID4gZXhwbGFpbnMNCj4gPiA+ID4gPiA+
ID4gaXQuDQo+ID4gPiA+ID4gPiA+IFRoZXJlJ3MgYSBiaWcgZGlmZmVyZW5jZSBiZXR3ZWVuIGEg
Y29pbiBmbGlwIGFuZCBhDQo+ID4gPiA+ID4gPiA+IF9jb3JyZWxhdGVkXw0KPiA+ID4gPiA+ID4g
PiBjb2luIGZsaXAuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IEknZCBtYXliZSBwb2ludCBv
dXQgdGhhdCB0aGUgc2VsZWN0aW9uIHByb2Nlc3MgaXMgYmFzZWQgb24NCj4gPiA+ID4gPiA+IGEN
Cj4gPiA+ID4gPiA+IG5ldXJhbA0KPiA+ID4gPiA+ID4gbmV0d29yayB3aGljaCBrbm93cyBhYm91
dCB0aGUgZXhpc3RlbmNlIG9mIGEgRml4ZXMgdGFnIGluIGENCj4gPiA+ID4gPiA+IGNvbW1pdC4N
Cj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gSXQgZG9lcyBleGFjdGx5IHdoYXQgeW91J3JlIGRl
c2NyaWJpbmcsIGJ1dCBhbHNvIHRha2luZyBhDQo+ID4gPiA+ID4gPiBidW5jaA0KPiA+ID4gPiA+
ID4gbW9yZQ0KPiA+ID4gPiA+ID4gZmFjdG9ycyBpbnRvIGl0J3MgZGVzaWNpb24gcHJvY2VzcyAo
InBhbmljIj8gIm9vcHMiPw0KPiA+ID4gPiA+ID4gIm92ZXJmbG93Ij8NCj4gPiA+ID4gPiA+IGV0
YykuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBJIGFtIG5vdCBhZ2FpbnN0
IEFVVE9TRUwgaW4gZ2VuZXJhbCwgYXMgbG9uZyBhcyB0aGUgZGVjaXNpb24NCj4gPiA+ID4gPiB0
bw0KPiA+ID4gPiA+IGtub3cNCj4gPiA+ID4gPiBob3cgZmFyIGJhY2sgaXQgaXMgYWxsb3dlZCB0
byB0YWtlIGEgcGF0Y2ggaXMgbWFkZQ0KPiA+ID4gPiA+IGRldGVybWluaXN0aWNhbGx5DQo+ID4g
PiA+ID4gYW5kIG5vdCBzdGF0aXN0aWNhbGx5IGJhc2VkIG9uIHNvbWUgQUkgaHVuY2guDQo+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gQW55IGF1dG8gc2VsZWN0aW9uIGZvciBhIHBhdGNoIHdpdGhvdXQg
YSBGaXhlcyB0YWdzIGNhbiBiZQ0KPiA+ID4gPiA+IGNhdGFzdHJvcGhpYw0KPiA+ID4gPiA+IC4u
IGltYWdpbmUgYSBwYXRjaCB3aXRob3V0IGEgRml4ZXMgVGFnIHdpdGggYSBzaW5nbGUgbGluZQ0K
PiA+ID4gPiA+IHRoYXQgaXMNCj4gPiA+ID4gPiBmaXhpbmcgc29tZSAib29wcyIsIHN1Y2ggcGF0
Y2ggY2FuIGJlIGVhc2lseSBhcHBsaWVkIGNsZWFubHkNCj4gPiA+ID4gPiB0bw0KPiA+ID4gPiA+
IHN0YWJsZS0NCj4gPiA+ID4gPiB2LnggYW5kIHN0YWJsZS12LnkgLi4gd2hpbGUgaXQgZml4ZXMg
dGhlIGlzc3VlIG9uIHYueCBpdA0KPiA+ID4gPiA+IG1pZ2h0DQo+ID4gPiA+ID4gaGF2ZQ0KPiA+
ID4gPiA+IGNhdGFzdHJvcGhpYyByZXN1bHRzIG9uIHYueSAuLg0KPiA+ID4gPiANCj4gPiA+ID4g
SSB0cmllZCB0byBpbWFnaW5lIHN1Y2ggZmxvdyBhbmQgZmFpbGVkIHRvIGRvIHNvLiBBcmUgeW91
DQo+ID4gPiA+IHRhbGtpbmcNCj4gPiA+ID4gYWJvdXQNCj4gPiA+ID4gYW55dGhpbmcgc3BlY2lm
aWMgb3IgaW1hZ2luYXJ5IGNhc2U/DQo+ID4gPiANCj4gPiA+IEl0IGhhcHBlbnMsIHJhcmVseSwg
YnV0IGl0IGRvZXMuIEhvd2V2ZXIsIGFsbCB0aGUgY2FzZXMgSSBjYW4NCj4gPiA+IHRoaW5rDQo+
ID4gPiBvZg0KPiA+ID4gaGFwcGVuZWQgd2l0aCBhIHN0YWJsZSB0YWdnZWQgY29tbWl0IHdpdGhv
dXQgYSBmaXhlcyB3aGVyZSBpdCdzDQo+ID4gPiBiYWNrcG9ydA0KPiA+ID4gdG8gYW4gb2xkZXIg
dHJlZSBjYXVzZWQgdW5pbnRlbmRlZCBiZWhhdmlvciAobG9jYWwgZGVuaWFsIG9mDQo+ID4gPiBz
ZXJ2aWNlDQo+ID4gPiBpbg0KPiA+ID4gb25lIGNhc2UpLg0KPiA+ID4gDQo+ID4gPiBUaGUgc2Nl
bmFyaW8geW91IGhhdmUgaW4gbWluZCBpcyB0cnVlIGZvciBib3RoIHN0YWJsZSBhbmQgbm9uLQ0K
PiA+ID4gc3RhYmxlDQo+ID4gPiB0YWdnZWQgcGF0Y2hlcywgc28gaXQgeW91IHdhbnQgdG8gcmVz
dHJpY3QgaG93IHdlIGRlYWwgd2l0aA0KPiA+ID4gY29tbWl0cw0KPiA+ID4gdGhhdA0KPiA+ID4g
ZG9uJ3QgaGF2ZSBhIGZpeGVzIHRhZyBzaG91bGRuJ3QgaXQgYmUgdHJ1ZSBmb3IgKmFsbCogY29t
bWl0cz8NCj4gPiANCj4gPiBBbGwgY29tbWl0cz8gZXZlbiB0aGUgb25lcyB3aXRob3V0ICJvb3Bz
IiBpbiB0aGVtID8gd2hlcmUgZG9lcyB0aGlzDQo+ID4gc3RvcCA/IDopDQo+ID4gV2UgX211c3Rf
IGhhdmUgYSBoYXJkIGFuZCBkZXRlcm1pbmlzdGljIGN1dCBmb3IgaG93IGZhciBiYWNrIHRvDQo+
ID4gdGFrZSBhDQo+ID4gcGF0Y2ggYmFzZWQgb24gYSBodW1hbiBkZWNpc2lvbi4uIHVubGVzcyB3
ZSBhcmUgMTAwJSBwb3NpdGl2ZQ0KPiA+IGF1dG9zZWxlY3Rpb24gQUkgY2FuIG5ldmVyIG1ha2Ug
YSBtaXN0YWtlLg0KPiA+IA0KPiA+IEh1bWFucyBhcmUgYWxsb3dlZCB0byBtYWtlIG1pc3Rha2Vz
LCBBSSBpcyBub3QuDQo+IA0KPiBPaCBJJ20gcmV2aWV3aW5nIGFsbCBwYXRjaGVzIG15c2VsZiBh
ZnRlciB0aGUgYm90IGRvZXMgaXQncw0KPiBzZWxlY3Rpb24sDQo+IHlvdSBjYW4gYmxhbWUgbWUg
Zm9yIHRoZXNlIHNjcmV3IHVwcy4NCj4gDQo+ID4gSWYgYSBGaXhlcyB0YWcgaXMgd3JvbmcsIHRo
ZW4gYSBodW1hbiB3aWxsIGJlIGJsYW1lZCwgYW5kIHRoYXQgaXMNCj4gPiBwZXJmZWN0bHkgZmlu
ZSwgYnV0IGlmIHdlIGhhdmUgc29tZSBzdGF0aXN0aWNhbCBtb2RlbCB0aGF0IHdlIGtub3cNCj4g
PiBpdA0KPiA+IGlzIGdvaW5nIHRvIGJlIHdyb25nIDAuMDAxJSBvZiB0aGUgdGltZS4uIGFuZCB3
ZSBzdGlsbCBsZXQgaXQgcnVuLi4NCj4gPiB0aGVuIHNvbWV0aGluZyBuZWVkcyB0byBiZSBkb25l
IGFib3V0IHRoaXMuDQo+ID4gDQo+ID4gSSBrbm93IHRoZXJlIGFyZSBiZW5lZml0cyB0byBhdXRv
c2VsLCBidXQgb3ZlcnRpbWUsIGlmIHRoaXMgaXMgbm90DQo+ID4gYmVpbmcgYXVkaXRlZCwgbWFu
eSBwaWVjZXMgb2YgdGhlIGtlcm5lbCB3aWxsIGdldCBicm9rZW4gdW5ub3RpY2VkDQo+ID4gdW50
aWwgc29tZSBwb29yIGRpc3RybyBkZWNpZGVzIHRvIHVwZ3JhZGUgdGhlaXIga2VybmVsIHZlcnNp
b24uDQo+IA0KPiBRdWl0ZSBhIGZldyBkaXN0cm9zIGFyZSBhbHdheXMgcnVubmluZyBvbiB0aGUg
bGF0ZXN0IExUUyByZWxlYXNlcywNCj4gQW5kcm9pZCBpc24ndCB0aGF0IGZhciBiZWhpbmQgZWl0
aGVyIGF0IHRoaXMgcG9pbnQuDQo+IA0KPiBUaGVyZSBhcmUgYWN0dWFsbHkgdmVyeSBmZXcgbm9u
LUxUUyB1c2VycyBhdCB0aGlzIHBvaW50Li4uDQo+IA0KPiA+ID4gPiA8Li4uPg0KPiA+ID4gPiA+
ID4gTGV0IG1lIHB1dCBteSBNaWNyb3NvZnQgZW1wbG95ZWUgaGF0IG9uIGhlcmUuIFdlIGhhdmUN
Cj4gPiA+ID4gPiA+IGRyaXZlci9uZXQvaHlwZXJ2Lw0KPiA+ID4gPiA+ID4gd2hpY2ggZGVmaW5p
dGVseSB3YXNuJ3QgZ2V0dGluZyBhbGwgdGhlIGZpeGVzIGl0IHNob3VsZA0KPiA+ID4gPiA+ID4g
aGF2ZQ0KPiA+ID4gPiA+ID4gYmVlbg0KPiA+ID4gPiA+ID4gZ2V0dGluZyB3aXRob3V0IEFVVE9T
RUwuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiANCj4gPiA+ID4gPiB1bnRpbCBzb21lIHBhdGNo
IHdoaWNoIHNob3VsZG4ndCBnZXQgYmFja3BvcnRlZCBzbGlwcw0KPiA+ID4gPiA+IHRocm91Z2gs
DQo+ID4gPiA+ID4gYmVsaWV2ZQ0KPiA+ID4gPiA+IG1lIHRoaXMgd2lsbCBoYXBwZW4sIGp1c3Qg
Z2l2ZSBpdCBzb21lIHRpbWUgLi4NCj4gPiA+ID4gDQo+ID4gPiA+IEJ1Z3MgYXJlIGluZXZpdGFi
bGUsIEkgZG9uJ3Qgc2VlIG1hbnkgZGlmZmVyZW5jZXMgYmV0d2VlbiBidWdzDQo+ID4gPiA+IGlu
dHJvZHVjZWQgYnkgbWFudWFsbHkgY2hlcnJ5LXBpY2tpbmcgb3IgYXV0b21hdGljYWxseSBvbmUu
DQo+ID4gPiANCj4gPiA+IE9oIGJ1Z3Mgc2xpcCBpbiwgdGhhdCdzIHdoeSBJIHRyYWNrIGhvdyBt
YW55IGJ1Z3Mgc2xpcHBlZCB2aWENCj4gPiA+IHN0YWJsZQ0KPiA+ID4gdGFnZ2VkIGNvbW1pdHMg
dnMgbm9uLXN0YWJsZSB0YWdnZWQgb25lcywgYW5kIHRoZSBzdGF0aXN0aWMgbWF5DQo+ID4gPiBz
dXJwcmlzZQ0KPiA+ID4geW91Lg0KPiA+ID4gDQo+ID4gDQo+ID4gU3RhdGlzdGljcyBkbyBub3Qg
bWF0dGVyIGhlcmUsIHdoYXQgcmVhbGx5IG1hdHRlcnMgaXMgdGhhdCB0aGVyZSBpcw0KPiA+IGEN
Cj4gPiBwb3NzaWJpbGl0eSBvZiBhIG5vbi1odW1hbiBpbmR1Y2VkIGVycm9yLCB0aGlzIHNob3Vs
ZCBiZSBhIG5vIG5vLg0KPiA+IG9yIGF0IGxlYXN0IG1ha2UgaXQgYW4gb3B0LWluIHRoaW5nIGZv
ciB0aG9zZSB3aG8gd2FudCB0byB0YWtlDQo+ID4gdGhlaXINCj4gPiBjaGFuY2VzIGFuZCBrZWVw
IGEgY2xvc2UgZXllIG9uIGl0Li4NCj4gDQo+IEhybSwgd2h5PyBQcmV0ZW5kIHRoYXQgdGhlIGJv
dCBpcyBhIGh1bWFuIHNpdHRpbmcgc29tZXdoZXJlIHNlbmRpbmcNCj4gbWFpbHMgb3V0LCBob3cg
ZG9lcyBpdCBjaGFuZ2UgYW55dGhpbmc/DQo+IA0KDQpJZiBpIGtub3cgYSBib3QgbWlnaHQgZG8g
c29tZXRoaW5nIHdyb25nLCBpIEZpeCBpdCBhbmQgbWFrZSBzdXJlIGl0DQp3aWxsIG5ldmVyIGRv
IGl0IGFnYWluLiBGb3IgaHVtYW5zIGkganVzdCBjYW4ndCBkbyB0aGF0LCBjYW4gSSA/IDopDQpz
byB0aGlzIGlzIHRoZSBkaWZmZXJlbmNlIGFuZCB3aHkgd2UgYWxsIGhhdmUgam9icyAuLiANCg0K
PiA+ID4gVGhlIHNvbHV0aW9uIGhlcmUgaXMgdG8gYmVlZiB1cCB5b3VyIHRlc3RpbmcgaW5mcmFz
dHJ1Y3R1cmUNCj4gPiA+IHJhdGhlcg0KPiA+ID4gdGhhbg0KPiA+IA0KPiA+IFNvIHBsZWFzZSBs
ZXQgbWUgb3B0LWluIHVudGlsIEkgYmVlZiB1cCBteSB0ZXN0aW5nIGluZnJhLg0KPiANCj4gQWxy
ZWFkeSBkaWQgOikNCg0KTm8geW91IGRpZG4ndCA6KSwgSSByZWNlaXZlZCBtb3JlIHRoYW4gNSBB
VVRPU0VMIGVtYWlscyBvbmx5IHRvZGF5IGFuZA0KeWVzdGVyZGF5Lg0KDQpQbGVhc2UgZG9uJ3Qg
b3B0IG1seDUgb3V0IGp1c3QgeWV0IDstKSwgaSBuZWVkIHRvIGRvIHNvbWUgbW9yZSByZXNlYXJj
aA0KYW5kIG1ha2UgdXAgbXkgbWluZC4uDQoNCj4gDQo+ID4gPiB0YWtpbmcgbGVzcyBwYXRjaGVz
OyB3ZSBzdGlsbCB3YW50IHRvIGhhdmUgKmFsbCogdGhlIGZpeGVzLA0KPiA+ID4gcmlnaHQ/DQo+
ID4gPiANCj4gPiANCj4gPiBpZiB5b3UgY2FuIGJlIHN1cmUgMTAwJSBpdCBpcyB0aGUgcmlnaHQg
dGhpbmcgdG8gZG8sIHRoZW4geWVzLA0KPiA+IHBsZWFzZQ0KPiA+IGRvbid0IGhlc2l0YXRlIHRv
IHRha2UgdGhhdCBwYXRjaCwgZXZlbiB3aXRob3V0IGFza2luZyBhbnlvbmUgISENCj4gPiANCj4g
PiBBZ2FpbiwgSHVtYW5zIGFyZSBhbGxvd2VkIHRvIG1ha2UgbWlzdGFrZXMuLiBBSSBpcyBub3Qu
DQo+IA0KPiBBZ2Fpbiwgd2h5Pw0KPiANCg0KQmVjYXVzZSBBSSBpcyBub3QgdGhlcmUgeWV0Li4g
YW5kIHRoaXMgaXMgYSB2ZXJ5IGJpZyBwaGlsb3NvcGhpY2FsDQpxdWVzdGlvbi4NCg0KTGV0IG1l
IHNpbXBsaWZ5OiB0aGVyZSBpcyBhIGJ1ZyBpbiB0aGUgQUksIHdoZXJlIGl0IGNhbiBjaG9vc2Ug
YSB3cm9uZw0KcGF0Y2gsIGxldCdzIGZpeCBpdC4NCg0KDQoNCg0K

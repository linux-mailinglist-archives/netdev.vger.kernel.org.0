Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37ECC1AB684
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 06:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgDPEIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 00:08:20 -0400
Received: from mail-eopbgr40054.outbound.protection.outlook.com ([40.107.4.54]:33670
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726409AbgDPEIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 00:08:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpnU92wM+N5dzM6Sj/A9HNiwvfs2YxElNqPTH85To9OhirHzD+WitqtKtDcvkc9sGRrOp/Eyh8RFOhf1VUBnE6lRnT0E2+i2Fepfd+6KERi8+SdVLUIr5NtPCz0fvWKY1ktNb0ilZZ+ZyvJCOw5gt25uoKyPjZ9UB+7JTpcX0vTZ66hvd0rHpk7xcjqZ9uDqkbK0zxLNyjB/NXQ9RbuqYWiQAPVmCF8QHgOq6Vf0wMBtmS6D8FjCZUCrzskqyryMQuOaTuI14iyyq3kQShfDOykkF+ZL3PFiaxPchliyV/ci00H8W7+KksQBU4JjOnBbWQ2cOgfZukN5YpCxxHcXcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggajgpJuW8jNjPMB55RcgOwUCZTGZxJwHlYdB/QGiRQ=;
 b=fXVx+9hEYF0IXUnTJWuZut02pUSLOIkcQZGrU9JCcMfjxGLjAWw2/sUhdvGPUpEEz1syAfGL2hik9+ms/Ep6laeQTGKd6trl1eOyKi3r/ORIgP57OoYXR0CYr8MbgwnQzpEVInjyoMnjWGNUBfx52zOOVsnibZTidSDNRSokPpDyT2RQ2O1Yg/a6ER13EyGam7v/nkdnzgJXjurPNys+eo0D8xBtWEH/s7GDP4O5sDt5yB1HswQzs/2vf5sBf4NO91wXNR74ZuPz4V9HW/X4Vj+Y5dCk/TySY2Ci66v+XYOto+LeqqdayMpJBSqJ3N2YpGkPg9jUsVrAoLuXXV8Jjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggajgpJuW8jNjPMB55RcgOwUCZTGZxJwHlYdB/QGiRQ=;
 b=AZCj/CgoIeYlxfu7Acuo1QMXQ9PjsVbXv5MVYQoB+7Yndbm2+eR2cKqZr2LF0vfy3uJYVuF5rcaboWcbP/t1qA2bqoKXZHMfMQghGNwh3Tjw+jmQa5P3EUH1V3OUBYaxReNI3dnR/kwvLWOf8L8eAioDvcsmVO2bMx4Gj4YNuR4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6126.eurprd05.prod.outlook.com (2603:10a6:803:ed::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Thu, 16 Apr
 2020 04:08:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.028; Thu, 16 Apr 2020
 04:08:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "ecree@solarflare.com" <ecree@solarflare.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Topic: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Index: AQHWEFb6WRVOJO0/j0GE4IB+QkA/0qh1Ei4AgAC1ZICAAheSAIAAjYWAgAAM6ICAADp+AIAAE8gAgABWOICAAURNAIAAgPKAgABFSIA=
Date:   Thu, 16 Apr 2020 04:08:10 +0000
Message-ID: <434329130384e656f712173558f6be88c4c57107.camel@mellanox.com>
References: <20200411231413.26911-9-sashal@kernel.org>
         <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
         <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20200414015627.GA1068@sasha-vm>
         <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
         <20200414110911.GA341846@kroah.com>
         <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
         <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
         <20200414205755.GF1068@sasha-vm>
         <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
         <20200416000009.GL1068@sasha-vm>
In-Reply-To: <20200416000009.GL1068@sasha-vm>
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
x-ms-office365-filtering-correlation-id: 16a5c6a2-959a-4d2c-c450-08d7e1bbc69a
x-ms-traffictypediagnostic: VI1PR05MB6126:
x-microsoft-antispam-prvs: <VI1PR05MB612669B6695C82B6E4F7CBB3BED80@VI1PR05MB6126.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0375972289
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(86362001)(66946007)(91956017)(316002)(66476007)(76116006)(64756008)(81156014)(8676002)(8936002)(66446008)(5660300002)(45080400002)(478600001)(6486002)(966005)(6512007)(36756003)(4326008)(71200400001)(6506007)(186003)(26005)(2906002)(66556008)(53546011)(2616005)(54906003)(110136005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EWgBELD0lPRv9VZXBpSWTGUkcAs/4zOifpa2GBd84eVAdej69sJudZat5c4hnWPP6dMHl0gZ1vxv1f0QU2WA4kczalMoozWW8mgtpZ9CsHoIiszy4icyTIDSEsXP7pOXzBo+SL70MYm68aJpl53O7RyqbLaSkwx6Q+9bOuRuQpk//w0pw8HveYFJ8d47TegsXEhWp2T3jLLU+tlD/Z1f9cOGom/EVoslwjlvREMLSrIRJTYR0wFkwvFh3zc4Lp0WBb7JoeZEsWPZp1Ks6xqahWS/tEkDG0S5fcvl/pGSCaT++l0nXuJamDbSdcXzTpCFnzit1IwtwQXm/F68D09HFhtsy/0A5zM2VdS4CqrZ/jr5cnGEbHAP0SXleeBcXVAKTFbcyyX33VO1LKpx6tgmTFhjNM74PXvJRDDaSoFxf3CVBor2LkyCSuwVBO8nWkS9Bg1dQjq5P1oNpp0CvgAXEbWGHiJarZxyz1l1btu0F+SQ4OXzW245rHD0WTPxy8UgJtjaxRYly1BryYDKO1vP5Q==
x-ms-exchange-antispam-messagedata: EYNPRnP3sg+iG0ZKWZcvJ6MYhCR+EZgwBTW7piwoU/O+bwHqlnGvJqSAh/jajcA5TiYN1lYTG1li+ngOm+Utb4B9lfnVJT4QT88goYGj1NWoEggB/SCQW1hl+Rb+oZz0noQpbN2eC8PbI5/zIpTUHA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB68FDBC93E4D147AE6F2FADFEAE5C2B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a5c6a2-959a-4d2c-c450-08d7e1bbc69a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2020 04:08:10.1721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A4RUOwBGqKycuHx0oRTu38NN3pVs2I3GW0Z7NDldaJMy9n7KHZivKBQ38JEwaM3jhCMRub6F4Tquebioz0NRjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA0LTE1IGF0IDIwOjAwIC0wNDAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4g
T24gV2VkLCBBcHIgMTUsIDIwMjAgYXQgMDU6MTg6MzhQTSArMDEwMCwgRWR3YXJkIENyZWUgd3Jv
dGU6DQo+ID4gRmlyc3RseSwgbGV0IG1lIGFwb2xvZ2lzZTogbXkgcHJldmlvdXMgZW1haWwgd2Fz
IHRvbyBoYXJzaCBhbmQgdG9vDQo+ID4gIGFzc2VydGl2ZWFib3V0IHRoaW5ncyB0aGF0IHdlcmUg
cmVhbGx5IG1vcmUgdW5jZXJ0YWluIGFuZCB1bmNsZWFyLg0KPiA+IA0KPiA+IE9uIDE0LzA0LzIw
MjAgMjE6NTcsIFNhc2hhIExldmluIHdyb3RlOg0KPiA+ID4gSSd2ZSBwb2ludGVkIG91dCB0aGF0
IGFsbW9zdCA1MCUgb2YgY29tbWl0cyB0YWdnZWQgZm9yIHN0YWJsZSBkbw0KPiA+ID4gbm90DQo+
ID4gPiBoYXZlIGEgZml4ZXMgdGFnLCBhbmQgeWV0IHRoZXkgYXJlIGZpeGVzLiBZb3UgcmVhbGx5
IGRlZHVjZQ0KPiA+ID4gdGhpbmdzIGJhc2VkDQo+ID4gPiBvbiBjb2luIGZsaXAgcHJvYmFiaWxp
dHk/DQo+ID4gWWVzLCBidXQgZmFyIGxlc3MgdGhhbiA1MCUgb2YgY29tbWl0cyAqbm90KiB0YWdn
ZWQgZm9yIHN0YWJsZSBoYXZlDQo+ID4gYSBmaXhlcw0KPiA+ICB0YWcuICBJdCdzIG5vdCBhYm91
dCBoYXJkLWFuZC1mYXN0IEFyaXN0b3RlbGlhbiAiZGVkdWN0aW9ucyIsIGxpa2UNCj4gPiAidGhp
cw0KPiA+ICBkb2Vzbid0IGhhdmUgRml4ZXM6LCB0aGVyZWZvcmUgaXQgaXMgbm90IGEgc3RhYmxl
IGNhbmRpZGF0ZSIsIGl0J3MNCj4gPiBhYm91dA0KPiA+ICBwcm9iYWJpbGlzdGljICJpbmR1Y3Rp
b24iLg0KPiA+IA0KPiA+ID4gIml0IGRvZXMgaW5jcmVhc2UgdGhlIGFtb3VudCBvZiBjb3VudGVy
dmFpbGluZyBldmlkZW5jZSBuZWVkZWQgdG8NCj4gPiA+IGNvbmNsdWRlIGEgY29tbWl0IGlzIGEg
Zml4IiAtIFBsZWFzZSBleHBsYWluIHRoaXMgYXJndW1lbnQgZ2l2ZW4NCj4gPiA+IHRoZQ0KPiA+
ID4gYWJvdmUuDQo+ID4gQXJlIHlvdSBmYW1pbGlhciB3aXRoIEJheWVzaWFuIHN0YXRpc3RpY3M/
ICBJZiBub3QsIEknZCBzdWdnZXN0DQo+ID4gcmVhZGluZw0KPiA+ICBzb21ldGhpbmcgbGlrZSBo
dHRwOi8veXVka293c2t5Lm5ldC9yYXRpb25hbC9iYXllcy8gd2hpY2ggZXhwbGFpbnMNCj4gPiBp
dC4NCj4gPiBUaGVyZSdzIGEgYmlnIGRpZmZlcmVuY2UgYmV0d2VlbiBhIGNvaW4gZmxpcCBhbmQg
YSBfY29ycmVsYXRlZF8NCj4gPiBjb2luIGZsaXAuDQo+IA0KPiBJJ2QgbWF5YmUgcG9pbnQgb3V0
IHRoYXQgdGhlIHNlbGVjdGlvbiBwcm9jZXNzIGlzIGJhc2VkIG9uIGEgbmV1cmFsDQo+IG5ldHdv
cmsgd2hpY2gga25vd3MgYWJvdXQgdGhlIGV4aXN0ZW5jZSBvZiBhIEZpeGVzIHRhZyBpbiBhIGNv
bW1pdC4NCj4gDQo+IEl0IGRvZXMgZXhhY3RseSB3aGF0IHlvdSdyZSBkZXNjcmliaW5nLCBidXQg
YWxzbyB0YWtpbmcgYSBidW5jaCBtb3JlDQo+IGZhY3RvcnMgaW50byBpdCdzIGRlc2ljaW9uIHBy
b2Nlc3MgKCJwYW5pYyI/ICJvb3BzIj8gIm92ZXJmbG93Ij8NCj4gZXRjKS4NCj4gDQoNCkkgYW0g
bm90IGFnYWluc3QgQVVUT1NFTCBpbiBnZW5lcmFsLCBhcyBsb25nIGFzIHRoZSBkZWNpc2lvbiB0
byBrbm93DQpob3cgZmFyIGJhY2sgaXQgaXMgYWxsb3dlZCB0byB0YWtlIGEgcGF0Y2ggaXMgbWFk
ZSBkZXRlcm1pbmlzdGljYWxseQ0KYW5kIG5vdCBzdGF0aXN0aWNhbGx5IGJhc2VkIG9uIHNvbWUg
QUkgaHVuY2guDQoNCkFueSBhdXRvIHNlbGVjdGlvbiBmb3IgYSBwYXRjaCB3aXRob3V0IGEgRml4
ZXMgdGFncyBjYW4gYmUgY2F0YXN0cm9waGljDQouLiBpbWFnaW5lIGEgcGF0Y2ggd2l0aG91dCBh
IEZpeGVzIFRhZyB3aXRoIGEgc2luZ2xlIGxpbmUgdGhhdCBpcw0KZml4aW5nIHNvbWUgIm9vcHMi
LCBzdWNoIHBhdGNoIGNhbiBiZSBlYXNpbHkgYXBwbGllZCBjbGVhbmx5IHRvIHN0YWJsZS0NCnYu
eCBhbmQgc3RhYmxlLXYueSAuLiB3aGlsZSBpdCBmaXhlcyB0aGUgaXNzdWUgb24gdi54IGl0IG1p
Z2h0IGhhdmUNCmNhdGFzdHJvcGhpYyByZXN1bHRzIG9uIHYueSAuLiANCg0KaWYgeW91IHdhbnQg
dGhlc2UgZmFjdG9ycyB0byBrZWVwIHBsYXlpbmcgYSByb2xlIGluIHRoZSBhdXRvc2VsDQpwcm9j
ZXNzLCB0aGVuIGEgaHVtYW4gZmFjdG9yIG9yIHNvbWUgZGV0ZXJtaW5pc3RpYyB0ZXN0aW5nL2Nv
ZGUNCmNvdmVyYWdlIHN0ZXAgbXVzdCB0YWtlIGFjdGlvbiBiZWZvcmUgYmFja3BvcnRpbmcgc3Vj
aCBwYXRjaCBvbiB0aGUNCmJsaW5kLgkNCg0KV2hhdCBpIHdvdWxkIHN1Z2dlc3QgaGVyZTogRm9y
IHBhdGNoZXMgdGhhdCBhcmUgbWlzc2luZyBhIEZpeGVzIHRhZywNCnRoZXkgc2hvdWxkIGJlIGNv
bnNpZGVyZWQgYXMgYSAiY2FuZGlkYXRlIiBmb3IgYXV0b3NlbCwgYW5kIGRvbid0DQphY3R1YWxs
eSBhcHBseSB0aGVtIHVudGlsIGFuIGV4cGxpY2l0IEFDSyBmcm9tIHNvbWUgaHVtYW4vcmVncmVz
c2lvbg0KdGVzdCBmYWN0b3IgaXMgcmVjZWl2ZWQuIA0KDQo+ID4gPiBUaGlzIGlzIGdyZWF0LCBi
dXQgdGhlIGtlcm5lbCBpcyBtb3JlIHRoYW4ganVzdCBuZXQvLiBOb3RlIHRoYXQgSQ0KPiA+ID4g
YWxzbw0KPiA+ID4gZG8gbm90IGxvb2sgYXQgbmV0LyBpdHNlbGYsIGJ1dCByYXRoZXIgZHJpdmVy
cy9uZXQvIGFzIHRob3NlIGVuZA0KPiA+ID4gdXAgd2l0aA0KPiA+ID4gYSBidW5jaCBvZiBtaXNz
ZWQgZml4ZXMuDQo+ID4gZHJpdmVycy9uZXQvIGdvZXMgdGhyb3VnaCB0aGUgc2FtZSBEYXZlTSBu
ZXQvbmV0LW5leHQgdHJlZXMsIHdpdGgNCj4gPiB0aGUNCj4gPiAgc2FtZSBydWxlcy4NCj4gDQo+
IExldCBtZSBwdXQgbXkgTWljcm9zb2Z0IGVtcGxveWVlIGhhdCBvbiBoZXJlLiBXZSBoYXZlDQo+
IGRyaXZlci9uZXQvaHlwZXJ2Lw0KPiB3aGljaCBkZWZpbml0ZWx5IHdhc24ndCBnZXR0aW5nIGFs
bCB0aGUgZml4ZXMgaXQgc2hvdWxkIGhhdmUgYmVlbg0KPiBnZXR0aW5nIHdpdGhvdXQgQVVUT1NF
TC4NCj4gDQoNCnVudGlsIHNvbWUgcGF0Y2ggd2hpY2ggc2hvdWxkbid0IGdldCBiYWNrcG9ydGVk
IHNsaXBzIHRocm91Z2gsIGJlbGlldmUNCm1lIHRoaXMgd2lsbCBoYXBwZW4sIGp1c3QgZ2l2ZSBp
dCBzb21lIHRpbWUgLi4gDQoNCj4gV2hpbGUgbmV0LyBpcyBkb2luZyBncmVhdCwgZHJpdmVycy9u
ZXQvIGlzIG5vdC4gSWYgaXQncyBpbmRlZWQNCj4gZm9sbG93aW5nDQo+IHRoZSBzYW1lIHJ1bGVz
IHRoZW4gd2UgbmVlZCB0byB0YWxrIGFib3V0IGhvdyB3ZSBnZXQgZG9uZSByaWdodC4NCj4gDQoN
CmJvdGggbmV0IGFuZCBkcml2ZXJzL25ldCBhcmUgbWFuYWdlZCBieSB0aGUgc2FtZSBtYWl0YWlu
ZXIgYW5kIGZvbGxvdw0KdGhlIHNhbWUgcnVsZXMsIGNhbiB5b3UgZWxhYm9yYXRlIG9uIHRoZSBk
aWZmZXJlbmNlID8NCg0KPiBJIHJlYWxseSBoYXZlIG5vIG9iamVjdGlvbiB0byBub3QgbG9va2lu
ZyBpbiBkcml2ZXJzL25ldC8sIGl0J3MganVzdA0KPiB0aGF0IHRoZSBleHBlcmllbmNlIEkgaGFk
IHdpdGggdGhlIHByb2Nlc3Mgc3VnZ2VzdHMgdGhhdCBpdCdzIG5vdA0KPiBmb2xsb3dpbmcgdGhl
IHNhbWUgcHJvY2VzcyBhcyBuZXQvLg0KPiANCg==

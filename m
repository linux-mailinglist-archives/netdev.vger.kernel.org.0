Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1F323A854
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHCOXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:23:24 -0400
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:60566
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726358AbgHCOXY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 10:23:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIk01tbTgkMZCiDsXdNx91RqfSM2XDUsVmqWuEdtIcjcrv+tykq9JWgAZcIJDq2eFzzdh5upPWj/sZRx39ZNj6aclMJB6Wq6c6BMmwDGhGszdrS0Tzt7Fmg/EE9MtB43DzZAuGmzPH4AoCkbbuYgcoyUl/mtBABPHXlckh+r+zty+e7wHLJec2XBHHvCii2+fnX5GYG72AjDWfPsZAgI7bFXOu6YY17IPnl1R3APvB+wbX5bJXMddFzKOSc4lv7Jnf1e3Spph9+KLsTRylOGKI7j9u3btSocujTBQSH5eQjrv69LEY9tEThClJwRVx99tgnDaU8WSuQPyCZ3YvDyjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/L6T9bxJEW0O5paBGI6UD7BHxUFW3/Akp4i9M62WxA=;
 b=hIoF666uTY9+I31F7ZgiiS6VJ11+cNdQxzyXof+ZkjX8C+FF+p+xYL7z78Gxf3pQcbT2hX1TaHVLrs8ljSgRJy5eEcotP2iG3qRTCA+TcSfNyFx5ya06m0L2YsI+ZWOBJ4KusWfqaUPP8xlB92qM+cmy60vm1HKiticb9LxQSP6kllXnhjsUMVOrtBF0DlUdLPRXvF9L7GEUlloMfRaSAWocYPaydkCw+h5EEC1l+6mlCwy3PF0mCTcVLLHa9b1zZ4zU3M/42CJz2J4OkydQTbnSylwrahJIuK3FdrREIUKIqJeDQW8lcHmeuOQdk8pdiPoNfur/2x2EQA++KN8U9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/L6T9bxJEW0O5paBGI6UD7BHxUFW3/Akp4i9M62WxA=;
 b=kjeHKcdlLD6IXLUaBPYNBVu87XfawcdPnah26JStUjYFCF1ZRrnyUUod8uc0n4Dl0hlTPLkSgZujmZlPllLCMbX73osEB1qDTy4kSjNyY0xBz7XRwxMLs8YIaSudQeWX2TvBETGl00fx8nVUF70sDkWQUj0Zw6J7EVuBae+WrS8=
Received: from VI1PR05MB4110.eurprd05.prod.outlook.com (2603:10a6:803:3f::23)
 by VE1PR05MB7184.eurprd05.prod.outlook.com (2603:10a6:800:1a5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Mon, 3 Aug
 2020 14:23:19 +0000
Received: from VI1PR05MB4110.eurprd05.prod.outlook.com
 ([fe80::c19b:54d7:a861:2a88]) by VI1PR05MB4110.eurprd05.prod.outlook.com
 ([fe80::c19b:54d7:a861:2a88%4]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 14:23:19 +0000
From:   Asmaa Mnebhi <Asmaa@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     David Thompson <dthompson@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>, Jiri Pirko <jiri@mellanox.com>
Subject: RE: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Thread-Topic: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Thread-Index: AQHWZdY0iihhdKXIGkuYVb+rxnyJGKkh+DcAgAASKfCAABLjAIAAFqEggABCwgCABABYsA==
Date:   Mon, 3 Aug 2020 14:23:19 +0000
Message-ID: <VI1PR05MB41106AB40B9F26EE8F3ECD4EDA4D0@VI1PR05MB4110.eurprd05.prod.outlook.com>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
 <20200731174222.GE1748118@lunn.ch>
 <VI1PR05MB4110070900CF42CB3E18983EDA4E0@VI1PR05MB4110.eurprd05.prod.outlook.com>
 <20200731195458.GA1843538@lunn.ch>
 <VI1PR05MB4110ACD3FE86FD3DF5F59D84DA4E0@VI1PR05MB4110.eurprd05.prod.outlook.com>
 <20200801011454.GB1843538@lunn.ch>
In-Reply-To: <20200801011454.GB1843538@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [65.96.160.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f4be843c-9d7e-4753-4567-08d837b8c51a
x-ms-traffictypediagnostic: VE1PR05MB7184:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR05MB7184392F15937A265729D12FDA4D0@VE1PR05MB7184.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CUBrX/4JC9q57l/fltXRpASOuUVXAM1KnTi144C2busVIXq2Rytnu1lMQWDAMrIC5aUbW/9C4VH7XFc/EH4m2nzcW2Di30HloDlPwHgFQ/xZ1dbKBxbAbcmu/jWbb7BcV8pgyYPXgiyuMMA4pObkmkilf0+knJQaeUd6155MdDF4D2gCHLCW8G+l8OOHhBxNYOuI81pXNppmuIbIE6FT8xroNnJKfVk3a+sELqdmUUmzW/ceWafwUTl7wcuwlevueUoOGpg5hsbo5zpgIl1i2wD6otKvq57wVGRiY9kEZk/xXinbm65dCo3iopa+NKBxqDh+bIl7VD609jBM013Enw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4110.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(5660300002)(107886003)(6916009)(186003)(6506007)(9686003)(53546011)(26005)(55016002)(2906002)(8936002)(83380400001)(8676002)(478600001)(71200400001)(54906003)(7696005)(66556008)(66476007)(66946007)(316002)(86362001)(33656002)(76116006)(4326008)(66446008)(64756008)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: lfRmxa+NILOTNEgANTNBuBIrEaxx6MIGgQLSLPis7THMIVbuIM6gnGzL3GstHT4zb9W65aR7NAcTkc8efJXvX5jgSH8uEv5Gav19Nt4zedWdVPWDD5rkVMBCTnS8ol+LRN4fXgqhz/bDOF6E0IPgJtY1OPtRvKo2OLRUayspKwwFnLySGWy4mrRDnYG9hbOKsi+TgKTZz9acJEMO83xr9p37Z2yUi1+EPmVKcbhfJI1P0NKDWzkv96kTwQTiLL2gEhsjaPSPf7tbYql38wT1ORX8Fehfx98zd6dxsJy5sGhgBmEkrpzKb3bCT9Lc1bmoQsISOgHXw6XJn/SweeOgCS84p20lwiaPyWHcsasW3UrWj6BoDIwDlOEkMZVMNnjXcqrHoNjczHS2gs3oJxdimSeQMuEtF2N+H9ey30jaJE97uRJYDK+6DQFnhg3UCE3hm/aH+7+rj2wZWduBvDh7j+FNTcnYsUZM5bdtNC8aieevQu1qc+NOjvkBPKBWjOLwVCL+w5bEa5ADNY1u+PjrnWb5w9qN/tLQqlHpC1Z/Brp7n/DdPLtE8zHhrCCs98twK3IFBnv2bOzl8aMmZ1GEdXR4DL+mTrw0IoNz2Rnj3aki5qJY8FpFA4z4K9wZ62yIM1xG9Br343F7rBZ0tx9FoQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4110.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4be843c-9d7e-4753-4567-08d837b8c51a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 14:23:19.1869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +yUP+/pEbMIDm9vVGYmG7YUN993QdZPG+LPoOwayTcyDm7Faao0vMVkYFN3FIpyxFjDGdWmgPSPcNHYtXHxGLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR05MB7184
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IEx1bm4gPGFu
ZHJld0BsdW5uLmNoPg0KPiBTZW50OiBGcmlkYXksIEp1bHkgMzEsIDIwMjAgOToxNSBQTQ0KPiBU
bzogQXNtYWEgTW5lYmhpIDxBc21hYUBtZWxsYW5veC5jb20+DQo+IENjOiBEYXZpZCBUaG9tcHNv
biA8ZHRob21wc29uQG1lbGxhbm94LmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRh
dmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgSmlyaSBQaXJrbw0KPiA8amlyaUBt
ZWxsYW5veC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHRdIEFkZCBNZWxsYW5v
eCBCbHVlRmllbGQgR2lnYWJpdCBFdGhlcm5ldCBkcml2ZXINCj4gDQo+ID4gPiA+ID4gK3N0YXRp
YyBpbnQgbWx4YmZfZ2lnZV9tZGlvX3JlYWQoc3RydWN0IG1paV9idXMgKmJ1cywgaW50DQo+ID4g
PiA+ID4gK3BoeV9hZGQsIGludA0KPiA+ID4gPg0KPiA+ID4gPiA+ICtwaHlfcmVnKSB7DQo+ID4g
PiA+DQo+ID4gPiA+ID4gKyAgICAgICAgIHN0cnVjdCBtbHhiZl9naWdlICpwcml2ID0gYnVzLT5w
cml2Ow0KPiA+ID4gPg0KPiA+ID4gPiA+ICsgICAgICAgICB1MzIgY21kOw0KPiA+ID4gPg0KPiA+
ID4gPiA+ICsgICAgICAgICB1MzIgcmV0Ow0KPiA+ID4gPg0KPiA+ID4gPiA+ICsNCj4gPiA+ID4N
Cj4gPiA+ID4gPiArICAgICAgICAgLyogSWYgdGhlIGxvY2sgaXMgaGVsZCBieSBzb21ldGhpbmcg
ZWxzZSwgZHJvcCB0aGUgcmVxdWVzdC4NCj4gPiA+ID4NCj4gPiA+ID4gPiArICAgICAgICAgKiBJ
ZiB0aGUgbG9jayBpcyBjbGVhcmVkLCB0aGF0IG1lYW5zIHRoZSBidXN5IGJpdCB3YXMgY2xlYXJl
ZC4NCj4gPiA+ID4NCj4gPiA+ID4gPiArICAgICAgICAgKi8NCj4gPiA+ID4NCj4gPiA+ID4NCj4g
PiA+ID4NCj4gPiA+ID4gSG93IGNhbiB0aGlzIGhhcHBlbj8gVGhlIG1kaW8gY29yZSBoYXMgYSBt
dXRleCB3aGljaCBwcmV2ZW50cw0KPiA+ID4gPiBwYXJhbGxlbA0KPiA+ID4gYWNjZXNzPw0KPiA+
ID4gPg0KPiA+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiBUaGlzIGlzIGEgSFcgTG9jay4gSXQgaXMg
YW4gYWN0dWFsIHJlZ2lzdGVyLiBTbyBhbm90aGVyIEhXIGVudGl0eQ0KPiA+ID4gPiBjYW4gYmUg
aG9sZGluZyB0aGF0IGxvY2sgYW5kIHJlYWRpbmcvY2hhbmdpbmcgdGhlIHZhbHVlcyBpbiB0aGUg
SFcNCj4gcmVnaXN0ZXJzLg0KPiA+ID4NCj4gPiA+IFlvdSBoYXZlIG5vdCBleHBsYWlucyBob3cg
dGhhdCBjYW4gaGFwcGVuPyBJcyB0aGVyZSBzb21ldGhpbmcgaW4gdGhlDQo+ID4gPiBkcml2ZXIg
aSBtaXNzZWQgd2hpY2ggdGFrZXMgYSBiYWNrZG9vciB0byByZWFkL3dyaXRlIE1ESU8gdHJhbnNh
Y3Rpb25zPw0KPiA+DQo+ID4gQWggb2shIFRoZXJlIGlzIGEgSFcgZW50aXR5IChjYWxsZWQgWVUp
IHdpdGhpbiB0aGUgQmx1ZUZpZWxkIHdoaWNoIGlzDQo+IGNvbm5lY3RlZCB0byB0aGUgUEhZIGRl
dmljZS4NCj4gPiBJIHRoaW5rIHRoZSBZVSBpcyB3aGF0IHlvdSBhcmUgY2FsbGluZyAiYmFja2Rv
b3IiIGhlcmUuIFRoZSBZVQ0KPiA+IGNvbnRhaW5zIHNldmVyYWwgcmVnaXN0ZXJzIHdoaWNoIGNv
bnRyb2wgcmVhZHMvd3JpdGVzIFRvIHRoZSBQSFkuIFNvDQo+ID4gaXQgaXMgbGlrZSBhbiBleHRy
YSBsYXllciBmb3IgcmVhZGluZyBNRElPIHJlZ2lzdGVycy4gT25lIG9mIHRoZSBZVSByZWdpc3Rl
cnMgaXMNCj4gdGhlIGdhdGV3YXkgcmVnaXN0ZXIgKGFrYSBHVyBvciBNTFhCRl9HSUdFX01ESU9f
R1dfT0ZGU0VUIGluIHRoZQ0KPiBjb2RlKS4gSWYgdGhlIEdXIHJlZ2lzdGVyJ3MgTE9DSyBiaXQg
aXMgbm90IGNsZWFyZWQsIHdlIGNhbm5vdCB3cml0ZSBhbnl0aGluZw0KPiB0byB0aGUgYWN0dWFs
IFBIWSBNRElPIHJlZ2lzdGVycy4NCj4gPiBEaWQgSSBhbnN3ZXIgeW91ciBxdWVzdGlvbj8NCj4g
DQo+IE5vcGUuDQo+IA0KPiBIb3cgY2FuIHR3byB0cmFuc2FjdGlvbnMgaGFwcGVuIGF0IHRoZSBz
YW1lIHRpbWUsIGNhdXNpbmcgdGhpcyBsb2NrIGJpdCB0bw0KPiBiZSBsb2NrZWQ/IEdpdmVuIHRo
YXQgdGhlIE1ESU8gY29yZSBoYXMgYSBtdXRleCBhbmQgc2VyaWFsaXNlcyBhbGwNCj4gdHJhbnNh
Y3Rpb25zLiBIb3cgY2FuIHRoZSBsb2NrIGJpdCBldmVyeSBiZSBzZXQ/DQoNCkFoIEkgc2VlIHdo
YXQgeW91IGFyZSBzYXlpbmcuIFNXIHRha2VzIGNhcmUgb2YgaXQsIHNvIEhXIHdvdWxkIG5ldmVy
IGZhbGwgaW50byB0aGlzIHNjZW5hcmlvLiBUaGF0IHdpbGwgbWFrZSB0aGluZ3MgY2xlYW5lciBh
bmQgZmFzdGVyIHRoZW4hIE9rIHdpbGwgY2hhbmdlIGl0LCB0ZXN0IGl0IGFuZCByZXBvcnQgYmFj
ay4NCg0KPiANCj4gPiA+ID4gPiArICAgICAgICAgcmV0ID0gbWx4YmZfZ2lnZV9tZGlvX3BvbGxf
Yml0KHByaXYsDQo+ID4gPiA+ID4gKyBNTFhCRl9HSUdFX01ESU9fR1dfTE9DS19NQVNLKTsNCj4g
PiA+ID4NCj4gPiA+ID4gPiArICAgICAgICAgaWYgKHJldCkNCj4gPiA+ID4NCj4gPiA+ID4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gLUVCVVNZOw0KPiA+ID4gPg0KPiA+ID4gPg0K
PiA+ID4gPg0KPiA+ID4gPiBQSFkgZHJpdmVycyBhcmUgbm90IGdvaW5nIHRvIGxpa2UgdGhhdC4g
VGhleSBhcmUgbm90IGdvaW5nIHRvIHJldHJ5Lg0KPiA+ID4gPiBXaGF0IGlzIGxpa2VseSB0byBo
YXBwZW4gaXMgdGhhdCBwaHlsaWIgbW92ZXMgaW50byB0aGUgRVJST1INCj4gPiA+ID4gc3RhdGUs
IGFuZCB0aGUgUEhZIGRyaXZlciBncmluZHMgdG8gYSBoYWx0Lg0KPiA+ID4gPg0KPiA+ID4gPg0K
PiA+ID4gPg0KPiA+ID4gPiBUaGlzIGlzIGEgZmFpcmx5IHF1aWNrIEhXIHRyYW5zYWN0aW9uLiBT
byBJIGRvbuKAmXQgdGhpbmsgaXQgd291bGQNCj4gPiA+ID4gY2F1c2UgYW5kIGlzc3VlIGZvciB0
aGUgUEhZIGRyaXZlcnMuIEluIHRoaXMgY2FzZSwgd2UgdXNlIHRoZQ0KPiA+ID4gPiBtaWNyZWwg
S1NaOTAzMS4gV2UgaGF2ZW7igJl0IHNlZW4gaXNzdWVzLg0KPiA+ID4NCj4gPiA+IFNvIHlvdSBo
YXZlIGhhcHB5IHRvIGRlYnVnIGhhcmQgdG8gZmluZCBhbmQgcmVwcm9kdWNlIGlzc3VlcyB3aGVu
IGl0DQo+ID4gPiBkb2VzIGhhcHBlbj8gT3Igd291bGQgeW91IGxpa2UgdG8gc3BlbmQgYSBsaXR0
bGUgYml0IG9mIHRpbWUgbm93IGFuZA0KPiA+ID4ganVzdCBwcmV2ZW50IGl0IGhhcHBlbmluZyBh
dCBhbGw/DQo+ID4NCj4gPiBJIHRoaW5rIEkgbWlzdW5kZXJzdG9vZCB5b3VyIGNvbW1lbnQuIERp
ZCB5b3UgYXNrIHdoeSB3ZSBhcmUgcG9sbGluZw0KPiBoZXJlPyBPciB0aGF0IHdlIHNob3VsZG4n
dCBiZSByZXR1cm5pbmcgLUVCVVNZPw0KPiANCj4gSSB0aGluayB5b3Ugc2hvdWxkIG5vdCBiZSBy
ZXR1cm5pbmcgRUJVU1kuIElmIGl0IGV2ZXJ5IGhhcHBlbnMsIGJhZCB0aGluZ3Mgd2lsbA0KPiBo
YXBwZW4uDQo+IA0KPiBUaGlzIGxvY2sgYml0IHNlZW1zIHRvIHNlcnZlciBubyBwdXJwb3NlLiBT
b2Z0d2FyZSB3aWxsIGVuc3VyZSB0aGF0DQo+IHRyYW5zYWN0aW9ucyBhcmUgc2VyaWFsaXplZC4g
SWYgaXQgc2VydmVzIG5vIHB1cnBvc2UsIGp1c3QgZW5zdXJlIGl0IGlzIHVubG9ja2VkDQo+IGF0
IHByb2JlIHRpbWUsIGFuZCB0aGVuIGlnbm9yZSBpdC4gSWYgeW91IGlnbm9yZSBpdCwgeW91IHdp
bGwgbmV2ZXIgcmV0dXJuIC0NCj4gRUJVU1kgYW5kIHNvIGJhZCB0aGluZ3Mgd2lsbCBuZXZlciBo
YXBwZW4uDQo+IA0KPiBKdXN0IGJlY2F1c2UgaGFyZHdhcmUgZXhpc3RzIGRvZXMgbm90IG1lYW4g
eW91IGhhdmUgdG8gdXNlIGl0IG9yIHRoYXQgaXQNCj4gYWRkcyBhbnkgdmFsdWUuDQoNClNvdW5k
cyBnb29kLg0KPiANCj4gICAgICAgIEFuZHJldw0K

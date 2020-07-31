Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913EB234D36
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 23:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgGaVic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 17:38:32 -0400
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:5958
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726571AbgGaVib (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 17:38:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpJG/pDzwQMkNvY9+cStD05gooLHLP/d6RQyUiGAU+9XbtV10DIPKqMaliC/4gQch4tvzDPC11Y03QNm5v9Br9ItP2yyClsd0siZt95wvMnl7gwz6huJOtDotU+84CD7El2NV2tT5bWVmeDqljjxmtv6sODXUTIhLEC43XuOQl9uwaCeKbIfu7rXzt4gpmTCsQFKQGaZu3BaN6zBWaFRIRGpRKkBFDCuhYfP3q2fYXSKstBiy5gPKL1dPF7698Ix3LyhXFHlXLMHS3+sQvxqbXc0EFnXmCrxLSSlDDKkz0U4ULeAOcKv7wcby6lEUvfSj3UwK+BIhGf2LbJuxACqXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y071+Fgm1hGr/SL25cmpvvwR3AnSDmbKi5vU8DzIH28=;
 b=BsXWrKWQ/vn26mj9OxTQ3iijw3NvmoK0uVTc2gl29A62nR8rGS3mHTBcmvFu6DpdvFZTRKS2Tx7zraiQiw0ONPJftB8L22eM5CLfGjYONOXrbwttIFvQefukgwucm80g3i8ERAeXiS/pmfYQIsmouI/4/CFfXIrUD8D5+yG5lD1FYdx8v5rm+S80R1XvvtS/CiY/yLU/37kNiBfDwYnzo6PNAWcUnuVAMrp9pWcwa+c7jbjbQOYHemzixsOVlnfa47tvVOURWKAHmUEh5FqdIe/dB/YWcuzVjNG4WysHgea3XEQVH4yzJf4v1zZoYNnCCCNxAJFDVN7NkvZjhi/68g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y071+Fgm1hGr/SL25cmpvvwR3AnSDmbKi5vU8DzIH28=;
 b=iEnS97c3fDIP4mY1McZQa8hAmb+6ky3kF1tiaeG3HfOTi9s6z/uzFxZNY4VhPSYhwh/NMHuv6MonePlOGy5vJXQzpPU5CtiAlcW0KbBhwkkj2xy8wc+99WS/XVFSSsGs7J2m0uxK5QvTtclueq4ME8A+A7ZZfzaav0wb1S2M3w0=
Received: from VI1PR05MB4110.eurprd05.prod.outlook.com (2603:10a6:803:3f::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.28; Fri, 31 Jul
 2020 21:38:26 +0000
Received: from VI1PR05MB4110.eurprd05.prod.outlook.com
 ([fe80::c19b:54d7:a861:2a88]) by VI1PR05MB4110.eurprd05.prod.outlook.com
 ([fe80::c19b:54d7:a861:2a88%4]) with mapi id 15.20.3239.020; Fri, 31 Jul 2020
 21:38:26 +0000
From:   Asmaa Mnebhi <Asmaa@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     David Thompson <dthompson@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>, Jiri Pirko <jiri@mellanox.com>
Subject: RE: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Thread-Topic: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Thread-Index: AQHWZdY0iihhdKXIGkuYVb+rxnyJGKkh+DcAgAASKfCAABLjAIAAFqEg
Date:   Fri, 31 Jul 2020 21:38:26 +0000
Message-ID: <VI1PR05MB4110ACD3FE86FD3DF5F59D84DA4E0@VI1PR05MB4110.eurprd05.prod.outlook.com>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
 <20200731174222.GE1748118@lunn.ch>
 <VI1PR05MB4110070900CF42CB3E18983EDA4E0@VI1PR05MB4110.eurprd05.prod.outlook.com>
 <20200731195458.GA1843538@lunn.ch>
In-Reply-To: <20200731195458.GA1843538@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [65.96.160.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8758cb50-94b1-4270-578a-08d8359a0eda
x-ms-traffictypediagnostic: VI1PR05MB5391:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB53910C5B8B475E21FC4DEED2DA4E0@VI1PR05MB5391.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ac1SSR+CAlZ5OXFYx/1T9xMrU/DtWZL5fmlH+35Y7GeOnvSbPl5fPexSJ2xoO4XFARMqhs3ajYksBtmgmQNjTWXh3Bvb6zYwhRoFZtbc5OyMwnCtZ1/KjqrvsL8poqyiZ3jSrwmbBGGA86U54/J3u3jLeTI8PF4HPApYqnkGL3T28dljlD1u/NKCs/vNGwurlo3absHFG6W9LFOxUDPzWmfgYAYNm99UHBTSWMv3mHZA42Lwm+IkQ8sYWCz2Y7BAVGKD4mEJDhT6PKQ/MXK0mauPrZ9jA6YzW/TBlhZf+QTgaLo6H72cjsRAdjwMAQzK6VDK8TN97pGXFk0ej7FQwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4110.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(83380400001)(2906002)(8936002)(186003)(6916009)(71200400001)(53546011)(7696005)(26005)(8676002)(76116006)(4326008)(107886003)(66946007)(6506007)(478600001)(9686003)(316002)(66556008)(64756008)(66476007)(52536014)(66446008)(54906003)(33656002)(55016002)(5660300002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: nQop1DwCSnG9CRrXm9Juu70SnToPbJ9OTy7KCb4dIUTmaj3DUGPD4HsCt5upmgPvCvxDy5lQIUuTESzwiuzU15ojh6LXMRbmWjAL2AiibBmKxHxSA1uZXQ4A89faulSrVxejdL5LPyxVcLp3sm5LtWR2mnocEim6i3f3xzGxwPKNSp9VaYLRsDJh8FSbiv37y/ITcoNyTAx1MhTeJdswy1PraZGFnF38PbiZA0wF3Nbd0fkqlMTuG5lsfWY7tBYz1QDEeoj4521hEloq9S7bWUWkS2X7Usfe2VCkm6EwszpAj3Q6HE2DYS691VZIvITQ4DXw3C3YeLoqbb4i2PPtKLKUrgtMzxaDZ7GqUWxu1jnRU3Loeyyq95fVCiAI62Bk15hYr7DvAm/4l7bDZ3fexvJFzQebvjTpfpIGKL9i3SBnxGigidQSbJWoUlz0HgtcVmy6SZrMoXwX+LlCCIkzBQ9pJX0YcZAToU2DBWCWXoU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4110.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8758cb50-94b1-4270-578a-08d8359a0eda
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 21:38:26.1981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BO8MCeadACNYuYrxLIZRk5M95d0q2zLbnAWPY4uYIw0k6pUN4lKjHHgl0f4rNBikdh1vUh1z0LVPLwuXR0YnYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IEx1bm4gPGFu
ZHJld0BsdW5uLmNoPg0KPiBTZW50OiBGcmlkYXksIEp1bHkgMzEsIDIwMjAgMzo1NSBQTQ0KPiBU
bzogQXNtYWEgTW5lYmhpIDxBc21hYUBtZWxsYW5veC5jb20+DQo+IENjOiBEYXZpZCBUaG9tcHNv
biA8ZHRob21wc29uQG1lbGxhbm94LmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRh
dmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgSmlyaQ0KPiBQaXJrbyA8amlyaUBt
ZWxsYW5veC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHRdIEFkZCBNZWxsYW5v
eCBCbHVlRmllbGQgR2lnYWJpdCBFdGhlcm5ldA0KPiBkcml2ZXINCj4gDQo+IE9uIEZyaSwgSnVs
IDMxLCAyMDIwIGF0IDA2OjU0OjA0UE0gKzAwMDAsIEFzbWFhIE1uZWJoaSB3cm90ZToNCj4gDQo+
IEhpIEFzbWFhDQo+IA0KPiBQbGVhc2UgZG9uJ3Qgc2VuZCBIVE1MIG9iZnVzdGljYXRlZCBlbWFp
bHMgdG8gbWFpbGluZyBsaXN0cy4NCg0KTXkgYXBvbG9naWVzISANCg0KPiANCj4gPiA+ICtzdGF0
aWMgaW50IG1seGJmX2dpZ2VfbWRpb19yZWFkKHN0cnVjdCBtaWlfYnVzICpidXMsIGludCBwaHlf
YWRkLA0KPiA+ID4gK2ludA0KPiA+DQo+ID4gPiArcGh5X3JlZykgew0KPiA+DQo+ID4gPiArICAg
ICAgICAgc3RydWN0IG1seGJmX2dpZ2UgKnByaXYgPSBidXMtPnByaXY7DQo+ID4NCj4gPiA+ICsg
ICAgICAgICB1MzIgY21kOw0KPiA+DQo+ID4gPiArICAgICAgICAgdTMyIHJldDsNCj4gPg0KPiA+
ID4gKw0KPiA+DQo+ID4gPiArICAgICAgICAgLyogSWYgdGhlIGxvY2sgaXMgaGVsZCBieSBzb21l
dGhpbmcgZWxzZSwgZHJvcCB0aGUgcmVxdWVzdC4NCj4gPg0KPiA+ID4gKyAgICAgICAgICogSWYg
dGhlIGxvY2sgaXMgY2xlYXJlZCwgdGhhdCBtZWFucyB0aGUgYnVzeSBiaXQgd2FzIGNsZWFyZWQu
DQo+ID4NCj4gPiA+ICsgICAgICAgICAqLw0KPiA+DQo+ID4NCj4gPg0KPiA+IEhvdyBjYW4gdGhp
cyBoYXBwZW4/IFRoZSBtZGlvIGNvcmUgaGFzIGEgbXV0ZXggd2hpY2ggcHJldmVudHMgcGFyYWxs
ZWwNCj4gYWNjZXNzPw0KPiA+DQo+ID4NCj4gPg0KPiA+IFRoaXMgaXMgYSBIVyBMb2NrLiBJdCBp
cyBhbiBhY3R1YWwgcmVnaXN0ZXIuIFNvIGFub3RoZXIgSFcgZW50aXR5IGNhbg0KPiA+IGJlIGhv
bGRpbmcgdGhhdCBsb2NrIGFuZCByZWFkaW5nL2NoYW5naW5nIHRoZSB2YWx1ZXMgaW4gdGhlIEhX
IHJlZ2lzdGVycy4NCj4gDQo+IFlvdSBoYXZlIG5vdCBleHBsYWlucyBob3cgdGhhdCBjYW4gaGFw
cGVuPyBJcyB0aGVyZSBzb21ldGhpbmcgaW4gdGhlIGRyaXZlcg0KPiBpIG1pc3NlZCB3aGljaCB0
YWtlcyBhIGJhY2tkb29yIHRvIHJlYWQvd3JpdGUgTURJTyB0cmFuc2FjdGlvbnM/DQoNCkFoIG9r
ISBUaGVyZSBpcyBhIEhXIGVudGl0eSAoY2FsbGVkIFlVKSB3aXRoaW4gdGhlIEJsdWVGaWVsZCB3
aGljaCBpcyBjb25uZWN0ZWQgdG8gdGhlIFBIWSBkZXZpY2UuDQpJIHRoaW5rIHRoZSBZVSBpcyB3
aGF0IHlvdSBhcmUgY2FsbGluZyAiYmFja2Rvb3IiIGhlcmUuIFRoZSBZVSBjb250YWlucyBzZXZl
cmFsIHJlZ2lzdGVycyB3aGljaCBjb250cm9sIHJlYWRzL3dyaXRlcw0KVG8gdGhlIFBIWS4gU28g
aXQgaXMgbGlrZSBhbiBleHRyYSBsYXllciBmb3IgcmVhZGluZyBNRElPIHJlZ2lzdGVycy4gT25l
IG9mIHRoZSBZVSByZWdpc3RlcnMgaXMgdGhlIGdhdGV3YXkgcmVnaXN0ZXIgKGFrYSBHVyBvcg0K
TUxYQkZfR0lHRV9NRElPX0dXX09GRlNFVCBpbiB0aGUgY29kZSkuIElmIHRoZSBHVyByZWdpc3Rl
cidzIExPQ0sgYml0IGlzIG5vdCBjbGVhcmVkLCB3ZSBjYW5ub3Qgd3JpdGUgYW55dGhpbmcgdG8g
dGhlIGFjdHVhbCBQSFkgTURJTyByZWdpc3RlcnMuDQpEaWQgSSBhbnN3ZXIgeW91ciBxdWVzdGlv
bj8NCg0KPiANCj4gPiA+ICsgICAgICAgICByZXQgPSBtbHhiZl9naWdlX21kaW9fcG9sbF9iaXQo
cHJpdiwNCj4gPiA+ICsgTUxYQkZfR0lHRV9NRElPX0dXX0xPQ0tfTUFTSyk7DQo+ID4NCj4gPiA+
ICsgICAgICAgICBpZiAocmV0KQ0KPiA+DQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICBy
ZXR1cm4gLUVCVVNZOw0KPiA+DQo+ID4NCj4gPg0KPiA+IFBIWSBkcml2ZXJzIGFyZSBub3QgZ29p
bmcgdG8gbGlrZSB0aGF0LiBUaGV5IGFyZSBub3QgZ29pbmcgdG8gcmV0cnkuDQo+ID4gV2hhdCBp
cyBsaWtlbHkgdG8gaGFwcGVuIGlzIHRoYXQgcGh5bGliIG1vdmVzIGludG8gdGhlIEVSUk9SIHN0
YXRlLA0KPiA+IGFuZCB0aGUgUEhZIGRyaXZlciBncmluZHMgdG8gYSBoYWx0Lg0KPiA+DQo+ID4N
Cj4gPg0KPiA+IFRoaXMgaXMgYSBmYWlybHkgcXVpY2sgSFcgdHJhbnNhY3Rpb24uIFNvIEkgZG9u
4oCZdCB0aGluayBpdCB3b3VsZCBjYXVzZQ0KPiA+IGFuZCBpc3N1ZSBmb3IgdGhlIFBIWSBkcml2
ZXJzLiBJbiB0aGlzIGNhc2UsIHdlIHVzZSB0aGUgbWljcmVsDQo+ID4gS1NaOTAzMS4gV2UgaGF2
ZW7igJl0IHNlZW4gaXNzdWVzLg0KPiANCj4gU28geW91IGhhdmUgaGFwcHkgdG8gZGVidWcgaGFy
ZCB0byBmaW5kIGFuZCByZXByb2R1Y2UgaXNzdWVzIHdoZW4gaXQgZG9lcw0KPiBoYXBwZW4/IE9y
IHdvdWxkIHlvdSBsaWtlIHRvIHNwZW5kIGEgbGl0dGxlIGJpdCBvZiB0aW1lIG5vdyBhbmQganVz
dCBwcmV2ZW50DQo+IGl0IGhhcHBlbmluZyBhdCBhbGw/DQoNCkkgdGhpbmsgSSBtaXN1bmRlcnN0
b29kIHlvdXIgY29tbWVudC4gRGlkIHlvdSBhc2sgd2h5IHdlIGFyZSBwb2xsaW5nIGhlcmU/IE9y
IHRoYXQgd2Ugc2hvdWxkbid0IGJlIHJldHVybmluZyAtRUJVU1k/DQo+IA0KPiAgICAgIEFuZHJl
dw0K

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7DA1AD1BD
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 23:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgDPVLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 17:11:43 -0400
Received: from mail-vi1eur05on2077.outbound.protection.outlook.com ([40.107.21.77]:23069
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725928AbgDPVLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 17:11:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkoTmTIVQ2pT3MvF9MRDh+asr9/yDdlO1WD3eJNjCrgtt/MNDAG8tiQQv64B4+P0SMZbzs7ThJY0aylZ9F8j3Xhn4v61qi8B598U7ks1pXt2BmyT4lzhRFxcNnRq+mIOzPl7KlBDKb4cD7S2NDPHq+GRUYyka2PqZ15aOEIa5IZ2Vrk4gh+J9HNbygMcN/OjQTmlDFyeTmy+JuYAdWlSRfw+CIQbv+rllqqeBJPEbNKrFoCo4X71qpE3HyByjgVChUaK8Cfl3Oj2YScRpOopR2bTFJIHhmWR4TDX5eBAeAXsH0nvUYtJWCa9J1oll0VyOnqktoug483ksizzbjJYhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWVewDVCTD+kTg3S33RK/F90qpyIEBR2RBqZDocjms8=;
 b=oPtHv4VSKvMJiUbqI9U49S3hD/anSvrgYnSO5aYiuDvxj7kbkvLC/WJMM1IXP0KmxWOBbKgbh4ELkZESNxG4aopi2lPHAcFampbAd+V3/ZcWpK41gDoGTFmBYVRaXLILunDoQe83XGsa81FNcVfumAWDyWQg6RHN/C5BItgHwERpz8Ydn/+qaaiX8K21n8i+avke9TH5a4qnlCYhyK79nQ7hWHL3jeVzch+s0KisS7qSIovoLTn0+9uZhw+1lmJnmBHxksk697+F/OmITOQVunRLsujuFDqLvBUs23r6LhcaCf/enOIj4N7m0ALbil/bMPiy8JB+RFepAu8PjtS9aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWVewDVCTD+kTg3S33RK/F90qpyIEBR2RBqZDocjms8=;
 b=Y+L2hAVK9eQ5pH1mADOufv37WR1eHRjSjl4JVo+TUAhyeZXRAKE3LwOTWEhr+ceq5fBgEMqsXTGjVnY/Bpl5iNxQ57Vn4MMiOdyD/y70yek+juYtNJjal89ZSc8MYOnzyF7MgTKmJY4HmWBN2Zw1OsLT6t7xj/Tm6FU5NjD5nqc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6752.eurprd05.prod.outlook.com (2603:10a6:800:131::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Thu, 16 Apr
 2020 21:11:38 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.028; Thu, 16 Apr 2020
 21:11:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Topic: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Index: AQHWEFb6WRVOJO0/j0GE4IB+QkA/0qh1Ei4AgAC1ZICAAheSAIAAjYWAgAAM6ICAADp+AIAAE8gAgABWOICAAURNAIAAgPKAgADlNYCAAD1UgIAAJLSAgAAKXACAABGkAA==
Date:   Thu, 16 Apr 2020 21:11:38 +0000
Message-ID: <4a5bc4cf3225682e3d79590eeec1ae81774e3c2a.camel@mellanox.com>
References: <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20200414015627.GA1068@sasha-vm>
         <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
         <20200414110911.GA341846@kroah.com>
         <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
         <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
         <20200414205755.GF1068@sasha-vm>
         <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
         <20200416000009.GL1068@sasha-vm>
         <CAJ3xEMjfWL=c=voGqV4pUCzWXmiTn-R6mrRi82UAVHMVysKU1g@mail.gmail.com>
         <20200416172001.GC1388618@kroah.com>
         <b8651ce6d7d6c6dcb8b2d66f07148413892b48d0.camel@mellanox.com>
         <20200416130828.1f35b6cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200416130828.1f35b6cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: f2f8bcef-c1f1-478b-323c-08d7e24ac0a5
x-ms-traffictypediagnostic: VI1PR05MB6752:
x-microsoft-antispam-prvs: <VI1PR05MB6752E3B8D93DA49BE667AC23BED80@VI1PR05MB6752.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0375972289
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(2616005)(6916009)(71200400001)(6512007)(45080400002)(36756003)(6486002)(8936002)(26005)(2906002)(186003)(81156014)(8676002)(5660300002)(6506007)(66476007)(64756008)(86362001)(316002)(478600001)(66556008)(66446008)(91956017)(66946007)(76116006)(54906003)(4326008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7maPaUfPHk3Zss0WXBGP7DPHM25Zhpjqx+NKSpW6JXUt3/kpoLiy/L7J9uDNKVzoxMeHfeYjs6yzZ9iGAcIzQ0h42pENYCKf2Xsmpbw2QgoPDBidnaoRlj4my9DAzILubPBcPV5BVQWDPy5Tb5WUCS/fnR/l/tY/LY66vXqHY4kYl4rmDS3Y8wKFrVzkEY9CyUHjRY7MiD2iOIJxvWfWRRlWU9f65wrOdIfnBVHfEF3lGvqFazYNYKymkcDXiA+ygoKjYsvqAndoy7shkAfl/71kfAai5fI278xLtXqyTmFmgTpWLD+1AoxY60FD/N9lGYpMJEefgRAuTFCv4AxI76gKGAcMfoI/eTexEy1f3+l9wqAo4BHVjvuhOWqIcZJBFReyuoXZARnpaAdnBvO4oHdqAkDKd7SXnAdPhMrQDcvMYCENxWivBsCPHq6Vpsy/
x-ms-exchange-antispam-messagedata: wiLwSQHzkjAHw+1Bp1j+jB5YQbViXHLGyWwfANsw/PHBFXTfAXzuEK91ktziyu+HnO0X74/korpPotA9OPFana5v2qQ/t0l886Sw6hhqmVLl6T0IEVi184o/09nJXADtQfvmckfcC7PKYmrY6sdGdA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7AFC0E461E539545BEE20687E3D4FFFB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2f8bcef-c1f1-478b-323c-08d7e24ac0a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2020 21:11:38.2854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tbQLcL1pwk/B0gThekhqMWBg/+b5JlkrYFwGpmSj7Ackxxa1VzI4JWxJx01ngypRFCwzEGGM03EeEm9gK1BLwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6752
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTE2IGF0IDEzOjA4IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAxNiBBcHIgMjAyMCAxOTozMToyNSArMDAwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiA+ID4gSU1ITyBpdCBkb2Vzbid0IG1ha2UgYW55IHNlbnNlIHRvIHRha2UgaW50byBz
dGFibGUNCj4gPiA+ID4gYXV0b21hdGljYWxseQ0KPiA+ID4gPiBhbnkgcGF0Y2ggdGhhdCBkb2Vz
bid0IGhhdmUgZml4ZXMgbGluZS4gRG8geW91IGhhdmUgMS8yLzMvNC81DQo+ID4gPiA+IGNvbmNy
ZXRlDQo+ID4gPiA+IGV4YW1wbGVzIGZyb20geW91ciAocmVmZXJyaW5nIHRvIHlvdXIgTWljcm9z
b2Z0IGVtcGxveWVlIGhhdA0KPiA+ID4gPiBjb21tZW50DQo+ID4gPiA+IGJlbG93KSBvciBvdGhl
cidzIHBlb3BsZSBwcm9kdWN0aW9uIGVudmlyb25tZW50IHdoZXJlIHBhdGNoZXMNCj4gPiA+ID4g
cHJvdmVkIHRvDQo+ID4gPiA+IGJlIG5lY2Vzc2FyeSBidXQgdGhleSBsYWNrZWQgdGhlIGZpeGVz
IHRhZyAtIHdvdWxkIGxvdmUgdG8gc2VlDQo+ID4gPiA+IHRoZW0uICANCj4gPiA+IA0KPiA+ID4g
T2ggd293LCB3aGVyZSBkbyB5b3Ugd2FudCBtZSB0byBzdGFydC4gIEkgaGF2ZSB6aWxsaW9ucyBv
ZiB0aGVzZS4NCj4gPiA+IA0KPiA+ID4gQnV0IHdhaXQsIGRvbid0IHRydXN0IG1lLCB0cnVzdCBh
IDNyZCBwYXJ0eS4gIEhlcmUncyB3aGF0DQo+ID4gPiBHb29nbGUncw0KPiA+ID4gc2VjdXJpdHkg
dGVhbSBzYWlkIGFib3V0IHRoZSBsYXN0IDkgbW9udGhzIG9mIDIwMTk6DQo+ID4gPiAJLSAyMDkg
a25vd24gdnVsbmVyYWJpbGl0aWVzIHBhdGNoZWQgaW4gTFRTIGtlcm5lbHMsIG1vc3QNCj4gPiA+
IHdpdGhvdXQNCj4gPiA+IAkgIENWRXMNCj4gPiA+IAktIDk1MCsgY3JpdGljaWFsIG5vbi1zZWN1
cml0eSBidWdzIGZpeGVzIGZvciBkZXZpY2UgWFhYWCBhbG9uZQ0KPiA+ID4gCSAgd2l0aCBMVFMg
cmVsZWFzZXMNCj4gPiANCj4gPiBTbyBvcHQtaW4gZm9yIHRoZXNlIGNyaXRpY2FsIG9yIF9hbHdh
eXNfIGluIHVzZSBiYXNpYyBrZXJuZWwNCj4gPiBzZWN0aW9ucy4NCj4gPiBidXQgbWFrZSB0aGUg
ZGVmYXVsdCBvcHQtb3V0Li4gDQo+IA0KPiBCdXQgdGhlIGxlc3MgYXR0ZW50aXZlL3dlYWtlciB0
aGUgbWFpbnRhaW5lcnMgdGhlIG1vcmUgYmVuZWZpdCBmcm9tDQo+IGF1dG9zZWwgdGhleSBnZXQu
IFRoZSBkZWZhdWx0IGhhcyB0byBiZSBjb3JyZWN0IGZvciB0aGUgZ3JvdXAgd2hpY2ggDQo+IGlz
IG1vcmUgbGlrZWx5IHRvIHRha2Ugbm8gYWN0aW9uLg0KDQpvciB0aGUgbW9yZSBleHBvc2VkIHRo
ZXkgYXJlIHRvIGZhbHNlIHBvc2l0aXZlcyA6KSwgdW5ub3RpY2VkIGJ1Z3MgZHVlDQp0byB3cm9u
ZyBwYXRjaGVzIGdldHRpbmcgYmFja3BvcnRlZC4uIHRoaXMgY291bGQgZ28gZm9yIHllYXJzIGZv
ciBsZXNzDQphdHRlbnRpdmUgd2Vha2VyIG1vZHVsZXMsIHVudGlsIHNvbWVvbmUgc3RlcHMgb24g
aXQuDQo=

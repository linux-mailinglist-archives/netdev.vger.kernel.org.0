Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 463319D9C0
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 01:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfHZXHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 19:07:00 -0400
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:29293
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726307AbfHZXHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 19:07:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WcyvsW85pw/JqsWM5No1R5Xv7q4kDKD6bAJk2z4/nZwMHTZoFK7PI95Htzn0f7hOGyXv6M9rfv9SruYeptqQGPcfN9bO5s22ECC40L3bm7qXfuSlYF/NV/kwMG5IK92EdgkqHaRsedfuqQaYoarrtUhFaa6/uQCTyBv0xgvKTvlvDIn2Z4xkwwmGGAt/RBU25emzQ6mURM0759YZo9Nnoz8EL+0m6gS+VJ8LDo1qlJEyNnzyVIjYkLjf1m7mhuWqMstEp/Tx1UsFsoDSGUNSg4hBXZ0+gMOIrVm9k5nN9pzn9vavgktLQWvnZYNBqlkxriyFqfDBL7tJv0r67cilmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEi+wgLUarhlgrExY0H6oZAFXBYFYaQK9hMO/kHBuLw=;
 b=hwFWIMRJ1J9KoGLGUg7ewEt6VctR441Xi+B1eJcHycIPtBI5RaxIwpyFPAXvVG4j3ZpyIAFL8Pbx0sftpA8bxLPOnOfWSpjt5MMmj44KAat4SmfwKolxp7s7aZEHBZboy4li7jXAwMGBNdl9T+rw81CGoc9JiZRDQ8iNHZHxjXO0H65zwk721ShV3051ImuUTWM/3ahBE4n57ro1b7Cqw0Wq9ILCLg3UKoiaxonxekflakRnZD+QyAXbbrW5yT012Kn5GzF+zE1Mv2MN7hEm9gLlT2ny2HrvGzLXDE1XAp4AwYQVSU1G4+arXabBw4eLIDVPx9la0NA7Sje0Pj/Jrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEi+wgLUarhlgrExY0H6oZAFXBYFYaQK9hMO/kHBuLw=;
 b=ias3AbG6gwfhBVq1fLBgN8w0h2zmUGWRlGpeWnk1udbJ1oHICT3csSQtB2ZracZL0zj3CsNsqtOD7UeG8je3/slxYscIKujA+lsV0q0ihgGZrK51aIPc+Qg3tdApTISZhaYvGDSRD0ni83l5sZiFHEwmNaoAfl4knKn+8cFqACc=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2461.eurprd05.prod.outlook.com (10.168.137.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Mon, 26 Aug 2019 23:06:53 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Mon, 26 Aug 2019
 23:06:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [net-next 4/8] net/mlx5e: Add device out of buffer counter
Thread-Topic: [net-next 4/8] net/mlx5e: Add device out of buffer counter
Thread-Index: AQHVWUJWlLdQtLGJp0+FOnAm6QwlfqcH8v0AgABKrwCAAM1ygIAE2CiAgAAHBICAACkUgA==
Date:   Mon, 26 Aug 2019 23:06:53 +0000
Message-ID: <3be3a78c989e86f6761d3c0a66d6b24d50d1da8e.camel@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
         <20190822233514.31252-5-saeedm@mellanox.com>
         <20190822183324.79b74f7b@cakuba.netronome.com>
         <27f7cfa13d1b5e7717e2d75595ab453951b18a96.camel@mellanox.com>
         <20190823111601.012fabf4@cakuba.netronome.com>
         <18abb6456fb4a2fba52f6f77373ac351651a62c6.camel@mellanox.com>
         <20190826133949.0691660c@cakuba.netronome.com>
In-Reply-To: <20190826133949.0691660c@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 904078c5-e919-4ad8-f999-08d72a7a15b7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2461;
x-ms-traffictypediagnostic: VI1PR0501MB2461:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB246181EE3EC0E8C5FF06BB1CBEA10@VI1PR0501MB2461.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(199004)(189003)(51914003)(36756003)(14454004)(3846002)(6306002)(53936002)(71200400001)(71190400001)(81166006)(118296001)(6506007)(54906003)(486006)(7736002)(316002)(25786009)(5640700003)(81156014)(11346002)(2616005)(99286004)(2351001)(6916009)(229853002)(5660300002)(476003)(6246003)(102836004)(6512007)(66066001)(305945005)(4326008)(478600001)(256004)(186003)(8936002)(91956017)(76116006)(58126008)(76176011)(8676002)(66446008)(26005)(66476007)(66556008)(64756008)(6436002)(6116002)(66946007)(966005)(107886003)(446003)(2906002)(86362001)(6486002)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2461;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2nBtwoYf9bWUWyySDKCO1CKrrrxqXnJfjiV47i8mfbYVfd7AeANgs/C3fRZK4pNVgQNah5HAe7TkiraRmsirh/m6KolexO0U9PHr3Ry1V97W4H5ScMyBw6Pq4jSmR6l0SoubLzBhPN3QKMXpAwPvVmiPdEZayvPgK0jar1sXy84NqGQ1Kw5ag8CNXtjKYbuOUhUPQX05+23xbHvsxauH7Kmb/GQ1y9bnVR7kFkrDkjinXzoL73fUoMlp5khJmHKpTRZSQORNVCHvFN/aMlVfg//fqsfk8XdJTiDzovFLECmVgK7rTgF+TxiPRL5euSAKQuz7sKn2ss0kgyKB/UCZCF08/1K+zIs2PYqnqbfczoRKadaPcEFJ9ASY+7PcpQLwYercmeqBmmyKYewqi/JZe54VrMjBAfPfiFWPAdz6Eys=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52E4A476E5D06241B0F378417C569F8C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 904078c5-e919-4ad8-f999-08d72a7a15b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 23:06:53.4469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dESZvgHXCokbzmrSMSavXNIlJVFPwChK8q4CPIGnMke5CWittOpA3pt72xn1u7PV4TbFg3ToiZlQcc2ZWV4VyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2461
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTI2IGF0IDEzOjM5IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAyNiBBdWcgMjAxOSAyMDoxNDo0NyArMDAwMCwgU2FlZWQgTWFoYW1lZWQgd3Jv
dGU6DQo+ID4gPiBJIHNlZSB0aGFua3MgZm9yIHRoZSBleHBsYW5hdGlvbiBhbmQgc29ycnkgZm9y
IHRoZSBkZWxheWVkDQo+ID4gPiByZXNwb25zZS4NCj4gPiA+IFdvdWxkIGl0IHBlcmhhcHMgbWFr
ZSBzZW5zZSB0byBpbmRpY2F0ZSB0aGUgaGFpcnBpbiBpbiB0aGUNCj4gPiA+IG5hbWU/ICANCj4g
PiANCj4gPiBXZSBoYWQgc29tZSBpbnRlcm5hbCBkaXNjdXNzaW9uIGFuZCB3ZSBjb3VsZG4ndCBj
b21lIHVwIHdpdGggdGhlDQo+ID4gcGVyZmVjdCBuYW1lIDopDQo+ID4gDQo+ID4gaGFpcnBpbiBp
cyBqdXN0IGFuIGltcGxlbWVudGF0aW9uIGRldGFpbCwgd2UgZG9uJ3Qgd2FudCB0bw0KPiA+IGV4
Y2x1c2l2ZWx5DQo+ID4gYmluZCB0aGlzIGNvdW50ZXIgdG8gaGFpcnBpbiBvbmx5IGZsb3dzLCB0
aGUgcHJvYmxlbSBpcyBub3Qgd2l0aA0KPiA+IGhhaXJwaW4sIHRoZSBhY3R1YWwgcHJvYmxlbSBp
cyBkdWUgdG8gdGhlIHVzZSBvZiBpbnRlcm5hbCBSUXMsIGZvcg0KPiA+IG5vdw0KPiA+IGl0IG9u
bHkgaGFwcGVucyB3aXRoICJoYWlycGluIGxpa2UiIGZsb3dzLCBidXQgdG9tb3Jyb3cgaXQgY2Fu
DQo+ID4gaGFwcGVuDQo+ID4gd2l0aCBhIGRpZmZlcmVudCBzY2VuYXJpbyBidXQgc2FtZSByb290
IGNhdXNlICh0aGUgdXNlIG9mIGludGVybmFsDQo+ID4gUlFzKSwgd2Ugd2FudCB0byBoYXZlIG9u
ZSBjb3VudGVyIHRvIGNvdW50IGludGVybmFsIGRyb3BzIGR1ZSB0bw0KPiA+IGludGVybmFsIHVz
ZSBvZiBpbnRlcm5hbCBSUXMuDQo+ID4gDQo+ID4gc28gaG93IGFib3V0Og0KPiA+IGRldl9pbnRl
cm5hbF9ycV9vb2I6IERldmljZSBJbnRlcm5hbCBSUSBvdXQgb2YgYnVmZmVyDQo+ID4gZGV2X2lu
dGVybmFsX291dF9vZl9yZXM6IERldmljZSBJbnRlcm5hbCBvdXQgb2YgcmVzb3VyY2VzIChtb3Jl
DQo+ID4gZ2VuZXJpYw0KPiA+ID8gdG9vIGdlbmVyaWMgPykNCj4gDQo+IE1heWJlIGRldl9pbnRl
cm5hbF9xdWV1ZV9vb2I/IFRoZSB1c2Ugb2YgJ2ludGVybmFsJyBpcyBhIGxpdHRsZQ0KPiB1bmZv
cnR1bmF0ZSwgYmVjYXVzZSBpdCBtYXkgYmUgcmVhZCBhcyBSUSBydW4gb3V0IG9mIGludGVybmFs
DQo+IGJ1ZmZlcnMuDQo+IFJhdGhlciB0aGFuIHNwZWNpYWwgdHlwZSBvZiBxdWV1ZSBydW4gb3V0
IG9mIGJ1ZmZlcnMuDQo+IEJ1dCBub3Qga25vd2luZyB0aGUgSFcgSSBkb24ndCByZWFsbHkgaGF2
ZSBhbnkgZ3JlYXQgc3VnZ2VzdGlvbnMgOigNCj4gRWl0aGVyIG9mIHRoZSBhYm92ZSB3b3VsZCB3
b3JrIGFzIHdlbGwuDQo+IA0KDQpUcnVlLCBldmVuIG91ciBIVyBhcmNoaXRlY3RzIGRpZG4ndCBr
bm93IGhvdyB0byBjYWxsIGl0LCBzaW5jZSBzdGlja2luZw0KdG8gYSBuYW1lIG5vdyB0aGF0IG1p
Z2h0IGJlIGRlcHJlY2F0ZWQgaW4gYSBmdXR1cmUgSFcgaXMgd2hhdCB3ZSBhcmUNCnRyeWluZyB0
byBhdm9pZC4gYSBnZW5lcmljIG5hbWUgaXMgcHJlZmVyYWJsZS4NCg0KSSBsaWtlIGRldl9pbnRl
cm5hbF9xdWV1ZV9vb2IsIHdpbGwgdGFrZSBpdCB3aXRoIHRoZSB0ZWFtIGFuZCBzZW5kIHYydG9t
b3Jyb3cuIA0KDQp0aGFua3MgSmFrdWIgZm9yIHRoZSBzdXBwb3J0Lg0KDQoNCj4gPiBBbnkgc3Vn
Z2VzdGlvbiB0aGF0IHlvdSBwcm92aWRlIHdpbGwgYmUgbW9yZSB0aGFuIHdlbGNvbWUuDQo+ID4g
DQo+ID4gPiBkZXZfb3V0X29mX2J1ZmZlciBpcyBxdWl0ZSBhIGdlbmVyaWMgbmFtZSwgYW5kIHRo
ZXJlIHNlZW1zIHRvIGJlDQo+ID4gPiBubw0KPiA+ID4gZG9jLCBub3IgZG9lcyB0aGUgY29tbWl0
IG1lc3NhZ2UgZXhwbGFpbnMgaXQgYXMgd2VsbCBhcyB5b3UNCj4gPiA+IGhhdmUuLiAgDQo+ID4g
DQo+ID4gUmVnYXJkaW5nIGRvY3VtZW50YXRpb246DQo+ID4gQWxsIG1seDUgZXRob29sIGNvdW50
ZXJzIGFyZSBkb2N1bWVudGVkIGhlcmUNCj4gPiBodHRwczovL2NvbW11bml0eS5tZWxsYW5veC5j
b20vcy9hcnRpY2xlL3VuZGVyc3RhbmRpbmctbWx4NS1saW51eC1jb3VudGVycy1hbmQtc3RhdHVz
LXBhcmFtZXRlcnMNCj4gPiANCj4gPiBvbmNlIHdlIGRlY2lkZSBvbiB0aGUgbmFtZSwgd2lsbCBh
ZGQgdGhlIG5ldyBjb3VudGVyIHRvIHRoZSBkb2MuDQo+IA0KPiBJIHNlZSwgdGhhbmtzIQ0KDQpJ
IHdpbGwgYWRkIGEgbGluayB0byB0aGlzIGZpbGUgaW4gDQpodHRwczovL3d3dy5rZXJuZWwub3Jn
L2RvYy9odG1sL2xhdGVzdC9uZXR3b3JraW5nL2RldmljZV9kcml2ZXJzL21lbGxhbm94L21seDUu
aHRtbD9oaWdobGlnaHQ9bWx4NQ0KDQo=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9205B7592D
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfGYU4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:56:17 -0400
Received: from mail-eopbgr30052.outbound.protection.outlook.com ([40.107.3.52]:9294
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726479AbfGYU4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 16:56:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YB3Pvbzm3zIBXbTCxPe/mnf2yiCgOkNFu4SGoGo3Dni+pzYDCaAuFgc7aoXVN7dPvkPBwAaKnv4cMNlxlXvFARCIxhg66mK9rcq+lTPt3JxLCbW7SDDzuHf96f3ziOPtruLKAB/id0vd//dzVrSnmh1zMiCUKCkZLJSzPH987v6bUmhMRAfj+pQDa/7SwchcJDnlfpee2u29mACVv5fYrRG4Dgx3GqhE/pIeZtsuL01WtFeRaNnoiwPgrUNa242N6iFXnz6QLvCP3N/lLKEAGfuWr2CsIiRABkcqVr4gClSJWbuzRUiteIhXk2pKNTZYMWteMINjDCoCRaaIGyQiag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrp0R86y5Xb6k5vgyA4pGy297tz9VLCWiErBgbOe1gE=;
 b=HahxlHYcqCejjPUVGZK378FCibtL9uViXziDkFaFOdtCTbWyzcY7D8VowdE80ZB+NQZJfj3rBg6LeA9F4LbeGIg5050Sm+THxbARPmAWmAhrsyqNIjoRT7vJzzvNEdWXX+sm4/Bv7dXo4UDruk83xfah/DS01yeo1C6pDHKwuRAc4aEhgLCLth0ZyTdc64z8sOsK3X+/FGs6gHzN3FCjE8VuTQPHWt7myeoG+D1jEZH6yFA7+anfI5u5ftwUjAsf3Ag3E6YMThicsRDuG1AWPek02spO8ZYKyUaU1nMJMbWigataH6ZkwcjARyIfWPVgkbjWQg/ScmRUV+6WBNgIZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrp0R86y5Xb6k5vgyA4pGy297tz9VLCWiErBgbOe1gE=;
 b=mz69+cV4Viyh/5/ut8gVdqier3AoTi93geayQw9V24mpeS88fUnKEDURxYMUt+NEzv5pC/AcVdQItoC4MxjYMCo65EQwq32MdaZyFp42cm2pjdeRg256+jPfHXbMS6DFntvBeAYbNFsUWo8KoX+j99Ei/Tguf9EYQrNL0OWayn8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2696.eurprd05.prod.outlook.com (10.172.225.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Thu, 25 Jul 2019 20:56:10 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 20:56:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "skalluru@marvell.com" <skalluru@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "aelior@marvell.com" <aelior@marvell.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] qed: Add API for flashing the nvm
 attributes.
Thread-Topic: [PATCH net-next 2/2] qed: Add API for flashing the nvm
 attributes.
Thread-Index: AQHVQduLZVoKGVtDL0SZAJwk9KfVQabaLDSAgABVbICAAVFsAA==
Date:   Thu, 25 Jul 2019 20:56:10 +0000
Message-ID: <2e1aa979be713dc6c84e382b12ffe43344856933.camel@mellanox.com>
References: <20190724045141.27703-1-skalluru@marvell.com>
         <20190724045141.27703-3-skalluru@marvell.com>
         <24c09b029d00ba73aab58ef09a2e65ac545b3423.camel@mellanox.com>
         <MN2PR18MB25283C800F4F96BB511118A0D3C10@MN2PR18MB2528.namprd18.prod.outlook.com>
In-Reply-To: <MN2PR18MB25283C800F4F96BB511118A0D3C10@MN2PR18MB2528.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3371133e-10dd-43ac-c1d6-08d71142858a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2696;
x-ms-traffictypediagnostic: DB6PR0501MB2696:
x-microsoft-antispam-prvs: <DB6PR0501MB2696021392DAC73D5E2835FFBEC10@DB6PR0501MB2696.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(189003)(199004)(13464003)(51914003)(229853002)(25786009)(476003)(2501003)(305945005)(8676002)(446003)(11346002)(6512007)(6506007)(486006)(3846002)(102836004)(86362001)(66066001)(7736002)(99286004)(186003)(54906003)(26005)(6116002)(2616005)(71200400001)(14454004)(58126008)(76176011)(110136005)(256004)(71190400001)(66556008)(6246003)(76116006)(64756008)(66446008)(8936002)(53546011)(66476007)(5660300002)(66946007)(6486002)(68736007)(6436002)(53936002)(2906002)(81156014)(316002)(81166006)(118296001)(14444005)(36756003)(4326008)(478600001)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2696;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: neen/LaCUNfBP75URxwCt453k6urf9up7RIWBSQgBr1Et2dt2h5RzsbbGgUyNHBtwK1nasg3zO5s1Us0iXAVRz0NMl/JI0qoUE/67JrJQXNGbL23m101VfJSUnFlYoEcdhH0+LZ0q8t4rvxzvYldogUYxlmguuXNL7l7+pFjdlZNhJwe1UJdD1R/YWL9/n7BlmXEASAzvBaANFZlHDstZYFvcEuaASdAl0DOBE7BWSF4dJpeTiSVfEPLhTmkBmMIRUKijxX8T5a/TaRblFqSZXg2/QtAJJaCB3ttDq52bfRXCehvO5wtbZNeSbm+zG3lfdsdPvo6S7+kUEF0tHwKPHOvbuVAKTsFplRg0k6p/nNOS5SkchRF6PSq9e22UseRZGczdja0bsCN/5cZSjNLgTQbwxEqhFFqAby2HDgERbI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A4A48FC37FFC6488368FB64D736FFAE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3371133e-10dd-43ac-c1d6-08d71142858a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 20:56:10.0922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2696
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA3LTI1IGF0IDAwOjQ4ICswMDAwLCBTdWRhcnNhbmEgUmVkZHkgS2FsbHVy
dSB3cm90ZToNCj4gPiA+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJv
bTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+ID4gU2VudDogVGh1cnNk
YXksIEp1bHkgMjUsIDIwMTkgMToxMyBBTQ0KPiA+IFRvOiBTdWRhcnNhbmEgUmVkZHkgS2FsbHVy
dSA8c2thbGx1cnVAbWFydmVsbC5jb20+Ow0KPiA+IGRhdmVtQGRhdmVtbG9mdC5uZXQNCj4gPiBD
YzogQXJpZWwgRWxpb3IgPGFlbGlvckBtYXJ2ZWxsLmNvbT47IE1pY2hhbCBLYWxkZXJvbg0KPiA+
IDxta2FsZGVyb25AbWFydmVsbC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4gU3Vi
amVjdDogW0VYVF0gUmU6IFtQQVRDSCBuZXQtbmV4dCAyLzJdIHFlZDogQWRkIEFQSSBmb3IgZmxh
c2hpbmcNCj4gPiB0aGUgbnZtDQo+ID4gYXR0cmlidXRlcy4NCj4gPiANCj4gPiBFeHRlcm5hbCBF
bWFpbA0KPiA+IA0KPiA+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gLS0tLS0NCj4gPiBPbiBUdWUsIDIwMTktMDct
MjMgYXQgMjE6NTEgLTA3MDAsIFN1ZGFyc2FuYSBSZWRkeSBLYWxsdXJ1IHdyb3RlOg0KPiA+ID4g
VGhlIHBhdGNoIGFkZHMgZHJpdmVyIGludGVyZmFjZSBmb3IgcmVhZGluZyB0aGUgTlZNIGNvbmZp
Zw0KPiA+ID4gcmVxdWVzdCBhbmQNCj4gPiA+IHVwZGF0ZSB0aGUgYXR0cmlidXRlcyBvbiBudm0g
Y29uZmlnIGZsYXNoIHBhcnRpdGlvbi4NCj4gPiA+IA0KPiA+IA0KPiA+IFlvdSBkaWRuJ3Qgbm90
IHVzZSB0aGUgZ2V0X2NmZyBBUEkgeW91IGFkZGVkIGluIHByZXZpb3VzIHBhdGNoLg0KPiBUaGFu
a3MgZm9yIHlvdXIgcmV2aWV3LiBXaWxsIG1vdmUgdGhpcyBBUEkgdG8gdGhlIG5leHQgcGF0Y2gg
c2VyaWVzDQo+IHdoaWNoIHdpbGwgcGxhbiB0byBzZW5kIHNob3J0bHkuDQo+IA0KPiA+IEFsc28g
Y2FuIHlvdSBwbGVhc2UgY2xhcmlmeSBob3cgdGhlIHVzZXIgcmVhZHMvd3JpdGUgZnJvbS90byBO
Vk0NCj4gPiBjb25maWcNCj4gPiA/IGkgbWVhbiB3aGF0IFVBUElzIGFuZCB0b29scyBhcmUgYmVp
bmcgdXNlZCA/DQo+IE5WTSBjb25maWcvcGFydGl0aW9uIHdpbGwgYmUgdXBkYXRlZCB1c2luZyBl
dGh0b29sIGZsYXNoIHVwZGF0ZQ0KPiBjb21tYW5kIChpLmUuLCBldGh0b29sIC1mKSBqdXN0IGxp
a2UgdGhlIHVwZGF0ZSBvZiANCj4gb3RoZXIgZmxhc2ggcGFydGl0aW9ucyBvZiBxZWQgZGV2aWNl
LiBFeGFtcGxlIGNvZGUgcGF0aCwNCj4gICBldGhvb2wtZmxhc2hfZGV2aWNlIC0tPiBxZWRlX2Zs
YXNoX2RldmljZSgpIC0tPiBxZWRfbnZtX2ZsYXNoKCkgLS0+IA0KPiBxZWRfbnZtX2ZsYXNoX2Nm
Z193cml0ZSgpDQo+IA0KDQpJIHNlZSwgdGhhbmtzIGZvciB0aGUgY2xhcmlmaWNhdGlvbi4NCg==

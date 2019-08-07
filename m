Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A13842AA
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 04:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbfHGCz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 22:55:57 -0400
Received: from mail-eopbgr710066.outbound.protection.outlook.com ([40.107.71.66]:58512
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726518AbfHGCz4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 22:55:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYeUUlhRWVmZ9xfH3PwMGkIoJYOMVI50LkkdJNBpocBpvcqYojmLFiDcWzwRmRUSD1Vm0VRTcnfdMYgxREH0uy2nVy93Mn3GztSQjs9/5dkSqGbA+MqtAdF4goIj8eF5Uol256LH7Vs2l/9RTqpHEvUxNFF4dEn85BxVzX4Hq/UhSsxB2eK8KAY615aLWvHe0Am8T6feYvvNfAVStJ4gRrdffOZp8xCtAeqUUbAK+PMfNXOMzlNjd1S1pBB7ruSjOpzY4XkRWN16HXeeQAYgUD7D3ZhZMc0+GSt++y/AN0L3ezjSOnXFaYjmUhNphYafDp6iTDE8VSliHj7GKT9tRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WppfqCVJqwNBN2+zc62wPd6NKKvq7SDUv3AGXGjGq2g=;
 b=CnnvfM8x+Fx1sAMRwVStAxS4uSsadewKaCuOg2aUK9kwXqCO2BR++lgsymv2rpEqrAA7bOeW9FByoGy+hk+Hss8WCetkpSngaP6Ly/8TXRaI0SbrGEV3oDchJR1zmYAwvWJzzqKDblDSKHcoy1GkNqqMipCYxh40kWRSVrfgoqbPiU67Rrhu/w8gCI8kgXs4b9GhspsUavDCLc8chBSYC/aryI15Y03f9IsGwgAvIbLnz/u2lt6Hnr0JmsxtqHgNJeb1AGI9eYmfXSSFspSSWlzV5HgUIO+UPBldVndVY+n2SFgaDS7u+QfqzdYHjXk7Vzmbzt6MvFuPbSD4ipRpBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=ericsson.com;dmarc=pass action=none
 header.from=ericsson.com;dkim=pass header.d=ericsson.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WppfqCVJqwNBN2+zc62wPd6NKKvq7SDUv3AGXGjGq2g=;
 b=opWH3gwPcCghdShuPjXz9HEgR/2jngkDK9WyqChFln4gy0NcaVbsWF5AdOerICWvSCQRE9iOqVW0VvrpUANs2IcRGDgb97R599fg6aztg7QS2DMWZYnTLOtuMznxttbDbYGzOm6BdP+MQXRANRe5UH79icrgUqnOh3GTWFak86o=
Received: from CH2PR15MB3575.namprd15.prod.outlook.com (10.255.156.17) by
 CH2PR15MB3670.namprd15.prod.outlook.com (52.132.229.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Wed, 7 Aug 2019 02:55:51 +0000
Received: from CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::ecc4:bffd:8512:a8b6]) by CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::ecc4:bffd:8512:a8b6%2]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 02:55:51 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Slowness forming TIPC cluster with explicit node addresses
Thread-Topic: Slowness forming TIPC cluster with explicit node addresses
Thread-Index: AQHVQ0Hkw5M86TmlWkazctTgG4cJIabc5XqAgALa5YCABtFugIAFBHpw//9MBoCABC4cMA==
Date:   Wed, 7 Aug 2019 02:55:51 +0000
Message-ID: <CH2PR15MB35759E27F2A01FAE59AB66809AD40@CH2PR15MB3575.namprd15.prod.outlook.com>
References: <1564097836.11887.16.camel@alliedtelesis.co.nz>
         <CH2PR15MB35754D65AB240A74AE488E719AC00@CH2PR15MB3575.namprd15.prod.outlook.com>
         <1564347861.9737.25.camel@alliedtelesis.co.nz>
         <1564722689.4914.27.camel@alliedtelesis.co.nz>
         <CH2PR15MB3575BF6FC4001C19B8A789559ADB0@CH2PR15MB3575.namprd15.prod.outlook.com>
 <1564959879.27215.18.camel@alliedtelesis.co.nz>
In-Reply-To: <1564959879.27215.18.camel@alliedtelesis.co.nz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [71.190.216.107]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7f43d45-76fe-4eed-ffd0-08d71ae2c227
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3670;
x-ms-traffictypediagnostic: CH2PR15MB3670:
x-microsoft-antispam-prvs: <CH2PR15MB36707E10EA69AD923309E4579AD40@CH2PR15MB3670.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(199004)(189003)(13464003)(4326008)(55016002)(76116006)(2501003)(66556008)(25786009)(8936002)(14444005)(6436002)(64756008)(81166006)(305945005)(7736002)(256004)(8676002)(9686003)(81156014)(54906003)(53936002)(66446008)(66946007)(6246003)(478600001)(229853002)(68736007)(66476007)(6116002)(5660300002)(86362001)(6506007)(53546011)(76176011)(66066001)(102836004)(3846002)(7696005)(52536014)(99286004)(74316002)(26005)(71200400001)(14454004)(476003)(71190400001)(2906002)(110136005)(11346002)(44832011)(33656002)(486006)(186003)(316002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR15MB3670;H:CH2PR15MB3575.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4/uzE/rvKqsoN5Irb5jVJAdhQs8pbhpGL8z19x+yGAu7BOxOUNlptNXknAKWddJt41lzJkz36EtNHdiizsCiCkm/v6dN5Eli6fNWoJf7vkSFQmtXtNb9rVRlh7lQgl1vYvjovmUnnXXYvPuVnZaRR0uh+TNy71r1PwnZWoGlHAYiWc3nWdyuKXRiYJXEIYpw6sj3W3L7x9iQOX5iWfspIrJhT/Sue5pkXhqCrcdYbNyQMFoZ9JP0VrGAth9UfiLiTBYa7aTK01Y/ATI8WVhNXolt1ZbTC0Lx+szIO53u+j8+7g/SRP8XpHkB0vTxsqAyWs1zH2cnpx9nVOduhouj2lz/jkYyHDbAvlaVaH/tgrzta+m5T9AroSH5CIlSpCIkyD1iKXNQdn9KRSo+BnInaA96AMPkhKFKqibORmDmkkw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f43d45-76fe-4eed-ffd0-08d71ae2c227
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 02:55:51.3119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jon.maloy@ericsson.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3670
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2hyaXMgUGFja2hhbSA8
Q2hyaXMuUGFja2hhbUBhbGxpZWR0ZWxlc2lzLmNvLm56Pg0KPiBTZW50OiA0LUF1Zy0xOSAxOTow
NQ0KPiBUbzogSm9uIE1hbG95IDxqb24ubWFsb3lAZXJpY3Nzb24uY29tPjsgdGlwYy0NCj4gZGlz
Y3Vzc2lvbkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQNCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFNsb3duZXNz
IGZvcm1pbmcgVElQQyBjbHVzdGVyIHdpdGggZXhwbGljaXQgbm9kZSBhZGRyZXNzZXMNCj4gDQo+
IE9uIFN1biwgMjAxOS0wOC0wNCBhdCAyMTo1MyArMDAwMCwgSm9uIE1hbG95IHdyb3RlOg0KPiA+
DQo+ID4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IG5l
dGRldi1vd25lckB2Z2VyLmtlcm5lbC5vcmcgPG5ldGRldi1vd25lckB2Z2VyLmtlcm5lbC5vcmc+
DQo+IE9uDQo+ID4gPiBCZWhhbGYgT2YgQ2hyaXMgUGFja2hhbQ0KPiA+ID4gU2VudDogMi1BdWct
MTkgMDE6MTENCj4gPiA+IFRvOiBKb24gTWFsb3kgPGpvbi5tYWxveUBlcmljc3Nvbi5jb20+OyB0
aXBjLQ0KPiA+ID4gZGlzY3Vzc2lvbkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQNCj4gPiA+IENjOiBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4g
PiBTdWJqZWN0OiBSZTogU2xvd25lc3MgZm9ybWluZyBUSVBDIGNsdXN0ZXIgd2l0aCBleHBsaWNp
dCBub2RlDQo+ID4gPiBhZGRyZXNzZXMNCj4gPiA+DQo+ID4gPiBPbiBNb24sIDIwMTktMDctMjkg
YXQgMDk6MDQgKzEyMDAsIENocmlzIFBhY2toYW0gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IE9u
IEZyaSwgMjAxOS0wNy0yNiBhdCAxMzozMSArMDAwMCwgSm9uIE1hbG95IHdyb3RlOg0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+DQo+ID4g
PiA+ID4gPg0KPiA+ID4gPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+ID4g
PiA+IEZyb206IG5ldGRldi1vd25lckB2Z2VyLmtlcm5lbC5vcmcgPG5ldGRldi0NCj4gPiA+IG93
bmVyQHZnZXIua2VybmVsLm9yZz4NCj4gPiA+ID4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+IE9uIEJlaGFsZiBPZiBDaHJpcyBQYWNraGFtDQo+ID4gPiA+ID4gPiBTZW50OiAy
NS1KdWwtMTkgMTk6MzcNCj4gPiA+ID4gPiA+IFRvOiB0aXBjLWRpc2N1c3Npb25AbGlzdHMuc291
cmNlZm9yZ2UubmV0DQo+ID4gPiA+ID4gPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gPiA+ID4gU3ViamVjdDogU2xvd25lc3Mg
Zm9ybWluZyBUSVBDIGNsdXN0ZXIgd2l0aCBleHBsaWNpdCBub2RlDQo+ID4gPiA+ID4gPiBhZGRy
ZXNzZXMNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBIaSwNCj4gPiA+ID4gPiA+DQo+ID4gPiA+
ID4gPiBJJ20gaGF2aW5nIHByb2JsZW1zIGZvcm1pbmcgYSBUSVBDIGNsdXN0ZXIgYmV0d2VlbiAy
IG5vZGVzLg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFRoaXMgaXMgdGhlIGJhc2ljIHN0ZXBz
IEknbSBnb2luZyB0aHJvdWdoIG9uIGVhY2ggbm9kZS4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4g
PiBtb2Rwcm9iZSB0aXBjDQo+ID4gPiA+ID4gPiBpcCBsaW5rIHNldCBldGgyIHVwDQo+ID4gPiA+
ID4gPiB0aXBjIG5vZGUgc2V0IGFkZHIgMS4xLjUgIyBvciAxLjEuNiB0aXBjIGJlYXJlciBlbmFi
bGUgbWVkaWENCj4gPiA+ID4gPiA+IGV0aCBkZXYgZXRoMA0KPiA+ID4gPiA+IGV0aDIsIEkgYXNz
dW1lLi4uDQo+ID4gPiA+ID4NCj4gPiA+ID4gWWVzIHNvcnJ5IEkga2VlcCBzd2l0Y2hpbmcgYmV0
d2VlbiBiZXR3ZWVuIEV0aGVybmV0IHBvcnRzIGZvcg0KPiA+ID4gPiB0ZXN0aW5nDQo+ID4gPiA+
IHNvIEkgaGFuZCBlZGl0ZWQgdGhlIGVtYWlsLg0KPiA+ID4gPg0KPiA+ID4gPiA+DQo+ID4gPiA+
ID4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+DQo+
ID4gPiA+ID4gPiBUaGVuIHRvIGNvbmZpcm0gaWYgdGhlIGNsdXN0ZXIgaXMgZm9ybWVkIEkgdXNl
wqB0aXBjIGxpbmsgbGlzdA0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFtyb290QG5vZGUtNSB+
XSMgdGlwYyBsaW5rIGxpc3QNCj4gPiA+ID4gPiA+IGJyb2FkY2FzdC1saW5rOiB1cA0KPiA+ID4g
PiA+ID4gLi4uDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gTG9va2luZyBhdCB0Y3BkdW1wIHRo
ZSB0d28gbm9kZXMgYXJlIHNlbmRpbmcgcGFja2V0cw0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+
IDIyOjMwOjA1Ljc4MjMyMCBUSVBDIHYyLjAgMS4xLjUgPiAwLjAuMCwgaGVhZGVybGVuZ3RoIDYw
DQo+ID4gPiA+ID4gPiBieXRlcywNCj4gPiA+ID4gPiA+IE1lc3NhZ2VTaXplDQo+ID4gPiA+ID4g
PiA3NiBieXRlcywgTmVpZ2hib3IgRGV0ZWN0aW9uIFByb3RvY29sIGludGVybmFsLCBtZXNzYWdl
VHlwZQ0KPiA+ID4gPiA+ID4gTGluaw0KPiA+ID4gPiA+ID4gcmVxdWVzdA0KPiA+ID4gPiA+ID4g
MjI6MzA6MDUuODYzNTU1IFRJUEMgdjIuMCAxLjEuNiA+IDAuMC4wLCBoZWFkZXJsZW5ndGggNjAN
Cj4gPiA+ID4gPiA+IGJ5dGVzLA0KPiA+ID4gPiA+ID4gTWVzc2FnZVNpemUNCj4gPiA+ID4gPiA+
IDc2IGJ5dGVzLCBOZWlnaGJvciBEZXRlY3Rpb24gUHJvdG9jb2wgaW50ZXJuYWwsIG1lc3NhZ2VU
eXBlDQo+ID4gPiA+ID4gPiBMaW5rDQo+ID4gPiA+ID4gPiByZXF1ZXN0DQo+ID4gPiA+ID4gPg0K
PiA+ID4gPiA+ID4gRXZlbnR1YWxseSAoYWZ0ZXIgYSBmZXcgbWludXRlcykgdGhlIGxpbmsgZG9l
cyBjb21lIHVwDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gW3Jvb3RAbm9kZS02wqB+XSMgdGlw
YyBsaW5rIGxpc3QNCj4gPiA+ID4gPiA+IGJyb2FkY2FzdC1saW5rOiB1cA0KPiA+ID4gPiA+ID4g
MTAwMTAwNjpldGgyLTEwMDEwMDU6ZXRoMjogdXANCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBb
cm9vdEBub2RlLTXCoH5dIyB0aXBjIGxpbmsgbGlzdA0KPiA+ID4gPiA+ID4gYnJvYWRjYXN0LWxp
bms6IHVwDQo+ID4gPiA+ID4gPiAxMDAxMDA1OmV0aDItMTAwMTAwNjpldGgyOiB1cA0KPiA+ID4g
PiA+ID4NCj4gPiA+ID4gPiA+IFdoZW4gSSByZW1vdmUgdGhlICJ0aXBjIG5vZGUgc2V0IGFkZHIi
IHRoaW5ncyBzZWVtIHRvIGtpY2sNCj4gPiA+ID4gPiA+IGludG8NCj4gPiA+ID4gPiA+IGxpZmUg
c3RyYWlnaHQgYXdheQ0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFtyb290QG5vZGUtNSB+XSMg
dGlwYyBsaW5rIGxpc3QNCj4gPiA+ID4gPiA+IGJyb2FkY2FzdC1saW5rOiB1cA0KPiA+ID4gPiA+
ID4gMDA1MGI2MWJkMmFhOmV0aDItMDA1MGI2MWU2ZGZhOmV0aDI6IHVwDQo+ID4gPiA+ID4gPg0K
PiA+ID4gPiA+ID4gU28gdGhlcmUgYXBwZWFycyB0byBiZSBzb21lIGRpZmZlcmVuY2UgaW4gYmVo
YXZpb3VyIGJldHdlZW4NCj4gPiA+ID4gPiA+IGhhdmluZw0KPiA+ID4gPiA+ID4gYW4gZXhwbGlj
aXQgbm9kZSBhZGRyZXNzIGFuZCB1c2luZyB0aGUgZGVmYXVsdC4gVW5mb3J0dW5hdGVseQ0KPiA+
ID4gPiA+ID4gb3VyDQo+ID4gPiA+ID4gPiBhcHBsaWNhdGlvbiByZWxpZXMgb24gc2V0dGluZyB0
aGUgbm9kZSBhZGRyZXNzZXMuDQo+ID4gPiA+ID4gSSBkbyB0aGlzIG1hbnkgdGltZXMgYSBkYXks
IHdpdGhvdXQgYW55IHByb2JsZW1zLiBJZiB0aGVyZQ0KPiA+ID4gPiA+IHdvdWxkIGJlDQo+ID4g
PiA+ID4gYW55IHRpbWUgZGlmZmVyZW5jZSwgSSB3b3VsZCBleHBlY3QgdGhlICdhdXRvIGNvbmZp
Z3VyYWJsZScNCj4gPiA+ID4gPiB2ZXJzaW9uDQo+ID4gPiA+ID4gdG8gYmUgc2xvd2VyLCBiZWNh
dXNlIGl0IGludm9sdmVzIGEgREFEIHN0ZXAuDQo+ID4gPiA+ID4gQXJlIHlvdSBzdXJlIHlvdSBk
b24ndCBoYXZlIGFueSBvdGhlciBub2RlcyBydW5uaW5nIGluIHlvdXINCj4gPiA+ID4gPiBzeXN0
ZW0/DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiAvLy9qb24NCj4gPiA+ID4gPg0KPiA+ID4gPiBOb3Bl
IHRoZSB0d28gbm9kZXMgYXJlIGNvbm5lY3RlZCBiYWNrIHRvIGJhY2suIERvZXMgdGhlIG51bWJl
ciBvZg0KPiA+ID4gPiBFdGhlcm5ldCBpbnRlcmZhY2VzIG1ha2UgYSBkaWZmZXJlbmNlPyBBcyB5
b3UgY2FuIHNlZSBJJ3ZlIGdvdCAzDQo+ID4gPiA+IG9uDQo+ID4gPiA+IGVhY2ggbm9kZS4gT25l
IGlzIGNvbXBsZXRlbHkgZGlzY29ubmVjdGVkLCBvbmUgaXMgZm9yIGJvb3RpbmcNCj4gPiA+ID4g
b3Zlcg0KPiA+ID4gPiBURlRQDQo+ID4gPiA+IMKgKG9ubHkgdXNlZCBieSBVLWJvb3QpIGFuZCB0
aGUgb3RoZXIgaXMgdGhlIFVTQiBFdGhlcm5ldCBJJ20NCj4gPiA+ID4gdXNpbmcgZm9yDQo+ID4g
PiA+IHRlc3RpbmcuDQo+ID4gPiA+DQo+ID4gPiBTbyBJIGNhbiBzdGlsbCByZXByb2R1Y2UgdGhp
cyBvbiBub2RlcyB0aGF0IG9ubHkgaGF2ZSBvbmUgbmV0d29yaw0KPiA+ID4gaW50ZXJmYWNlIGFu
ZA0KPiA+ID4gYXJlIHRoZSBvbmx5IHRoaW5ncyBjb25uZWN0ZWQuDQo+ID4gPg0KPiA+ID4gSSBk
aWQgZmluZCBvbmUgdGhpbmcgdGhhdCBoZWxwcw0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9u
ZXQvdGlwYy9kaXNjb3Zlci5jIGIvbmV0L3RpcGMvZGlzY292ZXIuYyBpbmRleA0KPiA+ID4gYzEz
OGQ2OGU4YTY5Li40OTkyMWRhZDQwNGEgMTAwNjQ0DQo+ID4gPiAtLS0gYS9uZXQvdGlwYy9kaXNj
b3Zlci5jDQo+ID4gPiArKysgYi9uZXQvdGlwYy9kaXNjb3Zlci5jDQo+ID4gPiBAQCAtMzU4LDEw
ICszNTgsMTAgQEAgaW50IHRpcGNfZGlzY19jcmVhdGUoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3QN
Cj4gPiA+IHRpcGNfYmVhcmVyICpiLA0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoHRpcGNfZGlzY19p
bml0X21zZyhuZXQsIGQtPnNrYiwgRFNDX1JFUV9NU0csIGIpOw0KPiA+ID4NCj4gPiA+IMKgwqDC
oMKgwqDCoMKgwqAvKiBEbyB3ZSBuZWVkIGFuIGFkZHJlc3MgdHJpYWwgcGVyaW9kIGZpcnN0ID8g
Ki8NCj4gPiA+IC3CoMKgwqDCoMKgwqDCoGlmICghdGlwY19vd25fYWRkcihuZXQpKSB7DQo+ID4g
PiArLy/CoMKgwqDCoMKgaWYgKCF0aXBjX293bl9hZGRyKG5ldCkpIHsNCj4gPiA+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdG4tPmFkZHJfdHJpYWxfZW5kID0gamlmZmllcyArDQo+
ID4gPiBtc2Vjc190b19qaWZmaWVzKDEwMDApOw0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBtc2dfc2V0X3R5cGUoYnVmX21zZyhkLT5za2IpLCBEU0NfVFJJQUxfTVNHKTsN
Cj4gPiA+IC3CoMKgwqDCoMKgwqDCoH0NCj4gPiA+ICsvL8KgwqDCoMKgwqB9DQo+ID4gPiDCoMKg
wqDCoMKgwqDCoMKgbWVtY3B5KCZkLT5kZXN0LCBkZXN0LCBzaXplb2YoKmRlc3QpKTsNCj4gPiA+
IMKgwqDCoMKgwqDCoMKgwqBkLT5uZXQgPSBuZXQ7DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgZC0+
YmVhcmVyX2lkID0gYi0+aWRlbnRpdHk7DQo+ID4gPg0KPiA+ID4gSSB0aGluayBiZWNhdXNlIHdp
dGggcHJlLWNvbmZpZ3VyZWQgYWRkcmVzc2VzIHRoZSBkdXBsaWNhdGUgYWRkcmVzcw0KPiA+ID4g
ZGV0ZWN0aW9uDQo+ID4gPiBpcyBza2lwcGVkIHRoZSBzaG9ydGVyIGluaXQgcGhhc2UgaXMgc2tp
cHBlZC4gV291bGQgaXMgbWFrZSBzZW5zZQ0KPiA+ID4gdG8NCj4gPiA+IHVuY29uZGl0aW9uYWxs
eSBkbyB0aGUgdHJpYWwgc3RlcD8gT3IgaXMgdGhlcmUgc29tZSBiZXR0ZXIgd2F5IHRvDQo+ID4g
PiBnZXQgdGhpbmdzIHRvDQo+ID4gPiB0cmFuc2l0aW9uIHdpdGggcHJlLWFzc2lnbmVkIGFkZHJl
c3Nlcy4NCj4gPg0KPiA+IEkgYW0gb24gdmFjYXRpb24gdW50aWwgdGhlIGVuZCBvZiBuZXh0LXdl
ZWssIHNvIEkgY2FuJ3QgZ2l2ZSB5b3UgYW55DQo+ID4gZ29vZCBhbmFseXNpcyByaWdodCBub3cu
DQo+IA0KPiBUaGFua3MgZm9yIHRha2luZyB0aGUgdGltZSB0byByZXNwb25kLg0KPiANCj4gPiBU
byBkbyB0aGUgdHJpYWwgc3RlcCBkb2VzbuKAmXQgbWFrZSBtdWNoIHNlbnNlIHRvIG1lLCAtaXQg
d291bGQgb25seQ0KPiA+IGRlbGF5IHRoZSBzZXR1cCB1bm5lY2Vzc2FyaWx5IChidXQgd2l0aCBv
bmx5IDEgc2Vjb25kKS4NCj4gPiBDYW4geW91IGNoZWNrIHRoZSBpbml0aWFsIHZhbHVlIG9mIGFk
ZHJfdHJpYWxfZW5kIHdoZW4gdGhlcmUgYSBwcmUtDQo+ID4gY29uZmlndXJlZCBhZGRyZXNzPw0K
PiANCj4gSSBoYWQgdGhlIHNhbWUgdGhvdWdodC4gRm9yIGJvdGggbXkgZGV2aWNlcyAnYWRkcl90
cmlhbF9lbmQgPSAwJyBzbyBJDQo+IHRoaW5rwqB0aXBjX2Rpc2NfYWRkcl90cmlhbF9tc2cgc2hv
dWxkIGVuZCB1cCB3aXRoIHRyaWFsID09IGZhbHNlDQoNCkkgc3VnZ2VzdCB5b3UgdHJ5IGluaXRp
YWxpemluZyBpdCB0byBqaWZmaWVzIGFuZCBzZWUgd2hhdCBoYXBwZW5zLg0KDQovLy9qb24NCg0K
PiANCj4gPg0KPiA+IC8vL2pvbg0KPiA+DQo=

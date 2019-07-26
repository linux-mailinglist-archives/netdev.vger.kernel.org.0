Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 484237678A
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfGZNcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:32:18 -0400
Received: from mail-eopbgr750049.outbound.protection.outlook.com ([40.107.75.49]:5950
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726364AbfGZNcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 09:32:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAFc8E56qWZKq4c8hu3N9XhHDFtsU8IO6PjsnOhulvliZM0dZz03AAbZGgirammmR4uEgAe3GOnXuwbWdwBkANVRORtg7mNmNx2cTbG/Qvgte5QOvJHI42V9h8dlpHAt1wv4vCJeIuE4AUZErEBTG0GMVKEFYVOmZWry8n8ZdCL8viMTLPSF8N6XYVuxU1BIHvtyaIRjMySL7VbWLG/Bw5NM4PieWMb5KcpjOHjFy65eCjW+kqGVRV5NCS3EyrrG8t6eeJBuwkglonWUd3gnCMuwbgBzIGl2rOZZo5NPFIvtJb3EmMLFaetbC5F+2tp7ODlEzyGJSSbGC6cjtdT9QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0S9fV5i8z3tagHuyFqDcW1jslyurLKQNiQEDAklEK4=;
 b=S8ESLwVAVNSEkr1qoBdqtbwWyFN2NboB3/JIwJFf2iymeZHp7MSOqoAytW9woCKicG6MNh5quBDUMvtBcColsn+kywnBN+7d66T3NIrTBEM2x1mtHwebBKzSz3b/MX/3txrC3rHRPwRM/DOSwXT83QiLOll+LAAYOc5Xf3ziZUr1S3TU3Tyu4vhYNHnAzeNuyuEHPGR8RXJdv9NkW19RF9gAlAyiisXRlfU0Kw0cl2k1gAfqEn7GmBtMdhS0NP1UF/y+3H+EVQjSqIhzk4wRVoF6zQyons7xd8VEsQkePavWqPigHP1UYlHHaFEvxvs1Cseocw+t8Lj5jcLo3YvqQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=ericsson.com;dmarc=pass action=none
 header.from=ericsson.com;dkim=pass header.d=ericsson.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0S9fV5i8z3tagHuyFqDcW1jslyurLKQNiQEDAklEK4=;
 b=TWfzoOfxNFZNhzmJSPY/8mvFIdZ0uxzeNQnGyE4CYuBVB5VdJRo9vNMNAEApxZA8CX6/XH0QyoVkC7L0h0ilyQli456tJGbC8Ue7uDeOG9y+PnvtyYTI+RYkbJovm9C7FoiCC94P59SkrITlVveIM5vb4Vlf6bncUbtso3PSrSU=
Received: from CH2PR15MB3575.namprd15.prod.outlook.com (10.255.156.17) by
 CH2PR15MB3654.namprd15.prod.outlook.com (52.132.229.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Fri, 26 Jul 2019 13:31:33 +0000
Received: from CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::ecc4:bffd:8512:a8b6]) by CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::ecc4:bffd:8512:a8b6%2]) with mapi id 15.20.2115.005; Fri, 26 Jul 2019
 13:31:33 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Slowness forming TIPC cluster with explicit node addresses
Thread-Topic: Slowness forming TIPC cluster with explicit node addresses
Thread-Index: AQHVQ0Hkw5M86TmlWkazctTgG4cJIabc5XqA
Date:   Fri, 26 Jul 2019 13:31:33 +0000
Message-ID: <CH2PR15MB35754D65AB240A74AE488E719AC00@CH2PR15MB3575.namprd15.prod.outlook.com>
References: <1564097836.11887.16.camel@alliedtelesis.co.nz>
In-Reply-To: <1564097836.11887.16.camel@alliedtelesis.co.nz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [24.225.233.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2be64543-4892-458a-6b43-08d711cd9399
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3654;
x-ms-traffictypediagnostic: CH2PR15MB3654:
x-microsoft-antispam-prvs: <CH2PR15MB3654A777764C903BF0B2336E9AC00@CH2PR15MB3654.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(13464003)(11346002)(476003)(446003)(6246003)(486006)(66946007)(2501003)(229853002)(186003)(99286004)(76176011)(26005)(316002)(7696005)(9686003)(5660300002)(305945005)(6506007)(53546011)(7736002)(33656002)(64756008)(66556008)(66476007)(25786009)(53936002)(71200400001)(86362001)(52536014)(71190400001)(4326008)(14444005)(76116006)(256004)(68736007)(8936002)(6116002)(55016002)(6436002)(14454004)(8676002)(81166006)(2906002)(81156014)(66066001)(44832011)(74316002)(110136005)(54906003)(3846002)(66446008)(102836004)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR15MB3654;H:CH2PR15MB3575.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eu1KxgbqgEZ+Mi/AKLQI12Taf7l6po7hKt4ZjSmvokiB58GBuoBjPVphv335VasZNlINasGDpv3+yQeGt+Qpk93TtsnU+fB+wKsZqLlT4KUGmsZ7vGmGdH7VdLgdrA2SsJ0oWjmzav171nFr8lE3QRuVNfMeusUiXnCW1sA8HxNf9D0k0rwCg5KfdsyPtX6APuNnfZqosaDZyk60h7E+2BXZWMJknboz0HJM98+9AJuqzkYzvM1Vb7oe/iQCWlwQtRWLXTqZMBVD1odW/HitSrggVf50hkTMiF6/hz35kilQvL7/dmahnXsNbPPp6Wp5i9Xrw+D+mpGAxRiLdRErQvp9z12YasAm1ySRl/IufxlbDFHB0MRmiPyyngWP7Ss1XkQDkzzaRKpPxtyNHG2E06y4f9e0fmFaHSncHDbli9k=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be64543-4892-458a-6b43-08d711cd9399
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 13:31:33.7148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jon.maloy@ericsson.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3654
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbmV0ZGV2LW93bmVyQHZn
ZXIua2VybmVsLm9yZyA8bmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZz4gT24NCj4gQmVoYWxm
IE9mIENocmlzIFBhY2toYW0NCj4gU2VudDogMjUtSnVsLTE5IDE5OjM3DQo+IFRvOiB0aXBjLWRp
c2N1c3Npb25AbGlzdHMuc291cmNlZm9yZ2UubmV0DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFNsb3duZXNzIGZv
cm1pbmcgVElQQyBjbHVzdGVyIHdpdGggZXhwbGljaXQgbm9kZSBhZGRyZXNzZXMNCj4gDQo+IEhp
LA0KPiANCj4gSSdtIGhhdmluZyBwcm9ibGVtcyBmb3JtaW5nIGEgVElQQyBjbHVzdGVyIGJldHdl
ZW4gMiBub2Rlcy4NCj4gDQo+IFRoaXMgaXMgdGhlIGJhc2ljIHN0ZXBzIEknbSBnb2luZyB0aHJv
dWdoIG9uIGVhY2ggbm9kZS4NCj4gDQo+IG1vZHByb2JlIHRpcGMNCj4gaXAgbGluayBzZXQgZXRo
MiB1cA0KPiB0aXBjIG5vZGUgc2V0IGFkZHIgMS4xLjUgIyBvciAxLjEuNg0KPiB0aXBjIGJlYXJl
ciBlbmFibGUgbWVkaWEgZXRoIGRldiBldGgwDQoNCmV0aDIsIEkgYXNzdW1lLi4uDQoNCj4gDQo+
IFRoZW4gdG8gY29uZmlybSBpZiB0aGUgY2x1c3RlciBpcyBmb3JtZWQgSSB1c2XCoHRpcGMgbGlu
ayBsaXN0DQo+IA0KPiBbcm9vdEBub2RlLTUgfl0jIHRpcGMgbGluayBsaXN0DQo+IGJyb2FkY2Fz
dC1saW5rOiB1cA0KPiAuLi4NCj4gDQo+IExvb2tpbmcgYXQgdGNwZHVtcCB0aGUgdHdvIG5vZGVz
IGFyZSBzZW5kaW5nIHBhY2tldHMNCj4gDQo+IDIyOjMwOjA1Ljc4MjMyMCBUSVBDIHYyLjAgMS4x
LjUgPiAwLjAuMCwgaGVhZGVybGVuZ3RoIDYwIGJ5dGVzLCBNZXNzYWdlU2l6ZQ0KPiA3NiBieXRl
cywgTmVpZ2hib3IgRGV0ZWN0aW9uIFByb3RvY29sIGludGVybmFsLCBtZXNzYWdlVHlwZSBMaW5r
IHJlcXVlc3QNCj4gMjI6MzA6MDUuODYzNTU1IFRJUEMgdjIuMCAxLjEuNiA+IDAuMC4wLCBoZWFk
ZXJsZW5ndGggNjAgYnl0ZXMsIE1lc3NhZ2VTaXplDQo+IDc2IGJ5dGVzLCBOZWlnaGJvciBEZXRl
Y3Rpb24gUHJvdG9jb2wgaW50ZXJuYWwsIG1lc3NhZ2VUeXBlIExpbmsgcmVxdWVzdA0KPiANCj4g
RXZlbnR1YWxseSAoYWZ0ZXIgYSBmZXcgbWludXRlcykgdGhlIGxpbmsgZG9lcyBjb21lIHVwDQo+
IA0KPiBbcm9vdEBub2RlLTbCoH5dIyB0aXBjIGxpbmsgbGlzdA0KPiBicm9hZGNhc3QtbGluazog
dXANCj4gMTAwMTAwNjpldGgyLTEwMDEwMDU6ZXRoMjogdXANCj4gDQo+IFtyb290QG5vZGUtNcKg
fl0jIHRpcGMgbGluayBsaXN0DQo+IGJyb2FkY2FzdC1saW5rOiB1cA0KPiAxMDAxMDA1OmV0aDIt
MTAwMTAwNjpldGgyOiB1cA0KPiANCj4gV2hlbiBJIHJlbW92ZSB0aGUgInRpcGMgbm9kZSBzZXQg
YWRkciIgdGhpbmdzIHNlZW0gdG8ga2ljayBpbnRvIGxpZmUgc3RyYWlnaHQNCj4gYXdheQ0KPiAN
Cj4gW3Jvb3RAbm9kZS01IH5dIyB0aXBjIGxpbmsgbGlzdA0KPiBicm9hZGNhc3QtbGluazogdXAN
Cj4gMDA1MGI2MWJkMmFhOmV0aDItMDA1MGI2MWU2ZGZhOmV0aDI6IHVwDQo+IA0KPiBTbyB0aGVy
ZSBhcHBlYXJzIHRvIGJlIHNvbWUgZGlmZmVyZW5jZSBpbiBiZWhhdmlvdXIgYmV0d2VlbiBoYXZp
bmcgYW4NCj4gZXhwbGljaXQgbm9kZSBhZGRyZXNzIGFuZCB1c2luZyB0aGUgZGVmYXVsdC4gVW5m
b3J0dW5hdGVseSBvdXIgYXBwbGljYXRpb24NCj4gcmVsaWVzIG9uIHNldHRpbmcgdGhlIG5vZGUg
YWRkcmVzc2VzLg0KDQpJIGRvIHRoaXMgbWFueSB0aW1lcyBhIGRheSwgd2l0aG91dCBhbnkgcHJv
YmxlbXMuIElmIHRoZXJlIHdvdWxkIGJlIGFueSB0aW1lIGRpZmZlcmVuY2UsIEkgd291bGQgZXhw
ZWN0IHRoZSAnYXV0byBjb25maWd1cmFibGUnIHZlcnNpb24gdG8gYmUgc2xvd2VyLCBiZWNhdXNl
IGl0IGludm9sdmVzIGEgREFEIHN0ZXAuDQpBcmUgeW91IHN1cmUgeW91IGRvbid0IGhhdmUgYW55
IG90aGVyIG5vZGVzIHJ1bm5pbmcgaW4geW91ciBzeXN0ZW0/DQoNCi8vL2pvbg0KDQoNCj4gDQo+
IFtyb290QG5vZGUtNSB+XSMgdW5hbWUgLWENCj4gTGludXggbGludXhib3ggNS4yLjAtYXQxKyAj
OCBTTVAgVGh1IEp1bCAyNSAyMzoyMjo0MSBVVEMgMjAxOSBwcGMNCj4gR05VL0xpbnV4DQo+IA0K
PiBBbnkgdGhvdWdodHMgb24gdGhlIHByb2JsZW0/DQo=

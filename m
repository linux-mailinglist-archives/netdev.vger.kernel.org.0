Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D48080CD9
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 23:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfHDVyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 17:54:03 -0400
Received: from mail-eopbgr730082.outbound.protection.outlook.com ([40.107.73.82]:21952
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726346AbfHDVyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 17:54:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3aI2V+SQ7ufWctUgxaW5W5pmOkIdhb8OeHAPRvzbGheNBW1Fo+t2DgPpX95o6oD8IVlz9sRdB7yu8OJa1lsmx9VZDVIfzfV0gVPrVO3x3/nORWd9mVxKIGI9p0wN1HFckbT/x28I65vcURoS6Wo1bW7iPZ8LSO+1NjAG21TwDVVx9lPm0UxCL9ZGcXl5LVhZyZRjIk0FRpDSmnFpdgfGEtLrQf49LXYpCZstvHm/owO24AntmSSzfY2glF5Elh/huhDxyYs84cBR8MrM7oFraXpEMVbKSRCVXiYjkBrK8YbONjy+ZrOThGzNeR9OrDxDRKLZ3LHL90ljHmeQriONw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+BIf4P0iZlO4rX4GpNbyh97UMT8hDO6eZkdxnzvTIc=;
 b=FIQRbZpDCMiDx2v6YorTzXjBUFFL7hBK1ly+tdlxg2IphC2rO6ba8tu2PuX+DtVQoVWALNIs+m9vEXDyf485at7c0erYLz/4f2ChnykwQ8aoOzV29DGAlJkOe/Ykva25qitU1qUFnI9llnnuJSWSBTGDR2GVYrVX2Ya/k7iPx7WgxWWXJdeSo3AqOItoS83L6N41vUdHHT8TrBKoks50gh0oH4S48lIDVN5OrD6rGI4EyiUXeLHx2/Jtp4GL3lGBWdH84txhpDec/OYtBpcqixTdnNBbwfaRcC8ONS0riCpOAYuDNj0ps6zuxiH2sVoK7SiLTerjKbCG4y9O9R8scQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=ericsson.com;dmarc=pass action=none
 header.from=ericsson.com;dkim=pass header.d=ericsson.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+BIf4P0iZlO4rX4GpNbyh97UMT8hDO6eZkdxnzvTIc=;
 b=nZsQRSXTvhYodDBVS4TvpLz39CNmjv0aJuRFukCwYt3j+QEg6+xacSUlhIvWV752cTar5bBNp0cyI053LDi4buQ7t+jNFBhgWWexYdd5gohKj2ifLl06euO6IEpiIDM6hok1mt1V0PFbCR0OLVa41LaUaLT1WuKy5QFn2S39hfg=
Received: from CH2PR15MB3575.namprd15.prod.outlook.com (10.255.156.17) by
 CH2SPR01MB0016.namprd15.prod.outlook.com (10.141.52.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Sun, 4 Aug 2019 21:53:52 +0000
Received: from CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::ecc4:bffd:8512:a8b6]) by CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::ecc4:bffd:8512:a8b6%2]) with mapi id 15.20.2136.018; Sun, 4 Aug 2019
 21:53:52 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Slowness forming TIPC cluster with explicit node addresses
Thread-Topic: Slowness forming TIPC cluster with explicit node addresses
Thread-Index: AQHVQ0Hkw5M86TmlWkazctTgG4cJIabc5XqAgALa5YCABtFugIAFBHpw
Date:   Sun, 4 Aug 2019 21:53:52 +0000
Message-ID: <CH2PR15MB3575BF6FC4001C19B8A789559ADB0@CH2PR15MB3575.namprd15.prod.outlook.com>
References: <1564097836.11887.16.camel@alliedtelesis.co.nz>
         <CH2PR15MB35754D65AB240A74AE488E719AC00@CH2PR15MB3575.namprd15.prod.outlook.com>
         <1564347861.9737.25.camel@alliedtelesis.co.nz>
 <1564722689.4914.27.camel@alliedtelesis.co.nz>
In-Reply-To: <1564722689.4914.27.camel@alliedtelesis.co.nz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [24.225.233.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d046517-50cb-4ef8-9506-08d719263d42
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2SPR01MB0016;
x-ms-traffictypediagnostic: CH2SPR01MB0016:
x-microsoft-antispam-prvs: <CH2SPR01MB00165F9053AEAE1F1C308CA29ADB0@CH2SPR01MB0016.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0119DC3B5E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39850400004)(366004)(136003)(346002)(396003)(13464003)(199004)(189003)(14454004)(86362001)(5660300002)(4326008)(6246003)(7736002)(6436002)(26005)(52536014)(8676002)(2906002)(76116006)(71190400001)(71200400001)(229853002)(66446008)(64756008)(66556008)(476003)(446003)(186003)(99286004)(25786009)(66476007)(11346002)(66946007)(44832011)(478600001)(256004)(14444005)(486006)(8936002)(76176011)(66066001)(316002)(102836004)(6506007)(2501003)(81156014)(9686003)(53546011)(54906003)(110136005)(6116002)(3846002)(305945005)(74316002)(81166006)(55016002)(33656002)(68736007)(7696005)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2SPR01MB0016;H:CH2PR15MB3575.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VjtABl/P1Kr8VqgoEoq4cG7Wf12bX1sCnj8GM9zGwrOTNlPb+1CRKrwrDiGlffwGK31h9HzBmLSHwhWh/76oGiyS6GkBW2I4gG/3lTNy0zZyGJLt1MBeCzdz3fAQEUyzifpAVPHsRkCbiHzgOZu6H5HRxuU76OjtIkAh9dcmTgGP0yeU+0VdwEz4mtUCGkt1umZnbjD7WQkBYIGvWmxytHg48J9QsIIOZ+rRo0KJFhgcXRyAgo41m8n/q9Ax0gcChuz26161fORVGw6cYDe4MB/otONKkdaC6pYXCL/pefV6hf5ZADG+c7icsDLotuRYtExK4DkHpqfuMKNlgRfUKCm0z5MbvmO7l2ruWrmXwS5jtM7jc5r5HAAeIM/QCKQTHu8LlnNuu5ZshfuCVxCBc6S+SkH7ZaiTpKlSyD/CFng=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d046517-50cb-4ef8-9506-08d719263d42
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2019 21:53:52.1171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jon.maloy@ericsson.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2SPR01MB0016
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbmV0ZGV2LW93bmVyQHZn
ZXIua2VybmVsLm9yZyA8bmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZz4gT24NCj4gQmVoYWxm
IE9mIENocmlzIFBhY2toYW0NCj4gU2VudDogMi1BdWctMTkgMDE6MTENCj4gVG86IEpvbiBNYWxv
eSA8am9uLm1hbG95QGVyaWNzc29uLmNvbT47IHRpcGMtDQo+IGRpc2N1c3Npb25AbGlzdHMuc291
cmNlZm9yZ2UubmV0DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBTbG93bmVzcyBmb3JtaW5nIFRJUEMgY2x1
c3RlciB3aXRoIGV4cGxpY2l0IG5vZGUgYWRkcmVzc2VzDQo+IA0KPiBPbiBNb24sIDIwMTktMDct
MjkgYXQgMDk6MDQgKzEyMDAsIENocmlzIFBhY2toYW0gd3JvdGU6DQo+ID4gT24gRnJpLCAyMDE5
LTA3LTI2IGF0IDEzOjMxICswMDAwLCBKb24gTWFsb3kgd3JvdGU6DQo+ID4gPg0KPiA+ID4NCj4g
PiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+
ID4gRnJvbTogbmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZyA8bmV0ZGV2LQ0KPiBvd25lckB2
Z2VyLmtlcm5lbC5vcmc+DQo+ID4gPiA+IE9uIEJlaGFsZiBPZiBDaHJpcyBQYWNraGFtDQo+ID4g
PiA+IFNlbnQ6IDI1LUp1bC0xOSAxOTozNw0KPiA+ID4gPiBUbzogdGlwYy1kaXNjdXNzaW9uQGxp
c3RzLnNvdXJjZWZvcmdlLm5ldA0KPiA+ID4gPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gPiBTdWJqZWN0OiBTbG93bmVzcyBm
b3JtaW5nIFRJUEMgY2x1c3RlciB3aXRoIGV4cGxpY2l0IG5vZGUNCj4gPiA+ID4gYWRkcmVzc2Vz
DQo+ID4gPiA+DQo+ID4gPiA+IEhpLA0KPiA+ID4gPg0KPiA+ID4gPiBJJ20gaGF2aW5nIHByb2Js
ZW1zIGZvcm1pbmcgYSBUSVBDIGNsdXN0ZXIgYmV0d2VlbiAyIG5vZGVzLg0KPiA+ID4gPg0KPiA+
ID4gPiBUaGlzIGlzIHRoZSBiYXNpYyBzdGVwcyBJJ20gZ29pbmcgdGhyb3VnaCBvbiBlYWNoIG5v
ZGUuDQo+ID4gPiA+DQo+ID4gPiA+IG1vZHByb2JlIHRpcGMNCj4gPiA+ID4gaXAgbGluayBzZXQg
ZXRoMiB1cA0KPiA+ID4gPiB0aXBjIG5vZGUgc2V0IGFkZHIgMS4xLjUgIyBvciAxLjEuNiB0aXBj
IGJlYXJlciBlbmFibGUgbWVkaWEgZXRoDQo+ID4gPiA+IGRldiBldGgwDQo+ID4gPiBldGgyLCBJ
IGFzc3VtZS4uLg0KPiA+ID4NCj4gPiBZZXMgc29ycnkgSSBrZWVwIHN3aXRjaGluZyBiZXR3ZWVu
IGJldHdlZW4gRXRoZXJuZXQgcG9ydHMgZm9yIHRlc3RpbmcNCj4gPiBzbyBJIGhhbmQgZWRpdGVk
IHRoZSBlbWFpbC4NCj4gPg0KPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+
ID4gVGhlbiB0byBjb25maXJtIGlmIHRoZSBjbHVzdGVyIGlzIGZvcm1lZCBJIHVzZcKgdGlwYyBs
aW5rIGxpc3QNCj4gPiA+ID4NCj4gPiA+ID4gW3Jvb3RAbm9kZS01IH5dIyB0aXBjIGxpbmsgbGlz
dA0KPiA+ID4gPiBicm9hZGNhc3QtbGluazogdXANCj4gPiA+ID4gLi4uDQo+ID4gPiA+DQo+ID4g
PiA+IExvb2tpbmcgYXQgdGNwZHVtcCB0aGUgdHdvIG5vZGVzIGFyZSBzZW5kaW5nIHBhY2tldHMN
Cj4gPiA+ID4NCj4gPiA+ID4gMjI6MzA6MDUuNzgyMzIwIFRJUEMgdjIuMCAxLjEuNSA+IDAuMC4w
LCBoZWFkZXJsZW5ndGggNjAgYnl0ZXMsDQo+ID4gPiA+IE1lc3NhZ2VTaXplDQo+ID4gPiA+IDc2
IGJ5dGVzLCBOZWlnaGJvciBEZXRlY3Rpb24gUHJvdG9jb2wgaW50ZXJuYWwsIG1lc3NhZ2VUeXBl
IExpbmsNCj4gPiA+ID4gcmVxdWVzdA0KPiA+ID4gPiAyMjozMDowNS44NjM1NTUgVElQQyB2Mi4w
IDEuMS42ID4gMC4wLjAsIGhlYWRlcmxlbmd0aCA2MCBieXRlcywNCj4gPiA+ID4gTWVzc2FnZVNp
emUNCj4gPiA+ID4gNzYgYnl0ZXMsIE5laWdoYm9yIERldGVjdGlvbiBQcm90b2NvbCBpbnRlcm5h
bCwgbWVzc2FnZVR5cGUgTGluaw0KPiA+ID4gPiByZXF1ZXN0DQo+ID4gPiA+DQo+ID4gPiA+IEV2
ZW50dWFsbHkgKGFmdGVyIGEgZmV3IG1pbnV0ZXMpIHRoZSBsaW5rIGRvZXMgY29tZSB1cA0KPiA+
ID4gPg0KPiA+ID4gPiBbcm9vdEBub2RlLTbCoH5dIyB0aXBjIGxpbmsgbGlzdA0KPiA+ID4gPiBi
cm9hZGNhc3QtbGluazogdXANCj4gPiA+ID4gMTAwMTAwNjpldGgyLTEwMDEwMDU6ZXRoMjogdXAN
Cj4gPiA+ID4NCj4gPiA+ID4gW3Jvb3RAbm9kZS01wqB+XSMgdGlwYyBsaW5rIGxpc3QNCj4gPiA+
ID4gYnJvYWRjYXN0LWxpbms6IHVwDQo+ID4gPiA+IDEwMDEwMDU6ZXRoMi0xMDAxMDA2OmV0aDI6
IHVwDQo+ID4gPiA+DQo+ID4gPiA+IFdoZW4gSSByZW1vdmUgdGhlICJ0aXBjIG5vZGUgc2V0IGFk
ZHIiIHRoaW5ncyBzZWVtIHRvIGtpY2sgaW50bw0KPiA+ID4gPiBsaWZlIHN0cmFpZ2h0IGF3YXkN
Cj4gPiA+ID4NCj4gPiA+ID4gW3Jvb3RAbm9kZS01IH5dIyB0aXBjIGxpbmsgbGlzdA0KPiA+ID4g
PiBicm9hZGNhc3QtbGluazogdXANCj4gPiA+ID4gMDA1MGI2MWJkMmFhOmV0aDItMDA1MGI2MWU2
ZGZhOmV0aDI6IHVwDQo+ID4gPiA+DQo+ID4gPiA+IFNvIHRoZXJlIGFwcGVhcnMgdG8gYmUgc29t
ZSBkaWZmZXJlbmNlIGluIGJlaGF2aW91ciBiZXR3ZWVuIGhhdmluZw0KPiA+ID4gPiBhbiBleHBs
aWNpdCBub2RlIGFkZHJlc3MgYW5kIHVzaW5nIHRoZSBkZWZhdWx0LiBVbmZvcnR1bmF0ZWx5IG91
cg0KPiA+ID4gPiBhcHBsaWNhdGlvbiByZWxpZXMgb24gc2V0dGluZyB0aGUgbm9kZSBhZGRyZXNz
ZXMuDQo+ID4gPiBJIGRvIHRoaXMgbWFueSB0aW1lcyBhIGRheSwgd2l0aG91dCBhbnkgcHJvYmxl
bXMuIElmIHRoZXJlIHdvdWxkIGJlDQo+ID4gPiBhbnkgdGltZSBkaWZmZXJlbmNlLCBJIHdvdWxk
IGV4cGVjdCB0aGUgJ2F1dG8gY29uZmlndXJhYmxlJyB2ZXJzaW9uDQo+ID4gPiB0byBiZSBzbG93
ZXIsIGJlY2F1c2UgaXQgaW52b2x2ZXMgYSBEQUQgc3RlcC4NCj4gPiA+IEFyZSB5b3Ugc3VyZSB5
b3UgZG9uJ3QgaGF2ZSBhbnkgb3RoZXIgbm9kZXMgcnVubmluZyBpbiB5b3VyIHN5c3RlbT8NCj4g
PiA+DQo+ID4gPiAvLy9qb24NCj4gPiA+DQo+ID4gTm9wZSB0aGUgdHdvIG5vZGVzIGFyZSBjb25u
ZWN0ZWQgYmFjayB0byBiYWNrLiBEb2VzIHRoZSBudW1iZXIgb2YNCj4gPiBFdGhlcm5ldCBpbnRl
cmZhY2VzIG1ha2UgYSBkaWZmZXJlbmNlPyBBcyB5b3UgY2FuIHNlZSBJJ3ZlIGdvdCAzIG9uDQo+
ID4gZWFjaCBub2RlLiBPbmUgaXMgY29tcGxldGVseSBkaXNjb25uZWN0ZWQsIG9uZSBpcyBmb3Ig
Ym9vdGluZyBvdmVyDQo+ID4gVEZUUA0KPiA+IMKgKG9ubHkgdXNlZCBieSBVLWJvb3QpIGFuZCB0
aGUgb3RoZXIgaXMgdGhlIFVTQiBFdGhlcm5ldCBJJ20gdXNpbmcgZm9yDQo+ID4gdGVzdGluZy4N
Cj4gPg0KPiANCj4gU28gSSBjYW4gc3RpbGwgcmVwcm9kdWNlIHRoaXMgb24gbm9kZXMgdGhhdCBv
bmx5IGhhdmUgb25lIG5ldHdvcmsgaW50ZXJmYWNlIGFuZA0KPiBhcmUgdGhlIG9ubHkgdGhpbmdz
IGNvbm5lY3RlZC4NCj4gDQo+IEkgZGlkIGZpbmQgb25lIHRoaW5nIHRoYXQgaGVscHMNCj4gDQo+
IGRpZmYgLS1naXQgYS9uZXQvdGlwYy9kaXNjb3Zlci5jIGIvbmV0L3RpcGMvZGlzY292ZXIuYyBp
bmRleA0KPiBjMTM4ZDY4ZThhNjkuLjQ5OTIxZGFkNDA0YSAxMDA2NDQNCj4gLS0tIGEvbmV0L3Rp
cGMvZGlzY292ZXIuYw0KPiArKysgYi9uZXQvdGlwYy9kaXNjb3Zlci5jDQo+IEBAIC0zNTgsMTAg
KzM1OCwxMCBAQCBpbnQgdGlwY19kaXNjX2NyZWF0ZShzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdA0K
PiB0aXBjX2JlYXJlciAqYiwNCj4gwqDCoMKgwqDCoMKgwqDCoHRpcGNfZGlzY19pbml0X21zZyhu
ZXQsIGQtPnNrYiwgRFNDX1JFUV9NU0csIGIpOw0KPiANCj4gwqDCoMKgwqDCoMKgwqDCoC8qIERv
IHdlIG5lZWQgYW4gYWRkcmVzcyB0cmlhbCBwZXJpb2QgZmlyc3QgPyAqLw0KPiAtwqDCoMKgwqDC
oMKgwqBpZiAoIXRpcGNfb3duX2FkZHIobmV0KSkgew0KPiArLy/CoMKgwqDCoMKgaWYgKCF0aXBj
X293bl9hZGRyKG5ldCkpIHsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB0bi0+
YWRkcl90cmlhbF9lbmQgPSBqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcygxMDAwKTsNCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtc2dfc2V0X3R5cGUoYnVmX21zZyhkLT5za2Ip
LCBEU0NfVFJJQUxfTVNHKTsNCj4gLcKgwqDCoMKgwqDCoMKgfQ0KPiArLy/CoMKgwqDCoMKgfQ0K
PiDCoMKgwqDCoMKgwqDCoMKgbWVtY3B5KCZkLT5kZXN0LCBkZXN0LCBzaXplb2YoKmRlc3QpKTsN
Cj4gwqDCoMKgwqDCoMKgwqDCoGQtPm5ldCA9IG5ldDsNCj4gwqDCoMKgwqDCoMKgwqDCoGQtPmJl
YXJlcl9pZCA9IGItPmlkZW50aXR5Ow0KPiANCj4gSSB0aGluayBiZWNhdXNlIHdpdGggcHJlLWNv
bmZpZ3VyZWQgYWRkcmVzc2VzIHRoZSBkdXBsaWNhdGUgYWRkcmVzcyBkZXRlY3Rpb24NCj4gaXMg
c2tpcHBlZCB0aGUgc2hvcnRlciBpbml0IHBoYXNlIGlzIHNraXBwZWQuIFdvdWxkIGlzIG1ha2Ug
c2Vuc2UgdG8NCj4gdW5jb25kaXRpb25hbGx5IGRvIHRoZSB0cmlhbCBzdGVwPyBPciBpcyB0aGVy
ZSBzb21lIGJldHRlciB3YXkgdG8gZ2V0IHRoaW5ncyB0bw0KPiB0cmFuc2l0aW9uIHdpdGggcHJl
LWFzc2lnbmVkIGFkZHJlc3Nlcy4NCg0KSSBhbSBvbiB2YWNhdGlvbiB1bnRpbCB0aGUgZW5kIG9m
IG5leHQtd2Vlaywgc28gSSBjYW4ndCBnaXZlIHlvdSBhbnkgZ29vZCBhbmFseXNpcyByaWdodCBu
b3cuDQpUbyBkbyB0aGUgdHJpYWwgc3RlcCBkb2VzbuKAmXQgbWFrZSBtdWNoIHNlbnNlIHRvIG1l
LCAtaXQgd291bGQgb25seSBkZWxheSB0aGUgc2V0dXAgdW5uZWNlc3NhcmlseSAoYnV0IHdpdGgg
b25seSAxIHNlY29uZCkuDQpDYW4geW91IGNoZWNrIHRoZSBpbml0aWFsIHZhbHVlIG9mIGFkZHJf
dHJpYWxfZW5kIHdoZW4gdGhlcmUgYSBwcmUtY29uZmlndXJlZCBhZGRyZXNzPw0KDQovLy9qb24N
Cg0K

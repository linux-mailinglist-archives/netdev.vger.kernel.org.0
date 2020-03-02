Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D80D17637B
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgCBTKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:10:07 -0500
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:3219
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727126AbgCBTKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 14:10:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jx1yUsFwAvUYlfNQb7l7END/XvGcA/9CrSgajLXxCb6vGhZMLf41b3Ov4MLgpVNWqXJAmoa6Oja2ocAwyRgypl69p0V7XONWPgd9VQhF5xBXhCeVs/g6KZz4HGJfYrVYTvp0K5BdgRtAZke5jZSOnxizyfz8YThcWQfa4eydb4U7IKPPkLo4OuDHLPI2GbRuaiyCoOVucvcYY2VoQxlJqkl1BixCDwglCwc3Tdip9w/dlyziWAYFRe/VMzKUy0WUp012wb0JjXVu4qPVsAVydguzk3QzOq1IEUsMgRX98ofMt9CsHG/ZmVi/in5ThHRSTYoHGpfYV41SkhjU42Qx2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTOh4ZSbZVhF1aYG8S/hGVNOyA8xjPvPRtGfQddG4oU=;
 b=KBzd0XwHgR7/+6AzbPydH2Ur/70Rnyc85loLm13Y+Tb6EPgETinQnopRmkAyg1OmOU6pMhKrJoVW0iGx05ov9xWtTOr/Q5CdhKxn4Y2tWPdnoe1oiIPDJaJLlQirjgaYO+XWJBE6Rbb4iauVTCAGH0lbat7x+PyWThbRRwMPy8NIo5MPT5wcFtLhk/GRhFnvGCeoBq0lPOyRXulwa9K49RL1JPUmRLqmSLP4yn7FnqTS+nK9kwJymAlrLac8Mih9o9KomgebrE0eunbjlK9sjWj5Jg2QZ60MyvZRcrwU6mxcrw5xHh0uiNV4GsA4njvmk0HCmls3ariL+V/JBFCTow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTOh4ZSbZVhF1aYG8S/hGVNOyA8xjPvPRtGfQddG4oU=;
 b=TOmxEHLBHlk+jxA/B6+iyWZyCZYPRQYhpUm3YhQLulNcXEHG/I1kBpbnay5fMEjv9LmgmKKFnmP6E/TtF4yg/+t2EjBRcLhWqDwRDSAAdwRSOEuelboQvYWLPSdPLheRY7GJZRn6rqsXYOfbaWKSlE4oVTtzMYPt/ovAETMlDF8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.19; Mon, 2 Mar 2020 19:10:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 19:10:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Roi Dayan <roid@mellanox.com>,
        "ian.kumlien@gmail.com" <ian.kumlien@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [VXLAN] [MLX5] Lost traffic and issues
Thread-Topic: [VXLAN] [MLX5] Lost traffic and issues
Thread-Index: AQHV7kgbA5hDJtJPaEeiBsN7ELo13Kg1r8eA
Date:   Mon, 2 Mar 2020 19:10:03 +0000
Message-ID: <32234f4c5b4adcaf2560098a01b1544d8d8d3c2c.camel@mellanox.com>
References: <CAA85sZsO9EaS8fZJqx6=QJA+7epe88UE2zScqw-KHZYDRMjk5A@mail.gmail.com>
In-Reply-To: <CAA85sZsO9EaS8fZJqx6=QJA+7epe88UE2zScqw-KHZYDRMjk5A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 08bc0ae3-1cf7-49f3-2acf-08d7bedd4fea
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49908608B74AA7E5A248BC01BEE70@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(199004)(189003)(36756003)(2616005)(91956017)(76116006)(6486002)(66574012)(4326008)(66476007)(66556008)(64756008)(66446008)(8676002)(81156014)(81166006)(66946007)(6506007)(478600001)(8936002)(54906003)(86362001)(110136005)(5660300002)(6512007)(71200400001)(316002)(186003)(107886003)(2906002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8OfvtGR198UxTvpoTe/1nKYMPol+1B6+Ve7Tq5ZcWJSq+MUz40HpiYGWNGRqYCsJfY5ZEyNX1M0Cht6aQ0Z3I0mOErmLpnlgCNB3FfCMsMzzz/3c3a2rUk7/hh3P+z515rHH3YW+DTzAjM29Yk8cGTakuteY6mEiSc3wgzl1V6fQ7kkyQBgwy98L0meS29dWE6Q6F7X3RA0Vww6dcyEycQaJX28DSuM1RnuF//X++x4/DMvp3MyP08Uev3pY/VmBO7fChLrcsx1q95Ks7LtT8fmdpzAl/yhCR5IljeYzRSRU6hU/vqOkUsLfrI2FAEFMw2NXHQ588ACQ3qh20c9hax/ZLQTgFfzheUlciYeZNG440wY/TW77P9n8oS+K8uohuPK3kwvvJtfBv24mu1AIQOw3lYFtBoHEieI43jSPJAjb1cnxYQgnNvhqNJMLBQ75
x-ms-exchange-antispam-messagedata: e3OLqeqxfDg8ndJlApSug5vUvfUNhys4CjZBHGIcVD2hpNfhQYfvDWAdJ+i5x/PDsflNQ9bD6aOKenzsYBopt3cvN8QOWTegKHI8CPAAyAuG0BtDuogbfguecDYWwOLbARoEjvdg0B29T4d+MnpBMA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <04E43F2AEE1A8E40A8BEA7C1B0A09092@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08bc0ae3-1cf7-49f3-2acf-08d7bedd4fea
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 19:10:03.2851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4doLn/PmRfi2Gy4QW1cY6wolGlBDgRDpbDdqMorJ71UI5raeSWFuN4HY1MZCxrKI/8kficYqhq6/OTiYOoVlPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAyLTI4IGF0IDE2OjAyICswMTAwLCBJYW4gS3VtbGllbiB3cm90ZToNCj4g
SGksDQo+IA0KPiBJbmNsdWRpbmcgbmV0ZGV2IC0gdG8gc2VlIGlmIHNvbWVvbmUgZWxzZSBoYXMg
YSBjbHVlLg0KPiANCj4gV2UgaGF2ZSBhIGZldyBtYWNoaW5lcyBpbiBhIGNsb3VkIGFuZCB3aGVu
IHVwZ3JhZGluZyBmcm9tIDQuMTYuNyAtPg0KPiA1LjQuMTUgd2UgcmFuIGluIHRvDQo+IHVuZXhw
ZWN0ZWQgYW5kIGludGVybWl0dGVudCBwcm9ibGVtcy4NCj4gKEkgaGF2ZSB0ZXN0ZWQgNS41LjYg
YW5kIHRoZSBwcm9ibGVtcyBwZXJzaXN0cykNCj4gDQo+IFdoYXQgd2Ugc2F3LCB1c2luZyBzZXZl
cmFsIG1vbml0b3JpbmcgcG9pbnRzLCB3YXMgdGhhdCB0cmFmZmljDQo+IGRpc2FwcGVhcmVkIGFm
dGVyIHdoYXQgd2UgY2FuIHNlZSB3aGVuIHRjcGR1bXBpbmcgb24gImJvbmQwIg0KPiANCj4gV2Ug
aGFkIHRjcGR1bXAgcnVubmluZyBvbjoNCj4gMSwgREhDUCBub2RlcyAobG9jYWwgdGFwIGludGVy
ZmFjZXMpDQo+IDIsIFJvdXRlciBpbnN0YW5jZXMgb24gTDMgbm9kZQ0KPiAzLCBMb2NhbCBub2Rl
ICh3aGVyZSB0aGUgVk0gcnVucykgKHRhcCwgYnJpZGdlIGFuZCBldmVudHVhbGx5IHRhcA0KPiBp
bnRlcmZhY2UgZHVtcGluZyBWWExBTiB0cmFmZmljKQ0KPiA0LCBVc2luZyBwb3J0IG1pcnJvcmlu
ZyBvbiB0aGUgMTAwZ2JpdCBzd2l0Y2ggdG8gc2VlIHdoYXQgZW5kZWQgdXAgb24NCj4gdGhlIHBo
eXNpY2FsIHdpcmUuDQo+IA0KPiBXaGF0IHdlIGNhbiBzZWUgaXMgdGhhdCBmcm9tIHRoZSBmb3Vy
IHN0ZXAgaGFuZHNoYWtlIGZvciBESENQIG9ubHkNCj4gdHdvDQo+IHN0ZXBzIHdvcmtzLCB0aGUg
Zm9ydGggc3RlcCB3aWxsIGJlIGRyb3BwZWQgIm9uIHRoZSBuaWMiLg0KPiANCj4gV2UgY2FuIHNl
ZSBpdCBnbyBvdXQgYm9uZDAsIGluIHRhZ2dlZCBWTEFOIGFuZCB3aXRoaW4gYSBWWExBTiBwYWNr
ZXQNCj4gLQ0KPiBob3dldmVyIHRoZSBzd2l0Y2ggbmV2ZXIgc2VlcyBpdC4NCj4gDQoNCkhpLCAN
Cg0KSGF2ZSB5b3Ugc2VlbiB0aGUgcGFja2V0cyBhY3R1YWxseSBnb2luZyBvdXQgb24gb25lIG9m
IHRoZSBtbHg1IDEwMGdiaXQNCmxlZ3MgPyANCg0KPiBUaGVyZSBoYXMgYmVlbiBhIGZldyBtbHg1
IGNoYW5nZXMgd3J0IFZYTEFOIHdoaWNoIGNhbiBiZSBjdWxwcml0cyBidXQNCj4gaXQncyByZWFs
bHkgaGFyZCB0byBqdWRnZS4NCj4gDQo+IGRtZXNnIHxncmVwIG1seA0KPiBbICAgIDIuMjMxMzk5
XSBtbHg1X2NvcmUgMDAwMDowYjowMC4wOiBmaXJtd2FyZSB2ZXJzaW9uOiAxNi4yNi4xMDQwDQo+
IFsgICAgMi45MTI1OTVdIG1seDVfY29yZSAwMDAwOjBiOjAwLjA6IFJhdGUgbGltaXQ6IDEyNyBy
YXRlcyBhcmUNCj4gc3VwcG9ydGVkLCByYW5nZTogME1icHMgdG8gOTc2NTZNYnBzDQo+IFsgICAg
Mi45MzUwMTJdIG1seDVfY29yZSAwMDAwOjBiOjAwLjA6IFBvcnQgbW9kdWxlIGV2ZW50OiBtb2R1
bGUgMCwNCj4gQ2FibGUgcGx1Z2dlZA0KPiBbICAgIDIuOTQ5NTI4XSBtbHg1X2NvcmUgMDAwMDow
YjowMC4xOiBmaXJtd2FyZSB2ZXJzaW9uOiAxNi4yNi4xMDQwDQo+IFsgICAgMy42Mzg2NDddIG1s
eDVfY29yZSAwMDAwOjBiOjAwLjE6IFJhdGUgbGltaXQ6IDEyNyByYXRlcyBhcmUNCj4gc3VwcG9y
dGVkLCByYW5nZTogME1icHMgdG8gOTc2NTZNYnBzDQo+IFsgICAgMy42NjEyMDZdIG1seDVfY29y
ZSAwMDAwOjBiOjAwLjE6IFBvcnQgbW9kdWxlIGV2ZW50OiBtb2R1bGUgMSwNCj4gQ2FibGUgcGx1
Z2dlZA0KPiBbICAgIDMuNjc1NTYyXSBtbHg1X2NvcmUgMDAwMDowYjowMC4wOiBNTFg1RTogU3Ry
ZFJxKDEpIFJxU3ooOCkNCj4gU3RyZFN6KDY0KSBSeENxZUNtcHJzcygwKQ0KPiBbICAgIDMuODQ2
MTQ5XSBtbHg1X2NvcmUgMDAwMDowYjowMC4xOiBNTFg1RTogU3RyZFJxKDEpIFJxU3ooOCkNCj4g
U3RyZFN6KDY0KSBSeENxZUNtcHJzcygwKQ0KPiBbICAgIDQuMDIxNzM4XSBtbHg1X2NvcmUgMDAw
MDowYjowMC4wIGVucDExczBmMDogcmVuYW1lZCBmcm9tIGV0aDANCj4gWyAgICA0LjAyMTk2Ml0g
bWx4NV9pYjogTWVsbGFub3ggQ29ubmVjdC1JQiBJbmZpbmliYW5kIGRyaXZlciB2NS4wLTANCj4g
DQo+IEkgaGF2ZSB0cmllZCB0dXJuaW5nIGFsbCBvZmZsb2FkcyBvZmYsIGJ1dCB0aGUgcHJvYmxl
bSBwZXJzaXN0cyBhcw0KPiB3ZWxsIC0gaXQncyByZWFsbHkgd2VpcmQgdGhhdCBpdCBzZWVtcyB0
byBiZSBvbmx5IHNvbWUgcGFja2V0cy4NCj4gDQo+IFRvIGJlIGNsZWFyLCB0aGUgYm9uZDAgaW50
ZXJmYWNlIGlzIDIqMTAwZ2JpdCwgdXNpbmcgODAyLjFhZCAoTEFDUCkNCj4gd2l0aCBsYXllcjIr
MyBoYXNoaW5nLg0KPiBUaGlzIHNlZW1zIHRvIGJlIG9mZmxvYWRlZCBpbiB0byB0aGUgbmljIChj
YW4gaXQgYmUgdHVybmVkIG9mZj8pIGFuZA0KPiBtZXNzYWdlcyBhYm91dCBtb2RpZnlpbmcgdGhl
ICJsYWcgbWFwIiB3YXMNCj4gcXVpdGUgZnJlcXVlbnQgdW50aWwgd2UgZGlkIGEgZmlybXdhcmUg
dXBncmFkZSAtIGV2ZW4gd2l0aCB1cGdyYWRlZA0KPiBmaXJtd2FyZSwgaXQgY29udGludWVkIGJ1
dCB0byBhIGxlc3NlciBleHRlbnQuDQo+IA0KPiBXaXRoIDUuNS43IGFwcHJvYWNoaW5nLCB3ZSB3
b3VsZCB3YW50IGEgcGF0aCBmb3J3YXJkIHRvIGhhbmRsZQ0KPiB0aGlzLi4uDQoNCg0KV2hhdCB0
eXBlIG9mIG1seDUgY29uZmlndXJhdGlvbiB5b3UgaGF2ZSAoTmF0aXZlIFBWIHZpcnR1YWxpemF0
aW9uID8NClNSSU9WID8gbGVnYWN5IG1vZGUgb3Igc3dpdGNoZGV2IG1vZGUgPyApDQoNClRoZSBv
bmx5IGNoYW5nZSB0aGF0IGkgY291bGQgdGhpbmsgb2YgaXMgdGhlIGxhZyBtdWx0aS1wYXRoIHN1
cHBvcnQgd2UNCmFkZGVkLCBSb2kgY2FuIHlvdSBwbGVhc2UgdGFrZSBhIGxvb2sgYXQgdGhpcyA/
DQoNClRoYW5rcywNClNhZWVkLg0KDQoNCg0K

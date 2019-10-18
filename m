Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 584ACDC412
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 13:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394286AbfJRLkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 07:40:40 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:17130
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729803AbfJRLkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 07:40:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egdlkWQ5a4RLaCXTExYVrsKcfMsz1IXLn2Dvu/N73+DZey+9u4gCTTWv2hX915BKw+xyRuWVbn0m5XmfKTLr+7JnTBhXs9evdl2r1uHd1cX//0zdBPkHnbgEtnJxogrimhjfEPbG9+eVjjXud9yktL7ZmoKde/Hvx8sJWijvSE+sq8guca4KRCgPgEDIULvpvLGkmVUeDTxHfYXSV+15g0tTqBScC3nnEyXHdl5yqDR63g9abrSXOBJlsl+PvLaFR9gueMPqaKG1Knteu96WgBPUvYNchrkh7YI2iXLNTqgFZvhHjt1LnVIiI2zlLxJEb2GAk9WQSYcHrPGyj2AsDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qqr5tJ0kxzjG2XW9q38T14iHRdlgPaoQqPKV7egeSI=;
 b=XK9sDAXeVhoaZrZZOX/CQa/NXoz6m6RvFgjp6CLqUQEiH2A1bWpdgOQAc7woZehcCbZ/8yrAIUjAiO73K4vTFBB6ABaQqkxdHi38cKZwqbIVYgCjKGS4fiA61+m0s2gpylShM30qw0k7wzMHmO2p6lN0v93B6fPlvd1JPCKwBPM8G6sWEEMPtj6Uus94yEh2GeAPQucOHxKiMCx29TzCqWpmitwCwdduuBa/1PWGhLTM+fRLqyJaInhv1RD2KUhcLZGJ7kNX4f3V/ImaNb9j2LzApAhw5lMDZN+ItBO8ZGX1ISdR9WR1ESrqMlpbhsDv2/vi5klx+53++zsvjJNytA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qqr5tJ0kxzjG2XW9q38T14iHRdlgPaoQqPKV7egeSI=;
 b=VrmeRVHl/A1uAYsQvC4fWYjfjCjdoTQDRIOo9KdVp41Ao0qwtM8K+/1JRLELUtiPUR9j1vxVK1VP1v3ZkoUJkQOmnUuW4Q4sJ+nDpOXOAaBku3Cs7ihnHDuTzJpMKyy5HglMRIBtZgxqLLOyJ5t/yEEjd0dB4PxNM0MbQjDqyCc=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB5360.eurprd04.prod.outlook.com (20.178.120.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 18 Oct 2019 11:40:36 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 11:40:36 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     Maxim Uvarov <muvarov@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     netdev <netdev@vger.kernel.org>
Subject: RE: Fw: [Bug 205215] New: Amiga X5000 Cyrus board DPAA network driver
 issue
Thread-Topic: Fw: [Bug 205215] New: Amiga X5000 Cyrus board DPAA network
 driver issue
Thread-Index: AQHVhFQ15zOhtcOi8U6s/AXygB/FAKdgF0kAgAAw4KA=
Date:   Fri, 18 Oct 2019 11:40:36 +0000
Message-ID: <VI1PR04MB55677FB8BC9504E429ED86D2EC6C0@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <20191016120158.718e4c25@hermes.lan>
 <CAJGZr0JFY9ene2iW8CGhWUwARC_TvJg9NCxy7MHdH+moVOjz0g@mail.gmail.com>
In-Reply-To: <CAJGZr0JFY9ene2iW8CGhWUwARC_TvJg9NCxy7MHdH+moVOjz0g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cb9695e-b908-4f12-64c8-08d753bffe6e
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR04MB5360:
x-microsoft-antispam-prvs: <VI1PR04MB536041015DD288E8F3A3B932EC6C0@VI1PR04MB5360.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(13464003)(189003)(199004)(4326008)(446003)(11346002)(52536014)(86362001)(81166006)(81156014)(3846002)(256004)(6246003)(186003)(110136005)(316002)(6116002)(486006)(476003)(8676002)(76176011)(5660300002)(66446008)(76116006)(74316002)(66946007)(26005)(66476007)(66556008)(64756008)(66066001)(2906002)(99286004)(25786009)(33656002)(9686003)(305945005)(102836004)(7736002)(6436002)(229853002)(71200400001)(71190400001)(55016002)(53546011)(6506007)(7696005)(8936002)(478600001)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5360;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +R0ovmWMMhIGzsN2CzB4DmURj4oaDUChB+nzd6riXjthh5ESRVSUryOqCuDJ6w6Qg/AKk3xx3bX4zwsCii/ADX4YnOsu7jjWlSxiWx2ypGqtgb8dgZHjX7+GBnZvbK3GpCc/1kZQtI8TIkfW9o86Q2poN0VdH5Ec/7ke2XdzhLapqhnkdqn0ykWxAnG0y3AsE26f7g0dwJXMVLbXTcRfxxYAAbzL9Cltgy+xD3HmqO66vzKbH0l23L88RGsj1a8MH7PC+j12budrLksuAMY1GxulZ1FsG5jkSXrMJEdcdHH5SOMT94tu1BXWyd+AEARba+1U/zHxNr4EBH1A7/4lkccI+RNOmkBLBXLO0Dypvk6Zt6aQz9E2OuV8+WL9yWFwQPVxRupwZJgCi3POZK58jXcRhYbx4Th4oG5sGjGnB9w=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb9695e-b908-4f12-64c8-08d753bffe6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 11:40:36.7621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: znmEsLtCjBk1LBppqjuEUPQ2sgOFZFVnd3bbjtmlKZYPXm6C0tiA0NdECCbl4NVpbsfS5iGbG0ekJvRqqzOXPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5360
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXhpbSBVdmFyb3YgPG11dmFy
b3ZAZ21haWwuY29tPg0KPiBTZW50OiBGcmlkYXksIE9jdG9iZXIgMTgsIDIwMTkgMTE6NDIgQU0N
Cj4gVG86IFN0ZXBoZW4gSGVtbWluZ2VyIDxzdGVwaGVuQG5ldHdvcmtwbHVtYmVyLm9yZz4NCj4g
Q2M6IE1hZGFsaW4tY3Jpc3RpYW4gQnVjdXIgPG1hZGFsaW4uYnVjdXJAbnhwLmNvbT47IG5ldGRl
dg0KPiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz4NCj4gU3ViamVjdDogUmU6IEZ3OiBbQnVnIDIw
NTIxNV0gTmV3OiBBbWlnYSBYNTAwMCBDeXJ1cyBib2FyZCBEUEFBIG5ldHdvcmsNCj4gZHJpdmVy
IGlzc3VlDQo+IA0KPiDRh9GCLCAxNyDQvtC60YIuIDIwMTkg0LMuINCyIDIwOjI3LCBTdGVwaGVu
IEhlbW1pbmdlcg0KPiA8c3RlcGhlbkBuZXR3b3JrcGx1bWJlci5vcmc+Og0KPHNuaXA+DQo+ID4g
U28gd2hhdCBpcyBoYXBwZW5pbmcsDQo+ID4NCj4gPiBGaXJzdCBvZiBhbGwgdGhlIGhhcmR3YXJl
IGlzIGZ1bmN0aW9uYWwuIFdoZW4gdXNpbmcgQW1pZ2FPUzQuMUZFIHRoZQ0KPiBFdGhlcm5ldA0K
PiA+IGFkYXB0ZXIgaXMgZmluZS4gV2hlbiB1c2luZyB0aGUgYWRhcHRlciB3aXRoaW4gVS1ib290
IChwaW5nIGZvciBleGFtcGxlKQ0KPiBpdCBpcw0KPiA+IGFsc28gd29ya2luZyBhcyBleHBlY3Rl
ZC4NCj4gPg0KPiA+IFdoZW4gYm9vdGVkIGludG8gbGludXggdGhlIGV0aGVybmV0IGFkYXB0ZXIg
ZG9lcyBub3QgZ2V0IHVwLg0KPiA+IFRoZSBvdXRwdXQgb2YgRE1FU0cgaXM6DQo+ID4NCj4gPiBz
a2F0ZW1hbkBYNTAwMExOWDp+JCBkbWVzZyB8IGdyZXAgZXRoDQo+ID4gWyA0Ljc0MDYwM10gZnNs
X2RwYWFfbWFjIGZmZTRlNjAwMC5ldGhlcm5ldDogRk1hbiBkVFNFQyB2ZXJzaW9uOg0KPiAweDA4
MjQwMTAxDQo+ID4gWyA0Ljc0MTAyNl0gZnNsX2RwYWFfbWFjIGZmZTRlNjAwMC5ldGhlcm5ldDog
Rk1hbiBNQUMgYWRkcmVzczoNCj4gPiAwMDowNDphMzo2Yjo0MTo3Yw0KPiA+IFsgNC43NDEzODdd
IGZzbF9kcGFhX21hYyBmZmU0ZTgwMDAuZXRoZXJuZXQ6IEZNYW4gZFRTRUMgdmVyc2lvbjoNCj4g
MHgwODI0MDEwMQ0KPiA+IFsgNC43NDE3NDBdIGZzbF9kcGFhX21hYyBmZmU0ZTgwMDAuZXRoZXJu
ZXQ6IEZNYW4gTUFDIGFkZHJlc3M6DQo+ID4gMDA6MWU6YzA6Zjg6MzE6YjUNCj4gPiBbIDQuNzQy
MDAxXSBmc2xfZHBhYV9tYWMgZmZlNGUwMDAwLmV0aGVybmV0Og0KPiA+IG9mX2dldF9tYWNfYWRk
cmVzcygvc29jQGZmZTAwMDAwMC9mbWFuQDQwMDAwMC9ldGhlcm5ldEBlMDAwMCkgZmFpbGVkDQo+
IA0KPiBzb3VuZCBsaWtlIG1hYyBpcyBtaXNzaW5nIGluIGR0Lg0KPiANCg0KSW5kZWVkLCBpZiB5
b3UgZG8gbm90IHNldCB0aGUgcmVxdWlyZWQgdS1ib290IGVudiBlbnRyaWVzLCB0aGUgTUFDIGFk
ZHJlc3MNCmZpeHVwIG9mIHRoZSBkZXZpY2UgdHJlZSB3aWxsIG5vdCBiZSBwZXJmb3JtZWQgYW5k
IHRoZSBkcml2ZXIgd2lsbCBub3QgDQpwcm9iZSB0aG9zZSBNQUNzLiBUaGUgcXVlc3Rpb24gaXMg
LSBhcmUgdGhlIGludGVyZmFjZXMgdGhhdCBkbyBwcm9iZQ0KZnVuY3Rpb25hbD8NCg0KTWFkYWxp
bg0K

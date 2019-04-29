Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB78FDE6B
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfD2IxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:53:23 -0400
Received: from mail-eopbgr140134.outbound.protection.outlook.com ([40.107.14.134]:55293
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727525AbfD2IxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:53:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qeRuZLrUkq60Btaeq+vnxRx/UmFPvMjCexezcg0k94=;
 b=cjk3SxUeG/YgSRMRRi9Xhp/Kicubn2mZLdT5ijL6VSP+i6AmMkHlHHBPf9vx50EWvsE1UoIpQiWnPAmqTdPIrZNhHk0nZuVEvxliIzaxDpXPXbVl+IUkKYnMd86a9OjF3+FAWF/3fpr/OGHVQMfg6Qh2LdBhUn8MBKuKrgFHnys=
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM (20.178.126.212) by
 VI1PR10MB1679.EURPRD10.PROD.OUTLOOK.COM (10.165.194.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 08:53:19 +0000
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8]) by VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8%2]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 08:53:19 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Thomas Winding <twi@deif.com>, Fabio Estevam <festevam@gmail.com>,
        Per Christensen <pnc@deif.com>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: Re: [PATCH] can: flexcan: bump FLEXCAN_TIMEOUT_US to 250
Thread-Topic: [PATCH] can: flexcan: bump FLEXCAN_TIMEOUT_US to 250
Thread-Index: AQHU1PaDftXKRmjpAUe9LFJjLfS9raYUlMMAgAG4fwD///7hgIABEGQAgAABhwCAO8n9AA==
Date:   Mon, 29 Apr 2019 08:53:19 +0000
Message-ID: <e9b2b895-aa65-72be-5e6e-d38365ff2624@prevas.dk>
References: <20190307150024.23628-1-rasmus.villemoes@prevas.dk>
 <a418bbc9-186c-174a-20d8-18cedeaf0089@pengutronix.de>
 <5615c217-8ba6-e452-1aaa-1e3b32eb4cca@prevas.dk>
 <f1fb86fb-1b6b-1860-899d-820d4bc672cf@pengutronix.de>
 <4471c611-1a58-6365-2ab6-1b39c310265a@prevas.dk>
 <b03e9868-3070-ce35-3477-3119d691baec@pengutronix.de>
In-Reply-To: <b03e9868-3070-ce35-3477-3119d691baec@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0185.eurprd05.prod.outlook.com
 (2603:10a6:3:f8::33) To VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e3::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1a7fb5b-868f-4588-7cbe-08d6cc80204c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR10MB1679;
x-ms-traffictypediagnostic: VI1PR10MB1679:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR10MB1679CA97E0A3D54EC6897C3E8A390@VI1PR10MB1679.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:480;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(39840400004)(366004)(136003)(199004)(189003)(6246003)(31696002)(81166006)(8936002)(81156014)(36756003)(44832011)(8676002)(31686004)(8976002)(5660300002)(6512007)(54906003)(110136005)(99286004)(6506007)(386003)(6306002)(486006)(53936002)(53546011)(7736002)(305945005)(4326008)(25786009)(52116002)(76176011)(186003)(446003)(6486002)(6436002)(26005)(42882007)(97736004)(71190400001)(14444005)(256004)(2616005)(93886005)(316002)(11346002)(476003)(71200400001)(102836004)(229853002)(74482002)(2906002)(7416002)(66066001)(6116002)(3846002)(478600001)(72206003)(14454004)(73956011)(966005)(68736007)(66556008)(64756008)(66946007)(66476007)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB1679;H:VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QsCvv9DfAXhrce+r8iwMTZPpniDF42JIsWN9y3iqo7Ls1zU9fAgdg52dOQvhBst6x4a9a4u9ENff1hmfuL67ZKEQr+i7DCNw1WcWfVI8mnFxvZNarwmbbhQrTxe4BzoqICJ9PbY3lAxOzG9grsw78BJRK1hvyYvDtEC5ybwpW5vZ3Sb7fncoOCtUXSiHlP/mfcgBd5quQvz+YiytT92y6ZsR2RiSi2tQv/5r6Rlc5sx9ZBgpB+lT4IB2Y3OXppwlC1rz3ZgahIQA5CLmGTB93GxNvLLfkCLZ0EON1V7lwzUd5R9xCsUq68oMdkfyYAHmXFtTKsipNZJlJjVEWkDhofmdg/5WK0i4tQfFx5uO1sbQFdQa/gqdi8geiTBS72CpbvlblBl5JY2Drw596eMFz9zVQSX9U8seo8LiXibffmM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9689F66843FFC84F9F2B01A6B923C809@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a7fb5b-868f-4588-7cbe-08d6cc80204c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 08:53:19.1729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB1679
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjIvMDMvMjAxOSAwOC41MSwgTWFyYyBLbGVpbmUtQnVkZGUgd3JvdGU6DQo+IE9uIDMvMjIv
MTkgODo0NSBBTSwgUmFzbXVzIFZpbGxlbW9lcyB3cm90ZToNCj4+IE9uIDIxLzAzLzIwMTkgMTYu
MzAsIE1hcmMgS2xlaW5lLUJ1ZGRlIHdyb3RlOg0KPj4+IE9uIDMvMjEvMTkgMzozNCBQTSwgUmFz
bXVzIFZpbGxlbW9lcyB3cm90ZToNCj4+Pj4gT24gMjAvMDMvMjAxOSAxNC4xOCwgTWFyYyBLbGVp
bmUtQnVkZGUgd3JvdGU6DQo+Pj4NCj4+PiBDYW4geW91IHByb3Bvc2UgYW4gdXBkYXRlZCBjb21t
aXQgbWVzc2FnZSBmb3IgSm9ha2ltIFpoYW5nJ3MgcGF0Y2g/DQo+Pj4NCj4+PiBodHRwczovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9ta2wvbGludXgtY2FuLmdpdC9j
b21taXQvP2g9dGVzdGluZyZpZD05ZGFlZDg5YWU4YTNmYzQ0Y2NkMmIyYmI5YzNjNGQzZTM0MzE5
MDRkDQo+Pj4NCj4+PiBJJ2xsIGFkZCBpdCBieSBoYW5kIGFuZCBpbmNyZWFzZSB0aGUgdGltZW91
dCB0byAyNTAuIE9rPw0KPj4NCj4+IFNvdW5kcyBmaW5lLiBJbiBvcmRlciBub3QgdG8gY2hhbmdl
IEpvYWtpbSdzIGNvbW1pdCBsb2cgdG9vIG11Y2gsIGhvdw0KPj4gYWJvdXQgYWRkaW5nIHNvbWV0
aGluZyBsaWtlICh3aXRoIHlvdXIgaW5pdGlhbHMsIHNpbmNlIHlvdSdyZSBuZXh0IGluDQo+PiB0
aGUgc2lnbi1vZmYgY2hhaW4pDQo+Pg0KPj4gW21rbDogTWVhbndoaWxlLCBSYXNtdXMgVmlsbGVt
b2VzIHJlcG9ydGVkIHRoYXQgZXZlbiB3aXRoIGEgdGltZW91dCBvZg0KPj4gMTAwLCBmbGV4Y2Fu
X3Byb2JlKCkgZmFpbHMgb24gdGhlIE1QQzgzMDksIHdoaWNoIHJlcXVpcmVzIGEgdmFsdWUgb2Yg
YXQNCj4+IGxlYXN0IDE0MCB0byB3b3JrIHJlbGlhYmx5LiAyNTAgd29ya3MgZm9yIGV2ZXJ5b25l
Ll0NCj4+DQo+PiA/IEZlZWwgZnJlZSB0byBlZGl0IGFzIHlvdSB3aXNoLg0KPiANCj4gVGhhbmtz
LCBJJ3ZlIGFkZGVkIHRoYXQgdG8gdGhlIGNvbW1pdCBtZXNzYWdlIGl0c2VsZi4NCg0KV2hhdCdz
IHRoZSBzdGF0dXMgb2YgdGhpcz8gSSBjYW4ndCBmaW5kIGFueXRoaW5nIGluIC1uZXh0IChhcyBv
Zg0KbmV4dC0yMDE5MDQyNiksIG5laXRoZXIgSm9ha2ltJ3Mgb3JpZ2luYWwgb3IgdGhlIGFtZW5k
ZWQgcGF0Y2guDQoNClRoYW5rcywNClJhc211cw0K

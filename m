Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AED715D48D
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 10:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgBNJSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 04:18:40 -0500
Received: from mail-am6eur05on2075.outbound.protection.outlook.com ([40.107.22.75]:6173
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727965AbgBNJSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 04:18:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/VVo4GqCaY6zM4sgvxSsHWBbAKmZRFzjpkj6Jgyll0iVJAd36cny5y5f7LmTDfN85OtkfNux3vi0iijvivSUpeVBUXM8/GptgOZiFzwWKuPLQHaROrNPmjc6AR2TqhAAjUvZii23EGqdRHDOpi0JMZ/+Ibt5oB73hPpruornjJc4BFnXnqnJQGs4/FiY/alwUkpwDjjumbfJXlCNsEG9GZQY5sVeT9FS2rCDnI5jYk9DNhVttX/m4A5dHjxaB0JMx1dyNF8C9aKA8oSJvqfmGjoVv5GUmi8BrqTUJS7UaDX8Tonrb1WWHXiTw5Dst/PqBLbXvteEH+0RtsOTnbqhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcfT3iE7tClRRcStTa2OIJKwXBFdna72+6VUZs/zPUc=;
 b=AFcJHuwEdSjVL0O+90eEl30xU/3y7zXzXk7Z3/7recRSKslXGaacPrgB8VI4ncGh8EcdMXSwckVSpWyr/tv9AX79+WClDYKmhOCjmev8gN9sUG/9dNGAE6JVL8pSh0SFvgK0GUrlB5Uq/P5Cu7LNaYdTPhLIr/N+yD6Jzc+aEtIe03dXYlGDhecqH6+GLSnM1SAJh92rCjDGiR8OUK4lkgBznvYcnCNE+uWZO+eH4Ee64Ezau+MVnRd4w/fnc1F4XSfcaM1xNbB6vGvGyaAuzsQemxUmTVzOgYdIi19EM08xaB2cv4WzWUOJIrvl/xY/TdVurm9LcxxQrrXBo44r2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcfT3iE7tClRRcStTa2OIJKwXBFdna72+6VUZs/zPUc=;
 b=qG25l1luZO7+PYD0+sQ+e9GNm0S0G6WTCzh12cwUtrv93F/FotO7ldbrBixMQurV/5YiwnF/BhSkfBXt88F+Ic8SE87W7SGw7Y8pMYxvxogQSHDVJ3eB01OC8KdhlYAi6a8/3Y3JtiBjMs7aVfZobAyTi+ml6GlMVwR5nLhNFyU=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5948.eurprd04.prod.outlook.com (20.178.106.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Fri, 14 Feb 2020 09:18:23 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::5cb4:81c8:1618:5ca]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::5cb4:81c8:1618:5ca%7]) with mapi id 15.20.2729.025; Fri, 14 Feb 2020
 09:18:23 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>
Subject: RE: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Thread-Topic: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Thread-Index: AQHVOIgqonFULiHPO0eSKFSJ3ULGeqbbAsWQgAAINwCAAC3BgIE/m36AgABmuxCAAHloAIAAB/CA
Date:   Fri, 14 Feb 2020 09:18:23 +0000
Message-ID: <DB7PR04MB46187A6B5A8EC3A1D73D69FFE6150@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <24eb5c67-4692-1002-2468-4ae2e1a6b68b@pengutronix.de>
 <20200213192027.4813-1-michael@walle.cc>
 <DB7PR04MB461896B6CC3EDC7009BCD741E6150@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <2322fb83486c678917957d9879e27e63@walle.cc>
In-Reply-To: <2322fb83486c678917957d9879e27e63@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [222.93.234.203]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fc0667f8-affe-4a9a-14f8-08d7b12ed77c
x-ms-traffictypediagnostic: DB7PR04MB5948:|DB7PR04MB5948:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB594836269F8E345194C8508BE6150@DB7PR04MB5948.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03137AC81E
x-forefront-antispam-report: SFV:NSPM;SFS:(10001)(10009020)(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(189003)(199004)(81166006)(86362001)(81156014)(6506007)(53546011)(4326008)(9686003)(55016002)(5660300002)(186003)(8676002)(26005)(45080400002)(966005)(478600001)(6916009)(66476007)(64756008)(33656002)(316002)(54906003)(71200400001)(52536014)(76116006)(7696005)(8936002)(66556008)(2906002)(66446008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5948;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ll4BRR3tgNw2oTulTOpkD3gbQzSqUrUcR9sz08UnVz4tgWf2JU9965qzKzmkG2AVCM0wMYMIpinJFFqwusjtPItRkEv9Hm9vud4fzjHFnXWKlnnEqpgLB5dpnJ0nGVt+DHQqyqhoEy4cl2eT54UXlB042xVgm7TxVd0vBNMaaXJ/blxh04/ZFp9+ZkNtsTQNwYAptp6h8iLHgmzSzzKvTMQa/EIWsqXaf/UrjgYdm5E8uKSjOODG8qozz1mTo65k5Kz9VCnbZLLdEgCH+MCVu7CIHiMOrmXS/iCHU3InOxWDih1BdE3zvu2Q4b+DAexEbTNc7p595vK+p/rAW8TLwVYjVEyU7YVGu+tUOvciM21OAuNqg1+XQzfeMCOoKczNdl/i1YpDkhBsUActvxabIOTf977KMTIp9irpuHGy8P1QBr2QcHCdBLu7ftthLyl5V9XBNkgtUTdMb7NkbE7ilSwg5r6rIiWDsAScwtRHsBv35zwMQJ6Q10J3CzsWDlT5YKCnIl3wwOemUDJs8wZM2/Rliyp9fszwR0ZgRe8b0jwr4qcYHxP3NvzTpXreOlAEfg85XwRfM+iA9MH5WoyQKrAMeBBqH0C/ze0ny1yLA0VFRkB5H8y3ma/8+c4qsLEY
x-ms-exchange-antispam-messagedata: yKl4TsaFY7tyF4BR4aLbCEBYO2Zo4GDU8BzggMBLzyWhlMPz6VpJ3JopOta4tpTngHlagEe/dTRmychyC2pEva0JApZbcSYv85Z0R9QJoa98MN71Wu18BH8y4J5PDjGsU6HicicziDWpA4VqnWFf+g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc0667f8-affe-4a9a-14f8-08d7b12ed77c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2020 09:18:23.7510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /p/iiYsH9dcH9drjjbysMB4mfHEf2vBE4z1SBTcaqlQ9P4KQBl743D94PILgjKPbX8c2XRrLRWymi0r5Ctm9ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5948
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQo+IEZyb206IE1pY2hhZWwgV2FsbGUgPG1pY2hhZWxAd2FsbGUuY2M+DQo+IFNlbnQ6
IDIwMjDlubQy5pyIMTTml6UgMTY6NDMNCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpo
YW5nQG54cC5jb20+DQo+IENjOiBNYXJjIEtsZWluZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRl
Pjsgd2dAZ3JhbmRlZ2dlci5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWNh
bkB2Z2VyLmtlcm5lbC5vcmc7IFBhbmthaiBCYW5zYWwNCj4gPHBhbmthai5iYW5zYWxAbnhwLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCAwLzhdIGNhbjogZmxleGNhbjogYWRkIENBTiBGRCBz
dXBwb3J0IGZvciBOWFAgRmxleGNhbg0KPiANCj4gSGkgSm9ha2ltLA0KPiANCj4gQW0gMjAyMC0w
Mi0xNCAwMjo1NSwgc2NocmllYiBKb2FraW0gWmhhbmc6DQo+ID4gSGkgTWljaGFsLA0KPiA+DQo+
ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IE1pY2hhZWwgV2FsbGUg
PG1pY2hhZWxAd2FsbGUuY2M+DQo+ID4+IFNlbnQ6IDIwMjDlubQy5pyIMTTml6UgMzoyMA0KPiA+
PiBUbzogTWFyYyBLbGVpbmUtQnVkZGUgPG1rbEBwZW5ndXRyb25peC5kZT4NCj4gPj4gQ2M6IEpv
YWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyB3Z0BncmFuZGVnZ2VyLmNvbTsN
Cj4gPj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtY2FuQHZnZXIua2VybmVsLm9yZzsg
UGFua2FqIEJhbnNhbA0KPiA+PiA8cGFua2FqLmJhbnNhbEBueHAuY29tPjsgTWljaGFlbCBXYWxs
ZSA8bWljaGFlbEB3YWxsZS5jYz4NCj4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCAwLzhdIGNhbjog
ZmxleGNhbjogYWRkIENBTiBGRCBzdXBwb3J0IGZvciBOWFANCj4gPj4gRmxleGNhbg0KPiA+Pg0K
PiA+PiBIaSwNCj4gPj4NCj4gPj4gPj4+IEFyZSB5b3UgcHJlcGFyZWQgdG8gYWRkIGJhY2sgdGhl
c2UgcGF0Y2hlcyBhcyB0aGV5IGFyZSBuZWNlc3NhcnkNCj4gPj4gPj4+IGZvciBGbGV4Y2FuIENB
TiBGRD8gQW5kIHRoaXMgRmxleGNhbiBDQU4gRkQgcGF0Y2ggc2V0IGlzIGJhc2VkIG9uDQo+ID4+
ID4+PiB0aGVzZSBwYXRjaGVzLg0KPiA+PiA+Pg0KPiA+PiA+PiBZZXMsIHRoZXNlIHBhdGNoZXMg
d2lsbCBiZSBhZGRlZCBiYWNrLg0KPiA+PiA+DQo+ID4+ID5JJ3ZlIGNsZWFuZWQgdXAgdGhlIGZp
cnN0IHBhdGNoIGEgYml0LCBhbmQgcHVzaGVkIGV2ZXJ5dGhpbmcgdG8gdGhlDQo+ID4+ID50ZXN0
aW5nIGJyYW5jaC4gQ2FuIHlvdSBnaXZlIGl0IGEgdGVzdC4NCj4gPj4NCj4gPj4gV2hhdCBoYXBw
ZW5kIHRvIHRoYXQgYnJhbmNoPyBGV0lXIEkndmUganVzdCB0cmllZCB0aGUgcGF0Y2hlcyBvbiBh
DQo+ID4+IGN1c3RvbSBib2FyZCB3aXRoIGEgTFMxMDI4QSBTb0MuIEJvdGggQ0FOIGFuZCBDQU4t
RkQgYXJlIHdvcmtpbmcuDQo+ID4+IEkndmUgdGVzdGVkIGFnYWluc3QgYSBQZWFrdGVjaCBVU0Ig
Q0FOIGFkYXB0ZXIuIEknZCBsb3ZlIHRvIHNlZSB0aGVzZQ0KPiA+PiBwYXRjaGVzIHVwc3RyZWFt
LCBiZWNhdXNlIG91ciBib2FyZCBhbHNvIG9mZmVycyBDQU4gYW5kIGJhc2ljIHN1cHBvcnQNCj4g
Pj4gZm9yIGl0IGp1c3QgbWFkZSBpdCB1cHN0cmVhbSBbMV0uDQo+ID4gVGhlIEZsZXhDQU4gQ0FO
IEZEIHJlbGF0ZWQgcGF0Y2hlcyBoYXZlIHN0YXllZCBpbg0KPiA+IGxpbnV4LWNhbi1uZXh0L2Zs
ZXhjYW4gYnJhbmNoIGZvciBhIGxvbmcgdGltZSwgSSBzdGlsbCBkb24ndCBrbm93IHdoeQ0KPiA+
IE1hcmMgZG9lc24ndCBtZXJnZSB0aGVtIGludG8gTGludXggbWFpbmxpbmUuDQo+ID4gaHR0cHM6
Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJG
JTJGZ2l0Lg0KPiA+DQo+IGtlcm5lbC5vcmclMkZwdWIlMkZzY20lMkZsaW51eCUyRmtlcm5lbCUy
RmdpdCUyRm1rbCUyRmxpbnV4LWNhbi1uZXh0LmcNCj4gPg0KPiBpdCUyRnRyZWUlMkYlM0ZoJTNE
ZmxleGNhbiZhbXA7ZGF0YT0wMiU3QzAxJTdDcWlhbmdxaW5nLnpoYW5nJTQwbg0KPiB4cC5jbw0K
PiA+DQo+IG0lN0M5NGRjYTQ0NzJhNTg0NDEwYjNiOTA4ZDdiMTI5ZGIyNyU3QzY4NmVhMWQzYmMy
YjRjNmZhOTJjZDk5Yw0KPiA1YzMwMTYzDQo+ID4NCj4gNSU3QzAlN0MwJTdDNjM3MTcyNjY1NjQy
MDc5MTkyJmFtcDtzZGF0YT03N3RHNlZ1UUNpJTJGWlhCS2IyMw0KPiA4JTJGZE5TVjMNCj4gPiBO
VUlGck01WTBlOXlqMEozb3MlM0QmYW1wO3Jlc2VydmVkPTANCj4gPiBBbHNvIG11c3QgaG9wZSB0
aGF0IHRoaXMgcGF0Y2ggc2V0IGNhbiBiZSB1cHN0cmVhbWVkIHNvb24uIDotKQ0KPiANCj4gSSd2
ZSB0b29rIHRoZW0gZnJvbSB0aGlzIGJyYW5jaCBhbmQgYXBwbGllZCB0aGVtIHRvIHRoZSBsYXRl
c3QgbGludXggbWFzdGVyLg0KPiANCj4gVGh1cywNCj4gDQo+IFRlc3RlZC1ieTogTWljaGFlbCBX
YWxsZSA8bWljaGFlbEB3YWxsZS5jYz4NCj4gDQo+IA0KPiA+PiBJZiB0aGVzZSBwYXRjaGVzIGFy
ZSB1cHN0cmVhbSwgb25seSB0aGUgZGV2aWNlIHRyZWUgbm9kZXMgc2VlbXMgdG8gYmUNCj4gPj4g
bWlzc2luZy4NCj4gPj4gSSBkb24ndCBrbm93IHdoYXQgaGFzIGhhcHBlbmVkIHRvIFsyXS4gQnV0
IHRoZSBwYXRjaCBkb2Vzbid0IHNlZW0gdG8NCj4gPj4gYmUgbmVjZXNzYXJ5Lg0KPiA+IFllcywg
dGhpcyBwYXRjaCBpcyB1bm5lY2Vzc2FyeS4gSSBoYXZlIE5BQ0tlZCB0aGlzIHBhdGNoIGZvciB0
aGF0LA0KPiA+IGFjY29yZGluZyB0byBGbGV4Q0FOIEludGVncmF0ZWQgR3VpZGUsIENUUkwxW0NM
S1NSQ109MCBzZWxlY3QNCj4gPiBvc2NpbGxhdG9yIGNsb2NrIGFuZCBDVFJMMVtDTEtTUkNdPTEg
c2VsZWN0IHBlcmlwaGVyYWwgY2xvY2suDQo+ID4gQnV0IGl0IGlzIGFjdHVhbGx5IGRlY2lkZWQg
YnkgU29DIGludGVncmF0aW9uLCBmb3IgaS5NWCwgdGhlIGRlc2lnbiBpcw0KPiA+IGRpZmZlcmVu
dC4NCj4gDQo+IG9rIHRoYW5rcyBmb3IgY2xhcmlmeWluZy4NCj4gDQo+ID4gSSBoYXZlIG5vdCB1
cHN0cmVhbSBpLk1YIEZsZXhDQU4gZGV2aWNlIHRyZWUgbm9kZXMsIHNpbmNlIGl0J3MNCj4gPiBk
ZXBlbmRlbmN5IGhhdmUgbm90IHVwc3RyZWFtZWQgeWV0Lg0KPiA+DQo+ID4+IFBhbmthaiBhbHJl
YWR5IHNlbmQgYSBwYXRjaCB0byBhZGQgdGhlIGRldmljZSBub2RlIHRvIHRoZSBMUzEwMjhBIFsz
XS4NCj4gPj4gVGhhdHMgYmFzaWNhbGx5IHRoZSBzYW1lIEkndmUgdXNlZCwgb25seSB0aGF0IG1p
bmUgZGlkbid0IGhhZCB0aGUNCj4gPj4gImZzbCxsczEwMjhhcjEtZmxleGNhbiIgY29tcGF0aWJs
aXR5IHN0cmluZywgYnV0IG9ubHkgdGhlDQo+ID4+ICJseDIxNjBhcjEtZmxleGNhbiINCj4gPj4g
d2hpY2ggaXMgdGhlIGNvcnJlY3Qgd2F5IHRvIHVzZSBpdCwgcmlnaHQ/DQo+ID4gWW91IGNhbiBz
ZWUgYmVsb3cgdGFibGUgZnJvbSBGbGV4Q0FOIGRyaXZlciwgImZzbCxseDIxNjBhcjEtZmxleGNh
biINCj4gPiBzdXBwb3J0cyBDQU4gRkQsIHlvdSBjYW4gdXNlIHRoaXMgY29tcGF0aWJsZSBzdHJp
bmcuDQo+IA0KPiBjb3JyZWN0LiBJJ3ZlIGFscmVhZHkgYSBwYXRjaCB0aGF0IGRvZXMgZXhhY3Rs
eSB0aGlzIDspIFdobyB3b3VsZCB0YWtlIHRoZSBwYXRjaA0KPiBmb3IgYWRkaW5nIHRoZSBMUzEw
MjhBIGNhbiBkZXZpY2UgdHJlZSBub2RlcyB0byBsczEwMjhhLmR0c2k/IFlvdSBvciBTaGF3bg0K
PiBHdW8/DQpTb3JyeSwgSSBtaXNzZWQgdGhlIGxpbmtbM10sIHdlIHVzdWFsbHkgd3JpdGUgaXQg
dGhpcyB3YXk6DQoJCQljb21wYXRpYmxlID0gImZzbCxsczEwMjhhcjEtZmxleGNhbiIsImZzbCxs
eDIxNjBhcjEtZmxleGNhbiI7DQpQbGVhc2Ugc2VuZCBwYXRjaCB0byBTaGF3biBHdW8sIGhlIHdp
bGwgcmV2aWV3IHRoZSBkZXZpY2UgdHJlZS4NCg0KPiA+IHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb2Zf
ZGV2aWNlX2lkIGZsZXhjYW5fb2ZfbWF0Y2hbXSA9IHsNCj4gPiAJeyAuY29tcGF0aWJsZSA9ICJm
c2wsaW14OHFtLWZsZXhjYW4iLCAuZGF0YSA9DQo+ID4gJmZzbF9pbXg4cW1fZGV2dHlwZV9kYXRh
LCB9LA0KPiA+IAl7IC5jb21wYXRpYmxlID0gImZzbCxpbXg2cS1mbGV4Y2FuIiwgLmRhdGEgPSAm
ZnNsX2lteDZxX2RldnR5cGVfZGF0YSwNCj4gPiB9LA0KPiA+IAl7IC5jb21wYXRpYmxlID0gImZz
bCxpbXgyOC1mbGV4Y2FuIiwgLmRhdGEgPSAmZnNsX2lteDI4X2RldnR5cGVfZGF0YSwNCj4gPiB9
LA0KPiA+IAl7IC5jb21wYXRpYmxlID0gImZzbCxpbXg1My1mbGV4Y2FuIiwgLmRhdGEgPSAmZnNs
X2lteDI1X2RldnR5cGVfZGF0YSwNCj4gPiB9LA0KPiA+IAl7IC5jb21wYXRpYmxlID0gImZzbCxp
bXgzNS1mbGV4Y2FuIiwgLmRhdGEgPSAmZnNsX2lteDI1X2RldnR5cGVfZGF0YSwNCj4gPiB9LA0K
PiA+IAl7IC5jb21wYXRpYmxlID0gImZzbCxpbXgyNS1mbGV4Y2FuIiwgLmRhdGEgPSAmZnNsX2lt
eDI1X2RldnR5cGVfZGF0YSwNCj4gPiB9LA0KPiA+IAl7IC5jb21wYXRpYmxlID0gImZzbCxwMTAx
MC1mbGV4Y2FuIiwgLmRhdGEgPSAmZnNsX3AxMDEwX2RldnR5cGVfZGF0YSwNCj4gPiB9LA0KPiA+
IAl7IC5jb21wYXRpYmxlID0gImZzbCx2ZjYxMC1mbGV4Y2FuIiwgLmRhdGEgPSAmZnNsX3ZmNjEw
X2RldnR5cGVfZGF0YSwNCj4gPiB9LA0KPiA+IAl7IC5jb21wYXRpYmxlID0gImZzbCxsczEwMjFh
cjItZmxleGNhbiIsIC5kYXRhID0NCj4gPiAmZnNsX2xzMTAyMWFfcjJfZGV2dHlwZV9kYXRhLCB9
LA0KPiA+IAl7IC5jb21wYXRpYmxlID0gImZzbCxseDIxNjBhcjEtZmxleGNhbiIsIC5kYXRhID0N
Cj4gPiAmZnNsX2x4MjE2MGFfcjFfZGV2dHlwZV9kYXRhLCB9LA0KPiA+IAl7IC8qIHNlbnRpbmVs
ICovIH0sDQo+ID4gfTsNCj4gPg0KPiANCj4gLW1pY2hhZWwNCg==

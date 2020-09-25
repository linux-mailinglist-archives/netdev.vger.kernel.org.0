Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3E5278395
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 11:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgIYJJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 05:09:27 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:12498
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727132AbgIYJJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 05:09:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rr+YGoDisePM0k7GtIc3nfwsquMWnPDk3DyJbeVJS+jAym8UdJJgNq2U4rsujNRJU0/UA1ePZ8j8Vchp0ZmgZraI0rX6ugSKNDC6JfBtGp87E5OwJMW2c6QOCMrehSk9gdWicgJ4GoE80OvYFF8YzTORBNCXlKqYrjh+LndoKE9Mwt5p86Za67JYU3J96U97FH0wGqBbIOev8hhBWN6l2fFmmw8NapSGge1m+iakENuy5XIW4hArUkDPSSTkXoAHNZPKWdm9iuMbuqhs+6iwfqiftIVRH/a6byhLpq48GLh3sumx37S7/IUqye/UAIg6ZamuiHWmUSrl48rFCJXQGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQ4g5zIA2jL+xcQZ45S01ftE8NLGhoijUpL899+dmaw=;
 b=foS0QcDc2gZcmQRmyjGW9Yke9nplAFjHXU3bbbVSJcXqYT4YUJk23iNEmFwKuvHL766fSRFCTpiXISqLs/rVa3oTr7oGcalXPNol7hvyfye6m7+XBIl4YypszMt60aYsMCiCvHZkByz6KTNy0zUh4MP16Jfz0Df4VyBGc4icOBiUV9d9539lDVPzmWxMU1j2D34umMOPx2K6+OVBkDyb5XfCyQRIb6MkfeZmKkgfWp30D5a2q/G7QvPu2hmlPT7XuRpdSNroHmMAmlgKI2iAYyE8z6mHUkCIyvvhsL0sYLims6dv7197S+0NNB6G3bb75Wf1hMM8VIGDIsjxr6A4Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQ4g5zIA2jL+xcQZ45S01ftE8NLGhoijUpL899+dmaw=;
 b=IqoslXa+TXCbddgJ/tBETBsrbVweuoBIKD3IL3/KmRA3Tu0cC/w+xjHXgYhAEcvj7/8hS4Tz60mqsEpWqxbPeG+CrSMGrIpHODlnwjw4zvqjvCflgYtq8YlyJsbtBNgP6u1j1ODoTqR/wmJFNqdQcICz+p6aFoS7tGmAQSaPe+M=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5498.eurprd04.prod.outlook.com (2603:10a6:10:80::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 09:09:23 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 09:09:22 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
Thread-Topic: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
Thread-Index: AQHWkwrxc33Q4pOyMEiSJX13xMzIVal49jIAgAAAT/CAAApBAIAABgZggAAIjICAAAD+IA==
Date:   Fri, 25 Sep 2020 09:09:22 +0000
Message-ID: <DB8PR04MB6795F99110BC7B3356E08CA9E6360@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
 <20200925151028.11004-2-qiangqing.zhang@nxp.com>
 <b4960a59-a864-d6f8-cef6-7223a6351dae@pengutronix.de>
 <DB8PR04MB6795BB0D5F2FFEEC3D384A96E6360@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <a4a57849-fc34-0bc5-f35e-13347f6585dd@pengutronix.de>
 <DB8PR04MB6795BAB5714106474A06FD81E6360@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <ec1fc3c2-9879-8df5-c1ab-35fe1705c99c@pengutronix.de>
In-Reply-To: <ec1fc3c2-9879-8df5-c1ab-35fe1705c99c@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5753d919-927b-43f3-0551-08d86132b187
x-ms-traffictypediagnostic: DB7PR04MB5498:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5498510B28745F8250EFB88DE6360@DB7PR04MB5498.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PeDI9Rz3XhMry8awhgaXucUc6Y68ZLhlRGstVtAi5wJwi8bpmubB/IUZs64kqW7FuOOSkkdrrvOt7lH4XslvuWpMRNxdLctHz/KZhtBt+EclhWykkh67ql+iosAeXS+dFWwrZKtn4HKoM0s6D9Lso7/KuFYv1rNmNhl4Wfv4eOODxU24TMQ0/5Xz59CKDgpSyrUGjF8yBF9GHpavDx9QNX2Mps7Og7SSODIXnSLN71oN6g0yi79WPVNgyjZyVi3BG4wBY6MtGvsOcfjf1Em1igljqaZ50eAXV66DDLgyofi/IOzz9qiwNOyNVcJGMIoL7nVOylmLHy+I/NBvGH3WFOJ3opNG8eSScWS/kHBVyHvEmc5vkEn7X9GcEVGMk4z98yh8nnjGUfXe2CAp+8i9fg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(5660300002)(71200400001)(186003)(26005)(316002)(7696005)(83380400001)(2906002)(4326008)(53546011)(966005)(33656002)(110136005)(83080400001)(478600001)(66946007)(66446008)(64756008)(66476007)(66556008)(54906003)(55016002)(6506007)(8676002)(52536014)(86362001)(8936002)(76116006)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: nE/qTl5HCHzYMUr3tU0uBerPCWOvh1q9+UQcwooARnMSzTw0ATLabuGjP+kry4Pt5FRL+NL5vvMN5mhFozUtCqScX9E0pgKbCPnH0wQ7e7F51HfpBtRle9vm72UahZmaj2I+zA9sbR9zah1X/vmCBj7AtkpL0TyBZFpZ+X3s5PG1jYM/rdR8tFVTU1zj1vtR+5YRCVswnci+Zpyx1jnGeBp1F3kKFK9VdM/QCRJrZ/yQ+Ayl0JXZauHtTkuiUTxuDXJWejlXIU7XAZ/q4digusrq8QjHv3M3rXJlqsIVq3h0y13q9MdIsx74/iQVmDw7aA4O+kuBcP/smKnn9QIbCDz3g1jQTdbq2B+yazoUPmcm5aGO7rms3LxM6NjETEFKNK4XzvkJFEhmeWg4X9hxqCeBxoXo7506JPsG8gckTGxvqgAneg4DA0mUMclEt6cAPGK6VIGnpi2bxHdS8U7FSOE8voEyMh91tmsDOh9RG+4E3X2UG4WJ/GL9Wj0QFYX/vQqL2EtiDVSa2otVqz6kGDCk/aRROdy5Kv5+azueJ1NlcTYZ0TgfG6dRuf/N/QTxuK72xVfH1v88cWvhs9quu9Rjq0wOb7z3OCc7n/EMyUQ7d1h5hEfIDxIsCZ7m0u0Y9LVkXSosHyZ37KC/kSGKpw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5753d919-927b-43f3-0551-08d86132b187
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 09:09:22.6485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hs3VqXWDvnai75KBwdY2RLce4tAJPtviPHt6wne3xKIYXutudhO+jdLyNifpdVaBlCtuZx7x6PpcCobkGsMh9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5498
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjXml6UgMTc6MDMNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGxpbnV4LWNhbi1uZXh0
L2ZsZXhjYW4gMS80XSBjYW46IGZsZXhjYW46IGluaXRpYWxpemUgYWxsIGZsZXhjYW4NCj4gbWVt
b3J5IGZvciBFQ0MgZnVuY3Rpb24NCj4gDQo+IE9uIDkvMjUvMjAgMTA6NTEgQU0sIEpvYWtpbSBa
aGFuZyB3cm90ZToNCj4gPj4+IEkgbm90aWNlIGl0IGp1c3Qgbm93LCBzZWVtcyBsYWNrIG9mIHBh
dGNoIGZvciBpbXggZmlybXdhcmUgaW4NCj4gPj4+IHVwc3RyZWFtLCB0aGF0IHdpbGwgYWx3YXlz
IGV4cG9ydCBzY3Ugc3ltYm9scy4NCj4gPj4+IGluY2x1ZGUvbGludXgvZmlybXdhcmUvaW14L3N2
Yy9taXNjLmgNCj4gPj4NCj4gPj4gVGhhdCB3aWxsIGFmZmVjdCAiY2FuOiBmbGV4Y2FuOiBhZGQg
Q0FOIHdha2V1cCBmdW5jdGlvbiBmb3IgaS5NWDgiDQo+ID4+IG5vdCB0aGlzIHBhdGNoLCByaWdo
dD8NCj4gPg0KPiA+IFllcywgb25seSBhZmZlY3QgImNhbjogZmxleGNhbjogYWRkIENBTiB3YWtl
dXAgZnVuY3Rpb24gZm9yIGkuTVg4IiwgSQ0KPiA+IHdpbGwgcmVtb3ZlIHRoaXMgcGF0Y2ggZmly
c3QuDQo+IA0KPiBvaw0KPiANCj4gPiBTb3JyeSwgSSByZXBsaWVkIGluIGEgd3JvbmcgcGxhY2Uu
DQo+IA0KPiBucA0KPiANCj4gPiAiY2FuOiBmbGV4Y2FuOiBpbml0aWFsaXplIGFsbCBmbGV4Y2Fu
IG1lbW9yeSBmb3IgRUNDIGZ1bmN0aW9uIiBmb3INCj4gPiB0aGlzIHBhdGNoLCBJIGZpbmQgdGhp
cyBpc3N1ZSBpbiBpLk1YOE1QLCB3aGljaCBpcyB0aGUgZmlyc3QgU29DDQo+ID4gaW1wbGVtZW50
cyBFQ0MgZm9yIGkuTVgNCj4gDQo+IFdoYXQgYWJvdXQgdGhlIG14Nz8NCj4gDQo+ID4gSSB0aGlu
ayB0aGlzIHBhdGNoIHNob3VsZCBjb21wYXRpYmxlIHdpdGggb3RoZXJzIHdoaWNoIGhhcyBFQ0MN
Cj4gPiBzdXBwb3J0LCBidXQgSSBkb24ndCBoYXZlIG9uZSB0byBoYXZlIGEgdGVzdC4NCj4gDQo+
IFdoYXQgYWJvdXQgdGhlIG14Nz8NCg0KQXMgSSBrbm93IG9ubHkgaS5NWDdEIGludGVncmF0ZWQg
aW4gRmxleGNhbiB3aXRob3V0IEVDQywgSSBhbSBub3QgcXVpdGUgdW5kZXJzdGFuZCB3aGF0IHlv
dSBtZWFuaW5nLg0KQ291bGQgeW91IGV4cGxhaW4gbW9yZT8NCg0KQmVzdCBSZWdhcmRzLA0KSm9h
a2ltIFpoYW5nDQo+IE1hcmMNCj4gDQo+IC0tDQo+IFBlbmd1dHJvbml4IGUuSy4gICAgICAgICAg
ICAgICAgIHwgTWFyYyBLbGVpbmUtQnVkZGUgICAgICAgICAgIHwNCj4gRW1iZWRkZWQgTGludXgg
ICAgICAgICAgICAgICAgICAgfCBodHRwczovL3d3dy5wZW5ndXRyb25peC5kZSAgfA0KPiBWZXJ0
cmV0dW5nIFdlc3QvRG9ydG11bmQgICAgICAgICB8IFBob25lOiArNDktMjMxLTI4MjYtOTI0ICAg
ICB8DQo+IEFtdHNnZXJpY2h0IEhpbGRlc2hlaW0sIEhSQSAyNjg2IHwgRmF4OiAgICs0OS01MTIx
LTIwNjkxNy01NTU1IHwNCg0K

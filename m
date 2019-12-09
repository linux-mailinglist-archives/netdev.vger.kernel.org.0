Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D108116819
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 09:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfLII2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 03:28:23 -0500
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:4224
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726377AbfLII2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 03:28:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXzMFLXYiTMmCwBU0nswfzRmk5+IeXlYUtYlyNvvprs+Cr+CWJZI88t43H5VaC7om1DejKWakpMvt2LenolP8pXBCRTbAeK77FHmmKEaNM8Ksc+5BqnJLIn8k9E+DfZSEzZkVL/BXEsflZVoeYLSMmFkX6oDNKxOtIiwD6ciNlXHyDYmIn5B8dFGdw0eP/nSFN01VlEjJZgO+AZRox6zgWNvUeP349ce2vifWXDG5NPLfVMoCRMPmbJOKSnBAAj5KTpg52aWakt8Mx0xGOii5QtSZkGMj1BapY/kNUp7aFlwah7H+5J6F1eUhifC4yGA5ukZvo459YX01tVfkfKJ7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3kyj5a5B2Yb7rZNXU3/sIiam4fdGgZErfKE2n4CDrzA=;
 b=QOR7Vzrc4H1MBMfy5TIEKhTrLssY443Ol41UQPH8FJfNtnnnw1piZyRteaGNgQOONV4LSzwD3dJwLKI3ZBAK7lO1FdRBFwH/m89uRiBqfI3/7QO8nbzO7yJNhzwczFG0lcsuKhyBYJCZT4wCY3/yt1XNC3pA9QGqkit/KTzYTn6Hz/qST460vQzFrqa09BKLLrxj4nVE1NOB+a5OjADWE5Ful/hj+MBGHzvlhMFx2x4ogpa05dwDrh6I/XLKdWB3s58CbGPERKC6WXzLew5nGTvN6tJb9F1HjdTTv3Cv1rzv5jTEJmO8umK4ZjYHV+yM+ZsNxDtsSZyT6hi/rGv47Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3kyj5a5B2Yb7rZNXU3/sIiam4fdGgZErfKE2n4CDrzA=;
 b=UE4FKp4yn73TypicwwMmMjLvlRDVLm+yL2k6D4QBtpCvcKoi5obCO4Kfrt8ngILmQHbms2BYBNv9iEcIIB0drKzYLGDYbFC8b/2fwQsPrfcDmBHcYj6WywGfB1JGnurT9Pfqm1gaiDbg0AMpKgXIXouGqTbX8SB+sFbMBFdaLVo=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5561.eurprd04.prod.outlook.com (20.178.104.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Mon, 9 Dec 2019 08:28:17 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 08:28:17 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V3 0/6] can: flexcan: fixes for stop mode
Thread-Topic: [PATCH V3 0/6] can: flexcan: fixes for stop mode
Thread-Index: AQHVqpcC9+9ZZuOr5E+r+rwXW/eLZKeuuxgAgALENZA=
Date:   Mon, 9 Dec 2019 08:28:17 +0000
Message-ID: <DB7PR04MB4618328FDC7BC5B4DA3953A2E6580@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191204113249.3381-1-qiangqing.zhang@nxp.com>
 <67da1a42-f3d3-6ac1-e5f9-211d2da00ba3@pengutronix.de>
In-Reply-To: <67da1a42-f3d3-6ac1-e5f9-211d2da00ba3@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: de18e58f-c313-44e0-e56d-08d77c81bdfc
x-ms-traffictypediagnostic: DB7PR04MB5561:|DB7PR04MB5561:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5561920A425BCDB2DAB933A0E6580@DB7PR04MB5561.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(13464003)(189003)(199004)(74316002)(316002)(52536014)(2906002)(55016002)(9686003)(8936002)(305945005)(33656002)(99286004)(4326008)(81166006)(81156014)(6506007)(8676002)(186003)(53546011)(76116006)(66446008)(64756008)(66556008)(66946007)(66476007)(102836004)(966005)(478600001)(54906003)(229853002)(110136005)(26005)(86362001)(76176011)(7696005)(71200400001)(71190400001)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5561;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JUJOODAbjvmbqw0QaGVECG8Tl8ROoJeupx0faEPEiSm97qjgiQLDzjlx1E895f/HdrSJa5h+9nwAJdZgjjjdI7uofUkR3rWMOxb40i1Vjb2VU1ks7XE10dfXgec+RfytTYonyR8IL9u9nvmTKXiRwjtIgN+Gisc0h5knk4Ay3uy468vcPYIqIrMYMoANEeAvCM/J70mj8tREBkTMgCAcw4ULtKYHCtG8h3RGSXq07U1eiEJ1AK564q608SRrtqE9qa2sRdFdUJ1vRLT9LsITRLOCOGCaIvHJS+Mj91MyLt7K7pFKy/uGpu0RbguqMjROFTV9r5QebLzIzULNi7IMiPkjsC5qpY88Fozp9BHrET6hzNRGMNxbNVWoVvCn7RJ5Te1QMAqk5Qi8Bbid28qdlDclPc/P7JMECLOT5JqF17bUXN00kDRMAdHmK6eCXvbsd09TPscYszKtNz+dgG1vobMznW8FuMZvR6YpbKHeqiGqXhwOwHmF0nXdGR5uiFdmcbnJzE2i6lrO4XwyZWmJSJCFBVrqtmp4mf1yWYV3dTc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de18e58f-c313-44e0-e56d-08d77c81bdfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 08:28:17.3998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SbkHhaXcTPRgxdInMcFpXuhwnSa/iFHBA+/RQitSRYPS5iB9gwpMhmQt05IVxOx3Ow3e+AmthBSA6lfzaOWnWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5561
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMTnlubQxMuaciDfml6UgMjI6MTENCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBzZWFuQGdlYW5peC5j
b207DQo+IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGlu
dXgtaW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggVjMgMC82XSBjYW46IGZsZXhjYW46IGZpeGVzIGZvciBzdG9wIG1vZGUNCj4gDQo+IE9u
IDEyLzQvMTkgMTI6MzYgUE0sIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBIaSBNYXJjLA0KPiA+
DQo+ID4gICAgSSByZW1vdmVkIHRoZSBwYXRjaCAoY2FuOiBmbGV4Y2FuOiB0cnkgdG8gZXhpdCBz
dG9wIG1vZGUgZHVyaW5nDQo+ID4gcHJvYmUgc3RhZ2UpIG91dCBvZiB0aGlzIHBhdGNoIHNldCBm
b3Igbm93LiBUaGlzIHBhdGNoIHNob3VsZCBmdXJ0aGVyDQo+ID4gZGlzY3VzcyB3aXRoIFNlYW4g
YW5kIEkgd2lsbCBwcmVwYXJlIGl0IGFjY29yZGluZyB0byBmaW5hbCBjb25jbHVzaW9uLiBUaGFu
a3MuDQo+ID4NCj4gPiBSZWdhcmRzLA0KPiA+IEpvYWtpbSBaaGFuZw0KPiA+DQo+ID4gSm9ha2lt
IFpoYW5nICg1KToNCj4gPiAgIGNhbjogZmxleGNhbjogQWNrIHdha2V1cCBpbnRlcnJ1cHQgc2Vw
YXJhdGVseQ0KPiA+ICAgY2FuOiBmbGV4Y2FuOiBhZGQgbG93IHBvd2VyIGVudGVyL2V4aXQgYWNr
bm93bGVkZ21lbnQgaGVscGVyDQo+ID4gICBjYW46IGZsZXhjYW46IGNoYW5nZSB0aGUgd2F5IG9m
IHN0b3AgbW9kZSBhY2tub3dsZWRnbWVudA0KPiANCj4gQWJvdmUgMyBhcHBsaWVkIHRvIGxpbnV4
LWNhbi4NCkhpIE1hcmMsDQoNCkZyb20gYmVsb3cgbGluaywgSSBoYXZlIG5vdCBmb3VuZCB0aGUg
cGF0Y2g6IGNhbjogZmxleGNhbjogQWNrIHdha2V1cCBpbnRlcnJ1cHQgc2VwYXJhdGVseQ0KaHR0
cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbWtsL2xpbnV4LWNh
bi5naXQvbG9nLz9oPWxpbnV4LWNhbi1maXhlcy1mb3ItNS41LTIwMTkxMjA4DQoNCj4gPiAgIGNh
bjogZmxleGNhbjogcHJvcGFnYXRlIGVycm9yIHZhbHVlIG9mIGZsZXhjYW5fY2hpcF9zdG9wKCkN
Cj4gPiAgIGNhbjogZmxleGNhbjogYWRkIExQU1IgbW9kZSBzdXBwb3J0DQo+IA0KPiBBYm92ZSAy
IGFwcGxpZWQgdG8gbGludXgtY2FuLW5leHQNCg0KSSBhbHNvIGhhdmUgbm90IGZvdW5kIHRoZXNl
IHR3byBwYXRjaCBvbiBsaW51eC1jYW4tbmV4dCwgd2hpY2ggYnJhbmNoIGhhcyB5b3UgcHVzaGVk
Pw0KDQpUaGFua3MuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiBNYXJjDQo+IC0t
DQo+IFBlbmd1dHJvbml4IGUuSy4gICAgICAgICAgICAgICAgIHwgTWFyYyBLbGVpbmUtQnVkZGUg
ICAgICAgICAgIHwNCj4gRW1iZWRkZWQgTGludXggICAgICAgICAgICAgICAgICAgfCBodHRwczov
L3d3dy5wZW5ndXRyb25peC5kZSAgfA0KPiBWZXJ0cmV0dW5nIFdlc3QvRG9ydG11bmQgICAgICAg
ICB8IFBob25lOiArNDktMjMxLTI4MjYtOTI0ICAgICB8DQo+IEFtdHNnZXJpY2h0IEhpbGRlc2hl
aW0sIEhSQSAyNjg2IHwgRmF4OiAgICs0OS01MTIxLTIwNjkxNy01NTU1IHwNCg0K

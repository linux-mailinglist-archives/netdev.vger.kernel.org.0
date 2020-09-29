Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3E027CE12
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgI2Mux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:50:53 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:5441
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725497AbgI2Muw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 08:50:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixLoY3VEGCKf6JwHY4TwVYlUtIaBCSZp2zX6LWTrkF02HgC2e5v5pAMBIm2K05f9mqTtXzfpYZ7jaI1+QcJ5A7dPdQzHUoqPCRBO+ypmA3bGYk5CriIKmtlaDv2HWDq+UD/CDNIBseRhBmJjYunco2zUKgpWd8KgIaxY5dkzlYW9K1AAjP9ymM08MTDUi1v/KkJY+mgUEvNibR5NBaWg4QxDAVCxh3cuknrRpCCn7Aa9UrgRyCgifN64joYQumr6Ns7i/XUk0J1yIM2eUQpA8GclEF0G4mi24+w1SYfd5DcImNL6okF4AzLOpDlkpUl52TYHLqs7Qd8aDBJLyM0AHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krEeQXh7vnZCRxm2B+HeuQ0g0I/CSomob562jDXjN74=;
 b=DqH8/5Hj8zW29Ta8Yr5h2Z2nIhytIXZTyzXi+hx9/vs59UWrTnWep20ziD1HQqZYcqTQ4godvcOI0X9oIYeHEt4qBh3E+M5n7BtJV10vqw+z1N2f1tbXFhgDq539Ey4KuhZAobJ7aphg0F8uHm4O1TcL3P+Yf4ukHc1x8VWF0dCAFsVev+Jnu/GqfcQbonGi0nydivalqS9Ndyy3yU3u7NkkXhAeElQFikW+1rTVXdsO1Eso9CTLJE46vqCTEbXWFDP2JMWiF/hIEzCvyfLltPBNfyR0Bp0ToO5O2Gs7RqmEEvGKzNehcti/t3nSHUEw+hR2OsHCPA1MmgETQCI3hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krEeQXh7vnZCRxm2B+HeuQ0g0I/CSomob562jDXjN74=;
 b=EVVgcEIj4kfYajz5x3Hk+UI18QxDDA4hI//XOinMFkx+0a23vDcLrblc9v5nRRuP41IKsFwg93t6Dum6RVMzLGi4hqwZJy9E3OtkWgfsEhrNMJQOiFgf/ReEoztDYftnJOtrblNjMSqf+p6mELTgJkyL5PT17CAW2vVundjoz9A=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4523.eurprd04.prod.outlook.com (2603:10a6:5:36::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Tue, 29 Sep
 2020 12:50:47 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 12:50:47 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V4 1/3] can: flexcan: initialize all flexcan memory for
 ECC function
Thread-Topic: [PATCH V4 1/3] can: flexcan: initialize all flexcan memory for
 ECC function
Thread-Index: AQHWllxRCGGVs15QsUygFdyhvunwO6l/jOyAgAAAM9CAAAMlgIAAAPgg
Date:   Tue, 29 Sep 2020 12:50:47 +0000
Message-ID: <DB8PR04MB6795EE167EB23830A3FDA3EEE6320@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200929203041.29758-1-qiangqing.zhang@nxp.com>
 <20200929203041.29758-2-qiangqing.zhang@nxp.com>
 <a48af36d-86ac-8523-a1be-f176b4e14540@pengutronix.de>
 <DB8PR04MB67955F29A48029246831EA85E6320@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <93f814c5-e782-81dd-36a9-1d6013f791d7@pengutronix.de>
In-Reply-To: <93f814c5-e782-81dd-36a9-1d6013f791d7@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ff77de26-032e-44ff-13e3-08d864764982
x-ms-traffictypediagnostic: DB7PR04MB4523:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4523F19AFC1E742D52403C8FE6320@DB7PR04MB4523.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tVbJMrs4iHLG6r2QSgxurkqHTksUm6XyaYBnyAxU6nUefSu2Th4FWih4xIGkKDYV2QElvYD/lmMzv8j2E09WcO34yA0RtcAupLzdFVgTBVACZrMQ/E3OiLjKoH1M6lBGbpzwWwX7JH1Z8zuVaTA3a2xqTpLHHtqzgzCzL1RKn2ckTzIqtqqisoA0v0ifNMfVfdoOfCpvOB9iKbwVI64/uOG800dEiDzu4JOp1WcOpACEve1pEFG/Jr//mY25sEB7pEURZBUyok8tQgM9mqCLDAWL+iXpqdQRUeZDD87t9AfXoXx9FdVFpmIZHHshZlUVuBYu0xpa7flQQvVpRGgN0EsID9TDwkApTL+VLvKbvfmtbvCurbKLBFju9Dk1vBNUFhVDBxS8u0Xz9LGusKZdfFFSMpcEXxztqpU87H3rC2jMLnB1L5ycHWAkSIq0vdy9zoHQ6Cz4F/dnIQjIFfUDUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39840400004)(376002)(366004)(346002)(396003)(2906002)(8936002)(8676002)(9686003)(55016002)(5660300002)(52536014)(66446008)(71200400001)(316002)(66556008)(76116006)(66946007)(66476007)(64756008)(54906003)(110136005)(966005)(7696005)(6506007)(53546011)(478600001)(86362001)(83380400001)(26005)(4326008)(83080400001)(186003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: DeRLEVYckZsVnTYTo3G6Rld8ox/nwUbNmbkEzz+ID89mJwvq+59AA68xHC9t4voTYNfXZWn9W+3VVr6taSQB10RyfHs46b4h2UwdLvmfTan+xab41Tsu2REi85ygW2GBwg2rBMVET9qm4c1Y0MVVVnimja740idO2qUMDoXt90n0VFxrWfl1++MWoez2zhAYoqTnSoTJpxxk7y+z3ekjW5bkA91zH732QujgQfGUTSvQF3xpIBj+1PVYkozrZceYKC5/SPbMz2erTIQKmvqiHjE080LknTVmECLlXZsxkSV0ys0jVIbhfK7mWx+7YM7tCwZJQ1HvGuxAEMM077TNlbOtU3QkNA81ws+7LI+YEPSUQdhKPaWAwQodzrfZsWQ2h9cQstXTIojn4sh25haOr6y+fueLgkrCVBEH/0sIzeuRE1v3LgqfrecAiHgX3nV4xIjSt9lIsBvoE/hB+6LfOkVc6+4Rb3/0//oY3WxyagcQY1ZLTcjFFMR8OtYnrNNZVTs1Iy5Lmjixe6oMo543J4M1+2h+yDA12/2m5zFeFwxQ/ydpNUfDpet7uVEm4FZbYZievi36vu6fKChOaxqv/GjuAcrFnsb+/u8zRV2jigp2QeOgILXC07m5Ntkr3b8tWE9s0scop7OPVycZeCuWww==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff77de26-032e-44ff-13e3-08d864764982
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2020 12:50:47.4547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rdSfvm3Z6pZPedDbXoH5LwXGNLUubgsVzTRZAAwP7Z9eRPjGzX4LqDWkFqZw65vmP+PLvspN3mfwqRR+BmDuAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4523
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjnml6UgMjA6NDYNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkbC1saW51eC1pbXgg
PGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFY0IDEvM10gY2FuOiBm
bGV4Y2FuOiBpbml0aWFsaXplIGFsbCBmbGV4Y2FuIG1lbW9yeSBmb3IgRUNDDQo+IGZ1bmN0aW9u
DQo+IA0KPiBPbiA5LzI5LzIwIDI6MzggUE0sIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPj4+ICAJ
CXJldHVybiBmbGV4Y2FuX3NldF9iaXR0aW1pbmdfY3RybChkZXYpOyAgfQ0KPiA+Pj4NCj4gPj4+
ICtzdGF0aWMgdm9pZCBmbGV4Y2FuX2luaXRfcmFtKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpIHsN
Cj4gPj4+ICsJc3RydWN0IGZsZXhjYW5fcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQo+
ID4+PiArCXN0cnVjdCBmbGV4Y2FuX3JlZ3MgX19pb21lbSAqcmVncyA9IHByaXYtPnJlZ3M7DQo+
ID4+PiArCXUzMiByZWdfY3RybDI7DQo+ID4+PiArDQo+ID4+PiArCS8qIDExLjguMy4xMyBEZXRl
Y3Rpb24gYW5kIGNvcnJlY3Rpb24gb2YgbWVtb3J5IGVycm9yczoNCj4gPj4+ICsJICogQ1RSTDJb
V1JNRlJaXSBncmFudHMgd3JpdGUgYWNjZXNzIHRvIGFsbCBtZW1vcnkgcG9zaXRpb25zIHRoYXQN
Cj4gPj4+ICsJICogcmVxdWlyZSBpbml0aWFsaXphdGlvbiwgcmFuZ2luZyBmcm9tIDB4MDgwIHRv
IDB4QURGIGFuZA0KPiA+Pj4gKwkgKiBmcm9tIDB4RjI4IHRvIDB4RkZGIHdoZW4gdGhlIENBTiBG
RCBmZWF0dXJlIGlzIGVuYWJsZWQuDQo+ID4+PiArCSAqIFRoZSBSWE1HTUFTSywgUlgxNE1BU0ss
IFJYMTVNQVNLLCBhbmQgUlhGR01BU0sNCj4gcmVnaXN0ZXJzDQo+ID4+IG5lZWQgdG8NCj4gPj4+
ICsJICogYmUgaW5pdGlhbGl6ZWQgYXMgd2VsbC4gTUNSW1JGRU5dIG11c3Qgbm90IGJlIHNldCBk
dXJpbmcgbWVtb3J5DQo+ID4+PiArCSAqIGluaXRpYWxpemF0aW9uLg0KPiA+Pj4gKwkgKi8NCj4g
Pj4+ICsJcmVnX2N0cmwyID0gcHJpdi0+cmVhZCgmcmVncy0+Y3RybDIpOw0KPiA+Pj4gKwlyZWdf
Y3RybDIgfD0gRkxFWENBTl9DVFJMMl9XUk1GUlo7DQo+ID4+PiArCXByaXYtPndyaXRlKHJlZ19j
dHJsMiwgJnJlZ3MtPmN0cmwyKTsNCj4gPj4+ICsNCj4gPj4+ICsJbWVtc2V0X2lvKCZyZWdzLT5t
YlswXVswXSwgMCwNCj4gPj4+ICsJCSAgKHU4ICopJnJlZ3MtPnJ4X3NtYjFbM10gLSAmcmVncy0+
bWJbMF1bMF0gKyAweDQpOw0KPiA+Pg0KPiA+PiB3aHkgdGhlIGNhc3Q/DQo+ID4NCj4gPiBEdWUg
dG8gbWIgaXMgZGVmaW5lZCBhcyBhIHU4LiBBbmQgdGhlIGNvdW50IG9mIG1lbXNldF9pbyBpcyBi
eXRlcy4NCj4gDQo+IHJpZ2h0LiB0aGlzIGlzIHdoeSB5b3UgZG9uJ3QgbmVlZCB0aGUgMm5kIGNh
c3QuDQoNClllcywgZG8geW91IG5lZWQgbWUgc2VuZCBhIHBhdGNoIHRvIGltcHJvdmUgaXQgd2l0
aCBvZmZzZXRvZigpPw0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gTWFyYw0KPiAN
Cj4gDQo+IC0tDQo+IFBlbmd1dHJvbml4IGUuSy4gICAgICAgICAgICAgICAgIHwgTWFyYyBLbGVp
bmUtQnVkZGUgICAgICAgICAgIHwNCj4gRW1iZWRkZWQgTGludXggICAgICAgICAgICAgICAgICAg
fCBodHRwczovL3d3dy5wZW5ndXRyb25peC5kZSAgfA0KPiBWZXJ0cmV0dW5nIFdlc3QvRG9ydG11
bmQgICAgICAgICB8IFBob25lOiArNDktMjMxLTI4MjYtOTI0ICAgICB8DQo+IEFtdHNnZXJpY2h0
IEhpbGRlc2hlaW0sIEhSQSAyNjg2IHwgRmF4OiAgICs0OS01MTIxLTIwNjkxNy01NTU1IHwNCg0K

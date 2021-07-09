Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B8D3C209F
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 10:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhGIISy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 04:18:54 -0400
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:60384
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231278AbhGIISx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 04:18:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDVWXHdyt3BGyPm2DqoDQ9pqpzcAQC6BJRzHQRLjmsT00QrQxEsY4eLRBVPlorIaK7rqLQHz0GVQctj4R3JipnbzIvyW+DCS0v34KIZDuvEFfuyMSMyZvMN8Ar+B/NnuWPPKLSxZ9XAPNBAIeKjGng9aIPHasxHFh66aRN9NoG93tLJ7EIy6VtD1xkhwBCrjU9Phw7nU/9aOg7FEVM/E2rHP1sFCzY0VN6i3slxne9gSOHcdHRmjs3hdqI3zAoK+wkf16hse1E7R4NR0gE+yJc1bRTl1SmQGImRsIB8ub/srkRJrMz11naRzRGHz3+dUTbCnVDxwI99hagcXkSFSCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZbYz4HJIa8Bqppmd6gYhh/fvvW5N2jXxo1rHMBnPSE=;
 b=Ve5HKWskNCy47Vr3GlB1T4jQNgQ90j+5+opoo2u1+BLuFmTgcTfySQ5KK5jviqAh+ovfpk3Y5LgDttTh8h/nREetD1UPe7fElAn9552f+vvi270mIa9eYcO5VJX8+v8leOJ8MODm6JAE72kym/gMtWpmYG+tLiTZAWZkoxpqCYDls0mdd/25Fl8FtLAhaIfcCQXvuoDA9aE9glstndIlB2Y8ClzRRmnvihraX0Zdf38SlKPXEbqRr2mvYlhNaBv25xfxWdSG9b4AJ/93+e7/DuPsd6vMSV+xmCzw15KuuPg+EWHXyZ6OStNJ2qHnCbm2FC9CxY/Ye0ZLkxUk5058tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZbYz4HJIa8Bqppmd6gYhh/fvvW5N2jXxo1rHMBnPSE=;
 b=gMWGB++LpHKzA7mY15F/zzWhVlZRCyRZaSrJEbVoXFKc7D5yQKFuoaNpOT6VRGO9Ox/SOOU3PNY55HoAwnArj0H53IvUpBef3vRR7+MYzORlaGVc2FvL5OD7e4eeG7ozHPjyr9Y1aKin0k1hkbu9beI06p/2fKrmIqZyBVrtwek=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5130.eurprd04.prod.outlook.com (2603:10a6:10:14::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.27; Fri, 9 Jul
 2021 08:16:07 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 08:16:07 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V1 0/5] net: fec: add support for i.MX8MQ and i.MX8QM
Thread-Topic: [PATCH V1 0/5] net: fec: add support for i.MX8MQ and i.MX8QM
Thread-Index: AQHXdJeSHEQ90K3UPUu1uanc5WIKV6s6S7jQ
Date:   Fri, 9 Jul 2021 08:16:07 +0000
Message-ID: <DB8PR04MB679549022A2DF4E0C554A51DE6189@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf90ddeb-fee9-482a-87ac-08d942b1cd91
x-ms-traffictypediagnostic: DB7PR04MB5130:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB51304AA32F736A91594598C6E6189@DB7PR04MB5130.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fsCWM0h0R3KbLKapgl1ub881vf7chuGSf1gJtR3Dq6kjFWTPUhXCgX+HxJIQw6JA9lIIat/F6Oc2M8fldyqF/W6lPWSB/aXsErzkqx8EhONSKmOG11S9GjUR816DZk955GqMD8/AzShyTs35XH55W7PP68Uk0V7d7zrkkDsk8PlSdsI/8YXugAAgxL2H4xY3SKsl2o5U+VE7R9+UB7xb49WNI4rW5L3KaSBINJ/eUaW7tEgGT937QM8HDJTcxl8c/wxFDciEj7l3xw+QXoOnGyi0DLx26Su8SjKm8GLqgPUkxR+0jOdthGr/U7f+wT4kRaSDeQiygmK8HzjKVhILtrTMmGmiNb7jhmsIcROa62xU3ZgEDyLQD/srGJLnnAXHyIUEbG6RLwYMtQcQrEKA7pU8HEJFDtOZf5wCjBIv7pX5z65nqqUdKZZJN9y3KZ5yTDTJNl+J5zap8WZtEJ0USNabcTSnBwm/KLrhA2t2QQNg9NJe1Zp2g8cV4fPHwdkKfDhpMVjlw9PhhxGFwG9UFJOJAlB49jFwmMv+YTmWS/cPrEGnxpCpmt/B4uM2eimpdTgu1B0PkXI3C5x9GSLNFx1gFlurZ4XcDI5q6ucijvdXW+c/eAS95qmpkEOr1k00ZE4UHZSdtMWsHx11mISfrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(478600001)(55016002)(86362001)(186003)(26005)(110136005)(54906003)(4326008)(83380400001)(8936002)(7696005)(52536014)(316002)(5660300002)(33656002)(9686003)(122000001)(66556008)(53546011)(8676002)(71200400001)(66946007)(6506007)(66476007)(2906002)(38100700002)(66446008)(64756008)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?MDR6MVlZckVBOWo2L1dHTzFEWldTZkxuRnJKOHppYVJPMzEzTXJ0a2cwcGVO?=
 =?gb2312?B?Q1lnTjdJZXdQRk1EMHdram9GbGZ3SHNZODBYblZ1cHZiK1hXOHNBMzNkRXJJ?=
 =?gb2312?B?ZGxSZ0ZpKzk5cXhoVDdwd0h3TU9Lc3JoRklkQmIzYmRPOXd1ZUEya0FTcXpX?=
 =?gb2312?B?NFh6MG04R1BZdWVaRWJHdGdPWnQwSVQrelI2cVlvVnZBUHM3Y1RJeTh3SVJt?=
 =?gb2312?B?NHErazlRbXFMU1lRTVFwY1o5MTdtUEY3azROQXRiRkl2b3dVcHoyNHhySTZU?=
 =?gb2312?B?a1dmN1JaT3grMlo0d2w2S1BBZEpCeG4zSEdzK3hQZ1ZubVdRZnc3MmNHWU56?=
 =?gb2312?B?Q0pMOC9ab2tJY2txd3JjNjAxM1RqVnI0ZXVvSDd0Y2pGWThWL3lYc1RNZU13?=
 =?gb2312?B?STZMR2hJMlNsK3pNZ3lYaFIrR29VeGsyOFIvN05oVDAvS3ZxSnRlbXp0eVkv?=
 =?gb2312?B?aWk2WlVKMXA2V3RVdkVXYlEzUU1FT3RsbGtqRXZScFVja2FSMWZtQ3BZMWNy?=
 =?gb2312?B?YlBJWkFYQ3YvTDNvaDdsSEJMODhuSnIzVjBGZGVFbkVub2xya3I0V1ZUcTIz?=
 =?gb2312?B?RFRYWWd4WmwyQXpCY09vdkptUnUyNm9hdUJaZi9CRXhoNVd3ZklGYmtLNFB5?=
 =?gb2312?B?Qm1pRm1YWklORlZJR1ZCb3l3RkxMTTAxS3pyaDJNUnUwa1ZJdWx6bVNxd1dV?=
 =?gb2312?B?T0NBZ3lrODNmS3IwR2tKUkZDdDBzUmpCenJHbGVick53aG9yUGVJZnZ5Vmxz?=
 =?gb2312?B?eVp4NEJVbVhuQnJqd1p5Q3l0Nm1pSXB6dDdIVUpuWVMrUENLdkpyek4xQjVa?=
 =?gb2312?B?SGFIMlN5TDE2N0lJTnNCNXBqWEtDSVkvZ3AxTURsUUlGTjdBWjE2Y05WTEV5?=
 =?gb2312?B?MnhXNVdzUjBBWGNjV2VPeHZpM2lOMXd1QUQ0ZG9UeVpYdGJDVHlzZjM5Q1pB?=
 =?gb2312?B?ZGJteW51MENJa1ppOGFBWnNuQ2FpSFlJQ3ZrME11TkFFQlJGUzdqUC9QVnc2?=
 =?gb2312?B?WE5HS3Raeml5SmIrRVlERXNrMXBNWU80M2NIcFVSc2FnYVFQK2dDajM4c3p6?=
 =?gb2312?B?NmhuVVl3bDdQdmxpWXl1ak9neXZLSnQrUytQOXFDQ0J4cm1IOTlxNlNGdnVF?=
 =?gb2312?B?cVVqdnArSHo1RlpQUGdQamQ1TEdxeHRIbTdxc1VhZG8vR3JIWHJkT2JEQ3cy?=
 =?gb2312?B?S2JvRjI0UUxzZUg2ZFQ3SmlidllGbVEvNWx4ZkNFSndnYTZHekszNWg2bjdG?=
 =?gb2312?B?dHk2VldjNkhIOHI5dkVvbW9OYjZHSW5oeEoxR2txMmFOQkMvQysvMXNPTXBn?=
 =?gb2312?B?TTYyd1lpZ3RWcDBteE5lWXd3RStkelJMQmRueDhreklOSDlMN25SaXlRLzM0?=
 =?gb2312?B?M1ZGUmJydmdSOUdrTHFsMWRwOXFGNGNVOEZPWEVQdWFISEU1SGd5dVc1NHFR?=
 =?gb2312?B?WGxxVmp2cUVQNnRkdGVzejNZYWlaKzJhbWVKWDVOR294a3daemxZT2VhWWk5?=
 =?gb2312?B?cys1NUZxbmVWRXdQODVUSFhPblRNeVFJaFVLRVJSN091R1FWd29vNEJ1KzhY?=
 =?gb2312?B?WkhEd3BvMlNSWnI4OWo1U2tZVnc0LzdvK2xpUXdTOEY2ZHBIWHNjcG8yT2pj?=
 =?gb2312?B?NDZDWWlrWDRSMU1JL1V5UkNLejl2V3lSUkFndTd3czRqSC9SSC9DNk1qTDFs?=
 =?gb2312?B?S0FFbzBmQmJWdGNsR2wyYmY3Y1F1M29iZ2xvZ21tTkxpQ3AwRE1jbFR2Y3Ju?=
 =?gb2312?Q?a7jKhY4CPwW2rtuOt4=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf90ddeb-fee9-482a-87ac-08d942b1cd91
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2021 08:16:07.4659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vg6IB6hgKk8NZuhJZ8YYhLSkAJAgiA2LyinX1EQjweKhOfagg6Fql/h8qaLzemOYQe944Fv4i4fK5nGk0cOntw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5130
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpTb3JyeSBmb3IgdGhlIG5vaXNlLCBwbGVhc2UgaWdub3JlIHRoaXMgdmVyc2lvbiwgSSB3aWxs
IHJlc2VuZCBpdCB3aXRoICJuZXQtbmV4dCIgdGFyZ2V0Lg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2Fr
aW0gWmhhbmcNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2FraW0g
WmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBTZW50OiAyMDIxxOo31MI5yNUgMTU6
NTQNCj4gVG86IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgcm9iaCtkdEBr
ZXJuZWwub3JnOw0KPiBhbmRyZXdAbHVubi5jaA0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmc7IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+DQo+IFN1YmplY3Q6IFtQQVRD
SCBWMSAwLzVdIG5ldDogZmVjOiBhZGQgc3VwcG9ydCBmb3IgaS5NWDhNUSBhbmQgaS5NWDhRTQ0K
PiANCj4gVGhpcyBwYXRjaCBzZXQgYWRkcyBzdXBwb3J0cyBmb3IgaS5NWDhNUSBhbmQgaS5NWDhR
TSwgYm90aCBvZiB0aGVtIGV4dGVuZA0KPiBuZXcgZmVhdHVyZXMuDQo+IA0KPiBGdWdhbmcgRHVh
biAoNSk6DQo+ICAgZHQtYmluZGluZ3M6IGZlYzogYWRkIHRoZSBtaXNzaW5nIGNsb2NrcyBwcm9w
ZXJ0aWVzDQo+ICAgZHQtYmluZGluZ3M6IGZlYzogYWRkIFJHTUlJIGRlbGF5ZWQgY2xvY2sgcHJv
cGVydHkNCj4gICBuZXQ6IGZlYzogYWRkIGlteDhtcSBhbmQgaW14OHFtIG5ldyB2ZXJzaW9ucyBz
dXBwb3J0DQo+ICAgbmV0OiBmZWM6IGFkZCBlZWUgbW9kZSB0eCBscGkgc3VwcG9ydA0KPiAgIG5l
dDogZmVjOiBhZGQgTUFDIGludGVybmFsIGRlbGF5ZWQgY2xvY2sgZmVhdHVyZSBzdXBwb3J0DQo+
IA0KPiAgLi4uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2ZzbC1mZWMudHh0ICAgICAgIHwgIDE1
ICsrDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjLmggICAgICAgICAgfCAg
MjUgKysrDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYyAgICAg
fCAxNDUgKysrKysrKysrKysrKysrKysrDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDE4NSBpbnNlcnRp
b25zKCspDQo+IA0KPiAtLQ0KPiAyLjE3LjENCg0K

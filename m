Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FEA20A572
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406278AbgFYTH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:07:28 -0400
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:46320
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390330AbgFYTH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 15:07:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHstisfGpG3iF4c56U4BQtSrMUlDo/9rjP2zFwqecNlJK1ajEgHKm/78Ifi4s7Orl9Cow1UieC789JJQCy9fHqXlNqblVXMNJ1FI+dy96e+/2go3D31GEoesgu3TziLtee7iyHEwS0jRRa9PnGTFVEayBbax5H6pJonpm4WdNW9gh9FyqhJlsf/BJdUWmavd+i2+vjdpNlA0pWlDpqVPjmUMNtm2tGszKaHdAAcW+naGdTXKZ/e92shSaabY312gB2fBClB60dfic5gx973gGr0mKqmmzpzayyhGpmMxI3LUR5Rfq+FFP5YKMNyD8sgQPGyDD1eRV7z27x/FPsZI2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Loi9/En1wQVjVcDvPmsGTs1MuStPphzSfaLrfAjRrg=;
 b=Oc3x/aoOYJHb4GT6Pyxd5PVsOlNOZ3oXSBY427loS1yUpEqGYAto3kND9aNPx5km1uYTeAPI9UTEJUtPd7OeLV5rHwYng2C4mm2rA1AmUBXhNICo/dTS68S/oPw4hoDIZt/j4u3oqSTdgR3xoAA6cmJBHd1AdNnMuyyKo0tBi58T25IEm5BS5v82KcxeAkrmoWz+bZOjDuKq8tZcdcvJEpfp9HB8O13Ij7Uf0RUfGYa23MdAaeMQTlrI9VKngoXulweXLgD7orBBeh4h3+/UfB0W310924EvqtdTKi3IYYOA6qRLS3pMVOKVbfRfDb3014rrMeH2rT8rLasrSt8TBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Loi9/En1wQVjVcDvPmsGTs1MuStPphzSfaLrfAjRrg=;
 b=SKWY0Ck/BibTYIwvuK5e9jgRlEK9SY5c3yRPucT/UWJKFTpozaPh6SqHL3ss2zFNwfoL7C8sDxc9oiqTQKHA8hb3Dx5e0Dp6akiOSWa+1/0bNWmgRNyA9eX64iQ9dJMjTRaEhNnPnFXe0QMBuiI8OQ9qnXjsqS2HR0j1f/XlET8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6765.eurprd05.prod.outlook.com (2603:10a6:800:141::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Thu, 25 Jun
 2020 19:07:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 19:07:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next V3 0/9] mlx5 updates 2020-06-23
Thread-Topic: [pull request][net-next V3 0/9] mlx5 updates 2020-06-23
Thread-Index: AQHWSeKIMlZSQxUp9kWuIDvnAEOPYajox9qAgADsFgA=
Date:   Thu, 25 Jun 2020 19:07:24 +0000
Message-ID: <75f8c32ec5c00001968f213c57d5c0440552a9a7.camel@mellanox.com>
References: <20200624044615.64553-1-saeedm@mellanox.com>
         <20200624.220223.817974985870667481.davem@davemloft.net>
In-Reply-To: <20200624.220223.817974985870667481.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 37faad99-1f5f-40a7-dda0-08d8193afe7e
x-ms-traffictypediagnostic: VI1PR05MB6765:
x-microsoft-antispam-prvs: <VI1PR05MB6765FA8C032988536F50413BBE920@VI1PR05MB6765.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FAe4r2nFHtPu5f396L0IMFD7Qzv+imz45q6OuFl/0BOTZiLq5royltD95XVQR8LfGczWggm9J8h8IkpNu0zz7X4Hae4Xa85JMPqIaqD98wmiX6t4diuu1SFJVIreZTgtUNcHuYujMMsJpAqjcWlkTiE1Lu68w7Dz8VVAW+bCXKue7fhTAwXXxymiAb20QBLlAeRYgI8PmgcvUZRXCVK7RM9nl+lucxgO1MfB9kja5pwWOtkhlpIZz9FxwHoR9++CSJaezywkFt4NM09PId7O9wFN+eGke9sV99VQ2jekRweD2QMKyPbusAZrAVq35CXzMM9FIhUBCVB8uU6SYQTcyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(6506007)(478600001)(15650500001)(316002)(66556008)(6916009)(66476007)(66446008)(64756008)(76116006)(8676002)(2616005)(54906003)(6486002)(66946007)(91956017)(86362001)(5660300002)(6512007)(26005)(2906002)(36756003)(4326008)(186003)(8936002)(4744005)(71200400001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 98S9fXylcohWwZJI/yrn8/XacuNIdVoKzBm2+wyUPe5Q7tg1MIS7YY9v4edP2QxIP2lOm7riEJLKTDn54j3fLUzhqMuJIOGLW9benprSeihaDv0Kb/DlNpeXfqUr9Jupk+X/oeT8P6R+ybeF9B/J/O/lq3z992qqS5X/BQH6JhpojV630nKFtPT4JtMeXv9bU6DF1EL0MZayxJhPqMGYfB+B2QhmPygSynL3+azgsMQOU5I+cMR85FuoSMcfB5B3ZIw0KhaCfKu5GZgkIKFsHE2y2uddXsuHaM4sX2y9mpaegEGBFiOuvC7Ec4KIOcLQtCZdYkXiCW2O2wCkUqvy3soxrELTrKZ1BE69tV1ibiXGRC1zrZ/dgFNjHgRBe7ndw3KMN1jWq2MZP6zFzMrEY3AqyQOYrcNjfK0/4hiv08TcxoSg9iejZsDWEb4iW0R0/mfPjALIN7AfvU4M3r9L/uDLYNPewnduQBV9bHguFsY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <02825E65FD987344B46CFF16A65A31CC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37faad99-1f5f-40a7-dda0-08d8193afe7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 19:07:24.0650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KS5/Vud1mXdd3F4Irso4D+XEkX+kei7xy4efCU2KNcO1JuzsXvgCc3qBo9GIw7i9Ymr3XAL6gRFwYMwl+VZYvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6765
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA2LTI0IGF0IDIyOjAyIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiBEYXRlOiBUdWUs
IDIzIEp1biAyMDIwIDIxOjQ2OjA2IC0wNzAwDQo+IA0KPiA+IEhpIERhdmUsIEpha3ViDQo+ID4g
DQo+ID4gVGhpcyBzZXJpZXMgYWRkcyBtaXNjIHVwZGF0ZXMgYW5kIG9uZSBzbWFsbCBmZWF0dXJl
LCBSZWxheGVkDQo+IG9yZGVyaW5nLCANCj4gPiB0byBtbHg1IGRyaXZlci4NCj4gPiANCj4gPiB2
MS0+djI6DQo+ID4gIC0gUmVtb3ZlZCB1bm5lY2Vzc2FyeSBGaXhlcyBUYWdzIA0KPiA+IA0KPiA+
IHYyLT52MzoNCj4gPiAgLSBEcm9wICJtYWNybyB1bmRlZmluZSIgcGF0Y2gsIGl0IGhhcyBubyB2
YWx1ZQ0KPiA+IA0KPiA+IEZvciBtb3JlIGluZm9ybWF0aW9uIHBsZWFzZSBzZWUgdGFnIGxvZyBi
ZWxvdy4NCj4gPiANCj4gPiBQbGVhc2UgcHVsbCBhbmQgbGV0IG1lIGtub3cgaWYgdGhlcmUgaXMg
YW55IHByb2JsZW0uDQo+IA0KPiBTYWVlZCwgcGxlYXNlIHRvc3MgcGF0Y2ggIzkgYW5kIHJlc2Vu
ZCB0aGlzLCBpdCBzdGlsbCBuZWVkDQo+IGRpc2N1c3Npb24uDQo+IA0KPiBJIHBlcnNvbmFsbHkg
ZG9uJ3QgbGlrZSB1c2luZyBldGh0b29sIGZvciB0aGlzIGV2ZW4gZm9yIGRpYWdub3N0aWMNCj4g
cHVycG9zZXMuICBTdWNoIGNvbnRyb2xzIGJlbG9uZyBpbiB0aGUgUENJIGxheWVyIGFuZCBhc3Nv
Y2lhdGVkIHN5c2ZzDQo+IGZpbGUgb3Igc2ltaWxhci4NCj4gDQoNCkFjay4NCg==

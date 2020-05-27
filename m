Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0981E37CB
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 07:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgE0FPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 01:15:55 -0400
Received: from mail-vi1eur05on2041.outbound.protection.outlook.com ([40.107.21.41]:6087
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbgE0FPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 01:15:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/fb8dufY6BEnbxrMT7vJCqx8fiy9BKyY1IDKTL/LGvjWp1S4iXNuMU0AAO+VA5ua2ilH+7LW8Xdj9sBx2IX5S2C+fBmkqpFoqZUtNu6mbLnCgposURHnkCu0H8dYYKEUnIsJiiQBGupWOGOy4R3tufEvLJ4rWnoGwgaXw1f4/XGykZUpLDbO72zUk1P51qVZrHn2haQp8dFOLhlWvhH8DPL7w1Sf/C5bN6FHFB52jzladJeqLQPQZrTcL0/7ZN/StWqdyOMxG4psetA6NTo/8OE6d80VNkFraDLGMb5ytZ+BCWye8JCw8NKdRU0LRzvDouB/4Oa7KqdeaZCm/kDlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYdbigaG44GjFDVjO6t+c4SS4osdgojTPoY99Ex5YfM=;
 b=c/Xn2hIKAha+WPlyo0tsnXSVlpmTnQgOt2terBheyDdUvm8wshJxKM3y7HhZY3+5SBKA5lBGqyny2N5NIm6On8oXfYK0+19/YvVufDPm5BzzLm8EvMbJqWWPROZK598VUTK0rjbAnq0ZOi/KIUKxsfjSHyPYsagaiRMKLIQAg0WxOy+0yEw6YFBKuhCKXg19AzCuSz+bh/nSZAW2dq0FnKIWQK1D0QFNXGq2pRhSq5kLPZLo457BakUxkkmuXgoAb+CY6XfrIQpxgBjZkrj2AOXEPXICWwOMaxofagRo02MvJWnVJd/NmoXxdYsxk+avtiCwrP+lMPBGuaBdagTkZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYdbigaG44GjFDVjO6t+c4SS4osdgojTPoY99Ex5YfM=;
 b=O4Y3uONJvYIdrL5Na82hclezKdPE44WND5unSYUJtusFhn8OiNIRNIffUvbQ0YMZqVw6tkUacBEQrJkqdAdz9m5Te/afjPIO5DjczUQk7Ueh6dIwgrrBy8JepQ00VD+pP1HQYTNwP3/SNVQLDVjUfgK0rvuqM9OE7JCDDIWpHSI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5373.eurprd05.prod.outlook.com (2603:10a6:803:b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 05:15:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 05:15:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Eli Cohen <eli@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 07/10] net/mlx5e: Add support for hw encapsulation of
 MPLS over UDP
Thread-Topic: [net-next 07/10] net/mlx5e: Add support for hw encapsulation of
 MPLS over UDP
Thread-Index: AQHWMJQLnWxRjw6M+kqbwsJLi1fpAKi6w/QAgAACKoCAAKR9AA==
Date:   Wed, 27 May 2020 05:15:51 +0000
Message-ID: <48d764427014f1450e6104746945dd67c5edb64b.camel@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
         <20200522235148.28987-8-saeedm@mellanox.com>
         <20200526121920.7f5836e6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <97ec57bc-c46d-f9ca-037a-a9e07ad0fc08@gmail.com>
In-Reply-To: <97ec57bc-c46d-f9ca-037a-a9e07ad0fc08@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f855e4ff-48d8-4f31-40cf-08d801fd0624
x-ms-traffictypediagnostic: VI1PR05MB5373:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5373A970402F6487E824D29ABEB10@VI1PR05MB5373.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UL3Pne/iHGviuFnWF5sT0H+ZNb4BfZmewEXxFX3VPrg3W4Aw82WjGhUfeQCxrgVx+nQbxR1ul0kRwMkAfjKzGsCVamVYFReRjAsmkDiczyd4L2WWvcrL4lKItnaBP6RAJZsOdSW6+F1KYwMKKJL6HXCjyK3fW5E5U2A46XnCOiq4LcIFss+ozXnDCIVufAEjAh/m2GhchwtID0sEgEVB4GAur0mCpMTivDKr7yiz2bcLjdUc9DkEbFAsiCewLVautwHxIToFh4qfsYwmFg9Rve1ntAeCMVEM7RKyv7htd0tJqd5gPugsBCqzJsWvczqqiIR+49x8MxmcbbGv+YdaVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(71200400001)(6486002)(91956017)(6512007)(5660300002)(36756003)(66446008)(64756008)(66556008)(66476007)(186003)(6506007)(66946007)(26005)(110136005)(316002)(53546011)(76116006)(8936002)(4326008)(8676002)(478600001)(86362001)(54906003)(2906002)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: IHAUEBwwLfa3czKj/7XEL3l84Cy8zxKpIYXM3WzDkleXXmB++3oQEYPGYgXIiE6+350ivwyOXlR0sG0P8dc5lLqbCPqeMx5arHOiccrqfgH6eVeE68uLU+j87SHvOusrTmOcAqJFREmXPc7aWP5SN5Ii8P+7TNuqd7f7HbO6fZPym2o0GCEPfHBcyEbVZDcsSH4Amc86pjaDXi7a5hlq2Jnuudw4tr5KEPk8foaSNOVbGOO3J6VWc7nC3hR1EvoXK+QjhYy1mjyI+/uWBll7Vq1O58RDXcry7gF7bRnT6x0+rVYALKpRTZY9DxifvFPjCgMROeuMevkNjjwofFehqsffzPYZ+7RMLDSwnhLipLzgkX6MpACBuqd+1B80F7eCyAitHcjA8h3SAu9dSUp3vrzt7mDJ76QUxMKTropIiks+tropaJWMx6+8r+GVhXeIeCRSWGhTZWutdKnRxcLx8Wc1S8vYkATwaxmkU30oWQ8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <854FD3429A06094885D1CAC3F0B55BE9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f855e4ff-48d8-4f31-40cf-08d801fd0624
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 05:15:51.3058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c4Q/q5Umxkjlc5wR73zhVlg1HFs9VSdtPwMWXref6dQYT8NlbycvBcr0LjL+18QDemY22wAkXKlcKgSh2GT3Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5373
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA1LTI2IGF0IDEzOjI3IC0wNjAwLCBEYXZpZCBBaGVybiB3cm90ZToNCj4g
T24gNS8yNi8yMCAxOjE5IFBNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gPiBPbiBGcmksIDIy
IE1heSAyMDIwIDE2OjUxOjQ1IC0wNzAwIFNhZWVkIE1haGFtZWVkIHdyb3RlOg0KPiA+ID4gK3N0
YXRpYyBpbmxpbmUgX19iZTMyIG1wbHNfbGFiZWxfaWRfZmllbGQoX19iZTMyIGxhYmVsLCB1OCB0
b3MsDQo+ID4gPiB1OCB0dGwpDQo+ID4gPiArew0KPiA+ID4gKwl1MzIgcmVzOw0KPiA+ID4gKw0K
PiA+ID4gKwkvKiBtcGxzIGxhYmVsIGlzIDMyIGJpdHMgbG9uZyBhbmQgY29uc3RydWN0aW9uIGFz
IGZvbGxvd3M6DQo+ID4gPiArCSAqIDIwIGJpdHMgbGFiZWwNCj4gPiA+ICsJICogMyBiaXRzIHRv
cw0KPiA+ID4gKwkgKiAxIGJpdCBib3R0b20gb2Ygc3RhY2suIFNpbmNlIHdlIHN1cHBvcnQgb25s
eSBvbmUgbGFiZWwsIHRoaXMNCj4gPiA+IGJpdCBpcw0KPiA+ID4gKwkgKiAgICAgICBhbHdheXMg
c2V0Lg0KPiA+ID4gKwkgKiA4IGJpdHMgVFRMDQo+ID4gPiArCSAqLw0KPiA+ID4gKwlyZXMgPSBi
ZTMyX3RvX2NwdShsYWJlbCkgPDwgMTIgfCAxIDw8IDggfCAodG9zICYgNykgPDwgIDkgfA0KPiA+
ID4gdHRsOw0KPiA+ID4gKwlyZXR1cm4gY3B1X3RvX2JlMzIocmVzKTsNCj4gPiA+ICt9DQo+ID4g
DQo+ID4gTm8gc3RhdGljIGlubGluZXMgaW4gQyBzb3VyY2UsIHBsZWFzZS4gQmVzaWRlcyB0aGlz
IGJlbG9uZ3MgaW4gdGhlDQo+ID4gbXBscw0KPiA+IGhlYWRlciwgaXQncyBhIGdlbmVyaWMgaGVs
cGVyLg0KPiA+IA0KPiANCj4gbmV0L21wbHMvaW50ZXJuYWwuaDoNCj4gDQo+IHN0YXRpYyBpbmxp
bmUgc3RydWN0IG1wbHNfc2hpbV9oZHIgbXBsc19lbnRyeV9lbmNvZGUodTMyIGxhYmVsLA0KPiB1
bnNpZ25lZA0KPiB0dGwsIHVuc2lnbmVkIHRjLCBib29sIGJvcykNCj4gew0KPiAgICAgICAgIHN0
cnVjdCBtcGxzX3NoaW1faGRyIHJlc3VsdDsNCj4gICAgICAgICByZXN1bHQubGFiZWxfc3RhY2tf
ZW50cnkgPQ0KPiAgICAgICAgICAgICAgICAgY3B1X3RvX2JlMzIoKGxhYmVsIDw8IE1QTFNfTFNf
TEFCRUxfU0hJRlQpIHwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICh0YyA8PCBNUExT
X0xTX1RDX1NISUZUKSB8DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAoYm9zID8gKDEg
PDwgTVBMU19MU19TX1NISUZUKSA6IDApIHwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICh0dGwgPDwgTVBMU19MU19UVExfU0hJRlQpKTsNCj4gICAgICAgICByZXR1cm4gcmVzdWx0Ow0K
PiB9DQo+IA0KPiBwZXJoYXBzIHRoYXQgY2FuIGJlIG1vdmVkIHRvIGluY2x1ZGUvbmV0L21wbHMu
aA0KDQpBZ3JlZWQsIEVsaSBpcyBwcmVwYXJpbmcgYSBwYXRjaCBhcyB3ZSBzcGVhay4NCg0KVGhh
bmtzLA0KU2FlZWQuDQo=

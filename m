Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEA71E04B3
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 04:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388463AbgEYC3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 22:29:33 -0400
Received: from mail-eopbgr40059.outbound.protection.outlook.com ([40.107.4.59]:12150
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388110AbgEYC3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 22:29:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OhPu9WzYBrkUfrTigpxuFVPd+Muq6nY3RJnonUVhwpHOkrXr62j+1N7hIYKiV+ybNPnSR33l8YHg3TpUhuWioSo/90atexIEtxtQ+op+tkjI2Bt4zkKdheE+1b9u9vB67K4Ds2WcE1IA5qgPVGja93URL0i/5fE6RySEJxR8pyhukMskfnz9R0mvI1E/oOtbImptqYH7mJWy6/2++kLtTJmZp9wgBukC+p+07YNvXdyEBfIahp25QKSHf7NqhjIuYyx5Xs/GYa+TbuehUyGDKXx5Fe3sLnZKQIBC5TZK/IKAKj0KuubUtAxI4uOV7l15fxUVPMuYDBN4+K8iXpVkRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pG5mvXN6RtTEIGhjtRJgEJh2qFck+3FgiKg6L1SDJjI=;
 b=A6r4Ujd3pQ+JW11h0qtWhxZuetb4edPOPgcA2KH+GathhE6PN97BWgRD/rhNGkDL/HZ1QXxQ/hS22QXaSa7jP2Uc3ksz48eTinexvg8rRr0bxQzgTXFSu4RicWRo5RjQzO/dcgq98/MeGWMjS0JqLimg1kBEKrsrGkZHDQwUnawU+A0vyzNsPAdNA6/YBwufbooYzH6FR7Vc0fYom7wykwjFyzQniXaUb9JlsmfXKXmPzFDfg5yQ7PgCUw+1XlhmraFvjSWuLg8ofBC3YrxCQL3yz/x7kHs7E4oFqrO4eHodSrO2MNolXJjcZVQ4obcceF+VxS5Dt195ceThbpHYdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pG5mvXN6RtTEIGhjtRJgEJh2qFck+3FgiKg6L1SDJjI=;
 b=rhhshXd4VrI+//ZpL++QqavxBXFhRlqe3lmiZJhA4Kuqi5dDEdEcLLst8orOCofzvsBd72Yyb5Y4GzgKMpHNjmanb5qZKp7ejT88XJlw67V3JEPAbLxqZx8nQd0MMce6YgEwJQtKa0inGPJUGsUxqTJUR/XJHJCUo0RRJsO63hA=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3720.eurprd04.prod.outlook.com
 (2603:10a6:209:1a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 02:29:28 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 02:29:28 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net 3/4] ARM: dts: imx6: update fec gpr property
 to match new format
Thread-Topic: [EXT] Re: [PATCH net 3/4] ARM: dts: imx6: update fec gpr
 property to match new format
Thread-Index: AQHWLoHSZsTKfn2KY0W5vmilgDZ/AqixNB4AgACoEqCAAKg5AIAAxaRggAEfV4CAA7BLwA==
Date:   Mon, 25 May 2020 02:29:28 +0000
Message-ID: <AM6PR0402MB3607365FD8D754B5EDDD5242FFB30@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
 <1589963516-26703-4-git-send-email-fugang.duan@nxp.com>
 <20200520170322.GJ652285@lunn.ch>
 <AM6PR0402MB3607541D33B1C61476022D0AFFB70@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <20200521130700.GC657910@lunn.ch>
 <AM6PR0402MB360728F404F966B9EF404697FFB40@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <CANh8QzwxfnQ1cACz=6dhYujEVtQoTCw8kTgkHi9BnxESptL=xQ@mail.gmail.com>
In-Reply-To: <CANh8QzwxfnQ1cACz=6dhYujEVtQoTCw8kTgkHi9BnxESptL=xQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: flowbird.group; dkim=none (message not signed)
 header.d=none;flowbird.group; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 458eed39-49a6-45e8-cf74-08d8005372d0
x-ms-traffictypediagnostic: AM6PR0402MB3720:
x-microsoft-antispam-prvs: <AM6PR0402MB37204BF9B78EE6E512140C60FFB30@AM6PR0402MB3720.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: onhmVz81rso0JnAhU5hOqoO70gdHSGBMfbpVNttdqoinwdpWWCFnh2+mODo+lfgFfsQEwZb4sprX5xnEhJdBwRh1Ivfe8YTqFWakti4gtr9sBAA3+qHaKX27G89s+4mIYpDco1FgPG+PpU96v49vrLdKOYRfz/Mj94+sWD2+TCEWzdJFovtP5uAi2rc8TTF/6JNQWu/yB5rZ0HxAzk1Ucp0MX2vPq6YlACVJAeQ9XNQ8b6lkZcTjzlCbTrWoT/uLllNLLNV/xMRHPvxLDmBF5jLXv65f1CgkFp1hKRLtd8Xl3uzaKhKZ7ww8IIBh00i+Nk9BwXyEVidBim7pVhujlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(2906002)(66446008)(26005)(64756008)(9686003)(66556008)(66476007)(6506007)(76116006)(66946007)(52536014)(7696005)(4326008)(478600001)(316002)(186003)(54906003)(71200400001)(55016002)(86362001)(8936002)(33656002)(8676002)(5660300002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: uCNydKIeEkoHZ225oD8PSpWggDS7tm4i2d0eDpAW1fgyG9JuZgNaJmgzUnOWO4kTjcmIVJnPdDgbACzWAFQpjd4cYVND7g9jon3SnIvH0tJERfBhPVUhYBLf1Q1c50tjfMUkdJER53ycS0sDzsN5egVyHMt9e2V1o3zGJ3LKEwO35gYkH/8LZcLB4ayIWmaH8HP0lhWMInVvjrYcaVlmkrmVvmndqHesa+u2ymJW6vpJsazJYxSlB1EIDItYkDzOXPRVgsaOpqjFhVek3EuoZgNllm2xuS7IddVKn7TMy6s0px7ugas6TPNzPuSmF7NEka3LYb4m0J2jy5XSVzGuBvvISVpMeDVuJs/mWzeGkZsd6GWqRSYqflUscVbBegJNJlt5RpPVnPrnjjNGKtcqag2PtyQID5qjZSripN6e/L6nR6gXOT0gKsvoYvPvWQsw4ELH6ILFjaftHY96X3A6YoSfNdcJP28thd0eYW2jOAA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 458eed39-49a6-45e8-cf74-08d8005372d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 02:29:28.1128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YX2KtA0oV+AOXrBOrJIFxnE43vt/xmsTjx+Uj5B1Wg6z8RQVL+VMqThdOZW8ZZaWhvcbwWM1/PmFBWHMO/UATw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRnV6emV5LCBNYXJ0aW4gPG1hcnRpbi5mdXp6ZXlAZmxvd2JpcmQuZ3JvdXA+IFNlbnQ6
IFNhdHVyZGF5LCBNYXkgMjMsIDIwMjAgMjowMyBBTQ0KPiBIaSBBbmR5LA0KPiANCj4gT24gRnJp
LCAyMiBNYXkgMjAyMCwgMDM6MDEgQW5keSBEdWFuLCA8ZnVnYW5nLmR1YW5AbnhwLmNvbT4gd3Jv
dGU6DQo+ID4NCj4gPiBBbmRyZXcsIG1hbnkgY3VzdG9tZXJzIHJlcXVpcmUgdGhlIHdvbCBmZWF0
dXJlLCBOWFAgTlBJIHJlbGVhc2UgYWx3YXlzDQo+ID4gc3VwcG9ydCB0aGUgd29sIGZlYXR1cmUg
dG8gbWF0Y2ggY3VzdG9tZXJzIHJlcXVpcmVtZW50Lg0KPiA+DQo+ID4gQW5kIHNvbWUgY3VzdG9t
ZXJzJyBib2FyZCBvbmx5IGRlc2lnbiBvbmUgZXRoZXJuZXQgaW5zdGFuY2UgYmFzZWQgb24NCj4g
PiBpbXg2c3gvaW14N2QvDQo+ID4gSW14OCBzZXJpYWwsIGJ1dCB3aGljaCBpbnN0YW5jZSB3ZSBu
ZXZlciBrbm93LCBtYXliZSBlbmV0MSwgbWF5YmUNCj4gPiBlbmV0Mi4gU28gd2Ugc2hvdWxkIHN1
cHBseSBkaWZmZXJlbnQgdmFsdWVzIGZvciBncHIuDQo+ID4NCj4gPiBTbywgaXQgaXMgdmVyeSBu
ZWNlc3NhcnkgdG8gc3VwcG9ydCB3b2wgZmVhdHVyZSBmb3IgbXVsdGlwbGUgaW5zdGFuY2VzLg0K
PiA+DQo+IA0KPiBZZXMsIEkgZG9uJ3QgdGhpbmsgYW55b25lIGlzIHNheWluZyBvdGhlcndpc2Uu
DQo+IA0KPiBUaGUgcHJvYmxlbSBpcyBqdXN0IHRoYXQgdGhlcmUgYXJlIGFscmVhZHkgLmR0c2kg
ZmlsZXMgZm9yIGkuTVggY2hpcHMgaGF2aW5nDQo+IG11bHRpcGxlIGV0aGVybmV0IGludGVyZmFj
ZXMgaW4gdGhlIG1haW5saW5lIGtlcm5lbCAoYXQgbGVhc3QgaW14NnVpLmR0c2ksDQo+IGlteDZz
eC5kdHMsIGlteDdkLmR0c2kpIGJ1dCB0aGF0IHRoaXMgcGF0Y2ggc2VyaWVzIGRvZXMgbm90IG1v
ZGlmeSB0aG9zZSBmaWxlcw0KPiB0byB1c2UgdGhlIG5ldyBEVCBmb3JtYXQuDQo+IA0KRm9yIGlt
eDZ1bC9pbXg2c3gvaW14N2QvaW14OG1xL2lteDhtbS9pbXg4bW4gY2hpcHMgdG8gc3VwcG9ydCB3
b2wsIA0KSSBwbGFuIHRvIHN1Ym1pdCBhbm90aGVyIGR0cyBwYXRjaCBhZnRlciB0aGUgcGF0Y2gg
c2V0IGlzIGFjY2VwdGVkLg0KDQpJZiB5b3UgdGhpbmsgYWRkIHRoZSBkdHMgcGF0Y2ggYXBwZW5k
aW5nIHRvIHRoZSBwYXRjaCBzZXQsIEkgd2lsbCBhZGQgaXQgaW4gdjIuDQoNCj4gSXQgY3VycmVu
dGx5IG9ubHkgbW9kaWZpZXMgdGhlIGR0cyBmaWxlcyB0aGF0IGFyZSBhbHJlYWR5IHN1cHBvcnRl
ZCBieQ0KPiBoYXJkY29kZWQgdmFsdWVzIGluIHRoZSBkcml2ZXIuDQo+IA0KPiBBcyB0byBub3Qg
a25vd2luZyB3aGljaCBpbnN0YW5jZSBpdCBzaG91bGRuJ3QgbWF0dGVyLg0KPiBUaGUgYmFzZSBk
dHNpIGNhbiBkZWNsYXJlIGJvdGgvYWxsIGV0aGVybmV0IGludGVyZmFjZXMgd2l0aCB0aGUgYXBw
cm9wcmlhdGUNCj4gR1BSIGJpdHMuDQo+IEJvdGggc2V0IHRvIHN0YXR1cyA9ICJkaXNhYmxlZCIu
DQo+IA0KPiBUaGVuIHRoZSBib2FyZCBzcGVjaWZpYyBkdHMgZmlsZSBzZXRzIHN0YXR1cz0ib2th
eSIgYW5kIGFjdGl2YXRlcyB3b2wgYnkgYWRkaW5nDQo+ICINCj4gImZzbCxtYWdpYy1wYWNrZXQi
IGlmIHRoZSBoYXJkYXdhcmUgc3VwcG9ydHMgaXQgKGJlY2F1c2UgdGhhdCBkZXBlbmRzIG9uDQo+
IHRoaW5ncyBiZXlvbmQgdGhlIFNvQywgbGlrZSBob3cgdGhlIGV0aGVybmV0IFBIWSBpcyBjbG9j
a2VkIGFuZCBwb3dlcmVkLikNCj4gDQo+IE1hcnRpbg0K

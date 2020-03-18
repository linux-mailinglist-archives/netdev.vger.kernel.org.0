Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2EAE189749
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgCRIeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:34:21 -0400
Received: from mail-eopbgr130085.outbound.protection.outlook.com ([40.107.13.85]:27511
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726550AbgCRIeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 04:34:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpO0vmbQbqqJkKcL1tiOwdwxLy0JKLdcstZyW1tkQ+o7Ad519B4XvIygCCDNJqrthyF+FSJEUyjpeb0WiweBKmq7l+2e1GlTHHvY0AePo90WxsWydY/4Auni/UpG6ki0SDxZcbGsHToMW6sy5auVwKynuSBdISt/2vY7HkYidnJhpQIEibj34THe98iLkZv18E6QAkep4jo3daIS9+G3f8Do0W6xkH4MqP/wXiINp9IVR+O8sAKBZ3F0RGRce8yeQU6k/8AmUvP2AzyMslQ3xSP/jSNSc6Z0VqfOPDNNSoMoQKaeilp80wLxDGYW3t1ozNu5/Dvpcj8AbrLQczYnsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lrNo5icQrKFtI2XP+USq4GbjnDycHlt7Eke26fd0ec=;
 b=gG35v0iYRXjZ40VTMwegTzWHnVkdrc+LWG4FO+3dUo0Er7lWF+XaDBCmq679Od0tBOQXRHbZOo3nYqprOn+RmKBgG4LBHnE2dHLexhZqnqdba09/zEztMTo5jl1y2S+UX2YSeIwfpWOVLwvrL455joy7cQ9XBttDhwiD1KToLreNHj2qZ2PKnz0drKF4pcUIwNwHujK58QxwBQMqmneVrrz6CXCIwOtlsfb3VevCfh/D7GmnukB6e6wqibs9hPOIDOyoKv50tTyGi1fl9Er9ZRyO6r6J/ORPwJ4z4yiNs4uO7VHb0LnQMCCTPFyLz1cQjn0iNEOtwX3yREDrftfdSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lrNo5icQrKFtI2XP+USq4GbjnDycHlt7Eke26fd0ec=;
 b=YL0EzBUPfyyiRR+9PmF+1o4+0/nW+Z6EjmPvyMJXhwIdU171mtj+urQ/mv5qLh3CYRHJ2u47Q2OZeQTXUPak1S+YREgIhFkqmMQk/Rfmhm4A3baToE5XRHSp0yiQaZkWdwhigG1LtRXoAZiv3F4IO35kouxHjxwU5AYkrb2wTXs=
Received: from AM0PR0402MB3587.eurprd04.prod.outlook.com (52.133.51.20) by
 AM0PR0402MB3779.eurprd04.prod.outlook.com (52.133.39.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.23; Wed, 18 Mar 2020 08:34:03 +0000
Received: from AM0PR0402MB3587.eurprd04.prod.outlook.com
 ([fe80::d9d3:bd30:8d1:3dc0]) by AM0PR0402MB3587.eurprd04.prod.outlook.com
 ([fe80::d9d3:bd30:8d1:3dc0%3]) with mapi id 15.20.2835.017; Wed, 18 Mar 2020
 08:34:03 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
CC:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [EXT] [PATCH 0/4] Fix Wake on lan with FEC on i.MX6
Thread-Topic: [EXT] [PATCH 0/4] Fix Wake on lan with FEC on i.MX6
Thread-Index: AQHV/HwfH3wTHDqsi0KQfAvD/Tjc/6hN41QggAAh8ICAAADusA==
Date:   Wed, 18 Mar 2020 08:34:03 +0000
Message-ID: <AM0PR0402MB3587ABEF56CD2C11EC805CBEFFF70@AM0PR0402MB3587.eurprd04.prod.outlook.com>
References: <1584463806-15788-1-git-send-email-martin.fuzzey@flowbird.group>
 <VI1PR0402MB3600DC7BB937553785165C2AFFF70@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CANh8QzwPmbfr1y9Yz7ctbannX3gOWZBQG1_xDM6xit=3ZXD+pg@mail.gmail.com>
In-Reply-To: <CANh8QzwPmbfr1y9Yz7ctbannX3gOWZBQG1_xDM6xit=3ZXD+pg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a7e26322-a662-4404-09b7-08d7cb171d62
x-ms-traffictypediagnostic: AM0PR0402MB3779:|AM0PR0402MB3779:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0402MB37796C4DF2CC02B5018BFB48FFF70@AM0PR0402MB3779.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(199004)(33656002)(8936002)(81156014)(81166006)(8676002)(6916009)(316002)(54906003)(186003)(66446008)(478600001)(66556008)(64756008)(66476007)(66946007)(71200400001)(26005)(7696005)(55016002)(9686003)(4326008)(6506007)(5660300002)(52536014)(76116006)(86362001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0402MB3779;H:AM0PR0402MB3587.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6/GWtr/zYNt1Onw0veWdzeWapLCmu+TwvUFXGYx9SU8NvoBi8aveQ2etsaEuxdJjez6drszFXRZAS+NC7o7VMlyfWxJopV+jpus/IgiItIhA5SwloGTRrb+Zk57LhVadtz30M8dCVlPKlqN/b5A8fSs0UkW8HzCFIk3Xal9zFmwJoaO826AhEStnV0ZRIkK2l+mhEPNHIb8f3zTHTOchwyGKl89BaePDiV9lV2tzBVicn6fYvD35v08Cfgnl6pEmyy8j/kl60Th6feNhB1gy0Yosl5i7faYzfEbRClmlAFJ+WAt1mWO2AjNz0FaE2AvxtXO43Ry0A7RopoO5jL7iKzuULNsA3QUkb/Qf3vrT0pIK404sahdNParrKQFwxVmMtk6r0rdVp36y1SKuRFjMbZ7LpcJdUBwL6R/52W2DgbxinykbkZZ7JrQmHy5LO3LF
x-ms-exchange-antispam-messagedata: DNmiIOhyKGzyBYpLY8TH9s1rICTPkbHa+KLZ0UlPaO2tifDbyOEiGqyXaYfQMAymw8Fz6GBJwM5BarYC4xpYftQJyxH2aAw1hv/VnEns+KZEShZrgvQJ0ZEDATefsg4uBsUtsabNNdgad7ttRIVSpg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7e26322-a662-4404-09b7-08d7cb171d62
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 08:34:03.2525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TQbDRko1TyyVGQtMt0wdptREbH0NgBKD6++ovhLXtVvhLB7mZg381XLdoW5JiiystBEdjhnkzUlK7/6D5GVwjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3779
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRnV6emV5LCBNYXJ0aW4gPG1hcnRpbi5mdXp6ZXlAZmxvd2JpcmQuZ3JvdXA+IFNlbnQ6
IFdlZG5lc2RheSwgTWFyY2ggMTgsIDIwMjAgNDoyOCBQTQ0KPiBIaSBBbmR5LA0KPiANCj4gDQo+
IE9uIFdlZCwgMTggTWFyIDIwMjAgYXQgMDc6MjgsIEFuZHkgRHVhbiA8ZnVnYW5nLmR1YW5Abnhw
LmNvbT4gd3JvdGU6DQo+ID4NCj4gPg0KPiA+IFRoZSBtb3N0IG9mIGNvZGUgaXMgcmV1c2VkIGZy
b20gbnhwIGludGVybmFsIHRyZWUsIElmIHlvdSByZWZlciB0aGUNCj4gPiBwYXRjaGVzIGZyb20g
bnhwIGtlcm5lbCB0cmVlLCBwbGVhc2Uga2VlcCB0aGUgc2lnbmVkLW9mZiB3aXRoIG9yaWdpbmFs
DQo+ID4gYXV0aG9yLg0KPiA+DQoNCkl0IGRvZXNuJ3QgbWF0dGVyLCBJIGFtIGhhcHB5IHlvdSB1
cHN0cmVhbSB0aGUgcGF0Y2guDQpKdXN0IGtlZXA6IFNpZ25lZC1vZmYtYnk6IEZ1Z2FuZyBEdWFu
IDxmdWdhbmcuZHVhbkBueHAuY29tPg0KPiANCj4gT2ssIGxvb2tzIGxpa2UgaXQgd2FzIG9yaWdp
bmFsbHkgZnJvbSB5b3UsIHNob3VsZCBJIGFkZCB5b3VyIGN1cnJlbnQgZW1haWwNCj4gYWRkcmVz
cyBvciB0aGUgb25lIGF0IHRoZSB0aW1lIChCMzg2MTFAZnJlZXNjYWxlLmNvbSk/DQo+IA0KPiBB
Y3R1YWxseSBJIGRvbid0IGhhdmUgdGhlIE5YUCB0cmVlIGJ1dCBhIERpZ2kgdHJlZSwgd2hpY2gg
aXMgcHJvYmFibHkgYmFzZWQgb24NCj4gaXQuDQo+IA0KPiBJIHRoaW5rLCBnZW5lcmFsbHksIHRo
aXMgaXMgYSBiaXQgb2YgYSBncmV5IGFyZWEuDQo+IA0KPiBXaGlsZSBJIHdvdWxkIGFsd2F5cyBr
ZWVwIGEgU29CIGlmIEkgYmFzZSBhIHBhdGNoIG9uIGFuIG9sZCBtYWlsaW5nIGxpc3QgcGF0Y2gN
Cj4gc3VibWlzc2lvbiAoYW5kIGNvbnRhY3QgdGhlIHBlcnNvbiBpZiBwb3NzaWJsZSBmaXJzdCB0
bw0KPiBhc2spIEknbSBub3Qgc3VyZSBpZiBhIFNvQiBmcm9tIGEgInJhbmRvbSBnaXQgdHJlZSIg
aW5kaWNhdGVzIHRoZXkgd2lzaCBhDQo+IG1haW5saW5lIHN1Ym1pc3Npb24gd2l0aCB0aGVpciBu
YW1lIChzb21lIHBlb3BsZSBtYXkgd2FudCBjcmVkaXQgYW5kDQo+IG90aGVycyBub3Qgd2FudCB0
byBiZSBjb25zaWRlcmVkIHJlc3BvbnNpYmxlIGZvciBidWdzLi4uKS4NCj4gSSBkaWRuJ3Qgc2Vl
IGEgc3VibWlzc2lvbiBvZiB0aGlzIHZlcnNpb24gKHdpdGggdGhlIGdwciBpbmZvcm1hdGlvbiBj
b21pbmcgZnJvbQ0KPiB0aGUgRFQpIG9uIHRoZSBtYWlsaW5nIGxpc3RzLCBvbmx5IHRoZSBpbml0
aWFsIHZlcnNpb24gdXNpbmcgdGhlIHBsYXRmb3JtIGNhbGxiYWNrDQo+IHRoYXQgd2FzIE5BS2Qg
KEkgbWF5IGhhdmUgbWlzc2VkIGl0IHRob3VnaCkuDQo+IA0KPiBSZWdhcmRzLA0KPiANCj4gTWFy
dGluDQo=

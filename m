Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3DB78FB8
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388201AbfG2PqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:46:23 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:41536
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387476AbfG2PqW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 11:46:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFOM5b3PuZIze1j0hfEp75t/O1lR0cw8tqjNW6JPH6xKoCHTY1BL0X9U2wYTftyFAeJaNvNtMnmvBaWEv9kY9und1LJPTSPxAScCslI70L/8jF1yp+GlazoavJ8RPq4yYRnpFaPtm9pGTelm101mGbM4mK9QGwZqEq3An0NzkGdn8kzLZa13tapdRr6wGGP3v5ZQ8bJVujh5+Lm+qE0vRLWjWVEIC31++16a/5WMVR/XgUEqrqVa48e3e9ilF8bXJ3B7SSFOk8Ol2z/XjwU3EPE4Mu/vBJdHpyj8W3j6iYYGMDA72S1CGJ3/EHkLb7WzVX7B22vs2sgmNkgabh95Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MCk19dj4kFiqFVu8xCOoiZ4iH13iHgiIguTbpYhfHU=;
 b=ADVc1IrRZxjtnmEHYehZAQm8nJsrWv2WZp7Fo6MNKaP5LBUDnBQFW1lVFF9cGC9LeYVDq1ZPvywkMhzQSQzTiWlvyzr7s7rHT5dEbat7jSVP9kzIadE+nLeLu648uasCMwF8fLf4mXuKNfvPu7nuGk1qpfiSbGZrh5247Muymrnk61nKBEePNRvhq8nghAlrg/HEbhXsSY2G/oTInaOzaGgmBWitkRpjlV+NaysETJ1ZmynHOUPIOKszWwuNFcwDEEA3NuZHS/fGrUf2RN9YjplhIOHgk5dUkyBGEyNqtXsFrYNwXTqdB57DFMz2eGCjxIaAgvF4kPJDALFLOZrH4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MCk19dj4kFiqFVu8xCOoiZ4iH13iHgiIguTbpYhfHU=;
 b=gn5Oz/xbc23YVXOra9ntxuCqgV/xWRlAfKigZVcnrEnEwsIszD5hS3PIZPCOfBBLKSFYNu0Yw8Kke3mvTh942kXyDylQSI9X/Pl0EnYfpuo0Dptr4E6NUof24Y3i9bKYnG60/NUpZycXbsw1E7Tkcpj+KuutE+X2YqWhtzLm7ZQ=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB6256.eurprd04.prod.outlook.com (20.179.25.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 15:46:17 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::e401:6546:3729:47c0]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::e401:6546:3729:47c0%6]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 15:46:17 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3 2/4] enetc: Add mdio bus driver for the PCIe
 MDIO endpoint
Thread-Topic: [PATCH net-next v3 2/4] enetc: Add mdio bus driver for the PCIe
 MDIO endpoint
Thread-Index: AQHVRfTzIlSQL21yzUKJl+LDCQ5gdabhupAA////0TCAAAKmEA==
Date:   Mon, 29 Jul 2019 15:46:17 +0000
Message-ID: <VI1PR04MB488060D95CFD31CB904CDF6796DD0@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <1564394627-3810-1-git-send-email-claudiu.manoil@nxp.com>
 <1564394627-3810-3-git-send-email-claudiu.manoil@nxp.com>
 <20190729153524.GG4110@lunn.ch>
 <VI1PR04MB48806AF2F6CEDE105B78086696DD0@VI1PR04MB4880.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB48806AF2F6CEDE105B78086696DD0@VI1PR04MB4880.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6309c20e-fc0b-4189-986f-08d7143be555
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB6256;
x-ms-traffictypediagnostic: VI1PR04MB6256:
x-microsoft-antispam-prvs: <VI1PR04MB62566ADED7CA1B01E881D50896DD0@VI1PR04MB6256.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(199004)(189003)(51914003)(13464003)(8936002)(6506007)(229853002)(446003)(52536014)(2906002)(86362001)(26005)(25786009)(14454004)(44832011)(186003)(11346002)(256004)(486006)(55016002)(6436002)(5660300002)(66066001)(53936002)(476003)(4326008)(6246003)(81166006)(81156014)(66946007)(66476007)(9686003)(71200400001)(54906003)(110136005)(3846002)(7736002)(76176011)(8676002)(33656002)(68736007)(7696005)(74316002)(99286004)(305945005)(2940100002)(71190400001)(478600001)(76116006)(316002)(6116002)(64756008)(66556008)(66446008)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6256;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sgxnSPcJIqDCE7Z7osQaujug7lzwbXKfQlBghguwTy0JucgXtOGjN7yOfZ7LOlwLjXzhElaz1EtlP9/esg6ViLrZQUx/+ldR4WCqI5F6gEtLCx237w8YnB+vw72zKkr4AcAYTMh/xb+0WCTaxg3myMIOzqdFjFelu3cO2GysZS59x8Xa/JlfhNdRIthOaqgG+vcQ2uK2W9YSBsk03DNHqwjcEiQM8rhXKXAbg7DnAv1Rcw7wJXjZZJksJV6JRuwaPAFAuX20/lx9Mu7QApUHEBu0ldQ/qjnDmetUo4/MU7yTqJayMctiJ57OuE6QJKUtSoDSVKq0bGPhxHY59D2K5pyXfNyQuyROFthpedoH3qcFRNXjf5WqvX1NWf09Gc0W/ilf9mnEbfTleTnECn8DZPG7ndAQ180rcxrEclV2vq4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6309c20e-fc0b-4189-986f-08d7143be555
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 15:46:17.7833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: claudiu.manoil@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogbmV0ZGV2LW93bmVyQHZnZXIua2Vy
bmVsLm9yZyA8bmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZz4gT24NCj5CZWhhbGYgT2YgQ2xh
dWRpdSBNYW5vaWwNCj5TZW50OiBNb25kYXksIEp1bHkgMjksIDIwMTkgNjo0MCBQTQ0KPlRvOiBB
bmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+Q2M6IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVt
QGRhdmVtbG9mdC5uZXQ+OyBSb2IgSGVycmluZw0KPjxyb2JoK2R0QGtlcm5lbC5vcmc+OyBMZW8g
TGkgPGxlb3lhbmcubGlAbnhwLmNvbT47IEFsZXhhbmRydSBNYXJnaW5lYW4NCj48YWxleGFuZHJ1
Lm1hcmdpbmVhbkBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj5kZXZpY2V0cmVl
QHZnZXIua2VybmVsLm9yZzsgbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBs
aW51eC0NCj5rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+U3ViamVjdDogUkU6IFtQQVRDSCBuZXQt
bmV4dCB2MyAyLzRdIGVuZXRjOiBBZGQgbWRpbyBidXMgZHJpdmVyIGZvciB0aGUgUENJZQ0KPk1E
SU8gZW5kcG9pbnQNCj4NCj4+LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4+RnJvbTogQW5k
cmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPj5TZW50OiBNb25kYXksIEp1bHkgMjksIDIwMTkg
NjozNSBQTQ0KPj5UbzogQ2xhdWRpdSBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+DQo+
PkNjOiBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgUm9iIEhlcnJpbmcN
Cj4+PHJvYmgrZHRAa2VybmVsLm9yZz47IExlbyBMaSA8bGVveWFuZy5saUBueHAuY29tPjsgQWxl
eGFuZHJ1IE1hcmdpbmVhbg0KPj48YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAuY29tPjsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsNCj4+ZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFy
bS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsNCj4+bGludXgtIGtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmcNCj4+U3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2MyAyLzRdIGVuZXRjOiBBZGQg
bWRpbyBidXMgZHJpdmVyIGZvciB0aGUNCj4+UENJZSBNRElPIGVuZHBvaW50DQo+Pg0KPj4+ICsJ
aHctPnBvcnQgPSBwY2lfaW9tYXAocGRldiwgMCwgMCk7DQo+Pj4gKwlpZiAoIWJ1cy0+cHJpdikg
ew0KPj4NCj4+aHctPnBvcnQgPz8NCj4+DQo+DQo+WWVhaCwgYmV0dGVyIGlnbm9yZSB0aGlzIGZv
ciBub3cg8J+Yig0KPkl0J3MgZm9yIHRoZSBlbmV0YyBhY2Nlc3NvcnMsIGVuZXRjX3BvcnRfLi4o
KS4NCg0KT2ggSSBzZWUsIGl0J3MgYSBtaXN0YWtlLiAgSSdtIGNoZWNraW5nIHRoZSB3cm9uZyB0
aGluZy4NClNvcnJ5LiAgVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0K

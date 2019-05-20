Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A80D22A14
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 04:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbfETCzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 22:55:35 -0400
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:43566
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727087AbfETCze (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 22:55:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xu1JBhVGFfB2amgaocljRqmfE6NLZWYDynBMDXaq35c=;
 b=g5iH+3h80oSl3Nl+gYT/MhBxbZD7Up/E6St2YBgFzk39rNVXbIs9unUwLaRdDdKx8gEuQfzzaL38rHZN1wcwydYvquYmRw+k+ovM21j6cWcKWf9A1SC+RUQ3+FhVjqfSEOo97NSvKRTmT0dsRQHbrylZti5Wc7Nvk+5eFiR/gso=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2688.eurprd04.prod.outlook.com (10.168.66.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Mon, 20 May 2019 02:55:29 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986%3]) with mapi id 15.20.1900.020; Mon, 20 May 2019
 02:55:29 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        David Miller <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] enetc: add hardware timestamping support
Thread-Topic: [PATCH 1/3] enetc: add hardware timestamping support
Thread-Index: AQHVC84AyxJ95TkLo0SObQ6CRQsOGKZtv6UAgAWXbVA=
Date:   Mon, 20 May 2019 02:55:28 +0000
Message-ID: <VI1PR0401MB22373507628D6D133B8D5F2AF8060@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190516100028.48256-1-yangbo.lu@nxp.com>
 <20190516100028.48256-2-yangbo.lu@nxp.com>
 <VI1PR04MB4880C3E6D24AB7A53887D9C9960A0@VI1PR04MB4880.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB4880C3E6D24AB7A53887D9C9960A0@VI1PR04MB4880.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33170ad1-74b4-4a4a-3fbe-08d6dcce9dfe
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2688;
x-ms-traffictypediagnostic: VI1PR0401MB2688:
x-microsoft-antispam-prvs: <VI1PR0401MB26889A06E1B2436DEBC2F345F8060@VI1PR0401MB2688.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 004395A01C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(346002)(376002)(366004)(189003)(199004)(13464003)(33656002)(52536014)(486006)(256004)(54906003)(55016002)(74316002)(110136005)(71200400001)(71190400001)(476003)(4744005)(53546011)(5660300002)(6506007)(99286004)(102836004)(9686003)(76176011)(3846002)(6116002)(7696005)(53936002)(229853002)(186003)(2501003)(81166006)(81156014)(2906002)(8676002)(25786009)(8936002)(6246003)(316002)(478600001)(14454004)(73956011)(7736002)(66946007)(66556008)(66446008)(64756008)(66476007)(446003)(11346002)(86362001)(305945005)(76116006)(68736007)(4326008)(66066001)(6436002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2688;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RBeDLRZhNb2iVs4YR8r3jszk+z0doFiXJp5twDcmlDP232mhPP5KQnv1nNVkBDNS4z5a3qskcgd1BGkI4WyA2bOpTOaHWTZOlTHkemDeDfPX5+J4q3SWc3QspVu2rtfg8WWjmb8TwD9EltQFPMDDlRC336dTGy3n1+1ylvGw/H+sVxo1yUZccbU7sjWULN3w4R/33EoCQk0XSPJm34Q8YWxvtpQqV5S8XmofTR9+NrgfjARggQAqJ2M2KTa9naeW2wZahfht7qZx4/JBtpAwNysThcorMTjpXXlrvdZ7Pvk6k+FM+OnNgsCp6jo23bo5/vgsBXo8mLgS8idzydKES06bQg8Mr/2QSLw6/3eKqLaDeANkN/SjKSmXqUAs8U+d/KOF1r3Z3QBV350haxVce/m8pWYwc2W4pozd/fjWAqE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33170ad1-74b4-4a4a-3fbe-08d6dcce9dfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2019 02:55:28.9961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2688
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDbGF1ZGl1IE1hbm9pbA0KPiBT
ZW50OiBUaHVyc2RheSwgTWF5IDE2LCAyMDE5IDk6MzEgUE0NCj4gVG86IFkuYi4gTHUgPHlhbmdi
by5sdUBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgUmljaGFyZCBDb2NocmFuDQo+
IDxyaWNoYXJkY29jaHJhbkBnbWFpbC5jb20+OyBEYXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9m
dC5uZXQ+OyBTaGF3bg0KPiBHdW8gPHNoYXduZ3VvQGtlcm5lbC5vcmc+OyBSb2IgSGVycmluZyA8
cm9iaCtkdEBrZXJuZWwub3JnPg0KPiBDYzogZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxp
bnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSRTogW1BBVENIIDEvM10gZW5ldGM6IGFkZCBoYXJkd2Fy
ZSB0aW1lc3RhbXBpbmcgc3VwcG9ydA0KPiANCj4gPi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQo+ID5Gcm9tOiBZLmIuIEx1DQo+IFsuLi5dDQo+ID5TdWJqZWN0OiBbUEFUQ0ggMS8zXSBlbmV0
YzogYWRkIGhhcmR3YXJlIHRpbWVzdGFtcGluZyBzdXBwb3J0DQo+ID4NCj4gWy4uLl0NCj4gDQo+
IEhpIFlhbmdibywNCj4gDQo+IFRoZXNlIGVuZXRjIHBhdGNoZXMgdGFyZ2V0aW5nIG5ldC1uZXh0
IHdpbGwgaGF2ZSB0byBiZSByZWJhc2VkIG9uIHRoZSBsYXRlc3QNCj4gZW5ldGMgbmV0LmdpdCBj
b21taXRzLCBvdGhlcndpc2UgdGhlcmUgd2lsbCBiZSBzb21lIG1lcmdlIGNvbmZsaWN0cyBmb3Ig
ZW5ldGMuYw0KPiBhbmQgZW5ldGNfZXRodG9vbC5jLg0KPiBUaGFua3MsDQo+IENsYXVkaXUNCj4g
DQo+IHNlZQ0KPiAyMmZiNDNmMzYwMDYgImVuZXRjOiBBZGQgbWlzc2luZyBsaW5rIHN0YXRlIGlu
Zm8gZm9yIGV0aHRvb2wiDQo+IGY0YTBiZTg0ZDczZSAiZW5ldGM6IEZpeCBOVUxMIGRtYSBhZGRy
ZXNzIHVubWFwIGZvciBUeCBCRCBleHRlbnNpb25zIg0KDQpbWS5iLiBMdV0gVGhhbmtzIENsYXVk
aXUuIEkgc2hvdWxkIGhhdmUgbm90aWNlZCB0aGF0LiBMZXQgbWUgc2VuZCB2MiBhZnRlciBuZXQt
bmV4dCBpcyBvcGVuLg0K

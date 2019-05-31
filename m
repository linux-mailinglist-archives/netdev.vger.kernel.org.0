Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71439313E3
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfEaRdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:33:04 -0400
Received: from mail-eopbgr30066.outbound.protection.outlook.com ([40.107.3.66]:6272
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726604AbfEaRdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 13:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIceLZiHcHCG593X2VSQBK/nRcQ4vWVFkq8qzqbr1V4=;
 b=d1aec/yzcBBBrZiyjZu6yPNF9l0v3XObvP6AmBLDfjXks4qRtrcJYP0JAifEgMeD06vGYzuUsOXFt/M0xaukChiHS1bUphpPCQPMJdIqxOsz9UoKnwqNnu8ABXQZnK3itDc3lNJ91Z7qfxI0ZQZ7A8NkuBDRkUmxV+lPadjO/EM=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.50.159) by
 VI1SPR01MB0371.eurprd04.prod.outlook.com (20.178.125.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 31 May 2019 17:32:58 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::8d0e:de86:9b49:b40]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::8d0e:de86:9b49:b40%7]) with mapi id 15.20.1922.024; Fri, 31 May 2019
 17:32:58 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     =?utf-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jocke@infinera.com" <joakim.tjernlund@infinera.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Mian Yousaf Kaukab <yousaf.kaukab@suse.com>
Subject: RE: [PATCH v3 0/6] Prerequisites for NXP LS104xA SMMU enablement
Thread-Topic: [PATCH v3 0/6] Prerequisites for NXP LS104xA SMMU enablement
Thread-Index: AQHVFvLAUsVmmx2jaE2ZHLZY1pGN66aFajIAgAAH5dCAAAWjAIAABkSw
Date:   Fri, 31 May 2019 17:32:58 +0000
Message-ID: <VI1PR04MB5134E4DA6EA052BEBB3C26EFEC190@VI1PR04MB5134.eurprd04.prod.outlook.com>
References: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
 <d086216f-f3fc-c88a-3891-81e84e8bdb01@suse.de>
 <VI1PR04MB5134BFA391D8FF013762882FEC190@VI1PR04MB5134.eurprd04.prod.outlook.com>
 <19cc3230-33b0-e465-6317-590780b33efa@suse.de>
In-Reply-To: <19cc3230-33b0-e465-6317-590780b33efa@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd6528e5-3fc5-4774-3ca7-08d6e5ee062a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1SPR01MB0371;
x-ms-traffictypediagnostic: VI1SPR01MB0371:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1SPR01MB0371351011C47BC791317F3EEC190@VI1SPR01MB0371.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(346002)(366004)(136003)(396003)(376002)(13464003)(189003)(199004)(66556008)(76116006)(52536014)(66446008)(64756008)(66946007)(102836004)(25786009)(71190400001)(53936002)(305945005)(73956011)(66574012)(81156014)(74316002)(5660300002)(76176011)(33656002)(6246003)(68736007)(256004)(7736002)(71200400001)(7696005)(26005)(66476007)(54906003)(6506007)(14444005)(55016002)(476003)(81166006)(446003)(229853002)(9686003)(11346002)(8676002)(14454004)(316002)(86362001)(44832011)(478600001)(6916009)(486006)(8936002)(99286004)(4326008)(66066001)(6436002)(186003)(2906002)(6116002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0371;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: txJoEvoxShin5Wd059+uxffnfOSdoKxsHX3t2fgGJNpNaeS+SjqSKazODDrwkoAYvhFk800Mpidc8Q0ZVGOCFtXzBNPdSOA1bbl5DIA+4S6eBE+jXSSQp3CbtmUXY2l0pcfGbkxMl8cPpp9abQSdc4nybJcJ1KH6FZa/dfkLoSj7ZwfRpjGQj+LhttjhTTb7SQzz+WZvJ46hN/iFLE/gb8NIKQ3WatqzkWTYojIw4x3mE3xmhbAbZc5e2zYAqVXgzLxuYggZHJUOixGVQrklfbY7aERuM/OqswlcgoiSagF6P9/N6bKe2ySUpDt7Ws7BMtt2ttcS7TPNcmgca5KY7prB9tYRtvJj7aQv7Divf7h+Y4Ezzobk5LDAiUnQ/EOJg7nrcfcVp07W6D7vyhLfIqDGWgFPPPZI+dCwLW6cb2k=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd6528e5-3fc5-4774-3ca7-08d6e5ee062a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 17:32:58.6553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: laurentiu.tudor@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0371
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmRyZWFzIEbDpHJiZXIgPGFm
YWVyYmVyQHN1c2UuZGU+DQo+IFNlbnQ6IEZyaWRheSwgTWF5IDMxLCAyMDE5IDg6MDQgUE0NCj4g
DQo+IEhlbGxvIExhdXJlbnRpdSwNCj4gDQo+IEFtIDMxLjA1LjE5IHVtIDE4OjQ2IHNjaHJpZWIg
TGF1cmVudGl1IFR1ZG9yOg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBG
cm9tOiBBbmRyZWFzIEbDpHJiZXIgPGFmYWVyYmVyQHN1c2UuZGU+DQo+ID4+IFNlbnQ6IEZyaWRh
eSwgTWF5IDMxLCAyMDE5IDc6MTUgUE0NCj4gPj4NCj4gPj4gSGkgTGF1cmVudGl1LA0KPiA+Pg0K
PiA+PiBBbSAzMC4wNS4xOSB1bSAxNjoxOSBzY2hyaWViIGxhdXJlbnRpdS50dWRvckBueHAuY29t
Og0KPiA+Pj4gVGhpcyBwYXRjaCBzZXJpZXMgY29udGFpbnMgc2V2ZXJhbCBmaXhlcyBpbiBwcmVw
YXJhdGlvbiBmb3IgU01NVQ0KPiA+Pj4gc3VwcG9ydCBvbiBOWFAgTFMxMDQzQSBhbmQgTFMxMDQ2
QSBjaGlwcy4gT25jZSB0aGVzZSBnZXQgcGlja2VkIHVwLA0KPiA+Pj4gSSdsbCBzdWJtaXQgdGhl
IGFjdHVhbCBTTU1VIGVuYWJsZW1lbnQgcGF0Y2hlcyBjb25zaXN0aW5nIGluIHRoZQ0KPiA+Pj4g
cmVxdWlyZWQgZGV2aWNlIHRyZWUgY2hhbmdlcy4NCj4gPj4NCj4gPj4gSGF2ZSB5b3UgdGhvdWdo
dCB0aHJvdWdoIHdoYXQgd2lsbCBoYXBwZW4gaWYgdGhpcyBwYXRjaCBvcmRlcmluZyBpcyBub3QN
Cj4gPj4gcHJlc2VydmVkPyBJbiBwYXJ0aWN1bGFyLCBhIHVzZXIgaW5zdGFsbGluZyBhIGZ1dHVy
ZSBVLUJvb3QgdXBkYXRlIHdpdGgNCj4gPj4gdGhlIERUQiBiaXRzIGJ1dCBib290aW5nIGEgc3Rh
YmxlIGtlcm5lbCB3aXRob3V0IHRoaXMgcGF0Y2ggc2VyaWVzIC0NCj4gPj4gd291bGRuJ3QgdGhh
dCByZWdyZXNzIGRwYWEgdGhlbiBmb3Igb3VyIGN1c3RvbWVycz8NCj4gPj4NCj4gPg0KPiA+IFRo
ZXNlIGFyZSBmaXhlcyBmb3IgaXNzdWVzIHRoYXQgcG9wcGVkIG91dCBhZnRlciBlbmFibGluZyBT
TU1VLg0KPiA+IEkgZG8gbm90IGV4cGVjdCB0aGVtIHRvIGJyZWFrIGFueXRoaW5nLg0KPiANCj4g
VGhhdCB3YXMgbm90IG15IHF1ZXN0aW9uISBZb3UncmUgbWlzc2luZyBteSBwb2ludDogQWxsIHlv
dXIgcGF0Y2hlcyBhcmUNCj4gbGFja2luZyBhIEZpeGVzIGhlYWRlciBpbiB0aGVpciBjb21taXQg
bWVzc2FnZSwgZm9yIGJhY2twb3J0aW5nIHRoZW0sIHRvDQo+IGF2b2lkIF95b3VyIERUIHBhdGNo
ZXNfIGJyZWFraW5nIHRoZSBkcml2ZXIgb24gc3RhYmxlIGJyYW5jaGVzIQ0KDQpJdCBkb2VzIGFw
cGVhciB0aGF0IEknbSBtaXNzaW5nIHlvdXIgcG9pbnQuIEZvciBzdXJlLCB0aGUgRFQgdXBkYXRl
cyBzb2xlbHkgd2lsbA0KYnJlYWsgdGhlIGtlcm5lbCB3aXRob3V0IHRoZXNlIGZpeGVzIGJ1dCBJ
J20gbm90IHN1cmUgSSB1bmRlcnN0YW5kIGhvdyB0aGlzDQpjb3VsZCBoYXBwZW4uIE15IHBsYW4g
d2FzIHRvIHNoYXJlIHRoZSBrZXJuZWwgZHRzIHBhdGNoZXMgc29tZXRpbWUgYWZ0ZXIgdGhpcyBz
ZXJpZXMNCm1ha2VzIGl0IHRocm91Z2guDQoNCi0tLQ0KQmVzdCBSZWdhcmRzLCBMYXVyZW50aXUN
Cg==

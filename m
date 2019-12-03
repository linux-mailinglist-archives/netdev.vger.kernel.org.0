Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BB110FB9B
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfLCKQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:16:32 -0500
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:14753
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbfLCKQb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 05:16:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHHmIeXxsWkhpdP38xeX7QH3JZAz8b4eOvLTROczglm90JsXLP4eMsuykm2WC35m5B5q/n3lujXmrdjl9xsuOR0qhzQajKhq9UYvlnpRmitNwbGsIbsn+q9L+NIvyVdvdwwYUrq0kxl8dhKhu4qQq0+spXXOWS7UEOL7lBveMPvUoKXfWVZYDjuipOxXcZ2RmZ9/0FjzYxSb1UPRSO9mInrtU8oQg+m2a613H0MYVBj7Z7imvHOaglOQvfFaRmKLxYaprKYwybdil21XrnGFE67nVLqKuVQ7SESeqv4NVekZaLbHSDuCatXZoQ6fB7ZpgDlKGVLOEV7qafsbvnwdoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjRs7inzue7nFXL419KgyTzNCkpOtAmC2p8/VhBby+g=;
 b=Xku1ifbsGRBtOQaf/CiCXIP6GLCr3fco9v0OKJ3grx5gyUxY1Hif1N9X8mmngzZhBGZqBzb1+IzC0IgcCB2on4NgOpv4TSimSB5X99MLeg+nWmPYpnOJL9a+zJHpVeEBrXejwgNrizL6XJdURWby5qmN4EUprn8h+LJ8R3hOGzD5/eaNV6ctib2pG8BqkTaAztRrteGvkD8ZXWSHk++EkLnt1GUNA5SH/T+/u6jCABSc0J2TYntK4QNsvBj5kQ2RFD1rwqMHQJNJFJgkI7Q7fTKlUs5sUcsckatNSqlvY2GkVejXz9zXesVg+E8D6bSJIycCQ2TwK2ILIYgunTK3fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjRs7inzue7nFXL419KgyTzNCkpOtAmC2p8/VhBby+g=;
 b=gVYXpMwAhcMAbxhFeNmXOEuJ4aJPQuFjtPNfB8ZM8Y7mXxmOphOnGWGqpzXcZT1wuohUiRvtaMRe9sqUvinNVCjzYZu48Gcjh4jy3C5K56fFEeyJg7rlu/JElWuBVIZG4h2X/o32IWBmw7FfxFqtR9Vcw3MhSFl44aDuJPpjEDs=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5530.eurprd04.prod.outlook.com (20.178.104.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Tue, 3 Dec 2019 10:16:27 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Tue, 3 Dec 2019
 10:16:27 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 0/4] can: flexcan: fixes for stop mode
Thread-Topic: [PATCH V2 0/4] can: flexcan: fixes for stop mode
Thread-Index: AQHVpOdxXAI9W9cZiUqxHtJbOFpoG6eeiWMAgAAhqwCAABa5QIAAAZ0wgAADdACAAADr0IAAAUMAgAlxzoA=
Date:   Tue, 3 Dec 2019 10:16:26 +0000
Message-ID: <DB7PR04MB461896927F3DD1C88A987672E6420@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <e936b9b1-d602-ac38-213c-7272df529bef@geanix.com>
 <4a9c2e4a-c62d-6e88-bd9e-01778dab503b@geanix.com>
 <DB7PR04MB46186472F0437A825548CE11E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <DB7PR04MB4618C541894AD851BED5B0B7E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <1c71c2ef-39a4-6f38-98c0-4ee43767a725@geanix.com>
 <DB7PR04MB46180EE59D373F9634DD936AE6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <6fa94966-c21b-ad2b-653d-aa3589b32df8@geanix.com>
In-Reply-To: <6fa94966-c21b-ad2b-653d-aa3589b32df8@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c5954f8f-8b99-49f1-b3cf-08d777d9db85
x-ms-traffictypediagnostic: DB7PR04MB5530:|DB7PR04MB5530:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB553087ABE5306651ADD8B5C3E6420@DB7PR04MB5530.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 02408926C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(13464003)(199004)(189003)(52536014)(55016002)(2906002)(86362001)(3846002)(53546011)(2501003)(316002)(6506007)(186003)(74316002)(26005)(102836004)(305945005)(4326008)(8676002)(7736002)(478600001)(71200400001)(71190400001)(5660300002)(9686003)(66476007)(25786009)(66556008)(64756008)(66446008)(14454004)(8936002)(256004)(2201001)(11346002)(81156014)(110136005)(6246003)(54906003)(6436002)(4744005)(66946007)(7696005)(76176011)(99286004)(229853002)(76116006)(33656002)(6116002)(446003)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5530;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nei4GBTuV7JFV74HzokK3Va0KFqgda2MN3st5fIa3AMIdGn2Zt8c0DapTedL3FEdpTrq5+fzDHNs+Ot+JpxdCFJobYRDaxqSGPkFcuIkkOuD+q5lm3jHnCO+4mtazVRhfh8PPznYnHheQsu6BO7K9N2I7404wklUhw6FeD0rD7NioGEZ4CrRQXFYjWg8mWZbgtA4ZqjqUApNSvHlWiM5E+kTgnYZ4jZ4DSbtlEERcnAifHEq0DoYlpKRPyQ2gAfMY74UD4qGNBcqB6hBHZb73XbeeMVU2c/Z9vbCAjXSXSpZ8di+9cg8fZ5lIsjST7HIhcxloGXDaSXnEes0XLaOulzKPaqddSu43c0efPF2ja+RpaUHWI9cNAY1yMDVAAdPZLU6IT6t6wbawFJS7NXhHCYT5OFZnjXFwWSZMERqTgAiKJG3gxMDDWBtzGrFz/RF
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5954f8f-8b99-49f1-b3cf-08d777d9db85
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2019 10:16:26.9736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OogSlKjbTukENwp+xMvt/cBq14nMnw2t5kQCGHCvYJmIODj6eJyuxSFGLthB3sW8Y9j8TA3/8yHnI7t9Ly9uXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5530
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGxpbnV4LWNhbi1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNhbi1vd25lckB2Z2VyLmtlcm5lbC5vcmc+DQo+IE9uIEJl
aGFsZiBPZiBTZWFuIE55ZWtqYWVyDQo+IFNlbnQ6IDIwMTnlubQxMeaciDI35pelIDE4OjAwDQo+
IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgbWtsQHBlbmd1dHJv
bml4LmRlOw0KPiBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXgg
PGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIFYyIDAvNF0gY2FuOiBmbGV4Y2FuOiBmaXhlcyBmb3Igc3RvcCBtb2RlDQo+IA0K
PiANCj4gDQo+IE9uIDI3LzExLzIwMTkgMTAuNTgsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBD
b3VsZCB5b3UgZ2l2ZSB5b3VyIFRlc3QtYnkgdGFnIGZvciB0aGlzIHBhdGNoIHNldD8gQW5kIHRo
ZW4gTWFyYyBjb3VsZA0KPiByZXZpZXcgdGhpcyBwYXRjaCBzZXQuDQo+IA0KPiBEb25lIDopDQo+
IENhbid0IHRlc3QgcGF0Y2ggNC80Li4uDQo+IA0KPiBIb3BlIE1hcmMgY2FuIGdpdmUgaGlzIGNv
bW1lbnRzIGFuZCBwaWNrIHRoZXNlLg0KDQpIaSBNYXJjLA0KDQpDb3VsZCB5b3UgcGxlYXNlIHJl
dmlldyB0aGlzIHBhdGNoIHNldCwgb3IgbmVlZCBJIHJlc2VuZCBpdD8gU2VhbiBoYXMgYWxyZWFk
eSB0ZXN0ZWQgZmlyc3QgdGhyZWUgcGF0Y2hlcy4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpo
YW5nDQo+IC9TZWFuDQo=

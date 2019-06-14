Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED88345AB4
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 12:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfFNKkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 06:40:19 -0400
Received: from mail-eopbgr10051.outbound.protection.outlook.com ([40.107.1.51]:47842
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726931AbfFNKkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 06:40:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tU6UMKygDXTyhPtQhhaWcowdl9X2b4kaHu1DeoXO+70=;
 b=NqXdVm1lh0awjs5w3Y5/S5wdpa8yh5lq3NI8E9bfRQGvmc4ERJ50TMF8L7B0z2LjT7OEjkTGAPSRVrruT8LhDNhLq23OoWqkt52sm87yk6eQ//IznX+7qIP6VbFCDmDvEQjjD5e6NfphqmSgDsZG9WKebDctRwHGXBG5wPt1HEo=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2543.eurprd04.prod.outlook.com (10.168.66.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Fri, 14 Jun 2019 10:40:14 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::3408:f7f9:7f82:c67c]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::3408:f7f9:7f82:c67c%7]) with mapi id 15.20.1987.013; Fri, 14 Jun 2019
 10:40:14 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/6] ptp: add QorIQ PTP support for DPAA2
Thread-Topic: [PATCH 1/6] ptp: add QorIQ PTP support for DPAA2
Thread-Index: AQHVHztS7fz1CkTI/EyG9roH6EAQXaaU3AqAgAKPkpCAAJZvgIAC+lZw
Date:   Fri, 14 Jun 2019 10:40:13 +0000
Message-ID: <VI1PR0401MB223763F5537C0E5F3A9C33DAF8EE0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190610032108.5791-1-yangbo.lu@nxp.com>
 <20190610032108.5791-2-yangbo.lu@nxp.com> <20190610130601.GD8247@lunn.ch>
 <VI1PR0401MB2237247525AB5DB5B5F275A8F8EC0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20190612131049.GC23615@lunn.ch>
In-Reply-To: <20190612131049.GC23615@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f583ea9e-1f55-4931-6763-08d6f0b4af10
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2543;
x-ms-traffictypediagnostic: VI1PR0401MB2543:
x-microsoft-antispam-prvs: <VI1PR0401MB2543C4FE3D70B048930FD9B8F8EE0@VI1PR0401MB2543.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(366004)(376002)(39860400002)(199004)(189003)(13464003)(3846002)(6116002)(5660300002)(6436002)(76176011)(52536014)(9686003)(55016002)(229853002)(256004)(6246003)(53936002)(99286004)(76116006)(102836004)(73956011)(66946007)(64756008)(53546011)(66476007)(6506007)(66556008)(7736002)(478600001)(66446008)(66066001)(7696005)(86362001)(8936002)(26005)(486006)(11346002)(71190400001)(71200400001)(446003)(476003)(54906003)(6916009)(305945005)(186003)(4326008)(25786009)(14454004)(68736007)(33656002)(2906002)(74316002)(81156014)(81166006)(8676002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2543;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tGS5RpKA5PpoXDR/4bOew20p0nEJZTzBygC3+9K6chodcj24aA031+LCv1hTGwfCxV4d8sDoWVpV4+HPpKfal8pGaoeS6y8tFq5WfK7ejm4CwuShaqzkWIUcFCwN8eBeXOvYTtLoUY/FKuBSLykQCw/Kci6YtYYM+2nEx1eXGPnj9y4E4uTOu2Nie881eXFrHYLxBUAZIvbkGDvSYkIekjG3p8Itv2dibM01OHDIHgyt+8vDpShbCjJNm90nEYDhO9pNHN97UdCYayjYhylwqsk7z7Z7IaQ2So3WGNbzRaVFtgOqXimdgPXJME22RMMJxnk72yxj41AKEHFHnFDuwT35E9J520dyshbovWILIFcQYIJwIcMe0EfQUaOiHv8IJiVcDiRXAmrkcOkHDxyrFjXiEly8rnEE0vr0ciYnu9E=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f583ea9e-1f55-4931-6763-08d6f0b4af10
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 10:40:14.0070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yangbo.lu@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2543
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmRyZXcgTHVubiA8YW5kcmV3
QGx1bm4uY2g+DQo+IFNlbnQ6IDIwMTnE6jbUwjEyyNUgMjE6MTENCj4gVG86IFkuYi4gTHUgPHlh
bmdiby5sdUBueHAuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgRGF2aWQgUyAu
IE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+IFJpY2hhcmQgQ29jaHJhbiA8cmljaGFy
ZGNvY2hyYW5AZ21haWwuY29tPjsgUm9iIEhlcnJpbmcNCj4gPHJvYmgrZHRAa2VybmVsLm9yZz47
IFNoYXduIEd1byA8c2hhd25ndW9Aa2VybmVsLm9yZz47DQo+IGRldmljZXRyZWVAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1hcm0ta2VybmVs
QGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCAxLzZdIHB0cDogYWRk
IFFvcklRIFBUUCBzdXBwb3J0IGZvciBEUEFBMg0KPiANCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvcHRwL0tjb25maWcgYi9kcml2ZXJzL3B0cC9LY29uZmlnIGluZGV4DQo+ID4gPiA+IDli
OGZlZTUuLmIxYjQ1NGYgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL2RyaXZlcnMvcHRwL0tjb25maWcN
Cj4gPiA+ID4gKysrIGIvZHJpdmVycy9wdHAvS2NvbmZpZw0KPiA+ID4gPiBAQCAtNDQsNyArNDQs
NyBAQCBjb25maWcgUFRQXzE1ODhfQ0xPQ0tfRFRFDQo+ID4gPiA+DQo+ID4gPiA+ICBjb25maWcg
UFRQXzE1ODhfQ0xPQ0tfUU9SSVENCj4gPiA+ID4gIAl0cmlzdGF0ZSAiRnJlZXNjYWxlIFFvcklR
IDE1ODggdGltZXIgYXMgUFRQIGNsb2NrIg0KPiA+ID4gPiAtCWRlcGVuZHMgb24gR0lBTkZBUiB8
fCBGU0xfRFBBQV9FVEggfHwgRlNMX0VORVRDIHx8DQo+IEZTTF9FTkVUQ19WRg0KPiA+ID4gPiAr
CWRlcGVuZHMgb24gR0lBTkZBUiB8fCBGU0xfRFBBQV9FVEggfHwgRlNMX0RQQUEyX0VUSCB8fA0K
PiA+ID4gRlNMX0VORVRDIHx8DQo+ID4gPiA+ICtGU0xfRU5FVENfVkYNCj4gPiA+ID4gIAlkZXBl
bmRzIG9uIFBUUF8xNTg4X0NMT0NLDQo+ID4gPg0KPiA+ID4gSGkgWWFuZ2JvDQo+ID4gPg0KPiA+
ID4gQ291bGQgQ09NUElMRV9URVNUIGFsc28gYmUgYWRkZWQ/DQo+ID4NCj4gPiBbWS5iLiBMdV0g
Q09NUElMRV9URVNUIGlzIHVzdWFsbHkgZm9yIG90aGVyIEFSQ0hzIGJ1aWxkIGNvdmVyYWdlLg0K
PiA+IERvIHlvdSB3YW50IG1lIHRvIGFwcGVuZCBpdCBhZnRlciB0aGVzZSBFdGhlcm5ldCBkcml2
ZXIgZGVwZW5kZW5jaWVzPw0KPiANCj4gSGlpIFkuYi4gTHUNCj4gDQo+IE5vcm1hbGx5LCBkcml2
ZXJzIGxpa2UgdGhpcyBzaG91bGQgYmUgYWJsZSB0byBjb21waWxlIGluZGVwZW5kZW50IG9mIHRo
ZSBNQUMNCj4gZHJpdmVyLiBTbyB5b3Ugc2hvdWxkIGJlIGFibGUgdG8gYWRkIENPTVBJTEVfVEVT
VCBoZXJlLg0KDQpbWS5iLiBMdV0gVGhhbmtzIEFuZHJldy4gSSBoYWQgc2VudCBvdXQgdjIgd2l0
aCB0aGUgY2hhbmdlLg0KDQo+IA0KPiAgICAgQW5kcmV3DQo=

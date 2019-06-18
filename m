Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC564AEBE
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 01:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbfFRX2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 19:28:06 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:43576 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfFRX2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 19:28:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560900484; x=1592436484;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=C+ejFAyAaDzYV1d6Ah7AhxW1J8PaUIPnCk0+XKPe5fQ=;
  b=Ja34FnrQ8wujaJlWKdeFxIrkiZ1ykkrtbN8FhcXLv55lCl6FNQCspOFi
   /RkcN0Qe+twJ0C7ozBPDOl6tMbcCrzPdNiGBUVJq1uiPm1BKL96q+1xwD
   xrZfww60FWb2GrlQLGu8pD0Q05tTsuvRvksYz4jo8/69dBc+WVJBXarPw
   evOCYROJwZoGFbXOFytgAUCsvP3wFBOZt17YBzhacYOBYT4bZ4T4TyqDk
   lQqRnHWwVhibGm/FUl18bY0sPlQTPREFtJQkWvMPRdZHm/ESfIFgFgcSZ
   k3n1iN0mTcjn6E0JmqV3O6w9ckBwn7ayqZorl2ypE0e3+hbqZ+cZCkYYg
   Q==;
X-IronPort-AV: E=Sophos;i="5.63,390,1557158400"; 
   d="scan'208";a="115813192"
Received: from mail-cys01nam02lp2050.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.50])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2019 07:27:58 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+ejFAyAaDzYV1d6Ah7AhxW1J8PaUIPnCk0+XKPe5fQ=;
 b=ufZypDtlmNv5FqEnVt6+hw6LSNXW3QPIhrfMU/SYansWzyOBUxhy7IgpF5qf9d52DkavlFzFyEmj8yY9Kc1ApgfI2KdidatLerZjf3CG5fyz15NU++Adq2w8LPKqJZ1JFuBqgs2Ldc/AqtuyjXtdikVqCbb7tmchWBR2/Sbl1Ek=
Received: from BYAPR04MB3782.namprd04.prod.outlook.com (52.135.214.142) by
 BYAPR04MB5749.namprd04.prod.outlook.com (20.179.58.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Tue, 18 Jun 2019 23:27:56 +0000
Received: from BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::65e3:6069:d7d5:90a2]) by BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::65e3:6069:d7d5:90a2%5]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 23:27:56 +0000
From:   Atish Patra <Atish.Patra@wdc.com>
To:     "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yash.shah@sifive.com" <yash.shah@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "sachin.ghadi@sifive.com" <sachin.ghadi@sifive.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "palmer@sifive.com" <palmer@sifive.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH v3 0/2] Add macb support for SiFive FU540-C000
Thread-Topic: [PATCH v3 0/2] Add macb support for SiFive FU540-C000
Thread-Index: AQHVJautaYczd+F3bUKX3+FaLXpAT6aiD5AA
Date:   Tue, 18 Jun 2019 23:27:56 +0000
Message-ID: <ecded54c9b7bb7c85f029920db225cf19e1ee325.camel@wdc.com>
References: <1560844568-4746-1-git-send-email-yash.shah@sifive.com>
In-Reply-To: <1560844568-4746-1-git-send-email-yash.shah@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Atish.Patra@wdc.com; 
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dbd639a7-4e7a-43d4-3ca5-08d6f44497fb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5749;
x-ms-traffictypediagnostic: BYAPR04MB5749:
x-ms-exchange-purlcount: 2
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <BYAPR04MB57494C90F4EA518832AB5924FAEA0@BYAPR04MB5749.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6029001)(39860400002)(366004)(376002)(346002)(136003)(396003)(199004)(189003)(256004)(68736007)(2501003)(6436002)(66946007)(72206003)(6116002)(4326008)(3846002)(446003)(118296001)(36756003)(53936002)(5660300002)(76176011)(186003)(14454004)(7416002)(7736002)(81166006)(476003)(73956011)(81156014)(8936002)(229853002)(110136005)(11346002)(54906003)(66066001)(6512007)(6246003)(66476007)(2616005)(64756008)(66446008)(478600001)(2906002)(2201001)(6506007)(6306002)(99286004)(76116006)(6486002)(966005)(66556008)(305945005)(486006)(316002)(26005)(71190400001)(86362001)(102836004)(71200400001)(25786009)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5749;H:BYAPR04MB3782.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pp8xA2wOzSSW1SwycGQhNiZmNbYql1XjRZYQuMemsIToSTkYsBjCZ4+SZ5jfqGChQns1Yd18J3EzvJ7EHoumUpdm7A3KEPPmmiK+03eUjQs93UQa9hRM93OY4L3848nUwed1GxlafT5t/m3psfrZw2j+gfahI0Oo2zkZxvnNWmhQgE3eaIb5NqGnP2v59/eKeTgQ90vFdX1yll/DnEbSDu8goWZWFCLCgfoGMaUZnixUuNnosejkeakM3T8Qo7xncnYMPBs15hs0AT0h2f8+S2ktOocEEhGHQKibl6lVR2EePtIUwW8qaSC2AY2W5c2Q0nCVNNUONrpFV7XElGoTPoB8Y3bV96ppJdz9IOcmIOJAnXNCz+qKmwCA0HQ6xtINArMD+iqei2XWEYBrLrNs+AWtdIHlFicmhS2rQx3BW3c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFC52306D091CA4592F396976E2BC5AD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd639a7-4e7a-43d4-3ca5-08d6f44497fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 23:27:56.3662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Atish.Patra@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5749
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTE4IGF0IDEzOjI2ICswNTMwLCBZYXNoIFNoYWggd3JvdGU6DQo+IE9u
IEZVNTQwLCB0aGUgbWFuYWdlbWVudCBJUCBibG9jayBpcyB0aWdodGx5IGNvdXBsZWQgd2l0aCB0
aGUgQ2FkZW5jZQ0KPiBNQUNCIElQIGJsb2NrLiBJdCBtYW5hZ2VzIG1hbnkgb2YgdGhlIGJvdW5k
YXJ5IHNpZ25hbHMgZnJvbSB0aGUgTUFDQg0KPiBJUA0KPiBUaGlzIHBhdGNoc2V0IGNvbnRyb2xz
IHRoZSB0eF9jbGsgaW5wdXQgc2lnbmFsIHRvIHRoZSBNQUNCIElQLiBJdA0KPiBzd2l0Y2hlcyBi
ZXR3ZWVuIHRoZSBsb2NhbCBUWCBjbG9jayAoMTI1TUh6KSBhbmQgUEhZIFRYIGNsb2Nrcy4gVGhp
cw0KPiBpcyBuZWNlc3NhcnkgdG8gdG9nZ2xlIGJldHdlZW4gMUdiIGFuZCAxMDAvMTBNYiBzcGVl
ZHMuDQo+IA0KPiBGdXR1cmUgcGF0Y2hlcyBtYXkgYWRkIHN1cHBvcnQgZm9yIG1vbml0b3Jpbmcg
b3IgY29udHJvbGxpbmcgb3RoZXIgSVANCj4gYm91bmRhcnkgc2lnbmFscy4NCj4gDQo+IFRoaXMg
cGF0Y2hzZXQgaXMgbW9zdGx5IGJhc2VkIG9uIHdvcmsgZG9uZSBieQ0KPiBXZXNsZXkgVGVycHN0
cmEgPHdlc2xleUBzaWZpdmUuY29tPg0KPiANCj4gVGhpcyBwYXRjaHNldCBpcyBiYXNlZCBvbiBM
aW51eCB2NS4yLXJjMSBhbmQgdGVzdGVkIG9uIEhpRml2ZQ0KPiBVbmxlYXNoZWQNCj4gYm9hcmQg
d2l0aCBhZGRpdGlvbmFsIGJvYXJkIHJlbGF0ZWQgcGF0Y2hlcyBuZWVkZWQgZm9yIHRlc3Rpbmcg
Y2FuIGJlDQo+IGZvdW5kIGF0IGRldi95YXNocy9ldGhlcm5ldF92MyBicmFuY2ggb2Y6DQo+IGh0
dHBzOi8vZ2l0aHViLmNvbS95YXNoc2hhaDcvcmlzY3YtbGludXguZ2l0DQo+IA0KPiBDaGFuZ2Ug
SGlzdG9yeToNCj4gVjM6DQo+IC0gUmV2ZXJ0ICJNQUNCX1NJRklWRV9GVTU0MCIgY29uZmlnIGNo
YW5nZXMgaW4gS2NvbmZpZyBhbmQgZHJpdmVyDQo+IGNvZGUuDQo+ICAgVGhlIGRyaXZlciBkb2Vz
IG5vdCBkZXBlbmQgb24gU2lGaXZlIEdQSU8gZHJpdmVyLg0KPiANCj4gVjI6DQo+IC0gQ2hhbmdl
IGNvbXBhdGlibGUgc3RyaW5nIGZyb20gImNkbnMsZnU1NDAtbWFjYiIgdG8gInNpZml2ZSxmdTU0
MC0NCj4gbWFjYiINCj4gLSBBZGQgIk1BQ0JfU0lGSVZFX0ZVNTQwIiBpbiBLY29uZmlnIHRvIHN1
cHBvcnQgU2lGaXZlIEZVNTQwIGluIG1hY2INCj4gICBkcml2ZXIuIFRoaXMgaXMgbmVlZGVkIGJl
Y2F1c2Ugb24gRlU1NDAsIHRoZSBtYWNiIGRyaXZlciBkZXBlbmRzIG9uDQo+ICAgU2lGaXZlIEdQ
SU8gZHJpdmVyLg0KPiAtIEF2b2lkIHdyaXRpbmcgdGhlIHJlc3VsdCBvZiBhIGNvbXBhcmlzb24g
dG8gYSByZWdpc3Rlci4NCj4gLSBGaXggdGhlIGlzc3VlIG9mIHByb2JlIGZhaWwgb24gcmVsb2Fk
aW5nIHRoZSBtb2R1bGUgcmVwb3J0ZWQgYnk6DQo+ICAgQW5kcmVhcyBTY2h3YWIgPHNjaHdhYkBz
dXNlLmRlPg0KPiANCj4gWWFzaCBTaGFoICgyKToNCj4gICBtYWNiOiBiaW5kaW5ncyBkb2M6IGFk
ZCBzaWZpdmUgZnU1NDAtYzAwMCBiaW5kaW5nDQo+ICAgbWFjYjogQWRkIHN1cHBvcnQgZm9yIFNp
Rml2ZSBGVTU0MC1DMDAwDQo+IA0KPiAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L25ldC9tYWNiLnR4dCB8ICAgMyArDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21h
Y2JfbWFpbi5jICAgICAgIHwgMTIzDQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIDIg
ZmlsZXMgY2hhbmdlZCwgMTI2IGluc2VydGlvbnMoKykNCj4gDQoNCkNhbiB5b3UgYWxzbyBwb3N0
IHRoZSBldGhlcm5ldCBkdCBlbnRyeVsxXSBhbG9uZyB3aXRoIHRoaXMgcGF0Y2ggPw0KSSB0aGlu
ayBpdCB3b3VsZCBiZSBnb29kIHRvIGFsbCB0aGUgZHQgcmVsYXRlZCBzdHVmZiByZXZpZXdlZCB0
b2dldGhlci4NCg0KWzFdIA0KaHR0cHM6Ly9naXRodWIuY29tL3lhc2hzaGFoNy9yaXNjdi1saW51
eC9jb21taXQvNmQzYWY2NGJjNWVmZWQzOTE1ZDY1OGRjM2JmZTgyZGMxZGJmYWZiMw0KDQpJIGFt
IGFibGUgdG8gZ2V0IG5ldHdvcmtpbmcgdXAgaW4gbGF0ZXN0IGtlcm5lbCArIHlvdXIgcGF0Y2hl
cyBpbg0KT3BlblNCSSArIFUtQm9vdCh3aXRoIHVwZGF0ZWQgY29tcGF0aWJsZSBzdHJpbmcpICsg
TGludXggYm9vdGZsb3cuDQoNClRlc3RlZC1ieTogQXRpc2ggUGF0cmEgPGF0aXNoLnBhdHJhQHdk
Yy5jb20+DQoNClJlZ2FyZHMsDQpBdGlzaA0K

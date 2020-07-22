Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4952922961C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732053AbgGVKcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:32:32 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:16520 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731951AbgGVKcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 06:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595413951; x=1626949951;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mSehFQkck53P3sniCiCm7vZp42rPCCjCurLfB43bk68=;
  b=s55h9RZ/eiqYJeelzaIovQ6FneUfnNO6Fk3xUTZ82DC5FLYLwuyIP98b
   KyLzEib5qLUWNhPh1C1t3ERpncAvlXZFcISHNqRncuUHPR5vbYjeLzQ4C
   dSyWqP3EpltJP77EokVLQHQGladzKvKCwfzupyDjT+CwjaTnbvuHxt9AH
   2CCmpZeJbQT28V5J4af3cM/wgpTG5Zxjf73XGqKxLnlHXm41lYqkERGnf
   VSiHJXYB55F2v8tT8pXGky2gHWP4/1YZUG3xrPk/GEqX1LU6PW7q7q6Zr
   kl6+CL3kxiEd3asw/vnKFSBY+jAihUDDoHoz8e87MZnKAF7c15PFkVzZ3
   A==;
IronPort-SDR: EwhPXCwCP7ncbTQJjGCcgGdi3myVqMi1FeVnFyTIiVNCghDmfbMoq2pe3CSdhoGMz2Stcu+XFW
 CEIEmOxidpzRhw7iEX5Ex2XidSVkEgdzfsbekbMUFvXHX8fUpxMWJwCzVPEvWMuV5ZiHf/03tA
 YOkToRt9vFQLoMrrhCh1aYN3hq+frguO3gVX/AZVshaggR4TZR+4P4NCHqZBBR1YchDO4+uuDy
 NMK/pVdBnSQfKM9g9gtc0R/I3/CpRHw04jvBFC2fd9gztMnT4qSFHMOHdleOIFQP5S207Jd8bN
 hTo=
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="84934310"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2020 03:32:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 03:31:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 22 Jul 2020 03:32:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDyyoDDqixq6VoeXRnP1rOwkH+xdh42/4hYRqWPej4fwbEvYE7GB2KFHDLRn4jXkGML6n0sRg6AvVmfU2O/4/i5vcSnb86KgGN8eUc6pZAp9fEZaUQadV8zt5HyGfM4GopZh1UWUgtaerl91KUzKqRUSIiqPEL+juBRFU3rdhKjH4aV0I28WAzxiZsjEMu8YFxJ8tVUK2D6NO62wbBtoDIKPoe77uEfeFfl94UaOMY/1mhEFmtEHcBt0ojpRFBKMIQ96RrPLzdTiJPsmZ9aYSrmWVe7GUZQpFLLKsXzaFCg888qmgDeQV94cjg0z9+wi8k2Z+Mj4bkJSOxj03CFnfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSehFQkck53P3sniCiCm7vZp42rPCCjCurLfB43bk68=;
 b=DrOwkBg3KLvRnd3xKnd0ato/huz534H38nfvpjhbUOg1BvZk6OFXK4tRamZOigc40OmeSMoc3ANoFJnGBqdpkS70hitwZE+tpdzuJXnlCyMLVyaB1mkNvLfoSJsblIb88NH1okwc3yfIaHDjSRWVCynd996ikz4PCu8DiCBO0G2YT/b1pwWHh+RwkP9ULIhbRAixLJcOlNJ6nIJtDEL+L6uqbl2zat5qbKqZAVzAfB7Ln7voYqOhtOc2KAcxH05aB2SBPbQp2rP4ASl3u/J2kin52FjQaHEupgNpI9AYkFSX2MpElDmbtkurL7un3pmPvXrv1xrzvZIi7zZgez4IMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSehFQkck53P3sniCiCm7vZp42rPCCjCurLfB43bk68=;
 b=VtkURXhUW6fkLOWJ6r41QjEuAyUXVlYw+6KDZjVxtaKZiwT7YgDsVFb1PlW++J12NoU4j4S+NEfbXBkdc3X8ENyLRggULQuZI4ltswp+2/xotkDSWhAqBuoenaW9BJP74oHCEzbWqQVGf88fR/qNoDLcj4x+O+dTMYzZ0LW/vxE=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM5PR11MB1579.namprd11.prod.outlook.com (2603:10b6:4:f::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.17; Wed, 22 Jul 2020 10:32:21 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::e8b2:1d82:49d9:f4b]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::e8b2:1d82:49d9:f4b%6]) with mapi id 15.20.3195.025; Wed, 22 Jul 2020
 10:32:21 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <Codrin.Ciubotariu@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <robh+dt@kernel.org>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH net-next v2 0/7] Add an MDIO sub-node under MACB
Thread-Topic: [PATCH net-next v2 0/7] Add an MDIO sub-node under MACB
Thread-Index: AQHWYBNhIyVBpIRYr0OAbjzWw9KOlQ==
Date:   Wed, 22 Jul 2020 10:32:21 +0000
Message-ID: <0ec99957-57e9-b384-425a-ccf0e877f1a1@microchip.com>
References: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
In-Reply-To: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [82.76.227.81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2e53ba4-6a44-4b81-8b77-08d82e2a847e
x-ms-traffictypediagnostic: DM5PR11MB1579:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1579A5A283589FD176C6FFEE87790@DM5PR11MB1579.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9qIws/ko0g8YERoqkd0eS1DBdkNwx2bu9VMEWpz8JtbazDVrg8Ew1o+wqZHGH1ckWueksa62GOCfS4YvHj6LcCMbPJh88C8+qmSJ2ezU+ig/XmwTfw9TM1w5HJEUrx+RuGNEwv1pFS3rf+vkdTr3CfSbTgYaPlTCIfhGM0cpVfewNI7fKHrdsbLAlGfYMWSfQinHz0eVwQJHPVHCUYybGTTQ4Kq6GDzJk4npmL6yH3+WQXox1xOrHWQ7ubajNBxyBWljoGl1umV5Ia3QMthyB8g+OTMg8L93/BV1t7gNp4YvDzF863E1twn9xH/1BwxeZxQauJPb++0yGfdXfjMk5aCLIkhJmwPykFoSE78U7cfdIi3Y04FiZjb+uBCOJ1j3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(136003)(366004)(376002)(346002)(83380400001)(53546011)(26005)(186003)(71200400001)(54906003)(6506007)(2906002)(7416002)(8936002)(478600001)(8676002)(66476007)(66946007)(316002)(91956017)(76116006)(5660300002)(66556008)(110136005)(36756003)(2616005)(66446008)(64756008)(86362001)(6486002)(6512007)(4326008)(31696002)(107886003)(31686004)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ppeUkvwyu5lNlRRMMd/YB4ryvPja6faWbZOSZ3rnaRIZcykR5yQNeYSBrVxHrs0I3BdI7yFrms/D9jFUeQadysVkdBTTMg7Spnb8m53SpADtYOjPLQH2Nyk7PIPfycFwx2aZdUia9MWXtfuYHIiJKWRwH5Pf0EVYoiNmyyEi3O7ncquEv+w8vXkJgcAtVX4AJ65nEQ9hz492DU3uqjlAVxGg42GeZMl1W9vUISyuw4M5+cvqzgAY4oEQyByiKHYisyZNEQ0ENaPdL1sz1nDE7UPipO7TQffHe1Ijm44m2RKCpaf9b2PbQvVy4OdJfdsLfEFwanuc+yEojhWTlRijbS8A3SwvNM04Ulxahv/Y42m0OaJDx3BnjAbt+s+9nL268PxB1WajwcgV8eIUrrEyXwjqW8NkMfPI2lq5Iu+unPkQF0UCWu/l6amSDnyystKdNLOH8Kc1kw8MZcRiemBDZOhDwcoXxWKSaEr14AYLF1U=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3BDC96C2D703544AD0399E97891AAB7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e53ba4-6a44-4b81-8b77-08d82e2a847e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 10:32:21.7775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ie0o4VJubYVxh2O8ev4DHkVc1IWuU1Prhyg7y1DXUiUPSjTC73iYXbGp4wxgNyUZmppCC23FJq0VWhspGwStm5o3Vadavj5eIb5THUzntuU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1579
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIxLjA3LjIwMjAgMjA6MTMsIENvZHJpbiBDaXVib3Rhcml1IHdyb3RlOg0KPiBBZGRp
bmcgdGhlIFBIWSBub2RlcyBkaXJlY3RseSB1bmRlciB0aGUgRXRoZXJuZXQgbm9kZSBiZWNhbWUg
ZGVwcmVjYXRlZCwNCj4gc28gdGhlIGFpbSBvZiB0aGlzIHBhdGNoIHNlcmllcyBpcyB0byBtYWtl
IE1BQ0IgdXNlIGFuIE1ESU8gbm9kZSBhcw0KPiBjb250YWluZXIgZm9yIE1ESU8gZGV2aWNlcy4N
Cj4gVGhpcyBwYXRjaCBzZXJpZXMgc3RhcnRzIHdpdGggYSBzbWFsbCBwYXRjaCB0byB1c2UgdGhl
IGRldmljZS1tYW5hZ2VkDQo+IGRldm1fbWRpb2J1c19hbGxvYygpLiBJbiB0aGUgbmV4dCB0d28g
cGF0Y2hlcyB3ZSB1cGRhdGUgdGhlIGJpbmRpbmdzIGFuZA0KPiBhZGFwdCBtYWNiIGRyaXZlciB0
byBwYXJzZSB0aGUgZGV2aWNlLXRyZWUgUEhZIG5vZGVzIGZyb20gdW5kZXIgYW4gTURJTw0KPiBu
b2RlLiBUaGUgbGFzdCBwYXRjaGVzIGFkZCB0aGUgTURJTyBub2RlIGluIHRoZSBkZXZpY2UtdHJl
ZXMgb2Ygc2FtYTVkMiwNCj4gc2FtYTVkMywgc2FtYWQ0IGFuZCBzYW05eDYwIGJvYXJkcy4NCj4g
DQoNClRlc3RlZCB0aGlzIHNlcmllcyBvbiBzYW1hNWQyX3hwbGFpbmVkIGluIHRoZSBmb2xsb3dp
bmcgc2NlbmFyaW9zOg0KDQoxLyBQSFkgYmluZGluZ3MgZnJvbSBwYXRjaCA0Lzc6DQptZGlvIHsN
CgkjYWRkcmVzcy1jZWxscyA9IDwxPjsNCgkjc2l6ZS1jZWxscyA9IDwwPjsNCglldGhlcm5ldC1w
aHlAMSB7DQoJCXJlZyA9IDwweDE+Ow0KCQlpbnRlcnJ1cHQtcGFyZW50ID0gPCZwaW9BPjsNCgkJ
aW50ZXJydXB0cyA9IDxQSU5fUEM5IElSUV9UWVBFX0xFVkVMX0xPVz47DQp9Ow0KDQoyLyBQSFkg
YmluZGluZ3MgYmVmb3JlIHRoaXMgc2VyaWVzOg0KZXRoZXJuZXQtcGh5QDEgew0KCXJlZyA9IDww
eDE+Ow0KCWludGVycnVwdC1wYXJlbnQgPSA8JnBpb0E+Ow0KCWludGVycnVwdHMgPSA8UElOX1BD
OSBJUlFfVFlQRV9MRVZFTF9MT1c+Ow0KfTsNCg0KMy8gTm8gUEhZIGJpbmRpbmdzIGF0IGFsbC4N
Cg0KQWxsIDMgY2FzZXMgd2VudCBPSy4NCg0KWW91IGNhbiBhZGQ6DQpUZXN0ZWQtYnk6IENsYXVk
aXUgQmV6bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KQWNrZWQtYnk6IENsYXVk
aXUgQmV6bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KDQpUaGFuayB5b3UsDQpD
bGF1ZGl1IEJlem5lYQ0KDQo+IENoYW5nZXMgaW4gdjI6DQo+ICAtIHJlbmFtZWQgcGF0Y2ggMi83
IGZyb20gIm1hY2I6IGJpbmRpbmdzIGRvYzogdXNlIGFuIE1ESU8gbm9kZSBhcyBhDQo+ICAgIGNv
bnRhaW5lciBmb3IgUEhZIG5vZGVzIiB0byAiZHQtYmluZGluZ3M6IG5ldDogbWFjYjogdXNlIGFu
IE1ESU8NCj4gICAgbm9kZSBhcyBhIGNvbnRhaW5lciBmb3IgUEhZIG5vZGVzIg0KPiAgLSBhZGRl
ZCBiYWNrIGEgbmV3bGluZSByZW1vdmVkIGJ5IG1pc3Rha2UgaW4gcGF0Y2ggMy83DQo+IA0KPiBD
b2RyaW4gQ2l1Ym90YXJpdSAoNyk6DQo+ICAgbmV0OiBtYWNiOiB1c2UgZGV2aWNlLW1hbmFnZWQg
ZGV2bV9tZGlvYnVzX2FsbG9jKCkNCj4gICBkdC1iaW5kaW5nczogbmV0OiBtYWNiOiB1c2UgYW4g
TURJTyBub2RlIGFzIGEgY29udGFpbmVyIGZvciBQSFkgbm9kZXMNCj4gICBuZXQ6IG1hY2I6IHBh
cnNlIFBIWSBub2RlcyBmb3VuZCB1bmRlciBhbiBNRElPIG5vZGUNCj4gICBBUk06IGR0czogYXQ5
MTogc2FtYTVkMjogYWRkIGFuIG1kaW8gc3ViLW5vZGUgdG8gbWFjYg0KPiAgIEFSTTogZHRzOiBh
dDkxOiBzYW1hNWQzOiBhZGQgYW4gbWRpbyBzdWItbm9kZSB0byBtYWNiDQo+ICAgQVJNOiBkdHM6
IGF0OTE6IHNhbWE1ZDQ6IGFkZCBhbiBtZGlvIHN1Yi1ub2RlIHRvIG1hY2INCj4gICBBUk06IGR0
czogYXQ5MTogc2FtOXg2MDogYWRkIGFuIG1kaW8gc3ViLW5vZGUgdG8gbWFjYg0KPiANCj4gIERv
Y3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWFjYi50eHQgfCAxNSArKysrKysr
KysrKystLS0NCj4gIGFyY2gvYXJtL2Jvb3QvZHRzL2F0OTEtc2FtOXg2MGVrLmR0cyAgICAgICAg
ICAgfCAgOCArKysrKystLQ0KPiAgYXJjaC9hcm0vYm9vdC9kdHMvYXQ5MS1zYW1hNWQyN19zb20x
LmR0c2kgICAgICB8IDE2ICsrKysrKysrKystLS0tLS0NCj4gIGFyY2gvYXJtL2Jvb3QvZHRzL2F0
OTEtc2FtYTVkMjdfd2xzb20xLmR0c2kgICAgfCAxNyArKysrKysrKysrLS0tLS0tLQ0KPiAgYXJj
aC9hcm0vYm9vdC9kdHMvYXQ5MS1zYW1hNWQyX3B0Y19lay5kdHMgICAgICB8IDEzICsrKysrKysr
LS0tLS0NCj4gIGFyY2gvYXJtL2Jvb3QvZHRzL2F0OTEtc2FtYTVkMl94cGxhaW5lZC5kdHMgICAg
fCAxMiArKysrKysrKy0tLS0NCj4gIGFyY2gvYXJtL2Jvb3QvZHRzL2F0OTEtc2FtYTVkM194cGxh
aW5lZC5kdHMgICAgfCAxNiArKysrKysrKysrKystLS0tDQo+ICBhcmNoL2FybS9ib290L2R0cy9h
dDkxLXNhbWE1ZDRfeHBsYWluZWQuZHRzICAgIHwgMTIgKysrKysrKystLS0tDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jICAgICAgIHwgMTggKysrKysrKysrKysr
LS0tLS0tDQo+ICA5IGZpbGVzIGNoYW5nZWQsIDg2IGluc2VydGlvbnMoKyksIDQxIGRlbGV0aW9u
cygtKQ0KPiA=

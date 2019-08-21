Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D98984DA
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 21:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbfHUTxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 15:53:34 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:64762 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbfHUTxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 15:53:34 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Woojung.Huh@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Woojung.Huh@microchip.com";
  x-sender="Woojung.Huh@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  a:mx1.microchip.iphmx.com a:mx2.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Woojung.Huh@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Woojung.Huh@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: r6BS1izEprEtkSfQ5nuPMD4YlFQuzgxWoqbvaUfHIZbTOy6qPS10KHwfugqaCtqTWj813H/kt3
 v7zDvsOTlfdmQl8zP2WERTGUUDXcwlFcPFExapWwaA2w+MG5nUW2dsfYj4aTRFyt6wCZqiBWlq
 Q/62b2aqRatK4bGi1vp+PSa3lqK4fBasJ6Hu6GGVAvfNywoQIVFl0yHaxCNdBxM6xiTiF8KR4h
 Gpjn2FpuSzI825v/MTF4ZO/BZjx+60F2RweUm/jqWfOfpetW1KgPnDIPiUqHs3mXHW9HrNUTcf
 kdI=
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="43149377"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Aug 2019 12:53:33 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 21 Aug 2019 12:53:31 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 21 Aug 2019 12:53:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cud+nZz1ehW/tWqvzVaERKfieWDD35P6YtobtN8UX8UDFkDu6mLrsDLoyyI2kM6MNUCDPa6QJW06o2MBZnhXXeaWknkL8nvfHzcvGRqvtASoJj9SHZabPz2HeetPdZ6MKaGc5zM5vGGH7FGZuveTrnR+bAWf/E4Ytc5jKfEW0C2gVsGsFHotv14EilPwPFrXsPjvp1Rgwgs35p2f8d6MFd7Fsv3nC9Jpp25UlifX2UVdl4imvF3mCLAGJuNDGGoBy2AT1Q6M4GgxyP1hWeEkhuf9qaGok9hq8H0Xa8OyWPizVzXCI0bCKSkwwHygOWndf3BHPrLkXvhJNFr55yFqxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoTvRfljh9/3y49b5uKUVZQP6fAXzcWuHT8I1rnIHLI=;
 b=lcmI2gr8cCDA4a+7nn0keeVUOFOj/caCu9qTBab5hertiHKXwJf0SLG5nRr/JJyyD6kLE50oLi2h6VVFLnhq6Qnfwbsnu4CFcHwggAh280OV4dItx0Jp6FGEjSLK/SFXM4ZSuXwhdtZTlmZok0AK/W7YeOMw+4Pnkcw/2ZpQp2LCJDxXP0Ma66pYMrFVGo1wYCnSaqM7mv44RIz/iMsCoD4CB9+2Pr7VVkYH1kUD6Th3n1y3ARvVbuotfO539pU0lKum9gTF4XjNpguiJJJ60VlVugmT3xhLf4Liq9AIRTHfho3G1iqRLLUPS4sdIWGcSPSWWAUcm69z0D9jeLb4MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoTvRfljh9/3y49b5uKUVZQP6fAXzcWuHT8I1rnIHLI=;
 b=icsZDo6hpxKfrhdGLHae4B9rngVHiJ7W9fLuYqJUU9idlMH8a7JGhp2v9Bi7wXFdNJ0yq3febDWUr8QQIH9WSJVzjmCpJQVCHZvtjIDzGbw8QRMui7kdLB3SYiz1nQ6xoikYNi4/tMtTTP0he+KTf+Llvp3DahBbV3jlgrdXzX0=
Received: from BL0PR11MB3012.namprd11.prod.outlook.com (20.177.204.78) by
 BL0PR11MB3474.namprd11.prod.outlook.com (10.167.234.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 19:53:29 +0000
Received: from BL0PR11MB3012.namprd11.prod.outlook.com
 ([fe80::8853:e70a:1179:5fa9]) by BL0PR11MB3012.namprd11.prod.outlook.com
 ([fe80::8853:e70a:1179:5fa9%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 19:53:29 +0000
From:   <Woojung.Huh@microchip.com>
To:     <Allan.Nielsen@microchip.com>, <f.fainelli@gmail.com>
CC:     <u.kleine-koenig@pengutronix.de>, <Nicolas.Ferre@microchip.com>,
        <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <kernel@pengutronix.de>, <hkallweit1@gmail.com>,
        <Ravi.Hegde@microchip.com>, <Tristram.Ha@microchip.com>,
        <Yuiko.Oshino@microchip.com>
Subject: RE: net: micrel: confusion about phyids used in driver
Thread-Topic: net: micrel: confusion about phyids used in driver
Thread-Index: AQHVBqZnczi/KVB+tEa6R2+NBZWvoKZjRcWAgAADbYCAAKvSgIBUKAwAgAAGD0CAOVhcgIAToemAgAFf6ACAABfQAIAAEPzQ
Date:   Wed, 21 Aug 2019 19:53:29 +0000
Message-ID: <BL0PR11MB3012CC53F680EDF4C5146652E7AA0@BL0PR11MB3012.namprd11.prod.outlook.com>
References: <20190509202929.wg3slwnrfhu4f6no@pengutronix.de>
 <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
 <20190509210745.GD11588@lunn.ch>
 <20190510072243.h6h3bgvr2ovsh5g5@pengutronix.de>
 <20190702203152.gviukfldjhdnmu7j@pengutronix.de>
 <BL0PR11MB3251651EB9BC45DF4282D51D8EF80@BL0PR11MB3251.namprd11.prod.outlook.com>
 <20190808083637.g77loqpgkzi63u55@pengutronix.de>
 <20190820202503.xauhbrj24p3vcoxp@pengutronix.de>
 <1057c2c2-e1f0-75ba-3878-dbd52805e0cc@gmail.com>
 <20190821184947.43iilefgrjn4zrtl@lx-anielsen.microsemi.net>
In-Reply-To: <20190821184947.43iilefgrjn4zrtl@lx-anielsen.microsemi.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cbada34d-7738-444f-59e6-08d726713d4b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BL0PR11MB3474;
x-ms-traffictypediagnostic: BL0PR11MB3474:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB34743FBD895EE75963465E6AE7AA0@BL0PR11MB3474.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(136003)(376002)(346002)(53754006)(189003)(199004)(7696005)(14454004)(76176011)(256004)(26005)(186003)(66066001)(478600001)(33656002)(71200400001)(476003)(99286004)(102836004)(11346002)(6506007)(74316002)(316002)(446003)(7736002)(9686003)(86362001)(6246003)(66946007)(66476007)(305945005)(55016002)(66446008)(64756008)(66556008)(4326008)(25786009)(71190400001)(52536014)(486006)(3846002)(6116002)(4744005)(8936002)(110136005)(54906003)(53936002)(8676002)(229853002)(81156014)(5660300002)(76116006)(107886003)(6436002)(2906002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR11MB3474;H:BL0PR11MB3012.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZPelGAHjZCAgNnog0hnmtP7yYc+DT+SHX7f5JuCHRIiqyNYjGGcRtLsRPAPwTPyejQPeGtYxgcC2DFT4/jSFqXX3X3ywl5wlAoqf0R6RwR7ihGSshypg2Z/Ah2HDdCjh+D6wb6IBnI9Dajbk0cTnakm73iOkjGUcga8XOb9H2tzCEv2puEiLGr8kdre0ZYsxZtnT9umJxybQ0VF2BwJ8IcteDSO8Dzeu28pEmgaA4Gf3UF5Q45RFKvEuF+2cvdFw4kNDwXW3UMPPwwA4kalxyRFJn/wVZqraODBdSzNxvbxC2KsOdV5kjJ2eHi0Cw1ORcA2rJvlPJ5ejNQpTn82Ht7FHaHY6Um8xy6OEhgokG0xpZFxPq7gzEu3pFRAjgX7SX/mTtFXCV1hSk2P9YCogqVgqP9yoZ3j2ndE3iIIo7ng=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cbada34d-7738-444f-59e6-08d726713d4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 19:53:29.5344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6RtJjYaNAGLyJUlj4JkzotoPQ+F+YiIaZPgHE0tfAzs5K8dc71n84FqN9x5HImNVwU0QjXQ1g6+Y68d6p6lIPLDghG4xD172cnFLTk2+vyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3474
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsYW4gJiBGbG9yaWFuLA0KDQo+ID4gPiBTbyB3ZSdyZSBpbiBuZWVkIG9mIHNvbWVvbmUg
d2hvIGNhbiBnZXQgdGhlaXIgaGFuZHMgb24gc29tZSBtb3JlDQo+ID4gPiBkZXRhaWxlZCBkb2N1
bWVudGF0aW9uIHRoYW4gcHVibGljbHkgYXZhaWxhYmxlIHRvIGFsbG93IHRvIG1ha2UgdGhlDQo+
ID4gPiBkcml2ZXIgaGFuZGxlIHRoZSBLU1o4MDUxTUxMIGNvcnJlY3RseSB3aXRob3V0IGJyZWFr
aW5nIG90aGVyIHN0dWZmLg0KPiA+ID4NCj4gPiA+IEkgYXNzdW1lIHlvdSBhcmUgaW4gYSBkaWZm
ZXJlbnQgZGVwYXJ0bWVudCBvZiBNaWNyb2NoaXAgdGhhbiB0aGUgcGVvcGxlDQo+ID4gPiBjYXJp
bmcgZm9yIFBIWXMsIGJ1dCBtYXliZSB5b3UgY2FuIHN0aWxsIGhlbHAgZmluZGluZyBzb21lb25l
IHdobyBjYXJlcz8NCj4gPg0KPiA+IEFsbGFuLCBpcyB0aGlzIHNvbWV0aGluZyB5b3UgY291bGQg
aGVscCB3aXRoPyBUaGFua3MhDQo+IFNvcnJ5LCBJJ20gbmV3IGluIE1pY3JvY2hpcCAod2FzIGFx
dWlyZWQgdGhyb3VnaCBNaWNyb3NlbWkpLCBhbmQgSSBrbm93IG5leHQgdG8NCj4gbm90aGluZyBh
Ym91dCB0aGUgTWljcmVsIHN0dWZmLg0KPiANCj4gV29vanVuZzogQ2FuIHlvdSBjb21tZW50IG9u
IHRoaXMsIG9yIHRyeSB0byBkaXJlY3QgdGhpcyB0byBzb21lb25lIHdobyBrbm93cw0KPiBzb21l
dGhpbmcuLi4NCg0KRm9yd2FyZGVkIHRvIFl1aWtvLiBXaWxsIGRvIGZvbGxvdy11cC4NCg0KVGhh
bmtzLg0KV29vanVuZw0K

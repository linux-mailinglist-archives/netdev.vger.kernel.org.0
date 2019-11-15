Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3697BFD7FC
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 09:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfKOIbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 03:31:32 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:3625 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfKOIbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 03:31:32 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Claudiu.Beznea@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="Claudiu.Beznea@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Claudiu.Beznea@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: o2y3XXbT/isioqQCANZ4xBENq+33qaB1x9Ppz/zsZ1qtUb7P2j5JEwIqKF6pyc0i3z3iKWKkRP
 eI+myIF6xuoq5RmsyS1kKKLPGrsNIrEaBBTkO2LMqOPYehMKyxSgTmTkttruSA95wi3U1p7RTN
 nUTF+hT2NPiGi2TbNEt1syMWzxiPq1AzTeTZ9q+rK9/nv532lpiacIc1hx/GV/XslfcftFUxwQ
 6mLsH3RR+G/WQnTgDVna5pFASTDsaLMu5GNFgdB7g5/gWkf7RaLkQdC5cCl5u7+C0/MqR1YtpS
 Xzw=
X-IronPort-AV: E=Sophos;i="5.68,307,1569308400"; 
   d="scan'208";a="54454410"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Nov 2019 01:31:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 15 Nov 2019 01:31:26 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Fri, 15 Nov 2019 01:31:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Is9tsvoUPkVyA2FFwVohgYdsmsYkoxqQKyk5NCowHh9RM6gfnTh5T65m92UlY6eXCUdCJk9XwMBEHoTmbzeekrOHFN1IZYcw3cPS4q+uss1jXNUM1sFG23EgzhORB0pkRsN+q3uCsGGKXahedliPv96mZQRIeDv2nvdotAlzubWfMGDDBJpTaS0sVEeJP75chprw0QQWSiyTjjSjkReCQGYLRF7cerLhFKz0lYdJSZg5vwMHeDRp0LKRqfcOdRjOadTNUrAfZKMRMi7Vr/qz5IPdjJAdE15CYwX2lTDQrj/D3elzg254vZdj3hKeTV+vQgapRvBy+gAp0fypTqrkYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H08rhQb/iDyiRRvASB84ZEd18CM2SUAHVpOjqRI1zrc=;
 b=FmdiqBXQbKTQYaf2ekTq/JFAgj7QEXsP/Ipda3RucE/d6xLsib/ZF+ZNLwXSXtTyeG1VXPZ1WMn8z+XF4eNd+Wl6XJmL0DKBq9B/9LUBcqFQvuXmegKQUEoDzbJfe1Vr/KlrmBUvBKqVLOH0RxtZl6mEBDjeEDNJN2G7+o52Up+nLEWgjmMlOFx0+COiwaFcOPIZZmGfe0onXQlFIWi/jGqQSoC1R56goTKLj2VXGVb4+ibaeElbeRU7W2TfLGqBEdTZtJ+Y0yLm7XCLIJgOvV3zgJcoAEF60hTjZOSLbu22K/G+sYhGwotpBvCe/r9UC76QqJlaQ6jUKyh1J/dONw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H08rhQb/iDyiRRvASB84ZEd18CM2SUAHVpOjqRI1zrc=;
 b=J1fHAM/KrrQlQ8e3nrYWu4NPKNZGDXDZSmG1qy9HDYzSw4q1CLw1YzSoT6uBgvJkOq+0c9OxUeu4ePekJj82KCudOjcoTXjFMQGi8g7YEHILMpAtv1JNqy4ZkrHjASO1d+MVf9IvyJwBs4T/w3SJ5GmTWPgeDTOV7LuqBQAHkzc=
Received: from BYAPR11MB3224.namprd11.prod.outlook.com (20.177.127.88) by
 BYAPR11MB2696.namprd11.prod.outlook.com (52.135.226.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 15 Nov 2019 08:31:25 +0000
Received: from BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::f4eb:2c83:7aec:ee98]) by BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::f4eb:2c83:7aec:ee98%3]) with mapi id 15.20.2451.029; Fri, 15 Nov 2019
 08:31:25 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <hslester96@gmail.com>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: macb: add missed tasklet_kill
Thread-Topic: [PATCH] net: macb: add missed tasklet_kill
Thread-Index: AQHVm48R1lX7YGSggE21FUz940bweA==
Date:   Fri, 15 Nov 2019 08:31:25 +0000
Message-ID: <9d370a0a-95af-59f8-4ebf-7775cd44d8a0@microchip.com>
References: <20191115023201.7188-1-hslester96@gmail.com>
In-Reply-To: <20191115023201.7188-1-hslester96@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR07CA0021.eurprd07.prod.outlook.com
 (2603:10a6:205:1::34) To BYAPR11MB3224.namprd11.prod.outlook.com
 (2603:10b6:a03:77::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20191115103117099
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7622617-578f-4b64-cf4e-08d769a633ac
x-ms-traffictypediagnostic: BYAPR11MB2696:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB269685FF609FF197DF72FD8287700@BYAPR11MB2696.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:126;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(396003)(39860400002)(376002)(199004)(189003)(51444003)(25786009)(81166006)(6246003)(6486002)(1411001)(14454004)(54906003)(256004)(71200400001)(71190400001)(229853002)(6916009)(486006)(6512007)(4326008)(52116002)(31686004)(66476007)(2616005)(64756008)(66556008)(446003)(66446008)(7736002)(4744005)(5660300002)(6436002)(76176011)(36756003)(66946007)(11346002)(305945005)(8936002)(86362001)(8676002)(316002)(53546011)(66066001)(478600001)(6506007)(386003)(476003)(3846002)(6116002)(102836004)(31696002)(2906002)(186003)(99286004)(26005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2696;H:BYAPR11MB3224.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xReTOKv3b/Vf4tfRCUQ33S+hQzSOpZfofmb98+LbIJ82z+ja06JyO6NLIZ42Xx2pny3HipORmh7m1nDTsYJZR0awBuyY7OOouPlLTmbvtDoIb0146JjaIM572IJX11KCGUWgq+C0WdjMhLkatRBP7z13X5vO18x5tePX31b2goXeK8/J7PeB2TNoiwhkkn6PNDd9+opChky+paVJ7uiuEMsMLRo0kA4fN7faAXKQDzIPCtIpzJ/WEapob6wu1KTYOUf1oi2L2R4rTFelH8rmXe82ZfrIG4ImAJVhiRR1+cCZqSxXmhpbgT6PNrLCPWI11EhuxPbj9xTEZjFbZm1BAxtgTCBquQuM3vlFdqOs2x3kGmp/oYAM1UQ0B4llAabW2pVCX5Bnnhf77zPlKn0lLYUVby+iErE6QfghtHmKjkyY/ugHJWLFnRjbgDqASOlC
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3995A0EDB3B374EB655B3E85ACA7A2B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c7622617-578f-4b64-cf4e-08d769a633ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 08:31:25.0594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KL3BVRMKi8vrflpIU/jpGomwqayhNBmAYu+7xhZ7iQcErrXFPuCxPot9OgI+t3a+00xclFXLEpMlcWgJx+xWCUxu1JMVHt4j/2Wqiis2jDg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2696
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDE1LjExLjIwMTkgMDQ6MzIsIENodWhvbmcgWXVhbiB3cm90ZToNCj4gVGhpcyBkcml2
ZXIgZm9yZ2V0cyB0byBraWxsIHRhc2tsZXQgaW4gcmVtb3ZlLg0KPiBBZGQgdGhlIGNhbGwgdG8g
Zml4IGl0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2h1aG9uZyBZdWFuIDxoc2xlc3Rlcjk2QGdt
YWlsLmNvbT4NCg0KSSB0aGluayB0aGF0IHlvdSBuZWVkIHRvIHJlYmFzZSBpdCBvbiBsYXRlc3Qg
bmV0LW5leHQuIE90aGVyIHRoYW4gdGhpczoNCg0KUmV2aWV3ZWQtYnk6IENsYXVkaXUgQmV6bmVh
IDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEg
aW5zZXJ0aW9uKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2Fk
ZW5jZS9tYWNiX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWlu
LmMNCj4gaW5kZXggMWUxYjc3NGUxOTUzLi4yZWM0MTYwOThmYTMgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBAQCAtNDM4Myw2ICs0MzgzLDcgQEAg
c3RhdGljIGludCBtYWNiX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAN
Cj4gICAgICAgICBpZiAoZGV2KSB7DQo+ICAgICAgICAgICAgICAgICBicCA9IG5ldGRldl9wcml2
KGRldik7DQo+ICsgICAgICAgICAgICAgICB0YXNrbGV0X2tpbGwoJmJwLT5ocmVzcF9lcnJfdGFz
a2xldCk7DQo+ICAgICAgICAgICAgICAgICBpZiAoZGV2LT5waHlkZXYpDQo+ICAgICAgICAgICAg
ICAgICAgICAgICAgIHBoeV9kaXNjb25uZWN0KGRldi0+cGh5ZGV2KTsNCj4gICAgICAgICAgICAg
ICAgIG1kaW9idXNfdW5yZWdpc3RlcihicC0+bWlpX2J1cyk7DQo+IC0tDQo+IDIuMjQuMA0KPiAN
Cj4gDQo=

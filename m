Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568289E924
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbfH0NWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:22:32 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:57314 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfH0NWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 09:22:31 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Razvan.Stefanescu@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Razvan.Stefanescu@microchip.com";
  x-sender="Razvan.Stefanescu@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Razvan.Stefanescu@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Razvan.Stefanescu@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: Xny7/OdC3qAqJfpAiQeBKy84eqkNZr1GSMZ244OpgcpThqlrKchPsgu220dTeq+gPsr3ONPjCP
 05C//VzYwNQQ5gHZbtwk8ZWe0cf4MmKeFYncJ5tQXlGuNEquvA+Nd7u1jApeL6n4ASoBMCsYr0
 XlQagfyOdh2QtUERcLPaB6bVGVhUX606d/DQV3L2SZKCGZfbVGYoUTC3FmJrfdCa7HATcRrc/D
 8vO/uVflaU4rvSJYd5+Wtx8AaPL8Y5AdNXSLzUj2x5qH/mTva/r3wFUEENXeuAzvfsAEUTI5PW
 M4s=
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="46754491"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Aug 2019 06:22:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 27 Aug 2019 06:22:30 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 27 Aug 2019 06:22:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVDSKERoxXZTHExT2MGBufaYn4yQDjOV5zREA+A7ho6yLALWnq3xeHB6Wo02HAKfIwsY/8Cky4H2fsv9wJ5wiGGMA1UCQoetHWjvN/iXnp6dasMq3nDjfDxPnnQjzNmo77YbcSmK8euiu2hQmZuw93n/wNdcXGLKMhZyJeOLkEAnaeIf210nQa03yO1SldTLl92YvoD1nhLyyjHupKhXaFuEUbI+YJgqt7S+yaDRfIRrZMICo0bCsAbkUudfEhV1qYsXsDuUibJ7dvo3Vf+QnxV9+XS0Jf/YoaqAtDoHJRtQRuk9fCJtksoOklEvX0NsMsz3asff6jLM7D9JlaBLcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTYPGKtulfipsMrGPtPCcooCdnLz4AqEo1GIJOyIamk=;
 b=SlBvpPE3kh3GW1/vM5dMG/mXvbAx6j0jWNienS5blr56z1YVyM0P38ZYhww0iHl3H4B3/Vkv54AA5rHfDowZb31PgjUFIS6B5mBG1IWFwX6/u7XAP7I+BXmsZXPsNEmydmnNY00TMnUuQ+4BJSpdsYerkwvTrj9Gl7nw5p2Hs0tMtWEGfvaSJnjqkydSwyTBqxsiDQPrlxaoH+x2AVegTXt68aWSXH5reHT7KRMDcDez7IpN0S1tbP5mTV3z2tBkJW2vHG0nkvt7PmqrXb/fZ8eP/50wC0o5pZTHeUgPoZo/oyuUz73VATaVMY+snzfHokX7avu5rs/QmAwc6AqCoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTYPGKtulfipsMrGPtPCcooCdnLz4AqEo1GIJOyIamk=;
 b=CiMudKAROQBnAh+g/BRXldAIICiMN2TNLH2Kyvy9uYuaa2T6I9Cp6tBmK6W25JBBIl6GfLfZu7dfeNok1UyLT1EFv6B4hBkSZqPz4T6dywL6Qp8KP/VJYRS89dl42HYiSoJ4tjVOkDf/KPMbtMycqCudd2D6DfK9/polEOtRrWQ=
Received: from MWHPR11MB1358.namprd11.prod.outlook.com (10.169.233.136) by
 MWHPR11MB1711.namprd11.prod.outlook.com (10.169.235.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 13:22:26 +0000
Received: from MWHPR11MB1358.namprd11.prod.outlook.com
 ([fe80::6cfc:6aaf:c384:acae]) by MWHPR11MB1358.namprd11.prod.outlook.com
 ([fe80::6cfc:6aaf:c384:acae%4]) with mapi id 15.20.2199.021; Tue, 27 Aug 2019
 13:22:26 +0000
From:   <Razvan.Stefanescu@microchip.com>
To:     <andrew@lunn.ch>
CC:     <Woojung.Huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] net: dsa: microchip: fix interrupt mask
Thread-Topic: [PATCH 3/4] net: dsa: microchip: fix interrupt mask
Thread-Index: AQHVXNZAIF7P9e/OfE+nI+8hAaFN9qcO+zkA
Date:   Tue, 27 Aug 2019 13:22:26 +0000
Message-ID: <f54e1c98-e2db-2c63-4bd9-d1576f94937b@microchip.com>
References: <20190827093110.14957-1-razvan.stefanescu@microchip.com>
 <20190827093110.14957-4-razvan.stefanescu@microchip.com>
 <20190827125135.GA11471@lunn.ch>
In-Reply-To: <20190827125135.GA11471@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0411.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::15) To MWHPR11MB1358.namprd11.prod.outlook.com
 (2603:10b6:300:23::8)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa7e1132-6baf-43ec-1cdb-08d72af19a49
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1711;
x-ms-traffictypediagnostic: MWHPR11MB1711:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB17112E3C334DCBF6E754FF0CE8A00@MWHPR11MB1711.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(199004)(189003)(476003)(486006)(81166006)(81156014)(8676002)(6916009)(54906003)(76176011)(4744005)(256004)(26005)(7736002)(2906002)(31696002)(66066001)(99286004)(229853002)(8936002)(66556008)(64756008)(66446008)(66476007)(186003)(66946007)(52116002)(71200400001)(71190400001)(6246003)(53936002)(2616005)(36756003)(25786009)(5660300002)(386003)(305945005)(102836004)(6506007)(53546011)(3846002)(6116002)(6512007)(4326008)(11346002)(498600001)(446003)(6436002)(6486002)(31686004)(14454004)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1711;H:MWHPR11MB1358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QSZkOOn8nPAwVQRjbrjsXZWAEUihECNVCScopxxbre2mB+mO5MgqE0lK0OwCQD0HKhoeB7mKXYosDmB51MBvlE5bZ+MdTA1gpWu1I6NxjToRoSkvF1wFyKOQ2dDucryvrXzEbQiw7EFOfzo3jiLu9ImgGTywLzHY/6UWYozdE4+QLPckXSI5Bb12VoRiU8AG+jS87Df18dqdwxDsRobbo057JHQGEzFgHw10iTIrLB6aEgfn94mBLlMAv9mXIBi7XPnAFzj1ADuq79b0pvPnCafithuBFWfngUwsoylvZUT6KSO7qIExnixcLIZ+ZdbD5b6YuCaDJ2hEJWYdC9ADG9fwHTR1EeytmrfnjAeafsGKbInMe+FI8C1G471PZAb8XWlYuFU8Yf/wMy2XSvfP8AaYyENcptsIYHrTg9ah1YI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81490BEDD54C2E47A2E40F83A2F7260F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fa7e1132-6baf-43ec-1cdb-08d72af19a49
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 13:22:26.3400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XyZH8zXrKwqdvbva+ix2/3fSIk00eVrCiRKRMACmRoTJw/Uzoir/MhWGaYq3zPMHc9NMc1OsFB2wz2rbUDpj6nFuCpu1GgG3Wbf1jzP/Qu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1711
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDI3LzA4LzIwMTkgMTU6NTEsIEFuZHJldyBMdW5uIHdyb3RlOg0KPiANCj4gT24gVHVl
LCBBdWcgMjcsIDIwMTkgYXQgMTI6MzE6MDlQTSArMDMwMCwgUmF6dmFuIFN0ZWZhbmVzY3Ugd3Jv
dGU6DQo+PiBHbG9iYWwgSW50ZXJydXB0IE1hc2sgUmVnaXN0ZXIgY29tcHJpc2VzIG9mIExvb2t1
cCBFbmdpbmUgKExVRSkgSW50ZXJydXB0DQo+PiBNYXNrIChiaXQgMzEpIGFuZCBHUElPIFBpbiBP
dXRwdXQgVHJpZ2dlciBhbmQgVGltZXN0YW1wIFVuaXQgSW50ZXJydXB0DQo+PiBNYXNrIChiaXQg
MjkpLg0KPj4NCj4+IFRoaXMgY29ycmVjdHMgTFVFIGJpdC4NCj4gDQo+IEhpIFJhenZhbg0KPiAN
Cj4gSXMgdGhpcyBhIGZpeD8gU29tZXRoaW5nIHRoYXQgc2hvdWxkIGJlIGJhY2sgcG9ydGVkIHRv
IG9sZCBrZXJuZWxzPw0KDQpIZWxsbywNCg0KRHVyaW5nIHRlc3RpbmcgSSBkaWQgbm90IG9ic2Vy
dmVkIGFueSBpc3N1ZXMgd2l0aCB0aGUgb2xkIHZhbHVlLiBTbyBJIGFtIA0Kbm90IHN1cmUgaG93
IHRoZSBzd2l0Y2ggaXMgYWZmZWN0ZWQgYnkgdGhlIGluY29ycmVjdCBzZXR0aW5nLg0KDQpNYXli
ZSBtYWludGFpbmVycyB3aWxsIGJlIGFibGUgdG8gbWFrZSBhIGJldHRlciBhc3Nlc3NtZW50IGlm
IHRoaXMgbmVlZHMgDQpiYWNrLXBvcnRpbmcuIEFuZCBJIHdpbGwgYmUgaGFwcHkgdG8gZG8gaXQg
aWYgaXQgaXMgbmVjZXNzYXJ5Lg0KDQpCZXN0IHJlZ2FyZHMsDQpSYXp2YW4NCg==

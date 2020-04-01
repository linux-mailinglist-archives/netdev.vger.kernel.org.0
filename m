Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B71B19A691
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 09:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731968AbgDAHvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 03:51:04 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:55120 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730426AbgDAHvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 03:51:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1585727463; x=1617263463;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xyOGMOkFbFXBYV/0h98KFIzzgltfZyPCzPOGrobzedg=;
  b=pkfQ/rThTO3pxU/8dZZcGxh3Tn0Eni8epfF2rPwPvZfI1ikTgak5695/
   xnF3v3KwEvNHtWA+kTfQh9NPEE662gcP/sCPdRvXN7T4feoYTgnAlBtdp
   md4QHGqSRCpfm6NX3RXy0nOm5kh3S3MCZu3jUtA5xX2DL0n7SR6NfXf1F
   oafSkRUiELjdv+tqnwWPv3dIpq/bTuQCEmbp5jn9Hf/qL4B6kzJhLPA3y
   GVpeKMg8jRRMSwoUZOQEU7s/z02ERJvfMwfBv1KHbjdojfymiRg61y2lY
   GTI9RphfqHQlxGKZlj7wTiIVaQDMcNegizoTk1kBdwJxXltO9zfCe4agL
   A==;
IronPort-SDR: o4UZu/PqwrW1/ckZK4vf1XrQZPdpcV0xAXPqv4WjMKg4XKCEXz0dXp4fHQevCjSZ8ZJbTb6+Wo
 OHMSmwHO3i8LtyRzxQwRNg52YC/nIWV9TJqfhEv4PXF48iulYX3M/FHoryofOoQxq/QrSQ2lJn
 TZQyrbE6u0mc0lkftSkn8Vp3Q4hGhJp+zBgrAecYKOBRBPrvvjss2/YnZbJXWggrkL0IP2QiR/
 /uExEnGv/l7+UIGQTc/nXlhmNFuT/vyV5c2zQzxPZeOpGMX6ivCGfuNE9CZweQcxTqpQxYelOS
 nVI=
X-IronPort-AV: E=Sophos;i="5.72,330,1580799600"; 
   d="scan'208";a="7695485"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2020 00:51:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 1 Apr 2020 00:51:01 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Wed, 1 Apr 2020 00:51:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vh9T3dSFem7xA2/q4mEgS4KEOgeymQvn08JQ96RQdvdmDzpEv4KIxBdkffm5HKDKdGiOYmjfXeiJco2hmH8H3mO94dfP3rXuvNS0EjA9PFwk5pdLizD+QhDg7g2XzIyfwqLEPxvCGs9CE0Z6U4ngZ/1Hgjd1fQL6G2eRTgtXzHcK6NJEOa6JuTf+NylAZ4X/XdW+Ur9thjM0ug+9/dnCKcusLiE/bIzsbjLQds/7uKKxBh+i3/SJXiCyFawYCwQyfrDm/EZuNExmdGpeEDYEnsd5q9vsf2OFOPoau2zNnCWGemEkKbfxstDjQzrx/1eguuwlCHUDEVPRs7ZsGtfaGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyOGMOkFbFXBYV/0h98KFIzzgltfZyPCzPOGrobzedg=;
 b=TU0ByHmNjHFdQg3PkNsqaLPQHuhqVOqsfx218uSOLxRlFYmoE9qqWG0tJMEricH4+FnDLSIt874+yuWRooWmS/Y1nn7s+VZAMuT95fVVVUBt2RXzrGxStF6wHdbp4/B+9Rydrnii17rq+KE+iAKX6UgJrw3rIawN8eJCYsuFGxWHzXEQMbfsAlIXXSGSVlM9XPp6/1qVsp49r03/xo0GkGZ1MqVwJbCMNzyWt6NKFYCcsc9fcFOBz1Sjsz1XphrWJlRGRU5Afw7Eokwqr2t7e6HCIhDmbdRqpPU20PGHMeJdTc7y6XTyLF5qk1dxIlgI3JtT7aWCBsUC379byvVOKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyOGMOkFbFXBYV/0h98KFIzzgltfZyPCzPOGrobzedg=;
 b=ITytz5uZ21USFEv7k+6xKqqs03hurcLRS1TnuRDjVsIY7FLxEy50a6oBvJz7jmDvgC0hFxIsCwo6TgME9IPSvuGbTsjQA83keyR716FrgiuF9J3tlxWKEgfCd473xa3E96g85O3ZTtjtoae9363Hb0rQyIcU2zjIinpO6K3OfX4=
Received: from BY5PR11MB4497.namprd11.prod.outlook.com (2603:10b6:a03:1cc::28)
 by BY5PR11MB4021.namprd11.prod.outlook.com (2603:10b6:a03:191::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 07:50:58 +0000
Received: from BY5PR11MB4497.namprd11.prod.outlook.com
 ([fe80::114b:fdb3:5bf5:2694]) by BY5PR11MB4497.namprd11.prod.outlook.com
 ([fe80::114b:fdb3:5bf5:2694%5]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 07:50:58 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>
Subject: Re: [PATCH] net: mdio: of: Do not treat fixed-link as PHY
Thread-Topic: [PATCH] net: mdio: of: Do not treat fixed-link as PHY
Thread-Index: AQHWBqykuJ0v/jHHYESe6xUz4L35r6hhU7EAgAAOiACAAQRNgIAARHUAgAE8MwA=
Date:   Wed, 1 Apr 2020 07:50:58 +0000
Message-ID: <12cdbe77-b932-9194-5d5e-5058622cef6c@microchip.com>
References: <20200330160136.23018-1-codrin.ciubotariu@microchip.com>
 <20200330163028.GE23477@lunn.ch>
 <9bbbe2ed-985b-49e7-cc16-8b6bae3e8e8e@gmail.com>
 <bd9f2507-958e-50bf-2b84-c21adf6ab588@microchip.com>
 <20200331125908.GB24486@lunn.ch>
In-Reply-To: <20200331125908.GB24486@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Codrin.Ciubotariu@microchip.com; 
x-originating-ip: [86.121.14.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba4cd23a-87b5-45ba-7aab-08d7d6116a4d
x-ms-traffictypediagnostic: BY5PR11MB4021:
x-microsoft-antispam-prvs: <BY5PR11MB4021EB29B488801AC9068C57E7C90@BY5PR11MB4021.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4497.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(376002)(366004)(136003)(346002)(396003)(39860400002)(66476007)(53546011)(86362001)(8676002)(6916009)(478600001)(6506007)(81156014)(36756003)(5660300002)(81166006)(2906002)(76116006)(71200400001)(54906003)(66946007)(91956017)(4744005)(26005)(66446008)(66556008)(8936002)(186003)(6486002)(2616005)(6512007)(31686004)(64756008)(31696002)(4326008)(316002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3X0VObii2iflKf9PLl9ATGIcA/SgQDPRq+kr5mUVa5QJK3KoX0yV+haGavbFcgpGwN8e0E4n3WR4RhI3xEZt8ZHNzaSnuLdArqtb2lAiQDzy3odeGDl1EAVEHmRlxjATEIq2poVYAeDYktpURWiX/LYrINAXeuW6V4ljlb4RJCVtZpzPudQrA0BhFuqR3F89GvfpdsfpiCeeoPEkpeapw/GWP5wjmcLKCp2ALIXN4VUNB6t5VmYspbd22xTnSMk2WEpwdME22cLKVpgOO0+glYKP0UdIzygkRoQFH2+5TV8Kp4vSKf1stawKTnWw3Af6KhPbQ+BbNYXKwpnIWlg3XVhfGRnxp9aD1v+wKmykBpXHHwvbGN9spx1r9j6jDj/lC/WHNlPk3rU16xjqF12IV0mM3pTi9y1yvQxaJSGA3apW9IDHOwfeQ8bMIyeZe9gv
x-ms-exchange-antispam-messagedata: RgfE5n3CUlf2+GGAB4mejdKYJ3/sBsYAJUnkqOTfZ0j0CeJhxjxlH/4dh1dq9SWe+Nlu/nqRIW+EMFUgSrxd8IVVZVxWL3V8CmdC9mAIkVhfWm0aaPpBShTJVtAa7v/vutCJBrun5hMR2Hzj75clQg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E32D10737FCB4540921FDE0399F08610@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ba4cd23a-87b5-45ba-7aab-08d7d6116a4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2020 07:50:58.0466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v9Och2DVSxi0zaaLl3GBZvPouuy8cyR4dODVnCYyyKs0B6YFUSRgUPqTgpfJwT1GZW2iRzSDYvYQRd1UHDwlYhVfmDyeDClXkuvUjqyBvRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4021
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMzEuMDMuMjAyMCAxNTo1OSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4+IFRoYW5rcyBndXlzLiBJIHRob3VnaHQgdGhlcmUg
bWlnaHQgYmUgb3RoZXIgY29udHJvbGxlcnMgdGhhdCBoYXZlIHRoZQ0KPj4gUEhZIG5vZGVzIGlu
c2lkZSB0aGUgZXRoZXJuZXQgbm9kZS4NCj4gDQo+IEhpIENvZHJpbg0KDQpIaSBBbmRyZXcNCg0K
PiANCj4gVGhlcmUgYXJlIHNvbWUgc3RpbGwgdXNpbmcgdGhpcyBkZXByZWNhdGVkIGZlYXR1cmUu
IEJ1dCBtYWNiIGlzIHRoZQ0KPiBvbmx5IG9uZSBkb2luZyB0aGlzIG9kZCBsb29waW5nIG92ZXIg
Y2hpbGQgbm9kZXMuIEl0IGlzIHRoaXMgbG9vcGluZw0KPiB3aGljaCBpcyBicmVha2luZyB0aGlu
Z3MsIG5vdCB0aGUgdXNlIG9mIHRoZSBkZXByZWNhdGVkIGZlYXR1cmUNCj4gaXRzZWxmLg0KDQpZ
ZXMsIGl0cyBkdWUgdG8gdGhlIGZhY3QgdGhhdCB0aGUgTURJTyBub2RlIGlzIG1pc3NpbmcuIFNo
b3VsZCB3ZSBoYXZlIA0KaW4gbWluZCB0byBhZGQgYW4gTURJTyBub2RlIHVuZGVyIHRoZSBtYWNi
IG5vZGUsIHdoZXJlIHdlIGNvdWxkIGFkZCB0aGUgDQpQSFkgbm9kZXM/IFRoZSBtYWNiIGJpbmRp
bmdzIGRvbid0IHNlZW0gdG8gcmVxdWlyZSB0aGUgUEhZIG5vZGVzIA0KZGlyZWN0bHkgdW5kZXIg
dGhlIG1hY2Igbm9kZSwgYnV0IHRoZSBjb21wYXRpYmlsaXR5IHdpdGggdGhlIGRlcHJlY2F0ZWQg
DQpmZWF0dXJlIG5lZWRzIHRvIGJlIG1haW50YWluZWQuDQoNCkJlc3QgcmVnYXJkcywNCkNvZHJp
bg==

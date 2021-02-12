Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB2231A62D
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 21:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhBLUqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 15:46:35 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:22270 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhBLUqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 15:46:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613162792; x=1644698792;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PEdG6regig4NQpq/+0yWxUOBCfKr1nEeKcE1H2wBOkk=;
  b=RdOgm6yTKdiQShwvLqAqWHYo53mMSVRZ0zEVbcwuizHr+YgeD44FLkvN
   bMsZNgAQrnttYcNQBgSBcvHkj5InG1TXOONfLRbw4ny6rHsYV7JVODqhh
   3oMgcSl7I06SNZRPyDfXyD05Bk6h3AS8ekVyiz74FjHxrPuc9hZkBan0R
   916+9ilAngpFvFS1IOc7FZjxj3P5THfjlqo/9DlOCGIxGeOsM5ogUzpTT
   uXEAlmI12iWar3QIWz5WS1CJoDWCOY2kI8vA9emncxh6bN/LT9Cg2gFd/
   30ECtnGlucUpTsw898qGl8YKT6AJ6mCmSO5C87X3idfAhvctg9fh6DQZW
   g==;
IronPort-SDR: Tv2aif4vrXXfjcvcF4ls/uBd6eObj2hZaGFC/g8Vmv+GykhM0AQZv4QxSe8ScVcJEegWYsNoiO
 9yOJ63NFM1SfbJ/DY+SEo+DOcK5xGOAzrDnQYaNU4twLPRzac5xWQRnceErhvCzhi99NDPteGw
 Km5jhh1YyFg6CX9j/0uD+USC8bipSk4gC9D9Zc0Jx+aifnFrhzVJ9K0q3euOCMnsKX9M9M3HjZ
 RiCzyHTYE1Bc7Y3pkfAdUgnECqOEtga4bDqM9IYtU/SqMK59y+SvhA8sP2LH1rfBwgXzh9tYvC
 WI4=
X-IronPort-AV: E=Sophos;i="5.81,174,1610434800"; 
   d="scan'208";a="43937096"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2021 13:45:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 12 Feb 2021 13:45:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Fri, 12 Feb 2021 13:45:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2OclpBN/5hXkAq73XweEW7MVFsgY728iP4eWF7rkxRlweJdI33Wm8LEyppwTh70q001+22rPQAdzYJtd7KKLZMeIZ2YBK3RmshPBz9gy2fh8ETUW8k0/O9d4npOH9DSpj070tmlK3uSHaHCn2jrpmaF9Bg+naxQOzLAn3bb212ouSdH4oIhcA06u4grgKrwUG3QNkBHhZA1E2jAA/OxvHOcZNS/xuh/Vq/5z3wJB3CdQsyuy156uPN34Yu9odKofiMOdtk8Ydn8eCg2046EP/LNY42FDSvKmpbNx3uRjsiYyDkk0iF/8HMgR6ErUrB++qEyxlAej6RYXrIe48UcsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEdG6regig4NQpq/+0yWxUOBCfKr1nEeKcE1H2wBOkk=;
 b=K/IvGTepqvD1J23SJErajkz+dsQ2wa2sT95ymgSGVh+7pzMc7xRi38BOBu0RzbhM17GlpkFRdAarR9si7hWL7opubo0yWYJBvF3FiAt0XyJNGadPoUvR3VOO8dFI/njqhdSCZDu/jvxG/dhdRdTnPnjzTGLUsUoIt0WiMrXYmGcbas/FCtlVl/BxqWYFdNw9PRTagmkpdVraVjKqR1UW5mKq6vEZb6OSStCRrdPztojnNQxEA8CUcIW36GEqWJpy/+mNWmWXjlQOk/Kr3W8heCWAi1A09yApFly6TeGvyKkxsiTUXtVbnLvKbR2gKZLoGd/TGenvTrVzs6FLsf5OZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEdG6regig4NQpq/+0yWxUOBCfKr1nEeKcE1H2wBOkk=;
 b=rCMmSzAHSco1w7jts8XI9uDINGWJlG9011kYFBn6d3DzuzSpOJ9Snp9K4PdJeH4A5L+gGCOB59AkoaJSGiBTmDOmIGMY+Awc5y/9XEUSFE8rqC9C9vzV/aSnt2fVs9R9suBVkTGztKaNfOzlWIls5DhMP2cjpJCEf9AZqnPiZIs=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB3725.namprd11.prod.outlook.com (2603:10b6:208:f9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 20:45:14 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584%2]) with mapi id 15.20.3825.031; Fri, 12 Feb 2021
 20:45:14 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <thesven73@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <rtgbnm@gmail.com>, <sbauer@blackbox.su>,
        <tharvey@gateworks.com>, <anders@ronningen.priv.no>,
        <hdanton@sina.com>, <hch@lst.de>,
        <willemdebruijn.kernel@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/5] lan743x: sync only the received area of
 an rx ring buffer
Thread-Topic: [PATCH net-next v2 2/5] lan743x: sync only the received area of
 an rx ring buffer
Thread-Index: AQHXAJGpa8G4jGvBo06W56EUgcdc1KpU/sdQ
Date:   Fri, 12 Feb 2021 20:45:14 +0000
Message-ID: <MN2PR11MB36628F31F7478FED5885FB92FA8B9@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <20210211161830.17366-1-TheSven73@gmail.com>
 <20210211161830.17366-3-TheSven73@gmail.com>
In-Reply-To: <20210211161830.17366-3-TheSven73@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28c0337e-ad6c-4394-63fe-08d8cf971989
x-ms-traffictypediagnostic: MN2PR11MB3725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3725818508A868B65EF9FE95FA8B9@MN2PR11MB3725.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7NQzfFgIQa8Q3XfQvotSUPU+pOAuRMHYxAEgVIl8EQprZvahr0W/Q1MeDeN9P9gpLiwkVgTjDycJXgs3okV+Ynbju+V6VkJ4eT/phHuupn5mOgoaciNMUGmMPrOaGyfMPMOJI39ARn2Wjc5ih7y7t7sRM0Jz/BqpGy9g/5JMYG1mETJO/A+mht1TqZ4sII97PcNTM0Ihy8nTHNNBX3mgHo2t5Qep778sOICnUA+iq9mdZVfBXU01yG41npj/KbgMB/tI+r/SQzzdDwjflW5kHjcGbBeytlR+mAgsWoG11ePH8sHEwpNtqKjj5yHwTGPvxR3zuqNc5OLkBGpWOCtmZoRepuuO8HMIK39oIONEjI/JM7Gyg8gGF+CmZU3W7WLowfkK+hpSpwLcSN9GK0y67ktud2TCO8NbVZohxUzWXiOwha20EiQa/FdFN9gdZT4nB/OAB/Xb3CX+f9BeINnv4TPyzvIpPgOX8ozZHhjLA6yB/3eJFRXJsKZ0IQxkRD6Y9yygO7o3r+HhsE7RGeTJ3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(346002)(136003)(366004)(316002)(66946007)(7696005)(5660300002)(9686003)(76116006)(66446008)(55016002)(52536014)(66476007)(26005)(64756008)(4326008)(7416002)(66556008)(478600001)(71200400001)(8936002)(33656002)(54906003)(8676002)(86362001)(2906002)(186003)(6506007)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SldQbDZWbGtXMFBicDlDaDhRYXhHYzBwd29ra0JDdGFOTFpsamFqSFRQRSsw?=
 =?utf-8?B?bGo5SXN6QXVzcjliMWlRVmF6aFIwbWhUZUUxWjdVQzIwRVpoL2VjajYxZUta?=
 =?utf-8?B?cnVDS1dZQlZMb2ZRUHZ6elVZTHpDK3oxcVlXK1pFc2NrK2QxaHQxTnovaGIx?=
 =?utf-8?B?V1RLME1iblVBdUFGL2F0eGVxM0ZYVnVZRTBQT2IrZklibmJud3hKRWhGMmtl?=
 =?utf-8?B?SjFaUmtLOVI1cXQyN1Z1TXBreWNMejBnSXdMRDVNMmlCK29GbVZlMWtrenBP?=
 =?utf-8?B?U2FRMklmRFMzdWxFWnFtZ1B6MFgwendUMTE2anZreXNkSFYvQmxja2FuQndn?=
 =?utf-8?B?SGczdzl6MzFFZjdaalRQVUJVWE1lVVQ5VXNUaGFxZEFIU1MxRm9PdW1MVmRl?=
 =?utf-8?B?eEtTVlg3aDVUc3lCdlVXZjYwcFZsdnd5dkNTTkdEVVQ2VHFwbHRhZlZhUUUw?=
 =?utf-8?B?Y3p2U3JtNHBUUERITzlvZFpSUkg0d3l6a2liUUlCT0tKZldma1Q5MHQwWlE0?=
 =?utf-8?B?VFg2U2RWZkZCMnFjMVZiOXJwVmtMZlphTG9TcDY5RndsUXBuWUIyd3hXajlS?=
 =?utf-8?B?Qng0Rjgxc2VaTFRtTFRnNXFQRHJwNHRRVUgrWUdnTlBjaisxUkFNOCs4aUtW?=
 =?utf-8?B?OXV4ZVJUQzh5ZURRaXY0MGlVV0pHYWFIWmh3MTFrY0lnTjVEVHE3bjlUODkx?=
 =?utf-8?B?cy9BTTBoWERkaU95NzRTNU1QcGRwVlpPYlM5M1NTSDdST1d5cktnN0l2eVRK?=
 =?utf-8?B?UHFzZis0R1ZiT3pVVEY0bStWa1lZTXJGVjB4K0ticWtScHR4endJSFBkaDBZ?=
 =?utf-8?B?NHlFdS81Ti9qR3Q0UVV3dzlCK2Ixclp1VHY1YlpXZ1ZFd1RlUEpYNWo0WEVB?=
 =?utf-8?B?aDdVM1NrL0Z2MUQrZDFDOUhyeWZmazR4MmFocmVRT2N0dmpTZDNrejcwcHRo?=
 =?utf-8?B?SXpWdUZZcEI0ZDhIUmZ4c0JLYVNhK0p2TVpMYXp2MERLaU1FQnExVk85ekFC?=
 =?utf-8?B?MFRUWm5SSlpuRTVlSFJLWmQ2R2p3bGZjNjZpaVNIRmova09wbEF0Q3REK285?=
 =?utf-8?B?SEpNOVZJN2ViMDVzalJKWGtBblhhbVoybUc2a0Z1a3k0SXhXRXZ0dzltOVNn?=
 =?utf-8?B?bWZoQkFkMEtkUjF0eTFaNWx5SXdtVFhoR2VGRHZrZWdZR1Bnd2FLNXpwd2Ux?=
 =?utf-8?B?enJSZUVyS3VuMG9FeEcxdFNtYXJJZUZvN1Y0NDRtRjNHeWRrS3N2Q0VxZjhi?=
 =?utf-8?B?anpXZmI3TG1aM09iOGg3cEhTWlBFZmpVSTlYazBzT1lGelROaFRDNUpDTTNa?=
 =?utf-8?B?UmhBR3FhdTN6TEd5NHJWOTIwUSt6RTRiQmJaSXpEenVJVVJ1Ry9PNWhXRWZz?=
 =?utf-8?B?VFQxVlRibzV4OThhcmliT3p4WWFtaTU0YkhpZUZuTk5ZU20wZU1lbGJ5UVNk?=
 =?utf-8?B?c3hnS0RWOVBuNTVCMU1GNDQ4TG1kYjBRcUFYeXVmS3daMDBrek5YMVRseWRI?=
 =?utf-8?B?Z0VIN1FvQlluYnRFVU9CVEJJbTFGekt0S0xNZHYvL3NmUUdmUksySGFJSGZ4?=
 =?utf-8?B?UFg1L3ZyeWxTZXlveGlQVDNWQzFBVUlHWlIvZWpTNC8xZENtenBLd0ZPV0tF?=
 =?utf-8?B?TWdJSitidXFzREtSbE5Vd085ZE81TGxWaFZBY0RjSXh5bjhTcE44cit2YXUz?=
 =?utf-8?B?bUVtWkk5ZHpKMFVMYkMwcUIxU2VtNlBiczRiNzUybzFsZGZObVFlRDAyYkF1?=
 =?utf-8?Q?K70pvSpgcjWgx5MdB/9t6nU4RJ4NLQ1pvEJl6Vw?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28c0337e-ad6c-4394-63fe-08d8cf971989
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2021 20:45:14.7451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pr4QInPMEFX6z2JobCFj7SQRJ+aS+jEME9/4vM/KbX26T7uqSa/rk24JNlovptdZsOOKzxUC7wxPOTQVXDXIYNNHqbGJSGdv0yFpQZbhvmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3Zlbiwgc2VlIGJlbG93Lg0KDQo+ICsgICAgICAgaWYgKGJ1ZmZlcl9pbmZvLT5kbWFfcHRy
KSB7DQo+ICsgICAgICAgICAgICAgICAvKiB1bm1hcCBmcm9tIGRtYSAqLw0KPiArICAgICAgICAg
ICAgICAgcGFja2V0X2xlbmd0aCA9IFJYX0RFU0NfREFUQTBfRlJBTUVfTEVOR1RIX0dFVF8NCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAobGUzMl90b19jcHUoZGVzY3JpcHRvci0+
ZGF0YTApKTsNCj4gKyAgICAgICAgICAgICAgIGlmIChwYWNrZXRfbGVuZ3RoID09IDAgfHwNCj4g
KyAgICAgICAgICAgICAgICAgICBwYWNrZXRfbGVuZ3RoID4gYnVmZmVyX2luZm8tPmJ1ZmZlcl9s
ZW5ndGgpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIC8qIGJ1ZmZlciBpcyBwYXJ0IG9mIG11
bHRpLWJ1ZmZlciBwYWNrZXQ6IGZ1bGx5IHVzZWQgKi8NCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgcGFja2V0X2xlbmd0aCA9IGJ1ZmZlcl9pbmZvLT5idWZmZXJfbGVuZ3RoOw0KDQpBY2NvcmRp
bmcgdG8gdGhlIGRvY3VtZW50IEkgaGF2ZSwgRlJBTUVfTEVOR1RIIGlzIG9ubHkgdmFsaWQgd2hl
biBMUyBiaXQgaXMgc2V0LCBhbmQgcmVzZXJ2ZWQgb3RoZXJ3aXNlLg0KVGhlcmVmb3JlLCBJJ20g
bm90IHN1cmUgeW91IGNhbiByZWx5IG9uIGl0IGJlaW5nIHplcm8gd2hlbiBMUyBpcyBub3Qgc2V0
LCBldmVuIGlmIHlvdXIgZXhwZXJpbWVudHMgc2F5IGl0IGlzLg0KRnV0dXJlIGNoaXAgcmV2aXNp
b25zIG1pZ2h0IHVzZSB0aG9zZSBiaXRzIGRpZmZlcmVudGx5Lg0KDQpDYW4geW91IGNoYW5nZSB0
aGlzIHNvIHRoZSBMUyBiaXQgaXMgY2hlY2tlZC4NCglJZiBzZXQgeW91IGNhbiB1c2UgdGhlIHNt
YWxsZXIgb2YgRlJBTUVfTEVOR1RIIG9yIGJ1ZmZlciBsZW5ndGguDQoJSWYgY2xlYXIgeW91IGNh
biBqdXN0IHVzZSBidWZmZXIgbGVuZ3RoLiANCg0KPiArICAgICAgICAgICAgICAgLyogc3luYyB1
c2VkIHBhcnQgb2YgYnVmZmVyIG9ubHkgKi8NCj4gKyAgICAgICAgICAgICAgIGRtYV9zeW5jX3Np
bmdsZV9mb3JfY3B1KGRldiwgYnVmZmVyX2luZm8tPmRtYV9wdHIsDQo+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBwYWNrZXRfbGVuZ3RoLA0KPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgRE1BX0ZST01fREVWSUNFKTsNCj4gKyAgICAgICAg
ICAgICAgIGRtYV91bm1hcF9zaW5nbGVfYXR0cnMoZGV2LCBidWZmZXJfaW5mby0+ZG1hX3B0ciwN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYnVmZmVyX2luZm8tPmJ1
ZmZlcl9sZW5ndGgsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIERN
QV9GUk9NX0RFVklDRSwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
RE1BX0FUVFJfU0tJUF9DUFVfU1lOQyk7DQo+ICsgICAgICAgfQ0KDQo=

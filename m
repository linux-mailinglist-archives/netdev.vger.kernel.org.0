Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EC6318950
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhBKLWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:22:33 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:54572 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhBKLTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:19:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613042383; x=1644578383;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LGdMuUka37QuL+2zF+8P3O7K0yaTCgrOui5DteIgCBI=;
  b=hR9oMXjNc7Zex2yD2Bmn6omcuZD743QFR+j/fR5Y//AnpkS1M6CxWyzU
   KTj5PA23yqguDq5dITNiG7fjW5VPybENNhxUYM9BZkrGA4Jz49MoYZOnc
   0yUbNsNF9lCKUCRXaP4uB1wl16VvebavQ0FDFn1VIL0YpkNjQ5rrQcTz7
   goQ+RQ34ZBGhRuR6JXDtfHEA7N/tf0LmnVCJ9UcWqBjx3AsMpFJMB7UHX
   KRFQwjgcPy7WXLflM+0QPpG/6aU41VZmr0Jw+TSCR62hAV5Hl6fC4T3vU
   5iN5zFu8CX8ENf7DnWpSSKUOwD5cMnUQ0aWWT0vBH7+Qi05ELpaSm/ItH
   Q==;
IronPort-SDR: jj6Hoqx10OsA0Syc1FZvhj3SvclncA2/c0+rhtYDbYulrCl3swUAgeH5d9oPenYvqu56zz2cT/
 ZWwMaAD6gBVRCLja3P05tFkdgCfYS1znDliQ2JmtF5E1nuqk0cmF+DEETKS/iunhC1+ZAFGrQu
 aCMKY8zOS4eMZJ0h/mEZRQCrgPb7wmozPS9a6SFF1MbCvDvgF4/6s0aygB+vLTRECsY/m8QS3s
 LQu47cSby31TjNLEZIKWybfEktuQAHVmTHs+9bBao3n6OEacEU+vLUzvzhgKwojfkp/MIE4eiv
 IJw=
X-IronPort-AV: E=Sophos;i="5.81,170,1610434800"; 
   d="scan'208";a="106243288"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Feb 2021 04:18:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 11 Feb 2021 04:18:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Thu, 11 Feb 2021 04:18:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cm9izAfNoKayPGeNb7r889/CHNOJW+CsVmxGdVp50+MqENuWcSIK/qea2WxKkNU+lSfsbkn09dwuHNMYFXBMbbpcJwkxX2vMCrDPQykEEmsLVWWGe4nsvs/mjhKd7V+xkSTkuQapI019SEdPjiGnQNa7SHEGnjlSHnGEcfkk/zRx682RjdaDoYU58j2jjWE3/yUo90LeO5ZyONLs13cTAN7DWvfJB4ptGmNgfxoDOXH3wQrq2XpuNT5a3TR1/xKsBVDeYplcsYYU1DNheYXQDGL9bOzkuloJwAsd55vBp5PMExis4wcqRsft+s2x36S9jS+GRxiH0j9AvRC8RXRMpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGdMuUka37QuL+2zF+8P3O7K0yaTCgrOui5DteIgCBI=;
 b=EaADV8eWa+H2o+RkZYd+RY2IeDUC5CZen8IzAGIBAdGRX1VWKbsrTPZj2Up6PihRRlusB5sq2Ach37iUUMCHUcY20Zuq0SLpkpVIcuCo+hNzxjOaqP5UMXPzR2TLBTVYfpfxagVPzXtgzREXXPTmrDDE/+u8pKubWTTN25XRS5Akr7MFwQJi4W2finQuAy+5Vvdqp/xClPu3H1diIDnZ8XXyG21fPa+MCm9strkGBc2tZcWnIoXo8Pj3naAXz0syE9LpS1yBdZ9KCe8s0sBJUeDCHJEcbIHAuUCFlYMugRLrO9v7v1aJQsuKqQjtzG9/W5d8BZNYMa0NSouHNi6R/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGdMuUka37QuL+2zF+8P3O7K0yaTCgrOui5DteIgCBI=;
 b=npTM8zqveSn4TinTX0FJ1PJJhfyJEL6AQi7kRyi3D+VpEsoLA+infwNnz5YFZHILAr0XZ0CuTcz5KBOMgW12iUhdlwnPKE3RphG0cXulnpBb25GtoHwcOk4t6+hififrXeoZFu6em1iUhSjkVk9bF7NS0OdRaF596OmuDNKAgrc=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM6PR11MB4595.namprd11.prod.outlook.com (2603:10b6:5:2ac::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.23; Thu, 11 Feb 2021 11:18:10 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4%5]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 11:18:10 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <rjw@rjwysocki.net>, <pavel@ucw.cz>
CC:     <andrew@lunn.ch>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Thread-Topic: [PATCH] net: phy: micrel: reconfigure the phy on resume
Thread-Index: AQHW6Y6UrG2j4PiM1k2BT3XuGZuJHg==
Date:   Thu, 11 Feb 2021 11:18:10 +0000
Message-ID: <74922e53-e521-fde3-050a-64dd6bb507fd@microchip.com>
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
 <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
 <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
 <ee0fd287-c737-faa5-eee1-99ffa120540a@gmail.com>
 <ae4e73e9-109f-fdb9-382c-e33513109d1c@microchip.com>
 <7976f7df-c22f-d444-c910-b0462b3d7f61@gmail.com>
 <d9fcf8da-c0b0-0f18-48e9-a7534948bc93@microchip.com>
 <20210114102508.GO1551@shell.armlinux.org.uk>
 <fe4c31a0-b807-0eb2-1223-c07d7580e1fc@microchip.com>
 <56366231-4a1f-48c3-bc29-6421ed834bdf@gmail.com>
In-Reply-To: <56366231-4a1f-48c3-bc29-6421ed834bdf@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [86.124.22.121]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55f88966-6904-4f74-d8f5-08d8ce7eb724
x-ms-traffictypediagnostic: DM6PR11MB4595:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB459522787102CCE6A80FA3A8878C9@DM6PR11MB4595.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F21efrkc+kvVMu8C9DM1pHd2rPMj2/UAJIjN/nFrd8g7uJeKqD5rObVoN3DWMn/bR97QMkWiDrPFrJaoryoQoaOcYMyki2wvIqOYuS3l23yjbDK7f0COyMlBy1JjZMa/zWbH8euNAq6TEy2/t9XrWOSVdssg1oiE647b327XAIrzrrsbaLu1ydVEBODPw0gUzHSEQwHEaLh+ErL1rJy82hbDfUl0CZzIva0r8HTavR5kxQJPNGrruHwVGn15UI1LjkmWQvU+xKxxAz0bOPBn+hXIhM3YNPlhHDkIirzMPvCr8IXAvQCFWlGitxIn7jktMZkWXQd0R2vvhdrLF26Mb4VzN4l8f02+31CgKC1ynT8LddbiY9HPjTBTI12S8bi8H7/PfduCnVZOb/SyCKfyd7u4gOkYoUdorhM59rAPmOw+6rqWPtXN7bLqCf7Mephef/mswBu4ksF5Rz+YHx0ml5z3ROMXGaK0FaHHyhkU7FWItLwvl07sA4mhiDL7DkC5ZZzrAmLz3hcjeRPQQ5hpFxr4yvHpS6JgvJra8beSNKQj2HC4/+0GApW3XlvCXvvlsU3r240dAALy0d9cdTce5JHa+/XNvo545b94dWcgT6GkBh1gj03I8FxTnVI58IdsG4pdiYvEUIszlkvpHJN8YS5IGrjdvMO3KAmleUj9JxsnEsbyoh+lhnF/qusWbHXz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(396003)(376002)(39860400002)(110136005)(6486002)(54906003)(5660300002)(31686004)(53546011)(7416002)(4326008)(316002)(31696002)(86362001)(8676002)(36756003)(83380400001)(66946007)(66556008)(6506007)(478600001)(66446008)(64756008)(966005)(26005)(66476007)(2906002)(186003)(8936002)(6512007)(76116006)(91956017)(71200400001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MUJiN1NLZWt4RDNjYTlZVWpkbG5nSWlCK0V5cHhSUWtmd3hHbWZyV2dZSDIx?=
 =?utf-8?B?MzErTFZyN2cwbkFLbkVnVlNsZmhkMENMVFJSRk1tU3IyRmlidFNLdDRSbnAv?=
 =?utf-8?B?V0ZocjNlWXcwR3NpZUNnTVB2OGdIRUlCOUJRTVJ2LzB5aTlOY0ZqUXBRRWQ5?=
 =?utf-8?B?N0h4ZVlDalI3R1c3azNkNW9BZjJBNmh0d09IWit6dVFPWmk2MWNaZlNaY1Bn?=
 =?utf-8?B?a2NzLzVROFMzSXU1ZGZ2eUpUNHg0b2VNcHVqTFNlT1JSNTl4QkZ3eDhUSEFW?=
 =?utf-8?B?RUFrcEx4WUtGR29jSldtSUYvNTVGNGtJcGc1a3lSQ1RDMGJ6VTFGSXlCOExh?=
 =?utf-8?B?VnF4UVdBcGJzQjdxaWYxMlBOdHJPMlB6L3ZWcE5KK3Z3bWFpVUZZMnBEKzN2?=
 =?utf-8?B?clpxQUZKalVQNkozaXFUVENzVWQ5MUU4NW85RXd2eDBYTy9ya3VhNFNwQkNR?=
 =?utf-8?B?NnVpZXZXRFFlQXFXUUFrSUZjYTRJYmgwRHVFT3BpU2N5MXppQjhPY3Y2YUdn?=
 =?utf-8?B?OW1lc25pbXRmaTZQSmhlTjh0dHdMNHRTNERhaFVtdDFmc3JtT1J6YXhGVTlV?=
 =?utf-8?B?SFc0VmxPTGxORnFOOG1WK2RuZllJQWpGQmlPY1RqeHJRZU9pS0doNWNRdkpo?=
 =?utf-8?B?ZmpxS0R5ZmxZdWswRm9nUS96WTdlZk1uUW5ZWVNmWkZoaDF4MmxXM09uRmVz?=
 =?utf-8?B?MVBIN1Z3UVlzMzlpWnhNQ2s4TThOSU4wSHVxanl5eHV4MnNWOXlobXlBM1Zv?=
 =?utf-8?B?L3VrN1ZZKytJK1lDL1k0WkVXa0oyd3VFVktRUm4xem93QXUyMlhiQzVyMzU3?=
 =?utf-8?B?emp6TjdnaGllU3NJSlBTT3VvTEtjK25Ka0NaemxiREhnZTYybDRrK013MlU1?=
 =?utf-8?B?VEZRMGRHU05nUHRoSE5BRlBKOHQ0a0loM0JQS0hraGJubElRTVB1Uzg2Rllp?=
 =?utf-8?B?bEZoTjB3N3A4V1FMMk1VUXpsbTVKbjAzclQwSGFxallMbHBuNnhzQWtjYkxx?=
 =?utf-8?B?N3c3bkFoK3c1L3BidG5ZR0dRM3BCV25ZMzI2T1Z6K2d5SE1EL1BsQ3VnelJa?=
 =?utf-8?B?eCszSU5BWFh5QyttLzIzZDgrVk0vOVVtQ0pWYXd3cUU0YXdaM3hFaXhPRzYz?=
 =?utf-8?B?dmhIKzBBNEloRnhTbVJzOGVwREFrSkhUcHpkN1NRbGQ2Rlo3STZNd2NFN1BY?=
 =?utf-8?B?MTVhZms4KzBvYjRMYjhiZmxiUGFKdGxwUHB6Q1U0Vlp4N1NQWFp0KzdRR0l6?=
 =?utf-8?B?dTJoOUR5YnN4N0tsSnlsajZZK3dhT2MyZEdtS0MwVEs3KzRQRzVQWHpwd3BO?=
 =?utf-8?B?UXhPUjV3ZklDMlVEUHdhbk5DajVZK1U0U2NuUEFzVUJLSFFOWDhSYmd6OFhw?=
 =?utf-8?B?T0hERlViUEhFNm1SUzJCMmZFWE9RR2RLQzVIczk5SCtUNDNmWkczcmJITmE5?=
 =?utf-8?B?cURRM2x5ZFhTUnVNVDFpUDN3ZWtFREt2elRyQVFXRGQ2cVVsckVEWG9LVGJ4?=
 =?utf-8?B?SXNFMUtpVWs1WEVPR2E1THU0TnRBQWpvM3UxNkxVWDNSNDBGSGxjdXRERyt0?=
 =?utf-8?B?MnppNWVGbXRNSjhnQXNvdytoMlA0VXo5clNiVmNZZGl4VkFtV1NrZGNjVEJw?=
 =?utf-8?B?KzFzUHFtNjVLenpUMXQrT3FtcVZueGo2VXhpTkZISlc3Nkx2MWNDSWJGWFc2?=
 =?utf-8?B?WHJKd0pqaXo4OEpzd20vbnltdHlpTGVmZTJPLzVYblBuanlTYm4ybjk1UWhX?=
 =?utf-8?Q?ZMQ2cN2PWqzuGhkLPA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <331D8A5BBD19D646A368C5561C8A2BD6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f88966-6904-4f74-d8f5-08d8ce7eb724
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 11:18:10.5558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UpR6jvpZUB8Cc/w/gWrEFv/VIqOFVtvq3LjNyFQaKOurytDKNSn5j7+yMOBteOc/zpFiHPuoD9z59Akv0SYwxP8sJf2itnydnR2M+t4+wn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4595
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIFJhZmFlbCwgUGF2ZWwsDQoNCkkga25vdyB5b3UgbWF5IGJlIGJ1c3kuIEp1c3QgYSBnZW50
bGUgcGluZyBvbiB0aGlzIHRvcGljLiBJdCB3b3VsZCBiZSBuaWNlDQp0byBoYXZlIHlvdXIgaW5w
dXQgaW4gdGhpcy4NCg0KVGhhbmsgeW91LA0KQ2xhdWRpdSBCZXpuZWENCg0KT24gMTQuMDEuMjAy
MSAxMzowNSwgSGVpbmVyIEthbGx3ZWl0IHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90
IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZSBjb250
ZW50IGlzIHNhZmUNCj4gDQo+IE9uIDE0LjAxLjIwMjEgMTE6NDEsIENsYXVkaXUuQmV6bmVhQG1p
Y3JvY2hpcC5jb20gd3JvdGU6DQo+Pg0KPj4NCj4+IE9uIDE0LjAxLjIwMjEgMTI6MjUsIFJ1c3Nl
bGwgS2luZyAtIEFSTSBMaW51eCBhZG1pbiB3cm90ZToNCj4+Pg0KPj4+IEFzIEkndmUgc2FpZCwg
aWYgcGh5bGliL1BIWSBkcml2ZXIgaXMgbm90IHJlc3RvcmluZyB0aGUgc3RhdGUgb2YgdGhlDQo+
Pj4gUEhZIG9uIHJlc3VtZSBmcm9tIHN1c3BlbmQtdG8tcmFtLCB0aGVuIHRoYXQncyBhbiBpc3N1
ZSB3aXRoIHBoeWxpYg0KPj4+IGFuZC9vciB0aGUgcGh5IGRyaXZlci4NCj4+DQo+PiBJbiB0aGUg
cGF0Y2ggSSBwcm9wb3NlZCBpbiB0aGlzIHRocmVhZCB0aGUgcmVzdG9yaW5nIGlzIGRvbmUgaW4g
UEhZIGRyaXZlci4NCj4+IERvIHlvdSB0aGluayBJIHNob3VsZCBjb250aW51ZSB0aGUgaW52ZXN0
aWdhdGlvbiBhbmQgY2hlY2sgaWYgc29tZXRoaW5nDQo+PiBzaG91bGQgYmUgZG9uZSBmcm9tIHRo
ZSBwaHlsaWIgaXRzZWxmPw0KPj4NCj4gSXQgd2FzIHRoZSByaWdodCBtb3ZlIHRvIGFwcHJvYWNo
IHRoZSBQTSBtYWludGFpbmVycyB0byBjbGFyaWZ5IHdoZXRoZXINCj4gdGhlIHJlc3VtZSBQTSBj
YWxsYmFjayBoYXMgdG8gYXNzdW1lIHRoYXQgcG93ZXIgaGFkIGJlZW4gY3V0IG9mZiBhbmQNCj4g
aXQgaGFzIHRvIGNvbXBsZXRlbHkgcmVjb25maWd1cmUgdGhlIGRldmljZS4gSWYgdGhleSBjb25m
aXJtIHRoaXMNCj4gdW5kZXJzdGFuZGluZywgdGhlbjoNCj4gLSB0aGUgZ2VuZXJhbCBxdWVzdGlv
biByZW1haW5zIHdoeSB0aGVyZSdzIHNlcGFyYXRlIHJlc3VtZSBhbmQgcmVzdG9yZQ0KPiAgIGNh
bGxiYWNrcywgYW5kIHdoYXQgcmVzdG9yZSBpcyBzdXBwb3NlZCB0byBkbyB0aGF0IHJlc3VtZSBk
b2Vzbid0DQo+ICAgaGF2ZSB0byBkbw0KPiAtIGl0IHNob3VsZCBiZSBzdWZmaWNpZW50IHRvIHVz
ZSBtZGlvX2J1c19waHlfcmVzdG9yZSBhbHNvIGFzIHJlc3VtZQ0KPiAgIGNhbGxiYWNrIChpbnN0
ZWFkIG9mIGNoYW5naW5nIGVhY2ggYW5kIGV2ZXJ5IFBIWSBkcml2ZXIncyByZXN1bWUpLA0KPiAg
IGJlY2F1c2Ugd2UgY2FuIGV4cGVjdCB0aGF0IHNvbWVib2R5IGN1dHRpbmcgb2ZmIHBvd2VyIHRv
IHRoZSBQSFkNCj4gICBwcm9wZXJseSBzdXNwZW5kcyB0aGUgTURJTyBidXMgYmVmb3JlDQo+IA0K
Pj4gVGhhbmsgeW91LA0KPj4gQ2xhdWRpdSBCZXpuZWENCj4+DQo+Pj4NCj4+PiAtLQ0KPj4+IFJN
SydzIFBhdGNoIHN5c3RlbTogaHR0cHM6Ly93d3cuYXJtbGludXgub3JnLnVrL2RldmVsb3Blci9w
YXRjaGVzLw0KPj4+IEZUVFAgaXMgaGVyZSEgNDBNYnBzIGRvd24gMTBNYnBzIHVwLiBEZWNlbnQg
Y29ubmVjdGl2aXR5IGF0IGxhc3QhDQo+IA0KDQoNCg==

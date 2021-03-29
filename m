Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC18334CFB6
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhC2MHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:07:43 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36824 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbhC2MHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 08:07:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617019651; x=1648555651;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jEb1+1f/b/kIa6N5yqpOw30dL63WtEjYb3w4G4HKJAY=;
  b=MJqi+QCGQBfzkF+zU++5HZiIXjDyGvoZM565l2+/uKUZIXNMq58HQ7XT
   zaJbV6hYBxeZDCcBa9E+QJ97868twLBdme6/SnkVLr+eskAdgasT6ZaeZ
   0bTzp8HobjheWYJ/gqL5b7DxSDK9xEeIgGC6o08pz51kTibWkfutR8LqC
   5Qh8R5oq+rHnwzHNqmme6Ymx+4npSZW8zZUvyJKQ3U0zqp8HmTI/HcSrW
   QB4d5fmHvCIkBXdgJ1NpoBZGJZTqbWbl921NIYe5LqeyHn4qiJV/D4/ab
   klt47QFQxpBxburCMiO4Yle9RX+TKvPSsKIZauNF6HtaMNhGhS3LHibHM
   w==;
IronPort-SDR: ajHe7Li0kcnRLiPOZ7hBCQFf7OOaXv8EuY83EXPIqLf9lXbqdd1K7vFvta80QKLi77SV3aYqno
 09baZ8BiGdXaNr9A84uKrgssfBm2zTryxM8UvZKeQRP+4XWRfPbxHAuikn5PRJiSHZA/o/Dgef
 xFtS8vArljKzkZVSTuSBhGsIliurizw8oF/9z+63UYjEdAdg9ajal/q6eLFNDMiM26umKs7y3z
 qO+1lHEady5XkTwdIRziWvCJ+H4WrGuWQehnX2pX+aPXDIJh+DLlixme10KqL7ih2Gd6y2t6Y4
 3ps=
X-IronPort-AV: E=Sophos;i="5.81,287,1610434800"; 
   d="scan'208";a="115009099"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2021 05:07:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 05:07:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Mon, 29 Mar 2021 05:07:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clurZnWrXgEpyJBojeKv6afUpF0sFXaVybw10lq8tE09LHDRSqjwI+Ljvn1hfNeyFih3fNTMuj050IAC5WK3C+6tjy/+K+U3CVj45srBkzoXLJxlgbaoML1LBtvI808QQ2DxIMa2ZdgDlakL5cC5isomX31fSgHctDeCoTgvQBwh7NE1tg02srE53Q8gtoiaFqy2OwR8L2PYdIyy6FtKHWfSBTbxzUqPhDG3ZLr70wkuQEsQLQ5Js5y3aCa3jeGfM9J1+74zR4xT0A3wEQ2nMrSCj8JpGEYA5YDsGUtCIDR5XqBNTOzrWLcKEO0t2AKPy8oYGfwHzp+mCT8lPj0Q/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEb1+1f/b/kIa6N5yqpOw30dL63WtEjYb3w4G4HKJAY=;
 b=Lawsz84UQYXEVBmLLHsMwcZINi+1uJJRs0pwl48aBdqBlw1SORt7EAecRvMecEpKxJJvh8Z1QaXX07eg+Lf+vpCRL1JkAHQ7cXMu19Ud19NSkBqabS42SsGBtr+sDH80NaRAZCPoQkjnG1ZtyzaRXHFxU4bxMn8UHBW7nZURI2/euAUGCwTp5e1d61VZmigZuu9pulaLRzzh5N9gOKl1pnVZ/JXaQe+V0JJTbWKN/Sbu38Rgt0myo2poxMOhYngj/SV9r1CoelO7HDneVP87dIc6MMFeAHS8FD70g5lmcc0m1cV1cOmMyBiKCCRKufScallySpv6Suhli+cTknLPtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEb1+1f/b/kIa6N5yqpOw30dL63WtEjYb3w4G4HKJAY=;
 b=E02UQrx2ycjlxulvC88LpDDFUaGFf84c3Sgi8fhbwR4VnxiPuditozzjO41ujTXK1p2AgGlORcaFdYn7coeWnAxSiO/C3Nji2GniClRIecDjNpEp11ICPRJWVVCOSNs18Qt5cVziD9O3mtsy4FtG+C2kP3bPQ335tgrvzWf1ibE=
Received: from CO1PR11MB5011.namprd11.prod.outlook.com (2603:10b6:303:6d::21)
 by MW3PR11MB4635.namprd11.prod.outlook.com (2603:10b6:303:2c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Mon, 29 Mar
 2021 12:07:28 +0000
Received: from CO1PR11MB5011.namprd11.prod.outlook.com
 ([fe80::8da2:ac01:fdfe:393d]) by CO1PR11MB5011.namprd11.prod.outlook.com
 ([fe80::8da2:ac01:fdfe:393d%7]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 12:07:28 +0000
From:   <Andre.Edich@microchip.com>
To:     <mans@mansr.com>
CC:     <Parthiban.Veerasooran@microchip.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: phy: lan87xx: fix access to wrong register
 of LAN87xx
Thread-Topic: [PATCH net-next] net: phy: lan87xx: fix access to wrong register
 of LAN87xx
Thread-Index: AQHXJIBTbm/f8E+c/EOoz1GMkTLOl6qa0dV+gAANRgA=
Date:   Mon, 29 Mar 2021 12:07:28 +0000
Message-ID: <53b244ad343f4fa9533ff5fa1e2b0b25ba92a984.camel@microchip.com>
References: <20210329094536.3118619-1-andre.edich@microchip.com>
         <yw1xblb2fbrg.fsf@mansr.com>
In-Reply-To: <yw1xblb2fbrg.fsf@mansr.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4 
authentication-results: mansr.com; dkim=none (message not signed)
 header.d=none;mansr.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [93.202.178.253]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ecc8bf9c-a7dd-45ee-aac2-08d8f2ab38fc
x-ms-traffictypediagnostic: MW3PR11MB4635:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB46357C67AEF6E9D9D71CA53AEC7E9@MW3PR11MB4635.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xw1tvMU2jbJnrUwK0NS3s4/YxXWI7M1dlsrO+N7Y8inm8cKYkh3a8IbStIWBpX3zFD0EHZQIGPrVAJPJUjR4MtHKxsJvSoxM3j096Wg98FEcgh4RZBtHHbxid3zMUSikkh7BwjLvKMUkARwAGQMYnnhmps2RNUN9VqySnw8g5LW9zj632pppb8mYn0ZvRhkcC2oDgZLpkuzIHi2siXgFHRck6Ba4xUjo05mqICh/8w3STYdyQLoHO7KpWhGscr6xarGUMiTJIRlB4m91usH9qSfPL6BAbc+VGCXmVLJoNMTtdTtdsA+qH3CETXS43nI62HqRJa6gLYRQtzv0HJv5BQdNsGhU+w4SReOmM9hJExsPgW13ViQyq/vv+6OhF90Bs8Ihy5spH0k4JA8ifpKohk3SXnx4sNIQ44AFesObdDVv6H2oHJaDY0ch+SKUMBZv3a4e1DrioczRISnZHyLbRGHMUbsnWSj/7+XsjAgerXn6DpMVrlAZY8A9qgr9N3txWs4voDac34aI6AfbdaW0+8QhzJK9jEI2aRT6dVjTIBcLnPg/OxxMKT01LFEQGZykmm5axW4W97Hp2RtlaQVNrZFBNo0yhbkHfyUcX5iOibpk2B02zDQvSZNoatQnKXVC4OtaOnHHPtBtVzwo4MG7ItHpryMmRzk+SzHF83EMVbk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5011.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(136003)(396003)(366004)(26005)(186003)(38100700001)(478600001)(71200400001)(6486002)(2616005)(66574015)(76116006)(86362001)(91956017)(4326008)(6916009)(6506007)(8676002)(2906002)(54906003)(316002)(107886003)(83380400001)(36756003)(64756008)(8936002)(66476007)(66446008)(6512007)(66946007)(5660300002)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?citCZEtsRUtuQ3ZhdCtPK25VSy93WUd6dWIrSXA1bWF5S0dRY09nMlQ1WnM3?=
 =?utf-8?B?ZWZESjQwbGJram9sNG5HMUF2TVVJeGxvVzJtUmlSczZpMzljVS93REVseVJk?=
 =?utf-8?B?OTYwMWlRUnl3RjJYYUp4N05BYWdsQTZYc3ZJWjBjV0VKUnJHYk80djBhWkVF?=
 =?utf-8?B?TGFDOG9wTzM0MXdmM0V1c3h2TXVmWisyU0xEUWlIU3dHd1owTUs2WW9RYkIv?=
 =?utf-8?B?Vzk5KzBscDVrcm83eElPMmdoSUNrSGxzODZzeG1oQWx2SGJQU0M1TjJGRC9Y?=
 =?utf-8?B?VjJETUFYQjRXN1BERnBlUEsyS1pHbmpUUENJSjJLemowd1B6U0tSTlh1Y2o1?=
 =?utf-8?B?ZzFlaVpPbXgzb2VIMjJ0cDdZOFZQNGRRcWlmMVhaSDZNSHgrWG5lVXRDRnFX?=
 =?utf-8?B?YkVpbzJoQnM1SFI1aGFVWGtnTWdOakJjV2p2VWt3L29Xd2JnMHB2bFR1R1A3?=
 =?utf-8?B?TVUvSzhJd0JubVdMcXlvalk5R284b0d1N1V2UTN2TkVOcVY4MEM4eUNqNHgv?=
 =?utf-8?B?YzNHaVBlbUVWdlBlM01nVXdRd1BDSjlubElYRm0wM3p5cElGNS9oOFJYdmtx?=
 =?utf-8?B?UUI4ampYbXh5cFhZaU0vSTgzWFlvZUNzR3JJeHJ3VktSYU9KUk5PR1RubnNX?=
 =?utf-8?B?a2pkTzZqZnNHbnQrcDI1UmtpNU1TLzZBOW1WakZMVlRpZnZodTRnVDdJVC9I?=
 =?utf-8?B?K2paRExtVUExZEQrakhMRTBEZExIWjVQMXRlU0ZFam1SUUpEUmNVZkJVQWpn?=
 =?utf-8?B?aWpaN3dSV01wTC9QQ2ozL0RmakJRSjVmRCswVzlWU3BEbWVJRm4wbHhMdHNx?=
 =?utf-8?B?cEtNWUNpY3Y4c2J4QXJic1JnRlY5anMxb1RGRWRDOHR1Y3RxOFpGdFgxaTA0?=
 =?utf-8?B?VEhLSjJzcnpqbGpFZlJLa1AxVC9Ya2E3R2hSVWIzYVMrQndvQTkxclp5SG4x?=
 =?utf-8?B?N0NuakFtcFc4eURTQnRkbG1zWU94TUhXK3g1a2hXWTFPSndLa0ZTK2Q0aFFm?=
 =?utf-8?B?QlEzLzV3bWNRMWtEb2oxUUVGQlU4RFg0TVZFQ0luT1FGSVZYRmNTRDBreDBE?=
 =?utf-8?B?RVJzOWppY240TkE1empScW5Ka3pDdHhQdUlBTldicFM5ZWh2L3hiM3ZaS09h?=
 =?utf-8?B?eFdVTlNQY1JvS1U5NnNscU8rY09iMGdoWUxhcWZVZGJpQmZGK2pTV1pVbVEx?=
 =?utf-8?B?Ulh1KzJJNjVSK1JkNHhFOEg1L2t4TlY3amVHUGk3dUluZldxYklYZTBVZ1RM?=
 =?utf-8?B?N3k4RTlSdW9BaWVEK3RTN0J6VEVWbWxtblFTL3VWcGxHdnlvc3hKc2VPekM0?=
 =?utf-8?B?ZlV3d1NIY2lyZ0lDUGo2K0cvdFZyVGxVM2dUK21UVEZKWFYvVlJSUGtINFFE?=
 =?utf-8?B?RUVhZEg2eFBNdFFFaU1obHhRV3FhSnFNb04rWUM4S2Y0dVI5V3VWS3BDR2Fk?=
 =?utf-8?B?bFp4R214c2lVaFpmRW1jTldsNWtnbVNsSzgyYTdEbXJ4UnNlTm80TmJtY3Z6?=
 =?utf-8?B?TVB5QzFOZ0doTUttOTRhWlphK1l6VVBWd3QzZ2lIM2l3ZDRiNVRiVTA3QkJm?=
 =?utf-8?B?NlBuNjd6Y1BJUUIwQlphcUJpMXNQdEd4NnllNmlmaktOeDJWb3orWWx0UXE1?=
 =?utf-8?B?V3ZXM1ZMaTlHbWlFb0M5VTFCczkvS2xhMGsrelJQdjQzWXlrQ0x1ek82ZS85?=
 =?utf-8?B?RS9TNlYxdjVDN2dkSVBFZi9rLy9LWmU4eEpEZ29MdXd6SS9zaFhkWXhhTStS?=
 =?utf-8?Q?mKHPzVfSLGMhPrjC1ZeEg7sKwaXVEEL7Dz9qVVj?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AAB0413D2B631448CBAD88DD9F4F652@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5011.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecc8bf9c-a7dd-45ee-aac2-08d8f2ab38fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 12:07:28.1212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xi/r70K5FNTMUX5fBbY87tF5tUhy9IExS06GlX00lKbmFou210hVY4+nQq7rNsLl6oO+S/aNEKWDsOFdoPmpeStpOA6WotFYpiHBNSw9CD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4635
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTAzLTI5IGF0IDEyOjE5ICswMTAwLCBNw6VucyBSdWxsZ8OlcmQgd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91IGtub3cNCj4gdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gQW5kcmUgRWRp
Y2ggPGFuZHJlLmVkaWNoQG1pY3JvY2hpcC5jb20+IHdyaXRlczoNCj4gDQo+ID4gVGhlIGZ1bmN0
aW9uIGxhbjg3eHhfY29uZmlnX2FuZWdfZXh0IHdhcyBpbnRyb2R1Y2VkIHRvIGNvbmZpZ3VyZQ0K
PiA+IExBTjk1eHhBIGJ1dCBhcyB3ZWxsIHdyaXRlcyB0byB1bmRvY3VtZW50ZWQgcmVnaXN0ZXIg
b2YgTEFOODd4eC4NCj4gPiBUaGlzIGZpeCBwcmV2ZW50cyB0aGF0IGFjY2Vzcy4NCj4gPiANCj4g
PiBUaGUgZnVuY3Rpb24gbGFuODd4eF9jb25maWdfYW5lZ19leHQgZ2V0cyBtb3JlIHN1aXRhYmxl
IGZvciB0aGUgbmV3DQo+ID4gYmVoYXZpb3IgbmFtZS4NCj4gPiANCj4gPiBSZXBvcnRlZC1ieTog
TcOlbnMgUnVsbGfDpXJkIDxtYW5zQG1hbnNyLmNvbT4NCj4gPiBGaXhlczogMDViMzVlN2ViOWEx
ICgic21zYzk1eHg6IGFkZCBwaHlsaWIgc3VwcG9ydCIpDQo+ID4gU2lnbmVkLW9mZi1ieTogQW5k
cmUgRWRpY2ggPGFuZHJlLmVkaWNoQG1pY3JvY2hpcC5jb20+DQo+ID4gLS0tDQo+ID4gwqBkcml2
ZXJzL25ldC9waHkvc21zYy5jIHwgNyArKysrKy0tDQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgNSBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9waHkvc21zYy5jIGIvZHJpdmVycy9uZXQvcGh5L3Ntc2MuYw0KPiA+IGluZGV4IGRk
Yjc4ZmI0ZDZkYy4uZDhjYWMwMmE3OWI5IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3Bo
eS9zbXNjLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9waHkvc21zYy5jDQo+ID4gQEAgLTE4NSwx
MCArMTg1LDEzIEBAIHN0YXRpYyBpbnQgbGFuODd4eF9jb25maWdfYW5lZyhzdHJ1Y3QNCj4gPiBw
aHlfZGV2aWNlICpwaHlkZXYpDQo+ID4gwqDCoMKgwqDCoCByZXR1cm4gZ2VucGh5X2NvbmZpZ19h
bmVnKHBoeWRldik7DQo+ID4gwqB9DQo+ID4gDQo+ID4gLXN0YXRpYyBpbnQgbGFuODd4eF9jb25m
aWdfYW5lZ19leHQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4gPiArc3RhdGljIGludCBs
YW45NXh4X2NvbmZpZ19hbmVnX2V4dChzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPiA+IMKg
ew0KPiA+IMKgwqDCoMKgwqAgaW50IHJjOw0KPiA+IA0KPiA+ICvCoMKgwqDCoCBpZiAocGh5ZGV2
LT5waHlfaWQgIT0gMHgwMDA3YzBmMCkgLyogbm90IChMQU45NTAwQSBvciBMQU45NTA1QSkNCj4g
PiAqLw0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIGxhbjg3eHhfY29uZmln
X2FuZWcocGh5ZGV2KTsNCj4gPiArDQo+ID4gwqDCoMKgwqDCoCAvKiBFeHRlbmQgTWFudWFsIEF1
dG9NRElYIHRpbWVyICovDQo+ID4gwqDCoMKgwqDCoCByYyA9IHBoeV9yZWFkKHBoeWRldiwgUEhZ
X0VEUERfQ09ORklHKTsNCj4gPiDCoMKgwqDCoMKgIGlmIChyYyA8IDApDQo+ID4gQEAgLTQ0MSw3
ICs0NDQsNyBAQCBzdGF0aWMgc3RydWN0IHBoeV9kcml2ZXIgc21zY19waHlfZHJpdmVyW10gPSB7
DQo+ID4gwqDCoMKgwqDCoCAucmVhZF9zdGF0dXPCoMKgwqAgPSBsYW44N3h4X3JlYWRfc3RhdHVz
LA0KPiA+IMKgwqDCoMKgwqAgLmNvbmZpZ19pbml0wqDCoMKgID0gc21zY19waHlfY29uZmlnX2lu
aXQsDQo+ID4gwqDCoMKgwqDCoCAuc29mdF9yZXNldMKgwqDCoMKgID0gc21zY19waHlfcmVzZXQs
DQo+ID4gLcKgwqDCoMKgIC5jb25maWdfYW5lZ8KgwqDCoCA9IGxhbjg3eHhfY29uZmlnX2FuZWdf
ZXh0LA0KPiA+ICvCoMKgwqDCoCAuY29uZmlnX2FuZWfCoMKgwqAgPSBsYW45NXh4X2NvbmZpZ19h
bmVnX2V4dCwNCj4gPiANCj4gPiDCoMKgwqDCoMKgIC8qIElSUSByZWxhdGVkICovDQo+ID4gwqDC
oMKgwqDCoCAuY29uZmlnX2ludHLCoMKgwqAgPSBzbXNjX3BoeV9jb25maWdfaW50ciwNCj4gPiAt
LQ0KPiANCj4gVGhpcyBzZWVtcyB0byBkaWZmZXJlbnRpYXRlIGJhc2VkIG9uIHRoZSAicmV2aXNp
b24iIGZpZWxkIG9mIHRoZSBJRA0KPiByZWdpc3Rlci7CoCBDYW4gd2UgYmUgY2VydGFpbiB0aGF0
IGEgZnV0dXJlIHVwZGF0ZSBvZiBjaGlwIHdvbid0IGJyZWFrDQo+IHRoaXMgYXNzdW1wdGlvbj8N
Cg0KVGhlIHdheSB0byBmYWlsIHdvdWxkIGJlIHRvICJmaXgiIGFuZCByZWxlYXNlIGFueSBvZiBM
QU45NXh4QSBpbiB0aGUNCndheSB0aGF0IHRoZSByZWdpc3RlciBtYXAgd2lsbCBpcyBjaGFuZ2Vk
IG9yIGZlYXR1cmUgaXMgZGlzYWJsZWQgYnV0DQp0aGUgUGh5IElEICByZW1haW5zIHRoZSBzYW1l
LiAgVGhpcyBpcyB2ZXJ5IHVubGlrZWx5IGFuZCBvYnZpb3VzbHkNCndyb25nLiAgSSBkb24ndCBi
ZWxpZXZlIHRoaXMgbWF5IGhhcHBlbi4NCg0KSWYgYSBuZXcgY2hpcCB3aXRoIHRoZSBkaWZmZXJl
bnQgUGh5IElEIGJ1dCB0aGUgc2FtZSBmZWF0dXJlIHdpbGwgYmUNCnJlbGVhc2VkLCB0aGVuIGl0
IG11c3QgYmUgZXhwbGljaXRseSBhZGRlZCBpbnRvIHRoZSB0YWJsZS4NCg0KSXMgdGhlcmUgYSB0
aGlyZCBjYXNlIEkgZG9uJ3Qgc2VlPw0KDQotLSANClJlZ2FyZHMsDQpBbmRyZQ0KDQo+IA0KPiAt
LQ0KPiBNw6VucyBSdWxsZ8OlcmQNCg0K

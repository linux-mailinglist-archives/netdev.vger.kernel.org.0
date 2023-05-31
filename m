Return-Path: <netdev+bounces-6683-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9F07176DC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:31:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 599E928134B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D3B1879;
	Wed, 31 May 2023 06:31:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6007E8
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:31:46 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B563D99;
	Tue, 30 May 2023 23:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685514705; x=1717050705;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=06BsXitnnx080El8zcGt8ZSaaesVE9kUC16icqXziqQ=;
  b=eNSOdjzC1L2P2P0AEnZayRD62tFKUhUDheb0wZzGXZw53LuWW+E6vtAQ
   Re6V7GktpRO7/1IRu0Flye/wgWSY8YB17Y/Hciav+WSawaApPIML5aCT/
   22E4Wbr3rG34GsyjBwH14LfHWk/HvuwnaWV2t8uWP9RHBS14Rw2KXn0sA
   MBxxEZMvJb7DPdY5Df5ooqqotHLALYAh4W7Gly9rIFo/0xNlEFiOlevj7
   Dr+PbpzVaB+mK++c/ZSOvwtaAEK5ASXSp0q8MPMD5g1k+PeS7TLtWs201
   rDLZ+IKEJtExWqKnteO1RsCutE4uaeJOVbZyEH4x0+CQ/FrwwbE/VhdQf
   A==;
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="216156352"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2023 23:31:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 30 May 2023 23:31:43 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 30 May 2023 23:31:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=duc+aIwVmU56vQvLWNydhnnS+aPNoh5oZnfaL5qIXM2PCHKtmXiufDzNmPXzL5fMC+JX6/iK8Wyuq9Mb15PhaLX6EoVFE1pqXpmdwxCzR4dNyXarHljECa7+d/UWBgiPm0K9iMZkufT7FvUVuD+hZC5o9+9eKBT8sENBiMcoUVNPzcIeKc/WYCcUt91P/Ho4bXBr3bf+LC/VmxzI7M4bUDrH7EQzP6ORdTmKlzjXIB5K2d5W/bzJ7SeLqu0R31OJOJD5Qx2EXpjzFl9etCju3BPi100YwV+rqiOX8eTgWHpK9c1dsHiuZAI+t2NKus4A6TALhucGfoEp25XRTaS1Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06BsXitnnx080El8zcGt8ZSaaesVE9kUC16icqXziqQ=;
 b=Z0U68Milj7jN12NtHrzHGyasAd0piotrqbd+GQs/hn0+leASgOpzkh2aCV8Vkye+lh0Ebn+Di6nHafAT6uGaRtcNIqyOP5iZKrnirv14USSCXPeAvSjp9sG5YrOjhq0UGH0kespU0hmfiP3YtBWf0RBKpQbjv+OqUz3+BNPCrH8vNEbcgGhzsFm5OFRf1UeRlT7b2vRx75tiC+9dsRyHJ2pvS1rRP7WQcP/HMfuARH51k6MOyir4KpPRsKtMhc7pIXYfP7ffN+NE2GdAsBdlr+ZRSQWenvikB+zOdrZMX1XhSj3r3FYP0gs8MAwhFK/scFbzN+FJimAYbhcZmL4p6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06BsXitnnx080El8zcGt8ZSaaesVE9kUC16icqXziqQ=;
 b=PIrn1nzA6K6VcxqcuGH/IyihcE9qA4aVAIQnDy6VsApWYljvZy6qQOlwRxbxRQBkfogTyuMmKxyEGCH9AG1eQTQbZJgsWEH4LgDNbArta27YmciH3iQCkjrXZnU1iNgkylMkv4osen4F2eqQB1vXK1TZELSqgisNa5zpROOg6rg=
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com (2603:10b6:a03:4c3::17)
 by SJ2PR11MB8471.namprd11.prod.outlook.com (2603:10b6:a03:578::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.18; Wed, 31 May
 2023 06:31:41 +0000
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be]) by SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be%5]) with mapi id 15.20.6433.020; Wed, 31 May 2023
 06:31:41 +0000
From: <Claudiu.Beznea@microchip.com>
To: <pranavi.somisetty@amd.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <Nicolas.Ferre@microchip.com>
CC: <git@amd.com>, <michal.simek@amd.com>, <harini.katakam@amd.com>,
	<radhey.shyam.pandey@amd.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v3 1/2] dt-bindings: net: cdns,macb: Add
 rx-watermark property
Thread-Topic: [PATCH net-next v3 1/2] dt-bindings: net: cdns,macb: Add
 rx-watermark property
Thread-Index: AQHZk4mP0qur9DIbVk+VW2p57qilxg==
Date: Wed, 31 May 2023 06:31:41 +0000
Message-ID: <0deaf87a-5010-0113-c86e-9a4b13d7dd3c@microchip.com>
References: <20230530095138.1302-1-pranavi.somisetty@amd.com>
 <20230530095138.1302-2-pranavi.somisetty@amd.com>
In-Reply-To: <20230530095138.1302-2-pranavi.somisetty@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB7648:EE_|SJ2PR11MB8471:EE_
x-ms-office365-filtering-correlation-id: f4b1c078-b761-4895-44ca-08db61a0b1f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JfW32HAQ1+RVk2SRiSCrw7zVCLNk6d0sZMvpPPylbEfXTsnGKIVUg0G6ccaPtRsB8iiUpB8sbupjkdTfnm6tAhVqdSxmc4waG69HnXv5eApVbkC5TKevswV0W3Lp29/g4dxjSRgXfFv6At3D7DWHGgOokjJBAjVl+7eJmqJsqmsykUDP6s1kBhkYEho4TmwE+1dJED6ftNjly0mb2y0/Alid4YQ1kEgG7i+q81yA81I9DZe2svBV0nDNQIoilJlNhDb7SVraFQyy9MEHUUqaZIe5drD+saoiBd6oXQLRLX7XCRZmJFxc+l1FNbwiYoYRvyFqx6IYpEBCdzev0WCo5Ni2mirO6mv3xeds95ZZYWiJOfsu3XTTaDIgnjLqyqxgsywTgOUcNoMooB4DKXGdOwYov8oCHMzWkOOKCyseKII7JzNKdeVs6vEl5zd4JYimRHC+73Q1zseKNOWZB8UzLvNkfNxHR91iwC6rKanXrai3uZck9zmfyxqN8GCQ4To9Xbo5N3juIGw2HzdYA5Gu/fHZ6uQLrFP4kbBslaUWx6miW/dGVDAeXd3qkWPZfaDVn6myfyNFULq4cMgrlvvWGckBehxMp0mWQf9OXAazzfGlAt9JWg0t5jupp/OoQbFCU2sy/glI/D3oykQSjEH0/UaI2mTDVgoRi31UfOP5Q+pw3lJfOT2TpZ6Oi9x0hVJM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7648.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(39860400002)(376002)(136003)(451199021)(38070700005)(316002)(6486002)(41300700001)(2906002)(26005)(8676002)(6512007)(7416002)(83380400001)(38100700002)(8936002)(53546011)(36756003)(31696002)(5660300002)(2616005)(6506007)(186003)(86362001)(76116006)(66446008)(66946007)(66556008)(91956017)(66476007)(6636002)(4326008)(110136005)(31686004)(54906003)(64756008)(478600001)(122000001)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZlRpcVgyVVNGTmJnME9tZE9TM2tqMnRNbXVtbmdjT2pLNHhnMlVZZWRRbEUy?=
 =?utf-8?B?dmY5NW5xZ2pTSldIYVpJRFFZQ1I4RGswTExGdG56dldaMEh4V1pyZVdWTnd0?=
 =?utf-8?B?K3UxQ01sMzhuV253Nnh3TVZEWWZacVppNnVscU05T25ZV2ZPT1NTRytnWHNy?=
 =?utf-8?B?eFEwYTdIUXRxZ2ozbFplL0MzQVYxUy9semtnRXFIcXZtS2k1dVEwUHdFNE5t?=
 =?utf-8?B?b3JGSHlIcUF3S1FhZGhMK1M3OE1tbmcya0xaeUdqVmZ0L25ac2RjUFpqOVEr?=
 =?utf-8?B?c29ZOTNtbDBBQlp4ZXJ4N2hwT05UUzBEQzRqTWJuZnBDb2Fzc1h3NllVL2to?=
 =?utf-8?B?bmE1VnoxTnN6cUhzcEVLTmVkK0k0R0NPb0JmWHJyZ0JLTFJYTmNnRERKU3hh?=
 =?utf-8?B?NGdzeUg1WCtleXpzd1p3czN1T2hSUXhoS0pUaThRZUc5bkRHcTFzTzF1UnJx?=
 =?utf-8?B?RnhaYlQxOEhEdDhDVlNob1V3VG5tSksra2FjMmZNOXBoWjRuVEQvb3RNOWMw?=
 =?utf-8?B?aWJJNG84TVh2UCtoRWluY3RDOVo0ZUxNeWhNamZxcEQ0SEtndDZqcDBjdWFV?=
 =?utf-8?B?L0lKYjRBTm90cGI4YStKYUF1L0Z2SUVMdDhlYjhCOGxqL1I3R1QzcjBpU3hj?=
 =?utf-8?B?NFE2NEJtRDBxZFFEZGRieGx5MVBjMllzbjZ5Q2tIUUV5WWJ4MitEQ05uT1JH?=
 =?utf-8?B?azJpME9JRnJZeWhJZkYxUk1LdVNRL2ZmNDV3b3VDeFlzV0dHT2VFamhEVHpa?=
 =?utf-8?B?Wmk2eWxPM2RHa1d3TDM4YitRYVdkN3RPRTNBMHZiRWpYVVB1cXZveHlzeUds?=
 =?utf-8?B?bEJ0Sm0wVVNlY2kvcjlITmdOZEZJUGpvdkkrbW84aXk4L3lMeUxLa1I3RUdS?=
 =?utf-8?B?emJTanhubnY5LzF3bXRZcUNMazQzZ0sxaVArZ1hGMjcwRWJZY0doMlE4d2Rj?=
 =?utf-8?B?NmlMaGlHcTFUSHV2UXQwczNyL3l5eGF0WWkvWllBZXgrYUl4OTM5MUsrenhu?=
 =?utf-8?B?KzF1YW85dlA4OU5TVFpFd2htM25tR2NZWi9SbFNmaFlBcDFjdlovSEpnYzhW?=
 =?utf-8?B?UDFBZ1RxanNzRHdHVjU4WEd2UDJwb0xpczl0TjlWaVVObFpCeEhENzI1R1lx?=
 =?utf-8?B?YkxGOXRyZFdDRng5N1pYc1c5WVdrWE94TWN5SXZtNE9mOVk3RTNNTlYxR0M3?=
 =?utf-8?B?VUw2dk5hV1pTYkE1MlVpUDdqejdMUEY3ZmFMNDZwY2grMld4dDQwcUkvVDRv?=
 =?utf-8?B?NGRaOENBMEc3NStpUlJoUDZhbWZVZHY3SGxJZG1YK0VqaE02d1E3NDN4N25P?=
 =?utf-8?B?c2FVci9LUE9LWjNCb2hnaUdzbWJTTHMrYXZucVdSWUR2N20vYkhvWjNJbFdM?=
 =?utf-8?B?UTVGYTBhdFJYOG1NTy96SXExWXFaT3FCNGE3OTdsUG1HK2I0ZWdVWkw0VTZ0?=
 =?utf-8?B?L2ZNTVB0emlkdUl3eUxQNUhTSjNDbUpWVlVkN3c2WUZETzRGQUFpK2RCbnlu?=
 =?utf-8?B?VXhXYk1LN3RnM3ZsTzlEa2FGRmJ6dkFoUUhmN2JBcThQRmY4cGt5b1dleXk4?=
 =?utf-8?B?M1Y3QkxHU1JYcEJ4TStmblRlemRzNVUyWTI4NEJPNXBmaURYNVpZckh3eUVJ?=
 =?utf-8?B?UDZtYXJ5blR0OXhDVlN2akdtUmV6dzdGbm1KRXljdVEyTnFYZkMzeStIdkg5?=
 =?utf-8?B?Qi84Ky9HNEdYOVI1S2xVcE1laFBtNzZhOUdxR2h1WUpuNXB5UkZHck1oWng5?=
 =?utf-8?B?Yjh1d2M0amcySytPdE9RSmYxTHJzNjVvZXlpOHp4cFJLNVdtV3pGczZLcmhq?=
 =?utf-8?B?M3J3ekYvc3JiL1hUWlR6cm52dXFmdVNDcmRsUGJxVlIwTVNPRzdEWXhzK3Yy?=
 =?utf-8?B?LzJ5eU5mTmljSnlqeUU0cEFneTRkZm84emwzTE5PaTNlUlhEa0NwZCtSbDZE?=
 =?utf-8?B?VVU4Qjk1UG9GVUEyWldEQ3ZhRE5WNit3UExsNUpDemVRaWpxUllicFBjdTQ4?=
 =?utf-8?B?c05KbEpGMmxJcGpzbW5USmE1QVhoWlZ4dVZMTy85eStoUWN4K2UyQTZhRkNV?=
 =?utf-8?B?UG9TeFVRTmp2VUZQTDh0WituZDBORTY3b1lWY0FzY3djeEE3QysyMXIzc0VT?=
 =?utf-8?B?amNIZ1VybENSdC9udy9nMnM1a1FiTlNRc0U1Yjk3V1V5Wjk5N0dBc1ZtYmJB?=
 =?utf-8?B?a0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <412B9AECBDEDBC40A4BB74FC91E7C821@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7648.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b1c078-b761-4895-44ca-08db61a0b1f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 06:31:41.1577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w3lG5gs6r6FYQN7a3y8plFe2KlNIF5WLJg9Jj6dv5/AJ9OvrWEK7IJbuvU6Eo0L6bxZ5c9+HMCPdjRHTdpWBwDPwMa1S1UsoQ39M1UHtkbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8471
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gMzAuMDUuMjAyMyAxMjo1MSwgUHJhbmF2aSBTb21pc2V0dHkgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gd2F0ZXJtYXJrIHZhbHVlIGlzIHRoZSBt
aW5pbXVtIGFtb3VudCBvZiBwYWNrZXQgZGF0YQ0KPiByZXF1aXJlZCB0byBhY3RpdmF0ZSB0aGUg
Zm9yd2FyZGluZyBwcm9jZXNzLiBUaGUgd2F0ZXJtYXJrDQo+IGltcGxlbWVudGF0aW9uIGFuZCBt
YXhpbXVtIHNpemUgaXMgZGVwZW5kZW50IG9uIHRoZSBkZXZpY2UNCj4gd2hlcmUgQ2FkZW5jZSBN
QUNCL0dFTSBpcyB1c2VkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUHJhbmF2aSBTb21pc2V0dHkg
PHByYW5hdmkuc29taXNldHR5QGFtZC5jb20+DQo+IC0tLQ0KPiBDaGFuZ2VzIHYyOg0KPiBOb25l
IChwYXRjaCBhZGRlZCBpbiB2MikNCj4gDQo+IENoYW5nZXMgdjM6DQo+IDEuIEZpeGVkIERUIHNj
aGVtYSBlcnJvcjogInNjYWxhciBwcm9wZXJ0aWVzIHNob3VsZG4ndCBoYXZlIGFycmF5IGtleXdv
cmRzIi4NCj4gMi4gTW9kaWZpZWQgZGVzY3JpcHRpb24gb2Ygcngtd2F0ZXJtYXJrIHRvIGluY2x1
ZGUgdW5pdHMgb2YgdGhlIHdhdGVybWFyayB2YWx1ZS4NCj4gMy4gTW9kaWZpZWQgdGhlIERUIHBy
b3BlcnR5IG5hbWUgY29ycmVzcG9uZGluZyB0byByeF93YXRlcm1hcmsgaW4NCj4gcGJ1Zl9yeGN1
dHRocnUgdG8gImNkbnMscngtd2F0ZXJtYXJrIi4NCj4gNC4gTW9kaWZpZWQgY29tbWl0IGRlc2Ny
aXB0aW9uIHRvIHJlbW92ZSByZWZlcmVuY2VzIHRvIFhpbGlueCBwbGF0Zm9ybXMsDQo+IHNpbmNl
IHRoZSBjaGFuZ2VzIGFyZW4ndCBwbGF0Zm9ybSBzcGVjaWZpYy4NCj4gLS0tDQo+ICBEb2N1bWVu
dGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2NkbnMsbWFjYi55YW1sIHwgOSArKysrKysr
KysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQg
YS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2NkbnMsbWFjYi55YW1sIGIv
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jZG5zLG1hY2IueWFtbA0KPiBp
bmRleCBiZWY1ZTBmODk1YmUuLjJjNzMzYzA2MWRjZSAxMDA2NDQNCj4gLS0tIGEvRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jZG5zLG1hY2IueWFtbA0KPiArKysgYi9Eb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2NkbnMsbWFjYi55YW1sDQo+IEBAIC0x
MDksNiArMTA5LDE0IEBAIHByb3BlcnRpZXM6DQo+ICAgIHBvd2VyLWRvbWFpbnM6DQo+ICAgICAg
bWF4SXRlbXM6IDENCj4gDQo+ICsgIGNkbnMscngtd2F0ZXJtYXJrOg0KPiArICAgICRyZWY6IC9z
Y2hlbWFzL3R5cGVzLnlhbWwjL2RlZmluaXRpb25zL3VpbnQxNg0KDQpJIHN0aWxsIHRoaW5rIGtl
ZXBpbmcgdGhpcyBvbiAzMiBiaXRzIGlzIHN0aWxsIGEgYmV0dGVyIGlkZWEgdG8gaGF2ZSB0aGlz
DQpEVCBwcm9wZXJ0eSB1c2VhYmxlIG9uIGZ1dHVyZSBoYXJkd2FyZSBpbXBsZW1lbnRhdGlvbiB0
aGF0IG1heSBleHBhbmQgaXQuDQoNCj4gKyAgICBkZXNjcmlwdGlvbjoNCj4gKyAgICAgIFNldCB3
YXRlcm1hcmsgdmFsdWUgZm9yIHBidWZfcnhjdXR0aHJ1IHJlZyBhbmQgZW5hYmxlDQo+ICsgICAg
ICByeCBwYXJ0aWFsIHN0b3JlIGFuZCBmb3J3YXJkLiBXYXRlcm1hcmsgdmFsdWUgaGVyZQ0KPiAr
ICAgICAgY29ycmVzcG9uZHMgdG8gbnVtYmVyIG9mIFNSQU0gbG9jYXRpb25zLiBUaGUgd2lkdGgg
b2YgU1JBTSBpcw0KPiArICAgICAgc3lzdGVtIGRlcGVuZGVudCBhbmQgY2FuIGJlIDQsOCBvciAx
NiBieXRlcy4NCg0Kcy80LDgvNCwgOA0KDQo+ICsNCj4gICAgJyNhZGRyZXNzLWNlbGxzJzoNCj4g
ICAgICBjb25zdDogMQ0KPiANCj4gQEAgLTE2Niw2ICsxNzQsNyBAQCBleGFtcGxlczoNCj4gICAg
ICAgICAgICAgIGNvbXBhdGlibGUgPSAiY2RucyxtYWNiIjsNCj4gICAgICAgICAgICAgIHJlZyA9
IDwweGZmZmM0MDAwIDB4NDAwMD47DQo+ICAgICAgICAgICAgICBpbnRlcnJ1cHRzID0gPDIxPjsN
Cj4gKyAgICAgICAgICAgIGNkbnMscngtd2F0ZXJtYXJrID0gL2JpdHMvIDE2IDwweDQ0PjsNCj4g
ICAgICAgICAgICAgIHBoeS1tb2RlID0gInJtaWkiOw0KPiAgICAgICAgICAgICAgbG9jYWwtbWFj
LWFkZHJlc3MgPSBbM2EgMGUgMDMgMDQgMDUgMDZdOw0KPiAgICAgICAgICAgICAgY2xvY2stbmFt
ZXMgPSAicGNsayIsICJoY2xrIiwgInR4X2NsayI7DQo+IC0tDQo+IDIuMzYuMQ0KPiANCg0K


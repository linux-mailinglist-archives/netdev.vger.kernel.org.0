Return-Path: <netdev+bounces-10641-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1A6072F857
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:51:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10C8B1C20C88
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643A13D6C;
	Wed, 14 Jun 2023 08:51:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501737FC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:51:43 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B161B1BD2;
	Wed, 14 Jun 2023 01:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686732697; x=1718268697;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s/ouzSIJIz3jUpedX2Vk7bhBe3Vg6juewsaQUvcgvAc=;
  b=N/cDO2zQXr/vGBwJQd8AcT9wwxlPiklNj+c/ycsKeUqU8eyZCYolXO0R
   DVdykDDvctbgll8yoAmKaB3LBcTrUimiIPxoMkRWNAGfhVBW2IN3UTA+R
   tiCDwuo5N3nlO/kgmgeXFFVHa/vch3OZJ0/tLtJFMWq9NUBC6cZMLX3tG
   ae8a5mlmhHKPivQ3MSSn5H7zq2goFakqPFf9VzE4eyQXhMAJH9Q1elBbX
   XYTUKLgwL4vf6o1kgC1bXPvzxmyMZAs3WKWXf/wIK/I9DEEP4hY5N25wi
   EZUtE4jIJM4JNZWL7LYdhhnUihjU47eVmG59osDishcKXjbmUNeSvZEPU
   g==;
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="156905785"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jun 2023 01:51:35 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 14 Jun 2023 01:51:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 14 Jun 2023 01:51:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jz+o90oQYs7xv6BzWYLKdFFvOtM7R/+wRz4SsUyOw962WO3IHephBNiJG2f0gxqhJ3d6/nMmF1omUGwbrER4Ly2tYlFF8X96ybgOr5j5payqR/3V7VUUNUfQ+xwQ4wR7bt71L14Pc8qAtTc6bLoHVx4nkK+KTAZlqLTImjvKu5PehHcol2sU82n1XjPwo9S2gQJGD/rAF+JJMQtqDvHHDfQaAT1MFh0+V9Aso+VfuKoK79+ODo9APc5tRQHLOppy1AsOO0ecHolumZjrnrmzKRT+5HwpCH+UI5EuHxd3bwvv+tVjCH30yJbfb925BKQlGwbuN20f3yGeh/UZ53SVCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/ouzSIJIz3jUpedX2Vk7bhBe3Vg6juewsaQUvcgvAc=;
 b=XL1v6bquBoSspPs44/2npl8kn2Yx4GfSymzTIlDYFMM6NBl4UfWBJOWcty6klzNeCUfvw0lhg+emi84TheoLvAX/wj2BBokmcHELNpWvEIX9XQ/u7L2EjQLGd/IYUPOnqSvyIStNiU+e8ek672Mp0y/49YkmW6+5NK58V/uc1N6gxkomsYVG4r3WCMYKF4bvE+Q2qgZvMGooLODBizQMu+8j9v6/DrT3CremSg2odsue8NTVecxJL3Zla6BQ00Zfp9v1XqqQWj8pk3ma7qQA6nQfkSHKlF0qYiSTXEN0zSRMJvSs1CZRmYtfSQapTejesGlXE6AM4uMBqXd8lkncJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/ouzSIJIz3jUpedX2Vk7bhBe3Vg6juewsaQUvcgvAc=;
 b=Gb5K3c7Hm4RpuyAp3CTJc47uNlhsgWJLig7mY7RBzl4xu8eMPhARJ7WiXw9AFfwx04/IzHS0aUbInRXvCHscqWfMtf+0SiFySq4dfOFVdazUnpdIlOhsCZu6PUYUxSpqL2Atjvi4cdZj5pZ3Xl/LT2Bwz5PxlSFj/wpPGx9EQjw=
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com (2603:10b6:a03:4c3::17)
 by PH7PR11MB7122.namprd11.prod.outlook.com (2603:10b6:510:20d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 08:51:34 +0000
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be]) by SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be%5]) with mapi id 15.20.6433.024; Wed, 14 Jun 2023
 08:51:33 +0000
From: <Claudiu.Beznea@microchip.com>
To: <pranavi.somisetty@amd.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <Nicolas.Ferre@microchip.com>
CC: <git@amd.com>, <michal.simek@amd.com>, <harini.katakam@amd.com>,
	<radhey.shyam.pandey@amd.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v4 2/2] net: macb: Add support for partial store
 and forward
Thread-Topic: [PATCH net-next v4 2/2] net: macb: Add support for partial store
 and forward
Thread-Index: AQHZnp1r1rFe/udRE0CqX5hytyHqZA==
Date: Wed, 14 Jun 2023 08:51:33 +0000
Message-ID: <af6840d6-8ceb-abf4-bde2-be4f8befe94d@microchip.com>
References: <20230613054340.12837-1-pranavi.somisetty@amd.com>
 <20230613054340.12837-3-pranavi.somisetty@amd.com>
In-Reply-To: <20230613054340.12837-3-pranavi.somisetty@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB7648:EE_|PH7PR11MB7122:EE_
x-ms-office365-filtering-correlation-id: 6871af82-5328-453a-5f28-08db6cb48e38
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BBu7nFXllIa3LWzcLIbA2ZmSoJGbuCZ2V+ztwg4BtKCuTfQCL5WIu78OeOAGRrI6xUD+qI9/oY1uC+heXaJbeTsUqt7qyPsv4TCSjqYaZKyOXbk245+UEBZjGjfejkghHhA3QFUz2HGQsprzTPRCtvN+bUk8M7jgHKcEFEmdirMJHUMroy6jEJPBpO/6RsrAcEcyrSaAhP0TMpsyE7GQNILT0E1J05i+fQk7Lj510gD+tE47cWpVtu2EBMtMSvVzwfb6k/ysR1yp2mQwixp7OzRRwTJ3rCndV03w/EkR8cJ5l8FaNex9j6V2x7DP81ic57bm63nh8v0+STb38pNjo/Bb9EQ3Dgj/Eh4AqjR6+THMAPsrZrLo2qqJE8Fq29dXx3mQNo7uHhtpbkxlAgJbQQt2iRNFY3aOm6rHnDHMpdrEVSKMDTJWClUQwjWorozFbi4VT8D3x9zpt3kEVJctUOtMNncpzlgbxsxDOMtr0gGp0mxtmz+8Z4BkHoyBD21q4yqYamSzI/Za04LQaaN/nrXEWShKczc5MJIvhfnUiccmvL8DRKeRx5vIRlPOdla94z+OoW5piMwxUl4BNTdXY8vRl27GQOAXJEN/s/4gFU/4KjV8UX6EefcjU/nUkyr/i8fj3jH8WhjuTapp3hg2X093xM9rEOxO+AkakkTAv5du220r9Mr1N/m1RBiijdQo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7648.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199021)(36756003)(31696002)(38070700005)(2906002)(86362001)(7416002)(31686004)(6486002)(83380400001)(186003)(6512007)(6506007)(26005)(53546011)(122000001)(91956017)(71200400001)(110136005)(54906003)(6636002)(76116006)(66946007)(66476007)(64756008)(66556008)(66446008)(4326008)(5660300002)(2616005)(316002)(38100700002)(478600001)(8936002)(8676002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUpHV215Wk1FTlZ6ZXplUTRTeXVIRXhOOUFZdm0xQ0k1MkRlMlo5OUNDam9a?=
 =?utf-8?B?cVpvVEJ3M1ZJcEJ2Q1NNK284dzVWRk53eHN6Zkp1cnUxdXlpcU1VZXk5WWJI?=
 =?utf-8?B?bGdFUVNYaHo0SURtcjR6T0VQRWxEdkE4Z1h3SmU4Y0VBalRCZHNXZDlBTVpI?=
 =?utf-8?B?RHRNSGYyajVaelhQMkJ3MkUxQ2xEc0JTWnEzdlFYQ1QzRDcwMGcyME5jSWJJ?=
 =?utf-8?B?OTl5QTVVRmZweUpRKzNJZWsxRURZRHpmNnQyU0xnY01DK1dEZVM0QnlIdTJs?=
 =?utf-8?B?UXBkbDdpQTdyVUNWT2Z1em5VaWlta3lSMHRsZmlKL3JVYzg3S3cxR3l0VXdk?=
 =?utf-8?B?ZmdRQVN2all3clBUYnMyL3QwZWRiYlRIZUVLM3Y3Y2FOSnRmTVBSTnd5d0dt?=
 =?utf-8?B?VHBQbmdMOTdFVkg1b3lRdHVFTzNmNDZZZE4zcGYxZ0E2bmdaRFJmZ0dJc1hI?=
 =?utf-8?B?d25jamFtcVZiOE5qbWtzcFEyNU5CYTdmK0lvKzhjSEdLbjlKSFVqcVZKRGtZ?=
 =?utf-8?B?RlcrUkVzWWhrSENsS0R1SGJSMVdPTk93ZGtJSVlKdmdkdmJJZ3FUQkpBenRB?=
 =?utf-8?B?WG1MUlhzNDVndW1lSVlLUnNaWnZ1MnJsZkZMRWpkVzg5ZG94RDU4Tkg2TGM0?=
 =?utf-8?B?VHdyVmlvT3VIdFVSY3V0YTVxTFBhSit4ZnFvSHF6ZklkS1Z4eFYxcUFkNytQ?=
 =?utf-8?B?VHc1R0ZmZFpyL1lPNDdMRTU4aFk0NkJiMjV4KzgzS2JNeFUxQjFscDE0OUdW?=
 =?utf-8?B?MmN2U1NjOEY4NHJWTlNxRS9QaFF2WGtLUkUxd09wSzYzKy9yeEg3NXVwMkpR?=
 =?utf-8?B?Z3lqbWFUTlFYVi80TzVWM0I4dzRPT09sYUdOUEQvL0V5ZHo2ZE9qOS9iWFlu?=
 =?utf-8?B?L0dXYkVTYTA0WHZMamRXWjgzanBCS29Jb0tLZFJpNFZHV1c2amk0UDlpSll1?=
 =?utf-8?B?RjUvOGVrSW1qWENZYi8rSk53MVFLeWo2WVNEMXhaU2JvSzZqMEM3ZnphcHpt?=
 =?utf-8?B?dmI3TldTVW8vUlZDSkxzb2FSS252WkxWZm5OU1JHeG53SU96UVlhZHNzQlRj?=
 =?utf-8?B?TkxrdkIrTXp5akJUTi9pUUNJTXk3Nkp2Sk9yN29HSEJtRk54WjBTNjhFU2hn?=
 =?utf-8?B?c2lpRGV2eHdDVlFpdEVXWWs1dytwZFFOMHh3WHFoRXdTWGRlQjU5ZE83OHdF?=
 =?utf-8?B?dWJXOWhGVlUwazJTemFvN25XdmQ5KzhyM2FVVzB6YUZuVCtRZlFDMkdzVnl2?=
 =?utf-8?B?cmFoNGtPNFd4djJDenFURHJod3BxMmljMnZrZllrQm1UbnBoZHJRWlJvdHd5?=
 =?utf-8?B?K0pjWk9ubnRZNTBnODF4T1dnSXlzcitDUjUzakZraktzRzNISzFySHhxZmt5?=
 =?utf-8?B?VVd2ZTRIS05WWFBvcytKYlJwN2xwZGo2TjNQNk0vRExlWllwaFQ4SkVBRGJR?=
 =?utf-8?B?SHpiNDhYTC9IZHllSnVWOThqYjJDWEZpeEF6enBVNlRhdDc3NGVyNzh1K2oz?=
 =?utf-8?B?K21RSm81a1VmU2tMbEtXQThZdlFybnhvYkNCWmVpd3gzd3dXd2x5WVBYaGt6?=
 =?utf-8?B?OXVvdGFkZUs3SStCQVZjNy9nWHV4VmV3eDlmQWhaNE5pN0NoQ0c1Qi9OdHRG?=
 =?utf-8?B?bmlhYWpBcElTNjkrVVVlVzlaOVh2SEJ4d0tYQzZZOFNyTmdla0EzamFoblk5?=
 =?utf-8?B?SHVxTktqR1dlOFY3MEs0dVdEdEFnekpyNVBJcEovYWMvS3huZUFCSFBaRUZP?=
 =?utf-8?B?OVNKMkxaL1B6TG5NNWI4b3BXWEtJVmxqRFY1Zncya3UvbUlwb2hNNGdabmNO?=
 =?utf-8?B?YWtjSzB3cHhNSjdBTmRNRnl4TWJZUTVzSUJORmFCV2VQUVJadWRjTUpCMngx?=
 =?utf-8?B?VDBEaGV2dDdRTGFncWIvaDBBUWY5VUs4YWxyc2dLZm96MzB1V0xVNXBJaytT?=
 =?utf-8?B?aStiUG5nZ25Fb2ZVNlpXanpKb0p1U3daRVJhQVZ2SmV4eGw4Mnc3RVY5OU5E?=
 =?utf-8?B?RVB6VzVUQUwyVU5lUXFlQ0dRVExCeXB4N1BkR1ZkMVdEejRzdHN3a2NiTG5B?=
 =?utf-8?B?OEZWdWQyMjEvbk15VFFtN1BDYzA1cDM5QlM2Y2dLVlI4dWwrZjZCdytsS2Iz?=
 =?utf-8?Q?CklhgawGFqDsblViXCtFzFyy3?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC8F07318C29984BB041955F5CF6DEF4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7648.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6871af82-5328-453a-5f28-08db6cb48e38
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 08:51:33.8978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xOM++kkToF/3h4D8z598YYtXEpVqewUu6WHxjg8iDOaDGPDiFGozgpt711lcaeC8WjMcl3qRyJvsGLWUSMeRHyZvOVHq+ceORahX4A0mdOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7122
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gMTMuMDYuMjAyMyAwODo0MywgUHJhbmF2aSBTb21pc2V0dHkgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gRnJvbTogTWF1bGlrIEpvZGhhbmkgPG1h
dWxpay5qb2RoYW5pQHhpbGlueC5jb20+DQo+IA0KPiBXaGVuIHRoZSByZWNlaXZlIHBhcnRpYWwg
c3RvcmUgYW5kIGZvcndhcmQgbW9kZSBpcyBhY3RpdmF0ZWQsIHRoZQ0KPiByZWNlaXZlciB3aWxs
IG9ubHkgYmVnaW4gdG8gZm9yd2FyZCB0aGUgcGFja2V0IHRvIHRoZSBleHRlcm5hbCBBSEINCj4g
b3IgQVhJIHNsYXZlIHdoZW4gZW5vdWdoIHBhY2tldCBkYXRhIGlzIHN0b3JlZCBpbiB0aGUgcGFj
a2V0IGJ1ZmZlci4NCj4gVGhlIGFtb3VudCBvZiBwYWNrZXQgZGF0YSByZXF1aXJlZCB0byBhY3Rp
dmF0ZSB0aGUgZm9yd2FyZGluZyBwcm9jZXNzDQo+IGlzIHByb2dyYW1tYWJsZSB2aWEgd2F0ZXJt
YXJrIHJlZ2lzdGVycyB3aGljaCBhcmUgbG9jYXRlZCBhdCB0aGUgc2FtZQ0KPiBhZGRyZXNzIGFz
IHRoZSBwYXJ0aWFsIHN0b3JlIGFuZCBmb3J3YXJkIGVuYWJsZSBiaXRzLiBBZGRpbmcgc3VwcG9y
dCB0bw0KPiByZWFkIHRoaXMgcngtd2F0ZXJtYXJrIHZhbHVlIGZyb20gZGV2aWNlLXRyZWUsIHRv
IHByb2dyYW0gdGhlIHdhdGVybWFyaw0KPiByZWdpc3RlcnMgYW5kIGVuYWJsZSBwYXJ0aWFsIHN0
b3JlIGFuZCBmb3J3YXJkaW5nLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWF1bGlrIEpvZGhhbmkg
PG1hdWxpay5qb2RoYW5pQHhpbGlueC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFByYW5hdmkgU29t
aXNldHR5IDxwcmFuYXZpLnNvbWlzZXR0eUBhbWQuY29tPg0KDQpSZXZpZXdlZC1ieTogQ2xhdWRp
dSBCZXpuZWEgPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+DQoNCg0KPiAtLS0NCj4gQ2hh
bmdlcyB2MjoNCj4gMS4gUmVtb3ZlZCBhbGwgdGhlIGNoYW5nZXMgcmVsYXRlZCB0byB2YWxpZGF0
aW5nIEZDUyB3aGVuIFJ4IGNoZWNrc3VtIG9mZmxvYWQgaXMgZGlzYWJsZWQuDQo+IDIuIEluc3Rl
YWQgb2YgdXNpbmcgYSBwbGF0Zm9ybSBkZXBlbmRlbnQgbnVtYmVyICgweEZGRikgZm9yIHRoZSBy
ZXNldCB2YWx1ZSBvZiByeCB3YXRlcm1hcmssDQo+IGRlcml2ZSBpdCBmcm9tIGRlc2lnbmNmZ19k
ZWJ1ZzIgcmVnaXN0ZXIuDQo+IDMuIEFkZGVkIGEgY2hlY2sgdG8gc2VlIGlmIHBhcnRpYWwgcy9m
IGlzIHN1cHBvcnRlZCwgYnkgcmVhZGluZyB0aGUNCj4gZGVzaWduY2ZnX2RlYnVnNiByZWdpc3Rl
ci4NCj4gDQo+IENoYW5nZXMgdjM6DQo+IDEuIEZvbGxvd2VkIHJldmVyc2UgY2hyaXN0bWFzIHRy
ZWUgcGF0dGVybiBpbiBkZWNsYXJpbmcgdmFyaWFibGVzLg0KPiAyLiBSZXR1cm4gLUVJTlZBTCB3
aGVuIGFuIGludmFsaWQgd2F0ZXJtYXJrIHZhbHVlIGlzIHNldC4NCj4gMy4gUmVtb3ZlZCBuZXRk
ZXZfaW5mbyB3aGVuIHBhcnRpYWwgc3RvcmUgYW5kIGZvcndhcmQgaXMgbm90IGVuYWJsZWQuDQo+
IDQuIFZhbGlkYXRpbmcgdGhlIHJ4LXdhdGVybWFyayB2YWx1ZSBpbiBwcm9iZSBpdHNlbGYgYW5k
IG9ubHkgd3JpdGUgdG8gdGhlIHJlZ2lzdGVyDQo+IGluIGluaXQuDQo+IDUuIFdyaXRpbmcgYSBy
ZXNldCB2YWx1ZSB0byB0aGUgcGJ1Zl9jdXRocnUgcmVnaXN0ZXIgYmVmb3JlIGRpc2FiaW5nIHBh
cnRpYWwgc3RvcmUNCj4gYW5kIGZvcndhcmQgaXMgcmVkdW5kYW50LiBTbyByZW1vdmluZyBpdC4N
Cj4gNi4gUmVtb3ZlZCB0aGUgcGxhdGZvcm0gY2FwcyBmbGFnLg0KPiA3LiBJbnN0ZWFkIG9mIHJl
YWRpbmcgcngtd2F0ZXJtYXJrIGZyb20gRFQgaW4gbWFjYl9jb25maWd1cmVfY2FwcywNCj4gcmVh
ZGluZyBpdCBpbiBwcm9iZS4NCj4gOC4gQ2hhbmdlZCBTaWduZWQtT2ZmLUJ5IGFuZCBhdXRob3Ig
bmFtZXMgb24gdGhpcyBwYXRjaC4NCj4gDQo+IENoYW5nZXMgdjQ6DQo+IDEuIFJlbW92ZWQgcmVk
dW5kYW50IGNvZGUgYW5kIHVudXNlZCB2YXJpYWJsZXMuDQo+IDIuIFdoZW4gdGhlIHJ4LXdhdGVy
bWFyayB2YWx1ZSBpcyBpbnZhbGlkLCBpbnN0ZWFkIG9mIHJldHVybmluZyBFSU5WQUwsDQo+IGRv
IG5vdCBlbmFibGUgcGFydGlhbCBzdG9yZSBhbmQgZm9yd2FyZC4NCj4gMy4gQ2hhbmdlIHJ4LXdh
dGVybWFyayB2YXJpYWJsZSdzIHNpemUgdG8gdTMyIGluc3RlYWQgb2YgdTE2Lg0KPiAtLS0NCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYi5oICAgICAgfCAxMiArKysrKysrKysr
Kw0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDI3ICsrKysr
KysrKysrKysrKysrKysrKysrKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAzOSBpbnNlcnRpb25zKCsp
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiLmgg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2IuaA0KPiBpbmRleCAxNGRmZWM0ZGI4
ZjkuLjM5ZDUzMTE3YThjZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2Fk
ZW5jZS9tYWNiLmgNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiLmgN
Cj4gQEAgLTgyLDYgKzgyLDcgQEANCj4gICNkZWZpbmUgR0VNX05DRkdSICAgICAgICAgICAgICAw
eDAwMDQgLyogTmV0d29yayBDb25maWcgKi8NCj4gICNkZWZpbmUgR0VNX1VTUklPICAgICAgICAg
ICAgICAweDAwMGMgLyogVXNlciBJTyAqLw0KPiAgI2RlZmluZSBHRU1fRE1BQ0ZHICAgICAgICAg
ICAgIDB4MDAxMCAvKiBETUEgQ29uZmlndXJhdGlvbiAqLw0KPiArI2RlZmluZSBHRU1fUEJVRlJY
Q1VUICAgICAgICAgIDB4MDA0NCAvKiBSWCBQYXJ0aWFsIFN0b3JlIGFuZCBGb3J3YXJkICovDQo+
ICAjZGVmaW5lIEdFTV9KTUwgICAgICAgICAgICAgICAgICAgICAgICAweDAwNDggLyogSnVtYm8g
TWF4IExlbmd0aCAqLw0KPiAgI2RlZmluZSBHRU1fSFNfTUFDX0NPTkZJRyAgICAgIDB4MDA1MCAv
KiBHRU0gaGlnaCBzcGVlZCBjb25maWcgKi8NCj4gICNkZWZpbmUgR0VNX0hSQiAgICAgICAgICAg
ICAgICAgICAgICAgIDB4MDA4MCAvKiBIYXNoIEJvdHRvbSAqLw0KPiBAQCAtMzQzLDYgKzM0NCwx
MCBAQA0KPiAgI2RlZmluZSBHRU1fQUREUjY0X1NJWkUgICAgICAgICAgICAgICAgMQ0KPiANCj4g
DQo+ICsvKiBCaXRmaWVsZHMgaW4gUEJVRlJYQ1VUICovDQo+ICsjZGVmaW5lIEdFTV9FTkNVVFRI
UlVfT0ZGU0VUICAgMzEgLyogRW5hYmxlIFJYIHBhcnRpYWwgc3RvcmUgYW5kIGZvcndhcmQgKi8N
Cj4gKyNkZWZpbmUgR0VNX0VOQ1VUVEhSVV9TSVpFICAgICAxDQo+ICsNCj4gIC8qIEJpdGZpZWxk
cyBpbiBOU1IgKi8NCj4gICNkZWZpbmUgTUFDQl9OU1JfTElOS19PRkZTRVQgICAwIC8qIHBjc19s
aW5rX3N0YXRlICovDQo+ICAjZGVmaW5lIE1BQ0JfTlNSX0xJTktfU0laRSAgICAgMQ0KPiBAQCAt
NTA5LDYgKzUxNCw4IEBADQo+ICAjZGVmaW5lIEdFTV9UWF9QS1RfQlVGRl9PRkZTRVQgICAgICAg
ICAgICAgICAgIDIxDQo+ICAjZGVmaW5lIEdFTV9UWF9QS1RfQlVGRl9TSVpFICAgICAgICAgICAg
ICAgICAgIDENCj4gDQo+ICsjZGVmaW5lIEdFTV9SWF9QQlVGX0FERFJfT0ZGU0VUICAgICAgICAg
ICAgICAgICAgICAgICAgMjINCj4gKyNkZWZpbmUgR0VNX1JYX1BCVUZfQUREUl9TSVpFICAgICAg
ICAgICAgICAgICAgNA0KPiANCj4gIC8qIEJpdGZpZWxkcyBpbiBEQ0ZHNS4gKi8NCj4gICNkZWZp
bmUgR0VNX1RTVV9PRkZTRVQgICAgICAgICAgICAgICAgICAgICAgICAgOA0KPiBAQCAtNTE3LDYg
KzUyNCw4IEBADQo+ICAvKiBCaXRmaWVsZHMgaW4gRENGRzYuICovDQo+ICAjZGVmaW5lIEdFTV9Q
QlVGX0xTT19PRkZTRVQgICAgICAgICAgICAgICAgICAgIDI3DQo+ICAjZGVmaW5lIEdFTV9QQlVG
X0xTT19TSVpFICAgICAgICAgICAgICAgICAgICAgIDENCj4gKyNkZWZpbmUgR0VNX1BCVUZfQ1VU
VEhSVV9PRkZTRVQgICAgICAgICAgICAgICAgICAgICAgICAyNQ0KPiArI2RlZmluZSBHRU1fUEJV
Rl9DVVRUSFJVX1NJWkUgICAgICAgICAgICAgICAgICAxDQo+ICAjZGVmaW5lIEdFTV9EQVc2NF9P
RkZTRVQgICAgICAgICAgICAgICAgICAgICAgIDIzDQo+ICAjZGVmaW5lIEdFTV9EQVc2NF9TSVpF
ICAgICAgICAgICAgICAgICAgICAgICAgIDENCj4gDQo+IEBAIC0xMjgzLDYgKzEyOTIsOSBAQCBz
dHJ1Y3QgbWFjYiB7DQo+IA0KPiAgICAgICAgIHUzMiAgICAgICAgICAgICAgICAgICAgIHdvbDsN
Cj4gDQo+ICsgICAgICAgLyogaG9sZHMgdmFsdWUgb2Ygcnggd2F0ZXJtYXJrIHZhbHVlIGZvciBw
YnVmX3J4Y3V0dGhydSByZWdpc3RlciAqLw0KPiArICAgICAgIHUzMiAgICAgICAgICAgICAgICAg
ICAgIHJ4X3dhdGVybWFyazsNCj4gKw0KPiAgICAgICAgIHN0cnVjdCBtYWNiX3B0cF9pbmZvICAg
ICpwdHBfaW5mbzsgICAgICAvKiBtYWNiLXB0cCBpbnRlcmZhY2UgKi8NCj4gDQo+ICAgICAgICAg
c3RydWN0IHBoeSAgICAgICAgICAgICAgKnNnbWlpX3BoeTsgICAgIC8qIGZvciBaeW5xTVAgU0dN
SUkgbW9kZSAqLw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9t
YWNiX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4g
aW5kZXggNDE5NjRmZDAyNDUyLi43ZDAyM2I5MmIxNjkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBAQCAtMjYxNyw2ICsyNjE3LDkgQEAgc3RhdGlj
IHZvaWQgbWFjYl9yZXNldF9odyhzdHJ1Y3QgbWFjYiAqYnApDQo+ICAgICAgICAgbWFjYl93cml0
ZWwoYnAsIFRTUiwgLTEpOw0KPiAgICAgICAgIG1hY2Jfd3JpdGVsKGJwLCBSU1IsIC0xKTsNCj4g
DQo+ICsgICAgICAgLyogRGlzYWJsZSBSWCBwYXJ0aWFsIHN0b3JlIGFuZCBmb3J3YXJkIGFuZCBy
ZXNldCB3YXRlcm1hcmsgdmFsdWUgKi8NCj4gKyAgICAgICBnZW1fd3JpdGVsKGJwLCBQQlVGUlhD
VVQsIDApOw0KPiArDQo+ICAgICAgICAgLyogRGlzYWJsZSBhbGwgaW50ZXJydXB0cyAqLw0KPiAg
ICAgICAgIGZvciAocSA9IDAsIHF1ZXVlID0gYnAtPnF1ZXVlczsgcSA8IGJwLT5udW1fcXVldWVz
OyArK3EsICsrcXVldWUpIHsNCj4gICAgICAgICAgICAgICAgIHF1ZXVlX3dyaXRlbChxdWV1ZSwg
SURSLCAtMSk7DQo+IEBAIC0yNzcwLDYgKzI3NzMsMTAgQEAgc3RhdGljIHZvaWQgbWFjYl9pbml0
X2h3KHN0cnVjdCBtYWNiICpicCkNCj4gICAgICAgICAgICAgICAgIGJwLT5yeF9mcm1fbGVuX21h
c2sgPSBNQUNCX1JYX0pGUk1MRU5fTUFTSzsNCj4gDQo+ICAgICAgICAgbWFjYl9jb25maWd1cmVf
ZG1hKGJwKTsNCj4gKw0KPiArICAgICAgIC8qIEVuYWJsZSBSWCBwYXJ0aWFsIHN0b3JlIGFuZCBm
b3J3YXJkIGFuZCBzZXQgd2F0ZXJtYXJrICovDQo+ICsgICAgICAgaWYgKGJwLT5yeF93YXRlcm1h
cmspDQo+ICsgICAgICAgICAgICAgICBnZW1fd3JpdGVsKGJwLCBQQlVGUlhDVVQsIChicC0+cnhf
d2F0ZXJtYXJrIHwgR0VNX0JJVChFTkNVVFRIUlUpKSk7DQo+ICB9DQo+IA0KPiAgLyogVGhlIGhh
c2ggYWRkcmVzcyByZWdpc3RlciBpcyA2NCBiaXRzIGxvbmcgYW5kIHRha2VzIHVwIHR3bw0KPiBA
QCAtNDkyMyw2ICs0OTMwLDcgQEAgc3RhdGljIGludCBtYWNiX3Byb2JlKHN0cnVjdCBwbGF0Zm9y
bV9kZXZpY2UgKnBkZXYpDQo+ICAgICAgICAgcGh5X2ludGVyZmFjZV90IGludGVyZmFjZTsNCj4g
ICAgICAgICBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2Ow0KPiAgICAgICAgIHN0cnVjdCByZXNvdXJj
ZSAqcmVnczsNCj4gKyAgICAgICB1MzIgd3RybXJrX3JzdF92YWw7DQo+ICAgICAgICAgdm9pZCBf
X2lvbWVtICptZW07DQo+ICAgICAgICAgc3RydWN0IG1hY2IgKmJwOw0KPiAgICAgICAgIGludCBl
cnIsIHZhbDsNCj4gQEAgLTQ5OTUsNiArNTAwMywyNSBAQCBzdGF0aWMgaW50IG1hY2JfcHJvYmUo
c3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gDQo+ICAgICAgICAgYnAtPnVzcmlvID0g
bWFjYl9jb25maWctPnVzcmlvOw0KPiANCj4gKyAgICAgICAvKiBCeSBkZWZhdWx0IHdlIHNldCB0
byBwYXJ0aWFsIHN0b3JlIGFuZCBmb3J3YXJkIG1vZGUgZm9yIHp5bnFtcC4NCj4gKyAgICAgICAg
KiBEaXNhYmxlIGlmIG5vdCBzZXQgaW4gZGV2aWNldHJlZS4NCj4gKyAgICAgICAgKi8NCj4gKyAg
ICAgICBpZiAoR0VNX0JGRVhUKFBCVUZfQ1VUVEhSVSwgZ2VtX3JlYWRsKGJwLCBEQ0ZHNikpKSB7
DQo+ICsgICAgICAgICAgICAgICBlcnIgPSBvZl9wcm9wZXJ0eV9yZWFkX3UzMihicC0+cGRldi0+
ZGV2Lm9mX25vZGUsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAiY2RucyxyeC13YXRlcm1hcmsiLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgJmJwLT5yeF93YXRlcm1hcmspOw0KPiArDQo+ICsgICAgICAgICAgICAgICBp
ZiAoIWVycikgew0KPiArICAgICAgICAgICAgICAgICAgICAgICAvKiBEaXNhYmxlIHBhcnRpYWwg
c3RvcmUgYW5kIGZvcndhcmQgaW4gY2FzZSBvZiBlcnJvciBvcg0KPiArICAgICAgICAgICAgICAg
ICAgICAgICAgKiBpbnZhbGlkIHdhdGVybWFyayB2YWx1ZQ0KPiArICAgICAgICAgICAgICAgICAg
ICAgICAgKi8NCj4gKyAgICAgICAgICAgICAgICAgICAgICAgd3RybXJrX3JzdF92YWwgPSAoMSA8
PCAoR0VNX0JGRVhUKFJYX1BCVUZfQUREUiwgZ2VtX3JlYWRsKGJwLCBEQ0ZHMikpKSkgLSAxOw0K
PiArICAgICAgICAgICAgICAgICAgICAgICBpZiAoYnAtPnJ4X3dhdGVybWFyayA+IHd0cm1ya19y
c3RfdmFsIHx8ICFicC0+cnhfd2F0ZXJtYXJrKSB7DQo+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgZGV2X2luZm8oJmJwLT5wZGV2LT5kZXYsICJJbnZhbGlkIHdhdGVybWFyayB2YWx1
ZVxuIik7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYnAtPnJ4X3dhdGVybWFy
ayA9IDA7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIH0NCj4gKyAgICAgICAgICAgICAgIH0N
Cj4gKyAgICAgICB9DQo+ICAgICAgICAgc3Bpbl9sb2NrX2luaXQoJmJwLT5sb2NrKTsNCj4gDQo+
ICAgICAgICAgLyogc2V0dXAgY2FwYWJpbGl0aWVzICovDQo+IC0tDQo+IDIuMzYuMQ0KPiANCg0K


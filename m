Return-Path: <netdev+bounces-11006-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3939731116
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:44:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D70FB1C20ADC
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF36B20E0;
	Thu, 15 Jun 2023 07:44:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4DC375
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:44:07 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632CB2103;
	Thu, 15 Jun 2023 00:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686815042; x=1718351042;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4PCVsGP/jH/glMwjmecn+ITxKl1MuyVx2mg1QQ8N1M0=;
  b=aaUtnct1LLEfDuGSFvOS9ygfpBJX21D81Sz1f+QSHs9+9E3D/wSQp5C9
   B2GrAV1Ioz+GrFnvWdQpjhSu0Hfb1Y4GH9pZUjf5sfkIyhRHBTPP+OVSk
   rplS0y+P1u+DXUVnaPxF03y91mHnHasEyDYyhNbO4ad7DyYoBZ2ZRhmb/
   wFtb/SUZEtpfzjqPd6CiwEut1TgCREgJp2q20OIKa/MTG+1yEYchXJman
   uq7sIyKAFER7jbDaUnf+7WwcC2x4FIAPC6VSe6avjupGYDA/ffwRjk+vJ
   T+hrvgyAsOpme1OMrHIPZnuoMWKTS2Ro3hzIoasF77pQtW3pXxxiOP5Iq
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="230249758"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2023 00:44:01 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 15 Jun 2023 00:44:00 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 15 Jun 2023 00:44:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4n/fzCTNN1OgTVza+WMGDEI7FbJ0TF5oPSeQu8vmwe/Imt7OuB/8RLe4KWvmMIq+3EY/oNqsVAF9oWVp5kz7qEsMsSAdQWcsdOP39qeMC8VF5EXG3d/qqCaKHfffzGdT4FMTmFEgkxkVCKDEv2U3TuG3SEmht97x4l4VlBFF3wZzjxBdN1nTpSfXTQhbkcsLhRRUh1nKqaZMVqtm3r0lmD2+spgld9zPugvvYsZ5M1S0aRUY5PLoBQTQgJ3VH/2E7VzyR/5DU5HCAPI2GExugDmPwhrt7hIAZKVq6K0s5jrrsmF71zt50X1v1Si0vCMxlRv0ekWEH6TlezffiZrnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4PCVsGP/jH/glMwjmecn+ITxKl1MuyVx2mg1QQ8N1M0=;
 b=fLWJe3ayIOtuoBKK7fxUXQLbbWuReWc4S41ayAANWOCKRO54itGRVtoOx8d3ZMGuJi5N6/emz7gqDhvGd3DDjwmSL1PMkrj1GxqT9L4X9FaA/2/uY+fRrcmHK9PQf88fDBijDou1YNeU+L6UhtZn2NAhyu9mnc/93k8TgHn+4qiULTi3Em/wtVQ7JfgE134FiVFk5f+bCbrmHtRa4MSeBGE+OpU2TbQG0Mosyd4NnEg1Pcl4ajXYZPD1Uj/r8L9jWYDSj2Kpn67tSoLLgRSpxKQerUtlDb+6XbdD3oVELvJV9MgzBJFDnV/zD3HRibCGbBY/kMvkuDWgB9X+Yyz5kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PCVsGP/jH/glMwjmecn+ITxKl1MuyVx2mg1QQ8N1M0=;
 b=HmkIZoREQMAsq0nA+EcKQxKXDKuw4io/C3iZYHq0VpsPFyg+p2wW5+AJrHI+8eaXNXpWKQUX8J1ZfOdhPOG5vukrzwU5EJfHvwGQIesBOVpgHfcG3ANfRTb44Q5c90faO9fUYEnJh1dNeZwY/NrBgkI+uOdi6u+ljeKpL4JkBqk=
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com (2603:10b6:a03:4c3::17)
 by BN9PR11MB5243.namprd11.prod.outlook.com (2603:10b6:408:134::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.38; Thu, 15 Jun
 2023 07:43:58 +0000
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be]) by SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be%5]) with mapi id 15.20.6433.024; Thu, 15 Jun 2023
 07:43:58 +0000
From: <Claudiu.Beznea@microchip.com>
To: <Varshini.Rajendran@microchip.com>, <tglx@linutronix.de>,
	<maz@kernel.org>, <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
	<conor+dt@kernel.org>, <Nicolas.Ferre@microchip.com>,
	<alexandre.belloni@bootlin.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<gregkh@linuxfoundation.org>, <linux@armlinux.org.uk>,
	<mturquette@baylibre.com>, <sboyd@kernel.org>, <sre@kernel.org>,
	<broonie@kernel.org>, <arnd@arndb.de>, <gregory.clement@bootlin.com>,
	<sudeep.holla@arm.com>, <Balamanikandan.Gunasundar@microchip.com>,
	<Mihai.Sain@microchip.com>, <linux-kernel@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<linux-clk@vger.kernel.org>, <linux-pm@vger.kernel.org>
CC: <Hari.PrasathGE@microchip.com>, <Cristian.Birsan@microchip.com>,
	<Durai.ManickamKR@microchip.com>, <Manikandan.M@microchip.com>,
	<Dharma.B@microchip.com>, <Nayabbasha.Sayed@microchip.com>,
	<Balakrishnan.S@microchip.com>
Subject: Re: [PATCH 09/21] ARM: at91: pm: add sam9x7 soc init config
Thread-Topic: [PATCH 09/21] ARM: at91: pm: add sam9x7 soc init config
Thread-Index: AQHZn10l0do5TmMx9ESKXjQr+uZjWA==
Date: Thu, 15 Jun 2023 07:43:58 +0000
Message-ID: <ade645fd-76d1-204f-9c31-0af8ab19e48f@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-10-varshini.rajendran@microchip.com>
In-Reply-To: <20230603200243.243878-10-varshini.rajendran@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB7648:EE_|BN9PR11MB5243:EE_
x-ms-office365-filtering-correlation-id: f675107e-ff31-4402-ac5d-08db6d744788
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +yxp0yYP3RHdnAS1n0vyDCnybpOUNLoIcYkL12PZPRZ2CoYz3XWUdk4PIMhF1q1Z8MCPxlFTTKgQnHst/N5/qNzIqNSitNe2MsCAkeOi/rxJ121S9UjvBoU0hyu8+2yTVmPQphfC4j1LRGTSnRW9rrbVARUqpe4ADdwGbnuEKuptax6Ru+KqzCLvtGERaz/1d2x4EltKMbHZTPKOfBjysz1hmROQZdORGhtOezFtPd9TdgrpkU27gRWmof5upMrxbvTLSn1r2JXRlzMbJN0OmW26XGnyg8o8h+ERGG/D724dHIDwUq912K2MFoRBop8qE3kmWSrYdDF3pWfRqTMLsKk6ldqbR+CMTYFuXqSlw1A3kZ1piwS0dF/woUVqsUlE8NMARhb5FXCN0C2GfcGRfezI3DvjMfNfsbxP9LX76xiDdTKCCzqgHhB84CHie2MiJqNRtLyoe6JfFlA9sxFV3HzJHykIae1TxWOplPEpVzhS6Blrxd34T+7orFCKKQmpJHru2EWgk8P/lJ9JWVYFoOBFa0Rbll0tARJKiyu6gwJKu4J2SzFjAYMOsSxz6dLGxK1yICwfN0kEd554nbOfuQhvM80Fr1JYF4R/gmhfEZrS5SjEY/SK8mR0Mt3H6m6vagS5b9mu/ClTNt+wPHCOB78NW/9fTqhB3pGYApasCv7Dsox38Hmnd3vt7BxCxmX+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7648.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(396003)(136003)(376002)(451199021)(4326008)(66556008)(91956017)(66946007)(316002)(66476007)(66446008)(64756008)(76116006)(6486002)(71200400001)(36756003)(110136005)(107886003)(8676002)(5660300002)(31686004)(8936002)(41300700001)(478600001)(54906003)(31696002)(53546011)(86362001)(7416002)(38070700005)(186003)(2906002)(38100700002)(122000001)(921005)(6512007)(26005)(6506007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q21jRjZ4SEE3U2FwSDJCQnR5Q3FwVGFnc0xqdkNheVFXK3l3RjBEOUNzd2Fm?=
 =?utf-8?B?STNyKzFvKzBOQklVcXBQQ0s2QndFalNMblFqTGE2M2VFYjJ0andrUUpLRzlQ?=
 =?utf-8?B?UEVqd2FyT3BPUnNMdm9ySXlWbmI0N0Fad0svOGh6WVg1a3N3VVYyVHNSa2M0?=
 =?utf-8?B?Skh4RVJKVUNOM2xSVWVwZGlUU3BkZHRBOUpBMG4rZyt3TWlzeTgxWGZTbE1r?=
 =?utf-8?B?SXpTbEFCSTRRbXhCN3AvN05PelJzcGdpWWFId0NHU0tMc1JZZ2tPTlN4bXVL?=
 =?utf-8?B?RGQ1ci9zaTR5TDhXd0x0YlB4ODAzV3dDTnNsaEE4N2pXWHhMaFU0VjVncjdu?=
 =?utf-8?B?ZldKSUxWOTNnYm5DeXZFell6a09BTUNwdHRGSUtKQnFBV1dLSHNyZTNqblBh?=
 =?utf-8?B?MDBUVFBEbXdSWHNncHB1L1pya3haTkNBS3pMVHRYTjBRKzQ4bEJmOEhPMmx6?=
 =?utf-8?B?cG1ZNlRzY2Vha3hYbE9XbTJuS2FVbEVsVDRVLzZ5UmJHUmN4aDhtRkVjOSty?=
 =?utf-8?B?VUE1UDZaWk9xZlZLUHFlSUthOU5pUzNtRDQzM1QzTFJnUkQ5clhNVFVkZktz?=
 =?utf-8?B?QisvUmVoVE0xek9rcituV0tNeGp5ZExwcVVlM2RhM3UvaERQSnh2UEtMZVRY?=
 =?utf-8?B?VDlRcUJHalBCMTVwcldzRVJPdDRMVW1adTVPZjl5eVBlZWxhRnBuWUhISWpt?=
 =?utf-8?B?N0xtNjlLVGtLbExMMkFYTlNHN0IrUnRvWTJUTzhwRnN0cVh0WlhkSmVEdjNk?=
 =?utf-8?B?RFRYUzRyQVc2S3RyU0E2SHdHRTgyQWFFTEpITHBYZi94MWR2aTEvNTk2MGJn?=
 =?utf-8?B?K21yVVBBdXdiMzNtVnpqZzhRSFFNNHJYYkxhbWxKU05JeEs2amlvRnUvaGpI?=
 =?utf-8?B?V0RzU3pwb3R4Y0NnUi94dDRDZ3J6Q0FxRmQvWHAzVXBZbnY3aWVTQXFkeGpC?=
 =?utf-8?B?b010d1JkYWwrOEpJYXczUE9hTEwra3BCM1QyV29URXBLYzdaNXZmN3V0VEhF?=
 =?utf-8?B?eFdSVTZCcFVsS1g5WDFiOTF1S3g1YzdPZXpFczJBV0RtcXluNExFaEVtV1BV?=
 =?utf-8?B?TzNxWXdNUlYwM3cxalQzSmFoUHg5S2tuc0tZTVptMlFqbmJOQ2lENWZRc0VH?=
 =?utf-8?B?cVFwcmVCWTNQandqd2RmRlJONlFhdkpHK3ZaeWZzMTM1aW1VUyt1YkhLV0pq?=
 =?utf-8?B?bzhBb3gxcS9vdjJzYnVIZnNwT1B2ZXFuTHk1cEpsNWF5ZGhBSGQ0Y2F2eEpJ?=
 =?utf-8?B?SGFtZisrVVE3ZExnSU1waGFuVU5jbmdjUndXUVhTQlFDNXVFazFQNUIwcmtW?=
 =?utf-8?B?VVM3Qys1Y2NwMGJxdG9ybk9HWnYzcHlVc1dvUjUrQXI1ZGZwbGxHaGp6OG1F?=
 =?utf-8?B?VXZiR2t4NnB1QlgyT3JGY2Z2SlVZT1ZZa0VjVktwMWFUOUROVy9xTVRGMlE1?=
 =?utf-8?B?VlJJdVN5eGU5MTZaZW81Um5sejBiK1prdTg0Z1lDc0w5MEdFckV6anFHc0xn?=
 =?utf-8?B?MkJCZWZQdjZkSnc3UEFVK1hCUGZ0cVY1bXlDOXk1bGhiQ1BNbXFtcjFjUGRJ?=
 =?utf-8?B?b3N4YmJ0eGs3S0tTa1o5ZTFHSWNJMkVjVUpmZHBTUFR6alNPUU1KSnpjdk9H?=
 =?utf-8?B?SU9YdUJyUEI1QThJUUorL29wWW50LzJ2Y25BOUIzdTdjY1NjcmtEdlNIVUZ6?=
 =?utf-8?B?VlZYajVIS0F0MEVZOTFsRlZRSDgrZkcrallCVFU2UnQ4N2ZicVk5Z1FCRnQ1?=
 =?utf-8?B?cDR6NHA3ZFBQNCs0S2ordWVjYWpmVmxLYkpLSXhSMkNqN1Z4b29ZNXhJRFVU?=
 =?utf-8?B?VEkxa2N4TWh6MzExUjgzSGlkWVkwd0ExcUEveTBZZTlkS042NHU1cmt5RGJN?=
 =?utf-8?B?NjFIVFFqTldJd1FBOGo4aGNFbUhZb3VsQTFHUlhHK0ZwWXdwSmNKd1lpM2Rl?=
 =?utf-8?B?S3paclRQM0dLU1FkSWoybnl3STdyZjRLM1pvZU82L1JyZVFPKzdmUlRJQXJw?=
 =?utf-8?B?YmZaMUI0QWcvdjJlUDY1YVJtdXI2Nk15ZU15dkhJUHNodFVaUERPY0Q4MGFZ?=
 =?utf-8?B?OUZwMENwQ04wcjdEQzlTL0tUMzZiQStYeGJLbzdWMVN0cWxqK1JBTzl6a1NZ?=
 =?utf-8?Q?a3iSlT9C565k4dcXK+wgUtpNH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B3BCC2D4F95D7498F5298F930E01D15@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7648.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f675107e-ff31-4402-ac5d-08db6d744788
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 07:43:58.6220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gmkArQWt1h1zSl1dtd1d2o9uzZjvjcNpyKZDaLdSU7KGyKv+pkpsctjGbtlKFlVPGfk2uhSudg6JuJGF4vykNKauEjJJ2fEKk4QqZN4zu0M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5243
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gMDMuMDYuMjAyMyAyMzowMiwgVmFyc2hpbmkgUmFqZW5kcmFuIHdyb3RlOg0KPiBBZGQgU29D
IGluaXQgY29uZmlnIGZvciBzYW05eDcgZmFtaWx5DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBWYXJz
aGluaSBSYWplbmRyYW4gPHZhcnNoaW5pLnJhamVuZHJhbkBtaWNyb2NoaXAuY29tPg0KPiAtLS0N
Cj4gIGFyY2gvYXJtL21hY2gtYXQ5MS9NYWtlZmlsZSB8ICAxICsNCj4gIGFyY2gvYXJtL21hY2gt
YXQ5MS9zYW05eDcuYyB8IDM0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4g
IDIgZmlsZXMgY2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKQ0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0
IGFyY2gvYXJtL21hY2gtYXQ5MS9zYW05eDcuYw0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJt
L21hY2gtYXQ5MS9NYWtlZmlsZSBiL2FyY2gvYXJtL21hY2gtYXQ5MS9NYWtlZmlsZQ0KPiBpbmRl
eCA3OTRiZDEyYWIwYTguLjdkOGE3YmM0NGU2NSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm0vbWFj
aC1hdDkxL01ha2VmaWxlDQo+ICsrKyBiL2FyY2gvYXJtL21hY2gtYXQ5MS9NYWtlZmlsZQ0KPiBA
QCAtNyw2ICs3LDcgQEANCj4gIG9iai0kKENPTkZJR19TT0NfQVQ5MVJNOTIwMCkJKz0gYXQ5MXJt
OTIwMC5vDQo+ICBvYmotJChDT05GSUdfU09DX0FUOTFTQU05KQkrPSBhdDkxc2FtOS5vDQo+ICBv
YmotJChDT05GSUdfU09DX1NBTTlYNjApCSs9IHNhbTl4NjAubw0KPiArb2JqLSQoQ09ORklHX1NP
Q19TQU05WDcpCSs9IHNhbTl4Ny5vDQo+ICBvYmotJChDT05GSUdfU09DX1NBTUE1KQkJKz0gc2Ft
YTUubyBzYW1fc2VjdXJlLm8NCj4gIG9iai0kKENPTkZJR19TT0NfU0FNQTcpCQkrPSBzYW1hNy5v
DQo+ICBvYmotJChDT05GSUdfU09DX1NBTVY3KQkJKz0gc2Ftdjcubw0KPiBkaWZmIC0tZ2l0IGEv
YXJjaC9hcm0vbWFjaC1hdDkxL3NhbTl4Ny5jIGIvYXJjaC9hcm0vbWFjaC1hdDkxL3NhbTl4Ny5j
DQo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAwMC4uZTMyMmM1YTNj
ZGI2DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvYXJjaC9hcm0vbWFjaC1hdDkxL3NhbTl4Ny5j
DQo+IEBAIC0wLDAgKzEsMzQgQEANCj4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwt
Mi4wKw0KPiArLyoNCj4gKyAqIFNldHVwIGNvZGUgZm9yIFNBTTlYNy4NCj4gKyAqDQo+ICsgKiBD
b3B5cmlnaHQgKEMpIDIwMjIgTWljcm9jaGlwIFRlY2hub2xvZ3kgSW5jLiBhbmQgaXRzIHN1YnNp
ZGlhcmllcw0KDQoyMDIzPw0KDQo+ICsgKg0KPiArICogQXV0aG9yOiBWYXJzaGluaSBSYWplbmRy
YW4gPHZhcnNoaW5pLnJhamVuZHJhbkBtaWNyb2NoaXAuY29tPg0KPiArICovDQo+ICsNCj4gKyNp
bmNsdWRlIDxsaW51eC9vZi5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L29mX3BsYXRmb3JtLmg+DQo+
ICsNCj4gKyNpbmNsdWRlIDxhc20vbWFjaC9hcmNoLmg+DQo+ICsjaW5jbHVkZSA8YXNtL3N5c3Rl
bV9taXNjLmg+DQo+ICsNCj4gKyNpbmNsdWRlICJnZW5lcmljLmgiDQo+ICsNCj4gK3N0YXRpYyB2
b2lkIF9faW5pdCBzYW05eDdfaW5pdCh2b2lkKQ0KPiArew0KPiArCW9mX3BsYXRmb3JtX2RlZmF1
bHRfcG9wdWxhdGUoTlVMTCwgTlVMTCwgTlVMTCk7DQo+ICsNCj4gKwlzYW05eDdfcG1faW5pdCgp
Ow0KPiArfQ0KPiArDQo+ICtzdGF0aWMgY29uc3QgY2hhciAqY29uc3Qgc2FtOXg3X2R0X2JvYXJk
X2NvbXBhdFtdIF9faW5pdGNvbnN0ID0gew0KPiArCSJtaWNyb2NoaXAsc2FtOXg3IiwNCj4gKwlO
VUxMDQo+ICt9Ow0KPiArDQo+ICtEVF9NQUNISU5FX1NUQVJUKHNhbTl4N19kdCwgIk1pY3JvY2hp
cCBTQU05WDciKQ0KPiArCS8qIE1haW50YWluZXI6IE1pY3JvY2hpcCAqLw0KPiArCS5pbml0X21h
Y2hpbmUJPSBzYW05eDdfaW5pdCwNCj4gKwkuZHRfY29tcGF0CT0gc2FtOXg3X2R0X2JvYXJkX2Nv
bXBhdCwNCj4gK01BQ0hJTkVfRU5EDQoNCg==


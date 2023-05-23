Return-Path: <netdev+bounces-4562-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3620770D3AF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:14:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E74B41C20C70
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902F41C742;
	Tue, 23 May 2023 06:14:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8071B918
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:14:01 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C91130;
	Mon, 22 May 2023 23:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684822434; x=1716358434;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wcxmapf1x+KFpSHAzEkLWVAyP1P0vZXqRSJIko7FPQM=;
  b=jP/Rebu7biPVQhRRX5s6gbJw9XwquXFoBs2G0bO1ee9DRTNTBW7MoCfI
   fgV1yqwQvF3MGJtgXFkr/EbO3+Prx8nrd725MEoUsO94tThEOPkZmtBkr
   B1kGBGRoITnbgHzaTV94yhyPszMa9jmrioUEQATA9aPmP+2Dr5UPpOWEX
   UIQ6yL9fKEg/Dt/siHpV09W3nlMH0cD1bRL6PSkFZOI8XWtSbgri6v3fj
   YKSg2tWbmBvQb+PRMJHZY2pWeWyyDBuwtnHbHdslB18ka3J8CmkGP8CjQ
   xNYynakof0X9yCS/U+/WpS4dD7gJI38KoxaRhKGSdx7aD6Mhy0BFkfzLs
   w==;
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="214451970"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 23:13:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 23:13:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 22 May 2023 23:13:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UwdYIaeqv2cqobA+SeqmJiqleUnuXRzUKMCP8ym4QjLktUZuDPwfc/uFEjXkPW31ZBSNcGZ/QginzuX9pCtcnUb0NphY48IRZc57a0Nu+VJKKDigQlC48tah3NHc06gSEWj6IANNid2IUb6O2PZbmSXfhjUvMiH552aeSDDPX1FJ/gXSwzs6uCyUAW2BQ3aDXilQzjPcEVo+AS/CxU7WR9h4RkDRzgdbIL3BTea01j2R5c/VeOpErjaDV3m7h4K1hXxHGHs99SsorO5UPJ2xcDG1qOy8m0b41yeYF+xXPd5c65BfrxO4p74hZxEzmXeYVJPO+7yfXMTjq/GBw+t41Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcxmapf1x+KFpSHAzEkLWVAyP1P0vZXqRSJIko7FPQM=;
 b=Witmk1H9oevhLvrxWUPHTCjiUtj6pNHPInqhEzxEamit9YFZGWRw5xs7mV8j9OM+kH+Xaw4QuR9pbLRw3we88lj0RoSXIhm2XP2endpHV2Mm62pPfvP4L6LgsPZk1XQGrPNu63Ywf+dI+f1WtEg+CzNaS7D2jffe7NPi4judDXnv06S5UFRfCZxBvxfXTDio/HNh5VNgD3+ASr+kM26vYaD8al7XTBj6KfqRp5wcy2tLz5gjDU+/fKnr2h5Da6EBSosQPkjVqFJFuyAjuxHq5hLTkHVIbtp0qQf3ksEJM4ewtljE1oS+12zBGNPbMVZy3T1HS2RERVgC/DgRDQZ2Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcxmapf1x+KFpSHAzEkLWVAyP1P0vZXqRSJIko7FPQM=;
 b=qw5chMuLn8zKIBRmdTcnNS2E1C9eDmklpGK5SZyzmesZCX5/PGSJNefbJjV293qYXuK3s+axuLAv95PBe6selmSS2JZBzN4V3bkMyGMJrDiSdVXTJm78EX7RWusy1aBwOMb++Tz5xhtQYnw0y1bjmGhfimEv+3+BF9mH1vm97TY=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 DS7PR11MB6126.namprd11.prod.outlook.com (2603:10b6:8:9e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Tue, 23 May 2023 06:13:50 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6411.027; Tue, 23 May 2023
 06:13:50 +0000
From: <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>
CC: <hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ramon.nordin.rodriguez@ferroamp.se>, <Horatiu.Vultur@microchip.com>,
	<Woojung.Huh@microchip.com>, <Nicolas.Ferre@microchip.com>,
	<Thorsten.Kummermehr@microchip.com>
Subject: Re: [PATCH net-next v2 6/6] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Thread-Topic: [PATCH net-next v2 6/6] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Thread-Index: AQHZjKFXg4D7h/qJg0WxwlInlNp8HK9mQHSAgAEiHQA=
Date: Tue, 23 May 2023 06:13:50 +0000
Message-ID: <f366d388-420a-082d-ed26-25e93d143671@microchip.com>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
 <20230522113331.36872-7-Parthiban.Veerasooran@microchip.com>
 <349e1c57-24c6-46fa-b0ab-c6225ae1ece4@lunn.ch>
In-Reply-To: <349e1c57-24c6-46fa-b0ab-c6225ae1ece4@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|DS7PR11MB6126:EE_
x-ms-office365-filtering-correlation-id: 7730a3f0-44fe-46ff-b121-08db5b54e08c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S/HQaiQJ0ublCEu11SUCK2rGgm3nxI/hRkVL7BhpZIxo0ip9gXTfTBtaMBiDlYj2DvBrd5jkAsrDvJnCoSs9RjY141DNXi6ilunrRaCWpNl1O4gHZfHV3RYx963XrRMcQjd0MXS4ZYdB/3j84B+UhuwP/DPgq9sJs/sv7OTRmFuEwBbCZv4gBaNYx3WXqcD1WtewJElk0pHxNQHg5+yv9zkJ+ojpzd9cRuQWf9rBihcdXDhidzthzqOClHdfXDQCmc+/Y+Z83SSyOMqOalD77/YUGwTdoX7gUGmZfgrlvXx67L8xb8QCoboJtgBEbeB8Axy6hmULc5j1rFW3l605ZF3oTGFgs+cTuaxTtdKwk0H/7p2oWdRa+/lweq6rvXz/Vez0I45h8RKCmJhNu1wNPkLHg/NFpX6unNqiGSBJ8DHRwutnzAq90xXP+Ab9xdGkU5BwjJs2LK0t2es/XjJ4smujf6e876Z/7sK2BjGKCEdLvaVIFitNO4fL7/E3I4AYyJKjWyUmXsZ2zBNuayC9tqwyDgeSRp6fQVHECGFfq9bPUt29QqxW3HaN/iog6M/r6RtykGBS6WWJAZMRffWPCu2lmadEtcmU8FjrLbYb7JYucChRGQRT9acV6ttm4rDuLZArtzWqwNeZR7cvEf9zbKspL9vHYCdZwLNlkxov6R/sfSuoS5EntWEY3lTar/54
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(366004)(376002)(39860400002)(451199021)(54906003)(41300700001)(6486002)(31686004)(478600001)(31696002)(316002)(91956017)(4326008)(66476007)(64756008)(66556008)(76116006)(6916009)(66446008)(66946007)(71200400001)(5660300002)(38070700005)(86362001)(8936002)(8676002)(38100700002)(107886003)(122000001)(6512007)(6506007)(26005)(7416002)(186003)(53546011)(2906002)(2616005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cGpSYXVHWHFZMS9KbmwvTEwzSnVmYjlxbnBudjZhaWN4Tzl4QzRJcUNiTnB6?=
 =?utf-8?B?UWdxaFBQa25OcEY5WHoweTRNb3N4STdTb0ZJU1I5NU1WR3ZFZkxZRkE4VFNY?=
 =?utf-8?B?RVZoTlVFYXp1ckhMcFQycjMvNGNnaTlzUGpIWjBiTW12TlpBNGtEVVNsZEF0?=
 =?utf-8?B?ekt4c1FVTXIxNFZXRDFtekVMdUJsVHUyV28renVCb2NWRWxyUXh3c2JRSktO?=
 =?utf-8?B?cFhxeUFWU2RUaGRram9KR0xZeGhNbVczMDNIelJXM3dRMWlvUytKSG1sWGsy?=
 =?utf-8?B?VUZoaXZNSTYvdXl4aTR2QXNFYzhidzR1M1FZSnpNaEhIU2M0VzFmRnR4NjNt?=
 =?utf-8?B?UlluMkdyY2dlUkRjZzU2YS9ocDU5TjZpUzVvR2RPRkx2NW9OSGJHTmtaS1c0?=
 =?utf-8?B?RjdKRTlETFVxYmtXSDc0Ri9kZUJ4WFM5U2tzdlAzRHZ4OFphd1ovU1kyTUhL?=
 =?utf-8?B?UXdqRVNGMEFjQ2RSQzI0em40U05kbEw1MHJHVDMwTE5TaHVxQnVmRlY5cHF2?=
 =?utf-8?B?TVlSWE9vL25hcnZOSkhBWnhJY0dkUXh5WEtxOXY1K2RWRGtmZjYweVYxbUw4?=
 =?utf-8?B?dkZNMmpQUi9meTVJUE1MUWxneDBiZ2Z0ZS8wN1lwcWFHYkw4ZURTZVFsMUNK?=
 =?utf-8?B?OWhCU2JhVGVTZkYrUTdCTkVEVW5Ua3BJZmlFRklJTTBTNkpLOThPRjdZYnVm?=
 =?utf-8?B?cGtxTWNieVk4TmswUm00dXhycXZ2UFlVRWxMTnJLT2lRNXRadExuTERVdU1W?=
 =?utf-8?B?Q1BGMGJFUVlpTWVJcGwyZkh6N0F5Z2NoZ2xkQXBQTm5ZcUZCYUFPeEpCd2Jv?=
 =?utf-8?B?QUk1a2FIOFkra0UvNjBIaGdIaUZ2TmNlM3N5d1BZaVNYOU00azdrYmNGUkxE?=
 =?utf-8?B?dkI4SE5CVVBzME1wYUw0S25ySFFPY3BmT2sydjFtaGVtQzlHVFhZcEZNMVdV?=
 =?utf-8?B?QnZXS1ZZTG83djI5OElYUGlCYmZoYW95ZmJJL2Z3SmFsYkhPR255dTEzU0N6?=
 =?utf-8?B?STFCMUNQTWJFY1o3ZWkyYTdMWXpkdkVjRmFiWXdpOXJZY3IwTllSeTU1eTNl?=
 =?utf-8?B?amlrOWZ3YVU5d2lNdmxkN3lPZGhSSyt6WHIyYS8vS29NNEhWc1BYbUp0aEFQ?=
 =?utf-8?B?QVUzdkxTclh3MGRjMk9KQi9nd1lYQWZXRFdTS2Z0L2pXK0NnNXY1TzBaMXcy?=
 =?utf-8?B?QWVycENpT3JWYjBrRVpWNmI2c1daQ2tOejBQZUhHUjhUWldLN0luMm0yNjJV?=
 =?utf-8?B?U2VNZjlPWEd6Wm05M0padENXTERLSG12MVdtZzUzK25HVDNxeEhYNUZ5MFhY?=
 =?utf-8?B?c2w5LzJyV09NYWk0MXhKcDFMa0pZUExvVllDd0JsUVdoQWNZSmF4djdmbk9k?=
 =?utf-8?B?dldGdzdVdmN0T0t6Y2VMZXlXcjFKbS9GWktwUVJ5NXEwSnpTTkt2SURXNVR1?=
 =?utf-8?B?MGFybGV2eXhRdlB0dGtJU2x0MG52RUJ2Slg0ODZYTmxPcWFET3pGT2JFS0Jx?=
 =?utf-8?B?SFp5cTJGQVh0Nms0OFJpNDhFdXArZCs3ZDRWbkhWNHRrMXJLWUdnWHpsOW80?=
 =?utf-8?B?VTVaaW01WVozTkxnTjhSQTJGSXB1Sm5DZ1hxOE1xRjJBVW8wR3VUOFM5aFJI?=
 =?utf-8?B?N0oySHBjeXMvdVc0bFlJYjl0MHJkenlYWUpQdUJCSXpGdjVjcHF3ZzFxb2pQ?=
 =?utf-8?B?MlRlejRSUTNXTmZST1lHL1U1dUE5emNqMG1iOTJ2TTdSbEM5NE9aQmhFd2Iy?=
 =?utf-8?B?Mml0cmFpUXlIK2VMNlI2bG8rbDgreDFHYk1MaDJzOFFiY3hCSldtam9KempG?=
 =?utf-8?B?RXRRSjZyQU54OVNvVGxSdkR5dzhYdmVTc0ZyVHRnWTI1dU9La3dFWlNWVFJG?=
 =?utf-8?B?MDVGYU9kSmxueUlNWDNSeXFJZFJVNFdvSHVmdnFDa3Frb3pYU20zRzF5WEZK?=
 =?utf-8?B?ZW8raVpyV0llUHFEYTE2OURwc1RlZHJRV3lKNW1QODBpWEYrQ0I5c0dKcTlr?=
 =?utf-8?B?QVZpcnJDa0FtS2UwQlRDK21HL201dy94cFRtTEI3QUd6RVBvQkZhelJ6eC9x?=
 =?utf-8?B?RWFaaGJHUGtvVnI1TG43MW0wcjdLMEtudUFCSkVySkZaZWJ6cGcwUWdYMmJX?=
 =?utf-8?B?Qm9HWGU2L3NiNXNreldFN3ZHOFR1b0ttUnpyM2xCSGpOVktLbGZObWRNc0hZ?=
 =?utf-8?B?aFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5408EA2757B1504D9FDE35334BFED4AF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7730a3f0-44fe-46ff-b121-08db5b54e08c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 06:13:50.5656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UXIghnDNQalE4T4Bb29w7S1ILxfG/VB1PKOMwYgZUYYtlm3qK6udrOzQVHm6w/N97oT4fOfrSB+NpmIiVDOhkERX79DCnGqJGdgAn9KHOTeei7pEUh1fPkH8UF6zskGr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6126
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgQW5kcmV3LA0KDQpPbiAyMi8wNS8yMyA2OjI2IHBtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPj4gK3N0YXRpYyBpbnQgbGFu
ODY1eF9zZXR1cF9jZmdwYXJhbShzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPj4gK3sNCj4+
ICsgICAgIHUxNiBjZmdfcmVzdWx0c1s1XTsNCj4+ICsgICAgIHUxNiBjZmdfcGFyYW1zW0FSUkFZ
X1NJWkUobGFuODY1eF9yZXZiMF9maXh1cF9jZmdfcmVncyldOw0KPj4gKyAgICAgczggb2Zmc2V0
c1syXTsNCj4+ICsgICAgIGludCByZXQ7DQo+IA0KPiBSZXZlcnNlIENocmlzdG1hcyB0cmVlIHBs
ZWFzZS4NCkFoIHllcywgc3VyZWx5IHdpbGwgY29ycmVjdCBpdCBpbiB0aGUgbmV4dCB2ZXJzaW9u
Lg0KPiANCj4+ICsNCj4+ICsgICAgIHJldCA9IGxhbjg2NXhfZ2VuZXJhdGVfY2ZnX29mZnNldHMo
cGh5ZGV2LCBvZmZzZXRzKTsNCj4+ICsgICAgIGlmIChyZXQpDQo+PiArICAgICAgICAgICAgIHJl
dHVybiByZXQ7DQo+PiArDQo+PiArICAgICByZXQgPSBsYW44NjV4X3JlYWRfY2ZnX3BhcmFtcyhw
aHlkZXYsIGNmZ19wYXJhbXMpOw0KPiANCj4gSXMgdGhpcyBkb2luZyBhIHJlYWQgZnJvbSBmdXNl
cz8gSXMgYW55dGhpbmcgZG9jdW1lbnRlZCBhYm91dCB0aGlzPw0KPiBXaGF0IHRoZSB2YWx1ZXMg
bWVhbj8gV291bGQgYSBib2FyZCBkZXNpZ25lciBldmVyIG5lZWQgdG8gdXNlDQo+IGRpZmZlcmVu
dCB2YWx1ZXM/IE9yIGlzIHRoaXMganVzdCBhIGNhc2Ugb2YgJ3RydXN0IHVzJywgeW91IGRvbid0
IG5lZWQNCj4gdG8gdW5kZXJzdGFuZCB0aGlzIG1hZ2ljLg0KWWVzLCBpdCBpcyBhIHJlYWQgZnJv
bSBmdXNlcyBhbmQgdGhvc2UgdmFsdWVzIGFyZSBzcGVjaWZpYy91bmlxdWUgZm9yIA0KZWFjaCBQ
SFkgY2hpcC4gVGhvc2UgdmFsdWVzIGFyZSBjYWxjdWxhdGVkIGJhc2VkIG9uIHNvbWUgY2hhcmFj
dGVyaXN0aWNzIA0Kb2YgdGhlIFBIWSBjaGlwIGJlaGF2aW9yIGZvciBvcHRpbWFsIHBlcmZvcm1h
bmNlIGFuZCB0aGV5IGFyZSBmdXNlZCBpbiANCnRoZSBQSFkgY2hpcCBmb3IgdGhlIGRyaXZlciB0
byBjb25maWd1cmUgaXQgZHVyaW5nIHRoZSBpbml0aWFsaXphdGlvbi4gDQpUaGlzIGlzIGRvbmUg
aW4gdGhlIHByb2R1Y3Rpb24vdGVzdGluZyBzdGFnZSBvZiB0aGUgUEhZIGNoaXAuIEFzIGl0IGlz
IA0Kc3BlY2lmaWMgdG8gUEhZIGNoaXAsIGEgYm9hcmQgZGVzaWduZXIgZG9lc24ndCBoYXZlIGFu
eSBpbmZsdWVuY2Ugb24gDQp0aGlzIGFuZCBuZWVkIG5vdCB0byB3b3JyeSBhYm91dCBpdC4gVW5m
b3J0dW5hdGVseSB0aGV5IGNhbid0IGJlIA0KZG9jdW1lbnRlZCBhbnl3aGVyZSBhcyB0aGV5IGFy
ZSBkZXNpZ24gc3BlY2lmaWMuIFNvIHNpbXBseSAndHJ1c3QgdXMnLg0KDQpCZXN0IFJlZ2FyZHMs
DQpQYXJ0aGliYW4gVg0KPiANCj4+ICsgICAgIGlmIChyZXQpDQo+PiArICAgICAgICAgICAgIHJl
dHVybiByZXQ7DQo+PiArDQo+PiArICAgICBjZmdfcmVzdWx0c1swXSA9IChjZmdfcGFyYW1zWzBd
ICYgMHgwMDBGKSB8DQo+PiArICAgICAgICAgICAgICAgICAgICAgICBGSUVMRF9QUkVQKEdFTk1B
U0soMTUsIDEwKSwgOSArIG9mZnNldHNbMF0pIHwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAg
IEZJRUxEX1BSRVAoR0VOTUFTSygxNSwgNCksIDE0ICsgb2Zmc2V0c1swXSk7DQo+PiArICAgICBj
ZmdfcmVzdWx0c1sxXSA9IChjZmdfcGFyYW1zWzFdICYgMHgwM0ZGKSB8DQo+PiArICAgICAgICAg
ICAgICAgICAgICAgICBGSUVMRF9QUkVQKEdFTk1BU0soMTUsIDEwKSwgNDAgKyBvZmZzZXRzWzFd
KTsNCj4+ICsgICAgIGNmZ19yZXN1bHRzWzJdID0gKGNmZ19wYXJhbXNbMl0gJiAweEMwQzApIHwN
Cj4+ICsgICAgICAgICAgICAgICAgICAgICAgIEZJRUxEX1BSRVAoR0VOTUFTSygxNSwgOCksIDUg
KyBvZmZzZXRzWzBdKSB8DQo+PiArICAgICAgICAgICAgICAgICAgICAgICAoOSArIG9mZnNldHNb
MF0pOw0KPj4gKyAgICAgY2ZnX3Jlc3VsdHNbM10gPSAoY2ZnX3BhcmFtc1szXSAmIDB4QzBDMCkg
fA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgRklFTERfUFJFUChHRU5NQVNLKDE1LCA4KSwg
OSArIG9mZnNldHNbMF0pIHwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICgxNCArIG9mZnNl
dHNbMF0pOw0KPj4gKyAgICAgY2ZnX3Jlc3VsdHNbNF0gPSAoY2ZnX3BhcmFtc1s0XSAmIDB4QzBD
MCkgfA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgRklFTERfUFJFUChHRU5NQVNLKDE1LCA4
KSwgMTcgKyBvZmZzZXRzWzBdKSB8DQo+PiArICAgICAgICAgICAgICAgICAgICAgICAoMjIgKyBv
ZmZzZXRzWzBdKTsNCj4+ICsNCj4+ICsgICAgIHJldHVybiBsYW44NjV4X3dyaXRlX2NmZ19wYXJh
bXMocGh5ZGV2LCBjZmdfcmVzdWx0cyk7DQo+PiArfQ0KPiANCj4gDQo+ICAgICAgICAgIEFuZHJl
dw0KPiANCg0K


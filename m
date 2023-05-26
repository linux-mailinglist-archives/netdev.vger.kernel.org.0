Return-Path: <netdev+bounces-5515-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E407711F5F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7E7928165F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 05:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A063523DB;
	Fri, 26 May 2023 05:48:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4AE23D0
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:48:36 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE7E13D;
	Thu, 25 May 2023 22:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685080114; x=1716616114;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CqhzrR+MpmV+t0LC4f71NhAUPA9huR4lMP0vCONPV6E=;
  b=rBSOF/kROpK7PumVjUSby65Ygd/SHYd1pHXPf4HfJAbrs6xQR40Hzmir
   gz2mJRxcMSUGDEFmDalRV5AHgmeL5z2K+d9S6GlxIXCPO/TKlRISz4Nue
   3Qxh4ZaJhjwbpftz+dOSRA9RW7zVsH58CAX/MhjVWLA8k0r2ytU+su+aQ
   3ifbZ43PNPRmF+ryj6TR/h7ZPlBSG9icu6fU+wKVOzjdb4Aamljx045DY
   MGn0YAo8r2klqkot2arCe00xBPvkU0ovfZeLNdK0Wz06vv16PS60iEMoj
   xWC04WWhqdNLY80CHQ9POlgrtJ1PeLpoIvx21RjvYR3YXmS8a+LelvXYn
   A==;
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="154041644"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2023 22:48:33 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 25 May 2023 22:48:31 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 25 May 2023 22:48:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGGr6sKMpCCukHrX+7rkNsrZ25bsvZw+2go3ybDKQaSiIytLpOcfIQ1nIoRnF6S694WAB4Fy5BBQJJfUFJ2o3am83aJ6EsD/JtbY+CX6zdLo9R4MRaHhRiitLhgPyIRpbvmklmuIDpBR4zBfMpFkspzwdvr26RB93iDwxn9mGDD7iwqI0+SfO8RwubL3EIuS4/0VUoee6Erl54XAohA+KDs4rQ5AvERmCABjXQAqvbe4eLRuwDofR89ugQZhGDMsQlXh/zZJrUO5nivinAPffPXxmXTeThimd9QamKVxc2R/NHymVebmyFp+2c+VcfzA9quR+tA0Z/1K8PFyIWvSBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CqhzrR+MpmV+t0LC4f71NhAUPA9huR4lMP0vCONPV6E=;
 b=m0jjC8eRK6bI1xJvGhFUE76/cMspll4Qbq45xxT7bYTjBOulTa2QezzyPZXfYpDXX7mW4DT67hsWF1rDH+62vcr2jiX6ojwckd91+wxvddFf6t2q7Y+yDlFSeHW9edQInE2shXia76NA2q4gvDKGG3bhxeC0LXeH8+c6dtorD1PUk5rjA1ItuARH/Idvi1AlkwC5eiAClkoRyrF+svIpHlJVzDLxbh1VKVlptVzPhvriHzt0FY3WINeEYFLgsyScXwKqTLg29E9SVDjb+Btoq5t4398hB98FzTOsDuWKdYia6mmAP1qBicnigpilNvMraOfZNWLH2sQka/RLJkYojA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CqhzrR+MpmV+t0LC4f71NhAUPA9huR4lMP0vCONPV6E=;
 b=tLwBVUmTkTBF28Hre45Dhwxme35ksplEfUimI38PIYRAHAtczlv9UFsP9Jd99ZAYbAocOcKjxt+ydYhWH3rxW18K5zdBaur2mwsBUotYPZHJjjp0JUYmA1erp5u67vEb7YRk3tr8aLQOqXQavlBUuJRhmwwyJmoH8A0gG4fxcG8=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 DS7PR11MB6222.namprd11.prod.outlook.com (2603:10b6:8:99::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.17; Fri, 26 May 2023 05:48:27 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 05:48:26 +0000
From: <Parthiban.Veerasooran@microchip.com>
To: <ramon.nordin.rodriguez@ferroamp.se>
CC: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <Horatiu.Vultur@microchip.com>,
	<Woojung.Huh@microchip.com>, <Nicolas.Ferre@microchip.com>,
	<Thorsten.Kummermehr@microchip.com>
Subject: Re: [PATCH net-next v3 2/6] net: phy: microchip_t1s: replace
 read-modify-write code with phy_modify_mmd
Thread-Topic: [PATCH net-next v3 2/6] net: phy: microchip_t1s: replace
 read-modify-write code with phy_modify_mmd
Thread-Index: AQHZjk5SiM6a6RpMm0+kz4LCxOBmWa9rGPWAgAD2KIA=
Date: Fri, 26 May 2023 05:48:25 +0000
Message-ID: <f81c80cb-fbe8-0c7e-f0f9-14509f47c653@microchip.com>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-3-Parthiban.Veerasooran@microchip.com>
 <ZG9599nfDnkcw8er@debian>
In-Reply-To: <ZG9599nfDnkcw8er@debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|DS7PR11MB6222:EE_
x-ms-office365-filtering-correlation-id: df40fd82-1cd3-4511-bab5-08db5dacd308
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ByVWtConOcnAwtpj+PBFiauIzRNLPhIBF/mQ9AsttAPSjN8NgR/ssxA+PgePh8JZLktw8UYIViHvFUQeWi2zalrTAl0l05sJDmgWm89AZtO81ZnJn/bXEfk6qf1ks1jQJz/9cVs8hgJOucyhT7HB6H+LtZ0BNGiVd/oPsoQXnxNkYIg8dEYFmZd8Ktx7xmsnhMBUR3SFx1bUpNpkw+8BGydV+q5Riep/uQxAnhiLq/gW8kQxwmuJWlzSf4HhlHVCDbukEitQqYNnXL4uke4TmURlz91BZc3F86KK+6BeydjHWB3bOIbQN0hEpFeCbKZsqi31DA+LRCZQoQZCDfoAe16XOe0OwTBNFmgVyrpdXXGsHgD1GvNhmhZnNfSrxMW0xn6phQJxFeMtKaRe/zAvGhI8RISRAD8XgGGacVDNy4BraFnAFYZWUDrvc0Sl1euhoAuiLmKP8/Ep49S2MgpbYs5QEKA1hhhqWqtBWkijJyb0YF7o6wV2LAQ2XN4MzvumtuVt1faWsYZvs4hHbWARs4tE4lEqqDWs62ObLUuWAqPagRHECawpNCoUW9pQUGdVijxp6XJr3oUnxeQvN+r1d6Jq+0V/JQx1AF6u3EyiK2+pT4ve83xh4O1buaurkwq9BHB6CJAaHzebe+OW7oaelSCF7MD9kalM1eaEIxKodT4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199021)(31686004)(83380400001)(64756008)(966005)(66556008)(66476007)(91956017)(76116006)(66946007)(66446008)(6916009)(478600001)(316002)(54906003)(4326008)(38070700005)(86362001)(31696002)(36756003)(6512007)(107886003)(26005)(53546011)(6506007)(186003)(2616005)(41300700001)(7416002)(71200400001)(2906002)(8936002)(8676002)(6486002)(38100700002)(122000001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEJJTzFOeTljTGorL1Exc005NFQrQjV6QmRCSkVwa1QwQmZKc2MrTWNHcHpw?=
 =?utf-8?B?YWtXUEdFSHRLMEhKeEUveGdwY0FCdERCYW1CVmZlRklkSklFZlgxQ2RpdVlz?=
 =?utf-8?B?M2srQzdPeC8xWWIwMUVNMnRSMTJwVzB5L0Nab0VEdkpXTU1IOEF0VmU1MTVE?=
 =?utf-8?B?Uk4ybVBuaVJmSEtZUXZkOEJwbkRrL1N0dURTM2h5RTRlcm53R0QrU08zempi?=
 =?utf-8?B?NDAxd0pLaVdWcDNrNWdpT2VHVHJVYzZodEdnZkJNYWpoMmxjUVJqck1mVVJU?=
 =?utf-8?B?MHZnb285TTlGZmU1MUdWbnR2aU9ieWluek9ycUpMZnZZWmovNTJSWUM3VXNi?=
 =?utf-8?B?eDcwTEhsMnVNeCtSY2JxeStJRWpheUpjbURudUFoSGV2NVQ5dDBzdFU2TS9a?=
 =?utf-8?B?alRxQm5wTllXR1FtTEpoVzd4MnRGR094d0xsZFRtdUJxNkV6NURMTGhVdXlQ?=
 =?utf-8?B?cjJYK3I5SHhtVXpnWllRVE9KRjllekNXVGVKYW16STRVdU8zYmpOSDM5SVIz?=
 =?utf-8?B?U01JRXcwNnFEWUZieTlxRk4zWXR5dDhmb0RYeEY2VEZod2VDdmRBazBGQjZl?=
 =?utf-8?B?emFWMWtkUjgxUlFuRHlaOTZhQXZITzdiemZtUmJmVXRjeVhBenk3VnpHSExy?=
 =?utf-8?B?eDhBUW91UVA1c3NtN0w4bHdHYlJlblhmbUVTM2FMYVBseitHckkyZXdKM0VB?=
 =?utf-8?B?WFVIUkxnSWpoMi85M3JIaEJiTXNOYzdITDdKNDlZODE1YzNSVWhzTFNHNGpY?=
 =?utf-8?B?V25XN3d3YmtOSWhMRHVBZXJDT1BMMVA5U1Eza2Zna3g5OW4wekF4REdOREpS?=
 =?utf-8?B?ZFh1RjVWSWFZZW5wZVh0SkRtL2p4anM3RnVuMWkrT3RBYVptS281cXplMCt4?=
 =?utf-8?B?cGdFa0NoVklranN4QTgzN3NMWnNnaGlWa0lucGU0a1pxYU5BSElnem1IN0hw?=
 =?utf-8?B?STkyWGNNSFVZZDBDS0xQYmxrWmxQNnREYytrZG9taUFvOU5Ea1Irb1g3QkJM?=
 =?utf-8?B?MlF3dFdnNkpNaXhwbGViM2dsdVpUbTl2ME1wTUxZcEg0ck8vcGxzbmhvV2F4?=
 =?utf-8?B?Z0JxZnB6NkFZZ3hJS1VBSmVESmFUV1JZVWIyU01BNS82VzErOWZhdGwrYnNn?=
 =?utf-8?B?RU5xNlQyMFFjNDRTSFhWRzNrVnlVaFl4ZFR6MmtlNW9vc3RNVlRnMStOM3Fw?=
 =?utf-8?B?aEgrNEF2dDRtUWhBQnpiZ216aTJPd05zSHlXdzd4WVhqVlVtanlBQVhYRHlJ?=
 =?utf-8?B?U1BubmdQWENaVDJwd2VScDdhdUduTzMvQzFEQmtNVWJ5akpXKzZYOWFybVg0?=
 =?utf-8?B?QVYrZk0yU1pRdUZPajRlMEtVLytlTGVKc2hZZnQ5TEpCYTJTTWR0YXFWdTRJ?=
 =?utf-8?B?aHAxbU04Y1lQRWphUDV5NWdFKytKOVhleUttSUlHcjlqbGJLcnEydE1qUFpI?=
 =?utf-8?B?WWhITkdyRWRGV3FycTBLK2k4ZURsSGk0by9Icjl0SjZNeWNNQXljZ2tXZlcr?=
 =?utf-8?B?amUxT3RuMVNCYWZUSUpKT1ByWEpZeDBNeG55cFJ1czM4NjBDclVyOWd1S2w4?=
 =?utf-8?B?dDZkaG9DWUVyTUF3bDU1K1dtWTR2SkFCTUZSMi9MS2VlV0NMNVlYSmFnSlpP?=
 =?utf-8?B?NUthWEVlS1ZpOHZ3Q0hMUVFkbTIvZVZJSEN0WHpmZm9JOTRINklva05KODJW?=
 =?utf-8?B?QUthRy95ZEdEUGtlLy9Vc1M3amptVGVYNEJnMEdabEFEdHZISUNtU0RxTVY2?=
 =?utf-8?B?S2k5VUhPN2Y0MGQrMnBuSzVtVmdvQ0w0TTVYK1oxV1pmWTJ5d3A1andTWXJN?=
 =?utf-8?B?REpHVW1OTW9VeTlUcy9GYWVKekVQL3NVMVJIMGxXSTY1bHdnZDFkSkVXTFVl?=
 =?utf-8?B?bVFaZkRQYWxqSm9McHFvNmpBUkdsbHFyZGJZSXFOUXRXb2pWV1pkUTQ5Q01H?=
 =?utf-8?B?QTg0ZGhJUmNVTEl4QUdRYldFRUNId2Rpeno0Y3FSNWVnV1dEQXluNTlPa1Rw?=
 =?utf-8?B?VGpDamhsQktkOXRpVDE5cS9EOTRHWGRZTitnM0VUQjllSlRFcDZOdzFjVHFW?=
 =?utf-8?B?UlRQUGNoQ0I1MkxpREtxaVhQUUh0eUk5eXZsWnFBKzVnVjlXdVZNTktGa3ZG?=
 =?utf-8?B?NEJERzE0R0J4ckNiaU5QUDNKM3czMlJ5clNBYUE5RHVyb1U1RHNiRksxRCti?=
 =?utf-8?B?ZVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BB4C251444C7C40ACDBF8226AB41783@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df40fd82-1cd3-4511-bab5-08db5dacd308
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 05:48:25.8770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8TNlS7Fw+XFPRy+Ya046YtoudGRNx+MGVW6m4SEnhdC+8XIrzqpkbgLTXZ82LtPgLLVANoghszUz/WZsW/ptYIUYG5YZWKnXJX9nlJlt4evVQ/ryIrHtEIdUqoTLFYQt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6222
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgUmFtb24sDQoNCk9uIDI1LzA1LzIzIDg6MzggcG0sIFJhbcOzbiBOb3JkaW4gUm9kcmlndWV6
IHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0
YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIFdl
ZCwgTWF5IDI0LCAyMDIzIGF0IDA4OjE1OjM1UE0gKzA1MzAsIFBhcnRoaWJhbiBWZWVyYXNvb3Jh
biB3cm90ZToNCj4+IFJlcGxhY2UgcmVhZC1tb2RpZnktd3JpdGUgY29kZSBpbiB0aGUgbGFuODY3
eF9jb25maWdfaW5pdCBmdW5jdGlvbiB0bw0KPj4gYXZvaWQgaGFuZGxpbmcgZGF0YSB0eXBlIG1p
c21hdGNoIGFuZCB0byBzaW1wbGlmeSB0aGUgY29kZS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBQ
YXJ0aGliYW4gVmVlcmFzb29yYW4gPFBhcnRoaWJhbi5WZWVyYXNvb3JhbkBtaWNyb2NoaXAuY29t
Pg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvbmV0L3BoeS9taWNyb2NoaXBfdDFzLmMgfCAyMyArKysr
KysrKysrKy0tLS0tLS0tLS0tLQ0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygr
KSwgMTIgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9t
aWNyb2NoaXBfdDFzLmMgYi9kcml2ZXJzL25ldC9waHkvbWljcm9jaGlwX3Qxcy5jDQo+PiBpbmRl
eCBhNDJhNmJiNmUzYmQuLmI1YjVhOTVmYTZlNyAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0
L3BoeS9taWNyb2NoaXBfdDFzLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9taWNyb2NoaXBf
dDFzLmMNCj4+IEBAIC0zMSwxOSArMzEsMTkgQEANCj4+ICAgICogVyAgIDB4MUYgMHgwMDk5IDB4
N0Y4MCAtLS0tLS0NCj4+ICAgICovDQo+Pg0KPj4gLXN0YXRpYyBjb25zdCBpbnQgbGFuODY3eF9m
aXh1cF9yZWdpc3RlcnNbMTJdID0gew0KPj4gK3N0YXRpYyBjb25zdCB1MzIgbGFuODY3eF9maXh1
cF9yZWdpc3RlcnNbMTJdID0gew0KPj4gICAgICAgIDB4MDBEMCwgMHgwMEQxLCAweDAwODQsIDB4
MDA4NSwNCj4+ICAgICAgICAweDAwOEEsIDB4MDA4NywgMHgwMDg4LCAweDAwOEIsDQo+PiAgICAg
ICAgMHgwMDgwLCAweDAwRjEsIDB4MDA5NiwgMHgwMDk5LA0KPj4gICB9Ow0KPj4NCj4+IC1zdGF0
aWMgY29uc3QgaW50IGxhbjg2N3hfZml4dXBfdmFsdWVzWzEyXSA9IHsNCj4+ICtzdGF0aWMgY29u
c3QgdTE2IGxhbjg2N3hfZml4dXBfdmFsdWVzWzEyXSA9IHsNCj4+ICAgICAgICAweDAwMDIsIDB4
MDAwMCwgMHgzMzgwLCAweDAwMDYsDQo+PiAgICAgICAgMHhDMDAwLCAweDgwMUMsIDB4MDMzRiwg
MHgwNDA0LA0KPj4gICAgICAgIDB4MDYwMCwgMHgyNDAwLCAweDIwMDAsIDB4N0Y4MCwNCj4+ICAg
fTsNCj4+DQo+PiAtc3RhdGljIGNvbnN0IGludCBsYW44Njd4X2ZpeHVwX21hc2tzWzEyXSA9IHsN
Cj4+ICtzdGF0aWMgY29uc3QgdTE2IGxhbjg2N3hfZml4dXBfbWFza3NbMTJdID0gew0KPj4gICAg
ICAgIDB4MEUwMywgMHgwMzAwLCAweEZGQzAsIDB4MDAwRiwNCj4+ICAgICAgICAweEY4MDAsIDB4
ODAxQywgMHgxRkZGLCAweEZGRkYsDQo+PiAgICAgICAgMHgwNjAwLCAweDdGMDAsIDB4MjAwMCwg
MHhGRkZGLA0KPj4gQEAgLTYzLDIzICs2MywyMiBAQCBzdGF0aWMgaW50IGxhbjg2N3hfY29uZmln
X2luaXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4+ICAgICAgICAgKiB1c2VkLCB3aGlj
aCBtaWdodCB0aGVuIHdyaXRlIHRoZSBzYW1lIHZhbHVlIGJhY2sgYXMgcmVhZCArIG1vZGlmaWVk
Lg0KPj4gICAgICAgICAqLw0KPj4NCj4+IC0gICAgIGludCByZWdfdmFsdWU7DQo+PiAgICAgICAg
aW50IGVycjsNCj4+IC0gICAgIGludCByZWc7DQo+Pg0KPj4gICAgICAgIC8qIFJlYWQtTW9kaWZp
ZWQgV3JpdGUgUHNldWRvY29kZSAoZnJvbSBBTjE2OTkpDQo+PiAgICAgICAgICogY3VycmVudF92
YWwgPSByZWFkX3JlZ2lzdGVyKG1tZCwgYWRkcikgLy8gUmVhZCBjdXJyZW50IHJlZ2lzdGVyIHZh
bHVlDQo+PiAgICAgICAgICogbmV3X3ZhbCA9IGN1cnJlbnRfdmFsIEFORCAoTk9UIG1hc2spIC8v
IENsZWFyIGJpdCBmaWVsZHMgdG8gYmUgd3JpdHRlbg0KPj4gICAgICAgICAqIG5ld192YWwgPSBu
ZXdfdmFsIE9SIHZhbHVlIC8vIFNldCBiaXRzDQo+PiAtICAgICAgKiB3cml0ZV9yZWdpc3Rlciht
bWQsIGFkZHIsIG5ld192YWwpIC8vIFdyaXRlIGJhY2sgdXBkYXRlZCByZWdpc3RlciB2YWx1ZQ0K
Pj4gKyAgICAgICogd3JpdGVfcmVnaXN0ZXIobW1kLCBhZGRyLCBuZXdfdmFsKSAvLyBXcml0ZSBi
YWNrIHVwZGF0ZWQgcmVnaXN0ZXIgdmFsdWUuDQo+PiArICAgICAgKiBBbHRob3VnaCBBTjE2OTkg
c2F5cyBSZWFkLCBNb2RpZnksIFdyaXRlLCB0aGUgd3JpdGUgaXMgbm90IHJlcXVpcmVkIGlmDQo+
PiArICAgICAgKiB0aGUgcmVnaXN0ZXIgYWxyZWFkeSBoYXMgdGhlIHJlcXVpcmVkIHZhbHVlLg0K
Pj4gICAgICAgICAqLw0KPiANCj4gTml0cGljaywgSSB0aGluayB0aGlzIGJsb2NrIGNvbW1lbnQg
Y2FuIGJlIHJlZHVjZWQgdG86DQo+IC8qIFRoZSBmb2xsb3dpbmcgYmxvY2sgZGV2aWF0ZXMgZnJv
bSBBTjE2OTkgd2hpY2ggc3RhdGVzIHRoYXQgYSB2YWx1ZXMNCj4gICAqIHNob3VsZCBiZSB3cml0
dGVuIGJhY2ssIGV2ZW4gaWYgdW5tb2RpZmllZC4NCj4gICAqIFdoaWNoIGlzIG5vdCBuZWNlc3Nh
cnksIHNvIGl0J3Mgc2FmZSB0byB1c2UgcGh5X21vZGlmeV9tbWQgaGVyZS4qLw0KPiANCj4gICBU
aGUgY29tbWVudCBJIGFkZGVkIHdhcyBpbnRlbmRlZCB0byBkZXNjcmliZSB3aHkgSSB3YXMgZG9p
bmcgd2VpcmQNCj4gICB0aGluZ3MsIGJ1dCBub3cgSSB0aGluayBpdCdzIG1vcmUgaW50ZXJlc3Rp
bmcgdG8gZGVzY3JpYmUgd2h5IHdlJ3JlDQo+ICAgZGV2aWF0aW5nIGZyb20gdGhlIEFOLg0KPiAN
Cj4gICBPciB0aGUgYmxvY2sgY29tbWVudCBjb3VsZCBiZSBkcm9wcGVkIGFsbCB0b2doZXRlciwg
SSdtIGd1ZXNzaW5nIG5vIG9uZQ0KPiAgIGlzIGdvaW5nIHRvIGNvbnN1bHQgdGhlIEFOIGlmIHRo
aW5ncyAnanVzdCB3b3JrJw0KPiANCkJ5IGNvbnNvbGlkYXRpbmcgYWxsIHlvdXIgY29tbWVudHMg
aW4gdGhlIG90aGVyIGVtYWlscyBhcyB3ZWxsIG9uIHRoaXMgDQoybmQgcGF0Y2gsIGRvIHlvdSBh
Z3JlZSBmb3IgbXkgYmVsb3cgcHJvcG9zYWw/DQoNCldlIHdpbGwgcmVtb3ZlIGFsbCBibG9jayBj
b21tZW50cyBhbmQgc2ltcGx5IHB1dCBBTjE2OTkgcmVmZXJlbmNlIGFzIHdlIA0KZGlkIGZvciBs
YW44NjV4X3JldmIwX2NvbmZpZ19pbml0IHdpdGggYSBzbWFsbCBhZGRpdGlvbiBvbiB0b3Agb2Yg
DQpwaHlfbW9kaWZ5X21tZCBmb3IgbG9vcD8gc28gdGhlIGNvbW1lbnQgd2lsbCBsb29rIGxpa2Ug
YmVsb3csDQoNCi8qIFJlZmVyZW5jZSB0byBBTjE2OTkNCiAgKiANCmh0dHBzOi8vd3cxLm1pY3Jv
Y2hpcC5jb20vZG93bmxvYWRzL2FlbURvY3VtZW50cy9kb2N1bWVudHMvQUlTL1Byb2R1Y3REb2N1
bWVudHMvU3VwcG9ydGluZ0NvbGxhdGVyYWwvQU4tTEFOODY3MC0xLTItY29uZmlnLTYwMDAxNjk5
LnBkZg0KICAqIEFOMTY5OSBzYXlzIFJlYWQsIE1vZGlmeSwgV3JpdGUsIGJ1dCB0aGUgV3JpdGUg
aXMgbm90IHJlcXVpcmVkIGlmIA0KdGhlICByZWdpc3RlciBhbHJlYWR5IGhhcyB0aGUgcmVxdWly
ZWQgdmFsdWUuIFNvIGl0IGlzIHNhZmUgdG8gdXNlIA0KcGh5X21vZGlmeV9tbWQgaGVyZS4NCiAg
Ki8NCg0KU28gaW4gZnV0dXJlLCBpZiBzb21lb25lIHdhbnRzIHRvIGtub3cgYWJvdXQgdGhpcyBj
b25maWd1cmF0aW9uIHRoZXkgY2FuIA0Kc2ltcGx5IHJlZmVyIHRoZSBBTjE2OTkuDQoNCldoYXQg
ZG8geW91IHRoaW5rPw0KDQpCZXN0IFJlZ2FyZHMsDQpQYXJ0aGliYW4gVg0KPj4gICAgICAgIGZv
ciAoaW50IGkgPSAwOyBpIDwgQVJSQVlfU0laRShsYW44Njd4X2ZpeHVwX3JlZ2lzdGVycyk7IGkr
Kykgew0KPj4gLSAgICAgICAgICAgICByZWcgPSBsYW44Njd4X2ZpeHVwX3JlZ2lzdGVyc1tpXTsN
Cj4+IC0gICAgICAgICAgICAgcmVnX3ZhbHVlID0gcGh5X3JlYWRfbW1kKHBoeWRldiwgTURJT19N
TURfVkVORDIsIHJlZyk7DQo+PiAtICAgICAgICAgICAgIHJlZ192YWx1ZSAmPSB+bGFuODY3eF9m
aXh1cF9tYXNrc1tpXTsNCj4+IC0gICAgICAgICAgICAgcmVnX3ZhbHVlIHw9IGxhbjg2N3hfZml4
dXBfdmFsdWVzW2ldOw0KPj4gLSAgICAgICAgICAgICBlcnIgPSBwaHlfd3JpdGVfbW1kKHBoeWRl
diwgTURJT19NTURfVkVORDIsIHJlZywgcmVnX3ZhbHVlKTsNCj4+IC0gICAgICAgICAgICAgaWYg
KGVyciAhPSAwKQ0KPj4gKyAgICAgICAgICAgICBlcnIgPSBwaHlfbW9kaWZ5X21tZChwaHlkZXYs
IE1ESU9fTU1EX1ZFTkQyLA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBs
YW44Njd4X2ZpeHVwX3JlZ2lzdGVyc1tpXSwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgbGFuODY3eF9maXh1cF9tYXNrc1tpXSwNCj4+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgbGFuODY3eF9maXh1cF92YWx1ZXNbaV0pOw0KPj4gKyAgICAgICAgICAg
ICBpZiAoZXJyKQ0KPj4gICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gZXJyOw0KPj4gICAg
ICAgIH0NCj4+DQo+PiAtLQ0KPj4gMi4zNC4xDQo+Pg0KDQo=


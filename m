Return-Path: <netdev+bounces-5708-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75CDE71281C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:15:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD5591C2102F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A2924E96;
	Fri, 26 May 2023 14:15:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C95124129
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 14:15:06 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADFB187;
	Fri, 26 May 2023 07:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685110506; x=1716646506;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=72iiDjcXlJ75M6W6UhMkOx8LNC3E6+5MrsZ08bFIDLQ=;
  b=PhKZnXiU0Y9ZVy+6B93OArO7b54SsNOPUQy51SHKBIAzOZnJDqQXYt+H
   twxMhKBbulWtuYCuC7jky7DUX2L6tSO5TXVcENvNvkd4NYDppBH9r8v/l
   70CeQ86tevcSuJLE51UGTBdTxjf6hLFTZS+kUqjH0in0Qdz0HSJeygnhw
   PqC3xYrEu8+BLproM9xsK0hjWDY8ZciTT2fkV95wyfKrzmYb08i4rOEwN
   CI5sJ7cG6Y+xEeTqpKX2NpQBjy0ICtYIeVAmsXpJLLY4jqaeJm2wMmH8q
   EyGtoXiIQL7S+ooGK3DYSlXhj/xt7+XvKI4wXqbtiURf4Gh1qD9ecQ8kr
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="213245321"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 May 2023 07:15:04 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 26 May 2023 07:15:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Fri, 26 May 2023 07:15:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2njvpXe2nDaeGHFXf5FuIpM1oKg9jnQuXIxBLNSuqO6aebIZmtLShESnI58ZJ+Fmkxsoa1O9NdFd4PYvTwVR2PK58I6LhQYBSoUgRokOgHZedRkrl2oLpYpe//CL5HpPdLbhvpqAQQR9ETesFhkKPq+rX65eCutEDAZTj9lPQED8w45KC04zguglPRVBwuYzMxatjO1cMoNdwPPbNNgKXCRJY8RnyRKpka5aY0N3aJkLV8evrwCeIbeQkoLS0CuonpsIbc3QvOl3NzNsYcYBOwYKPvW8IeY7CotXbxrwwCRbWcP8I+QUFkvcI/7JSobjtjgaMmpF9BRaNIGRiAlsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72iiDjcXlJ75M6W6UhMkOx8LNC3E6+5MrsZ08bFIDLQ=;
 b=gQ3lmUeDjntbE8WvZOZUGEaPNP88Yus0FXjN4BBZHic/pGtoPtwxFAPcrWiAV9XEcBX12ESAu57WyAQK/naDz3bPtQ9Pi+U0EO965Mbe/2N3zCL08heNPaTrlYolgXNSaT0+LgjjRnhSnqKKPcWI5Xg6oErw6jkzT26vco7WnqHGhVCqNXkL4RedEY00+wPCFuyhwMkM4lkMs/HmUCW/h7ASw5PFksZ51mWAoSW2cRIutt5jHO1xzg23qiSL/iKRNIHOhONsqqOfRfBv9aCEdWNsYI1T2tRgbYUWvvoJijm/oP2+RQUgvWLP9x64f8YNJCKGvPkLNklFz8jcXIhvmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72iiDjcXlJ75M6W6UhMkOx8LNC3E6+5MrsZ08bFIDLQ=;
 b=SwMha/bcQ8bjVjCVIee2bDZKHjCz72kcaeSFoKmvEt9KAjJakyy9oSAKhR+y9qoEPumOZiZParzbmnpD66A1kqSLg+21esxJfr6RQokaQ7IN59jqL+R/x0H/RIBeXGcLi/v9nehHDukZOT2pJ7jDIl8J5Gmryh6211m/yKmnCaA=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 SA1PR11MB8446.namprd11.prod.outlook.com (2603:10b6:806:3a7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.17; Fri, 26 May 2023 14:15:00 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 14:15:00 +0000
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
Thread-Index: AQHZjk5SiM6a6RpMm0+kz4LCxOBmWa9rGPWAgAD2KICAABZ/AIAAaGUAgAAKyoCAAAPbgA==
Date: Fri, 26 May 2023 14:15:00 +0000
Message-ID: <98645f0b-bb69-f58d-0a3a-22c67a4c4ad2@microchip.com>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-3-Parthiban.Veerasooran@microchip.com>
 <ZG9599nfDnkcw8er@debian>
 <f81c80cb-fbe8-0c7e-f0f9-14509f47c653@microchip.com>
 <ZHBbVNWeKK2di73h@debian>
 <6eb6893f-7731-dcc5-9221-048383bcbce4@microchip.com>
 <ZHC78yzOp/xIXKYL@builder>
In-Reply-To: <ZHC78yzOp/xIXKYL@builder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|SA1PR11MB8446:EE_
x-ms-office365-filtering-correlation-id: a593573b-cae5-454d-e8e7-08db5df39771
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: km8MOZBM46UFH5rB5ruK45uRh4NUSE4a7GLHo7AlvQCT2QGuuv7UFLOynTRBOLTXtqw6IWUeg7I0sWOOi1n7QyZAAZfqdZVaWt/DQckniwjv93XQef005Zuq7fLqECJNut8PRitjgzeKa4Y3jCiExD7xmwl9O2FpRpPew1G2qBJRIfdmpUKM20xtIqYVA7KJXVn96Nnjf21/lZq3W+yWnaxmQnTijZ0XFWhSIC4mlhByD9FN6QyxYwuhsytwm9EYhs6n+4VemK7QX390kuVaD3XzmiWfABsAmyJxzJ8mSGCct5zPHEX8mD594yoc8R9e1qGGQc31RV4D0yt0g7sUPBcGdQj421fWITKoCn1KuELDJhsOsJMvud7tr1YnqRF24uoSEVsituXyk2AZjeb9IzluGNeAA57IXQmK3phHqRbjnUfwDWSDtFUqa4urQTbyYXOzz4RwpFBep0QrueRqj5Wv/H36GQVDwHdOrfTvmgBds2YC+2CcNWG7eCf2/ECD8v2DeaPqrmjfNPif3YyOd6QrdiNwFltqA5LWRIdn3Advy9Z90ODgwovJII/oCG4U3cKd5IBjJuPf5pEpSk+bSqupxYsBOF/4UvT143P/jbXhrUkGdUW3SPuewf+W5n5KG2bXI8sSqPxlWL+VPJuGCjTXuKsbyDNO+VGVMLlp66k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199021)(5660300002)(8676002)(7416002)(54906003)(478600001)(31686004)(966005)(8936002)(41300700001)(6486002)(6506007)(6512007)(66946007)(6916009)(66476007)(64756008)(4326008)(76116006)(316002)(66446008)(66556008)(71200400001)(53546011)(26005)(107886003)(91956017)(2906002)(186003)(2616005)(66574015)(83380400001)(122000001)(38100700002)(31696002)(86362001)(38070700005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cUI2VTJzcUFLQ3JLRUIzbUE2ekdoZHc2b09YakcrUTcrNHdJZDhmYnpFdTFn?=
 =?utf-8?B?WWN5RC9keEpwNk4rbEUrVWlxWnlWN3hqNDRubHRtNXlwUXAwbVpVb2RxSlRF?=
 =?utf-8?B?cDMxeVhaZUYzTVJLMHFvRUdsY0RTdndRemVrYnNOaVg4dk56R1N6V0d3K1Yz?=
 =?utf-8?B?aDJCRmNaV2l3ZGhrTElHRHdmSHh5NmtzU0Rpd2ZRL2FFaURuekcrKzVMSFIv?=
 =?utf-8?B?ek1xWk41aXVtQnM2RmtDOWp5bk0rbFhOYjU3d0tCa1FHZmZidnhBb0U5NWVL?=
 =?utf-8?B?T1FtUEdQZmhmcWU4RXYxbjl3M3Q4SDV0Y0xyakphc3lCNjhBN25SVDJOWTd0?=
 =?utf-8?B?bXpwU3MzbDJWUGFEVjBWZjFQUUNzMDAvbWF6NndKdUJ4M3cxUmRsUW5zbDJp?=
 =?utf-8?B?eks2MXRuVUlKNG1jSmNENmpqUXVtR0UyaE56RWwrdjJ0ZnZIZHVJQ2Y5VU0r?=
 =?utf-8?B?cVR4WE9uUnZtd0xnam8ydGo4dE1OZDRLYW9mV2J4ZEcrQUdJVnR0K1QxZVJz?=
 =?utf-8?B?ZVNTbkc3cGp2eGhQR1RCUFdSa0Jua0JyUWVqYzUyR1JYYUF5MHhzN2cyVSsz?=
 =?utf-8?B?NWQxd09EL0U3cHNxa0JWRnpMVExFSVZNUEJocG5pSFZGVFBhVlFHUEZMT2JX?=
 =?utf-8?B?UUdneUhkeWlKanUzSTd1YlNOVHNvNVNud3E4RXFPQy9ETjNKdXVLUktkNkYx?=
 =?utf-8?B?RzJic1pPNlY4MldUaU1aWmZORzA1eUNxdU11V2x6TDVtMFNCczMwMVduQkQw?=
 =?utf-8?B?TG95S0FTVndvRE01eVlWc2R0ekUwMWYyZk5hRXdJQmgyV004WG5zNlV2R2tF?=
 =?utf-8?B?UlZQZjhsV2xoMUJvU0VRK3h2T3pldmZWOFVZaEJCRUdCUlVhalVSdFJTaENz?=
 =?utf-8?B?NWtjOGUxMis0QzJVTEJNdUZCSWhXNEsyYTVpTUNYdVJhMUgwK3BJZU5HR3hS?=
 =?utf-8?B?dWFkemlWUDRtT1ZaN2RYNDhjamtBcmFiUnJOK3hnaDFxL015eGVXS2dzeEIr?=
 =?utf-8?B?U0R4WE1ma3A3TDNFVTRQQUlmdDFQclRHaW9rM0tiWDlXM1YwVE5WV09KTE11?=
 =?utf-8?B?OUlpVE1WL20yNWpCVmFKamdGYm5XMmloK1NYTE9WdE43T1FwanRKbmdENUJ5?=
 =?utf-8?B?Q1MxRVh4cUZzbVBwTXNZWlFFQ29lNVRYVGw2QzRJT2h6UzdWZHFSZXR6NTBR?=
 =?utf-8?B?aVFIazNINzV2Rm5tZHlvN1pQMnlaWmt4T0htVklQMVMxcDBKbEgwMWlSYUh6?=
 =?utf-8?B?RVk4NmhNS2hVTGFnNko2bEJGYlBIYzE5MVNocjk3dFJGNkxsdkNlM3ExT2VP?=
 =?utf-8?B?Wk9vSEdHUkZVeTc1UHJ3RGdRN3pSUlA1UmpQWnVndElOMERvWHl4dDJBQ25o?=
 =?utf-8?B?dk5wVVFSMkROaEdxdlVCTW5vTzNObENZbk55d0dOOHpHOERmaTYwZGxWVm16?=
 =?utf-8?B?YWRYQU1VdEo5N0VYY1hQZ1ozM3Z5Wm0zdHFPWDZhWXExM0FHL0UvR3JiVzRC?=
 =?utf-8?B?S1BuQ1Z1WEk0STBuYUN5MGpLd3M0MXIwTVlXRDhYYXhLWXZkUFNVTEt5anZo?=
 =?utf-8?B?UGx3NSt2T1A2b0psS0djTDRvc2VsbHpieWdsSERHMTdXYzlJMjhVRTZFYU9r?=
 =?utf-8?B?cGsxdkdFTzB2RDlDZ1dIQUdRMHQ2Q0ZIeUg0VjFLU2wrUXNiWjY1ZnYxd0NQ?=
 =?utf-8?B?UXZtMTliQzJVYXI0d2syWWVJQktaTVJpd1lJOXBjR1NpUzdQVUVZQVBicFZt?=
 =?utf-8?B?eXhCZTJaTHpYZWdjdWN6VXJ0aWQ3RjN1c3JlTWEvUGlNbHZ3UC9sQTUzQ2F6?=
 =?utf-8?B?UldLMW41NGExOUZaWEdlOTJuU1AxWkw0aHNDclhXL3pHWWdpMGpKRzZ3ZDFv?=
 =?utf-8?B?VDlXSHowTGpEL09YQ2U4WUM4SjFxOWsxZlBzMG1kaGg1WllxcXVLQXRzeHAr?=
 =?utf-8?B?cExjbzRnUlRiZ0NUSW90NFhYWXh3ZGFZaVpRTHpuY1FDSExsM3haUlBSUXhM?=
 =?utf-8?B?TlhQL0ZHRFZyc3hwMU5rZ2J6T3VEWjZ3SUtqdGtPRDhEOVljRDFDdXliSUdW?=
 =?utf-8?B?Z3ZlQndPRU9neXV4SlVkVzc5QjNxbU5RNUJBOCthejE3MHZTZjZNakJPSElB?=
 =?utf-8?B?ZGdrVGh1VHFNblorVlM3Zm03YTkzd24vOFZPUWhHQ3BBUE0xS2VVSzl3dXZY?=
 =?utf-8?Q?8eHoIOCU0Ojl3BdaoYILOqc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E604AC92CFC124D9EF505154667F242@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a593573b-cae5-454d-e8e7-08db5df39771
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 14:15:00.2058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cZPfkfA3suTVWtFCSoN1P8zDCEn0g59uQJwByXzuVJoFcWMHZV59CyVE+jIapJLeIZJw/ORkOngZqvGbxj+OCurKAzEnfVByDnEziBHiJWoUegXaBIGeRRXiP2r97BSk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8446
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgUmFtb24sDQoNCk9uIDI2LzA1LzIzIDc6MzIgcG0sIFJhbcOzbiBOb3JkaW4gUm9kcmlndWV6
IHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0
YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+Pj4+IC8q
IFJlZmVyZW5jZSB0byBBTjE2OTkNCj4+Pj4gICAgICoNCj4+Pj4gaHR0cHM6Ly93dzEubWljcm9j
aGlwLmNvbS9kb3dubG9hZHMvYWVtRG9jdW1lbnRzL2RvY3VtZW50cy9BSVMvUHJvZHVjdERvY3Vt
ZW50cy9TdXBwb3J0aW5nQ29sbGF0ZXJhbC9BTi1MQU44NjcwLTEtMi1jb25maWctNjAwMDE2OTku
cGRmDQo+Pj4+ICAgICAqIEFOMTY5OSBzYXlzIFJlYWQsIE1vZGlmeSwgV3JpdGUsIGJ1dCB0aGUg
V3JpdGUgaXMgbm90IHJlcXVpcmVkIGlmDQo+Pj4+IHRoZSAgcmVnaXN0ZXIgYWxyZWFkeSBoYXMg
dGhlIHJlcXVpcmVkIHZhbHVlLiBTbyBpdCBpcyBzYWZlIHRvIHVzZQ0KPj4+PiBwaHlfbW9kaWZ5
X21tZCBoZXJlLg0KPj4+PiAgICAgKi8NCj4+Pj4NCj4+Pj4gU28gaW4gZnV0dXJlLCBpZiBzb21l
b25lIHdhbnRzIHRvIGtub3cgYWJvdXQgdGhpcyBjb25maWd1cmF0aW9uIHRoZXkgY2FuDQo+Pj4+
IHNpbXBseSByZWZlciB0aGUgQU4xNjk5Lg0KPj4+Pg0KPj4+PiBXaGF0IGRvIHlvdSB0aGluaz8N
Cj4+Pj4NCj4+Pg0KPj4+IEknbSBub3Qgc3VyZSBhYm91dCB0aGUgbGluaywgcmVzb3VyY2VzIGhh
dmUgYSB0ZW5kZW5jeSB0byBtb3ZlLg0KPj4gWWVzLCBJIGFncmVlIHdpdGggeW91IGJ1dCBzb21l
aG93IHRoZXJlIGlzIG5vIHdheSBmb3IgZ2l2aW5nIHRoZQ0KPj4gcmVmZXJlbmNlIHRvIHRoaXMg
ZG9jdW1lbnQuIE1heSBiZSB3ZSB3aWxsIGtlZXAgdGhpcyBsaW5rIGZvciB0aGUNCj4+IHJlZmVy
ZW5jZSwgbGF0ZXIgaWYgc29tZW9uZSBpcyBub3QgYWJsZSB0byBhY2Nlc3MgdGhlIGxpbmsgdGhl
biB0aGV5IGNhbg0KPj4gcmVxdWVzdCBNaWNyb2NoaXAgdG8gZ2V0IHRoZSBkb2N1bWVudC4NCj4+
DQo+PiBXaGF0IGRvIHlvdSB0aGluayBhYm91dCB0aGlzIHByb3Bvc2FsPyBJZiB5b3UgYWdyZWUg
dGhlbiBJIHdpbGwgcHJvY2VlZA0KPj4gZm9yIHByZXBhcmluZyB0aGUgbmV4dCB2ZXJzaW9uIHdp
dGggeW91ciBjb21tZW50cy4NCj4gDQo+IFRodW1icyB1cCBmcm9tIG1lDQpUaGFua3MuDQoNCkJl
c3QgUmVnYXJkcywNClBhcnRoaWJhbiBWDQo+IFINCj4gDQo+Pj4gT3RoZXJ3aXNlIExHVE0NCj4+
Pg0KPj4+PiBCZXN0IFJlZ2FyZHMsDQo+Pj4+IFBhcnRoaWJhbiBWDQo+Pg0KDQo=


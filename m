Return-Path: <netdev+bounces-5695-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E70571276B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:22:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D39DC281869
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B30818B1D;
	Fri, 26 May 2023 13:22:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19020101E8
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:22:45 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD95194;
	Fri, 26 May 2023 06:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685107361; x=1716643361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fGuh0y7hQqYN9gYp5qX8Qzr1W5FrRrTgMBfY+F58lkc=;
  b=jJ0E6YK+6Y3+/W2NeBVsRfER1gabeiSWlSrDZt3iooywjzoEA71wc+yM
   HTQz8T2LMGVrJJqJi303TIHs4gnQS1PTTTG/38YZrDZteCFwydwjQud/g
   TWb8XUe+SjWRUnNMOifQ+lLoX1nbuRzXiG65cPLl3IKAWBYWZhCor/8A9
   +ZQgliq6R8s8Iwm3GK5bZQDOWDzMr8ulpppAiROWhEgQ8hF7hcpThK8oB
   Z0RJ9r6+KYII5ABeLGmMMtd6FfgI/gjNjJsNoKGzsQsWXssF5+95b6tkl
   bD9wNdMVtLNLYe8LrE4TJHciaoj94AHgEfI1bGtqU8TQ6DnZn1PmzuDWB
   A==;
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="215633367"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 May 2023 06:22:41 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 26 May 2023 06:22:37 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Fri, 26 May 2023 06:22:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkiy8HagenYAlogCj7V+qnJEIn2Hn+G92IZfOgUQi9zQBRrjqiwj9ugFJQAOhUFk2pHPbwPBD+j+2i/ymqqyonIbUpeLbFdATuzEUGRnbx0rKynO1ZoolXGA+gh2FIE6tTepmnJHPEbA64PPa2VH4+V0hGCPa0NM2IqV4oR/q5EZ5PTk0L8dw8204bP6O3awAiKxFftfrPGe/1urVKDF3qbeeqiB68FZQlYVgGhAY0iKJO/LDslkmO73J1nK8Rs9V/REMJ8q1fS6wyT7w/plONrYhdMh1TLqTvrQVHSCHOjLIbMyktarIekNmEZKi6Pz+P6SNPAkSB8vJNgDY0Qi4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGuh0y7hQqYN9gYp5qX8Qzr1W5FrRrTgMBfY+F58lkc=;
 b=BNUHdouJr7we3DATzKtAdtlUs7WjPN8ryLXDZNAXhZuze+t5CBMdiKMxqyNM8fIuTu5FHnRgTKfCGBHm3YYbNlJHlUX7eLm2Zcl/GKk04EdgSYsSCInLSuMrTV6zDqlLdaxd1u23qRP6sASBF9WdUQfeVPlqAX4to6pGK/Sg5i3GeEzJ1qVhU1LFzNNxBGui499UAoWZDZx0oE6LeahJTik4HlMRFroFHRDvwu8xgFFbjVYCV86PMzfbK8LYl3qTKWZ3fnjZH51qwM/3kQ7VVOJY0u2j0i8K1luZfP4I8zEio8Y6JuYpE1BF4LGSvBNizYhyO8r+Ze6RR1EXYmGgWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGuh0y7hQqYN9gYp5qX8Qzr1W5FrRrTgMBfY+F58lkc=;
 b=SOrFxRoRlsS/hIuXNSiPRxnslXIiHWVrRCidU6qIea4/yMtq5+TWCRnf/Z3i5Qr/iOVBMvbYZUDPy2FZAqNZli1t4TTdFkYyPH/BAzq8J1ydJhGgo+UgdwBYsc4sdGYDJhOcqGNwAfY1MwRaAW4a0FsCnE2FRUgA8+KAVIZcqSY=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 LV8PR11MB8485.namprd11.prod.outlook.com (2603:10b6:408:1e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Fri, 26 May
 2023 13:22:35 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 13:22:35 +0000
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
Thread-Index: AQHZjk5SiM6a6RpMm0+kz4LCxOBmWa9rGPWAgAD2KICAABZ/AIAAaGUA
Date: Fri, 26 May 2023 13:22:35 +0000
Message-ID: <6eb6893f-7731-dcc5-9221-048383bcbce4@microchip.com>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-3-Parthiban.Veerasooran@microchip.com>
 <ZG9599nfDnkcw8er@debian>
 <f81c80cb-fbe8-0c7e-f0f9-14509f47c653@microchip.com>
 <ZHBbVNWeKK2di73h@debian>
In-Reply-To: <ZHBbVNWeKK2di73h@debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|LV8PR11MB8485:EE_
x-ms-office365-filtering-correlation-id: f3a3af4e-1ac0-4028-262b-08db5dec44f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vEQfVksa+JLVRpCJxPHBMBirUDdYdcInNslOuZL9ucx1QCZvaeWzvmbRMmSf8zdxw7AM6KD7cu8bhSOpuooPlUKN1lhrXsSnGdKngt/u49OmGlIVVs/XZFM1L90pzIKhkSqxdHxfjNge659BeJcsxmiPbPvODL+jp7xWqDqkyy0hMmsSC3tPgRAa2kC0ugdk9Ij3jqzjEEpwurdRGH9gMxGGZPnke1oBpL+7hvo/VDOD7Frr6na/waIJ4Q6spjbtrfDY/UxiHSD54S5PfGJApZEeboq5Aq2DEO154g4vQBVRcOIxSe9g2bVZ7V8Ie6b8qJjUP0AC6oROy7oNqbVYX8M8fRXVLYJ6M4Ehku1vkPhNE5FpCbBSdqF3msbCqpMa148F70O86QZBj90qzshjSiE8Pf44oahUw+wApfNghWeS0HRz4NAvvCH7cJ4CuGpqklgikYwZ90YklTcRVvDWKhRWFf0Zy4eI7qWP9h2Hz4ucvCB75QX1Xs2I2ztL8pm5KFUvABPOP06Tt7U8Y8PiQQ9E8wUOf4pGONWkamnRCpunuj5Jx+FMXlMnMV52BLp0qIFzulAQ5izLr+4eB9NFgupC9u8q1uJKwJo14CEJwfHiZFvYCQEobyTD+wlsRLTa6SNEnetoYqoDLl1Jurs2Aw3JJAITw1SJFvGDZigPJp8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(376002)(39860400002)(346002)(451199021)(122000001)(31686004)(6916009)(966005)(66946007)(66446008)(76116006)(91956017)(64756008)(66476007)(66556008)(478600001)(316002)(54906003)(4326008)(86362001)(38070700005)(31696002)(36756003)(66574015)(53546011)(107886003)(2616005)(186003)(26005)(6512007)(6506007)(83380400001)(41300700001)(2906002)(8676002)(8936002)(5660300002)(7416002)(71200400001)(6486002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTB6VFZXSzUzN3N1ZEs0dHJETXE4Q0d4NFN5YXprU1R1K210UUpSTE5BVkNU?=
 =?utf-8?B?ZDFXTmxBYzdXOG1SczhTYVJCeFFlWWh2ZFQ0LzFKaVQwN2kydEJyc3RadTVu?=
 =?utf-8?B?RkRjRXI4M0hJcTN4K0tLWnUzOWp2QXZycHdTL2VTcDZOVkZIcE9JRG12YkRQ?=
 =?utf-8?B?bExVRVM1aWJXMkRVOCsxdFdHUUxDTWZHWUlGVmU0d3F1YTZMdGVtRDFwTDVP?=
 =?utf-8?B?SzVHbGRBZ1RLbHg3bGxxVmtxYjBtYitGYzVxdXVtSFlHejNNWVNPL0pCeFFm?=
 =?utf-8?B?ZjFYc0swYkV2TlA0eWg2cmVJbGJGOVZsS2xCOGkvdW5LbUhOUGdOUGJ1WUFG?=
 =?utf-8?B?QklNZzlmSElNV3ZBMzZITUtBZGw2emhXZk1KWi8wZ3ZidUhDTVdVNGh2MkVw?=
 =?utf-8?B?ejVBZmoxTDNHcWZIYmJpZnQ5TFg3RFhxRG1Ia3A5bmZtWS9qTzBRbjFUQUE0?=
 =?utf-8?B?R1BiMVh1YkphZTNKZHJXYWdhKzQxekI2Q29kWWR3RDk3VHhTN2lScGdrVEpB?=
 =?utf-8?B?bm9NRndsOXJna2k2eE1yQnV4MTg2aEREdTdPTlk1MWYxVGpVS056dmNsL01L?=
 =?utf-8?B?UGNLMkFWaWlsZDFHbVNoZHIyWHZyU2dvczNuWWxTbmEvZlBMSTRLR3hDTUsr?=
 =?utf-8?B?bTZSWGplTGJKU21mM0FxYXF5dEdoMWtVSC9vREd4WlBqOUg5bHNScWJRbUNR?=
 =?utf-8?B?dC9WZkFhZUJlODl2NGR1djZXblowdDU0a2syRi93dzlydFEvK2x1Y3JyL3Jk?=
 =?utf-8?B?RG16bzgzeGRqRjhZQ2FleWFTanI1RlpONXZ2QXlGZmtyOWpZeHpMTzFvOUNB?=
 =?utf-8?B?Vzg5djV5cHhGaUxOUU82WmJqaTR2ejRmMHdiWEpvclFoUEVrYnhSbStISnp3?=
 =?utf-8?B?QUxKbXc5b2FxcERFeXhqdkxHd1ZVRDIvQnp4b3BUdDRSYUwxYVAxeDNDSUhW?=
 =?utf-8?B?eVB3R1Fqci8xMHJaYVZ5ZmoxRkZmMmthNVNvT21VNFFmemFDVXR4NGVZYURY?=
 =?utf-8?B?TkxxMTdoWFNoa0pzOVBnSmFiV1lyYnhvUHZNblhDemRndTVrTFlKZDNPamhN?=
 =?utf-8?B?bVkvVXJ4L3JLZ3A4bGdQRzFlWmZCa1RYSnBJMklGUTFDOUtaT1NKYWFpWG1a?=
 =?utf-8?B?MHllcEdRWXdERjdIOTBwYkhXbDd1eDI1VTRManpFZVhVcUNycEdjQ2Zpd2pz?=
 =?utf-8?B?Z2VjMmdmWTRQYzBBWGhaS3NOQUZTUEk3ZW9OL2RpV0FDMDcxNXUyN0tkRlVr?=
 =?utf-8?B?bW5RZXVCWVdWbzlwU05LRlprZmJpdHhBU0hyNjUycGRLbVdKMS85NGpWYTl0?=
 =?utf-8?B?a2MxWk5RN2plQmt5Z1RuTnJFMzladUxPWEhEWHFWN2dkQWVTMFJZTXk5NW1H?=
 =?utf-8?B?Uld3T0dUeThmVGRjUWtqV1o3c3M0bWpJQkFZUWVBOFhIdjJxTjRoVUZVQnRn?=
 =?utf-8?B?eHFHSU80WHJFVnE1OHp5OFlnQWVNRlF3eTI5eG41NGp0NTRHQmxWTXpoQnh0?=
 =?utf-8?B?aHVNeTZmWGJlR0RESHdzaHh4ZklXQ3NoenRhUTdmL2Y5MFdMUFZ4ZlFyWGJY?=
 =?utf-8?B?K2x3WjRMdW9CeVJLR2dIVUVCeSs1YUk3WDVvNTI5eVl4Q2owbXpkTGY2WXJ6?=
 =?utf-8?B?OEhjZTFhT0phbENMUmpPTWpQYWxaNjZwcDd5VmNaaE9xQ0lia040ZUxEckhZ?=
 =?utf-8?B?UXJXQlFDR1FuVGliWnBBcnd1OGZIcVFSWXJmK3ZxbmZWVHJZMzE2RU56eUJa?=
 =?utf-8?B?VUNaU2hrSWNUalROb2ZGbHpsVGhmNnhHcHN4Q1ZScU1iQ2F5a2xuQUhLUGJ2?=
 =?utf-8?B?cUxwdVltd3VjbUdXdjZIbUhOanAvTXY1TUFhQU52ckVxN3RoY01DcnNPYTJQ?=
 =?utf-8?B?L21xYmxZWmlBeUpTZHN0TXZleE54WmNtSlVTelJjM3lpSEQxeEhZNExGZVdF?=
 =?utf-8?B?c29nczluSTREellJVzlldVJRbktMTk9iZktkLzVubVQ3Y0NJS1RsOWMwL3BZ?=
 =?utf-8?B?R0tXRVk5VHRiNVFucW5GN3A4K2tyUHJUS0FCcXJQWUlVeTQ2NXdtdTd1ZEE1?=
 =?utf-8?B?cFVHUXNtbDdvaVlWSER1M1hPeWhWQVZzcjVqWmN3bDVocjdPSVVYcVkvdi83?=
 =?utf-8?B?ODVRdWxRbWJYa0tEMFRsQ3RZRW1naS9LY0tOcGZ4WU1jbmVGVGFRR3pxV2Ro?=
 =?utf-8?B?eHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <513A65934B050A42B05A61D86824D636@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a3af4e-1ac0-4028-262b-08db5dec44f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 13:22:35.3202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nr9RYdf97LQVhxKTldMpmF+GNtDS9Vo5TuyhyFYYtPpcHa23dMRXdPdyxtM8wGKWX1JUa4ZgIksxx+zRfFUNS3MKrMFrRCVqjKqXV2iXpP9seOtHvLh+ltzZ8p62Q7wX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8485
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gMjYvMDUvMjMgMTI6NDAgcG0sIFJhbcOzbiBOb3JkaW4gUm9kcmlndWV6IHdyb3RlOg0KPiBF
WFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5s
ZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIEZyaSwgTWF5IDI2LCAy
MDIzIGF0IDA1OjQ4OjI1QU0gKzAwMDAsIFBhcnRoaWJhbi5WZWVyYXNvb3JhbkBtaWNyb2NoaXAu
Y29tIHdyb3RlOg0KPj4gSGkgUmFtb24sDQo+Pj4gTml0cGljaywgSSB0aGluayB0aGlzIGJsb2Nr
IGNvbW1lbnQgY2FuIGJlIHJlZHVjZWQgdG86DQo+Pj4gLyogVGhlIGZvbGxvd2luZyBibG9jayBk
ZXZpYXRlcyBmcm9tIEFOMTY5OSB3aGljaCBzdGF0ZXMgdGhhdCBhIHZhbHVlcw0KPj4+ICAgICog
c2hvdWxkIGJlIHdyaXR0ZW4gYmFjaywgZXZlbiBpZiB1bm1vZGlmaWVkLg0KPj4+ICAgICogV2hp
Y2ggaXMgbm90IG5lY2Vzc2FyeSwgc28gaXQncyBzYWZlIHRvIHVzZSBwaHlfbW9kaWZ5X21tZCBo
ZXJlLiovDQo+Pj4NCj4+PiAgICBUaGUgY29tbWVudCBJIGFkZGVkIHdhcyBpbnRlbmRlZCB0byBk
ZXNjcmliZSB3aHkgSSB3YXMgZG9pbmcgd2VpcmQNCj4+PiAgICB0aGluZ3MsIGJ1dCBub3cgSSB0
aGluayBpdCdzIG1vcmUgaW50ZXJlc3RpbmcgdG8gZGVzY3JpYmUgd2h5IHdlJ3JlDQo+Pj4gICAg
ZGV2aWF0aW5nIGZyb20gdGhlIEFOLg0KPj4+DQo+Pj4gICAgT3IgdGhlIGJsb2NrIGNvbW1lbnQg
Y291bGQgYmUgZHJvcHBlZCBhbGwgdG9naGV0ZXIsIEknbSBndWVzc2luZyBubyBvbmUNCj4+PiAg
ICBpcyBnb2luZyB0byBjb25zdWx0IHRoZSBBTiBpZiB0aGluZ3MgJ2p1c3Qgd29yaycNCj4+Pg0K
Pj4gQnkgY29uc29saWRhdGluZyBhbGwgeW91ciBjb21tZW50cyBpbiB0aGUgb3RoZXIgZW1haWxz
IGFzIHdlbGwgb24gdGhpcw0KPj4gMm5kIHBhdGNoLCBkbyB5b3UgYWdyZWUgZm9yIG15IGJlbG93
IHByb3Bvc2FsPw0KPj4NCj4+IFdlIHdpbGwgcmVtb3ZlIGFsbCBibG9jayBjb21tZW50cyBhbmQg
c2ltcGx5IHB1dCBBTjE2OTkgcmVmZXJlbmNlIGFzIHdlDQo+PiBkaWQgZm9yIGxhbjg2NXhfcmV2
YjBfY29uZmlnX2luaXQgd2l0aCBhIHNtYWxsIGFkZGl0aW9uIG9uIHRvcCBvZg0KPj4gcGh5X21v
ZGlmeV9tbWQgZm9yIGxvb3A/IHNvIHRoZSBjb21tZW50IHdpbGwgbG9vayBsaWtlIGJlbG93LA0K
Pj4NCj4+IC8qIFJlZmVyZW5jZSB0byBBTjE2OTkNCj4+ICAgICoNCj4+IGh0dHBzOi8vd3cxLm1p
Y3JvY2hpcC5jb20vZG93bmxvYWRzL2FlbURvY3VtZW50cy9kb2N1bWVudHMvQUlTL1Byb2R1Y3RE
b2N1bWVudHMvU3VwcG9ydGluZ0NvbGxhdGVyYWwvQU4tTEFOODY3MC0xLTItY29uZmlnLTYwMDAx
Njk5LnBkZg0KPj4gICAgKiBBTjE2OTkgc2F5cyBSZWFkLCBNb2RpZnksIFdyaXRlLCBidXQgdGhl
IFdyaXRlIGlzIG5vdCByZXF1aXJlZCBpZg0KPj4gdGhlICByZWdpc3RlciBhbHJlYWR5IGhhcyB0
aGUgcmVxdWlyZWQgdmFsdWUuIFNvIGl0IGlzIHNhZmUgdG8gdXNlDQo+PiBwaHlfbW9kaWZ5X21t
ZCBoZXJlLg0KPj4gICAgKi8NCj4+DQo+PiBTbyBpbiBmdXR1cmUsIGlmIHNvbWVvbmUgd2FudHMg
dG8ga25vdyBhYm91dCB0aGlzIGNvbmZpZ3VyYXRpb24gdGhleSBjYW4NCj4+IHNpbXBseSByZWZl
ciB0aGUgQU4xNjk5Lg0KPj4NCj4+IFdoYXQgZG8geW91IHRoaW5rPw0KPj4NCj4gDQo+IEknbSBu
b3Qgc3VyZSBhYm91dCB0aGUgbGluaywgcmVzb3VyY2VzIGhhdmUgYSB0ZW5kZW5jeSB0byBtb3Zl
Lg0KWWVzLCBJIGFncmVlIHdpdGggeW91IGJ1dCBzb21laG93IHRoZXJlIGlzIG5vIHdheSBmb3Ig
Z2l2aW5nIHRoZSANCnJlZmVyZW5jZSB0byB0aGlzIGRvY3VtZW50LiBNYXkgYmUgd2Ugd2lsbCBr
ZWVwIHRoaXMgbGluayBmb3IgdGhlIA0KcmVmZXJlbmNlLCBsYXRlciBpZiBzb21lb25lIGlzIG5v
dCBhYmxlIHRvIGFjY2VzcyB0aGUgbGluayB0aGVuIHRoZXkgY2FuIA0KcmVxdWVzdCBNaWNyb2No
aXAgdG8gZ2V0IHRoZSBkb2N1bWVudC4NCg0KV2hhdCBkbyB5b3UgdGhpbmsgYWJvdXQgdGhpcyBw
cm9wb3NhbD8gSWYgeW91IGFncmVlIHRoZW4gSSB3aWxsIHByb2NlZWQgDQpmb3IgcHJlcGFyaW5n
IHRoZSBuZXh0IHZlcnNpb24gd2l0aCB5b3VyIGNvbW1lbnRzLg0KPiBPdGhlcndpc2UgTEdUTQ0K
PiANCj4+IEJlc3QgUmVnYXJkcywNCj4+IFBhcnRoaWJhbiBWDQoNCg==


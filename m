Return-Path: <netdev+bounces-4568-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 551BC70D3EE
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:25:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C4AF1C20C7E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E5E1C74F;
	Tue, 23 May 2023 06:25:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A60B1C74C
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:25:42 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF72E119;
	Mon, 22 May 2023 23:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684823137; x=1716359137;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2rzTsQvQcio3qIL0QnSVceG9lKN9gw/jSd4OiB0nagc=;
  b=lpZvKDsxqkCn31Tv5ES4x+mwSdoh8/kc/NzZL2F4r5P6PbDhamEePXgS
   YSamoODE/CRKMmMlffxGmDs3jQV0r+JY37KNXGFbfsspmJqbeAflc7qiH
   NW5JhLPQ61e/6GV6UBDo1z3XucZlpKHDVPjx2wiu8MbHlHuF5hOtwuNEZ
   Sli/KmbzyIWS32TnBaNf3wFSHPT0NmJnz3eigc2X1fkHTDZWA0comRPHD
   dlKWYrymkDG1a/8bKrZH5OBsqdp5sC1tjwPblx3/zZND+YfM7GK1uhwGb
   ZFD32qB6y0eECnX+6NL1IHVrA4/BFrnbSoVDTEITbmd/09OkcZ3pRwNhl
   g==;
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="226539635"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 23:25:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 23:25:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 22 May 2023 23:25:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9pc6pq0AphyfAbXO85ANpj/mdL97a8pUy3SvWGqNkq2vHUp4PqBpiAEHRwEGsby+HWck0axDsmJl/h0+vP82bMTSYK/7AiVPXqeOv7uWmLruCMdRZ0Owz7RaogWeM0L81xqN3HYaRWmxBRQFfkg5k4/BbYxEU0RRGa6c7+mGMM6G8VdUrgAic22BeEdQDCIY9Hk1iqITBj2MrtbG65EY+7SqIFvF744nY9x0PYP2i7JlHn8cQhwqJ7XsdUcRDkqEcWfPgkc4UwDT40P+WHv1v/AliQUta5H3oCRrmItGS2B+V8bIcQ0+iDi8ypYdOHSaS5CQ9IyrRGxmX/b1pvRgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2rzTsQvQcio3qIL0QnSVceG9lKN9gw/jSd4OiB0nagc=;
 b=iL9qVmRLUE07OsgD43Pc3GkEOyHJtHoSORCClXkkMOerpdM01umoWc3LduI2xzPr1vYBF+5YeJb50K7dQrXHilOycpNfe326pEQb9bgZYlKsHxmtxdtdmqKIH/INTpqa755W67Y8BbLpPsYFvQjKWwqBcIbPgoFCA6lBvsO9RW8dJVTo/2+aElLteYdhq2IqoomxXsh/R2uD/nAZN97/q72mlK4d+GGYGzLE78j1R32nUjdJHvnTDok8+kAp0K3wRytFvOsPC0Y/ZZ5WNAvnNj3P9bM3KYpt+gS/V+MAjE9QPXIagEB2LG1OWcLeNfBbS4axJg/GjKmtUhfO/FGHNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rzTsQvQcio3qIL0QnSVceG9lKN9gw/jSd4OiB0nagc=;
 b=cKfqQZuWoxQPS+h53uBaajdIz1ut6c5hSnOmD4uNSJ2Q/OMVDC/DkHtSFmCsaO4Z61SJKMyY7bjKFhaRGLOoCZEKcYxO/lHwIIopXOeJhzZGg+Sw4phUoQvuANjOfjZ6/pLtMM26qXd3OhZKq06QcbMftvjQYg6wdrizOQM0Tus=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 CH3PR11MB8239.namprd11.prod.outlook.com (2603:10b6:610:156::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 06:25:35 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6411.027; Tue, 23 May 2023
 06:25:35 +0000
From: <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>
CC: <hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ramon.nordin.rodriguez@ferroamp.se>, <Horatiu.Vultur@microchip.com>,
	<Woojung.Huh@microchip.com>, <Nicolas.Ferre@microchip.com>,
	<Thorsten.Kummermehr@microchip.com>
Subject: Re: [PATCH net-next v2 3/6] net: phy: microchip_t1s: update LAN867x
 PHY supported revision number
Thread-Topic: [PATCH net-next v2 3/6] net: phy: microchip_t1s: update LAN867x
 PHY supported revision number
Thread-Index: AQHZjKEm7ahfieBQc0ufRB4gwuUofq9mO2iAgAEqcYA=
Date: Tue, 23 May 2023 06:25:35 +0000
Message-ID: <df01df54-9cc4-50be-028e-8ee785d160cb@microchip.com>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
 <20230522113331.36872-4-Parthiban.Veerasooran@microchip.com>
 <f417ba86-4d48-44e9-8bf0-aa15c466a9f2@lunn.ch>
In-Reply-To: <f417ba86-4d48-44e9-8bf0-aa15c466a9f2@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|CH3PR11MB8239:EE_
x-ms-office365-filtering-correlation-id: 174db723-a060-469b-e301-08db5b5684ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +g9OCO4Kh2DQcuJ0lyk6Ykeikmov6NPy8+h5LXA0OTw60/AM1x/0p/ZQD0xZHJou9b4G8Aqlx3V6DKoiTKzf7xEdrQsU/tscFb+xGhQBnvUjukQjqEhcEzuRezVup7RHaytMaEhgy5gNx1hm5VRcoE+3Lo2aIrL6AKdZPaEFByuZ92Yi0uTBGlXyadh48a25iD+7bO+l4+jNv44Asw9f3GbS6E315OrYJfqY1ZfeECS4Nu53WNCqMFao3KT772QCZq7LKXTDDfkdQn3rsC8kVOBecjDqMKi4bnCNtwvVdS8Kt1oQ73/R/0gBMMKrsBEhLmPIxgrmFxVzKYpWTLCpmoJPlxhQ19VVt1XMB1pv4yp5F7xEF23R5EmvNjWBjfslZAF7B2GKsJPppaiEoj8tJHW1yAY4kATB77H6SW+sdfu17GtTLXGCkdQJ7FUAtThzyNFrVggBzn7qnOFCwnvyg1r4/g8/pHgGouuLCpEy4Gb9pEwF1JClMVObD5jQQkCboQ0Qw5BmVtJQPbcQGxgLDAZMJMWOeWmtSyAlY8sOJrlgfpqptQjNpknHlSC3R1+msEiFv9BX8v3LPJxQXe0bQxsJp7sd/OMTu2EifhfjMa/x2Tr5LWoT1KliOJhu6E8DdqINzswJhaFgiGKJtztX+86taY3fyNRhTs4k1/KHQXeYDesFp0ddmDyWo4BCEGNy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199021)(2906002)(5660300002)(15650500001)(7416002)(6512007)(53546011)(186003)(122000001)(38070700005)(107886003)(31696002)(86362001)(26005)(6506007)(38100700002)(2616005)(83380400001)(36756003)(8676002)(8936002)(478600001)(71200400001)(6486002)(4326008)(6916009)(66446008)(66476007)(66556008)(66946007)(76116006)(64756008)(41300700001)(316002)(54906003)(91956017)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFgyUnBiQjNTditZdjhRY2twQmxaMXpLQzhhUkN3cUdaQVdTbSthRnU1MWZN?=
 =?utf-8?B?SGpxYlFGVDVjRUFBZUI5eDl6cEZDUS9QZ0Z0dU5FaytyM1AzU3JPTEZuNk9w?=
 =?utf-8?B?NFpLandDRVZqZ1JCeU5VelU5RllKbjF4M2tiZ0ZMMllPalJQQVBLMUFsRFpl?=
 =?utf-8?B?NDlxM2FPeHUzVGI2MzQ3MVBaV2FoVjVqcktuM3BWb2VvZlNaTTV5MkZ0aXV4?=
 =?utf-8?B?eSsvTFV6M3Z2WVVGb2dCNjBtREFUejBQbzYwRkN5Qy9pVDVMOGhEZnhtQ1Bj?=
 =?utf-8?B?MUIxcXJBblZKSlcxU3dsQjh1cmlidysvakhnUFdPdmoyMW5XZnZTWTBFaWNY?=
 =?utf-8?B?QTBMK0d3VFJQUEI1TXIydnFPc2NsbDZ6b2s1S0lBdVcxUTFVc2J4cUkwNktY?=
 =?utf-8?B?am14UnBObS93NTNUYVJLbTNIS1pzcFBkWDk2RVNqQ0NKbS9LNGZMMnlsdG9r?=
 =?utf-8?B?RDVBMzFQZ1NWOHViMFpna25RTHFPcWZBb0M3RzRSSGFRd2dlbTJJcGlwMGow?=
 =?utf-8?B?aUxsS0QrZHZmczY5akRvRUhKQjQwWUFNNWtLRnk2ZmNzSEdNUzJmUGR4Y0Rk?=
 =?utf-8?B?a1FuNTArUm9wRzhJVW1pOUdHYjhIZytRZlpidFJ2VXFOaUV1N0UvSS9HQ2JJ?=
 =?utf-8?B?bmtlL2pVTHFLNmxNakIrdDB4bjJIeUl1Wm9RU0p3V2tqVElDZ2ZPZ04rWHBu?=
 =?utf-8?B?NWtyV2dqSWlONTU1ajZZb0FiWGc1SURqVGprdStGUDdxQlR4cXY3M292T1Fm?=
 =?utf-8?B?cFVwM1lxWU9jQ0NORUgwbVJUbnJ1eUVoT2w3YjRDMUxYZTdkRFdrMnMxcmNI?=
 =?utf-8?B?cG0rZDIvSlptaWdTaUsvS3VKZmlKSjRDbHNRMVIwV1diT2dkNWZrOFZFeVFr?=
 =?utf-8?B?OTV0K3NKcktlMjhRSFdvY295RC9iMGIzcFkzV0hRRWF6L1RlN1VjT1piaE5X?=
 =?utf-8?B?TFh1NnF6aFpBSk1Ia0VXS0dBN2xvWDJsRVpYdS9kUEhnSlVDV2NrMnN6Lyt1?=
 =?utf-8?B?ajAvSzZ0VytRbHlOYlZHMW9YZXFwNWJQV1RsbnBWQkwycWZGV3k2cW1hOVdz?=
 =?utf-8?B?UEMyOHdSeVY0RmNjNTQ3SzFETlVDbXZNcWx3bG92SHp1dVBPbUp5ZmZKOHlX?=
 =?utf-8?B?eWZLUDlZY1pWazk3MExKeWY0N2c5S3R4dnY3Ni9LZUJHTGh2aFBqSlRGTUMx?=
 =?utf-8?B?YzdIU1RYclpva1h4d0tMUENDckVMZkhsVndLcVhabDNSc1JMTUdtcWNyc0xO?=
 =?utf-8?B?V3J3MUZJRFg3eFBzSXNTYTNOTkFaNy9VR0hrM1QyMlFQQVMvSEFibVRWOHB0?=
 =?utf-8?B?djFxb3pkdmhoS1FsNGV1cnhvbDFtNWRvMVZoTlJPVk9BSy94Wm92bXJkeGlD?=
 =?utf-8?B?aC9YZ0p4UG1yMWduNVJhVXVqUSsxQ1NYTzE0azBudUpYNTNMK0drcjBWV00z?=
 =?utf-8?B?bDk2a0dmd1h3dUhUQThPMTM4cTZKdWU4YmxubjhtRnZyaWRWVnM2MDhPai9y?=
 =?utf-8?B?WXFxbEhpQ0ZXeVJWTzdKWkt2VUpRN3A0YVM5Ynd1Y0EybEJIUDRKdEdUTEdC?=
 =?utf-8?B?eGtwMTE5clBtQWRvbVpnTWVYTTluTkdGSXlwc29TeHJCY2c4NDgxb0RGeEt6?=
 =?utf-8?B?TkpQQlVZWE41K1YwUktHbzl6UnAwazlGeWtRZldET2hsSUlGMXFZS1VYbk91?=
 =?utf-8?B?M0JzaXlTYnJnaXhQVTdmZFBVdU1vcDF5QlZXQlg5V1RCbHp4QWNpeGtseGJZ?=
 =?utf-8?B?UEltSUFmOXFjM2Z1dG91QmhoeUVBZTQ0UlN3YkZ6TlBkWDBNSWQ5cU9YZzJZ?=
 =?utf-8?B?dEh1c3lldk56dUc0ZWFCcEFJckMyOFdNYkw4TnJRejhQN0ZLa284UnlqWFho?=
 =?utf-8?B?M2dXR05aUlgwQ1daS1c5d3dIWGhPQmRFZS9uSTVUcWFSREI4eDFnTEViSlNy?=
 =?utf-8?B?SWlrc0pMMzFsZDFEU2p3WitLOUE1YUxidk4yQWJ0Z0NyaGdsOU9SeXpwVEVQ?=
 =?utf-8?B?cFZtdldjUlVqVTd2WFpteE9KNm9mWm5XVVo0cDhKSVRtNFpyUU1ySFZCSDhv?=
 =?utf-8?B?ZkhHbWdadEM4NElGVmxBYkxTeWhWRDY4ZHNjYmFhdk1zS1FZWmhHZkpKb0l2?=
 =?utf-8?B?WEhsdmcwRkZHSS80OExRcDBSU0hLdG1xWVNZRmQvWVAwMjVjNy9xNzZNNHFl?=
 =?utf-8?B?aXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E80B07A184C95145A89EACAE06B28FC2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 174db723-a060-469b-e301-08db5b5684ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 06:25:35.3917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ouxSiu0gGY5rbDy5FQyMWhBgQymphMpM9yjDNLjh7wkishPmRlx6+mcc1xWjKLFZ7jfpC8TmKnL+PenwoTBCNc34/F/Mr8//6xMTgR0xb1bTHM4LC1SGrGxD2paUBAgK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8239
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgQW5kcmV3LA0KDQpPbiAyMi8wNS8yMyA2OjA4IHBtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPj4gLSNkZWZpbmUgUEhZX0lE
X0xBTjg2N1ggMHgwMDA3QzE2MA0KPj4gKyNkZWZpbmUgUEhZX0lEX0xBTjg2N1hfUkVWQjEgMHgw
MDA3QzE2Mg0KPiANCj4+ICAgc3RhdGljIHN0cnVjdCBwaHlfZHJpdmVyIG1pY3JvY2hpcF90MXNf
ZHJpdmVyW10gPSB7DQo+PiAgICAgICAgew0KPj4gLSAgICAgICAgICAgICBQSFlfSURfTUFUQ0hf
TU9ERUwoUEhZX0lEX0xBTjg2N1gpLA0KPj4gLSAgICAgICAgICAgICAubmFtZSAgICAgICAgICAg
ICAgID0gIkxBTjg2N1giLA0KPj4gKyAgICAgICAgICAgICBQSFlfSURfTUFUQ0hfRVhBQ1QoUEhZ
X0lEX0xBTjg2N1hfUkVWQjEpLA0KPj4gKyAgICAgICAgICAgICAubmFtZSAgICAgICAgICAgICAg
ID0gIkxBTjg2N1ggUmV2LkIxIiwNCj4+ICAgICAgICAgICAgICAgIC5mZWF0dXJlcyAgICAgICAg
ICAgPSBQSFlfQkFTSUNfVDFTX1AyTVBfRkVBVFVSRVMsDQo+PiAtICAgICAgICAgICAgIC5jb25m
aWdfaW5pdCAgICAgICAgPSBsYW44Njd4X2NvbmZpZ19pbml0LA0KPj4gKyAgICAgICAgICAgICAu
Y29uZmlnX2luaXQgICAgICAgID0gbGFuODY3eF9yZXZiMV9jb25maWdfaW5pdCwNCj4+ICAgICAg
ICAgICAgICAgIC5yZWFkX3N0YXR1cyAgICAgICAgPSBsYW44Njd4X3JlYWRfc3RhdHVzLA0KPj4g
ICAgICAgICAgICAgICAgLmdldF9wbGNhX2NmZyAgICAgICA9IGdlbnBoeV9jNDVfcGxjYV9nZXRf
Y2ZnLA0KPj4gICAgICAgICAgICAgICAgLnNldF9wbGNhX2NmZyAgICAgICA9IGdlbnBoeV9jNDVf
cGxjYV9zZXRfY2ZnLA0KPj4gQEAgLTEyNCw3ICsxMjQsNyBAQCBzdGF0aWMgc3RydWN0IHBoeV9k
cml2ZXIgbWljcm9jaGlwX3Qxc19kcml2ZXJbXSA9IHsNCj4+ICAgbW9kdWxlX3BoeV9kcml2ZXIo
bWljcm9jaGlwX3Qxc19kcml2ZXIpOw0KPj4NCj4+ICAgc3RhdGljIHN0cnVjdCBtZGlvX2Rldmlj
ZV9pZCBfX21heWJlX3VudXNlZCB0YmxbXSA9IHsNCj4+IC0gICAgIHsgUEhZX0lEX01BVENIX01P
REVMKFBIWV9JRF9MQU44NjdYKSB9LA0KPj4gKyAgICAgeyBQSFlfSURfTUFUQ0hfRVhBQ1QoUEhZ
X0lEX0xBTjg2N1hfUkVWQjEpIH0sDQo+PiAgICAgICAgeyB9DQo+PiAgIH07DQo+IA0KPiBNYXli
ZSBpIGFza2VkIHRoaXMgbGFzdCB0aW1lLi4uDQo+IA0KPiBXaGF0IHZlcnNpb25zIGFjdHVhbGx5
IGV4aXN0PyBUaGUgb2xkIGVudHJ5IHdvdWxkIG1hdGNoIDB4MDAwN0MxNlgsIHNvDQo+IDB4MDAw
N0MxNjAgYW5kIDB4MDAwN0MxNjEsIDB4MDAwN0MxNjIsIGlmIHRob3NlIGFjdHVhbGx5IGV4aXN0
LiBOb3cNCj4geW91IGFyZSBuYXJyb3dpbmcgaXQgZG93biB0byBqdXN0IDB4MDAwN0MxNjIuDQo+
IA0KPiBJdCB3b3VsZCBiZSBnb29kIHRvIGNvbW1lbnQgb24gdGhpcyBpbiB0aGUgY29tbWl0IG1l
c3NhZ2UsIHRoYXQNCj4gMHgwMDA3QzE2MCBhbmQgMHgwMDA3QzE2MSBuZXZlciBlc2NhcGVkIHRo
ZSB0ZXN0aW5nIGZhY2lsaXR5IGFuZCBoZW5jZQ0KPiBkb24ndCBuZWVkIHRvIGJlIHN1cHBvcnRl
ZC4NCkFoIG9rLCBJIHdpbGwgZG8gaXQgaW4gdGhlIG5leHQgdmVyc2lvbi4NCg0KQmVzdCBSZWdh
cmRzLA0KUGFydGhpYmFuIFYNCj4gDQo+ICAgICAgICAgIEFuZHJldw0KDQo=


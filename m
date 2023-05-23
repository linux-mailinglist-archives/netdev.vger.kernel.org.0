Return-Path: <netdev+bounces-4563-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF82070D3BB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:15:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D2181C20C75
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A644C1C744;
	Tue, 23 May 2023 06:15:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F101B918
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:15:43 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CAE130;
	Mon, 22 May 2023 23:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684822541; x=1716358541;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZLL8d/NEQCjZnU8i8gmJEGjiKlRBwGsJ02ypTRMUc4w=;
  b=axl55eMCFtcewvSaA1/GQt0W6lRjrQdrII3qg1kEgNiolFoYzKUYaRN2
   FMjVB2uTW+Lx8r38ZMFmzQQOLh58EjnQnAGUwpvheFLAQGjJSy/T/C2V7
   Z4nIXtFJc30Mm3Garex31DRCmzlzXemYelfeeUD7zIRYor9r5GX+qjuom
   BybIE+IK0hKsG3+rR9sSQYRd9Wf7n9Ejkh8n2g5mICuNEyDA44B6I6FG4
   Xj8nfkBTgJupaDg2nvLpGqUaDOZrPFY1P7wsEKqY4QI/PtRM3Xbo243yZ
   o74v9KnWN1nG7zSkB3FO4CHd8zksNYZy7H/u3qf09iS2AqH8WnA4JMOFT
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="226538545"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 23:15:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 23:15:40 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 22 May 2023 23:15:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9O2Sw5KPvS3dY4CvXzjQecSYWlo/pXjPf6G/DrcQCUvII75U3FnJT5ovgxiI/cM2njialTtUiTyJNLrlo+Ar1EfmivHqE+oWIPa7FpVoYwdLcmGj75CyvUMIG03iTh1fY9/GG+8pzsbv1j1jXDJIczoQi97azFZGnQdHYn8VHyy8EgNPDXXYEcp6H/9le7rFvQTD2vg/hZfqOy3aozJYk407JkrGwIBkvmsynoOLAUqWuCJHRHNiba9XjeGOdv8ZgTvCZ/bvR2jXCeapGS0VA7yQFf6bOzEyP1BwBKGKPlt9n1qQVboY+6evkaSxVa95oEXZCuGSzvIMIBOas1iUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLL8d/NEQCjZnU8i8gmJEGjiKlRBwGsJ02ypTRMUc4w=;
 b=H3Yo9a5ORlE9VX4/AqQIjmSl2rFAqSoe94BFCs9Q1Ojdcx1UVOyMkmI5p+MyZhHWUqP4LfKbSjziIV2nSMS/4/RaOUF0qQk8JjDDNJT/wNBJ4RUvF8PHmyi1bwQcjlpCaUY7nlwjScbyBSy70EZxNqgNy/q18AjV91oLoBiw/lNLfgHb6cuONxzNt8AFx2zXTRAVsr1VhlCzskWRqNM0qgaporzfvH3h8qx+9fXQ4B8XLBiOuyLG32WzE/zEqiY/GirNjXEEtCT8C0h1rlW1uuFunmFl3yEokTTeBu0rjvrROrWW7uCebGC0uWpw348mvcYS33psFGlhO2gA4MI0TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLL8d/NEQCjZnU8i8gmJEGjiKlRBwGsJ02ypTRMUc4w=;
 b=eGAaZ83tPEJONottGnCRTksND9W46IxznC9xTYfLO/EtKMEuDyhOSxoxP8ztq4/5TTqSStZZFmxwn35Hu2SWfmYCKhO0esPQZrAPACQ3bl73M4IxIv5IOZS6MD05QsNJkPp18fWOiHnVF88ARTnkS+HYftWFV4WM4jaZfx2gMo4=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 DS7PR11MB6126.namprd11.prod.outlook.com (2603:10b6:8:9e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Tue, 23 May 2023 06:15:38 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6411.027; Tue, 23 May 2023
 06:15:38 +0000
From: <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>
CC: <hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ramon.nordin.rodriguez@ferroamp.se>, <Horatiu.Vultur@microchip.com>,
	<Woojung.Huh@microchip.com>, <Nicolas.Ferre@microchip.com>,
	<Thorsten.Kummermehr@microchip.com>
Subject: Re: [PATCH net-next v2 2/6] net: phy: microchip_t1s: replace
 read-modify-write code with phy_modify_mmd
Thread-Topic: [PATCH net-next v2 2/6] net: phy: microchip_t1s: replace
 read-modify-write code with phy_modify_mmd
Thread-Index: AQHZjKE7iGUm1eomYEe+bTFbtQM3Oa9mOWEAgAEpsAA=
Date: Tue, 23 May 2023 06:15:38 +0000
Message-ID: <8f5ef5b1-ce52-1426-fe68-55c769885f9a@microchip.com>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
 <20230522113331.36872-3-Parthiban.Veerasooran@microchip.com>
 <2c78f2cc-ff5e-4dcd-a309-de21a5725053@lunn.ch>
In-Reply-To: <2c78f2cc-ff5e-4dcd-a309-de21a5725053@lunn.ch>
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
x-ms-office365-filtering-correlation-id: 9d5b563f-7cb1-4ad5-384d-08db5b5520af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: URpsQ8lY3JzLG+HelPNsWi52cc2Yz22w7xm9jv/k9qh4E25+b84/MbhfHJ+G40trp5u63YdpP3dhDkd7iPHqYNPUe4kX1rK/ReeqeewGNKSjnEiQaVVhIgXOJpO8+iffOEGefsHKEAPaISKTyyHWsAgCQxB5ChDbrrV1UfKJvEhYsv5SJsgOte8t8R7EJWMGXZPBkLqqHUC+hph7R+abNqeGxeYlwgHfIKBnjGyhMBCH36FYW3v9pmaaFKRfpI0tyZd/9VSNcPDVp6d6/KjQ0AFfKCZAVuegFJoi+l0L+zSarK3jEH1aa/YEAB+TCeoGnNQ78QXkR4qqaruTYbxYleqe1do3yT+/5fH/42DZA9TTbkyZK9imy4PgbcVwfXHC0KZ9XhHmFhGjbFfGkwPChdoSRVCg493AiZFNZcdnFch+JcymMVdvym9VWR4InOJiglCy1P2OyWqsmAvbHqXvCeRXUFNaM3d4WKA8fQ0fKROvxO+A1pQ7+emCvopg1l9ICn5OgzIA5iKJp3o8MVmVtOqpDFs/4Kyxg+NMqJQPrUQyp8iI/mxr69hH8ZDaGjPrIW26CgGCCipMerhwLDDqPHTlURwkI6AU+mWzHEtAm5kzMQyG4D6443kHe+iVlE9AIh1dm0UAFRNT8WYk1ggr8VQ8MhDzLYSKZvaeGEd9Lon4YW27WMcUPQuUAZ2nxL/b
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(366004)(376002)(39860400002)(451199021)(54906003)(41300700001)(6486002)(31686004)(478600001)(31696002)(316002)(91956017)(4326008)(66476007)(64756008)(66556008)(76116006)(6916009)(66446008)(66946007)(71200400001)(5660300002)(38070700005)(86362001)(8936002)(8676002)(38100700002)(107886003)(122000001)(6512007)(6506007)(26005)(7416002)(186003)(53546011)(83380400001)(2906002)(2616005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bGNWRnBTM09EaFdrTU00VG1YeU4ySjQvRmxyUXhuQ1h1aU5Kcm9uWFVHZXB1?=
 =?utf-8?B?OUl4c29wSXdCRzRYNVkvZTdwZlppZk41SlFNUlRyQlZGMllPci9pM2xvY3FZ?=
 =?utf-8?B?TWp5dGF0aHhLdWtCcWNzYlRBVlF2YXJGME5GNnNid0RvSmtGdEx0YmtWMHRI?=
 =?utf-8?B?bk9ERDBoQU13NWNwWjJTWjJtcXI0VVJub1cwTXFSQTBvZFZkL1JlZVJIL01l?=
 =?utf-8?B?S3o0RUMrUVFHWE8yZW5sQ2pZUzd6cE96SzMyajNWbm9PMC9FbEI1OXZNSWtS?=
 =?utf-8?B?OGdMOWxheVNpbzhOSGpRRnFncCs5MUlTRXN0K3dsb2UraENNZjlhbXBhZzVZ?=
 =?utf-8?B?Ykt6OWc0QzFOWFlaeGk2TzlYUnNIVXczNEtpUzJNZkp1UGlmS2tkMHhYcUxN?=
 =?utf-8?B?YmNQMDZGTno4a1VqV0R2NlRoVjB1bDZaeHdGMXZkOE9TYWdKUDBJZm9aZ0d0?=
 =?utf-8?B?cWp5U1hmbjE2eFhvMVdwM2dPejJUOVZidEt6OUhkZ0xXem92cUp3aFRnZFhr?=
 =?utf-8?B?NE9nc2JBZmVrTlNJbUNtTVhaRmNuaWp3SnBpVmt6bXc2NThuMnBnNXBjMlls?=
 =?utf-8?B?Qm0yZWlWNlpMM0tpNGFlOTN6aHVDSU1LY3J5Q3lTWldSandBQWtPQnZhT2N0?=
 =?utf-8?B?L00vUm42b3hiV3RDSTJmcS9DSEZlNW02S21YeUFPcnptV1FIWmJZOS9kMmlH?=
 =?utf-8?B?WVA5OUJDOVV3LzRnTTlZQWVDSjY1Sk5pQXdDVWNxSFdsa0pzcy9yVTZqYXh1?=
 =?utf-8?B?ckM5dFhKbDYralVMeGhIWWFsY3JGY2lVUTRJaldabFl0UTh1VHFNZG1aSjhX?=
 =?utf-8?B?MnNaM1lHMDNKSzFWZjFPKzJ3L25JaTB2MHE3TjNiOWIzdkVXSkpjVEZublBm?=
 =?utf-8?B?QlluMWsvT3dBZU9ETkNsZS9Kc2p2OVBMS1BhOEtXT2FJZUJsZkJVNkZMNGdj?=
 =?utf-8?B?dnU4Z05QcjVBMkRGRkJuNkN5cG9VYlVrWE1uSnduNmM2elJNRURabHFGV2hF?=
 =?utf-8?B?TXJiUGk4WjdzSXE2c3VEWURSZXY5ZXBzY3NnYW1xNDBndFNhOFBCMWxJWFJy?=
 =?utf-8?B?bm96OHNwa09RMmF0ZEs5dldPbVByMlJnRnF2Q1U3elNJNlIrN1g1em1WUXA2?=
 =?utf-8?B?bkExaktLalhzeHJQczRtSHJrbTNkZ1VTekl1ZUgxeVFYRHMzMlNsUzhFYlpo?=
 =?utf-8?B?ZzRKanZjWURBaG1HUHowVThUOU51dXBQVWlWaXlaS2xHYmh3Q2pSREV1S0pF?=
 =?utf-8?B?MjhGa1BFd1RlUTV4czR6aFNYa0FZZHRHKzhzZldIY2h0aFlKcnZHRXhOL2U3?=
 =?utf-8?B?MWNzQ3VWdGJ2WWlpSTBpSWg2ZmdTaVR2M0lGcjZqZjlFd3BJMUJ1RS9scGZ4?=
 =?utf-8?B?ZjBTYkd6MkoxYmdhRU16QW1mbDRGV2gxODZ3Qy9JK3llanN5NEdHUWhrMlBO?=
 =?utf-8?B?NVkrVndwYkloSlRTR1BITWhFNWQydURjWkkxTEJiV1A1Q3BlMzV4UVhvQUJv?=
 =?utf-8?B?d05vTkU1eFc3U2lhSVpFMCt5U3hTNG9EYk5QVFJhZi9JZGprWm1XY2IyN0sw?=
 =?utf-8?B?ZnVuYVdqRXdoL0s3eFJzWDQ3WGVHMTlzZ0VoU3hyRjBUTHBBSE5ZQkVzWCsx?=
 =?utf-8?B?MmZ4elA1RUpFR05JNVFxbUFuUnFrWlB2QldVNHE2a2Uyd3dmc0RFbHhYZnpx?=
 =?utf-8?B?T3hGUjZ0Rmd6UzU3OXZHTTM4MEJDamRicVhxamlwbXB6MWpUcXg3cUpodjlZ?=
 =?utf-8?B?WTJtOVpRbHlMZ2VOcmI2b1A0Mm9kZXdkZFV1N1FJc1dVc3NnK3dHRHNkZXpI?=
 =?utf-8?B?WG9GOUIyU1pPdGs3bnFMUHhrUE1nNVc0M2UyYXF4emtoOEpmeDBpZjJKb0dN?=
 =?utf-8?B?UXNFMGNMYmdpUGc0ZUc3cEhINm11T2NIaEdlbnNsSnJZaHl4NkhFamJEZHVp?=
 =?utf-8?B?OVJUdmZlMHp5SDY0a2cvc0Rnd1E3R2Z6WWMxSkZ0QmxZSlNJUWZUTUdYVHVz?=
 =?utf-8?B?aTY1TzNoK3VaOW5Sc1JINWFJS2NLZE56blJwZElvaVVXNUJMTTNDM2RkcVFF?=
 =?utf-8?B?YWZyMWZidUlXQ2ZaZEFXL2FualErMGxuS2VZeGlmaEkwQjZDQXdQdjZpSTlZ?=
 =?utf-8?B?bUh5TGc1cG5rSzBqd21kanFKeklqS2k5MGF1Rm43ZDhadis2Qk5XcSt0WldS?=
 =?utf-8?B?TUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9626C78554A404A9E736D9C35BA0B21@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d5b563f-7cb1-4ad5-384d-08db5b5520af
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 06:15:38.1468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lev+/AMItnyDn/iBzlxczJJGoY2mQqrRcYIViyJCqY8tMbAwqfOAyVEDadhZUtoXKMpcS6H4gWr2Kax8tzi/3jLdwRidzITwhPSkaFaRagB5v2+xvIXFlMcl3hI2yQha
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6126
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgQW5kcmV3LA0KDQpPbiAyMi8wNS8yMyA2OjAxIHBtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPj4NCj4+ICAgICAgICAvKiBS
ZWFkLU1vZGlmaWVkIFdyaXRlIFBzZXVkb2NvZGUgKGZyb20gQU4xNjk5KQ0KPj4gICAgICAgICAq
IGN1cnJlbnRfdmFsID0gcmVhZF9yZWdpc3RlcihtbWQsIGFkZHIpIC8vIFJlYWQgY3VycmVudCBy
ZWdpc3RlciB2YWx1ZQ0KPiANCj4gSGkgUGFydGhpYmFuDQo+IA0KPiBNYXliZSBleHRlbmQgdGhl
IGNvbW1lbnQgdG8gaW5kaWNhdGUgdGhhdCBhbHRob3VnaCBBTjE2OTkgc2F5cyBSZWFkLA0KPiBN
b2RpZnksIFdyaXRlLCB0aGUgd3JpdGUgaXMgbm90IHJlcXVpcmVkIGlmIHRoZSByZWdpc3RlciBh
bHJlYWR5IGhhcw0KPiB0aGUgcmVxdWlyZWQgdmFsdWUuIFRoYXQgaXMgd2hhdCBwaHlfbW9kaWZ5
X21tZCgpIGFjdHVhbGx5IGRvZXMuDQpTdXJlLCBJIHdpbGwgYWRkIGl0IGluIHRoZSBuZXh0IHZl
cnNpb24uDQoNCkJlc3QgUmVnYXJkcywNClBhcnRoaWJhbiBWDQo+IA0KPj4gQEAgLTc0LDEyICs3
MiwxMSBAQCBzdGF0aWMgaW50IGxhbjg2N3hfY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2Ug
KnBoeWRldikNCj4+ICAgICAgICAgKiB3cml0ZV9yZWdpc3RlcihtbWQsIGFkZHIsIG5ld192YWwp
IC8vIFdyaXRlIGJhY2sgdXBkYXRlZCByZWdpc3RlciB2YWx1ZQ0KPj4gICAgICAgICAqLw0KPj4g
ICAgICAgIGZvciAoaW50IGkgPSAwOyBpIDwgQVJSQVlfU0laRShsYW44Njd4X2ZpeHVwX3JlZ2lz
dGVycyk7IGkrKykgew0KPj4gLSAgICAgICAgICAgICByZWcgPSBsYW44Njd4X2ZpeHVwX3JlZ2lz
dGVyc1tpXTsNCj4+IC0gICAgICAgICAgICAgcmVnX3ZhbHVlID0gcGh5X3JlYWRfbW1kKHBoeWRl
diwgTURJT19NTURfVkVORDIsIHJlZyk7DQo+PiAtICAgICAgICAgICAgIHJlZ192YWx1ZSAmPSB+
bGFuODY3eF9maXh1cF9tYXNrc1tpXTsNCj4+IC0gICAgICAgICAgICAgcmVnX3ZhbHVlIHw9IGxh
bjg2N3hfZml4dXBfdmFsdWVzW2ldOw0KPj4gLSAgICAgICAgICAgICBlcnIgPSBwaHlfd3JpdGVf
bW1kKHBoeWRldiwgTURJT19NTURfVkVORDIsIHJlZywgcmVnX3ZhbHVlKTsNCj4+IC0gICAgICAg
ICAgICAgaWYgKGVyciAhPSAwKQ0KPj4gKyAgICAgICAgICAgICBlcnIgPSBwaHlfbW9kaWZ5X21t
ZChwaHlkZXYsIE1ESU9fTU1EX1ZFTkQyLA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBsYW44Njd4X2ZpeHVwX3JlZ2lzdGVyc1tpXSwNCj4+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgbGFuODY3eF9maXh1cF9tYXNrc1tpXSwNCj4+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgbGFuODY3eF9maXh1cF92YWx1ZXNbaV0pOw0KPj4gKyAg
ICAgICAgICAgICBpZiAoZXJyKQ0KPj4gICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gZXJy
Ow0KPj4gICAgICAgIH0NCj4gDQo+IA0KPiAgICAgIEFuZHJldw0KPiANCj4gLS0tDQo+IHB3LWJv
dDogY3INCg0K


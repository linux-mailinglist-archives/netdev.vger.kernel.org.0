Return-Path: <netdev+bounces-4192-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 214C870B93D
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86CF11C209E0
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AFDEA940;
	Mon, 22 May 2023 09:41:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FBF9445
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 09:41:34 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A46F9D;
	Mon, 22 May 2023 02:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684748493; x=1716284493;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jZdpTYi6t/1SxbPESfyYNcoAzhU1Qm858QSG9Zh3ZUA=;
  b=GQXNhaub9gh8/RKeZODsl+NX0yv+/+qoI7/ELf/tcj/W+gLL7U+YUGDT
   A8SUmwxHJoTSy2qwaWocurVxlwmCNIrT2O3TRm8USdzzhNfJ5rXUoUzAw
   svQs0J/u/FICmGd4WlvSMf094nHQytlcpNPkUC/hFiNgpJJs6A/OBVMbt
   wlXzBXs7yc+Vd2JtOg8ocL8Psto7AJam4xFXWwSpV+S0b8hJwkMKBSuuz
   BoiGdmCwFFDoskS1VBphVmIb8wn96taxjD4epua1F/SA7zo9vEX3bfl6E
   +pjRrYy8pO+1w1fI8WXPuKeRhsWT92IPa0p7zl0aYUmM4J5RhjejpDF1i
   w==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="216614134"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 02:41:32 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 02:41:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 22 May 2023 02:41:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VS8xBVukE6sjLYrsBaJnsSC4uCf+ZTdXj4RB/FTkr91oE7srXrnmf7RvCt4J6649zYW/Uwwv2ijD3cEqT2aj8+GmglGT8A7BT8vwB8ZYuh5Kd8oiXKwqw8Z9xfJi5zzZiwF/51ZxTq/1mxBZPhwwvjuXBCry7+ci5gfwASvRjV4zF1EPox8DIhaKV+sZyABxYfKai+0DYmtUWl1VisBEOSu1ABg5zIT0DiL9ggSOEVJ72cH9wpfZd/uh58ItNyKLZh7Vu1+V1heaQKgbn+2AcGUH9Ug7bUYDaP/X141SooBfqfIBsTD4FeJiOw8Z7ZQhabU+4uMFh59C7yjDhoBVbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZdpTYi6t/1SxbPESfyYNcoAzhU1Qm858QSG9Zh3ZUA=;
 b=MzMziOgeKFb943LYeK9VpRqTu33ISGiYLjeb8GxTarUbWOHc5QC50bRxtqh675sMnDcM2Q2zj3Dhd1jJr/Ecc5+oWiF/gXQbO5Rf8AbrYFJu/OJ7RPS8WUoJPB7LNa1LI2rWrKFNsU3Kt8PvGQtwjSH+iak4gGEq8KlH24AuR+FLXvkxmx69PHwpzxb11r2fCebV5EY5zVn/q0697XwpoRGZPbT/Hvv89IUpmopDbFNBJwz3KSluM7/AWkU/2DfsnrMxV76G8MAAAjohkcLJcyMnjXt0zuMN8PtQjAwx2Uj/VKKggQ2W998VPN4LEfLMUnGg7YFUqU3OXmoQxER0Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZdpTYi6t/1SxbPESfyYNcoAzhU1Qm858QSG9Zh3ZUA=;
 b=OSF+xZAXNE4uOSrc8bl8taGdjw1//HxHn2ODaujlqTYxt8yURe5xOfMnMcTUk9iOdMdx3wOErRkwGwehPSC6d3o1jUMWrYLPmSP0ft6wjzpY77M3tz3zhtM0XJlliDn6CYBMtcszzBWy8/ghz3FmtHK6NHGK9rL5x1LND+OiKMI=
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com (2603:10b6:a03:4c3::17)
 by PH7PR11MB7663.namprd11.prod.outlook.com (2603:10b6:510:27c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 09:41:26 +0000
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be]) by SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 09:41:26 +0000
From: <Claudiu.Beznea@microchip.com>
To: <Horatiu.Vultur@microchip.com>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
	<richardcochran@gmail.com>, <Nicolas.Ferre@microchip.com>
Subject: Re: [PATCH] ARM: dts: lan966x: Add support for SMA connectors
Thread-Topic: [PATCH] ARM: dts: lan966x: Add support for SMA connectors
Thread-Index: AQHZjJGTMZmS9kd6kk21INlry4cjEg==
Date: Mon, 22 May 2023 09:41:26 +0000
Message-ID: <db4a26f5-2255-f77d-44b2-e1c5fefc0dbf@microchip.com>
References: <20230421113758.3465678-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230421113758.3465678-1-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB7648:EE_|PH7PR11MB7663:EE_
x-ms-office365-filtering-correlation-id: 0d562957-06b8-4a05-8024-08db5aa8b672
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qSQ4hthxvNqh7Bj7sb7P6GhhPFWghZJH/pL2MvxEXHCkh9RVOhKwDJnxXkP4wF8cHcsH2hT8rSyon/2XF33jaPa6eI0EOJjCCf/qcoxsLib/WHGCxWFgtjvV9I5pqfmlcRUG0o2NLPBwQ6kxf+ulL64RTW51J91KPQwY8T/404jA16J9ilk9YHQ1uFck4XVCD4cFxsnOOCLkWST5ZHiY8n8dnmHz5EpSuphStyG5PAUEvXkcgJYYUo58Uzqb7bE3F/3nxZq9wSGlRYtdJcV/A1TevggBO48+Ical6oM0rXtdDcEe8wZRyioX5T2j38b3rF0fNnrSdhNodpsiHQT8PPlp+bkckU8aFiyZh9T0p9xjPFsYwpI6mvdIkEHhS+z1x64mvsmnG6ssz8UjZ0srqEzF3IQqr75RO54m4bcYtZdvQ/b4xGNu8uEU0uFkx2fNEWkTQpF78Q4LolZkjZLNoLVRPX2R6OnGkZrEjBMp//I4B3+Z6SNUnWBU6mAlbczS+QyLyKUj1TlMn8obo8GXhGjFewIpL1EK3PU6lGLbIjAZzUJK69dZ9WMV0JWpOqiH5DXW+wFULPL9gAzarCChE2rIDFPcoI37Nwc7IhbEwHawWteUNpfa/nGfIk6B0nOhyiFaDGHM4aKYMU2QFsunyA7SRb+9Z7uE4q710I3XYufXPq3haz3KJF0RqKS/X44H
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7648.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199021)(31686004)(2906002)(110136005)(54906003)(5660300002)(8676002)(8936002)(41300700001)(64756008)(91956017)(316002)(76116006)(66446008)(66476007)(66556008)(66946007)(478600001)(4326008)(36756003)(71200400001)(6486002)(26005)(53546011)(6512007)(6506007)(122000001)(38100700002)(2616005)(31696002)(86362001)(107886003)(186003)(38070700005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czRIRGdGbXdNV2dINFlKVjEwYjA5dk5QbkNCUGRHbjl4SE05MzFHMWgxaEtR?=
 =?utf-8?B?Y1J6Q3dxYkFOUzMwZDRJNXZJYUEwYnFldGpYZERySk1oM2l0Z0lnQ2tRL3cr?=
 =?utf-8?B?UjQwekVaTFRPQllDc1IvVnpSTmVxYml4MkxaU1BWRXZNK3JIWFlxU1Bud2Rl?=
 =?utf-8?B?R25QVEs2Z3VzdTJpRXJvTllKTzcrY08wYTNuYmwvR0tKam1RdkJNbkE3dndE?=
 =?utf-8?B?cGE5YkFNNDltNFllaW1Sd0lEem9qQjBxTVJmelpwTHRXQmplcFM2SkhEZU9B?=
 =?utf-8?B?SzBOWithajBGbXJ3ZFVxbkIxdUV5Rk5KMm1JdTJQVzFPZmpqSHZxaVh2ZThm?=
 =?utf-8?B?dXBOVDBrRTU2VVpNWjJSTDYxUEtFK09aT0NzbDZ6WDcrcWxYUjV1bUpBQWEy?=
 =?utf-8?B?TnUvV1pJR0p0S1FhbUZ2YWhXN0E0U29NcGtleE4wSUlyVmRocTR4ZEp1anQ0?=
 =?utf-8?B?THBxc21XeTlxSDJSeXFIVnhGK1l6Vm9HdDJFWVh6Z29vTUF1Q1daS05rV2k2?=
 =?utf-8?B?QzhPVE9oVmxxUFNNcXlEdGRGazRyVS9HMFU3T0ZxNllNMHQxdE5mK2RxbHB4?=
 =?utf-8?B?c2NYekZBM3NMOWZjUG52T2xyV3RXSXp0N0RnU1cvQlQ4ZVZWSy8yZDdRMEFQ?=
 =?utf-8?B?OEJVYUF5aFpKako4eE9KZFVEUVZWcU1uMDNWZ1BDTWVSWk1OMlJXR0Y2eEZn?=
 =?utf-8?B?VjRHYUZZenRraHNRWFpzTm15MDV6S0pKNnBDdFM0NEMxaUJCOUYrMHV3NW9v?=
 =?utf-8?B?VFNZYUNBN0lLNm1RdXNVeTR5VDkvUko5dGRVbHB4bTc1QURDbDljeGxKU04z?=
 =?utf-8?B?TExsQVFxUEpWMHJja2l0MlFYdklhM2dhUFNTeVpDbzF5T1diMjNFQnMzb3Zt?=
 =?utf-8?B?SzIrcHBsRFRZOXdaYktDWi94NG93MG40RUxvYk5ZWnRsYmJjazZ3SVhXYnNQ?=
 =?utf-8?B?ZE5uSzZWRk5UTklCRHh6V1QzMUh2dVhISzQ3ZWZSSTRSOGRtUzZHNno3WkN5?=
 =?utf-8?B?Y1RyYnMrVGc3a1ZSREIxWGpVbFdHNDVjN3FsMFNzY2luQUN0NEQ0WnVOWWl6?=
 =?utf-8?B?c1dwY0N0azlnRUcwSlc1RzZpSmc1UlJ6UkpCTnM4enJIU2JSN012S1ZyQ0RV?=
 =?utf-8?B?YXY2VDluaDM4R2hNcjFRcmJJU3UxS21JZ2drMSs4L09tcE4weEUwTjZyVGZo?=
 =?utf-8?B?SVNicnR0VXdud0tPMjJlRjRJdXd0OFFUbXM5b0YzNDRET1hmS2tieXd5b0cw?=
 =?utf-8?B?cnJWTU15WUloTVIvS0RFRjFqWEdiZHBtZEkzSkgxQ0NKSEpPekFlMU80SE5Z?=
 =?utf-8?B?TU5DTlpCblhUNERjM2NudUQ0UFlGYWRHMjV1RnFLekVkM0hEVzNxaVVIUEox?=
 =?utf-8?B?WWVFb0hvcVpoWS9XTzRiYjcyMkVJNmRZNjlsWVd4LzExNWpvYWFIVk9GalVz?=
 =?utf-8?B?dG1keWZIQkZKY09uVzF3eG83U0pLYlFOd1RtZUpWTldkSFdDbGlabCt3MUN3?=
 =?utf-8?B?dzg1d2I1Rmp1VEVIWHhEQzRySlFBMGdJZDFBckhJbmE3Ym1EZ09wNjZyM3dp?=
 =?utf-8?B?VVBZWXM1eEZta3I0NkpuV3A0WkphUmMxSVdER0RQMzJuRThyQXh3bkcyZXNy?=
 =?utf-8?B?QU9COVJVeE85WWYyZ3gyendtaytwU3JwZTh4N2YrT0NZK0JOaTNFZzY5YnFV?=
 =?utf-8?B?SUZrK2Qxdm9USmUwc01JTGZnbkVQK3J4Tm8rY2JUckpESDI0RDhDb0xQVHQv?=
 =?utf-8?B?MnA0NXRDUnovQzJBUzViaUw0SlhZcDlGYTYrYTQ3dHBVc1hYaVdzRWZra0FQ?=
 =?utf-8?B?UDk4ZjRxNmwrZmo5ZGZDc2Q3UHN0UUh1L1JBNHlaVC91ekxUaUlJdVBiS25o?=
 =?utf-8?B?TUxsczlKMDV5cktsVWJaSnJ6cXFvRG8vY2tuNkpySGxHQWJsak1qZVhpYlFP?=
 =?utf-8?B?Z0crYytXZkY3OXBFTnoraDlEOFZ5dGZ2L1ZNZkMrU1JieXhpeXhrMVdxbmN6?=
 =?utf-8?B?QVRhQ0taZnpteGdZd3AzTmdweTc3K3pGcGhvVCs2eU9DZU84azBURHRhbkNx?=
 =?utf-8?B?eXhXK25jNEVVWmt0NGI0bVUwSHBIaUx1K0ZpQ0wxYm05RDBCZ2pWSlJVVlkw?=
 =?utf-8?Q?g1PGK3NLMsFrLcfVCMaNcMzd1?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EACAF966578D7746AA85E3BA15C4FA58@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7648.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d562957-06b8-4a05-8024-08db5aa8b672
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 09:41:26.4633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bDaVSc3qx/AiWE4f07QUd5aT2O5KyTNoJoz63iajNCC/bpSCIu/kfv+rbik3CaLpSXHFHz5OEtwL6EFssMF4g1a0fi6E3V5ZIL8+Srbie84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7663
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gMjEuMDQuMjAyMyAxNDozNywgSG9yYXRpdSBWdWx0dXIgd3JvdGU6DQo+IFRoZSBwY2I4MzA5
IGhhcyAyIFNNQSBjb25uZWN0b3JzIHdoaWNoIGFyZSBjb25uZWN0ZWQgdG8gdGhlIGxhbjk2NngN
Cj4gY2hpcC4gVGhlIGxhbjk2NnggY2FuIGdlbmVyYXRlIDFQUFMgb3V0cHV0IG9uIG9uZSBvZiB0
aGVtIGFuZCBpdCBjYW4NCj4gcmVjZWl2ZSAxUFBTIGlucHV0IG9uIHRoZSBvdGhlciBvbmUuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBIb3JhdGl1IFZ1bHR1ciA8aG9yYXRpdS52dWx0dXJAbWljcm9j
aGlwLmNvbT4NCg0KQXBwbGllZCB0byBhdDkxLWR0LCB0aGFua3MhDQoNCj4gLS0tDQo+ICBhcmNo
L2FybS9ib290L2R0cy9sYW45NjZ4LXBjYjgzMDkuZHRzIHwgMTQgKysrKysrKysrKysrKysNCj4g
IDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC9hcm0vYm9vdC9kdHMvbGFuOTY2eC1wY2I4MzA5LmR0cyBiL2FyY2gvYXJtL2Jvb3QvZHRzL2xh
bjk2NngtcGNiODMwOS5kdHMNCj4gaW5kZXggYzQzNmNkMjBkNGI0Yy4uMGNiNTA1Zjc5YmExYSAx
MDA2NDQNCj4gLS0tIGEvYXJjaC9hcm0vYm9vdC9kdHMvbGFuOTY2eC1wY2I4MzA5LmR0cw0KPiAr
KysgYi9hcmNoL2FybS9ib290L2R0cy9sYW45NjZ4LXBjYjgzMDkuZHRzDQo+IEBAIC0xNDQsNiAr
MTQ0LDE4IEBAIGZjNF9iX3BpbnM6IGZjNC1iLXBpbnMgew0KPiAgCQlmdW5jdGlvbiA9ICJmYzRf
YiI7DQo+ICAJfTsNCj4gIA0KPiArCXBwc19vdXRfcGluczogcHBzLW91dC1waW5zIHsNCj4gKwkJ
LyogMXBwcyBvdXRwdXQgKi8NCj4gKwkJcGlucyA9ICJHUElPXzM4IjsNCj4gKwkJZnVuY3Rpb24g
PSAicHRwc3luY18zIjsNCj4gKwl9Ow0KPiArDQo+ICsJcHRwX2V4dF9waW5zOiBwdHAtZXh0LXBp
bnMgew0KPiArCQkvKiAxcHBzIGlucHV0ICovDQo+ICsJCXBpbnMgPSAiR1BJT18zOSI7DQo+ICsJ
CWZ1bmN0aW9uID0gInB0cHN5bmNfNCI7DQo+ICsJfTsNCj4gKw0KPiAgCXNncGlvX2FfcGluczog
c2dwaW8tYS1waW5zIHsNCj4gIAkJLyogU0NLLCBEMCwgRDEsIExEICovDQo+ICAJCXBpbnMgPSAi
R1BJT18zMiIsICJHUElPXzMzIiwgIkdQSU9fMzQiLCAiR1BJT18zNSI7DQo+IEBAIC0yMTIsNSAr
MjI0LDcgQEAgZ3Bpb0AxIHsNCj4gIH07DQo+ICANCj4gICZzd2l0Y2ggew0KPiArCXBpbmN0cmwt
MCA9IDwmcHBzX291dF9waW5zPiwgPCZwdHBfZXh0X3BpbnM+Ow0KPiArCXBpbmN0cmwtbmFtZXMg
PSAiZGVmYXVsdCI7DQo+ICAJc3RhdHVzID0gIm9rYXkiOw0KPiAgfTsNCg0K


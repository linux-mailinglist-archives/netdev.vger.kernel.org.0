Return-Path: <netdev+bounces-2148-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B9297007E2
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 14:29:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CA741C21181
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D86DF6C;
	Fri, 12 May 2023 12:29:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08A5D308
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 12:29:03 +0000 (UTC)
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4A613C20
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 05:28:35 -0700 (PDT)
Received: from 104.47.11.170_.trendmicro.com (unknown [172.21.19.58])
	by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id 5F86F108B365D;
	Fri, 12 May 2023 12:27:53 +0000 (UTC)
Received: from 104.47.11.170_.trendmicro.com (unknown [172.21.201.179])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 94BC2100017BA;
	Fri, 12 May 2023 12:26:50 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1683894408.247000
X-TM-MAIL-UUID: 8e1f46f4-5f48-4387-b82d-804b33e6da9e
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.170])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 3C74B10000E4F;
	Fri, 12 May 2023 12:26:48 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKZ46zl0WHFFzap1EagFq0ZE/2DuQuWfsI3KXtulii1FS0PRaJrBTXBlAYvz1wFij/3p5KwrTh4RWbqglNiAQN9xUdwgRlpkizOxW+/ReiPx3KTRxg5YP8I63jxKS/LO4g0871VjcwpriQbAPYVywcQfZjgB/0yTdnrvi3R4Nqq9aOt4AoWvqfBibkd4nuDyq9LvITPtsvhnTVTEQTg/u0+527MWhXKWZOUlYSKZw309gpCggVbbHThHRcDRJ4Tw+U0kP1vWEi/FuQ5s662ZfhQSfFY6dg7ao+ut/cbJfDOJ0W5c90c2XrvsiTwJA/h4QnVyG/BEGjMpQUkj/HUKig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+hdfSCLLA365Z8nGmJhjrci88EOyFF/v7csXPj0sGo=;
 b=cu7004pSmYQpmnZ/7NuxWM5AYhkc/CaCb1sLH72e4kc7UhAzaxwDI6HZUNcwXMdHQK+gYhIZXcW5swU9QnSB46WGs2n0AcRGzFzOCykUeAFJXimK9Nk4syPOR9yuZpO9SUz9sGizGzU047dgD6/5H5O2DkC+k8ptjal8G1p4uJOxE1tJ9AAEf7osbmtPBcjZ1g61vVS+4cKouf8eL+QH314y1cmp17j1Ho3V0nH/1BE4NNzb4VZqaBTVG2rEBpWhG8n3j1Ed8RbGwyUcPg2/FqwllMB47ab1DTfR3WlS7Z1uiUSqoEo8APyduqRdnnFPN74S2VCk+t2AbydEPB4S/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <055d9100-1e29-3534-ee76-07f5e61ef94d@opensynergy.com>
Date: Fri, 12 May 2023 14:26:44 +0200
From: Harald Mommer <harald.mommer@opensynergy.com>
Subject: Re: [RFC PATCH v3] can: virtio: Initial virtio CAN driver.
To: Simon Horman <simon.horman@corigine.com>,
 Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>
Cc: virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 Wolfgang Grandegger <wg@grandegger.com>,
 Marc Kleine-Budde <mkl@pengutronix.de>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
References: <20230511151444.162882-1-Mikhail.Golubev-Ciuchea@opensynergy.com>
 <ZF0MXKkK1tEN6QyV@corigine.com>
Content-Language: en-US
In-Reply-To: <ZF0MXKkK1tEN6QyV@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0127.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::32) To BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:4a::9)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BE1P281MB3400:EE_|FR2P281MB0043:EE_
X-MS-Office365-Filtering-Correlation-Id: 58b88203-ceb2-4073-8f3d-08db52e4273b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	f8GkIN6zhA/gtN2FjJNgYQGjHLLCyoy24pWv1PW2n4bE8evbgNasZKZWt+wyvgDFD4GvXNpKZzDkF0qgkSzGWHf6wU52oB1Iy959yF2Bq5siBZpVA2dIEmA1qoCjW8nPopUzDO75tTfbMoL2i/C77WgismQe9MV86j2CSEEp1WhcYL39trPuSmtytK6t/iZM/+w2de/1ShOG5Yv7WJOsgVdSto/GUVHR4tAZs70fT5t0fd/hbknO8Zrssucczbob7jfk9NKiyjwn/ILI83Adn/Q+K02FVV2h8uHPuQsEC+jBuWYui5S25NaxSsGQciYncXL/qAMbg8sYHF60AJbfx8T9wfJYuA8AFoNjVLYMkT0zF46vyaVQ3Ga/fFvrh/vfVrKZPpi6L4ZsqgzG5BvzXT3bl1cYxWSQWjTj0j5sTDVpHgcU84X6QOPBtd5axplDljA0dlGaG4+kxjC+/qxAtY4tOkn+TusPyqnazM26vItQ4oAdYRMuWpeLIRBCky4NPxRGK8G96nbDUzzgKudO5qzlTQMiMdgpE5EBu4deboY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(39830400003)(346002)(366004)(451199021)(110136005)(54906003)(478600001)(42186006)(66946007)(66476007)(66556008)(4326008)(6636002)(316002)(41300700001)(31686004)(966005)(8936002)(8676002)(2906002)(5660300002)(7416002)(44832011)(107886003)(26005)(186003)(53546011)(2616005)(83380400001)(38100700002)(31696002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1ZiTkVDWHAvanU0eFQ2OHdkOG0zWGpWeVZYeTdDMkQwRGNPWUcrUGhQWGNo?=
 =?utf-8?B?c0hBRC8wSCtjeW9qV2VsV2FGZ1lNanl4azlTWmpLckVrNGYwVEFNVnU2UnRI?=
 =?utf-8?B?VUl1WGl2aXMyYzYxS0NuSDFoVys3SHRLYXBiWDJsbGtRWlVlM0hsQTM1b3pt?=
 =?utf-8?B?TVJ3Q2dEZXp1c3BLaW9uUzNoZkV2YzJqZWErZVdKamVId2QzcTBrWkpSZ3kr?=
 =?utf-8?B?SGRrOG9sTFZ5dFMyVkFWWkZzdU9ncmVFV3hnKysrVld0cE9qcXJWVXM3SHBq?=
 =?utf-8?B?QzBQQUgvdmIyWk5jRlNEYVlrWlhFWmozb3pnUVVranZKRktxUmFYR3NSeDl2?=
 =?utf-8?B?eU1LYkVWdTh2UmRyNmNCTk14NHQ0QzNvVGwzYkloenNxMVlyd3c2bFB1VUNP?=
 =?utf-8?B?R1ByMjBYendLVExhUGNsZWxGZHZTMHRwSFFJZ3RTbnlvaFYwREJ1TUtSUTB6?=
 =?utf-8?B?QlBZOEk1NzlId3c4bnZUN3NnZ3FYNFZKZVQ0dFZtNktHbmk0VkZkdHptQ1Qz?=
 =?utf-8?B?Y3FWTDZRMTNMRG43N3pTMFZQV0hBUjJxZHZQSzB2d2hpa3pvMjRDd1MxYnBL?=
 =?utf-8?B?S2hIVnhKaHhBcUdEQlJZYWdaQ2hEaG5KeDExUHpSNHhIU1MwNTNuVy9xYWps?=
 =?utf-8?B?NngwVTZuVms2anBCQk1tMlZGL1VUQm1acmRwL1M2ZlBxSEdYUXJiV1h6a1pD?=
 =?utf-8?B?L3ZheE9ZaEtHaWFaNHV4M29KbjBDT3F2dEVVR2o0cm0rck9WZVQ3Wit6Vmw0?=
 =?utf-8?B?NW0vMUFpK01ta0FtV2o0c2h0cU0zdGFHNEZTUzVYN3VxbkxZK3ZJRHoyVzYz?=
 =?utf-8?B?c3AxMFEwcTdOUlVZM3hYUWxMUGJLWk5GN2NhTk16L3NmL2xJZWRLeXdYdmN2?=
 =?utf-8?B?Q0EvNmVJUmRXNjFMcWgvL2VYblJ4UVZJWHlYVVZtalZJVnM3Y05wTmo5dGFJ?=
 =?utf-8?B?WTEzUld1ODQycFFUOU9DZGV3d2I5U0dFaks4MGthUTFYY2M5NktDU1VQMVdt?=
 =?utf-8?B?TFcyT3JFWVpNaVlZaVZDOHJDSjV0ZWl5eFpqVWZESnJGMS9raU9SR2lYWjFp?=
 =?utf-8?B?K0NxaEtKRWJGZVZSZ0p4YlIwdjBFbTVWTktSNHRlcnN0Q2xlS0oybzU5NzNE?=
 =?utf-8?B?M0NRNWlRKzArNkt1ZnlsZHRGcENsc051eElGWjlqUDh0SDQ0VWx0RW5mR2lk?=
 =?utf-8?B?NjdCRmtwYkF4MHAwZzR1aHQyMFVKQ2hCZ2VhN2hOSmR2UVQwcDBOZ0pqRnJ6?=
 =?utf-8?B?WmxGcjUxSzNYN3ZyK1VYSTlnaGxVRi9wNnlPcEZqOFRzRjM2czg5VnJScjc1?=
 =?utf-8?B?dFdkTTF0NXhyS0ZyK3p2ZXN3LzdlQXVOT0wzcCtjZDBpVTYydUI5ZzVjM1dW?=
 =?utf-8?B?Uk40d0hhOEt6ejJWTXlPemk2RlNQZFh6cEJYSmc0Z0FIc2EvYzE2S2VCbmcv?=
 =?utf-8?B?cGV4SzlaZjFURVM3WFZlcVZJVFVEU2xaTC81Ky9sZFNEMldiRmtCRWtRRXNu?=
 =?utf-8?B?aGhrOU1IcWpRSDJXME05cjVoNjRhb3dCWHBzRWVWbndxR29Hb21vQk9sMXho?=
 =?utf-8?B?aXk1QXY0VDBhcjgydit3bmJHSWFUcFdwQnl4WnNKSWV6TlptNitoRWh5dHpU?=
 =?utf-8?B?VzExK2ZYNHdUOUhvaW8zdTg2T2lVWmRhdTF0MkR0UHZjenU3WG5BQU1RbHFw?=
 =?utf-8?B?Rndxb0U3Rm9XQlB2NVY2bHoxNUVCbDBIS1pXUXRJUTJCNnJxWHRsemJCbXJO?=
 =?utf-8?B?TjNWS2FIeFYrb3lXVll1WnEyQ2R6bWYwTU5VVWFFTmVSRUk1MDhid0ZSVzhl?=
 =?utf-8?B?Mnk5dElhZnRuc1NsN0pubFp6cFMxL3ZpeXA0MEgwR1hsQkdobDNXS0F5c2Jo?=
 =?utf-8?B?NC9nYTc0ZGVWOXJqSG5mQXFGWjA4SFlhMG9QMlRxdzN3UzBLR0lUUGRxNEJS?=
 =?utf-8?B?TGJWTjFrZVE2S3NRVDhOVjVid2FHQUJZd1RaU0lzOFJZRXJ1UlF5b3kwaGVN?=
 =?utf-8?B?cjY3UERUVEhFd2lockF4enhZaUgwckZ0NUlMMmVmK0hHSjhlYnVOMmhSdGpp?=
 =?utf-8?B?THZEUVJza09hOFBoZC9oWnArLzRPWXptTzRBQXN4UTlZR3dEQ3RPS3pJcE16?=
 =?utf-8?Q?g8Ft+j1cDakOILyFvFa/A2Uba?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58b88203-ceb2-4073-8f3d-08db52e4273b
X-MS-Exchange-CrossTenant-AuthSource: BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 12:26:46.9234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 06RDxuIf6eQ/MJtnFM4WuFG/JlE6k2CBm5bOLN9jK+dbWV8ZVX8znxXnKjnMu61qbCYahIU9b0GHS4bTKv6Nwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB0043
X-TM-AS-ERS: 104.47.11.170-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1007-27620.007
X-TMASE-Result: 10--27.417100-4.000000
X-TMASE-MatchedRID: EMyCvCfVN1EMek0ClnpVp/HkpkyUphL9Y6cKHJXjZfTRLEyE6G4DRIoW
	lS5cw47VDj8YRDafOjaRtvxxSNJ73V5Saok1/fZCOjf3A4DTYuE9hYABIgx2v/5RBOvixc5SgK6
	qCGa1Z9dYYfnBUCWGoV+wX0SqSP+33szvVnpBZzjece0aRiX9WgT2OEnoCt48sLigDA/FpvWGq2
	b390YgW9VVozIm8IuW7s2Nt+r3hd/NiKALwBvAss69emDs42ddIfyQNHR2naaI6oxsBIW8EucDD
	zKnTzUsvAQxPUzd//bs+Reb+uzo9+VaI0j/eUAPqh+piAXo1X9ULRRq00o2mVc/CedjlcvkeCxT
	OVrPrCskXOk8OePtLgHPh0m8/rkHmHQ8ODC8xrYdZEkR8Y/meVjKpSEColRJhUyuigqZPgzh0m+
	JrKxx7Ebf3XPwCSGamEw+qTWEPMjtRphfdomnhKoXHZz/dXlxuoYFb0nRiqO7N2IdiDgmM9KpMG
	DE0EVGMZtLpjey/X7GJtkdCrnkPIKM7SeEhKNNfsrJIMK37At9LQinZ4QefL6qvLNjDYTwsuf7R
	WbvUtyrusVRy4an8bxAi7jPoeEQftwZ3X11IV0=
X-TMASE-XGENCLOUD: 02328cd5-30ed-4af3-9e83-eebccd303f03-0-0-200-0
X-TM-Deliver-Signature: 73A4CFE9194CEB6FC7B390EB63649725
X-TM-Addin-Auth: eIvGqBEG5R/RsY4S2Avz4rOR0XcUVrgj/doZpZtu77ft75PBUN+2FkcRns7
	pXaf+xU5450r3qLkak49Vfca/XdnM6Y/H2LUEp20rxuSLjXhvTL0q6hAobH7eAVtOF58/6eX8QM
	QQgacBagbUzwktiTwE0poeaoR2g/l2BsVEmXFiadPu96JVNjkeOvNHVF9YXsFpTyAFtZ8HpZ+lc
	+HRokpBs+gc9cVjNz2Og5uNknUc9SZtI8pivysFQuERycdmKpgCiSP/bl31sll1gLqi77Z86CQ0
	w+2s2nTtfmMk9A0=.R94kxtKnUFadozFc1SZRUXC0thldq5OlSHQ8r2Wr2GKaZ78C6MyyM96V2f
	MpGszPNhBkMOeUp15KRq1ODVSJ8f9/BD0rD1NsoqKFeqB/AdmlyaUQAT1uOwZ0KdrGuhiDWIVA+
	LIrmY2DWP+RtMLqJ45U4HRZ/C1h44RcmNo97qDE3JRDEQeXuqEZ5HUETPORyc67cNJ0YNyy8oQu
	2tn01FCXUdtOyySpbvdyGXOi6OnPBYaucwpAWnI61Fwq/VbggvSZBaS8o8oG2eEMpfn1BQhdyGT
	1Gt/qOjZ38ruf0TSn4VCBqpx+FYXcV/3F+jmlXefRl1IC9odymYbhVz1DWg==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1683894410;
	bh=mUqVvoAcmsow2f+AdAk0Q+hUy6BYnY7pS1UyNcFvFko=; l=7692;
	h=Date:From:To;
	b=vB2lPJf9msdncTDSaZENMIh66S7SSvYM/NYsmardUEBtW1WDKKySCC3A9hs7StIe3
	 4gWaHI9jAoX62xNvjMBXhzgWDR/RI05FwUjbjG3LXnglKY1ezcBsHKUx+LTXVW+Xi3
	 9c7uwpLcVBWbGg2ZTfwwVCDhsYWwBpwnI8p4pSORB9TgLmEAtoICvgezs0JPjVo8EP
	 HlGRMh6o1DQ6qdEVrmN/fGQsc8Wg0SplQda+NzSvlbUP0xxKUV66uvz91hhRtgCASf
	 rj5APiiJbDz1vq+GBakFBw74mj23UGRmONm+/i4ASXY9n3PyZQjPlp5FLEl93GMLXy
	 JDLjXVDpbAf0g==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 11.05.23 17:40, Simon Horman wrote:
> On Thu, May 11, 2023 at 05:14:44PM +0200, Mikhail Golubev-Ciuchea wrote:
>> From: Harald Mommer<harald.mommer@opensynergy.com>
>>
>> - CAN Control
>>
>>    - "ip link set up can0" starts the virtual CAN controller,
>>    - "ip link set up can0" stops the virtual CAN controller
>>
>> - CAN RX
>>
>>    Receive CAN frames. CAN frames can be standard or extended, classic or
>>    CAN FD. Classic CAN RTR frames are supported.
>>
>> - CAN TX
>>
>>    Send CAN frames. CAN frames can be standard or extended, classic or
>>    CAN FD. Classic CAN RTR frames are supported.
>>
>> - CAN BusOff indication
>>
>>    CAN BusOff is handled by a bit in the configuration space.
>>
>> Signed-off-by: Harald Mommer<Harald.Mommer@opensynergy.com>
>> Signed-off-by: Mikhail Golubev-Ciuchea<Mikhail.Golubev-Ciuchea@opensynergy.com>
>> Co-developed-by: Marc Kleine-Budde<mkl@pengutronix.de>
>> Signed-off-by: Marc Kleine-Budde<mkl@pengutronix.de>
>> Cc: Damir Shaikhutdinov<Damir.Shaikhutdinov@opensynergy.com>
> Hi Mikhail,
>
> thanks for your patch.
> Some minor feedback from my side.
>
> ...
>
>> diff --git a/drivers/net/can/virtio_can.c b/drivers/net/can/virtio_can.c
> ...
>
>> +/* Send a control message with message type either
>> + *
>> + * - VIRTIO_CAN_SET_CTRL_MODE_START or
>> + * - VIRTIO_CAN_SET_CTRL_MODE_STOP.
>> + *
>> + * Unlike AUTOSAR CAN Driver Can_SetControllerMode() there is no requirement
>> + * for this Linux driver to have an asynchronous implementation of the mode
>> + * setting function so in order to keep things simple the function is
>> + * implemented as synchronous function. Design pattern is
>> + * virtio_console.c/__send_control_msg() & virtio_net.c/virtnet_send_command().
>> + */
>> +static u8 virtio_can_send_ctrl_msg(struct net_device *ndev, u16 msg_type)
>> +{
>> +	struct virtio_can_priv *priv = netdev_priv(ndev);
>> +	struct device *dev = &priv->vdev->dev;
>> +	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
>> +	struct scatterlist sg_out[1];
>> +	struct scatterlist sg_in[1];
>> +	struct scatterlist *sgs[2];
>> +	int err;
>> +	unsigned int len;
> nit: For networking code please arrange local variables in reverse xmas
>       tree order - longest line to shortest.
>
>       You can check this using:https://github.com/ecree-solarflare/xmastree
>
>       In this case I think it would be:
>
> 	struct virtio_can_priv *priv = netdev_priv(ndev);
> 	struct device *dev = &priv->vdev->dev;
> 	struct scatterlist sg_out[1];
> 	struct scatterlist sg_in[1];
> 	struct scatterlist *sgs[2];
> 	struct virtqueue *vq;
> 	unsigned int len;
> 	int err;
>
> 	vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
>
> ...

https://docs.kernel.org/process/maintainer-netdev.html

I see, I see...

>> +static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
>> +					 struct net_device *dev)
>> +{
>> +	struct virtio_can_priv *priv = netdev_priv(dev);
>> +	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
>> +	struct virtio_can_tx *can_tx_msg;
>> +	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
>> +	struct scatterlist sg_out[1];
>> +	struct scatterlist sg_in[1];
>> +	struct scatterlist *sgs[2];
>> +	unsigned long flags;
>> +	u32 can_flags;
>> +	int err;
>> +	int putidx;
>> +	netdev_tx_t xmit_ret = NETDEV_TX_OK;
>> +	const unsigned int hdr_size = offsetof(struct virtio_can_tx_out, sdu);
>> +
>> +	if (can_dev_dropped_skb(dev, skb))
>> +		goto kick; /* No way to return NET_XMIT_DROP here */
>> +
>> +	/* No local check for CAN_RTR_FLAG or FD frame against negotiated
>> +	 * features. The device will reject those anyway if not supported.
>> +	 */
>> +
>> +	can_tx_msg = kzalloc(sizeof(*can_tx_msg), GFP_ATOMIC);
>> +	if (!can_tx_msg)
>> +		goto kick; /* No way to return NET_XMIT_DROP here */
>> +
>> +	can_tx_msg->tx_out.msg_type = cpu_to_le16(VIRTIO_CAN_TX);
>> +	can_flags = 0;
>> +
>> +	if (cf->can_id & CAN_EFF_FLAG) {
>> +		can_flags |= VIRTIO_CAN_FLAGS_EXTENDED;
>> +		can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_EFF_MASK);
>> +	} else {
>> +		can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_SFF_MASK);
>> +	}
>> +	if (cf->can_id & CAN_RTR_FLAG)
>> +		can_flags |= VIRTIO_CAN_FLAGS_RTR;
>> +	else
>> +		memcpy(can_tx_msg->tx_out.sdu, cf->data, cf->len);
>> +	if (can_is_canfd_skb(skb))
>> +		can_flags |= VIRTIO_CAN_FLAGS_FD;
>> +
>> +	can_tx_msg->tx_out.flags = cpu_to_le32(can_flags);
>> +	can_tx_msg->tx_out.length = cpu_to_le16(cf->len);
>> +
>> +	/* Prepare sending of virtio message */
>> +	sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + cf->len);
>> +	sg_init_one(&sg_in[0], &can_tx_msg->tx_in, sizeof(can_tx_msg->tx_in));
>> +	sgs[0] = sg_out;
>> +	sgs[1] = sg_in;
>> +
>> +	putidx = virtio_can_alloc_tx_idx(priv);
>> +
>> +	if (unlikely(putidx < 0)) {
>> +		netif_stop_queue(dev);
>> +		kfree(can_tx_msg);
>> +		netdev_warn(dev, "TX: Stop queue, no putidx available\n");
> If I understand things correctly, this code is on the datapath.
> So perhaps these should be rate limited, or only logged once.
> Likewise elsewhere in this function.

This block is almost a never. Like all blocks returning NETDEV_TX_BUSY.

virtio_can_alloc_tx_idx() may return on error -ENOSPC or -ENOMEM.

The queue is stopped under "/* Normal queue stop when no transmission 
slots are left */" before -ENOSPC is seen here. When -ENOMEM is returned 
we have more severe problems as some trace, considered as a theoretical 
issue only. So if the trace is seen most likely flow control got broken, 
needs to be fixed and I won't want to miss this.

>> +		xmit_ret = NETDEV_TX_BUSY;
>> +		goto kick;
>> +	}
>> +
>> +	can_tx_msg->putidx = (unsigned int)putidx;
>> +
>> +	/* Protect list operation */
>> +	spin_lock_irqsave(&priv->tx_lock, flags);
>> +	list_add_tail(&can_tx_msg->list, &priv->tx_list);
>> +	spin_unlock_irqrestore(&priv->tx_lock, flags);
>> +
>> +	/* Push loopback echo. Will be looped back on TX interrupt/TX NAPI */
>> +	can_put_echo_skb(skb, dev, can_tx_msg->putidx, 0);
>> +
>> +	/* Protect queue and list operations */
>> +	spin_lock_irqsave(&priv->tx_lock, flags);
>> +	err = virtqueue_add_sgs(vq, sgs, 1u, 1u, can_tx_msg, GFP_ATOMIC);
>> +	if (err != 0) { /* unlikely when vq->num_free was considered */
>> +		list_del(&can_tx_msg->list);
>> +		can_free_echo_skb(dev, can_tx_msg->putidx, NULL);
>> +		virtio_can_free_tx_idx(priv, can_tx_msg->putidx);
>> +		spin_unlock_irqrestore(&priv->tx_lock, flags);
>> +		netif_stop_queue(dev);
>> +		kfree(can_tx_msg);
>> +		if (err == -ENOSPC)
>> +			netdev_dbg(dev, "TX: Stop queue, no space left\n");
>> +		else
>> +			netdev_warn(dev, "TX: Stop queue, reason = %d\n", err);
>> +		xmit_ret = NETDEV_TX_BUSY;
>> +		goto kick;
>> +	}
Below is the "normal flow control" block which is likely to be entered 
under load. Everything else returning NETDEV_TX_BUSY is "never" or at 
least "almost never".
>> +	/* Normal queue stop when no transmission slots are left */
>> +	if (atomic_read(&priv->tx_inflight) >= priv->can.echo_skb_max ||
>> +	    vq->num_free == 0 || (vq->num_free < 2 &&
>> +	    !virtio_has_feature(vq->vdev, VIRTIO_RING_F_INDIRECT_DESC))) {
>> +		netif_stop_queue(dev);
>> +		netdev_dbg(dev, "TX: Normal stop queue\n");
>> +	}
>> +
>> +	spin_unlock_irqrestore(&priv->tx_lock, flags);
>> +
>> +kick:
>> +	if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
>> +		if (!virtqueue_kick(vq))
>> +			netdev_err(dev, "%s(): Kick failed\n", __func__);
>> +	}
>> +
>> +	return xmit_ret;
>> +}
> ...



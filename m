Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783F163B169
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiK1Sde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbiK1SdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:33:00 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F5B10B
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669660275; x=1701196275;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JSx+scvk33CxvmyMj5/yx6l5r4ohADRyvShm++LL6pk=;
  b=W+L9dixZO9LdGsd9onMOmfOUBSVPAxVFL8q1UpMLuWlLGo3yS/37IDnc
   jKW8skvhU03NambR12J0W/Ed5bl0N0Asi0OT+VJhF/Z+yIv9K+lcFt6bI
   I2jZsu3pb08xQRgUp/B76BDEZCOOomXXO+utGG3YCBF+ZApIjXK9v2nfr
   /bCd5VhWAiNpo3kLWj7XMpZAJy4OmulgTGWYYW6RSnmuRQAhH4qxYCQaX
   vBYdP7jOdZn7TEh152V34kdcVdjc+H49FwqVm04W4Q31T/OTGXYj5pBwA
   lWBYZXmKoGHUvtTU013d/lCperoM9WMtHd3VOx95cSqXWTV6SVC8pIC6A
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="313620161"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="313620161"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 10:31:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="637318888"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="637318888"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 28 Nov 2022 10:31:09 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 10:31:09 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 10:31:09 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 10:31:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ul+y4tglwCR0fceV9ZVq8IPCExOwYCvJNrC1+lJkXl1FByQHlOecJoMTHHFAydboSJoUqQnOyK2EqwFfylm8q0gATey18/C95LZmJl/Bp3flVzfFJ/lO+S80n9o+torcbqlP5swIpxceCbDG0fEMCfu7i5kchC+iAC1phds0h8xc1vk9/htwJ2vq1hg6Rwg66ZsWftrs8Har/8ZDvADHFZDxQlUukD+oWOmOV6ESnIBQIyIVgoJtoCwBLGWZvgEVnpTH+LHMCIRUxR1ec6T0opxvrnVZfFK2RLIAia/Dj7+q+jGb9jf6iSTSPCr7kEpeoOiSHqRFgUGwQtAvEDd6lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b440jqebhtfC3RFLX2kfnK+4N2WUChb1TvSjdreGulM=;
 b=jAJVu9DaNCv26GxN4zx06oWgRkhYzIBiFX76zt4o7QOB8qcl9a4Am4m6WjU76m8wm1FtRA8dGFdq3di2xpna9AOcgeTxFvQ+1ZrnkRd4f8VVBW9nicykss3dZfesxAEvyBslG+uyWInvsIJ8TNSRQrvCNadVEEapr+L6BhopjZ5d4dTdVfABBknxukpk5qegFGY63qjypcQ7z1QvRBuGr9MJEBqrWpU5vXU9FGMSheT+3qC5DcjWcLHVEoL9Smy/aeipPDB/+oseUPqSJKaIntc89huUcKaxEJTWJL3gyK2jNTDkZQx2YlCOtYCVwTkANExmvrMHZXX6N6yDrltExw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB5206.namprd11.prod.outlook.com (2603:10b6:510:3f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 18:31:06 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 18:31:06 +0000
Message-ID: <395aa6d3-c423-266e-28e1-43f8d66dce2a@intel.com>
Date:   Mon, 28 Nov 2022 10:31:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v2 1/9] devlink: use min_t to calculate data_size
To:     David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
 <20221123203834.738606-2-jacob.e.keller@intel.com>
 <d561b49935234451ac062f9f12c50e83@AcuMS.aculab.com>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <d561b49935234451ac062f9f12c50e83@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:a03:331::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB5206:EE_
X-MS-Office365-Filtering-Correlation-Id: 79854a79-7842-4068-8dbb-08dad16eb669
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ifwSb8L3p+uEmyXhXFt872UAbwJR0eFl0mf3bM+7Ruy2PPhMtR9sIK7y37NLCwzzWH3o73o0ccaKeJ6RRL08Ck2yxzIihHOsEHhubXjLrg8iBNa6y4xiAf8j21gwJSjdtGSDBJfCorbIBxkTcTHFpj8UvJHlkoUaG63BEwJuN3hdUUsYnLFm1JjDeDtpOZt6Vwh+0jvHdg4ungxLioQGWyqmi3z374NhOrXi+xDmy1/pQX29RpJl9rrI7Sx7qv4J4R7+kuRab29Vbc590xwD//cHx54y1pJXgTc2Dsyzt/sAPHE7wYGOVps3XEImJh5VS9duPWqJALIBpeZpByKBSnqNyJrKDOQJBh+ClaruMsf1KCMtQMrNQW9qRt+QM/O5eVRA+MpmmOIDJrk9rEev75qpMP9/U8bnQH89MZcsQ7535ecV8tI0g6fkwSmr1aTGg/WQzetB5xuFyl4ZdetPn4ztgrgkPsiIj/oomEQx1JTY+/BH5s10TgiydDCvt10NfJwG/rlT0yMm4nHl1HvHxoYmZ4Cd10EOTG5tEBepPto6zG3+H7rKlOauj++79HozV7c6JTExX1VZOCZ3/1FHtQ0BBJv/PsQDj1KMT4MtePAp8e8vbCblXUo5M1oaxUW/DwIEpZBVuPXo20j84//IC4xK6JnMCX9FJp9w9I2hr5OeUSCXvkYzn0AiSRNrVwcm7U9frf6iTcsLFajDpEPzUGRDGiMSBOjNPsfuBJ0aN2QLCA+zYdVgZiEfv8yjysR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(396003)(346002)(136003)(451199015)(2616005)(31686004)(2906002)(83380400001)(478600001)(38100700002)(6486002)(66476007)(66946007)(41300700001)(66556008)(8676002)(36756003)(82960400001)(26005)(6506007)(6512007)(5660300002)(53546011)(8936002)(4326008)(31696002)(86362001)(186003)(54906003)(110136005)(316002)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGZidER2TERSYi80VmM2K2RreDBESEx5YUI3a2RwQ3c1Rjk3ZnM4MTZYdjdm?=
 =?utf-8?B?ZmxKWXRoMGh4dktBTCtPVWJBaGJZbFM5dVlYb3UxMVR3U0VIOU51bmVscnlj?=
 =?utf-8?B?ZDN4c3BRRS9lOC92RUFJbXlXL3ZwbkpySm80R0RkTDNndlplQmxMc3VzRjFC?=
 =?utf-8?B?Z2RuRU1iYzhFU1VUU2lQeENaYUU5OG1wUDdsNHMvUkZhY1NpNjRkTldlWjly?=
 =?utf-8?B?Zk41MC91aW9ZSnE5REpSazltekhKc0hHYWZOanBIajY4eUd3U2IrTWo2Qm1u?=
 =?utf-8?B?Y1JGcEF4NUdOTG04Unl4K0VhOEN1SytaWnU3VVgzSm1paFFYTHZ2WkczeCtS?=
 =?utf-8?B?c2pubmpmRzh1R01PU0tjbS94d1VNOVNSaUpsVkxBbUNTZE5EVVdwUGJKSnRj?=
 =?utf-8?B?UE5DMnpuNXNFbUxpT1NvQzN2UFBYRDg0SnZjakZ6WFZURzNiMi96MUpqaWNY?=
 =?utf-8?B?ZFg2M1ZEOEJ1VEdNWUU1Uk0xWTRaNldmRDI2OEg3SXZpcEdKNXV5UUdaQ0pV?=
 =?utf-8?B?c29CbE1RWDJsd1R3ck92dVFVdlorMEp6eGtzRE5vQkpUTStjbFFwd2hmL2k4?=
 =?utf-8?B?TTBpTlUwdVNPallqWnJEN3lSaDFOcmlaOVc3VENDU0lmWG9pdEZoakVnVU84?=
 =?utf-8?B?UURYNmQrNWFZU2duc2pyZFZkVURHS1BhR1MybU5hREkxNzhzRXJHSm9Dejcy?=
 =?utf-8?B?Ulk3UWU0Ym9SUEcwVnc5bHloS21TMElYL2EyQ0JQWFRrdGRDazFwdWVzYkND?=
 =?utf-8?B?WCtvb01YR2NLai9sd01mM0FNUG9wSmpUdTJCdEdpMkpkL2tWS0M5ZVMybWF3?=
 =?utf-8?B?bTNVV0diUkx1NE0zeXV0YVh1MTdNaFZUd0s1ZVcxczdtNzg0VEVMb0thdmhD?=
 =?utf-8?B?TEFwRHJXT1IxNGRCVzFIUTZQaFVzeVUrSDg5OXhLcnVROFlmUytva0ZQeXBm?=
 =?utf-8?B?RFRodzRMTWZJck51MjltUU5EYmtnd0drMUx3SU90cXFZSDZvZjlNTzZPeHpL?=
 =?utf-8?B?YnIwS0x2YzJwQ3ltOFNxYkdacW9tR25CR3VRdEMxeEd2RG12OEFwUm5yN21i?=
 =?utf-8?B?aXAyM0dsUXlqenRnRk94cWdXOTdXSm5TWUI3YU93dktFREtLVU9HdHN5Nzl4?=
 =?utf-8?B?VG1YamRVUUhBQTNOT2hXWElBSFFhNGpHZFBFTUx5U0FhYWlNZ0FickhvU2l1?=
 =?utf-8?B?OWVJNXRtSDJ5T2FXeU5ZM1NrcmxzY0xzR3k5cWl0Kzgwb0MrQThMRHIzdzlv?=
 =?utf-8?B?OG1QUlY5UUpEZURTUWVCZ1RWTjJ2blNYdTdPQ3dvVjdQaG9RT1BnQU9NUTAz?=
 =?utf-8?B?SUprc0NKUmwwa3Y4RzFPTG13R29GSWJERUVPd0FrNHlTSmxYWStBdkc4SzlL?=
 =?utf-8?B?WmhXSk5uODFEc2d3cDZXc25yOTZ5dTBxUERNTW5TcDF4MkhjcmRUamhpNUJt?=
 =?utf-8?B?RDc0b2Y5cHFoZnlOSjZ0T3BMRVpvakJjQ1JWZVlndi9DQWM0Q1NFQVhXYWZL?=
 =?utf-8?B?MDViWW81SEJYdVE5dnB1bERCVVVrMEs1Yi9vdkRaeGY1bUJvU3BmTW54OW96?=
 =?utf-8?B?SHd1ajMyT00xUWg5blNiRG02Y2FQeTVwcDEvTnJsS05BUURRZ1htOG5yUEFE?=
 =?utf-8?B?dzRsNFJ0Tzl3bEwwN1gya0prdytVbnljOVYzbDgzYVZuWUpZZmhveVQzNXpn?=
 =?utf-8?B?OU9MMkFPUmxIYjQwQnI4bHVGem1FL3d6SHlTR3NZKzBPdzM2QUN0TzBMSFE2?=
 =?utf-8?B?cERFMjNXMzlDdE4zYTJIRDdDb1lZMXMzTWk1c2R4Mlh3MW5ycDFkUzdkMGpE?=
 =?utf-8?B?VG9QSWtFQ3NQUlZoV0NTbWp6aUNNRURlN0w0UUJWRHBvbWpaT3UyM0pkV2RN?=
 =?utf-8?B?WFNIdkg0OERkRS90bncrZEVrakNCdGZaUEtseTNnbXZvRHl1VVc1UHJwV0tH?=
 =?utf-8?B?Q1E4cDgwa0MxUWNRY2Rhd09JVWpNNDdENW5GcUk5akE3MEVBTTUyVXp2VzhF?=
 =?utf-8?B?NWlObDg2RklRTE9KMmxxVHdGOEZjSlRCRTQvY01jNnRBemY0Zmh2Q29xOW92?=
 =?utf-8?B?VEhKSXFFTGdOaTc3RFZ4bVN2S0ErbmRVTC9lNW5DMHlWZkFSWXAySlZHUWdl?=
 =?utf-8?B?UCtnMTFRWXN3UWFuYU9mSkpKTmF1aWM3aHlZWTJFTy9kTDB5b2U4Z1Q3WHVU?=
 =?utf-8?B?ckE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 79854a79-7842-4068-8dbb-08dad16eb669
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 18:31:06.5355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zNbafnsyClhePdcTWy8c+dfnZehla/fDb3UpCunp899gcTh4OuAkXobVEiWiK1WZmpHsFgdG0B/RFTdlE/ut85dVFNONkNpJ0OzzTds3Ng4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5206
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/2022 1:53 PM, David Laight wrote:
> From: Jacob Keller
>> Sent: 23 November 2022 20:38
>>
>> The calculation for the data_size in the devlink_nl_read_snapshot_fill
>> function uses an if statement that is better expressed using the min_t
>> macro.
> 
> There ought to be a 'duck shoot' arranged for all uses of min_t().
> I was testing a patch (I might submit next week) that relaxes the
> checks in min() so that it doesn't error a lot of valid cases.
> In particular a positive integer constant can always be cast to (int)
> and the compare will DTRT.
> 
> I found things like min_t(u32, u32_length, u64_limit) where
> you really don't want to mask the limit down.
> There are also the min_t(u8, ...) and min_t(u16, ...).
> 

Wouldn't that example just want to be min_t(u64, ...)?

> 
> ...
>> +		data_size = min_t(u32, end_offset - curr_offset,
>> +				  DEVLINK_REGION_READ_CHUNK_SIZE);
> 
> Here I think both xxx_offset are u32 - so the CHUNK_SIZE
> constant probably needs a U suffix.

Right. My understanding was that min_t would cast everything to a u32 
when doing such comparison, and we know that 
DEVLINK_REGION_READ_CHUNK_SIZE is < U32_MAX so this is ok?

Or am I misunderstanding?

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8F96A573F
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 11:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjB1K4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 05:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjB1Kzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 05:55:55 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74F92BF16;
        Tue, 28 Feb 2023 02:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677581691; x=1709117691;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FiRgn+UYcxvjMQ6NWrMpahABtdxeM/LH+Bp44Rv8URU=;
  b=juoMIM6uHUzJo2xvAilAyJ2KZ3HNq4j53QjHW34tCrt9NYzv/rjqCi3d
   CM6J7a+2JRMjK07F4OywGyyjEGb/S3IZ+EV4GxVM5UKozi5DJsT9WlcwD
   fs5b5W5yW/ISsLrcmN3WLKb1FJDWWdLpw42RFmvb8Ghip8nrfPS9Ic1Ki
   Vf4re2kK0dDtiKRp8vBxj96QcPfpTTV+8FivD6TivoeFMFmWibE5hWyJb
   GUNCUC07zLHX523jgWddpwX+0Go7TjqFnpZ+Ij8EghEOs+PJasGlr6JTS
   FWebVc84O5b+P5+8F4MKOqntOJQXVwTBPP3SQ2PIwOgC54kfpN+bFsxtu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="331586577"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="331586577"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 02:54:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="848202088"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="848202088"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 28 Feb 2023 02:54:51 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 02:54:50 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 02:54:50 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 02:54:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dE0CXoc0gN84mq9fLaCNeuiw1/Zo84zNgWbFvnFQz+Synu1alCPjjMrJgLTeaThhS6Wr0CghwBpuSZZ0tCaQgwQ3jOjvdpx3xsDagGP7hR5q4DyWe3t0TcT063hjo4B6zdnxwU4RuOMkB+7oVx4G0RrWlZDI0hmx7pvjU5cgn04Ia2Q2KrzpJWeYxeH99DyZibqNJfoDHQY0nnCdrg89WNoe3KL5nuIoSs7avWDPaCQGd0Tsy6+jLZHR6kEaY2mfFBo0qynn6PXKjf1fpCjo4zwqvL8K2L8Gb9Oj49u+2ZE2UGcyuW85vHlQj8dynLKaLg69zvUkU0+YYiLZpwufZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CAEkc6OHYTWjYuo57dyv/Dqg/AkH+u1Vc9kvkrGEe40=;
 b=KmAgkxTwBPelPjfCWinxAWWtyNXvdA5dLWoEuzu57ldshupOfkGS8OIKtBkChcKC7bUCnsb1NTgSfQJaxzrhfzFpB2aemmDKjcU3sUq5xnNeBVcVnILBQyP8PNQztTbx5lB2LfORAJH6cfJY3QNZYLTMlMi4pBHFLaY8H9zUKQh2T+zAiu7TopjX9vMA+QAtLQgz6cfE5OKmAzKcpywpIvIUcqSB5k4vubFkeO3d0JJoBrSkhjLwfI+dNx4b1/V4cmOTQh+Cisg0ZBZrwh3Im5SulGjJhd2GXxcT841BEKNpWaY3IAff3ztfpU+DNNsgUP2QAccteQKX/FwTCXP4Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CO1PR11MB5203.namprd11.prod.outlook.com (2603:10b6:303:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 10:54:48 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 10:54:48 +0000
Message-ID: <411ad4f0-2551-d0e7-77b6-04e71d35f6e4@intel.com>
Date:   Tue, 28 Feb 2023 11:53:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 net-next 3/5] net: dsa: microchip: add eth mac grouping
 for ethtool statistics
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
 <20230217110211.433505-4-rakesh.sankaranarayanan@microchip.com>
 <84835bee-a074-eb46-f1e4-03e53cd7f9ec@intel.com>
 <20230217164227.mw2cyp22bsnvuh6t@skbuf>
 <47a67799-27d9-094e-11c3-a18efcf281e2@intel.com>
 <20230224215349.umzw46xvzccjdndd@skbuf>
 <ca1f4970-206d-64f2-d210-e4e54b59d301@intel.com> <Y/zDmZDPnwvBqAST@lunn.ch>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <Y/zDmZDPnwvBqAST@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::7) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CO1PR11MB5203:EE_
X-MS-Office365-Filtering-Correlation-Id: ca184325-0702-4254-9ce9-08db197a358f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9/yd7TFODRGzBKZuY3pyHxvJNJ398rgkAR6LHazFg9HP9T4i6uz9I2xfY1cEGWR73QGrjXXNBcf6EQpBxyV3u/s7u+aSQ94AeDpPDsrs/iJyLV+FrRBL4Xw3m2F9w9v9GjiZB2M6mP79bDaB8wC/M0tiuR1uCf5RhtLoOIf3ts5i7GUoAYm0Mf6JfzrYJasoKyMXQheI1AKbgLtL6VJTGqdeQD7Ml0ONKad7qfqI2FaH1Wtlx/H+7LLLp5kNPHj12bH4nZgMQfbWSFhcblaCsufuoXvrRQmwz28UAoDzqQD+sMII5hWXhLhZbhVsxCRABSuOJi7UP8MRXJQ1LiFL94mBShvs4Fv7FPdRvF816Zxj5zDYexDObDLgHVgCOwOJHGSoUpyqmh2C5iJ7FxZ417usRcC1BSGzzIVs4OXBh2YMyPond5WggE+6fVjka7ORy83Hfwf6DQ1OyfYQOjoFpqMqBGvpSVjS1MAVjVGN+V+JK92ExU18/bxxK6RenaWRxadncXA9ZMeWHaEF809vNl62CaMdOP0UBcHHtcFCdH8RTDyHDvfSSUMpppB6xSq/VntbyJkcT9vs2pjBBthjBHRbdOZEnNI+HEOn5PpfBCUA/+tavnt+ip39wiBSFl+0h2cp6RwdK0bSQospFOx/y/dX5it+y6YJsgHNrKD+xJL9v7/PL1hUEB+7DEfadDb8NQSNFtfaXOtBjKLt80c1A2PwCobKMt1ajqNBaOpAYTQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(376002)(136003)(396003)(451199018)(31686004)(86362001)(36756003)(41300700001)(66946007)(66556008)(66476007)(7416002)(5660300002)(8936002)(31696002)(8676002)(2906002)(6916009)(4326008)(82960400001)(38100700002)(6666004)(6486002)(478600001)(54906003)(316002)(83380400001)(26005)(2616005)(186003)(6506007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEtET3E1Z0xKdU1pRStvUU1qUzVLZlIyUVdpTGRVRFM2UWQyVjV3RWszTUIz?=
 =?utf-8?B?aHZVb3lUU0pvazIwVFI0dDgyd1EvU2JZd09yUk16QVRKRk03eEI5dk1UQUtt?=
 =?utf-8?B?M2xVdzJXd0tpc3QweW1LWGRuYjI2UXJYdWxCcDVMRWllL1NwYno4dTUzQklG?=
 =?utf-8?B?UVQ2cm12ZkhOTDFTK2dwUGd5Q0lCNkpyT0lKbFpKMzdVb0kxakt3aEV3bU1S?=
 =?utf-8?B?cW9RY3k4Y3BlakxXOVMyRzhQMnd6eldyYmdzSE0zeEtYMWpoVHB1dWo4Qmg0?=
 =?utf-8?B?eWZnWElKb1ZrRFh6aDFpL091dHFlSFArdWRhOEVQWXlxOGJZWGs0L3JmQnJK?=
 =?utf-8?B?MzJtemJnUUQycVpKTjhSQVZZQ0RnUzdQNFhXZmRJNUxnU0RLR0FDVU9WS1lp?=
 =?utf-8?B?REFybnFiUzZBYTN4TVd0TjZ1SGplY0dzUkp1Z3F5NnhHMjVXZHlvb0VuNXlO?=
 =?utf-8?B?bS9qR1JEQkh5NnlYY3hmTE4ydVFlZmRKUjZmQ1puWGRQamJrT2xIZUNXdG1T?=
 =?utf-8?B?OURZRFRpT3hjR09RWlI0bGFmdU8wQll2S0lrZzl0eTgzQitLdEY1UUZyNEQ3?=
 =?utf-8?B?NjBjM3FMQVB6dzJ0SlpucjhuVDhCRW40TXRYVFR6b0s3WFozdWxkcnhMdUJn?=
 =?utf-8?B?MG9lN1lWd0c4SzNQYmlBa2hCMUtaK29rZVlyK0NjR2Y3NFMwNzhGZzNrMlRz?=
 =?utf-8?B?VHE0TUQ5bGZiS2dZWkZxVHc2UGdPekJTb2FMcWdCbUVPYWxKb09KRTVCS3Jy?=
 =?utf-8?B?NHRZcHZqSG01aXBJRWhKeG9VK29XRXptNERIdzZGbXhuWVRyVEt6YXFsRmMz?=
 =?utf-8?B?dTM3K2E5ODZ0MkI1dmQ5MmRJZG0zTEJkamZMZUZzTjNqYlRjU1RXc1VxUTdx?=
 =?utf-8?B?TS9GNGFnSUpBaERyeHpuWU5ncDNwbG1vM3NhdU8ycm8rT254N1pROE1sdTIy?=
 =?utf-8?B?MmpXSmVveU1DZndMb3owb2NyRGhWRVgzVHlQZDRjOXZlQWplUTV3djM5Ym9C?=
 =?utf-8?B?WUo0eTRTdS9JOGpHRU5UK2E1VW42d2JuTGxPOVN3TnFDMWtGSHlYRDlBUlZ4?=
 =?utf-8?B?bEhqQXNXdDNTdHRIZWxqSUhEajBSUGtNSDgyZXQ5ejBYcGwzZGtRQWg3bzZB?=
 =?utf-8?B?TFEwdGxQcS9LL1V3ZStQdXFMOUpEMUFSdXhDN0prZ01WZ0twZXFrL1AySXVO?=
 =?utf-8?B?MjVMdjdlalZqcStLWUdkaW9mTU8zK3oybnVaV0RMdWQ4YlYyaWpwYWFac05j?=
 =?utf-8?B?VVJDcytkV3JWNFdmb3MzQTQzUTFGdmJqMVVRSWNwRWJMNE1tL0M5U084ekRt?=
 =?utf-8?B?OUJ2QlRWU290UW5iREZxUGZVb3JtQ3Y1RG5YbHF5ZmkySUk1MkZwSVhjUjRH?=
 =?utf-8?B?QjMrRWJVQ0lRdTl1SWxudnRjUDlSOVJObHVyOFNkS093MWJKVE9DNXY1bkd3?=
 =?utf-8?B?K2tUYWVRMGlvb1JDVU00SDZkYVk1aHJRWkFZT01scVVPcXhZZWZXZ016N0tS?=
 =?utf-8?B?a0RPYlJreUQ5ZG96ZHFmYzlHK0tMMmFqc1ltN3Y5cTkwSWhETUU3OFFCUWdQ?=
 =?utf-8?B?WU41VytpcytQa0VjTWdMUXBXYklLTWx0N1NzaGdidVc2QUg2eGpUWWxheHJC?=
 =?utf-8?B?WFgzME5NdEJMSjcrWERUSEVQQmZJb1d6aXJBUUhlSnNVcnN5N296UTdJTkdX?=
 =?utf-8?B?OGdudkdEWG1aQ0NaeGZ1QmZmZ3dFLzdXWUlZZ3Jlcm9XRGlOSWE1bGQ5RUoy?=
 =?utf-8?B?dWQ3SkNhQ29iZkc3b21DZjdwUGd2cWUvWmxRWnF1ZHNPQ0Zxbm45R3FBS1d0?=
 =?utf-8?B?V0FEWDJaeXJRRDRRUFE2WnhjWjJKTjJkV2NoZ01NVFV6dmsvOE1YNFpZZytm?=
 =?utf-8?B?aVRvL2luaXg0U0ZQamxoVkZ3NGZjYkFoclNlcG9UNnVWM1V1S0dFaElzSUZ2?=
 =?utf-8?B?TmFCS0RoRS9mS0ljM3lWMWJNZ1A0a25Ha1ZGZDAya3hjb25lZmtxTktFT0U3?=
 =?utf-8?B?NDMzbWZmM0N4c0Ixd0htZTRRb1k2anBoRm9wdXlDRDhBMGgyb3BwUnBqMUdG?=
 =?utf-8?B?TXRGeVUrQkVLb3JoZVdMb1c3R25seW1ZYmZaU2pVOFg2b1BxU01IdTFJRUlG?=
 =?utf-8?B?WEhOd3RzbHBOaFFsOWZISjFGOWRCa3gycmdMYmpnRDJ5UVdFK1RxWkJZMW13?=
 =?utf-8?Q?obOYzgQ+pdsL/LUEmH0YOOA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca184325-0702-4254-9ce9-08db197a358f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 10:54:48.1490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k9U2D2JrahiZitBPDOzuO/9Fg8aPfZtlS2Wav3gobuqMubtDSPH3zugY55LOiUm/IYzqxZEKdHIZepq8rjOc/LYLFaRCGWWWmYYLDH8n0TU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5203
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Mon, 27 Feb 2023 15:52:09 +0100

>>> Easiest way to see a disassembly (also has C code interleaved) would be
>>> this:
>>>
>>> make drivers/net/dsa/microchip/ksz_ethtool.lst
>>
>> Oh, nice! I didn't know Kbuild has capability of listing the assembly
>> code built-in. I was adding it manually to Makefiles when needed >_<
>> Thanks! :D
> 
> You can also do
> 
> make drivers/net/dsa/microchip/ksz_ethtool.o
> make drivers/net/dsa/microchip/ksz_ethtool.S
> 
> etc to get any of the intermediary files from the build process.
> 
> Also
> 
> make drivers/net/dsa/microchip/

I was aware of this and .o, but didn't know about .lst and .S, hehe.
Yeah, this helps a lot. Sometimes I do

make W=1 <folder/file to recheck>

so that if a driver builds cleanly before my changes, it should do so
after them as well. `make W=1` for the whole kernel is still noisy
currently.

> 
> will build everything in that subdirectory and below. That can be much
> faster, especially when you have an allmodconf configuration and it
> needs to check 1000s of modules before getting around to building the
> one module you just changed. FYI: the trailing / is important.
> 
>        Andrew

Thanks,
Olek

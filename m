Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3107A49CC6F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 15:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242190AbiAZOgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 09:36:12 -0500
Received: from mail-bn7nam10on2046.outbound.protection.outlook.com ([40.107.92.46]:54049
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235539AbiAZOgL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 09:36:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCA13Z8FYLgaLvHLDJc+gZ57BjIgTmPzenl7EJ9y+VKtaiDWtucYIjjwC37fNilLhw84V2s4oL5sO0R2CyrZu5FzLUE1LUbP/NVyUwBgIMgCHcv8qeGo3Zp+9ku5XGaxmz7QXKAiR9C9IZNXUeFCWLtFvkxZVnDPB1upIc0pSbj0ynKTfxqwWF7RLCYNFkSpSQWmjAIHKc8fXwYQlI5eAoxoFW8SAPRDj7eRZjqM881iSM1UX8SgrvaI77+aeqnGoBG2/ZCpDrOe/ZYDVuRP/jPmU4ZrzEFSq7cNZcjbaM9eDDV5jhcwfE29V1PRypfP576jh4DKyL6NQ/e4abv3kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rroqk15qS0UHYcunOAdvKXc2JT2slnormnLDOeBEdiQ=;
 b=iLMOkptiDAboPjxGPRcUl/dsm6zhToznCi6cAEC5HYNMCm+Vuk0QtlfZ9JOGfCG6WsOrr77YsKSBEXMgmFAezmrIoDNf33IE7rv4XJAEfurixeYJPI+z01Z9ZLAyEaWufT734vqfMkHxYygMCEmmHscoJw7PFMo6lnVWGgeJkwLkUq3MqpsJX83ixQz5vOntBpm0yOBd0IOed2/NBLb4jQPJ5hSQBlHuynPBvrCH0WWi4pYwSWzJNCgyofn7oV8Tjkno16Xw9MbD8U6jTmiMMTm1oj5PG3bpCVyYtnqTajsrw+ELWzGNLJucLYdhOfAJSoEOkJ3H174nR/Ht8/lcFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rroqk15qS0UHYcunOAdvKXc2JT2slnormnLDOeBEdiQ=;
 b=N56n94oUCoXb1jmKT0vEO9ILVnxStFhm5j/HHA4W4GF4CPr4/qUFcGt5O2lcnsDnP92RSGY0DRjIqePEOg2bolLLEhYTUVees7n3tFpCZuJzuLyRNFtkI9iLXgwFQEfeLn0ITTgaqLr5vwmWPNzAosRfAwJNx5XecFaEHqnU/B4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13)
 by BYAPR12MB4709.namprd12.prod.outlook.com (2603:10b6:a03:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Wed, 26 Jan
 2022 14:36:08 +0000
Received: from CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::dd4b:b67b:1688:b52]) by CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::dd4b:b67b:1688:b52%9]) with mapi id 15.20.4930.017; Wed, 26 Jan 2022
 14:36:07 +0000
Message-ID: <a0d2a954-45ea-9b51-678d-0e501d7e2bdd@amd.com>
Date:   Wed, 26 Jan 2022 09:35:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 07/11] drm/amd/display: Use str_yes_no()
Content-Language: en-US
To:     Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S. Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>, Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <20220126093951.1470898-1-lucas.demarchi@intel.com>
 <20220126093951.1470898-8-lucas.demarchi@intel.com>
From:   Harry Wentland <harry.wentland@amd.com>
In-Reply-To: <20220126093951.1470898-8-lucas.demarchi@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0117.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::35) To CO6PR12MB5427.namprd12.prod.outlook.com
 (2603:10b6:5:358::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e80176b-7ab1-40c9-68b7-08d9e0d93059
X-MS-TrafficTypeDiagnostic: BYAPR12MB4709:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB4709516AD1B219AA681FCEB88C209@BYAPR12MB4709.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:612;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iLrZlAlk/lf2aVe+T5P07EojtUQkZgn1kJQIoP6CohrDRyNwjjwAEdB0MwGBEVNTYqHzaG8s5EECXa3n4wuaH8hAinS+icN3stSPbjgZ0/e3qXe82A/iJJAnPl9EehSYlvQDW9phKLWISbEiNYg8DcKfYA+iuK2zx20ecGH+H8IBd4SgtvshLSHhOF72J/LefxyvB6bBFF3aKt+fLSU9bkpdtV9T83HCZiTDKqgyamPtlyUMT8ZwjIDluKWdUacTFUsyyKDSm2iXbWC6DRiz4ZpTz6u0rsujucSqOhSw40xkrY53rl1M66MxZa+b4iH/a+Sa3XsPVPXMyfYYg+MzZmqeZVQ/TAZ9sDjEi+UI/VOtnRNuavJlkEKECd6eul+MqhjItndSeD+DEyOK21LSIn4nfpQ05H1rDMcqPDMvP8puGUD/sE/6cS+udz7Q7bPXsKaMJrZ49wNZHy1jP400PB+29gsGnPYF5sDhDxcJx8F9Vxp08pmrPRdhBikexm+CVTi/k/iqHwD8w0kbp7ioBEOjFbON4didMcP+neyNt4a5yOvffcEQzF1E9OCPI9dZMJCGc4SfJFCRe/SRHZik1yGdVph54q2ACT7uk4QBPXwz8bJKHob16mFq8+o/T3J5JoILtvZP7iUMm94j3cOSeir6aYFrOM2DTP0eUEjavQRIlYiVcg/XCHM7nGoUDPNjyQuYkIE8vMgUMXe9ni0DsoQLEwlOs6qxxtCRjzHQbUU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5427.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7406005)(38100700002)(186003)(26005)(6666004)(8936002)(316002)(6506007)(54906003)(53546011)(86362001)(2906002)(31696002)(8676002)(44832011)(66476007)(508600001)(66556008)(83380400001)(4326008)(7416002)(5660300002)(36756003)(6486002)(66946007)(2616005)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWRNUTBwNFdOTU4xRk00cXROSHp4aThiekZYWEZpaUxuR0QxekxzczNpbWVL?=
 =?utf-8?B?Z1Jrd29aUC93Y1hwenpReDkvQXV2NnI5cDJPTEpsT1BDS3dOanluUTA0ODZt?=
 =?utf-8?B?S1hBYkdRVW9NRDRLek5WVjhUTXpDZ1IvZTJ6Mzk4YUdmdWFzM09YTWZlT0hK?=
 =?utf-8?B?bDZsc1QxL1VBc3BKZ0p5ZzAwcysxdXpmclRxSXoweDB4ZmtCRUdScy91em8v?=
 =?utf-8?B?Y2luNnFSREt4M0VmRHpBUjRHekZIWUpsWEgrT3dnY00rTENXNDJBMDl3UmZ5?=
 =?utf-8?B?dElxK3dkd1d4R0xSSlp4ZldxckxMSUVEUE1BQnBDUkltUkIrRTc0ejdBUDNW?=
 =?utf-8?B?dFhXQVRSM29yWDk5Qm1HVXI5UUtuWFIyNk0reDlPd2pZN20zTnI1N1BNOFlG?=
 =?utf-8?B?Qm9qTzlqTy82dVJwQ1FGaVBrekw1MzY4VFdJY2c0bGVVUzhpK3JZTDl6M3Y4?=
 =?utf-8?B?U2dkQS83ZmphMW5vVnVJeFA3RTRtR0xuZ2RtVWdTL25hN2FrUDNFbUVCVllq?=
 =?utf-8?B?akhtdjhrYU41S3dPeVF4ckJkRXY0bHYwdlgxTnh5cXNnTmxTZ0szTEhZdWNh?=
 =?utf-8?B?ckF0OG0vNkxETWk4QnpTRy9uZElNYUhjOEI5dzNhVXpmTWVGUFhqNHc4bkVh?=
 =?utf-8?B?bXdJVU5SRVowN3RxTVpNYTJMZ0syRkE4ZDQyZk5SWG1seUpiSEFKQ0tnS0RB?=
 =?utf-8?B?azB4RzRMUktkT2kxMm05NC80SWhyRFdJWU5qaE5RTHpEcHVwK3U5ejFoQXR1?=
 =?utf-8?B?c3NqL1ZkZW5IZFlteUQvZEN0T1pwOURQNVVTdkp6bU95OVJXMFRWU3lrNG45?=
 =?utf-8?B?WUV2SkZyQW1mUzRNVCtWTDV0d1Jsd05YajJ2QWdvZEcxek1QTElzRTl6SkNK?=
 =?utf-8?B?d0ZDL2VIdmtSMjhxYjZUSXJzTXhHRUhmRDNTVGJrcE9URE15QTlibXBwL1VM?=
 =?utf-8?B?WVF2eGh0Z1BTL1dLTmVwTDhEai9jTVdPSE80VDhJZHJaa3ZDSFpKUGZSQi9B?=
 =?utf-8?B?Uko3SVFHa2JyKzBoR3ZoNkN3dU5DazlMdFFldTZ6TERaZ0xxdlc1SkFJVkNr?=
 =?utf-8?B?V0w0L2crRS9pV0JlNlZVVUhxWkFRdDZOaWEwZUVPd3BGcUg4T1ZLMmp2Z0tm?=
 =?utf-8?B?QWhWMG1aYnNsOFR5bE9Zd2tMM05Xcmo0M2FSdG1TeHZ4Mmt6MmlyOHhOdzRJ?=
 =?utf-8?B?WThScUpVTDhCdnh2UG1ub2dvR1Q2Mi9xVyt0L2lLQUwwVlVoNjA1Wnl2N0pH?=
 =?utf-8?B?Nk5QZXFxVTBqOVdkc1BiZER0ckNaQTkrOEg4bC9LT3NQRnVDSSt3aVBvVWpQ?=
 =?utf-8?B?RjVQaGdnVVBhS3FyTERUZDl4cEQrdzNvSTlLWmpIMDJXbnFBSlNDS0k3Mks4?=
 =?utf-8?B?V2pDWmlITGFtbTZ4TFppdUZHTFBFZ3U5dklsSlpNc0xUUTgxYUZGU3JScVVH?=
 =?utf-8?B?SlpIbDQ1MG44SjlzYTYxZEpHR1Y1VmVKNUZoaXFqbkxmQTdoL1g0bEVTUkNr?=
 =?utf-8?B?Uzk2RDZraXVyV0VJNXppbnQ1ZVVTRjVDSmx0aEw3Wjhib1ErdFcwN3hRMzRJ?=
 =?utf-8?B?RWEyUzFPZmNpZm90Z084eDlaeDJBcmswTUtZUTlmVDEvcTA1WDdvYWc4RlRo?=
 =?utf-8?B?TkhxZjJzUVUzVTR6d2dJTjVuQWtEOXI1WHFiSTNyOFgzeGNzWWdxMnhWcFlu?=
 =?utf-8?B?UDlST1VDbnVDOUh2QVVVaU5JMENBSjl6S0I3b0p5TEtHY2MweVFKS0l5RStZ?=
 =?utf-8?B?Z01IZnAzYkN2WVJ6bG1Qa1FoUnRkWDlYRk4zMzlPMG55R29DQUl2VEVyMEFt?=
 =?utf-8?B?RlIyWC9KOG83Z1ljN3lIVm5RZUpaUFIxZXJVUGhqWXM2YmE2a1RTUGZ3Rnc5?=
 =?utf-8?B?Vzlmd1ZXaHc2TmphSmVFdWtUblE0NUpwUkxCZ1pzK2Qvell3KzBBOVVqQWNz?=
 =?utf-8?B?K0x6aUtHME8wbE44Q0UyM2RVcFVaaFIwMHFEanlXV1hab2RiNVp6alBsenNI?=
 =?utf-8?B?bEt1bTQxb3hxTVFRb0k1NG9BNkZ6S2J4dzgrYk9XQjg1ZDZMSWtBeUQyeWFw?=
 =?utf-8?B?b29HOU9Nd3BTUEVwZmxwQTlNamZteWtYTE80QXNveXJEQXJOWGFVcUtGWXAy?=
 =?utf-8?B?TEM4V0piVUtES0pYOEkxWlVMeW1TVHR5KzJPOHIvWm5PejFJaDNXUzJHWXBh?=
 =?utf-8?Q?dEtvXorhJXR7hgKLBT6avCY=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e80176b-7ab1-40c9-68b7-08d9e0d93059
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5427.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 14:36:07.6607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AL2DQBVlQw8soauM8w3I6BFgcgUz+ev1Obsu+XhIu9qzd7pIzmTj+EgbNhovxSg4nNUf/Ye/GJgr5QVaES3Xrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-26 04:39, Lucas De Marchi wrote:
> Remove the local yesno() implementation and adopt the str_yes_no() from
> linux/string_helpers.h.
> 
> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>

Reviewed-by: Harry Wentland <harry.wentland@amd.com>

Harry

> ---
>  .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
> index 26719efa5396..5ff1076b9130 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
> @@ -23,6 +23,7 @@
>   *
>   */
>  
> +#include <linux/string_helpers.h>
>  #include <linux/uaccess.h>
>  
>  #include "dc.h"
> @@ -49,11 +50,6 @@ struct dmub_debugfs_trace_entry {
>  	uint32_t param1;
>  };
>  
> -static inline const char *yesno(bool v)
> -{
> -	return v ? "yes" : "no";
> -}
> -
>  /* parse_write_buffer_into_params - Helper function to parse debugfs write buffer into an array
>   *
>   * Function takes in attributes passed to debugfs write entry
> @@ -853,12 +849,12 @@ static int psr_capability_show(struct seq_file *m, void *data)
>  	if (!(link->connector_signal & SIGNAL_TYPE_EDP))
>  		return -ENODEV;
>  
> -	seq_printf(m, "Sink support: %s", yesno(link->dpcd_caps.psr_caps.psr_version != 0));
> +	seq_printf(m, "Sink support: %s", str_yes_no(link->dpcd_caps.psr_caps.psr_version != 0));
>  	if (link->dpcd_caps.psr_caps.psr_version)
>  		seq_printf(m, " [0x%02x]", link->dpcd_caps.psr_caps.psr_version);
>  	seq_puts(m, "\n");
>  
> -	seq_printf(m, "Driver support: %s", yesno(link->psr_settings.psr_feature_enabled));
> +	seq_printf(m, "Driver support: %s", str_yes_no(link->psr_settings.psr_feature_enabled));
>  	if (link->psr_settings.psr_version)
>  		seq_printf(m, " [0x%02x]", link->psr_settings.psr_version);
>  	seq_puts(m, "\n");
> @@ -1207,8 +1203,8 @@ static int dp_dsc_fec_support_show(struct seq_file *m, void *data)
>  	drm_modeset_drop_locks(&ctx);
>  	drm_modeset_acquire_fini(&ctx);
>  
> -	seq_printf(m, "FEC_Sink_Support: %s\n", yesno(is_fec_supported));
> -	seq_printf(m, "DSC_Sink_Support: %s\n", yesno(is_dsc_supported));
> +	seq_printf(m, "FEC_Sink_Support: %s\n", str_yes_no(is_fec_supported));
> +	seq_printf(m, "DSC_Sink_Support: %s\n", str_yes_no(is_dsc_supported));
>  
>  	return ret;
>  }


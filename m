Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEF8628F7A
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 02:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiKOBqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 20:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiKOBqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 20:46:22 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B120917421
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 17:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668476781; x=1700012781;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2FxosL7eOpeFs1R2VtLH38sYAzJUrEEQBtdK16CEnGY=;
  b=CyG7kFIkcA1Y+XoLIJpde+fesQJ4MAjsEK69fnsZ4ZvAGQBW14zx4VLm
   D/F+RJMN+wKt5wo5EoT18Wz1So63wbkZhWRQ8hu7I+3WER1BUggGzdr3P
   uwrISffN5Y9Hl3Q5T35CAZEzJCm3jdaicKPN5EvH/t94d218PmXUbFQ3v
   TIRlLp6NKwf+d4H+SHfW4t3/RtULKpdAbDBm9/GwvFs7kNsZSwlLS+HgG
   hQBgVdCovbY7G8mOr8VPEBRu3DH7x0hUrzU6pnOXFPcwY39HkqwEv9KFP
   lqmgBJqfACj6nZlCdB0Xf7hO4jr9MV3CSUG0zjMAfJTNPZzGG9q1lYUJ6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="374264065"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="374264065"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 17:46:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="727762111"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="727762111"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Nov 2022 17:46:21 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 17:46:20 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 14 Nov 2022 17:46:20 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 14 Nov 2022 17:46:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3ob/CqbmBVaB0yTIAAwXzzSWE7p4pAqV/7rQbxo6UzXgAcF/fJFfXs/GdKkp/xg7539+Qz0I2CO9GDxJfZWVKTJY531mRDY5IUrS9oLL7BHN3WkNF+RE7kS8/LNelaMg8CqCfmOsdvxC75OROY7TGvK2+Ek0zTXEClw5aDzeAY7RlRAMkmxx3tDWa+MQX08hen4h7qgmXlgn7L1tah96kRSm7iCJveqybLDstK1oQ5BWA/cqUZyFjIqUytZDSHrX6BEFDVm9Dgx4jlo4rbNVM4OOljd2A/blwT+mhM+M0OcscSy8OGKflGTf9vPsMBOsUYpJ8HMS02GS0u/q0XTzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+sNYRRsgp4cKkY0LpvdpxIPejxxuk18CEdEFRcsEWf8=;
 b=FBZ0zT+T1fI3C1YlL6eUaSaO08eVpnVo5FmF8nwFlmIgvZ90hNa7gAaJFP6IOkdyi7NGKYtfEt32woSdabHlvRLjviURY8IFq/uGFcTYE/S1avJzK7QnqkzxUVnDYgQ2F6fRXuqQbGpeYbHv6PxATNXwRRVR1Rqq4JTGbLoNe+U87cb/fG3Jns+AoxlKBIHkOz3/bVbUPRFkcz3pqyXzjqem2hZDMqyucXFZz1ts/jEhweJhiD3vrE6U2vrcis3lOc0oX/Ikk+oUPGaePOBOntu5+M/IyGQxahyOjb1m7A8d4kR5x4YuSKZXJxk6T98hBOWKr4+tUUyhvXhkQiWQCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by CH0PR11MB5346.namprd11.prod.outlook.com (2603:10b6:610:b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 01:46:18 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::f09b:dc76:ce14:2d2e]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::f09b:dc76:ce14:2d2e%9]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 01:46:18 +0000
Message-ID: <9af9586f-b579-95f7-3626-f378da792261@intel.com>
Date:   Mon, 14 Nov 2022 19:46:13 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2] ethtool: add netlink based get rxfh support
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
References: <20221104234244.242527-1-sudheer.mogilappagari@intel.com>
 <20221107182549.278e0d7a@kernel.org>
 <IA1PR11MB626686775A30F79E8AE85905E4019@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20221109164603.1fd508ca@kernel.org>
 <eba940d8-a2da-9a7e-2802-fbac680b7df6@intel.com>
 <20221110143413.58f107c2@kernel.org>
 <0402fc4f-21c9-eded-bed7-fd82a069ca70@intel.com>
 <20221110161257.35d37983@kernel.org>
 <c40e7ed0-1118-168b-7fdc-a833b461b918@intel.com>
 <20221114091559.7e24c7de@kernel.org>
Content-Language: en-US
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20221114091559.7e24c7de@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::39) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|CH0PR11MB5346:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ae6ea3a-bac1-4169-1f29-08dac6ab3007
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kWWwmZkkaSgV0/TgIwM8/BrC+38V3P4UODh6tFTb4dqsW8fxQx0HZ4wrKqsC7ywsvC8FeJMzhWB187+GNS0bnzj4cp7kqvypw7MkJVtsBjSg3+HumQ9wB8oXIJnKhfmCITRGhtbrvcyWH7vA4zD+UVYAAYHJVjV7R3BCgNKk2MgOfscQTIkBt7Gv5ALsP2naipfwt1spgeJc2nKJi5SMr3tf7a6qAp1yuPFVlg7ZfePnkBhkzHl7+KCYU78bo1778cNmvBKn5R34cG70IHejatM4a7FUBZ3DK3KFvoAqJ5Gu4L3a3icQ214PEXQGruLx15dqJ+Ek9JErbbY9qgjpiQht5pgp2RNZTWRNYqIN8oUjE9Y3C+K9g1hupQ8x59y/syCgt9dqeRWhaPmDdnaDW+gR35M7/ELpbgjXw6XpBBm0cauYP7V9LxZoX9d8zGihcO8SWYWqIdl2bTDQmc3Miiaoe2A0D6XlpkG1SbGqBkgcBekbD/wIBAqDIrrWsaol8tN77hROl5eP9+ewxtb+CEqfhw9mlEeBPO/SB7NmishXxKm8XXpiYx6eaRjJg+nHl9P/izoRIrdXJo7eWHNTPWwKEg/cKt/1iNRtLndgeEmmnt7h9vglz3M4MEOYTS3JuXAsqEl+mMhRUgPEONKl27nKIOhT7GJhSiiIil6sVytjtY7lmPBrEQh2hd/Qb/dYThjH5PmcbBxmFBJVHP4cLJqMB+iq+fYrabik0RnBRvBQdKh/M/8CUW9iRansd+3t+IPIeuti54Ffc6luacsFMllm4104iB6t0yWx89k9i1c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(376002)(39860400002)(136003)(451199015)(6486002)(31686004)(53546011)(478600001)(107886003)(6666004)(6506007)(6916009)(54906003)(66946007)(8936002)(36756003)(4326008)(66556008)(26005)(66476007)(8676002)(2616005)(316002)(41300700001)(5660300002)(6512007)(186003)(2906002)(82960400001)(31696002)(38100700002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVk1U2s4dEgxQWl3OWhjN0k0RGRJWnRHSEpkek1OVEpqRnRlVGR1QVZzQmZI?=
 =?utf-8?B?eEFhUDJuRWNYUVJ3ZWRpRGFVdE1ld0hnMU9VY3JXdnRYVEUzaEYrbVBRZEVp?=
 =?utf-8?B?cyt0bkpmcUg5c09xZTJOL1lXdVoyMjB0akVrQllIZUpWR0kvNkJXUmlvYXls?=
 =?utf-8?B?TGxiOVcrVFdha0M0bjhhQW1XangvVXcxNHpraEthNDdsTS9ZRG1qWFNHZ01Z?=
 =?utf-8?B?MTZPOVRaMTRmd1pHZE8wU0ZSbUpVSERESTJaN0l1cWZYeUcveklsYkREU3BO?=
 =?utf-8?B?NEZYK2FDekFZVDhtSTErZUVkMmRSUnlteFA0bmNWUXZHaWtzeXNkYUcxZERZ?=
 =?utf-8?B?U1JFc2RmTTMwL1RZYStPbnFuVFRaMjRPU3BUcjFNMkFlYnFtUG1tOUJJa2h6?=
 =?utf-8?B?UzcvcEh2Z25jYnlCbFNTWDhuT2IrOUc2ZVJPdkk3K1FlWnBaZXJhamNvTWk2?=
 =?utf-8?B?bjk1cU5CS2ZBRzM5eE5NYlI1VGlVdzBrM1dxRkU2N2lka2xZS1Z3akhBemhr?=
 =?utf-8?B?MmlnSXFidWhoSnhGSU1lZnIyMHlDRnVBN25vR1lUWURHby96c1FkRVpYYnRj?=
 =?utf-8?B?Y2xuWFh5dE9CVkxQSW1jY3h5aW12Y0daUWpXcmZBdTJ1cmxjc1RQbmQ5WG5u?=
 =?utf-8?B?YVdNcHBPd3FrUzRVU3c4OC9BK1JRWmdHRjk5c3lZYXg3Vm5udWtJVnJSNGNp?=
 =?utf-8?B?cXBpbTkydjNBNWVnMTdaNHNPUUx0MUMwSFZ0Y2RFcURRUEFKUE05ejFSMytY?=
 =?utf-8?B?SlMzeTRKUVJ2V2pHdEJqVVFaNFRZL0docEpVTzlZZ2kvSTcvMHRFQTJuQkZi?=
 =?utf-8?B?elErZ2FnZ3dMN1Z4M1p2M05RN3ljRm85bUQ4N29PSVdsYnFVNlZQQ2pMb2E3?=
 =?utf-8?B?cTZ0SGo1WDZNTkt6Z2FMZk4zYVRHSW1LM0dPWHhlS3RuTmJYaTE1cENleDRB?=
 =?utf-8?B?Sk9NcHI0Y2lDWTcrVnAzUjBqKzJ1VVdYOFIxL1hjQW1XRERIa3dhZzBUeFZV?=
 =?utf-8?B?Nkw3UWZsZE9uZlJzbTM4M3d0dCtmUHBxU1VaRWRQQk1NT0lEZ0lYM09ra3E0?=
 =?utf-8?B?czV5MXExUk1sVE9zUTRicUFRTTJVU0F5OGx4UEwyQkZxZzczU095TEx1aW9M?=
 =?utf-8?B?V1lxampnTEU4dzVna3BmTC9wYTNXT1RTNVg4T0Z6amNwbndoekJPMG5QanA0?=
 =?utf-8?B?UE0vaEkzQmlwNFIxSXZqWHMzZXcyaklNTHdDeU9qWVpKQ3l4cEQwc2dZNXJ5?=
 =?utf-8?B?cVJzNGFmbUFrSHE1Qjc2MVBkQWlLc0Z1SnoyNTNubUYyNW50STdPTWROMW5S?=
 =?utf-8?B?Nitxa2ZwWVZzQ1Fzenc0TkhCblpxbVhsOFJzK2QzTmxzVlJndlRnTHNNREIy?=
 =?utf-8?B?NVgvL25jVmZRZjFkTW0raFdsZ3VkOEYzRDUvTWp6dlpvb2lUVFFnNGZocGpL?=
 =?utf-8?B?QkhYZXNVVHVuMXhBU1JVY3VXQlp6ZjZXaDJVQUFlWVFlK3Z5MGpveXhrNHZk?=
 =?utf-8?B?bkRwSCs0V255cWJwYStOOWp6eTNzY1NGL0ZrU2s2LzNFS2Z6ZWxsYWVFRmtJ?=
 =?utf-8?B?L0lIK2tDblNsTXVTcCsrcW42UmpqTUY3SFVDVW1tc3FrVnFYWThOcTBvaU5l?=
 =?utf-8?B?YUtyWW9xdWFsZXpwL01hdkVFNUx3ZlRENk1mUkdweWlvY0hpMkw3ZmR0Tklr?=
 =?utf-8?B?aDNmVTNTdzhtSkdBVHBlWEN2NWdqNHBjeCt4cUVZdm1wMElsL0xZS1N3NW0z?=
 =?utf-8?B?dUNieUFXdzNsNWpIcFVvU21OU2hsc1plc0pYQjc4cW92ci9EZFNRL1ZpQi9u?=
 =?utf-8?B?V0JicFozaEx2a3Z3VFRJRkxQWU1kY1M0eFhIQlYyQlJkSHh0VTE0Q203dyt6?=
 =?utf-8?B?OCtMdGlXZWVzeVlET0tMc3RibHJ5UTZ6TnpVY3VuWnNnUHR3eUptRjAwcklH?=
 =?utf-8?B?TG5UZVpVcDZFTzNTY3I4YXJuellZOWJQV1pCZUI0d3lDY1g1MWYxdW9Jbkx1?=
 =?utf-8?B?dHdHNVZxYW5zdkdDWHdtL3lpVHA0RGFIbHhtakhYc2ZIZThKdXpUc29FdGJn?=
 =?utf-8?B?ZDVHYkJkUEY2TXgwVkdWVTZLemdlMHJOb21XWGlXWktaZVpKSElzSHVVcUFJ?=
 =?utf-8?B?VnhlR1JvVmhFZU5KRkFwbW0xSk1lcXVwVTN2VE14RWdYc3JWRmx0dVczVHJz?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae6ea3a-bac1-4169-1f29-08dac6ab3007
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 01:46:18.6494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kltdUNFD3l0HTSV4kaqBAvl1AIfJ8WenozbUOZ6JwYa5OogAxV/yGc1uD3njz3dcjWMbmiT+BXAAXq19rd+d8Fj+Z3xD3JKRYMOpvCHaidI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5346
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/2022 11:15 AM, Jakub Kicinski wrote:
> On Sun, 13 Nov 2022 22:23:25 -0600 Samudrala, Sridhar wrote:
>>> My worry is that if we go with a more broad name like
>>> "queue group" someone may be mislead to adding controls
>>> unrelated to flow <> queue assignment here.
>> Later we would like to add a per queue-group parameter that would allow
>> reducing/changing the number of napi pollers for a queue group from the default
>> value equal to the number of queues in the queue group. Are you suggesting
>> creating a queue-group object and use devlink API to configure such parameters
>> for a queue-group?
> I was thinking devlink because of scheduler/QoS and resource control.
> For NAPI config not so sure, but either way RSS will not be a place
> for NAPI/IRQ config.

Another option we could go with is via sysfs by exposing
   /sys/class/net/<iface>/queue_groups/qg<0-n>/num_pollers

With this option, it may be possible to also consider making per-netdev
napi parameters like threaded and napi_defer_hard_irqs etc to be
per-queue-group parameters.




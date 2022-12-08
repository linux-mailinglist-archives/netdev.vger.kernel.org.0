Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C826465DF
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 01:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiLHAaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 19:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLHAaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 19:30:17 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB0B291
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 16:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670459416; x=1701995416;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H39SCjSpamt1N9iZwdnbevAECSot1m0ndjqChCTgZ3I=;
  b=DN97y4l0gHy8NeFEU8BL7uJX2D/DzvFoJc/WFoK4q3pZU+pQjRRYkfDn
   FzSH1om2GhaF9Y+I2jl8tt6E/XL2DD9fppGRt+E/IVMWTEj3DjEAWK86N
   VSfo79erBbxD4dyVvCSEoV3Ky/okC/xEdh1V/m5JcOv8y40HW/O/11Sft
   It5GrFBc3wBaJVZhZsu3T72/yf6fANbwKLDm/95TuD++I1vjJgeWYZeK6
   GIaDnmJlnQi5+KsDCcPTT/xmS0E6tbirut745RKYkDq0mVoXbSiczfdm/
   XhrScEnhybYy3HuzypPmi+o+HtO+Pg5QtXIGbqLEQlZ3qjpjDkr/sXBKx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="381328478"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="381328478"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 16:30:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="735592293"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="735592293"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Dec 2022 16:29:59 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 16:29:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 16:29:59 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 16:29:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bz//FJJY6Ywr+TMZxgp06ZD8g9GNQwbdGGr8+GOYSzGKSyGCk7cN3AeaJhiuZX9ubBsW4JUx2kN+EGeWk3CO7xoUy+ycT7opldZrU0rWTe9r5sIRYgAsMEmd9E3eUcVGPeNlyjmMGh9x7Se4DhEA8Ij0IYC+hJUoOaE9c7o+TZ8HD2mAVm8PVG/H8NrUgoUlf8gRAV3rgvEAfIms60/Q2Fz/9zoZGHwpO07JYHW9vl0EZYEPVdRIvswv7OzQiRu5FIestsudtoJFOTmF+VEh1a2/0tmzOV07Rpu3oHg1i6MFokquNOb4x0Qi6zX6EYKas7j7NfRGxZvgXCkjwB32wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=la9RfmTefWT1JGps5aQ4dKz8qfgRmg8tdq2EAj15/3E=;
 b=RXCobcNWbq/MxItmj7EOqjPsRGayNH1IvsMvECALB3rM+84bvub5ZVBkNbFumllJ/aqOLXWf+7vrgL2LfAhRIX4Zbp44RVVyTkAEuPEAiuhxyaQY4RaZVifOR3yj6SjK6scRlwdyE3r2Vwgm5SVLNaMzoLX/bnlRwlhmsWbk8kD8zYi+a34dzFAbUfNeAhScbdZiklqq/eC/zgfUjJA1U1T5wgLu68pBr49T+hFhfspZ6bVEaUV9q3Bqkn+uOHvdjcRPdvu1/XcV8s8YNcJ5AXR8ZrCG7GBSdTSHhCSE3X1QO42KAIGBxcby/AJCPBL0pM9MyngaaqchERwmi0e6Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by LV2PR11MB6048.namprd11.prod.outlook.com (2603:10b6:408:178::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 00:29:57 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%4]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 00:29:56 +0000
Message-ID: <73b634db-13fe-dd02-614a-7d1453c3834d@intel.com>
Date:   Wed, 7 Dec 2022 16:29:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next v2 09/15] ice: protect init and calibrating check
 in ice_ptp_request_ts
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <richardcochran@gmail.com>, <leon@kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
References: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
 <20221207210937.1099650-10-anthony.l.nguyen@intel.com>
 <Y5Ejgb2P2f/PX0ym@x130>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y5Ejgb2P2f/PX0ym@x130>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::23) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|LV2PR11MB6048:EE_
X-MS-Office365-Filtering-Correlation-Id: d911d0a3-5e6f-4d17-13a3-08dad8b3552e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GP7e9yUu+JHzEjoSv+Y5SDSe+eKaeT3hxc/3n/Jtn7R+31mTnX2H97B9ZDL1ZVEqV7jbiwA4ucVIUQukwjwOHpAYCT9mQdGx6S4lyNyy7tZg3GkruPDSBZDPTXLs+aCQe1y5ikSD6h/62Y3O8KgVlqUf9B0dobAke+EnegFFQ3BpotYWiWn6evmTyFCvkIew8omcBRAElknFDfsiXLSNkW+Nx/DvhmHYrUdcAluT2n2h+6nrNOxwWaGUrRtxEY/d7iTqRuj7X4bCHR2vF8m6QDb54bJqZ+Mmfe7tfhBOG84t6fFYiKyTgOI/VfSrpoCsKSXPfu1I89kzAqBZ8ln2imbW/9s3+TedUowoetmydnNSs2Ut4rVyhbfwsSH10iXk1DkMtfr6IpGNTLmfdxaO8yiOM4uVk9fFGcW3TWLdIvFYUgr5pYFcE2bEsxun0Uke0lx2lEkT+UtJK4GoelXCM6a9h/CzjWGPKy2I1ip8HaRCBUsl15+wRKo085Hrx7+cnPp9efs6gkT14yrkk8KbLq6gwUoMQx0K47DsNcLj9WhQoymF2sVOmh/3gWOVU/k6UeC86eEAhU9sl1HqWZiyMk1hYzn5Jqv23L5pr6L4tCSsfuP+7PPemBcdTx2ngMi7LsVvaSCVzA7udSFNAQMEFYuemHLuu7O44DjXiKmQ+Wm0m1hEPzVLRjZYqyP1GnT781YD1h7FnsF3JCjFjmxquYw9/EA7+nwbClJHcYfn+fk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199015)(86362001)(31696002)(41300700001)(83380400001)(478600001)(26005)(6512007)(53546011)(2906002)(107886003)(186003)(6506007)(8936002)(2616005)(5660300002)(6486002)(36756003)(82960400001)(31686004)(66556008)(110136005)(6636002)(8676002)(66946007)(316002)(4326008)(38100700002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEtkZ1dBdEpBdlVoS3IyaXQ4d0N2SVU4UFljYUFhenQxeURBdHp5Q01VNFFC?=
 =?utf-8?B?d0RycFRBZzZKQW1Lei9nVko3Y3RQMGJLL3NCdWQyeTZQVUxJVlI0TTFkQUlr?=
 =?utf-8?B?TXdPbjlPN2VzMFBaMmNGMWZrdER5eVovVUhpbTRiVVcrQU9TcUErWGlXaDBR?=
 =?utf-8?B?cUZWVFB5Q2grQ1dSVktwSXB3cHNIYVpxc0JLZGhEWUx2SVBUMjc5bjNPL2Mr?=
 =?utf-8?B?bXRjdWRoWCtKZFE3TC8vY1ZMNFFNS3hVRFIzZ2w4ZkhqeU9MZDRRMEdTdDQ2?=
 =?utf-8?B?YjBVYmQ5RmFLZkUrTlNJcHlmdzFBcFNmamFMUVQ1M0RReHlPQ2EyMmZ6dUh2?=
 =?utf-8?B?ajJTVHVUbklUdUoxVTcyY3lUNDhXdzdwNDdVaW1XVUhwdFU3TjU5T2h6d0c0?=
 =?utf-8?B?TEpHc3NhUkVLaFhVK3ZoMm81ajJ5MWdGKzdadW9GVGViOFlncVl5VVhoZjdq?=
 =?utf-8?B?bWlFZGowZDBIdzYwV1Y4NnR1cXVoT0E4UjhhQjROQWNGSXJGUGJZeVF0Zmph?=
 =?utf-8?B?azM5MWxTY0JESGZoWndSUVd2U1hyYmVYSDFvUXU5dDRlcFdXb3Z1cTdPRkcr?=
 =?utf-8?B?dy9IeWF0UFpVUkluSkZRa1h1Wk5sU01CanprUGIyQkJWU2MxY2lYUGJseGt5?=
 =?utf-8?B?VThZT0ZyT2t0dDlUWXBNRnMzUEgvdjM2MGg1QjdkUURkSUhYalNGWHljdTg4?=
 =?utf-8?B?cDhpbGJ3N2pEd2hkSTFrU1ZBS3FZVlQ1b3VVaDFGcHgwbEgxNFBRWHdXVEZk?=
 =?utf-8?B?cmU2M09tdmExb0JqaktZUk5zckQ1UC9TdXNmV2dHN05qcUVUZHJBeWw5NzV1?=
 =?utf-8?B?WGdkeWIrR0lmMUJpbHlEczZVNElJeTJkREN6T1U5V2NqQzM1dDk0SVcwZXlB?=
 =?utf-8?B?ZXBhcFA5RndReXppR09nM3U1cmhkaTJqVHpxTTVWMGlFS1MxV2M3WklZREt0?=
 =?utf-8?B?VmQrUGZaRVdWWHM5NU9wRDB0TVQxNndndUp6TWxyckZQZzhUY2xjclcvVHVw?=
 =?utf-8?B?SUtmcUIzVHh6dWZLQmlkdjZmNC9OVDI3R2Z4ZDBLTzd2cDMyRkJscGhWYVBw?=
 =?utf-8?B?UkV4RDZVYnRpNEMvRm4yRlFzNExHb29HTFVSZS9kdHpyVVhLVXpSdTBnWXpx?=
 =?utf-8?B?bTVWNUl2UVVZazN3V3FJZjk3NzlvNERvSnFZbVZNbE1abjYvWGF5SzgzY0p4?=
 =?utf-8?B?QStsVGlhc0ZpTnVGdTZFMUFvZmNCdkNZR09FWFVwUkx1MERXc2NHN1c3cmYv?=
 =?utf-8?B?UzRaRitYSWtteHk4WTZzZUwyMGVSem5VOUxsaWFaZHEvdmd6UExNVFVrTEox?=
 =?utf-8?B?bGNBQ1hrdHUvSnYwOERVMmhxdnd2YkczWVlHY2xzR2dKeWJtR002TVZKM002?=
 =?utf-8?B?NWQyS3h6aEt5ZnVhYUxabXNFZXVVenVLaWY5RHowMlF2OW9UTk5iNC9abVdF?=
 =?utf-8?B?SjB6L3RxM2hqYVp4dkxKYWpVZloxOTVIaHFidldrVUZYSmpPTWVFZWh4ekw1?=
 =?utf-8?B?b2NtUDVsWWFlQ0FMNWtpYkZZZTlWaWhyNzVpaExmbnNjdk9qSENvcDA5Y0hK?=
 =?utf-8?B?VlZOdi95SmtLRDVlamsxditWc2J3VnU4TGh4Z1VRUG5PbUF3U1B4dXZaeGxQ?=
 =?utf-8?B?VjlZQVV5TEhGbDExYVV5SU81MnAzeUlLajhwMXlIWVBya0p0Ykd0Z2dDbGtp?=
 =?utf-8?B?UGRiZDlaSGF6bGpIQnE4UWVvczN2MmhBbUNVSldIOFN6NmhnOG1lZFZtTWlN?=
 =?utf-8?B?dUh4b0ZaM2ZnTTQ1ckpIM0lqWE9DUnIrOVphaFl6S2M1N1VsTzVmcFlocDdk?=
 =?utf-8?B?dFg0b3hPSlo4YUdIQktrcStjN1JWV1NzVW96VUg3YjJEUDB2dGdxYXJWNjBo?=
 =?utf-8?B?T2xqK3FhTjMzSHFoSnBBMHJkOWEzRWNCRjZjWnpRbWo3NlNDd1FIcVFQTURY?=
 =?utf-8?B?bkxvdklNeDBqc1dxODFKRnMrQTV5SzJTb2M5UkJ4Wk1FOUYrblg3ekRJa2Vp?=
 =?utf-8?B?RVByclU2YU5PYnpuNmhqRWp2Mk5kbktTY0VvT0t5ZnZjSWRxNUVRbkt5QWN5?=
 =?utf-8?B?bzZXbFVCSGIwclRhME4weERWVmdxN0lhaVp3YTVNNEd5amNYN0doNzIzVmdI?=
 =?utf-8?B?YXY2SmFhZHR0MHJxU1VDcVhmNHJsRG5GVFJiMTltdE0wRGl4cjgwbHhOTXMz?=
 =?utf-8?B?eVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d911d0a3-5e6f-4d17-13a3-08dad8b3552e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 00:29:56.8518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qwxP4tFt8IGNOWRGvpmHL/6GKtO71qfoff8KM9/UfUFlayu0I1g7BAe85wYv0icus2jVJjqiynM/iCeCeGiJUhfShOYu7YKykoKkiUmGEAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6048
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



On 12/7/2022 3:36 PM, Saeed Mahameed wrote:
> On 07 Dec 13:09, Tony Nguyen wrote:
>> From: Jacob Keller <jacob.e.keller@intel.com>
>>
>> When requesting a new timestamp, the ice_ptp_request_ts function does not
>> hold the Tx tracker lock while checking init and calibrating. This means
>> that we might issue a new timestamp request just after the Tx timestamp
>> tracker starts being deinitialized. This could lead to incorrect 
>> access of
>> the timestamp structures. Correct this by moving the init and calibrating
>> checks under the lock, and updating the flows which modify these 
>> fields to
>> use the lock.
>>
>> Note that we do not need to hold the lock while checking for tx->init in
>> ice_ptp_tstamp_tx. This is because the teardown function will use
>> synchronize_irq after clearing the flag to ensure that the threaded
> 
> FYI: couldn't find any ice_ptp_tstamp_tx(), and if it's running in xmit
> path sofritrq then sync_irq won't help you.
> 

I think that's a typo in the commit message, woops. It should be the 
following flow:

ice_misc_intr_thread_fn() -> ice_ptp_process_ts() -> ice_ptp_tx_tstamp()

the ice_misc_intr_thread_fn is a threaded IRQ function for 
ice_misc_intr. I believe from reading the kernel doc that 
synchronize_irq will work for threaded IRQ function.

Thanks,
Jake

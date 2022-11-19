Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF7263088C
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiKSBmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiKSBmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:42:38 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2195A46F
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 16:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668818855; x=1700354855;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TUtb7r3qyGgQWxB4PKSFQbj4CB5ngmribYWmqdiAezk=;
  b=bAGC3UnSUvLDuUmRusyA5YuF3SFtgV8gh5hTCs2GZjBmVUuWQElN7vyN
   tMsfZbjg4f7ZNx+jFmhyq5tFJBKexrgPG4dzT36TTm4u0HEo5txoK8PDe
   CH07aoABP9/VHMRfMYNSLiCryp+YRJOtKD1m0UewCV2/woVONxma6RhHn
   kwsC9h5zkUY7kkVosd7s2tsPiMNaL1Br3Z+NF+qtLCIhC6JBhQGFVlvms
   j5vqVi3TJybQj/Ml5T68pg3vqv9GHRjcXczMFQ2NlL2ghHcwmrctZCkZ/
   qfUKjY2EkiBT5ThmTZwZ5BK3hJh2din8PGmav6ICC/GsJKAefvIrlmRyn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="292982676"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="292982676"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 16:47:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="673390491"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="673390491"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 18 Nov 2022 16:47:35 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 16:47:35 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 16:47:35 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 16:47:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQu2eScWqWzGXYquAR0xIg9zOEs9ZJTKDInKXrOo78XOwFS3DOKARZBzcEhaczdhMQOqd4en5iQISSQ3SJA2whutSnZqV8HQjW4yXDqwc+pZkTR+gVKfB1e3xrSUaBI7SF99Tq09g1W/ihITFnj6t+iVtZInBrQBDbiETEXVCH6MGszWobTEBGrejXpqA76cAKBuCvZfs220Sg1bdm8vznR5Zhkd6cNIsxZLDqsaLU5rFjxt8fnn1sRWcZzkJWTDssSseYel+BaE6qWbSsOy3r555xcPGr5+D/0oDXXpObW129skI18jWoTu3zsBrZG2tycrTD8ZBC1kt4jOFVA2RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zDgBM8q3aQEB+2lK691TUffhDjjnzpb89Rh49SbeCr0=;
 b=cUnD6jrG0cVSObx1LEckJsbBJSl5D8xGOYUpmt3KzPeqdV2cWpuv0mzm7x2dsFU+r2emOIZV+4Musa8jvBcO7C9neJytbm6WCuO24sVEpqqpkF2aCAUeQRxgsbvp4iqjGShZlBOGwD8wN6FEZb1yNleIuhK9WpOePRnD/qoVeOIhcS//ta+kq4IoIW9ubhW7qerYHL3jA1C57TEXxYVhWup2JwCal65JPPiWaqTfO6DqFSo+U3gHsROJfhsR3D2SW0vERfJn3o996t8MVUxUZWvBv4a00kIlNkZjp5LwGeK1v9zT4Bmhf7nQrFPmcosEqVqHzWGNJqIt7j4bzsHWZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by LV2PR11MB6047.namprd11.prod.outlook.com (2603:10b6:408:179::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Sat, 19 Nov
 2022 00:47:32 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::a123:7731:5185:ade9]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::a123:7731:5185:ade9%8]) with mapi id 15.20.5834.009; Sat, 19 Nov 2022
 00:47:32 +0000
Message-ID: <015d1dd2-de6b-3922-2c44-f54bf475f8c3@intel.com>
Date:   Fri, 18 Nov 2022 16:47:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 5/5] sunvnet: Use kmap_local_page() instead of
 kmap_atomic()
Content-Language: en-US
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        <netdev@vger.kernel.org>
CC:     Ira Weiny <ira.weiny@intel.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
 <20221117222557.2196195-6-anirudh.venkataramanan@intel.com>
 <2373606.NG923GbCHz@suse> <2784595.88bMQJbFj6@suse>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <2784595.88bMQJbFj6@suse>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR01CA0005.prod.exchangelabs.com (2603:10b6:a02:80::18)
 To MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|LV2PR11MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ad9db28-11e8-4bdb-dc69-08dac9c7a3bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HLW6OBGILjR5Ke0Z/QjKHSQaxQRNoFuUISdKYiEv60Qg472hS749Im43Pd6fL77EzOzgIEc4ooLtshLWb5O3wSFp6gT+B7gXIPA8TerUewnqpH9999SJL3fU3nDR9Ur7g52K0x9HTXtVsJchpELds2NC7W/7b/mU0rrcJYEJYGS2r1BK16GZLxutetIDA6UHt+SA+0vEdbpRomgNPLFB73JTKzOonTYDpzX5aRCoc7xI9FwHeCog4i5VzHwMamKxaMfVCUpu9ewbJeaeHTDoHl7BkrTLIvfIj2M2GZ66xnSN/5HEfNzBZFJyym2+2JIhdQrVbR46k1tVevUuGfo9Co6jLmJSFAh7AdYq9Y439t9HDH1ucLFHN/Sc8z2KJi1ZIqfjGM3ydipSHMmfczE8cmY8AN3gBs7YERwbA3hkDAsVaTEscXGjmOYP/fepjkZ8ytWJPb5UIUNpLiVdDpqO4kLlj0I62WKfJhjXYkJwM/DhBtduL81+QnlNAUGrVXMlbreJrizgm3m1FcEoXGmClLC8NUjq0HMGLdZSSBoZ98jhqW+Vmd933pDCr6oRuzo+eL6R7o1z1xv2wwgMn8uADEP+h6j9JsrUeu7WnWyBvqu0sxNskm7y6kLrTVuuMNIRRRJf2Kc+A5wdpaUCEZdPiPOOVOzWWlWSd2t9NCGok43f+GHNpfeE8EonNXwwHKhCqpb/FaKSjhlq0zJNL/TSFqIsfE31eyGGNgxzRb0+6BU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199015)(82960400001)(186003)(2616005)(107886003)(53546011)(6666004)(6512007)(6506007)(26005)(478600001)(6486002)(316002)(4326008)(8676002)(5660300002)(41300700001)(66476007)(8936002)(44832011)(66556008)(66946007)(2906002)(83380400001)(86362001)(36756003)(31696002)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTJ5WVJEcG5SSzc4TTRlZmR4TXd1Q3d5dHNkTTE5WmNEdlBXKy9oNnQxZTJF?=
 =?utf-8?B?c25YMlE2V2ZEaDVQMWFGVGVQSGFOUHlFaFgrNzIwU0lEdjBFaEFlN1BNYzh5?=
 =?utf-8?B?cEVVd2Z2bDdDMnM5OE16azFIWVpWNzhaeFFLYWIxVSt2SnNSZjdWMXlvL2Nr?=
 =?utf-8?B?Y2dKT25wbVlVQytMeDJ2SlluNDNwMXJkam04OFhWSGI3Zjg4b1Z0SThmeS9a?=
 =?utf-8?B?b3ZLUkNEM0Q3aXVhN1pRaVZUUkdGYzVkb2NHNVBta2poelJGNHdjd3lhRTlM?=
 =?utf-8?B?RWZITVJvaTRkbHlLYzltQ3crMzVLSndHVVJqdXNhNWlqQmhTd2hEdUFoY3d5?=
 =?utf-8?B?Q2RPbXR6N3hNUEEzVWdyb0UrbFFGNitDK2Z2RFZBSGUreGFOY3N2VGdVRVZk?=
 =?utf-8?B?ZGgrY0dWMEQ5VDVOSzhCWGQyYWVkMmJwN2tzQXpZd1hTUVhQUDEvQ1V3N20v?=
 =?utf-8?B?QmpDRHovcDk2T3c3ak1iNjhNcldNZEpUV2plRDJlSEdkZWRFUkpZWEhXWm5s?=
 =?utf-8?B?blpsQ0ZBZmxvbkpxNlgzNHVFejlhWHVEeXdHdFZEdEo3d1Ivb3F0V05XOVZZ?=
 =?utf-8?B?NkxidDFlK3dRbzVjSmFBdnI5VjVNNFhkd05vMkx4RVNocDh3NVhDV1hUM28v?=
 =?utf-8?B?VVA3ZXkyNXJ6cGlpektCLzF6UnR1VHN3S2NBcHVGNkdjSDAzNnZzbGRXUXRq?=
 =?utf-8?B?ekpkZ2JtNEpxdGZFOEFUWnpMQjVrVDBMdDlXa3I5ZHljd2tEMlpFSzMxNXh2?=
 =?utf-8?B?VjVrSE1Ka1kzN2cvWU1QRFp3UW5rc3RndU9BTGJxdXY4cDQyUi9OL2hVVWFq?=
 =?utf-8?B?WnFuYlFJYnB1eUdyZzFBWXdQZ1MzN2xwcnFXRVJNRUNtZjB3WGcvdExuTVRY?=
 =?utf-8?B?NElUbEtzTVJFTTVzVTZlS3ZwM1Q5eWdCTkpELzdYREVWVzhXcGZaSGh5NEhR?=
 =?utf-8?B?Q1V1Y3hNSmdvZGV5VWNMR0pIcmUyaWt1aUNMcUkyREVCZFBTaGtBY0wvYUVq?=
 =?utf-8?B?MGkwcDNaVkk0R3Z5VFUxWUE5TStjaHNtSmdCOFVZTVVhSWJpZFkySVV3K2R1?=
 =?utf-8?B?ZkVuZEpZTWNNZUZGREV1eit4K3R3QTVIRXlqMzErdDhNUjBhNDh2MWVKWTVM?=
 =?utf-8?B?R2ZSZ240MzBFdXFTOWZvTzBNcE5FVFo5aUltRXNySnp5cVZIZENzc3E5bHMw?=
 =?utf-8?B?K25qYUp6NXVrTG1Ud3JtTHFJRTVoY3dXNUZwdDBzQTRHTWd5aEQ2aHdrQTY1?=
 =?utf-8?B?eEtjM3ozMEtUbFJLcXN1b3k0VkhqUkE1bGNCdGVXRCtHdXVmZUt3bGlES3dB?=
 =?utf-8?B?UHdnU3p5Z29EVWlGUmlWUG1CSkVUVkc4SnZ0OERkNGc3cndwM2trWU5FcGd6?=
 =?utf-8?B?Wi9qd1prWDVQbERLZjBNMmpuK2U1cjJQcXNjbzFXbXdmaEtpSHZJeGNBRWtU?=
 =?utf-8?B?OWM3eDdUTlpIZmdtTW9JcWVYNmR0ZnYycTN3MU9kUTZMdytiTXBZOStiNGVJ?=
 =?utf-8?B?SjU4N1FKTmVzMmkvNFFwTWlwYWhzMjVUd0l2ZjBEdWpSVDdzVjAzcVdNaTk5?=
 =?utf-8?B?SmJzcjkvbkZJTDNKRXFxZU16UFN1Z3hnYVpWY0lPcG9kYnZVbzAvaVlaYW9K?=
 =?utf-8?B?OEpUamdwSEtiZFZhVWVoSmVrQ2lTdzRIcUNudlVVVllmNys1L095alRlRVlN?=
 =?utf-8?B?VmpTZERkelhDUWNRODUvL0lqaUZPaWJCOU9USVMzT3VhRUdVc0hEdDRCbXE2?=
 =?utf-8?B?dGMrTlBzZHRlTTJnVFgzSUtPSnpxQmc0RDJUZGJaNlhYNVlrWDkybmhPbWgy?=
 =?utf-8?B?dTh2K2psdGRCdnNjOTUvVFlWUThSZGRiWWtsb3FwVE9BY1RkRnRJa2M1WFRQ?=
 =?utf-8?B?UUJiZm4rQmQyN3lnRTd5Uk53ajE4TjdlRllaZmhxNEp4R3hCOVo1KzFWZDdo?=
 =?utf-8?B?NTVWa0NON2lkUnBtSUoxeHl3OFc3b1dQVGhqYnpzbnZrVmVVMUcrMmRrSzBP?=
 =?utf-8?B?WG0xUUx0aDZMdWpxRFhVVFdNcXk4VzJsZVYxM0JWd3MreUN5QzdBQ1BTZGJx?=
 =?utf-8?B?UGRSSldUT3FrbVd0cWdvWW13ODNvS0wrU1FTcUpTQSsxZkVqU0NyRWluSE5R?=
 =?utf-8?B?dktNRjR2Rmt6T2ViK293Um94YXpzMkp0a25UdGxjVFdNWXl1MHdlNWJMdXJH?=
 =?utf-8?Q?907AmWrBQMmKzGT3QzR/UW8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad9db28-11e8-4bdb-dc69-08dac9c7a3bb
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 00:47:32.5123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FS1S8xbjhPMkmx2kS3gqsVTkznWurEPrEKFYEb809+hFxkBFFR82VANLgI6lb2Q2gAGUc0n5is/O8uPWG3pX4hykRJwIvRtPEyDO7mxKJUTlguc+hAJyusuioz498Zqs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6047
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/2022 12:45 PM, Fabio M. De Francesco wrote:
> On venerdì 18 novembre 2022 10:11:12 CET Fabio M. De Francesco wrote:
> 
> Now that we are at 5/5 again. I'd like to point again to what worries me:
> 
> "Converting the former to the latter is safe only if there isn't an implicit
> dependency on preemption and page-fault handling being disabled, ...".
> 
> If I was able to convey my thoughts this is what you should get from my long
> email:
> 
> "Converting the former to the latter is _always_ safe if there isn't an
> implicit dependency on preemption and page-fault handling being disabled and
> also when the above-mentioned implicit dependency is present, but in the
> latter case only if calling pagefault_disable() and/or preempt_disable() with
> kmap_local_page(). These disables are not required here because...".
> 
> As you demonstrated none of your nine patches need any explicit disable along
> with kmap_local_page().
> 
> Do my two emails make any sense to you?
> However, your patches are good. If you decide to make them perfect use those
> helpers we've been talking about.

Hi Fabio,

I'll be posting v2 next week. I've incorporated feedback from our 
discussion, and hopefully the things I've added make sense. If not, 
let's continue talking.

Ani

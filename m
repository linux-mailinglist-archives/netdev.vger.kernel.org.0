Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF206F1CCE
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346073AbjD1QmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjD1QmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:42:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F935261;
        Fri, 28 Apr 2023 09:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682700121; x=1714236121;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kTc9IEDiW1m5hYhMFaHI3NHH1xhI36WzCzFJbSMImZ4=;
  b=MhUM6ck5Nkt9FeF4RvM3XUtzybtOWG7c47Kwzzz94SnRqmTVuZ6c5WtD
   6vFCIAvjwW/dFKK8RbYds5QWYNn8DA1Vpaon8X9zqEb/WySM0Cq+GahR6
   o7N1BS7U/quzOmk6i4dvNVFeprObNm16rHWsRvBxxKKefWo5RfRKv8gwu
   X4IS76los/ZfAvuC1NpJqg47JTX2oD50FIutBHeDNZass2Wv26NW7Qpcf
   Z3K2hVgucfWvXQhxEiXuuS0KSM/IvKojMB/p0YGOoKQwx8iUUb7HG6QLr
   saQuFkObnj8SNM7g23U6T8XM3/8yNX2+ijYdvVjB3/LEumYLhuaB8yVjL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="327415280"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="327415280"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 09:42:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="819070132"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="819070132"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 28 Apr 2023 09:41:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 09:41:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 09:41:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 09:41:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FijLrwiQ1gTEw3gTMJLlaMR9pP4rYIo/ENCS5sp7VupRhfecG5KUO6DGewiBiYZpFbocmdRx8vK8JYBe3BHrf2W8WCwMwzYwLFWhL8LJi6DuKsPvfMzSPs7GV2XLQWX1L+Y9+clPMJPIpeloC9D9m6WVA9WaK9dQ0uBtOT6LS5KasZvm9Ih+40FipoBAaUzx3AQuqQJzVSDopFtYXYcmHEW87LjpIW9WGg1INl5AB71nrLLAT2VWMd5lBnQYi/H5y6NzqB4Bci7zVzzTU/Kwq4msZ9uw35Y3cxIZDgrcSPA8OBvK0Dy+D4tIdE7LPkFfYSVtN905U5JTeI7991+YAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTc9IEDiW1m5hYhMFaHI3NHH1xhI36WzCzFJbSMImZ4=;
 b=XLkykGdBnclegf2vHOeT/AbS9MReQtKVHxFUDXwZB9zHbnRWBpd9JQaOmyTazyt17Nk4H73E+qh8/A62CVA6PjQAKn1Zu4MDizPkx0+nptpiaAkoye7DyNsh07fqXeUGhYaLKetxvQtzjVaJ7K2BEQTj4lW9nXLyDDeuKF9JhPByle3nRXMVn7yAMi+cF90o+1Ah2jZhd00DEPB0tzu2WRNwZa9fSHLvgd1SNXsxXgm3sCFf7wxPWc/6Kazsvx+vryDKpbp6Fuk6nkg1wQVw/Ugx3RJw53G5mXoBPbq/rht08us0YFkqzS3AlikhZIQINSIJO1lOCo1HPDbFMTu8Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH7PR11MB6673.namprd11.prod.outlook.com (2603:10b6:510:1ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 16:41:46 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4b81:e2b0:d5fa:ad47]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4b81:e2b0:d5fa:ad47%6]) with mapi id 15.20.6319.034; Fri, 28 Apr 2023
 16:41:46 +0000
Message-ID: <c7d70574-b03f-3d88-878b-ab21422ed214@intel.com>
Date:   Fri, 28 Apr 2023 09:41:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net v2 1/2] iavf: Fix use-after-free in free_netdev
Content-Language: en-US
To:     Ding Hui <dinghui@sangfor.com.cn>,
        Michal Kubiak <michal.kubiak@intel.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <intel-wired-lan@lists.osuosl.org>,
        <jesse.brandeburg@intel.com>, <keescook@chromium.org>,
        <grzegorzx.szczurek@intel.com>, <mateusz.palczewski@intel.com>,
        <mitch.a.williams@intel.com>, <gregory.v.rose@intel.com>,
        <jeffrey.t.kirsher@intel.com>, <simon.horman@corigine.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>, <pengdonglin@sangfor.com.cn>,
        <huangcun@sangfor.com.cn>
References: <20230419150709.24810-1-dinghui@sangfor.com.cn>
 <20230419150709.24810-2-dinghui@sangfor.com.cn>
 <ZElExd5bAL2FCpIB@localhost.localdomain>
 <650acda0-9ec9-7634-3e01-e4870c8890b7@sangfor.com.cn>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <650acda0-9ec9-7634-3e01-e4870c8890b7@sangfor.com.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0206.namprd05.prod.outlook.com
 (2603:10b6:a03:330::31) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|PH7PR11MB6673:EE_
X-MS-Office365-Filtering-Correlation-Id: ed5b16f7-6432-4ece-ce87-08db48077457
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 67Nqj9K23AvtXsphrTQnk74YDe4ZL0yWj6Ow7PnmPEWlQL08ercEynhDDR2VLgbN2mxEJZ0dYvtK3kvXKmrCOF7vhVgrN0Qok7bLtRVSfJwAeMlvr7dGju7oG9yHGNJwrzeCPz4cCV0alzOY6jGm50vsAKwMwPpLl+AE1qoAqlTZa6k8OkPLhEu5e4+8RV9VVTzwNLdSmTOa+PN/C3n+XbMKvO95Ec9K0zA/t07PSb/y8v3OacWOv00zPpWpxX4KMP3oH8eXfLNJwd1DnIde2K/KHPb9KSY7QRN/0aS+jPf4287CkCwb8ajk6V7Ro/sGhderDv2Y9uWIYNJ5Eievo6utsuDGK/3qp78C82DKDqr6VPIyswYoPnbuasDNhTIkkjFzTFjYk2rNuVBcQ/SKc456NxITN5CYvKim8wzQCpiySIo/iSmsyR8eexnb9VwVFcHB4n4+Ao0xhVzgs2sfavK9b06iDEBbNcVN4KAU73dUNx+AmNHnsUCabB17A0gCzWojO3+YzHR/Yn/NDC+okxUv/0V2G/REGv9R54v7QLPa/b1RlZTKktf5wina/c8y9PKEoSEOsnWpshl8/rjkUtq1UJ7OgMpkjAPnRafn8o170SoYukoGywLSAwcZZCAL40EVQ6pwFbah4V/7Xgxl/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199021)(31686004)(6506007)(6636002)(110136005)(26005)(186003)(478600001)(66946007)(2616005)(31696002)(86362001)(558084003)(83380400001)(6666004)(316002)(36756003)(6486002)(53546011)(2906002)(41300700001)(38100700002)(4326008)(8676002)(66476007)(5660300002)(66556008)(8936002)(82960400001)(6512007)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VG9saXlGR3E4WmVqVEhOTnV1bUhoaXJyRGdtdzhIYmU4SGN0RGhqVFhCbUww?=
 =?utf-8?B?SnAyZ2Mxay9HM3VlQmpEYnNkVE5rSG1JdWZNdWhnTTNvVmt3R1RUcEdHbWIy?=
 =?utf-8?B?TWJvSlM2R1JRRnpLdjhPUjhVVy9LTmpHWXd3cVd3WG5lektiZ2F0dmsyeWtx?=
 =?utf-8?B?ZXYvaUVjT1hoNDJKcmNzOWk3TUgrNUVJUXdhNG9zbTIyL0hXckc4QTJGVlFq?=
 =?utf-8?B?ektuY2E3YThBbzJvTTFycW5UTVdSU1NmN0laSFAxVlRsck8ydlhHcnJnbkNv?=
 =?utf-8?B?cm9TVHoyMXNoazJBRlNUL3JzdUxjOXFlTVExTnBUMGlmNXJLZmNWTEF2c1Jx?=
 =?utf-8?B?dFpnM0JicjlwbGNWQUd5UjdEQ24vRFJzVEtWQ1FMMnpMSEIzR1VaM2hFRmJ3?=
 =?utf-8?B?WFBlWStqSFJudmdkZkRsQVJiNDRFUWE5ZytVeW1jVG02YklaWmdDaERwY2xi?=
 =?utf-8?B?UTdJTHZCMXcveWpjZEMraWJ2TVNiVjhRMU1OSVMwVys5K2xnOVcrSnVaV1Nv?=
 =?utf-8?B?MHo5OHU0bi9wY0FPRis2ZVRMbEM3V3FSQTNjS3QzSm5Oc09rTHN2aFQycUFq?=
 =?utf-8?B?RGhVd2tqeWgvWHFtUGR5eXJidkxNZmkyNkdQVmNOREdvbE51TU9xVGtRLyty?=
 =?utf-8?B?a3JQNXh4cktnb3lnRUZmczlYN2JEVUlIaG1SQzZEMkpuK3l6UGZKRDIzZmpV?=
 =?utf-8?B?cEFJVmdveTJ0QlFSRzdSQlJFUlNpQWlLUlJoa3BVRi9uckRPYkNwV1ZTV0hW?=
 =?utf-8?B?bjFldzVualBScmVOeTVaK1Brd1dRMENZK1VoNjhvWDhWNHNUeUYzdXUzSzVE?=
 =?utf-8?B?OVFUbXA2aTZMT1daZ1ExT1l4aGo5bFF4eTlScWVxejNJYzBDcHNhZnVLbS9j?=
 =?utf-8?B?UkVSQitJUXliczI0cXQ0SEJab1UxQ3ZrMUJlcUtmU2pWcXVENlozS3ZZSWJN?=
 =?utf-8?B?c0NpdHpBdUZIUlJsd3dWSTN4aWpNVWVGN1AvenBwU2xleGJ5WDZpbjRBWkFw?=
 =?utf-8?B?S0Z5SWtUZGM0aU94R2lRNmF0b293cExLQ002dHpSM0ZMS1h6T0tzWGsrRUds?=
 =?utf-8?B?TkFaMkpmUEVQcDVCVFd3OVlSdmw4KzRJVXlONCsxZ3Y3eEVwL0lVZCtJOFFp?=
 =?utf-8?B?cU52UnB2SmFrYmhIUit6OVVIZzBtb0ZhMHhPQ2h6RjNQZGpzM3YrM0VjUm5z?=
 =?utf-8?B?aVQ5QlpEUUh6L2hNVEFxaWgvMlhqQ1Q1MWpzaEJoTDBXTE9RN3FYME5Yc0JH?=
 =?utf-8?B?V0h5a3NaVzlEaXA0UHVzRDBVV0ZHNTZucUg2SGt1Z2puTUFRNDg2Qmhsb3VL?=
 =?utf-8?B?bDlqb2NnUWM4d0czekJORGcrcjh1WXRoSjB3cGFDcTVGS1JEUzB2blphNWVZ?=
 =?utf-8?B?OHgyVDFMVDExU3kyQmJWcU5rY0pPTE1YVFJ6QjJRZVNQVmJiR2lBYjR2Tm1t?=
 =?utf-8?B?c3R0Z0h5RkFYV1hwakpTdDR3VWVFZHpUTnUydU1xdzdPRVZIdytYSlJuenBo?=
 =?utf-8?B?SGt4RFNDQmN5OXBydUsvMnhtVlZnT1JvU3hURlFCMkQwSXYrQjNSNDIralVy?=
 =?utf-8?B?d2NmUlYrMGdkUmszRys4YTY2OGZFWndDNkxydFBsUFd2bmZqMmV5S1psdnBG?=
 =?utf-8?B?UVIxTTVjanFXYVhHZm4xb1FkamxQelZHeGMxSDNEcmhUbTVGMjFUeEtBNVdB?=
 =?utf-8?B?emZDRWZqNXRGSkdhV3J0OExzR0E0MDd3Y3VtYzg0UFZzN0h5VUFBeFM3RHhr?=
 =?utf-8?B?L2krTUpHZHpIMkZ1NzZLU2FMQUVRTVpRTlF6ZHdWTUZDWTFpN3VaQjlFUGtE?=
 =?utf-8?B?NWRPRVFXNStzV01TeU5RTmpiM3FQRTlmUEhMQTNuT3B6SDRvbldLd1VYVWVp?=
 =?utf-8?B?bmRoTEs2ZWdadzZRY0czNGtRK1BSY29aZStNVFFabnVUMEpSbWVxYi9uSU9G?=
 =?utf-8?B?b1I1U05JWjhPZ2FjbUFQbHdmMUhmVlVZUE04TjNFUGY3YkE2ekVsRWFQbVdX?=
 =?utf-8?B?QlVUcjdUSHUwWkNSbVY2bUhzc0xZTWJPRjZrL0ZLYklOMXAvRkNIR0VhZ2dK?=
 =?utf-8?B?d0N5ZWQzOFdBYVV6dHBVVmVxYTVFdXFCdEdvUEIveFV5UW9iaEN2K2ZucVcv?=
 =?utf-8?B?QXJJY2pBNStJM0pzd200Sm9rZEFjMFIxZmROSXZqSDJqMzBhaGlobXJFQm91?=
 =?utf-8?B?c3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5b16f7-6432-4ece-ce87-08db48077457
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 16:41:45.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xq85QMzqty4kDK/OS20Ka4vqom03Br+3rNwThcGo21OWVYL4BqkaUdX/+3vJ26exYF6lPktrdQmPN7i+fNYS1pcPLnx8RKaPoK8yUZvCv7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6673
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/2023 6:14 PM, Ding Hui wrote:
> Hi Tony Nguyen,
> the patches is already applied to your dev-queue branch, should I send
> v3 or you can fix it in your git?

An updated v3 would be great.

Thanks,
Tony

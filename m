Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35A563B621
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbiK1Xtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234725AbiK1Xtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:49:41 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2277228E11;
        Mon, 28 Nov 2022 15:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669679379; x=1701215379;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hOoqtxHHkiGBpbMRdeRnzH07lzKp0heP6ymODTPkC/c=;
  b=ZQJ5DomUAGs+4q/DOUw+Z4MGgahdc8SOGQJmFmwssUdAg5T5kjKtjL0m
   DLYpuuaXZXaqnLU4giu9HKe7nYZI+RKQGsOdzjBAlluU/kH7mDOQ8q2O6
   iuaWSmJ8aswg6LSrM9hx3XpZcC50zoe9ku3sOJNhVgY7maOOmMpfMGwIU
   Ep1xP/WjTa9k8ZdFMRrK82ezqjEHv4IawZt2AC6iR5bHCmetHT2uYo+Ae
   r4X4RVoHL7QAbqGQnDl0a2aFPiN5Bu4dekWH58gD5x2s4S9mZqvu32R21
   fmiF76QRKFC1iXIEgko1ySU8U8fahH8Rle2XtMJ8pLvDkZXeywO6Ue9Bl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="302561568"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="302561568"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:49:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="674413654"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="674413654"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 28 Nov 2022 15:49:38 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:49:38 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:49:38 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:49:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZehtNPQGeQy2BlupQxHDWJ0AHNk02Zk6RVJtYgMEt+HKfenW83DEqhpCfCCQHQmasRCtBxwAK/Nh6qx/HpVuEOLKUeax3SPN3fOvSfEoWzi7TOP/00Nf06g3/5jP/zl3goji28pq8UTM1prsiShUcz8OYlOmOGdw40iUNn+045JxVoyLjIA/K4bYo0HCS3ODyVhQdSE4FqpuhQRuV3q5iGmfgxnjMBIngxFJokFMpPCzQla178DfJqoEPJulrLlUnaaKjkg1KldD8Qy6GMQl3eCIwik9BSB/29j+pOF2hiW9+GfaC1+eTwbW2ish2LFxncS3L6I6v/k6pTE5XvjxEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YYnvCzyTZzEGUCL09ICPs8IQdcLiM0B+wZyWVq4CQqY=;
 b=N5NCCb75iDrLAzBx7L+qdYaZbptCnx3cHvDbOm+y+1pBYZgBUUAkHbj5j2rmZx8CR9EhHwjziNaJqL6GPjPjOxilu4Vg+LK8MNNhByDnJUjp3h2T3+k3Vnqs5l7K5Z6oTDZSRQ1umzD5gK/7z7n4WmXrep/aTHGki/xbmlYrpFSKSKiuNrB3Nf9419a8Hvlaqxm03NDskfZ7KoYxLFgb35CoebidtYzHKaGULhu3Cbwp6miUIHWsRlCiuDQF3lUg/a4qFiRVAqPLGmqjRJ4y3nPJbwwnwEdJCexddF9qFeiAieJFJVHXgkCF24sMUwLlsTfipNvJtCliXh8NUZarmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB5014.namprd11.prod.outlook.com (2603:10b6:510:31::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Mon, 28 Nov
 2022 23:49:35 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:49:35 +0000
Message-ID: <8ba44ad1-675f-92c2-0e13-6bf9c4f8e598@intel.com>
Date:   Mon, 28 Nov 2022 15:49:33 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 net 2/2] vmxnet3: use correct intrConf reference when
 using extended queues
Content-Language: en-US
To:     Ronak Doshi <doshir@vmware.com>, <netdev@vger.kernel.org>
CC:     VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20221128193205.3820-1-doshir@vmware.com>
 <20221128193205.3820-3-doshir@vmware.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221128193205.3820-3-doshir@vmware.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0150.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::35) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB5014:EE_
X-MS-Office365-Filtering-Correlation-Id: 64e20be4-3ffe-437d-c65b-08dad19b3422
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O8ttA+BacirkPUVTTIL1uWJQ3QDEH0eXmq9+wnUPWQ/hhyYVlC2IjqlbXoTCllztL8evuxl9QEkhOBgU5H3JjqjJisPAcWmBLDbiVj9HFC8UlpoKch2g2A3N62cPR6MrNwslWwEq+GmVwPTtDG3V0cucsUgRLaXDjO3vDJExyfgt2i9HCG3Z5h5xhtCgyuEpPYTvyAHLSN02IypRwQzB/jX0Imzf+nn1W5mvzQGz3IPfphOSay/S1Zz+JQKkvB5xC5VZJmbK3kITQkrOuuTB8dk1ZqH7dHACbwOP55dgTgfkZwNlOgGFM/YaSxrkYTscVbJ/ajnRTDPgC4OWfsKsIRw0EUoOSITP5fEWmWENKCi7ncmEsqRcyMeYGaYxIAc0pfdCypesqdGx5OKUDk8QvPygtq66dy5+hnMODiH5EsRJQjggSQj8xLpfxE8CpeT0guirtQDrtnqDC0LVGygt/KPA5wYoeiRAKAYwMUOEWQL9kxRO4GMX2qniVJgHb2wg0qr5HvjxxaTD2H4Ur1GOhN4BvJZnVIWu25HYIrC3EwP+Gr1QvsjS45sJHjkXwIKekJGxKRszEU+iOaPPSN46A6enlaFyAzG0GSRntkWdnoM0PF8S9oN4n/lXFNTO+odVJq1DZdFrhq3mqebOuCI1HYa2t0olWtzV7QP20WloFUMe3gFlTKSuFHUdpGm22D4EGn+DhnHeCMpT4HVF89v8sWYR79ojol7+Cvg1LU9Nd5o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199015)(31686004)(38100700002)(8936002)(41300700001)(82960400001)(5660300002)(31696002)(4326008)(66556008)(8676002)(66476007)(53546011)(83380400001)(66946007)(186003)(316002)(2906002)(478600001)(6506007)(86362001)(36756003)(6486002)(6512007)(54906003)(26005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnF2VkhQcEMzTTVpdGtzd0ltcU84QUFUNXhoYjBPbGZmMDg4WU02RFFKaGFk?=
 =?utf-8?B?ZWE4bmtoVWk4UGhYZWs4UGZEbk5PcXlGcGVacWtrVEJBM1IzZ0lxSTgxWXI3?=
 =?utf-8?B?V3YrNHB3OFFpakNCU2FrY1R5VElLRVZvTkEzMmdkVVhXd1k2Q3ZpQnBva2dq?=
 =?utf-8?B?VklBNFVTZXZYVzlzM0F1b2NHMDBNb0p3WHdncWZRSE1Objczb0dCY0VaMUY0?=
 =?utf-8?B?UGo4Tm55UnZuZWNHMTdWdCtWZ0NUSk92R01YTFFNa3lTNWF5cFNPL0ordjZK?=
 =?utf-8?B?WVJjZnRIZmpNWTVmdEVZdndkNUlhYjFkQjg1WUhDUkxtcmI2eWFEOXlRb3py?=
 =?utf-8?B?dElOMDlXUGFFS2ZLVWRKVFZGRmI1M2Z0STY0WHBkSWQvckNwRllCbDExcmJj?=
 =?utf-8?B?akRzZUJ3MFpza2I1bUlXQ1ptaVZ6WUU3Y1p4NldtYTk2YUtZL1hrZDBDd21P?=
 =?utf-8?B?MS91ZnBlY3BVTGpuOFN0S1hUTGZIV1hZeG1jMjJUT05zdVZvMSt6VWh6YUE5?=
 =?utf-8?B?SjZEaWxHZC9KRjVsV1Q5eUJHV24yQ2JOWnR6ek5VNXZYT0ZSVCtwUWExZUlo?=
 =?utf-8?B?SEpNcWNYVTBJd3RmR3BNR1FXTHJ2UkRTWDF4YW5rdFR3VzBOS3NRaVJib1Jw?=
 =?utf-8?B?WFhFSktSOUoxeVZVekgxaElYcnBrMG44cWV1N2kyTGlUMHI2c0lWdEJsS3M4?=
 =?utf-8?B?dzJnM1IrNlkwSklmSFVuMTdxRFdxMUpQWmNpM3MxY3IzQm9vRENkeGpFMVBO?=
 =?utf-8?B?ckRiRXlUZU5YamlsZDBkZ1AycnZxRGRhSnRESmt2SUdRRCt0dDZOMFVoOTRh?=
 =?utf-8?B?a2l0cDhtREdrL1BzdXhEdFJqVWNHMVFXNzk4ZytwWERMckdFMVJYUWFJSjFn?=
 =?utf-8?B?MGhUemhDVEsrL29pM24rUG9WZTdQRUJtS3lsTjV0L1g4ekxFQVN6bmZiV0VC?=
 =?utf-8?B?c1F5TUtXcWFMV0trZGFqaWE1V1RWcytXNUg5ZDZQMDVvYzlrRHAranZnZTFH?=
 =?utf-8?B?R1FYT3lCYWNteXB0Wm5HeCtYWnFScERzWG4xeWt4NUxTamlFcE5WMVVBRTN2?=
 =?utf-8?B?aGtLSmlLSlFWQmxoT05nQit4WXVJQkQ4c0hjYU1QMmxLZXRjRXV2L0VWMTZM?=
 =?utf-8?B?YXNpZzRLNSswRFlSYUkrckVCZS9DU2pRT3UwRFc2SFRJQ3R4aFRFLzBDZVFk?=
 =?utf-8?B?eUJDd1NvYmpFZmVVcC9RU2t6QXVOdjErdWtHMHFBQTIxbitxOFJkN0p3ZnZM?=
 =?utf-8?B?djBDdUhabElaS3orRHRJTkljWUNKeDFQNG9XMklHY1JPRDV6dWN4WkpTcnZ6?=
 =?utf-8?B?ZGFhMng1TEZtSXFTd203Zm9pUmdPY1JXVEFRNWJ6RXpCTm1nK0p3Zit0WVVW?=
 =?utf-8?B?UVp3MkE3eThQeTl0RWwxbjc2alRFN243QWdGYUx5dFZseGZpcWJmcnlBY3c3?=
 =?utf-8?B?ZkVPR1UvSmk1WFphQ1VTR0R4UU1lS3U5WmZzdE0yUXAxcmFmdkhBTUlwQnh6?=
 =?utf-8?B?OXdvaEVGKzlvWVVUS1JQNEhvY1dGNUZxWDkxcmR0OEtFdTNLN08zbUhSWmNK?=
 =?utf-8?B?N2o2amJCc0ZTaUNLRUxEMmk0RzZwSDVBbm9UVG1OeDJBMDBHWjhaTmcwQzV2?=
 =?utf-8?B?dlc3Y3N3M1FHUVllUGZvTmoyZ2EvVUZoRHlxd3JQNjUyU1ZtNXBQNEpBeGJx?=
 =?utf-8?B?b254bGppd2FJUk0yOEtlSGpPTDB5VkpXQ1JjM005ZXlFVmh1QjNiMFd3QmZP?=
 =?utf-8?B?YmI5NmFGaXErRmczWHNzeGNjaFdONjcxd3FJTkxnTWZVR21NM1NKMUMrYXV0?=
 =?utf-8?B?bnFGaVZ3cHU3dFlINWdpMFZmK0VoYTJ6eFY2Tnh1bjFTK01ueTFiSzlvQSt3?=
 =?utf-8?B?UTBQdlVpSDZUaXJqekRoTy9Ob3hOTWVxM04vSjdUYkNremJrZ2FUQ01adVhv?=
 =?utf-8?B?aFB1NUdveHRYeG8rcmRjclQwNTVUajRsdmppZUp4S3ZpQXJNSHB3VjJ1Ylg2?=
 =?utf-8?B?T0duQ1RhS2E3NHFsbmVMRUxIeitCeGErU2xUK2hpZWUrZnNWeHZOaDdwUkEx?=
 =?utf-8?B?UkVkUGVwQ214RHV5aHhqbk5yNFBRZVdRaXZaTDd5SVVWL05HaUJjVUpyUG1p?=
 =?utf-8?B?YWFRUlFDWVB2ckdKZ2hLejNpQlNrVkxFRDZEcGFyWHpqdVUwNVR4dXliTE9j?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e20be4-3ffe-437d-c65b-08dad19b3422
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:49:35.2582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RqaOPUa/dOWV68JUKifoSbRKxgzhLAHbbA2Y4psXwuw3+LL4BolVChqTYvGc7UUJncEDQAt2EYp9AlGEpYCVZ8S2EJIykBgqHDgx4OEnrlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5014
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/28/2022 11:32 AM, Ronak Doshi wrote:
> 'Commit 39f9895a00f4 ("vmxnet3: add support for 32 Tx/Rx queues")'
> added support for 32Tx/Rx queues. As a part of this patch, intrConf
> structure was extended to incorporate increased queues.
> 

Nit: no need to quote around the commit reference here.

I don't personally think its worth a re-roll to fix that, but good to be 
aware of in future submission.

The patch itself makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> This patch fixes the issue where incorrect reference is being used.
> 
> Fixes: 39f9895a00f4 ("vmxnet3: add support for 32 Tx/Rx queues")
> Signed-off-by: Ronak Doshi <doshir@vmware.com>
> Acked-by: Guolin Yang <gyang@vmware.com>
> ---
>   drivers/net/vmxnet3/vmxnet3_drv.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index 611e8a85de17..39a7e90d4254 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -75,8 +75,14 @@ vmxnet3_enable_all_intrs(struct vmxnet3_adapter *adapter)
>   
>   	for (i = 0; i < adapter->intr.num_intrs; i++)
>   		vmxnet3_enable_intr(adapter, i);
> -	adapter->shared->devRead.intrConf.intrCtrl &=
> +	if (!VMXNET3_VERSION_GE_6(adapter) ||
> +	    !adapter->queuesExtEnabled) {
> +		adapter->shared->devRead.intrConf.intrCtrl &=
>   					cpu_to_le32(~VMXNET3_IC_DISABLE_ALL);
> +	} else {
> +		adapter->shared->devReadExt.intrConfExt.intrCtrl &=
> +					cpu_to_le32(~VMXNET3_IC_DISABLE_ALL);
> +	}
>   }
>   
>   
> @@ -85,8 +91,14 @@ vmxnet3_disable_all_intrs(struct vmxnet3_adapter *adapter)
>   {
>   	int i;
>   
> -	adapter->shared->devRead.intrConf.intrCtrl |=
> +	if (!VMXNET3_VERSION_GE_6(adapter) ||
> +	    !adapter->queuesExtEnabled) {
> +		adapter->shared->devRead.intrConf.intrCtrl |=
>   					cpu_to_le32(VMXNET3_IC_DISABLE_ALL);
> +	} else {
> +		adapter->shared->devReadExt.intrConfExt.intrCtrl |=
> +					cpu_to_le32(VMXNET3_IC_DISABLE_ALL);
> +	}
>   	for (i = 0; i < adapter->intr.num_intrs; i++)
>   		vmxnet3_disable_intr(adapter, i);
>   }

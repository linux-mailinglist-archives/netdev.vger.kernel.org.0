Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2CC4A407D
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 11:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbiAaKvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 05:51:21 -0500
Received: from mga05.intel.com ([192.55.52.43]:9979 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235803AbiAaKvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 05:51:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643626280; x=1675162280;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=nA3ePWF3f3dVt6pEEhN4dl+h0W9xUUv4utZdKeH+R34=;
  b=cmlIe8zT+65gv3lyF0LZNg8xu1RV0tDk5biIdsyzTz4cRHC7Kx3p+dcV
   7ZUMHR3rPkdyqkAFXXx2wRBIt2YeW8vz6mq6S7Qru5apPsFTjyI2YLN+B
   NrblrwQCTsKotoCqJYgl69WQ9HHDvwPe7HEuPfsEMCU1QmHo9mCycWBLI
   cpGpSpfllnsormeAFCxub7tNXbc1RPFRS5L5Zjij7zIlFiTCciWmEg4ks
   e3tLBTDDwNOZAts5C9CE2FOUu9d1AV0IKsxz6V5iCdKKvkcbQJmeabRnG
   icqmRX/QH0MebwGsKQT0RWKHpLH4m8nnu48/mB3eXiWpVbAxx5P3j2yY4
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10243"; a="333794645"
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="333794645"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 02:51:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="697960776"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 31 Jan 2022 02:51:19 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 31 Jan 2022 02:51:19 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 31 Jan 2022 02:51:18 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 31 Jan 2022 02:51:18 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 31 Jan 2022 02:51:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfXYDStaHKH+Tpz/vIPgIToej/RnB4kRBOyubfI6/EsGxthDj59wS/Hnt+Xu2flWwKu5i+rzb18GWaCSXzGDxlwUKQqIspWGpbnfyo5d/w91uaVq/DLevJtApRr0Ro9AV64Lcrc2L9JxZGeijATE/2j0fPUx8hQxdld8D7yNcpavIo+EaN8oGrU9ZzexHXSaNlW5EdGd7qgUhi/Ok464UW8+JAXGEIW4lEFLUowoh3wxcuNd2gPeichohZxFzx+vroiMbveOhGaC7KNfIvx0fpxlbznnOvW62VIOyeCHQ+NhI4Bh3VyW2Ij4yoK80EAZ79ImPWJb5V5KIa/VLV32DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGJ653VD+qNj/3mL8FY7BZvtEDJxoLzDndG8hDKCusQ=;
 b=ICU1/FVoE7xNb5FaABco6LgXFN+Ykc1vhfCIeqs3UdA9cr4V+U4l03PF9McbUrEpS4QEgDIFF60sZ7CHoKRkmVnt5dnBScOtMqcB8M79VBTOuLdzujX+3wquMXPw7RKAgrJH8pIAuK7GaJ8/1ikyrOq6cTBcY0Ip24RCv8gIXIZF05GVscarE8vftwd6FRSAMj6aSJmGvo6KMuQO9vD15P3Gf+DZA0XBT6+a4f9SU2EOYSTi56TMYbO+MB+sGI37XXy6AxP3fOWetw6HAJTyLU0/pWnhdQzlzPEoQVSr+89t/qg3wT8LSdpJnPLiqzQvwY8XEO41DXp64NoEZv07Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by DM6PR11MB4393.namprd11.prod.outlook.com (2603:10b6:5:206::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 10:51:16 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::44df:92e8:8706:13a3]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::44df:92e8:8706:13a3%3]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 10:51:16 +0000
Message-ID: <d32ac7da-f460-6d7a-5f7f-9c9d873bf393@intel.com>
Date:   Mon, 31 Jan 2022 12:51:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH net] net: e1000e: Recover at least in-memory copy of NVM
 checksum
Content-Language: en-US
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Fuxbrumer, Devora" <devora.fuxbrumer@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20220127150807.26448-1-tbogendoerfer@suse.de>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
In-Reply-To: <20220127150807.26448-1-tbogendoerfer@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P195CA0070.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::47) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f70da9c0-dde7-437a-3369-08d9e4a79b0d
X-MS-TrafficTypeDiagnostic: DM6PR11MB4393:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB4393F7DFD20D99A4F7DFF20297259@DM6PR11MB4393.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MMV2XhzbeuRR875RaiXmOB4KWroRlKzKjRL1d2JkcG7Hi4i7jXvUtM/a8x4wZt1ETOrrLd0Pncvkq049tzzni+E1rcRmaN7UAnYFk5/ycGtKtk/9OxrZa4TkUUwcC7MMSYZrIqmVA52bk1YAwiwmCzJTLE2Lo34CAkd/u0v7DbbUgM03lvWARDE1mIEKRnvokyAYk9rpYBieS7y2aGspZ3Umjl6p7mDCGNdk/TND3ZKTpm41QY1N/YKb0PZ2YJdcgzZCw//UNKpkde4ixLyDsvk9QMF8vm0fAMk1aCSv4Z7QjZeBovaj8a7b1rs7PYLhbC9XxR5gI9k+4vyLJsol+33EZy54mvrtPd4+NhzfJHv3vvqZiLGeBm/ugoBUm/x0y+Oqde3HVA7/iG3/GYtknMND+gNckv24yLzxzWgsJSY93+W1r5e1JtkTSxZoLsbi9axBsry4UmZpH2UZOhKGizSAW4vX5qFWOttdW2+2RdquZNrr6hnxuAjih9BXlyVMiFyxQlguwpOzzRLMmkTnp+rxExpX2qFR0OYWqtgHKrzINJN8XQceCFOnTqczh0j7hgsrjcXznFqmBj/7H+z1GVYttnLaF4AHbjQHK7AFNVpt8ysLZ7LW4xyQT3cPf+U0kwmXmCgjaFIkXEyUIHz7K7o7iUUE/HrnoSYkRTZ6z2EHeddocMJBvDGOcd2BaxCSfuKlZb8Cx+SMaCQk5NYxxAeoMulgPRnj7lMGXrd2x4rI09od/IcR8fdNXkPabDf9tVO602le4KUV5E7PJYssCAyt1BHxbgNcAfXLr7K/KtwQ25bglofVeXg9ZKml/Xc5wNrB4yEjlGJyFmHYZRNoqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(31696002)(966005)(31686004)(53546011)(2616005)(508600001)(110136005)(6486002)(86362001)(26005)(186003)(6512007)(36756003)(6666004)(316002)(82960400001)(921005)(66946007)(66556008)(8936002)(8676002)(66476007)(38100700002)(5660300002)(83380400001)(2906002)(43740500002)(45980500001)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEFnMk9UODFLRVZxNmdsWnVBdFJTdEhycEhwZEErQTg3OEdNTUpoUS9WbXo2?=
 =?utf-8?B?Q01TS0k0NDl3eUtNTEo4dFVGaktCOU9qLzcwRk9JcStsajlrVUMzcG9CcnNS?=
 =?utf-8?B?bGZMYm1PY2NDQkpBKzB0TVJQM3VOM0F6NnFRbnpsWlk3QXZpRlFqTmJRR2t0?=
 =?utf-8?B?dkFFb1FsOVM1SUJSTUtaREJNY1VHZXo2dnYrQktFMnQrZy8yZEs3RjlvNkpX?=
 =?utf-8?B?QkdsYXh1dExBVHd6QURscGMxZDNyVWVEOHpoUy9qSEliMkhDWStNaElIb3hu?=
 =?utf-8?B?UGVRNUNjQXlJZm5Ub1RYalV0VjVxTzlhWUh0ZHlnODNBTTFYNXE1bndjWVhh?=
 =?utf-8?B?OGpSZS83NDhKa0h5NVRYTEgrZDBtbkd3dHl5T1d6TUZvcnpwdW1TYjRhbTJQ?=
 =?utf-8?B?U3dWOFBkQUpOSXo0Q2dRUlRrNGl3SGMvWnNJS005SkpnamVtNFdqMFhwODRm?=
 =?utf-8?B?QnVmMFNEUUNEMmtqQ3hxcGhWSHBZdE1RTW5jVjYyZ2haWllVV1lxd0o0TVBL?=
 =?utf-8?B?MUtFdUFxSjQ4RHhaM0k5dy9NcjgyK0xsQWYwVWlBZWZHblFxeWo2VXplWEQw?=
 =?utf-8?B?TVZpQUVjelFMY0FkYWFWdGlBWGJnUHdITDBxQ2R3eXd4c3ZFcExOZzAyS3kw?=
 =?utf-8?B?cDN0M0ovQk5KUDQxbjRDY3Q2TStYd0lzdXg0ZzdYNHE1U1JISVQzQUNrQUdl?=
 =?utf-8?B?bjF4OThFS0JPOVVJc2JVa2NwTXdXMXhHaW1nNVBCU1ViTlVDNjBLb013ZktL?=
 =?utf-8?B?blZ6UmlXZTg1cjkzRzgwZEhEaXJvYXdabzQ4RU1GcnBiZGpWaU1aRlFLVE1r?=
 =?utf-8?B?ckFISXFidys0b3ZqT3daUWszT1hqUjFRaHRGTG5EZ2pWUEdDRElQNkE2SEw0?=
 =?utf-8?B?NzMzc0FLSHVRcHVVa1Z0b1VIVExJVmtkU1kvbVlMUkFMbFA3dGVsdExPTW12?=
 =?utf-8?B?TkVLVk1HbkhMK2NGOWEvdjFJZkI1NkVFa0NhZU5sWFBtVDZJMkxjS0FOcUtv?=
 =?utf-8?B?K1FKVXQveTFlaVgxRDVzY3lremJTNE9VenBDaGhkRGxibVFmMW9MdUdyb054?=
 =?utf-8?B?Y21nTUgxbm9hU0VzeHpqcm1qVUhqY0N5aFB4Mm0wd1pPU3lRMXpUeHhkUi9D?=
 =?utf-8?B?VEt4VW15R0xBRzcrVUQrcTYwUUlyK1hJTUlhSHVWSmhqSW81eEVRdnhJdmlt?=
 =?utf-8?B?ZldOaW9wZ21rMFFKTDFsYjM3aFB3b0w0aEVvM2FreG1Meld1Qk1LR1VJSHdj?=
 =?utf-8?B?ajdNbjROSGdKQ0JoenliWjNXck1KNEFNbWlkTjRTSUphQU1pYXNyYUxwWHdB?=
 =?utf-8?B?c1c2WHlCN2dlajdnWmYvMnpML2RtMlNZUWhsTjJtVkEwS1Ftd3o2T1FzaEJz?=
 =?utf-8?B?NWdYdkt2bFREQzVxaEh4RUVCZEdsV2hlWjMrdGdrTloxbzBZSkRlTkd4WEg1?=
 =?utf-8?B?aXMrM2JnUGFCNTZHS2gxcGYxdGdocUZQczA2LytMZnpoNHNKeU5vQitFcDli?=
 =?utf-8?B?c011V0hhbXFyc2ErRVJXQmJEVjBQOVlGVDVqNTkzTmhXYy9kUlh2QWgrQ09w?=
 =?utf-8?B?eVBsb1pIWWFVWGNnMFN1b09yY3hDeExpVjRIb0tXZGdIdXBlb3UvdTJjNjlm?=
 =?utf-8?B?OG5vWmc3WXJFMjZ2WkVGYVhwTjB5R010UU43V2pSN2FIbHVjNHNObDdVRmg5?=
 =?utf-8?B?UXdGMDA2VElMTk1JaU15SVQvbFpXSERJbFFkRTZtTHE3SEVnZUwrTHcydk9Y?=
 =?utf-8?B?MUx5Zi93Z2x0MFFxY20vVlRwV1RaYlVsN3V6NTNsb0pGRld1VDRxQU5OR0FJ?=
 =?utf-8?B?cStSN0RENXkxRGpPNkFzZWlmRWFRZHV0b3lCMURodUJ1QjF5VlFjN1poM0E5?=
 =?utf-8?B?SnQ0S1J6MlAvc3hUZkpNTkVPdVE4cFVxOVBOSXFpZTlsYXc4R0tITFRiTFJy?=
 =?utf-8?B?dC9vUzFjekJxK2ZGYThrYlVNWXo5TVJIZmhGQ2l4TWVnZFgwQTVNcjllYnZu?=
 =?utf-8?B?SGdvVjdEYXpYdHRJenJ1OC9GZ2FUSllibkxLMEVCU3FSY1R1V1BKdUg4VGFE?=
 =?utf-8?B?R0RVUmNGR25nYzBaN2NVL2dSeUkyY25Ebzd1SmZlQ3dHcm03UmVZUUhyOC9P?=
 =?utf-8?B?T2Rkbkc1L0hmdS9McXRzS0JtaE9WSWx6aE16ZjBvT2xvcHlxSTErMU5zcm1E?=
 =?utf-8?Q?CXV1l+BJN3cmQU5wOwxKWpc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f70da9c0-dde7-437a-3369-08d9e4a79b0d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 10:51:16.5234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k+Aju8c0NJkTAF7rsVyfKJKZ5iNMJajfYHnCu6SNZ4aShfa4hoZMMo2B/4w/n/93ZhahKyQBHyrQ7KWkBJ+l/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4393
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/2022 17:08, Thomas Bogendoerfer wrote:
> Commit 4051f68318ca ("e1000e: Do not take care about recovery NVM
> checksum") causes a regression for systems with a broken NVM checksum
> and hardware which is not able to update the NVM. Before the change the
> in-memory copy was correct even the NVM update doesn't work, which is
> good enough for the driver to work again.
> 
> See
> 
> https://bugzilla.opensuse.org/show_bug.cgi?id=1191663
> 
> for more details.
> 
> This patch reverts the change and moves the check for hardware without
> NVM update capability right before the real flash update.
> 
> Fixes: 4051f68318ca ("e1000e: Do not take care about recovery NVM checksum")
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---
>   drivers/net/ethernet/intel/e1000e/ich8lan.c | 21 ++++++++++-----------
>   1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> index 5e4fc9b4e2ad..613a60f24ba6 100644
> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> @@ -3808,6 +3808,9 @@ static s32 e1000_update_nvm_checksum_spt(struct e1000_hw *hw)
>   	if (nvm->type != e1000_nvm_flash_sw)
>   		goto out;
>   
> +	if (hw->mac.type >= e1000_pch_cnp)
> +		goto out;
> +
>   	nvm->ops.acquire(hw);
>   
>   	/* We're writing to the opposite bank so if we're on bank 1,
> @@ -4136,17 +4139,13 @@ static s32 e1000_validate_nvm_checksum_ich8lan(struct e1000_hw *hw)
>   		return ret_val;
>   
>   	if (!(data & valid_csum_mask)) {
> -		e_dbg("NVM Checksum Invalid\n");
> -
> -		if (hw->mac.type < e1000_pch_cnp) {
I meant: change hw->mac.type < e1000_pch_cnp to hw->mac.type < e1000_pch_tgp
> -			data |= valid_csum_mask;
> -			ret_val = e1000_write_nvm(hw, word, 1, &data);
> -			if (ret_val)
> -				return ret_val;
> -			ret_val = e1000e_update_nvm_checksum(hw);
> -			if (ret_val)
> -				return ret_val;
> -		}
Hello Thomas,
For security reasons starting from the TGL platform SPI controller will 
be locked for SW access. I've double-checked with our HW architect, not 
from SPT, from TGP. So, first, we can change the mac type e1000_pch_cnp 
to e1000_pch_tgp (as fix for initial patch)
Do we want (second) to allow HW initialization with the "wrong" NVM 
checksum? It could cause unexpected (HW) behavior in the future. Even if 
you will "recover" check in shadow RAM - there is no guarantee that NVM 
is good.
> +		data |= valid_csum_mask;
> +		ret_val = e1000_write_nvm(hw, word, 1, &data);
> +		if (ret_val)
> +			return ret_val;
> +		ret_val = e1000e_update_nvm_checksum(hw);
> +		if (ret_val)
> +			return ret_val;
>   	}
>   
>   	return e1000e_validate_nvm_checksum_generic(hw);
Thanks,
Sasha

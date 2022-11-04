Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21D7619A2F
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbiKDOhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbiKDOhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:37:13 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071A46548
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667572492; x=1699108492;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v2aDk/VgdtM7QJtVXNNpLHHnhTpXH7FZMFIWfUlVqzQ=;
  b=SwfSqjgsodXlhxqsEpCkvZUCwiRaiZdpUHb1cAhsPAWuMLTJcNMrkUx8
   V3SG61dwI05pcl9U9/nZnhlChGPm6ibw1SlA4+M/CVPWbEyXqJxjtJ81E
   c41sfQCP4QzvMIxUuwz5/uu8DzSj3IoYsKCO3gK/ZexwmwhbFBaXW5+N6
   icC6I0ESA6+Axm2/NYPKCdO4QiGW0eyE8Q5VwukXuEXC4GVUcCuPOFFLH
   WDlXcGtCKj/qx68UGld5M3WKLvuJD2SBk2cy0lFpzrqbce/hnM5pqZPr+
   t+5C/60iDeFi654AMJM9QqkiR+B571WURZ24nen9quFM5l1N4DezfjRGV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="308691345"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="308691345"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:34:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="760344223"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="760344223"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 04 Nov 2022 07:34:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 07:34:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 4 Nov 2022 07:34:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 4 Nov 2022 07:34:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3vn+Ll0rfr+rcfXFcgzcr6yR0f9YEAn+ohNt2dev7FtM7IzG0dDviwQaL7zlQ8visA14jKDcZxWp5j6UTwDEemCbktxOSYHrndQZwPxWWIYgs4T5UP/9LVH3huS/DUWk23TqahdfYlIs5oB8vLj2H/PoffUzod51L9sD28NVLHD4zct1sXrnKczV/rnH/cD12ZgpnBUX4mXe7X3lQKNbD1/bnVxfI+C6SoS+XbDgG3uqDszULuy3qW1LG2aO2L+b4RmUeaNnfsuPEsGtpLYI7jSD9FA8YFIm3NemVaVP8q07ozx11/rBtNIOXTlnWKi+8LOIVkUOevNiUy1qVSHhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mhNcpisXQVHwsVF5WcxNV2wH/K7wZk5OiTCsfTf0bOI=;
 b=Ytn8u0zIbEwfqHYptWgitPsaGdQY/p/qc5JVXI+c1rplZkAf4WGlFc3AftTzwIgGZ2SgHkpp7BbISsx9tMCnskP5MFi+hujFOIxkfEiDkRO78q4aOSf2QDPwJ59Xf+7DMpvJfSQcntkLTEn+nlEkePdYBjlxPp2RZPXkX6dHdRODnKeZ5u8YkkxafnNDOSrJZQkkhykg6YSBgycMUzDA+zLh2SgskeaABv09QTSLT7z3nwHA5S3kJfqhywL+1hiIDvLlmEzJwr/ykPxydCRmDBYKqaKqiCW8I3IuLvkLIGVkGDtHm4SkXPlTbyLNVgapquNCDWbIBX1K/GpiMhvZpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by BL1PR11MB5509.namprd11.prod.outlook.com (2603:10b6:208:31f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 14:34:42 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%8]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 14:34:42 +0000
Message-ID: <5b9e1247-ce31-bb8a-b787-bb7b9a92f03e@intel.com>
Date:   Fri, 4 Nov 2022 15:34:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v8 3/9] devlink: Enable creation of the
 devlink-rate nodes from the driver
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <kuba@kernel.org>, <ecree.xilinx@gmail.com>
References: <20221028105143.3517280-1-michal.wilczynski@intel.com>
 <20221028105143.3517280-4-michal.wilczynski@intel.com>
 <Y1+hLUPkXn3YWIlA@nanopsycho>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <Y1+hLUPkXn3YWIlA@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::7) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|BL1PR11MB5509:EE_
X-MS-Office365-Filtering-Correlation-Id: b8bae399-2579-4027-80f6-08dabe71b62a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ke2j2w10VqfiJPxwk1cy9IWXUMxk/2CJohlcpAClMT3gTnHQQ99pXjNDW7o2ML5Ol7EKJpVO69XHNvuuH/Ik7rGrHSX2zbfno/OJCOYA4vIV8w0deduc4UUa99Z0QszeVqiYlHGAbrVjlkiSrQyk/AKwrzKlHWJhlxZQq8eesJnDuFkxFVN/1JfydWzbDX4SmjANPG6EaA5JXETZ/doY1YLkBYd+wyLSuCEn/ubaQmwFNXmIa7raAAT9b4YT3wEu/XZbS610oC/CnvrKEgMP+t/YuVX/qSSkXZna/OA7kiVqi+ZYUOva/c8H96Ab21rpZAytbmYNjXvng9tZ0n6qnBqDk57R3z032ub9IRGmvZ00bbY3+OvaRRakDVDNuDHEg48caxVs2UVm9BOci9EOmAbX0PhdltcIlrnsOLNG4mkPAf8mSKaTmDoHgDlFHUDDpdj7ZC/Jtjva1B+X73vn0fcxxef1bna1LSCxuVtpTF1M/r+dkgv9rFzAHnFSepuLqVc3K7HTPby8b4+FciPOauEn6NibNVy4UbdHGxL06HhudYBznY0bEVcEpRtsdm/MuQaQlwdJpaB1/vV3nG1iSs6tuuBvjpaeYizBuE40L+wU6xfIDa7yNQFFKSPcPAgqhOd1l9YnYQXUQQxZuuXxsOrJ3BgcY+iwyokawu9RQk5bio4FZFDYNMeZ1u7qAXaPVSByzAlgxcnerperptcPBnJxkGG85ATkZD/YvViu8eWz/7I+ClbSNp82nreJo41ilNO/w1ixrn8AfUVLJvxmRjGOWgbUYkYcvr6b/vMc/AI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199015)(316002)(186003)(5660300002)(2616005)(83380400001)(66556008)(66946007)(41300700001)(66476007)(4326008)(8676002)(26005)(6512007)(2906002)(53546011)(6506007)(36756003)(8936002)(31686004)(478600001)(6486002)(82960400001)(6666004)(31696002)(86362001)(6916009)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHhROFB1OStYbHpJem4vN2gwQ0VPbDVJS3hPbEZKeDBoRnNQRUZzRzY2UkNh?=
 =?utf-8?B?c3NZaGFZcXBVMTJma0tja1Q2VFYwVDhvcTk1d2xncE9VTWtEVnMzcGFRc2Jj?=
 =?utf-8?B?cndDUDkwNFZuMm1CaFJ0N2tlbEcxU0NHcGdnMlNRNElXWjRkZEhhVUFTQXgv?=
 =?utf-8?B?dWJFR2dqNnJYdmNqZ2F5RDVFNHZJSzB6Znlublo1UXAzOHYxUjA0dmR6aHdx?=
 =?utf-8?B?QWVDa0liVHkvdmdtdG9rUGNHYklZeiszTlB5dmhIOHllY2tJZGl3dmI1R1ZM?=
 =?utf-8?B?czRUZ1ovRTRzZnEySVp6V0RKMjVPNmVLblBHaStGdDhEdlRjaW05NG51aXpW?=
 =?utf-8?B?T28vNmErMG1BZGhtcHB6NWZ3dVNNcTNZVHRxWTUxdlNXdXYxTmRMa0RDWnlH?=
 =?utf-8?B?NWFla3kyRVZUbE9JUzYrSm9FNDF5TEg5SFRmaUlkUEJ6Z1RTaUdLcy8xYXNz?=
 =?utf-8?B?T1BLOCtDWTBjMjZhamJlemI3SHk3SW9tekJNL2RaZHB1ZjFWYXp0YjNsY3Rv?=
 =?utf-8?B?SlZuQ1FsQUpYeGhoSG4yaTZCYkhjbTNRYys5eDZrMDdkUEIxdUpRendpT3Z6?=
 =?utf-8?B?QjR0aVVJdERkazRsS2RVTWhFZVd0VXlKVDZnaC9adEgwcHhLUkQ1bHpwVDln?=
 =?utf-8?B?WHdtV0JuY244S1haZThuM1pIUFU0NFlPQ3JwT2ZOTWZFc0pQMVlRMlY1YVFG?=
 =?utf-8?B?eDJpclE4b1djMkJ5REh5cDJjeFRZOXZHWjZ1TXNKQUpJVSszcUJ0VG5tZWo5?=
 =?utf-8?B?WklBNHRoVHZoU0llclUrZ043WTE0MXdoYUU1RFhLb3ErUTJLcjBJUmRKZytE?=
 =?utf-8?B?MTBySFRMRkt0WHpzRVNodTM4Nk9NOUUxeFlRc29JOGVYWG16dWt1SDgwckND?=
 =?utf-8?B?YjFNWDZDeWdpMU1DY0RicEtQSmlvSUlnV01QL2l4SFFtVWxMd0NRUEM0OCtm?=
 =?utf-8?B?Z3FhaVdwbElSQVd0ZTBQSk8rT0JHbWdFUTE4Z0lXS1dtd0UzeW9MV3JEVndC?=
 =?utf-8?B?eVZITmFmQm9HMnQ4cWZiSlJZMGVtOUgzbVlmNVlxbFo5RVV1VmJKV1FxVmlW?=
 =?utf-8?B?RnJjSmVmemxsSHFYL01PTzRXUXMwN3BCUnVmUHZVMVFPWWdYZXg2aW5TUFVT?=
 =?utf-8?B?WFJVMTQ3SGZWdDVuMmw5S0hrT0ZMRkN2TVdwb2crZ3dCd255Zmh5Vm91aWhs?=
 =?utf-8?B?UVFwUmpzWlBocDhidktMY0Vub0NkaXppZGhHUysyT3M5bXgzOVp1NmJKaStQ?=
 =?utf-8?B?dVJZbGJZNndmNkU3MjhRMFVJczJTeThnaEROWDYwV1BTbXliYm01akFRSXNn?=
 =?utf-8?B?aG44MVg4M2J1cUxkeXFSZTBxNk9ya2tQVCtieU5QSWdTUXZuOXdYa2NmS3BF?=
 =?utf-8?B?Z2lSMFJwaFZGcFNTVHhjaE1GdlRzOXR5OTNsQUpxeFR4YVIySi9kRXZJcTd5?=
 =?utf-8?B?WmtpLzM0U2tBSi9TWXk4M1dzQlg0a2NmNVFpRjdFUlpQQ1lFWnNhQUN2SU1O?=
 =?utf-8?B?bUlPUUxMa0t0ZDBZclB4NkI2QTFpV3dMVW5zOHIwOGQvcDRiN3dTMWpFTnVC?=
 =?utf-8?B?OUVTM2FzU1dEOUFDQ3dWV0FMZmxZOGhQcW8vTVN0ZUdtdW10SjExU3hjd0Jq?=
 =?utf-8?B?OVBhQmcvQXF5a1JGaXlpeXZZdUM3YlFCRFRWOTdzL1FyLys0aFRVZTJxbGdp?=
 =?utf-8?B?U3doRGE3QjRZYldxMFJFc1pRbkVKQmJhVWh6YlpVMHkvaXBhOTg3aHNWVk5Q?=
 =?utf-8?B?VHROdmVvbEU2Y2FkcFcwdkl4MXNaaEFFaHY5a08rS2gxK0ZjSmxNRDlMWE5S?=
 =?utf-8?B?ZDZGRk9tYjUvSyt2VnRJdmR5eG5JL0VJelQ1ZTlxMUFXeEhVZ0swbGE5ZDl2?=
 =?utf-8?B?T2NRZ0cycDhMQnlPenFGNmFhWHYvTUc0NzNzTmVydkJva2ltSWJmOVpKdWtv?=
 =?utf-8?B?K2RSOTRsRE1QSWhBMHBETW5Iam9JTE9uS1Z6Z3JHZjEzaGJmQnpTUUxndVBW?=
 =?utf-8?B?MWFHYUxNQ3VrWHE2eTJ5d1hCZ2ZXNHNaQmV3SXQ2ME14b0ZDTW9IeXRrSmFq?=
 =?utf-8?B?ajlLRDlod3c1Rmd3OXRhZHNjT3ZKdjdEcUxCdi9qZnp5TmRad0lwN2E5NWRp?=
 =?utf-8?B?Tk8xM0I3ejlZVTUyRVVMblNZYXVBYlYyTHNyUmpIdmFjZnlxTXMvMGFXZHdW?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8bae399-2579-4027-80f6-08dabe71b62a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 14:34:42.8013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6jQcmeb7kinBB9FDX5UhqlQjD1hGcO+VMwXy/3XhY3dvWXyyxJBUjqkSEGgCjO6kDzCH6HrsRz9MU7vtpPkn3mHIl6JmSi06XvMHalQKxt8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5509
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/31/2022 11:19 AM, Jiri Pirko wrote:
> Fri, Oct 28, 2022 at 12:51:37PM CEST, michal.wilczynski@intel.com wrote:
>> Intel 100G card internal firmware hierarchy for Hierarchicial QoS is very
>> rigid and can't be easily removed. This requires an ability to export
>> default hierarchy to allow user to modify it. Currently the driver is
>> only able to create the 'leaf' nodes, which usually represent the vport.
>> This is not enough for HQoS implemented in Intel hardware.
>>
>> Introduce new function devl_rate_node_create() that allows for creation
>> of the devlink-rate nodes from the driver.
>>
>> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
>> ---
>> include/net/devlink.h |  4 ++++
>> net/core/devlink.c    | 49 +++++++++++++++++++++++++++++++++++++++++++
>> 2 files changed, 53 insertions(+)
>>
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 929cb72ef412..9d0a424712fd 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -98,6 +98,8 @@ struct devlink_port_attrs {
>> 	};
>> };
>>
>> +#define DEVLINK_RATE_NAME_MAX_LEN 30
>> +
>> struct devlink_rate {
>> 	struct list_head list;
>> 	enum devlink_rate_type type;
>> @@ -1601,6 +1603,8 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
>> 				   u32 controller, u16 pf, u32 sf,
>> 				   bool external);
>> int devl_rate_leaf_create(struct devlink_port *port, void *priv);
>> +int devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
>> +			  char *parent_name);
>> void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
>> void devl_rate_nodes_destroy(struct devlink *devlink);
>> void devlink_port_linecard_set(struct devlink_port *devlink_port,
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index b97c077cf66e..08f1bbd54c43 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -10270,6 +10270,55 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
>> }
>> EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
>>
>> +/**
>> + * devl_rate_node_create - create devlink rate node
>> + * @devlink: devlink instance
>> + * @priv: driver private data
>> + * @node_name: name of the resulting node
>> + * @parent_name: name of the parent node
>> + *
>> + * Create devlink rate object of type node
>> + */
>> +int devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name, char *parent_name)
> Nope, this is certainly incorrect. Do not refer to kernel object by
> string. You also don't have internal kernel api based on ifname to refer
> to struct net_device instance.
>
> Please have "struct devlink_rate *parent" to refer to parent node and
> make this function return "struct devlink_rate *".

Okay, I changed that and re-sent. The downside is I have to
store devlink_rate pointers in the driver instead of just names.

>
>
>> +{
>> +	struct devlink_rate *rate_node;
>> +	struct devlink_rate *parent;
>> +
>> +	rate_node = devlink_rate_node_get_by_name(devlink, node_name);
>> +	if (!IS_ERR(rate_node))
>> +		return -EEXIST;
>> +
>> +	rate_node = kzalloc(sizeof(*rate_node), GFP_KERNEL);
>> +	if (!rate_node)
>> +		return -ENOMEM;
>> +
>> +	if (parent_name) {
>> +		parent = devlink_rate_node_get_by_name(devlink, parent_name);
>> +		if (IS_ERR(parent)) {
>> +			kfree(rate_node);
>> +			return -ENODEV;
>> +		}
>> +		rate_node->parent = parent;
>> +		refcount_inc(&rate_node->parent->refcnt);
>> +	}
>> +
>> +	rate_node->type = DEVLINK_RATE_TYPE_NODE;
>> +	rate_node->devlink = devlink;
>> +	rate_node->priv = priv;
>> +
>> +	rate_node->name = kstrndup(node_name, DEVLINK_RATE_NAME_MAX_LEN, GFP_KERNEL);
> Why do you limit the name length? We don't limit the length passed from
> user, I see no reason to do it for driver.

I thought it's safer to limit this to avoid buffer overflow.
Changed this in v9.

>
>
>> +	if (!rate_node->name) {
>> +		kfree(rate_node);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	refcount_set(&rate_node->refcnt, 1);
>> +	list_add(&rate_node->list, &devlink->rate_list);
>> +	devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(devl_rate_node_create);
>> +
>> /**
>>   * devl_rate_leaf_create - create devlink rate leaf
>>   * @devlink_port: devlink port object to create rate object on
>> -- 
>> 2.37.2
>>


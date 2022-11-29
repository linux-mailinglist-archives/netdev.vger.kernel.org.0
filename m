Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580CC63B666
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbiK2AKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbiK2AKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:10:13 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEA8C6B;
        Mon, 28 Nov 2022 16:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669680609; x=1701216609;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kP5O5mO/tlGJUo9cqF/lFq+Ja8amYbotb9KjtGajGBE=;
  b=Pq8TvaEXEze9BxE01mteV3JnObYS2iGUG1z7Am9hbRSv6xL0z+P03O9+
   3MEcT/AH5/Vb2qfpgkmYNkw3ejUd8U8o8NCg6hBmQZ2s/7Dhccm1okyAV
   A4QlMA9a2xq4Ozqz3DbDgx11uUg5w5NNMwTjd6zsH5A0bbSkcz5sehR1R
   er0lwtYpOWebvdR9sGbcxbiV2taTFgoTXpZEDypwezjt+euSEBoseDQHK
   5Zzxvf+/ZcuTt0SIkoutSNrbbdTkO4seWniGjKUi6F8vAusJFFJM5sNdy
   053mkMJLvIGBGKKHkiRfK2ztWtd069ERbH5yDx7kb8upYO65j3JR4H8wZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="316814646"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="316814646"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 16:10:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="637408042"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="637408042"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 28 Nov 2022 16:10:08 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 16:10:07 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 16:10:07 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 16:10:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EI39terbWCPlzaM4obAoDrdkdWurUAgxY9HnrXWAgko37clfCPSUJJuVxJjSknm9kkmJ2GavCMqhgQ3Zv8JTISu9c0KDUFJMw0MA8tX+eWgtOMfMHt1kQF1vtP1hy9ada/SLqPSYZsB+MAVmoTNBP+5N86uMX7H2nNv7AsHWmssGEHE1aDe4D31qYtyDjQ4RUJLam589hiGCIaBQ6C3/3C1OwdQ6CHq+hyGK7JHtu0l6wiv/XepbCDcEytNGIt3+Ka1nSHQBilWEW3pIYnGVH1Pck5loSP96S9q6jB1TrfmdvUY5RR1tTwm+0aGgxaX6QRm/jYjFFvX2f8qSoCz2tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xayloidaq0ydo/kvdeYeKIIFEyf2TATkjpecmc3hS3Y=;
 b=DTAv7N6uO/1ew+LC2xBoxt1dBXKDwUNXP7PH/ajhOy3CgKDiH+IRUyC4Ed695G5Ltd0lnON1TYb1HfgobX8w8lqh7NNKy1zvk8Jh9X+F2G3/arhYn9+fNyuaOZVLt6BSnBaMMPUboQJ+yUGZGlyA4yG9d3ijQN3+9z90pCrKjZHDK/LZS4ZEN9AwNLZOoAkqINT8E0bKadD0QIslQj+BH1Q7Ca+CWJL8ThN9MyJb0FGPmVlyGIWgg01AQ0cQd8+38oETyx08t3TiIMsnqOjnTqMwXmO05CMcex8Sy6FoXqkeMZComVeMr7QcnIxOSXGeaIj6If4JXeeBFfu4cSh/dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by IA0PR11MB7378.namprd11.prod.outlook.com (2603:10b6:208:432::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Tue, 29 Nov
 2022 00:10:05 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 00:10:05 +0000
Message-ID: <7fe25f71-9c14-0eb9-3d54-5d03ab837d53@intel.com>
Date:   Mon, 28 Nov 2022 16:10:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] MAINTAINERS: Update maintainer list for chelsio drivers
Content-Language: en-US
To:     Ayush Sawal <ayush.sawal@chelsio.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, <herbert@gondor.apana.org.au>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <fmdefrancesco@gmail.com>
References: <20221128231348.8225-1-ayush.sawal@chelsio.com>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <20221128231348.8225-1-ayush.sawal@chelsio.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0161.namprd03.prod.outlook.com
 (2603:10b6:a03:338::16) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|IA0PR11MB7378:EE_
X-MS-Office365-Filtering-Correlation-Id: bcfe0ec1-667f-4ddd-cbad-08dad19e1172
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o9K1Xna3A+a8S9tYfUGmdQ9SJSlUsB7oYpMyDO1NyZisHJtcOGlXvi053P3SFqPPZ66TEEOx1FPiaEhLASiBF9bRTwlN+MZweV1UvY6XolHYmOBEQnvETp1eTk+plQzgYmm3kxM0dKjKU+PnD1myPz2PVXJSDif7DaNpGorgTr7xFDF9xNi0Pnwk5hePD8wpN3/ByxI2FHZ7F05RwN5Kcd/JdOO6JWg8Zoy6L5BqxRw1u5rOiW4wo6Is90sL6KmLWdCxnYo7SWhzRiZCPjzMR5IvmgG03IQLTMQak+pO7ooU0/Mvy+A+x7p2jWN2YkVXxRrjuo8KAW7t247tqGDBWQ6MJukigQlKsbLRVnmM1FjTM7SoqPCD8COYJgnkz2Fg39jKyeewMbgWjtVWGjldjTe/kqCkuDlrGVZ4ajGJsH31xk3Mq3AAYDtS1K/L00ADZp8A1j/SyU9I8OK53Iy9xi8o/CxrKz4fCF7MxjeMBbBkw0BbAPZ/uEqveWiAguaal5S+kocUSiTQmAJZkez+z9i5GiVzyo1jxsoP+tXd2UIwZ/77+5eW8/Aj9Uqf+fzioQeujeCe2mR+Jh/deWI/CFte0rqnMk/Vk/TBuT3iUP6pHFTRNuiwvv2rpNx/YPEy+c9+kYCD5ivitUpaaNc1IypTSJ2ZhtqOCvarSvvQfYYSaurCYXf+YGoF7XGOZgcLdtLPeQUsCXxReokwbwMDEYMdAGScjtUMkwJi/vDOvOY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199015)(15650500001)(31686004)(2906002)(44832011)(4744005)(316002)(5660300002)(36756003)(66946007)(66476007)(41300700001)(8936002)(66556008)(8676002)(4326008)(86362001)(6512007)(6486002)(478600001)(31696002)(6506007)(26005)(53546011)(186003)(2616005)(82960400001)(83380400001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SThoOXNwSlhmazhHbDZ2d0pTRityQkVRWllEekFqV2FmaTB4K2tqMDgvbzJC?=
 =?utf-8?B?QnZxeEdvWTZwS3hhZHh6L0lKME9MWm45bWlIQStlYmxkR2REdm5XNUJTN05l?=
 =?utf-8?B?bkRGNUtIR3h6ZmhvQVlxZ05qMXNydm5Hdk1PTW8zZFJZYUIwamdUVngvWHFE?=
 =?utf-8?B?RmNXWTBDUEtCeWdKQmJLNnk4VEZ0dUFiQlZ0TndJSnZtVEMrVktrQXlSY2g4?=
 =?utf-8?B?Q3FNU3czVHRCRDNtMlJBR0x1eXkrcXh4RFY5TWVtUXFGa29ha0I3T2p6UVpj?=
 =?utf-8?B?T2Y5THlYUUN6WjJKTUM3eUZkYW40TWdkWmRQdWpGVFZLWWc0TDBOekoxSjBj?=
 =?utf-8?B?aWNRcG4veDVWT3JMdlc0eFEzNWtHcDV4Z0ZaMUptdC9iOExuZGhFUTFKWEcy?=
 =?utf-8?B?TDBzdDl5dHBKai9NRk5iaFRiT3Z3MnFCOGVteGV1V3pKZC9DU3I4MkF1c3Vy?=
 =?utf-8?B?TzRTNjFXZFRDYWs4VGVoaVhSQlo0NUxadHExT2NxY2wzSDVwSXU3TW5iaHJQ?=
 =?utf-8?B?b2NRdkJNZ2tYVWh2c2tGMkN5cnZEZVF1Ty9Na2Q0RFZCNXFtaXZxbmtmY2V5?=
 =?utf-8?B?WnJIbzNJTy9lN2lvbC9mMCttQlRhOEthTWNsdTIwMTJ6K0V4S0tNUUFRN0I4?=
 =?utf-8?B?U1Q3dWhtRVJTalBnWTdKS3kyNVFnd2lxdjdzZVVkUE1mOHJQQzNOYzk4SzZw?=
 =?utf-8?B?MlhPaVFTSzVaM1prNUtkTjZkRG5rUjJOT2RQak5aWnVZYVpNay9aWGFDZTg1?=
 =?utf-8?B?b1NCbGZNb0ZIK2ZaRGFJVG5Oc3FHTlF3dE1mVm9vV1RDc05RNFJZcTh5K204?=
 =?utf-8?B?dDdmWUdLWVdQTEJrdjV1a3d2Z3FpQVpOa0l4Z0hyZW5Cc1VERzBabFd3THRo?=
 =?utf-8?B?b0xXMWN3eFBWcGNvTTlVa0h6WkpXeE16RXFMb3VGUU85dDR6SkVoby94SXlF?=
 =?utf-8?B?U0RxU3J3c3dsckpKSk1nNnNjellRandNNHVMNzY2MHFpKzRqVlRMTWduR09z?=
 =?utf-8?B?YjB0MllGYXpTMjUwanF0MHFCL0dCaU1wbFdhTTlVN3l1UG0xT1BhazNoZ043?=
 =?utf-8?B?d2p5aGgrNG1JRTMxOVU2ZVM0bExSZFduYzhpb3diUHorMnpXaEVMR1ZIUmN1?=
 =?utf-8?B?MStPdWp6Yy82SHNTU1ovMC82VXpwUGtkNTBocXdmU2tKcSszNHFpR0xMWWJm?=
 =?utf-8?B?N1Y2S21iem44WmJHMnd5VDJMU0tHTlgvZjBwSkQxSytrcFZUdzZEaFZFdnlE?=
 =?utf-8?B?WGZBa0ZrOXdZWHk0c251aURtd0ZUZ2Z0SHJXeUE0NXpWU3FqR1pOSUNRYUhy?=
 =?utf-8?B?ZHRmZFVodzRYZGd4UURBeXZTckdEMVE1aG5admRld3BPSXdnQ0g1VEZoUExQ?=
 =?utf-8?B?azI2MXZuMy9LaXZORkZWM0xKdzhxV1VHR3FzSVhmN3RyYmk5bVV2cTVSZDVS?=
 =?utf-8?B?Wi9LZmk1UkxpZGo2S0wyR0VzNnpzS1I1VHQ4LzZkdktORGh6U0lnOFNFditX?=
 =?utf-8?B?RmNJVEI4bk4xVVhOQkd4RTFSVWdadFJVS1dUTi9lRHZqVmoyN1F5RXptRlp1?=
 =?utf-8?B?b1B6d0lhNnFvUk0zZjZFdFN1eDltaUpER2Z0S2NnK052OHBrNUNHUm0vVjBt?=
 =?utf-8?B?UVZWblVBOVN4NUtOUlFmaUpVblZxU2JSOE9lcHM5dHBLVVRyRkFGV3cxTzRT?=
 =?utf-8?B?TVhZbHpxckdIbmZsY1h5bGFxN1ZHWGhQTlYwMC9rdFdFT00yY29aQURQdUFm?=
 =?utf-8?B?NkNNUTRaZGhWQ2pWUll4ZFdORkFlL1FXVzNiMk9SWEZ3M2Rtd2lBSXRCNmIw?=
 =?utf-8?B?Sk1KMTFndlEwdEczR3pKQkE1Z2RFRTh1SUIydm0zRVczR0tKQkdLSjliYVdK?=
 =?utf-8?B?SndmQWdxL0xFTG1hYVBOcGFBeUloaVFKaHRGamtqaGlZbW93eHptcjB3N2JG?=
 =?utf-8?B?dmxkbVBQOFRjZmlWSWJRUElORWFOa1RZa21hUkZRMVpNVDFSWVpoZG13Ynlk?=
 =?utf-8?B?NDI2SEpBYnJQdmYvLzdWUnlzSENPM2p5OFNRSlUrUTdqYXpRRDNlL05UYVcz?=
 =?utf-8?B?a0lHd1pEOExpN3lQc09XeHdkNHNoNENPTDg5SzVIbU8razhFdmkwK2w5Rnlr?=
 =?utf-8?B?d3F1UFhBeVNma0xudGVsK3FmMkxEc3NMMG9qYXRFWXBuVzJxc0lhRUtZdnFt?=
 =?utf-8?Q?fWZdlqpb873+rvKvgItNjW0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bcfe0ec1-667f-4ddd-cbad-08dad19e1172
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 00:10:05.5682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LISc7nXoA+tJJPR5muh6QNxbxdBbKQL+eASttAr/OobE3/VrLdbKfGiB01Z7MxAz7L3A9FbgT41CY7ocLgutFyn8ox2/uvevNjLnsj9CICPG6ywGLKfD+jNJ0QM0O1Td
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7378
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

On 11/28/2022 3:13 PM, Ayush Sawal wrote:
> This updates the maintainers for chelsio inline crypto drivers and
> chelsio crypto drivers.
> 
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
> ---
>   MAINTAINERS | 4 ----
>   1 file changed, 4 deletions(-)
> 

Acked-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

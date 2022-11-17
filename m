Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7576B62CF9C
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbiKQAao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbiKQAan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:30:43 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B79F45A08;
        Wed, 16 Nov 2022 16:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668645042; x=1700181042;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=42p/gYGnfzgQDazy+WuxZbGqy/bbdgJeC9xi+ocfRD4=;
  b=fsk1d4UvuzRSta4ghyc9Qq0YegivENAoRTWiZujguuyvkAaXlrsNndGk
   V2h6mFcEa9ShNT75kH5UVTGRsnvw2SDXSdUzifB5mwwMKK+QeAiCpBQCt
   gc57R/LZrrlQLQCWOs8AEPMy39+ZSkZgMeGRFWa9T+r4J91yQrpXj3Tub
   kQQVX4yPzve7cCh/IZ3VvpCpFLqx/h+RflQGcZI3mYMdfDDpzXZKGsnbp
   lrW5tyUHlY9hl2Q8i8cBR64aHJXLSv93aqz9l6VZfMZxZ2xzWX7g6QHB/
   2QE6icQ9cDBrhusDz1Jr15XhRnf8dLwIp1/Nf9vALZ0A1yjmlXo5MI6b/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="292415009"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="292415009"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 16:30:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="633837854"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="633837854"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 16 Nov 2022 16:30:40 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 16:30:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 16 Nov 2022 16:30:40 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 16 Nov 2022 16:30:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JifAnNzlgv+CnFJvUul2CCUmsYL8NdLFSfAPj2yT0BiY6YoFumAKA+wdkg9xNf4POjFLTCosdntTjoQGdiqs+dMs12378/m7qL4L5DxE3GeFXptLIJTvRcltEiDDHhRkNyTOvaCB5CI5wmq6z+WRr6zy6xF3lHJ/+QRITX+x6k1zudoiFdM+lA2v1W0tSX+iK7zODL0km+HhzvKbHVWB7TL0dXCp5PodDeK1bZvj20XDbxxiwRBCF7xLlytHId1AMAQ1vRAIBu4XRfmza7lCAE5jlPtNxTEeAGvILZ7zBFjBHvKONwtupiw+ebO7Rpr3P1nYnuiB4dN/PXTwNMKblA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YpOA7C1FXrmkI5I+SUS1daj03sPStD5phZhiwBCPXKM=;
 b=QAN5sVEhe7PY7HQ4OFJtznga4RO+6V8yjdwcO/MYItyYkswKtHSUySZ2bnQiTK66LRU1nBoDOHQezGEjMaHlqbmd4WqfXuiKpV6vxttFqkk1+Ha9L5D7KtoNUMUHfaicqU39uHLasdU32RuFTGU0HDOCiiRXyA5sNt3cdMM9yOHZseYQu4XdBxfiCUeUAfuqvm5Lr1a7Jpi2z73DHheFBOWOwpve+IGH01nnkJP6R7f2hMf189ZD9L/FoIW1gTPK5Q7zlT4D2ovo+bEOPzcrIoW8Js9Xasi0xdgy7yOPBtHh4U9/ZfujK7eGTstcQh7aVea5GAF8T8O/W7XXaIyuAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA2PR11MB4922.namprd11.prod.outlook.com (2603:10b6:806:111::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 00:30:38 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%5]) with mapi id 15.20.5813.013; Thu, 17 Nov 2022
 00:30:38 +0000
Date:   Thu, 17 Nov 2022 01:30:26 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <magnus.karlsson@intel.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-11-14 (i40e)
Message-ID: <Y3WAos0k3iGJ1R7n@boxer>
References: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
 <20221116232121.ahaavt3m6wphxuyw@skbuf>
 <Y3V6OLY6YlljYZFx@boxer>
 <20221117002433.dvswqnfo5djobpfp@skbuf>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221117002433.dvswqnfo5djobpfp@skbuf>
X-ClientProxiedBy: FRYP281CA0015.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::25)
 To DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA2PR11MB4922:EE_
X-MS-Office365-Filtering-Correlation-Id: b0a30847-89d4-44bd-1b5d-08dac832f384
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Be9UjCer2z6Pf1h6DfVQT9/hKPcwimBl3R99u923AnB0slEo4g9c4uWEVgH5kANDk+/1oHRTapFBnTKl/1QGEVU/nb+W/gQYUuzwublOPCaEX0K1BXmkNW8KwNlcSpmC0bNZeOLC2fP1MrWataoOy1WlGye86SsK1CgzooWIdsg0YEBdZtyUdZoSKzFbhLb8vfROd0/yQl/q0LAbsZv+9CW3ygtSg681kbgts21+1kBvzHcDSpe2g+cTaBbJ+aZ4xIuoTIyprfng+TyKr4flrvC7s19D2+iBS+tfLUglwcUqO8b7A+N7CiI5C0oHgStCOeR8MthtyI90+8VJXbYzWOn7BFb3F0QXx6fFoH1Ry2OJtTzutgV2rmjrvlmSpZYIZYko6kSqeNxKNJxUNbJa5pc8YnAJHWkWdjNhF9dNrHM+W/ciEUHNtXizF8xwPBURPRoYhgzz0EZESylh0zn6wPCHCOMArGldM0EQFvTCrmLUnP08gpfIWzFQigSvEz1WErbzXac3q7kdqp6Hs4tjBlVloAmm2qCm1xxTkDFP+5FxxfVdeuB2RuZ5vqbIIZE9uN4Zz04UF/rH4xrvRby8ImduISQCatb4xMisNsGd6j6PV7ifS9jpkcp2xLLAhVQaON8UFoa4pnQo+Fo5GiGwfxFB4d1BrVkMgeFIBdJWLS4kMI1nXsuT9ChNLyWzJuhDoXcpKv8l1uojc8pGhifcSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199015)(26005)(86362001)(38100700002)(82960400001)(33716001)(83380400001)(2906002)(44832011)(186003)(6512007)(9686003)(15650500001)(5660300002)(7416002)(478600001)(8936002)(6506007)(6486002)(6666004)(41300700001)(66556008)(66476007)(8676002)(6916009)(4326008)(316002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8RBPd0GxdBOHiDPfZN+flA1CC8sVwhL3efrB4yqLHwUjD+bI/KnarKqnY+8G?=
 =?us-ascii?Q?LggEzVZAa517SdNnBuI9L3hh5O8fsuR6ze+d4qhbWm97NeslHkIMCKFTZvYb?=
 =?us-ascii?Q?fBzTXgs4B6zXixa8GMphncnxOBIg3zkdOg5lzD4ySfJvJICGVeU8EiH7soC8?=
 =?us-ascii?Q?M6lV9xnuA5hEFq/+IoXY6Q38/NMz7ZL5ik7D7w07wwKgW5C+V7gd0Y6Eq1Bb?=
 =?us-ascii?Q?VsDi/4sl8XzT3WC3TOl9ywPGZKVTgVr0gMV/JLoSA34M9OhLgx+YIeOl3Ft7?=
 =?us-ascii?Q?C9tZyzQNLFZyBbl2K+cZgxiH+sArtP6YZ/SLL5kGU2LM0ZVeNGXNv1+bEc1Z?=
 =?us-ascii?Q?4wCsJEGodM8JFJRXB30kq40l36ggGY1wFNGbgYDsKfnNEQDxivoR6RVEveu4?=
 =?us-ascii?Q?+dRz7eBorh9nuNvyAtYqbPraBq2jIWniswBYoLFhH4NTSV9y8vpFjn4yePit?=
 =?us-ascii?Q?AFgl3WklxBuSOO5pT1n+8BF6CyDXaVY+kkdmBtpSAArN1AZaAgbaAmcuXctZ?=
 =?us-ascii?Q?QdNCfDSrSnVlQljgtLv3VaU8pzc13LcQ4G8lQ82z5P1MZ5naLwB7zuEWjHNV?=
 =?us-ascii?Q?WyAk69YgobaCpEVRvTC7R/UjIZbZejrpzHQ+YPK4EYKQ1KNvEoylW76TT8SD?=
 =?us-ascii?Q?4+Go3FdmMFWcCOii8NYzy0e+o0qKrkBsZ2nt7kytyQEiOXZMQq7CTcjUtzYE?=
 =?us-ascii?Q?hqgHU37kMhTe6oVc9koosGyYPLAimv6EylmjDCIH0kRLP91zG2nTeghElcuc?=
 =?us-ascii?Q?Xw1ltgw8Y8SU/1fIFfHWf+AeijiSNXkuJZCCc8auiUTNFh9tAv5N3NW6OHEl?=
 =?us-ascii?Q?kSSHmjyy/OBz6Fcqvdeshdv8hy6wRVxMxix0El16+3g2UKGgRwJaSuvsvsEE?=
 =?us-ascii?Q?tQwg8pTnM/khL0/8dfSVSGsI412+BnVgAtpsvqTxZhEhTccEErBPD/D7wke7?=
 =?us-ascii?Q?CL/Kn7Y5qq2HbtckBtl0VrtvfUab8BxiGMvtLH+zj4Zq+qMehErx0fVFLErQ?=
 =?us-ascii?Q?gfadVKr4m67+Mjw8RgFqiLGWOBqZHIHyxXNIWC+proZKmkr89IVEN9lDoMYf?=
 =?us-ascii?Q?8ffxEHzKm9BG1mJvZVYvkstWphvUJ0jrriMN5MhiCz+5WUq/C4zdBdLJ0QXq?=
 =?us-ascii?Q?EffIdvvcxpvTBG835a0QXbxygu8hVR1vRf7YoBdGnfbPA0W9Um+41xZ7p7DH?=
 =?us-ascii?Q?wR8rD905bBIH70l5PfYherZ01p3aX2qK2VWAlWTUUG4s6jq1WlPQ3GEmGDtY?=
 =?us-ascii?Q?uIYzTkMIppDg9WtdNkb7MXBs7Se4jo0eyECU8P760W/a0uCxhN+t1jQxe8EW?=
 =?us-ascii?Q?CxeaZXJVQhZFZzyqgmy06BpOipu5c0/G5Ukr1PNMOjVBsp05fY9X34TRJQXL?=
 =?us-ascii?Q?OEfl5MAHSSkN+RYPaJDOM4qiUKaRpiLGUWZ3WQMmamoBrANHYxgm3QwVDbsy?=
 =?us-ascii?Q?VRHs9GoWEkEYcSNRaMF2rSAJy561ODipRu8olps3C7OR8X+UXBhkYhCz+amZ?=
 =?us-ascii?Q?qnbAPs7bL16VCGUXO0rs80z+MPIz8Rj8LwW72PXKCx20EZZas7hFGgqQgYHc?=
 =?us-ascii?Q?CcB0Qx4OLjyP0J3uV2vJmsF3EbztLpqki4v3761rd1R4cmO41HBklhZonBH8?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a30847-89d4-44bd-1b5d-08dac832f384
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 00:30:38.7037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ctPp9pbHw+qDJGIxhEfUAeR+d8JJbbMNU9Cx5ujaqpGkeOnhzaR4i2tSVUVgcldKfDP5KzVPNj1fd//llp/wGP8l4TFkebhu59/MFLtMA4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4922
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 02:24:33AM +0200, Vladimir Oltean wrote:
> Hi Maciej,
> 
> On Thu, Nov 17, 2022 at 01:03:04AM +0100, Maciej Fijalkowski wrote:
> > Hey Vladimir,
> > 
> > have a look at xdp_convert_zc_to_xdp_frame() in net/core/xdp.c. For XDP_TX
> > on ZC Rx side we basically create new xdp_frame backed by new page and
> > copy the contents we had in ZC buffer. Then we give back the ZC buffer to
> > XSK buff pool and new xdp_frame has to be DMA mapped to HW.
> 
> Ah, ok, I didn't notice the xdp_convert_zc_to_xdp_frame() call inside
> xdp_convert_buff_to_frame(), it's quite well hidden...
> 
> So it's clear now from a correctness point of view, thanks for clarifying.
> This could spark a separate discussion about whether there is any better
> alternative to copying the RX buffer for XDP_TX and re-mapping to DMA
> something that was already mapped. But I'm not interested in that, since
> I believe who wrote the code probably thought about the high costs too.
> Anyway, I believe that in the general case (meaning from the perspective
> of the XSK API) it's perfectly fine to keep the RX buffer around for a
> while, nobody forces you to copy the frame out of it for XDP_TX.

I sort of agree but I will get back to you after getting some sleep.
Basically I am observing better perf when I decide not to convert buff to
frame for XDP_TX (in this case I'm referring to standard data path of
Intel drivers, not the ZC data path). For ZC I am thinking about
converting ZC Rx buff to xdp_buff, but maybe we need to revisit the idea
behind that copy altogether. It was developed way before the times when
XSK buffer pool got introduced.


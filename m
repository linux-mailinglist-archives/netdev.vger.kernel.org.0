Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921736298E3
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiKOMao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiKOMan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:30:43 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4601A1CB0D;
        Tue, 15 Nov 2022 04:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668515443; x=1700051443;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WB9l7gR8iJRcJ9eZ5mZF6e9WLZEy5REiDPPk0gZW+OI=;
  b=SmVzCXQ8OHAoiKpj9w50O4Azy3D06rXIFP79nmGPlt8T2yavv17pEAOl
   CtRXY8w5t+OayMHYZYO5TBEXbqsz7oIbeUdSEJZp+n3kjNBKhZ8OLb8pF
   XY1wASJ3N2fgvw27L7iCxPRNJu5AcDSq1j9MTj09ZwmRLnn86hmY9pOeh
   n4GdBMuZQbpp/UwBLhKpMWb9LHEp7jzCJw+vYzjk5DQNawwas5tw+w75h
   QGqc6MM6FseeHX5xf0BAp32744n9tXopIg5gKeSqufeyuJcrwMeNJiOVm
   hT4/M+Xabw34lhy3JO+Nc17J6mGaDsZzEzXVBuV6NT+vv203Z95PF/KgU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="339036792"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="339036792"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 04:30:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616738082"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="616738082"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 15 Nov 2022 04:30:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 04:30:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 15 Nov 2022 04:30:42 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 15 Nov 2022 04:30:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y2hyCg6sMGTekvdUuz2LyuAM+ODUdCHN0Aadwp21we/cn+PSo2XIHVFU17Nu+BZDqVc5i8/g+KDIIZhB2tXenbOizUT1wxTONxLkprOuK8uLpJJrEbmHO6Wgy/FUoESpzBRMnBspUEwrGy7CqIxujSaOTgyQfZBF/HdqtOo8tQdL2BoBs8JQEUkTIqjWiZXOX1H35SFSRPsH6X4aGTK0R6bW085xy1Nm3n/syMLhxyELVfiakfRVkUDWfGcqxxw897+4ZTdQPXyMleqtPrSbRbNfIUPCO6QP6+u/NuHh178BaTm17bmu9d5Ei4QZJWE37096uNsFU8JXTbzj8VXDBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mleygq6mO4U3c6xOOxm5TLg4Xb/KXUW9XKCBUF/4jI=;
 b=hupIteNBxuz7wrfxWJT2eatPgpt8ElvXzC1ELEjwOrkUOtvXJ83t0AJOrG5CcCEG7Bp2z/9mj1XYo8MYYYNjP7Y96uxFjUVHh7Img6IRGjK7EbAhz5i/XhA8VF7T4aZPMiq2CS/CpjMgfDNiPR1Nz3+SG510+GFxxc1Ob+3xbg+/8hcRKXJMui2wdGxdX6aUcxW1/UuH5hms6rpkBd+c0Lfi9T5A1zPZkwckFicZnTJfxM8EW8+kXUTQ4R2q124Poom3KMKJbyJql91FPv+OG4jrTp8CfVbvMeChLucsk6aGqJUpHNk2rl35HF3kTrFAR1E1jBn+URoX2nPTxnXGQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MN2PR11MB4696.namprd11.prod.outlook.com (2603:10b6:208:26d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 12:30:40 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%5]) with mapi id 15.20.5813.013; Tue, 15 Nov 2022
 12:30:40 +0000
Date:   Tue, 15 Nov 2022 13:30:34 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <jonathan.lemon@gmail.com>, <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf 0/3] selftests/xsk: three small fixes
Message-ID: <Y3OGaodqylAXHohI@boxer>
References: <20221115080538.18503-1-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221115080538.18503-1-magnus.karlsson@gmail.com>
X-ClientProxiedBy: FR3P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::6) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MN2PR11MB4696:EE_
X-MS-Office365-Filtering-Correlation-Id: 0949dc57-bf64-47df-de1a-08dac70534d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +fR6vuAZig82u0KgWACzD0sOGvKAqTcUNsrfZtiScUmRcuzy62j2Y5RtzgARTYzb/Hug/sy5ClEFhqIjC4dCV9hb7JGMC0UlOvmVoO8IJ8xDkV7+C/CHgkgbVxs0Oo9rqwjcz0rl9+dffLeTQC6zAdkumvFrrKm2W/69VLcSd6eYfbwyBm4v56tsruMmGvSNJ/YFUd4NrzOGCEtwSKERCJjEFo61bfWbgve1930ht+xOn/SmAIPzmpEX73qsvpB461J+38cQLyCUiy99lquQgPcHFz18ImvPsumHqpC2Y5fb5EzmXtdrtysdDHEjfY/QjSswG/KJ8ZWW5EHceexvHukjTlasHZYWRDJpZ7C0PFoVkWtxsSUwmEbIfkL/gFyQ2Vms2EmQoxIZ0RJtF1vZuuPrmtVbk467Vm3WuvWO6eU0BeOje0P0ODNhDFTY+so9TIB4d3J57FCStEleZ4LFcTkWohE95xefw0sJoT2Obq+IMXfntuAFaCXp3Y8q0nWIzrioqojtZ/gG7adVNFaQBBhV4SNo6oyG9X2IaGkqCGXL6deJCnha5NQUrJKwWIR+cBWpEojTmvNISXC/usvowx5GXQ5546fxFK6tf/nlR2suCEAlV/TZxrk3bbUcusafaFj9YnV/MAGR4ZwNWECmeElWTA2PwmMQaphuEghT+xWWFoFXLDbrP07AqoPhpxDilWg6Ffm3EkKOZ/5/o5Xfgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199015)(82960400001)(44832011)(186003)(2906002)(33716001)(5660300002)(38100700002)(86362001)(6486002)(83380400001)(26005)(6512007)(9686003)(6666004)(478600001)(66946007)(4326008)(6506007)(66556008)(66476007)(41300700001)(8676002)(6916009)(8936002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aWupefSJvGYT0X9kLRXLEd8wiVnBs8lfKqvmdaec283uqa2OooAzsNQ8eeWi?=
 =?us-ascii?Q?TI9myNJbAXQJbQ1Z9r/mcWG3Ao5NCvlPmYE67xOJ7qSuYFA9xoGv7ajB3lMx?=
 =?us-ascii?Q?XjsqgdX/8PrwhxKcCNcVP6ECTrDxtST4OlwsRMCQlpBaTqu+R8165hRKTXAj?=
 =?us-ascii?Q?n/ZdwyjuV90w1vgr+/dDoDcNbFhygMWtzjzqUm+ojXjUu0UeKe5kfviHZOWd?=
 =?us-ascii?Q?lbmclH+wJ1vkey2Ea2LngwJdjjo2U4OQfwqt4VS3abZX2W/QJlJCHBfLLfBw?=
 =?us-ascii?Q?5AkPKHdbvCDN8SN2l0ykJPCffrz5caHFMJXnO1LlwZs9D0Mg81WGNlOGxOE3?=
 =?us-ascii?Q?SHZacuQ4qChDXqur3msGcqrKG3kTWMlrzTfq7pDAXmXX5+GE5/KAKYPBbWDf?=
 =?us-ascii?Q?Upd0ZsCGD3VjFthk3+fxIJMdHcqyJXqFETa4J9tGIi+HZZqB1nJWnhcE5jUI?=
 =?us-ascii?Q?Vos+FmrBcCDFSJd+FDlJDlVWMYqfhdLWCkwg3aIGBzoBmc8OoZo2wvtyTupA?=
 =?us-ascii?Q?BN2vHsAnlgoGtnwM4dLHswNTkyy/wkSLg3JU+w7hiziabD1Kdqm1ZFDI5YnV?=
 =?us-ascii?Q?C0V9GjgXOxKLniNqERww5XbddYftQC49Hsip81J6G3i1vtAoF/sP1CbqlesH?=
 =?us-ascii?Q?aH5A9YLlRtSQTlpSpkIeS8zXBarzEQtBza027eC971aUlqlYi753GMR9fDjW?=
 =?us-ascii?Q?NlfC+04BQNRpJpYl2duq52HYV2Qt3Ie6rJQGSk2ROv5+FpBfQOJxfBRrg7wU?=
 =?us-ascii?Q?v9oDrFbjfI7PKkznDcWEhgqbJnFyj8YafXhGzpamcbnXQr9MSfUgTunfnoL9?=
 =?us-ascii?Q?KRiFcRPuzUSK+eCnEoTMFVOadUFZ2S29SiSX/P4o/dsXzWAKzDSg3KNjswDm?=
 =?us-ascii?Q?r3FFYpMzOcbv9CpMi8E2ZMPSXJmYsfokPu9splR2Cz448ndDm8T9lfiprH7K?=
 =?us-ascii?Q?I7HG2HhRfdG1zYsnf57M4BO6gta5hB4MQ0ICxu0WsX4nuPseBtzJlZY+ZflW?=
 =?us-ascii?Q?IVLZmwEJbJXPZ5iyqadTAHvQ9j5nyJO3dfmxLlVNKsp4/akhh01XbE5nGwq2?=
 =?us-ascii?Q?IdT9adbGXp/zbKhbsKgk7jOQyTMrhxsybRGsGFYXUA+ahT0iNgWChYyPPtUC?=
 =?us-ascii?Q?mPJrj6c7lqPZp5b/2y6OjyLBODHH3vjKEAE9Lgy15Gic9ZG+hu9i+5xHcq9V?=
 =?us-ascii?Q?auqrYAfknLaEUzkBNciwUrqDswUwKWFH7lK0GMYoVsmpIZqjT7/Wo28dWcDB?=
 =?us-ascii?Q?nFRFuU0gMC3hmYprP6elFa2kgbQ+OA6/h8nXKQdahVLkgmRXie0NPCRt0sjE?=
 =?us-ascii?Q?ewCz2ur0cuMFZ7EcV8cnci+0lxIbbKBKAbGIiR5ikmpxM9nkZ6WavWSxk6BF?=
 =?us-ascii?Q?udFXj1VjTXFoDeopd54QAZEdJxQ47vrSMWSfBfyJLz7v4KUoDC3CA/doM6r4?=
 =?us-ascii?Q?5wCJ/Yb9/oTGw1ZgjrteZgCv/urbwJ9ZO6UQNuQ///Vs0HchHq6z+W4cWptf?=
 =?us-ascii?Q?A7Lal94vz/F+I0VAapngeJJISUk3taQhxq2oPm2Pnh4SyZDUvnkpja5+ZL8V?=
 =?us-ascii?Q?oqn+vexJHnN/07ccjouFlCPWF7/6KJV0ez1MgA58vP5djjKla0No57itSrBE?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0949dc57-bf64-47df-de1a-08dac70534d8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 12:30:40.2363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXY4koE2FdpJ0snqjwYU9rdjvF34DS8ao9UZE5ek379T+Y4B4hONVJlMQwEymfaQ9u2U/2lAQu95WWQF/BKXg76Q/vTlrzJwXp0O9SfrAaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4696
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 09:05:35AM +0100, Magnus Karlsson wrote:
> This patch set contains three small fixes for bugs discovered while
> implementing some new tests that will be sent to bpf-next. These are
> minor fixes to the xsk test framework that IMHO should not be
> backported to any of the stable kernels as no one using them would
> care. The tests work fine without these fixes, but when developing new
> code and some test fails (or the framework fails), these bugs in the
> code are irritating.
> 
> Thanks: Magnus

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> Magnus Karlsson (3):
>   selftests/xsk: print correct payload for packet dump
>   selftests/xsk: do not close unused file descriptors
>   selftests/xsk: print correct error codes when exiting
> 
>  tools/testing/selftests/bpf/xsk.c        | 13 +++++++++++--
>  tools/testing/selftests/bpf/xskxceiver.c | 24 ++++++++++++------------
>  2 files changed, 23 insertions(+), 14 deletions(-)
> 
> 
> base-commit: 5fd2a60aecf3a42b14fa371c55b3dbb18b229230
> --
> 2.34.1

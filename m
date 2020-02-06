Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B8E154597
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 14:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgBFN61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 08:58:27 -0500
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:45903
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727637AbgBFN60 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 08:58:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnxoQxy5Uqvpe92n+VlYOskHDw0yr5CtZbkphwAt9sXL775l/ioExAxZ73oLgCLzZvWjkiQOY7JsF1QtCeTWsZE1Sae9tj1qavTHdAaqPcjd+AtwYrc3m1ZtXNWCY2nzj2256yQQ+NF7GaVP17BTjpO7mAfcZx8ya+TBl9ioBtCIhV/QsKZnu+/kz61B6q7eyUagL51k7erj6NWnFnz2/DfdGTFlKx8/JsiRo+A55OkfPLSRwiZpEQKZBDV+QNBOWEE7bE7ZX9BkwL7cgKJXE+qk8kfEhy81gMuQva/yc48Lbc46QFSc4nP0JxLCK5bE13Ve3tHcY6LQWAWrnfxUMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NksTOhSenlwDVAIMweZYrPSKWaWAq5cVzRkj5rwN6Fk=;
 b=lUnepKKyRfdE6vwCXhfe0YmCMc4uA9AsojoaGqZRDctkvhYqQXynm7aMpEXulx37bhqGy5e12hsXlYEqgyl/3mDKcv/JSeWnn/vkiipI8a4Z67Jsiqwlv6/iHmdNztX5/oMPog4mi9r5bhPjbE66jK+JBZ0jKAEkIblLYGyJKExwn0OOPCYAj7mQOoaBejj5VEEFc0yCa2zKBw/ZH3LWob5rNAalpnwf+vw7b1TOxUrm881G/MShVYHoEkEyAToIwVP7ZSGRrfiEplxzucctIie9v6Aq6AJ96BwOIJnyMc096ble/djBzc0d5VrfRjlcnrR38rmbxDGoUqdbUsOvdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NksTOhSenlwDVAIMweZYrPSKWaWAq5cVzRkj5rwN6Fk=;
 b=d2kFQFkl5oe1DffoSz8NjEP1RPfra14vY6KuBbGNLOccu080sPqtVYvO3a1+VAAQKiXFHTUu1D0HrUFkdmjaJd3q9oZ9YVHI+jOCwzeoO+eUtPmKuTUeW/UFtahuKzB7rwL7NSR8d/iJVmYCoqDPFWj2F2ZPzwXPmhaICe9Wyq8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com (10.168.126.17) by
 HE1PR0501MB2460.eurprd05.prod.outlook.com (10.168.125.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 6 Feb 2020 13:58:21 +0000
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::60c4:f0b4:dc7b:c7fc]) by HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::60c4:f0b4:dc7b:c7fc%10]) with mapi id 15.20.2707.023; Thu, 6 Feb 2020
 13:58:21 +0000
Subject: Re: [PATCH bpf 0/3] XSK related fixes
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net
Cc:     ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
References: <20200205045834.56795-1-maciej.fijalkowski@intel.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <d843052f-e0a5-7a8c-da65-7cb15c274483@mellanox.com>
Date:   Thu, 6 Feb 2020 15:58:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <20200205045834.56795-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0902CA0010.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::20) To HE1PR0501MB2570.eurprd05.prod.outlook.com
 (2603:10a6:3:6c::17)
MIME-Version: 1.0
Received: from [10.44.1.235] (37.57.128.233) by AM4PR0902CA0010.eurprd09.prod.outlook.com (2603:10a6:200:9b::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Thu, 6 Feb 2020 13:58:20 +0000
X-Originating-IP: [37.57.128.233]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: defbfaae-c669-4c57-ae8c-08d7ab0ca00c
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2460:
X-Microsoft-Antispam-PRVS: <HE1PR0501MB2460B2931B4AEADF9989628ED11D0@HE1PR0501MB2460.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0305463112
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(199004)(189003)(2906002)(81156014)(31686004)(81166006)(86362001)(5660300002)(8676002)(31696002)(186003)(2616005)(16526019)(26005)(52116002)(956004)(4326008)(55236004)(53546011)(6486002)(6666004)(8936002)(316002)(36756003)(66946007)(966005)(16576012)(66556008)(478600001)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0501MB2460;H:HE1PR0501MB2570.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GLy6aAjEUPlDJcHtzwl5G7o0RMjVjPgmhlKANikWZPzhBUW+dwwrEr/7ZKbxqEnvJJheHN1U5SksGVHcQDkW38T40GcVY5aGJYCmO7y/9DXpNqMIxdj7OXUuo1HJ2xdP8sHqvNPH3sZlhGaexFXMzJDnLZm1RMa9O7UGg63+DYkxkdVvDQQ2z+avjQ8GCrzTeU4lIqd+C1WKYd64jQNzb8qJx9+wCWcdyl3qmZJ4J08P6ZzOurxXGEDsqzvDulBTDcSccCz/CIdq/EUa1WqluVKXO4aMwPvppT7h3U7D2TIbOG13Kli4jYuyUhrLzMHNJJ7hPpQq0zGMxQ0V7e/vorIl87vokg3rj+HvRfl6hGLdRS2FRR2AQbi0/FPzxcvG5P+nRqBInQ1v/y2evQL3XcW0U3pO/ux4/eDiZU3Gzoh6vQDGHrIRQpzpv6ECN6tFX8Z/wHJciPlQVoVRE6VS3OxT/I4jPaCf5VObgi/QoFfDKuSAu+t00fW7YvSd82Swc3mk4QZ0irGmBF4aFvo2ag==
X-MS-Exchange-AntiSpam-MessageData: JlAZlgHQMmkq99draulB2HGMyciNdv8FVxM9S6KlrcZUxT9VZJOhlwOHtEcj5bkR3e4z6bvAmLWluy8Zr792e27VNtscAztB9K9O+aP2T0G6MbXX9HednEtPloHSI8IubOTor9zRcSMc29V9tBuQBw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: defbfaae-c669-4c57-ae8c-08d7ab0ca00c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2020 13:58:21.2056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r0kYAfIS1fa8S7SjbQ+bQBIAYdi263kGyz2FtxhXjddE94wB+8/pN8Jz73npXraanIlzQcgXT2PHosGuz05xaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2460
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-05 06:58, Maciej Fijalkowski wrote:
> Cameron reported [0] that on fresh bpf-next he could not run multiple
> xdpsock instances in Tx-only mode on single network interface with i40e
> driver.
> 
> Turns out that Maxim's series [1] which was adding RCU protection around
> ndo_xsk_wakeup added check against the __I40E_CONFIG_BUSY being set on
> pf->state within i40e_xsk_wakeup() - if it's set, return -ENETDOWN.
> Since this bit is set per PF when UMEM is being enabled/disabled, the
> situation Cameron stumbled upon was that when he launched second xdpsock
> instance, second UMEM was being registered, hence set __I40E_CONFIG_BUSY
> which is now observed by first xdpsock and therefore xdpsock's kick_tx()
> gets -ENETDOWN as errno.
> 
> -ENETDOWN currently is not allowed in kick_tx(), so we were exiting the
> first application. Such exit means also XDP program being unloaded and
> its dedicated resources, which caused an -ENXIO being return in the
> second xdpsock instance.
> 
> Let's fix the issue from both sides - protect ourselves from future
> xdpsock crashes by allowing for -ENETDOWN errno being set in kick_tx()
> (patch 3) and from driver side, return -EAGAIN for the case where PF is
> busy (patch 1).
> 
> Remove also doubled variable from xdpsock_user.c (patch 2).
> 
> Note that ixgbe seems not to be affected since UMEM registration sets
> the busy/disable bit per ring, not per PF.
> 
> Thanks!
> Maciej
> 
> [0]: https://www.spinics.net/lists/xdp-newbies/msg01558.html
> [1]: https://lore.kernel.org/netdev/20191217162023.16011-1-maximmi@mellanox.com/
> 
> Maciej Fijalkowski (3):
>    i40e: Relax i40e_xsk_wakeup's return value when PF is busy
>    samples: bpf: drop doubled variable declaration in xdpsock
>    samples: bpf: allow for -ENETDOWN in xdpsock
> 
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
>   samples/bpf/xdpsock_user.c                 | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 

Acked-by: Maxim Mikityanskiy <maximmi@mellanox.com>

Though it's already merged (that was too fast).

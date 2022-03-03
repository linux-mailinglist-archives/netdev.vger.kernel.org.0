Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4054CBC89
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 12:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbiCCLbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 06:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiCCLbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 06:31:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889527E5A9
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 03:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AE72B8245A
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 11:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14F0AC340EF;
        Thu,  3 Mar 2022 11:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646307015;
        bh=X0ySmOY6SevZP/9qVI/IkLEMKPpy48/m/+3mfB0vUfk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=olJShKeVow909JzaaDaJGN0LMEQ9J+YlmzKdGM+YC5UmtzAMLQl/2YB4ajmYpygpK
         Cvuay6kjngOaC1NvoJQDk11DHPEGZ+UyGtmTczXG7hbvIj3dK6wMltoVk54fIZrUQ9
         BxvvF+1acd143BxQnN8dhUMCxczdwjpVWDZAa+ZqZEooZ+oqyLAsyR+AjVNJC1Av0G
         13YIahx1H2Ih93UyrcA0Lq/UcY4I8XdjE/Dw3MRfnr+MX40CsCjKV56h6j5aqAgli9
         Fx2SgydlTEZYc1grCsBoqDVZTGiAtnQmAI/6lKxfVk9H74MmvV4V4gPeLEYHpVgT7G
         d06dMQz3WK18g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC1DAE8DD5B;
        Thu,  3 Mar 2022 11:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/14] HW counters for soft devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164630701489.19662.13236792625641122428.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 11:30:14 +0000
References: <20220302163128.218798-1-idosch@nvidia.com>
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, jiri@nvidia.com, roopa@nvidia.com,
        razor@blackwall.org, dsahern@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Mar 2022 18:31:14 +0200 you wrote:
> Petr says:
> 
> Offloading switch device drivers may be able to collect statistics of the
> traffic taking place in the HW datapath that pertains to a certain soft
> netdevice, such as a VLAN. In this patch set, add the necessary
> infrastructure to allow exposing these statistics to the offloaded
> netdevice in question, and add mlxsw offload.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/14] net: rtnetlink: Namespace functions related to IFLA_OFFLOAD_XSTATS_*
    https://git.kernel.org/netdev/net-next/c/6b524a1d012b
  - [net-next,v2,02/14] net: rtnetlink: Stop assuming that IFLA_OFFLOAD_XSTATS_* are dev-backed
    https://git.kernel.org/netdev/net-next/c/f6e0fb812988
  - [net-next,v2,03/14] net: rtnetlink: RTM_GETSTATS: Allow filtering inside nests
    https://git.kernel.org/netdev/net-next/c/46efc97b7306
  - [net-next,v2,04/14] net: rtnetlink: Propagate extack to rtnl_offload_xstats_fill()
    https://git.kernel.org/netdev/net-next/c/05415bccbb09
  - [net-next,v2,05/14] net: rtnetlink: rtnl_fill_statsinfo(): Permit non-EMSGSIZE error returns
    https://git.kernel.org/netdev/net-next/c/216e690631f5
  - [net-next,v2,06/14] net: dev: Add hardware stats support
    https://git.kernel.org/netdev/net-next/c/9309f97aef6d
  - [net-next,v2,07/14] net: rtnetlink: Add UAPI for obtaining L3 offload xstats
    https://git.kernel.org/netdev/net-next/c/0e7788fd7622
  - [net-next,v2,08/14] net: rtnetlink: Add RTM_SETSTATS
    https://git.kernel.org/netdev/net-next/c/03ba35667091
  - [net-next,v2,09/14] net: rtnetlink: Add UAPI toggle for IFLA_OFFLOAD_XSTATS_L3_STATS
    https://git.kernel.org/netdev/net-next/c/5fd0b838efac
  - [net-next,v2,10/14] mlxsw: reg: Fix packing of router interface counters
    https://git.kernel.org/netdev/net-next/c/8fe96f586b83
  - [net-next,v2,11/14] mlxsw: spectrum_router: Drop mlxsw_sp arg from counter alloc/free functions
    https://git.kernel.org/netdev/net-next/c/9834e2467c86
  - [net-next,v2,12/14] mlxsw: Extract classification of router-related events to a helper
    https://git.kernel.org/netdev/net-next/c/c1de13f91ee5
  - [net-next,v2,13/14] mlxsw: Add support for IFLA_OFFLOAD_XSTATS_L3_STATS
    https://git.kernel.org/netdev/net-next/c/8d0f7d3ac647
  - [net-next,v2,14/14] selftests: forwarding: hw_stats_l3: Add a new test
    https://git.kernel.org/netdev/net-next/c/ba95e7930957

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



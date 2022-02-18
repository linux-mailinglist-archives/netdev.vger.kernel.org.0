Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F954BB7D5
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbiBRLKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:10:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbiBRLKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:10:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDAE2B460F
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2732B61C36
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 11:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BCEFC340EF;
        Fri, 18 Feb 2022 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645182610;
        bh=kdrtcQJDQrXYMWx+TyiAgV5MPqDs0H4cKmPYyRLb+UM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VwSdYH4qfjsj6IDLLfYefd9DGZbnpSXTE8fGHWRlSt4GicNz6Y2I8BZvGT/EABbuw
         5AKEe36QV2rk2szVWZ4CiOf900oSU6XIhpBNxKsEEB3r5wQmduWpPT2FLSVA8dFPMY
         CN8He2Z2NR1YKr6kndWkDqEPEEqBaiYwj587p73wqjPZU9ihGCymb93oqgOBZ2OsDI
         50gajGA+Uu7iC1X0ha7M/M0VCOgo1nTJ1wUjojp/Y4bWNCvnLQevUbJxw8hGERa3Y+
         gvQLyfKnJQbBEywblzwP2i8vhmP/4GWZE13+MvsSe0dwLGV0IlMN7YdVK6aVB/sd5U
         ZygDS2k7ZjS2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 744BEE7BB08;
        Fri, 18 Feb 2022 11:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net/sched: act_ct: Fix flow table lookup after ct
 clear or switching zones
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164518261047.25032.774223185223497778.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 11:10:10 +0000
References: <20220217093048.23392-1-paulb@nvidia.com>
In-Reply-To: <20220217093048.23392-1-paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        davem@davemloft.net, jiri@nvidia.com, xiyou.wangcong@gmail.com,
        kuba@kernel.org, ozsh@nvidia.com, vladbu@nvidia.com,
        roid@nvidia.com, lariel@nvidia.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Feb 2022 11:30:48 +0200 you wrote:
> Flow table lookup is skipped if packet either went through ct clear
> action (which set the IP_CT_UNTRACKED flag on the packet), or while
> switching zones and there is already a connection associated with
> the packet. This will result in no SW offload of the connection,
> and the and connection not being removed from flow table with
> TCP teardown (fin/rst packet).
> 
> [...]

Here is the summary with links:
  - [net,1/1] net/sched: act_ct: Fix flow table lookup after ct clear or switching zones
    https://git.kernel.org/netdev/net/c/2f131de361f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



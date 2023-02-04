Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA8F68A81B
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 05:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbjBDEK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 23:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbjBDEK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 23:10:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE1B6E96
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 20:10:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2BCC603F5
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 04:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 311F6C433A0;
        Sat,  4 Feb 2023 04:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675483825;
        bh=6iJ2lRxC+OZW8fA04uXqOp886a/haOaMUuBWdPLUdNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V+edqPgLSyHfhGpGHtQNULZpRJJ/hSemoBXDAQVoVixXHnJ8nqvsy5CTTU8HiYuzJ
         txrj3mV62qkDX0nEciTkZNhaUM4V9diVamEh7kIwR76JGy9z1x9XciOEhya7sAsDB4
         2+scAw1Awf88uNvjCSEQLd+7jynfSTpFt1n/tBjv12JEgHcXSuZ0YZuHoeIkyZ+DAs
         EbzqMaxaTEZNECpvpwvzlN/qD/W/gqCzPSFub+VnJ1BaX+MWzhuTcpOzvneburh07h
         otn1eSpIjc2TF1dk2ZWqUw4/ZM9WfOuWt7XmFxSuYDjdKZzAkrJv8CLyAgZymUYVWv
         +N6B4Pq72BD5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 167EFE270CB;
        Sat,  4 Feb 2023 04:10:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] Updates to ENETC TXQ management
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167548382508.22938.9308859797255835086.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Feb 2023 04:10:25 +0000
References: <20230203001116.3814809-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230203001116.3814809-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        simon.horman@corigine.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  3 Feb 2023 02:11:12 +0200 you wrote:
> The set ensures that the number of TXQs given by enetc to the network
> stack (mqprio or TX hashing) + the number of TXQs given to XDP never
> exceeds the number of available TXQs.
> 
> These are the first 4 patches of series "[v5,net-next,00/17] ENETC
> mqprio/taprio cleanup" from here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20230202003621.2679603-1-vladimir.oltean@nxp.com/
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: enetc: simplify enetc_num_stack_tx_queues()
    https://git.kernel.org/netdev/net-next/c/1c81a9b3aaa2
  - [net-next,2/4] net: enetc: allow the enetc_reconfigure() callback to fail
    https://git.kernel.org/netdev/net-next/c/46a0ecf93b6d
  - [net-next,3/4] net: enetc: recalculate num_real_tx_queues when XDP program attaches
    https://git.kernel.org/netdev/net-next/c/4ea1dd743eb6
  - [net-next,4/4] net: enetc: ensure we always have a minimum number of TXQs for stack
    https://git.kernel.org/netdev/net-next/c/800db2d125c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



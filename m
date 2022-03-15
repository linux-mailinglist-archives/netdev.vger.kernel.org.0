Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14EE04DA2D5
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351193AbiCOTB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 15:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343730AbiCOTB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 15:01:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDC650E34;
        Tue, 15 Mar 2022 12:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 195ECB81803;
        Tue, 15 Mar 2022 19:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AFFF1C340F5;
        Tue, 15 Mar 2022 19:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647370812;
        bh=vl4DMROik9qe1jQlUAwzgpIIvuCAozFHv1U0EdAVlJc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uWHqaekxJ2ElgNSffoOQJUvup5d5rKxmQdcqH8+c+TnQ0N3niWJK28YUFTkwtMno4
         RU5/96sh6f2eqpZ6F+L6qjEZDZtYRaQxD9AU7cdxfi8sjX5zRoG58hPlFZLvlphC4D
         I+HEJ4LH6p2VOcvHtIsnvv1MUu7I6eQKDddcx8otvJLKSQfKQOAceuh7NHZNmGO/xs
         xrrkfyuc0jxdxImAyEs+WAPOSRNq6X/JG/LvI6GWR3KR2KSINoUgHJfCJwneK+c308
         cVVdpBt5wOLQ9ln3xJS/ZVp194QRyJ9i9rhAGq0eIQIZBzYwiYMSQzReJPUAY2723E
         o+IYNEsOgctsA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84E9FE6D44B;
        Tue, 15 Mar 2022 19:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH nf-next 1/6] Revert "netfilter: conntrack: mark UDP zero
 checksum as CHECKSUM_UNNECESSARY"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164737081254.13795.2158434995988219572.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Mar 2022 19:00:12 +0000
References: <20220315091513.66544-2-pablo@netfilter.org>
In-Reply-To: <20220315091513.66544-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Florian Westphal <fw@strlen.de>:

On Tue, 15 Mar 2022 10:15:08 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> This reverts commit 5bed9f3f63f8f9d2b1758c24640cbf77b5377511.
> 
> Gal Presman says:
>  this patch broke geneve tunnels, or possibly all udp tunnels?
>  A simple test that creates two geneve tunnels and runs tcp iperf fails
>  and results in checksum errors (TcpInCsumErrors).
> 
> [...]

Here is the summary with links:
  - [nf-next,1/6] Revert "netfilter: conntrack: mark UDP zero checksum as CHECKSUM_UNNECESSARY"
    https://git.kernel.org/netdev/net-next/c/bbfbf7a5e77e
  - [nf-next,2/6] netfilter: nf_tables: Reject tables of unsupported family
    https://git.kernel.org/netdev/net-next/c/f1082dd31fe4
  - [nf-next,3/6] netfilter: flowtable: Support GRE
    https://git.kernel.org/netdev/net-next/c/4e8d9584d154
  - [nf-next,4/6] act_ct: Support GRE offload
    https://git.kernel.org/netdev/net-next/c/fcb6aa86532c
  - [nf-next,5/6] net/mlx5: Support GRE conntrack offload
    https://git.kernel.org/netdev/net-next/c/1918ace1382d
  - [nf-next,6/6] netfilter: bridge: clean up some inconsistent indenting
    https://git.kernel.org/netdev/net-next/c/334ff12284fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



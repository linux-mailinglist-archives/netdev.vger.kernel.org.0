Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5427D4AE94F
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239471AbiBIF2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:28:06 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbiBIFUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:20:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD233C03E931
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:20:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99FACB81ED6
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72F01C340EF;
        Wed,  9 Feb 2022 05:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644384033;
        bh=RnGaBRnkf/jwKuvs8sQH5JxKhZU97ixZDQky2Tl5FBY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bJQ1vsA4mey4W7Fqf82bXfVXrRzcskcNSL6zaK0xc3JMfMl6+sR27+1/XE9rn4M4v
         eYnsT5tId/SESUt85yJO53LdHdzfdMTPDr6HWutxK8MhlbVw7c+7Bn+ghSj2myp+sU
         7Q+syC3L6sd6ML09DeajkR/Bx3eqzb3Af5fyxRCKTmPFkuq/SShAPUaxxI2irVKkY0
         8c7SFSrq2XhE47zFyc615ZndgeoR2kswSljcE7qnPa6A4wV0Qc4y8zNxK4TGuqNqym
         PbO7FCD72VXUjW4cdnEJD/lQGTd/N+Fl8+srC64na0VPn6IZjE6iowusqgOPk0nGou
         8PZk+DYtN/3tA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 620F4E5D084;
        Wed,  9 Feb 2022 05:20:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 00/11] net: speedup netns dismantles
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164438403339.12376.10643717122690570581.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 05:20:33 +0000
References: <20220208045038.2635826-1-eric.dumazet@gmail.com>
In-Reply-To: <20220208045038.2635826-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  7 Feb 2022 20:50:27 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> In this series, I made network namespace deletions more scalable,
> by 4x on the little benchmark described in this cover letter.
> 
> - Remove bottleneck on ipv6 addrconf, by replacing a global
>   hash table to a per netns one.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,01/11] ipv6/addrconf: allocate a per netns hash table
    https://git.kernel.org/netdev/net-next/c/21a216a8fc63
  - [v2,net-next,02/11] ipv6/addrconf: use one delayed work per netns
    https://git.kernel.org/netdev/net-next/c/8805d13ff1b2
  - [v2,net-next,03/11] ipv6/addrconf: switch to per netns inet6_addr_lst hash table
    https://git.kernel.org/netdev/net-next/c/e66d11722204
  - [v2,net-next,04/11] nexthop: change nexthop_net_exit() to nexthop_net_exit_batch()
    https://git.kernel.org/netdev/net-next/c/fea7b201320c
  - [v2,net-next,05/11] ipv4: add fib_net_exit_batch()
    https://git.kernel.org/netdev/net-next/c/1c6957646143
  - [v2,net-next,06/11] ipv6: change fib6_rules_net_exit() to batch mode
    https://git.kernel.org/netdev/net-next/c/ea3e91666ddd
  - [v2,net-next,07/11] ip6mr: introduce ip6mr_net_exit_batch()
    https://git.kernel.org/netdev/net-next/c/e2f736b753ec
  - [v2,net-next,08/11] ipmr: introduce ipmr_net_exit_batch()
    https://git.kernel.org/netdev/net-next/c/696e595f7075
  - [v2,net-next,09/11] can: gw: switch cangw_pernet_exit() to batch mode
    https://git.kernel.org/netdev/net-next/c/ef0de6696c38
  - [v2,net-next,10/11] bonding: switch bond_net_exit() to batch mode
    https://git.kernel.org/netdev/net-next/c/16a41634acca
  - [v2,net-next,11/11] net: remove default_device_exit()
    https://git.kernel.org/netdev/net-next/c/ee403248fa6d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



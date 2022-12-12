Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D73264A974
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiLLVUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiLLVUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2B027A;
        Mon, 12 Dec 2022 13:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D647B80E73;
        Mon, 12 Dec 2022 21:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF734C433F0;
        Mon, 12 Dec 2022 21:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670880016;
        bh=RqXJOZTJub+qHAL89cqOUXtFtAkLk5O8aQo3/SPJtbA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FTXRSr/NBT3xotK3bCOA5iS5ElQc7AFYkbhcBRPY/3IZAOtyzLt7VVYY2KqtkQVhz
         BYngorZ3nVAZRNh4HgnahIwSFxDWdVT6rY7eTx9zFVIvLIWCsVJ0oV5drqB2nS45nN
         oecyCAVmlBvbVIekdt/uxZmkDpuou4R73MqFnY/upANNxRH756kYpfEj/Gf8vdcQSR
         d5YQ7pb7Zc6xfeVNQL6LU+8xPVQA0udK/vwIAgLzrcXe+6njW4oh6e8a9TXUeeDVXR
         NFJq7yDumutQJpp3PcnSDJHTXykxL3pd/ncukJ/bwFDnW0BXZYLGpLsm1QsrscX3bZ
         rYtD60/n7cQ8A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A702BC41606;
        Mon, 12 Dec 2022 21:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] mptcp: Fix IPv6 reqsk ops and some netlink error
 codes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088001668.6199.4449323416184280216.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 21:20:16 +0000
References: <20221210002810.289674-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20221210002810.289674-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de,
        kishen.maloor@intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        stable@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Dec 2022 16:28:06 -0800 you wrote:
> Patch 1 adds some missing error status values for MPTCP path management
> netlink commands with invalid attributes.
> 
> Patches 2-4 make IPv6 subflows use the correct request_sock_ops
> structure and IPv6-specific destructor. The first patch in this group is
> a prerequisite change that simplifies the last two patches.
> 
> [...]

Here is the summary with links:
  - [net,1/4] mptcp: netlink: fix some error return code
    https://git.kernel.org/netdev/net/c/e0fe1123ab2b
  - [net,2/4] mptcp: remove MPTCP 'ifdef' in TCP SYN cookies
    https://git.kernel.org/netdev/net/c/3fff88186f04
  - [net,3/4] mptcp: dedicated request sock for subflow in v6
    https://git.kernel.org/netdev/net/c/34b21d1ddc8a
  - [net,4/4] mptcp: use proper req destructor for IPv6
    https://git.kernel.org/netdev/net/c/d3295fee3c75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78499692C12
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 01:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBKAa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 19:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBKAaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 19:30:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53820195
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 16:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0129CB82656
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 00:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8819C4339E;
        Sat, 11 Feb 2023 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676075420;
        bh=SP2ERypKHUnWAaqy9ltaTGNR3SRK+vST7N9Dh4q7SeQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ztd04FpMgTGtRJgFFGhe8JO7I9L3xQcPGvxlxRYDmmX5RNhYKOFyvHM4mMyZBShvZ
         dj7HsTLvqJFpKBKDlyhMC50fciaHOZiwSE/W1BlYfP2ot+zvPQdAsLlMUL0+VssFls
         apkHeC04WGv/zSHs5Qg80v/mh9HZxFdULa7zCUEUS3LH27r7n7Q9PQ6KD5vYkW0fjL
         sqU8zPJtnnTe7BKydTMZs4JZFzk/+I8QUW/X3Ei6L9rG8lOeEKQpBhogEvZzHRCs3J
         ujN02zarw/C3ElggnF4BCLjqZU7LY2DMA0jBm0oAufbK0dW1U9zxk2o6CYr7ASW92L
         uClVTjsA9uCJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84F9AE55EFD;
        Sat, 11 Feb 2023 00:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net-next 0/5] net: move more duplicate code of ovs and tc
 conntrack into nf_conntrack_ovs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167607542053.32477.15635160688212283611.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 00:30:20 +0000
References: <cover.1675810210.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1675810210.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pshelar@ovn.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        marcelo.leitner@gmail.com, i.maximets@ovn.org, aconole@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Feb 2023 17:52:05 -0500 you wrote:
> We've moved some duplicate code into nf_nat_ovs in:
> 
>   "net: eliminate the duplicate code in the ct nat functions of ovs and tc"
> 
> This patchset addresses more code duplication in the conntrack of ovs
> and tc then creates nf_conntrack_ovs for them, and four functions will
> be extracted and moved into it:
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net-next,1/5] net: create nf_conntrack_ovs for ovs and tc use
    https://git.kernel.org/netdev/net-next/c/c0c3ab63de60
  - [PATCHv2,net-next,2/5] net: extract nf_ct_skb_network_trim function to nf_conntrack_ovs
    https://git.kernel.org/netdev/net-next/c/67fc5d7ffbd4
  - [PATCHv2,net-next,3/5] openvswitch: move key and ovs_cb update out of handle_fragments
    https://git.kernel.org/netdev/net-next/c/1b83bf4489cb
  - [PATCHv2,net-next,4/5] net: sched: move frag check and tc_skb_cb update out of handle_fragments
    https://git.kernel.org/netdev/net-next/c/558d95e7e11c
  - [PATCHv2,net-next,5/5] net: extract nf_ct_handle_fragments to nf_conntrack_ovs
    https://git.kernel.org/netdev/net-next/c/0785407e78d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



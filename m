Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20019622E97
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 16:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbiKIPAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 10:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiKIPAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 10:00:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A79A13EA2;
        Wed,  9 Nov 2022 07:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 63A8ECE1FD0;
        Wed,  9 Nov 2022 15:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 806BBC433B5;
        Wed,  9 Nov 2022 15:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668006016;
        bh=d+kc0LdkBOz1gjUp6TAiscslJjOVNqV+VYjDP7Mdg78=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AS6vTbj8+ep3m0l8g9lkWCUcbkbnLfrYSG46N4/RsjvtPztHT4wC0mwoaQe53opxa
         Jn2p2hr8nuVxYYTfPNJXjt5ODfsiVrubkIl29L2n9VGu31t9U1wPvuhCcy61m9bY4n
         LT/Hx5TPKSlQO29NUUNl/I37IVK4w2yxZcGQTW6DOVXWU0u3y8ysuxI2lVfM7CxxlX
         LpUpyXu4Rded22h+Id5adsKixiSolHwX74eZi/aqyzEpSjyf6ESQNptMgzCWmJQaSS
         A8QooNA+tQoqxjXEPTVP70XeT+qpDl4CBbUY8PsEabP+LK0UBD9uv24NmtOIXWN9UG
         XUMjheWi3wrUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66089C395F8;
        Wed,  9 Nov 2022 15:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nfnetlink: fix potential dead lock in
 nfnetlink_rcv_msg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166800601641.24441.15795715154161961134.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Nov 2022 15:00:16 +0000
References: <20221109112820.206807-2-pablo@netfilter.org>
In-Reply-To: <20221109112820.206807-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
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
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed,  9 Nov 2022 12:28:18 +0100 you wrote:
> From: Ziyang Xuan <william.xuanziyang@huawei.com>
> 
> When type is NFNL_CB_MUTEX and -EAGAIN error occur in nfnetlink_rcv_msg(),
> it does not execute nfnl_unlock(). That would trigger potential dead lock.
> 
> Fixes: 50f2db9e368f ("netfilter: nfnetlink: consolidate callback types")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nfnetlink: fix potential dead lock in nfnetlink_rcv_msg()
    https://git.kernel.org/netdev/net/c/03832a32bf8f
  - [net,2/3] netfilter: Cleanup nft_net->module_list from nf_tables_exit_net()
    https://git.kernel.org/netdev/net/c/03c1f1ef1584
  - [net,3/3] selftests: netfilter: Fix and review rpath.sh
    https://git.kernel.org/netdev/net/c/58bb78ce0226

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E754CEB3F
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 12:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbiCFLlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 06:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiCFLlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 06:41:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873672DD62;
        Sun,  6 Mar 2022 03:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2309C60C52;
        Sun,  6 Mar 2022 11:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70082C36AE2;
        Sun,  6 Mar 2022 11:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646566812;
        bh=9a+xIELn5RTUs4Nu8zL1uwRjkVymUDKjTRl+HJIvaDg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I/praGz+f0kLCD8UGP2ose93UwCfv+tWaNoLgYI55CzcYVunDWigpxc8Q5gLiZbfY
         2W5jHZ5FrtCY274uK42wFhuIe7D3/ME738m+lAEqv15V3HRlBwKYmomh6osz8lHyMz
         PVcYjeGWeAP3XiN4fJnmvutiZQDmohbAcnSYU5V4TW+3OqIfkq32JNwKYzbs0c0zsr
         VeD/ruCO4UnF+892ok2ghLYiNglQKqmg3+VBYRGYcEtPM+B+8OyhqTp759/7R1ULX0
         nslDHt4NavPHbylpcCK2HIecRDQ15fod/VPQKax+nun5CyUVs2IkyXl58AgOPHranT
         OOuOsQ6CI5h1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55AFEF0383B;
        Sun,  6 Mar 2022 11:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/3] tun/tap: use kfree_skb_reason() to trace
 dropped skb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164656681234.19389.3852306221775116194.git-patchwork-notify@kernel.org>
Date:   Sun, 06 Mar 2022 11:40:12 +0000
References: <20220304145507.1883-1-dongli.zhang@oracle.com>
In-Reply-To: <20220304145507.1883-1-dongli.zhang@oracle.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  4 Mar 2022 06:55:04 -0800 you wrote:
> The commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()") has
> introduced the kfree_skb_reason() to help track the reason.
> 
> The tun and tap are commonly used as virtio-net/vhost-net backend. This is to
> use kfree_skb_reason() to trace the dropped skb for those two drivers.
> 
> Changed since v1:
> - I have renamed many of the reasons since v1. I make them as generic as
>   possible so that they can be re-used by core networking and drivers.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/3] net: tap: track dropped skb via kfree_skb_reason()
    https://git.kernel.org/netdev/net-next/c/736f16de75f9
  - [net-next,v6,2/3] net: tun: split run_ebpf_filter() and pskb_trim() into different "if statement"
    https://git.kernel.org/netdev/net-next/c/45a15d89fbcd
  - [net-next,v6,3/3] net: tun: track dropped skb via kfree_skb_reason()
    https://git.kernel.org/netdev/net-next/c/4b4f052e2d89

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



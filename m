Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CA255A75F
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 07:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiFYFaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 01:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbiFYFaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 01:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29C250B04;
        Fri, 24 Jun 2022 22:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63B226136A;
        Sat, 25 Jun 2022 05:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 793F8C341C7;
        Sat, 25 Jun 2022 05:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656135013;
        bh=z0cluZQlh0hiD7cXsYiqKYRRvibJSMQQGBh5L3ooxlw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rBWoD7etR3r1q6AtWKByDYKK03v38c4BrQHaifSefIUU0V+fJ3o/U06zWCZVjzG8h
         PjpdXCByDmeFHDz5HxiDTIlo1LWuC9BdX1Z+RsNn/MNZZJyioMUaX3jFa0Xp8X/OLJ
         0Ue3IxLL7n08hnfi1QqdC2mGhXmFvHn9CCUytpPrupMwZaYHLOC/unzeug+frqxWAj
         hMEGfDsx+1FqcFNOO9ZxjFWolM8BuEcRKWNbqSaz+v18Xza2a4EpZlRaXQpIMbtPgt
         JKXYUU06wur/9DPUvkAJD7PlvBxpb4Ey5O6BKnTpCUG4pX6uJi/IAfIa6pTYcLoFkf
         fIZ2QdJUznU3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62821E85C6D;
        Sat, 25 Jun 2022 05:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: fix IFF_TX_SKB_NO_LINEAR definition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165613501339.30344.5019258234819055049.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Jun 2022 05:30:13 +0000
References: <YrRrcGttfEVnf85Q@kili>
In-Reply-To: <YrRrcGttfEVnf85Q@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     davem@davemloft.net, xuanzhuo@linux.alibaba.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, alobakin@pm.me,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jun 2022 16:32:32 +0300 you wrote:
> The "1<<31" shift has a sign extension bug so IFF_TX_SKB_NO_LINEAR is
> 0xffffffff80000000 instead of 0x0000000080000000.
> 
> Fixes: c2ff53d8049f ("net: Add priv_flags for allow tx skb without linear")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Before IFF_CHANGE_PROTO_DOWN was added then this issue was not so bad.
> 
> [...]

Here is the summary with links:
  - [net] net: fix IFF_TX_SKB_NO_LINEAR definition
    https://git.kernel.org/netdev/net/c/3b89b511ea0c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



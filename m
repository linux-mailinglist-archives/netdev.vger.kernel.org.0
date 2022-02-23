Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0EBE4C0AD4
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 05:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbiBWEKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 23:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiBWEKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 23:10:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AD565496
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 20:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 304186090C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87648C340EB;
        Wed, 23 Feb 2022 04:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645589410;
        bh=PbKeju794wEG7o8VKd2NsvG+6m+JMnyyU8u8w437gW8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eP1vvcWIvGEbVxDqxoSJ0BBYOzKhPL60jsSzCpJFa8ePk2hDNMSLy0Q85T8lgHW0V
         9jnMnGNHpzzwjsy+27x649JwqK1GwN+YhOk67AhHWPdEVKHkDX2oOgVvhwjgrnARlI
         p64gTqhq1X3m0UWGmtoEKQ5Ci8GycMGlEkWkc58W/KyzUlIGj0hEWg0NRq26xgqI0I
         65vJGJnmNo1jOTprg09zGjxYQeNBv0xrWnlqAjLFJrNx9/fkbZVcyFmtbjLK70UQIn
         nt0kFK70LI1vgxJGm+5ESQj7AOxD1CPpl+VQ5GNImPywC9cWVkA1PiMlrgROePUtFz
         K9u0vq/YroNRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E497E73590;
        Wed, 23 Feb 2022 04:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] tcp: take care of another syzbot issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164558941044.26093.15086204600598443366.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 04:10:10 +0000
References: <20220222032113.4005821-1-eric.dumazet@gmail.com>
In-Reply-To: <20220222032113.4005821-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        elver@google.com, edumazet@google.com
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

On Mon, 21 Feb 2022 19:21:11 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This is a minor issue: It took months for syzbot to find a C repro,
> and even with it, I had to spend a lot of time to understand KFENCE
> was a prereq. With the default kfence 500ms interval, I had to be
> very patient to trigger the kernel warning and perform my analysis.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: add skb_set_end_offset() helper
    https://git.kernel.org/netdev/net-next/c/763087dab975
  - [net-next,2/2] net: preserve skb_end_offset() in skb_unclone_keeptruesize()
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



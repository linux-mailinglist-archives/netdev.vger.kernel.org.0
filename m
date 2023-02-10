Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB79E691B22
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 10:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjBJJUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 04:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjBJJUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 04:20:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FECC72891;
        Fri, 10 Feb 2023 01:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D3FCB82424;
        Fri, 10 Feb 2023 09:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01C4FC4339B;
        Fri, 10 Feb 2023 09:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676020818;
        bh=JtjkZpU7dXfLrUx5EwURb8CsXyg/h7GD6ek5FjsINNs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZBiTgHGUYP7n3VIu9Rnx+u1MqnW22p8PMWzZ0HLAm8CzMOgf00DxxG+6Ap3mheJ/n
         Y9celWY9atwJvvtc1U0vOKOYfDBREtnS6wLKICK31JiO8wqdlxcxjzIgiQGXAr2OAS
         Y3MfPqMfLQA1ym8e84mGxthlAf4Omc8ljNCN2UqKbNbIhe9DxV2jLEzl94I2sJStTB
         O5MkrOMRFDAdUaqZYI8fyLscO/upVgrssgCMO1zVh2sG+UfSvEZUQtVKfnHtraWvGr
         sZsDVNpjYPMzS20VYj8yAPN+jSgYxylJ3GpHsFvK7iuFBTX929COXI4PV811cCQeir
         eTiC8/EW1hLVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9966C41677;
        Fri, 10 Feb 2023 09:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: skbuff: drop the word head from skb cache
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167602081788.32282.1728914965774061293.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 09:20:17 +0000
References: <20230209060642.115752-1-kuba@kernel.org>
In-Reply-To: <20230209060642.115752-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  8 Feb 2023 22:06:42 -0800 you wrote:
> skbuff_head_cache is misnamed (perhaps for historical reasons?)
> because it does not hold heads. Head is the buffer which skb->data
> points to, and also where shinfo lives. struct sk_buff is a metadata
> structure, not the head.
> 
> Eric recently added skb_small_head_cache (which allocates actual
> head buffers), let that serve as an excuse to finally clean this up :)
> 
> [...]

Here is the summary with links:
  - [net-next] net: skbuff: drop the word head from skb cache
    https://git.kernel.org/netdev/net-next/c/025a785ff083

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



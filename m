Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999A4522912
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 03:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240610AbiEKBkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 21:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239953AbiEKBkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 21:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B87C260878
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 18:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ED4A61AFD
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53A89C385D4;
        Wed, 11 May 2022 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652233213;
        bh=VijI675SXI/d5zJE8IBNL0hBuD6/hWthhqUU16dwiTk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pjW2HrZZfzDUmRtdujYf49suY9J3kq10KTA9dtkkNOkbomrXlh/1i5nBFNkl/lru5
         J9/sZOioV/HYfZDcJbiFb8RhPGxi0mEMw0jPB/EITyQgOVWrF1yIJ+NoiI5GNeFcz8
         Tlw+mEg96wHdA9brVmZHZ9YUkqz10GtrN4DocDXJRe8IjSF52GR1tpv4qmL+HZDoCw
         1nkOJcl5EDjEqR+cSY7ZXMLrCul0XixLFuT01wAYW9AE0muEF8ExmO/ca+GJMPO4wL
         khQHaAXbE0HDtms+4rvtqMzUyrMkw6usfNZoCMORcKrRY2SijJ1xPfMgvGBW4dj0HJ
         0g6nZSGltrpMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D3B2F03931;
        Wed, 11 May 2022 01:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fix kdoc on __dev_queue_xmit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165223321317.1620.10322165316281970001.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 01:40:13 +0000
References: <20220509170412.1069190-1-kuba@kernel.org>
In-Reply-To: <20220509170412.1069190-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, sfr@canb.auug.org.au, asml.silence@gmail.com,
        akiyks@gmail.com, bagasdotme@gmail.com, greearb@candelatech.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  9 May 2022 10:04:12 -0700 you wrote:
> Commit c526fd8f9f4f21 ("net: inline dev_queue_xmit()") exported
> __dev_queue_xmit(), now it's being rendered in html docs, triggering:
> 
> Documentation/networking/kapi:92: net/core/dev.c:4101: WARNING: Missing matching underline for section title overline.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Link: https://lore.kernel.org/linux-next/20220503073420.6d3f135d@canb.auug.org.au/
> Fixes: c526fd8f9f4f21 ("net: inline dev_queue_xmit()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: fix kdoc on __dev_queue_xmit()
    https://git.kernel.org/netdev/net-next/c/be76955dea93

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



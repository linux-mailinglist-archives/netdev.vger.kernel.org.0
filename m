Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B425711FB
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 07:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiGLFuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 01:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGLFuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 01:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E738F8FD57;
        Mon, 11 Jul 2022 22:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8438760C94;
        Tue, 12 Jul 2022 05:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C817AC341D3;
        Tue, 12 Jul 2022 05:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657605015;
        bh=/+zUdJxkD92HJvitx3n9yfnly1pUf/Z2A62BhIyELlw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d2ilwxcjEyQ1GaypVg4U4N2nBSqZ7y8rvPpEY1y3tD0vXEjFO840s2Czt5LHS7mVM
         gKUFZglbQzvs8zn5DG+sRRB8b+Pj5Z3TrXonfYXjvwKwCcE3Zxik5i7nypOp7yZOD2
         oNJV+hGtfWi1dndA3cPkuv5xpi3SOLFFj1l4mxXvGDBJ/rwaCuHP3nXvChyuZTVh7X
         9LemKPGoYTDafEDDHdIZ5Lq3KddEPc0CpafIBA7JO0aMqDLhUbDl0jM/ynXHJ5D8X3
         qlvwvWpdpzBysvq/QIgUaKHfWDd4E8AAxS4gH7moDh06GsM1eWQiPliwr9OfgDFd87
         Liijub67soRGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91C0AE4522F;
        Tue, 12 Jul 2022 05:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/fq_impl: Use the bitmap API to allocate bitmaps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165760501558.3229.12562457697234354111.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jul 2022 05:50:15 +0000
References: <c7bf099af07eb497b02d195906ee8c11fea3b3bd.1657377335.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <c7bf099af07eb497b02d195906ee8c11fea3b3bd.1657377335.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
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

On Sat,  9 Jul 2022 16:37:53 +0200 you wrote:
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> v1 --> v2: Fix commit message. devm_bitmap_zalloc() is not used here
> 
> [...]

Here is the summary with links:
  - [v2] net/fq_impl: Use the bitmap API to allocate bitmaps
    https://git.kernel.org/netdev/net-next/c/2b8bf3d6c993

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



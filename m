Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709E85711F4
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 07:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiGLFu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 01:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiGLFuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 01:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3E58FD67;
        Mon, 11 Jul 2022 22:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BA86B816AA;
        Tue, 12 Jul 2022 05:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0E01C385A2;
        Tue, 12 Jul 2022 05:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657605015;
        bh=gl1BEaDt9vR5F/Eh+L3pJAHYcYmRkoe2+ZZ1yU4QeQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pV6B+4arM0uGUthKpC1Qdr/e+251V0xrpQNK108dUAVveOk+IXsdnSqxZtc5OApZa
         E/fQ24EEdXge2IUDz4Iyob+eng9ucA83hhJuWN5JXKY+Wjg+HJU4yIwuHsZ1+ATu0r
         ajHhLqNMJMT1yPh3P6A77chcTxiW0MR6LUQxIHqC2YdWEZOgVujwSf7kXu5KaemZVi
         PID+QOkTV0EFqDfAcCEi//X2TWZkLCM3tMeFfRe6h7CTM03GH8vxwSN3nWxVx1phnR
         GoqsjteQTEZZ/1AcJMW7Vu2/Zoh12hykKapeAkwbqyhsBWO2GlRPAdvYDdyJ4ThzAx
         wYwWf1sya5WDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D1FEE4522D;
        Tue, 12 Jul 2022 05:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atm: he: Use the bitmap API to allocate bitmaps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165760501550.3229.17868755773463488393.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jul 2022 05:50:15 +0000
References: <7f795bd6d5b2a00f581175b7069b229c2e5a4192.1657379127.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <7f795bd6d5b2a00f581175b7069b229c2e5a4192.1657379127.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     3chas3@gmail.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
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

On Sat,  9 Jul 2022 17:05:45 +0200 you wrote:
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/atm/he.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

Here is the summary with links:
  - atm: he: Use the bitmap API to allocate bitmaps
    https://git.kernel.org/netdev/net-next/c/9e433ac1a381

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



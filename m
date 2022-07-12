Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78F95711F5
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 07:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbiGLFua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 01:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiGLFuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 01:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD198FD7A;
        Mon, 11 Jul 2022 22:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BAB7B8112C;
        Tue, 12 Jul 2022 05:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6BC0C341CD;
        Tue, 12 Jul 2022 05:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657605015;
        bh=bPJIT5VhJx+b0g2ZRQgpP++MkjQYWo/c8K00hajgNFU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rKKNy/UgQP9OAFp2OcLU5QddCGF3WP7XZJLA1YGQyJjinzbs2BFpnHXhp9+a76ATa
         1jyodTNplgYBXHaJKTflxaFMIGKzlRmW7u4JT6ICr2FO32GveO33FPHNdYi48ei07Q
         4v1TJ/hdc0dI8pkyh7IyII7BwUcJqxSP6dHRCO6hdWfXiT16My6FdYVqBd7j9LvYpa
         F/XGno0WXFtM2/ji7d+fPzJKCgw6YRIFCbrpLmQSDkekt/rIfgEJvYVSmibtQ37DHF
         xGVLsGvPMwE8zV3F8sGkFMqAEYfgauRAw6LDOC+fBcpDafv1EnWcI8YKiBgBLlqqfw
         s5Mjrjet0Lngw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86ADCE4522C;
        Tue, 12 Jul 2022 05:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: hellcreek: Use the bitmap API to allocate bitmaps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165760501554.3229.5901682004621317494.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jul 2022 05:50:15 +0000
References: <8306e2ae69a5d8553691f5d10a86a4390daf594b.1657376651.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <8306e2ae69a5d8553691f5d10a86a4390daf594b.1657376651.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     kurt@linutronix.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
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

On Sat,  9 Jul 2022 16:24:45 +0200 you wrote:
> Use devm_bitmap_zalloc() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/dsa/hirschmann/hellcreek.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Here is the summary with links:
  - net: dsa: hellcreek: Use the bitmap API to allocate bitmaps
    https://git.kernel.org/netdev/net-next/c/e7bde1c581e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



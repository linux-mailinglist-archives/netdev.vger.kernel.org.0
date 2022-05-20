Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8D352E175
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344183AbiETBAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiETBAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:00:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5042132776;
        Thu, 19 May 2022 18:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67D7CB82227;
        Fri, 20 May 2022 01:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1091DC34116;
        Fri, 20 May 2022 01:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653008412;
        bh=4ZIIEfoyvYX4fEoBiZJ364AXKQ8T4GQkaQ0V60+PgMQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gyuZK3CQo8iaQhx4JTHMJtfM+2nfKe/seigk1hs6Uw/4tLiv8hOuZuUmuASKRecaL
         g1hqmPQuo68cvg7P5WGwDw41Q5P8pYjBlr0JX4XJuuYCp2Mcv4VtJJ2+kpunYdONuF
         GDl/s6g9A/xdnQnBSlj2W0U/I4b19IlHOEIdgBbszcYSpkAOXqTvYmUHZVEGt9rCt7
         CmA4W0fh+bRXU84LbTMUH4xHPUxr4yusukpetybk2B47vV15IL2etdeOuAZy7ov8/G
         dIncXzsH/VESdXVZWBs+WcOgYiHiG8x8bAMirZML9RPyKFcJ2t4OLesCapXC1NGGP/
         UMK2DkGFr4cVA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D83F8F03937;
        Fri, 20 May 2022 01:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: SP7021: fix a use after free of
 skb->len
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165300841188.14248.497025533676573302.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 01:00:11 +0000
References: <YoUuy4iTjFAcSn03@kili>
In-Reply-To: <YoUuy4iTjFAcSn03@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     wellslutw@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 May 2022 20:37:15 +0300 you wrote:
> The netif_receive_skb() function frees "skb" so store skb->len before
> it is freed.
> 
> Fixes: fd3040b9394c ("net: ethernet: Add driver for Sunplus SP7021")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/sunplus/spl2sw_int.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: ethernet: SP7021: fix a use after free of skb->len
    https://git.kernel.org/netdev/net-next/c/df98714e432a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



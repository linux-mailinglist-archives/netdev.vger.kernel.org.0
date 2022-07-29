Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F880584B30
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbiG2Fa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbiG2FaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0E8E005;
        Thu, 28 Jul 2022 22:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98D2D61EA1;
        Fri, 29 Jul 2022 05:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2A7BC43142;
        Fri, 29 Jul 2022 05:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659072620;
        bh=cM+83w7omFok1JKgNk2iTdsAGrjvqD6AtFMVjC7evZM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nu63a1zpd2LE1LyiT/kaSTlw0BECNT0Whs2Vr6xMWKFgCt5HECoGp5/q6soRzLMS7
         j2kcAn0sF2mMtN7ajy5rlK/fpvqOKWG+1AJkXBvCFnjIT2Y3k7tmVac3/Px3TnjU1Q
         /Ba2e3MDcTrXPGKca7TzoBthcgc0wFQ6HcJ/sBs6GN3XGcvSpwTLyOg6DfsBcJ5E70
         P+Dj+qwkJOSQx22hSmJb7hpPzCFR4Ig74vkrMKffqUHPQ2ey/H1260eNEqyZkDnQVL
         gqkkUOyKcCkc91prbDPq5slDIplMzP6G3GqUE5WdyvwpxQ7gw9Cy1WsL4+PIlrJ5Aw
         MC9ayJGoJB7sg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D861EC43145;
        Fri, 29 Jul 2022 05:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] amt: fix typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165907261988.17632.9332710772893492418.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 05:30:19 +0000
References: <20220728032854.151180-1-RuffaloLavoisier@gmail.com>
In-Reply-To: <20220728032854.151180-1-RuffaloLavoisier@gmail.com>
To:     RuffaloLavoisier <ruffalolavoisier@gmail.com>
Cc:     ap420073@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, RuffaloLavoisier@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Jul 2022 12:28:54 +0900 you wrote:
> Correct spelling on 'non-existent' in comment
> 
> Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
> ---
> I wrote about the commit message in detail and modified the name.
>  drivers/net/amt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [v2] amt: fix typo in comment
    https://git.kernel.org/netdev/net-next/c/39befe3a43a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



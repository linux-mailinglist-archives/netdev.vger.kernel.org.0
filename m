Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A4B5FDE79
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiJMQuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiJMQuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB4B37424;
        Thu, 13 Oct 2022 09:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7851618C2;
        Thu, 13 Oct 2022 16:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B85DC433B5;
        Thu, 13 Oct 2022 16:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665679816;
        bh=/+g/Ai+yhSVdzAe1+bOeIxhxGQqimUpQH0mO6mRZ9a8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vGvLszxkDNRDg69KSEQVgc/jkMIKpcXXGxVWmgWJV9J2jNjkdHJSfOa/BhHp6Dt2B
         Q5YtVYua86gT9K6U4A9IDEVrDL4DhyB5CaKS7tTYuZkuFnJE+JPbmGnhdyDwE9JsOG
         BlCAWjqzijKNNjJuEerVYsrgf+obIZfUSd0I0H3kgG9nArXyYbptUihQbHqvnyCzmu
         wDuGetNjsv+Tl1m6YadAId2hRdAltudmJr4gWuaRDxzg6dfTDQwbW7jm9gFeMydTfJ
         PXXF4/S+LyWYxnN27MHOpzXlStyjHVLoEeY1SgbgSGZELjSnOBxbq7ssAMEDJ5ExWl
         5bZgLL0wRDNnQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DCF0CE50D94;
        Thu, 13 Oct 2022 16:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sunhme: fix an IS_ERR() vs NULL check in probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166567981589.2135.17644644029883484586.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Oct 2022 16:50:15 +0000
References: <Y0bWzJL8JknX8MUf@kili>
In-Reply-To: <Y0bWzJL8JknX8MUf@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     seanga2@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, eike-kernel@sf-tec.de,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 12 Oct 2022 18:01:32 +0300 you wrote:
> The devm_request_region() function does not return error pointers, it
> returns NULL on error.
> 
> Fixes: 914d9b2711dd ("sunhme: switch to devres")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/sun/sunhme.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net] sunhme: fix an IS_ERR() vs NULL check in probe
    https://git.kernel.org/netdev/net/c/99df45c9e0a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



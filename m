Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F64753059D
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 21:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350757AbiEVTud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 15:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351208AbiEVTuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 15:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EFA3A191;
        Sun, 22 May 2022 12:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFD7AB80D27;
        Sun, 22 May 2022 19:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97087C3411C;
        Sun, 22 May 2022 19:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653249012;
        bh=qQlX6IYidmAF5pxq2jX3J0m+XD4mMf6RSSKyAMk1fC0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eP88xIgQWGBo40w8uEKfD0sC0kxpCk2oUJCp+pPIgM+SRL2pCSTQgC6vvGgA9KR3i
         j01IyMeeBMr5msmdTEgtKE/H7oxS+SlPLNQtgHwEIdmZU5+A472rtEQrJs1MGU4Zhh
         htTLNzriwyWM3IxqUWaJ4pNKjhQWP18EvP9vQPcZHpm4pPki8zezUGqmgoH3M8CIp7
         RQB8+QpAufD4dJMRHA2luzKvUpCIVJbj7W2JCdoBnC+7j8Y9oNznxqsBKj9dHfqRB7
         KNNbAa+iu3YSoVs9VK3FkM/fISSJ3qbkOtuZ1/l/ex56ehz1RXBD9Qs2JYp3hyoQ3v
         wSjBxJ4tdnVDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7465BF03946;
        Sun, 22 May 2022 19:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mvpp2: fix typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165324901247.28407.7786184357899690611.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 19:50:12 +0000
References: <20220521111145.81697-19-Julia.Lawall@inria.fr>
In-Reply-To: <20220521111145.81697-19-Julia.Lawall@inria.fr>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     mw@semihalf.com, kernel-janitors@vger.kernel.org,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Sat, 21 May 2022 13:10:29 +0200 you wrote:
> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: mvpp2: fix typo in comment
    https://git.kernel.org/netdev/net-next/c/e34be16bee65

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



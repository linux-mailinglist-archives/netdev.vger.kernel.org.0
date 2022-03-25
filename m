Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644804E6C2C
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 02:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353110AbiCYBpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 21:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353838AbiCYBoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 21:44:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C3C9D4E0;
        Thu, 24 Mar 2022 18:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3651660B03;
        Fri, 25 Mar 2022 01:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93275C340F1;
        Fri, 25 Mar 2022 01:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648172411;
        bh=TTxPjJs7W8LtLk1EfCkrCcPng02d30Lyk5B59DLXoDU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KsQNfXSomoRKfq/BTfGGfOcRTRJQlBEgFVGMf34Y6id9LZra2OeGNS3WBxFHVXlkP
         T6cC5XGcI2ZOlawUr6Cnlg7UW6c5C/rqMKmtex7hmO/zjOvJqnAuoQBJt9kxDxPpZA
         AvkomOPNQ6+YHD6bSHlR6rBF/2El1dZJ6R4Rp2AOEC2ti6VC6L/vDM5ng/cgokyef5
         bAd5DLfIj8mn7j0qkzmbd9tEofCK4Sium28x6P+b1I913LJ8xKVZTYW/KUXNIhNYVu
         QzHYFLAB5Q8ejAxQEaA7QWDMUhzTxhAwmSPvz0vACz/BlIxZSlqQqobnXg7nWPF+E5
         SLVri8qgz9zNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75EB1E7BB0B;
        Fri, 25 Mar 2022 01:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: realtek: make interface drivers depend on
 OF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164817241147.12279.7223065793643464015.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Mar 2022 01:40:11 +0000
References: <20220323124225.91763-1-alvin@pqrs.dk>
In-Reply-To: <20220323124225.91763-1-alvin@pqrs.dk>
To:     =?utf-8?b?QWx2aW4gxaBpcHJhZ2EgPGFsdmluQHBxcnMuZGs+?=@ci.codeaurora.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Mar 2022 13:42:25 +0100 you wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> The kernel test robot reported build warnings with a randconfig that
> built realtek-{smi,mdio} without CONFIG_OF set. Since both interface
> drivers are using OF and will not probe without, add the corresponding
> dependency to Kconfig.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: realtek: make interface drivers depend on OF
    https://git.kernel.org/netdev/net/c/109d899452ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



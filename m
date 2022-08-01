Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E1758716A
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbiHATaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbiHATaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:30:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E072ACC;
        Mon,  1 Aug 2022 12:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ED8D4CE1882;
        Mon,  1 Aug 2022 19:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3ECA8C433D7;
        Mon,  1 Aug 2022 19:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659382214;
        bh=RSdenKgzgDbUZ1xdn72P3IXWtBaRKTopIQ2me2+7W3U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pckv6hSar7rbmrQOoTGxdJaoesk9NPjb3lW/xylQYd8b82lLZTEpFn7vc7qY7qOPH
         0E3WHtrvAbASozW805CQ/AmNCHNPqdSR0rpiIPgWZ8oXqTzTb5lANYCeLmScNWdh4h
         WKYprdx8hnIF3HMvcSoB1AMI2aYWUZ+4406SNvPCvGPOcyrCiFfVT+IjlRQqRFHfVG
         +yQWqwpeYeUiEQs6vAVWwcnj7Cce+ZVHQGkfYJj2NnYONZ0AQJtD4maxzTnj7Scvnb
         N93kIhA4+JwJGYWJEgeEeMW66A/j8B6C5Jp9KcJrXj73O1t36fAjl79/0ADrpEZLR1
         V8/qosEbSmHxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 23F8FC43143;
        Mon,  1 Aug 2022 19:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: txgbe: Fix an error handling path in txgbe_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165938221414.30942.4902074793645744820.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 19:30:14 +0000
References: <082003d00be1f05578c9c6434272ceb314609b8e.1659285240.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <082003d00be1f05578c9c6434272ceb314609b8e.1659285240.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jiawenwu@trustnetic.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 31 Jul 2022 18:34:15 +0200 you wrote:
> A pci_enable_pcie_error_reporting() should be balanced by a corresponding
> pci_disable_pcie_error_reporting() call in the error handling path, as
> already done in the remove function.
> 
> Fixes: 3ce7547e5b71 ("net: txgbe: Add build support for txgbe")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: txgbe: Fix an error handling path in txgbe_probe()
    https://git.kernel.org/netdev/net-next/c/2e8f205d910e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



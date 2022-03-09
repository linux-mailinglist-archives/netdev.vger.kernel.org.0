Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3584D2EF2
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbiCIMVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiCIMVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:21:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1098C175826;
        Wed,  9 Mar 2022 04:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F43E6195E;
        Wed,  9 Mar 2022 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 079CDC36AE3;
        Wed,  9 Mar 2022 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646828411;
        bh=ruvNF2r2MEvL+lu5OO6O46gNS5mOKDsC35sbWKd8Z1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uPJBnve86UL5XtjMM7wVVtDWjl4zXhIfmLvXhx91rSGZQaTJ3C/0LsLh/DqlrKWVv
         4LI/3C4KeGwpdUSMyFw9QZ0o5UjBiIOjv0/D2ZOAQfTal7TX6Rtx6jSAQSdjffkvkT
         IFWC8oX+BdrX17IPLjALBDuDTJ2t6mwux9zs55F9cVNwzKpnV7xrraTOSHzchS4IRI
         Q4aUox8QPAn6ROb2swIg9wJQofFK0pWGh3POyzX2FGpzly05dY1PIfv2il6tmYdEGg
         xBS0Z0yzTasYtWdAGPLCFB0dAPx35taPill2u6EsbqQWTmcUpsryiXT+IQnYFG3jEr
         sDu19b1TXSAZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0644E73C2D;
        Wed,  9 Mar 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: lpc_eth: Handle error for clk_enable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164682841091.19405.13712560190940990442.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 12:20:10 +0000
References: <20220308065739.1068782-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20220308065739.1068782-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     vz@mleia.com, davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  8 Mar 2022 14:57:39 +0800 you wrote:
> As the potential failure of the clk_enable(),
> it should be better to check it and return error
> if fails.
> 
> Fixes: b7370112f519 ("lpc32xx: Added ethernet driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> [...]

Here is the summary with links:
  - net: ethernet: lpc_eth: Handle error for clk_enable
    https://git.kernel.org/netdev/net/c/2169b79258c8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



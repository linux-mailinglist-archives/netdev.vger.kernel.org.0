Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F684DBD28
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 03:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358469AbiCQCl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 22:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbiCQCl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 22:41:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2904D1FCEB;
        Wed, 16 Mar 2022 19:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6ED5614FF;
        Thu, 17 Mar 2022 02:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B875C340F7;
        Thu, 17 Mar 2022 02:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647484811;
        bh=aYdUrgw8/IglXx8axGitcK3uGwS71gfO9jM+NaC3evY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gVfjhHNroMTsx0EPvPu/2UYb83st04LDinYEoQHoYt887mnAt6vLV/kS5HR5MAAI4
         wA4pGHf/bOTc2EjPjRmIfpranOWfRsDasvpJOxQr8mTcAOwf8r4ksYgv8mOJza6C5G
         LIhy2nKr73zPrSIIcThtYIo8gqbuIE/ouXzfDaei6UyZaK0ndsp0JlF/cY7SuWwzMp
         5jz6vUMc4J6UBzBMwJobS931O0kE/wf5Sy7rNAG8Q32NfxQChGMYqRhJrR8JiGqe8S
         Dk+uRiFvYdzsXAgQIIIh5BwunERR00LOm+TcjTtC3afIpedITY48CZlU6x7JK5tyho
         2Pf9dG+g0kOug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2730F03846;
        Thu, 17 Mar 2022 02:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] net: mv643xx_eth: undo some opreations in
 mv643xx_eth_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164748481085.31245.4456158628838052950.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 02:40:10 +0000
References: <20220316012444.2126070-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220316012444.2126070-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     kuba@kernel.org, sebastian.hesselbarth@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chi.minghao@zte.com.cn,
        zealci@zte.com.cn
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Mar 2022 01:24:44 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Cannot directly return platform_get_irq return irq, there
> are operations that need to be undone.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [V2] net: mv643xx_eth: undo some opreations in mv643xx_eth_probe
    https://git.kernel.org/netdev/net-next/c/571703ff387c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



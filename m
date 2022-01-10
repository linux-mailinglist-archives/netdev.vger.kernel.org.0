Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DF9488DBC
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbiAJBAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59074 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbiAJBAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D135961119
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 01:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32632C36B0B;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776414;
        bh=0/Khdx1G0Qa5rOwax8seXwHBNXPtZVVCQTqp73/u0CM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RQ4kveDEpSSUW9VJKvOFyBW6OLkJ9omjEY5QQtIHvw2Mkb+n6TmVWidb3wl+lqWwL
         pY1+kj1um/iVBBn8VO9n20Z8XgTSNsf0WoPdCZ/56dGKg2LI0FXXhOv7IweIdUMoZ6
         2IcV3Z7rHEEih3vyX5nViTOFvBAky/jHmuZLeWhKuloecfrL4hsMoXXks7doHa/JbF
         OQk4BHDpjEdXN/U0U0na06iVs11gq8jh3ldLinPexIuxwj77T6yDFQdJNAlo2D6kQd
         5bGsVd0SwiFw/zjcOwhRcEm8RAso8FywgoNPko1ymCLWJoAS+VmO7AVATMHk2N8Ufc
         Wz5dHMvxCrE5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C259F6078F;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: allwinner: Fix print format
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641411.18208.12653754291420226468.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:14 +0000
References: <20220108034438.2227343-1-kuba@kernel.org>
In-Reply-To: <20220108034438.2227343-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, keescook@chromium.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  7 Jan 2022 19:44:38 -0800 you wrote:
> Kees reports quoted commit introduced the following warning on arm64:
> 
> drivers/net/ethernet/allwinner/sun4i-emac.c:922:60: error: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'resource_size_t' {aka 'long long unsigned int'} [-Werror=format=]
>   922 |         netdev_info(ndev, "get io resource from device: 0x%x, size = %u\n",
>       |                                                           ~^
>       |                                                            |                                      |                                                            unsigned int
>       |                                                           %llx
>   923 |                     regs->start, resource_size(regs));
>       |                     ~~~~~~~~~~~
>       |                         |
>       |                         resource_size_t {aka long long unsigned int}
> 
> [...]

Here is the summary with links:
  - [net-next] net: allwinner: Fix print format
    https://git.kernel.org/netdev/net-next/c/009e4ee381a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



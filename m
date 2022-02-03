Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101C24A90F4
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 00:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355906AbiBCXAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 18:00:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34434 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238236AbiBCXAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 18:00:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95F9461857;
        Thu,  3 Feb 2022 23:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0241BC340EB;
        Thu,  3 Feb 2022 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643929209;
        bh=xG9Vb129YKjRhraPRERPha+AEnhPVoJ7a5WjOMrgaeU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dtKRCoW8qndvtNlR6dhPX/Ob5y4VyTN3YyIVXdVw9slI8G8TlKxTLP3Ou1vxvhsqW
         Rbr9wF61A2JV/wbAd2gTKG6sa6edNevFU+ibqSWj4av93FXPDLPwXjdjJzwZfI+n6t
         nfXNLMfNNK3fbdwl0tYk3dBlirDYiUZY+SoPge/FDfHAL+RRYsYTpfDSO+sC/sF00l
         qFL6E9sJqGTmoD+mI8uTKd9CVd5cR6z2NqLXNW/6cfIyWWfjRbEjeYk0isIlqcgtC2
         LzrP6+baBa44/0xNeibv+tAmdzb+Gdyrb3kCAOkkJYSPa8nM4WBknSerzOsVInO4Pv
         tTvihmu4/YygQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF1ECE6BB30;
        Thu,  3 Feb 2022 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ax25: fix reference count leaks of ax25_dev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164392920890.21168.4177402356117050169.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 23:00:08 +0000
References: <20220203150811.42256-1-duoming@zju.edu.cn>
In-Reply-To: <20220203150811.42256-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, dan.carpenter@oracle.com,
        thomas@osteried.de, jreuter@yaina.de, ralf@linux-mips.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  3 Feb 2022 23:08:11 +0800 you wrote:
> The previous commit d01ffb9eee4a ("ax25: add refcount in ax25_dev
> to avoid UAF bugs") introduces refcount into ax25_dev, but there
> are reference leak paths in ax25_ctl_ioctl(), ax25_fwd_ioctl(),
> ax25_rt_add(), ax25_rt_del() and ax25_rt_opt().
> 
> This patch uses ax25_dev_put() and adjusts the position of
> ax25_addr_ax25dev() to fix reference cout leaks of ax25_dev.
> 
> [...]

Here is the summary with links:
  - ax25: fix reference count leaks of ax25_dev
    https://git.kernel.org/netdev/net/c/87563a043cef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



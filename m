Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6684C47057B
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240822AbhLJQXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240831AbhLJQXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:23:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B68C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6401DB828FF
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 16:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6FBDC341C6;
        Fri, 10 Dec 2021 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639153209;
        bh=8Hp1YPRgloGaYq2DgIGq30ZZylV2nUegCe33+zy6AAo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T1bTGFhaXay282fyIexD8l8trsC08LaI0nKuBjVc2O0FJgmjJHDHgNLnH+PokKqyN
         IQffejJhtezwBjMePVqrMOCrm+wHH6Xf1qrG2WpIB/qmIizAf4KsXpL9/xzjI7vViY
         2zOkAaqr3chJtBAZOHt4dY6CIhTStCjJU9BDBvjEisyqRIi5b2czDearQjcwmQPEVZ
         HsGYteGJCRSsPkmwP1yRFJ3ku7nnLbZV/3YLp77jozQzPVeySVdo6963tQGKXR+9h0
         gfg/J7OezGRmus8rfhyVWBva/dN8XCMoRfCM2Bnq+aqIm1lJDRfPO0g7yx0p0Ed1jK
         p4v49k8zBTU9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B646F60A36;
        Fri, 10 Dec 2021 16:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net] sch_cake: do not call cake_destroy() from cake_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163915320974.27071.1527909177318994624.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Dec 2021 16:20:09 +0000
References: <20211210142046.698336-1-eric.dumazet@gmail.com>
In-Reply-To: <20211210142046.698336-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com, toke@toke.dk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Dec 2021 06:20:46 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> qdiscs are not supposed to call their own destroy() method
> from init(), because core stack already does that.
> 
> syzbot was able to trigger use after free:
> 
> [...]

Here is the summary with links:
  - [V2,net] sch_cake: do not call cake_destroy() from cake_init()
    https://git.kernel.org/netdev/net/c/ab443c539167

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



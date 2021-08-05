Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147E93E12C8
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 12:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240199AbhHEKkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 06:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232312AbhHEKkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 06:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A7946610A2;
        Thu,  5 Aug 2021 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628160006;
        bh=eQr2TNJrQoemKgkCIY4xgJwC+7WPOUAwTtmYMR2ZxRk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rF6MFz2ONJgAiyAHudtdb5HiLhJUC/uoYpst/RNAWCdx3zjy30C1iJ9hjrGV9vVRQ
         SJpm4aRjlMIZbM6jaXNKFoKL7n6AiP8yLDkirvEtuSMGlFLAGMtcZKc/V8dLaqdOry
         CTY8Xh7UdOkP1mfSLLjMz7eQyTFK0/D3UOc4pNY0WFjVkp4I4TySZnnuS3/m+kPhnJ
         tQ21pV/ErNLz/rnyKox/cVxYC1qJLcy9jdvMs+NuBC/kaFmv3hUwcjPaDwwvEetSOW
         BlzBgo+OokzGLj/g8hb3jWofS6Ec/ml0leeJLos1J1YNjRoX2smgTHgAhGx4MJo7rj
         AAWvvn3kgBDmg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9B30860A7C;
        Thu,  5 Aug 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fix GRO skb truesize update
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162816000663.17050.9067495109640433432.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 10:40:06 +0000
References: <9134e63fd0d42787e4fbd4bd890d330d6fda9f81.1628097645.git.pabeni@redhat.com>
In-Reply-To: <9134e63fd0d42787e4fbd4bd890d330d6fda9f81.1628097645.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  4 Aug 2021 21:07:00 +0200 you wrote:
> commit 5e10da5385d2 ("skbuff: allow 'slow_gro' for skb carring sock
> reference") introduces a serious regression at the GRO layer setting
> the wrong truesize for stolen-head skbs.
> 
> Restore the correct truesize: SKB_DATA_ALIGN(...) instead of
> SKB_TRUESIZE(...)
> 
> [...]

Here is the summary with links:
  - [net-next] net: fix GRO skb truesize update
    https://git.kernel.org/netdev/net-next/c/af352460b465

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



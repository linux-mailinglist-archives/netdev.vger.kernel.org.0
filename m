Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD0A367245
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244232AbhDUSKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240952AbhDUSKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 14:10:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2CD1761435;
        Wed, 21 Apr 2021 18:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619028609;
        bh=USuuWsJ1gBE2x6CH0iH7AojvNEEpAjyMSraWW8nP1Cg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i5jVbfxvE0cgSeBZ+kRP1A+f8FeK6TCK/opVMxRbRcTZp2C4MHDTjPgaQB+nT7HGZ
         OriyWjNOT9WJxosysMZqAMZRqAG+e/MJkYAd7D1aYAnduPX+9D+x2FlupSC/fGOLNV
         Wd/2SUAIwBI/2xT5BRLWNy0DVtClHI09O88lT6x/Cyrjbepi52o2Ia1PNPnZo8PMJv
         Q3poC7SOFGNspQrTC80NxFlICKIxkBqc4QtPOA+AuD6D+d5aslD09bkVjPYk5IkY4Q
         fTGg55F/yCi/mM9HbH0w4qBerdBOuc/DFzLM1oj3d3BCHpPfx/EAdK0hILoFeJD7CW
         a4e0azbPT6VUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 23EB7609AD;
        Wed, 21 Apr 2021 18:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qrtr: Avoid potential use after free in MHI send
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161902860914.28303.4568064883705440314.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 18:10:09 +0000
References: <20210421174007.2954194-1-bjorn.andersson@linaro.org>
In-Reply-To: <20210421174007.2954194-1-bjorn.andersson@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     mani@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Apr 2021 10:40:07 -0700 you wrote:
> It is possible that the MHI ul_callback will be invoked immediately
> following the queueing of the skb for transmission, leading to the
> callback decrementing the refcount of the associated sk and freeing the
> skb.
> 
> As such the dereference of skb and the increment of the sk refcount must
> happen before the skb is queued, to avoid the skb to be used after free
> and potentially the sk to drop its last refcount..
> 
> [...]

Here is the summary with links:
  - net: qrtr: Avoid potential use after free in MHI send
    https://git.kernel.org/netdev/net/c/47a017f33943

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AA334F268
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhC3Uu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhC3UuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 16:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E313D619BC;
        Tue, 30 Mar 2021 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617137408;
        bh=98kqGMBRnwrEtsNDWdxLgCVzrH/pvfmwINwRdQiHSiI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gd8T06n2wPuNTK+eVcBvpYWKDMkl3VqoZnE/JwFOyG3+Dx1SR8OFdOZdARmKcj8uO
         S/H9J9+b07N4voL6tg1THqgg+uUWpEvJzHnDERR43bVpbLQyir3M8+GJNrtbMvFRVI
         4Ii4L2MVyjfC512BcSoBZqLwrLi/OA1xBk2jMGxxtoZLx8QEWHMsWglNjoP4CgOJGc
         L+k3zj2WXByYsYeEGSYjWHMj54p7e+xJeUCdXnhvIkz4yVC8itUvo7TrSleWbNs3xs
         mA2zkUKcD+uGUVSe1q4u65p5uhdfKu70FQH1XhmF9sKyXJsRerhojH8oWrZrA66fH1
         Xp1EARNvW+zxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DA68660A5B;
        Tue, 30 Mar 2021 20:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qrtr: Fix memory leak on qrtr_tx_wait failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713740888.14455.11125778543288777755.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 20:50:08 +0000
References: <1617113468-19222-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1617113468-19222-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     manivannan.sadhasivam@linaro.org, netdev@vger.kernel.org,
        bjorn.andersson@linaro.org, kuba@kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 30 Mar 2021 16:11:08 +0200 you wrote:
> qrtr_tx_wait does not check for radix_tree_insert failure, causing
> the 'flow' object to be unreferenced after qrtr_tx_wait return. Fix
> that by releasing flow on radix_tree_insert failure.
> 
> Fixes: 5fdeb0d372ab ("net: qrtr: Implement outgoing flow control")
> Reported-by: syzbot+739016799a89c530b32a@syzkaller.appspotmail.com
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> 
> [...]

Here is the summary with links:
  - net: qrtr: Fix memory leak on qrtr_tx_wait failure
    https://git.kernel.org/netdev/net/c/8a03dd925786

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49AE3A6FD7
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbhFNUMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234866AbhFNUMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:12:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A9C3F6134F;
        Mon, 14 Jun 2021 20:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623701403;
        bh=G2fXRs/94NeTqMMqJICSXSVM/FXQTKFbAzQvgAKg7r4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lpfvZyTYU+7iaWwMgZA62Pe10nXRSPS7XVLX0V8EGzEnn5ZNPj4re244yK2IQZ8ol
         tGoZZg8R8U4EeW4HcyCAXrnHKGjLru8sEfHqfFx8YilLVJ0gH8BlLEGNCj5y0seCjx
         stFinSU3nzIEo9Ju1JJrwWVxzX6EP8rthlMb1D6n7IcXjRB4eaxwwttPX/vVjA2Fb8
         MzoRifuGg2JxKdgASrIX/1l1p1JzRVudYFDrTUYZ+R5Xz/tJTK/VUNOgeHautGLxaI
         Sa7wggXMvK2fwEII2m30qt2w3yMgFkmmASG06fKAU5gTVl0oQBfN0+acX1/qSHVtqG
         mPdjfDcpEdqFA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A0FB3609E7;
        Mon, 14 Jun 2021 20:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qrtr: fix OOB Read in qrtr_endpoint_post
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370140365.19720.3346569665571735760.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 20:10:03 +0000
References: <20210614120650.2731-1-paskripkin@gmail.com>
In-Reply-To: <20210614120650.2731-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     mani@kernel.org, davem@davemloft.net, bjorn.andersson@linaro.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+1917d778024161609247@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 14 Jun 2021 15:06:50 +0300 you wrote:
> Syzbot reported slab-out-of-bounds Read in
> qrtr_endpoint_post. The problem was in wrong
> _size_ type:
> 
> 	if (len != ALIGN(size, 4) + hdrlen)
> 		goto err;
> 
> [...]

Here is the summary with links:
  - net: qrtr: fix OOB Read in qrtr_endpoint_post
    https://git.kernel.org/netdev/net/c/ad9d24c9429e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



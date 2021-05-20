Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE6238B9B5
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 00:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhETWvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 18:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232024AbhETWvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 18:51:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FE71613B9;
        Thu, 20 May 2021 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621551011;
        bh=INlJrjoYl9PGqisEjhreiwAhlj09cRI+A9LvyVQpKIQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IBqNetNdp1CaU1Sc3lCqkKI8frgIgDFO5oFKUlZ2sanzlBmjInUsh/YtnNFE4gQW3
         kmLecEf5Wymw2n1rFKdgizJaEt9HD/KR2L4O5vn0gJdhudI48NZJr+Y5rmz2+bVM8Q
         pSdh0p9qyXdVXCnxB4bCVDf8N95AzowkLGMl2+4/0VifuZ6ZLAD+deM5dqCTksHAmh
         0PD8+u4M/uf+5reGI+cHmAzNkv9MXzdo3pUiU8oZaig54IynihIDdqyCxpaotZ91sz
         dhchPnZUr+spUjb+qhMyl0OCPzQh+8eI4t6VinvwuAs42zLSdLX+zoNVaJa7JzwTJS
         rLBNXTCNNvydA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 89A7860997;
        Thu, 20 May 2021 22:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND] NFC: st21nfca: remove unnecessary variable and labels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162155101155.27401.15694736044196651874.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 22:50:11 +0000
References: <20210520010550.31240-1-samirweng1979@163.com>
In-Reply-To: <20210520010550.31240-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     gustavoars@kernel.org, hslester96@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 20 May 2021 09:05:50 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> assign vlue (EIO/EPROTO) to variable r, and goto exit label,
> but just return r follow exit label, so we delete exit label,
> and just replace with return sentence.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> 
> [...]

Here is the summary with links:
  - [RESEND] NFC: st21nfca: remove unnecessary variable and labels
    https://git.kernel.org/netdev/net-next/c/4b99b7498277

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



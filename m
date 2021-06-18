Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C673AD346
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhFRUCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231737AbhFRUCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 16:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E54B9613C2;
        Fri, 18 Jun 2021 20:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624046403;
        bh=JSu9ICkYzplIjqBEqGM1scVIEGeBoatSK2dnZNLTvB0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iTh5+z4Cy4bG9l3ntlNCTosibal/+xipIwfu2EsbsHRxt2tni3C6wJTEhG1kEJQRc
         Yj+icgVczoNFhFKARFoYBQ8Uw54MGqe0uPYGX3p5J0a5N/xFvgRDt/Aktt/pCjjypC
         UsDTP80cdjR31QtmRfrLVZypGyccJJxPj+bkio1e4T5lRR0x4fM46Cinjm4/2F9CPU
         JmQKOjSpYnDE4R8Lg8UZ0a/Zf78BQo4FwQoIOq3zNpQxWcAzYdwal2G06z4EgFg5ZB
         v6XmW13MIiUGw5yTq3dqoFgguOySWu4cbcwWR/bFKX0WeInE8/SG0FDNkNNr3l3UaH
         lTIXi2ZTj3F3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D6CBD60A17;
        Fri, 18 Jun 2021 20:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] NFC: nxp-nci: remove unnecessary label
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404640387.428.16418769926643653562.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 20:00:03 +0000
References: <20210618085226.18440-1-samirweng1979@163.com>
In-Reply-To: <20210618085226.18440-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     charles.gorand@effinnov.com, krzysztof.kozlowski@canonical.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 16:52:26 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> Remove unnecessary label chunk_exit and return directly.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/nfc/nxp-nci/firmware.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [v2] NFC: nxp-nci: remove unnecessary label
    https://git.kernel.org/netdev/net-next/c/7437a2230e39

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



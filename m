Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA0234C09B
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 02:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhC2AkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 20:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231258AbhC2AkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 20:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DE84A61954;
        Mon, 29 Mar 2021 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616978409;
        bh=cuHaFcw+ilIzpxFiXsGyq1JNFiZocYzN+Pz6k8nCJUc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kTYiOHu9tawSNDBm5L29ItQTfUCX5itUG4Vn78JDhcQJ7hli3npc14Whno3gkCswi
         nq7t1OI5aqKk7O6hBkbKauP26PTkFSMNXVLu6FC5RS/Kv7wQblFxxCwkKmP37oVjbE
         uc0Rrl2EWL1PWZMnNNwoKl0sVj6DZuOGRdf2tD1Hh832s/ghQp2MAnaPjmZ76hWAWd
         LJkgL2u/MjKoLIlVar4/1c1p8WBSfctPYrjsW1mKz4wtYQkIV1P5aW4dRYArVVCIUn
         GkRd6zlK9k76Xd4sf8w2+gFBtPAQnCCJdzkZ8LIVSwSGQk1KBDUBjMVhLCnsdyWQkL
         nqQ0RqZ20SyIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D648960A3B;
        Mon, 29 Mar 2021 00:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ncsi: internal.h: Fix a spello
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161697840987.22621.9903626943849247862.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 00:40:09 +0000
References: <20210326231608.24407-12-unixbhaskar@gmail.com>
In-Reply-To: <20210326231608.24407-12-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 04:42:47 +0530 you wrote:
> s/Firware/Firmware/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  net/ncsi/internal.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> [...]

Here is the summary with links:
  - ncsi: internal.h: Fix a spello
    https://git.kernel.org/netdev/net-next/c/195a8ec4033b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



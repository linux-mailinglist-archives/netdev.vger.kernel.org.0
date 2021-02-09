Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7D7315461
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhBIQwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:52:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232898AbhBIQuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 11:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A2FD264EAC;
        Tue,  9 Feb 2021 16:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612889406;
        bh=cb58caZa/ePtgtnfHpUuGlhvL9WcchbQK37K8FlJOoY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OIbHHNxtN6og5JnwUbAxskksdYdes1LvBlzabY3tPAJioNdcXNrjl0bDq5RTvtyXZ
         GwFrmmkXQsMkLr1i8mitmAKym9b0sLVNWUWWpxS5bDRqS7tve36c6uqS3OuZDVqXpJ
         gXWgLVLL82AWY0Aa05GD5nQl0C4nlORRDxemBqeWu/b49KgPjLqpscNkKrStNfKoGE
         ObdEE7zrUrhzXrK3w7jGDNN2bhyFtd/PT8Mqw9eH9x1UIY8LjR/eYBA/nop+XjoqfT
         HsInj1+RrBl9dXV7Rq7j36PJYq9icJ65cbwi7mP3is0Q0rBakVQ/DEzO+mTDECi7gy
         hlXDFZgwa/NwA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9848C609E4;
        Tue,  9 Feb 2021 16:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool] gitignore: Ignore .dirstamp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161288940661.5204.6235090896302129954.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 16:50:06 +0000
References: <20210205005615.1058972-1-f.fainelli@gmail.com>
In-Reply-To: <20210205005615.1058972-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (refs/heads/master):

On Thu,  4 Feb 2021 16:56:15 -0800 you wrote:
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .gitignore | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [ethtool] gitignore: Ignore .dirstamp
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=b9af58abce8a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



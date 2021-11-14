Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15DE44F7DF
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 13:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbhKNMdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 07:33:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235827AbhKNMdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Nov 2021 07:33:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 40BD8611AE;
        Sun, 14 Nov 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636893008;
        bh=4JYK+nb3MGMSP+tgIz2mcAMU1W1ZOtFNhEZsWCPhqQs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QFzCyDf3L2UbMAxCNe+Fgr8all/q8WIV5/tykCeNOSCqV45UyeKOvUrGu9mxc9ZB9
         axjbVJiq7UzKQ8O0nYcMIy1rGg9i1nIhZjWwu4bd2phK6JPmnaz2MJnoFTM8md/1f6
         KPiPuXUkx2h1nMerK4pplfeBefZizO7wLfcb2qMnyRHbbLDhmCMBaVNaG6eOTLCY74
         Hz0foLo4Ut8hFp4vpv/wvosHKlfdwrtGFFO26R2tF3G/P05MbfhgLqv/l4TPBNtp0J
         tSflge+nqyoqqABPpLJM/IaAs2P4AjWeF50G3Gxjmj/rzPkqmwNEc5ZscCqqlw+i0K
         8IJ/vXydYwZMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3157360A6D;
        Sun, 14 Nov 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux-next] ipv6: Remove duplicate statements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163689300819.19604.5480020679609941607.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Nov 2021 12:30:08 +0000
References: <20211111150924.2576-1-luo.penghao@zte.com.cn>
In-Reply-To: <20211111150924.2576-1-luo.penghao@zte.com.cn>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo.penghao@zte.com.cn,
        zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 Nov 2021 15:09:24 +0000 you wrote:
> From: luo penghao <luo.penghao@zte.com.cn>
> 
> This statement is repeated with the initialization statement
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [linux-next] ipv6: Remove duplicate statements
    https://git.kernel.org/netdev/net-next/c/1274a4eb318d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



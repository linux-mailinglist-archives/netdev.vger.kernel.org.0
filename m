Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BC33E2777
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244184AbhHFJkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244493AbhHFJkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 05:40:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ED579611BF;
        Fri,  6 Aug 2021 09:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628242806;
        bh=atLPM6clZwbfjCynK9r6h5Z+NrQCLqpzgxnbtvlPL10=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p/vlG+MF9FZIgn7SFC1DSfjNuEQlSR+Y7+uR4/THrIwZ2W7BLNnLMXx2LNFYp7pyL
         s08A6HmSJ+uv+hmRGVzhgyR+m+2gfHEihlXFz432TjgOgppYOM8jfFW9BXAJ6356d8
         R4qA5cJdTp+2GdoNH63Uu3HWVY5mGRveR7y7NDzBDsWYlB93Rb7XR5qepL/BLqzo0b
         uBtBn8D3+r1ZnCcGMvTyjpCS/oSk38oPueEO+CQPd2hLcXNOsYhTa6EoAdx8HaEGQH
         JOpExMnVGNKaU9HLcin/2NiiOgL/iRWnLJrdyjanBaMzJlXXBUmsA9BieQjpTQWS0x
         tT9U6vxvsEWSg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E332760A72;
        Fri,  6 Aug 2021 09:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethtool: return error from ethnl_ops_begin if dev is
 NULL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162824280592.22626.3905645517981701019.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Aug 2021 09:40:05 +0000
References: <21a1abb0-300f-ccae-56da-16f016c4fff2@gmail.com>
In-Reply-To: <21a1abb0-300f-ccae-56da-16f016c4fff2@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jwi@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 5 Aug 2021 21:08:22 +0200 you wrote:
> Julian reported that after d43c65b05b84 Coverity complains about a
> missing check whether dev is NULL in ethnl_ops_complete().
> There doesn't seem to be any valid case where dev could be NULL when
> calling ethnl_ops_begin(), therefore return an error if dev is NULL.
> 
> Fixes: d43c65b05b84 ("ethtool: runtime-resume netdev parent in ethnl_ops_begin")
> Reported-by: Julian Wiedmann <jwi@linux.ibm.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] ethtool: return error from ethnl_ops_begin if dev is NULL
    https://git.kernel.org/netdev/net-next/c/596690e9f4fc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



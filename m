Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88109466378
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357877AbhLBMX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:23:56 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58694 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357834AbhLBMXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:23:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 24342CE2280;
        Thu,  2 Dec 2021 12:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22701C5831B;
        Thu,  2 Dec 2021 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638447611;
        bh=eM6BodfMV9gJp4vKa2ULke3IM2lfPcnrbIg3sD1NZdE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L7A0FlX8oG1dU+B7LpYOTVjgs6ArKvzmlltl+3s6TFB5vtN8/mvSxZmb5V297rTJL
         7Q0BLK9pbOElHAhsDzwvvvHLvvW4ZFR5/uA3hSgXsCyRev4GewdDGXg/Bb1RSXG/z4
         wJMxfG3R/nIRKWVazP1GVIHJfcTvRK4pHUvu2ANm/tM9p2TIofwHujHKeoDcH3ywXr
         gYlVk6BuFUTgdSonUSPSdGyWPCRvUOqRFmLKm7LkHgXvgOqD8bFme/0J7fIygTII3b
         TRdgvz1Il5E9nOSuoaSAb9881DGSQtXb5TMDR8zK4ANQEjwp2ylS42FVEtj9K/vk8X
         39zlKvnolxX/A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1208B60A88;
        Thu,  2 Dec 2021 12:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net/smc: fix wrong list_del in smc_lgr_cleanup_early
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844761106.9736.2889381250476751836.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:20:11 +0000
References: <20211201030230.8896-1-dust.li@linux.alibaba.com>
In-Reply-To: <20211201030230.8896-1-dust.li@linux.alibaba.com>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        ubraun@linux.ibm.com, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  1 Dec 2021 11:02:30 +0800 you wrote:
> smc_lgr_cleanup_early() meant to delete the link
> group from the link group list, but it deleted
> the list head by mistake.
> 
> This may cause memory corruption since we didn't
> remove the real link group from the list and later
> memseted the link group structure.
> We got a list corruption panic when testing:
> 
> [...]

Here is the summary with links:
  - [net,v3] net/smc: fix wrong list_del in smc_lgr_cleanup_early
    https://git.kernel.org/netdev/net/c/789b6cc2a5f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



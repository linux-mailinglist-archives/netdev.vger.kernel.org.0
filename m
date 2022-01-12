Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6041248C631
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354186AbiALOkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354167AbiALOkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:40:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF52C06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B9CA61826
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 14:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F5EAC36AEB;
        Wed, 12 Jan 2022 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641998409;
        bh=xizOLRLp1yo8D27OtV7lXUDHWaIJfrN2bJh10yiUHVg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AIC/HyPDgzBZwsHaH/7Yr66aBq7mDQer64Qlx7h/gHF6g8Yf7S2Fg1C82UuDenBrL
         fkN5mtrdpi8q+8B0hnT6yUIbDzHD28sBoceF33Somo9mVx7XztZJqzzB0c+6z5abGn
         ksD3Nal2bgf2KOiHfFXpY74BgDCr0Kn//ci92fiG0IbPGw1WQt3nKmjH3ajLTe6KY3
         OuRd8yrrWDNOvNli948w5jAkKtP38Yo42irZfPkvzSMd5DVKlT6NTqyx/5nVbawm5Z
         VOZ7OqQQ3zNIYswICjY/lcmJYeleU+at1l2HmtziCbatAhVF+X/7D+tZinbey3AJ7w
         lzXT9wdOLbg8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 795A9F60796;
        Wed, 12 Jan 2022 14:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ref_tracker: use __GFP_NOFAIL more carefully
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164199840949.8584.730720068136078295.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 14:40:09 +0000
References: <20220112111445.486446-1-eric.dumazet@gmail.com>
In-Reply-To: <20220112111445.486446-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, dvyukov@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 12 Jan 2022 03:14:45 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot was able to trigger this warning from new_slab()
> 		/*
> 		 * All existing users of the __GFP_NOFAIL are blockable, so warn
> 		 * of any new users that actually require GFP_NOWAIT
> 		 */
> 		if (WARN_ON_ONCE(!can_direct_reclaim))
> 			goto fail;
> 
> [...]

Here is the summary with links:
  - [net] ref_tracker: use __GFP_NOFAIL more carefully
    https://git.kernel.org/netdev/net/c/c12837d1bb31

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



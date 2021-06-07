Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A06C39E88B
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhFGUlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhFGUlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 16:41:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A3BA261139;
        Mon,  7 Jun 2021 20:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623098403;
        bh=IABVrMBrXxsDM4KwxSJlv8rO0klc0TfJOUpQ0RC+ZwY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fNT0OUIHTR+JyuYTwDWffIKmVr+AtialtvRqYocRwCLpslrFKGQAOPWyysXpzi+yS
         9UOq1NGXZr5xQ7mPf6pyzHGsnrketC3s/E86g48zTm5mXb5Un2RezNVLa4YAzrpdet
         eDhxFBBm5xXa94DBrK/fdhwg+4hxFB62+do/NA5r8LjuOPG8xVHiv9S9T1NUkNb78F
         l5qNCcGCxtwpGlyRH5/LL3lUmrq0NiWKrQomjAjsEdowFRMJXfcA8/nErxhh+hfdux
         tU6kp5M2NriFuyLa3pDyqtJwd00pBYvIlglG6wHB4JkGugCR84MgHy9fs/lRQogTkW
         Sl2xQXxpcc91A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9814060A16;
        Mon,  7 Jun 2021 20:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] revert "net: kcm: fix memory leak in kcm_sendmsg"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309840361.17620.5467559942095073860.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 20:40:03 +0000
References: <20210607184623.6914-1-paskripkin@gmail.com>
In-Reply-To: <20210607184623.6914-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+65badd5e74ec62cb67dc@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  7 Jun 2021 21:46:23 +0300 you wrote:
> In commit c47cc304990a ("net: kcm: fix memory leak in kcm_sendmsg")
> I misunderstood the root case of the memory leak and came up with
> completely broken fix.
> 
> So, simply revert this commit to avoid GPF reported by
> syzbot.
> 
> [...]

Here is the summary with links:
  - [v2] revert "net: kcm: fix memory leak in kcm_sendmsg"
    https://git.kernel.org/netdev/net/c/a47c397bb29f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



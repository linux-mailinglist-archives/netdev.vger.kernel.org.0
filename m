Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390F2482B1D
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 13:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbiABMuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 07:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiABMuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 07:50:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3B5C061574;
        Sun,  2 Jan 2022 04:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6BDEB80CFC;
        Sun,  2 Jan 2022 12:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AEF4C36AEF;
        Sun,  2 Jan 2022 12:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641127810;
        bh=xUzxBWiGMJi1qlc+5i8OSVo6g8IZedQQEvBSf2GwBEs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gx6jFZmUNZnQl4zuLFNsYbnvhBrk2CYkCTRUFC0MhcGFfnJJM+d2nVadIeivyZjv7
         n5ZARgXcFdoUv0LwnyIQ0sdhGola+yxxJG7tjVxBxmk7hKYec+f70BHzxQ3SCBHpKb
         bZg2VbhhDtOAXRieRTKgLWaEvZFe/dcYMEHd7N35E1ueGllLrZw9VCLRDq4QEe8sOm
         SiZTest06QjJUAwlLJAVGC4O25aoG6KmXFhGyXWIfX3bR8pR1AlUy47jon1QjALPeD
         dj6tap5G6RakAil3audsTm7fJ+e67PTVg5IkiydX5UXC8UX9qiSxWtFu9FHrVcSQ2W
         9gE6rGeR8bH7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72A16C395E8;
        Sun,  2 Jan 2022 12:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: hold endpoint before calling cb in
 sctp_transport_lookup_process
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164112781046.2909.6621910023872288424.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 12:50:10 +0000
References: <937648ddf3d2bf49c8fb15e82b45b24d5a537cda.1640993857.git.lucien.xin@gmail.com>
In-Reply-To: <937648ddf3d2bf49c8fb15e82b45b24d5a537cda.1640993857.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com,
        lee.jones@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 31 Dec 2021 18:37:37 -0500 you wrote:
> The same fix in commit 5ec7d18d1813 ("sctp: use call_rcu to free endpoint")
> is also needed for dumping one asoc and sock after the lookup.
> 
> Fixes: 86fdb3448cc1 ("sctp: ensure ep is not destroyed before doing the dump")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/sctp/sctp.h |  3 +--
>  net/sctp/diag.c         | 46 +++++++++++++++++++----------------------
>  net/sctp/socket.c       | 22 +++++++++++++-------
>  3 files changed, 37 insertions(+), 34 deletions(-)

Here is the summary with links:
  - [net] sctp: hold endpoint before calling cb in sctp_transport_lookup_process
    https://git.kernel.org/netdev/net/c/f9d31c4cf4c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



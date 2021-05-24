Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0AC38F4EC
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbhEXVbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233850AbhEXVbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 17:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3B7156140F;
        Mon, 24 May 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621891810;
        bh=oD4MVe7khTGPFN86fkPnHSZaQ7GZI5DiZWY8xvo+h88=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C9HMmFixx51lCt8bDfOKBLij4NTKZqi40JXtrNT0J4Tr5C7BEldbMs84sQ8GEiZjo
         uYy1KA/qvC7MOYwGP7u8M9i1FyWPTucnmIw1GRVQPPsuGKGaSOiLP2/GhJJPWakd43
         E7U0oL3PR0GoPDEhoH1N4HJuCnDkHhidtWlmx3XqWcb9xhX5L3WOyA5Mb/N1ba6Rbu
         VaD7rXdm1GfqZjeE3wfOvbF4FUo/e2W8rFIyIKND3Tdbnx7SWDyYP3MW80A2xy6x5D
         UYcRKfZVimi+xTSKxEOIO+rcG3FsPjx/pBLcxB6GDXofNKhQ68szuNeVZoMFSOBw9c
         FAsSWhSBFaJSw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2BC5B60CD0;
        Mon, 24 May 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hsr: fix mac_len checks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162189181017.16512.13935059871261299091.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 21:30:10 +0000
References: <20210524185054.65642-1-george.mccollister@gmail.com>
In-Reply-To: <20210524185054.65642-1-george.mccollister@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        m-karicheri2@ti.com, ap420073@gmail.com, olteanv@gmail.com,
        kurt@linutronix.de, luc.vanoostenryck@gmail.com,
        wanghai38@huawei.com, phil@philpotter.co.uk,
        andreas.oetken@siemens.com, marco.wenzel@a-eberle.de,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 24 May 2021 13:50:54 -0500 you wrote:
> Commit 2e9f60932a2c ("net: hsr: check skb can contain struct hsr_ethhdr
> in fill_frame_info") added the following which resulted in -EINVAL
> always being returned:
> 	if (skb->mac_len < sizeof(struct hsr_ethhdr))
> 		return -EINVAL;
> 
> mac_len was not being set correctly so this check completely broke
> HSR/PRP since it was always 14, not 20.
> 
> [...]

Here is the summary with links:
  - [net] net: hsr: fix mac_len checks
    https://git.kernel.org/netdev/net/c/48b491a5cc74

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



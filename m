Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176C7472FF1
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239805AbhLMPAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239555AbhLMPAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1223C061574;
        Mon, 13 Dec 2021 07:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A52DB8113B;
        Mon, 13 Dec 2021 15:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3526C34611;
        Mon, 13 Dec 2021 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639407611;
        bh=WjcGELbu5JIKbGB4EMlOVci44ait6RcZ0lcliNjSfIA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=psYdtPJZOEQQuzAu/yovjNacJXoUwfT9h2sMTh8oPH0Jf45yQlcUfxbC+3uiYqdS8
         ePjf4HZhOZIBN4lIh4/i8m6yo9+ZcGptg15ajxDewsplStTINzNycAgDOhRlSpWXHM
         dBz9f3KjkZPs29f/WPyuate7otj9zYpTqXoV3lvwxcp0KSYr0bAUQuf8w748pFitbw
         HxIdShlgRuLvo52xBPL1BLObLnwk68393gpvcXPFqVyiNcQptIYdiBPlwaAMigJ3xt
         mAixPmPLMddJtMgSZmV5SDlcJp+cojEyvn17IDJ+1saDTnAAPbELCW1cdZGJvPTFLz
         SjZNMoTvw2Daw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D30D66098C;
        Mon, 13 Dec 2021 15:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] mt76: remove variable set but not used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940761085.26947.2175837807635652318.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 15:00:10 +0000
References: <20211213095413.99456-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20211213095413.99456-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, abaci@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Dec 2021 17:54:13 +0800 you wrote:
> The code that uses variable queued has been removed,
> and "mt76_is_usb(dev) ? q->ndesc - q->queued : q->queued"
> didn't do anything, so all they should be removed as well.
> 
> Eliminate the following clang warnings:
> drivers/net/wireless/mediatek/mt76/debugfs.c:77:9: warning: variable
> ‘queued’ set but not used.
> 
> [...]

Here is the summary with links:
  - [-next] mt76: remove variable set but not used
    https://git.kernel.org/netdev/net-next/c/93d576f54e0f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



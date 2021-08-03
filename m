Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F69E3DEB40
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhHCKum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235480AbhHCKuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 06:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 422B861078;
        Tue,  3 Aug 2021 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627987807;
        bh=xjnIer3HOwFFwykuXRHF6mzwiBZUmbMtQWHTC2TM2YI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WANbqhargjwjCkLDgd3qHQDDnTRO8B1f/GTYT8Jkhfiq1NRR6MLRtLnDyrG4WKWf3
         dXKgFD4z6DaQd7+jXkqTQrHZHj4Q49BZUmPb/Jp7mu/hkSCV985aYkcW6F145JNpx1
         EhClSnWuvQht9JWTl/P7VUYSJVTeDM60Znn1eChXNtU3Q9wzGGvaWGJ1opseR+FKjW
         g91wDFc+MxQcGFbZXCiBnzEhyhhKk6W9C2KBoXaoA1mz0ch4kJCthKzDpYWPToUpsx
         dD675maD5WTr9x00hHabqAK9KyRhClC+CpbMXXk3iNj/Ge/RqQqYo3KqHKbhxi5W5J
         grd4Z/FEegTsA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 39A7560A6A;
        Tue,  3 Aug 2021 10:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: Remove redundant prints from the iWARP SYN handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162798780723.3453.10822967846479015713.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 10:50:07 +0000
References: <20210801102840.21822-1-smalin@marvell.com>
In-Reply-To: <20210801102840.21822-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        aelior@marvell.com, malin1024@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 1 Aug 2021 13:28:40 +0300 you wrote:
> Remove redundant prints from the iWARP SYN handling.
> 
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - qed: Remove redundant prints from the iWARP SYN handling
    https://git.kernel.org/netdev/net-next/c/9c638eaf42ec

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



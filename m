Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1401845065A
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbhKOONY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:13:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232072AbhKOONG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:13:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0ADBB6322D;
        Mon, 15 Nov 2021 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636985409;
        bh=SIs+iwklv8KfbyfcsPobIZu2x2aKdT3tn5NnV3mSFn4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QSuzW6b5ffmWFK6oCQMl0O0SLjurwpJFG8GxvAO2g9Sk2Rv0TQioBmBD4sRv/AJj5
         b7D/RfbIrxEFoyJ4AzQpizyhRhcqF3pPlu66g4S1WM7CfOk1Rx6G3ID6YcEu6KlDa2
         AKLbAn/ECR677rrfE50nCkryxroRvS3GuSbWGAD7w1Z/frl+CSK/aH3645kkkXfgYn
         4Uk0kNAGciQOT1oT0IEyqXZoSpsnNEHBiV+7ehahmPMgC7AHq4+IlkUU7nH7+n6CwI
         aRotyVbz0jH9xXuebLTnPYcsj5xucJ9QfUe8Ta3LV/wsRwqAd68yr7XkMcyrUjXVBv
         caQBg3M38LjFQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 011986095A;
        Mon, 15 Nov 2021 14:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bridge: Slightly optimize 'find_portno()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698540899.13805.10527037556945584609.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:10:08 +0000
References: <00c39d09c8df7ad0673bf2043f6566d6ef08b789.1636916479.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <00c39d09c8df7ad0673bf2043f6566d6ef08b789.1636916479.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 14 Nov 2021 20:02:35 +0100 you wrote:
> The 'inuse' bitmap is local to this function. So we can use the
> non-atomic '__set_bit()' to save a few cycles.
> 
> While at it, also remove some useless {}.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: bridge: Slightly optimize 'find_portno()'
    https://git.kernel.org/netdev/net-next/c/cc0be1ad686f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DE9488106
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 04:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbiAHDKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 22:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiAHDKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 22:10:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944EFC061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 19:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FC2E6204B
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 03:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 935E8C36AED;
        Sat,  8 Jan 2022 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641611409;
        bh=QYC6fliFeRjbpnr7X6pavm1xjOZlNRp+2EgPJa9L2rU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cazmv40kzdeW/nfWN5fUA6zzDYHetqBHkJmJDODEtmgc8QdLHJBTOBOVCYQzayxil
         I+OOmY+mMN/UcfiJizXWuxa036NL4QXTal7wt0R5s3I3CI6vDX08jgjVOWVx9TYo/9
         NZ7fYJP+qo1HgnXs474izkmn76B8JB35CrWJuuccY190sEEAAu5iwPHVvJW3HnF1nr
         G8CNnAwh4T1XHBH3H+At/753CiRVgz7sUv6hZwPJaK+pGhmR3+ojO3XhYykH4hXJ83
         QhPRfNVarbO4CZdZnR03EY+ViWXtB//nui5IwE+y8l+aCqxdX8GGvji6MLF+mdZfOR
         E9aDgBkzOuhuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 742B2F79404;
        Sat,  8 Jan 2022 03:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] octeontx2-af: Fix interrupt name strings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164161140947.29029.13133955604062873155.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Jan 2022 03:10:09 +0000
References: <1641538505-28367-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1641538505-28367-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        hkelam@marvell.com, gakula@marvell.com, sgoutham@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 7 Jan 2022 12:25:05 +0530 you wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> Fixed interrupt name string logic which currently results
> in wrong memory location being accessed while dumping
> /proc/interrupts.
> 
> Fixes: 4826090719d4 ("octeontx2-af: Enable CPT HW interrupts")
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-af: Fix interrupt name strings
    https://git.kernel.org/netdev/net/c/6dc9a23e2906

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



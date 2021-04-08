Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2CD358F2B
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbhDHVa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232628AbhDHVaZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 17:30:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 46C0561055;
        Thu,  8 Apr 2021 21:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617917414;
        bh=wFHkypvvUGXI+5ZmEk9IO7qK7xbLhHXoFcmwZqW/4pM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ltfYka7ylaNuckpkxitj5eRK+Hd5iPJE6TNozH1Oikud2SKoGk7jy9yFDFjavYdCC
         22fa28mahXI36lS03ZdVZzzArU+vCcUbSadq3fxz9BXerfQKmZ6GfiCLOlPpahgE3R
         7KAzleTWpNbbed51nim0xvFOlWqKrTk/OLOjMApYth2gc+1Lv81XaTcqJHU2g6MJ97
         jEXgo9j/L9mso+FarwBxsHEvi8KYcmLcqFJ5O7TuDQV6eoSdC+oh0O516Tj90bHf6M
         jyTXlgPaBu3aorO6tZpJryHT4AT34OICPaqFXHcpu6FWbnA/sBjwIC0BjebJb5Wxru
         duqrFwINeYNkQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3892B60BE6;
        Thu,  8 Apr 2021 21:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] batman-adv: Fix order of kernel doc in batadv_priv
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161791741422.16984.11272846748570435794.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Apr 2021 21:30:14 +0000
References: <20210408115401.16988-2-sw@simonwunderlich.de>
In-Reply-To: <20210408115401.16988-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, linus.luessing@c0d3.blue,
        sven@narfation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  8 Apr 2021 13:53:59 +0200 you wrote:
> From: Linus Lüssing <linus.luessing@c0d3.blue>
> 
> During the inlining process of kerneldoc in commit 8b84cc4fb556
> ("batman-adv: Use inline kernel-doc for enum/struct"), some comments were
> placed at the wrong struct members. Fixing this by reordering the comments.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> 
> [...]

Here is the summary with links:
  - [1/3] batman-adv: Fix order of kernel doc in batadv_priv
    https://git.kernel.org/netdev/net-next/c/549750babea1
  - [2/3] batman-adv: Drop unused header preempt.h
    https://git.kernel.org/netdev/net-next/c/5fc087ff96fd
  - [3/3] batman-adv: Fix misspelled "wont"
    https://git.kernel.org/netdev/net-next/c/35796c1d3438

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



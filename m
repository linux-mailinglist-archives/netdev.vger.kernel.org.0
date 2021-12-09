Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B84E46ECCF
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236840AbhLIQNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235508AbhLIQNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:13:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4BDC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 08:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E570B8254A
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 16:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2C68C341C3;
        Thu,  9 Dec 2021 16:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639066209;
        bh=yYR01Dzwy+wYFJD3ccjvLFi4o5/SPTETdVfYd/DouaM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hfI56gjjKImndf6iHpJz0uWcVaOm/ipeqr+rVyTuVmAUDwg3M5nRWLr5IH42TGzhV
         vySzuAbcpEZd60LZzqZNWyx2MkYaIrbjFD8vzG14zVT2D2qRvKSl1iQdBz7TRdAyG4
         fYl26zBUyXyk3G5JakF2Tr+dG67QCUVZUo3UEGEBSg/ufZkXSfmhFjN7axTVi5S1fr
         mDFRokHkdWhLHBs98wt0zlu8a+vJfGyi+u/hz5CMEKlGPq09/nCTuqzRIBXyB2aDkH
         r6C7YznxGp31paPtWLZM7jK27saNTW/FS4whmggNXZmvexQhffFOU5OvaEDESkb7uU
         txcrEBmkB0VgQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C94C860A3C;
        Thu,  9 Dec 2021 16:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: fq_pie: prevent dismantle issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163906620982.18129.4750753893395522768.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 16:10:09 +0000
References: <20211209084937.3500020-1-eric.dumazet@gmail.com>
In-Reply-To: <20211209084937.3500020-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com,
        tahiliani@nitk.edu.in, sdp.sachin@gmail.com,
        vsaicharan1998@gmail.com, mohitbhasi1998@gmail.com,
        lesliemonis@gmail.com, gautamramk@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 00:49:37 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> For some reason, fq_pie_destroy() did not copy
> working code from pie_destroy() and other qdiscs,
> thus causing elusive bug.
> 
> Before calling del_timer_sync(&q->adapt_timer),
> we need to ensure timer will not rearm itself.
> 
> [...]

Here is the summary with links:
  - [net] net/sched: fq_pie: prevent dismantle issue
    https://git.kernel.org/netdev/net/c/61c2402665f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



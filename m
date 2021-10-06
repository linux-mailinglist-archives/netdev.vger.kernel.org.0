Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85313423FF0
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238869AbhJFOWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238779AbhJFOV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 10:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8E852611C0;
        Wed,  6 Oct 2021 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633530007;
        bh=4K0pV/uI1w+zwhhX5zdAt8ZSo/GebZfdyNP+scOfbDs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WFkEr9eMGtEOhJmVoHi4oLa9qEDbGCcJRNKUWUD6w5LHyn9FFWolrWGAs7OpiwYWD
         Ozc/zHRcU4apS30UEShoFJl82WpcdGw7dG2WuswRk1cuaIYjRI9WTtbGSXX0t8MrWC
         Hvg8u6pD/Um1MghnQNGt3vP9OrfreWpPeHNH7BdaLimlS5bb/LDn8EXoaGvUzFa9kC
         NcOu09xYHuPMsKBLTScQlzYdGSFd5s2KkuJjX9UimLovpspyldwJ0pMxis3NAil3Lo
         A2+xLF/t+X9oysnvisj1tZo7RGSxWomo9S0grca4yFpRTamqpS8Y7KmJSYQEPSghCc
         D3fQGAbsbX8iQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8623E609F4;
        Wed,  6 Oct 2021 14:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ionic: move filter sync_needed bit set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163353000754.15249.4736328916639001642.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 14:20:07 +0000
References: <20211005231105.29660-1-snelson@pensando.io>
In-Reply-To: <20211005231105.29660-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, jtoppins@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  5 Oct 2021 16:11:05 -0700 you wrote:
> Move the setting of the filter-sync-needed bit to the error
> case in the filter add routine to be sure we're checking the
> live filter status rather than a copy of the pre-sync status.
> 
> Fixes: 969f84394604 ("ionic: sync the filters in the work task")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> 
> [...]

Here is the summary with links:
  - [net] ionic: move filter sync_needed bit set
    https://git.kernel.org/netdev/net/c/3707428ddaba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



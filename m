Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57EF3068D4
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhA1AvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:51:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231151AbhA1Aux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 19:50:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E5BE464DDA;
        Thu, 28 Jan 2021 00:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611795010;
        bh=m75KJQo6KsXCj6aMdKZXTlAIwpwOmosIgsd0Ih5llSI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W1anRBX8aKRM3qnbz/pSFeyK02h/SYdD06NwUa1S9GGh/UPz7NAGO79giqr/XXvpJ
         wRK/tgfJgyt2lH3Ka2mBNP6Q33HDhC/CkTdw+7ruXw6oIDQWbXuGO6FK7dFFIcTUa0
         vKgukTX/3nAqlBJD+W0xsZfaYy+2z7HAv0tWEax0Z0C5HjclHoCU2WGJipiqAM7ixv
         lvN8w8ufrR/WhWrSC4if21vGGs5aWKrGStujcXWHLv7AS2u6QNfQbp5gWuRilR/VCr
         3O4Z8Zuq4kcgm56NC0voavOYNqIh9yVSXh08wCy6Qqm000NWHZKzdCrvfc8/lE9ir3
         nIkR+m3GT0Y2g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E132761E3D;
        Thu, 28 Jan 2021 00:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] pktgen: fix misuse of BUG_ON() in pktgen_thread_worker()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179501091.14572.11655971573513336606.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 00:50:10 +0000
References: <20210125124229.19334-1-zhudi21@huawei.com>
In-Reply-To: <20210125124229.19334-1-zhudi21@huawei.com>
To:     zhudi <zhudi21@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        rose.chen@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 25 Jan 2021 20:42:29 +0800 you wrote:
> From: Di Zhu <zhudi21@huawei.com>
> 
> pktgen create threads for all online cpus and bond these threads to
> relevant cpu repecivtily. when this thread firstly be woken up, it
> will compare cpu currently running with the cpu specified at the time
> of creation and if the two cpus are not equal, BUG_ON() will take effect
> causing panic on the system.
> Notice that these threads could be migrated to other cpus before start
> running because of the cpu hotplug after these threads have created. so the
> BUG_ON() used here seems unreasonable and we can replace it with WARN_ON()
> to just printf a warning other than panic the system.
> 
> [...]

Here is the summary with links:
  - pktgen: fix misuse of BUG_ON() in pktgen_thread_worker()
    https://git.kernel.org/netdev/net-next/c/275b1e88cabb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD9E439DB7
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhJYRma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230505AbhJYRma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:42:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E4A0160F9D;
        Mon, 25 Oct 2021 17:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635183607;
        bh=yW3lUePvKstBIOR1swEYN9bl86+OVV2pt1fDGkAz3Ks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l+t4NmKUjjOz3xix5aAFc1GKmdyWNazIOPrVRG9dOTnhyaEk5dP9lR91bW515eya0
         ICDn2YT1QgdsnB8xJ5RKLp0Nnm0zTgruefon9kBAibNzqNlIg0zuzS3zN5dCYmIK8d
         yg97Ag65uFimLe0PbDJzyzH5rySyneCU9odV8mulvsxoaf6M+Aos36JfTBRHNZTs3l
         QxA6VsOlUN6I0sQ+HzOnRpZnYBNhcF3DoKnweEsIRamMTpD2QIntII9BfnE4T+9THJ
         ie5xxYgJRiSFN0V7VWyTbd39BP3YFtNS6nMUbjY5wZ8CdDqgZl14Jsb/EiwJ2wz4uR
         9tdDya8toKq1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D9BAE60A47;
        Mon, 25 Oct 2021 17:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] fddi: defza: add missing pointer type cast
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163518360788.30294.1257539339445417106.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 17:40:07 +0000
References: <20211025160000.2803818-1-kuba@kernel.org>
In-Reply-To: <20211025160000.2803818-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, macro@orcam.me.uk,
        lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 25 Oct 2021 09:00:00 -0700 you wrote:
> hw_addr is a uint AKA unsigned int. dev_addr_set() takes
> a u8 *.
> 
>   drivers/net/fddi/defza.c:1383:27: error: passing argument 2 of 'dev_addr_set' from incompatible pointer type [-Werror=incompatible-pointer-types]
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 1e9258c389ee ("fddi: defxx,defza: use dev_addr_set()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] fddi: defza: add missing pointer type cast
    https://git.kernel.org/netdev/net-next/c/a0c8c3372b41

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2E1480E2C
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 01:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbhL2AUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 19:20:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46252 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhL2AUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 19:20:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07BE861370;
        Wed, 29 Dec 2021 00:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FEE2C36AED;
        Wed, 29 Dec 2021 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640737209;
        bh=8vWVsDn0KFyPwhRmyaqZKrj1RcwWs7YSNpi5QgEC6wc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ol2e58+CXgHdjGoKBTQTHzn6Bd+HJvyIcQt8+Fmi7DTk0Q3LDGGyaxEWxAfQgTioG
         cDCre2+g2Wljfdif1YtTI13c9BE+NuwBG7eo+rIkg3XDAUKgJXXxTH+eulJx6dDAEp
         3vSN1hG2hpx6kKUwjONkSKKyGE5h5QESrx186u1VsI/Q+BktERdmeG2ZZ0JiwGi7yh
         O0PBFjwy8UDnniSttdfNDWK7hxBhXb1fwWZQSkN9gmfeHddZR9cVVcUoHWX/g3awA+
         7Z8UPPhlcNgr9LpfAULeoO4LtOg0dAWFqkNZiqc3RVKce41Xe1eHkjtbPAVqDNZmnk
         N+ppqkQRR4ASg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49744C395E8;
        Wed, 29 Dec 2021 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ionic: Initialize the 'lif->dbid_inuse' bitmap
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164073720929.15020.13473393631637951212.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Dec 2021 00:20:09 +0000
References: <6a478eae0b5e6c63774e1f0ddb1a3f8c38fa8ade.1640527506.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <6a478eae0b5e6c63774e1f0ddb1a3f8c38fa8ade.1640527506.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     snelson@pensando.io, drivers@pensando.io, davem@davemloft.net,
        kuba@kernel.org, allenbh@pensando.io, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 26 Dec 2021 15:06:17 +0100 you wrote:
> When allocated, this bitmap is not initialized. Only the first bit is set a
> few lines below.
> 
> Use bitmap_zalloc() to make sure that it is cleared before being used.
> 
> Fixes: 6461b446f2a0 ("ionic: Add interrupts and doorbells")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - ionic: Initialize the 'lif->dbid_inuse' bitmap
    https://git.kernel.org/netdev/net/c/140c7bc7d119

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E2F3F0204
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbhHRKur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234489AbhHRKuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 06:50:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1127B610A3;
        Wed, 18 Aug 2021 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629283806;
        bh=ZI9ycpQ7SIGi1GFBcxnMKOwgmJtfn5EVsDAXoZbMxHQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I9bRfdPK8xRDZ+gjhZbFk5SNWaujzSkfU8TLurLiA7oYx5bwrTFMEbzbmhpJ+Eaeo
         h5xn915kjxgaruAaXKZFpYbF1MNzowMdxIjhXUUx6KmMsQHu2j257UmY6mUIetCxg5
         vG/4lSbs2g+EBNbgwu0ME3OHnm5n0DTpxAXLcVKBp/e7VFH6sdysPggg2hVp1K7GSG
         vMV1jDU1rDUtRR3gpRNftro0jDJ5X2wQ8yZ4LGp0NwFE42umGrjnyvEErv5BuZsDtM
         znFzea6yRZWpOK/kSOx8362jprGpYnt9E1m4CJVI91C53t7n6fSo9f8frPxWJSF92G
         YADQt2x9Br75A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 06DAD60A48;
        Wed, 18 Aug 2021 10:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] pktgen: Remove fill_imix_distribution() CONFIG_XFRM
 dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162928380602.20153.15506792809667091863.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 10:50:06 +0000
References: <20210818013129.1147350-1-richardsonnick@google.com>
In-Reply-To: <20210818013129.1147350-1-richardsonnick@google.com>
To:     Nicholas Richardson <richardsonnick@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        nrrichar@ncsu.edu, promanov@google.com, arunkaly@google.com,
        gustavoars@kernel.org, yejune.deng@gmail.com, dev@ooseel.net,
        yebin10@huawei.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Aug 2021 01:31:26 +0000 you wrote:
> From: Nick Richardson <richardsonnick@google.com>
> 
> Currently, the declaration of fill_imix_distribution() is dependent
> on CONFIG_XFRM. This is incorrect.
> 
> Move fill_imix_distribution() declaration out of #ifndef CONFIG_XFRM
> block.
> 
> [...]

Here is the summary with links:
  - pktgen: Remove fill_imix_distribution() CONFIG_XFRM dependency
    https://git.kernel.org/netdev/net-next/c/7e5a3ef6b4e6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



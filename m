Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DD2319606
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhBKWuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:50:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhBKWus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D45B464E42;
        Thu, 11 Feb 2021 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613083807;
        bh=u4nBckBVLPJhiSWGak2IpaTs0JjrtKMkpS2OMjMZKXY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BA/X8KQlel3crWRdhLA4H9S/qTNOw5ak4a1ccq6HiF0JmFMH1K5q5YIn+ypABSbxz
         /D8IKHTpcCuDT9kYJBHxiTf0pJDjLDiJiWTmWvJF8gXRv7nttznl5xg7A8qsUWhthz
         MZePtI7n5rfOTQ55PVS40OJmRiDa+ulU8IEIm1pfUsRYfHYH5D3OigjYsasFciwm0h
         W+XJlCBbVoyJ8Pn1T517PL1mVTV9rPWZHiAgB/KhxjjOowciRFAcoCwfr8KdoAY0cn
         Qgsb9nu04yK0fmI1M6innjlut5PlEdsuAeMPmNZhBvZdeltZYP+n9DAkUNyggQfFHy
         7uXK3prZOMEsA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C9A9760A2A;
        Thu, 11 Feb 2021 22:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: aquantia: Handle error cleanup of start on
 open
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308380782.17877.1533543226259450837.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:50:07 +0000
References: <20210211051757.1051950-1-nathan@nathanrossi.com>
In-Reply-To: <20210211051757.1051950-1-nathan@nathanrossi.com>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, nathan.rossi@digi.com,
        irusskikh@marvell.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 11 Feb 2021 05:17:57 +0000 you wrote:
> From: Nathan Rossi <nathan.rossi@digi.com>
> 
> The aq_nic_start function can fail in a variety of cases which leaves
> the device in broken state.
> 
> An example case where the start function fails is the
> request_threaded_irq which can be interrupted, resulting in a EINTR
> result. This can be manually triggered by bringing the link up (e.g. ip
> link set up) and triggering a SIGINT on the initiating process (e.g.
> Ctrl+C). This would put the device into a half configured state.
> Subsequently bringing the link up again would cause the napi_enable to
> BUG.
> 
> [...]

Here is the summary with links:
  - net: ethernet: aquantia: Handle error cleanup of start on open
    https://git.kernel.org/netdev/net/c/8a28af7a3e85

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



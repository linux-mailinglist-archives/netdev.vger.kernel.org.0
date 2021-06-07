Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467F139E90A
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhFGVV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhFGVV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:21:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 537716109F;
        Mon,  7 Jun 2021 21:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100804;
        bh=WFvP+uhtcu01tluIL373SHUAK6jFJ+PXY7AC2pQrbSw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HfQYG3s1Fid1rUFnsa4YiMqZ6jeFeB4/oYseLxd+q7ncQBO2LqpZTGt3spY7JAM+b
         Z7T0sFv0SXHXTm69CmzgUfnsRlEldt2ZZw6bILPmIq2c4yvdprwsqsAjveV5Gj9KCs
         CA1HNSvkh3Us1cXLShO+b72Fqc8J4T3aUxHZsbVuSRWLOkonHylE20zpqf1s94mWSR
         7jAGS0WzhJXyhy/dOdBJEROFX/y4Hm0AzJCk/jzrpo+S393/g1ZzfbVTr5MoYooByx
         7z7IMNgjgE4j+Ifpj3GRJPDitWvR9p3UJ0qkARubTPmGRGJo9gbY2evPFj6SRHamM9
         f3AuijEM5js/g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 49212609B6;
        Mon,  7 Jun 2021 21:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/ncsi: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310080429.4243.4333641934527361894.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:20:04 +0000
References: <20210607150118.2856390-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210607150118.2856390-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     sam@mendozajonas.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 23:01:18 +0800 you wrote:
> Fix some spelling mistakes in comments:
> constuct  ==> construct
> chanels  ==> channels
> Detination  ==> Destination
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/ncsi: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/4fb3ebbf7e08

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



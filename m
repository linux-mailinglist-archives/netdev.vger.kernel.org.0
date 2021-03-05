Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DAC32F520
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 22:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhCEVKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 16:10:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhCEVKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 16:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 42D3F650A6;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614978609;
        bh=84JF+vVfdvF1N8LWacyv0vyL+mYsB4E2DY1afPPhINs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a+Mq/BCsHyC7visKMuwf6taQXKhpfKnHe9y4wSUPW68BqtrBmz6MOqn9SQCJfSPgc
         GZ7haXGtWWGEbfInB1FpVWWw4nBqsGB1unnYNDCknNg/ASBI1Sw+FrDObw3KpRlU+8
         EDh4yoYJ8PTe7oJnkhcsFoVJR91dozsIJv7FICQieqZy263T9ts4W1kZ/Jo8k0qJ5c
         FoZLm6aVWgvtPT1WgpuZKp8ZcjS3XTCekfbKpykwrY3PwHSXPg/gwlrN7AFxPYqmD4
         61vYVhlx4W4FTAK0Z67BmOjQkbCNNz8+Qv6FBFUyU20mqyw1vT9XHd/TtAdzKcxWDX
         ZFTuL5INTWMMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 38FB060A13;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: tehuti: fix error return code in bdx_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161497860922.24588.8387534315192369257.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 21:10:09 +0000
References: <20210305020648.3202-1-baijiaju1990@gmail.com>
In-Reply-To: <20210305020648.3202-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Mar 2021 18:06:48 -0800 you wrote:
> When bdx_read_mac() fails, no error return code of bdx_probe()
> is assigned.
> To fix this bug, err is assigned with -EFAULT as error return code.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: tehuti: fix error return code in bdx_probe()
    https://git.kernel.org/netdev/net/c/38c26ff3048a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



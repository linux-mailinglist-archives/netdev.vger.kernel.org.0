Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D423B3799F5
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 00:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhEJWVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 18:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231150AbhEJWVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 18:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A0806161E;
        Mon, 10 May 2021 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620685212;
        bh=hxjZ9Sk1w+UYvHvZXxTQm/bkUKV2ua8aXwY2KQKzTv4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j7K/5E+2nQrNR51LNKQk6M4DYl6tWdWU5Z6DvFj4cqjqbsoYQsxzHpNR4tNueYWQx
         ec+F7NMgUsZsR2jzTPwv123/yIN8JPQpSLa5TBZsZK2R1t9HZa9K2vJaZ/+VVYxBb5
         H6HjT/qwH5sfJ1JSoExra9NheWIvzrp8WDKXwCzb9tn2kOsN6rQJjrUedbR56wr1qB
         SOcHfYe5Qmz8nVgdQL64NUAbvfbP8ZGT3GRe1As05bSXJCMwG4B9FR2mIhSxSOjY11
         q1nyhNu2iw2JvYzoO1ooRVSkK5yM1VOYLWkb85Rq7hH9t7oFnzcovsHLEFgJD5UjOl
         oGf8rblRzHRpQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 30D4160A0E;
        Mon, 10 May 2021 22:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: stmmac: platform: Delete a redundant condition
 branch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068521219.17141.10735663458714364666.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 22:20:12 +0000
References: <20210510141002.4013-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210510141002.4013-1-thunder.leizhen@huawei.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 10 May 2021 22:10:02 +0800 you wrote:
> The statement of the last "if (xxx)" branch is the same as the "else"
> branch. Delete it to simplify code.
> 
> No functional change.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> 
> [...]

Here is the summary with links:
  - [1/1] net: stmmac: platform: Delete a redundant condition branch
    https://git.kernel.org/netdev/net-next/c/aed6864035b1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



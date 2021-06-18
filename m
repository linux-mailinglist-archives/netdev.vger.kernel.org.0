Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BB43AD2BC
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbhFRTWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235402AbhFRTWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9DD3C613F8;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044006;
        bh=WXXhO9FuY5yV2NncArmi17NLQRykIEQqMoaheEffRYQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aS5EiNaDkR6kbhWXe1aWe73dkfNJ8GJ9XpM5NtsWY3Pq4zMlOW4mR7XBn0M//UngI
         yqm2+/SJ7D1v3Wnm36ocfY4Bo5OngxPmi7QF/c2D7FpGzr93cEdJgpWimKFtyqW4gP
         D6760LKd3epugHLX/dXrxzn9FBgTd/iVfQqYVDSsrRQDCDRWQdKIv1Hfae3Op7Hoyu
         ScknmTfAzAg2NXqgFTXiXssgGzBD1TPwIy2N/54pTMi8G6CiXLoK/DJH3SaqpydEmb
         +ak8R8vO2msUak3cGhagZBQ93jOETrmKQmY1m1tRjxEKLm50MIan66a50l8W86rxIn
         0Kmeq1RsSwsJg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 92CC560C29;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: caif: modify the label out_err to out
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404400659.12339.13389955025693488534.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:20:06 +0000
References: <20210618073205.3318788-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210618073205.3318788-1-mudongliangabcd@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 15:32:04 +0800 you wrote:
> Modify the label out_err to out to avoid the meanless kfree.
> 
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  net/caif/cfcnfg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: caif: modify the label out_err to out
    https://git.kernel.org/netdev/net-next/c/9fd2bc3206b3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



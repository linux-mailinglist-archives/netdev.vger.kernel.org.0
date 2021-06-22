Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8673B0B97
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhFVRmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232225AbhFVRmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ECDCE61374;
        Tue, 22 Jun 2021 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624383605;
        bh=plwqpg/QXXdSPFcC+0CbYi+uneL0RPA6nAf8cfRh1Mo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D5+cmP2Kj2h3TUJYkXzi26lJ90aXdyOTrUV13kI+Z9bFuDmwZOxaxuXTo/EUEJbhn
         rDP5HOWWQehr26p6eBwbgxNdJa8O7TjPjCJzfmPZi1wyCXbaFHSF1WOlrI8lfG3iG1
         DIjP1dln385Le5S2Bp6v5RwFcWWol+AVwoiD+Q4/4EIlUTsnO8rfyb8/Du9Twg8iti
         SwhFTnwNUTmoCNfJmwD4W5xeFjCZJorj1+QtQ+nAsh3uY9QCP9dlbqRdrm0msUeFJW
         dRhRvqzFc4E4Hx4cxDcy7WtHa3xNDGNt5N26AePFQUX1vty389oP8kEjnvsr4eINBx
         qrOcj7b5+ILlA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DD033609FF;
        Tue, 22 Jun 2021 17:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/ipv4: swap flow ports when validating source
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438360490.26881.1083767963740683028.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:40:04 +0000
References: <04B365C6-F4FD-49AB-9C9E-35401BA309A9@gmail.com>
In-Reply-To: <04B365C6-F4FD-49AB-9C9E-35401BA309A9@gmail.com>
To:     Miao Wang <shankerwangmiao@gmail.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 22 Jun 2021 12:24:50 +0800 you wrote:
> When doing source address validation, the flowi4 struct used for
> fib_lookup should be in the reverse direction to the given skb.
> fl4_dport and fl4_sport returned by fib4_rules_early_flow_dissect
> should thus be swapped.
> 
> Fixes: 5a847a6e1477 ("net/ipv4: Initialize proto and ports in flow struct")
> Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> 
> [...]

Here is the summary with links:
  - [v2] net/ipv4: swap flow ports when validating source
    https://git.kernel.org/netdev/net/c/c69f114d0989

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



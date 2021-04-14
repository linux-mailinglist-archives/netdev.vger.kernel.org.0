Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22F935FC79
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349055AbhDNUUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347817AbhDNUUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 16:20:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EAED761164;
        Wed, 14 Apr 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618431610;
        bh=TB5WvuJaooJm03M/kUeWDFE8yKSLetNyNki5qbhMEXM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KvsrLf/VWmokR0NOv4GlI+nG95f0zloAAz03u5yxa2Z8s9hl4MteWjKMk5ZtdCVqM
         8JfeoyWyn+4O1nKb3CDZ5FHP7ymTkQsgYxmA9nRRNOVitp2H+xRtyTnPm+MUb1/C8f
         9ICLf56aP5y8iSSlTQEYPiiIrEyoUFFg10bVfVxhDg6sg6mh54ChMz8MDfeAlZUjs+
         FGAeMl/VtIYfn0HKuxXpwo2wh3rCr3+Wlw5dkHlWAojF6HCp3YgVICSGGcQ+pgXGT7
         vDcXlsoIiuUIYDzp47vjCFqzG0qa6SW20qc2TktrkRwu9GWGHLeSk/p+o0u9+B5T0o
         a/OwApr1qYHZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC35460CD2;
        Wed, 14 Apr 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vrf: fix a comment about loopback device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843160989.15230.12742233625105598320.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 20:20:09 +0000
References: <20210414100325.14705-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20210414100325.14705-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Apr 2021 12:03:25 +0200 you wrote:
> This is a leftover of the below commit.
> 
> Fixes: 4f04256c983a ("net: vrf: Drop local rtable and rt6_info")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  drivers/net/vrf.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net] vrf: fix a comment about loopback device
    https://git.kernel.org/netdev/net/c/2e1534f395e7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



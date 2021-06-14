Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8933A6EC9
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbhFNTWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234221AbhFNTWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:22:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 61FEC61378;
        Mon, 14 Jun 2021 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623698404;
        bh=M0cmmx1buBK/HxuXNOtLk+n171lvw8dYJVF48ztDnKM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WO+gbJkdiPGM3yMqp1+st7RVoU5LqRMYVYGaFZW3y4Agefq3utrHZ1j9QomNrIidt
         WuxnSzCbx+4vNTth8yUXvPI7RuBkADzRnI9VTaSElL0vfU6d72LEjWhZR2UTDjCKC5
         j3yf+UBe/+4kaXDXp3BHyzZKNvXXaQsQFH9tHDu60GZ1FSLCz7DrlAewp6JnHebwjb
         wrL26bpEVkwi2v8kGRPPP/bhQh9eKv4lvbk+gh3nA2yuGNEGtahGWuiVNgjqPBJ8Di
         F4IcTiU7CZuoO6GWsYAE8lESdphHou2G/QEtORGYZwQdE8zPCZ9BtIuzy4SDZ9R/f1
         OdsLRo4Yn8vOQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5916560A71;
        Mon, 14 Jun 2021 19:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sch_cake: revise docs for RFC 8622 LE PHB support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162369840436.27454.2039291841691808516.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 19:20:04 +0000
References: <20210612065411.15675-1-tyson@tyson.me>
In-Reply-To: <20210612065411.15675-1-tyson@tyson.me>
To:     Tyson Moore <tyson@tyson.me>
Cc:     toke@toke.dk, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 12 Jun 2021 02:54:11 -0400 you wrote:
> Commit b8392808eb3fc28e ("sch_cake: add RFC 8622 LE PHB support to CAKE
> diffserv handling") added the LE mark to the Bulk tin. Update the
> comments to reflect the change.
> 
> Signed-off-by: Tyson Moore <tyson@tyson.me>
> ---
>  net/sched/sch_cake.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Here is the summary with links:
  - sch_cake: revise docs for RFC 8622 LE PHB support
    https://git.kernel.org/netdev/net/c/4f667b8e049e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



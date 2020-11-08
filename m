Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572CE2AA879
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 01:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgKHAAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 19:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgKHAAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 19:00:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604793605;
        bh=OV+ruHzvHETJVvE82HvCTBlsHJJG2mWHorPQOawKTZQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SLCBA4KOgHlL0RTF1UKtbfQXOt16E1hIL0s4CGJKDrqOLRf2g4qreQBTlJMZWdw55
         msK/MBkpGu0gEfSDHF8OziIEEhShFHIPrNjVcJAPxCPsx36YT/xhubHo9NiaZTJpgH
         dcvbjAL4jylSkPrb52U3tCJMBfRMTmbrRmreMDZ8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: core: fix spelling typo in flow_dissector.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160479360515.2526.3505943404524635129.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Nov 2020 00:00:05 +0000
References: <1604650310-30432-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1604650310-30432-1-git-send-email-wangqing@vivo.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        jakub@cloudflare.com, sdf@google.com, andriin@fb.com,
        komachi.yoshiki@gmail.com, vladimir.oltean@nxp.com,
        lirongqing@baidu.com, gnault@redhat.com, lariel@mellanox.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  6 Nov 2020 16:11:49 +0800 you wrote:
> withing should be within.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  net/core/flow_dissector.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: core: fix spelling typo in flow_dissector.c
    https://git.kernel.org/netdev/net-next/c/75a5fb0cdbb7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7433AD2BA
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbhFRTWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235295AbhFRTWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6FA45613E9;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044006;
        bh=/pBZ9EauRuti1DUW1l1lAUKY3ZUWHV9xNhUn00Dpneo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TKOwRCooxvBuLIu0RYqV24abDJZB2Yk0ejZWSvQJg9KJrMnctCX4D0uXRzjT0GIp3
         C4dIRFCApzjDLCCgnVOIuPbWPdp74NpVQ2T4IkTULDCxZIEeXHQPHFZ75NrmgdEi9X
         SZVusJJJFleMQkm80NHJk2uC5nbpKevJC6v77GpV/UsRCxarW3YFZSXbl2Ahv3wFPu
         RUp+HY+M/XxZP/3FDz+XpX6zSBB/bLcBp/yl83BUodAUiTQgw7Atyz/rHxwaR/qLuj
         L3QXb/7UYMUZkVsofkl6WBX/fr03NFV4a84/+1iSoRJM9kDkMCQEl+uI1bfSWrFNqK
         zqZ5oWpAh92yQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 686F760C29;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: marvell/octeontx2: Simplify the return expression
 of npc_is_same
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404400642.12339.9215626631197849946.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:20:06 +0000
References: <20210618073431.103924-1-dingsenjie@163.com>
In-Reply-To: <20210618073431.103924-1-dingsenjie@163.com>
To:     None <dingsenjie@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 15:34:31 +0800 you wrote:
> From: dingsenjie <dingsenjie@yulong.com>
> 
> Simplify the return expression in the rvu_npc_fs.c
> 
> Signed-off-by: dingsenjie <dingsenjie@yulong.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Here is the summary with links:
  - ethernet: marvell/octeontx2: Simplify the return expression of npc_is_same
    https://git.kernel.org/netdev/net-next/c/e44dc724826c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



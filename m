Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029A545903A
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239463AbhKVOdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:33:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233427AbhKVOdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 09:33:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0CFB86023E;
        Mon, 22 Nov 2021 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637591409;
        bh=E95nm6cC9IAgx/5PCrlDxOKFaUuN+sZSazURKswtohQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oLtN/W3iVJjKmC1MmlJ0s8kXq5dG5Ft9UnPJgLE6UpxmPExOQeQhJSN+QFhsYNK2h
         NTR5FOUxn5EgwR42luZ5baO2hKaQFdBzN8c/ECvLAY0QgJ+5DQPTyTfxsq5dCWY5Wp
         r9AU3sW3x29R7xZWqDWtJqztTQotHCynCB6X1mxrdcuZUMdpMo8e3OnmyDslPkow1Y
         TJB4hXkToc9S+41g7YsAthqRiPxiqNVBpSG75uRTZVoy5Fnf2g08d7gR82hSalmQiC
         yA0vovrxNXzUQYIPpgi2excvtAAu9HUNj1WbEp6GNLQuulAnBdXzGQ+2OJriFAwmV5
         bpxkZVycK5ESw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EE5AD609B9;
        Mon, 22 Nov 2021 14:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rds: Fix a typo in a comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759140897.30186.7474648207680376038.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 14:30:08 +0000
References: <006364d427b54c8796dd1a896b527cd09865bba1.1637508662.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <006364d427b54c8796dd1a896b527cd09865bba1.1637508662.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 21 Nov 2021 16:32:04 +0100 you wrote:
> s/cold/could/
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  net/rds/send.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - rds: Fix a typo in a comment
    https://git.kernel.org/netdev/net-next/c/db473c075f01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



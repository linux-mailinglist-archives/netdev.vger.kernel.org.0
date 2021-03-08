Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31CB331804
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 21:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhCHUAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 15:00:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhCHUAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 15:00:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F3DE65287;
        Mon,  8 Mar 2021 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615233609;
        bh=V5DtGVzxX7v4dke4rhw+8vBR951EeV0UUfUNebDBeDg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bSyAqqUcg3wvaw8GmUJ7wQmFJutAkbOkxEFa9qIbtmw458Q/rouFfHhUebH1yRJrb
         fKWKwzJB1zI7iaRmR1bCggKQ9wdCKBiSNBD7LyBCkB5aZhXp/g5vj/cu1rKx30IYAs
         GHsA+u9wBZwn4zj2OYh9fJFDIv5pORy/vwNzLL89CM4S6oAeVkERc5GwL9QRicsZ0U
         5dohaeQf5pmJHt7xykx2hVJ+JsMJbm6WRCmgX5fPmWTQVMIbDGaKa/VknvtELfhR0Z
         LnO2skZ22uKOjX82QZW8snt6tEZssRVni8dgdzZVMGIgG5SZnct6HDYsN/HjtAcxtE
         7UBuiFIaUppBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 20FB2609DB;
        Mon,  8 Mar 2021 20:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wan: fix error return code of uhdlc_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161523360913.22994.7942114811329653133.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 20:00:09 +0000
References: <20210307091256.22897-1-baijiaju1990@gmail.com>
In-Reply-To: <20210307091256.22897-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     qiang.zhao@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  7 Mar 2021 01:12:56 -0800 you wrote:
> When priv->rx_skbuff or priv->tx_skbuff is NULL, no error return code of
> uhdlc_init() is assigned.
> To fix this bug, ret is assigned with -ENOMEM in these cases.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: wan: fix error return code of uhdlc_init()
    https://git.kernel.org/netdev/net/c/62765d39553c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B825836BACA
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 22:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235298AbhDZUk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 16:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233971AbhDZUkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 16:40:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2B96F613B0;
        Mon, 26 Apr 2021 20:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619469609;
        bh=zp8vVjpvI+DvL04AtJ5ZHjaD9wbk2JQnh0MOxp6oXXg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dtCYtywcOJDuQggQkDe0Py2WVwUQV/E8mVg/QvoEk19zAV7fWr3v612GUmsH3t4ST
         +cj8udGWi+nM+HadghnKTELsqiQvQ4svPT/ljabff9e9POxUMmaoOVETq3UM+gDRZ3
         y2l5AKFNd650sBUpFLZooOfX/9H248y7dcpbqtPn86rmoJvRbtVVhhCZc7TEOY3eXQ
         +gAkaGenl5Yss06isdp5YQYjGS5/dB6H+8kOmLdraoKpS4uKVK53pTVa50RUP5+Ktr
         2ha+/ZZWkOJFTemFkB9bq/6VzMpTRaLiFIHv2vLbidbvmyy+7jpgtaSMMRy8IzMFzV
         63WN7179uTL3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1F78E6094F;
        Mon, 26 Apr 2021 20:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net:emac/emac-mac: Fix a use after free in
 emac_mac_tx_buf_send
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161946960912.8317.15351788519078792132.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 20:40:09 +0000
References: <20210426160625.9573-1-lyl2019@mail.ustc.edu.cn>
In-Reply-To: <20210426160625.9573-1-lyl2019@mail.ustc.edu.cn>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     timur@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Apr 2021 09:06:25 -0700 you wrote:
> In emac_mac_tx_buf_send, it calls emac_tx_fill_tpd(..,skb,..).
> If some error happens in emac_tx_fill_tpd(), the skb will be freed via
> dev_kfree_skb(skb) in error branch of emac_tx_fill_tpd().
> But the freed skb is still used via skb->len by netdev_sent_queue(,skb->len).
> 
> As i observed that emac_tx_fill_tpd() haven't modified the value of skb->len,
> thus my patch assigns skb->len to 'len' before the possible free and
> use 'len' instead of skb->len later.
> 
> [...]

Here is the summary with links:
  - net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send
    https://git.kernel.org/netdev/net-next/c/6d72e7c767ac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DAC34C0E0
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhC2BKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhC2BKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 21:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BEA5761951;
        Mon, 29 Mar 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616980209;
        bh=zxQ+ZIrauQfx6GNAIlXEkCWtWQkdo2pHRfdWo9A4qdY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hqvWkiVI9tnXfhugPZBa7EdOI4pI+qXJEaeOFSsd4+SnPQbMofHcLNwK0FpeoIIQx
         E3beZGFdEWYLK7mShVghnDvSqaApPpQxqC1s4/InVQGLhc+0YWIArZby4osuV4uRDh
         X7eTWio5QkdNboZi5x/sjvzd5UvldKdwIB54Bu9mpFvnsOwGbuhWj4EvPLmZCj3aQ/
         4FptFmeXgdSqtOGbyHdJTNVJDWJz0X5YEUoqPxrt1HuEt1WCCveMTfcgoCVLnHKHh2
         1FOrVCY1d2hNm76tSJdEaKy6JvASv8cxHKx9OHM+iCJrxeko0uBdbZzvELIYqdELbc
         MoalEJNHIMYsw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B143260A58;
        Mon, 29 Mar 2021 01:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mt76: Convert to DEFINE_SHOW_ATTRIBUTE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161698020972.2631.5798600875086816841.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 01:10:09 +0000
References: <20210327095617.1222-1-angkery@163.com>
In-Reply-To: <20210327095617.1222-1-angkery@163.com>
To:     angkery <angkery@163.com>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, shayne.chen@mediatek.com,
        yiwei.chung@mediatek.com, ap420073@gmail.com,
        sean.wang@mediatek.com, Soul.Huang@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        yangjunlin@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 17:56:17 +0800 you wrote:
> From: Junlin Yang <yangjunlin@yulong.com>
> 
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
> ---
>  .../net/wireless/mediatek/mt76/mt7915/debugfs.c    | 36 ++++------------------
>  .../net/wireless/mediatek/mt76/mt7921/debugfs.c    | 18 ++---------
>  2 files changed, 9 insertions(+), 45 deletions(-)

Here is the summary with links:
  - mt76: Convert to DEFINE_SHOW_ATTRIBUTE
    https://git.kernel.org/netdev/net-next/c/8d93a4f9ccfd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



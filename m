Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D48A45078A
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhKOOxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:53:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231131AbhKOOxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:53:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8CD6163211;
        Mon, 15 Nov 2021 14:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636987808;
        bh=9DjMD/BUJwagr3X43PeQ+u4pTppZD2NqxOLmN2rD5V0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g7pd0i+Rxc9WUSrAbUEdYwMnUrbCGb+Y0exOpGdqfK9pqv3frywvBCb/hoQeBb/8U
         uleiTpTTIqogVlZDXv3iUyQ556meMJ4mhJJCEPJbOlbeICiCIKFa+jMpo1P8Jca+SA
         2dz1zvhRACG54UuaTJAucSR68EFIaObFsNL6giWAhOF2UgLwd+A9KSuPcZZ8psHZIQ
         47G/kmtOMNAHx7KQT6bcH6TAh0wrRWq+rxinwrezqHxYLNQvr+u9A6iFecPmzgeTSr
         /TTXfaPiqaKVN1f86k3YLnkB9DIf3udvoKcZXg3YVF9UyIxdmYlivYlPX/UJ+EjEkc
         ddPaLEy6OB2cg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7A1136095A;
        Mon, 15 Nov 2021 14:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: Make sure the link_id is unique
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698780849.3779.15323117255010260641.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:50:08 +0000
References: <1636969507-39355-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1636969507-39355-1-git-send-email-guwen@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com, tonylu@linux.alibaba.com,
        dust.li@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Nov 2021 17:45:07 +0800 you wrote:
> The link_id is supposed to be unique, but smcr_next_link_id() doesn't
> skip the used link_id as expected. So the patch fixes this.
> 
> Fixes: 026c381fb477 ("net/smc: introduce link_idx for link group array")
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [net] net/smc: Make sure the link_id is unique
    https://git.kernel.org/netdev/net/c/cf4f5530bb55

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



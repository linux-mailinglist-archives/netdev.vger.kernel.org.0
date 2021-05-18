Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6751C3881AA
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 22:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351949AbhERUvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 16:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351969AbhERUvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 16:51:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 12E3861377;
        Tue, 18 May 2021 20:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621371013;
        bh=7FCWd2B/CxkR73WUlM+s2mb+67BN7hCoVxCDDN+ttg0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dYwdTTavNGtMgH5ryML8M2Zd4doCm6f9LHK6ZRqc0nE85v6f8pW4JspOw527FFZMi
         dn7vj+9iTJBIuttwv4WTlzFDKYxdl0yp/N4Mw50dooBs9Ynf2nnQHPBplC3c0FzX2L
         Ed5BSNHcGQS21tQWR1oqf/d1C3gHiy2EvoKyCWOjskB93v0NYfG1lQAH09N/lqz1f8
         ndvxmoLzA5xGBRmZj5qGU+3tehlUCrli6BxPR3Dwn6OhRUJkB5sMerW5c54L7zJ8Mf
         DsnEz4k55vwEthkc66azjbTOCD58qtm8+Q2FDBm3ZApz8jjpfU3gJDV1pUy0ZryA+U
         C8wGMvt2Zj0UA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0BF7560A4F;
        Tue, 18 May 2021 20:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] cxgb4: clip_tbl: use list_del_init instead of
 list_del/INIT_LIST_HEAD
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162137101304.13244.16777161163606496526.git-patchwork-notify@kernel.org>
Date:   Tue, 18 May 2021 20:50:13 +0000
References: <20210518130135.1303312-1-yangyingliang@huawei.com>
In-Reply-To: <20210518130135.1303312-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 18 May 2021 21:01:35 +0800 you wrote:
> Using list_del_init() instead of list_del() + INIT_LIST_HEAD()
> to simpify the code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [-next] cxgb4: clip_tbl: use list_del_init instead of list_del/INIT_LIST_HEAD
    https://git.kernel.org/netdev/net-next/c/44e261c715b6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



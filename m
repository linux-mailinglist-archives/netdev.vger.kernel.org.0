Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C508446EC6C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbhLIQDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239756AbhLIQDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:03:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BD9C0617A2
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 08:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5750B8253E
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 16:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F9AFC341C8;
        Thu,  9 Dec 2021 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639065609;
        bh=0/PEl4TNEWjnIvETyPvtja6I2g6vq7WrdYlruzUUQLU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OS6E/FapmFmcTXOotCGMRLoqM/BcgLWa9bOEID3Art5Zgq7ZF1vyFw9IlYydoZvBe
         oB/1n/PMazaMOBSlcYvdZ8X2+mR4Bi332qvIvzFdk+wd/oPmOW7GixQtqsEXhqd1px
         i5ir7SEw2HvGXpOiaBqllZaqf4fImN9wxWNeH5X+xQ72p2WsX7SIbNh8ziV3MVPk1c
         BZILr9GpRrjeZDqv8x0i6jZA648RWp/JqhYtvf1XfNeEkNZRz1BiPC33LDQps47Mln
         Ds92wofneGTyBVE2XotfoM4p9qz0objUaASrSqaAd/IgzIvvrHeV92fZbn7DMhffWz
         1zFJjYS20L8Aw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 66FAE60A37;
        Thu,  9 Dec 2021 16:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] udp: using datalen to cap max gso segments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163906560941.14007.18184912106434798578.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 16:00:09 +0000
References: <900742e5-81fb-30dc-6e0b-375c6cdd7982@163.com>
In-Reply-To: <900742e5-81fb-30dc-6e0b-375c6cdd7982@163.com>
To:     Jianguo Wu <wujianguo106@163.com>
Cc:     netdev@vger.kernel.org, willemb@google.com, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 8 Dec 2021 18:03:33 +0800 you wrote:
> From: Jianguo Wu <wujianguo@chinatelecom.cn>
> 
> The max number of UDP gso segments is intended to cap to UDP_MAX_SEGMENTS,
> this is checked in udp_send_skb():
> 
>     if (skb->len > cork->gso_size * UDP_MAX_SEGMENTS) {
>         kfree_skb(skb);
>         return -EINVAL;
>     }
> 
> [...]

Here is the summary with links:
  - udp: using datalen to cap max gso segments
    https://git.kernel.org/netdev/net/c/158390e45612

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



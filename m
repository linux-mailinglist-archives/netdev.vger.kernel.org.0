Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154F2488DD0
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbiAJBBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237721AbiAJBAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D17C061757;
        Sun,  9 Jan 2022 17:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16B11B81082;
        Mon, 10 Jan 2022 01:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19E02C36B06;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776414;
        bh=hS9hh7p+4SCakO5Uzy4ZJ9A5Ahbw6pUakrQzHhek/cA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QQIJqJaxUqsDK1Da44Bp7As34CcbQsKnFitICanE8BYqfPgRz1zkVll7ogpsLsmXc
         hmpvSN5YRIVgD5LwrdTo4hkOX7Nu6b/9aLiAx0BYydwuLN9B/qRSVlSuiKnPgO9HBJ
         Ogy9kULptaP5cHM7eh/9CWr52bdmOKuH7BTMSwKccDntQye+QoX1V78JwZPfTzxEKl
         7TAB0kY4gXGgDjMTfHPmDoO3f4tlI2jVpRxl0iyiAiOVi9XUc4OMvuQM4YHBEpVLaj
         44nXcWsh5BUJzqgrO/qliPmgQGACn0k1u/kmjx0F41nNs8i3mP3yp7es7VRjnccddj
         e2BF+f/vOYKLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07BD7F6078E;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cxgb3: Remove useless DMA-32 fallback configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641402.18208.2421177951432334166.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:14 +0000
References: <a0e2539aefb0034091aca02c98440ea9459f1258.1641736234.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <a0e2539aefb0034091aca02c98440ea9459f1258.1641736234.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 14:51:22 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> So, if dma_set_mask_and_coherent() succeeds, 'pci_using_dac' is known to be
> 1.
> 
> [...]

Here is the summary with links:
  - cxgb3: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/544bdad07494

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



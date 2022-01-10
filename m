Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C7D488DC0
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237849AbiAJBAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237708AbiAJBAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADE7C06175A;
        Sun,  9 Jan 2022 17:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15BD761122;
        Mon, 10 Jan 2022 01:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67935C36AF2;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776414;
        bh=A2tZ/teiEKMNvU4Cxth89Exrf/a7s2r878v2y4jeKGc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PiLUyOSDl03eoAIjoEyc2LobCBbL7lPYB5ezIw8Lh152AWIrGFmZVRWe6vu3cG32K
         Ui16KZUxlGMV/PZ++vgba/PuXqxOMYOjGIN7IlwnLubnfmp7EZTiqWeqOjJqxra/qU
         IE9nLCrGIYO/kRz2nDLe22K03qUDPZI7K0xQe/iKS68uruvY8GFAASay0dEfPJEp1u
         QupmKweRZv3qL23KBXZ5ALLTrnBGA6coJBxU0KiTrl4xFlkDYriK2XISia/N/iPTu/
         8gzK/gOvJdlI6I8xcSnfUbK1yEgQf+t6ZqNzDRIEyK6ZGIvZoKb/eidFa2+qvzJCtT
         fzqLxCul0g/Sw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4FD32F6078F;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qlcnic: Simplify DMA setting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641432.18208.3025357572483387514.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:14 +0000
References: <4996ab0337d62ec6a54b2edf234cd5ced4b4d7ad.1641649611.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <4996ab0337d62ec6a54b2edf234cd5ced4b4d7ad.1641649611.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  8 Jan 2022 14:48:59 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask will never fail if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> So qlcnic_set_dma_mask(), (in qlcnic_main.c) can be simplified a lot and
> inlined directly in its only caller.
> 
> [...]

Here is the summary with links:
  - qlcnic: Simplify DMA setting
    https://git.kernel.org/netdev/net-next/c/a72dc1992de8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



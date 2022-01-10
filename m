Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4810488DD8
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbiAJBBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:01:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50608 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237698AbiAJBAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED730B8107D;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3E8FC36AF3;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776413;
        bh=QjGfbGdur4r8H/e7u5tmEEU3X5gKREK3p8NVS1iJxrs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u8ZVFREC6z3u1Z5G3sUXFdU5/9iQK0T6qq4tPnxXsVFgcaVIytjB6apnutQs4lmdZ
         IUinsgSXmyyP8ZSXJu5q+/+3q1AybKwh/bdSDdh0lDT5n6yaKrXa0TZBygo6sRsZM0
         +JUcRnSxzwKzLEL7ylcZz9qF49wvcWckd4IPRX1x3sMBB/oJiT9BOebrj3czW0HEJa
         wdAG13a3TbV3zgmhAGw5E5pEbqoyzPN49y2ZzRlUhCabV5HGHzm9Ijb7LxHLn5jcZf
         rsQJI8xOJTarcXpsc6YhDBx+HrwiD6tC2X+1kxnpT/cv3lNCeog6hb2Ieqh5R9q69I
         51tFbJttPVgLQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 924B9F60791;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bna: Simplify DMA setting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641359.18208.11290961412456226547.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:13 +0000
References: <1d5a7b3f4fa735f1233c3eb3fa07e71df95fad75.1641658516.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <1d5a7b3f4fa735f1233c3eb3fa07e71df95fad75.1641658516.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     rmody@marvell.com, skalluru@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  8 Jan 2022 17:16:16 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask will never fail if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> So, if dma_set_mask_and_coherent() succeeds, 'using_dac' is known to be
> 'true'. This variable can be removed.
> 
> [...]

Here is the summary with links:
  - bna: Simplify DMA setting
    https://git.kernel.org/netdev/net-next/c/9aaa82d2e8d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



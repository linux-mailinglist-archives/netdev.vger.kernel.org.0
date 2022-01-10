Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD1E488DC5
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237769AbiAJBAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237736AbiAJBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA91C061756;
        Sun,  9 Jan 2022 17:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 206D1B8107B;
        Mon, 10 Jan 2022 01:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2454DC36B09;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776414;
        bh=xxrtH6AQpTOSTjEmBsXyFHyyljWLYcbQt6gYD5ZCeGs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iknfAbllJeOlgq0JW5E9TtAh1lVup2JdNFjgLlqMUNSuVddZDVKVTOdDl4HmYqfnQ
         imvrLF3uI36dYcdf0HX7ev2vcKJTbMTluFViKj32dIlm6mGg3P0KRL1PSFIhQMAUQE
         uJqOQjImsOe3boGt3QY1gwSHQnQdseMpvCyZsIWAlsd5YSD1myOc5vRXdTd2gIMWho
         x7lwUlEKTgLaROdlS/pY32R2cNRbwlWCxWSHZgouJvA1lZ1rs2scwzMRz3Gz4UckJf
         drulTqucwNG06PcmznugQ/22fCKSfmwXdDHpYJIPbOV6fzMyMdY67u7QyFhtyFAiwJ
         nAWq5SpusKKSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11F1CF60791;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: enetc: Remove useless DMA-32 fallback configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641406.18208.1968849844538949127.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:14 +0000
References: <dbecd4eb49a9586ee343b5473dda4b84c42112e9.1641742884.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <dbecd4eb49a9586ee343b5473dda4b84c42112e9.1641742884.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org,
        yangbo.lu@nxp.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 16:41:43 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> Simplify code and remove some dead code accordingly.
> 
> [1]: https://lkml.org/lkml/2021/6/7/398
> 
> [...]

Here is the summary with links:
  - net: enetc: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/cfcfc8f5a54b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



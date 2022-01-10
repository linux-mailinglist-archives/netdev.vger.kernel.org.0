Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638D3488DB7
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237788AbiAJBA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbiAJBAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE636C061748;
        Sun,  9 Jan 2022 17:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4826F6109A;
        Mon, 10 Jan 2022 01:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4143C36AFC;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776413;
        bh=yKlf9NFNe4xAxjciHty/EvMBeOw4ic1gJtVS6+AWQ8U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WD4HBIFi+kCAj8gkSKTAA1eFOownHxbDqm5GSJ6cMH1mD8K3GUi+6mAmDn6ld7yHr
         dV5uN9FFrQZh/8/f4hnrGXCMwYtsscQ1re/YuU0U6oCas4T2LJ7C1N6cJ65RWNHnQI
         ctlFDKbqhvQGqOceNqkWslXZbqCZSlpmjBvgyOTA/0L0uV52/tt49qUiwbDfWY96TS
         GhQA3GTYrMd9E6rNeJeutKjVnPUM8EtUwYcdhCNMOSTkvBHV8xVFCXC4lomut0JFpY
         ZOSUGcvRcrM2vVXRGUmKXTW6IyZaGHb2c6LQOvQFOQfCWEhbY21PAa+ZlM+FhC1uE5
         zoqyjBPBuHyBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0D02F60790;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vmxnet3: Remove useless DMA-32 fallback configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641378.18208.15178450921966625401.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:13 +0000
References: <43e5dcf1a5e9e9c5d2d86f87810d6e93e3d22e32.1641718188.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <43e5dcf1a5e9e9c5d2d86f87810d6e93e3d22e32.1641718188.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 09:50:22 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> So if dma_set_mask_and_coherent() succeeds, 'dma64' is know to be 'true'.
> 
> Simplify code and remove some dead code accordingly.
> 
> [...]

Here is the summary with links:
  - vmxnet3: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/c38f30683956

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



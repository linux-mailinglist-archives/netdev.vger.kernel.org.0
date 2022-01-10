Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E2A488DBA
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237809AbiAJBAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237700AbiAJBAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA42C061751;
        Sun,  9 Jan 2022 17:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53057610A5;
        Mon, 10 Jan 2022 01:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7560C36AF9;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776413;
        bh=6GYBwtkAa4xUMccgC3/BzpMigN9YUet8OWuRDmfQQBw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hyIex0TwuFIf2ZkSE3DWtliAa8cBlA55pavXFLxUsNQjsK++4Ho1065o9luER8khL
         1pCNJtvo94UYzQIxGjEzITZvykwt4jjKg/wC4BtFhmBDXNecW1OP4h4QgO49zAzTP1
         uez69t8nYgtjvLWNQCsRUOJmqW716hD0hJZgOFVAfXA6/q/I/hkcRjAxeUPO/cz7pZ
         B/TX/1iOjzC1SEi9ryqldAziiTMeodx/NMYQAe/OpP4hYuJ2nvQqoXn2I9wtyRrKEi
         SDRFCanfFxGJsykojoaCec1nb2Kqeuv4v+EVOWKzqA6znymUpYTuOeVKOXbBYdN6KM
         NuaeXcW2S03tQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B31E3F6078E;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: alteon: Simplify DMA setting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641372.18208.8881552239019248991.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:13 +0000
References: <1a414c05c27b21c661aef61dffe1adcd1578b1f5.1641651917.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <1a414c05c27b21c661aef61dffe1adcd1578b1f5.1641651917.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        linux-acenic@sunsite.dk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  8 Jan 2022 15:26:06 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask will never fail if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> If dma_set_mask_and_coherent() succeeds, 'ap->pci_using_dac' is known to be
> 1. So 'pci_using_dac' can be removed from the 'struct ace_private'.
> 
> [...]

Here is the summary with links:
  - net: alteon: Simplify DMA setting
    https://git.kernel.org/netdev/net-next/c/ba8a58634972

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



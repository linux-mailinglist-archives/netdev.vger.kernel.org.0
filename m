Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94629488DCF
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbiAJBBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiAJBAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C5CC06175B;
        Sun,  9 Jan 2022 17:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D18DB81085;
        Mon, 10 Jan 2022 01:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0348EC36B04;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776414;
        bh=KswFpVK4DixhjjxjTyP5oo8O2HjjmOLZxMSzTZG+IFA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Geig0KPYYu6RancmWCRttoSAA50YVHsIMy8uG+YYVwvU7e8QsitV5C14paDv6e4Io
         Nd7YMF1j7ftz6AC1UqEyWI2ZnD4xf+efo7jpqv69IjPXyhH3Vt5YZqNw/WztSJt4f4
         gT0SM4m0itqdAdMh46vR55TWSAfILMzBwXYFwq0HwedGMkGvm/hBYEhZzce4DWe5LX
         /OJCRPYpXWd7KIo9lqbCmCJPFDpdr1D7LM1XDs5/xtLHQlnH/dCuy5EL5rHFZNp695
         tpieqwgqk/Ep9CbwE1FR3Eb3Oy9qFcMNqtT31qSNNbraCbNesjVqZ2ph+4JDJI9jF4
         /y9s1mkD3vWng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2468F6078F;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] be2net: Remove useless DMA-32 fallback configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641392.18208.2737558467182195149.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:13 +0000
References: <637696d7141faa68c29fc34b70f9aa67d5e605f0.1641718999.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <637696d7141faa68c29fc34b70f9aa67d5e605f0.1641718999.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 10:03:49 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> So if dma_set_mask_and_coherent() succeeds, 'netdev->features' will have
> NETIF_F_HIGHDMA in all cases. Move the assignment of this feature in
> be_netdev_init() instead be_probe() which is a much logical place.
> 
> [...]

Here is the summary with links:
  - be2net: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/942e78916f0c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



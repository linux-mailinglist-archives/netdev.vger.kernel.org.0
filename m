Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CA6488DDB
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238083AbiAJBBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:01:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50594 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237693AbiAJBAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6A7CB80E8A;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E247C36AE3;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776413;
        bh=pw18cUmaIpB1F/HWpZvXzHGi6pXH8AITFVZkviRrEpg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s7kn/gbu29dfh7/gUU/GZIrYPi+KCTtr07OmMrm+794zBzoLSe8oiT0vIqV9g7T1a
         +sWJk8cyQP9eDJeAwYTOavTcASaRwbP3MO6CKbWXzfa+BChXnqsOoNTs2bpIw2rlWq
         pieiADo4ggY6bhyPgTYgdMEXDyh5PG5p6BPpi1bRrygvXu/BJLaPJxLHbGQ56BL4Ql
         f4huBtQwI7qtFY0X7v181poRRhm12UDPzbqTAK0YKwXxTULke4pUeKy2rZK10W8zAt
         wGn8Fn6Z6K9C/XyaFrwD4Z7pUls6WRmI8E1XCM5WiKhYzSjqYyAtbVMwC+JUitKKyb
         B7aACpt9bfRiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C95CF6078E;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] myri10ge: Simplify DMA setting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641350.18208.1416757090967576315.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:13 +0000
References: <e92b0c3a3c1574a97a4e6fd0c30225f10fa59d18.1641651693.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <e92b0c3a3c1574a97a4e6fd0c30225f10fa59d18.1641651693.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     christopher.lee@cspi.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  8 Jan 2022 15:22:13 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask will never fail if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> If dma_set_mask_and_coherent() succeeds, 'dac_enabled' is known to be 1.
> 
> Simplify code and remove some dead code accordingly.
> 
> [...]

Here is the summary with links:
  - myri10ge: Simplify DMA setting
    https://git.kernel.org/netdev/net-next/c/21ef11eaf3f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



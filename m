Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE144A56F0
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 06:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbiBAFaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 00:30:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41866 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiBAFaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 00:30:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 356E461484;
        Tue,  1 Feb 2022 05:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76FC5C340ED;
        Tue,  1 Feb 2022 05:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643693410;
        bh=dxEhLGAPfFYwIotfbOYPoy4k4Qz/Kx96ise1IMTcyt0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t5L/DMcEzt7y7M83xvCtYxJB8+8saFwOWuLb4s9elYiPDKg8yepthvUwhcLYv44Tl
         jeZrATqOp02TlsjHuF3SBFgbWILBa+XQKQO9E6GEISBVhphhBSjGqUXroyRIK0UhQ0
         0YWsJCu5jqKSx/B5a++we/YRilyAlpbLeJlzCVzhy86YnOqst4l5HRYb663YgyNO3E
         /iypf0Hp0FwWOZMP6b7y+wycZNSrfbj8xYKHHf5r2A7PKTmITHnsIFG4ikCVxO+869
         ZqExCkE2YCK6fIbIwTYmUFQZxleyglYwCBUtW1W0WiITdYFGCzy5nYQDpXOznfbHGt
         uKB+atzQdPa7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5678FE5D08C;
        Tue,  1 Feb 2022 05:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: stmmac: dump gmac4 DMA registers correctly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164369341035.4704.10544082245464060928.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Feb 2022 05:30:10 +0000
References: <20220131083841.3346801-1-camel.guo@axis.com>
In-Reply-To: <20220131083841.3346801-1-camel.guo@axis.com>
To:     Camel Guo <camel.guo@axis.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, kernel@axis.com, camelg@axis.com,
        clabbe.montjoie@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Jan 2022 09:38:40 +0100 you wrote:
> From: Camel Guo <camelg@axis.com>
> 
> Unlike gmac100, gmac1000, gmac4 has 27 DMA registers and they are
> located at DMA_CHAN_BASE_ADDR (0x1100). In order for ethtool to dump
> gmac4 DMA registers correctly, this commit checks if a net_device has
> gmac4 and uses different logic to dump its DMA registers.
> 
> [...]

Here is the summary with links:
  - [v2] net: stmmac: dump gmac4 DMA registers correctly
    https://git.kernel.org/netdev/net/c/7af037c39b60

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



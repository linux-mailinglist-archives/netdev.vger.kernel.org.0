Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD854841BE
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbiADMkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiADMkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:40:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4F9C061761;
        Tue,  4 Jan 2022 04:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 934ECB8121D;
        Tue,  4 Jan 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B983C36AF4;
        Tue,  4 Jan 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641300011;
        bh=45TXa3t5mHJKvDcGYOiHnVaPCjYQakDojHx85SQGx3g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KeQn+E0lGopSAIIQ9FcRNtz5hxGN6R50Qp2yeBzirpXjr3NwILj9kmii48u79qB9O
         g9txUvIwtBY5GQ/tFuxvS5YM0FwsDKUOyFAxOCXHEdvp8kv+vI21Rzh5ftG8wjFhni
         3T8bWcT47va5h1T0v/sNye0uLOhzYONtCVHfBCOwet2uUdpJAkpDL+Mz0zyRCIHUr0
         YxA4Qnv+G5EmhWQE7eki/ARt41N5mC6CQqlAy0miRr4RUIgD1VizbNwaI/tgfLdTzj
         p6hB7t9sq0+MCM6hrD/1BDymHNvhnvtHgqtwmTtrBWAOlhcBULBzXDQWm+PWPrxlgN
         29ttSs5a+NOig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39631F79402;
        Tue,  4 Jan 2022 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lantiq_xrx200: add ingress SG DMA support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164130001121.24992.258036361751881128.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 12:40:11 +0000
References: <20220103194316.1116630-1-olek2@wp.pl>
In-Reply-To: <20220103194316.1116630-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  3 Jan 2022 20:43:16 +0100 you wrote:
> This patch adds support for scatter gather DMA. DMA in PMAC splits
> the packet into several buffers when the MTU on the CPU port is
> less than the MTU of the switch. The first buffer starts at an
> offset of NET_IP_ALIGN. In subsequent buffers, dma ignores the
> offset. Thanks to this patch, the user can still connect to the
> device in such a situation. For normal configurations, the patch
> has no effect on performance.
> 
> [...]

Here is the summary with links:
  - [net-next] net: lantiq_xrx200: add ingress SG DMA support
    https://git.kernel.org/netdev/net-next/c/c3e6b2c35b34

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



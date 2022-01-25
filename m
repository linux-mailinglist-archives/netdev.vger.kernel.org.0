Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495B549B9D1
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390215AbiAYRMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:12:12 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41022 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381226AbiAYRKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 12:10:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CA45ECE19D4;
        Tue, 25 Jan 2022 17:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3004C340E8;
        Tue, 25 Jan 2022 17:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643130613;
        bh=IGK8sFR8ROzYCbr03pUu99n6qgq4YQbfLcWdiBF3v5U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hTnNQ1I6XhvuUzlIx3lBAM5WfZR/1gU7rkhJ68+8ZQVJeWc4AcaHWzJKbL49NOSlp
         wbqdAQG2PrtiF7o8r8hvXrVTIZv5LgcOnV+8BjH1+8CdgGEKdlFAiPldvWh4fYyGaa
         GJYnS9LjDLXxowha5R/J+JyKeRnsngHtE1EnPy+B1QyBo2Oah5SU9AKRb0j+GauBdo
         9+MNjUTwb1FiRGgfxTeyGgXojJ2zDudU+OZrlWxOZGssvMW+2OKXcXOYYf9aS0gv/b
         Lmb40PJtC++OY+Yjg30MdUDfLOnT1N6gRNAX4slb2Lku68Ljf6nb+H7rrXMu+i2mhV
         awX4CzFSMlnkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0D02E5D087;
        Tue, 25 Jan 2022 17:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] amd: declance: use eth_hw_addr_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164313061384.29422.12974024496460633467.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Jan 2022 17:10:13 +0000
References: <20220125144007.64407-1-tsbogend@alpha.franken.de>
In-Reply-To: <20220125144007.64407-1-tsbogend@alpha.franken.de>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 25 Jan 2022 15:40:06 +0100 you wrote:
> Copy scattered mac address octets into an array then eth_hw_addr_set().
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>  drivers/net/ethernet/amd/declance.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - amd: declance: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net/c/8bdd24940b69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



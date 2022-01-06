Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1694448647B
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbiAFMkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:40:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50694 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238877AbiAFMkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:40:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4954C61B33
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1DACC36AF7;
        Thu,  6 Jan 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641472811;
        bh=cAcrORGpelwB/WO/uZMpJfvrFCWgvMLNlq/Aqwa0TWw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JT3YpaaNHKYogmbbP2IH0YV1r1haNiW+NxJrrkbqlF3hWneaGVyh7FWK2StregZGi
         8nE4kGSYi+7jfxryZd9p8OMvgn3hibDuuKAwiVgzOszBEkRm5hUJgfOZ4ktxkd2EK2
         DU/aVqpxeUUaSPPLmMzqlZmzqpdzjZRj29a1OwvXEOb3EjONZx/Hhv+Wr5BPrW3GhT
         /ytR4/gY0ni8TZTYBZccHpNS4Qn2fB1jTZNo9++jYddYpDWOSyZsoYH9oJoRbd/iq/
         i+mGiMS40AJclYSXzcwva3x7AFq8eef9Jarz3IPcEa3bdlFcvtfIfaGESa2Gq+pFhp
         0MoJWvrvRTwjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E244F7940F;
        Thu,  6 Jan 2022 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fix SOF_TIMESTAMPING_BIND_PHC to work with
 multiple sockets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147281157.4515.2982192982198313026.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 12:40:11 +0000
References: <20220105103326.3130875-1-mlichvar@redhat.com>
In-Reply-To: <20220105103326.3130875-1-mlichvar@redhat.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, richardcochran@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  5 Jan 2022 11:33:26 +0100 you wrote:
> When multiple sockets using the SOF_TIMESTAMPING_BIND_PHC flag received
> a packet with a hardware timestamp (e.g. multiple PTP instances in
> different PTP domains using the UDPv4/v6 multicast or L2 transport),
> the timestamps received on some sockets were corrupted due to repeated
> conversion of the same timestamp (by the same or different vclocks).
> 
> Fix ptp_convert_timestamp() to not modify the shared skb timestamp
> and return the converted timestamp as a ktime_t instead. If the
> conversion fails, return 0 to not confuse the application with
> timestamps corresponding to an unexpected PHC.
> 
> [...]

Here is the summary with links:
  - [net-next] net: fix SOF_TIMESTAMPING_BIND_PHC to work with multiple sockets
    https://git.kernel.org/netdev/net-next/c/007747a984ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



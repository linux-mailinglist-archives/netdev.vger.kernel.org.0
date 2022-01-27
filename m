Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9A249E3B8
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241869AbiA0NkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:40:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44542 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236960AbiA0NkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 08:40:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEC6C61C41
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 13:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40B03C340EB;
        Thu, 27 Jan 2022 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643290809;
        bh=EotJIMfQnX00M6kzu3Ct0LGhEHFRM5nSgBkx/0MyWd4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kWh5SolXTAEzuSRlw3xXloR354+25GMj8Chps+j7DQbdjB7/Msusy5OobG5SDPs1u
         O2pkJAp52648R757NwwkR1uE2T+EDtlhYPVljf+dX17W2983TCPkZ82jXQ4LTljxvJ
         rqnpO9t8aVvXY4xAc6RrdzKFxmOf1ntm2E1L2qEPlTjoruZVxKW7b64Z2cLzV0Jng1
         MXISdZDIKfmtdP56CVdoDXOCawIFNRNRwwoOZMpU3ohJMS1fyBSrpVVP3ZH3D1oIiE
         3OXn/aKX356UCRezacbXfkb2yr6hHSLfpDMkPS7Rjyi7UiOZqfYm2LLLo9p7aNuY9J
         W9S41+jH0Wl9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 28538E5D089;
        Thu, 27 Jan 2022 13:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "ipv6: Honor all IPv6 PIO Valid Lifetime values"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329080915.3515.11385110777017738459.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 13:40:09 +0000
References: <e767ccf72eaee6e816d277248dd3a98ebf5718c1.1643210627.git.gnault@redhat.com>
In-Reply-To: <e767ccf72eaee6e816d277248dd3a98ebf5718c1.1643210627.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, fgont@si6networks.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 16:38:52 +0100 you wrote:
> This reverts commit b75326c201242de9495ff98e5d5cff41d7fc0d9d.
> 
> This commit breaks Linux compatibility with USGv6 tests. The RFC this
> commit was based on is actually an expired draft: no published RFC
> currently allows the new behaviour it introduced.
> 
> Without full IETF endorsement, the flash renumbering scenario this
> patch was supposed to enable is never going to work, as other IPv6
> equipements on the same LAN will keep the 2 hours limit.
> 
> [...]

Here is the summary with links:
  - [net] Revert "ipv6: Honor all IPv6 PIO Valid Lifetime values"
    https://git.kernel.org/netdev/net/c/36268983e903

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



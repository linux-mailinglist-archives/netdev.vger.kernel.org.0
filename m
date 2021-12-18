Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0712479CB3
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbhLRVAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:00:13 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46154 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbhLRVAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 16:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ACDF6CE0B21
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 21:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE1DEC36AE5;
        Sat, 18 Dec 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639861209;
        bh=wmDqiRAINqxRHWSDGyhYkz6aJyRPMrqT+mDrYmyKjB0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TMcNRdh1pApH9dP1AxeqNAS4Ha7QDG6rzpZxh3NsIZXNTSZz3RdpnIxPmU8pi44In
         y+WaYFLBHPwOFbIeTisjyy79BtjLHNLqGY1qfQjbj5Bqx2qb2JGFltJpyT7Z3fE/Uc
         iJPx5SAL/eS2ZOvhH2aoa0H2Sk7oULs+D3Ep2UwyHHZSr7RJZxVuad+iUj43H9uyMp
         8CXld+lUJ43m7yEz9LKQcWIIXk2LhkFKaLjU+6AV+ILyZaK28zsCcV3CdPsZxVhAIc
         UvS/fEVZV3QYhB+4PsBTOYR/rP9/JDfchNGncG8E1tEYxeWpA9UHwq+5TnIFOatO+/
         BhYe35XU1z9WA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ADF0560A25;
        Sat, 18 Dec 2021 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v2] mptcp: add support for changing the backup
 flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163986120970.9334.15413333219970872584.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 21:00:09 +0000
References: <ee2da8de157ad9a77dc738d12d7d86ed220642c3.1639664865.git.dcaratti@redhat.com>
In-Reply-To: <ee2da8de157ad9a77dc738d12d7d86ed220642c3.1639664865.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, aclaudi@redhat.com,
        matthieu.baerts@tessares.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu, 16 Dec 2021 15:29:59 +0100 you wrote:
> Linux supports 'MPTCP_PM_CMD_SET_FLAGS' since v5.12, and this control has
> recently been extended to allow setting flags for a given endpoint id.
> Although there is no use for changing 'signal' or 'subflow' flags, it can
> be helpful to set/clear the backup bit on existing endpoints: add the 'ip
> mptcp endpoint change <...>' command for this purpose.
> 
> Link: https://github.com/multipath-tcp/mptcp_net-next/issues/158
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v2] mptcp: add support for changing the backup flag
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=26113360b763

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



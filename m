Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8861457EB7
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 15:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhKTOXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 09:23:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237353AbhKTOXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 09:23:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4312E60EB4;
        Sat, 20 Nov 2021 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637418009;
        bh=TviKUduyPWy3hQMPSXU7nTU8lDtLdBGCSJ+Eg7jG+sQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bojb8fZ6DHsI/87iosC4jtOtCjJt2PY1odnHZaynNh2A1xpas87zXJ7pwN7WjdvnJ
         jw+el5QHZ/nzxapyyr820JJmsmycF5lskYix5ohrjl2vr8ezHp8FXTz2/vWMSmPEGZ
         KX10SF32RAd2Q1luVCiXpDcW4dfkupRHfmeG+blTg+fvNxMNX+IBnVtDRar40lQ0aR
         iK4gyynX96iXzBox2pa+gSxzFfQCKn3Z/zYPsR7FVYSb1RgqVlZY1nyyV6lvs48W+1
         KAVZpnoalok++Sam/eqKnKxJekCwtcSVeq8/sb7/uA/fhC5YkHhI8Ct0m2abOCfLZ9
         0N/B0QoX4Ei9A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 33935609D9;
        Sat, 20 Nov 2021 14:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] mptcp: More socket option support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163741800920.1892.3156527522899532998.git-patchwork-notify@kernel.org>
Date:   Sat, 20 Nov 2021 14:20:09 +0000
References: <20211119204137.415733-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20211119204137.415733-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 Nov 2021 12:41:33 -0800 you wrote:
> These patches add MPTCP socket support for a few additional socket
> options: IP_TOS, IP_FREEBIND, IP_TRANSPARENT, IPV6_FREEBIND, and
> IPV6_TRANSPARENT.
> 
> Patch 1 exposes __ip_sock_set_tos() for use in patch 2.
> 
> Patch 2 adds IP_TOS support.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] ipv4: Exposing __ip_sock_set_tos() in ip.h
    https://git.kernel.org/netdev/net-next/c/4f47d5d507d6
  - [net-next,2/4] mptcp: Support for IP_TOS for MPTCP setsockopt()
    https://git.kernel.org/netdev/net-next/c/ffcacff87cd6
  - [net-next,3/4] mptcp: sockopt: add SOL_IP freebind & transparent options
    https://git.kernel.org/netdev/net-next/c/c9406a23c116
  - [net-next,4/4] selftests: mptcp: add tproxy test case
    https://git.kernel.org/netdev/net-next/c/5fb62e9cd3ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



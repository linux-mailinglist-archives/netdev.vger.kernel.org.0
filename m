Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CBF36E0C5
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 23:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhD1VLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 17:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230323AbhD1VKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 17:10:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0AF7E61446;
        Wed, 28 Apr 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619644210;
        bh=5vTXpMHcA1FkV3/YxNisYGt5BqaA2w+UPKYOzsifulk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kc7l/NujdArbBWuSPVhNm0j4HHNM6GTcIzF+JIp/cgO5zPc/QT9bjS7bVWbhedjRU
         uIClOn/+AbCQLYr62hC4nehSRuwV0Gug/x+EUg6KjApiwRvMNfPPhiUcJ/5S6o8SWf
         F/QmaabG2PoqjoYse1+RDWbcd7yjUhIVyWX33c0BSXT+qG62cHZEUilu1dEuZsFmJb
         a5rT13bp7WqTqX7XTlhRPYtYsz8EiTi9YYTWAP/rZrahsni601FAsm2VRHR39ux5l1
         hx7xakigpArhxOi8IE0TehT8JyBIxEhQva7lGtuFEo8Gy6PqQ4SNP31HTCgRN43c0g
         /At717IG6T+2Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EF71A60A72;
        Wed, 28 Apr 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next] icmp: standardize naming of RFC 8335 PROBE
 constants
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161964420997.17892.7124305214998591659.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Apr 2021 21:10:09 +0000
References: <20210427153635.2591-1-andreas.a.roeseler@gmail.com>
In-Reply-To: <20210427153635.2591-1-andreas.a.roeseler@gmail.com>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        stephen@networkplumber.org, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Apr 2021 10:36:35 -0500 you wrote:
> The current definitions of constants for PROBE, currently defined only
> in the net-next kernel branch, are inconsistent, with
> some beginning with ICMP and others with simply EXT. This patch
> attempts to standardize the naming conventions of the constants for
> PROBE before their release into a stable Kernel, and to update the
> relevant definitions in net/ipv4/icmp.c.
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] icmp: standardize naming of RFC 8335 PROBE constants
    https://git.kernel.org/netdev/net-next/c/e542d29ca81d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



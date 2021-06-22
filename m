Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AF93B0C28
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhFVSDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232483AbhFVSCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 14:02:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0258461370;
        Tue, 22 Jun 2021 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624384805;
        bh=Q323XiQStxK5iWMZIxwLVm0qk1CXaJM9S9LVZERnwrM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kQYeHfi83MzyBg+J2uaXlf3qDmmizl8iHeDzCrp64v18tmRxjkssJsT3mtWD/AjSi
         TARBgVNxDRFtYZxzEgP+YBm/ab507N+IzQBsDR6AhhLuW+4w+Ay1fRtHphyP0weBRz
         nLVRWOKlaBRWF8lj6k0ixGsSHzaQZ4VID/X5fW9sf8WH4KT5d2xp+RXF5DpBwXqmBS
         QSFsslWOQW3yecwkKCsELkzDwoJdB+l5uR/VQU1a0Jgv2Rb0g7s9a2ZlpTrHCQPLlk
         D6sfu2mCkdaY1ufhs65C+N5DrNSqIop7gA05eqahUXBC6JLmOWuYdSI88AbnQKIAVP
         eO69Q4bP9npJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F14D660A6C;
        Tue, 22 Jun 2021 18:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] tc-testing: add test for ct DNAT tuple collision
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438480498.5394.6226360533649730548.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 18:00:04 +0000
References: <cover.1624373870.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1624373870.git.marcelo.leitner@gmail.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, dcaratti@redhat.com, jhs@mojatatu.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 22 Jun 2021 12:04:59 -0300 you wrote:
> That was fixed in 13c62f5371e3 ("net/sched: act_ct: handle DNAT tuple
> collision").
> 
> For that, it requires that tdc is able to send diverse packets with
> scapy, which is then done on the 2nd patch of this series.
> 
> Marcelo Ricardo Leitner (3):
>   tc-testing: fix list handling
>   tc-testing: add support for sending various scapy packets
>   tc-testing: add test for ct DNAT tuple collision
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] tc-testing: fix list handling
    https://git.kernel.org/netdev/net-next/c/b4fd096cbb87
  - [net-next,2/3] tc-testing: add support for sending various scapy packets
    https://git.kernel.org/netdev/net-next/c/11f04de9021a
  - [net-next,3/3] tc-testing: add test for ct DNAT tuple collision
    https://git.kernel.org/netdev/net-next/c/e46905641316

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



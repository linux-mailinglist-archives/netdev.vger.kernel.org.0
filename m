Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B279445078C
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhKOOxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:53:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232125AbhKOOxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:53:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6386B63225;
        Mon, 15 Nov 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636987809;
        bh=mixMEjVP5uAAW4hcAl654j7hmJ72WJ73N82+mHaEluM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AG1sisEVi6FqowALsciNpsLyA51WooDYQCJA6RKlJQ7f5UfnmIM57/dOfOIK5o4Lq
         1q0X0dRouDe9khwQes8ZwB0uSbhXUXwt/h8aIZ1WjB+v/G+YpZRNQV83tdwGd1YFc+
         P3sSAUbEcRIZZ/tbOXqlXnOMVgr7qi/+ymuDN8r3yFjjP3gRTxzPqxZk6hg8w5jYYQ
         vJrIQkoS4m9hwbajFg0bcJoot6v9aF0XPWRPAhAIUhqllt334abx5kLBSg03CbCSPj
         LMhWHj/EmNgBE1MgZ57NfRut9BFwsNKCqvHvRz7LO5fxteFTzQNJqVdGTRnr5eSWwr
         1SXPZQvAcHV+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5C4EB60A3B;
        Mon, 15 Nov 2021 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] introduce generic phylink validation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698780937.3779.747027399718560228.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:50:09 +0000
References: <YZIvnerLwnMkxx3p@shell.armlinux.org.uk>
In-Reply-To: <YZIvnerLwnMkxx3p@shell.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, mw@semihalf.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Nov 2021 09:59:57 +0000 you wrote:
> Hi,
> 
> The various validate method implementations we have in phylink users
> have been quite repetitive but also prone to bugs. These patches
> introduce a generic implementation which relies solely on the
> supported_interfaces bitmap introduced during last cycle, and in the
> first patch, a bit array of MAC capabilities.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: phylink: add generic validate implementation
    https://git.kernel.org/netdev/net-next/c/34ae2c09d46a
  - [net-next,2/3] net: mvneta: use phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/02a0988b9893
  - [net-next,3/3] net: mvpp2: use phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/5038ffea0c6c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



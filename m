Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB5442C331
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhJMOcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233901AbhJMOcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 10:32:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3DC73610C8;
        Wed, 13 Oct 2021 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634135407;
        bh=PHIBG//xUpB2fRkqMQIOdNLmNmD5jaAFfRHic4W/AZo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jnUwM03KUXbQDDSpHczbBnEaVOSsiEteKV2Qn/UiOuRtxaYW9DIPwStF6+pudtRsX
         JQPaP6EH6fVivEBn6uQs6roe1J6N+/gzU86hCeSquhPt+nsBAz8szLSzEK8w7YJiEQ
         Mfx0Iezumwq7HENPgbdK17iuFWYha/onw33jEUQ4X51IQfQJXMZmIxhEzJ9z58torw
         dXVEputWLZAGcLO0NRDvLxV/VyBeIuDSyMdZNAnArLEdSmNmr8aR7I+SVwE64Y9Kn/
         jfi7bAKGA2hCER9NtkhJS1oYA8feqAJ7bRC7TYyaxSxqKv+wSzpejpnPBuknXm64k8
         8ymXt1ueBbS0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3200760A39;
        Wed, 13 Oct 2021 14:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: enetc: include ip6_checksum.h for
 csum_ipv6_magic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163413540719.24314.5958453063815709270.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 14:30:07 +0000
References: <20211012121358.16641-1-ioana.ciornei@nxp.com>
In-Reply-To: <20211012121358.16641-1-ioana.ciornei@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 15:13:58 +0300 you wrote:
> For those architectures which do not define_HAVE_ARCH_IPV6_CSUM, we need
> to include ip6_checksum.h which provides the csum_ipv6_magic() function.
> 
> Fixes: fb8629e2cbfc ("net: enetc: add support for software TSO")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: enetc: include ip6_checksum.h for csum_ipv6_magic
    https://git.kernel.org/netdev/net-next/c/edce2a93dd78

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



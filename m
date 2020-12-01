Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F87B2CACE8
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392479AbgLAUAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:00:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389571AbgLAUAq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 15:00:46 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606852805;
        bh=YNpykpzqYZIYVXGaCv4ucYP+YDJ/9fc/aLBnRg3QqfQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DfUm1Y2HYGGFpHJtkF1CeBPaFb/TT/j9I8ej+CsqFWlnJ0kmPQlRjCBguFX0emgAr
         DP7HPOD/fC3Wp0MTVj+rrNIDFZdshhoenixplD0WA4fH0/CyFw081vCsp1blWjtikA
         buucb5dXFJy3iH86jVHUypB2dr8OPaxYgoiAGYGU=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: broadcom CNIC: requires MMU
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160685280582.21759.13153048274985731187.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Dec 2020 20:00:05 +0000
References: <20201129070843.3859-1-rdunlap@infradead.org>
In-Reply-To: <20201129070843.3859-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        rmody@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 28 Nov 2020 23:08:43 -0800 you wrote:
> The CNIC kconfig symbol selects UIO and UIO depends on MMU.
> Since 'select' does not follow dependency chains, add the same MMU
> dependency to CNIC.
> 
> Quietens this kconfig warning:
> 
> WARNING: unmet direct dependencies detected for UIO
>   Depends on [n]: MMU [=n]
>   Selected by [m]:
>   - CNIC [=m] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_BROADCOM [=y] && PCI [=y] && (IPV6 [=m] || IPV6 [=m]=n)
> 
> [...]

Here is the summary with links:
  - net: broadcom CNIC: requires MMU
    https://git.kernel.org/netdev/net/c/14483cbf040f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



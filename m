Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A8D4318EF
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhJRMWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231408AbhJRMWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 08:22:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 17EFF61077;
        Mon, 18 Oct 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634559607;
        bh=T2n4lcsDwvAsoSzXkBlsBsgywf5xWzN++CfMj3xRzeI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F/3I+hF1cQPITUOvHqzs/mZ3s4K/Uy9PSSVekUPKzgIcfSqvH6p/j53Z9V7l6xotE
         UFaqEBZCrxK4u2Ks6BEQygqDxEDXBEM2RIDawdauA1peVVS2jtXCRhtY2Qp5gVD3Ao
         HuiZu+WaMcNUKeY6QavR//AlbODKG0Uqfe5cHMEEQKIx4BMtB569gxPW3VSjP0aCYL
         jfk2NUtPEnU5l7A9BmRDBGduVc/teKGj3d/zpVbmaXk6+UM5N4NlZNo/SXsI4stFFN
         BjmLiMJRfFheADAXVDqcO3miSakYnzsJPQ6FyPZqEZgetEhecKzbShpcC5iiver6OK
         4gDrHsGHdSVJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 03A2A609F7;
        Mon, 18 Oct 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] octeontx2-nic: fix mixed module build
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163455960701.13509.15630125332041765591.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 12:20:07 +0000
References: <20211015210616.884437-1-arnd@kernel.org>
In-Reply-To: <20211015210616.884437-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, kuba@kernel.org,
        naveenm@marvell.com, arnd@arndb.de, colin.king@canonical.com,
        yig@marvell.com, zhengyongjun3@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Oct 2021 23:06:01 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Building the VF and PF side of this driver differently, with one being
> a loadable module and the other one built-in results in a link failure
> for the common PTP driver:
> 
> ld.lld: error: undefined symbol: __this_module
> >>> referenced by otx2_ptp.c
> >>>               net/ethernet/marvell/octeontx2/nic/otx2_ptp.o:(otx2_ptp_init) in archive drivers/built-in.a
> >>> referenced by otx2_ptp.c
> >>>               net/ethernet/marvell/octeontx2/nic/otx2_ptp.o:(otx2_ptp_init) in archive drivers/built-in.a
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-nic: fix mixed module build
    https://git.kernel.org/netdev/net-next/c/0e9e7598c68f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



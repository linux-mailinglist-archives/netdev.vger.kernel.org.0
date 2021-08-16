Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D21B3ED1FA
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbhHPKam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233207AbhHPKah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:30:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3385861BD2;
        Mon, 16 Aug 2021 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629109806;
        bh=qAGaiuj7mkRVcBwTMO8R0IPO/4+ZbYODy9JyR9fFCCM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ATUSDptcpvP6ac6N7H7mUH8j3R2H5lHBPmEvCeT+oYytw/H1aQL6qAl8gXbBvvOoE
         8d8zZ/e6+VpOUsXhDFytmVpduWeKmlpNJ86OEDsFg55NfwlHFB06ormy4U3luEWxu4
         1c4nJTzyqInQA+nT+IMcOIY+f6MwVOH6bXatSXPc36vor8lSRKi7Zg9Y63dZAYIqcu
         1hmdXHpVZJ/5E9eDb+34MJF1iuudHGzLyM/BOuQ3Iq04QCpGsLMCz7cO5qYP8ah8sB
         IxzPwOAFeaeXsA7V+BGjGODv56vT6GnGChi2xWZZsJm4GqGt9Vz4KedsCvvN9C348h
         EZWugByPFSSFQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2137660A12;
        Mon, 16 Aug 2021 10:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 1/1] ptp_pch: Restore dependency on PCI
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910980613.576.16646341237793562162.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:30:06 +0000
References: <20210813173328.16512-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210813173328.16512-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     richardcochran@gmail.com, jonathan.lemon@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 13 Aug 2021 20:33:27 +0300 you wrote:
> During the swap dependency on PCH_GBE to selection PTP_1588_CLOCK_PCH
> incidentally dropped the implicit dependency on the PCI. Restore it.
> 
> Fixes: 18d359ceb044 ("pch_gbe, ptp_pch: Fix the dependency direction between these drivers")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [v1,net,1/1] ptp_pch: Restore dependency on PCI
    https://git.kernel.org/netdev/net/c/55c8fca1dae1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



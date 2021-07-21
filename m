Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FDB3D135E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhGUP3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:29:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231756AbhGUP33 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:29:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 12C6E6127C;
        Wed, 21 Jul 2021 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626883806;
        bh=Dn83UhcSYYhUEwq8NHNIrxPGniXJq+1VJH1oxrrBVpU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JIVfOP1ReH8eaYgFDwKCtIRFv/HhdCYj126/QUSaEDd1qeU747WI/4R093GHUV94J
         cS/yd3COuxke4qSB49BT/UupfRA782zUM/7UkTzrhTvRrl7/Z7RsaWwDYCyP6EvVCh
         2WJF9+vewd3PF/VOGNLkczAJFU7IPzERsQGBaRQxtMiGm9Y+6yEi3x7ueTcwnoZ0wN
         17OgUgYu1pj12jPO6fb6sMnQHs67fJX30i466GL4Q0Lg2VF8wzFrvMipfK8/B9vuRp
         VT1AnbWvKebZXiPbHHfR6vIwnsgy8gVTAaepbhvWqXtwcuW+gWu6tEcT6xVhLavwl0
         uv/lbqBDj4sqw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0C8F460CCF;
        Wed, 21 Jul 2021 16:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 1/1] net: wwan: iosm: Switch to use module_pci_driver()
 macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162688380604.30339.5977187977733465489.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 16:10:06 +0000
References: <20210721082058.71098-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210721082058.71098-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     m.chetan.kumar@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Jul 2021 11:20:58 +0300 you wrote:
> Eliminate some boilerplate code by using module_pci_driver() instead of
> init/exit, moving the salient bits from init into probe.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_pcie.c | 19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)

Here is the summary with links:
  - [v1,1/1] net: wwan: iosm: Switch to use module_pci_driver() macro
    https://git.kernel.org/netdev/net-next/c/7f8b20d0deed

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



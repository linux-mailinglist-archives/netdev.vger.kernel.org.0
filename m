Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE74940AEF0
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhINNcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233217AbhINNbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:31:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B6CB61159;
        Tue, 14 Sep 2021 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631626208;
        bh=iorR8u6sJw8DPkn1tkSyQs5T14bDSz+sRBp7yaFdKbE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Er135zvMhDfrl61F7mLGxF33JTFLaHwCmbNVYjZQ2/k1BmPBaG5n7U73CjcN90Y7X
         2XnTgExWXFfa5Ql4YpnPekpT10ez5/xMMa7yf12To+Rp0QYVvHLFEi6ISV8z44qCqj
         z2oCJkrrhqnfwU0secHto6MOAEjR8e0j9tYXysxPxL36SercWrz5hgLJbz0st1Clgy
         KGVdwMnmsaDDMkOl8ipzNi1M0s3eUv/QOCKeudk11JSifuJxDfD83aEY7p9MjL+ASd
         K33nnqBr0lgLD9ezs9WcojYYon3kz7dRpK/IR81u9xJS3G9+/Tpkd+FvNbWoVB9dXv
         rqQkGFzXX28ZA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8251E60A8F;
        Tue, 14 Sep 2021 13:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wwan: iosm: fix linux-next build error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163162620852.30283.405094877460476720.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Sep 2021 13:30:08 +0000
References: <20210914054801.1331080-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20210914054801.1331080-1-m.chetan.kumar@linux.intel.com>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com, linuxwwan@intel.com, sfr@canb.auug.org.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 14 Sep 2021 11:18:01 +0530 you wrote:
> Removed "stdbool.h" inclusion in iosm_ipc_imem.h
> 
> Fixes: 13bb8429ca98 ("net: wwan: iosm: firmware flashing and coredump collection")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_imem.h | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [net-next] net: wwan: iosm: fix linux-next build error
    https://git.kernel.org/netdev/net-next/c/0f440524b697

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



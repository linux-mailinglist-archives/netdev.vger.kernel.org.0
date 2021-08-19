Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606383F190F
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbhHSMUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhHSMUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 08:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 379036113B;
        Thu, 19 Aug 2021 12:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629375606;
        bh=GmXH1roX7XuBgtRKhCu2Kp+P2R17fwEo2sAsoqwcLcI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JUUrt2YCKmfzVxEgdnOFhZhx2RacbF2i4oKb+n4d2HPzKMzYVyjUaoejU8+HvLczd
         /VTrSkovf2e2IRG+PqsZ0wXRbag/S7vuc/+CdFXeOiW63ee+kBx3ADigi6UH9ZRoRl
         BvZ7nktKnGcluqzfX48bg7dUR71tjLYJJm39wNTSLdRWefm0ffDKCOW/B+L6JqHOzn
         dSfK6Zmk3DsXCLlLnXjBtZjL2y56y30zWvcWw0UAE2P9aVgddRg3iNrDvB8mUs3dFL
         qpWV5PZdkKSGnRtv6bFZmXvG1ckMOrorvXEe6Lkdobn4tIB6q/3MzDM4IGX2DZocrn
         VgmSpTdmgkABQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2B20A60A50;
        Thu, 19 Aug 2021 12:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 1/2] net: pch_gbe: remove mii_ethtool_gset() error handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162937560617.11166.5626597500396850477.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Aug 2021 12:20:06 +0000
References: <7e8946ac52de91a963beb7fa0354a19a21c5cf73.1629298981.git.paskripkin@gmail.com>
In-Reply-To: <7e8946ac52de91a963beb7fa0354a19a21c5cf73.1629298981.git.paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        andriy.shevchenko@linux.intel.com, christophe.jaillet@wanadoo.fr,
        kaixuxia@tencent.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Aug 2021 18:06:30 +0300 you wrote:
> mii_ethtool_gset() does not return any errors, so error handling can be
> omitted to make code more simple.
> 
> Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> [...]

Here is the summary with links:
  - [v3,1/2] net: pch_gbe: remove mii_ethtool_gset() error handling
    https://git.kernel.org/netdev/net-next/c/9fcfd0888cb7
  - [v3,2/2] net: mii: make mii_ethtool_gset() return void
    https://git.kernel.org/netdev/net-next/c/2274af1d60fe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



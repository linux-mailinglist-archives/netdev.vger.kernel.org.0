Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC9F2B9899
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbgKSQuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728529AbgKSQuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 11:50:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605804605;
        bh=gLrB+EApF6/NHcH1SALAYrPnsOoW5qu4Wt6NVNaE7Ew=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NkaUs70I3dHY+fs21zRYlPvjPDtGF3EeWBfPvTe8bSqM0svggHbZlLXCUgXEqfhXs
         7JjuLkQraNvedI0Fd04Jy5iHW8QpPoKrq1XwWxOECgWX0pdWeDm8kL4ib4HJcKES2I
         EmaO/8cjgx5drRk05sTLglus+BLTJJb+hdcW32mM=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] r8153_ecm: avoid to be prior to r8152 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160580460494.7502.504079918376376238.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Nov 2020 16:50:04 +0000
References: <1394712342-15778-394-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-394-Taiwan-albertk@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        m.szyprowski@samsung.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Nov 2020 14:43:58 +0800 you wrote:
> Avoid r8153_ecm is compiled as built-in, if r8152 driver is compiled
> as modules. Otherwise, the r8153_ecm would be used, even though the
> device is supported by r8152 driver.
> 
> Fixes: c1aedf015ebd ("net/usb/r8153_ecm: support ECM mode for RTL8153")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] r8153_ecm: avoid to be prior to r8152 driver
    https://git.kernel.org/netdev/net-next/c/657bc1d10bfc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



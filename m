Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71628456E99
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 13:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhKSMDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 07:03:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234589AbhKSMDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 07:03:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8CD8461A56;
        Fri, 19 Nov 2021 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637323211;
        bh=xUEr/+Q218WuJIA1paZay+pHPkm4uvPc5+JlRW6/Z/s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PVTOy6m40J6InIr7tWch6v+Ul6sQhVFGTSuD7vu1Acqw0EWt5wsOjEHO1j8oRCvZW
         84GDwCf2si+kiAeiy63uSkXmJ5sgZwqZ4ZdUDy9buMK4hhv7ynTNjvpER/V19bwaSo
         dhpur4UG+Ac8dMlOWOihAtRVKdLzkZCboHKy5B1LnQLVPWZlBCeKOb/k7WuJ0sjKyL
         46mLiafev8YccHBLAlLyJcM855++3fYcgWPfiwupyEBIB8x6O3zzYEF+w3R3wDnfxS
         oxS8Y75vzoHQ2crDZhFMb4xK1hOs1zupTqFqfgEsUGcNslZICVcBNglT6Q8smHVYXO
         HvpiPKQhLSxhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 816C56096E;
        Fri, 19 Nov 2021 12:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atlantic: fix double-free in aq_ring_tx_clean
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732321152.14736.8904248120705237232.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 12:00:11 +0000
References: <YZbAsgT17yxu4Otk@a-10-27-17-117.dynapool.vpn.nyu.edu>
In-Reply-To: <YZbAsgT17yxu4Otk@a-10-27-17-117.dynapool.vpn.nyu.edu>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        brendandg@nyu.edu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 16:08:02 -0500 you wrote:
> We found this bug while fuzzing the device driver. Using and freeing
> the dangling pointer buff->skb would cause use-after-free and
> double-free.
> 
> This bug is triggerable with compromised/malfunctioning devices. We
> found the bug with QEMU emulation and tested the patch by emulation.
> We did NOT test on a real device.
> 
> [...]

Here is the summary with links:
  - atlantic: fix double-free in aq_ring_tx_clean
    https://git.kernel.org/netdev/net/c/6a405f6c372d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280A13D4CAE
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 10:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhGYHto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 03:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230256AbhGYHtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 03:49:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 41C0660F23;
        Sun, 25 Jul 2021 08:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627201805;
        bh=QLqGwEAr4CIfbDdOkedeMBDEei5Mv61JKzvIU/oyQI8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oO3l1l7/jnWN4JC0mi1Ob6quN2BASxoK/0f36YWYZAsVfaWkS8pFN9Bv/7nrhDbJD
         5t+si9ADaSQ16fjQ4LsaqGl8pbzFhJZshrUE4MtOa/TgPkzsy2OAW8DGk6p7ZyEEoH
         U4+A4z6zx7wERIB2EetvATde+3Y9BLa+TkQ6IhWnCDqtBguu3MmiB8dieeJQolRXJp
         mJwsZxZ71o1Xa6KEeIhwioDwVkD0BqxEU3UF2cdmSszzdwgCkguqXXm21OvlnW+Rcs
         bhLBU3PzZmvNgkon0MQkM9aRTGQ8Om2mw67OER/xxs3V39apRaaKCmjG/oHdG5ujxg
         g6BxVFO6B/Yng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 368B060A3A;
        Sun, 25 Jul 2021 08:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] octeontx2-pf: Fix interface down flag on error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162720180521.26018.4602291131095083214.git-patchwork-notify@kernel.org>
Date:   Sun, 25 Jul 2021 08:30:05 +0000
References: <20210725075903.6426-1-gakula@marvell.com>
In-Reply-To: <20210725075903.6426-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lcherian@marvell.com, tduszynski@marvell.com, kuba@kernel.org,
        davem@davemloft.net, hkelam@marvell.com, sbhatta@marvell.com,
        sgoutham@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 25 Jul 2021 13:29:03 +0530 you wrote:
> In the existing code while changing the number of TX/RX
> queues using ethtool the PF/VF interface resources are
> freed and reallocated (otx2_stop and otx2_open is called)
> if the device is in running state. If any resource allocation
> fails in otx2_open, driver free already allocated resources
> and return. But again, when the number of queues changes
> as the device state still running oxt2_stop is called.
> In which we try to free already freed resources leading
> to driver crash.
> This patch fixes the issue by setting the INTF_DOWN flag on
> error and free the resources in otx2_stop only if the flag is
> not set.
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-pf: Fix interface down flag on error
    https://git.kernel.org/netdev/net/c/69f0aeb13bb5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



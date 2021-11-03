Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBDD444395
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhKCOcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231572AbhKCOco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 10:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B3637610EA;
        Wed,  3 Nov 2021 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635949807;
        bh=U6oZiDXnzpVV8shO8jA0CWDHcZZgaJaPrcU8jO43zyQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qXOMXMsoqUbJ+77sutkKcd4zs6swPH8djcS5qFS//RbqQpucsHqSPmzEFUoXO59kN
         KuuAUbEvQIzEIw1IFZVDJAdH8kq/Cn909Y4S94TCbJOG0SB7uKwhLE9uHPZQdaP8eW
         VLCMVMgws2/ijOrWmX1IT6t32jP5tMY9hDh492t1ZykbGTNsLF1u/UdtzFlxCid93v
         83amvBwsUyvkoOzKT5xNSZSl5jJ+M1vDmcNUyoRVXSFOkxKB907eq5g/oyQI9REFGm
         ciYZwOZK8jcNshH/s2neZVnxiloD9dFjnJrmymtHFzWaJZ29zP8uZ7rnmNRxKvpWE9
         yAGpVR2hF5VnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A872160A2E;
        Wed,  3 Nov 2021 14:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] net: dsa: qca8k: make sure PAD0 MAC06 exchange is
 disabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163594980768.8310.7991708894405990412.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 14:30:07 +0000
References: <20211102183041.27429-1-ansuelsmth@gmail.com>
In-Reply-To: <20211102183041.27429-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  2 Nov 2021 19:30:41 +0100 you wrote:
> Some device set MAC06 exchange in the bootloader. This cause some
> problem as we don't support this strange mode and we just set the port6
> as the primary CPU port. With MAC06 exchange, PAD0 reg configure port6
> instead of port0. Add an extra check and explicitly disable MAC06 exchange
> to correctly configure the port PAD config.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Fixes: 3fcf734aa482 ("net: dsa: qca8k: add support for cpu port 6")
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: qca8k: make sure PAD0 MAC06 exchange is disabled
    https://git.kernel.org/netdev/net/c/5f15d392dcb4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



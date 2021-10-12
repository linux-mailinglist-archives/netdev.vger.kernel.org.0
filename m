Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C754542A270
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbhJLKmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235881AbhJLKmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 06:42:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 90C9E61050;
        Tue, 12 Oct 2021 10:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634035207;
        bh=nnjTj0Y9hAswpZ09sM7G6s00RB7D+qpeMVe4h5mKLoE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mKCd3ByfYUSpIOPEPwJzkPMQyyY7q1Gc1Su5O7OENDmgvDxBjo6whiGDM361q8m34
         7RoLeVMRqyYlhPv7N5b+yC0awWVioZ2p2eQ1wsKZmFax6xKYOawu6uE2LdhQCVRrsM
         ejv3+xqdLRS+0LzS9AlLAx9+0pdRSfNtx2CrklMIFUKJrbRkqChBeS8AwqjipNGojU
         AIOxfberTUbez2bTRAUrUtOAa4LVDg8HrnVs+xnig3VcH8nS43MdM7taAwH+6+WkcC
         L0nr7/8ljjFRtOltwF3ivGFSgMHWMxGSC8R5+ypBjV/pAd4G+8l2potQNFWdeXR444
         l7PiLdwpuqd/w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 760E2609EF;
        Tue, 12 Oct 2021 10:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: dsa: microchip: Added the condition for
 scheduling ksz_mib_read_work
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163403520747.25122.15656227462874718417.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Oct 2021 10:40:07 +0000
References: <20211011154808.25820-1-arun.ramadoss@microchip.com>
In-Reply-To: <20211011154808.25820-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        george.mccollister@gmail.com, kuba@kernel.org, davem@davemloft.net,
        olteanv@gmail.com, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        andrew@lunn.ch, UNGLinuxDriver@microchip.com,
        woojung.huh@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 11 Oct 2021 21:18:08 +0530 you wrote:
> When the ksz module is installed and removed using rmmod, kernel crashes
> with null pointer dereferrence error. During rmmod, ksz_switch_remove
> function tries to cancel the mib_read_workqueue using
> cancel_delayed_work_sync routine and unregister switch from dsa.
> 
> During dsa_unregister_switch it calls ksz_mac_link_down, which in turn
> reschedules the workqueue since mib_interval is non-zero.
> Due to which queue executed after mib_interval and it tries to access
> dp->slave. But the slave is unregistered in the ksz_switch_remove
> function. Hence kernel crashes.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: dsa: microchip: Added the condition for scheduling ksz_mib_read_work
    https://git.kernel.org/netdev/net/c/ef1100ef20f2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDD6427950
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 13:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244679AbhJILCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 07:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230064AbhJILCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 07:02:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2795460F6C;
        Sat,  9 Oct 2021 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633777207;
        bh=+Etb21InFZEAu15VDLdt2jVCRMkyNVzKxg0mTjHbRK0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZNJhShqP2HNgo2TT1IG6H4LPn9RI0m8QrR4eqLcbJhpbi3Oqrz/fXlgyS8XszUKZI
         7+3pBqCvKKuU5mtLwbLCimX4t3t4InFTB456GryeP/L/C7mh4W8BBRyG9xDernW5YB
         GLeBwHPBzPU/Pp3CpOvHBkeR4Wm2Xiu04XviQQuf69LtGw/ZUUUYgJ0pfm/+zl9cij
         JM9CXEvRjt1CdCQI4KsJf/Whd/uWRdYnxB1LG1rdrOnPsaoTvOJUBW2N7gp/2mts2+
         wqbv36I9jRudpzt/5JSyBcgPfkWhvD9NIv9Y/4u2ykccCk7c+6B04v5/fj9QJdUUsw
         jL/j8wSs9AVYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1BE2960A53;
        Sat,  9 Oct 2021 11:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ionic: don't remove netdev->dev_addr when syncing uc list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163377720710.21740.792976688488580553.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 11:00:07 +0000
References: <20211008193801.41297-1-snelson@pensando.io>
In-Reply-To: <20211008193801.41297-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, jtoppins@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Oct 2021 12:38:01 -0700 you wrote:
> Bridging, and possibly other upper stack gizmos, adds the
> lower device's netdev->dev_addr to its own uc list, and
> then requests it be deleted when the upper bridge device is
> removed.  This delete request also happens with the bridging
> vlan_filtering is enabled and then disabled.
> 
> Bonding has a similar behavior with the uc list, but since it
> also uses set_mac to manage netdev->dev_addr, it doesn't have
> the same the failure case.
> 
> [...]

Here is the summary with links:
  - [net] ionic: don't remove netdev->dev_addr when syncing uc list
    https://git.kernel.org/netdev/net/c/5c976a56570f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



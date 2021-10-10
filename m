Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F5D42804B
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 11:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhJJJwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 05:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhJJJwG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 05:52:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DC22161074;
        Sun, 10 Oct 2021 09:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633859407;
        bh=q5GFnf87S7C/kVlvMDp+qW8mSpz28oZLUpN2AuDhVT8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C5USJ0S97VewuX0O55Z4O7I8qx1rgpc4XkOL7bXx5k44HzvSgUEJiZPUUQIqpcZBd
         eTudkROePHDWMO1EmkiUiBZ7Mr+me43W9M5H5R0wmBk1kHCZ25Q31/Wwi02OxnpNUu
         Gu81u8txG/usPc4Q3NGhaW14HHjMIfSAb68XD64qRAEXFGAhFecuMG2rpyk2v9Iz2B
         BTl/PghtfP+HABTpDRz7baG/p7BKkpz8aS1WoFEGT5krP78gA/7Gso6fcNjqoIvGpC
         /6DIecOMr7tCeamRn/q3eMgYLQJKIPLb5C/m0ncQs0PvIjN7PXVOjwEM93OzF2/RxP
         Jd9AfBztCfthw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C800760A39;
        Sun, 10 Oct 2021 09:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] ionic: add vlanid overflow management
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163385940781.1668.9728002117145800347.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Oct 2021 09:50:07 +0000
References: <20211009184523.73154-1-snelson@pensando.io>
In-Reply-To: <20211009184523.73154-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, jtoppins@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  9 Oct 2021 11:45:14 -0700 you wrote:
> Add vlans to the existing rx_filter_sync mechanics currently
> used for managing mac filters.
> 
> Older versions of our firmware had no enforced limits on the
> number of vlans that the driver could request, but requesting
> large numbers of vlans caused issues in FW memory management,
> so an arbitrary limit was added in the FW.  The FW now
> returns -ENOSPC when it hits that limit, which the driver
> needs to handle.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] ionic: add filterlist to debugfs
    https://git.kernel.org/netdev/net-next/c/c1634b118e84
  - [net-next,2/9] ionic: move lif mac address functions
    https://git.kernel.org/netdev/net-next/c/1d4ddc4a5370
  - [net-next,3/9] ionic: remove mac overflow flags
    https://git.kernel.org/netdev/net-next/c/4ed642cc6538
  - [net-next,4/9] ionic: add generic filter search
    https://git.kernel.org/netdev/net-next/c/ff542fbe5d55
  - [net-next,5/9] ionic: generic filter add
    https://git.kernel.org/netdev/net-next/c/eba688b15d34
  - [net-next,6/9] ionic: generic filter delete
    https://git.kernel.org/netdev/net-next/c/c2b63d3449d3
  - [net-next,7/9] ionic: handle vlan id overflow
    https://git.kernel.org/netdev/net-next/c/9b0b6ba6226e
  - [net-next,8/9] ionic: allow adminq requests to override default error message
    https://git.kernel.org/netdev/net-next/c/8c9d956ab6fb
  - [net-next,9/9] ionic: tame the filter no space message
    https://git.kernel.org/netdev/net-next/c/f91958cc9622

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



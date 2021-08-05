Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E8E3E12CE
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 12:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240339AbhHEKkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 06:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232619AbhHEKkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 06:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B3F286105A;
        Thu,  5 Aug 2021 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628160006;
        bh=LhqQugWyEtFPfVHlTMB1zuu+3ElXURLnc+tNxE3iQ/A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Iim5TFr8cWPPMlSz5AwA2Uoom71hsnhD71qMwfHYxuA22agOtuaCBNN0bC63ncxEf
         UA5Nat1hsV7llk0Q9G5KuVPJpGW8lBx7uUE8EtRrqwDUZS4EgGMqAP+IyyDi3dna3h
         RbDuIkSf9T4kJQKnbdN7cPQxOb/K7RbxPPHKUqpRpn8WatkSwcN5V5blsthL1J2vqd
         n9t5uHQz79Flu1vUvCFBAaD8ZdafELUcgARSpUz75c9GFHD+dOVCTQTn8PDE0k985N
         ymmxRtT8GqwQkMz3Kda8fHY7GTwhSUNS3wc7EpkEMCzlvcD5mtK00mvuLDHiNmgQGV
         xXnGJPyIscLqQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A34C160A72;
        Thu,  5 Aug 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: bridge: fix recent ioctl changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162816000666.17050.13699886393043128255.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 10:40:06 +0000
References: <20210805082903.711396-1-razor@blackwall.org>
In-Reply-To: <20210805082903.711396-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, arnd@arndb.de,
        bridge@lists.linux-foundation.org, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  5 Aug 2021 11:29:00 +0300 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> These are three fixes for the recent bridge removal of ndo_do_ioctl
> done by commit ad2f99aedf8f ("net: bridge: move bridge ioctls out of
> .ndo_do_ioctl"). Patch 01 fixes a deadlock of the new bridge ioctl
> hook lock and rtnl by taking a netdev reference and always taking the
> bridge ioctl lock first then rtnl from within the bridge hook.
> Patch 02 fixes old_deviceless() bridge calls device name argument, and
> patch 03 checks in dev_ifsioc()'s SIOCBRADD/DELIF cases if the netdevice is
> actually a bridge before interpreting its private ptr as net_bridge.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: bridge: fix ioctl locking
    https://git.kernel.org/netdev/net-next/c/893b19587534
  - [net-next,2/3] net: bridge: fix ioctl old_deviceless bridge argument
    https://git.kernel.org/netdev/net-next/c/cbd7ad29a507
  - [net-next,3/3] net: core: don't call SIOCBRADD/DELIF for non-bridge devices
    https://git.kernel.org/netdev/net-next/c/9384eacd80f3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



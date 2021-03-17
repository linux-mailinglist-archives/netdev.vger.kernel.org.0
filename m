Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B40E33F874
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhCQSu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233028AbhCQSuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 14:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B30564F51;
        Wed, 17 Mar 2021 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616007009;
        bh=16bY4Q9L91OTPdgdNxgxLVnLRs6fDvle7jzwH1pV4Tk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KUiPkmTO49BfebMM4e2Q4/RPZBF/y+p7v0HPEVf9OizLrHrow208m941u3hzr8OkM
         yWWvL1nJyytqNMfTUonN2V4hbdiJmLtGwiEeJQfeuC7ew3ddydyJe7IgL6KUJHTgni
         oT2xijLszEeuDiD0WAg8bMfKdijPZ7fItSGU/2SYxb8wg2FHQK8H0ZHpe8NjRQEv+l
         vMw/EZdPYyIekCsHyXwy7J1a8qryKGwNdyAO0wTva6ol8Pv2p3Gf/graBXLZmikIoQ
         MfUhKHdr5Jh7aiFeYhdGVTmmZpjIvwt5XBIXXGS9ggfpuMzftOoX08cRbe8O3ALX+K
         TYUEQcaz2+zFg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7397B60A60;
        Wed, 17 Mar 2021 18:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2 00/10] ethtool: Factor out common code related to
 writing ethtool strings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161600700946.1265.8041343414246655720.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 18:50:09 +0000
References: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
In-Reply-To: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, simon.horman@netronome.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, drivers@pensando.io,
        snelson@pensando.io, netanel@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, mst@redhat.com,
        jasowang@redhat.com, pv-drivers@vmware.com, doshir@vmware.com,
        alexanderduyck@fb.com, Kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Mar 2021 17:30:26 -0700 you wrote:
> This patch set is meant to be a cleanup and refactoring of common code bits
> from several drivers. Specificlly a number of drivers engage in a pattern
> where they will use some variant on an sprintf or memcpy to write a string
> into the ethtool string array and then they will increment their pointer by
> ETH_GSTRING_LEN.
> 
> Instead of having each driver implement this independently I am refactoring
> the code so that we have one central function, ethtool_sprintf that does
> all this and takes a double pointer to access the data, a formatted string
> to print, and the variable arguments that are associated with the string.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/10] ethtool: Add common function for filling out strings
    https://git.kernel.org/netdev/net-next/c/7888fe53b706
  - [net-next,v2,02/10] intel: Update drivers to use ethtool_sprintf
    https://git.kernel.org/netdev/net-next/c/c8d4725e985d
  - [net-next,v2,03/10] nfp: Replace nfp_pr_et with ethtool_sprintf
    https://git.kernel.org/netdev/net-next/c/6a143a7cf947
  - [net-next,v2,04/10] hisilicon: Update drivers to use ethtool_sprintf
    https://git.kernel.org/netdev/net-next/c/83cd23974a73
  - [net-next,v2,05/10] ena: Update driver to use ethtool_sprintf
    https://git.kernel.org/netdev/net-next/c/efbbe4fb5976
  - [net-next,v2,06/10] netvsc: Update driver to use ethtool_sprintf
    https://git.kernel.org/netdev/net-next/c/3ae0ed376d1c
  - [net-next,v2,07/10] virtio_net: Update driver to use ethtool_sprintf
    https://git.kernel.org/netdev/net-next/c/d7a9a01b4e21
  - [net-next,v2,08/10] vmxnet3: Update driver to use ethtool_sprintf
    https://git.kernel.org/netdev/net-next/c/3b78b3067f38
  - [net-next,v2,09/10] bna: Update driver to use ethtool_sprintf
    https://git.kernel.org/netdev/net-next/c/b82e8118c540
  - [net-next,v2,10/10] ionic: Update driver to use ethtool_sprintf
    https://git.kernel.org/netdev/net-next/c/acebe5b6107c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



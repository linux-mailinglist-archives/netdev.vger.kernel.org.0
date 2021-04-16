Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF973616B8
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 02:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhDPAUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 20:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234716AbhDPAUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 20:20:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4DABC6113D;
        Fri, 16 Apr 2021 00:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618532411;
        bh=EPyMRknMUNWx0XdiPVobhubnXACJ7b53SROEK+pOk5k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gFAQ3mgZ9vYpBYMbFzke7GxYCzWvjnwlXUFChT6Ip0XT35Mb3FY8VWftDvWdcqei9
         oUv/xdpZgzDysx6AQXfBmkbHWzwHGysNWFgITkKutXcokVJPpqXWECjeF7IvM/PmvE
         EjIk3we4xBkx6jv/N2aWHzBiir6IywqIWOSg71Fsn21qu1BTJlSTx1KmAfSZ4Bpyx+
         ck/Ag6jM95VHpQChU4sPUStyuSKqSrqw8M26ZP4Jam9QHbpGd7sMUT0OAMZ+X4cq6Y
         zetS2CUg9owhIv0gX/HbJCAsN/i+ZIhRtSalWhdxsbZQ40jS6olU3dKVbNdBU87FoT
         2P/J+d7p2m7HA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3A36A60CD1;
        Fri, 16 Apr 2021 00:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/6] ethtool: add standard FEC statistics
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161853241123.11262.11625557345112834747.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 00:20:11 +0000
References: <20210415225318.2726095-1-kuba@kernel.org>
In-Reply-To: <20210415225318.2726095-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, saeedm@nvidia.com, leon@kernel.org,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, mkubecek@suse.cz,
        ariela@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 15 Apr 2021 15:53:12 -0700 you wrote:
> This set adds uAPI for reporting standard FEC statistics, and
> implements it in a handful of drivers.
> 
> The statistics are taken from the IEEE standard, with one
> extra seemingly popular but not standard statistics added.
> 
> The implementation is similar to that of the pause frame
> statistics, user requests the stats by setting a bit
> (ETHTOOL_FLAG_STATS) in the common ethtool header of
> ETHTOOL_MSG_FEC_GET.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/6] ethtool: move ethtool_stats_init
    https://git.kernel.org/netdev/net-next/c/c5797f8a6415
  - [net-next,v2,2/6] ethtool: fec_prepare_data() - jump to error handling
    https://git.kernel.org/netdev/net-next/c/3d7cc109ecf7
  - [net-next,v2,3/6] ethtool: add FEC statistics
    https://git.kernel.org/netdev/net-next/c/be85dbfeb37c
  - [net-next,v2,4/6] bnxt: implement ethtool::get_fec_stats
    https://git.kernel.org/netdev/net-next/c/c9ca5c3aabaf
  - [net-next,v2,5/6] sfc: ef10: implement ethtool::get_fec_stats
    https://git.kernel.org/netdev/net-next/c/cab351be53c2
  - [net-next,v2,6/6] mlx5: implement ethtool::get_fec_stats
    https://git.kernel.org/netdev/net-next/c/1703bb50df0e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



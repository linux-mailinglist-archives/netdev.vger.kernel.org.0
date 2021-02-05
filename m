Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E07310446
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 06:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhBEFBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 00:01:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229720AbhBEFAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 00:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D6B2B64F9C;
        Fri,  5 Feb 2021 05:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612501207;
        bh=ANRXaJiGNzWVr3mfR9VypXiYgLGkuFRRJgyf3MDSJzk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dBa/cEE+TB+HadwkfkFJittt9+BTb8UQC6oUDkirDV3JLGmUmmiyjTSd6B/3rupRN
         5g53wn/CBcWx1hzg4lJXVghYdXpsVSj2rTD+R/BVrZYg2Y1+Wt0MmMyXs0WZYDKcTN
         Pnc1sVOIOuPxqnidg/JVvQ+kplpTgaa0VerYZzx+bokGzNhAdHRUgQHFSNF6M9xOTX
         Z/Z37kbuRjz9HhBMyK3ygU7MqRInhQsc1wqtcsxoIeDTF58tbIUa8AHH2n6e5bafr+
         GTCXy8OwKEIk88v6Ez6N5dGcrWZtXlk0V65CZIFD+BtmSCtn41U/JeW92YvQffT7DR
         6xZnwRk4xdpAA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BE6FE609F3;
        Fri,  5 Feb 2021 05:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Amend "hv_netvsc: Copy packets sent by Hyper-V
 out of the receive buffer"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161250120777.4551.1394354555198718660.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 05:00:07 +0000
References: <20210203113513.558864-1-parri.andrea@gmail.com>
In-Reply-To: <20210203113513.558864-1-parri.andrea@gmail.com>
To:     Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        mikelley@microsoft.com, linux-hyperv@vger.kernel.org,
        skarade@microsoft.com, juvazq@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  3 Feb 2021 12:35:11 +0100 you wrote:
> Patch #2 also addresses the Smatch complaint reported here:
> 
>    https://lkml.kernel.org/r/YBp2oVIdMe+G%2FliJ@mwanda/
> 
> Thanks,
>   Andrea
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] hv_netvsc: Allocate the recv_buf buffers after NVSP_MSG1_TYPE_SEND_RECV_BUF
    https://git.kernel.org/netdev/net-next/c/0102eeedb717
  - [net-next,2/2] hv_netvsc: Load and store the proper (NBL_HASH_INFO) per-packet info
    https://git.kernel.org/netdev/net-next/c/8dff9808e973

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



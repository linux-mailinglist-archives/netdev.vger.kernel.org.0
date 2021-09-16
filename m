Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A5940DB03
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240010AbhIPNV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhIPNV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 09:21:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CFEAD61212;
        Thu, 16 Sep 2021 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631798406;
        bh=cI/awQV9ZjwOhKVj1gpmmg3Qnl53AD8iX1idFJzA4Yg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W9m7NjXXEEPOvdfwXRIpLKTXFYIW/NLUqfvcVB8HuPk/idkgwVPKn9F9J4GclW72J
         pOnrtuqqa9sekB6U8xKEXlH7TinCM0HgQzR4W/mYcXd8BW3AW6zoTDaHWli2lls9hU
         PPUazREbDrQEUAMVniFIR8/NffKVYWYWzGUqoST14Xo8bFI7boi+y34eoDgNkM4kjA
         fPUumXXVik0CQ1vaXMM4gfgSD71ODSNWm7ujLjv5AhiBRwYbEV2dO3C29sZ7j/2wLq
         wkPZcpn61HVGMfsOOE4nCCqAtOmVK9T+8jmtSFLkMJYqBwyhO01Ga9VLj9EeaM32Zf
         REmE+9+Gm0yyA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C2BF460A9E;
        Thu, 16 Sep 2021 13:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/{mlx5|nfp|bnxt}: Remove unnecessary RTNL lock assert
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179840679.7555.9271360167851764548.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 13:20:06 +0000
References: <20210915044727.266009-1-elic@nvidia.com>
In-Reply-To: <20210915044727.266009-1-elic@nvidia.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     kuba@kernel.org, sriharsha.basavapatna@broadcom.com,
        ozsh@mellanox.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 15 Sep 2021 07:47:27 +0300 you wrote:
> Remove the assert from the callback priv lookup function since it does
> not require RTNL lock and is already protected by flow_indr_block_lock.
> 
> This will avoid warnings from being emitted to dmesg if the driver
> registers its callback after an ingress qdisc was created for a
> netdevice.
> 
> [...]

Here is the summary with links:
  - net/{mlx5|nfp|bnxt}: Remove unnecessary RTNL lock assert
    https://git.kernel.org/netdev/net/c/7c3a0a018e67

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



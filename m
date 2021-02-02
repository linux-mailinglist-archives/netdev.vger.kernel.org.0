Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FE130C6DF
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237098AbhBBRCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:02:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237114AbhBBRAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 12:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3E39264F7E;
        Tue,  2 Feb 2021 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612285208;
        bh=PrlgP6jamvPpgaGb0Lg9zd0Oy51mM6KYUjN/ocHpe8E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GdrZmcnmBmg7W8hhwPZ5TbPrCGnFlteMUZxfQA8q9c7mM4BeuKUflmHfgx+Mt5piM
         Xd6OPBP/6VBxHQj8GxJ4zf2FTP+pyNm+7rLPHFJlPW1mbWrP/d37YtntD8MibDVSbq
         UWs9DbOqEURrtkL7AqtlmHEEDPQWUcDNN7IZxGFafKDMoGQakp97T6cCU4aHfBn6Iw
         uf3SenWIFmxT+iTxxkLXjRN4Z2N5aZWy4hUH2aHsYpvUu8u7wHFrT06Yf5QuIQMe89
         gh6DztL1+H8KgueI8ZFD07v7tx+q7EhLin3zLNLTpPEIILW52WAyeoyLn0oRCY55Ap
         nFJMKH4bxl1Mg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2A6A8609CE;
        Tue,  2 Feb 2021 17:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/4] net/mlx5: Fix function calculation for page trees
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161228520816.27951.1106879366069546828.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 17:00:08 +0000
References: <20210202070703.617251-2-saeed@kernel.org>
In-Reply-To: <20210202070703.617251-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        danielj@nvidia.com, colin.king@canonical.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon,  1 Feb 2021 23:07:00 -0800 you wrote:
> From: Daniel Jurgens <danielj@nvidia.com>
> 
> The function calculation always results in a value of 0. This works
> generally, but when the release all pages feature is enabled it will
> result in crashes.
> 
> Fixes: 0aa128475d33 ("net/mlx5: Maintain separate page trees for ECPF and PF functions")
> Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,1/4] net/mlx5: Fix function calculation for page trees
    https://git.kernel.org/netdev/net/c/ed5e83a3c029
  - [net,2/4] net/mlx5: Fix leak upon failure of rule creation
    https://git.kernel.org/netdev/net/c/a5bfe6b4675e
  - [net,3/4] net/mlx5e: Update max_opened_tc also when channels are closed
    https://git.kernel.org/netdev/net/c/5a2ba25a55c4
  - [net,4/4] net/mlx5e: Release skb in case of failure in tc update skb
    https://git.kernel.org/netdev/net/c/a34ffec8af8f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



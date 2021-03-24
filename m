Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AC634847E
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238776AbhCXWUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232592AbhCXWUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 18:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 544A861A23;
        Wed, 24 Mar 2021 22:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616624409;
        bh=cIGv0jaKUpXCd19+16F1YDS7BVI+WQPx5ZsVIHt9GRM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R30UuTnkrryzWqmcArH6RRQp31MGym9Qee7R+xNsZumLnDQdTXwNQQG4FxOnSnXag
         DRbrZz8CirbYfGl0BNKCBC5Lzo5wN0/8Y8E5zvrth75KB+sjU8m9+4Hh3by2HLG1dN
         mMF8VcZZ2DiyuqwLgl38GykNGUlGyNYPqiOT26SXKVxfQKZTcrTIY68NVSqjVx0eN6
         hMQR5vqbacKvMRI+G2ug+XfMTNjJ3602qfF4qyIcR1s140BzA3Z+gJNF5pfuc5CK2u
         bzHfGrAkpqlYCMfhN5aBYvroTnwA53xlQO/T52PkD1U/Q6IWP+xyRDA0KSE5SaU7ao
         S/gcPySF6nzTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4807D60A3E;
        Wed, 24 Mar 2021 22:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sfc-falcon: Fix a typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161662440929.20293.11549571914947630124.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 22:20:09 +0000
References: <20210324075204.29645-1-unixbhaskar@gmail.com>
In-Reply-To: <20210324075204.29645-1-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 13:22:04 +0530 you wrote:
> s/maintaning/maintaining/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/ethernet/sfc/falcon/net_driver.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> [...]

Here is the summary with links:
  - sfc-falcon: Fix a typo
    https://git.kernel.org/netdev/net-next/c/bef32aa8e412

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



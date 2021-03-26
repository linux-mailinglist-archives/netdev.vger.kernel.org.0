Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E7A349DD4
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhCZAa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhCZAaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 906A361A02;
        Fri, 26 Mar 2021 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718610;
        bh=WeRjHN1RMhl4ReJ96PGtbxLM7HN0t4tlc4LHAeaBObY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p4hwaANBRdyRWnptAugG5GTY1AdSHJjdmibM+3v+VN6sNs6nyLfmmWS3AfUfnWLWx
         pOSfWYnX81B0T/XMEaoQQE2wtd9SGu1AhmH5fK3aHogosSB368CiZpc5Dmd3WXPg9K
         sDrEaOy8s5NHkzFu8hv+G63ytisU/dYpK9o5jAd4ie1vN15ETsLjjutib+i9hpdAO9
         B7gbBcnai5BuHtONGyiVWkX6TB8rhaO/B6CiiMGONk2CrIFpWFKE113jzljE7r2Zb0
         qaxPkcRR3z1QNAJjQMkws78D6cLovoTDqAWtlxuhLLR8/UXSZOWKGwgsJ2RGhU4QTw
         zdXBrYKXWM/PA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 81E2860C25;
        Fri, 26 Mar 2021 00:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] amd-xgbe: Update DMA coherency values
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671861052.2256.26945333361392247.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:30:10 +0000
References: <20210325030912.2541181-1-Shyam-sundar.S-k@amd.com>
In-Reply-To: <20210325030912.2541181-1-Shyam-sundar.S-k@amd.com>
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 25 Mar 2021 08:39:12 +0530 you wrote:
> Based on the IOMMU configuration, the current cache control settings can
> result in possible coherency issues. The hardware team has recommended
> new settings for the PCI device path to eliminate the issue.
> 
> Fixes: 6f595959c095 ("amd-xgbe: Adjust register settings to improve performance")
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> 
> [...]

Here is the summary with links:
  - [net] amd-xgbe: Update DMA coherency values
    https://git.kernel.org/netdev/net/c/d75135082698

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



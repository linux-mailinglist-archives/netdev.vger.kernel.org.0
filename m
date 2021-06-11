Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BED3A4A93
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 23:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhFKVWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 17:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhFKVWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 17:22:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 589DB613CA;
        Fri, 11 Jun 2021 21:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623446403;
        bh=+r89U6KGu2f7MNGrj9ySGI1AQCtIsgF9/XzU+rc3CVI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ty1hJcVzyA3nwy2eQCXTX1RuDh9jg3soKlceGRiKXe9nql+wgWGjkJlcRoZXlQr9n
         +qBw94w5tzsKVlnloXzMtIkYR8m1SLRfsQiisq3a0J2xXFRwVxftQ6CmoO04nVPqpZ
         trsHSNOud7vUX1oKPv2pK7I7WLVGXM7Jnj2rxmYWdxRVvbqQfi9JpmhwIOGewcgFPa
         v0Y7p7I91lPOUTzc4uhnC/3zBvgrNeLB78ZnMNZ0aMR4bi7QW/ERMHO7iYIfN3LCcY
         hlGoSgs9bK9T30XoRloPb2Rdp3NdG3/dD9HCiqkeCDTlLUimilsU5E4pL2t+5qPli3
         AL2BXSHZZ6QNw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4E30460A53;
        Fri, 11 Jun 2021 21:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] ibmvnic: fix kernel build warning in strncpy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344640331.8269.6819397375303273378.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 21:20:03 +0000
References: <20210611183353.91951-1-lijunp213@gmail.com>
In-Reply-To: <20210611183353.91951-1-lijunp213@gmail.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 13:33:53 -0500 you wrote:
> drivers/net/ethernet/ibm/ibmvnic.c: In function ‘handle_vpd_rsp’:
> drivers/net/ethernet/ibm/ibmvnic.c:4393:3: warning: ‘strncpy’ output truncated before terminating nul copying 3 bytes from a string of the same length [-Wstringop-truncation]
>  4393 |   strncpy((char *)adapter->fw_version, "N/A", 3 * sizeof(char));
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Lijun Pan <lijunp213@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] ibmvnic: fix kernel build warning in strncpy
    https://git.kernel.org/netdev/net-next/c/0b217d3d7462

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



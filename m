Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4580E47A8FC
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 12:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhLTLuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 06:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbhLTLuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 06:50:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C74C061574;
        Mon, 20 Dec 2021 03:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F9E660FEC;
        Mon, 20 Dec 2021 11:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C466C36AE9;
        Mon, 20 Dec 2021 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640001009;
        bh=U/yA3URX3W3zu/xsOu9eXFZOpLHEIIhfebhdPhQ0L9E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JhH+174OlVxx6pHRAEKubT8h60aZy1fHA3Zbv4pLZeNfyCAZBXAf3Y/yDnCZgNxQr
         MHzqmt9BA1BsnA5RaoEMJt6SlRFKMEFsVSXP9zf0cUw1QOqBuBEVlNx98Utr3sYhyr
         Xtzroo4A3ZDUgKJaDv9gvdKauPYKKu3AQUkgS+wvOwodwZXe5IsXu8qxf06pZqDO0+
         j7joQdjL6ozR/Q+rr39N50b3WhqqNJRoD/6L6YjH8WkT8EfL2i5a9U14KDHL61ulHQ
         Mtj7qpQC0phx2cSE8hZNlaYqj76mLUoRqPcbU9NUwZAsK0y6P8QOdBR0OS/PgPwNyU
         mK4Mlcy6VCtdw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5C8C160A6F;
        Mon, 20 Dec 2021 11:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] docs: networking: dpaa2: Fix DPNI header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164000100937.802.18160735404162601229.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Dec 2021 11:50:09 +0000
References: <20211217174231.36419-1-sean.anderson@seco.com>
In-Reply-To: <20211217174231.36419-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     corbet@lwn.net, linux-doc@vger.kernel.org, stuyoder@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        laurentiu.tudor@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Dec 2021 12:42:31 -0500 you wrote:
> The DPNI object should get its own header, like the rest of the objects.
> 
> Fixes: 60b91319a349 ("staging: fsl-mc: Convert documentation to rst format")
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
>  .../device_drivers/ethernet/freescale/dpaa2/overview.rst         | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - docs: networking: dpaa2: Fix DPNI header
    https://git.kernel.org/netdev/net/c/662f11d55ffd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



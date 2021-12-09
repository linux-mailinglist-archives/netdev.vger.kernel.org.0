Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF8146ECCE
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbhLIQNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:13:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34880 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbhLIQNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:13:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55DB7B82550;
        Thu,  9 Dec 2021 16:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06E19C341D0;
        Thu,  9 Dec 2021 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639066210;
        bh=zXPRW+vBKvZ6RvimQyuamzBt3dWqn9UHC6LIrTaukrs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XxQcIzkEADviCjv+oUBm3rcJMNLeStm0f5LC9AZxOHwQQt/d8gNOQkoZfQMEDmhOv
         FyWuXMho1L03eNNSzsZ/TuEcjlOA81tDXVKRGS69PIGum/g9xfeQlsxmGqwmZRE3nI
         K0ybR/6YS0oT2JEzWqIcMZwREmQZfMar12rFw7z9CELIbxaowCSq4JNDjbCdOQ91Hs
         8+vH8jNbUi7U/RN2HCUR6eCWm+ZLcu/hvHuqAonz4B62oPVfEyp/cTKBSte3VD1jUC
         yvgLbqufra1rKld43e5TMgwqX2maBOEUtv8jEKJK94TUMDjn7xtq5J1Va+WqeI4RiZ
         viNhcIkpTpEDw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D7EB560BE3;
        Thu,  9 Dec 2021 16:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mana: Fix memory leak in mana_hwc_create_wq
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163906620987.18129.15445565524915485016.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 16:10:09 +0000
References: <20211208223723.18520-1-jose.exposito89@gmail.com>
In-Reply-To: <20211208223723.18520-1-jose.exposito89@gmail.com>
To:     =?utf-8?b?Sm9zw6kgRXhww7NzaXRvIDxqb3NlLmV4cG9zaXRvODlAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Dec 2021 23:37:23 +0100 you wrote:
> If allocating the DMA buffer fails, mana_hwc_destroy_wq was called
> without previously storing the pointer to the queue.
> 
> In order to avoid leaking the pointer to the queue, store it as soon as
> it is allocated.
> 
> Addresses-Coverity-ID: 1484720 ("Resource leak")
> Signed-off-by: José Expósito <jose.exposito89@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: mana: Fix memory leak in mana_hwc_create_wq
    https://git.kernel.org/netdev/net/c/9acfc57fa2b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A1B48BE19
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 06:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350801AbiALFUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 00:20:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34376 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiALFUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 00:20:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B42F1B81DFE;
        Wed, 12 Jan 2022 05:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BFF9C36AEA;
        Wed, 12 Jan 2022 05:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641964810;
        bh=o2FlKU2MxkiEdyDOIdYluZ1k2IePupboyjANIrKEtks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IkzewU/syMEik9AwIjNBsv6CfGG6uLnxRyTENIfb65jtUn6qxDizT6Ub0B09TNxex
         c4c85gRS0maZZLCoXMUWFsgxxVDCthBqi5Gk9NAyU5wE9rasDbbhwuJlia4XwavCro
         dtszRD9q6dvJMbbDCeC60R3/a5qH0c9A8ftEvEmfikDsD01bdYis3MLNhMaAVDVN3D
         Ta1QfIMYnt6TjQF20zkQZfqiEPFhhTS7GTiEPm8xj0oNg4Ne9zBev+Vo7wV3at8z/1
         uTOCm59s3dGrenz3AiVcbw0fbyLP0m4fWiFwMngcnxh3zW1JkSYuj3xbKS0Gqa49VM
         e4VcVI/ttcolg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BA0AF60795;
        Wed, 12 Jan 2022 05:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: at803x: make array offsets static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164196481030.2105.16895737444875746282.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 05:20:10 +0000
References: <20220109231716.59012-1-colin.i.king@gmail.com>
In-Reply-To: <20220109231716.59012-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 23:17:16 +0000 you wrote:
> Don't populate the read-only const array offsets on the stack
> but instead make it static. Also makes the object code a little smaller.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/phy/at803x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: phy: at803x: make array offsets static
    https://git.kernel.org/netdev/net/c/edcb501e543c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



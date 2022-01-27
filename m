Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A5049E403
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241991AbiA0OA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241055AbiA0OAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:00:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56AFC061747;
        Thu, 27 Jan 2022 06:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62B9461B8D;
        Thu, 27 Jan 2022 14:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C50BAC340F0;
        Thu, 27 Jan 2022 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643292012;
        bh=DirBArJgrjkWAQ7ngqn2ezBLFz+I/u2qZpfU/RrUKzQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gaZL5jTvKrX6X+2aOXQo4/a/q8YQCBNBa/Fp6GiDlai391WuHemlcG5tjz6Sa06Of
         In8X9UcNmH3TBy/FMh5JPZ3nVjxT22OGydccZDSBueRaaBq4ot+YZX/x41NcTnROFF
         QRGq+lOBsAHi1p0OkDLsKJSJPa2/TNgXsVGLAReV37mpfxShmy3Wd2FOcgh/FG8PGD
         QttQl603JcpAQH4DQx7LGQbf3fkNc3xgo1htXCzPKZPV1BIVhTw7HpNhkjO17fw5n9
         HKvhWkVvNk3Mqq7JxltzF1Sh4J1XWFrgkGMRYi4OWQB8NoUbQaDk6CGkPe5BocblQv
         /GuNo1dZPZCFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4B18E5D087;
        Thu, 27 Jan 2022 14:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: nsp: Simplify array allocation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329201273.13469.1026660627963932938.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 14:00:12 +0000
References: <af578bd3eb471b9613bcba7f714cca7e297a4620.1643214385.git.robin.murphy@arm.com>
In-Reply-To: <af578bd3eb471b9613bcba7f714cca7e297a4620.1643214385.git.robin.murphy@arm.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 16:30:33 +0000 you wrote:
> Prefer kcalloc() to kzalloc(array_size()) for allocating an array.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] nfp: nsp: Simplify array allocation
    https://git.kernel.org/netdev/net-next/c/d9f393f468aa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAF56BC5A6
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 06:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjCPFaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 01:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCPFaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 01:30:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AA11ADD4;
        Wed, 15 Mar 2023 22:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 984BFCE1BA7;
        Thu, 16 Mar 2023 05:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C33A3C433D2;
        Thu, 16 Mar 2023 05:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678944618;
        bh=4hUdMQr026xj00aKlL6xKmoXEUt5LW0CoAdBttBl4gE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tD+tCxSYeQNwm+w9jLF687DP9EjJGJz3e/Zkj7cvWRFWDEagsnWePH01jb6zTTsi0
         yGccOtCUjbplaiRBz9xSTIfnD7A+NMuABD9B0eAEXoIOl5tqWal88bvWos5EsczHCI
         xYoiYMsnNgzlvdZiVYxm9iNrB0EnZClEWAtGjHx35NxY+b6dOhAnQsVdHJi7yUUsYr
         w/jOYHZmGgxKWi4fEt1409ks6bU7Gz6QGR4Nt0p7Cd3K36Xc5uE2admjpQkVS/cT2a
         7whQkCaEO4MZfyejrNRLOvK6J5vrVNjbMecSWnb7AmeNWGm0d2fR+0Is92VAyDAz9C
         LZ+4PoGXiBCbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AAA57C43161;
        Thu, 16 Mar 2023 05:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: phy: micrel: Fix spelling mistake "minimim" ->
 "minimum"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167894461869.21360.5260748461499126273.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 05:30:18 +0000
References: <20230314082315.26532-1-colin.i.king@gmail.com>
In-Reply-To: <20230314082315.26532-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Mar 2023 08:23:15 +0000 you wrote:
> There is a spelling mistake in a pr_warn_ratelimited message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/phy/micrel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] net: phy: micrel: Fix spelling mistake "minimim" -> "minimum"
    https://git.kernel.org/netdev/net-next/c/9bdf4489a395

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



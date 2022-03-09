Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A2B4D28FA
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 07:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiCIGbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 01:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiCIGbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 01:31:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5253414561B;
        Tue,  8 Mar 2022 22:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9D9EFCE1D7F;
        Wed,  9 Mar 2022 06:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2001C340F7;
        Wed,  9 Mar 2022 06:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646807410;
        bh=3M4MKg7rpgfaMb+u02OrdlJdFEkHXrF7Y9UAR8ezcGI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O+WJlU+Yc4ZTvxANti2QDaf46YrvLqiHlgnoG3yJ2nCnDx3FGpaoGWw3RDaLM7gII
         KCMvIdwwt34S7q9xzkgWIwDhu0lgMwN7ZmMUBZSXNpxQRUS719HGiGjCbf3km0NO+Z
         z+0M7JPJEgtKTKDF1QEdgbnoCPGUGZfns+iBNhdJq192vx5yIp+4mwYdxxbFFB2TuK
         +okHtkNRSYJjnX0uek1EPi2T2RrU0q/02ZjpxKUWLifRTENH1M3kSF8jr0JFs/kOV/
         f+8n7hxYeu2FEAk+twJMO1/iu0dg8nPvPr6aQ92MB3n/W5R5uDqFZO5Cjoc5rVDBTX
         wyZ0KMDHtpIdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C422E73C2D;
        Wed,  9 Mar 2022 06:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: prestera: acl: make read-only array client_map
 static const
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164680741063.15140.5277351972560162204.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 06:30:10 +0000
References: <20220307221349.164585-1-colin.i.king@gmail.com>
In-Reply-To: <20220307221349.164585-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     tchornyi@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  7 Mar 2022 22:13:49 +0000 you wrote:
> Don't populate the read-only array client_map  on the stack but
> instead make it static const. Also makes the object code a little
> smaller.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_acl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] net: prestera: acl: make read-only array client_map static const
    https://git.kernel.org/netdev/net-next/c/d82a6c5ef9dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



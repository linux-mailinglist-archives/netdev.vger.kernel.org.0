Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876BA56338C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 14:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235615AbiGAMkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 08:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbiGAMkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 08:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04D93B027;
        Fri,  1 Jul 2022 05:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 968F6B83016;
        Fri,  1 Jul 2022 12:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4AF28C341C8;
        Fri,  1 Jul 2022 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656679215;
        bh=uR4h2uxkUt8Jr/DeudVb5DGbs0OmHSl1xQxR8ppkTKs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VNJRoCOu0RGk5//aTqT9cCbRuejW89Xugn5Yiy3Rq36gRYkj+JUStEAongvb80kcW
         HUaumPmBwvtsH/bAiiqukH4GlQDbgwbWbP/ixJay6dhC8rm3fiQHSRaQWcCqKLDsWA
         9PjvvXodKuk9s6IVrWZU8Xi/1DgBQjTiJZmfZsiupdEXLgX5sM8FxQ7Cr/g1AGl6Ri
         Kibwd2OvKiMW/7G3NjAH1OaTqXZXRZLlOPdG7eJY/P+9lUOs+Iw6v4iwV7YWB4MNXE
         4tLZF8WyEGPFBc1TKvi8bjr55cwq7cBLp9JvszNhjMbLWD3AkJPZKl0IzOqGAtQAWD
         LMPS+d1YbTO2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2DC5FE49FA2;
        Fri,  1 Jul 2022 12:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] cxgb4: Fix typo in string
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165667921518.18764.4479752710127552065.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 12:40:15 +0000
References: <20220630124452.5018-1-kunyu@nfschina.com>
In-Reply-To: <20220630124452.5018-1-kunyu@nfschina.com>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     pabeni@redhat.com, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rajur@chelsio.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Jun 2022 20:44:52 +0800 you wrote:
> Remove the repeated ',' from string
> 
> Signed-off-by: Li kunyu <kunyu@nfschina.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [v2] cxgb4: Fix typo in string
    https://git.kernel.org/netdev/net-next/c/368843301d08

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



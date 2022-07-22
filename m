Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231C457D872
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 04:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbiGVCUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 22:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiGVCUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 22:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A49E0F4
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 19:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D266DB8270F
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79581C3411E;
        Fri, 22 Jul 2022 02:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658456413;
        bh=Y6m9Nx1jH/V8vRNhS8A3WI/yYD6gqkfOSsyeNa/TRtU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MCmQ+h5i6PV2siHhmNwQfR6NClFPlwXCYBjaU9dKZoT1E0MMvpc+Egk5E6LE8yPGX
         ezQJI/OPLkHhTmmnyPocrSeDz/mx+ih9pLus93odO7Nc3PIt6eUGVHcQY9P807JP2M
         0kGVaar+Nv+c4mUEbcbaosRyp5gGe539VbgwwmU/moTU+qD9dNC8dbjp5tU6CbDBaA
         mT9vyzFrCf08ClzBojbJH/86jiQonRYYeIr8Uhqc8pICUeWBIok+LIFGL/UhlrBnkP
         vh8QP+wDzltgDcsvVfb/fJ/2p34dxb36wsTwg/l8TWpBF43SKFlzfGAkZc5OgvosBD
         BdkWWlNy27DhQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5DE9AD9DDDD;
        Fri, 22 Jul 2022 02:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sungem_phy: Add of_node_put() for reference returned by
 of_get_parent()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165845641338.11073.3864497499292041775.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 02:20:13 +0000
References: <20220720131003.1287426-1-windhl@126.com>
In-Reply-To: <20220720131003.1287426-1-windhl@126.com>
To:     Liang He <windhl@126.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 Jul 2022 21:10:03 +0800 you wrote:
> In bcm5421_init(), we should call of_node_put() for the reference
> returned by of_get_parent() which has increased the refcount.
> 
> Fixes: 3c326fe9cb7a ("[PATCH] ppc64: Add new PHY to sungem")
> Signed-off-by: Liang He <windhl@126.com>
> ---
>  drivers/net/sungem_phy.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - net: sungem_phy: Add of_node_put() for reference returned by of_get_parent()
    https://git.kernel.org/netdev/net/c/ebbbe23fdf60

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



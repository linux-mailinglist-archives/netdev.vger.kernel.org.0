Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E298A5710BD
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 05:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiGLDUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 23:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiGLDUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 23:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BFC2E9D6;
        Mon, 11 Jul 2022 20:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB5FB6171C;
        Tue, 12 Jul 2022 03:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27C1CC341CA;
        Tue, 12 Jul 2022 03:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657596013;
        bh=GPm72V6I7awW7B2AYyGa6anWvvTOoOi8OXUNV5KFBuY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a+8L/36ACBFrvFMz0WVrEEWwZTvd/Z5akpYpd8sN8UCjEJ/mURMZvYKZLvi3a6PqZ
         B8fqMcE5ObVDK3vDDY2T0J0tKDlIO3NoAF3wqFavUs2mgnWD/FK0a2BOFyX22HvqxE
         n+uL8G2rga3pkYw3s7bLDJQiEP7Bd8zi33HN6oCb7wUQtXsWXIvL2KZ88CSZjFxfRe
         Kq3kUXKkGBKiaa0Uj4cTqjNWslCinbEVuW9+GC1427yvSRKRXURxlWmlDEEGTeXn/e
         t3mnk3miWS48ba7ndIqGAuqe7CF4pfXeXi6INiAUNGtcIKgx12jMWGJwQTAv7CsG5l
         l3ThhVCF82AOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05498E45225;
        Tue, 12 Jul 2022 03:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftest: net: add tun to .gitignore
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165759601301.2891.13976917278104910424.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jul 2022 03:20:13 +0000
References: <20220709024141.321683-1-kuba@kernel.org>
In-Reply-To: <20220709024141.321683-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  8 Jul 2022 19:41:41 -0700 you wrote:
> Add missing .gitignore entry.
> 
> Fixes: 839b92fede7b ("selftest: tun: add test for NAPI dismantle")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  tools/testing/selftests/net/.gitignore | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] selftest: net: add tun to .gitignore
    https://git.kernel.org/netdev/net/c/4a46de446d3f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



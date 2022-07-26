Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C12581174
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 12:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbiGZKud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 06:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238514AbiGZKud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 06:50:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F1126AC6;
        Tue, 26 Jul 2022 03:50:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 108CD60A1E;
        Tue, 26 Jul 2022 10:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F425C341D3;
        Tue, 26 Jul 2022 10:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658832631;
        bh=iNQPs9lywNhZ9XA7jS1Yx1xlQE8rNWfvws3BjZAtemY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S+2dCsJ5ERIYLt5tjTgP7ywQBkPJryeDqTu2KRT9ehIw8Q/uFPsBDDtTOF4Sj/4WK
         hkzEBn9QNgfi/lDRykqcaRw6DgR2R0ETRLdo31XTxYCz+C2eZgpOMDMnaTjvJglRZR
         XX4RNkdlXk7ke5CQWX6McJmahxhK892Wd0idiBHsal5hEEcGkAhbBSDdNZvv3ZOzcQ
         GLQ9HAKlKxCUIiv5mr8uugtFXhDodJ4HEjN6Eh2jHURvlZrh71PCwyVNAwYHjIPHmV
         OdsHCB/KE8+TXkC1GKp51V3WS5LusbPbu90EazEIoyXHk2ICikFKOJXN8p5/GVMlBz
         8KlEEx/by6mfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 497BAE450B7;
        Tue, 26 Jul 2022 10:50:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sfc/siena: fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165883263129.5700.4134100572559798852.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jul 2022 10:50:31 +0000
References: <20220724075207.21080-1-wangjianli@cdjrlc.com>
In-Reply-To: <20220724075207.21080-1-wangjianli@cdjrlc.com>
To:     wangjianli <wangjianli@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 24 Jul 2022 15:52:07 +0800 you wrote:
> Delete the redundant word 'in'.
> 
> Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
> ---
>  drivers/net/ethernet/sfc/siena/net_driver.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - sfc/siena: fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/58d8bcd47ecc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



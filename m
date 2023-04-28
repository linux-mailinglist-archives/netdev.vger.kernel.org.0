Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0456F135E
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjD1IkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjD1IkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC18C2717;
        Fri, 28 Apr 2023 01:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47F00641EE;
        Fri, 28 Apr 2023 08:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A753BC4339B;
        Fri, 28 Apr 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682671219;
        bh=hzbuxjl8laM60byWXm/NuRNenKvCk0gQ+Oy81tcIESE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FGLYqCuHapTY9XsVInCh5I/0cxBGQj7EAU5VT9HYsVmY94HTVU85/7KQ81diztk3g
         edsK8OioTQ+gVM2lEiA+0p/2vC270qVIdTi1jeaV+JhElI7R/ZOeUw8eyOGQvguAWd
         4WRLWX4ehr2h2JcGcQNAT4okSz0i7L2T6b4kUp4PlWJa5JKm9Kcag4TcQGBebUNAES
         diC3wgByxNGBWZfDED+CyieZUjIG4jENJGWUcWzMjPxULXlj/4/f+1jl1RKonsIhmu
         SIHz2KO/XjHpWYSjI1ggZytmPpEbrPKDn2OO5JhH1sgpKxDFKP6aKOpYqRQFWSIBPo
         m0lFBzyurfSTw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B842E5FFC5;
        Fri, 28 Apr 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/ncsi: clear Tx enable mode when handling a Config
 required AEN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168267121956.29185.4280925593881439460.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Apr 2023 08:40:19 +0000
References: <20230426081350.1214512-1-chou.cosmo@gmail.com>
In-Reply-To: <20230426081350.1214512-1-chou.cosmo@gmail.com>
To:     Cosmo Chou <chou.cosmo@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sam@mendozajonas.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cosmo.chou@quantatw.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Apr 2023 16:13:50 +0800 you wrote:
> ncsi_channel_is_tx() determines whether a given channel should be
> used for Tx or not. However, when reconfiguring the channel by
> handling a Configuration Required AEN, there is a misjudgment that
> the channel Tx has already been enabled, which results in the Enable
> Channel Network Tx command not being sent.
> 
> Clear the channel Tx enable flag before reconfiguring the channel to
> avoid the misjudgment.
> 
> [...]

Here is the summary with links:
  - [v2] net/ncsi: clear Tx enable mode when handling a Config required AEN
    https://git.kernel.org/netdev/net/c/6f75cd166a5a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



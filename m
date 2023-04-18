Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12C96E5F0B
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 12:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjDRKkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 06:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjDRKkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 06:40:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A223183FE
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 03:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D60562481
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 10:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90A4AC4339B;
        Tue, 18 Apr 2023 10:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681814419;
        bh=mp1jUM7FA9Ce+ogbJUnDvozLoq+DflTxljcFKstGllA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E4AENG7s2VjlRyWT5/ldpvXOMg71SMxWhAoqip+NsueYnjC5OR086cH97wJrstzeh
         mm/z4Dp1cVxqfeNisfD+Hw2d6MPA9P0ZvDxnlfxWy0Uww905VQ1zsNoM+kCBPlU3Xa
         +qZAejMXPgbHYGkrrXwxdvA9V0ZH6OcnHOaBVK5+bUVff4vY/8uc691QsopDMaHTDs
         RmBXO7pBi1wgYiKLvpUcc3mkA3rzG6UFPBmZfkfQjd6Ii9ftGhgFURA+4OSS1RmS3r
         nNF9olufBtIOKW4hT4bsy2fESMOqiV5prUKzkiYv/EvscXOwpZOyAvIIpPpcZOYYTP
         7kOrf4PbwtHtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D8C3C4167B;
        Tue, 18 Apr 2023 10:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] bnxt_en: Bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168181441944.15261.3551106304375753138.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Apr 2023 10:40:19 +0000
References: <20230417065819.122055-1-michael.chan@broadcom.com>
In-Reply-To: <20230417065819.122055-1-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gospo@broadcom.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 16 Apr 2023 23:58:17 -0700 you wrote:
> This small series contains 2 fixes.  The first one fixes the PTP
> initialization logic on older chips to avoid logging a warning.  The
> second one fixes a potenial NULL pointer dereference in the driver's
> aux bus unload path.
> 
> Kalesh AP (1):
>   bnxt_en: Fix a possible NULL pointer dereference in unload path
> 
> [...]

Here is the summary with links:
  - [net,1/2] bnxt_en: Do not initialize PTP on older P3/P4 chips
    https://git.kernel.org/netdev/net/c/e8b51a1a15d5
  - [net,2/2] bnxt_en: Fix a possible NULL pointer dereference in unload path
    https://git.kernel.org/netdev/net/c/4f4e54b1041e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



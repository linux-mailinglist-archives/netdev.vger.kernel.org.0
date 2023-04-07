Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADE26DA953
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 09:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239571AbjDGHU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 03:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239486AbjDGHUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 03:20:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93134A5F6;
        Fri,  7 Apr 2023 00:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 074FD60F7E;
        Fri,  7 Apr 2023 07:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55ADEC4339B;
        Fri,  7 Apr 2023 07:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680852018;
        bh=QnexnQFeAk6yLJjTDwsZq8ocAO5HizU4Vb2V68oXIEM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tK6qO2MiUHjjKaPBRgbZtdMEG3laO2l+TpF9hiP9L224zCtfX2Q9Hr3v3MbgO60v9
         O7jSygudJGCW+MsEM38UB29dKzFVDLOk6dFB3/pd3oGzyUBqV9RPcueIOIJq9Z3rWW
         a7xvkvC00yPvCV8x11VGGYXwtk4sHqNcpE6HJy11YH3bRyx4rUyFW0CJoocEMLYf7V
         giFwFy3oHFNzhIfhS64dalBTNDdMOJstTbVRojrLVde1f05X2CmTX/DtOekFEa3vRX
         LbOUWP4tQjBpXR+iGYcXupx1XCo4JttbVltdJ/Siu7lmV8N+q9NIj0mahvmsAh7EMy
         hgWzhW1/V442Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39754E4F14C;
        Fri,  7 Apr 2023 07:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] niu: Fix missing unwind goto in niu_alloc_channels()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168085201823.13885.16010992572875922038.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Apr 2023 07:20:18 +0000
References: <20230406063120.3626731-1-harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230406063120.3626731-1-harshit.m.mogalapalli@oracle.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     error27@gmail.com, kernel-janitors@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mkl@pengutronix.de, leon@kernel.org,
        keescook@chromium.org, robh@kernel.org,
        wsa+renesas@sang-engineering.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed,  5 Apr 2023 23:31:18 -0700 you wrote:
> Smatch reports: drivers/net/ethernet/sun/niu.c:4525
> 	niu_alloc_channels() warn: missing unwind goto?
> 
> If niu_rbr_fill() fails, then we are directly returning 'err' without
> freeing the channels.
> 
> Fix this by changing direct return to a goto 'out_err'.
> 
> [...]

Here is the summary with links:
  - niu: Fix missing unwind goto in niu_alloc_channels()
    https://git.kernel.org/netdev/net/c/8ce07be70345

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



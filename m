Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E917D4B6F13
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 15:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbiBOOkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:40:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbiBOOkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:40:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F160C102428
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DAE460AD9
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F05FFC340F6;
        Tue, 15 Feb 2022 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644936011;
        bh=o9qN3xv/j9w7td+XQAIQjbnTz5cv3V1kghwTBLsAH+M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nw666Mu6KtUmI0dofRi3Dlc7kfX2FXXiow7mBJdtPkNeEmibGoYGf0p0GjD3ZI8Rv
         fSqEil+hAqq9vgN8i5Mc6tNus+cmBpoKMM5xTKZVLLkQeOMQgKvDeatbuwkZW8IzlK
         +Q+4M8BRTYqk9b4kg2k5b6PNNDmrlTCDuLhtPK1fe7DieC/RQXXL+FCjHV365ftU+R
         xP75+bffXzXNGpox1g2xw2fVJ8QkgAN60hPqX5TatNbZO5wKvFlaet9PEL2sjn/GFd
         PilbltkMcQvycaw4xXOagh+MT480DnwHlxKykTidpSqkNJPrv+1inEBonh+zVr01EU
         kxjQmBiREFXqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC81BE7BB04;
        Tue, 15 Feb 2022 14:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dpaa2-eth: Initialize mutex used in one step timestamping
 path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164493601089.31968.6975486893401355075.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 14:40:10 +0000
References: <20220214174534.1051-1-radu-andrei.bulie@nxp.com>
In-Reply-To: <20220214174534.1051-1-radu-andrei.bulie@nxp.com>
To:     Radu Bulie <radu-andrei.bulie@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ioana.ciornei@nxp.com, yangbo.lu@nxp.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Mon, 14 Feb 2022 19:45:34 +0200 you wrote:
> 1588 Single Step Timestamping code path uses a mutex to
> enforce atomicity for two events:
> - update of ptp single step register
> - transmit ptp event packet
> 
> Before this patch the mutex was not initialized. This
> caused unexpected crashes in the Tx function.
> 
> [...]

Here is the summary with links:
  - [net] dpaa2-eth: Initialize mutex used in one step timestamping path
    https://git.kernel.org/netdev/net/c/07dd44852be8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



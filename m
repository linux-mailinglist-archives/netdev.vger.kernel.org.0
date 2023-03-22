Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D576C423B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 06:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjCVFkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 01:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjCVFkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 01:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F2F10413
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 22:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA57261F6F
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B790C4339E;
        Wed, 22 Mar 2023 05:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679463619;
        bh=lIB/ibfyUiLrmXFAl5EYTXvwuJN+nQq9yiROmb7na70=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QMGKNeRlD7pPbBF4hIJJJSc6WPl9LkwFJ5djIJdwvGwGe7bH2BcDSaPiZQoi0tI66
         0Xhwbj0CTKK2TUYobt7aOsww6oRoujLHsCvXTewVocXbl2VDCaDAah1aUHB2sR3JTp
         irszaeHaX3U/zWNmSGTd+OS3nGNjNMhGHSBrEXvEYjGP43VDGHajNNn+SM9StObvwO
         q6WWvywSfi+RfNCR3tfCXky6K2o1DVl85BTppQ9tY9D7znF1TqvP4CubJKcwMLMF4w
         kxT8rZT2sP9/4h92LnVz0WY4Qh1TA+Vh+DcpYgLW6beNisqPjdMTU5SUi/hVRMmICH
         nytidxwHIuI/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EC011E66C8E;
        Wed, 22 Mar 2023 05:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tools: ynl: skip the explicit op array size when no
 needed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167946361896.17510.14926242661020014836.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 05:40:18 +0000
References: <20230321044159.1031040-1-kuba@kernel.org>
In-Reply-To: <20230321044159.1031040-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Mar 2023 21:41:59 -0700 you wrote:
> Jiri suggests it reads more naturally to skip the explicit
> array size when possible. When we export the symbol we want
> to make sure that the size is right.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/core/netdev-genl-gen.c | 2 +-
>  tools/net/ynl/ynl-gen-c.py | 4 +++-
>  2 files changed, 4 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] tools: ynl: skip the explicit op array size when no needed
    https://git.kernel.org/netdev/net-next/c/56c874f7dbca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



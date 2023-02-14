Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733A46957B9
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 05:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjBNEKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 23:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjBNEKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 23:10:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE6317CE4;
        Mon, 13 Feb 2023 20:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 88496CE1E8F;
        Tue, 14 Feb 2023 04:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B791BC4339B;
        Tue, 14 Feb 2023 04:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676347818;
        bh=mVZ03NU8XcXvTaNayd/ATTysguEp6XAgRI3qSxsYbtc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EIvRJIn2vV4EJkIGuoc3/ZfKQemLW+U9p8pZS2ip/KX3av/lmp0UCtMbpU4lNvP7F
         +McyXn1b7GRb5NLuONgLnbajohXTGb5SZHeTAAbWNLFsO+bd296rdfG1wSCKDTy9W1
         w0I8Ev7vYQvjIrb8YNMLeIaEFhl9/WCOBnMARJ1/5KDpHNqfoowG3kXgzJ+1ztw2Xr
         UINrjwm7YFnkKYV9htETTnJpBA05NhaXAWi0MHalAPra6f3S5qwYju8C0ty2CNQYXu
         iA7Kd9r12cHIkpnuVGlY5PStKpQVS+cA+6S3ZgYnoJAIcBy9p4qzHmvHeDgDeu7MXt
         /mlEjpdmvsy8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9E4F4E450B9;
        Tue, 14 Feb 2023 04:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mvneta: do not set xdp_features for hw buffer
 devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167634781864.18399.9288861823788760626.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 04:10:18 +0000
References: <19b5838bb3e4515750af822edb2fa5e974d0a86b.1676196230.git.lorenzo@kernel.org>
In-Reply-To: <19b5838bb3e4515750af822edb2fa5e974d0a86b.1676196230.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        lorenzo.bianconi@redhat.com, bpf@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 12 Feb 2023 11:08:26 +0100 you wrote:
> Devices with hardware buffer management do not support XDP, so do not
> set xdp_features for them.
> 
> Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: mvneta: do not set xdp_features for hw buffer devices
    https://git.kernel.org/netdev/net-next/c/1dc55923296d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2049252B9B4
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbiERMAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbiERMAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E62117CC88;
        Wed, 18 May 2022 05:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6E7EB81F9A;
        Wed, 18 May 2022 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EB35C3411B;
        Wed, 18 May 2022 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652875214;
        bh=lTlGFySQT7oOf37vRpc8yn71fNLyH6cC7CaTeMhA7iQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qdh7Ka6hNjdEV0FXpTrulABxRPtWRs6IbkMTCzCxcYx4trkhLDTKJ3zJb1rVZDwZo
         VHsi1YcP/AQVA5bsBGHltoGTJj9vXGNyfvJBS8Q+/ujk4KbnbeQilIluGaYZHk+tvx
         V5E00CTrKTLxt8fuosCxlaWeHQ+xqFa0s9b2J6uOhJcQJiICId9bPe+4pqKDTp+o5D
         YlKVY+vLZVRs5Ejrp3ubhnClDGLQ123PNN4B+CEu/AwFT37beyIaue0EElc3L+XyRp
         Ha4LUvbXWmV3F6y5nxJiDL0JyQYdlnxY77Xs4txnSZduAhzYwcR5gErlE92x2wza+N
         N11Aa4ahGH7ug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D732F0393D;
        Wed, 18 May 2022 12:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch] net: af_key: check encryption module availability consistency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287521444.18230.8052917231672464360.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 12:00:14 +0000
References: <20220518063218.5336B160CF38F@cvk027.cvk.de>
In-Reply-To: <20220518063218.5336B160CF38F@cvk027.cvk.de>
To:     Thomas Bartschies <thomas.bartschies@cvk.de>
Cc:     davem@davemloft.net, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Steffen Klassert <steffen.klassert@secunet.com>:

On Wed, 18 May 2022 08:32:18 +0200 (CEST) you wrote:
> Since the recent introduction supporting the SM3 and SM4 hash algos for IPsec, the kernel
> produces invalid pfkey acquire messages, when these encryption modules are disabled. This
> happens because the availability of the algos wasn't checked in all necessary functions.
> This patch adds these checks.
> 
> Signed-off-by: Thomas Bartschies <thomas.bartschies@cvk.de>

Here is the summary with links:
  - net: af_key: check encryption module availability consistency
    https://git.kernel.org/netdev/net/c/015c44d7bff3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



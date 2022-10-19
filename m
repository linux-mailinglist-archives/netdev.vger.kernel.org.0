Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE9360388C
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 05:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiJSDU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 23:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJSDU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 23:20:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCD03A4B1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 20:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 720E361767
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 03:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D39B1C433D6;
        Wed, 19 Oct 2022 03:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666149622;
        bh=y3Qf3km/y1XSvpFAH1eCYGdvYRmr5C6rt6cOVXnl8fI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d117+iJjMO1IPqkYft8yv/kgVXWbAoukO0vXqUtxpncfLCzcG5PyohcnMy8+Svsry
         uuyUpeRgcveVG4ckKIFkktPdEikK5eBMNe0LpL/FfHUfX0z6fb6wZsSjv5+x6OGr9L
         9gVVi7LHOJMBCRtwtsn37HRDPjB90DzEXoSHonlUdHSt1LraK9Ub+6qTSj1TN35kz2
         86ygkD0Ef1dILq8rzEmH54krquxOT+pVkEu9YZ7N/j9a08hLyYlUYFoE1Q9Qhk7L0R
         fh/Q0LeOLuGoInwJCuPznHJeTB9kJG8zh2SR9s2V1QOXs10kjFDvoxryOQVp/1Oc9Z
         ljjYZbRJmTxeQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B00C3E50D8E;
        Wed, 19 Oct 2022 03:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] enic: define constants for legacy interrupts offset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166614962271.9993.2283069771294236172.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 03:20:22 +0000
References: <20221018005804.188643-1-govind.varadar@gmail.com>
In-Reply-To: <20221018005804.188643-1-govind.varadar@gmail.com>
To:     Govindarajulu Varadarajan <govind.varadar@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, benve@cisco.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 17 Oct 2022 17:58:04 -0700 you wrote:
> Use macro instead of function calls. These values are constant and will
> not change.
> 
> Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
> ---
>  drivers/net/ethernet/cisco/enic/enic.h      | 23 ++++++---------------
>  drivers/net/ethernet/cisco/enic/enic_main.c | 11 +++++-----
>  2 files changed, 11 insertions(+), 23 deletions(-)

Here is the summary with links:
  - [net-next] enic: define constants for legacy interrupts offset
    https://git.kernel.org/netdev/net-next/c/e2ac2a00dae1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



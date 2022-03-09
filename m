Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EE04D28EE
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 07:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiCIGVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 01:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiCIGVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 01:21:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441D23191C;
        Tue,  8 Mar 2022 22:20:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFE7BB81FB9;
        Wed,  9 Mar 2022 06:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D8E8C340F3;
        Wed,  9 Mar 2022 06:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646806812;
        bh=5892aYAmgJJ3XqfhFeBgWKzZU6cNcCQsgHlWSDjfye8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ulprq9ZBQfSIJMBpyzBK2/SYxDPh2qz56npnRiZ64u15shH5JL44JWoDWfLKG3R/M
         qQYq4QoCZEYBl3AJGOsKIlkMX4uornsrR6qaWYHJh5wxVXyiCBgfn+0DEwUY0erH6k
         z1id+pqsTXTA8coIOtR49bL7Te1IY1Mr06GBZ5FLPDkTApyv+ZdUUm7UebCj26S/mP
         9W4U7LM2weQhugNCV+oiWIVopVpdMG4gfO3xDDrOCkt1ac1/nCCIWbVABjFFTFM76u
         BwcYozrrhIUIw9f7Y3uxostezEyWkQZ7+fb1p9MOUnpT69JH/t8+NnZradWA1a/3Fg
         96IQzY4mUl54w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6025DF0383B;
        Wed,  9 Mar 2022 06:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2] SO_ZEROCOPY should return -EOPNOTSUPP rather than -ENOTSUPP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164680681239.10719.5966093019014584969.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 06:20:12 +0000
References: <20220307223126.djzvg44v2o2jkjsx@begin>
In-Reply-To: <20220307223126.djzvg44v2o2jkjsx@begin>
To:     Samuel Thibault <samuel.thibault@labri.fr>
Cc:     davem@davemloft.net, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 7 Mar 2022 23:31:26 +0100 you wrote:
> ENOTSUPP is documented as "should never be seen by user programs",
> and thus not exposed in <errno.h>, and thus applications cannot safely
> check against it (they get "Unknown error 524" as strerror). We should
> rather return the well-known -EOPNOTSUPP.
> 
> This is similar to 2230a7ef5198 ("drop_monitor: Use correct error
> code") and 4a5cdc604b9c ("net/tls: Fix return values to avoid
> ENOTSUPP"), which did not seem to cause problems.
> 
> [...]

Here is the summary with links:
  - [PATCHv2] SO_ZEROCOPY should return -EOPNOTSUPP rather than -ENOTSUPP
    https://git.kernel.org/netdev/net-next/c/869420a8be19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



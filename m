Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF01515B39
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 10:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380758AbiD3IEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 04:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382278AbiD3IEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 04:04:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D42F237E2;
        Sat, 30 Apr 2022 01:00:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E34F5B81D03;
        Sat, 30 Apr 2022 08:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E6A1C385AF;
        Sat, 30 Apr 2022 08:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651305641;
        bh=pe08Mdjqla3FNT96mNNuQXP8ILn0+/mHR01kJNYaDic=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kpvXG6gAXQ7u8p7VNWhLHi8OioRjTUEMNeyaytnu64Tlm3WDc+9G65aHyH17I6Diz
         5jBIXhCOYaE9MWPbblLVP34glVbcEXDFadZeC1m/ozWT0DtLOuk2lY2OLQTqEZxjcv
         UF1SUB7qrKBQNqJGV7DS+LErHbW5e24ev50IE4aqZ37tG1QD6bYzt2wRvMtP19xyET
         kb+hm3gSIlqoDwVSbGXCbAfFHb5+Fm+WKfhA6RRKW2aw3Bc5cVLkCO390GaRHqO0JS
         QYcBYGc+38fsaLliNEJEjp8cr1wYSjcYriu5X5/AHsphXMh14EX8ojqfJUpVrlLxY1
         S/K+3C67aDB6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5DB96E8DBDA;
        Sat, 30 Apr 2022 08:00:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: SO_RCVMARK socket option for SO_MARK with
 recvmsg()
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165130564137.32506.12098247313333350008.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 08:00:41 +0000
References: <20220427200259.2564-1-lnx.erin@gmail.com>
In-Reply-To: <20220427200259.2564-1-lnx.erin@gmail.com>
To:     Erin MacNeil <lnx.erin@gmail.com>
Cc:     rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        tsbogend@alpha.franken.de, James.Bottomley@HansenPartnership.com,
        deller@gmx.de, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, arnd@arndb.de, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        socketcan@hartkopp.net, mkl@pengutronix.de, robin@protonic.nl,
        linux@rempel-privat.de, kernel@pengutronix.de,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        jk@codeconstruct.com.au, matt@codeconstruct.com.au,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, edumazet@google.com, lmb@cloudflare.com,
        ptikhomirov@virtuozzo.com, m@lambda.lt, hmukos@yandex-team.ru,
        sfr@canb.auug.org.au, weiwan@google.com, yangbo.lu@nxp.com,
        fw@strlen.de, tglx@linutronix.de, rpalethorpe@suse.com,
        willemb@google.com, liuhangbin@gmail.com, pablo@netfilter.org,
        rsanger@wand.net.nz, yajun.deng@linux.dev,
        jiapeng.chong@linux.alibaba.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Apr 2022 16:02:37 -0400 you wrote:
> Adding a new socket option, SO_RCVMARK, to indicate that SO_MARK
> should be included in the ancillary data returned by recvmsg().
> 
> Renamed the sock_recv_ts_and_drops() function to sock_recv_cmsgs().
> 
> Signed-off-by: Erin MacNeil <lnx.erin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: SO_RCVMARK socket option for SO_MARK with recvmsg()
    https://git.kernel.org/bluetooth/bluetooth-next/c/6fd1d51cfa25

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



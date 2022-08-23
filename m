Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A8259CD7B
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbiHWBAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiHWBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6BD4AD5B
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 18:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03947B81A27
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 01:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7B3DC433C1;
        Tue, 23 Aug 2022 01:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661216415;
        bh=B5vAX/Q+4Oi+dyNgdnRS5gAtxlECFRZ+1Fl2rSkm+Q8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P75nIw6VsatZAYgUHFQPwfw+XOkNUDZSf+16Xb9+Qg7vLGU6dwiwyf/zAdh0CT/Yn
         hAwMSfn1Tf71JoxmsCV0kwle3Y/FnF0rOxpfCFraEPb1harVJ6UfjeU9rBLNK3QOPy
         9PeCJuKQ2pjIJ+3gVJYOxd8xyDaFd4e79ra4LRxDzsde0a9fgRpv/zLqyUwdviLxkd
         kYtLJ9lyzO04Qh+Bd6O+EZJGZgcs6X1yY8oOk1SdfnHBHnz/7lB+8QcowrxIpIfrzn
         QQYDoK/7sPUTwKGFEadpHj9HYdbKPZiR7eShaU/GzEXZYGhCllc075TuKRNTF0obuQ
         u8eJo15JYyEEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88C18C4166E;
        Tue, 23 Aug 2022 01:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device tree
 blobs with no phy-mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166121641555.14563.1081826151386318424.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 01:00:15 +0000
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        m.grzeschik@pengutronix.de, linux@rempel-privat.de,
        regressions@leemhuis.info, alsi@bang-olufsen.dk,
        linux@rasmusvillemoes.dk, craig@mcqueen.id.au
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 18 Aug 2022 17:32:50 +0300 you wrote:
> DSA has multiple ways of specifying a MAC connection to an internal PHY.
> One requires a DT description like this:
> 
> 	port@0 {
> 		reg = <0>;
> 		phy-handle = <&internal_phy>;
> 		phy-mode = "internal";
> 	};
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: microchip: keep compatibility with device tree blobs with no phy-mode
    https://git.kernel.org/netdev/net/c/5fbb08eb7f94

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18023558F13
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 05:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiFXDaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 23:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiFXDaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 23:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F17150E26
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 20:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3071CB82604
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 03:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D79C3C341C7;
        Fri, 24 Jun 2022 03:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656041413;
        bh=VVmj78Dy/tVwuUNyMpkdWaAqeCEThKG64tWyQyAabhw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BJGdKdG8WXQI9NWdjbLVJjfcSx0fom306E+iWyfbGrkpeUs8TMnpeSxr44Xq6YySX
         7xgqNpmcQhHVV8IYIDhM3jRXPfy4sxkcb0/H0MfYhjiFiu/5eexnvuIqSUrdknjcyI
         lLwrXOizAi7jaurfe8VBYFvEQe7AV6nKvRwOsgw0ucmC3ubKyJe7xc36+3x6wbiZ5J
         QoerJJm+hGvwIPvxK/0FU/EKA8hE3oOHRy7DhkomJOpSILJUp+x6FEHNHi74l9mx4k
         Rikc/CASJIVtKFTiqijHwp/4MYmCnca2v6Bk2JIsxCLEoE5jtUqEIOL3S44Uz08+Bo
         0/au4/tsF1weA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1BBAE737F0;
        Fri, 24 Jun 2022 03:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: dsa: mv88e6xxx: get rid of SPEED_MAX
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165604141371.13504.3415106547554041008.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 03:30:13 +0000
References: <YrGQBssOvQBZiDS4@shell.armlinux.org.uk>
In-Reply-To: <YrGQBssOvQBZiDS4@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kabel@kernel.org,
        davem@davemloft.net, edumazet@google.com, f.fainelli@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
        olteanv@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Jun 2022 10:31:50 +0100 you wrote:
> Hi,
> 
> This series does two things:
> 
> 1. it gets rid of mv88e6065_port_set_speed_duplex() which is completely
>    unused (do we support this device? I couldn't find it in the tables
>    in chip.c) This has a max speed of 200Mbps which we don't support.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: mv88e6xxx: remove mv88e6065 dead code
    https://git.kernel.org/netdev/net-next/c/aa64bc1990b2
  - [net-next,2/2] net: dsa: mv88e6xxx: get rid of SPEED_MAX setting
    https://git.kernel.org/netdev/net-next/c/3c783b83bd0f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



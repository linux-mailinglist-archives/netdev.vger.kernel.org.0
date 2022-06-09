Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2C1544259
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237075AbiFIEKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236029AbiFIEKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3113095A14
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 21:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BAC2B82BF9
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 04:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 002D2C341C4;
        Thu,  9 Jun 2022 04:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654747814;
        bh=JXJS961d8tI+NkB432wJXnC8sXBrEySW1RneZ+P0Cgg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jUXvVmE4Wyta9U+nOUV0fwW6FSsOkkYpY1s0XY2Y1tROU8qnX2Cx4tUq+bl0zTj9J
         qQSuYL6ZgmpZLvq/32eXLVMxzrFMNK+vwNZPFttFXfQNh9ojeT7FFnb5+RsZPYpawz
         6n3AH0oZonsXbSr3WXJlLW+pA5Hx9f/D6l61/5mNt3FmN5ZlMLaO3MMoulN8aFItys
         vAj5rNJFGsGUrnCMkb75PUxygvuBUSSaHhwotDYp/x0ShQYkYmTfE61LTwgBLc7sYb
         QZaQ1mcKIUvatSA3kJJom33bCFM2J1BBhh9/t57gN7ZwNBUqSwqIwwJrGdQmU8Ehlw
         4pSiVpBmtTaxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9E9AE737FE;
        Thu,  9 Jun 2022 04:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] mv88e6xxx: fixes for reading serdes state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165474781388.435.1087441152399104807.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 04:10:13 +0000
References: <Yp82TyoLon9jz6k3@shell.armlinux.org.uk>
In-Reply-To: <Yp82TyoLon9jz6k3@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
        f.fainelli@gmail.com, kuba@kernel.org, kabel@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        vivien.didelot@gmail.com, olteanv@gmail.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 7 Jun 2022 12:28:15 +0100 you wrote:
> Hi,
> 
> These are some low-priority fixes to the mv88e6xxx serdes code.
> Patch 1 fixes the reporting of an_complete, which is used in the
> emulation of a conventional C22 PHY. Patch from Marek.
> 
> Patch 2 makes one of the error messages in patch 2 to be consistent
> with the other error messages in this function.
> 
> [...]

Here is the summary with links:
  - [net,1/3] net: dsa: mv88e6xxx: use BMSR_ANEGCOMPLETE bit for filling an_complete
    https://git.kernel.org/netdev/net/c/47e96930d6e6
  - [net,2/3] net: dsa: mv88e6xxx: fix BMSR error to be consistent with others
    https://git.kernel.org/netdev/net/c/2b4bb9cd9bcd
  - [net,3/3] net: dsa: mv88e6xxx: correctly report serdes link failure
    https://git.kernel.org/netdev/net/c/b4d78731b34b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



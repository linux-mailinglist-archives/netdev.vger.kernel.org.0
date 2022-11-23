Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A099636BBB
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 22:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbiKWVAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 16:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiKWVAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 16:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A27518392
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 13:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF52FB824F6
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 21:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C925C433C1;
        Wed, 23 Nov 2022 21:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669237218;
        bh=AwraTpVsd7sOp1+eoJTEfLDftGJo8IrPY+cghm/JUhs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FEX6ZLWPCutqraDTwnCzaGvJe2ZwPEY/b7TTlHu6MXnk8WC3WJZisgwvy4BBjZjFf
         /NteDktPll364MNNM0ZkoCYT+OJzATQGj0SxLXEiEwbYG6ujCNgs2x6hq2OpztPQ6p
         CA59XmVVdnNbXXgy1wQvRggRouOUMQ5yyc+8q9u/n/qTOEVHXijL94qXlqtDeG8RlN
         rs8HYeGyTS3S5wmPEk+FT0j46Sp0Zhl7N3XXaFJjHNCn+yIFu742bkrmCh3Q+9Swwi
         Rz7QslfFOqfpokt45pVsRIsAL6/Vn+GZ/oONjMgtdszGTOgrEczBXwXeO2rU0NAqzd
         l2bA6AAFcdLGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36A0FC5C7C6;
        Wed, 23 Nov 2022 21:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/12] net: Complete conversion to i2c_probe_new
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166923721821.22845.12272125649723880535.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 21:00:18 +0000
References: <20221123045507.2091409-1-kuba@kernel.org>
In-Reply-To: <20221123045507.2091409-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, uwe@kleine-koenig.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Nov 2022 20:54:55 -0800 you wrote:
> Reposting for Uwe the networking slice of his mega-series:
> https://lore.kernel.org/all/20221118224540.619276-1-uwe@kleine-koenig.org/
> so that our build bot can confirm the obvious.
> 
> fix mlx5 -> mlxsw while at it.
> 
> v2: pull the prep into net-next first
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/12] net: dsa: lan9303: Convert to i2c's .probe_new()
    https://git.kernel.org/netdev/net-next/c/c479babce5b1
  - [net-next,v2,02/12] net: dsa: microchip: ksz9477: Convert to i2c's .probe_new()
    https://git.kernel.org/netdev/net-next/c/f925e2154de9
  - [net-next,v2,03/12] net: dsa: xrs700x: Convert to i2c's .probe_new()
    https://git.kernel.org/netdev/net-next/c/dfd5e53dd721
  - [net-next,v2,04/12] net/mlxsw: Convert to i2c's .probe_new()
    https://git.kernel.org/netdev/net-next/c/cb405c2a4040
  - [net-next,v2,05/12] nfc: microread: Convert to i2c's .probe_new()
    https://git.kernel.org/netdev/net-next/c/f72eed59eab4
  - [net-next,v2,06/12] nfc: mrvl: Convert to i2c's .probe_new()
    https://git.kernel.org/netdev/net-next/c/a9f656c88a90
  - [net-next,v2,07/12] NFC: nxp-nci: Convert to i2c's .probe_new()
    https://git.kernel.org/netdev/net-next/c/bf1f6f297528
  - [net-next,v2,08/12] nfc: pn533: Convert to i2c's .probe_new()
    https://git.kernel.org/netdev/net-next/c/d72c9828a3cb
  - [net-next,v2,09/12] nfc: pn544: Convert to i2c's .probe_new()
    https://git.kernel.org/netdev/net-next/c/2338adb2e091
  - [net-next,v2,10/12] nfc: s3fwrn5: Convert to i2c's .probe_new()
    https://git.kernel.org/netdev/net-next/c/0fc00c085d71
  - [net-next,v2,11/12] nfc: st-nci: Convert to i2c's .probe_new()
    https://git.kernel.org/netdev/net-next/c/75cc560ff661
  - [net-next,v2,12/12] nfc: st21nfca: i2c: Convert to i2c's .probe_new()
    https://git.kernel.org/netdev/net-next/c/1fa082734076

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



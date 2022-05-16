Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A54528252
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242731AbiEPKkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242699AbiEPKkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3473E23BDB;
        Mon, 16 May 2022 03:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBB3260EED;
        Mon, 16 May 2022 10:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29273C34119;
        Mon, 16 May 2022 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652697614;
        bh=xZ+bmIZy2Tzsib4GeADejj/iCh2ccjEaKmgbT2GZatg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b1zCi5thWIJ3gm4Mm5ePP3uI/qxKwl3USVQI8/DzwP4c+S3X/hxRbcdSXd9FA85a9
         Le9ChjV1q8qWkIr6UXm90zNu1iEkmG9q8SjA3dzai9oQ47FBbIuUlMZvskpgqIdkix
         4ExgTZoqvH1OpP+G3TIXHXn5NcITumk/4j9wL+xsn+Rls1Es5j6ktXHhC+2uRpCelH
         WsID4ldLtjnMjI+VreNQpOyza4oqKvxqq9nvSzRRdfc6owRL9+Ye7pKWP1uQJ1FCrH
         rmJUnqglQaZclVeEIjOnMO9GxyVQNzRi5mZTBm77Uoq3Nz2OPcUdisyNwcNY1nADuX
         Eut3eIqw1/dWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0AEBEF0393B;
        Mon, 16 May 2022 10:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: tulip: convert to devres
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269761404.8728.16015739218131453967.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 10:40:14 +0000
References: <2630407.mvXUDI8C0e@eto.sf-tec.de>
In-Reply-To: <2630407.mvXUDI8C0e@eto.sf-tec.de>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        yangyingliang@huawei.com, davem@davemloft.net, edumazet@google.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 13 May 2022 19:23:59 +0200 you wrote:
> Works fine on my HP C3600:
> 
> [  274.452394] tulip0: no phy info, aborting mtable build
> [  274.499041] tulip0:  MII transceiver #1 config 1000 status 782d advertising 01e1
> [  274.750691] net eth0: Digital DS21142/43 Tulip rev 65 at MMIO 0xf4008000, 00:30:6e:08:7d:21, IRQ 17
> [  283.104520] net eth0: Setting full-duplex based on MII#1 link partner capability of c1e1
> 
> [...]

Here is the summary with links:
  - [v2] net: tulip: convert to devres
    https://git.kernel.org/netdev/net-next/c/3daebfbeb455

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



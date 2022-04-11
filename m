Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510174FB8CE
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344716AbiDKKC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbiDKKC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:02:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A203E10FC;
        Mon, 11 Apr 2022 03:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E3CD612D6;
        Mon, 11 Apr 2022 10:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D2C3C385A3;
        Mon, 11 Apr 2022 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649671212;
        bh=zEs5JBbUBkl3v6LO2j24SJhPRwPFMfW/ri9tTEZwQC0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U7XF5N9naNd7pSFAqXaEkqigo1d3YVyv+9ojjf09U64twBXmAxJiMwD8TNDMKIrR+
         Cnvf3dBb7oB3VS0dSogBBHWcNRo86mg7dhQEMV1nhML3hWe4gucuj7irbrvpS4FXw+
         8vlgXy/6k1DPnC6KJuchsgNaAZBaxF3dq89hDWIOghi2n3UUeXYzGWmKDIbZ5iCC9E
         vkxq3iuS4LwYr6VtpUM9cA4ZEJPV1z9xtlPJON5/T1n3Brq061rV1OTdGb60UKZ5PE
         PQtxWH49udENLpUxql9Ez6jzt1nEj+Z8PDj/BitOmP89VqAq8TinN9BOa1qHSesveT
         R5Y1xjsMwqLoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DFE2E85B76;
        Mon, 11 Apr 2022 10:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net v2] net: phy: LAN87xx: remove genphy_softreset in
 config_aneg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164967121244.20630.6489793738825351974.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 10:00:12 +0000
References: <20220407044610.8710-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220407044610.8710-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        prasanna.vengateshan@microchip.com, pabeni@redhat.com,
        kuba@kernel.org, davem@davemloft.net, linux@armlinux.org.uk,
        hkallweit1@gmail.com, andrew@lunn.ch, UNGLinuxDriver@microchip.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 7 Apr 2022 10:16:10 +0530 you wrote:
> When the T1 phy master/slave state is changed, at the end of config_aneg
> function genphy_softreset is called. After the reset all the registers
> configured during the config_init are restored to default value.
> To avoid this, removed the genphy_softreset call.
> 
> v1->v2
> 
> [...]

Here is the summary with links:
  - [net,v2] net: phy: LAN87xx: remove genphy_softreset in config_aneg
    https://git.kernel.org/netdev/net/c/b2cd2cde7d69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



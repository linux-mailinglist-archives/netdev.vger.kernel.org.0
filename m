Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E48654C3B3
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346157AbiFOIkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243058AbiFOIkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9D949F3D
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 01:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 419FAB81D17
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BED93C341C0;
        Wed, 15 Jun 2022 08:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655282413;
        bh=trD32adcmXzb9+8uZdlskgRZ8XzDObXZXNuLhiXhPdg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rr+oC1RopBlT7KDa0ivdzl9MrozMtt2gOYFjA9jC5/T3qp2v5UwQK492qSrV9fpw9
         7iRea/vMLS4R0+dAGTwaM51Oj0IJrojP0avrCwLVt4KX8ZDxEsbb7IGc0WQJEBA+EO
         Iu/CH1jktzRTCcPsqhQvzmJbMwAk3+4n/t4aG90Ebc87dv50GWrBamoSpeudS5biuH
         7f3aMdBOmj1AgRRUWHT7ZgcvG9E5/Gwj2OQb2lod8rQv4oICrMMv3S+NMOIB/uUWGh
         iVyp0pqRgko4eARi4aFRoErC0Lz6qFJgrq+DCC+hgBvR7YdGSxedLYRWD8ftKnw9nL
         4hqfkPB2Mk+mA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9FF75E6D466;
        Wed, 15 Jun 2022 08:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: ax88179_178a needs FLAG_SEND_ZLP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165528241365.21469.4485156197785739064.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 08:40:13 +0000
References: <32138cf48914f241a998480f343e199ecd9b78c3.camel@gmail.com>
In-Reply-To: <32138cf48914f241a998480f343e199ecd9b78c3.camel@gmail.com>
To:     Jose Alonso <joalonsof@gmail.com>
Cc:     netdev@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Jun 2022 15:32:44 -0300 you wrote:
> The extra byte inserted by usbnet.c when
>  (length % dev->maxpacket == 0) is causing problems to device.
> 
> This patch sets FLAG_SEND_ZLP to avoid this.
> 
> Tested with: 0b95:1790 ASIX Electronics Corp. AX88179 Gigabit Ethernet
> 
> [...]

Here is the summary with links:
  - net: usb: ax88179_178a needs FLAG_SEND_ZLP
    https://git.kernel.org/netdev/net/c/36a15e1cb134

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



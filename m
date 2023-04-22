Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DFF6EB710
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 05:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjDVDa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 23:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjDVDaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 23:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCC91BDA;
        Fri, 21 Apr 2023 20:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7855563ED5;
        Sat, 22 Apr 2023 03:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4CD9C4339B;
        Sat, 22 Apr 2023 03:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682134218;
        bh=mNB1LmqbGggsV1k/w/tZ1bOZ01KD1NhrCVUa295o8V4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L3q/MW9u5tkh2SzksqQzkahHC8MedkWIAYZWBv4Srt0YhyH6O0IB1D2u8zMrtFUiU
         HJevb4B1bsVStLQk3rdFZtKo3AgGONkyolSHVmpw6SxQ8c/Oz5sIVxYsaxbhhy1vh7
         7F+/zxpwFjiEV92aMIzZip+JmK9xrkxjzpqwAcm0svBzD6pMQX1MeM2PpkMNj2skaO
         g7DfEpTShylPl3E0jp6TlJ5Muqb7b7B0iRGx7e/5yYE2Bi0GDlcG+PbZ3eq0fC7k4T
         0sK7zS7yDaAAIDAhDcYDAOmRaalR5WEftiOeEJSE7P3Ax+aMZ8znN9haUna2c8l4+e
         e5l5stDuBfhow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ADBE9E270E1;
        Sat, 22 Apr 2023 03:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: qca8k: fix LEDS_CLASS dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168213421870.22496.6722225959216080417.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 03:30:18 +0000
References: <20230420213639.2243388-1-arnd@kernel.org>
In-Reply-To: <20230420213639.2243388-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ansuelsmth@gmail.com, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Apr 2023 23:36:31 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> With LEDS_CLASS=m, a built-in qca8k driver fails to link:
> 
> arm-linux-gnueabi-ld: drivers/net/dsa/qca/qca8k-leds.o: in function `qca8k_setup_led_ctrl':
> qca8k-leds.c:(.text+0x1ea): undefined reference to `devm_led_classdev_register_ext'
> 
> [...]

Here is the summary with links:
  - net: dsa: qca8k: fix LEDS_CLASS dependency
    https://git.kernel.org/netdev/net-next/c/33c1af8e2c75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



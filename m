Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7AA559835
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 12:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiFXKuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 06:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiFXKuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 06:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E0F7705A;
        Fri, 24 Jun 2022 03:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F12EB827D2;
        Fri, 24 Jun 2022 10:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D528C341CC;
        Fri, 24 Jun 2022 10:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656067820;
        bh=sH3rBIKJPePOih8H0ErwAmzptIy++BSv6+DIWtO4S8M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KQfyIOEwveWKo7squ2R15HlkM3mFul0dE3+ADbICU89JUBv7SIQlVQ5QeIhvguHNl
         ob6BttyTpjStjkFPRHzqrmmcw4QnGIrdhd0sajVCA/Ktdlo3NVhVFKm92v+TxAhjtv
         6wfnupLE9VnXGwOpoBMpWToheLAS6TKeVFuzOIIh5ain6rec4Ab63R+LzB3nlh82PS
         MIhFHf1/F49vchokdOLWMk8ulBdhPMtgGUdplhxxI1sGsiTuqUjBTy+y4SD3raRvgy
         9C7i9rCzlZrKDz+8aSHULxAfBnAsvO4uS/3VuSfl2ISjG4ImwencX7FCTJDncLZ+uo
         xGshEMdgIZAzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F30EE85C6D;
        Fri, 24 Jun 2022 10:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next 00/13] net: dsa: microchip: common spi probe for the
 ksz series switches - part 2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165606782011.15655.7360355084913161028.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 10:50:20 +0000
References: <20220622090425.17709-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220622090425.17709-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk
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
by David S. Miller <davem@davemloft.net>:

On Wed, 22 Jun 2022 14:34:12 +0530 you wrote:
> This patch series aims to refactor the ksz_switch_register routine to have the
> common flow for the ksz series switch. And this is the follow up patch series.
> 
> First, it tries moves the common implementation in the setup from individual
> files to ksz_setup. Then implements the common dsa_switch_ops structure instead
> of independent registration. And then moves the ksz_dev_ops to ksz_common.c,
> it allows the dynamic detection of which ksz_dev_ops to be used based on
> the switch detection function.
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] net: dsa: microchip: rename shutdown to reset in ksz_dev_ops
    https://git.kernel.org/netdev/net-next/c/673b196fdd34
  - [net-next,02/13] net: dsa: microchip: add config_cpu_port to struct ksz_dev_ops
    https://git.kernel.org/netdev/net-next/c/fb9324beb5d4
  - [net-next,03/13] net: dsa: microchip: add the enable_stp_addr pointer in ksz_dev_ops
    https://git.kernel.org/netdev/net-next/c/331d64f752bb
  - [net-next,04/13] net: dsa: microchip: move setup function to ksz_common
    https://git.kernel.org/netdev/net-next/c/d2822e686879
  - [net-next,05/13] net: dsa: microchip: move broadcast rate limit to ksz_setup
    https://git.kernel.org/netdev/net-next/c/1ca6437fafc9
  - [net-next,06/13] net: dsa: microchip: move multicast enable to ksz_setup
    https://git.kernel.org/netdev/net-next/c/0abab9f3ec6b
  - [net-next,07/13] net: dsa: microchip: move start of switch to ksz_setup
    https://git.kernel.org/netdev/net-next/c/ad08ac189758
  - [net-next,08/13] net: dsa: microchip: common dsa_switch_ops for ksz switches
    https://git.kernel.org/netdev/net-next/c/1958eee85f67
  - [net-next,09/13] net: dsa: microchip: ksz9477: separate phylink mode from switch register
    https://git.kernel.org/netdev/net-next/c/7a8988a17c48
  - [net-next,10/13] net: dsa: microchip: common menuconfig for ksz series switch
    https://git.kernel.org/netdev/net-next/c/07bca160469b
  - [net-next,11/13] net: dsa: microchip: move ksz_dev_ops to ksz_common.c
    https://git.kernel.org/netdev/net-next/c/6ec23aaaac43
  - [net-next,12/13] net: dsa: microchip: remove the ksz8/ksz9477_switch_register
    https://git.kernel.org/netdev/net-next/c/ff3f3a3090d2
  - [net-next,13/13] net: dsa: microchip: common ksz_spi_probe for ksz switches
    https://git.kernel.org/netdev/net-next/c/4658f2fe8fbc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



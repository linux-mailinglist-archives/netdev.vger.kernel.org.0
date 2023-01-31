Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83833682F45
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjAaOa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjAaOaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A152D56;
        Tue, 31 Jan 2023 06:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE5BDB81D11;
        Tue, 31 Jan 2023 14:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 544FBC433EF;
        Tue, 31 Jan 2023 14:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675175419;
        bh=ITa4o4WFmTxgn+e+nJBzyA+kjxntGeRgij5LNvNc6lE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ASulkSs8sS6iGzxtc1phguQ26cZ/93JVL7rYG9cxXK5pwS2U/6A4RwZuRLedJ5pVK
         ZbtFFnxVbfZR7BpWdXwBtD1DZ8rKOXjZCCrmiEsu0+t9JPFujpK/CgxmRvVeTwizau
         ZUgde22tvGqy64GaiLDWltEXijdNaxSDEjkFwnKvp6+f/9ajJvGeuzC+8HvgF1fVbN
         uGbRAicTYTtiwfT+JmnvO/9GS3oXpqLSNlEp2vk+jCrUZRPQ/2kTn2oyr70jJUYFZw
         nDKZYmbochlZ8vHQbChUXHxOVAAt2D0qWSprg65eKdGmWY5nN79PgnKOeM6BCszc4g
         4Bn/NfZuGI0mg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D2CFE4D00A;
        Tue, 31 Jan 2023 14:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [v2] net: dsa: microchip: ptp: fix up PTP dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167517541917.29397.11216297645537148512.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Jan 2023 14:30:19 +0000
References: <20230130131808.1084796-1-arnd@kernel.org>
In-Reply-To: <20230130131808.1084796-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        kuba@kernel.org, richardcochran@gmail.com, arnd@arndb.de,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        arun.ramadoss@microchip.com, jacob.e.keller@intel.com,
        ceggers@arri.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 30 Jan 2023 14:17:51 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When NET_DSA_MICROCHIP_KSZ_COMMON is built-in but PTP is a loadable
> module, the ksz_ptp support still causes a link failure:
> 
> ld.lld-16: error: undefined symbol: ptp_clock_index
> >>> referenced by ksz_ptp.c
> >>>               drivers/net/dsa/microchip/ksz_ptp.o:(ksz_get_ts_info) in archive vmlinux.a
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: microchip: ptp: fix up PTP dependency
    https://git.kernel.org/netdev/net-next/c/562c65486cf1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



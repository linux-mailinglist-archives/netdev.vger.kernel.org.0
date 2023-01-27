Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DAA67DECF
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 09:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjA0IAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 03:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjA0IAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 03:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A31761EA
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 00:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19279B81FC1
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD18AC4339C;
        Fri, 27 Jan 2023 08:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674806417;
        bh=aBMnWMi045kXQI6sj4R9I+vE1lIabTPVsUzDexSUiuo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MDXu7lnpN5MkjTQpIp/lJCvJDi2I4Wk9kjc9SqKQQTkci9kh70CsdyUOehLhXvnob
         TaAMTVFTsI6BurcpiY6lNF64S1byYp8k8WrodbIJ79exTwMvOI61hybM8C8uMiBJhd
         Hcl/s24WRF5Tw7BS4b0XxA9FKi4BFHr/gbzOi+PY8gm17WZLlNdc2IwI+O4oa8ryOn
         X+ESQeP3SXKWvZ9hbnYAf0UxJY9v56WQUybMsDGlWxvOfnjnDcY1vJRaDInMgs1h/O
         W6RcjQ2u5mHSF0gSM4513Z1ASvjIEEbbtKBgleSyZTTNcj3JD/kipL7fAfH1VJiBde
         8CXFFugCfZK/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 931D7E52507;
        Fri, 27 Jan 2023 08:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: ocelot: build felix.c into a dedicated
 kernel module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167480641759.19668.17803015604689176892.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Jan 2023 08:00:17 +0000
References: <20230125145716.271355-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230125145716.271355-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        colin.foster@in-advantage.com, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, alobakin@pm.me
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 25 Jan 2023 16:57:16 +0200 you wrote:
> The build system currently complains:
> 
> scripts/Makefile.build:252: drivers/net/dsa/ocelot/Makefile:
> felix.o is added to multiple modules: mscc_felix mscc_seville
> 
> Since felix.c holds the DSA glue layer, create a mscc_felix_dsa_lib.ko.
> This is similar to how mscc_ocelot_switch_lib.ko holds a library for
> configuring the hardware.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: ocelot: build felix.c into a dedicated kernel module
    https://git.kernel.org/netdev/net-next/c/c8005511f387

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



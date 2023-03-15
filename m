Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED226BAA7A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjCOIK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjCOIKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:10:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D721285D;
        Wed, 15 Mar 2023 01:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E477B81D4F;
        Wed, 15 Mar 2023 08:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C2CEC433A4;
        Wed, 15 Mar 2023 08:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678867819;
        bh=YtL2KcIRGV+AqWho0Wwv22dmDqt+vS4Xxfr4UIuP9lY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q470luVlRKXKD073apUF+XYHrk9nTb9dZoKDihDfTe7xxwdVMZFk9/IQoZFUJrKwL
         zMGnKeuClbzrPmdsq8xbBBPS4VEg6MkpJgfvobmP2VPJqyjgLSLXD+kAlJI4fdmtxg
         EXbU6Of1biTzM4aiTTzJkXx/2aWXo7zp/liNh+QLYkMEet+PrlWD60OCsaFzj16L7U
         HlZB70Eabap0m/y7JMmYEJS89ZlwspWjFp7WyBQmNJtVmrAlPLNzHHbo4JDQ1ML7ev
         60npLsSsnkBrWW/i7mRDUJ5VaofBViL1PDa3itTX9htqLrCOMkaXt/4EmpdMc1XRkX
         5sl1Jw7QStjLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A0EFE61B6B;
        Wed, 15 Mar 2023 08:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] net: dsa: microchip: tc-ets support 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886781903.24118.14755725548116156158.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 08:10:19 +0000
References: <20230310090809.220764-1-o.rempel@pengutronix.de>
In-Reply-To: <20230310090809.220764-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     davem@davemloft.net, andrew@lunn.ch, edumazet@google.com,
        f.fainelli@gmail.com, kuba@kernel.org, pabeni@redhat.com,
        olteanv@gmail.com, woojung.huh@microchip.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Mar 2023 10:08:07 +0100 you wrote:
> changes v3:
> - add tc_ets_supported to match supported devices
> - dynamically regenerated default TC to queue map.
> - add Acked-by to the first patch
> 
> changes v2:
> - run egress limit configuration on all queue separately. Otherwise
>   configuration may not apply correctly.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] net: dsa: microchip: add ksz_setup_tc_mode() function
    https://git.kernel.org/netdev/net-next/c/69444581d002
  - [net-next,v3,2/2] net: dsa: microchip: add ETS Qdisc support for KSZ9477 series
    https://git.kernel.org/netdev/net-next/c/c570f861fa05

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



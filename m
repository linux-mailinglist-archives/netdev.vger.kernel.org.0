Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235E96C8D7B
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 12:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjCYLbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 07:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYLbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 07:31:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C28B72B2;
        Sat, 25 Mar 2023 04:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48709B80757;
        Sat, 25 Mar 2023 11:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0180BC433EF;
        Sat, 25 Mar 2023 11:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679743903;
        bh=U0QVQEsDdY6C6whk1ANXVKWU+qkoCLGSSY9wLGLS95o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g7mMaSYueGJheUtccNbmofCphrg4Hw1HZ8eVXY/VovCq8wp/y6CIJeHImwSk3mzzL
         gb1d+DxnVagSF7ac+5TzijpcIMTK20fcNI0SunXXmudyF1Tie2iWvcpy5TJmMKXXUl
         fa7Gol3e0mRMUffkmqyhhpd7vU8ISyefB+v8UnP4L45qmzKXd7PiIy2t5MhxLvdCWA
         Da7mkfnDyLMf9LXjMAKkeVOHaVDmxQZZaL1QNHQVoFJhIxq2UbK18rApv3U/iLhCgK
         KxCdUXCeimNqWkmaqrVX5t6C90lBA1zl0JD4w6Ol3+m1Quc4fmS7ClomKmWE9TqKw9
         dvQ/3Khkjw4ow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9A0BE4F0D7;
        Sat, 25 Mar 2023 11:31:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/6] net: dsa: microchip: ksz8: fixes for stable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167974390288.24850.2177602607202382121.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Mar 2023 11:31:42 +0000
References: <20230324080608.3428714-1-o.rempel@pengutronix.de>
In-Reply-To: <20230324080608.3428714-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     davem@davemloft.net, andrew@lunn.ch, edumazet@google.com,
        f.fainelli@gmail.com, kuba@kernel.org, pabeni@redhat.com,
        olteanv@gmail.com, woojung.huh@microchip.com,
        arun.ramadoss@microchip.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Mar 2023 09:06:02 +0100 you wrote:
> changes v2:
> - use proper Fixes tag
> - add Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com> on all
>   reviewed patches except the ksz8863_smi patch.
> 
> These fixes address issues such as incomplete FDB extraction, incorrect
> FID extraction and configuration, incorrect timestamp extraction, and
> ghost entry extraction from an empty dynamic MAC table. These updates
> ensure proper functioning of the FDB/MDB functionality for the
> ksz8863/ksz8873 series of chips.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/6] net: dsa: microchip: ksz8: fix ksz8_fdb_dump()
    https://git.kernel.org/netdev/net/c/88e943e83827
  - [net,v2,2/6] net: dsa: microchip: ksz8: fix ksz8_fdb_dump() to extract all 1024 entries
    https://git.kernel.org/netdev/net/c/5d90492dd4ff
  - [net,v2,3/6] net: dsa: microchip: ksz8: fix offset for the timestamp filed
    https://git.kernel.org/netdev/net/c/b3177aab89be
  - [net,v2,4/6] net: dsa: microchip: ksz8: ksz8_fdb_dump: avoid extracting ghost entry from empty dynamic MAC table.
    https://git.kernel.org/netdev/net/c/492606cdc748
  - [net,v2,5/6] net: dsa: microchip: ksz8863_smi: fix bulk access
    https://git.kernel.org/netdev/net/c/392ff7a84cbc
  - [net,v2,6/6] net: dsa: microchip: ksz8: fix MDB configuration with non-zero VID
    https://git.kernel.org/netdev/net/c/9aa5757e1f71

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



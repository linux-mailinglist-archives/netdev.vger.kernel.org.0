Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4985FE9BC
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 09:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiJNHk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 03:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJNHkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 03:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7837566133;
        Fri, 14 Oct 2022 00:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1E30B82265;
        Fri, 14 Oct 2022 07:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90A70C43144;
        Fri, 14 Oct 2022 07:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665733216;
        bh=nluamxpGNQM1259S0+YKikdRoXma4UvJDTiNbYlePwI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cvrEBziuSZBKzv1PTaJCM4Cq/mc0GpJpOVch+TNQwYRJTD211woKN+7mhFRGkB03E
         BX2q9G4sCEMVl2afIm7kR+kSxV50ZxBMmd7+TmYkpmHjU4/es6DOmEjVS3oNK44JNu
         0dTl2oDUjuUI3mQE8Ve+FmHxV1PFankDkZw9KIlMotc6aruYVsgmW10LZAn8CSRwTF
         OqoKvw9cbbynQ4EDErF+Jyj01rIiFTmIwUt2wQfv/TKyWlI0b6KNq4Z1gxBS6LMv1t
         dEz5lsrZm/a950WPNwJ5DsQg7YFqp5WXlnBzBT92U4dLKmQ7F5VG8Pj4ar5ggB6x0/
         9JkVHPCKGcTyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7BF8EE4D00B;
        Fri, 14 Oct 2022 07:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH v2 1/2] net: dsa: qca8k: fix inband mgmt for big-endian
 systems
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166573321650.24049.179193383949676080.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Oct 2022 07:40:16 +0000
References: <20221012171837.13401-1-ansuelsmth@gmail.com>
In-Reply-To: <20221012171837.13401-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paweldembicki@gmail.com, lech.perczak@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 12 Oct 2022 19:18:36 +0200 you wrote:
> The header and the data of the skb for the inband mgmt requires
> to be in little-endian. This is problematic for big-endian system
> as the mgmt header is written in the cpu byte order.
> 
> Fix this by converting each value for the mgmt header and data to
> little-endian, and convert to cpu byte order the mgmt header and
> data sent by the switch.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: dsa: qca8k: fix inband mgmt for big-endian systems
    https://git.kernel.org/netdev/net/c/a2550d3ce53c
  - [net,v2,2/2] net: dsa: qca8k: fix ethtool autocast mib for big-endian systems
    https://git.kernel.org/netdev/net/c/0d4636f7d72d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



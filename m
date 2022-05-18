Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BD052BCDD
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbiERNKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237530AbiERNKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5074E17B87C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0520BB82019
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B615FC34100;
        Wed, 18 May 2022 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652879412;
        bh=EIH9yiKDnL+UTvZPE7qnh67OC6VGMvnpFNOvsGUkcdY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C9MQIFjyZ0fHKSf7AGceMpzecm9Gr9EVoHqwjMJU5eWo654xBsL4Uy7AKlFcsG1rq
         jJRGXviszOPCrWvayWcqSTGCuM04tCmJJG9s33O/ZO/CLgtTBXypJQNwnQeaYs4GEe
         UZbDCP5zHaIzU0nLzveNZHoMN03j3qC+Fp/rLMni0X3u+0lmuceAvddtctnCeLWFfG
         tyGF6UW/mjrakiLdIVR+QdBqkUereH6WU6rFr3YiGDEHezgyt24PZO3ABua4TBivIs
         2oyjbMBjBbBkuPFbDN3WRsqh5l02vwTtDmf+PSQHk7hHGurdaYgl5Jr6xD/KzXFD4y
         Vd/PPP/jY35Cw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97140F0393B;
        Wed, 18 May 2022 13:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: ftgmac100: Disable hardware checksum on AST2600
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287941261.26952.17675675280998772661.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 13:10:12 +0000
References: <20220517092217.323060-1-joel@jms.id.au>
In-Reply-To: <20220517092217.323060-1-joel@jms.id.au>
To:     Joel Stanley <joel@jms.id.au>
Cc:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        andrew@aj.id.au, netdev@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, wilder@us.ibm.com,
        dylan_hung@aspeedtech.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 17 May 2022 18:52:17 +0930 you wrote:
> The AST2600 when using the i210 NIC over NC-SI has been observed to
> produce incorrect checksum results with specific MTU values. This was
> first observed when sending data across a long distance set of networks.
> 
> On a local network, the following test was performed using a 1MB file of
> random data.
> 
> [...]

Here is the summary with links:
  - [net,v3] net: ftgmac100: Disable hardware checksum on AST2600
    https://git.kernel.org/netdev/net/c/6fd45e79e8b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



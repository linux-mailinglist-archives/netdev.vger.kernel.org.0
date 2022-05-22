Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537D153061C
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 23:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351622AbiEVVUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 17:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244010AbiEVVUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 17:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197B23616E
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 14:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB672B80E08
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 21:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A592C34117;
        Sun, 22 May 2022 21:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653254412;
        bh=JlyfonAc6MfdS1QtClXzrlrw799M8bVJvsJy5QLYYzQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rJ7e+jCQKra3nVw3PvZMPCuHQZEOjHbAeQda6NJiQTYgH3cNWNQXVuOFpfhgnTGfx
         JCgKyklzLBVcO2u3BCpDQdSSNZ/e7KfwSJS1ZkIjlcMLWq7CYaSTTrweYElGdmomrz
         IRPIz8uw//CvHxOj50qu72HZPHox2rzXp3GDzhx8bekxtrt2smISqTOHcvqTQ04ix/
         7y1cy+IwuTxiYd52qwUte4oiG6nh2fK5FaLh5GUDaZu8ofx3TUMGpGCmh3TUF616aE
         U5/DeXN4rLbIj7vHCK1MQOBg8OxLD2AYnVJwAH233f6TIOYTlxqdSpqemQXe8JqVEZ
         hJ8Eafy2vLoiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7157BF03944;
        Sun, 22 May 2022 21:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mscc: ocelot: offload tc action "ok" using an
 empty action vector
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165325441245.2577.13445643226806421128.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 21:20:12 +0000
References: <20220522092701.2991605-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220522092701.2991605-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, colin.foster@in-advantage.com,
        xiaoliang.yang_1@nxp.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 22 May 2022 12:27:01 +0300 you wrote:
> The "ok" tc action is useful when placed in front of a more generic
> filter to exclude some more specific rules from matching it.
> 
> The ocelot switches can offload this tc action by creating an empty
> action vector (no _ENA fields set to 1). This makes sense for all of
> VCAP IS1, IS2 and ES0 (but not for PSFP).
> 
> [...]

Here is the summary with links:
  - [net-next] net: mscc: ocelot: offload tc action "ok" using an empty action vector
    https://git.kernel.org/netdev/net-next/c/4149af28318a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



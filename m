Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E263E644345
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiLFMk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiLFMkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D0820BDA;
        Tue,  6 Dec 2022 04:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BAF0B81A0A;
        Tue,  6 Dec 2022 12:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EAE4C433D7;
        Tue,  6 Dec 2022 12:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670330417;
        bh=v8Lt6RilO6gDs8BUPiYwQaLT4Cim+x/Jp+f6ZXg2BGY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vKlx6ndXF9zqiVNlrrsMw+ApHFu/Ej3rPhk+kkMPps69S1UdY/ELosNbDiG9n+0yu
         71tvGvW7qiG0m8aLCyrW1JqybJcUzcSM3p2dlx562DOYSTGnkKsS3johISlg0I3McL
         4sLcC/kSUHQDm4M9+ctW6QuG+mEewmLzlfVifw6SXT8oXbuXEbimprdmM1SJvV/Tga
         Ku6tdwdsuX+91uWv2XngsbtwCXWSxzTupf77vQRmtWxREb0pxItwEuE8tBsoecHeQY
         ITegYLzdwdqfFPL/rKtDGzeZI7dzhoX3xzoWtFJeUq0znFdqdNR29k1Wtf6WHcscCD
         n5BSpS3Xi8fhQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE2A6C395E5;
        Tue,  6 Dec 2022 12:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] net: lan966x: Enable PTP on bridge interfaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167033041690.5968.18443824551119031476.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 12:40:16 +0000
References: <20221203104348.1749811-1-horatiu.vultur@microchip.com>
In-Reply-To: <20221203104348.1749811-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Steen.Hegelund@microchip.com, lars.povlsen@microchip.com,
        daniel.machon@microchip.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com, olteanv@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 3 Dec 2022 11:43:44 +0100 you wrote:
> Before it was not allowed to run ptp on ports that are part of a bridge
> because in case of transparent clock the HW will still forward the frames
> so there would be duplicate frames.
> Now that there is VCAP support, it is possible to add entries in the VCAP
> to trap frames to the CPU and the CPU will forward these frames.
> The first part of the patch series, extends the VCAP support to be able to
> modify and get the rule, while the last patch uses the VCAP to trap the ptp
> frames.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] net: microchip: vcap: Add vcap_get_rule
    https://git.kernel.org/netdev/net-next/c/610c32b2ce66
  - [net-next,v3,2/4] net: microchip: vcap: Add vcap_mod_rule
    https://git.kernel.org/netdev/net-next/c/2662b3f93d26
  - [net-next,v3,3/4] net: microchip: vcap: Add vcap_rule_get_key_u32
    https://git.kernel.org/netdev/net-next/c/6009b61f80e0
  - [net-next,v3,4/4] net: lan966x: Add ptp trap rules
    https://git.kernel.org/netdev/net-next/c/72df3489fb10

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



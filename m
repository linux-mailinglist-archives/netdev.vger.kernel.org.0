Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A1E63E973
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 06:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLAFuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 00:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLAFuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 00:50:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A8A22BD6;
        Wed, 30 Nov 2022 21:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A275661E79;
        Thu,  1 Dec 2022 05:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1527C433C1;
        Thu,  1 Dec 2022 05:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669873817;
        bh=++z2WwZ4e2gXPupAOsrRtVnM4cW2CwgPBUFRgK480rA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J1Ag0LNhLC16KDFT6dB5s/Spz46b4HnB2DfLMdAbOHetfbxm7laixQF9LF0n52/ak
         +28dQCw9Kc5vWYzl7o1NZAA0/+wVqlXSvJiOhF++KCKW/dFt+ry4SrKr4MPHWJX7cb
         7ke1UgkPFrdEhbmIIfJkPrC2HWhWTAFBU8ijwYpXLNrwCO74t+03Xo4c6l5CBAbjr1
         VOuhYe8x6S1MjhiQlc7ORnigaRnfSYraHSnNuL+9kKmbnFBOImKHCgkfYT/ytWW+XO
         5ioezpmVfrs8BNumsrfCWwJHqoilbFIqbfkl8+VHEL4U2pLCI+Mj990v1LTJ+LLuhb
         aUUvvQ0Gz4Bbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B65AFE270C8;
        Thu,  1 Dec 2022 05:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: microchip: vcap: Change how the rule id is
 generated
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166987381774.9213.6922572894983084029.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 05:50:17 +0000
References: <20221128142959.8325-1-horatiu.vultur@microchip.com>
In-Reply-To: <20221128142959.8325-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, UNGLinuxDriver@microchip.com,
        casper.casan@gmail.com
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

On Mon, 28 Nov 2022 15:29:59 +0100 you wrote:
> Currently whenever a new rule id is generated, it picks up the next
> number bigger than previous id. So it would always be 1, 2, 3, etc.
> When the rule with id 1 will be deleted and a new rule will be added,
> it will have the id 4 and not id 1.
> In theory this can be a problem if at some point a rule will be added
> and removed ~0 times. Then no more rules can be added because there
> are no more ids.
> 
> [...]

Here is the summary with links:
  - [net-next] net: microchip: vcap: Change how the rule id is generated
    https://git.kernel.org/netdev/net-next/c/c1d8e3fb1a3b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



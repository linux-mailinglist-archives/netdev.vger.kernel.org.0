Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16753515CE4
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 14:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353594AbiD3Mdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 08:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240638AbiD3Mdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 08:33:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB6660D9;
        Sat, 30 Apr 2022 05:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 638BA60B29;
        Sat, 30 Apr 2022 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B96BCC385AF;
        Sat, 30 Apr 2022 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651321811;
        bh=TNwRjjaZtTXUA+rKES33JT5EjS9KBENobC9GoKco64M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=deMujOuzAlh5ONdUI1a3avYrWVkzjRDOhzA+3MRvpr97WOf2uthmncsU1KtJlgvgk
         y4diCzTeKzxOTC/3xH9nseDtJSubteNbrEK4nOtm94j/P4niYvAJ/Arny0wouVoJ3C
         hVwIvrz8ZQ65KGAv7FV3gUISRhEh4yQM4Iktrn6CP4GeruIrPpxbbHJjIlEsN2hnbz
         UOOSQ+whQVydZzwLtIfUFiEv9wOThT6kYaAJ0ja0eZWTNlurszojds3SyhIHOp0ESz
         4TPXMEH0JbHXALNZV4F0VUXdRX81ueZjCo/uQOGuDdGdeJOpRF/Yr2PZqleh9MtZlc
         30JREaWapslXQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F9C1F03847;
        Sat, 30 Apr 2022 12:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: lan966x: remove PHY reset support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165132181158.22225.4698610186663844622.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 12:30:11 +0000
References: <20220428114049.1456382-1-michael@walle.cc>
In-Reply-To: <20220428114049.1456382-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, horatiu.vultur@microchip.com,
        UNGLinuxDriver@microchip.com, p.zabel@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Apr 2022 13:40:47 +0200 you wrote:
> Remove the unneeded PHY reset node as well as the driver support for it.
> 
> This was already discussed [1] and I expect Microchip to Ack on this
> removal. Since there is no user, no breakage is expected.
> 
> I'm not sure it this should go through net or net-next and if the patches
> should have a Fixes: tag or not. In upstream linux there was never any user
> of it, so there is no bug to be fixed. But OTOH if the schema fix isn't
> backported, then there might be an older schema version still containing
> the reset node. Thoughts?
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dt-bindings: net: lan966x: remove PHY reset
    https://git.kernel.org/netdev/net-next/c/4fdabd509df3
  - [net-next,2/2] net: lan966x: remove PHY reset support
    https://git.kernel.org/netdev/net-next/c/5b06ef86826a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



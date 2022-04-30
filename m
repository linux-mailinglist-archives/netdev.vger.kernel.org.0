Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F398D515953
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 02:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381874AbiD3Adm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 20:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbiD3Adm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 20:33:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415BC10CF;
        Fri, 29 Apr 2022 17:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF7216243B;
        Sat, 30 Apr 2022 00:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55C82C385A7;
        Sat, 30 Apr 2022 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651278612;
        bh=w0Kb+JlJ3YxNGv5ZHU4i/iB27lhjEWCRLy/t4cz2zkw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GKqgCMX1B7PWxKbYl2J15HZssGuOcACluqIz9H7FoeAjvL9ea8Uph0T4l5ROiXVNE
         v5uVaEVKU4xBWNYjJHO9raXtbvNJZv83YW/ZxYvsuzvvEP/TH+hHCKrTKDErU9i/a7
         hBSssnWHpJcguyBF5R3DqeboUQqr5wAmz/ydv4R5Hoj522N6DWp6Q2ERe4jy5dMKiH
         fR6wLTHNmUmiCgPGz7w09oBUZQj1z945bkecoSp+hzFJLfSVLlhD+jcTPhMOptDFhN
         BKu1VZJX0Ze4eLqGK7p7vPnYzIRjVJrTi8HhM/fa+RP8Ywq5c9fBqqRZJ3/EwRpXwg
         0Ug/ent6FiILQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3270DF0383D;
        Sat, 30 Apr 2022 00:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 0/3] net: phy: micrel: add coma mode support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165127861220.13084.9227966291421298377.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 00:30:12 +0000
References: <20220427214406.1348872-1-michael@walle.cc>
In-Reply-To: <20220427214406.1348872-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Apr 2022 23:44:03 +0200 you wrote:
> Add support to disable coma mode by a GPIO line.
> 
> Michael Walle (3):
>   dt-bindings: net: micrel: add coma-mode-gpios property
>   net: phy: micrel: move the PHY timestamping check
>   net: phy: micrel: add coma mode GPIO
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/3] dt-bindings: net: micrel: add coma-mode-gpios property
    https://git.kernel.org/netdev/net-next/c/749c61e5b30a
  - [net-next,v1,2/3] net: phy: micrel: move the PHY timestamping check
    https://git.kernel.org/netdev/net-next/c/31d00ca4ce0e
  - [net-next,v1,3/3] net: phy: micrel: add coma mode GPIO
    https://git.kernel.org/netdev/net-next/c/738871b09250

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



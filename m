Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F8351161F
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 13:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiD0LX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 07:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiD0LX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 07:23:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317F830F55;
        Wed, 27 Apr 2022 04:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D44ADB8261B;
        Wed, 27 Apr 2022 11:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64265C385AA;
        Wed, 27 Apr 2022 11:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651058412;
        bh=l53XzaWwKba3OJW6HFGuebym4/RWTvktNA+PgO3IgHE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ucdokk1b9Bx01ozICt01o0aEmWJxdHNoWij09FFFaYICrGv8rAlH+BpGkter3peOI
         ktLj3AR4YJspEvkwIGeaUrx/xw7Sh5Z9eGINYAS+ZP/puMfnFO9LUprA1V770EXPxa
         13NOCczXBJU9dcpWO2gSXzWMsOtpKaNlWOGJhCwZTcrwRbx5DYp/1jGd5OzMDNL45v
         9JZu0oPhZd6oTH5sjeq9Qvei7NW+JqMgdTjDXS9XQEIxBv5MtyX/rXfw1lksImqeos
         3Uh7yxKcBDf+hpYS7rCP/4+xkbdSv7R9/AoshJhTpXagRx19a6p4s4AzEPwZ2F6SbS
         SR+LirWTbODOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47353E5D087;
        Wed, 27 Apr 2022 11:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] net: lan966x: Add support for PTP
 programmable pins
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165105841228.27586.15571101022871593482.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 11:20:12 +0000
References: <20220427065127.3765659-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220427065127.3765659-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, UNGLinuxDriver@microchip.com,
        richardcochran@gmail.com
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

On Wed, 27 Apr 2022 08:51:22 +0200 you wrote:
> Lan966x has 8 PTP programmable pins. The last pin is hardcoded to be used
> by PHC0 and all the rest are shareable between the PHCs. The PTP pins can
> implement both extts and perout functions.
> 
> v1->v2:
> - use ptp_find_pin_unlocked instead of ptp_find_pin inside the irq handler.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] dt-bindings: net: lan966x: Extend with the ptp external interrupt.
    https://git.kernel.org/netdev/net-next/c/c1a519919d04
  - [net-next,v2,2/5] net: lan966x: Change the PTP pin used to read/write the PHC.
    https://git.kernel.org/netdev/net-next/c/77f2accb501a
  - [net-next,v2,3/5] net: lan966x: Add registers used to configure the PTP pin
    https://git.kernel.org/netdev/net-next/c/3adc11e5fc5f
  - [net-next,v2,4/5] net: lan966x: Add support for PTP_PF_PEROUT
    https://git.kernel.org/netdev/net-next/c/2b7ff2588ec2
  - [net-next,v2,5/5] net: lan966x: Add support for PTP_PF_EXTTS
    https://git.kernel.org/netdev/net-next/c/f3d8e0a9c28b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



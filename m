Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B61960C292
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 06:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiJYEU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 00:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiJYEUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 00:20:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826B29B840;
        Mon, 24 Oct 2022 21:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21A2E61716;
        Tue, 25 Oct 2022 04:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A23AC433B5;
        Tue, 25 Oct 2022 04:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666671623;
        bh=R9BvFUzyKbsbhLmesEyNT5dPBM6rnz8sqaKUMfXrKtE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S79n2CFhE+Z3j0cWmDBXDsRW0iSTcMgNTAc/RsAI/Jg4WpjXckV9zP+j88f5SK8/X
         KV+hBtA88VZJVL9XqwMfRXvT0wi8OyGyoBpOpBFXK52orziiu7Xphjsx8h0sOX/xr3
         RMAVEjCktZtAzjMN9jP+pSv5FSg3QV+M0N/2YtexagtIWxIxDADLUy4OVWBLv/jeWn
         fH+MtWY9pOejLbd/k4bVnOretcfeTP7vkBg3iewdz9dtTgtljNEQRElw5PMkXk9rFv
         Fx/24knh5oKS4VQZmbaF1SxT+mR4RD8jhggJjdTocL/Zkmg+ghnIqMgsRczmLn1/n/
         M55dtZs5DHMng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CD21E29F30;
        Tue, 25 Oct 2022 04:20:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/7] net: sfp: improve high power module
 implementation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166667162324.8210.9772168919348975383.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 04:20:23 +0000
References: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
In-Reply-To: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        devicetree@vger.kernel.org, edumazet@google.com,
        hkallweit1@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, pabeni@redhat.com, robh+dt@kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 21 Oct 2022 16:08:29 +0100 you wrote:
> Hi,
> 
> This series aims to improve the power level switching between standard
> level 1 and the higher power levels.
> 
> The first patch updates the DT binding documentation to include the
> minimum and default of 1W, which is the base level that every SFP cage
> must support. Hence, it makes sense to document this in the binding.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] dt-bindings: net: sff,sfp: update binding
    https://git.kernel.org/netdev/net-next/c/a272bcb9e5ef
  - [net-next,2/7] net: sfp: check firmware provided max power
    https://git.kernel.org/netdev/net-next/c/02eaf5a79100
  - [net-next,3/7] net: sfp: ignore power level 2 prior to SFF-8472 Rev 10.2
    https://git.kernel.org/netdev/net-next/c/18cc659e95ab
  - [net-next,4/7] net: sfp: ignore power level 3 prior to SFF-8472 Rev 11.4
    https://git.kernel.org/netdev/net-next/c/f8810ca75829
  - [net-next,5/7] net: sfp: provide a definition for the power level select bit
    https://git.kernel.org/netdev/net-next/c/398900498485
  - [net-next,6/7] net: sfp: add sfp_modify_u8() helper
    https://git.kernel.org/netdev/net-next/c/a3c536fc7580
  - [net-next,7/7] net: sfp: get rid of DM7052 hack when enabling high power
    https://git.kernel.org/netdev/net-next/c/bd1432f68ddc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



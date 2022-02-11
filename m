Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7FB4B251C
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349789AbiBKMAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:00:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbiBKMAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:00:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE030E6D
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 04:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 794A461B6C
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 12:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9C27C340F3;
        Fri, 11 Feb 2022 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644580813;
        bh=qQQQ5xyZZSqxESLO2FmXAPc/MP7UBuJKnbzSl74FZtI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q4CCo5qACSrO7xMRv7gRWF59ZKzfG1IZ/dOBFr8YbBq3hOsStmmrEPYq99hJBPgCd
         I7rXpRCxUKgnEJM9ORQ/xHxrVIMzDZoGjq/jRI4uLaejNJ6Mu4GRhNKie2kkSC2LHH
         7SHGr7mK5h5alMCnma6HxcCbhfd9EY1b2Id/UqFyp8/ZELD87BZEPRCiyQqb2obN50
         4Rn+zwC8l1O16WG4PNoMs++fyuXltTyuRFnb4QzAEfmIcNe7SoirnuJNEOA1PutZKU
         nYZjqtBkTc1MtwEO2rguGy11AppuyjB2iYdyfwumvRcELgOVbpp8RPAtXCBtA/uCqz
         rETD80MnVvqxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B916DE6D3DE;
        Fri, 11 Feb 2022 12:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 1/2] dt-bindings: phy: Add `tx-p2p-microvolt` property
 binding
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164458081375.17283.18070555669510980703.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Feb 2022 12:00:13 +0000
References: <20220210174823.15488-1-holger.brunck@hitachienergy.com>
In-Reply-To: <20220210174823.15488-1-holger.brunck@hitachienergy.com>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, kabel@kernel.org,
        robh@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Feb 2022 18:48:22 +0100 you wrote:
> From: Marek Behún <kabel@kernel.org>
> 
> Common PHYs and network PCSes often have the possibility to specify
> peak-to-peak voltage on the differential pair - the default voltage
> sometimes needs to be changed for a particular board.
> 
> Add properties `tx-p2p-microvolt` and `tx-p2p-microvolt-names` for this
> purpose. The second property is needed to specify the mode for the
> corresponding voltage in the `tx-p2p-microvolt` property, if the voltage
> is to be used only for speficic mode. More voltage-mode pairs can be
> specified.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dt-bindings: phy: Add `tx-p2p-microvolt` property binding
    https://git.kernel.org/netdev/net-next/c/066c4b6ba063
  - [net-next,2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude configurable
    https://git.kernel.org/netdev/net-next/c/926eae604403

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB214DCB91
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbiCQQla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiCQQl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:41:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF5816F6C9
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09F906149B
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 16:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E402C340F4;
        Thu, 17 Mar 2022 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647535211;
        bh=3c0VfFe+ua7imjQZDfxkqGox3cYcQmiOGZ4snjWgMeM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aJQB0aYdeR+nuCwnEsPSzhxkeCjUHJMpLPFhv+HsaAxcdjGOgZEnF/PUk9IvGgk/x
         oeniUFvApiLknNe/GL5cWvjNxOWsBEjVD48HufhI3j3TOV8MIza+lNhEdxg+aTpn3z
         6384rZqght2djqAwQq9RO2PqGy16jMkKbbvivlvECBVW8XDXZNgyku/62RfPvupsy6
         rVqjYioU6CUOVfExjBp713mkr2aVdt3lTX+dfnYWqCgFxLra73Q16qWXh0WVLnDZIm
         zW44j3I6ci3PvZDhcqNo4zm+bVRRjeZ3G8FQ8cKGrrKcYbdzvqvpPWqj0ZMFUC3UY2
         Llg49jysojkAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4739AF03842;
        Thu, 17 Mar 2022 16:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mscc: ocelot: fix backwards compatibility with
 single-chain tc-flower offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164753521128.23544.9613748654792250011.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 16:40:11 +0000
References: <20220316192117.2568261-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220316192117.2568261-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Mar 2022 21:21:17 +0200 you wrote:
> ACL rules can be offloaded to VCAP IS2 either through chain 0, or, since
> the blamed commit, through a chain index whose number encodes a specific
> PAG (Policy Action Group) and lookup number.
> 
> The chain number is translated through ocelot_chain_to_pag() into a PAG,
> and through ocelot_chain_to_lookup() into a lookup number.
> 
> [...]

Here is the summary with links:
  - [net] net: mscc: ocelot: fix backwards compatibility with single-chain tc-flower offload
    https://git.kernel.org/netdev/net/c/8e0341aefcc9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



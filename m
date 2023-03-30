Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10636D0DF2
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjC3Skp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbjC3Sko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:40:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035FDEC65
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C3AF6216E
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 18:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1526C4339B;
        Thu, 30 Mar 2023 18:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680201618;
        bh=bZJSyn6tIdhhYnh2e3n0vldy5ytS/wAx+JtkYR6w68M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cio6PkPaAKoWmosDNxOY/ZbKHx5bbounxz/ND7bwLLsIUyXK9BZ9NM78k3vZzJOE2
         DQ/0Y6aTzvuv5CXTFD1tWhphXp8BOV7NdOFSuxbV/STf5VG/dnq+9AWsS2NgO9/ZSr
         6o4QAbotSa0CtIDniPlDITUKyHQrg3wugx4c+WTSVwobzxgjmqT8Re3f+gMEwU2lTI
         SBF9qoj/d7ThLqC4dlRzvW/DuDr0DeUAsMscG+cjR+tYPUUypgcNQxrjs0JpANE5/B
         tflk8bWdvJ489eVgCsMhVbavFYgN+czarAWKXukbW6NYNqcVfAN/LUE1VCMNwCaKlN
         e+Ah0hmUacECA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CAFFFE21EDD;
        Thu, 30 Mar 2023 18:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Enable IGMP snooping on user ports
 only
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168020161781.2203.8770484978086197428.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 18:40:17 +0000
References: <20230329150140.701559-1-festevam@gmail.com>
In-Reply-To: <20230329150140.701559-1-festevam@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, olteanv@gmail.com,
        netdev@vger.kernel.org, steffen@innosonix.de, festevam@denx.de
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Mar 2023 12:01:40 -0300 you wrote:
> From: Steffen Bätz <steffen@innosonix.de>
> 
> Do not set the MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP bit on CPU or DSA ports.
> 
> This allows the host CPU port to be a regular IGMP listener by sending out
> IGMP Membership Reports, which would otherwise not be forwarded by the
> mv88exxx chip, but directly looped back to the CPU port itself.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only
    https://git.kernel.org/netdev/net/c/7bcad0f0e6fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E9351E3EA
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 06:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244223AbiEGEOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 00:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445485AbiEGEOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 00:14:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FF1658E
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 21:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C6C660A6A
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 04:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D487CC385A5;
        Sat,  7 May 2022 04:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651896614;
        bh=uhyzM1ByeVrSJBnltjpOPpym3ovoigQTWRipg13WCtE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rdiXXObUTqo59/301kAVb+8LR8v1LX2omBmBCBPR0UoiN9qKxT8wRJN7YnMU5U8bI
         kUL1Hn86N5AN/vksE7AlMEGtVDxonN2lV4y9YRQ0q7863paimexFHYfJtZlgFAN4PA
         o2wT8tj6zR2dss9fpiF1qjuYZxEEJGQxmdVwnohxmwQvHyRnHeM/itX5iAaA/Lef/g
         J1zk1SlXyHOskNhPfedLVDdlC+R65S56nl6HJyRngkMaLKwQNZkP0yu+P3s593edHR
         RD1epsWoafVrtZPG2jAwHpHp+5EpjOcZdU+PlSs8reF+C1v0tcXtBB7lGrdaSKHtyV
         Gg9CwoEiRo6hg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A44EEEAC081;
        Sat,  7 May 2022 04:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] mlxbf_gige: increase MDIO polling rate to 5us
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165189661466.31844.9350262318044387647.git-patchwork-notify@kernel.org>
Date:   Sat, 07 May 2022 04:10:14 +0000
References: <20220505162309.20050-1-davthompson@nvidia.com>
In-Reply-To: <20220505162309.20050-1-davthompson@nvidia.com>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org, asmaa@nvidia.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 5 May 2022 12:23:09 -0400 you wrote:
> This patch increases the polling rate used by the
> mlxbf_gige driver on the MDIO bus.  The previous
> polling rate was every 100us, and the new rate is
> every 5us.  With this change the amount of time
> spent waiting for the MDIO BUSY signal to de-assert
> drops from ~100us to ~27us for each operation.
> 
> [...]

Here is the summary with links:
  - [net-next,v1] mlxbf_gige: increase MDIO polling rate to 5us
    https://git.kernel.org/netdev/net-next/c/0a02e282bad4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



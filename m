Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3695BD924
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiITBKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiITBK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:10:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80FC4CA07;
        Mon, 19 Sep 2022 18:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15BFEB822B3;
        Tue, 20 Sep 2022 01:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C98D2C433D7;
        Tue, 20 Sep 2022 01:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636220;
        bh=a9OerAIw11joib6k3IYr0elkmPfN/0gWPfeQUQFnQ3k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EgHb824Cjs1axeMw+7VCQdEc3ZNzvAmpRlKcnkei9hVyRp6Gv63QSUDICfZH6I3+c
         eYsrKd4eMgUQZgzUfbGvgIzjul/l2biFIBHm24ABGUbX2kDN38RiPCM/by003ik7l0
         LsifeZlJocZjDMyYoK6hF09GlePkoRHd/2lS2y2xPDicU6si4wbjZeG7A8//m6Jm+T
         A8A+bWqEDkVHSjRzt19brTMO1WDLV/uEHhMb2tVnTDSvtL2H9Wr3rclC0CcqFwySi4
         lf0/4ndZ14dwAUdrIOgdW/g1oS/OBiIaaH+TqQTIRq4diFkNb6GlYmuZ9vj+msuA1u
         AOH90FSUKKlqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4E34E52536;
        Tue, 20 Sep 2022 01:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Standardized ethtool counters for NXP ENETC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363622073.23429.15716129925198304336.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:10:20 +0000
References: <20220909113800.55225-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220909113800.55225-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiaoliang.yang_1@nxp.com,
        claudiu.manoil@nxp.com, richard.pearn@nxp.com,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Sep 2022 14:37:58 +0300 you wrote:
> This is another preparation patch for the introduction of MAC Merge
> Layer statistics, this time for the enetc driver (endpoint ports on the
> NXP LS1028A). The same set of stats groups is supported as in the case
> of the Felix DSA switch.
> 
> Vladimir Oltean (2):
>   net: enetc: parameterize port MAC stats to also cover the pMAC
>   net: enetc: expose some standardized ethtool counters
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: enetc: parameterize port MAC stats to also cover the pMAC
    https://git.kernel.org/netdev/net-next/c/e2bd065c3b22
  - [net-next,2/2] net: enetc: expose some standardized ethtool counters
    https://git.kernel.org/netdev/net-next/c/38b922c91227

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



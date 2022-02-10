Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C57A4B16A8
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 21:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244158AbiBJUAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 15:00:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241342AbiBJUAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 15:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151D35F4F
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 12:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1877B8273E
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 20:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04FC7C340ED;
        Thu, 10 Feb 2022 20:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644523211;
        bh=tWD8zN57UW5hP5NkHcaPnfT74EgHkQFCscL/bUrQaL8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ctmF2A4BauZ/+hvuNwGg4YhWY/UylfoAsfizTCYvnG4NGcfd7hbYY6ATDgmDgtrAb
         j4S3XF6akNEjmQ2u0pRrdj3tax8G23gqnps32OnrzsdA5hRaFxgCdaP+N9PtRaob0D
         wVav7/xW2/IyEbbqEr+dk6ogYPbN8O3jkO0oDv7bRnvTLxVF1rdbRTdxwVui05PC4x
         Re+fTIMpI76O8VSpBhqwdUWHdvrMLoHJDFWzPw2wnmWnQYVySqH6uKEg2Zady0WAnA
         ZhUNEF05dh8ugRZjGGAeDuuj5D6IDRvp+PsLeoQyKMVIbSw9eqaPYRnzRa/f/OGuQ/
         JFnESSwMj0Xsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E060AE6D4A1;
        Thu, 10 Feb 2022 20:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: fix use-after-free in
 mv88e6xxx_mdios_unregister
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164452321091.17968.16088246642739956763.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 20:00:10 +0000
References: <20220210174017.3271099-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220210174017.3271099-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, rafael.richter@gin.de, daniel.klauer@gin.de
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Feb 2022 19:40:17 +0200 you wrote:
> Since struct mv88e6xxx_mdio_bus *mdio_bus is the bus->priv of something
> allocated with mdiobus_alloc_size(), this means that mdiobus_free(bus)
> will free the memory backing the mdio_bus as well. Therefore, the
> mdio_bus->list element is freed memory, but we continue to iterate
> through the list of MDIO buses using that list element.
> 
> To fix this, use the proper list iterator that handles element deletion
> by keeping a copy of the list element next pointer.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mv88e6xxx: fix use-after-free in mv88e6xxx_mdios_unregister
    https://git.kernel.org/netdev/net/c/51a04ebf2112

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



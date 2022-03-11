Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7590E4D6068
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 12:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347823AbiCKLLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 06:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiCKLLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 06:11:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78D118621B;
        Fri, 11 Mar 2022 03:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43FC261B79;
        Fri, 11 Mar 2022 11:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B380C340F4;
        Fri, 11 Mar 2022 11:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646997014;
        bh=UT+YDrzJ8XesdyaHuwwzp4zSUTpngFBe7etq5SdMyqw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H/IrtdXKTDIlfW4SsJjcQCfO7+VRQY8fPnNQuVJ+DbQf5MiLOyOPnheReuFXxa92I
         F1AEr3nCliQvgF1je0I/urt44oB6TBDyBwa+0Ljc5HCsGcFaPpYLW+bfsqU927HDYi
         FdLTOflkYI2rFrJytXneeElUgbZaaLGDHakEyNrT2uLUBVZqimDAN7Ca6EXPFuE3CZ
         jQ5fMN4S+/6OjULGcPc5E26odEZ27g1v9B9SQ7CBO69GM8GmpxhptxVuKi8627r/QG
         Jq3QtZGPjcV3OsToO39Hh/cSrGE3bBXCUaeuVDeIexG7zXfqWwHe4fhAObrznb/gAh
         ez+cdF/29lX/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D4F1E6D3DD;
        Fri, 11 Mar 2022 11:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ethernet: ti: am65-cpsw: Convert to PHYLINK
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164699701451.2968.3028481229273193299.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 11:10:14 +0000
References: <20220309075944.32166-1-s-vadapalli@ti.com>
In-Reply-To: <20220309075944.32166-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, vigneshr@ti.com, grygorii.strashko@ti.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Wed, 9 Mar 2022 13:29:44 +0530 you wrote:
> Convert am65-cpsw driver and am65-cpsw ethtool to use Phylink APIs
> as described at Documentation/networking/sfp-phylink.rst. All calls
> to Phy APIs are replaced with their equivalent Phylink APIs.
> 
> No functional change intended. Use Phylink instead of conventional
> Phylib, in preparation to add support for SGMII/QSGMII modes.
> 
> [...]

Here is the summary with links:
  - [v2] net: ethernet: ti: am65-cpsw: Convert to PHYLINK
    https://git.kernel.org/netdev/net-next/c/e8609e69470f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



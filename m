Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E891859F915
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbiHXMKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236053AbiHXMKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4888F3CBCA;
        Wed, 24 Aug 2022 05:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7E7461978;
        Wed, 24 Aug 2022 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D5C0C43144;
        Wed, 24 Aug 2022 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661343017;
        bh=PkVdSo4pnuWMMJjVjFXu9ZGeQQUgZxZC5otX0MCCf2w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gVUiSWtSCSbjC3+C8OyBKTc3nZ+Oy9fvXedyX/l7RVQeJ/OQLyGy8PSTrHfEb6lJX
         2lN0MmwGVs59zTB4Kh4oke41lLwwNltN7RELGeor9/BCpX++ove6yNMQqfL97nshmO
         fzGTwy5/fbY/NxfgrLSjlszKjJ2Gql5qHzlezAHZ0CUsqEgjGdZ/lVBP/K/K1O2hIp
         7toQnihnPXgW9egK7JrXfBIn7eXtxnCEUaxClQvT5FrMRDIBml1CaELe/L0o4j+Brl
         1xUioKiU96wj7asGFnt/WDZP5cSAt3r0XscZmoJ3faSxb4WFhHYMyUK9olIT91qWHJ
         mLAaaP9Bfq5gQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1CDD2E2A03C;
        Wed, 24 Aug 2022 12:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] micrel: ksz8851: fixes struct pointer issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166134301711.8334.15216665637776829191.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 12:10:17 +0000
References: <20220822213932.12848-1-jerry.ray@microchip.com>
In-Reply-To: <20220822213932.12848-1-jerry.ray@microchip.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Aug 2022 16:39:32 -0500 you wrote:
> Issue found during code review. This bug has no impact as long as the
> ks8851_net structure is the first element of the ks8851_net_spi structure.
> As long as the offset to the ks8851_net struct is zero, the container_of()
> macro is subtracting 0 and therefore no damage done. But if the
> ks8851_net_spi struct is ever modified such that the ks8851_net struct
> within it is no longer the first element of the struct, then the bug would
> manifest itself and cause problems.
> 
> [...]

Here is the summary with links:
  - micrel: ksz8851: fixes struct pointer issue
    https://git.kernel.org/netdev/net-next/c/fef5de753ff0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



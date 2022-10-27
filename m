Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BA561006D
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbiJ0SkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbiJ0SkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944E910B54;
        Thu, 27 Oct 2022 11:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4754BB82762;
        Thu, 27 Oct 2022 18:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DEBF1C433C1;
        Thu, 27 Oct 2022 18:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666896017;
        bh=5Ci6ZUqYtCVT5GXsTDVEvoE9+O7nPDOSCll8y54KQr0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WfESKa6JGawOt/6ivZcVZIks7tmxQEl6ceNKn3GmgEWXdpsddMBpHy+YGYzomUsst
         5T+WRYBYIx69EwJLKbZJvvOuE7U6CSWukBw8cfrdoMvaeMXC21Os672kJvHH8Bvy4k
         muvpJO7LtDf3M7ADgbUCeO3frbh3baezQoQrkZB01FFZfU5+kMF/+O4xgZCYWYqj0W
         bf8OviOIFvHHAnYJQzHBDLVgFn6aUvE59faWmvTFTvEWQkVfQlER7OaNxsVMV7qK3Z
         Mu3BmLU2wjC3EeGUaZnP8W5J7Zmp/r95AKskkgWUzb6T4ziwRK4Lkd/VDapCCbcKTd
         MtLEyUjlo6Q3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BEE8FE270D9;
        Thu, 27 Oct 2022 18:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] net: enetc: survive memory pressure without crashing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166689601777.10145.516219090258177018.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 18:40:17 +0000
References: <20221027182925.3256653-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221027182925.3256653-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Oct 2022 21:29:25 +0300 you wrote:
> Under memory pressure, enetc_refill_rx_ring() may fail, and when called
> during the enetc_open() -> enetc_setup_rxbdr() procedure, this is not
> checked for.
> 
> An extreme case of memory pressure will result in exactly zero buffers
> being allocated for the RX ring, and in such a case it is expected that
> hardware drops all RX packets due to lack of buffers.
> 
> [...]

Here is the summary with links:
  - [v3,net] net: enetc: survive memory pressure without crashing
    https://git.kernel.org/netdev/net/c/84ce1ca3fe9e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



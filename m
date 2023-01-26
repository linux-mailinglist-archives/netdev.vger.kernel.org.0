Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F075F67C4E6
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjAZHaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbjAZHaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC1C65EFA;
        Wed, 25 Jan 2023 23:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B23EB81D0C;
        Thu, 26 Jan 2023 07:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE86FC4339C;
        Thu, 26 Jan 2023 07:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674718216;
        bh=YnYWB3x55mMTUNnUE9DhqZgIZJ2l4QVcj3NAixK6vpo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QdUQ0eHDiNIX8yz6rNLnfFLyf/PWhvIzDKh/a5xj9VAVuHjnnZ3HSaDRvzea9zE7I
         UYhQseaLar/mhxMHkWd3tYFjSHUXPhTSFjiAFu6FZ40Ft96bJnNIzXbnW0HLKdA0iS
         XvVoxT8PRMBZ02IuY49icQA/GBo1+mggMISsmm4vRJ9U35/mr5lQZR0uwrXXoUBM45
         zrDAyMRGiAlUpDdCIxwyiDmTXXFq8sh7hOpw7A+OaBzLoVMm2SRBCxPV2A4zjhZ45t
         iQAISa50G+187Ij9ym5Rfood24UzxspUOfID2HeGigzShkoFNGYz6Ym/Tk91rgRbtK
         Zl28b93uUdniA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF884F83ED3;
        Thu, 26 Jan 2023 07:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: mdio-mux-meson-g12a: force internal PHY off on
 mux switch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167471821678.31738.7019222500176784682.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Jan 2023 07:30:16 +0000
References: <20230124101157.232234-1-jbrunet@baylibre.com>
In-Reply-To: <20230124101157.232234-1-jbrunet@baylibre.com>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        linux-amlogic@lists.infradead.org, khilman@baylibre.com,
        neil.armstrong@linaro.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, qi.duan@amlogic.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 24 Jan 2023 11:11:57 +0100 you wrote:
> Force the internal PHY off then on when switching to the internal path.
> This fixes problems where the PHY ID is not properly set.
> 
> Fixes: 7090425104db ("net: phy: add amlogic g12a mdio mux support")
> Suggested-by: Qi Duan <qi.duan@amlogic.com>
> Co-developed-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> 
> [...]

Here is the summary with links:
  - [v2,net] net: mdio-mux-meson-g12a: force internal PHY off on mux switch
    https://git.kernel.org/netdev/net/c/7083df59abbc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



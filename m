Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0E4688EFA
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 06:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbjBCFa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 00:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjBCFa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 00:30:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4721A2201A;
        Thu,  2 Feb 2023 21:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B07BCCE2E88;
        Fri,  3 Feb 2023 05:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CBA45C4339B;
        Fri,  3 Feb 2023 05:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675402222;
        bh=SMrsyIbBFw0RcwONV0sKn6dinYqSsHt3OnKkxzdwmCQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UtMW4HjyYUsjNLiHn9/EZC2D7jh44BpU8KXJPdzUZNp7cczFZ4LaEDwb2FUJ9T4cM
         S76rCkJ+O8cQxGrbAUj0avHWLlJqXVqNEZjADqh5wZ1hVDyptjH2xA1pTSwmiFaF4Z
         oN5kV2Ahq8LomealrZiWXbTwYIT9UlszBccXtn8p85crsiIxQ+PGb2K4i+twdsw0fU
         Dcg15rrREyZHSfQTaTtuqBtY6siNn+QuTKm2c8uoXNSSDKAYmMWnf+8VPYnxj2y2lk
         CMyFK8FUuFBBr93+LBh2D8t0kOM0pA+4e98Nw5io3ysN0TfIlXyvaOVUQWCnCgVig+
         NqfEHfgDNeh0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A65BCE21ED1;
        Fri,  3 Feb 2023 05:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 1/2] net: fec: restore handling of PHY reset line as
 optional
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167540222267.591.3982135485284835075.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Feb 2023 05:30:22 +0000
References: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
In-Reply-To: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     wei.fang@nxp.com, kuba@kernel.org, andrew@lunn.ch, arnd@arndb.de,
        shenwei.wang@nxp.com, xiaoning.wang@nxp.com, linux-imx@nxp.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        mkl@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  1 Feb 2023 13:53:19 -0800 you wrote:
> Conversion of the driver to gpiod API done in 468ba54bd616 ("fec:
> convert to gpio descriptor") incorrectly made reset line mandatory and
> resulted in aborting driver probe in cases where reset line was not
> specified (note: this way of specifying PHY reset line is actually
> deprecated).
> 
> Switch to using devm_gpiod_get_optional() and skip manipulating reset
> line if it can not be located.
> 
> [...]

Here is the summary with links:
  - [v3,1/2] net: fec: restore handling of PHY reset line as optional
    https://git.kernel.org/netdev/net-next/c/d7b5e5dd6694
  - [v3,2/2] net: fec: do not double-parse 'phy-reset-active-high' property
    https://git.kernel.org/netdev/net-next/c/0719bc3a5c77

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



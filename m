Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAF46258B2
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 11:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbiKKKuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 05:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbiKKKuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 05:50:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0485F94
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 02:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66992B8258F
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDA60C433D7;
        Fri, 11 Nov 2022 10:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668163815;
        bh=xcPNVIizDapKc4iT4dhRR3+2QBFgWCYmFvOGLcC50+M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EaTg6UvShe1vJQRPM+u3Slvvs9K3RIHOI/s1KCrRgYCLh4DfCXOSJtaXktYddt+HG
         O3yBs96qDrPLUhieDZ+L4TcFyG+fSTGGFkLGuIwMi0/dHWsG/hfOzkDwtSKOPEIpTn
         fIF+H1gh9UQFBMJ/zaWfDxoga8rQnt8POSc/vZfBt1dkRd/1FZ3AFFBT2j4PzFH8O3
         ROk8G8JPX/OwVRTvw4oeTKRfqNxShyhnmM/jqdqMCi4TQPw3GnhBWh05YcJqIQJIG3
         V7eE0PwdvcQTUZhs/fujCwUOXEdayOxzoujjQypZCTRyqXJ+pG+XJAS/N0BBRDhsAa
         Mmfh86WOxTBYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9E45E270C6;
        Fri, 11 Nov 2022 10:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: change eeprom length to max length enumerators
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166816381482.5678.1863894259321677243.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Nov 2022 10:50:14 +0000
References: <20221109202757.147024-1-simon.horman@corigine.com>
In-Reply-To: <20221109202757.147024-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        jaco.coetzee@corigine.com, louis.peens@corigine.com
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
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Nov 2022 15:27:57 -0500 you wrote:
> From: Jaco Coetzee <jaco.coetzee@corigine.com>
> 
> Extend the size of QSFP EEPROM for types SSF8436 and SFF8636
> from 256 to 640 bytes in order to expose all the EEPROM pages by
> ethtool.
> 
> For SFF-8636 and SFF-8436 specifications, the driver exposes
> 256 bytes of EEPROM data for ethtool's get_module_eeprom()
> callback, resulting in "netlink error: Invalid argument" when
> an EEPROM read with an offset larger than 256 bytes is attempted.
> 
> [...]

Here is the summary with links:
  - [net] nfp: change eeprom length to max length enumerators
    https://git.kernel.org/netdev/net/c/f3a72878a3de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



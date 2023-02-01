Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF39685ED6
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjBAFUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjBAFUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:20:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D629715CBC;
        Tue, 31 Jan 2023 21:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F619B82081;
        Wed,  1 Feb 2023 05:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A351C4339B;
        Wed,  1 Feb 2023 05:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675228818;
        bh=SNDkwvktwMB6hGwtfdb89+BZQ5kt9sv25XcqeIWOYl8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k0wFyiC/Vr0bqslGZf1/s8ReGxrsVweGwva2KgbhJmqhLixc93eJ3fCTGFwWlgqtv
         f1oVBSf1mXbj9ysle6yMWdkmTW1mmcXcFmXMKangPmM2OyqMm8qwRejIC7LXFLZaUf
         1v6rIp+UEI7TLG/PnkRcQL0+XkpPUDhQ367Xudbobcs3DceCpcktO68DQVUrRvXf42
         SbnWLjwUO+vp4S9T7ZIvZ0/FEKJhTSDlAoexT2lwnMPvhTu94H9ZG1va9QSYB2em79
         LXUTuS4T/cJloqJrIYTpvDx2GgvIE0FPLY756MDRAyiy84Jx0y5bv6C16CVqaFhtcc
         FQl/steRYy0pg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A98EE270CC;
        Wed,  1 Feb 2023 05:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: phy: meson-gxl: Add generic dummy stubs for MMD
 register access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167522881803.32169.10037943725132569260.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 05:20:18 +0000
References: <20230130231402.471493-1-cphealy@gmail.com>
In-Reply-To: <20230130231402.471493-1-cphealy@gmail.com>
To:     Chris Healy <cphealy@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, neil.armstrong@linaro.org,
        khilman@baylibre.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        jeremy.wang@amlogic.com, healych@amazon.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 30 Jan 2023 15:14:02 -0800 you wrote:
> From: Chris Healy <healych@amazon.com>
> 
> The Meson G12A Internal PHY does not support standard IEEE MMD extended
> register access, therefore add generic dummy stubs to fail the read and
> write MMD calls. This is necessary to prevent the core PHY code from
> erroneously believing that EEE is supported by this PHY even though this
> PHY does not support EEE, as MMD register access returns all FFFFs.
> 
> [...]

Here is the summary with links:
  - [v3] net: phy: meson-gxl: Add generic dummy stubs for MMD register access
    https://git.kernel.org/netdev/net/c/afc2336f89dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



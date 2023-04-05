Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600C26D723A
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 04:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbjDECA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 22:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbjDECAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 22:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0103C05
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 19:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4151663ADD
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 926A1C433AC;
        Wed,  5 Apr 2023 02:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680660019;
        bh=RK9bt7Z5bMks1Ua7ZnIYZG6hlsr1VoZDBPGx7qNfVO8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=usX8yZddPiDACzpGQuAt74Zpa2bO10kZk+Ix9cdcnt+QVXVocQG8fu34Qg+b/M3Dv
         Irj35zXk78Jm7Ne7D/oOv31wVpfBF7mtfTOMi6wDMgBQkz2WHXFi34m8vIiFRitsBp
         gdE9g7QRtwUrKiDNYMRj4W52uNnQR+TbDoT4GCpJ9t3VsZRUVOxQdT+rJhWUwDwUwL
         zNzSamTwDxvG5nx1pfy5WAsPlwHOd6XTdNrfRYpKIMZe1aK0fgzU+kG8hihbNrxm4T
         mx0jmTqCCrJtZCIqsuT+oWHxvLxUcuyS6gLfz9Or6AqANdNYo+eOk4rWExII33mjN0
         Mc3yEeI8Eu6tA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6F883E524E4;
        Wed,  5 Apr 2023 02:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: meson-gxl: enable edpd tunable support for
 G12A internal PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168066001945.10193.5507736918462128877.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Apr 2023 02:00:19 +0000
References: <8d309575-067c-7321-33cf-6ffac11f7c8d@gmail.com>
In-Reply-To: <8d309575-067c-7321-33cf-6ffac11f7c8d@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, linux@armlinux.org.uk,
        martin.blumenstingl@googlemail.com, khilman@baylibre.com,
        jbrunet@baylibre.com, neil.armstrong@linaro.org, cphealy@gmail.com,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 3 Apr 2023 21:35:46 +0200 you wrote:
> Enable EDPD PHY tunable support for the G12A internal PHY, reusing the
> recently added tunable support in the smsc driver.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/meson-gxl.c | 4 ++++
>  1 file changed, 4 insertions(+)

Here is the summary with links:
  - [net-next] net: phy: meson-gxl: enable edpd tunable support for G12A internal PHY
    https://git.kernel.org/netdev/net-next/c/992e76908e92

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



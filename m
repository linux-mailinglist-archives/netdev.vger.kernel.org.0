Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDAE664154
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238589AbjAJNKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238569AbjAJNKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2634861339;
        Tue, 10 Jan 2023 05:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0635B8165B;
        Tue, 10 Jan 2023 13:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02CDCC433F0;
        Tue, 10 Jan 2023 13:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673356217;
        bh=AfYxGeKxmGTnRJ9VdzNFjXfxJwHYO6+E6nqMF8fjxxU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gJVnos5a/oJEvijdI0jN+J9SsCyp5eiWrwGhtIY+fLXJxGvFchDHwlSwxxo65gi6i
         W+VMMfm+zKndYlXtOjew8V9bDIcYDomkdmIbYIfUNBCWg+Jz0A3A2TvmgP92lp/1Gl
         NQjgQoz6ziVsWkNVpdrct0NC3VHUfsbl3XJN86+irgNnyC3J3z4ag5+XQeLXwEW0Mk
         NgJaPezVCxt1wEChyJsjTt9FOg7l9LNhJ7TJhcDdkq/odf7GbuBaiJApt5kgqh0Ri4
         h8NIYj3o+LhBzBXCetpM+FUNwn1DilGOz7v0Tni9gpMT+GFlfu7VVnLVFZR0SR1KqH
         /SfirgNHnt2oA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DD692E21EE9;
        Tue, 10 Jan 2023 13:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] net: phy: mxl-gpy: broken interrupt fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167335621689.15666.4497972475901169056.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Jan 2023 13:10:16 +0000
References: <20230109123013.3094144-1-michael@walle.cc>
In-Reply-To: <20230109123013.3094144-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, lxu@maxlinear.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  9 Jan 2023 13:30:09 +0100 you wrote:
> The GPY215 has a broken interrupt pin. This patch series tries to
> workaround that and because in general that is not possible, disables the
> interrupts by default and falls back to polling mode. There is an opt-in
> via the devicetree.
> 
> v3:
>  - move phy_device::dev_flags after the struct phy_device definition.
>    also add a comment. Thanks Russell.
>  - add a rationale for the new devicetree property in the commit
>    message
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] dt-bindings: vendor-prefixes: add MaxLinear
    https://git.kernel.org/netdev/net-next/c/dd1a98a375a6
  - [net-next,v3,2/4] dt-bindings: net: phy: add MaxLinear GPY2xx bindings
    https://git.kernel.org/netdev/net-next/c/90c47eb169ac
  - [net-next,v3,3/4] net: phy: allow a phy to opt-out of interrupt handling
    https://git.kernel.org/netdev/net-next/c/7d885863e716
  - [net-next,v3,4/4] net: phy: mxl-gpy: disable interrupts on GPY215 by default
    https://git.kernel.org/netdev/net-next/c/97a89ed101bb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



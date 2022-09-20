Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC535BE95B
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiITOuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiITOuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB552FFF2;
        Tue, 20 Sep 2022 07:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2216C62B1A;
        Tue, 20 Sep 2022 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EC96C4347C;
        Tue, 20 Sep 2022 14:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663685417;
        bh=uviyvA1Ht5f/XCF4evjEYAKSiInI7rFBkOOpJr770ho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rQ0d8Dn0O5hkImRCARgOijKH9G0R4D9XHqgmPpSRgYddXd3e31IlB+kb1o2SLs1qY
         n25VlRiKFyoq9vjaXxkzyObA8+JAkUT7dZE4s6nA9FQdTiIe9g8Csg/o4lktUrw+eC
         Ty+4DCHqxTY7Jxf7rJa0tLKjyEUdrsPq/EAEcBF4sotjHhxef05rqsM6ElNSvzAP9o
         7drpPOg9RSmmsddMzomX+kII1dovFsUiYJCxBwE9K1DCMq7kK9EF7oWUjfCp2TwClc
         PKJBhYXe6hw+0rG5wpmUt04EYgcrBQMs0hJU1svVDPMJuiAm8MGMXjRfP1gYWS9Llc
         vA/F79m2E1sJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D4E9E21EDF;
        Tue, 20 Sep 2022 14:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] dt-bindings: net: dsa: convert ocelot.txt to
 dt-schema
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368541737.14330.4496034186783554002.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 14:50:17 +0000
References: <20220913125806.524314-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220913125806.524314-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        colin.foster@in-advantage.com, fido_max@inbox.ru,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 13 Sep 2022 15:58:06 +0300 you wrote:
> Replace the free-form description of device tree bindings for VSC9959
> and VSC9953 with a YAML formatted dt-schema description. This contains
> more or less the same information, but reworded to be a bit more
> succint.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>
> 
> [...]

Here is the summary with links:
  - [v2,net-next] dt-bindings: net: dsa: convert ocelot.txt to dt-schema
    https://git.kernel.org/netdev/net-next/c/7f32974bdc9d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



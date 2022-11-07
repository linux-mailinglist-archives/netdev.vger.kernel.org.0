Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E157A61ED6B
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiKGIuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbiKGIuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA8D15730;
        Mon,  7 Nov 2022 00:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66C4360F4D;
        Mon,  7 Nov 2022 08:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7F53C433C1;
        Mon,  7 Nov 2022 08:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667811015;
        bh=uex1fBdShEvVtyLzJ48/6AsNC2ZE14PPaq29LD5jDAA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tlDFG2RFqLahc8lup2ovaElE52egtAAi0FA+pVgxJ00Dp+kBZQMz3zrID7yO7qw2v
         4f4HEoO3DC/YW1bWqao+kSvV4OJJtmpspCVpPULOEr1/joBuQAjnNny32zHeWbND68
         xb80sKnQ8qhrhGM0gcyIIcMXRkm6RBN+K/rw+RJ8230Ew9hjyY9QevXZSTfyy150dl
         OzyB60dnSXrdNlZdlnuC4eEji8JgWNqax04VUMEZmtbaDIf6l3l99WGhJCXtYpfkwc
         vph5PcDin7d82H7QyIhy30i1pMcGWKW6+iN0a0fSoQn04+k+j0AQsvbe2H+uhqj8vl
         ANxebjEWKOOWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9EAF7C73FFC;
        Mon,  7 Nov 2022 08:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 1/2] dt-bindings: net: constrain number of 'reg' in
 ethernet ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166781101564.969.17129042125310048499.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 08:50:15 +0000
References: <20221102161512.53399-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221102161512.53399-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        linux@rempel-privat.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        o.rempel@pengutronix.de
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
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Nov 2022 12:15:11 -0400 you wrote:
> 'reg' without any constraints allows multiple items which is not the
> intention for Ethernet controller's port number.
> 
> Constrain the 'reg' on AX88178 and LAN95xx USB Ethernet Controllers.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [v3,1/2] dt-bindings: net: constrain number of 'reg' in ethernet ports
    https://git.kernel.org/netdev/net-next/c/bd881b44fdbc
  - [v3,2/2] dt-bindings: net: dsa-port: constrain number of 'reg' in ports
    https://git.kernel.org/netdev/net-next/c/a352a2c5d2a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



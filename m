Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8725A1F2D
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244916AbiHZDA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 23:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244929AbiHZDAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C6E40E1A;
        Thu, 25 Aug 2022 20:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 823A7B82F72;
        Fri, 26 Aug 2022 03:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28F6CC433D7;
        Fri, 26 Aug 2022 03:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661482816;
        bh=lhOK0hN5NUnvLWU7XQhshd4+QudR/OnZ1UDqoKn9XmM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pheTM+Iv1gAfD3BqcsheVT5roQfzETnyE4zKJa6BSSSWrlLNLqQLpEmbaJOmPr/Ql
         S69xiCm6KMof2CCr8ZtdnVYAJbNJIVW3mfFxpQWeeSIhxf1/cRwA553n3kHFPraJlx
         OqLMqtmT71HSazDJuZ948XpI6IfrMEJF7MDp9jEZfupnziNfbmy421qGJE5DtWvkrb
         5pGB0/12Bc674X2bfQFSnW0VBWLC8DgVznzb+l7eBjpo16gP9yTKGJbVU09LUJtjcc
         e3iKg9kAp/F6UJmIDbGlmjIYhJQVR3v/Jq3QequRYCSFhUB6oHrvpmBbckDKSPGUwX
         dOgoEtqp8Z/jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05E04E2A040;
        Fri, 26 Aug 2022 03:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] dt-bindings: net: Add missing
 (unevaluated|additional)Properties on child nodes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166148281601.17475.2210507730801372556.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Aug 2022 03:00:16 +0000
References: <20220825192609.1538463-1-robh@kernel.org>
In-Reply-To: <20220825192609.1538463-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, wellslutw@gmail.com,
        grygorii.strashko@ti.com, nsekhar@ti.com,
        steen.hegelund@microchip.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Aug 2022 14:26:07 -0500 you wrote:
> In order to ensure only documented properties are present, node schemas
> must have unevaluatedProperties or additionalProperties set to false
> (typically). Add missing properties/$refs as exposed by this addition.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> v2:
>  - Add microchip,sparx5-switch.yaml and sunplus,sp7021-emac.yaml
> 
> [...]

Here is the summary with links:
  - [v2] dt-bindings: net: Add missing (unevaluated|additional)Properties on child nodes
    https://git.kernel.org/netdev/net-next/c/057062adb49b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



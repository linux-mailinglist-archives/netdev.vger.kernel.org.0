Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755F66D8C42
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbjDFBAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbjDFBAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:00:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F19576A5;
        Wed,  5 Apr 2023 18:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFDAD64266;
        Thu,  6 Apr 2023 01:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 267BFC433D2;
        Thu,  6 Apr 2023 01:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680742818;
        bh=vXEUYvwqrbVjxI/mGcd4Qq3K3smjT15yMes9sYmnOkE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=goUwakUA1zYXH/IdyWK/xvVuUh/rRnNVwhK+hjQ6Rp96yJbDonjLOw3u85eAGAliX
         OmpeQkejC3NeiwwEg3+SxT3IuVpv9oUTdxBC0v+9AEvxY9tOFiUba3SoSFxJY/TZZ/
         PIyjLtCyw6VExSoktsu9GJgjjgObjE4orXeoTr4uXn7EgvnE4icPa2VW5CN7CnwjEu
         aGoPMCtE5hpEyMvBoyDEc2p6tNZYbsNDTFSspNrSqVE09M0/9FvUysEqF8IVYmlK2C
         VAcOG7GvEobY18+Rdncj7uj0kTbApjZEqlBjlfhQXiOmtglyQFLNxFMuDU9ICA1eOi
         DKFHDGqOD9aDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F7B8C395D8;
        Thu,  6 Apr 2023 01:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: dsa: brcm,sf2: Drop unneeded
 "#address-cells/#size-cells"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168074281806.15345.5290233853020245950.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 01:00:18 +0000
References: <20230404204152.635400-1-robh@kernel.org>
In-Reply-To: <20230404204152.635400-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue,  4 Apr 2023 15:41:52 -0500 you wrote:
> There's no need for "#address-cells/#size-cells" in the brcm,sf2 node as
> no immediate child nodes have an address. What was probably intended was
> to put them in the 'ports' node, but that's not necessary as that is
> covered by ethernet-switch.yaml via dsa.yaml.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> 
> [...]

Here is the summary with links:
  - dt-bindings: net: dsa: brcm,sf2: Drop unneeded "#address-cells/#size-cells"
    https://git.kernel.org/netdev/net-next/c/f03789766905

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



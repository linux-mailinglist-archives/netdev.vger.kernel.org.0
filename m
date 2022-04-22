Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81C450B7A9
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 14:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbiDVM5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 08:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447654AbiDVMxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 08:53:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC5DDEFE;
        Fri, 22 Apr 2022 05:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48CC862043;
        Fri, 22 Apr 2022 12:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0525C385A4;
        Fri, 22 Apr 2022 12:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650631812;
        bh=H/9gLsV79O9kH0xuO7AgIyJUXk83OWQVXtEfVS2L+mc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uGqFsN+AWj9is9iuX+f1n2uBR6c9pWrzGNOj22lW0Z4+oD7DnOYdLBj1O0Kk7bc+f
         vtmevJpA6vZU8cTh1RILYlWafB7d6PCzTDZ7XFBGF4kEhMpMyARhMG1gx/UfVOgjss
         1lCm//A45p918ley5HKpI7sePjdYdLUelDU9RLh21qzwK+d9JO1r7uuALtaNNy/xDO
         TVq+DrYRZphWwVumD1f1rUcKXRyvs1uXuw7sTCyXkCovilXlR5rF2L8+p5vOjZ3SuW
         QILEt+g8fSWpfcqlwU53hw7V3B+TulZjNUzMHK/mdOS8BZIa33MX8CUiuxc5EpyOdH
         DzcZfDH+A5HYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A43FE85D90;
        Fri, 22 Apr 2022 12:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next] dt-bindings: net: mediatek,net: convert to the
 json-schema
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165063181242.24908.11489160264789538643.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 12:50:12 +0000
References: <6b417ab35163bd8a4bef4bd38cf46d777925bd26.1650463289.git.lorenzo@kernel.org>
In-Reply-To: <6b417ab35163bd8a4bef4bd38cf46d777925bd26.1650463289.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, lorenzo.bianconi@redhat.com,
        devicetree@vger.kernel.org, robh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, john@phrozen.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 20 Apr 2022 16:07:07 +0200 you wrote:
> This patch converts the existing mediatek-net.txt binding file
> in yaml format.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v2:
> - remove additionalItems for clock-names properties
> - move mediatek,sgmiisys definition out of the if block
> 
> [...]

Here is the summary with links:
  - [v3,net-next] dt-bindings: net: mediatek,net: convert to the json-schema
    https://git.kernel.org/netdev/net-next/c/c78c5a660439

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



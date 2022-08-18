Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3313598B2B
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345475AbiHRSaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345488AbiHRSaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:30:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52342B5A73;
        Thu, 18 Aug 2022 11:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10ED7B82370;
        Thu, 18 Aug 2022 18:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B707AC433B5;
        Thu, 18 Aug 2022 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660847417;
        bh=0tcBwhvU3IwbrGMz2RXkuGs7v8beKzHJW6W7ZezoMqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VyzWQ4W7Zxq4YYDdLa1ZMFGldOAczo3Z92T0pE6Wk37y+NUFm/wtT6At4YbpfPEFa
         XZ0UQPKD3qePJ4TpiJr/TsDeLYocZtqMxd46/xEcpsSPvjYIa+Z7Vz3e/YZvg7XG69
         D0RWOPhHBAxQxJmgKXXgdbhQwWSKYtMriZCAt3DTd8tleePyPY0kuIJybPJaW04A25
         Twqba6D8KRryriGSBlqyLrS/xD2P0AYQEPpt+8xM4OJ64diZf8YeQspki3muPnVZKG
         IZTFe2Mt+NaM1kWYf9P7udiulll/+HDBHIdmghTvh3+U/+QB5BpHzOL5WwPojROrB7
         V9iQ8r6XBuBRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A75EE2A058;
        Thu, 18 Aug 2022 18:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] dt-bindings: Fix incorrect "the the" corrections
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166084741762.25395.6372912472329150051.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 18:30:17 +0000
References: <c5743c0a1a24b3a8893797b52fed88b99e56b04b.1660755148.git.geert+renesas@glider.be>
In-Reply-To: <c5743c0a1a24b3a8893797b52fed88b99e56b04b.1660755148.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        slark_xiao@163.com, kuba@kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, niklas.soderlund@ragnatech.se,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 Aug 2022 18:54:51 +0200 you wrote:
> Lots of double occurrences of "the" were replaced by single occurrences,
> but some of them should become "to the" instead.
> 
> Fixes: 12e5bde18d7f6ca4 ("dt-bindings: Fix typo in comment")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v2:
>   - Drop blank line between Fixes and SoB tags.
> 
> [...]

Here is the summary with links:
  - [v2] dt-bindings: Fix incorrect "the the" corrections
    https://git.kernel.org/netdev/net/c/8aa48ade7db4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



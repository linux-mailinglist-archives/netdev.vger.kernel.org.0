Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAA15BD917
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiITBKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiITBKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:10:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A2ADFB3;
        Mon, 19 Sep 2022 18:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53A1661FEB;
        Tue, 20 Sep 2022 01:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 037B8C43143;
        Tue, 20 Sep 2022 01:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636221;
        bh=5v7TuQqDF1iCfVseXS2pcdxkYOYIJabRGEK5N6iBKZo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=shDtRyoLLBY9DUYHJo/guDpim/tq1YACixCxPfjKcQWedRgFJZe8XIjpazrn0qPix
         Pee3rPawL1gCewPV7sxeN9GyA+aefYBXAAZGOiIBqiHQ3jj2gFC7ulJJeeimCyw5GR
         PWNBp01RGdJxoWrs1Nl8MtAKDu4crIkojluGiHcvLF4Ab1DIBdSrhYSU7l+WIBLmhg
         nt3XjuPfkCtPLWrIvwC3y4y0VykhjvgpRABVRihj1iNwkVVibVLMpjg6STqRX6eXgh
         NcXi4BhNzZO0fgQXYLyB3nl+X2C05xBITydLe9PSsT/gKqwmxCGX5OcGZu4jrxcOlK
         wCrEDfBzmzy4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF2CDE52539;
        Tue, 20 Sep 2022 01:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Add FEC support on s32v234 platform
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363622090.23429.15584862562185231209.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:10:20 +0000
References: <20220907095649.3101484-1-wei.fang@nxp.com>
In-Reply-To: <20220907095649.3101484-1-wei.fang@nxp.com>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Sep 2022 17:56:47 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> This series patches are to add FEC support on s32v234 platfom.
> 1. Add compatible string and quirks for fsl,s32v234
> 2. Update Kconfig to also check for ARCH_S32.
> 
> Wei Fang (2):
>   dt-bindings: net: fec: add fsl,s32v234-fec to compatible property
>   net: fec: Add initial s32v234 support
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dt-bindings: net: fec: add fsl,s32v234-fec to compatible property
    https://git.kernel.org/netdev/net-next/c/00f5303c17ee
  - [net-next,2/2] net: fec: Add initial s32v234 support
    https://git.kernel.org/netdev/net-next/c/167d5fe0f6c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



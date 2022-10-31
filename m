Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7C1613246
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiJaJKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiJaJKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C458DE8A;
        Mon, 31 Oct 2022 02:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05A5B6104F;
        Mon, 31 Oct 2022 09:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5684BC43140;
        Mon, 31 Oct 2022 09:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667207417;
        bh=I4NVs0U7sjGhCQhI4xGL75Wf864Rg/GvXfCf3DWTyIg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OWKhRgROTBHPZJy7WJPy9Jinr9RcUW4H/LGAvOdit2Bvzcr7k4sDUB/l7qZUd3Vup
         pcBDKx5xf13uBhvAbvow5IPHgb1Idfs+P0ak9xuz79+hl/hH1n9unB5F6ShZ+naxoR
         ddyBphvAbrau6OGk5dXPSnOvPWGr96XW2gBAyq+LBy4zHsyZ0VqyuJbAItSrLwnQ9i
         6f/ooYbV+whzg2d6E1SEfbMl0tSyRJRtPA4k6KdT2i7Pw2yPm0NQ5zSXjRebbsqHoq
         /gkLl/4mgeDZEHzosEEZwr3v0L8eTbG7Yh56ffZHosfp0zenynNopgeI9xdcyeC8rW
         Jlvok7dhVMOiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 409ECE270D6;
        Mon, 31 Oct 2022 09:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 1/1] dt-bindings: net: snps,dwmac: Document queue config
 subnodes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166720741726.7426.12772308413973886987.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 09:10:17 +0000
References: <20221027163119.107092-1-sebastian.reichel@collabora.com>
In-Reply-To: <20221027163119.107092-1-sebastian.reichel@collabora.com>
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@collabora.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 27 Oct 2022 18:31:19 +0200 you wrote:
> The queue configuration is referenced by snps,mtl-rx-config and
> snps,mtl-tx-config. Some in-tree DTs and the example put the
> referenced config nodes directly beneath the root node, but
> most in-tree DTs put it as child node of the dwmac node.
> 
> This adds proper description for this setup, which has the
> advantage of validating the queue configuration node content.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,1/1] dt-bindings: net: snps,dwmac: Document queue config subnodes
    https://git.kernel.org/netdev/net-next/c/8fc4deaa8bd2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



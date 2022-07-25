Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F22757FE7E
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 13:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbiGYLkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 07:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbiGYLkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 07:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE93116D;
        Mon, 25 Jul 2022 04:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3856B60FFF;
        Mon, 25 Jul 2022 11:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F30FC341D1;
        Mon, 25 Jul 2022 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658749214;
        bh=Gha+LpOvmMDP3UdXwDZnCmWtL1yMT7Hzwl/OO+WSrNc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zu1y3DaeS4tOasBhdXquzlk6gfpaDf+1X6B6fKQYhNORDkcE5pAJnXMM86n4r24iH
         iF4NPqAWFOYmOerv2RuqNr0yGPT8nGwYltkYo1Auzv/+O8p6255sO7Ut8PFUJP1k8J
         xTUI8OMH/vO0A0Wi+YdDkM3od0cMS726tbVjTXPwfShNPAcbI8mALyji3UPGvrAkjG
         A67rZj7YreNFsZf0F4Iq/wouRXy9yAsSuTU5zfjT5AhMsAWO6kNZ/WIVtLQ8XEVwsh
         5zq0XNj+EDhifxdIK63JxezinDMBmRA41ye//r/2gLlsQEOdr0dSyoIKBOA9zWfjoH
         nhOfHdQ/rlgcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56B8DE450B3;
        Mon, 25 Jul 2022 11:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/3] Add Versal compatible string to Macb driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165874921435.25231.10967093929015786905.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jul 2022 11:40:14 +0000
References: <20220722110330.13257-1-harini.katakam@xilinx.com>
In-Reply-To: <20220722110330.13257-1-harini.katakam@xilinx.com>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@xilinx.com,
        harinikatakamlinux@gmail.com, harini.katakam@amd.com,
        devicetree@vger.kernel.org, radhey.shyam.pandey@xilinx.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 22 Jul 2022 16:33:27 +0530 you wrote:
> Add Versal device support.
> 
> v2:
> - Sort compatible strings alphabetically in DT bindings.
> - Reorganize new config and CAPS order to be cleaner.
> 
> Harini Katakam (2):
>   net: macb: Sort CAPS flags by bit positions
>   net: macb: Update tsu clk usage in runtime suspend/resume for Versal
> 
> [...]

Here is the summary with links:
  - [v2,1/3] dt-bindings: net: cdns,macb: Add versal compatible string
    https://git.kernel.org/netdev/net-next/c/f1fa61b04530
  - [v2,2/3] net: macb: Sort CAPS flags by bit positions
    https://git.kernel.org/netdev/net-next/c/1d3ded642535
  - [v2,3/3] net: macb: Update tsu clk usage in runtime suspend/resume for Versal
    https://git.kernel.org/netdev/net-next/c/8a1c9753f165

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6186583D4B
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbiG1LXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237008AbiG1LW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:22:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D76DFA3;
        Thu, 28 Jul 2022 04:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4801F61AB3;
        Thu, 28 Jul 2022 11:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99F4FC433D6;
        Thu, 28 Jul 2022 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659007213;
        bh=NLoiJ85ooOY7R0E1mdDICk95Ib07s5ReQ95M35FsNP8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CtJiaLq0Pg+RbjKkSZftsWHn4zILUyHarxPVefZNFH+QM9vN/UGSYFp7KsqYovY9Y
         ooptd/uvJKd2LvW0YVExiA0RkPkrNsRBwzx1amROBM1bbrhM1TEXbdtpgSQbFcMZtx
         PICV9XZoX9mE99Dx6Y945GpXVSdQM7YeneUaf8kotFNIkFP2efzQPwHgVMPii+eUbM
         hfnVcwBYXzh0DjIoiJO3HwA3pYJwR7zO+jO4C2M7WBpaLA6IMQwYNYc+8r+wtPL0nh
         200iBkvU++/OoGDdIdvfVLKiLsVB3Le69iHpx1LBEB4sjrg3lHhRS4Zp5s1/B9SKvP
         BwoAdkswenKNw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7E97CC43142;
        Thu, 28 Jul 2022 11:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] dt-bindings: net: cdns,macb: use correct xlnx prefix
 for Xilinx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165900721351.27752.17529636503507674443.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 11:20:13 +0000
References: <20220726070802.26579-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220726070802.26579-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh@kernel.org, harini.katakam@xilinx.com,
        radhey.shyam.pandey@xilinx.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 26 Jul 2022 09:08:01 +0200 you wrote:
> Use correct vendor for Xilinx versions of Cadence MACB/GEM Ethernet
> controller.  The Versal compatible was not released, so it can be
> changed.  Zynq-7xxx and Ultrascale+ has to be kept in new and deprecated
> form.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Reviewed-by: Rob Herring <robh@kernel.org>
> 
> [...]

Here is the summary with links:
  - [v2,1/2] dt-bindings: net: cdns,macb: use correct xlnx prefix for Xilinx
    https://git.kernel.org/netdev/net-next/c/afa950b8adc9
  - [v2,2/2] net: cdns,macb: use correct xlnx prefix for Xilinx
    https://git.kernel.org/netdev/net-next/c/623cd8700698

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



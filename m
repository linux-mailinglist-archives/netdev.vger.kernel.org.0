Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E51D6BD778
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjCPRuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjCPRuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3F41ABC9;
        Thu, 16 Mar 2023 10:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBCC4620D6;
        Thu, 16 Mar 2023 17:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31B95C433A1;
        Thu, 16 Mar 2023 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678989020;
        bh=/rFLNe93rQIRlAx/57xJ6NacQ6gFAXPh6A+DAAqx/RY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rKgHmH1sooRqw3nGbq3dUryuP04azSVgLR00rq6MsZBt67K6xq5U/DbzcpvZwgspe
         LDwV12ROIoHxlgKyvMkkkbsAo/Bo0YyjeDuI9yQ38MIlzJg5A90jtS5cBd+jIqUB2d
         ZjnpEtBLXj2fI0zxBCWMS36HM7et2XB9AH2jIWKKvcUysXzNR8nT3/ek4v0Ni79GU9
         U60CsnFj2LB59sYcNJ46yQOqptrQMaM9E1J0Gqn9OBQU1uM5ybRzEQxsFiSndKRB/m
         Tochl8xGkSZkmS0L1QXqZBvoOblNX8O4m1G9SM5ioao93p/jS3EPqHh/ROVd7b1OXc
         Swe/YlbXKZipg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0EAE9E29F32;
        Thu, 16 Mar 2023 17:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: Use of_property_read_bool() for boolean properties
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167898902004.2133.16158810493778389682.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 17:50:20 +0000
References: <20230314191828.914124-1-robh@kernel.org>
In-Reply-To: <20230314191828.914124-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        wei.fang@nxp.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
        linux-imx@nxp.com, claudiu.manoil@nxp.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, mcoquelin.stm32@gmail.com,
        grygorii.strashko@ti.com, romieu@fr.zoreil.com,
        michal.simek@xilinx.com, qiang.zhao@nxp.com, kvalo@kernel.org,
        sam@mendozajonas.com, simon.horman@corigine.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Mar 2023 14:18:27 -0500 you wrote:
> It is preferred to use typed property access functions (i.e.
> of_property_read_<type> functions) rather than low-level
> of_get_property/of_find_property functions for reading properties.
> Convert reading boolean properties to of_property_read_bool().
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # for net/can
> Acked-by: Kalle Valo <kvalo@kernel.org>
> Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> Acked-by: Francois Romieu <romieu@fr.zoreil.com>
> Reviewed-by: Wei Fang <wei.fang@nxp.com>
> Signed-off-by: Rob Herring <robh@kernel.org>
> 
> [...]

Here is the summary with links:
  - [v2] net: Use of_property_read_bool() for boolean properties
    https://git.kernel.org/netdev/net/c/1a87e641d8a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



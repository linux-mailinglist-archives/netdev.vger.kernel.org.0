Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2534CD4E0
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbiCDNLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238428AbiCDNLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:11:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56CB18885A;
        Fri,  4 Mar 2022 05:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BB2CB82943;
        Fri,  4 Mar 2022 13:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5675C340F1;
        Fri,  4 Mar 2022 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646399413;
        bh=P/mrzfKDo2Y3uAtXmoJw/uuehBQI3zLd+itMRIU6Zgo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YPONCs3Syy60CW4ost9nOknBCvmG5dDECTH2GV7qGZncWk6AZMqoGElxrQkPrL7i+
         I0P/VR4OAUrO5cxcvY6rdjOVolsggJ60BHqv3Ax1smYHxPpgTjLX5GI2U3rFt+IHOq
         eCiHHk0UoXmysfqLBmOkJQ6Pb5Ldd/1E7vqw4dDexlLYQdDD1274F54Wrldfc5v+7T
         szHo40Nlzdz9LU9NtSKbtNetz5HgWl3rPDF+QHw9AtyMZm17+xSHLpUTZvzfvrjIx/
         zDis5osJSmpk1Y3j+OqmkMdU0Z/uwP8pQIfXFOhl2eTZ3JI+lV+Ss2n4YgT3ut5w4Z
         EUimVNA8xF6WQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9F28E6D4BB;
        Fri,  4 Mar 2022 13:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] net: sparx5: Add PTP Hardware Clock support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164639941282.4305.10123541557120406446.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 13:10:12 +0000
References: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, casper.casan@gmail.com,
        richardcochran@gmail.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 4 Mar 2022 12:08:51 +0100 you wrote:
> Add support for PTP Hardware Clock (PHC) for sparx5.
> 
> Horatiu Vultur (9):
>   net: sparx5: Move ifh from port to local variable
>   dt-bindings: net: sparx5: Extend with the ptp interrupt
>   dts: sparx5: Enable ptp interrupt
>   net: sparx5: Add registers that are used by ptp functionality
>   net: sparx5: Add support for ptp clocks
>   net: sparx5: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP
>   net: sparx5: Update extraction/injection for timestamping
>   net: sparx5: Add support for ptp interrupts
>   net: sparx5: Implement get_ts_info
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: sparx5: Move ifh from port to local variable
    https://git.kernel.org/netdev/net-next/c/8f68f53a9325
  - [net-next,2/9] dt-bindings: net: sparx5: Extend with the ptp interrupt
    https://git.kernel.org/netdev/net-next/c/b066ad26ebf2
  - [net-next,3/9] dts: sparx5: Enable ptp interrupt
    https://git.kernel.org/netdev/net-next/c/6015fb905d89
  - [net-next,4/9] net: sparx5: Add registers that are used by ptp functionality
    https://git.kernel.org/netdev/net-next/c/3193a6118140
  - [net-next,5/9] net: sparx5: Add support for ptp clocks
    https://git.kernel.org/netdev/net-next/c/0933bd04047c
  - [net-next,6/9] net: sparx5: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP
    https://git.kernel.org/netdev/net-next/c/589a07b8eb49
  - [net-next,7/9] net: sparx5: Update extraction/injection for timestamping
    https://git.kernel.org/netdev/net-next/c/70dfe25cd866
  - [net-next,8/9] net: sparx5: Add support for ptp interrupts
    https://git.kernel.org/netdev/net-next/c/d31d37912ea7
  - [net-next,9/9] net: sparx5: Implement get_ts_info
    https://git.kernel.org/netdev/net-next/c/608111fc580f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



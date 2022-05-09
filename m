Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC06651FAB3
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 13:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiEILES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 07:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbiEILEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 07:04:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3847B1F8C7E;
        Mon,  9 May 2022 04:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C88B46101F;
        Mon,  9 May 2022 11:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D2E6C385A8;
        Mon,  9 May 2022 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652094018;
        bh=ikDxI0UBbdraQb7K+9dalHuQbxbHJSwgNwO+ncLaxr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lMq6013+5MB16OaTDkfHvm37p8w27p/IvAeRRuZB9C8LBw0ksDEch22MAqNv50QPK
         AiXQKJfX5+d2vb46/7/7jmcDQr0YLjVTsZS4GjxEVQRqO4qmeJHukctIhI3I4WMdpt
         dW2nsqD2Sc7nTIBm0Vedbm0xHS+q1Zib+MseHgl5rHJRyscyr5dF25F3kZ3j5avmpS
         EeqdnjwoZSJhCyeGiEIo9qq/89tSh5dMobaE5AzBg8n1pXd0b2VQKtNEI2IgJPPDnu
         +8C3myn0qZHLsTC+lkzoKQ3erh8QLaFY1FIts5idn6syzNxrTpx/HzXBRIm/+Rn/Cd
         0u+cJhsNjgyaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ED914F03927;
        Mon,  9 May 2022 11:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8 00/14] net: wwan: t7xx: PCIe driver for MediaTek
 M.2 modem
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165209401796.3033.5690066053334443938.git-patchwork-notify@kernel.org>
Date:   Mon, 09 May 2022 11:00:17 +0000
References: <20220506181310.2183829-1-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220506181310.2183829-1-ricardo.martinez@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, ilpo.johannes.jarvinen@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  6 May 2022 11:12:56 -0700 you wrote:
> t7xx is the PCIe host device driver for Intel 5G 5000 M.2 solution which
> is based on MediaTek's T700 modem to provide WWAN connectivity.
> The driver uses the WWAN framework infrastructure to create the following
> control ports and network interfaces:
> * /dev/wwan0mbim0 - Interface conforming to the MBIM protocol.
>   Applications like libmbim [1] or Modem Manager [2] from v1.16 onwards
>   with [3][4] can use it to enable data communication towards WWAN.
> * /dev/wwan0at0 - Interface that supports AT commands.
> * wwan0 - Primary network interface for IP traffic.
> 
> [...]

Here is the summary with links:
  - [net-next,v8,01/14] list: Add list_next_entry_circular() and list_prev_entry_circular()
    https://git.kernel.org/netdev/net-next/c/2fbdf45d7d26
  - [net-next,v8,02/14] net: skb: introduce skb_data_area_size()
    https://git.kernel.org/netdev/net-next/c/a4ff365346c9
  - [net-next,v8,03/14] net: wwan: t7xx: Add control DMA interface
    https://git.kernel.org/netdev/net-next/c/39d439047f1d
  - [net-next,v8,04/14] net: wwan: t7xx: Add core components
    https://git.kernel.org/netdev/net-next/c/13e920d93e37
  - [net-next,v8,05/14] net: wwan: t7xx: Add port proxy infrastructure
    https://git.kernel.org/netdev/net-next/c/48cc2f5ef846
  - [net-next,v8,06/14] net: wwan: t7xx: Add control port
    https://git.kernel.org/netdev/net-next/c/da45d2566a1d
  - [net-next,v8,07/14] net: wwan: t7xx: Add AT and MBIM WWAN ports
    https://git.kernel.org/netdev/net-next/c/61b7a2916a0e
  - [net-next,v8,08/14] net: wwan: t7xx: Data path HW layer
    https://git.kernel.org/netdev/net-next/c/33f78ab5a38a
  - [net-next,v8,09/14] net: wwan: t7xx: Add data path interface
    https://git.kernel.org/netdev/net-next/c/d642b012df70
  - [net-next,v8,10/14] net: wwan: t7xx: Add WWAN network interface
    https://git.kernel.org/netdev/net-next/c/05d19bf500f8
  - [net-next,v8,11/14] net: wwan: t7xx: Introduce power management
    https://git.kernel.org/netdev/net-next/c/46e8f49ed7b3
  - [net-next,v8,12/14] net: wwan: t7xx: Runtime PM
    https://git.kernel.org/netdev/net-next/c/d10b3a695ba0
  - [net-next,v8,13/14] net: wwan: t7xx: Device deep sleep lock/unlock
    https://git.kernel.org/netdev/net-next/c/de49ea38ba11
  - [net-next,v8,14/14] net: wwan: t7xx: Add maintainers and documentation
    https://git.kernel.org/netdev/net-next/c/c9933d494c54

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



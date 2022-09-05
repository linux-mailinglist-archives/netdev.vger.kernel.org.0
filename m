Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8C75AD428
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238114AbiIENkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238230AbiIENk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:40:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F95F4F189;
        Mon,  5 Sep 2022 06:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEDD0B811AB;
        Mon,  5 Sep 2022 13:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B63CC43140;
        Mon,  5 Sep 2022 13:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662385218;
        bh=6OkNTRmZgp9w9Gp+m6vHUoevwgIKFYL8Zii/ZwPojUY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sh4RtzZvi+GizYPg7PV2g9FMRtjd+Mkk4Q/0HelEX+759PzbasbrSubnRiIZ9BO1P
         Dn32m3gt2GWkXsVTk3iLvvT5zQXXhxMsMxwOEHFq0DodysCkMEfI9NgEFOC5yoU0NU
         jep/Qy9f5R2ThWeCT5kzfEbj2QcPVyRkGQ0LdMz6RlhbnUafWaH9JXdj/6GGtAM8dT
         kl7GyN5Fn1+YXK1wiULWOe4K1F4W7+SHyU84Pm8s4kvqxMVLUZ1FfnlL2vCgc3esWS
         z/ITpd4I22zVSHNucY2vySajmO/UABY1KOOgoE96FpUPhyRlE8ciMYSJZEQjDoupva
         miZhTHv3m7fmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5F17FC73FE0;
        Mon,  5 Sep 2022 13:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 00/14] net: dpaa: Cleanups in preparation for
 phylink conversion (part 2)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166238521838.32478.17433933785506172537.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 13:40:18 +0000
References: <20220902215737.981341-1-sean.anderson@seco.com>
In-Reply-To: <20220902215737.981341-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, camelia.groza@nxp.com,
        madalin.bucur@nxp.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, leoyang.li@nxp.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Sep 2022 17:57:22 -0400 you wrote:
> This series contains several cleanup patches for dpaa/fman. While they
> are intended to prepare for a phylink conversion, they stand on their
> own. This series was originally submitted as part of [1].
> 
> [1] https://lore.kernel.org/netdev/20220715215954.1449214-1-sean.anderson@seco.com
> 
> Changes in v5:
> - Reduce line length of tgec_config
> - Reduce line length of qman_update_cgr_safe
> - Rebase onto net-next/master
> 
> [...]

Here is the summary with links:
  - [net-next,v5,01/14] net: fman: Move initialization to mac-specific files
    https://git.kernel.org/netdev/net-next/c/302376feec1d
  - [net-next,v5,02/14] net: fman: Mark mac methods static
    https://git.kernel.org/netdev/net-next/c/1257c9623deb
  - [net-next,v5,03/14] net: fman: Inline several functions into initialization
    (no matching commit)
  - [net-next,v5,04/14] net: fman: Remove internal_phy_node from params
    https://git.kernel.org/netdev/net-next/c/45fa34bfaa52
  - [net-next,v5,05/14] net: fman: Map the base address once
    https://git.kernel.org/netdev/net-next/c/262f2b782e25
  - [net-next,v5,06/14] net: fman: Pass params directly to mac init
    (no matching commit)
  - [net-next,v5,07/14] net: fman: Use mac_dev for some params
    https://git.kernel.org/netdev/net-next/c/19c788b144e2
  - [net-next,v5,08/14] net: fman: Specify type of mac_dev for exception_cb
    https://git.kernel.org/netdev/net-next/c/5b6acb554065
  - [net-next,v5,09/14] net: fman: Clean up error handling
    https://git.kernel.org/netdev/net-next/c/aedbeb4e597e
  - [net-next,v5,10/14] net: fman: Change return type of disable to void
    https://git.kernel.org/netdev/net-next/c/901bdff2f529
  - [net-next,v5,11/14] net: dpaa: Use mac_dev variable in dpaa_netdev_init
    https://git.kernel.org/netdev/net-next/c/fca4804f68cf
  - [net-next,v5,12/14] soc: fsl: qbman: Add helper for sanity checking cgr ops
    https://git.kernel.org/netdev/net-next/c/d0e17a4653ce
  - [net-next,v5,13/14] soc: fsl: qbman: Add CGR update function
    https://git.kernel.org/netdev/net-next/c/914f8b228ede
  - [net-next,v5,14/14] net: dpaa: Adjust queue depth on rate change
    https://git.kernel.org/netdev/net-next/c/ef2a8d5478b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



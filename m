Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A432D4D8E36
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 21:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245037AbiCNUb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 16:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239124AbiCNUbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 16:31:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8449739812;
        Mon, 14 Mar 2022 13:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0BE9611E3;
        Mon, 14 Mar 2022 20:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 395EAC340EE;
        Mon, 14 Mar 2022 20:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647289811;
        bh=5slkzW/wYFCAJdfNlCFTBba0nZcr16X7BRShsWGs8e4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=leggAOjDGLqu5Y16iRzmCapGpn9MgtEwT4CrU4eyl+t2E31oSfK39qKDLg3AehmbU
         40wH8plobcUAZegoJFqfw9/xkqsBBPmZP9vZVSFOcI/Xp23ZGUf+pgmWTjQguJdafL
         aR+7p6LxqiE9iThzqyS8jQ9G6EB+4tZZi+yCfGQiapJJIo9jcBYm9fR9I2LX08BkN2
         bFDWmepy5ZVI6q23q7h6GXJ7SL0Svf5wH1oJCuTgacReCjqPgety1pGCFxOBEiOwa4
         z9SA1gQwBNf2EwKLfJ+KdExejyFckwalTlOP/U5FXz63cZ94Vo7u6CrKogKN+nyC4B
         +CVXdED/jOy7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0DC0AE6D3DE;
        Mon, 14 Mar 2022 20:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/30] fix typos in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164728981105.21494.10764025984714254687.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 20:30:11 +0000
References: <20220314115354.144023-1-Julia.Lawall@inria.fr>
In-Reply-To: <20220314115354.144023-1-Julia.Lawall@inria.fr>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     linux-can@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-spi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev,
        platform-driver-x86@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Laurent.pinchart@ideasonboard.com,
        jonas@kwiboo.se, jernej.skrabec@gmail.com,
        linux-leds@vger.kernel.org, shayne.chen@mediatek.com,
        sean.wang@mediatek.com, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-clk@vger.kernel.org, rafael@kernel.org,
        linux-rdma@vger.kernel.org, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org,
        matti.vaittinen@fi.rohmeurope.com, linux-power@fi.rohmeurope.com,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@kernel.org, namhyung@kernel.org,
        linux-perf-users@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 14 Mar 2022 12:53:24 +0100 you wrote:
> Various spelling mistakes in comments.
> Detected with the help of Coccinelle.
> 
> ---
> 
>  drivers/base/devres.c                               |    4 ++--
>  drivers/clk/qcom/gcc-sm6125.c                       |    2 +-
>  drivers/clk/ti/clkctrl.c                            |    2 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c              |    4 ++--
>  drivers/gpu/drm/amd/display/dc/bios/command_table.c |    6 +++---
>  drivers/gpu/drm/amd/pm/amdgpu_pm.c                  |    2 +-
>  drivers/gpu/drm/bridge/analogix/analogix_dp_core.c  |    4 ++--
>  drivers/gpu/drm/sti/sti_gdp.c                       |    2 +-
>  drivers/infiniband/hw/qib/qib_iba7220.c             |    4 ++--
>  drivers/leds/leds-pca963x.c                         |    2 +-
>  drivers/media/i2c/ov5695.c                          |    2 +-
>  drivers/mfd/rohm-bd9576.c                           |    2 +-
>  drivers/mtd/ubi/block.c                             |    2 +-
>  drivers/net/can/usb/ucan.c                          |    4 ++--
>  drivers/net/ethernet/packetengines/yellowfin.c      |    2 +-
>  drivers/net/wireless/ath/ath6kl/htc_mbox.c          |    2 +-
>  drivers/net/wireless/cisco/airo.c                   |    2 +-
>  drivers/net/wireless/mediatek/mt76/mt7915/init.c    |    2 +-
>  drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c |    6 +++---
>  drivers/platform/x86/uv_sysfs.c                     |    2 +-
>  drivers/s390/crypto/pkey_api.c                      |    2 +-
>  drivers/scsi/aic7xxx/aicasm/aicasm.c                |    2 +-
>  drivers/scsi/elx/libefc_sli/sli4.c                  |    2 +-
>  drivers/scsi/lpfc/lpfc_mbox.c                       |    2 +-
>  drivers/scsi/qla2xxx/qla_gs.c                       |    2 +-
>  drivers/spi/spi-sun4i.c                             |    2 +-
>  drivers/staging/rtl8723bs/core/rtw_mlme.c           |    2 +-
>  drivers/usb/gadget/udc/snps_udc_core.c              |    2 +-
>  fs/kernfs/file.c                                    |    2 +-
>  kernel/events/core.c                                |    2 +-
>  30 files changed, 39 insertions(+), 39 deletions(-)

Here is the summary with links:
  - [03/30] ath6kl: fix typos in comments
    (no matching commit)
  - [10/30] mt76: mt7915: fix typos in comments
    (no matching commit)
  - [12/30] drivers: net: packetengines: fix typos in comments
    https://git.kernel.org/netdev/net-next/c/ebc0b8b5374e
  - [19/30] rtlwifi: rtl8821ae: fix typos in comments
    (no matching commit)
  - [20/30] airo: fix typos in comments
    (no matching commit)
  - [27/30] can: ucan: fix typos in comments
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



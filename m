Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC9F4D855C
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 13:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236681AbiCNMtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 08:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238520AbiCNMr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 08:47:57 -0400
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCBD387A8;
        Mon, 14 Mar 2022 05:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=41PUcU9tzULCiIgb8Uibh/5DuRgn44vcqHlit9be1ys=;
  b=da5ZDADTYjfUb4CkZvv1ifI5i+2sUHWvJw+dkr6l96rFI9+3qCoi3gnv
   q0ycGdD5ccrm59796HzJuglqTi/Zn7sM07eq2eqJ7FQY8P7GtUxL24J6z
   5W/zcd3/E6fo/TuVnTzoYm6lik0f+KcMTza69NkDCls6kpW1/h8PdxP5f
   k=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,180,1643670000"; 
   d="scan'208";a="25997332"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 12:53:59 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     linux-can@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-spi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev, platform-driver-x86@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        linux-leds@vger.kernel.org, Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-clk@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-rdma@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        linux-power@fi.rohmeurope.com, Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH 00/30] fix typos in comments
Date:   Mon, 14 Mar 2022 12:53:24 +0100
Message-Id: <20220314115354.144023-1-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various spelling mistakes in comments.
Detected with the help of Coccinelle.

---

 drivers/base/devres.c                               |    4 ++--
 drivers/clk/qcom/gcc-sm6125.c                       |    2 +-
 drivers/clk/ti/clkctrl.c                            |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c              |    4 ++--
 drivers/gpu/drm/amd/display/dc/bios/command_table.c |    6 +++---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                  |    2 +-
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c  |    4 ++--
 drivers/gpu/drm/sti/sti_gdp.c                       |    2 +-
 drivers/infiniband/hw/qib/qib_iba7220.c             |    4 ++--
 drivers/leds/leds-pca963x.c                         |    2 +-
 drivers/media/i2c/ov5695.c                          |    2 +-
 drivers/mfd/rohm-bd9576.c                           |    2 +-
 drivers/mtd/ubi/block.c                             |    2 +-
 drivers/net/can/usb/ucan.c                          |    4 ++--
 drivers/net/ethernet/packetengines/yellowfin.c      |    2 +-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c          |    2 +-
 drivers/net/wireless/cisco/airo.c                   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c    |    2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c |    6 +++---
 drivers/platform/x86/uv_sysfs.c                     |    2 +-
 drivers/s390/crypto/pkey_api.c                      |    2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm.c                |    2 +-
 drivers/scsi/elx/libefc_sli/sli4.c                  |    2 +-
 drivers/scsi/lpfc/lpfc_mbox.c                       |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c                       |    2 +-
 drivers/spi/spi-sun4i.c                             |    2 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c           |    2 +-
 drivers/usb/gadget/udc/snps_udc_core.c              |    2 +-
 fs/kernfs/file.c                                    |    2 +-
 kernel/events/core.c                                |    2 +-
 30 files changed, 39 insertions(+), 39 deletions(-)

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8170F596E99
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 14:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbiHQMjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 08:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiHQMjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 08:39:46 -0400
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 2BDC05E64C;
        Wed, 17 Aug 2022 05:39:43 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [106.117.76.235])
        by mail-app2 (Coremail) with SMTP id by_KCgBnbvZx4fxiKwT3Ag--.45860S2;
        Wed, 17 Aug 2022 20:39:23 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     briannorris@chromium.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, johannes@sipsolutions.net,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH v7 0/2] Remove useless param of devcoredump functions and fix bugs
Date:   Wed, 17 Aug 2022 20:39:11 +0800
Message-Id: <cover.1660739276.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgBnbvZx4fxiKwT3Ag--.45860S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFW8JFyDtw18XFyDXrW3trb_yoW8CFyfpF
        48Kas7ZrySkrsxuayxJF1xCF98J3WxWa43Kr9Fv3s5W3WfAFyrJr15uFyFkryDXFW8ta43
        tF13Jw13GF9aqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6ryUMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUjNtx3UUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgwFAVZdtbEgdgAbsI
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch removes the extra gfp_t param of dev_coredumpv()
and dev_coredumpm().

The second patch fix sleep in atomic context bugs of mwifiex
caused by dev_coredumpv().

Duoming Zhou (2):
  devcoredump: remove the useless gfp_t parameter in dev_coredumpv and
    dev_coredumpm
  mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv

 drivers/base/devcoredump.c                       | 16 ++++++----------
 drivers/bluetooth/btmrvl_sdio.c                  |  2 +-
 drivers/bluetooth/hci_qca.c                      |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c       |  2 +-
 drivers/gpu/drm/etnaviv/etnaviv_dump.c           |  2 +-
 drivers/gpu/drm/msm/disp/msm_disp_snapshot.c     |  4 ++--
 drivers/gpu/drm/msm/msm_gpu.c                    |  4 ++--
 drivers/media/platform/qcom/venus/core.c         |  2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c   |  2 +-
 drivers/net/wireless/ath/ath10k/coredump.c       |  2 +-
 .../net/wireless/ath/wil6210/wil_crash_dump.c    |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c      |  6 ++----
 drivers/net/wireless/marvell/mwifiex/init.c      |  9 +++++----
 drivers/net/wireless/marvell/mwifiex/main.c      |  3 +--
 drivers/net/wireless/marvell/mwifiex/main.h      |  3 ++-
 drivers/net/wireless/marvell/mwifiex/sta_event.c |  6 +++---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c  |  3 +--
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c  |  3 +--
 drivers/net/wireless/realtek/rtw88/main.c        |  2 +-
 drivers/net/wireless/realtek/rtw89/ser.c         |  2 +-
 drivers/remoteproc/qcom_q6v5_mss.c               |  2 +-
 drivers/remoteproc/remoteproc_coredump.c         |  8 ++++----
 include/drm/drm_print.h                          |  2 +-
 include/linux/devcoredump.h                      | 13 ++++++-------
 sound/soc/intel/avs/apl.c                        |  2 +-
 sound/soc/intel/avs/skl.c                        |  2 +-
 sound/soc/intel/catpt/dsp.c                      |  2 +-
 28 files changed, 51 insertions(+), 59 deletions(-)

-- 
2.17.1


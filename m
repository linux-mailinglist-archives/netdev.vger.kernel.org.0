Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C6C24CF38
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgHUHQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgHUHQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:16:49 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69ABEC061386
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:49 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u18so828738wmc.3
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I6WRe1DNPmMYz2suAKa+qs1Ya8MpFkjuyKsOftRNQ1s=;
        b=TBUFBZD1rg3Np8Lb2UmmC8v+fh2kJRixdHWO8ofDNsgOF12inMrg8qltrMoIi1DTj8
         KPF9MsffX7XhyO/zEtOqj3cZHiWAsSMa3sMqJcde6d0ZDp6zf/WYJ+KpHz0I8Bnrfj9n
         FyTGKuPpMNXNApvgnGrbeRGT4f8ftse0Spbvov7MnMimKB6TaRzRD3/8CHCDe/OVjKNC
         15RkxMGgkoJMOZ4PEzTtWMGaF0OMofv5lb9xr5Tw5xIF4fjdq9almyEDsHLUyObsXBBI
         a0F7dfjxmuooIXDKHN2aWGQ23yzfNg1iPDk9T4ckzHDcac2ctFvDBawK8cIJ4XpCyf1F
         hMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I6WRe1DNPmMYz2suAKa+qs1Ya8MpFkjuyKsOftRNQ1s=;
        b=e5JyPTrTScejyCe5EdVUOGqJfVSm5D45uB66mNsagKeQyN8Lh2FtQpSQVmraM/foyf
         V7U7Nn7H81NHIKbNxm7/5Q9rXastc3KQKLlyiAddsmQDXJ5frOQPWXrz56FRkDM9ReLv
         slh1Umov8aunBXQqhKqnwSqCFUqGgjPj4BH/2ox6DrYr/s9wKNADu+UqfIB93pBFPgcp
         uPsKq48iPpTH/EURxDjSeNVTUEoT4EVsQWENmyGopVN5YJJiLXYuTHMql8mNDJ+hdHdU
         I2ovMb4XctmAqlO45FJ4Pj3LVbvPQsBcM73ILN7FWWT+D8GVy3amEsOD6z0YfKqT9w6C
         Mhrg==
X-Gm-Message-State: AOAM530PzJiOC+xyronmpHLxLsCiCxW09Y7PSUuEaJshsEvZlR5B61ww
        8Y2LZka80QNWJ5lTBRdAmAsmlg==
X-Google-Smtp-Source: ABdhPJxgwb0DgdkWDYC0d/filKBy3thLKecF0jLOs4GiMGdboMQW4RAjITGQ66/QvcxcV6Wt2FEFRg==
X-Received: by 2002:a05:600c:2945:: with SMTP id n5mr2115132wmd.66.1597994207849;
        Fri, 21 Aug 2020 00:16:47 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:16:47 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 00/32] Set 2: Rid W=1 warnings in Wireless
Date:   Fri, 21 Aug 2020 08:16:12 +0100
Message-Id: <20200821071644.109970-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

There are quite a few W=1 warnings in the Wireless.  My plan
is to work through all of them over the next few weeks.
Hopefully it won't be too long before drivers/net/wireless
builds clean with W=1 enabled.

This set brings the total number of (arm, arm64, x86, mips and
ppc *combined* i.e. some duplicated) warnings down from 4983
(since the last set) to 2066.

Lee Jones (32):
  wireless: marvell: mwifiex: sdio: Move 'static const struct's into
    their own header file
  wireless: rsi: rsi_91x_mac80211: Add description for function param
    'sta'
  wireless: intel: iwlwifi: mvm: ops: Remove unused static struct
    'iwl_mvm_debug_names'
  wireless: broadcom: brcm80211: brcmsmac: ampdu: Remove a bunch of
    unused variables
  wireless: broadcom: brcm80211: brcmfmac: p2p: Fix a bunch of function
    docs
  wireless: rsi: rsi_91x_mgmt: Add descriptions for
    rsi_set_vap_capabilities()'s parameters
  wireless: intel: iwlwifi: dvm: rx: Demote a couple of nonconformant
    kernel-doc headers
  wireless: intel: iwlwifi: mvm: utils: Fix some doc-rot
  wireless: broadcom: brcm80211: brcmsmac: main: Remove a bunch of
    unused variables
  wireless: rsi: rsi_91x_ps: Source file headers do not make good
    kernel-doc candidates
  wireless: intel: iwlwifi: dvm: scan: Demote a few nonconformant
    kernel-doc headers
  wireless: brcm80211: brcmfmac: firmware: Demote seemingly
    unintentional kernel-doc header
  wireless: intel: iwlwifi: dvm: rxon: Demote non-conformant kernel-doc
    headers
  wireless: rsi: rsi_91x_coex: File headers are not suitable for
    kernel-doc
  wireless: intel: iwlegacy: 4965-mac: Convert function headers to
    standard comment blocks
  wireless: brcm80211: btcoex: Update 'brcmf_btcoex_state' and demote
    others
  wireless: broadcom: b43: phy_ht: Remove 9 year old TODO
  wireless: intel: iwlwifi: mvm: tx: Demote misuse of kernel-doc headers
  wireless: intel: iwlwifi: dvm: devices: Fix function documentation
    formatting issues
  wireless: rsi: rsi_91x_debugfs: Source file headers are not suitable
    for kernel-doc
  wireless: intel: iwlwifi: iwl-drv: Provide descriptions debugfs
    dentries
  wireless: intel: iwlegacy: 4965-rs: Demote non kernel-doc headers to
    standard comment blocks
  wireless: intel: iwlegacy: 4965-calib: Demote seemingly accidental
    kernel-doc header
  wireless: brcmfmac: fwsignal: Remove unused variable
    'brcmf_fws_prio2fifo'
  wireless: ath: wil6210: wmi: Fix formatting and demote non-conforming
    function headers
  wireless: ath: wil6210: interrupt: Demote comment header which is
    clearly not kernel-doc
  wireless: ath: wil6210: txrx: Demote obvious abuse of kernel-doc
  wireless: ath: wil6210: txrx_edma: Demote comments which are clearly
    not kernel-doc
  wireless: realtek: rtl8192c: phy_common: Remove unused variable
    'bbvalue'
  wireless: ath: wil6210: pmc: Demote a few nonconformant kernel-doc
    function headers
  wireless: ath: wil6210: wil_platform: Demote kernel-doc header to
    standard comment block
  wireless: mediatek: mt76x0: Move tables used only by init.c to their
    own header file

 drivers/net/wireless/ath/wil6210/interrupt.c  |   2 +-
 drivers/net/wireless/ath/wil6210/pmc.c        |   8 +-
 drivers/net/wireless/ath/wil6210/txrx.c       |  20 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c  |   6 +-
 .../net/wireless/ath/wil6210/wil_platform.c   |   2 +-
 drivers/net/wireless/ath/wil6210/wmi.c        |  28 +-
 drivers/net/wireless/broadcom/b43/phy_ht.c    |   3 -
 .../broadcom/brcm80211/brcmfmac/btcoex.c      |  12 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c    |   2 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c    |  14 -
 .../broadcom/brcm80211/brcmfmac/p2p.c         |  22 +-
 .../broadcom/brcm80211/brcmsmac/ampdu.c       |  28 +-
 .../broadcom/brcm80211/brcmsmac/main.c        |  38 +-
 .../net/wireless/intel/iwlegacy/4965-calib.c  |   2 +-
 .../net/wireless/intel/iwlegacy/4965-mac.c    |  55 +--
 drivers/net/wireless/intel/iwlegacy/4965-rs.c |  10 +-
 .../net/wireless/intel/iwlwifi/dvm/devices.c  |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c |   6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   9 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |   7 +-
 .../wireless/marvell/mwifiex/sdio-tables.h    | 451 ++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/sdio.c   |   1 +
 drivers/net/wireless/marvell/mwifiex/sdio.h   | 427 -----------------
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |   1 +
 .../wireless/mediatek/mt76/mt76x0/initvals.h  | 145 ------
 .../mediatek/mt76/mt76x0/initvals_init.h      | 159 ++++++
 .../realtek/rtlwifi/rtl8192c/phy_common.c     |   3 +-
 drivers/net/wireless/rsi/rsi_91x_coex.c       |   2 +-
 drivers/net/wireless/rsi/rsi_91x_debugfs.c    |   2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c   |   1 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c       |   3 +
 drivers/net/wireless/rsi/rsi_91x_ps.c         |   2 +-
 36 files changed, 738 insertions(+), 762 deletions(-)
 create mode 100644 drivers/net/wireless/marvell/mwifiex/sdio-tables.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/initvals_init.h

-- 
2.25.1


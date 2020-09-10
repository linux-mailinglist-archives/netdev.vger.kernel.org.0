Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13C2263E70
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730353AbgIJHVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729161AbgIJGzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:55:18 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F49C061799
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:54:57 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w2so4474954wmi.1
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bi75izDeyrgG3F/TUHgVGa9WxHluBHgdlM5VA3X/qaQ=;
        b=j35D8Vvpq1cFq8gRDB8iHnKpKAKkesp6F/CabMROYXK5a2pB109LC3SbTXHIU5yX2I
         8+9HNaxkT1wDGrDJCpRdZDI7NHr0+FMVedYZwVOq+k72PSQ6JGowoH0bnQlXXjY2WDOF
         cB0nwOVILh28WIMkM3kXJb16dvOpqPbh9quxwkERSipfWd+xSgEcnRFlmNTCJli38Mrc
         +AUtGzcmG9HxVGwiJjSXXXQn97gARV+ab0H9VThJdbBgN0kWf05qZB5uq/KotlYrfZKc
         29Bb+sNAnl4UjvgoL4lKo3JpDjD7i4G21znVQOxDvyUZ1jPWQEuveWV7Su/o7j+E0du5
         qenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bi75izDeyrgG3F/TUHgVGa9WxHluBHgdlM5VA3X/qaQ=;
        b=eFfOYbXnKGXbOq7wgfJs5yTwtQKzvPaU91FeTbq/xgF1atBmzQmszQqUwHyiKjWrcD
         DFGV1rQ4EijRULO7PO7aMepx9VnPY6E6uM0oCe5pGqsDYGg4F1+7S6UYrz3bfZfx6vbn
         MDoUqAz3400e2qmp7TsjAj1tfgHW5C7GQmpOk2FiuxKJAczqfrLCA/eGc3JFXAneuShi
         YQ8ojTJ2UQ5R7ZEfQxf60czZWpJ7SMN5j2nj/iFvRMVEkUja41hHOXfyKfY8LUF4E3Ye
         qUrMfJy+JaGgIJieX+Kik6C/oJ18/k2IopLngmibphCwzwR4moTI0QjmOZqqP0tJg2U/
         c1aQ==
X-Gm-Message-State: AOAM533LHZOCL2s9zKvio+iUfqjB7U/vtEXbADoSNp9lszX08cdw3Pf/
        m8D8byI9UVS+b0f6rg1ehjRKdg==
X-Google-Smtp-Source: ABdhPJy/9ON89FbE0e0aOcoTMj86yFtAMdm0VRETr7obpaN7dxPNNsAkF38nRpB1I3GAiwyo6LWVoQ==
X-Received: by 2002:a1c:9697:: with SMTP id y145mr6792950wmd.174.1599720893461;
        Wed, 09 Sep 2020 23:54:53 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:54:52 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 00/29] [Set 1,2,3] Rid W=1 warnings in Wireless 
Date:   Thu, 10 Sep 2020 07:54:02 +0100
Message-Id: <20200910065431.657636-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a rebased/re-worked set of patches which have been
previously posted to the mailing list(s).

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

There are quite a few W=1 warnings in the Wireless.  My plan
is to work through all of them over the next few weeks.
Hopefully it won't be too long before drivers/net/wireless
builds clean with W=1 enabled.

Lee Jones (29):
  iwlwifi: dvm: Demote non-compliant kernel-doc headers
  iwlwifi: rs: Demote non-compliant kernel-doc headers
  iwlwifi: dvm: tx: Demote non-compliant kernel-doc headers
  iwlwifi: dvm: lib: Demote non-compliant kernel-doc headers
  iwlwifi: calib: Demote seemingly unintentional kerneldoc header
  wil6210: Fix a couple of formatting issues in 'wil6210_debugfs_init'
  iwlwifi: dvm: sta: Demote a bunch of nonconformant kernel-doc headers
  iwlwifi: mvm: ops: Remove unused static struct 'iwl_mvm_debug_names'
  iwlwifi: dvm: Demote a couple of nonconformant kernel-doc headers
  iwlwifi: mvm: utils: Fix some doc-rot
  iwlwifi: dvm: scan: Demote a few nonconformant kernel-doc headers
  iwlwifi: dvm: rxon: Demote non-conformant kernel-doc headers
  iwlwifi: mvm: tx: Demote misuse of kernel-doc headers
  iwlwifi: dvm: devices: Fix function documentation formatting issues
  iwlwifi: iwl-drv: Provide descriptions debugfs dentries
  wil6210: wmi: Fix formatting and demote non-conforming function
    headers
  wil6210: interrupt: Demote comment header which is clearly not
    kernel-doc
  wil6210: txrx: Demote obvious abuse of kernel-doc
  wil6210: txrx_edma: Demote comments which are clearly not kernel-doc
  wil6210: pmc: Demote a few nonconformant kernel-doc function headers
  wil6210: wil_platform: Demote kernel-doc header to standard comment
    block
  wil6210: wmi: Correct misnamed function parameter 'ptr_'
  ath6kl: wmi: Remove unused variable 'rate'
  ath9k: ar9002_initvals: Remove unused array
    'ar9280PciePhy_clkreq_off_L1_9280'
  ath9k: ar9001_initvals: Remove unused array 'ar5416Bank6_9100'
  ath9k: ar5008_initvals: Remove unused table entirely
  ath9k: ar5008_initvals: Move ar5416Bank{0,1,2,3,7} to where they are
    used
  brcmsmac: phytbl_lcn: Remove unused array 'dot11lcn_gain_tbl_rev1'
  brcmsmac: phy_lcn: Remove unused variable
    'lcnphy_rx_iqcomp_table_rev0'

 drivers/net/wireless/ath/ath6kl/wmi.c         | 10 +-
 .../net/wireless/ath/ath9k/ar5008_initvals.h  | 68 -------------
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   | 31 +++++-
 .../net/wireless/ath/ath9k/ar9001_initvals.h  | 37 -------
 .../net/wireless/ath/ath9k/ar9002_initvals.h  | 14 ---
 drivers/net/wireless/ath/wil6210/debugfs.c    |  8 +-
 drivers/net/wireless/ath/wil6210/interrupt.c  |  4 +-
 drivers/net/wireless/ath/wil6210/pmc.c        | 12 +--
 drivers/net/wireless/ath/wil6210/txrx.c       | 30 ++----
 drivers/net/wireless/ath/wil6210/txrx_edma.c  | 10 +-
 .../net/wireless/ath/wil6210/wil_platform.c   |  3 +-
 drivers/net/wireless/ath/wil6210/wmi.c        | 36 +++----
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c | 55 -----------
 .../brcm80211/brcmsmac/phy/phytbl_lcn.c       | 99 -------------------
 .../net/wireless/intel/iwlwifi/dvm/calib.c    |  2 +-
 .../net/wireless/intel/iwlwifi/dvm/devices.c  |  8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c  |  4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 11 +--
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c   | 12 +--
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c   |  4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c |  6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c |  8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c  | 22 ++---
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c   |  4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  9 --
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  4 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  7 +-
 28 files changed, 120 insertions(+), 403 deletions(-)

-- 
2.25.1


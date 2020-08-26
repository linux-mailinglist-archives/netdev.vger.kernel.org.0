Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2856D252A8C
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgHZJkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgHZJeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:34:06 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F60DC061757
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:06 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id t2so1085636wma.0
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nj39KvvJBDQl5ELAslfY4/i9vvM4QKppfETPhCXArpc=;
        b=jVsOQgq3bmDNN84kXzuXjYV8L219/+agEp0AYrZTWi5mNYBgR3wJWjK+E3NUMNqTSe
         3KFmoA6/7YIs9JZpCb74AcRq9O9xaj6fPkyteXmvcuajLsbeghuzoHxVAHPPXeSg2gQO
         T2GCNNXYeuCb2bro/kdqyOU2+rUESJ8vJX3xsQDV6i6dhGQdBJgDo+knImzjnlvTLXDH
         M1XL3XkTrIlxP3VfixZNTU+3iwZAM27dY/Zol2KPSQp0YzUqPKr3ww3GVEjZ+GsLa6zB
         BRq9+P37N55Se0YARaCTvStQAhPkLSLc6KTxuOjimy3oJ/Ie2JUhsvOqLOfyBBrC3HHt
         KLjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nj39KvvJBDQl5ELAslfY4/i9vvM4QKppfETPhCXArpc=;
        b=gUCIJseMc17lC3sBS84Mf5WwgZGlGRIwIztJskbpUM0HDXdOG+xZ4UFiCnppfNwMcH
         6+gxdnzym4g2g7YAcaqOSso0d97ji5VEWTyx4YvFjQva6dBirt3dX2I4hA9maG3vG7a0
         +XzowdutUfKF7uh0nAHywFIOTMkWM483kfZCpmd+8a2dC5Uua3E1mOTPgMnH4n972v+P
         1dBKgyhRNtFqcLcrpRHcJUzZiegp+tvv2VDjxP8Rxv5D6iXoKqQg4kwrLmSFaM7nnpAD
         YehtPLrzmqqvIFK4vHJTfmNuUAbTUBIiTZpNNyKEB1S3BjxIpXIFuHvdT8pXT/lC+MFQ
         XCEQ==
X-Gm-Message-State: AOAM530UMATxmPml8ZQWDZrVtzFk0NbROd36Mdvhq550w+xad+p8I1kU
        K38eaVSVoEsYVncfhAPXFzLgrHcC7RynSw==
X-Google-Smtp-Source: ABdhPJzkQOqGFOcEg9whbSvuGXmCwHXjNrJoG5glhH0qTG+uI4IMx4m3mRLJ96FmImpnqfyHHaoxLQ==
X-Received: by 2002:a05:600c:2212:: with SMTP id z18mr6041484wml.186.1598434444635;
        Wed, 26 Aug 2020 02:34:04 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:04 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 00/30] Set 3: Rid W=1 warnings in Wireless
Date:   Wed, 26 Aug 2020 10:33:31 +0100
Message-Id: <20200826093401.1458456-1-lee.jones@linaro.org>
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
ppc *combined* i.e. some duplicated) warnings down from 2066
(since the last set) to 1018.

Lee Jones (30):
  wireless: marvell: mwifiex: pcie: Move tables to the only place
    they're used
  wireless: broadcom: brcmsmac: ampdu: Remove a couple set but unused
    variables
  wireless: intel: iwlegacy: 3945-mac: Remove all non-conformant
    kernel-doc headers
  wireless: intel: iwlegacy: 3945-rs: Remove all non-conformant
    kernel-doc headers
  wireless: intel: iwlegacy: 3945: Remove all non-conformant kernel-doc
    headers
  wireless: broadcom: brcmfmac: p2p: Fix a couple of function headers
  wireless: intersil: orinoco_usb: Downgrade non-conforming kernel-doc
    headers
  wireless: broadcom: brcmsmac: phy_cmn: Remove a unused variables
    'vbat' and 'temp'
  wireless: zydas: zd1211rw: zd_chip: Fix formatting
  wireless: zydas: zd1211rw: zd_mac: Add missing or incorrect function
    documentation
  wireless: zydas: zd1211rw: zd_chip: Correct misspelled function
    argument
  wireless: ath: wil6210: wmi: Correct misnamed function parameter
    'ptr_'
  wireless: broadcom: brcm80211: brcmfmac: fwsignal: Finish documenting
    'brcmf_fws_mac_descriptor'
  wireless: ath: ath6kl: wmi: Remove unused variable 'rate'
  wireless: ti: wlcore: debugfs: Remove unused variable 'res'
  wireless: rsi: rsi_91x_sdio: Fix a few kernel-doc related issues
  wireless: ath: ath9k: ar9002_initvals: Remove unused array
    'ar9280PciePhy_clkreq_off_L1_9280'
  wireless: ath: ath9k: ar9001_initvals: Remove unused array
    'ar5416Bank6_9100'
  wireless: intersil: hostap: hostap_hw: Remove unused variable 'fc'
  wireless: wl3501_cs: Fix a bunch of formatting issues related to
    function docs
  wireless: realtek: rtw88: debug: Remove unused variables 'val'
  wireless: rsi: rsi_91x_sdio_ops: File headers are not good kernel-doc
    candidates
  wireless: intersil: prism54: isl_ioctl:  Remove unused variable 'j'
  wireless: marvell: mwifiex: wmm: Mark 'mwifiex_1d_to_wmm_queue' as
    __maybe_unused
  wireless: ath: ath9k: ar5008_initvals: Remove unused table entirely
  wireless: ath: ath9k: ar5008_initvals: Move ar5416Bank{0,1,2,3,7} to
    where they are used
  wireless: broadcom: brcm80211: phy_lcn: Remove a bunch of unused
    variables
  wireless: broadcom: brcm80211: phy_n: Remove a bunch of unused
    variables
  wireless: broadcom: brcm80211: phytbl_lcn: Remove unused array
    'dot11lcnphytbl_rx_gain_info_rev1'
  wireless: broadcom: brcm80211: phytbl_n: Remove a few unused arrays

 drivers/net/wireless/ath/ath6kl/wmi.c         |  10 +-
 .../net/wireless/ath/ath9k/ar5008_initvals.h  |  68 -----
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   |  31 +-
 .../net/wireless/ath/ath9k/ar9001_initvals.h  |  37 ---
 .../net/wireless/ath/ath9k/ar9002_initvals.h  |  14 -
 drivers/net/wireless/ath/wil6210/wmi.c        |   2 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c    |   6 +
 .../broadcom/brcm80211/brcmfmac/p2p.c         |   5 +-
 .../broadcom/brcm80211/brcmsmac/ampdu.c       |   9 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_cmn.c |   6 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c |  40 +--
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c   |  47 +--
 .../brcm80211/brcmsmac/phy/phytbl_lcn.c       |  13 -
 .../brcm80211/brcmsmac/phy/phytbl_n.c         | 268 ------------------
 .../net/wireless/intel/iwlegacy/3945-mac.c    |  24 +-
 drivers/net/wireless/intel/iwlegacy/3945-rs.c |   8 +-
 drivers/net/wireless/intel/iwlegacy/3945.c    |  46 +--
 .../net/wireless/intersil/hostap/hostap_hw.c  |   3 +-
 .../wireless/intersil/orinoco/orinoco_usb.c   |   6 +-
 .../net/wireless/intersil/prism54/isl_ioctl.c |   3 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c   | 149 ++++++++++
 drivers/net/wireless/marvell/mwifiex/pcie.h   | 149 ----------
 drivers/net/wireless/marvell/mwifiex/wmm.h    |   3 +-
 drivers/net/wireless/realtek/rtw88/debug.c    |   6 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c       |   7 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c   |   2 +-
 drivers/net/wireless/ti/wlcore/debugfs.h      |   6 +-
 drivers/net/wireless/wl3501_cs.c              |  22 +-
 drivers/net/wireless/zydas/zd1211rw/zd_chip.c |   4 +-
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c  |  15 +-
 30 files changed, 288 insertions(+), 721 deletions(-)

-- 
2.25.1


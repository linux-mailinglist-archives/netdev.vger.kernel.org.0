Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E66221DE68
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbgGMRVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:21:49 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:25685 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729855AbgGMRVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 13:21:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594660908; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=LqkEksaaJdeOEzzZiYtV6tDqy6i6SqTmgKw78aAkdQE=; b=u7cMB/0YPKD24t1MPPbQq8ykbRJMGLpsyAs8hy1I1wnynyFH0j2ujUiQuMdQADEVO8+n30WO
 IYs++OcbSL+BBTQNkgDtZSEoegBn2WCiX3bwKoOr08G3DLL0SKRVDDx2J8ajhiihsrBX60yx
 kW/iGQ+kqIEuLu6a3Eg6Di+8Too=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f0c98211012768490ecc2ef (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 13 Jul 2020 17:21:37
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 46086C433C6; Mon, 13 Jul 2020 17:21:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E34BC433C8;
        Mon, 13 Jul 2020 17:21:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5E34BC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2020-07-13
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200713172137.46086C433C6@smtp.codeaurora.org>
Date:   Mon, 13 Jul 2020 17:21:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:

  Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-07-13

for you to fetch changes up to dc7bd30b97aac8a97eccef0ffe31f6cefb6e2c3e:

  mt76: mt7615: fix EEPROM buffer size (2020-06-23 11:43:41 +0300)

----------------------------------------------------------------
wireless-drivers fixes for v5.8

First set of fixes for v5.8. Various important fixes for iwlwifi and
mt76.

iwlwifi

* fix sleeping under RCU

* fix a kernel crash when using compressed firmware images

mt76

* tx queueing fixes for mt7615/22/63

* locking fix

* fix a crash during watchdog reset

* fix memory leaks

----------------------------------------------------------------
Felix Fietkau (2):
      mt76: mt76x02: do not access uninitialized NAPI structs
      mt76: mt7615: fix EEPROM buffer size

Jiri Slaby (1):
      iwlwifi: fix crash in iwl_dbg_tlv_alloc_trigger

Johannes Berg (1):
      iwlwifi: mvm: don't call iwl_mvm_free_inactive_queue() under RCU

Kalle Valo (1):
      Merge tag 'mt76-for-kvalo-2020-06-07' of https://github.com/nbd168/wireless

Lorenzo Bianconi (5):
      mt76: add missing lock configuring coverage class
      mt76: mt7615: fix lmac queue debugsfs entry
      mt76: mt7615: fix hw queue mapping
      mt76: overwrite qid for non-bufferable mgmt frames
      mt76: mt7663u: fix memory leaks in mt7663u_probe

 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   | 16 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  8 ++---
 drivers/net/wireless/mediatek/mt76/mt76.h          |  1 +
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |  2 ++
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |  9 ++---
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |  9 ++---
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |  3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    | 20 ++++-------
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    | 15 ---------
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  4 +++
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h | 30 +++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    | 13 ++++----
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |  5 +--
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  3 ++
 drivers/net/wireless/mediatek/mt76/tx.c            |  7 ++++
 drivers/net/wireless/mediatek/mt76/usb.c           | 39 ++++++++++++++--------
 18 files changed, 120 insertions(+), 68 deletions(-)

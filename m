Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E5E35D747
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 07:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244372AbhDMFeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 01:34:05 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:56259 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhDMFeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 01:34:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618292025; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=NkA9TJv1SAkeVUjpfKUuL/EFOJA9G6yGr4vAcnlSftM=; b=lLBMM+ungrrZw6hGKAai6i+UFEi67FL2+OmDb3ziQcZ+4T2l3UzxWU+Uw94tLGco9U9C4DE6
 2/HOaRTLAw39+7rhbl2e259RR/NX5NuaUxUW29extdTC2HmGtzu6NOSs+ZKvZbxjSgtlvtil
 FPPsAYtx4LYmMJZs93NxxP0iSxc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60752d39e0e9c9a6b6278298 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 13 Apr 2021 05:33:45
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0D53FC433ED; Tue, 13 Apr 2021 05:33:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B850AC433C6;
        Tue, 13 Apr 2021 05:33:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B850AC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-next-2021-04-13
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210413053345.0D53FC433ED@smtp.codeaurora.org>
Date:   Tue, 13 Apr 2021 05:33:45 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 2117fce81f6b862aac0673abe8df0c60dca64bfa:

  Merge branch 'psample-Add-additional-metadata-attributes' (2021-03-14 15:00:44 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2021-04-13

for you to fetch changes up to fa9f5d0e0b45a06802f7cb3afed237be6066821e:

  iwlegacy: avoid -Wempty-body warning (2021-04-11 12:31:01 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for v5.13

First set of patches for v5.13. I have been offline for a couple of
and I have a smaller pull request this time. The next one will be
bigger. Nothing really special standing out.

ath11k

* add initial support for QCN9074, but not enabled yet due to firmware problems

* enable radar detection for 160MHz secondary segment

* handle beacon misses in station mode

rtw88

* 8822c: support firmware crash dump

mt7601u

* enable TDLS support

----------------------------------------------------------------
Ajay Singh (1):
      wilc1000: use wilc handler as cookie in request_threaded_irq()

Anilkumar Kolli (6):
      ath11k: Refactor ath11k_msi_config
      ath11k: Move qmi service_ins_id to hw_params
      ath11k: qmi: increase the number of fw segments
      ath11k: Update memory segment count for qcn9074
      ath11k: Add qcn9074 mhi controller config
      ath11k: add qcn9074 pci device support

Arnd Bergmann (1):
      iwlegacy: avoid -Wempty-body warning

Ching-Te Ku (1):
      rtw88: coex: fix A2DP stutters while WL busy + WL scan

Colin Ian King (2):
      ath11k: debugfs: Fix spelling mistake "Opportunies" -> "Opportunities"
      mt7601u: fix always true expression

Dan Carpenter (1):
      rtw88: Fix an error code in rtw_debugfs_set_rsvd_page()

David Mosberger-Tang (1):
      wilc1000: Support chip sleep over SPI

Kalle Valo (4):
      ath11k: print hardware name and version during initialisation
      ath11k: qmi: add more debug messages
      ath11k: qmi: cosmetic changes to error messages
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Karthikeyan Periyasamy (5):
      ath11k: add static window support for register access
      ath11k: add hal support for QCN9074
      ath11k: add data path support for QCN9074
      ath11k: add CE interrupt support for QCN9074
      ath11k: add extended interrupt support for QCN9074

Lavanya Suresh (3):
      ath11k: Fix sounding dimension config in HE cap
      ath11k: Enable radar detection for 160MHz secondary segment
      ath11k: Add support for STA to handle beacon miss

Lorenzo Bianconi (1):
      mt7601u: enable TDLS support

Marcus Folkesson (1):
      wilc1000: write value to WILC_INTR2_ENABLE register

Miaoqing Pan (1):
      ath11k: fix potential wmi_mgmt_tx_queue race condition

Ping-Ke Shih (1):
      rtw88: coex: add power off setting

Po-Hao Huang (1):
      rtw88: 8822c: add LC calibration for RTL8822C

Pradeep Kumar Chitrapu (1):
      ath11k: fix thermal temperature read

Shuah Khan (2):
      ath9k: fix ath_tx_process_buffer() potential null ptr dereference
      Revert "ath9k: fix ath_tx_process_buffer() potential null ptr dereference"

Sriram R (1):
      ath11k: Update signal filled flag during sta_statistics drv op

Youghandhar Chintala (1):
      ath10k: skip the wait for completion to recovery in shutdown path

Zong-Zhe Yang (4):
      rtw88: 8822c: support FW crash dump when FW crash
      rtw88: add flush hci support
      rtw88: fix DIG min setting
      rtw88: 8822c: update tx power limit table to RF v40.1

wengjianfeng (1):
      rtw88: remove unnecessary variable

 drivers/net/wireless/ath/ath10k/snoc.c             |  29 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   2 +-
 drivers/net/wireless/ath/ath11k/ce.c               |  58 +-
 drivers/net/wireless/ath/ath11k/ce.h               |   1 +
 drivers/net/wireless/ath/ath11k/core.c             |  45 +-
 drivers/net/wireless/ath/ath11k/core.h             |   6 +
 .../net/wireless/ath/ath11k/debugfs_htt_stats.c    |   2 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            | 476 ++++++------
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   6 +-
 drivers/net/wireless/ath/ath11k/hal.c              |  96 ++-
 drivers/net/wireless/ath/ath11k/hal.h              |  33 +-
 drivers/net/wireless/ath/ath11k/hal_desc.h         |  13 +-
 drivers/net/wireless/ath/ath11k/hal_tx.c           |   3 +
 drivers/net/wireless/ath/ath11k/hal_tx.h           |   1 +
 drivers/net/wireless/ath/ath11k/hif.h              |  10 +
 drivers/net/wireless/ath/ath11k/hw.c               | 796 +++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/hw.h               |  53 ++
 drivers/net/wireless/ath/ath11k/mac.c              |  88 ++-
 drivers/net/wireless/ath/ath11k/mac.h              |   2 +
 drivers/net/wireless/ath/ath11k/mhi.c              | 116 ++-
 drivers/net/wireless/ath/ath11k/pci.c              | 194 +++--
 drivers/net/wireless/ath/ath11k/pci.h              |  21 +-
 drivers/net/wireless/ath/ath11k/qmi.c              | 118 +--
 drivers/net/wireless/ath/ath11k/qmi.h              |   9 +-
 drivers/net/wireless/ath/ath11k/rx_desc.h          | 212 +++++-
 drivers/net/wireless/ath/ath11k/wmi.c              |  64 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |   2 -
 drivers/net/wireless/intel/iwlegacy/common.c       |   2 -
 drivers/net/wireless/intel/iwlegacy/common.h       |   2 +-
 drivers/net/wireless/mediatek/mt7601u/eeprom.c     |   2 +-
 drivers/net/wireless/mediatek/mt7601u/init.c       |   1 +
 drivers/net/wireless/microchip/wilc1000/netdev.c   |  14 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   2 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |  56 +-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |   6 +
 drivers/net/wireless/realtek/rtw88/coex.c          |  13 +-
 drivers/net/wireless/realtek/rtw88/coex.h          |   1 +
 drivers/net/wireless/realtek/rtw88/debug.c         |  43 +-
 drivers/net/wireless/realtek/rtw88/hci.h           |  16 +
 drivers/net/wireless/realtek/rtw88/mac.c           |  19 +
 drivers/net/wireless/realtek/rtw88/mac.h           |   4 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   2 +
 drivers/net/wireless/realtek/rtw88/main.c          | 104 ++-
 drivers/net/wireless/realtek/rtw88/main.h          |  13 +
 drivers/net/wireless/realtek/rtw88/pci.c           |  69 ++
 drivers/net/wireless/realtek/rtw88/phy.c           |  23 +-
 drivers/net/wireless/realtek/rtw88/phy.h           |   1 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   6 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  39 +-
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    | 686 +++++++++---------
 50 files changed, 2709 insertions(+), 871 deletions(-)

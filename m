Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACADB2AF1
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 12:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfINKOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 06:14:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48556 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfINKOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 06:14:46 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F10BA60770; Sat, 14 Sep 2019 10:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568456084;
        bh=fUu3G73u8wJrx9tfph3HNlcTBRREdUClNrhZxCLdNq4=;
        h=From:To:Cc:Subject:Date:From;
        b=DdWW76/ap19/OyQsbTmDueeCp85kj0cW/QU58RqlnDD4Uud8dq0b0i3oAg3EWw+0Y
         GS/OrBn2ceMinw1aL5sROT9kqTOpLm010q3CxSQzCasYx0v67pH4Z4J5UBLXcmoZ3h
         1VflemmACp9o4X7MIjKZpr6e2eBkUfHI8IWXZ3t4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D6469607F1;
        Sat, 14 Sep 2019 10:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568456084;
        bh=fUu3G73u8wJrx9tfph3HNlcTBRREdUClNrhZxCLdNq4=;
        h=From:To:Cc:Subject:Date:From;
        b=DdWW76/ap19/OyQsbTmDueeCp85kj0cW/QU58RqlnDD4Uud8dq0b0i3oAg3EWw+0Y
         GS/OrBn2ceMinw1aL5sROT9kqTOpLm010q3CxSQzCasYx0v67pH4Z4J5UBLXcmoZ3h
         1VflemmACp9o4X7MIjKZpr6e2eBkUfHI8IWXZ3t4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D6469607F1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2019-09-14
Date:   Sat, 14 Sep 2019 13:14:40 +0300
Message-ID: <87r24jchgv.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here's a pull request to net-next tree for v5.4, more info below. Please
let me know if there are any problems.

Kalle

The following changes since commit 172ca8308b0517ca2522a8c885755fd5c20294e7:

  cxgb4: Fix spelling typos (2019-09-12 12:50:56 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2019-09-14

for you to fetch changes up to f9e568754562e0f506e12aa899c378b4155080e9:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2019-09-13 18:15:58 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 5.4

Last set of patches for 5.4. wil6210 and rtw88 being most active this
time, but ath9k also having a new module to load devices without
EEPROM.

Major changes:

wil6210

* add support for Enhanced Directional Multi-Gigabit (EDMG) channels 9-11

* add debugfs file to show PCM ring content

* report boottime_ns in scan results

ath9k

* add a separate loader for AR92XX (and older) pci(e) without eeprom

brcmfmac

* use the same wiphy after PCIe reset to not confuse the user space

rtw88

* enable interrupt migration

* enable AMSDU in AMPDU aggregation

* report RX power for each antenna

* enable to DPK and IQK calibration methods to improve performance

----------------------------------------------------------------
Ahmad Masri (1):
      wil6210: fix PTK re-key race

Alexei Avshalom Lazar (2):
      wil6210: Add EDMG channel support
      wil6210: verify cid value is valid

Arnd Bergmann (1):
      wcn36xx: use dynamic allocation for large variables

Ben Greear (1):
      ath10k: free beacon buf later in vdev teardown

Chin-Yen Lee (1):
      rtw88: 8822c: update pwr_seq to v13

Christian Lamparter (1):
      ath9k: add loader for AR92XX (and older) pci(e)

Colin Ian King (4):
      wil6210: fix wil_cid_valid with negative cid values
      rtlwifi: rtl8821ae: make array static const and remove redundant assi=
gnment
      bcma: make arrays pwr_info_offset and sprom_sizes static const, shrin=
ks object size
      ssb: make array pwr_info_offset static const, makes object smaller

Dedy Lansky (4):
      wil6210: add wil_netif_rx() helper function
      wil6210: add debugfs to show PMC ring content
      wil6210: make sure DR bit is read before rest of the status message
      wil6210: properly initialize discovery_expired_work

Hui Peng (1):
      ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()

Jia-Ju Bai (1):
      ath6kl: Fix a possible null-pointer dereference in ath6kl_htc_mbox_cr=
eate()

Kalle Valo (1):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Larry Finger (9):
      rtlwifi: rtl8723ae: Remove unused GET_XXX and SET_XXX macros
      rtlwifi: rtl8723ae: Replace local bit manipulation macros
      rtlwifi: rtl8723ae: Convert macros that set descriptor
      rtlwifi: rtl8723ae: Convert inline routines to little-endian words
      rtlwifi: rtl8723be: Remove unused SET_XXX and GET_XXX macros
      rtlwifi: rtl8723be: Replace local bit manipulation macros
      rtlwifi: rtl8723be: Convert macros that set descriptor
      rtlwifi: rtl8723be: Convert inline routines to little-endian words
      rtlwifi: rtl8188ee: rtl8192ce: rtl8192de: rtl8723ae: rtl8821ae: Remov=
e some unused bit manipulation macros

Lior David (3):
      wil6210: use writel_relaxed in wil_debugfs_iomem_x32_set
      wil6210: fix RX short frame check
      wil6210: ignore reset errors for FW during probe

Lorenzo Bianconi (5):
      ath9k: dynack: fix possible deadlock in ath_dynack_node_{de}init
      ath9k: dyanck: introduce ath_dynack_set_timeout routine
      ath9k: dynack: properly set last timeout timestamp in ath_dynack_reset
      ath9k: dynack: set max timeout according to channel width
      ath9k: dynack: set ackto to max timeout in ath_dynack_reset

Lubomir Rintel (1):
      libertas: use mesh_wdev->ssid instead of priv->mesh_ssid

Luis Correia (1):
      CREDITS: Update email address

Markus Elfring (1):
      wil6210: Delete an unnecessary kfree() call in wil_tid_ampdu_rx_alloc=
()

Maya Erez (1):
      wil6210: report boottime_ns in scan results

Michael Straube (3):
      rtlwifi: rtl8192ce: replace _rtl92c_evm_db_to_percentage with generic=
 version
      rtlwifi: rtl8192cu: replace _rtl92c_evm_db_to_percentage with generic=
 version
      rtlwifi: rtl8192de: replace _rtl92d_evm_db_to_percentage with generic=
 version

Navid Emamdoost (2):
      ath9k_htc: release allocated buffer if timed out
      ath9k: release allocated buffer if timed out

Nicolas Boichat (1):
      ath10k: adjust skb length in ath10k_sdio_mbox_rx_packet

Rafa=C5=82 Mi=C5=82ecki (3):
      brcmfmac: move "cfg80211_ops" pointer to another struct
      brcmfmac: split brcmf_attach() and brcmf_detach() functions
      brcmfmac: don't realloc wiphy during PCIe reset

Rakesh Pillai (1):
      ath10k: fix channel info parsing for non tlv target

Tsang-Shian Lin (2):
      rtw88: 8822c: Enable interrupt migration
      rtw88: fix wrong rx power calculation

Tzu-En Huang (2):
      rtw88: 8822c: add SW DPK support
      rtw88: add dynamic cck pd mechanism

Wen Gong (2):
      ath10k: add mic bytes for pmf management packet
      ath10k: add reorder and change PN check logic for mac80211

Yan-Hsuan Chuang (5):
      rtw88: 8822c: update PHY parameter to v38
      rtw88: 8822c: add FW IQK support
      rtw88: move IQK/DPK into phy_calibration
      rtw88: allows to receive AMSDU in AMPDU
      rtw88: report RX power for each antenna

YueHaibing (1):
      carl9170: remove set but not used variable 'udev'

zhong jiang (2):
      ath9k: Remove unneeded variable to store return value
      brcmsmac: Use DIV_ROUND_CLOSEST directly to make it readable

 CREDITS                                            |    2 +-
 drivers/bcma/sprom.c                               |   10 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   91 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |    8 +
 drivers/net/wireless/ath/ath10k/mac.c              |    9 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   29 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |    2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |   16 +
 drivers/net/wireless/ath/ath10k/wmi.h              |    8 -
 drivers/net/wireless/ath/ath6kl/htc_mbox.c         |    4 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |    8 +
 drivers/net/wireless/ath/ath9k/Kconfig             |   16 +
 drivers/net/wireless/ath/ath9k/Makefile            |    2 +
 .../net/wireless/ath/ath9k/ath9k_pci_owl_loader.c  |  215 +
 drivers/net/wireless/ath/ath9k/dynack.c            |  101 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    4 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    3 +
 drivers/net/wireless/ath/ath9k/wmi.c               |    1 +
 drivers/net/wireless/ath/carl9170/usb.c            |    2 -
 drivers/net/wireless/ath/wcn36xx/smd.c             |  186 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  221 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |   16 +-
 drivers/net/wireless/ath/wil6210/main.c            |    4 +
 drivers/net/wireless/ath/wil6210/netdev.c          |    4 +
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |    4 +-
 drivers/net/wireless/ath/wil6210/pmc.c             |   26 +
 drivers/net/wireless/ath/wil6210/pmc.h             |    1 +
 drivers/net/wireless/ath/wil6210/rx_reorder.c      |    1 -
 drivers/net/wireless/ath/wil6210/txrx.c            |  244 +-
 drivers/net/wireless/ath/wil6210/txrx.h            |   42 +
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |   40 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.h       |   12 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |   25 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   43 +-
 drivers/net/wireless/ath/wil6210/wmi.h             |   29 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |    4 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    1 -
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |    1 -
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   42 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   15 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   34 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |   14 +-
 drivers/net/wireless/marvell/libertas/dev.h        |    2 -
 drivers/net/wireless/marvell/libertas/mesh.c       |   31 +-
 drivers/net/wireless/marvell/libertas/mesh.h       |    3 +-
 drivers/net/wireless/realtek/rtlwifi/base.h        |   27 -
 .../net/wireless/realtek/rtlwifi/rtl8188ee/def.h   |   29 -
 .../net/wireless/realtek/rtlwifi/rtl8192ce/def.h   |   33 -
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |   23 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   |   18 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/def.h   |   31 -
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |   18 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/def.h   |   31 -
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |  212 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.h   |  794 +--
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |  236 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.h   |  718 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/def.h   |   31 -
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |    4 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |    2 +-
 drivers/net/wireless/realtek/rtw88/coex.h          |    1 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    2 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    1 +
 drivers/net/wireless/realtek/rtw88/main.h          |   56 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |  145 +
 drivers/net/wireless/realtek/rtw88/phy.h           |    2 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   17 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    8 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      | 1188 +++-
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |   86 +
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    | 6930 ++++++++++++++--=
----
 .../net/wireless/realtek/rtw88/rtw8822c_table.h    |    3 +
 drivers/net/wireless/realtek/rtw88/rx.c            |    5 +
 drivers/ssb/pci.c                                  |    2 +-
 76 files changed, 8589 insertions(+), 3654 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c

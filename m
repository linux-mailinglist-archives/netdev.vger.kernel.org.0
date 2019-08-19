Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F5F949D5
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbfHSQ2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:28:34 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43022 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfHSQ2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 12:28:34 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7084060735; Mon, 19 Aug 2019 16:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566232112;
        bh=oFPm0akAMtPV52h7/LybKDpRV5+FKT/K+TDMwnYBG2Q=;
        h=From:To:Cc:Subject:Date:From;
        b=AFLO6GO9oHuIRdAvuil9gfbDD3aKpSwq2LXt7qLx8TgjwXvabDDjlHdy906M7ngDO
         2gdeNETxRdhS+nZnsYQuqw9/1F/Xnrq0a0ZNqyc8i1snJFEkyBl0fhFQra5bmPuYx4
         EOAchQ/44MMuyD3BrfNH+G9oXiiN34mMs3XXpl20=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7F5CD60112;
        Mon, 19 Aug 2019 16:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566232111;
        bh=oFPm0akAMtPV52h7/LybKDpRV5+FKT/K+TDMwnYBG2Q=;
        h=From:To:Cc:Subject:Date:From;
        b=nMOiqkcp5eO+uu+gZ39vxilL50Ex8HCrAL16dn/g0dAmLSWQeXlXz1g1iMAhL1CpF
         qIWtR/4bzBLhOoqkp2Qu4jMsYO1g1+9Z5kkkhK3bP7MhAq2swFSYpDZ19hle1DxPK8
         6kzGDWauCiaq2tSzwkycEBXqxa2ddo5ShmO1X8aU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7F5CD60112
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2019-08-19
Date:   Mon, 19 Aug 2019 19:28:28 +0300
Message-ID: <87tvad9l1v.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here's a pull request to net-next for v5.4, more info below. Please let
me know if there are any problems.

Kalle

The following changes since commit 3e3bb69589e482e0783f28d4cd1d8e56fda0bcbb:

  tc-testing: added tdc tests for [b|p]fifo qdisc (2019-07-23 14:08:15 -070=
0)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2019-08-19

for you to fetch changes up to 6004cf298a4180199dc40bc40466126df8a5a88c:

  b43legacy: Remove pointless cond_resched() wrapper (2019-08-06 15:43:50 +=
0300)

----------------------------------------------------------------
wireless-drivers-next patches for 5.4

First set of patches for 5.4.

Major changes:

brcmfmac

* enable 160 MHz channel support

rt2x00

* add support for PLANEX GW-USMicroN USB device

rtw88

* add Bluetooth coexistance support

----------------------------------------------------------------
Arend van Spriel (10):
      brcmfmac: add 160MHz in chandef_to_chanspec()
      brcmfmac: enable DFS_OFFLOAD extended feature if supported
      brcmfmac: allow 160MHz in custom regulatory rules
      Revert "brcmfmac: fix NULL pointer derefence during USB disconnect"
      brcmfmac: change the order of things in brcmf_detach()
      brcmfmac: avoid firmware command in brcmf_netdev_open() when bus is d=
own
      brcmfmac: clear events in brcmf_fweh_detach() will always fail
      brcmfmac: avoid firmware commands when bus is down
      brcmfmac: simply remove flowring if bus is down
      brcmfmac: remove unnecessary strlcpy() upon obtaining "ver" iovar

Brian Norris (2):
      rtw88: use txpwr_lmt_cfg_pair struct, not arrays
      Revert "mwifiex: fix system hang problem after resume"

Chris Chiu (1):
      rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU

Chuhong Yuan (5):
      bcma: Use dev_get_drvdata
      iwlegacy: Use dev_get_drvdata where possible
      mwifiex: pcie: Use dev_get_drvdata
      qtnfmac_pcie: Use dev_get_drvdata
      rtlwifi: rtl_pci: Use dev_get_drvdata

Colin Ian King (3):
      libertas: remove redundant assignment to variable ret
      wl3501_cs: remove redundant variable rc
      ipw2x00: remove redundant assignment to err

Dan Williams (1):
      libertas: Fix a double free in if_spi_c2h_data()

Enrico Weigelt (1):
      rsi: return explicit error values

Ganapathi Kondraju (2):
      rsi: fix for sdio interface setup in 9116
      rsi: fix for sdio reset card issue

Greg Kroah-Hartman (1):
      rt2x00: no need to check return value of debugfs_create functions

Hariprasad Kelam (1):
      rtlwifi: btcoex: fix issue possible condition with no effect (if =3D=
=3D else)

Jian-Hong Pan (2):
      rtw88: pci: Rearrange the memory usage for skb in RX ISR
      rtw88: pci: Use DMA sync instead of remapping in RX ISR

Joe Perches (1):
      rtw88: Fix misuse of GENMASK macro

Kevin Easton (1):
      libertas: Add missing sentinel at end of if_usb.c fw_table

Larry Finger (9):
      rtlwifi: rtl8188ee: Remove unused GET_XXX and SET_XXX descriptor macr=
os
      rtlwifi: rtl88188ee: Replace local bit manipulation macros
      rtlwifi: rtl8188ee: Convert macros that set descriptor
      rtlwifi: rtl8188ee: Convert inline routines to little-endian words
      rtlwifi: rtl8188ee: Remove local configuration variable
      rtlwifi: rtl8192ce: Remove unused GET_XXX and SET_XXX
      rtlwifi: rtl8192ce: Replace local bit manipulation macros
      rtlwifi: rtl8192ce: Convert macros that set descriptor
      rtlwifi: rtl8192ce: Convert inline routines to little-endian words

Mao Wenan (1):
      mwifiex: use eth_broadcast_addr() to assign broadcast address

Masanari Iida (1):
      rt2800usb: Add new rt2800usb device PLANEX GW-USMicroN

Navid Emamdoost (1):
      mt7601u: null check the allocation

Pavel Machek (1):
      mwifiex: make error values consistent in mwifiex_update_bss_desc_with=
_ie()

Ping-Ke Shih (1):
      rtlwifi: remove assignment to itself

Rafa=C5=82 Mi=C5=82ecki (1):
      brcmfmac: don't net_ratelimit() CONSOLE messages on firmware crash

Soeren Moch (1):
      rt2x00usb: remove unnecessary rx flag checks

Stanislaw Gruszka (1):
      mt7601u: use params->ssn value directly

Thomas Gleixner (1):
      b43legacy: Remove pointless cond_resched() wrapper

Yan-Hsuan Chuang (3):
      rtw88: allow c2h operation in irq context
      rtw88: enclose c2h cmd handle with mutex
      rtw88: add BT co-existence support

YueHaibing (5):
      libertas_tf: Use correct channel range in lbtf_geo_init
      rtlwifi: remove unneeded function _rtl_dump_channel_map()
      brcmfmac: remove set but not used variable 'dtim_period'
      brcmsmac: remove three set but not used variables
      rtw88: pci: remove set but not used variable 'ip_sel'

Zong-Zhe Yang (1):
      rtw88: debug: dump tx power indexes in use

 drivers/bcma/host_pci.c                            |    6 +-
 drivers/net/wireless/broadcom/b43legacy/phy.c      |   21 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |   11 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.h    |    6 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   61 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |    1 -
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   30 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |    4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |    9 -
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |   16 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |    3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    7 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.c   |   10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |    3 +-
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |   13 -
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |    2 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |    3 +-
 drivers/net/wireless/marvell/libertas/if_spi.c     |   14 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |    3 +-
 drivers/net/wireless/marvell/libertas/main.c       |    2 +-
 drivers/net/wireless/marvell/libertas_tf/cmd.c     |    2 +-
 drivers/net/wireless/marvell/mwifiex/init.c        |    2 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |    8 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |    2 +-
 drivers/net/wireless/marvell/mwifiex/tdls.c        |    3 +-
 drivers/net/wireless/mediatek/mt7601u/init.c       |    3 +
 drivers/net/wireless/mediatek/mt7601u/main.c       |    4 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |    4 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |    1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c   |  136 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |    9 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |   11 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    3 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |    8 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |    6 +-
 drivers/net/wireless/realtek/rtlwifi/regd.c        |   18 -
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |    7 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.c    |    4 -
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |  257 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.h   | 1046 ++++----
 .../net/wireless/realtek/rtlwifi/rtl8192ce/sw.c    |    2 -
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |  215 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.h   |  803 +++---
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    |    2 -
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |    2 -
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.c    |    4 -
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |    4 -
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |    4 -
 drivers/net/wireless/realtek/rtw88/Makefile        |    1 +
 drivers/net/wireless/realtek/rtw88/coex.c          | 2507 ++++++++++++++++=
+++
 drivers/net/wireless/realtek/rtw88/coex.h          |  369 +++
 drivers/net/wireless/realtek/rtw88/debug.c         |  112 +
 drivers/net/wireless/realtek/rtw88/fw.c            |  135 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |   73 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   19 +
 drivers/net/wireless/realtek/rtw88/main.c          |   45 +-
 drivers/net/wireless/realtek/rtw88/main.h          |  233 ++
 drivers/net/wireless/realtek/rtw88/pci.c           |   74 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |   15 +-
 drivers/net/wireless/realtek/rtw88/phy.h           |    9 +
 drivers/net/wireless/realtek/rtw88/ps.c            |    9 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   62 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |  462 +++-
 .../net/wireless/realtek/rtw88/rtw8822b_table.c    | 1564 +++++++++---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  355 ++-
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    | 2635 +++++++++++++---=
----
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |   31 +-
 drivers/net/wireless/wl3501_cs.c                   |    4 +-
 70 files changed, 8606 insertions(+), 2907 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/coex.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/coex.h

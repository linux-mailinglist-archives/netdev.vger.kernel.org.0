Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3533318FB4
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhBKQQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhBKQOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 11:14:22 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63666C061574;
        Thu, 11 Feb 2021 08:13:42 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id d24so8859586lfs.8;
        Thu, 11 Feb 2021 08:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition;
        bh=PtM6Tv68YQwsbF74pb3s4bcYrMCYksWul3XAtogUcWU=;
        b=hhBtLxzffXw/s5HGE9r/FUYX8J+A88Qw5wxx/00EIEznIZeoBmCGuVRb6ZamIM4KGO
         a/88gYUhHf90Wdb3KWOJUUSniWQdzPFiQlIHM8aaXc28g0pY2RCQAY+nm5SeXDj/bu9V
         z0cBvvP2n5a8iHLA23BJKlLbCoZDna4Xso+EVIM9pKkR88qY0qNGQUj4+jhUoBjJBveI
         uzFmfkve/BTl20v73OkhSz2kbCnJYnepWddbk9VXl/PvobtO88wICUCDDU5doqRpTqxN
         TBTWyBvBi/6jazAys1T6o4CEmdvdpvE7wwtzyf/wgDY4DRKXiXStZwP8TzgkN2eRrsIn
         mWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition;
        bh=PtM6Tv68YQwsbF74pb3s4bcYrMCYksWul3XAtogUcWU=;
        b=IoDMA4pKHc8iS50nTSKaHm4wK8YGxjR2WXC81/Axmb0VxUUk7kJ7YdEHnhDOA+PM2H
         gMCft8HJXH6xnZXB+lJZaxXcRgdmELSA5jhxZKclmuVA1nhkdsHM4fN4bPf4kBy50y7z
         1rgV8PH1KC3DGHiUkP9SN8MV6NMUEH6wi11B22GbmKd0NuSGzHM+hLmSzp4hhKZchy2Q
         8fZpTiPGT2+l9SutJAiPVPdCXfyQvCH3YMdCfn/o7EMRLpBJXJCHW26AfxdipLkDLOmh
         DidNtlhl3wOS1Zz+7bYktQz+NFVDUATTGP3n4c+G41hyqnfA0wPfQtqdkzMciCQEdecv
         cEDw==
X-Gm-Message-State: AOAM530YWh+adXrUSnxivTJ7T2tAA8G1trN0g2+JCW56wCSewOk4+4l5
        1mEEjM1i7l5btNQyGEU+7uhMs/feAO1SsLX9
X-Google-Smtp-Source: ABdhPJw86wyb+R7A/te63IoIktKs7ap9wGTuD0olwKpCjrRHVg5aimTQzeB/deXlXhyYbZB8yKe3MQ==
X-Received: by 2002:a19:357:: with SMTP id 84mr4598340lfd.68.1613060020856;
        Thu, 11 Feb 2021 08:13:40 -0800 (PST)
Received: from localhost (91-154-113-38.elisa-laajakaista.fi. [91.154.113.38])
        by smtp.gmail.com with ESMTPSA id t20sm218756lfl.116.2021.02.11.08.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 08:13:39 -0800 (PST)
Date:   Thu, 11 Feb 2021 18:13:38 +0200
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2021-02-11
Message-ID: <YCVXKF1pn6N8p0CK@lschmidt-MOBL.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="N127i058iNjEYKqT"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--N127i058iNjEYKqT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave, Jakub,

Here's the main bluetooth-next pull request for 5.12:

 - Add support for advertising monitor offliading using Microsoft
   vendor extensions
 - Add firmware download support for MediaTek MT7921U USB devices
 - Suspend-related fixes for Qualcomm devices
 - Add support for Intel GarfieldPeak controller
 - Various other smaller fixes & cleanups

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9:

  Merge tag 'staging-5.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging (2020-12-15 14:18:40 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 55c0bd77479b60ea29fd390faf4545cfb3a1d79e:

  Bluetooth: hci_qca: Fixed issue during suspend (2021-02-08 14:54:07 +0100)

----------------------------------------------------------------
Abhishek Pandit-Subedi (4):
      Bluetooth: Remove hci_req_le_suspend_config
      Bluetooth: Pause service discovery for suspend
      Bluetooth: btrtl: Enable central-peripheral role
      Bluetooth: btrtl: Add null check in setup

Archie Pusaka (6):
      Bluetooth: advmon offload MSFT add rssi support
      Bluetooth: advmon offload MSFT add monitor
      Bluetooth: advmon offload MSFT remove monitor
      Bluetooth: advmon offload MSFT handle controller reset
      Bluetooth: advmon offload MSFT handle filter enablement
      Bluetooth: advmon offload MSFT interleave scanning integration

Ard Biesheuvel (1):
      Bluetooth: avoid u128_xor() on potentially misaligned inputs

Arnd Bergmann (1):
      Bluetooth: btusb: fix excessive stack usage

Bastien Nocera (1):
      Bluetooth: L2CAP: Try harder to accept device not knowing options

Christophe JAILLET (1):
      Bluetooth: btqcomsmd: Fix a resource leak in error handling paths in the probe function

Christopher William Snowhill (1):
      Bluetooth: Fix initializing response id after clearing struct

Claire Chang (2):
      Bluetooth: hci_uart: Fix a race for write_work scheduling
      Bluetooth: hci_h5: Set HCI_QUIRK_SIMULTANEOUS_DISCOVERY for btrtl

Dinghao Liu (1):
      Bluetooth: hci_qca: Fix memleak in qca_controller_memdump

Geert Uytterhoeven (1):
      dt-bindings: net: btusb: DT fix s/interrupt-name/interrupt-names/

Gopal Tiwari (1):
      Bluetooth: Fix null pointer dereference in amp_read_loc_assoc_final_data

Hans de Goede (1):
      Bluetooth: Add new HCI_QUIRK_NO_SUSPEND_NOTIFIER quirk

Howard Chung (2):
      Bluetooth: disable advertisement filters during suspend
      Bluetooth: Fix crash in mgmt_add_adv_patterns_monitor_complete

Hui Wang (2):
      Bluetooth: btusb: Fix the autosuspend enable and disable
      Bluetooth: btusb: Some Qualcomm Bluetooth adapters stop working

Jagdish Tirumala (1):
      Bluetooth: btmtksdio: Fixed switch and case should be at the same indent

Jakub Pawlowski (1):
      Bluetooth: hci_bcm: Add support for ISO packets

Jiapeng Zhong (1):
      Bluetooth: fix coccicheck warnings debugfs

Joe Perches (1):
      Bluetooth: btusb: Remove duplicate newlines from logging

John-Eric Kamps (1):
      Bluetooth: hci_h5: Add support for binding RTL8723DS with device tree

Jupeng Zhong (2):
      Bluetooth: btusb: Fix memory leak in btusb_mtk_wmt_recv
      Bluetooth: btusb: Fix typo and correct the log print

Kiran K (2):
      Revert "Bluetooth: btintel: Fix endianness issue for TLV version information"
      Bluetooth: btusb: Add support for GarfieldPeak controller

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix handling fragmented length

Mark Chen (2):
      Bluetooth: btusb: Fine-tune mt7663 mechanism.
      Bluetooth: btusb: Add protocol support for MediaTek MT7921U USB devices

Max Chou (1):
      Bluetooth: btrtl: Enable WBS for the specific Realtek devices

Miao-chen Chou (3):
      Bluetooth: btqca: Enable MSFT extension for Qualcomm WCN399x
      Bluetooth: btusb: Enable MSFT extension for Intel controllers
      Bluetooth: btrtl: Enable MSFT extension for RTL8822CE controller

Pan Bian (2):
      Bluetooth: drop HCI device reference before return
      Bluetooth: Put HCI device if inquiry procedure interrupts

Sonny Sasaka (1):
      Bluetooth: Cancel Inquiry before Create Connection

Tim Jiang (1):
      Bluetooth: btusb: add shutdown function for wcn6855

Tomoyuki Matsushita (1):
      Bluetooth: fix indentation and alignment reported by checkpatch

Trent Piepho (1):
      Bluetooth: btusb: Always fallback to alt 1 for WBS

Vamshi K Sthambamkadi (1):
      Bluetooth: btusb: fix memory leak on suspend and resume

Venkata Lakshmi Narayana Gubba (4):
      Bluetooth: btqca: Add support to read FW build version for WCN3991 BTSoC
      Bluetooth: hci_qca: Wait for SSR completion during suspend
      Bluetooth: hci_qca: check for SSR triggered flag while suspend
      Bluetooth: hci_qca: Fixed issue during suspend

Ye Bin (1):
      Bluetooth: btusb: remove set but not used variable in btusb_mtk_setup_firmware_79xx

Yu Liu (1):
      Bluetooth: Skip eSCO 2M params when not supported

 Documentation/devicetree/bindings/net/btusb.txt |   2 +-
 drivers/bluetooth/btintel.c                     |  21 +-
 drivers/bluetooth/btmtksdio.c                   |  16 +-
 drivers/bluetooth/btqca.c                       |  67 ++++
 drivers/bluetooth/btqca.h                       |   1 +
 drivers/bluetooth/btqcomsmd.c                   |  27 +-
 drivers/bluetooth/btrtl.c                       |  43 ++-
 drivers/bluetooth/btusb.c                       | 313 +++++++++++++---
 drivers/bluetooth/hci_bcm.c                     |   1 +
 drivers/bluetooth/hci_h5.c                      |   7 +
 drivers/bluetooth/hci_ldisc.c                   |   7 +-
 drivers/bluetooth/hci_qca.c                     |  33 +-
 drivers/bluetooth/hci_serdev.c                  |   4 +-
 include/net/bluetooth/hci.h                     |   8 +
 include/net/bluetooth/hci_core.h                |  37 +-
 include/net/bluetooth/l2cap.h                   |   1 +
 include/net/bluetooth/mgmt.h                    |  16 +
 net/bluetooth/a2mp.c                            |   3 +-
 net/bluetooth/af_bluetooth.c                    |  22 +-
 net/bluetooth/amp.c                             |   3 +
 net/bluetooth/hci_conn.c                        |  37 +-
 net/bluetooth/hci_core.c                        | 201 ++++++++---
 net/bluetooth/hci_debugfs.c                     |  80 ++---
 net/bluetooth/hci_request.c                     |  74 ++--
 net/bluetooth/l2cap_core.c                      | 119 ++++--
 net/bluetooth/mgmt.c                            | 399 +++++++++++++++-----
 net/bluetooth/msft.c                            | 460 +++++++++++++++++++++++-
 net/bluetooth/msft.h                            |  30 ++
 net/bluetooth/smp.c                             |   5 +-
 29 files changed, 1694 insertions(+), 343 deletions(-)

--N127i058iNjEYKqT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQ8m6QjaLXd1XJ73Dsfyv3T9pQ3KgUCYCVXsgAKCRAfyv3T9pQ3
KnZcAQDwRUSlrnmH9jIU3nuowj4nLtq/xAhjkX9X1ET7V420uwEAqjmGXtoTq/Dx
z2Isy+ViN3OK/LUQvwCijNmXzrV5rwM=
=LwR2
-----END PGP SIGNATURE-----

--N127i058iNjEYKqT--

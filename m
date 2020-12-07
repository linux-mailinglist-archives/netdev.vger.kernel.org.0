Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A469B2D1470
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 16:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgLGPKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 10:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgLGPKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 10:10:00 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F9DC061749;
        Mon,  7 Dec 2020 07:09:20 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id m9so9122450pgb.4;
        Mon, 07 Dec 2020 07:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition;
        bh=tOzVtXqH2yrWHxYYbEQsQ165KXiOY4/rdio2NcOF61Q=;
        b=h/M+N/iJvfINxui6doCTnSk35ZV8UkZmLztZ4umaV9WjleYREqFS2JBi7AkadBS/40
         okP4/C3a/7xD9z3D6Nv5GUOOxH+kEUtiFqYf6Y4ELpTXiNBlQqv1WxTa9Ho5XqE11wwh
         ejzSw3bj/sWTdbynQVxnLJDoQdvNoxjULi8cMqcQM0mDgpo4JEalYY55BzJrfVmPftNg
         rxN7hDgdZhLwWdXRa2BX9LKNxKmm4oPhkctu8nqsPfpToI6jgpqpkV8XkoIlu8P63qCw
         Njqc9umxwcdfHHgOzv1Pxrhahh+ofv+bh+1QONjDy/kFn7Zv/sSuCphMGCsWonei15QQ
         wBWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition;
        bh=tOzVtXqH2yrWHxYYbEQsQ165KXiOY4/rdio2NcOF61Q=;
        b=kFF0foACNIrmiP/0Dh8gGe4FrggnVRrUOcpKjFkoi/h3/mJY/Zu1CW+TZEaktj1moh
         QVu7W0ha+cHB+Na9rGrb0j72ChWTszaHKnjPI/SsMgM8sz7PUY6g5PMKsfuitPF+PE0t
         B50XkhJG83WdVOTt1tsxDalX75ABlAciBBbozOfFuKXJMmrykaznHtfhnI1rUFDQrDxc
         eX3eDbeodE5con4/6qT4w6lWXG3Y+P1WP8ZWfhHWy0TfFfapw46YaXjsZTc8Py9GodPJ
         htsyUUQj/H0HMcKLQpXfKmpY9RyOsThpG5SdEV71+okPDMkqkeinzhU9hUlebB77A3pK
         Kl0w==
X-Gm-Message-State: AOAM532DJDo7vhYWu+AahEtXMVXSAKSi+ZMUlS0DkRCssQwlrWvXVomD
        9wnJ4FHFHWs7MTa8IuBN0oIZosf3UPK03PIg
X-Google-Smtp-Source: ABdhPJxDhKE+JiBFzd82nVOKhI+8Me1QzBYWW6sqKKsGX+2LUXkyeX91NM4fMvu4EhOFtRsYHW3gaA==
X-Received: by 2002:a05:6a00:170a:b029:19d:afca:4704 with SMTP id h10-20020a056a00170ab029019dafca4704mr16185047pfc.7.1607353759681;
        Mon, 07 Dec 2020 07:09:19 -0800 (PST)
Received: from localhost ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id er23sm10930145pjb.12.2020.12.07.07.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 07:09:18 -0800 (PST)
Date:   Mon, 7 Dec 2020 17:09:15 +0200
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2020-12-07
Message-ID: <20201207150915.GA10957@johnypau-MOBL2.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave, Jakub,

Here's the main bluetooth-next pull request for the 5.11 kernel.

 - Updated Bluetooth entries in MAINTAINERS to include Luiz von Dentz
 - Added support for Realtek 8822CE and 8852A devices
 - Added support for MediaTek MT7615E device
 - Improved workarounds for fake CSR devices
 - Fix Bluetooth qualification test case L2CAP/COS/CFD/BV-14-C
 - Fixes for LL Privacy support
 - Enforce 16 byte encryption key size for FIPS security level
 - Added new mgmt commands for extended advertising support
 - Multiple other smaller fixes & improvements

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit bff6f1db91e330d7fba56f815cdbc412c75fe163:

  stmmac: intel: change all EHL/TGL to auto detect phy addr (2020-11-07 16:=
11:54 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.gi=
t for-upstream

for you to fetch changes up to 02be5f13aacba2100f1486d3ad16c26b6dede1ce:

  MAINTAINERS: Update Bluetooth entries (2020-12-07 17:02:01 +0200)

----------------------------------------------------------------
Abhishek Pandit-Subedi (2):
      Bluetooth: btqca: Add valid le states quirk
      Bluetooth: Set missing suspend task bits

Anant Thazhemadam (2):
      Bluetooth: hci_h5: close serdev device and free hu in h5_close
      Bluetooth: hci_h5: fix memory leak in h5_close

Anmol Karn (1):
      Bluetooth: Fix null pointer dereference in hci_event_packet()

Archie Pusaka (1):
      Bluetooth: Enforce key size of 16 bytes on FIPS level

Balakrishna Godavarthi (1):
      Bluetooth: hci_qca: Enhance retry logic in qca_setup

Cadel Watson (1):
      Bluetooth: btusb: Support 0bda:c123 Realtek 8822CE device

Chris Chiu (1):
      Bluetooth: btusb: Add support for 13d3:3560 MediaTek MT7615E device

Claire Chang (1):
      Bluetooth: Move force_bredr_smp debugfs into hci_debugfs_create_bredr

Colin Ian King (1):
      Bluetooth: btrtl: fix incorrect skb allocation failure check

Daniel Winkler (6):
      Bluetooth: Resume advertising after LE connection
      Bluetooth: Add helper to set adv data
      Bluetooth: Break add adv into two mgmt commands
      Bluetooth: Use intervals and tx power from mgmt cmds
      Bluetooth: Query LE tx power on startup
      Bluetooth: Change MGMT security info CMD to be more generic

Edward Vear (1):
      Bluetooth: Fix attempting to set RPA timeout when unsupported

Hans de Goede (4):
      Bluetooth: revert: hci_h5: close serdev device and free hu in h5_close
      Bluetooth: hci_h5: Add OBDA0623 ACPI HID
      Bluetooth: btusb: Fix detection of some fake CSR controllers with a b=
cdDevice val of 0x0134
      Bluetooth: btusb: Add workaround for remote-wakeup issues with Barrot=
 8041a02 fake CSR controllers

Howard Chung (6):
      Bluetooth: Replace BT_DBG with bt_dev_dbg in HCI request
      Bluetooth: Interleave with allowlist scan
      Bluetooth: Handle system suspend resume case
      Bluetooth: Handle active scan case
      Bluetooth: Refactor read default sys config for various types
      Bluetooth: Add toggle to switch off interleave scan

Jimmy Wahlberg (1):
      Bluetooth: Fix for Bluetooth SIG test L2CAP/COS/CFD/BV-14-C

Jing Xiangfeng (2):
      Bluetooth: btusb: Add the missed release_firmware() in btusb_mtk_setu=
p_firmware()
      Bluetooth: btmtksdio: Add the missed release_firmware() in mtk_setup_=
firmware()

Julian Pidancet (1):
      Bluetooth: btusb: Add support for 1358:c123 Realtek 8822CE device

Kai-Heng Feng (1):
      Bluetooth: btrtl: Ask 8821C to drop old firmware

Kiran K (5):
      Bluetooth: btintel: Fix endianness issue for TLV version information
      Bluetooth: btusb: Add *setup* function for new generation Intel contr=
ollers
      Bluetooth: btusb: Define a function to construct firmware filename
      Bluetooth: btusb: Helper function to download firmware to Intel adapt=
ers
      Bluetooth: btusb: Map Typhoon peak controller to BTUSB_INTEL_NEWGEN

Luiz Augusto von Dentz (2):
      Bluetooth: Fix not sending Set Extended Scan Response
      Bluetooth: Rename get_adv_instance_scan_rsp

Marcel Holtmann (2):
      Bluetooth: Increment management interface revision
      MAINTAINERS: Update Bluetooth entries

Max Chou (3):
      Bluetooth: btusb: Add the more support IDs for Realtek RTL8822CE
      Bluetooth: btrtl: Refine the ic_id_table for clearer and more regular
      Bluetooth: btusb: btrtl: Add support for RTL8852A

Nigel Christian (1):
      Bluetooth: hci_qca: resolve various warnings

Ole Bj=F8rn Midtb=F8 (1):
      Bluetooth: hidp: use correct wait queue when removing ctrl_wait

Peilin Ye (1):
      Bluetooth: Fix slab-out-of-bounds read in hci_le_direct_adv_report_ev=
t()

Reo Shiseki (1):
      Bluetooth: fix typo in struct name

Sathish Narasimman (1):
      Bluetooth: Fix: LL PRivacy BLE device fails to connect

Sergey Shtylyov (1):
      Bluetooth: consolidate error paths in hci_phy_link_complete_evt()

Tim Jiang (1):
      Bluetooth: btusb: support download nvm with different board id for wc=
n6855

Venkata Lakshmi Narayana Gubba (2):
      Bluetooth: hci_qca: Wait for timeout during suspend
      Bluetooth: btqca: Use NVM files based on SoC ID for WCN3991

Wei Yongjun (1):
      Bluetooth: sco: Fix crash when using BT_SNDMTU/BT_RCVMTU option

Xiaolei Wang (1):
      Bluetooth: hci_ll: add a small delay for wl1271 enable bt_en

 MAINTAINERS                      |   6 +-
 drivers/bluetooth/btintel.c      |  21 +-
 drivers/bluetooth/btintel.h      |   6 +
 drivers/bluetooth/btmtksdio.c    |   2 +-
 drivers/bluetooth/btqca.c        |  36 ++--
 drivers/bluetooth/btqca.h        |  22 +-
 drivers/bluetooth/btrtl.c        | 123 ++++++-----
 drivers/bluetooth/btusb.c        | 421 +++++++++++++++++++++++++++++++++++=
+-
 drivers/bluetooth/hci_h5.c       |   4 +
 drivers/bluetooth/hci_ll.c       |   1 +
 drivers/bluetooth/hci_qca.c      | 118 +++++++----
 include/net/bluetooth/hci.h      |   7 +
 include/net/bluetooth/hci_core.h |  23 ++-
 include/net/bluetooth/mgmt.h     |  53 ++++-
 net/bluetooth/hci_conn.c         |  12 +-
 net/bluetooth/hci_core.c         |  53 ++++-
 net/bluetooth/hci_debugfs.c      |  50 +++++
 net/bluetooth/hci_event.c        |  44 ++--
 net/bluetooth/hci_request.c      | 303 +++++++++++++++++++--------
 net/bluetooth/hci_request.h      |   2 +
 net/bluetooth/hidp/core.c        |   2 +-
 net/bluetooth/l2cap_core.c       |  10 +-
 net/bluetooth/mgmt.c             | 436 +++++++++++++++++++++++++++++++++++=
+---
 net/bluetooth/mgmt_config.c      | 187 +++++++++++------
 net/bluetooth/sco.c              |   5 +
 net/bluetooth/smp.c              |  44 +---
 net/bluetooth/smp.h              |   2 +
 27 files changed, 1623 insertions(+), 370 deletions(-)

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQ8m6QjaLXd1XJ73Dsfyv3T9pQ3KgUCX85FmAAKCRAfyv3T9pQ3
Kpz6AP9WVG5b8QbaF26+0lCHLc8mkjdcczDAE7cQaweW+q0vYgD6A0p9x3+3Iik1
Y8NmIYsZxsER0xlBzAfZH/+ZvYaNjQs=
=rYCF
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--

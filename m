Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B632347DC
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 16:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgGaOfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 10:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728697AbgGaOfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 10:35:21 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6BCC061574;
        Fri, 31 Jul 2020 07:35:20 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h12so4758537pgf.7;
        Fri, 31 Jul 2020 07:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition;
        bh=VLbajNqJUMYFLAkFWvJlnYUaYnpgXI5a4nI621gWylA=;
        b=FL9bLTARP7lqQu8UAECga0zexpTERH34lhWR/wh6PLeABhQBYrbJIWTfz3mHDR5eC6
         srDHg/iE8J1RB9E3bC1B3bhRKyAeINdF6EHHGH4ay12F/a+q6GHC8U9FxIo/u4tLCPbo
         JyFjZBfHERaozFF4SLub6ByCr2FKOCXIxm0XM982CYWwuV2T3Y95Zcnox0fFbuXJfWS7
         GLCCnvFIWNMX8Q7Ta8nuy9TSWH51jlh3PzCRZzmzKJnv6H6eW853yJxQNDTRLR9galol
         d3z4wvoRMtog/w/TS7v04yZ44GGNhLzqmrMJKTUMM4iigGVF/uhUgjkpHZqdc8I1p4yp
         LAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition;
        bh=VLbajNqJUMYFLAkFWvJlnYUaYnpgXI5a4nI621gWylA=;
        b=E0yJldlnOBXWRMezerpx70QjwSQ7Q/r1wcL4zSb9+XnO51kiFx7tQc6BmokuZrx2F7
         NQVGzkSAs72QrLnHyR2eDCx+WtpIqwOpYPBktjPrSXCxuDlWE72s6vleI/A3EAJ7uhJf
         NXA9dKMbNUR84Fd+xk55Xujy7/ImWbQZTESPRDYmgNUDEZXcZZPpCu04H70HA6tBt/vV
         Iz6LH66HYQw4TFEHKJpTXkiYvHqBqB2xOASmhvD3dbQSWwD6HtxOPAQBBwCv1DodQrVS
         hM3Ck+pP+dQTFdTFeVvOajkBs6v/mRajg/CwGGa3flf5TKANMM3hM3LvVa3ychJaE/AE
         8z+Q==
X-Gm-Message-State: AOAM53215zLXxJuzTydVsc6+k0HY57dahiBIOrnid4APCNTaPyCqoe7z
        SinnNxO5znvt2GK9EDigcguv74JJzvY=
X-Google-Smtp-Source: ABdhPJw4+RSjYjidqyCq0HJT4pb78WhAIHTwaY4G8Qhq3JvheyLpQg6GujglaZ3auLAhp5bFI8JvDw==
X-Received: by 2002:a62:fcc6:: with SMTP id e189mr3836328pfh.25.1596206119052;
        Fri, 31 Jul 2020 07:35:19 -0700 (PDT)
Received: from localhost ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id mr21sm7863948pjb.57.2020.07.31.07.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 07:35:18 -0700 (PDT)
Date:   Fri, 31 Jul 2020 17:35:15 +0300
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2020-07-31
Message-ID: <20200731143515.GA79165@markorti-mobl.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Here's the main bluetooth-next pull request for 5.9:

 - Fix firmware filenames for Marvell chipsets
 - Several suspend-related fixes
 - Addedd mgmt commands for runtime configuration
 - Multiple fixes for Qualcomm-based controllers
 - Add new monitoring feature for mgmt
 - Fix handling of legacy cipher (E4) together with security level 4
 - Add support for Realtek 8822CE controller
 - Fix issues with Chinese controllers using fake VID/PID values
 - Multiple other smaller fixes & improvements

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 065fcfd49763ec71ae345bb5c5a74f961031e70e:

  selftests: net: ip_defrag: ignore EPERM (2020-06-02 15:54:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.gi=
t for-upstream

for you to fetch changes up to 075f77324f90149bac12c8a705dae5786a1d24fb:

  Bluetooth: Remove CRYPTO_ALG_INTERNAL flag (2020-07-31 16:42:04 +0300)

----------------------------------------------------------------
Abhishek Pandit-Subedi (15):
      Bluetooth: Allow suspend even when preparation has failed
      Bluetooth: btmrvl_sdio: Set parent dev to hdev
      Bluetooth: btmrvl_sdio: Implement prevent_wake
      Bluetooth: btmrvl_sdio: Refactor irq wakeup
      Bluetooth: Add bdaddr_list_with_flags for classic whitelist
      Bluetooth: Replace wakeable list with flag
      Bluetooth: Replace wakeable in hci_conn_params
      Bluetooth: Add get/set device flags mgmt op
      Bluetooth: Add hci_dev_lock to get/set device flags
      Bluetooth: btusb: Reset port on cmd timeout
      Bluetooth: btusb: BTUSB_WAKEUP_DISABLE prevents wake
      Bluetooth: Don't restart scanning if paused
      Bluetooth: btusb: Comment on unbalanced pm reference
      Bluetooth: Fix suspend notifier race
      Revert "Bluetooth: btusb: Disable runtime suspend on Realtek devices"

Alain Michaud (11):
      Bluetooth: Removing noisy dbg message
      Bluetooth: Add support for BT_PKT_STATUS CMSG data for SCO connections
      Bluetooth: Use only 8 bits for the HCI CMSG state flags
      Bluetooth: mgmt: read/set system parameter definitions
      Bluetooth: centralize default value initialization.
      Bluetooth: implement read/set default system parameters mgmt
      Bluetooth: use configured params for ext adv
      Bluetooth: Adding a configurable autoconnect timeout
      Bluetooth: use configured default params for active scans
      Bluetooth: le_simult_central_peripheral experimental feature
      Bluetooth: use the proper scan params when conn is pending

Alexander A. Klimov (1):
      Replace HTTP links with HTTPS ones: BLUETOOTH SUBSYSTEM

Balakrishna Godavarthi (3):
      Bluetooth: hci_qca: Disable SoC debug logging for WCN3991
      Bluetooth: hci_qca: Increase SoC idle timeout to 200ms
      Bluetooth: hci_qca: Request Tx clock vote off only when Tx is pending

Chethan T N (2):
      Bluetooth: btusb: Add support to read Intel debug feature
      Bluetooth: btusb: Configure Intel debug feature based on available su=
pport

Dan Carpenter (1):
      Bluetooth: hci_qca: Fix an error pointer dereference

Daniel Winkler (1):
      Bluetooth: Add per-instance adv disable/remove

Gustavo A. R. Silva (3):
      Bluetooth: core: Use fallthrough pseudo-keyword
      Bluetooth: RFCOMM: Use fallthrough pseudo-keyword
      Bluetooth: Use fallthrough pseudo-keyword

Herbert Xu (1):
      Bluetooth: Remove CRYPTO_ALG_INTERNAL flag

Hilda Wu (1):
      Bluetooth: btusb: USB alternate setting 1 for WBS

Ismael Ferreras Morezuelas (1):
      Bluetooth: btusb: Fix and detect most of the Chinese Bluetooth contro=
llers

Joseph Hwang (1):
      Bluetooth: btusb: add Realtek 8822CE to usb_device_id table

Kiran K (1):
      Bluetooth: btusb: Refactor of firmware download flow for Intel conrol=
lers

Lihong Kou (1):
      Bluetooth: add a mutex lock to avoid UAF in do_enale_set

Luiz Augusto von Dentz (1):
      Bluetooth: Disconnect if E0 is used for Level 4

Manish Mandlik (2):
      Bluetooth: Check scan state before disabling during suspend
      Bluetooth: Terminate the link if pairing is cancelled

Marcel Holtmann (6):
      Bluetooth: mgmt: Add commands for runtime configuration
      Bluetooth: mgmt: Use command complete on success for set system config
      Bluetooth: Translate additional address type correctly
      Bluetooth: Configure controller address resolution if available
      Bluetooth: Update resolving list when updating whitelist
      Bluetooth: Increment management interface revision

Martin Blumenstingl (1):
      dt-bindings: net: bluetooth: realtek: Fix uart-has-rtscts example

Matthias Kaehlcke (4):
      Bluetooth: hci_qca: Simplify determination of serial clock on/off sta=
te from votes
      Bluetooth: hci_qca: Only remove TX clock vote after TX is completed
      Bluetooth: hci_qca: Skip serdev wait when no transfer is pending
      Bluetooth: hci_qca: Refactor error handling in qca_suspend()

Max Chou (1):
      Bluetooth: Return NOTIFY_DONE for hci_suspend_notifier

Miao-chen Chou (9):
      Bluetooth: Add definitions for advertisement monitor features
      Bluetooth: Add handler of MGMT_OP_READ_ADV_MONITOR_FEATURES
      Bluetooth: Add handler of MGMT_OP_ADD_ADV_PATTERNS_MONITOR
      Bluetooth: Add handler of MGMT_OP_REMOVE_ADV_MONITOR
      Bluetooth: Notify adv monitor added event
      Bluetooth: Notify adv monitor removed event
      Bluetooth: Update background scan and report device based on advertis=
ement monitors
      Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()
      Bluetooth: Use whitelist for scan policy when suspending

Nicolas Boichat (2):
      Bluetooth: hci_h5: Set HCI_UART_RESET_ON_INIT to correct flags
      Bluetooth: hci_serdev: Only unregister device if it was registered

Pali Roh=E1r (4):
      mwifiex: Fix firmware filename for sd8977 chipset
      mwifiex: Fix firmware filename for sd8997 chipset
      btmrvl: Fix firmware filename for sd8977 chipset
      btmrvl: Fix firmware filename for sd8997 chipset

Patrick Steinhardt (1):
      Bluetooth: Fix update of connection state in `hci_encrypt_cfm`

Peilin Ye (3):
      Bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result=
_evt()
      Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_evt()
      Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_with_rssi=
_evt()

Sathish Narasimman (5):
      Bluetooth: Translate additional address type during le_conn
      Bluetooth: Let controller creates RPA during le create conn
      Bluetooth: Enable/Disable address resolution during le create conn
      Bluetooth: Enable RPA Timeout
      Bluetooth: Enable controller RPA resolution using Experimental feature

Sean Wang (2):
      Bluetooth: btusb: fix up firmware download sequence
      Bluetooth: btmtksdio: fix up firmware download sequence

Venkata Lakshmi Narayana Gubba (3):
      Bluetooth: hci_qca: Bug fix during SSR timeout
      Bluetooth: hci_qca: Bug fixes for SSR
      Bluetooth: hci_qca: Stop collecting memdump again for command timeout=
 during SSR

 .../devicetree/bindings/net/realtek-bluetooth.yaml |   2 +-
 drivers/bluetooth/bcm203x.c                        |   2 +-
 drivers/bluetooth/bluecard_cs.c                    |   2 -
 drivers/bluetooth/btintel.c                        |  59 +++
 drivers/bluetooth/btintel.h                        |  21 +
 drivers/bluetooth/btmrvl_main.c                    |  11 +
 drivers/bluetooth/btmrvl_sdio.c                    |  21 +-
 drivers/bluetooth/btmtksdio.c                      |  16 +-
 drivers/bluetooth/btqca.c                          |  27 +
 drivers/bluetooth/btqca.h                          |   2 +
 drivers/bluetooth/btusb.c                          | 303 +++++++----
 drivers/bluetooth/hci_h5.c                         |   2 +-
 drivers/bluetooth/hci_ll.c                         |   2 +-
 drivers/bluetooth/hci_qca.c                        | 134 +++--
 drivers/bluetooth/hci_serdev.c                     |   3 +-
 drivers/net/wireless/marvell/mwifiex/sdio.h        |   4 +-
 include/net/bluetooth/bluetooth.h                  |  12 +
 include/net/bluetooth/hci.h                        |  28 +-
 include/net/bluetooth/hci_core.h                   | 107 +++-
 include/net/bluetooth/hci_sock.h                   |   4 +-
 include/net/bluetooth/mgmt.h                       |  95 ++++
 include/net/bluetooth/sco.h                        |   2 +
 net/bluetooth/6lowpan.c                            |   5 +
 net/bluetooth/Kconfig                              |   2 +-
 net/bluetooth/Makefile                             |   2 +-
 net/bluetooth/af_bluetooth.c                       |   5 +-
 net/bluetooth/hci_conn.c                           |  51 +-
 net/bluetooth/hci_core.c                           | 212 +++++++-
 net/bluetooth/hci_event.c                          |  71 ++-
 net/bluetooth/hci_request.c                        | 286 ++++++++--
 net/bluetooth/hci_request.h                        |   5 +-
 net/bluetooth/hci_sock.c                           |   7 +-
 net/bluetooth/l2cap_core.c                         |  25 +-
 net/bluetooth/l2cap_sock.c                         |   4 +-
 net/bluetooth/mgmt.c                               | 577 +++++++++++++++++=
+++-
 net/bluetooth/mgmt_config.c                        | 283 ++++++++++
 net/bluetooth/mgmt_config.h                        |  17 +
 net/bluetooth/msft.c                               |   7 +
 net/bluetooth/msft.h                               |   9 +
 net/bluetooth/rfcomm/core.c                        |   2 +-
 net/bluetooth/rfcomm/sock.c                        |   2 +-
 net/bluetooth/sco.c                                |  32 ++
 net/bluetooth/selftest.c                           |   2 +-
 net/bluetooth/smp.c                                |   8 +-
 44 files changed, 2149 insertions(+), 324 deletions(-)
 create mode 100644 net/bluetooth/mgmt_config.c
 create mode 100644 net/bluetooth/mgmt_config.h

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQ8m6QjaLXd1XJ73Dsfyv3T9pQ3KgUCXyQsIAAKCRAfyv3T9pQ3
Kn7LAQCCcnriFiWIZNDceKtkAIfn8kQs7sYNvhgWhzIymvfVpgEAwgtQpMcKFB+A
XbLs/Og9dZ35bJ/JtrD9mSwcsPb5rQQ=
=B82a
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--

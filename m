Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B07F1D0A9C
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 10:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730553AbgEMIPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 04:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729106AbgEMIPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 04:15:23 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A785C061A0C;
        Wed, 13 May 2020 01:15:23 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id n18so184388pfa.2;
        Wed, 13 May 2020 01:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition;
        bh=s7Xwu90CYQ1ik4OayvSic3fdFdzVQBA9fJ9MJPdEP60=;
        b=PpdGaQgoaefRxJ8DzfZE4eLQ4w7FwY4dDChcW/F0REcnC0joHbZF3W9GBztiVj+udf
         UdS7spfcUewzF7/eABDA0XiUxw57e+GQ3ovwPZ4m0Cv0pxHf3U1kzIfJnsmEUbukpcF3
         xI307NkEPg0F2mIvj2aCWBhQ4Jvwn//h/42LTadaL6f2J1/PHOkFJXWQ8j0BfMGuF7Dc
         C8ojTDTEKE9/XoDLV03fU4CHk6IZKQD9xcGO8ei0LICEC3zPyj1aAlMF/1kAHq26Z6d6
         CaVQXBgb26l/CrobOUza6Yuugvd+E9hf+uGVbDV6kwPMf/SL0EDGI4cyLtNgTagBfBk9
         zvPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition;
        bh=s7Xwu90CYQ1ik4OayvSic3fdFdzVQBA9fJ9MJPdEP60=;
        b=Vh5PJyBG9mPZYauv68AXe5pkm8Qmdc23OHKGqETMLogZEohzTG3GcutXOZYhKfngvp
         ZNpMO83+Jso3JxYmtg4J0db2QBb/dcaI7pBJ+S80CfSu/JQWzllWQO2y1+esRaVhlptX
         ZeKZA/rCNDWpb2ZpYDFfUyQROx3mIuQKGX527WDBXrnCCttj3dirbIDspP+FeAW2cfZY
         BCT6sb1/45plQnfm0VpVcmwtnlOi7latn+QjeWTwFl2Df1jTlqoc7n5SpXqLFPnN27mr
         BE0e2/+Vi2GoLA4AGMRBHy5AxFmTyRYLYU4FdqQpzw0gZXvPjUviz7W97ZHfIsZVkN4Z
         mfcA==
X-Gm-Message-State: AGi0PuaU68tAFOumcWDeuk8/85k88LT2gjY4oh+gLihRdM3F+ELe/FSz
        lCTGl0VD17+PQ5f0b7IuJfwxjS9dk0Tbvw==
X-Google-Smtp-Source: APiQypJhzfkY7NWahOJLcE3JfTBkrmHzS4/CxZ4NT8nyuhtCCVYnYcvqPKTi946HR6NPtUZCyvlPEw==
X-Received: by 2002:aa7:8489:: with SMTP id u9mr25143169pfn.248.1589357722620;
        Wed, 13 May 2020 01:15:22 -0700 (PDT)
Received: from localhost ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id ie17sm14912102pjb.19.2020.05.13.01.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 01:15:21 -0700 (PDT)
Date:   Wed, 13 May 2020 11:15:17 +0300
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2020-05-13
Message-ID: <20200513081517.GA35645@isister-mobl.amr.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Here's a second attempt at a bluetooth-next pull request which
supercedes the one dated 2020-05-09. This should have the issues
discovered by Jakub fixed.

 - Add support for Intel Typhoon Peak device (8087:0032)
 - Add device tree bindings for Realtek RTL8723BS device
 - Add device tree bindings for Qualcomm QCA9377 device
 - Add support for experimental features configuration through mgmt
 - Add driver hook to prevent wake from suspend
 - Add support for waiting for L2CAP disconnection response
 - Multiple fixes & cleanups to the btbcm driver
 - Add support for LE scatternet topology for selected devices
 - A few other smaller fixes & cleanups

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 44dd5efc97dae0dc09ea9316597826c8b0fd1578:

  Merge branch 'Support-programmable-pins-for-Ocelot-PTP-driver' (2020-04-21 15:38:34 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 5b440676c15bbe1a40f2546ec92db83ed66d9e22:

  Bluetooth: L2CAP: add support for waiting disconnection resp (2020-05-13 10:03:51 +0200)

----------------------------------------------------------------
Abhishek Pandit-Subedi (5):
      Bluetooth: Fix incorrect type for window and interval
      Bluetooth: Modify LE window and interval for suspend
      Bluetooth: Rename BT_SUSPEND_COMPLETE
      Bluetooth: Add hook for driver to prevent wake from suspend
      Bluetooth: btusb: Implement hdev->prevent_wake

Alain Michaud (3):
      Bluetooth: Adding driver and quirk defs for multi-role LE
      Bluetooth: allow scatternet connections if supported.
      Bluetooth: btusb: Adding support for LE scatternet to Jfp and ThP

Archie Pusaka (1):
      Bluetooth: L2CAP: add support for waiting disconnection resp

Christian Hewitt (3):
      dt-bindings: net: bluetooth: Add device tree bindings for QCA9377
      Bluetooth: hci_qca: add compatible for QCA9377
      Bluetooth: hci_qca: allow max-speed to be set for QCA9377 devices

Hans de Goede (8):
      Bluetooth: btbcm: Drop upper nibble version check from btbcm_initialize()
      Bluetooth: btbcm: Move setting of USE_BDADDR_PROPERTY quirk to hci_bcm.c
      Bluetooth: btbcm: Fold Patch loading + applying into btbcm_initialize()
      Bluetooth: btbcm: Make btbcm_initialize() print local-name on re-init too
      Bluetooth: btbcm: Make btbcm_setup_patchram use btbcm_finalize
      Bluetooth: btbcm: Bail sooner from btbcm_initialize() when not loading fw
      Bluetooth: btbcm: Try multiple Patch filenames when loading the Patch firmware
      Bluetooth: btbcm: Add 2 missing models to subver tables

Konstantin Forostyan (1):
      Bluetooth: L2CAP: Fix errors during L2CAP_CREDIT_BASED_CONNECTION_REQ (0x17)

Marcel Holtmann (7):
      Bluetooth: Add MGMT_EV_PHY_CONFIGURATION_CHANGED to supported list
      Bluetooth: Replace BT_DBG with bt_dev_dbg for management support
      Bluetooth: replace zero-length array with flexible-array member
      Bluetooth: Introduce HCI_MGMT_HDEV_OPTIONAL option
      Bluetooth: Replace BT_DBG with bt_dev_dbg for security manager support
      Bluetooth: Add support for experimental features configuration
      Bluetooth: Introduce debug feature when dynamic debug is disabled

Raghuram Hegde (1):
      Bluetooth: btusb: Add support for Intel Bluetooth Device Typhoon Peak (8087:0032)

Rikard Falkeborn (1):
      Bluetooth: serdev: Constify serdev_device_ops

Sonny Sasaka (1):
      Bluetooth: Handle Inquiry Cancel error after Inquiry Complete

Tedd Ho-Jeong An (1):
      Bluetooth: Fix advertising handle is set to 0

Vasily Khoruzhick (2):
      dt-bindings: net: bluetooth: Add rtl8723bs-bluetooth
      Bluetooth: hci_h5: Add support for binding RTL8723BS with device tree

 .../devicetree/bindings/net/qualcomm-bluetooth.txt |   5 +
 .../devicetree/bindings/net/realtek-bluetooth.yaml |  54 +++
 drivers/bluetooth/btbcm.c                          | 139 ++++----
 drivers/bluetooth/btbcm.h                          |  10 +-
 drivers/bluetooth/btusb.c                          |  20 +-
 drivers/bluetooth/hci_bcm.c                        |  27 +-
 drivers/bluetooth/hci_h5.c                         |   2 +
 drivers/bluetooth/hci_qca.c                        |  17 +-
 drivers/bluetooth/hci_serdev.c                     |   4 +-
 include/net/bluetooth/bluetooth.h                  |  11 +
 include/net/bluetooth/hci.h                        |  10 +
 include/net/bluetooth/hci_core.h                   |   4 +-
 include/net/bluetooth/mgmt.h                       |  69 ++--
 net/bluetooth/Kconfig                              |   7 +
 net/bluetooth/hci_core.c                           |   8 +-
 net/bluetooth/hci_event.c                          |  23 +-
 net/bluetooth/hci_request.c                        |  12 +-
 net/bluetooth/hci_sock.c                           |  12 +-
 net/bluetooth/l2cap_core.c                         |   4 +-
 net/bluetooth/l2cap_sock.c                         |  30 +-
 net/bluetooth/lib.c                                |  33 ++
 net/bluetooth/mgmt.c                               | 367 ++++++++++++++-------
 net/bluetooth/smp.c                                |   8 +-
 23 files changed, 618 insertions(+), 258 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQ8m6QjaLXd1XJ73Dsfyv3T9pQ3KgUCXruskwAKCRAfyv3T9pQ3
KkNrAP96TZQ00F7A1Yc81KX2sp2AtzKHExUtrjyPvXep7LDq4QEA3BIi0dJgt1Ex
ZDMvT5bv77er2g/HOxevlDF2cLzLHgY=
=jjun
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--

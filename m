Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A961CC3BF
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 20:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgEIStf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 14:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728283AbgEISte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 14:49:34 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7906BC061A0C;
        Sat,  9 May 2020 11:49:34 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id v63so2674666pfb.10;
        Sat, 09 May 2020 11:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition;
        bh=PC0va4mHVM5E//sOd5QU7Y7mS6FB7r5lrD8IqdOiDKk=;
        b=roIFk0W2fzl+IGTH0D2ZsQgXjijHcX8/l5GgAaGdyGpthMpSfruKxJa21bJwSceGyl
         n4a4cCvK5g8D1qbfUajGGbhHcaOhwMMJCnuxp0D3UO8LzQ8f2enOZol8gwJ+2elNlQZY
         itlrAh2GowjnaARzBf+KeXc9S4RHI0ba21e1960t7HRfJ0mQjqeiYUGSrPeKmZkjsBXc
         5vvsckrVImKAO7Tqcs3hfpf6cEG+lo3jxIA8v1ozpFpHENJVijoQerutDSSPuv3xLpeo
         Nxt+B8UsO95V7fACZt4v4OWXZvYgBUXn4cTT8E5g+aR2P6/jHJCPrKssU0bZoyq5sOTb
         tiHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition;
        bh=PC0va4mHVM5E//sOd5QU7Y7mS6FB7r5lrD8IqdOiDKk=;
        b=k7KA8iFw+b5YS8n08mOBk5wLf/4BX8TWbp8/QrMD/f7mTjNiZYGnpi3sRF5sXTWynX
         cf5aAU0Mni+XvdCZzthPXTl5ezGTMXvAT6STqgrGgJLtuKZH1rqWCuWW/n0ARisiBUDl
         0nIbzmqP9ROEBXP3bMFBpAIBVBvOnv32933ycAe3C+XqKnZDdo+0eUYVYc5jgmwVVofR
         2+5Gm6C2BEepFYl8jV31eRBC7XLyzY8mCFHwmHyPnPDY8L4OAZ00NvYItxbryIohiB/s
         1dmE67JJNfmRGtGOE0wmxV4TOdz99Ik4fmmj5ZE2E699On7b4YPHUwRfo3/bao02j3je
         iWLg==
X-Gm-Message-State: AGi0PuZV+RQBNZH4+/oTj2/2ozn29vHGrpOcMqcz9YnY+PM/k6ApNzu0
        yOAPL1REFiLnBfyFvOOSre3ch+SRqkA=
X-Google-Smtp-Source: APiQypJG6kz6fN+ZQHf6qyrD5Q3jGO9rO2QTCrswKRTtjCrF8B+Omk4rKy+AjRCBkkA7kjDzmRd/hw==
X-Received: by 2002:aa7:96b6:: with SMTP id g22mr7560048pfk.225.1589050173955;
        Sat, 09 May 2020 11:49:33 -0700 (PDT)
Received: from localhost ([134.134.137.77])
        by smtp.gmail.com with ESMTPSA id a99sm5385896pje.35.2020.05.09.11.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 11:49:32 -0700 (PDT)
Date:   Sat, 9 May 2020 21:49:28 +0300
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next 2020-05-09
Message-ID: <20200509184928.GA26120@jhedberg-mac01.local>
Mail-Followup-To: davem@davemloft.net, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave,

Here's another set of Bluetooth patches for the 5.8 kernel:

 - Add support for Intel Typhoon Peak device (8087:0032)
 - Add device tree bindings for Realtek RTL8723BS device
 - Add device tree bindings for Qualcomm QCA9377 device
 - Add support for experimental features configuration through mgmt
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

for you to fetch changes up to c947c948df52c24d8477a36a9706ebfa26430ea4:

  Bluetooth: Introduce debug feature when dynamic debug is disabled (2020-05-08 11:53:44 +0300)

----------------------------------------------------------------
Alain Michaud (3):
      Bluetooth: Adding driver and quirk defs for multi-role LE
      Bluetooth: allow scatternet connections if supported.
      Bluetooth: btusb: Adding support for LE scatternet to Jfp and ThP

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

Hegde, Raghuram (1):
      Bluetooth: btusb: Add support for Intel Bluetooth Device Typhoon Peak (8087:0032)

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

Tedd Ho-Jeong An (1):
      Bluetooth: Fix advertising handle is set to 0

Vasily Khoruzhick (2):
      dt-bindings: net: bluetooth: Add rtl8723bs-bluetooth
      Bluetooth: hci_h5: Add support for binding RTL8723BS with device tree

 .../devicetree/bindings/net/qualcomm-bluetooth.txt |   5 +
 .../devicetree/bindings/net/realtek-bluetooth.yaml |  54 +++
 drivers/bluetooth/btbcm.c                          | 139 ++++----
 drivers/bluetooth/btbcm.h                          |  10 +-
 drivers/bluetooth/btusb.c                          |  12 +-
 drivers/bluetooth/hci_bcm.c                        |  27 +-
 drivers/bluetooth/hci_h5.c                         |   2 +
 drivers/bluetooth/hci_qca.c                        |  17 +-
 include/net/bluetooth/bluetooth.h                  |  11 +
 include/net/bluetooth/hci.h                        |  10 +
 include/net/bluetooth/hci_core.h                   |   1 +
 include/net/bluetooth/mgmt.h                       |  69 ++--
 net/bluetooth/Kconfig                              |   7 +
 net/bluetooth/hci_event.c                          |   4 +-
 net/bluetooth/hci_request.c                        |   6 +-
 net/bluetooth/hci_sock.c                           |  12 +-
 net/bluetooth/l2cap_core.c                         |   4 +-
 net/bluetooth/lib.c                                |  33 ++
 net/bluetooth/mgmt.c                               | 364 ++++++++++++++-------
 net/bluetooth/smp.c                                |   8 +-
 20 files changed, 556 insertions(+), 239 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQ8m6QjaLXd1XJ73Dsfyv3T9pQ3KgUCXrb7NgAKCRAfyv3T9pQ3
KvQgAP4tSQCMcbi6j3LGQTXx5SqybJkObBfmaBPlXj3pCMgWRgEAomzf8vdYeU2t
kOLW0w1JHpvkLkNxEizy8lS3x5RMMQo=
=xYRr
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--

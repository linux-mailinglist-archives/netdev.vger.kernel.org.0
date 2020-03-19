Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC1818C043
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgCST2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 15:28:50 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:39666 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgCST2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 15:28:50 -0400
Received: by mail-pj1-f45.google.com with SMTP id ck23so1424782pjb.4;
        Thu, 19 Mar 2020 12:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=ONywzPtGy3tNyw7U/GmlKSLLeiYiqTyuKIFCbHilOZc=;
        b=UfKtV4SAd6dlDyu0/TYZsDy8EiQsuk9ow9F/iPXbz2kFL5AvYxIaFINpFajeYIPsKl
         oJAILRGPTR3OcVHflF/IGnIESRLJHeipnimRdp1E+m7CifOxfJ+Jk0iXfBIXynHG/etD
         hsrxuOgSD7F8gMYyRbx2GXjUEF7oEQJtncddr7I9dGwxM+uqNe+ezogdtXAnoMtOVq+p
         sVjh8iCCgcyQSgujXYHtvuVbyzq9WZm/5Hr/rtuaXLBH8yZbh7QfWb7BcBkZQ4b5chwq
         CiYHn4WZmpDQqpf/2iSSKx/GWpDYQnkmYagV77rnAbTw5xs/lkIyl3C8/fQw4hGDNJ7e
         UTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=ONywzPtGy3tNyw7U/GmlKSLLeiYiqTyuKIFCbHilOZc=;
        b=RYwy+Dfe+mPUG0Gru/vde+Vkddpq47O+lDk69p0zTJrN5mrB7kLifOUw635VnkXW/s
         vT0QdLsDLvRwGrDR1kEdCxlzNbePL2fcZ8uxQNCeSGGiE8otPSPgbZmrCNGhF4aID95T
         /mMz+tI4t7YxU9ldlPqJWTVY0dy36o0/9OoGqIOk8ZP2JeNRefrxf4VgGepJlCgrLIKF
         S8mtjRsoV3RftvkKPA/v6aHnUcerxglAyHu8C6hr7xTJmNHOalQiPSxve7UWORqeJ1P2
         waoA0Ry8uogZwcmbeGy4L/uwASuWtdw+mUi4/lkAz1eBxYsHuXhnjIlvwP+W7cyzsRQH
         Upjw==
X-Gm-Message-State: ANhLgQ0DAdW7FSQ52Ot+T9nqlrV1hwzPOd+6JwvFOgYdWaCXduQUaRkP
        L+jkNTeZEB/2KH9/YNl6X9XPlvxV4zNaNQ==
X-Google-Smtp-Source: ADFU+vtgIFVDxew2DNt1vLOiKxCqRGPbKHS1G36tvAnPMPWu9Yfg1ef161t1FedmuKGBm62crj/tSg==
X-Received: by 2002:a17:902:be08:: with SMTP id r8mr4960213pls.321.1584646128434;
        Thu, 19 Mar 2020 12:28:48 -0700 (PDT)
Received: from localhost ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id g6sm2721135pjv.13.2020.03.19.12.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 12:28:46 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:28:41 +0200
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2020-03-19
Message-ID: <20200319192841.GA11720@aleibman-mobl1.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave,

Here's the main bluetooth-next pull request for the 5.7 kernel.

 - Added wideband speech support to mgmt and the ability for HCI drivers
   to declare support for it.
 - Added initial support for L2CAP Enhanced Credit Based Mode
 - Fixed suspend handling for several use cases
 - Fixed Extended Advertising related issues
 - Added support for Realtek 8822CE device
 - Added DT bindings for QTI chip WCN3991
 - Cleanups to replace zero-length arrays with flexible-array members
 - Several other smaller cleanups & fixes

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 8e5aa6173ad3ef794e52afa2bb56451db18642b9:

  Merge branch 'qed-Utilize-FW-8.42.2.0' (2020-01-27 14:35:40 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to ba7c1b47c11ba78e54f979aae9df1149815c23ad:

  Bluetooth: Do not cancel advertising when starting a scan (2020-03-18 12:25:03 +0100)

----------------------------------------------------------------
Abhishek Pandit-Subedi (4):
      Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND
      Bluetooth: Handle BR/EDR devices during suspend
      Bluetooth: Handle LE devices during suspend
      Bluetooth: Pause discovery and advertising during suspend

Alain Michaud (6):
      Bluetooth: Fixing a few comment typos in the quirk definitions.
      Bluetooth: btusb: Add flag to define wideband speech capability
      Bluetooth: Support querying for WBS support through MGMT
      Bluetooth: guard against controllers sending zero'd events
      Bluetooth: Enable erroneous data reporting if WBS is supported
      Bluetooth: fix off by one in err_data_reporting cmd masks.

Alex Shi (1):
      Bluetooth: remove __get_channel/dir and __dir

Christophe JAILLET (4):
      Bluetooth: SMP: Fix SALT value in some comments
      Bluetooth: Fix a typo in Kconfig
      Bluetooth: hci_h4: Fix a typo in a comment
      Bluetooth: hci_h4: Remove a redundant assignment in 'h4_flush()'

Dan Carpenter (1):
      Bluetooth: L2CAP: Fix a condition in l2cap_sock_recvmsg()

Davidlohr Bueso (1):
      Bluetooth: optimize barrier usage for Rmw atomics

Dmitry Grinberg (1):
      Bluetooth: Do not cancel advertising when starting a scan

Gustavo A. R. Silva (5):
      Bluetooth: btintel: Replace zero-length array with flexible-array member
      Bluetooth: hci_intel: Replace zero-length array with flexible-array member
      Bluetooth: hci_uart: Replace zero-length array with flexible-array member
      Bluetooth: Replace zero-length array with flexible-array member
      6lowpan: Replace zero-length array with flexible-array member

Hillf Danton (1):
      Bluetooth: prefetch channel before killing sock

Howard Chung (3):
      Bluetooth: secure bluetooth stack from bluedump attack
      Bluetooth: fix passkey uninitialized when used
      Bluetooth: L2CAP: handle l2cap config request during open state

Joseph Hwang (2):
      Bluetooth: mgmt: add mgmt_cmd_status in add_advertising
      Bluetooth: clean up connection in hci_cs_disconnect

Luiz Augusto von Dentz (7):
      Bluetooth: Add BT_PHY socket option
      Bluetooth: Fix crash when using new BT_PHY option
      Bluetooth: RFCOMM: Use MTU auto tune logic
      Bluetooth: Make use of skb_pull to parse L2CAP signaling PDUs
      Bluetooth: L2CAP: Add definitions for Enhanced Credit Based Mode
      Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode
      Bluetooth: L2CAP: Add module option to enable ECRED mode

Lukas Bulwahn (1):
      MAINTAINERS: adjust to 6lowpan doc ReST conversion

Madhuparna Bhowmik (2):
      Bluetooth: Fix Suspicious RCU usage warnings
      Bluetooth: Use list_for_each_entry_rcu() to traverse RCU list in RCU read-side CS

Manish Mandlik (1):
      Bluetooth: Fix refcount use-after-free issue

Marcel Holtmann (6):
      Bluetooth: hci_h5: Move variable into local scope
      Bluetooth: Fix calculation of SCO handle for packet processing
      Bluetooth: Increment management interface revision
      Bluetooth: bfusb: Switch from BT_ERR to bt_dev_err where possible
      Bluetooth: Use bt_dev_err for RPA generation failure message
      Bluetooth: hci_h5: Switch from BT_ERR to bt_dev_err where possible

Mauro Carvalho Chehab (1):
      docs: networking: convert 6lowpan.txt to ReST

Max Chou (1):
      Bluetooth: hci_h5: btrtl: Add support for RTL8822C

Qiujun Huang (1):
      Bluetooth: RFCOMM: fix ODEBUG bug in rfcomm_dev_ioctl

Rocky Liao (4):
      Bluetooth: hci_qca: Not send vendor pre-shutdown command for QCA Rome
      Bluetooth: btqca: Fix the NVM baudrate tag offcet for wcn3991
      Bluetooth: hci_qca: Make bt_en and susclk not mandatory for QCA Rome
      Bluetooth: hci_qca: Replace devm_gpiod_get() with devm_gpiod_get_optional()

Sathish Narsimman (3):
      Bluetooth: Disable Extended Adv if enabled
      Bluetooth: Remove adv set for directed advertising
      Bluetooth: During le_conn_timeout disable EXT_ADV

Sergey Shatunov (1):
      Bluetooth: btusb: Add support for 13d3:3548 Realtek 8822CE device

Sukumar Ghorai (1):
      Bluetooth: btusb: print Intel fw build version in power-on boot

Venkata Lakshmi Narayana Gubba (4):
      Bluetooth: hci_qca: Enable clocks required for BT SOC
      dt-bindings: net: bluetooth: Add device tree bindings for QTI chip WCN3991
      Bluetooth: hci_qca: Optimized code while enabling clocks for BT SOC
      Bluetooth: hci_qca: Bug fixes while collecting controller memory dump

YueHaibing (1):
      Bluetooth: L2CAP: remove set but not used variable 'credits'

 .../devicetree/bindings/net/qualcomm-bluetooth.txt |   3 +
 .../networking/{6lowpan.txt => 6lowpan.rst}        |  29 +-
 Documentation/networking/index.rst                 |   1 +
 MAINTAINERS                                        |   2 +-
 drivers/bluetooth/Kconfig                          |   4 +-
 drivers/bluetooth/bfusb.c                          |  33 +-
 drivers/bluetooth/btintel.c                        |   4 +-
 drivers/bluetooth/btqca.c                          |  10 +-
 drivers/bluetooth/btqca.h                          |   6 +-
 drivers/bluetooth/btrtl.c                          |  12 +
 drivers/bluetooth/btrtl.h                          |   4 +-
 drivers/bluetooth/btusb.c                          |  32 +-
 drivers/bluetooth/hci_ag6xx.c                      |   2 +-
 drivers/bluetooth/hci_h4.c                         |   4 +-
 drivers/bluetooth/hci_h5.c                         |  49 +-
 drivers/bluetooth/hci_intel.c                      |   2 +-
 drivers/bluetooth/hci_qca.c                        | 174 ++++--
 include/net/6lowpan.h                              |   2 +-
 include/net/bluetooth/bluetooth.h                  |  17 +
 include/net/bluetooth/hci.h                        |  74 ++-
 include/net/bluetooth/hci_core.h                   |  46 ++
 include/net/bluetooth/hci_sock.h                   |   6 +-
 include/net/bluetooth/l2cap.h                      |  52 +-
 include/net/bluetooth/mgmt.h                       |   5 +-
 include/net/bluetooth/rfcomm.h                     |   3 +-
 net/bluetooth/a2mp.h                               |  10 +-
 net/bluetooth/bnep/bnep.h                          |   6 +-
 net/bluetooth/hci_conn.c                           | 146 ++++-
 net/bluetooth/hci_core.c                           | 142 ++++-
 net/bluetooth/hci_event.c                          |  93 +++-
 net/bluetooth/hci_request.c                        | 350 +++++++++---
 net/bluetooth/hci_request.h                        |   2 +
 net/bluetooth/hidp/core.c                          |   2 +-
 net/bluetooth/l2cap_core.c                         | 617 +++++++++++++++++++--
 net/bluetooth/l2cap_sock.c                         |  59 +-
 net/bluetooth/mgmt.c                               | 113 +++-
 net/bluetooth/rfcomm/core.c                        |  13 +-
 net/bluetooth/rfcomm/tty.c                         |   4 +-
 net/bluetooth/sco.c                                |  13 +
 net/bluetooth/smp.c                                |  29 +-
 40 files changed, 1846 insertions(+), 329 deletions(-)
 rename Documentation/networking/{6lowpan.txt => 6lowpan.rst} (64%)


--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQ8m6QjaLXd1XJ73Dsfyv3T9pQ3KgUCXnPH5wAKCRAfyv3T9pQ3
Ki4WAP4n3A9oWq1RVuNbunQGVBh6ALOto3D6o/B0vOdt36qgOAEAyFYi8QyfKbuG
7bNYfp+xCwRXgGpk17KA5qGiY3GqfgE=
=ULWu
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--

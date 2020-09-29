Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC9E27C36C
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 13:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgI2LFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 07:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728730AbgI2LF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 07:05:26 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3481AC0613D0;
        Tue, 29 Sep 2020 04:05:25 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x22so4144778pfo.12;
        Tue, 29 Sep 2020 04:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition;
        bh=ljOk7a5C0MXtrzoZR3yIufkcsP+1k/zo/iX9VDr6GmM=;
        b=fXOGnX1tekcnFXhJ6S/9HOj+usN7K12NXkrMWxdiaF4/Y0IUxtqnehDgSDVSrYI9tm
         eMatev1lQ76bTpwxi2IM9qbt1fUPliROgp0nPKPpiLwc8Yur9lhJmIvexUNuYbLPWL25
         pSfYDt9gob1WAUlTOzask1rvhUfEiLTa3Rcdg46558SlJamdYhh4qKsEAZzAceyNaiWv
         eHcm/xEVXh3PkvDey0PaSlfRc5RhTDyctV7obRXEz7RscwIxoy2IF4SFRtyEVZBmKNTM
         2Z2rpCkYBPqKYi1p7FF1aW0yPP1MSTIWp27pV74bIUp+WdlCWnOK0HxXQHjYbfIa2LSH
         ZICQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition;
        bh=ljOk7a5C0MXtrzoZR3yIufkcsP+1k/zo/iX9VDr6GmM=;
        b=VMDBd3043nmAGMrZqXg7mZ5qnq1n6hWO16vv2POUGDLznj9+QJAhXVb7TQ/YIqOkHS
         KH81QN7KseLkfMuUwMXC74l1kyqlfTVigpUsKLY8G/5lmPjCnt+75GsACybhuzEwZ+pR
         xlwtl/LF3KjZtq6wtEdDtFud6QhoHOlq6octFOQeHX6/gatbMC69WamNQXJ1AXCSxVAJ
         Wp/dL2rwYcjs6GHN3Y67O8Oa7P/Kqz8/erbWE3m+BvfzsF6w2FVBER8Mt5jPucQqTKVU
         lRCxx58g6K6AjZu/RlBo+OhcZvmYNl7UGgCemVAMY8cxXfIdns7hsPKgIx2PHiyokf6q
         L7Eg==
X-Gm-Message-State: AOAM530hKLW+9HHnKvT/SeSvdPnd8Aa3hqqWEOvURo0QR1Mhu1zqAKjl
        btjPJLsqzGqvD17x4vp8iDjlFa35fiUVdQ==
X-Google-Smtp-Source: ABdhPJw7RRr/06cCKeqwOOsuX4pkw1WPgEbYhLsJfdB0KAa8znZibPd5rcuzOSaFsiYSBEEOgL/bxA==
X-Received: by 2002:a17:902:b216:b029:d1:e5e7:be05 with SMTP id t22-20020a170902b216b02900d1e5e7be05mr3974826plr.56.1601377524428;
        Tue, 29 Sep 2020 04:05:24 -0700 (PDT)
Received: from localhost (jfdmzpr04-ext.jf.intel.com. [134.134.137.73])
        by smtp.gmail.com with ESMTPSA id r1sm4551343pgl.66.2020.09.29.04.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 04:05:23 -0700 (PDT)
Date:   Tue, 29 Sep 2020 14:05:19 +0300
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2020-09-29
Message-ID: <20200929110519.GA43102@Dgorle-MOBL1.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Here's the main bluetooth-next pull request for 5.10:

 - Multiple fixes to suspend/resume handling
 - Added mgmt events for controller suspend/resume state
 - Improved extended advertising support
 - btintel: Enhanced support for next generation controllers
 - Added Qualcomm Bluetooth SoC WCN6855 support
 - Several other smaller fixes & improvements

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 7126bd5c8bcbc015cf89864cf71d750e8f33f924:

  mptcp: fix syncookie build error on UP (2020-08-01 11:52:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.gi=
t for-upstream

for you to fetch changes up to b40f58b973865ee98ead884d2bdc7880b896ddb8:

  Bluetooth: btusb: Add Qualcomm Bluetooth SoC WCN6855 support (2020-09-27 =
23:44:50 +0200)

----------------------------------------------------------------
Abhishek Pandit-Subedi (7):
      Bluetooth: Clear suspend tasks on unregister
      Bluetooth: Re-order clearing suspend tasks
      Bluetooth: Only mark socket zapped after unlocking
      Bluetooth: Set ext scan response only when it exists
      Bluetooth: Add mgmt suspend and resume events
      Bluetooth: Add suspend reason for device disconnect
      Bluetooth: Emit controller suspend and resume events

Andy Shevchenko (3):
      Bluetooth: hci_intel: drop strange le16_to_cpu() against u8 values
      Bluetooth: hci_intel: switch to list_for_each_entry()
      Bluetooth: hci_intel: enable on new platform

Daniel Winkler (3):
      Bluetooth: Report num supported adv instances for hw offloading
      Bluetooth: Add MGMT capability flags for tx power and ext advertising
      Bluetooth: pause/resume advertising around suspend

Dinghao Liu (1):
      Bluetooth: btusb: Fix memleak in btusb_mtk_submit_wmt_recv_urb

Howard Chung (1):
      Bluetooth: Set scan parameters for ADV Monitor

Joseph Hwang (1):
      Bluetooth: sco: new getsockopt options BT_SNDMTU/BT_RCVMTU

Kiran K (4):
      Bluetooth: btusb: Update boot parameter specific to SKU
      Bluetooth: btintel: Refactor firmware download function
      Bluetooth: btintel: Add infrastructure to read controller information
      Bluetooth: btintel: Functions to send firmware header / payload

Luiz Augusto von Dentz (4):
      Bluetooth: A2MP: Fix not initializing all members
      Bluetooth: L2CAP: Fix calling sk_filter on non-socket based channel
      Bluetooth: Disable High Speed by default
      Bluetooth: MGMT: Fix not checking if BT_HS is enabled

Miao-chen Chou (1):
      Bluetooth: Update Adv monitor count upon removal

Peilin Ye (1):
      Bluetooth: Fix memory leak in read_adv_mon_features()

Rocky Liao (2):
      Bluetooth: btusb: Enable wide band speech support for BTUSB_QCA_ROME
      Bluetooth: btusb: Add Qualcomm Bluetooth SoC WCN6855 support

Samuel Holland (2):
      Bluetooth: hci_h5: Remove ignored flag HCI_UART_RESET_ON_INIT
      Bluetooth: hci_uart: Cancel init work before unregistering

Sathish Narasimman (1):
      Bluetooth: Fix update of own_addr_type if ll_privacy supported

Sonny Sasaka (1):
      Bluetooth: Fix auto-creation of hci_conn at Conn Complete event

Tam=C3=A1s Sz=C5=B1cs (1):
      Bluetooth: btmrvl: eliminate duplicates introducing btmrvl_reg_89xx

Venkata Lakshmi Narayana Gubba (2):
      Bluetooth: hci_serdev: Close UART port if NON_PERSISTENT_SETUP is set
      Bluetooth: hci_qca: Remove duplicate power off in proto close

Xu Wang (1):
      Bluetooth: hci_qca: remove redundant null check

YueHaibing (1):
      Bluetooth: btmtksdio: use NULL instead of zero

 drivers/bluetooth/btintel.c      | 291 +++++++++++++++++++++++++++++++++++=
+++-
 drivers/bluetooth/btintel.h      |  91 ++++++++++++
 drivers/bluetooth/btmrvl_sdio.c  |  54 +-------
 drivers/bluetooth/btmtksdio.c    |   4 +-
 drivers/bluetooth/btusb.c        | 129 ++++++++++++-----
 drivers/bluetooth/hci_h5.c       |   2 -
 drivers/bluetooth/hci_intel.c    |  54 +++-----
 drivers/bluetooth/hci_ldisc.c    |   1 +
 drivers/bluetooth/hci_qca.c      |   8 +-
 drivers/bluetooth/hci_serdev.c   |  36 ++++-
 include/net/bluetooth/hci_core.h |   6 +
 include/net/bluetooth/l2cap.h    |   2 +
 include/net/bluetooth/mgmt.h     |  18 +++
 net/bluetooth/Kconfig            |   1 -
 net/bluetooth/a2mp.c             |  22 ++-
 net/bluetooth/hci_core.c         |  41 +++++-
 net/bluetooth/hci_event.c        |  89 +++++++++++-
 net/bluetooth/hci_request.c      |  85 ++++++++++--
 net/bluetooth/l2cap_core.c       |   7 +-
 net/bluetooth/l2cap_sock.c       |  21 ++-
 net/bluetooth/mgmt.c             |  57 ++++++--
 net/bluetooth/sco.c              |   6 +
 22 files changed, 851 insertions(+), 174 deletions(-)

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQ8m6QjaLXd1XJ73Dsfyv3T9pQ3KgUCX3MU7QAKCRAfyv3T9pQ3
KmNyAQC62zCnixV90766PmzI9yWVSOuE8HIFSk2hAEjxi0rRqwD/aiwb6jiYkaZq
9w6MufHhaV8UdyrBKcbijIFcamGCyA0=
=O8sl
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--

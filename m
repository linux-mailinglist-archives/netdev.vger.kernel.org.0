Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4816146B
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfGGIHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:07:54 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:46318 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfGGIHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:07:54 -0400
Received: by mail-pl1-f180.google.com with SMTP id c2so5056854plz.13;
        Sun, 07 Jul 2019 01:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=Rv/kL2Omk+edBiwz5S+x4MbxCi8H0KU1MTVaMm2hiC4=;
        b=tbSYhZyxy4VN2B535WEqXqNOuy3v4JWLUEgOmj3gR45on0QcOpL++ZEkmH6UHsten4
         WHME+zq+dC9Nm1IeZ+IsJYScg8KlrOa7j9kYvrfyPuTOHdeFThmHBlLEBluEq7fas025
         GwUSBDCfMBdi6DkEDWDOqerffqnfcMNkuDR4o3r9j7ikt8GbuIgBkb3o2uyC8J9hUUzS
         yEvoIH1YEFlpl8wKZNcP86x9VVR361VU58JGBZDBHnJXIux9uZJx32u3HgoeJzBpFzuy
         aCeqdRFgUdThPMX9Jg2Ly9tH2uUbrqATz8l8a4+mmYChUpGos5gwpQPFT1xvIZFVZgC0
         jNlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=Rv/kL2Omk+edBiwz5S+x4MbxCi8H0KU1MTVaMm2hiC4=;
        b=VhnngMHhH1ztv8KGWxjvzC/eSrdHK4qfojza1NStEMTmNkaF9mCLRseya4GIZDhXlA
         nKXTMLDtPfcsnyiyvh46HYyNI3cjrXhoWpco/h1gYQRFHYxjCK61bx4WV/JYT2F7ko6n
         KEIlzhdkVVCXvkUsHLHe4dqVSxL2rI7lRzHpJbnhd7WIyThcoanYSVqlXrs3Np6LH5Il
         uGZabEba+Jg1Bpg7+fAyn5eMzwFoppS6wWEWEgk8m/ZKiyyQliVfianxyv6uonjkoHnI
         enNeTE6S05JLhTgH1iKmjlWkWgzap4Zpg4M5eQm6dRFU5tvGmOjlwtAYO8Bjgl7vLX+u
         Ugjg==
X-Gm-Message-State: APjAAAVmiKFb9Y3tt0ScDgVcp3IslhRxMULx797VfgIUZ3/lqZSRjHop
        eH7jLczIy9SbHBWcQYlQlsgcXlEI09888Q==
X-Google-Smtp-Source: APXvYqxV2t64gi+6tY+KhV5pbjpHoWytjrfpVVcnQ2jG/R7QyYr9Ouw5fe+jIoH+3mC59fWFw769Dg==
X-Received: by 2002:a17:902:e40f:: with SMTP id ci15mr15608143plb.103.1562486873469;
        Sun, 07 Jul 2019 01:07:53 -0700 (PDT)
Received: from localhost ([134.134.139.77])
        by smtp.gmail.com with ESMTPSA id p19sm21031733pfn.99.2019.07.07.01.07.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Jul 2019 01:07:52 -0700 (PDT)
Date:   Sun, 7 Jul 2019 11:07:49 +0300
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next 2019-07-07
Message-ID: <20190707080749.GA26799@lazarenk-mobl.amr.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Here's the main bluetooth-next pull request for 5.3:

 - Added support for new devices from Qualcomm, Realtek and Broadcom and
   MediaTek
 - Various fixes to 6LoWPAN
 - Fix L2CAP PSM namespace separation for LE & BR/EDR
 - Fix behavior with Microsoft Surface Precision Mouse
 - Added support for LE Ping feature
 - Fix L2CAP Disconnect response handling if received in wrong state

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 23f30c41c732fe9800f4a2d545b37c9515d35ad6:

  Merge branch 'mlx5-TLS-TX-HW-offload-support' (2019-07-05 16:42:00 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.gi=
t for-upstream

for you to fetch changes up to 9ce67c3235be71e8cf922a9b3d0b7359ed3f4ce5:

  Bluetooth: btusb: Add protocol support for MediaTek MT7663U USB devices (=
2019-07-06 21:44:25 +0200)

----------------------------------------------------------------
Balakrishna Godavarthi (1):
      Bluetooth: btqca: inject command complete event during fw download

Dan Carpenter (1):
      Bluetooth: hidp: NUL terminate a string in the compat ioctl

Fabian Schindlatz (2):
      Bluetooth: hci_ll: Refactor download_firmware
      Bluetooth: Cleanup formatting and coding style

Greg Kroah-Hartman (1):
      6lowpan: no need to check return value of debugfs_create functions

Jian-Hong Pan (1):
      Bluetooth: btrtl: HCI reset on close for Realtek BT chip

Josua Mayer (3):
      Bluetooth: 6lowpan: search for destination address in all peers
      Bluetooth: 6lowpan: check neighbour table for SLAAC
      Bluetooth: 6lowpan: always check destination address

Jo=E3o Paulo Rechi Vita (2):
      Bluetooth: Add new 13d3:3501 QCA_ROME device
      Bluetooth: Add new 13d3:3491 QCA_ROME device

Larry Finger (1):
      Bluetooth:: btrtl: Add support for RTL8723DU

Luiz Augusto von Dentz (2):
      Bluetooth: Use controller sets when available
      Bluetooth: L2CAP: Check bearer type on __l2cap_global_chan_by_addr

Matias Karhumaa (1):
      Bluetooth: Check state in l2cap_disconnect_rsp

Matthias Kaehlcke (1):
      Bluetooth: hci_qca: wcn3990: Drop baudrate change vendor event

Neil Armstrong (1):
      Bluetooth: btbcm: Add entry for BCM4359C0 UART bluetooth

Peter Robinson (1):
      Bluetooth: btsdio: Do not bind to non-removable BCM4356

Philipp Puschmann (1):
      Bluetooth: hci_ll: set operational frequency earlier

Rocky Liao (2):
      Bluetooth: hci_qca: Load customized NVM based on the device property
      dt-bindings: net: bluetooth: Add device property firmware-name for QC=
A6174

Sascha Hauer (3):
      Bluetooth: hci_ldisc: Add function to wait for characters to be sent
      Bluetooth: hci_mrvl: Wait for final ack before switching baudrate
      Bluetooth: hci_mrvl: Add serdev support

Sean Wang (6):
      dt-bindings: net: bluetooth: add boot-gpios property to UART-based de=
vice
      dt-bindings: net: bluetooth: add clock property to UART-based device
      Bluetooth: btmtkuart: add an implementation for boot-gpios property
      Bluetooth: btmtkuart: add an implementation for clock osc property
      Bluetooth: btusb: Add protocol support for MediaTek MT7668U USB devic=
es
      Bluetooth: btusb: Add protocol support for MediaTek MT7663U USB devic=
es

Spoorthi Ravishankar Koppad (1):
      Bluetooth: Add support for LE ping feature

Szymon Janc (1):
      Bluetooth: Add SMP workaround Microsoft Surface Precision Mouse bug

Tomas Bortoli (1):
      Bluetooth: hci_bcsp: Fix memory leak in rx_skb

csonsino (1):
      Bluetooth: validate BLE connection interval updates

 .../devicetree/bindings/net/marvell-bluetooth.txt  |  25 +
 .../devicetree/bindings/net/mediatek-bluetooth.txt |  17 +
 .../devicetree/bindings/net/qualcomm-bluetooth.txt |   4 +
 drivers/bluetooth/Kconfig                          |  12 +
 drivers/bluetooth/bpa10x.c                         |   3 +-
 drivers/bluetooth/btbcm.c                          |   1 +
 drivers/bluetooth/btmtkuart.c                      |  51 +-
 drivers/bluetooth/btqca.c                          |  47 +-
 drivers/bluetooth/btqca.h                          |  10 +-
 drivers/bluetooth/btrtl.c                          |  28 +
 drivers/bluetooth/btrtl.h                          |   6 +
 drivers/bluetooth/btsdio.c                         |   1 +
 drivers/bluetooth/btusb.c                          | 584 +++++++++++++++++=
++++
 drivers/bluetooth/hci_bcsp.c                       |   5 +
 drivers/bluetooth/hci_ldisc.c                      |   8 +
 drivers/bluetooth/hci_ll.c                         | 109 ++--
 drivers/bluetooth/hci_mrvl.c                       |  72 ++-
 drivers/bluetooth/hci_qca.c                        |  73 ++-
 drivers/bluetooth/hci_uart.h                       |   1 +
 include/net/bluetooth/hci.h                        |  20 +
 include/net/bluetooth/hci_core.h                   |   4 +
 net/6lowpan/6lowpan_i.h                            |  16 +-
 net/6lowpan/core.c                                 |   8 +-
 net/6lowpan/debugfs.c                              |  97 +---
 net/bluetooth/6lowpan.c                            |  41 +-
 net/bluetooth/hci_conn.c                           |   5 +-
 net/bluetooth/hci_core.c                           |   4 +-
 net/bluetooth/hci_debugfs.c                        |  31 ++
 net/bluetooth/hci_event.c                          |  77 +++
 net/bluetooth/hci_request.c                        |  40 +-
 net/bluetooth/hci_request.h                        |   2 +-
 net/bluetooth/hidp/core.c                          |   2 +-
 net/bluetooth/hidp/sock.c                          |   1 +
 net/bluetooth/l2cap_core.c                         |  29 +-
 net/bluetooth/smp.c                                |  13 +
 35 files changed, 1266 insertions(+), 181 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell-bluetooth=
=2Etxt

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEyxvsVXjY3jV7sQ0/JCP2+/mo1BIFAl0hqFIACgkQJCP2+/mo
1BKyeA//c6xz+zg5tr7qZjHRnFedwfr5OS1zmRapAd1XI3roPT/WVXEX5Ey7jixN
cM7D7vvHmy0eBifO5Tiy3sE5IeY6AJWu04fPol0WD1T1gTYK/i2msb+u6/+WwKgk
XNxpmcDfP3RYV2jScg8gum62QjwH8C7va8MMUm/mmt777qK5EuRA2ZhpREP6MkVA
WYkCnHZr6RQOurP96ntAi9Wn2FjlAgBWl2+MBvAHMmS9zr+Cf0zW9/o1ZtbhLx9P
/0XO6oIbhw1sHcqIrsM+tkey6mk/e1eeip/dyBsiwbD1NIEu/EnVX18s0CBIVQ86
WAgRa13c16/Irc2LTOgcVdcRnpVVWI1WVL9UrwfND8/2HZ4y7mbBe8e/qmRVQaq3
ra7Z3s7Dg4ZEduD5789I57nW7nGxnx6QXAFzwuLLBN/yd2Jg5uGtn2QVggduNfCB
aqJO1RTUKTB59ch9dcXjoTOGa0FL55sQNItavRKntdcdbiApoghQB4HeI37weFuL
+1yZojvEKeAPQwfCq21bc4glrllOee+vy8J1mmaIIKw1dC9lyzNrMZhcmHJ3qXda
dBDxSHWxNqfOYdcwN/6ShLSWFAmu8bX0b6TvK8VTH2HVN8y/GGUqpRpx+WbHr+h2
z4Vd2lggDcyhjH8zcYwzfLsXHD+hLKAhr7Y7ZRbPetfgdocDQnc=
=tEbq
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--

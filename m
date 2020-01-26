Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59D6F149AE5
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 15:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgAZOBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 09:01:30 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:39466 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbgAZOB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 09:01:29 -0500
Received: by mail-pj1-f46.google.com with SMTP id e11so2018502pjt.4;
        Sun, 26 Jan 2020 06:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=PVKhboq1T9eiF6UWOxb3kz8bKSV07lYJnv/NX33PCdo=;
        b=irmSicrFlKQfcqWTZRLJutWCTo1rt6O0/KZXV8qMD4eUpXZzx9Mw6ssTEzhfbEUyu2
         o2LzOaI5blPEhU1QD2fZZ442bAGp1ifPG+DSfIQJ998LK2Wue9QBaKmMgzsKZnXmtQip
         dxNPmhorZMvsBVUrM8N87DTnI9Qw8/FKv+7JeBWe88uERQoWONkTDU9+3RjleiIhmPZF
         oapn/TCBGVA7ll11KYzQSVqbp+jEcbz/jilZ3afvxX5Uuvi1hqW6wQGQ4i0mcATmuRIp
         vVUlEFZ/uITsdT0Qu8pmT8taOnZ1p3++IZzP2yE3YXUnzhp1SbQ6B9zvDM9WIqPpAe0k
         cAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=PVKhboq1T9eiF6UWOxb3kz8bKSV07lYJnv/NX33PCdo=;
        b=SKyZg7aBVnQm1ySZDr8Nzv2FFMLZEN0vYT6xJVGx0I4B/0OC8D98/IWsFzQUq448wL
         JcoKQQuCyu3T5ur85lZoEka8r+TXOHPYpjm3KA5ZqdfSDwFIFmHRT3vMtIGcZNswCHlG
         9+3H7el+XLb9f3qxbU88TWq7rzEhnhZhaJzeYMliy1mEjOH4ElxNKasnMrisuJpBqg41
         79JUi1jayTmGwdUQWHJy89TmBxUJjByhMUJx0Dv7X0Dni4d1c3DSeRanOVkJemNtU6S7
         uoq0B0A3pi0J+/3zfVRsAx0dQNTN29xGldCzLh/Os5tcrSd0YvRPXw0A1R1j2ygkRzAB
         4rWQ==
X-Gm-Message-State: APjAAAVAX9sCksEYhTHEmFZrjlBabrjyjkCUIFZ//8SQ+J8FcfjKMZED
        SdI09cgq2nsrprc9hoivWZJYcTTi/mG2Eg==
X-Google-Smtp-Source: APXvYqyzI5SRWtRVAW6rUrC5TKQjiaEJS43BHuB04Or+nFCoC68MqkHfoFr31QFDGlesoJRG7mo82w==
X-Received: by 2002:a17:902:7896:: with SMTP id q22mr13540292pll.57.1580047288836;
        Sun, 26 Jan 2020 06:01:28 -0800 (PST)
Received: from localhost ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id e15sm12891514pja.13.2020.01.26.06.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jan 2020 06:01:27 -0800 (PST)
Date:   Sun, 26 Jan 2020 16:01:23 +0200
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2020-01-26
Message-ID: <20200126140123.GA77676@pmessmer-mobl1.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave,

Here's (probably) the last bluetooth-next pull request for the 5.6 kernel.

 - Initial pieces of Bluetooth 5.2 Isochronous Channels support
 - mgmt: Various cleanups and a new Set Blocked Keys command
 - btusb: Added support for 04ca:3021 QCA_ROME device
 - hci_qca: Multiple fixes & cleanups
 - hci_bcm: Fixes & improved device tree support
 - Fixed attempts to create duplicate debugfs entries

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 3c85efb8f15ffa5bd165881b9fd1f9e5dd1d705f:

  bna: remove set but not used variable 'pgoff' (2020-01-03 12:31:32 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 11eb85ec42dc8c7a7ec519b90ccf2eeae9409de8:

  Bluetooth: Fix race condition in hci_release_sock() (2020-01-26 10:34:17 +0200)

----------------------------------------------------------------
Abhishek Pandit-Subedi (1):
      Bluetooth: btbcm: Add missing static inline in header

Alain Michaud (4):
      Bluetooth: Adding a bt_dev_warn_ratelimited macro.
      Bluetooth: Implementation of MGMT_OP_SET_BLOCKED_KEYS.
      Bluetooth: adding missing const decoration to mgmt_status_table
      Bluetooth: fix appearance typo in mgmt.c

Balakrishna Godavarthi (1):
      Bluetooth: hci_qca: Collect controller memory dump during SSR

Changqi Du (1):
      Bluetooth: btbcm : Fix warning about missing blank lines after declarations

Colin Ian King (1):
      Bluetooth: remove redundant assignment to variable icid

Dan Carpenter (1):
      Bluetooth: Fix race condition in hci_release_sock()

Dmitry Osipenko (2):
      Bluetooth: hci_bcm: Add device-tree compatible for BCM4329
      dt-bindings: net: broadcom-bluetooth: Document BCM4329 support

Guillaume La Roque (2):
      dt-bindings: net: bluetooth: add interrupts properties
      Bluetooth: hci_bcm: enable IRQ capability from devicetree

Luiz Augusto von Dentz (9):
      Bluetooth: Add support for LE PHY Update Complete event
      Bluetooth: Auto tune if input MTU is set to 0
      Bluetooth: Add definitions for CIS connections
      Bluetooth: hci_vhci: Add support for ISO packets
      Bluetooth: monitor: Add support for ISO packets
      Bluetooth: Make use of __check_timeout on hci_sched_le
      Bluetooth: hci_h4: Add support for ISO packets
      Bluetooth: hci_h5: Add support for ISO packets
      Bluetooth: btsdio: Check for valid packet type

Marcel Holtmann (4):
      Bluetooth: Remove usage of BT_ERR_RATELIMITED macro
      Bluetooth: Increment management interface revision
      Bluetooth: Add missing checks for HCI_ISODATA_PKT packet type
      Bluetooth: Move {min,max}_key_size debugfs into hci_debugfs_create_le

Maxim Mikityanskiy (1):
      Bluetooth: btrtl: Use kvmalloc for FW allocations

Rocky Liao (6):
      Bluetooth: hci_qca: Replace of_device_get_match_data with device_get_match_data
      Bluetooth: btusb: Add support for 04ca:3021 QCA_ROME device
      Bluetooth: hci_qca: Add qca_power_on() API to support both wcn399x and Rome power up
      Bluetooth: hci_qca: Add QCA Rome power off support to the qca_power_shutdown()
      Bluetooth: hci_qca: Retry btsoc initialize when it fails
      Bluetooth: hci_qca: Enable power off/on support during hci down/up for QCA Rome

Stefan Wahren (1):
      Bluetooth: hci_bcm: Drive RTS only for BCM43438

Wei Yongjun (1):
      Bluetooth: hci_qca: Use vfree() instead of kfree()

YueHaibing (1):
      Bluetooth: hci_qca: Remove set but not used variable 'opcode'

 .../devicetree/bindings/net/broadcom-bluetooth.txt |   8 +-
 drivers/bluetooth/btbcm.c                          |   2 +
 drivers/bluetooth/btbcm.h                          |   4 +-
 drivers/bluetooth/btrtl.c                          |  20 +-
 drivers/bluetooth/btsdio.c                         |  19 +-
 drivers/bluetooth/btusb.c                          |   1 +
 drivers/bluetooth/hci_bcm.c                        |  25 +-
 drivers/bluetooth/hci_h4.c                         |   1 +
 drivers/bluetooth/hci_h5.c                         |   3 +
 drivers/bluetooth/hci_qca.c                        | 418 ++++++++++++++++++---
 drivers/bluetooth/hci_uart.h                       |   7 +
 drivers/bluetooth/hci_vhci.c                       |   1 +
 include/net/bluetooth/bluetooth.h                  |   8 +-
 include/net/bluetooth/hci.h                        | 165 ++++++++
 include/net/bluetooth/hci_core.h                   |  12 +
 include/net/bluetooth/hci_mon.h                    |   2 +
 include/net/bluetooth/mgmt.h                       |  17 +
 net/bluetooth/hci_core.c                           | 100 ++++-
 net/bluetooth/hci_debugfs.c                        |  78 ++++
 net/bluetooth/hci_event.c                          |  41 +-
 net/bluetooth/hci_sock.c                           |  21 +-
 net/bluetooth/l2cap_core.c                         |  55 ++-
 net/bluetooth/lib.c                                |  16 +
 net/bluetooth/mgmt.c                               |  88 ++++-
 net/bluetooth/smp.c                                | 111 +-----
 25 files changed, 1019 insertions(+), 204 deletions(-)

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEyxvsVXjY3jV7sQ0/JCP2+/mo1BIFAl4tm7AACgkQJCP2+/mo
1BLJYw/8CtrZHYpz9HleDZ9gAa3RIqf6fRif0wjN+tlbRT/rK2muNebvtrPmyp3X
tLYEQxrM96eEop5eDnDqIbeEoQ96YYERmpDsSlagdijLyOiHz4TX5eGYyTQzpQrc
mu46zu3II7mtBELyKn7LydLmlgc2h/kf3fNPWxwsJkhjhFER33IB/GO6hIJF3jxZ
v66JoacyRYuddeu42uAptEfqck0Dq1iKB9J5kQo2z2CNK/GpVZe5uKUgHPQRr4I0
/T2z+97WPO7YIgg9D4AvTImOanb1OsY1f5Bt1hW2HGpqgyeAcwhZGJpz8rmb0BEV
4dT/M1C6FvJ5bwLGBmIkMvhzIm5g+fVAJO4j6KyhzvzTFXcptvZMkJ6myBpPkEqt
2bK1Pcp5iufR2E9YvQ/qLMcleEdFy8eOgmu/YKHKKkxR/7hb4iShZjzdCU3SnNSQ
rD5FgAtzxNmdkaXXddUiy8Kmzx2ttPohcAFesXsmyud5TKxT94XGFWGcwnSHelhs
Y1HSvf3BOuHWdazZCiKsAl11k17xa52y1GbdgQ94zoDs63Lp0Mi6tsc/z6j14kZQ
tBDCYhuFx2Vf2pEmaIGtz9uRen20yXZZsQTyuCPpVwj/7dN1N3jtfbRukBV24ih0
f9YJoHTfdjPG8jV/jdnfQ+kHggpFW9r3dsjCG2SIG4gXG3gm1VA=
=AL/X
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--

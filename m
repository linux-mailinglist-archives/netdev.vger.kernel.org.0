Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AEB1AD8D7
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 10:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgDQInT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 04:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729166AbgDQInS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 04:43:18 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7947AC061A0C;
        Fri, 17 Apr 2020 01:43:18 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id o185so249863pgo.3;
        Fri, 17 Apr 2020 01:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=ZYtPxSkxPL8MYWDVQZPQD6mXE0FtUySZKXmEXI2AGWI=;
        b=hyzfylL8sSo+OmuHJ6mWKB0re2iYDIFctW9BkIwsY1aPIogRPtprWRZdUDOma+4QI3
         Hg2jgq+mRybILpyWYiQuEh4XdpDLYatrE8eBWoEoDGeGrYGZXUYG7o1CtsvlxCwIS1w7
         3f4G22PZEM+SM4XYpTSGm/CdahakH6TigV/ANEQt9sPNczlKgTxB9a/CJO+L87Vo+q3h
         +uSCn9KHm08RpXG5ruidVJ4KLJCIJP2BURvPVsQQaaijOCOTYKjt50hMRXUSt3Y4vcdZ
         Ot9NPvuNfWuqJFefuhF37GySCNe68K90MaMA71i7konutPu92Bi4SJ/PHs5JkyqwYPae
         DNiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=ZYtPxSkxPL8MYWDVQZPQD6mXE0FtUySZKXmEXI2AGWI=;
        b=NReO4KbL7FmyFikbRPstBf5v4FU53uKuiEkrFqJBfEunl2yIw4YOPwJelHkZwxYTOZ
         zqAKRguMDRItr1iwEGtJeqQEubmWV7ooqhQv+R8Mro6gqzph+fgHG/xZLRVMQCIlG8hC
         sDaa3gmKZj8/UhiQsoVrj3TCu25i2ru6BbU2P35HGzvp/psOI4NLHOM7zZmwL0KT5Y/i
         gT1Ao6IsG9b8cZvKaqGM2UEOM2lJNj9asnJCD96ysINwU5gL86ulphDc8T6TICS/Ipz2
         5zYLhZRqdjlA0EpBE94QN3usiBCMeEYXtYC53970OhlTP5vVxhFg6cOjvxrxR18Jx/Yd
         1ctQ==
X-Gm-Message-State: AGi0PuaqkGbQUlj5ZMi0/yo+SsIXQSKep68gZrpavxCNn9PPw7C2lVBi
        lBWpm7WsDYFIyFRTveTI7W5/J7xRentuPQ==
X-Google-Smtp-Source: APiQypIG3l57lTVNTmyGPL2tQbzXEITTY6MSA+qiqQr7fURp/jIdnH9YQ/QvDkYr3PgcM9u2q7l/Xw==
X-Received: by 2002:aa7:9904:: with SMTP id z4mr2111771pff.38.1587112997877;
        Fri, 17 Apr 2020 01:43:17 -0700 (PDT)
Received: from localhost ([134.134.139.83])
        by smtp.gmail.com with ESMTPSA id r13sm18054229pgj.9.2020.04.17.01.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 01:43:17 -0700 (PDT)
Date:   Fri, 17 Apr 2020 11:43:13 +0300
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2020-04-17
Message-ID: <20200417084313.GA48142@oeltahan-mobl.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Here's the first bluetooth-next pull request for the 5.8 kernel:

 - Added debugfs option to control MITM flag usage during pairing
 - Added new BT_MODE socket option
 - Added support for Qualcom QCA6390 device
 - Added support for Realtek RTL8761B device
 - Added support for mSBC audio codec over USB endpoints
 - Added framework for Microsoft HCI vendor extensions
 - Added new Read Security Information management command
 - Fixes/cleanup to link layer privacy related code
 - Various other smaller cleanups & fixes

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 1a323ea5356edbb3073dc59d51b9e6b86908857d:

  x86: get rid of 'errret' argument to __get_user_xyz() macross (2020-03-31=
 18:23:47 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.gi=
t for-upstream

for you to fetch changes up to 7edc9079540b65026f3d3386b3642d1820d5fed5:

  Bluetooth: Enhanced Connection Complete event belongs to LL Privacy (2020=
-04-16 12:43:03 +0300)

----------------------------------------------------------------
Abhishek Pandit-Subedi (1):
      Bluetooth: Prioritize SCO traffic

Alain Michaud (1):
      Bluetooth: fixing minor typo in comment

Archie Pusaka (1):
      Bluetooth: debugfs option to unset MITM flag

Daniels Umanovskis (1):
      Bluetooth: log advertisement packet length if it gets corrected

Guenter Roeck (1):
      Bluetooth: Simplify / fix return values from tk_request

Luiz Augusto von Dentz (2):
      Bluetooth: L2CAP: Fix handling LE modes by L2CAP_OPTIONS
      Bluetooth: Add BT_MODE socket option

Marcel Holtmann (11):
      Bluetooth: Move debugfs configuration above the selftests
      Bluetooth: btusb: Enable Intel events even if already in operational =
mode
      Bluetooth: Add support for Read Local Simple Pairing Options
      Bluetooth: Add support for reading security information
      Bluetooth: Increment management interface revision
      Bluetooth: Add HCI device identifier for VIRTIO devices
      Bluetooth: Sort list of LE features constants
      Bluetooth: Use extra variable to make code more readable
      Bluetooth: Enable LE Enhanced Connection Complete event.
      Bluetooth: Clear HCI_LL_RPA_RESOLUTION flag on reset
      Bluetooth: Enhanced Connection Complete event belongs to LL Privacy

Miao-chen Chou (2):
      Bluetooth: Add framework for Microsoft vendor extension
      Bluetooth: btusb: Enable MSFT extension for Intel ThunderPeak devices

Micha=C5=82 Miros=C5=82aw (2):
      Bluetooth: hci_bcm: respect IRQ polarity from DT
      Bluetooth: hci_bcm: fix freeing not-requested IRQ

Rocky Liao (2):
      Bluetooth: hci_qca: Add support for Qualcomm Bluetooth SoC QCA6390
      dt-bindings: net: bluetooth: Add device tree bindings for QCA chip QC=
A6390

Sathish Narasimman (2):
      Bluetooth: btusb: handle mSBC audio over USB Endpoints
      Bluetooth: btusb: check for NULL in btusb_find_altsetting()

Sathish Narsimman (1):
      Bluetooth: add support to notify using SCO air mode

Sonny Sasaka (2):
      Bluetooth: Always request for user confirmation for Just Works
      Bluetooth: Always request for user confirmation for Just Works (LE SC)

Ziqian SUN (Zamir) (1):
      Bluetooth: btrtl: Add support for RTL8761B

 .../devicetree/bindings/net/qualcomm-bluetooth.txt |   1 +
 drivers/bluetooth/btqca.c                          |  18 +-
 drivers/bluetooth/btqca.h                          |   3 +-
 drivers/bluetooth/btrtl.c                          |  10 +-
 drivers/bluetooth/btusb.c                          | 185 ++++++++++++++++-=
----
 drivers/bluetooth/hci_bcm.c                        |   8 +-
 drivers/bluetooth/hci_qca.c                        |  40 ++++-
 include/net/bluetooth/bluetooth.h                  |   8 +
 include/net/bluetooth/hci.h                        |  17 +-
 include/net/bluetooth/hci_core.h                   |  16 ++
 include/net/bluetooth/mgmt.h                       |   7 +
 net/bluetooth/Kconfig                              |  23 ++-
 net/bluetooth/Makefile                             |   1 +
 net/bluetooth/hci_conn.c                           |  25 ++-
 net/bluetooth/hci_core.c                           | 131 ++++++++-------
 net/bluetooth/hci_debugfs.c                        |  46 +++++
 net/bluetooth/hci_event.c                          |  54 +++++-
 net/bluetooth/hci_request.c                        |   4 +-
 net/bluetooth/l2cap_sock.c                         | 138 ++++++++++++++-
 net/bluetooth/mgmt.c                               |  55 +++++-
 net/bluetooth/msft.c                               | 141 ++++++++++++++++
 net/bluetooth/msft.h                               |  18 ++
 net/bluetooth/smp.c                                |  33 +++-
 23 files changed, 830 insertions(+), 152 deletions(-)
 create mode 100644 net/bluetooth/msft.c
 create mode 100644 net/bluetooth/msft.h

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQ8m6QjaLXd1XJ73Dsfyv3T9pQ3KgUCXplsHgAKCRAfyv3T9pQ3
Khx3AQCOCoJErZZnM4tstVhoBHv6hQguU7OtMfbNz0e2sCSktQD/Yb4dr6IrewB1
cYhoifI6FTz/31moVLkKYtRkgUXwJA8=
=Alls
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--

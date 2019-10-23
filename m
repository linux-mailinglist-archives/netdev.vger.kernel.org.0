Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E649BE2105
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 18:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfJWQvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 12:51:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41440 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfJWQvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 12:51:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id t3so12471869pga.8;
        Wed, 23 Oct 2019 09:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=gZgN2hGM2j7wSto2q0CnIK8/3sJDOxs1elTGzKeCXvg=;
        b=CRmiaPU6HwIUxYP+cDnaDpkbskTJPdS3PdxfjxD+SijY3sMTmBKzIBdZomWdmQtyKC
         hkddKOC6EpSofkYUawLUZGBSEl4r1ZO8Xz2rYlw3F3CVjkZae3vZIJoUvfs7YmnwukaE
         Y/LPJ0mmdN1zFQDrLK+r5exaczV2nnieGthj9ZPam79Py7YszRFNxo2oMt1enmj08OuV
         sm8GRRCvnYVVbyb7z/OIqekFjTW7y975q7lF0b8/kXY3NUIlUADJHG2a7z6TAx2SwiJq
         LZGoVx4EXE3tEnfNt4SQjzHwL4VM/rt9lr2IJZRn4G1hD7HIZ98LLH6PKAV8xgr7DdFI
         oCoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=gZgN2hGM2j7wSto2q0CnIK8/3sJDOxs1elTGzKeCXvg=;
        b=UybGKx7wZkpgIAd8YUsm/+4KBdcUN+Qj6oJE4PrYkDFP7MIBZ3L8poGWWgc01Zcgn7
         5ITIe1DgUD2pBPRh+gq9mm3hBTK8eKJjPi3m/dwedXVxA0fDHpR3/wyPWQDOeiNWvrUh
         IcRCtFdqZiWwey43sOF5mafy5zTIq6NJuG0e+CxUXzsXjy8gneodhMUj8HvH+ra/2zUM
         0HFlD/VINlTkbrK4au7L10cZ2GfFG3frohFE4Je7CwvptlUiWjxdmw51U1zm/t5x+hF4
         lAWqgj7K1ZP47tXWoHlcEQ+ULoILql1EqBZM/sD5cUFoEHLC30tS9WW9RYYdgLUx2lwf
         e2eQ==
X-Gm-Message-State: APjAAAWa//WxHMHMlXgyY0kcqdld9dprXf+bML7NqekPdSMsHq408LhB
        5bwYRTYdftksLwCTVbyMm50qZIoXpHyHaQ==
X-Google-Smtp-Source: APXvYqwAl1+FxG99vC8JvUpxrlLUJ0UB2Iwj7qJZy4ixh9Gr5ye8RNTVXXpwlbIFUyPBnWwdUtcZnQ==
X-Received: by 2002:a17:90a:86c9:: with SMTP id y9mr1131164pjv.67.1571849498554;
        Wed, 23 Oct 2019 09:51:38 -0700 (PDT)
Received: from localhost ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id i22sm2948542pfa.82.2019.10.23.09.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 09:51:37 -0700 (PDT)
Date:   Wed, 23 Oct 2019 19:51:33 +0300
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next 2019-10-23
Message-ID: <20191023165133.GA98720@amcewan-mobl1.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave,

Here's the main bluetooth-next pull request for the 5.5 kernel:

 - Multiple fixes to hci_qca driver
 - Fix for HCI_USER_CHANNEL initialization
 - btwlink: drop superseded driver
 - Add support for Intel FW download error recovery
 - Various other smaller fixes & improvements

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit d9f45ab9e671166004b75427f10389e1f70cfc30:

  net: bcmgenet: Add a shutdown callback (2019-10-15 20:59:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 3347a80965b38f096b1d6f995c00c9c9e53d4b8b:

  Bluetooth: hci_bcm: Fix RTS handling during startup (2019-10-21 17:05:14 +0200)

----------------------------------------------------------------
Adam Ford (1):
      Revert "Bluetooth: hci_ll: set operational frequency earlier"

Amit K Bag (2):
      Bluetooth: btusb: print FW version after FW download
      Bluetooth: btusb: Trigger Intel FW download error recovery

Arnd Bergmann (1):
      Bluetooth: btusb: avoid unused function warning

Ben Dooks (Codethink) (1):
      Bluetooth: missed cpu_to_le16 conversion in hci_init4_req

Bjorn Andersson (4):
      Bluetooth: hci_qca: Update regulator_set_load() usage
      Bluetooth: hci_qca: Don't vote for specific voltage
      Bluetooth: hci_qca: Use regulator bulk enable/disable
      Bluetooth: hci_qca: Split qca_power_setup()

Christophe JAILLET (1):
      Bluetooth: hci_nokia: Save a few cycles in 'nokia_enqueue()'

Jeffrey Hugo (2):
      Bluetooth: hci_qca: Add delay for wcn3990 stability
      Revert "Bluetooth: hci_qca: Add delay for wcn3990 stability"

Marcel Holtmann (1):
      Bluetooth: btusb: Use IS_ENABLED instead of #ifdef

Mattijs Korpershoek (1):
      Bluetooth: hci_core: fix init for HCI_USER_CHANNEL

Max Chou (1):
      Bluetooth: btrtl: Fix an issue for the incorrect error return code.

Nathan Chancellor (1):
      Bluetooth: btusb: Remove return statement in btintel_reset_to_bootloader

Sebastian Reichel (1):
      Bluetooth: btwilink: drop superseded driver

Stefan Wahren (1):
      Bluetooth: hci_bcm: Fix RTS handling during startup

Szymon Janc (1):
      Bluetooth: Workaround directed advertising bug in Broadcom controllers

YueHaibing (1):
      Bluetooth: remove set but not used variable 'smp'

 drivers/bluetooth/Kconfig     |  11 --
 drivers/bluetooth/Makefile    |   1 -
 drivers/bluetooth/btintel.c   |  45 ++++++
 drivers/bluetooth/btintel.h   |   5 +
 drivers/bluetooth/btrtl.c     |   2 +-
 drivers/bluetooth/btusb.c     |  54 ++++---
 drivers/bluetooth/btwilink.c  | 337 ------------------------------------------
 drivers/bluetooth/hci_bcm.c   |   2 +
 drivers/bluetooth/hci_ll.c    |  39 +++--
 drivers/bluetooth/hci_nokia.c |   2 +-
 drivers/bluetooth/hci_qca.c   | 135 +++++++----------
 net/bluetooth/hci_conn.c      |   8 +
 net/bluetooth/hci_core.c      |  13 +-
 net/bluetooth/smp.c           |   6 -
 14 files changed, 177 insertions(+), 483 deletions(-)
 delete mode 100644 drivers/bluetooth/btwilink.c

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEyxvsVXjY3jV7sQ0/JCP2+/mo1BIFAl2whRIACgkQJCP2+/mo
1BILNg//WMbTBzR0Bmb3GQROpIPbRqGZCxQfmCAaA7rgcL46CGEoKIOH+iR3JCLD
IsnHQc0Tt3GAcOJU7BjDhJiwiH6CBR+EAIOx0hKbTdYr88dOWnd8H8iU4M7fezl6
RwYi3s/TpdQ7ZSzulrkjfsPxkFGlN/aT6P+GF6m31Rp0CEpUtwXxrjo65nCwy4zW
ajhgqjHqgBt1+nsFaTFqqKjA+qMTssCrcq2uL6pXmBLY9QVScVLrE4zq+9OC/Pr/
lN4I8rLcP2Rq7zqHqpJdpa/LRHBt8zTJzk0671OV7eiGZned8oZ5iO8jcSu30CtD
5pSOzo1wPdWfJjkvDndLWuCUEoV7FPQLjPMFPyFpdcVgODnLUlL6vFuk00KQF/uh
f1Z+2JVWO1YD7ivhW2DMeH0zP1/jEjprN8djMcj5gK0PhcCxfoM3/Et1kHxMGynY
FMl10HZsP1TDhN6yxT+EA/TNoWT/g1YhRpAPYwd/o2TS93hMeZdsy50MxhPNWKXc
ffnuDQjQwwN8UD40Ug+vLBlMvAdylrItQTosbwQY7e12/GY+NhW8I1f6+08HOPXc
kagq3GLpZzsxOOdL44CI9lkgEKt9wKtx5pBAbQry040kyYJMd5P14dAmW1bJc2XO
FmCl8Be9djWaCJATnEJ6uzPfzn3aRjoFiMDyfBgoUtzWjxXtQYw=
=Uc88
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E80DF7FFD
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfKKTcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 14:32:54 -0500
Received: from mail-pl1-f174.google.com ([209.85.214.174]:38138 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfKKTcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 14:32:54 -0500
Received: by mail-pl1-f174.google.com with SMTP id w8so8214460plq.5;
        Mon, 11 Nov 2019 11:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=MAVRFnvbcrE0oPCckW9ArD+KIh8O0Hu6OBx+zFq+Fg4=;
        b=Drdzwb2nscVTUsB8sRGh16MAgdw5z+ll+mtgIJ15yQ8p+RYfZGwnrf0XYFbbyQ29jD
         kWP/2737Z1+FNx9tb6Vk2uX2ED2lJmrXmijq8YIjXuf1Wo7M3qpJrTCn+DnBD8cvRa+G
         oj3+6YYUOnYE9/hWv/Hfj4BrEDzo98UdhJQRFDpMN628uAcOjERUVL2CUY9MtapPn6Jb
         TOdhxknDp/7yEPABg0L8eqgB14dCt206lGqwP2DkQ7ne6E/EROL7nMZemwFXuz3soaFF
         bIMdusLhiEuX1xTIlGsZj3Uca/MJWOIVFd1EXvySSKs+O70vysrviwaMp0saaDheWt37
         1SNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=MAVRFnvbcrE0oPCckW9ArD+KIh8O0Hu6OBx+zFq+Fg4=;
        b=GMLDmH5E8ono08C6UNfPyGavnuObNl5NcfTtbiW+7MI4OKpN9UIMN+gio8dLyTEEv6
         hiQ7GdME8u26gf2yUZ3DCCdhx5gwrMWIud9GiW5O6OVXBAH/8QjH+mByRqSGrBaQGF9z
         bbU5e/xmi35mrXQqfPQC0yWG3pfMe84KJUF/c9hChmzGr8Z9O8afjeK96T9zdr6Z4QQh
         3/Jpzo6FQhvmRWYFkaHS3BChkfSK9XlwV9YWob6nOeixjOpS0KmRpHKaaDwwWe78HDyP
         exjqsBs1wqFd0qnKRP7dMhKsKcnQjbwFQdo9ztXurN9D6YrhxNlHDmd9pJQWFVCKwS6C
         VaZQ==
X-Gm-Message-State: APjAAAXoIWMVnixzv7ZQ125JqQfPCvG0jF5Alx+KLalt2s7sKE0SWxhi
        LIk0tspciDH9+OTWLb8INfRHD36UXx5cww==
X-Google-Smtp-Source: APXvYqy5EVkN6pTfpTvaMnYBCyp15qKCfbVVPxPn+3WubSycvOehVYMwuXIm2bwlsbkvDTlxra6cuw==
X-Received: by 2002:a17:902:b20b:: with SMTP id t11mr28026745plr.211.1573500773399;
        Mon, 11 Nov 2019 11:32:53 -0800 (PST)
Received: from localhost ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id x17sm4463414pfa.119.2019.11.11.11.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 11:32:52 -0800 (PST)
Date:   Mon, 11 Nov 2019 21:32:49 +0200
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: linux-bluetooth 2019-11-11
Message-ID: <20191111193249.GA34408@fashcrof-mobl1.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave,

Here's one more bluetooth-next pull request for the 5.5 kernel release.

 - Several fixes for LE advertising
 - Added PM support to hci_qca driver
 - Added support for WCN3991 SoC in hci_qca driver
 - Added DT bindings for BCM43540 module
 - A few other small cleanups/fixes

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 0629d2456ae3bfb374fdc686abb30b73294e4f99:

  Merge branch 'ionic-updates' (2019-10-25 20:52:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 7d250a062f75e6ee8368b64ac6ff1e09fbb6783d:

  Bluetooth: hci_qca: Add support for Qualcomm Bluetooth SoC WCN3991 (2019-11-09 03:26:47 +0100)

----------------------------------------------------------------
Abhishek Pandit-Subedi (2):
      Bluetooth: hci_bcm: Add compatible string for BCM43540
      dt-bindings: net: broadcom-bluetooth: Add BCM43540 compatible string

Balakrishna Godavarthi (2):
      Bluetooth: btqca: Rename ROME specific variables to generic variables
      Bluetooth: hci_qca: Add support for Qualcomm Bluetooth SoC WCN3991

Bartosz Golaszewski (1):
      Bluetooth: btmtksdio: add MODULE_DEVICE_TABLE()

Claire Chang (1):
      Bluetooth: hci_qca: add PM support

Luiz Augusto von Dentz (3):
      Bluetooth: Fix using advertising instance duration as timeout
      Bluetooth: Fix not using LE_ADV_NONCONN_IND for instance 0
      Bluetooth: Fix advertising duplicated flags

Tomas Bortoli (1):
      Bluetooth: Fix invalid-free in bcsp_close()

YueHaibing (1):
      Bluetooth: btrtl: remove unneeded semicolon

 .../devicetree/bindings/net/broadcom-bluetooth.txt |   1 +
 drivers/bluetooth/btmtksdio.c                      |   1 +
 drivers/bluetooth/btqca.c                          |  92 +++++++++----
 drivers/bluetooth/btqca.h                          |  32 +++--
 drivers/bluetooth/btrtl.c                          |   2 +-
 drivers/bluetooth/hci_bcm.c                        |   1 +
 drivers/bluetooth/hci_bcsp.c                       |   3 +
 drivers/bluetooth/hci_qca.c                        | 143 ++++++++++++++++++++-
 net/bluetooth/hci_request.c                        |  19 ++-
 9 files changed, 242 insertions(+), 52 deletions(-)

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEyxvsVXjY3jV7sQ0/JCP2+/mo1BIFAl3Jt14ACgkQJCP2+/mo
1BLO3A/9GmDa28w5jpYzHj5UWboZhtZmoc2v49s03NRf8dtruXY0DeoG1Ha45JVU
uRsApH0QOlzSZC3Pp7xHj4wnj5Uej0K5f2KqxBf9Ux2d0PVm3AU7eUY04ZCXMPty
hfkMDlBwzwqqSHnT6hq3VGBhB/j+6OBTTqR8b41IFTxDL82K2IXrgDgGb2XAFA0k
jehP+AfUUfaKInAc/KOpU3HTpOBZtw8iJTmf7FfpdkcCvP2LNqIrItf+A1HYGL25
+ZnFdIWUKxUEOGM4QGYiEDcu7MxGheyARjiZNNso8K/DQN7XpeU9QwVZ8F5nr8Cu
yRTVFqmAVY8l1B3Ra0mo42UC//kokuWNsva8hUSxIN4CYNlB7jGGFh232D0RSfrB
fnED1JNPb7LUDbIFbOrDk6Nb5sED5l2+1NsNM54p5PeOLdjuyORQKJc7ncawjbnj
3S7t+s0tiYDkCWR40RNaS/kat3/vSLsczu+odk+uEl3X4RAHU0p/HCMDz+ntBMiZ
+54Am1dp3N60v3tSdhLWGnPqvhJEuDHpkhi3L/Jei/4K+lSDXr8UORmVT5cnyedf
TlktSoh6+SO/jJAylQYoMnSGgWjP1SNzRBtmvz7NK9eKLPQ7c8oHKbmMz4Jluu2f
xaRdWjbvFay5oe+RTq9Tq/cNYEwkOIIUFXJBzXey65lj0bol7vo=
=B6rj
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC00ABEA3
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 19:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395182AbfIFRXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 13:23:50 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39402 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729928AbfIFRXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 13:23:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id s12so4936474pfe.6;
        Fri, 06 Sep 2019 10:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=/HzW4Qp75U7WBzQhs2hnRsyzdHsEUO6VvVTbSTDmCv8=;
        b=JTz8xVPHqk6nKKBd/iZCR8tBpARRzKLZKy64vbGcV08/iVXKQIpxjfcyvTFkg/LgWU
         5fqzkVuptOTXPbxeNhIMuZv59lqFbhS66rYIFhvGjBxq9UHRFimxw7xfQ/buLSySTr/t
         iwamPb51jSth2rAAPy30vsubltkDG2v+WH+mZhW26inZBXEan2RCS6PH76GmMSEJH3GM
         wQ2yt6aw5ojcVUqZXIr6XcZ2Avx8DkmiOzcOASYgeAvDny1qY+PqXeVr0ArXayUxhk0v
         CbHXJTGlxbOyalwBJ5HMdKbOl0J0mbyAysJjKPMy0zfPr8XICAqpSAoXiHUsImiV0+mM
         kjKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=/HzW4Qp75U7WBzQhs2hnRsyzdHsEUO6VvVTbSTDmCv8=;
        b=Wz3Tr2Yjzl5FNPE54rbt5PwG4Syr4HHV4d4gtokjIFOTOVXNHM6gHk1L0LTapLceSP
         xgk+rPC25sXXQl0eSiPAGZlIvQoNaKfcGu0liexFHjPCglpvueoCkSX6RXWVSn4X0IQ0
         C17iPVE8w38orCVFSMFVdeUlJXQCZYk36XQY2Wq7GA5ReuP6nmMyPovEf6jW6lKWExva
         WKJ3jBph4BVTXwlBETsrJrHL36eh41lIsrRf6y76ghF5tYvdVTEXsg89SuxuszkCn9Gd
         dIKyMA3ykDg4048GVMS8PlZa6JX0xrOS2Zl0H8Nf4MDSeWR9UWxYYlxfBg1DzPQoWE+N
         bqgw==
X-Gm-Message-State: APjAAAWvBXtuoV08glbgNVpyXD7MRXs7rEGF3gyDtiJN/ixIxOdrrgNy
        4vvE2tQORIczZwEPRpiB3NM4Z8Zji+7wDQ==
X-Google-Smtp-Source: APXvYqx/51Ez1fyokIW49PlSCR6byfpoxr0X9Nt+EpdU300RQvqQWPqIR/zTe7nb/iGywLZ6GkE0QQ==
X-Received: by 2002:aa7:83c7:: with SMTP id j7mr12049687pfn.167.1567790628834;
        Fri, 06 Sep 2019 10:23:48 -0700 (PDT)
Received: from localhost ([134.134.139.77])
        by smtp.gmail.com with ESMTPSA id p14sm5634366pfn.138.2019.09.06.10.23.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 10:23:43 -0700 (PDT)
Date:   Fri, 6 Sep 2019 20:23:39 +0300
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next 2019-09-06
Message-ID: <20190906172339.GA74057@jmoran1-mobl1.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave,

Here's the main bluetooth-next pull request for the 5.4 kernel.

 - Cleanups & fixes to btrtl driver
 - Fixes for Realtek devices in btusb, e.g. for suspend handling
 - Firmware loading support for BCM4345C5
 - hidp_send_message() return value handling fixes
 - Added support for utilizing Fast Advertising Interval
 - Various other minor cleanups & fixes

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 0e5b36bc4c1fccfc18dd851d960781589c16dae8:

  r8152: adjust the settings of ups flags (2019-09-05 12:41:11 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 8bb3537095f107ed55ad51f6241165b397aaafac:

  Bluetooth: hidp: Fix assumptions on the return value of hidp_send_message (2019-09-06 15:55:40 +0200)

----------------------------------------------------------------
Alex Lu (6):
      Bluetooth: btusb: Fix suspend issue for Realtek devices
      Bluetooth: btrtl: Set HCI_QUIRK_SIMULTANEOUS_DISCOVERY
      Bluetooth: btrtl: Add firmware version print
      Bluetooth: btrtl: Remove redundant prefix from calls to rtl_dev macros
      Bluetooth: btrtl: Remove trailing newline from calls to rtl_dev macros
      Bluetooth: btusb: Use cmd_timeout to reset Realtek device

Dan Elkouby (1):
      Bluetooth: hidp: Fix assumptions on the return value of hidp_send_message

Gustavo A. R. Silva (1):
      Bluetooth: mgmt: Use struct_size() helper

Harish Bandi (1):
      Bluetooth: hci_qca: wait for Pre shutdown complete event before sending the Power off pulse

Matthias Kaehlcke (1):
      Bluetooth: hci_qca: Remove redundant initializations to zero

Max Chou (1):
      Bluetooth: btrtl: Fix an issue that failing to download the FW which size is over 32K bytes

Nishka Dasgupta (2):
      Bluetooth: 6lowpan: Make variable header_ops constant
      Bluetooth: hci_qca: Make structure qca_proto constant

Ondrej Jirman (3):
      dt-bindings: net: Add compatible for BCM4345C5 bluetooth device
      bluetooth: bcm: Add support for loading firmware for BCM4345C5
      bluetooth: hci_bcm: Give more time to come out of reset

Rocky Liao (1):
      Bluetooth: hci_qca: Set HCI_QUIRK_SIMULTANEOUS_DISCOVERY for QCA UART Radio

Spoorthi Ravishankar Koppad (1):
      Bluetooth: Add support for utilizing Fast Advertising Interval

YueHaibing (1):
      Bluetooth: hci_bcm: Fix -Wunused-const-variable warnings

 .../devicetree/bindings/net/broadcom-bluetooth.txt |   1 +
 drivers/bluetooth/btbcm.c                          |   3 +
 drivers/bluetooth/btqca.c                          |   5 +-
 drivers/bluetooth/btrtl.c                          | 125 ++++++++++++---------
 drivers/bluetooth/btusb.c                          |  65 ++++++++++-
 drivers/bluetooth/hci_bcm.c                        |  33 +++---
 drivers/bluetooth/hci_qca.c                        |  28 ++---
 drivers/hid/hid-microsoft.c                        |   2 +-
 include/net/bluetooth/hci_core.h                   |   2 +
 net/bluetooth/6lowpan.c                            |   2 +-
 net/bluetooth/hci_request.c                        |  29 +++--
 net/bluetooth/hidp/core.c                          |   4 +-
 net/bluetooth/mgmt.c                               |   8 +-
 13 files changed, 197 insertions(+), 110 deletions(-)

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEyxvsVXjY3jV7sQ0/JCP2+/mo1BIFAl1ylhkACgkQJCP2+/mo
1BI9lRAArukCpVvMPgzy4e5Y+RaZTCxzMJ/nLd16rBCbpSzjiRoJBYb0030ZRlfY
K8jN5jXtJ/r8jznY0jH2yRRTrLAZ+GvEE4eikn29rAolFDGXvPLjG7JSGXnM9xlU
8a7ZkSYVJgI9G5YCVjiHE9y109OyqQuhazwdvH+PFn0xU29nFlRV5jH0FlQsYwj6
0MQ0c1PTyFoh7dxb0QTesbTiIbJxvWlcLz8JWqzPZpvmJib5Rd3pEllySzBX59+l
q+DPTYPZVUO/4QmPDqXqms77IHJINaSWO+C9Q2sc8nyM7NzQB0q5JQl9YUHjhwO6
TmuTZggUHORhUyUEp+eOETP2TcKXZsgzE6rCxVZSLjgckBmKeWMnGB1WrQfxQ6gp
1JiS2QOS+zbSpktSfpFeQK6NL43sC8f/br2AjPlfQfNiSJmsJVFaBoeW+5b30bfh
Qj+X7Z+lH+FICDsWe77HbDP62AuBFReWAlb2WdgJFLswr1d6iPBiCut51AUGC6uV
eOOgLdebw6apSEyXr11OiQ035aX1qN+aC293SmrNp278Vw+OfaefdrQqiNct0Ec/
kNxEKKILSpk34lM9aXqKTrnyayzbLtbzJDCIIOmpXn2/9iVracx4UdN+bWM2t1AS
Fep9VKcMgNw1LwBgix9IUHVkXkM3hVqwFWpr2OSSE1cE8gWKmWI=
=i843
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--

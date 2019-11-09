Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58A6F60FB
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 20:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfKITCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 14:02:21 -0500
Received: from mout.gmx.net ([212.227.15.18]:49563 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbfKITCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 14:02:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573326036;
        bh=K7CKH2sFHfDimmW1dIbo69c8oSLm5ez1U7M3pM6s/+E=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=dW6JW4Ob+mqjTz46lOUHJX1v+0S4LkxRQRVOj2Wbri+Rr3qP0uKYxOze2JwKKYO60
         vuZd1KkCdHq6YZMCDSBgUXz2Ew6cf8NgdkLUpTFVDJMfFsDud+E2AholP4nhkeC3fP
         +dhp4oSYYpcxFSqYDx+HzMfsXRr0+M59le77pp2o=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MvsEn-1hazuV0LEF-00stL6; Sat, 09 Nov 2019 20:00:36 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V3 net-next 0/7] ARM: Enable GENET support for RPi 4
Date:   Sat,  9 Nov 2019 20:00:02 +0100
Message-Id: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:OgFDCO0NwXvuJHy+Vu+h73awi0XbS0g0wqaxOoCfcg6M1laaqr0
 42WMpGs3AOwhMdR1fBhvUbb5TFyk20DV7l/TL5hZ0vYJypBqkuBTym/6BIIYZQedzi6jc7O
 SsdVWY4+RAHJWI9+LCWmt5YdJGHx6weJsESvw1u3d8fX8GqJeve499d7ejAJydocs8zlhUX
 WwWlW3ZTVtX4dtMANBHEw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cib+r+eNvWs=:/uhI6kKPMUNqdQMoO4/yG2
 ZCp5Za+V80fsbbFDY6WK/xAFVYennLWAhHpDw+JO4A/4Bc81M8vX27o6hPTgJYwdb3PUcR7oR
 TGsFXkrAQ8UAJaC+JxrNJQFzqaDtdOlulZ2q0YtTPe2zXzj6Har6goypTugNGaDnLCAJPLplc
 h7jtXElDUVdCBcMK5wzGUmGts/rzLN8ppvE3jDst1bWUIo5FdZDDGeOlZ4lu2t8ZS+0hyS+KV
 iIoPcgzB+l6Q6ltxsCbpPbUG7h33fBLYDXu4sb6GTt5pi4LEU/BuxbiWhPdfjfwUdRbDhCu9n
 4dwZ7lJERqEczy672tPXGxAMQ5eGhPX+ZEyT/yHM9GnuA7HFIHt3k5qnKehBZSKI3iJAIGbor
 ugkMRTasIjB2Thl4QFjYeMBGqEKJ1pYwRUpISrT6fBEKly8VvGl2xQBG8+rPxmfhf38xGG7MA
 0JHJKwdcLNk5fwGikclfVyHHKWd8oCSKQuMwTpwdga0BeSUfUI0cL5HXPkp+D/mR9Su8jru+x
 J1IOLG6XHkezIlO+LzWA1/47qbgffe5cDoC7pkSLZCvIXKCcU4C+mCvFBBOBZrXbyYmzk5GZW
 uQT4VS2sVRhsxaOqT9jtC942aSzuZGnnMYhZcYzHxOD7iCr7euefq/bNun5Xj3CjOcnX3SDDs
 MZkRI7QDuqQTVrMS4dLf8/jFFOILLxr7FMwxP62dqWCej8FkbtkDoo9YthyE5rrQLPY/igbnj
 Xe2G18cdSlAH1eMRoZJgJlqNf/1CVcn23SIL+OrvyD3JFCzC567IPFlYDWhpRry/3vRuZcFmS
 AJ3bOERQImA4WcoBFqWcTq+wM0ZUki1Pl6vLcHt3wc4tCx7weqSt1b6TfPzVw1+LtFg9wKE7E
 M0yLP3R2cEfVWDhVQOSSBNFJiNmBRJaq/yhRNf8wwGpHbHc+CARxwzwWEgWNa5zW6dRyPrsim
 rvaVmcaapIGVTkGQE8Xa5XD7mQi7xZBc3z1dhz8a9YVtBgAZJlb4w0/ylA4YDTGT4nz8tgkhp
 0K0QEcVGdEP1W+8+LzBG6atdFPv26lml75vAPVWYByZ0JSzAgNW0RWFueEVmA6DC6EeYCN5sz
 VcJJ6AsMBx8r5f9sEKo4v8SivF0AruA2NQ9+mK0kUFeLvo9qbRTWv87S7iydq4lO3jxuSzJKw
 w8uCmT1f6lc2Ebsud+CneJJYcFtSuPLJqb2B9EqYrKVzFXij+27mzAA7T1dxB7677PXbO8JNi
 4Baau5LFAXOqKrGLV9eOf23rkjkx0Q/xGHFSh/w==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Raspberry Pi 4 uses the broadcom genet chip in version five.
This chip has a dma controller integrated. Up to now the maximal
burst size was hard-coded to 0x10. But it turns out that Raspberry Pi 4
does only work with the smaller maximal burst size of 0x8.

This series based on Matthias Brugger's V1 series [1].

[1] - https://patchwork.kernel.org/cover/11186193/

Changes in V3:
- introduce SoC-specific compatibles for GENET (incl. dt-binding)
- use platform_get_irq_optional for optional IRQ
- remove Fixes tag from IRQ error handling change
- move most of MDIO stuff to bcm2711.dtsi

Changes in V2:
- add 2 fixes for IRQ retrieval
- add support for missing PHY modes
- declare PHY mode RGMII RXID based on the default settings
- add alias to allow firmware append the MAC address

Stefan Wahren (7):
  net: bcmgenet: Avoid touching non-existent interrupt
  net: bcmgenet: Fix error handling on IRQ retrieval
  dt-bindings: net: bcmgenet: Add BCM2711 support
  net: bcmgenet: Add BCM2711 support
  net: bcmgenet: Refactor register access in bcmgenet_mii_config
  net: bcmgenet: Add RGMII_RXID and RGMII_ID support
  ARM: dts: bcm2711-rpi-4: Enable GENET support

 .../devicetree/bindings/net/brcm,bcmgenet.txt      |  2 +-
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts              | 17 +++++
 arch/arm/boot/dts/bcm2711.dtsi                     | 26 ++++++++
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 74 +++++++++++++++++=
+----
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       | 51 ++++++++-------
 6 files changed, 133 insertions(+), 38 deletions(-)

=2D-
2.7.4


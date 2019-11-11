Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE03F6ECC
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 07:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKKG5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 01:57:45 -0500
Received: from mout.gmx.net ([212.227.15.15]:40351 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbfKKG5p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 01:57:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573455360;
        bh=0jxMWIGkU7ewd+S5xOOJEHPXWN5shKLBSrDpJeIk3Ok=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=G/bDu3kid608MB+4VMhpaVTuFo+QDdN1yTRgHtfgu0g9NCmk7wnDRJrPqtPm/tMk4
         iAA2eh9qGgU1nKm2Um6TPYMbkjI7ifu0khAEchLvSWNdQ464UxIEQSIXm4cfWccPsc
         bzM4+7AI9nJ2a/+eYt2tH/iY7+/uSQGM2Fa51ewY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1Mwfai-1hgF1W33SU-00y5K5; Mon, 11 Nov 2019 07:56:00 +0100
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
Subject: [PATCH V4 net-next 0/7] ARM: Enable GENET support for RPi 4
Date:   Mon, 11 Nov 2019 07:55:34 +0100
Message-Id: <1573455341-22813-1-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:znXwmQUr89xRFl3D685WuGsnPrIB78BhmrZCKjB1EDElWQ6BhYV
 MKRpXC5HoIaGo9FQBMcjkLPzNxbM0hzKlIYZYmnU9WHhzSp8KRNJIEO1Csaws0k1xo9ho3p
 tJ3FjIn6op0kWCoMIVFqLd+H87Nt0/zKsRmvTu0yjE1OLMLSC3JaWaOd9ybulG8lBDtmiiL
 6OcI2dYFtn2J+uJxK+7aw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1OM2d/R61Lc=:gLr/jMRGG1jJpIJpHIGUCl
 eT38XH3MsLhTitOBBf2SBlcnYUSRQ1YkK33soot2vtOsCR9d/sS+NN8ME1pgGGMehudYrXjO7
 rl0mtnCfWrPVFFQp44SjsFE66hsWmSXXrbp1JO2lE8KKJvdTTGyGzaohBZqBphz7zbLPYS6LL
 PcrVK7Oqcpr5SWxMmPRcJzxy8TzBnoS/b/0UkI4fge6cMLXAGy28Y9Yr/1UkUf8Hyv0NDVbWC
 rE0+0FX3Rteju2yIfBOf754ac9YMNjjl+wJT1HM7Syizinb17NafKy7OKgPz8kStvfBACjSej
 aE4hTRZaUsPKnAKBG+W0mZ36nrwzIOSXPwtUH0imKZP859UAKAzusZlsydu4hEVpjqJkb01Te
 qbU62K9B9t9BUhtIlNKatjGC6V8A3/tppWgkffG7kqn0zFKeb6ZSriUdxG3/ZZbeRZ3y/zUTe
 h67lT2tZ2iyfamgskA5IhJ5RhKT4f2YZ8Ar7ICu1pqvAW8i3ZmSgmp1sYFCXJfew9NdZ+rN6Y
 jVZjGXKwi9wVVt37QRMc6pF6zUW0NxR2dcVlZQfQEFiEfmdnO+50bRUDPzopHT1OxS/DYxeG0
 jJezbcgFFjTPB3fLuq1GMlVNxuMQg+W54smbKZgBQS9lcMVvuu7H+67+Xk+thc1rtqhG63dgx
 tYgvi4UCKxbZ+Cqqo1JONqpsMZiTRFrcdXp+ICr+G2x5eohB2BGGqF4kZ+GMlcCVoKylZsTqs
 ewCPof7RL5IePis0C8eis3DgFg8Dug736CC3L2IqFUmYSxWl2pYufz6sZbRguspq7lqM3YLFm
 IW4tIO28f69m4igNos3TZYJWaj+liRfxmm8Ponlv/xicQoJpLrekw/8qJ44cdyj6qZVfCRg2Z
 97Z1+R4H5DVxhogBZWoOWU5nprsee+rBH2t/Ft5bW8XmqVjHcY9UGllV70aFrKXRALfqv9a27
 RFoP9Pi0kNFhRn7Jq9FLryWyBoAurTY/nHq7gNxdZF+CU7qC90O8EsZxjb7brGlVNx5sYHyVi
 5bM3HwAtcFsSUsr4MY5BM0aiSz1DIYPrtP8fGHWkOT+MeKNfRxKcXvbl4IE1mAxK0aBTrAyur
 A31PuN9rmik/jSBJQzeCnNHfEr0UOvRENW7bkRflsCUn5hOzEVoqdvAmxGTiNiMidsj4G0TXS
 mmzWTnwF98JkeeZ9sceK3HoXo9NkaGznrCZFmZWD5XCRxo5fvhIk+nngkkOOzM4EGb3BQt6aL
 Bb5J8eQRAwvr1ffG6VxuI5lBb+9ixOUcpZS4xfg==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Raspberry Pi 4 uses the broadcom genet chip in version five.
This chip has a dma controller integrated. Up to now the maximal
burst size was hard-coded to 0x10. But it turns out that Raspberry Pi 4
does only work with the smaller maximal burst size of 0x8.

Additionally the patch series has some IRQ retrieval improvements and
adds support for a missing PHY mode.

This series based on Matthias Brugger's V1 series [1].

[1] - https://patchwork.kernel.org/cover/11186193/

Changes in V4:
- rebased on current net-next
- remove RGMII_ID support
- remove fixes tag from patch 1
- add Florian's suggestions to patch 5

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
  net: bcmgenet: Add RGMII_RXID support
  ARM: dts: bcm2711-rpi-4: Enable GENET support

 .../devicetree/bindings/net/brcm,bcmgenet.txt      |  2 +-
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts              | 17 +++++
 arch/arm/boot/dts/bcm2711.dtsi                     | 26 ++++++++
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 74 +++++++++++++++++=
+----
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       | 40 ++++++------
 6 files changed, 126 insertions(+), 34 deletions(-)

=2D-
2.7.4


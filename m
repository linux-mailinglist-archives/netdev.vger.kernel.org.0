Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB574ECEDC
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 14:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfKBNmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 09:42:25 -0400
Received: from mout.gmx.net ([212.227.17.21]:55979 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfKBNmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 09:42:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1572702113;
        bh=EJB0kQR1amjzWWdjl620iXf6Op+BL0oXNO+UIOhHuNE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=GYl0LugaMUQzknrNe0E89cJqjXSxeOWDxjATK8ha+49YYIlQAs9aSFHbSP5X8742w
         1LcH3blvlGhpCkRjP/7Hq/lRQp6m8vQ/Y56BjI//wIxSOOTNDkfajBjSKmaLFgjKyz
         6P5yBTbSOhMa86AxxTcvgWMvAFewBVOD/200rXUI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MGQj7-1iAB4e1POH-00GnPF; Sat, 02 Nov 2019 14:41:53 +0100
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
Subject: [PATCH RFC V2 0/6] ARM: Enable GENET support for RPi 4
Date:   Sat,  2 Nov 2019 14:41:27 +0100
Message-Id: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:eBFA/8UNxUBIxZRVAsUvYfXyOHy4QWtqysb2gI95RA11pGfwiUy
 QcxiTwav6B8Nh4m356ySTBed+5sOEdfsAtke8X36KZ9aZ/Rb1l/nYR2u5tb+eBeWWf9tMFl
 /qwiMSlwEs7hld8Gq4EyXU6MDYToS35JXjTXKKJ3vGRmkZc7H0bLtjIC9JFb+cZh1vueFEh
 c2/tcyHqFbUonB8lr1hgw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dkLlQCFhYBw=:+cG6eiq2T9cnM5gjU+PCmr
 D/7VSRb9ZW7RHMQ3eVegQczn2HNNkRufa87J9fn5BcQT6hltnYmchhu6SMhUQFPzTMMPmT1oZ
 SkBALaxdi0ql7nBKpCF9eC8Wa6coOUFANjHJDfUHh23pmWoeUGoEtQCQIlewzvJj8M51c4Gj0
 DhVi/sz1tVk7cLLoGxJVxIfx0RX582yXzKDp7K3msACNblhhLbTHFd3lQ8nY7ivg3v2a2aXyI
 uU4ZS+zO87WBzKcI5nxhPWygHmL/Vmd3uJirIc8Q2YZIhsi5MLmtHX/htEPitw3zA41GsvMXB
 qY5h0nmgzpRx0I826KTtkpCfbSSw8ajpjrwLxcL1GoB7rxmfCdzIy06YbiEFcgo2CfLiUS67J
 HXb09p6jfB1ow48wS/q6dbK/A4Ww0l4o+6gGRa3RJrwT/nSZiEAEvG2pdDh49aaFLK8ekm0nc
 PCXc4DlATOMvFTbEZywL2AqPWbNTZj5Q3mCZZsVPSRexQ8EPzbOnVAFUJA+7Qa4H7wVuj7ynp
 xrzzMD951kaHAOH2NTSVApStSIA7Xb1LjR3ltUDL0KI+v8bfkUpRhIwli9R7telafyllkzyTe
 p/wGvLb/mf8SZmm89YK3DAa+3iLXdzLuL4NyswW/eE1wNb5daMF4y7vG6/1L8MvJ8FOos7Iri
 p2vzEG2eqHt0Bvet9m1TkH7IeikPKD5wtuT+dvSyHHoW24iu3vvjQZTiQKg1ZKO9YfnFDqLqa
 mV+BFAvW3D3aA78sjh2aas6q7lnHkEvRQMlSIv9BWM7KMDFBfdCB0pdaBeukYkGR3JddFIIpB
 HPOWvVSCVuHQishm0gtMNOGPkoEeK4bAfFMn1SKZ3E96YF70DyYbLYoQffG0HbZmrdof5UYFy
 RDxiEo/YQGP3wwSmitUHV1Vhw+JSxdxvzNwntR2QntiYMbGOUiph3Fo74IdvTHiV8h4y0FDps
 R5lglW804GiZA0hNa/TVNalSSrMiXwKQD0OVazRSTX3fyhf3UGPtWv9WjHI5YMj8o4kGdcB+y
 T1hSmCC9n92p/qv4/EUv8D9gJKp3T0DgFbSxruNP7eAjtYE+69hzoA8xbJhg2okap7iXzuh+G
 qf2n22SXXyPfpGAUSIH6NuVTbLfgwXOZsXilNrOWxoSKlSDdKAmls6cHWDql4/3KAfIUby6rc
 yYSw3GSUCb1nCUdxItK+GTz0WbWYqSJPMl9BWfB/JlO2ByRmn4jaU7jWDjTT32idmEXjZ4/vg
 I25tILmJ2MfC09pkCUgEF1WXe4AZbtrOZSwIxuA==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Raspberry Pi 4 uses the broadcom genet chip in version five.
This chip has a dma controller integrated. Up to now the maximal
burst size was hard-coded to 0x10. But it turns out that Raspberry Pi 4
does only work with the smaller maximal burst size of 0x8.

This series based on Matthias Brugger's V1 series [1], should help
to put all missing pieces together and hand my changes over to him.
So i doesn't address all comments from Florian and the series isn't
ready to be merged.

[1] - https://patchwork.kernel.org/cover/11186193/

Changes in V2:
- add 2 fixes for IRQ retrieval
- add support for missing PHY modes
- declare PHY mode RGMII RXID based on the default settings
- add alias to allow firmware append the MAC address

Matthias Brugger (1):
  net: bcmgenet: use optional max DMA burst size property

Stefan Wahren (5):
  net: bcmgenet: Fix error handling on IRQ retrieval
  net: bcmgenet: Avoid touching non-existent interrupt
  net: bcmgenet: Refactor register access in bcmgenet_mii_config
  net: bcmgenet: Add RGMII_RXID and RGMII_ID support
  ARM: dts: bcm2711-rpi-4: Enable GENET support

 arch/arm/boot/dts/bcm2711-rpi-4-b.dts          | 23 ++++++++++++
 arch/arm/boot/dts/bcm2711.dtsi                 | 19 ++++++++++
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 25 ++++++++++---
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |  1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c   | 51 ++++++++++++++-------=
-----
 5 files changed, 90 insertions(+), 29 deletions(-)

=2D-
2.7.4


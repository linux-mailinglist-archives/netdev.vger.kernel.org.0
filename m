Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B375F8090
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfKKTvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 14:51:50 -0500
Received: from mout.gmx.net ([212.227.15.18]:49399 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbfKKTvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 14:51:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573501790;
        bh=xi27iTDjcDpnSMVKDfT12Ab/Na1O4J3NDmJZO0y75tU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=kY3FqCT7Gl0cbyXCF81zKfL++TQWx6NhtCRrEtvb0KAAqRydkfgoy8ckrn5z0izza
         yQbK+9M243Lku6pp40OPjWrQqSDgToSg2PWMBAJBvcq8vLMktyZI1PTEoyekRgHmLt
         fzPAZ+YViqlT3lTDSHshHj1M3UfyY2eGuEsSiu9c=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1N9MpS-1hrdfu19O8-015ING; Mon, 11 Nov 2019 20:49:50 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V5 net-next 0/7] ARM: Enable GENET support for RPi 4
Date:   Mon, 11 Nov 2019 20:49:19 +0100
Message-Id: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:sjjegBo9YJ4+FLoHPimLpHajqn+WYg1I1Rp8rwOjLXsa7L/nY7q
 oTpQIHadPsrmBmEnpRdl1CUiPy85n2bqRaBFQFGo1wc93JCv5PbLe6OJ0Rd/nf7HR0/nRiV
 BqB1PmNXYZ7zKSaz15G5R86QIlR2bNB+5uJ+uZpQ8TE+m9RkKbWDG/k9xDl3SVeVcYwQwL2
 AiE9AhJIUZpNSgaDeEf5A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5rnjUq1GL6Q=:h2srEYoWauvk3KmY7i1/z5
 D16sVhzBFyhW6kZvltK/ah5N6QJGmqoQ5IcPqRfIIrJY6tJWNes75FYgyUqJ19Vyj6SIm/aNq
 MBcEVKxPiGsIJoCoXCde60zAspD++Qctu/Tv+nP9cXSjAVu34PCUH08B8bpTp92denTakOMqU
 jIo4OEkTH86xrR04RvRabLNLclmN2rm+ATRMRe/feNdrGgehFET7jkcryliTkuRXKmtkad4Cf
 xkQAQ/mhSApq2rAWoJO6Gvt4cqQrBv/qvuNDc0+h85kywi29RqDQLe1/e1A7T148BbPagDok0
 xhX9NlqrU2Gk2YA4wv8A68xvhOFEJBmgJrqi5WeoHKs6JNphC3st1yWBYAs8y4aYzEypgABhm
 9yvYdsqbu38BOts0vwDVX93H4bCgdtXLoYMTSrzVO4lEG1oRwJeKN8esGEDwONSkRgq6weikJ
 Y4V+b+WGSRrB4DJboswb2mvJ3l86pg/5+dSfz/SR5eqOx1juruKXvhCqYXR0nhtUlGPe4vvSt
 gcNHQawN2O+LS8N4i/Vef+E9zyf8gX2XRioxmQdlVkBXKCd9aJzqAuhPSEnSxYSG2wfFrrge/
 BcPjLtuOLE8RgxK7uq+Rr/Lunc7XBW9cx6S62VlEHARWW1/vnrBju5Hx9RzSCxPMyzr25YwTA
 gG1z+cVjpLr54/4aGMD3DCV878cnHjQwuXX30Gl/6zOWWfHX+gnraIcg+emaUmyHq9xUkQbpl
 knHMTJ7feFMRsx2iN99S1q+lkkXx8O7nOvlya79ME0PdjBiS+LFs4O6qHMhQ0u3xmEMNbjNMK
 JOUVJ26xqf3t80kX77SRa2aohmtzj7N0UwA/MGw7iWPV73u/8dkRQFiHpoOw8La/Q7fkMxEAj
 whJ43wwDoKFxAmCruu73mFM3bDDgFsGawpnsYTqDU4viuxhHa9n6JehtupsVS0gM0HDx98sWY
 qE+Um9GWD8R2Cae/izH8s6PNYPM/yw2gj7SaIVF+Vm2mI7j4OHuH7m7y9di6DfeULH8+Jdn/Z
 tOe4UUIu3ve6zKL+cv6oD1mljxyz3PBn2dCel0F6TRUSeHt3ekCEOWa+UFZduWgpV4zXqhcxS
 vxJ0c3yd9/wo5IrtdsSYV+2Cum3t1uf08kOQaQvS1TN9fFryVr7HMbf6clKVy6Xx9jvRgkEAT
 gjPJstZJ6WOU3MahlQ91hU4iGLIFKsb0XzHHo5ijJbA8PGYDuOS2pu7x2f8aoqsGUjXHsm+qP
 22FT4TYAzDyVMEfDh5tX90dvpFC3cTm9UTFVHww==
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

Changes in V5:
- address Doug's comment

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
 drivers/net/ethernet/broadcom/genet/bcmmii.c       | 47 +++++++-------
 6 files changed, 130 insertions(+), 37 deletions(-)

=2D-
2.7.4


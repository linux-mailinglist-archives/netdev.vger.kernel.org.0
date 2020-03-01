Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC1D174DBB
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgCAOpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgCAOpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:01 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 674A120880;
        Sun,  1 Mar 2020 14:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073901;
        bh=kt741SrzGymR/U+kiWUmgrZjC78gpmkY1yf0gURzkCE=;
        h=From:To:Cc:Subject:Date:From;
        b=dOzzEBsJPve5MnjWSoDv41KxBMEx4EU9TJ/uQBkv5y0Kx0SbhxJJpfh/K4elLU0W6
         DhoOKm0/eT5xUOpGtESCGzcNMHdIIb1VKe4TSdTMRWyb/xXSDlckPzugyZ4Wo1Z03+
         Eq4V462zCZhyJn8cu0wifNqJ7GfungYAXs/gS/SU=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Ariel Elior <aelior@marvell.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Casey Leedom <leedom@chelsio.com>,
        Christian Benvenuti <benve@cisco.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Derek Chickles <dchickles@marvell.com>,
        Doug Berger <opendmb@gmail.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Li Yang <leoyang.li@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Raghu Vatsavayi <rvatsavayi@caviumnetworks.com>,
        Rasesh Mody <rmody@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 00/23] Clean driver, module and FW versions
Date:   Sun,  1 Mar 2020 16:44:33 +0200
Message-Id: <20200301144457.119795-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This is second batch of the series which removes various static versions
in favour of globaly defined Linux kernel version.

The first part with better cover letter can be found here
https://lore.kernel.org/lkml/20200224085311.460338-1-leon@kernel.org

The code is based on
68e2c37690b0 ("Merge branch 'hsr-several-code-cleanup-for-hsr-module'")

and WIP branch is
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=ethtool

Thanks

Leon Romanovsky (23):
  net/broadcom: Clean broadcom code from driver versions
  net/broadcom: Don't set N/A FW if it is not available
  net/brocade: Delete driver version
  net/liquidio: Delete driver version assignment
  net/liquidio: Delete non-working LIQUIDIO_PACKAGE check
  net/cavium: Clean driver versions
  net/cavium: Delete N/A assignments for ethtool
  net/chelsio: Delete drive and  module versions
  net/chelsio: Don't set N/A for not available FW
  net/cirrus: Delete driver version
  net/cisco: Delete driver and module versions
  net/cortina: Delete driver version from ethtool output
  net/davicom: Delete ethtool version assignment
  net/dec: Delete driver versions
  net/dlink: Remove driver version and release date
  net/dnet: Delete static version from the driver
  net/emulex: Delete driver version
  net/faraday: Delete driver version from the drivers
  net/fealnx: Delete driver version
  net/freescale: Clean drivers from static versions
  net/freescale: Don't set zero if FW not-available in dpaa
  net/freescale: Don't set zero if FW not-available in ucc_geth
  net/freescale: Don't set zero if FW iand bus not-available in gianfar

 drivers/net/ethernet/broadcom/b44.c           |  5 ----
 drivers/net/ethernet/broadcom/bcm63xx_enet.c  | 10 ++-----
 drivers/net/ethernet/broadcom/bcmsysport.c    |  1 -
 drivers/net/ethernet/broadcom/bnx2.c          | 11 --------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  8 +++++-
 .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |  7 -----
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  7 -----
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  8 ------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  4 ++-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  1 -
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  1 -
 drivers/net/ethernet/broadcom/tg3.c           | 11 +-------
 drivers/net/ethernet/brocade/bna/bnad.c       |  4 ---
 drivers/net/ethernet/brocade/bna/bnad.h       |  2 --
 .../net/ethernet/brocade/bna/bnad_ethtool.c   |  1 -
 .../ethernet/cavium/liquidio/lio_ethtool.c    |  2 --
 .../net/ethernet/cavium/liquidio/lio_main.c   |  8 ------
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  5 ++--
 .../cavium/liquidio/liquidio_common.h         |  6 -----
 .../ethernet/cavium/liquidio/octeon_console.c | 10 ++-----
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |  6 -----
 .../ethernet/cavium/thunder/nicvf_ethtool.c   |  2 --
 drivers/net/ethernet/chelsio/cxgb/common.h    |  1 -
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  3 ---
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  4 ---
 drivers/net/ethernet/chelsio/cxgb3/version.h  |  2 --
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  3 +--
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  6 +----
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 10 -------
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  9 -------
 .../ethernet/chelsio/libcxgb/libcxgb_ppm.c    |  2 --
 drivers/net/ethernet/cirrus/ep93xx_eth.c      |  2 --
 drivers/net/ethernet/cisco/enic/enic.h        |  2 --
 .../net/ethernet/cisco/enic/enic_ethtool.c    |  1 -
 drivers/net/ethernet/cisco/enic/enic_main.c   |  3 ---
 drivers/net/ethernet/cortina/gemini.c         |  2 --
 drivers/net/ethernet/davicom/dm9000.c         |  2 --
 drivers/net/ethernet/dec/tulip/de2104x.c      | 15 -----------
 drivers/net/ethernet/dec/tulip/dmfe.c         | 14 ----------
 drivers/net/ethernet/dec/tulip/tulip_core.c   | 26 ++-----------------
 drivers/net/ethernet/dec/tulip/uli526x.c      | 13 ----------
 drivers/net/ethernet/dec/tulip/winbond-840.c  | 12 ---------
 drivers/net/ethernet/dlink/dl2k.c             |  9 -------
 drivers/net/ethernet/dlink/sundance.c         | 20 --------------
 drivers/net/ethernet/dnet.c                   |  1 -
 drivers/net/ethernet/dnet.h                   |  1 -
 drivers/net/ethernet/emulex/benet/be.h        |  1 -
 .../net/ethernet/emulex/benet/be_ethtool.c    |  1 -
 drivers/net/ethernet/emulex/benet/be_main.c   |  5 +---
 drivers/net/ethernet/faraday/ftgmac100.c      |  2 --
 drivers/net/ethernet/faraday/ftmac100.c       |  3 ---
 drivers/net/ethernet/fealnx.c                 | 20 --------------
 .../ethernet/freescale/dpaa/dpaa_ethtool.c    | 11 --------
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 13 ----------
 .../net/ethernet/freescale/enetc/enetc_vf.c   | 12 ---------
 drivers/net/ethernet/freescale/fec_main.c     |  1 -
 .../ethernet/freescale/fs_enet/fs_enet-main.c |  2 --
 .../net/ethernet/freescale/fs_enet/fs_enet.h  |  2 --
 drivers/net/ethernet/freescale/gianfar.c      |  2 --
 drivers/net/ethernet/freescale/gianfar.h      |  1 -
 .../net/ethernet/freescale/gianfar_ethtool.c  |  4 ---
 drivers/net/ethernet/freescale/ucc_geth.c     |  1 -
 drivers/net/ethernet/freescale/ucc_geth.h     |  1 -
 .../net/ethernet/freescale/ucc_geth_ethtool.c |  2 --
 65 files changed, 22 insertions(+), 346 deletions(-)

--
2.24.1


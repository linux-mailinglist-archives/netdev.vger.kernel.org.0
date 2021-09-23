Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136F44164DF
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 20:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242721AbhIWSOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 14:14:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242696AbhIWSOc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 14:14:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3820360F43;
        Thu, 23 Sep 2021 18:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632420778;
        bh=mXvrfKC+e6Fp2msO1e9dvOO8RC/ii9We36xFgFUas8g=;
        h=From:To:Cc:Subject:Date:From;
        b=QqLZnuaHT8QqfyojGiczmUWMS8siMAdkDvolM75Q84+AiRhzknbPi0WqWHzhE5p33
         xJdzMF2B52hs/UCKQtZikWC/1/BbqRTc3EQzYJaJMJJLZ5s9Zv4FpRw1eFkajMMV4f
         t5sRXEGpTVHlZBxkIetdwTAE1b0fJihXnA5wUMUr02maJeFpYrE3IprsIPH+joGpL/
         pci6nd0BgQZd3FXo2vRMQevQK5B/munYkvA9GajE4nIKkNWPiBRAlIcRHSz0SLnshP
         FErUmwhcStUMdFLBaId569v8Gt5vMQfOzlCB+qcUGQu03mMyIz3U9Ryex66gLKfCG7
         /kzgI9+ckOGdg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>,
        intel-wired-lan@lists.osuosl.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Javed Hasan <jhasan@marvell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev@vger.kernel.org, Sathya Perla <sathya.perla@broadcom.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 0/6] Batch of devlink related fixes
Date:   Thu, 23 Sep 2021 21:12:47 +0300
Message-Id: <cover.1632420430.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

I'm asking to apply this batch of devlink fixes to net-next and not to
net, because most if not all fixes are for old code or/and can be considered
as cleanup.

It will cancel the need to deal with merge conflicts for my next devlink series :).

Thanks

Leon Romanovsky (6):
  bnxt_en: Check devlink allocation and registration status
  bnxt_en: Properly remove port parameter support
  devlink: Delete not used port parameters APIs
  devlink: Remove single line function obfuscations
  ice: Delete always true check of PF pointer
  qed: Don't ignore devlink allocation failures

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   5 +-
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  26 +---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.h |  13 --
 drivers/net/ethernet/intel/ice/ice_main.c     |   3 -
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  12 +-
 drivers/scsi/qedf/qedf_main.c                 |   2 +
 include/net/devlink.h                         |   6 -
 net/core/devlink.c                            | 123 +++++-------------
 8 files changed, 47 insertions(+), 143 deletions(-)

-- 
2.31.1


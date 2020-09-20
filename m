Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00019271437
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 14:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgITMQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 08:16:23 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:33987 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726273AbgITMQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 08:16:23 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Sep 2020 08:16:20 EDT
X-IronPort-AV: E=Sophos;i="5.77,282,1596492000"; 
   d="scan'208";a="468612186"
Received: from palace.lip6.fr ([132.227.105.202])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/AES256-SHA256; 20 Sep 2020 14:08:58 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     linux-spi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-rdma@vger.kernel.org, Yossi Leybovich <sleybo@amazon.com>,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 00/14] drop double zeroing
Date:   Sun, 20 Sep 2020 13:26:12 +0200
Message-Id: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sg_init_table zeroes its first argument, so the allocation of that argument
doesn't have to.

---

 block/bsg-lib.c                                  |    2 +-
 drivers/dma/sh/rcar-dmac.c                       |    2 +-
 drivers/dma/sh/shdma-base.c                      |    2 +-
 drivers/infiniband/hw/efa/efa_verbs.c            |    2 +-
 drivers/media/common/saa7146/saa7146_core.c      |    2 +-
 drivers/misc/mic/scif/scif_nodeqp.c              |    2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c      |    2 +-
 drivers/pci/p2pdma.c                             |    2 +-
 drivers/spi/spi-topcliff-pch.c                   |    4 ++--
 drivers/target/target_core_rd.c                  |    2 +-
 drivers/tty/serial/pch_uart.c                    |    2 +-
 net/rds/rdma.c                                   |    2 +-
 net/sunrpc/xprtrdma/frwr_ops.c                   |    2 +-
 14 files changed, 15 insertions(+), 15 deletions(-)

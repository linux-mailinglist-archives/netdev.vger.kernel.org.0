Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574D7512982
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 04:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241422AbiD1Cef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 22:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241406AbiD1Cee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 22:34:34 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD22086AF2
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 19:31:20 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id E306832010B;
        Thu, 28 Apr 2022 03:31:19 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1njtw7-0005WO-N5; Thu, 28 Apr 2022 03:31:19 +0100
Subject: [PATCH net-next v2 04/13] sfc: Copy shared files needed for Siena
 (part 2)
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Thu, 28 Apr 2022 03:31:19 +0100
Message-ID: <165111307940.21042.17476159328933671191.stgit@palantir17.mph.net>
In-Reply-To: <165111298464.21042.9988060027860048966.stgit@palantir17.mph.net>
References: <165111298464.21042.9988060027860048966.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Habets <martinh@xilinx.com>

These are the files starting with m through w.
No changes are done, those will be done with subsequent commits.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/mcdi.c             |    0 
 drivers/net/ethernet/sfc/siena/mcdi.h             |    0 
 drivers/net/ethernet/sfc/siena/mcdi_mon.c         |    0 
 drivers/net/ethernet/sfc/siena/mcdi_port.c        |    0 
 drivers/net/ethernet/sfc/siena/mcdi_port.h        |    0 
 drivers/net/ethernet/sfc/siena/mcdi_port_common.c |    0 
 drivers/net/ethernet/sfc/siena/mcdi_port_common.h |    0 
 drivers/net/ethernet/sfc/siena/mtd.c              |    0 
 drivers/net/ethernet/sfc/siena/net_driver.h       |    0 
 drivers/net/ethernet/sfc/siena/nic.c              |    0 
 drivers/net/ethernet/sfc/siena/nic.h              |    0 
 drivers/net/ethernet/sfc/siena/nic_common.h       |    0 
 drivers/net/ethernet/sfc/siena/ptp.c              |    0 
 drivers/net/ethernet/sfc/siena/ptp.h              |    0 
 drivers/net/ethernet/sfc/siena/rx.c               |    0 
 drivers/net/ethernet/sfc/siena/rx_common.c        |    0 
 drivers/net/ethernet/sfc/siena/rx_common.h        |    0 
 drivers/net/ethernet/sfc/siena/selftest.c         |    0 
 drivers/net/ethernet/sfc/siena/selftest.h         |    0 
 drivers/net/ethernet/sfc/siena/sriov.c            |    0 
 drivers/net/ethernet/sfc/siena/sriov.h            |    0 
 drivers/net/ethernet/sfc/siena/tx.c               |    0 
 drivers/net/ethernet/sfc/siena/tx.h               |    0 
 drivers/net/ethernet/sfc/siena/tx_common.c        |    0 
 drivers/net/ethernet/sfc/siena/tx_common.h        |    0 
 drivers/net/ethernet/sfc/siena/vfdi.h             |    0 
 drivers/net/ethernet/sfc/siena/workarounds.h      |    0 
 27 files changed, 0 insertions(+), 0 deletions(-)
 copy drivers/net/ethernet/sfc/{mcdi.c => siena/mcdi.c} (100%)
 copy drivers/net/ethernet/sfc/{mcdi.h => siena/mcdi.h} (100%)
 copy drivers/net/ethernet/sfc/{mcdi_mon.c => siena/mcdi_mon.c} (100%)
 copy drivers/net/ethernet/sfc/{mcdi_port.c => siena/mcdi_port.c} (100%)
 copy drivers/net/ethernet/sfc/{mcdi_port.h => siena/mcdi_port.h} (100%)
 copy drivers/net/ethernet/sfc/{mcdi_port_common.c => siena/mcdi_port_common.c} (100%)
 copy drivers/net/ethernet/sfc/{mcdi_port_common.h => siena/mcdi_port_common.h} (100%)
 copy drivers/net/ethernet/sfc/{mtd.c => siena/mtd.c} (100%)
 copy drivers/net/ethernet/sfc/{net_driver.h => siena/net_driver.h} (100%)
 copy drivers/net/ethernet/sfc/{nic.c => siena/nic.c} (100%)
 copy drivers/net/ethernet/sfc/{nic.h => siena/nic.h} (100%)
 copy drivers/net/ethernet/sfc/{nic_common.h => siena/nic_common.h} (100%)
 copy drivers/net/ethernet/sfc/{ptp.c => siena/ptp.c} (100%)
 copy drivers/net/ethernet/sfc/{ptp.h => siena/ptp.h} (100%)
 copy drivers/net/ethernet/sfc/{rx.c => siena/rx.c} (100%)
 copy drivers/net/ethernet/sfc/{rx_common.c => siena/rx_common.c} (100%)
 copy drivers/net/ethernet/sfc/{rx_common.h => siena/rx_common.h} (100%)
 copy drivers/net/ethernet/sfc/{selftest.c => siena/selftest.c} (100%)
 copy drivers/net/ethernet/sfc/{selftest.h => siena/selftest.h} (100%)
 copy drivers/net/ethernet/sfc/{sriov.c => siena/sriov.c} (100%)
 copy drivers/net/ethernet/sfc/{sriov.h => siena/sriov.h} (100%)
 copy drivers/net/ethernet/sfc/{tx.c => siena/tx.c} (100%)
 copy drivers/net/ethernet/sfc/{tx.h => siena/tx.h} (100%)
 copy drivers/net/ethernet/sfc/{tx_common.c => siena/tx_common.c} (100%)
 copy drivers/net/ethernet/sfc/{tx_common.h => siena/tx_common.h} (100%)
 copy drivers/net/ethernet/sfc/{vfdi.h => siena/vfdi.h} (100%)
 copy drivers/net/ethernet/sfc/{workarounds.h => siena/workarounds.h} (100%)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
similarity index 100%
copy from drivers/net/ethernet/sfc/mcdi.c
copy to drivers/net/ethernet/sfc/siena/mcdi.c
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/siena/mcdi.h
similarity index 100%
copy from drivers/net/ethernet/sfc/mcdi.h
copy to drivers/net/ethernet/sfc/siena/mcdi.h
diff --git a/drivers/net/ethernet/sfc/mcdi_mon.c b/drivers/net/ethernet/sfc/siena/mcdi_mon.c
similarity index 100%
copy from drivers/net/ethernet/sfc/mcdi_mon.c
copy to drivers/net/ethernet/sfc/siena/mcdi_mon.c
diff --git a/drivers/net/ethernet/sfc/mcdi_port.c b/drivers/net/ethernet/sfc/siena/mcdi_port.c
similarity index 100%
copy from drivers/net/ethernet/sfc/mcdi_port.c
copy to drivers/net/ethernet/sfc/siena/mcdi_port.c
diff --git a/drivers/net/ethernet/sfc/mcdi_port.h b/drivers/net/ethernet/sfc/siena/mcdi_port.h
similarity index 100%
copy from drivers/net/ethernet/sfc/mcdi_port.h
copy to drivers/net/ethernet/sfc/siena/mcdi_port.h
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
similarity index 100%
copy from drivers/net/ethernet/sfc/mcdi_port_common.c
copy to drivers/net/ethernet/sfc/siena/mcdi_port_common.c
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.h b/drivers/net/ethernet/sfc/siena/mcdi_port_common.h
similarity index 100%
copy from drivers/net/ethernet/sfc/mcdi_port_common.h
copy to drivers/net/ethernet/sfc/siena/mcdi_port_common.h
diff --git a/drivers/net/ethernet/sfc/mtd.c b/drivers/net/ethernet/sfc/siena/mtd.c
similarity index 100%
copy from drivers/net/ethernet/sfc/mtd.c
copy to drivers/net/ethernet/sfc/siena/mtd.c
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
similarity index 100%
copy from drivers/net/ethernet/sfc/net_driver.h
copy to drivers/net/ethernet/sfc/siena/net_driver.h
diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/siena/nic.c
similarity index 100%
copy from drivers/net/ethernet/sfc/nic.c
copy to drivers/net/ethernet/sfc/siena/nic.c
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/siena/nic.h
similarity index 100%
copy from drivers/net/ethernet/sfc/nic.h
copy to drivers/net/ethernet/sfc/siena/nic.h
diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/siena/nic_common.h
similarity index 100%
copy from drivers/net/ethernet/sfc/nic_common.h
copy to drivers/net/ethernet/sfc/siena/nic_common.h
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/siena/ptp.c
similarity index 100%
copy from drivers/net/ethernet/sfc/ptp.c
copy to drivers/net/ethernet/sfc/siena/ptp.c
diff --git a/drivers/net/ethernet/sfc/ptp.h b/drivers/net/ethernet/sfc/siena/ptp.h
similarity index 100%
copy from drivers/net/ethernet/sfc/ptp.h
copy to drivers/net/ethernet/sfc/siena/ptp.h
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/siena/rx.c
similarity index 100%
copy from drivers/net/ethernet/sfc/rx.c
copy to drivers/net/ethernet/sfc/siena/rx.c
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/siena/rx_common.c
similarity index 100%
copy from drivers/net/ethernet/sfc/rx_common.c
copy to drivers/net/ethernet/sfc/siena/rx_common.c
diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/sfc/siena/rx_common.h
similarity index 100%
copy from drivers/net/ethernet/sfc/rx_common.h
copy to drivers/net/ethernet/sfc/siena/rx_common.h
diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/siena/selftest.c
similarity index 100%
copy from drivers/net/ethernet/sfc/selftest.c
copy to drivers/net/ethernet/sfc/siena/selftest.c
diff --git a/drivers/net/ethernet/sfc/selftest.h b/drivers/net/ethernet/sfc/siena/selftest.h
similarity index 100%
copy from drivers/net/ethernet/sfc/selftest.h
copy to drivers/net/ethernet/sfc/siena/selftest.h
diff --git a/drivers/net/ethernet/sfc/sriov.c b/drivers/net/ethernet/sfc/siena/sriov.c
similarity index 100%
copy from drivers/net/ethernet/sfc/sriov.c
copy to drivers/net/ethernet/sfc/siena/sriov.c
diff --git a/drivers/net/ethernet/sfc/sriov.h b/drivers/net/ethernet/sfc/siena/sriov.h
similarity index 100%
copy from drivers/net/ethernet/sfc/sriov.h
copy to drivers/net/ethernet/sfc/siena/sriov.h
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/siena/tx.c
similarity index 100%
copy from drivers/net/ethernet/sfc/tx.c
copy to drivers/net/ethernet/sfc/siena/tx.c
diff --git a/drivers/net/ethernet/sfc/tx.h b/drivers/net/ethernet/sfc/siena/tx.h
similarity index 100%
copy from drivers/net/ethernet/sfc/tx.h
copy to drivers/net/ethernet/sfc/siena/tx.h
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/siena/tx_common.c
similarity index 100%
copy from drivers/net/ethernet/sfc/tx_common.c
copy to drivers/net/ethernet/sfc/siena/tx_common.c
diff --git a/drivers/net/ethernet/sfc/tx_common.h b/drivers/net/ethernet/sfc/siena/tx_common.h
similarity index 100%
copy from drivers/net/ethernet/sfc/tx_common.h
copy to drivers/net/ethernet/sfc/siena/tx_common.h
diff --git a/drivers/net/ethernet/sfc/vfdi.h b/drivers/net/ethernet/sfc/siena/vfdi.h
similarity index 100%
copy from drivers/net/ethernet/sfc/vfdi.h
copy to drivers/net/ethernet/sfc/siena/vfdi.h
diff --git a/drivers/net/ethernet/sfc/workarounds.h b/drivers/net/ethernet/sfc/siena/workarounds.h
similarity index 100%
copy from drivers/net/ethernet/sfc/workarounds.h
copy to drivers/net/ethernet/sfc/siena/workarounds.h


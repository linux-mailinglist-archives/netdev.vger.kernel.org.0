Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80CDC105593
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfKUP3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:29:30 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:32885 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUP3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 10:29:30 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xALFTHVl009018;
        Thu, 21 Nov 2019 07:29:18 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        nirranjan@chelsio.com, atul.gupta@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 0/3] cxgb4: add UDP Segmentation Offload support
Date:   Thu, 21 Nov 2019 20:50:46 +0530
Message-Id: <cover.1574347161.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add UDP Segmentation Offload (USO) supported
by Chelsio T5/T6 NICs.

Patch 1 updates the current Scatter Gather List (SGL) DMA unmap logic
for USO requests.

Patch 2 adds USO support for NIC and MQPRIO QoS offload Tx path.

Patch 3 adds missing stats for MQPRIO QoS offload Tx path.

Thanks,
Rahul


Rahul Lakkireddy (3):
  cxgb4/chcr: update SGL DMA unmap for USO
  cxgb4: add UDP segmentation offload support
  cxgb4: add stats for MQPRIO QoS offload Tx path

 drivers/crypto/chelsio/chcr_ipsec.c           |  27 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  21 +-
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |   2 +
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  16 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  11 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 290 ++++++++++--------
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |  14 +-
 8 files changed, 218 insertions(+), 165 deletions(-)

-- 
2.24.0


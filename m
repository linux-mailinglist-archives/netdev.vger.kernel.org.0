Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC062747E2
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 19:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgIVR4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 13:56:46 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:18438 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIVR4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 13:56:46 -0400
X-Greylist: delayed 696 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2020 13:56:46 EDT
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 08MHj2cS031036;
        Tue, 22 Sep 2020 10:45:03 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net-next 0/3] cxgb4/ch_ktls: updates in net-next
Date:   Tue, 22 Sep 2020 23:14:58 +0530
Message-Id: <20200922174501.14943-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches improves connections setup and statistics.

This series is broken down as follows:

Patch 1 fixes the handling of connection setup failure in HW. Driver
shouldn't return success to tls_dev_add, until HW returns success.

Patch 2 avoids the log flood.

Patch 3 adds ktls statistics at port level.

Rohit Maheshwari (3):
  ch_ktls: Issue if connection offload fails
  cxgb4: Avoid log flood
  cxgb4/ch_ktls: ktls stats are added at port level

 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  35 +--
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  50 +++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.c    |   8 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |  21 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 278 +++++++++---------
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.h |  15 +-
 6 files changed, 206 insertions(+), 201 deletions(-)

-- 
2.18.1


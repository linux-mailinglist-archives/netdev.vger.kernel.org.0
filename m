Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A650327690B
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 08:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgIXGg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 02:36:56 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:10188 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbgIXGg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 02:36:56 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 08O6aejZ003455;
        Wed, 23 Sep 2020 23:36:46 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net-next v2 0/3] cxgb4/ch_ktls: updates in net-next
Date:   Thu, 24 Sep 2020 12:06:36 +0530
Message-Id: <20200924063639.18005-1-rohitm@chelsio.com>
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

v1->v2:
- removed conn_up from all places.

Rohit Maheshwari (3):
  ch_ktls: Issue if connection offload fails
  cxgb4: Avoid log flood
  cxgb4/ch_ktls: ktls stats are added at port level

 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  35 +--
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  50 +++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.c    |   8 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |  21 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 275 ++++++++----------
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.h |  13 +-
 6 files changed, 194 insertions(+), 208 deletions(-)

-- 
2.18.1


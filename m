Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68627200B4D
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 16:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgFSOWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 10:22:06 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:48830 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgFSOWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 10:22:05 -0400
Received: from vishal.asicdesigners.com (chethan-pc.asicdesigners.com [10.193.177.170] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05JELtbb002529;
        Fri, 19 Jun 2020 07:21:57 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, rahul.lakkireddy@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 0/5] cxgb4: add support for ethtool n-tuple filters
Date:   Fri, 19 Jun 2020 19:51:34 +0530
Message-Id: <20200619142139.27982-1-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: Adds data structure to maintain list of filters and handles init/dinit
	 of the same.

Patch 2: Handles addition of filters via ETHTOOL_SRXCLSRLINS.

Patch 3: Handles deletion of filtes via ETHTOOL_SRXCLSRLDEL.

Patch 4: Handles viewing of added filters.

Patch 5: Adds FLOW_ACTION_QUEUE support.

Vishal Kulkarni (5):
  cxgb4: add skeleton for ethtool n-tuple filters
  cxgb4: add ethtool n-tuple filter insertion
  cxgb4: add ethtool n-tuple filter deletion
  cxgb4: add support to fetch ethtool n-tuple filters
  cxgb4: add action to steer flows to specific Rxq

 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  15 +
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 335 ++++++++++++++++++
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c |   5 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.h |   3 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  22 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  | 131 ++++---
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |   9 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   2 +
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h  |   4 +
 9 files changed, 463 insertions(+), 63 deletions(-)

-- 
2.18.2


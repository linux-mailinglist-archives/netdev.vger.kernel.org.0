Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EB61FEB3E
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 08:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgFRGG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 02:06:57 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:39417 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgFRGG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 02:06:57 -0400
Received: from vishal.asicdesigners.com ([10.193.191.100])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05I66ob4030007;
        Wed, 17 Jun 2020 23:06:51 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next v2 0/5] cxgb4: add support to read/write flash
Date:   Thu, 18 Jun 2020 11:35:51 +0530
Message-Id: <20200618060556.14410-1-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches adds support to read/write different binary images
of serial flash present in Chelsio terminator.

V2 changes:
Patch 1: No change
Patch 2: No change
Patch 3: Fix 4 compilation warnings reported by C=1, W=1 flags
Patch 4: No change
Patch 5: No change
 
Vishal Kulkarni (5):
  cxgb4: update set_flash to flash different images
  cxgb4: add support to flash PHY image
  cxgb4: add support to flash boot image
  cxgb4: add support to flash boot cfg image
  cxgb4: add support to read serial flash

 drivers/net/ethernet/chelsio/cxgb4/cudbg_if.h |   3 +-
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    |  38 +++
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.h    |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  67 +++++
 .../net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c  |  14 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_cudbg.h  |   1 +
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 244 ++++++++++++++-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    | 277 ++++++++++++++++++
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h  |   6 +
 9 files changed, 638 insertions(+), 16 deletions(-)

-- 
2.21.1


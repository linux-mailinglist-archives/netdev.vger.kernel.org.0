Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AF420620A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392900AbgFWUyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:54:02 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:53714 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392810AbgFWUqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:46:07 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKk5SR019579;
        Tue, 23 Jun 2020 13:46:06 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 0/2] cxgb4: fix more warnings reported by sparse
Date:   Wed, 24 Jun 2020 02:03:21 +0530
Message-Id: <cover.1592941598.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 ensures all callers take on-chip memory lock when flashing
PHY firmware to fix lock context imbalance warnings.

Patch 2 moves all static arrays in header file to respective C file
in device dump collection path.

Thanks,
Rahul

Rahul Lakkireddy (2):
  cxgb4: always sync access when flashing PHY firmware
  cxgb4: move device dump arrays in header to C file

 .../net/ethernet/chelsio/cxgb4/cudbg_entity.h | 161 -------
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 406 ++++++++++++++++++
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.h    |   2 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   3 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c  | 248 +----------
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |   5 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |   5 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    |  14 +-
 8 files changed, 420 insertions(+), 424 deletions(-)

-- 
2.24.0


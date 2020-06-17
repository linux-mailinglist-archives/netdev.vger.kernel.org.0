Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385BD1FC62E
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 08:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgFQG3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 02:29:32 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:44802 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgFQG3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 02:29:32 -0400
Received: from vishal.asicdesigners.com ([10.193.191.100])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05H6TOkL026703;
        Tue, 16 Jun 2020 23:29:25 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 0/5] cxgb4: add support to read/write flash
Date:   Wed, 17 Jun 2020 11:59:02 +0530
Message-Id: <20200617062907.26121-1-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches adds support to read/write different binary images
of serial flash present in Chelsio terminator.

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
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    | 279 ++++++++++++++++++
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h  |   6 +
 9 files changed, 640 insertions(+), 16 deletions(-)

-- 
2.18.2


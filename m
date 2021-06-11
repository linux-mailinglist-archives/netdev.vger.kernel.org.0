Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED2A3A3E4A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 10:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhFKIux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 04:50:53 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:3906 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhFKIuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 04:50:52 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 15B8mn5o022141;
        Fri, 11 Jun 2021 01:48:50 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com
Subject: [PATCH net 0/3] cxgb4: bug fixes for ethtool flash ops
Date:   Fri, 11 Jun 2021 12:17:44 +0530
Message-Id: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add bug fixes in ethtool flash operations.

Patch 1 fixes an endianness issue when writing boot image to flash
after the device ID has been updated.

Patch 2 fixes sleep in atomic when writing PHY firmware to flash.

Patch 3 fixes issue with PHY firmware image not getting written to
flash when chip is still running.

Thanks,
Rahul

Rahul Lakkireddy (3):
  cxgb4: fix endianness when flashing boot image
  cxgb4: fix sleep in atomic when flashing PHY firmware
  cxgb4: halt chip before flashing PHY firmware image

 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 24 ++++++++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 -
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    | 46 ++++++++++++-------
 3 files changed, 48 insertions(+), 24 deletions(-)

-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1A4248A35
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgHRPl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:41:29 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:1113 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgHRPl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 11:41:26 -0400
Received: from localhost (fedora32ganji.blr.asicdesigners.com [10.193.80.135])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 07IFf7D9024129;
        Tue, 18 Aug 2020 08:41:07 -0700
From:   Ganji Aravind <ganji.aravind@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, vishal@chelsio.com,
        rahul.lakkireddy@chelsio.com
Subject: [PATCH net 0/2]cxgb4: Fix ethtool selftest flits calculation
Date:   Tue, 18 Aug 2020 21:10:56 +0530
Message-Id: <20200818154058.1770002-1-ganji.aravind@chelsio.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 will fix work request size calculation for loopback selftest.

Patch 2 will fix race between loopback selftest and normal Tx handler.

Thanks,
Ganji Aravind.

Ganji Aravind (2):
  cxgb4: Fix work request size calculation for loopback test
  cxgb4: Fix race between loopback and normal Tx path

 drivers/net/ethernet/chelsio/cxgb4/sge.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
2.26.2


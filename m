Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70561223D43
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 15:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgGQNtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 09:49:14 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:9053 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQNtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 09:49:13 -0400
Received: from vishal.asicdesigners.com (indranil-pc.asicdesigners.com [10.193.177.163] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06HDn2F5017430;
        Fri, 17 Jul 2020 06:49:08 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 0/4] cxgb4: add ethtool self_test support
Date:   Fri, 17 Jul 2020 19:17:55 +0530
Message-Id: <20200717134759.8268-1-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add support for below tests.
1. Adapter status test
2. Link test
3. Link speed test
4. Loopback test

Vishal Kulkarni (4):
  cxgb4: Add ethtool self-test support
  cxgb4: Add link test to ethtool self test.
  cxgb4: Add adapter status check to ethtool
  cxgb4: Add speed link test to ethtool self_test

 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  10 ++
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 137 ++++++++++++++++++
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 117 ++++++++++++++-
 3 files changed, 261 insertions(+), 3 deletions(-)

-- 
2.18.2


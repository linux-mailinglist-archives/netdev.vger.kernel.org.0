Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1612924D70
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 13:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfEULBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 07:01:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:38967 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbfEULBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 07:01:35 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 May 2019 04:01:34 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 21 May 2019 04:01:33 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hT2WS-0009NY-N1; Tue, 21 May 2019 19:01:32 +0800
Date:   Tue, 21 May 2019 19:01:12 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Vishal Kulkarni <vishal@chelsio.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org, davem@davemloft.net,
        nirranjan@chelsio.com, indranil@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [RFC PATCH] cxgb4: t4_get_tp_e2c_map() can be static
Message-ID: <20190521110112.GA89318@lkp-kbuild13>
References: <1558410037-29161-1-git-send-email-vishal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558410037-29161-1-git-send-email-vishal@chelsio.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 2b22a51be851 ("cxgb4: Enable hash filter with offload")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 t4_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 866ee31..c85dcbf 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -6213,7 +6213,7 @@ unsigned int t4_get_mps_bg_map(struct adapter *adapter, int pidx)
  *      @adapter: the adapter
  *      @pidx: the port index
  */
-unsigned int t4_get_tp_e2c_map(struct adapter *adapter, int pidx)
+static unsigned int t4_get_tp_e2c_map(struct adapter *adapter, int pidx)
 {
 	unsigned int nports;
 	u32 param, val = 0;

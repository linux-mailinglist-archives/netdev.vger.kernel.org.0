Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53EA719B9DF
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 03:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733214AbgDBB0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 21:26:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:31355 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732462AbgDBB0M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 21:26:12 -0400
IronPort-SDR: 0v4D3r2SKr5SU0+OKkgM5f+clB745rb/74uNOCFNIuOn+SWwlc/6894JMdwuL/76gmMWwSLl8U
 SssDNtIS4eGQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2020 18:26:12 -0700
IronPort-SDR: PJxDp+fV4UgIdKEJICvzrUJlvUIvsCpvPyMg6iYbfbZQwvGkbKq62rRuLeEbT+N0/qJZnLB4b8
 24xFC0TaRVow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,333,1580803200"; 
   d="scan'208";a="450760650"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.3])
  by fmsmga006.fm.intel.com with ESMTP; 01 Apr 2020 18:26:08 -0700
Date:   Thu, 2 Apr 2020 09:25:48 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kbuild-all@lists.01.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, murali.policharla@broadcom.com,
        stephen@networkplumber.org, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, nikolay@cumulusnetworks.com,
        netdev@vger.kernel.org
Subject: [RFC PATCH] net: dsa: dsa_bridge_mtu_normalization() can be static
Message-ID: <20200402012548.GG8179@shao2-debian>
References: <202003280227.SLAlsyiu%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202003280227.SLAlsyiu%lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: f41071407c85 ("net: dsa: implement auto-normalization of MTU for bridge hardware datapath")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 slave.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8ced165a79084..624f54750dbb3 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1261,7 +1261,7 @@ static void dsa_hw_port_list_free(struct list_head *hw_port_list)
 }
 
 /* Make the hardware datapath to/from @dev limited to a common MTU */
-void dsa_bridge_mtu_normalization(struct dsa_port *dp)
+static void dsa_bridge_mtu_normalization(struct dsa_port *dp)
 {
 	struct list_head hw_port_list;
 	struct dsa_switch_tree *dst;

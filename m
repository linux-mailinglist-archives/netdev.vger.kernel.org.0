Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60461E85DB
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgE2Ryw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:54:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:13136 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgE2Ryv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:54:51 -0400
IronPort-SDR: YhUoC6bkwMHwv3O1+rnz+lzB3B9iR1vKINpem31NBvMj/X7EyqJgOZ4eRAF4TSOONrZGoCKJwb
 xgDlJmB75nUA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 10:54:51 -0700
IronPort-SDR: +KxvRqICPdTtRixo2wc0d+npRohybXIOYc0sHBSTR5R+ZzWlu5BAs6gWTQKdpsbl/ipC0G2JQ7
 6RJt7R5pOX2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="303196628"
Received: from lkp-server01.sh.intel.com (HELO 9f9df8056aac) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 29 May 2020 10:54:49 -0700
Received: from kbuild by 9f9df8056aac with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jejDV-0000QP-0m; Fri, 29 May 2020 17:54:49 +0000
Date:   Sat, 30 May 2020 01:54:05 +0800
From:   kbuild test robot <lkp@intel.com>
To:     "Doug, Berger," <opendmb@gmail.com>
Cc:     kbuild-all@lists.01.org, Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH linux-next] Revert "net: bcmgenet:
 bcmgenet_hfb_add_filter() can be static
Message-ID: <20200529175405.GA69129@d90f8b999b53>
References: <202005300154.63FdkmJb%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202005300154.63FdkmJb%lkp@intel.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 14da1510fedc ("Revert "net: bcmgenet: remove unused function in bcmgenet.c"")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 bcmgenet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index b37ef05c5083a..98e492e066dcb 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2855,8 +2855,8 @@ static int bcmgenet_hfb_find_unused_filter(struct bcmgenet_priv *priv)
  * bcmgenet_hfb_add_filter(priv, hfb_filter_ipv4_udp,
  *                         ARRAY_SIZE(hfb_filter_ipv4_udp), 0);
  */
-int bcmgenet_hfb_add_filter(struct bcmgenet_priv *priv, u32 *f_data,
-			    u32 f_length, u32 rx_queue)
+static int bcmgenet_hfb_add_filter(struct bcmgenet_priv *priv, u32 *f_data,
+				   u32 f_length, u32 rx_queue)
 {
 	int f_index;
 	u32 i;

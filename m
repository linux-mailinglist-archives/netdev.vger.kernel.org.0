Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72547213EF3
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 19:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgGCRrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 13:47:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:48281 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgGCRrS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 13:47:18 -0400
IronPort-SDR: KWIY8txE2O6ubSezVhnWiRr96pQu7JHmAU0miIHsr/umAo6LWRFw2W0mtujAzx9pFaJMqlM9wf
 +5nat/TWGiXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9671"; a="146264610"
X-IronPort-AV: E=Sophos;i="5.75,308,1589266800"; 
   d="scan'208";a="146264610"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2020 10:47:17 -0700
IronPort-SDR: Au1XLfpkPcWC7L8a68RUEIZL6cj0LXTlsyvVg4GYTMDBTOT+AABxSNo/DMDkc5idEnsr5GUIPO
 wmv85ORhY+wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,308,1589266800"; 
   d="scan'208";a="426346318"
Received: from lkp-server01.sh.intel.com (HELO 6dc8ab148a5d) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 03 Jul 2020 10:47:16 -0700
Received: from kbuild by 6dc8ab148a5d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jrPmN-0000KR-JE; Fri, 03 Jul 2020 17:47:15 +0000
Date:   Sat, 4 Jul 2020 01:46:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Edward Cree <ecree@solarflare.com>,
        linux-net-drivers@solarflare.com, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [RFC PATCH] sfc_ef100: ef100_hard_start_xmit() can be static
Message-ID: <20200703174655.GA64951@bc3541c4c19f>
References: <b9ccfacc-93c8-5f60-d3a5-ecd87fcef5ee@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9ccfacc-93c8-5f60-d3a5-ecd87fcef5ee@solarflare.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 ef100_netdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 356938104cb27..8e23ffed3f0ec 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -42,8 +42,8 @@ static void ef100_update_name(struct efx_nic *efx)
  * Note that returning anything other than NETDEV_TX_OK will cause the
  * OS to free the skb.
  */
-netdev_tx_t ef100_hard_start_xmit(struct sk_buff *skb,
-				  struct net_device *net_dev)
+static netdev_tx_t ef100_hard_start_xmit(struct sk_buff *skb,
+					 struct net_device *net_dev)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct efx_tx_queue *tx_queue;

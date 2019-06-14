Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C97444524D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 05:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfFNDDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 23:03:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:31060 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbfFNDC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 23:02:58 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 20:02:57 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 13 Jun 2019 20:02:55 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hbcUQ-0001eX-Mf; Fri, 14 Jun 2019 11:02:54 +0800
Date:   Fri, 14 Jun 2019 11:02:08 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Sameeh Jubran <sameehj@amazon.com>
Cc:     kbuild-all@01.org, Netanel Belgazal <netanel@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH linux-next] net: ena: ena_adjust_intr_moderation() can be
 static
Message-ID: <20190614030208.GA13281@lkp-kbuild18>
References: <201906141113.NUYnC1ZG%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201906141113.NUYnC1ZG%lkp@intel.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: c2b542044761 ("net: ena: remove inline keyword from functions in *.c")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 ena_netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index b7865ee..b63ae9b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1155,7 +1155,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	return 0;
 }
 
-void ena_adjust_intr_moderation(struct ena_ring *rx_ring,
+static void ena_adjust_intr_moderation(struct ena_ring *rx_ring,
 				       struct ena_ring *tx_ring)
 {
 	/* We apply adaptive moderation on Rx path only.

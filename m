Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A660C63BF1
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbfGITc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:32:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:11270 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbfGITc3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 15:32:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 12:32:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,471,1557212400"; 
   d="scan'208";a="173655907"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Jul 2019 12:32:26 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hkvqk-0003hP-Bt; Wed, 10 Jul 2019 03:32:26 +0800
Date:   Wed, 10 Jul 2019 03:32:25 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     kbuild-all@01.org, Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH linux-next] net: ethernet: ti: davinci_cpdma:
 cpdma_chan_split_pool() can be static
Message-ID: <20190709193225.GA89649@lkp-kbuild04>
References: <201907100329.bQl3UgMB%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201907100329.bQl3UgMB%lkp@intel.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 962fb618909e ("net: ethernet: ti: davinci_cpdma: allow desc split while down")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 davinci_cpdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 0ca2a1a..1f6065b 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -722,7 +722,7 @@ static void cpdma_chan_set_descs(struct cpdma_ctlr *ctlr,
  * cpdma_chan_split_pool - Splits ctrl pool between all channels.
  * Has to be called under ctlr lock
  */
-int cpdma_chan_split_pool(struct cpdma_ctlr *ctlr)
+static int cpdma_chan_split_pool(struct cpdma_ctlr *ctlr)
 {
 	int tx_per_ch_desc = 0, rx_per_ch_desc = 0;
 	int free_rx_num = 0, free_tx_num = 0;

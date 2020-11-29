Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B0B2C7920
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 13:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgK2Mwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 07:52:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:27078 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgK2Mwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 07:52:51 -0500
IronPort-SDR: h0DjLgOn0MKkv0cwMqUEeLfbqvrZ5wq6KcfO1uaGtWwRJMFxbo3p1JK5Tmqw+BkaOFZ8fPYzTR
 1pBOriRFRfvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9819"; a="172632659"
X-IronPort-AV: E=Sophos;i="5.78,379,1599548400"; 
   d="scan'208";a="172632659"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2020 04:52:09 -0800
IronPort-SDR: 7VJLYYFQ88L5YzSYwivPtSQbJxk59BrWNa5j0rhwbx2C9RI3vBAkEMmIxy5n9p6kuB98/2me4o
 I6/X36dwa4Fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,379,1599548400"; 
   d="scan'208";a="366746471"
Received: from lkp-server01.sh.intel.com (HELO 3082e074203f) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 29 Nov 2020 04:52:07 -0800
Received: from kbuild by 3082e074203f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kjMBS-00006R-OZ; Sun, 29 Nov 2020 12:52:06 +0000
Date:   Sun, 29 Nov 2020 20:51:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jean Pihet <jean.pihet@newoldbits.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        Ryan Barnett <ryan.barnett@rockwellcollins.com>,
        Conrad Ratschan <conrad.ratschan@rockwellcollins.com>,
        Hugo Cornelis <hugo.cornelis@essensium.com>,
        Arnout Vandecappelle <arnout.vandecappelle@essensium.com>,
        Jean Pihet <jean.pihet@newoldbits.com>
Subject: [RFC PATCH] net: dsa: ksz8795: ksz8795_adjust_link() can be static
Message-ID: <20201129125159.GA24820@45a3048463a8>
References: <20201129102400.157786-2-jean.pihet@newoldbits.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201129102400.157786-2-jean.pihet@newoldbits.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 ksz8795.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 09c1173cc6073c..834a8dc251adba 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1111,7 +1111,7 @@ static int ksz8795_setup(struct dsa_switch *ds)
 	return 0;
 }
 
-void ksz8795_adjust_link(struct dsa_switch *ds, int port,
+static void ksz8795_adjust_link(struct dsa_switch *ds, int port,
 						 struct phy_device *phydev)
 {
 	struct ksz_device *dev = ds->priv;

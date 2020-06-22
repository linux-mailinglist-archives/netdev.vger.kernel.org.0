Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62151203C93
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgFVQa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:30:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:36779 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729461AbgFVQaZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 12:30:25 -0400
IronPort-SDR: mu9u9/08kWLcX26YzMNPawmTqiSrK3LeQvaxKXe2UbKY562Fv2Ck+nzXjPjP9VZye290PqQSNJ
 h/BL2LJEEWSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="123459158"
X-IronPort-AV: E=Sophos;i="5.75,267,1589266800"; 
   d="scan'208";a="123459158"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 09:30:25 -0700
IronPort-SDR: kZtJYymsZAmC650+LCDw/DK2bdhTZRWugWOG2IU2igWVmbkvzDCfGoQ50nByfEDwPLMim0IhgN
 MctHs6cVY7cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,267,1589266800"; 
   d="scan'208";a="263009394"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 22 Jun 2020 09:30:23 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id C699C11C; Mon, 22 Jun 2020 19:30:22 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: thunderbolt: Add comment clarifying prtcstns flags
Date:   Mon, 22 Jun 2020 19:30:22 +0300
Message-Id: <20200622163022.53298-1-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ThunderboltIP protocol currently has two flags from which we only
support and set match frags ID. The first flag is reserved for full E2E
flow control. Add a comment that clarifies them.

Suggested-by: Yehezkel Bernat <yehezkelshb@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/net/thunderbolt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index a812726703a4..3160443ef3b9 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1335,6 +1335,10 @@ static int __init tbnet_init(void)
 	tb_property_add_immediate(tbnet_dir, "prtcid", 1);
 	tb_property_add_immediate(tbnet_dir, "prtcvers", 1);
 	tb_property_add_immediate(tbnet_dir, "prtcrevs", 1);
+	/* Currently only announce support for match frags ID (bit 1). Bit 0
+	 * is reserved for full E2E flow control which we do not support at
+	 * the moment.
+	 */
 	tb_property_add_immediate(tbnet_dir, "prtcstns",
 				  TBNET_MATCH_FRAGS_ID);
 
-- 
2.27.0


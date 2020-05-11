Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F111CE681
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 23:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731973AbgEKVCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 17:02:20 -0400
Received: from mga06.intel.com ([134.134.136.31]:60130 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728544AbgEKVCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 17:02:18 -0400
IronPort-SDR: nA6sReJIXxAj2lc8J6aHTgAEWEJztBhgUA9Jjqs9IoQYYodXNK1KXdieJ5wPrKdYc3KjbFrc7H
 JG176sOPjqwg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 14:02:17 -0700
IronPort-SDR: 4beUGah8RDKCo4M/VHRMlkbuVjDbNw4/kbLgluP6x37Da6aJdyn3IGtBfV7RcOsmGWBNG75WOu
 CU/v/dk4lMSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="261890568"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by orsmga003.jf.intel.com with ESMTP; 11 May 2020 14:02:17 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net] ptp: fix struct member comment for do_aux_work
Date:   Mon, 11 May 2020 14:02:15 -0700
Message-Id: <20200511210215.4178242-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The do_aux_work callback had documentation in the structure comment
which referred to it as "do_work".

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 include/linux/ptp_clock_kernel.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 31144d954d89..d3e8ba5c7125 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -108,10 +108,10 @@ struct ptp_system_timestamp {
  *            parameter func: the desired function to use.
  *            parameter chan: the function channel index to use.
  *
- * @do_work:  Request driver to perform auxiliary (periodic) operations
- *	      Driver should return delay of the next auxiliary work scheduling
- *	      time (>=0) or negative value in case further scheduling
- *	      is not required.
+ * @do_aux_work:  Request driver to perform auxiliary (periodic) operations
+ *                Driver should return delay of the next auxiliary work
+ *                scheduling time (>=0) or negative value in case further
+ *                scheduling is not required.
  *
  * Drivers should embed their ptp_clock_info within a private
  * structure, obtaining a reference to it using container_of().
-- 
2.25.2


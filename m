Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A56A26E2EC
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgIQRwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgIQRvp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 13:51:45 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3528C206C3;
        Thu, 17 Sep 2020 17:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600365100;
        bh=cv9pPWme/azgO+Ol74IEDvpoTbVbYWxSlqu0/Zb3LWo=;
        h=From:To:Cc:Subject:Date:From;
        b=Hj3oOUYeteILAN86zbZa/dhJIjjGvKj5ioJS79jDh6cQdRurikSFjhqnZcW7fawgy
         hNPbID1M1wWkllxpcBf66qx4UQ0tfjNPQANdgP7YtVkfPt+lAUF0XVIHRp9eQqz2gn
         0V/PwGKFuxNOn1HQkT38tRC9OrzI3llA1xziRlcw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: remove comments on struct rtnl_link_stats
Date:   Thu, 17 Sep 2020 10:51:32 -0700
Message-Id: <20200917175132.592308-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We removed the misleading comments from struct rtnl_link_stats64
when we added proper kdoc. struct rtnl_link_stats has the same
inline comments, so remove them, too.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/if_link.h | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index bf4667403cab..c4b23f06f69e 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -7,24 +7,23 @@
 
 /* This struct should be in sync with struct rtnl_link_stats64 */
 struct rtnl_link_stats {
-	__u32	rx_packets;		/* total packets received	*/
-	__u32	tx_packets;		/* total packets transmitted	*/
-	__u32	rx_bytes;		/* total bytes received 	*/
-	__u32	tx_bytes;		/* total bytes transmitted	*/
-	__u32	rx_errors;		/* bad packets received		*/
-	__u32	tx_errors;		/* packet transmit problems	*/
-	__u32	rx_dropped;		/* no space in linux buffers	*/
-	__u32	tx_dropped;		/* no space available in linux	*/
-	__u32	multicast;		/* multicast packets received	*/
+	__u32	rx_packets;
+	__u32	tx_packets;
+	__u32	rx_bytes;
+	__u32	tx_bytes;
+	__u32	rx_errors;
+	__u32	tx_errors;
+	__u32	rx_dropped;
+	__u32	tx_dropped;
+	__u32	multicast;
 	__u32	collisions;
-
 	/* detailed rx_errors: */
 	__u32	rx_length_errors;
-	__u32	rx_over_errors;		/* receiver ring buff overflow	*/
-	__u32	rx_crc_errors;		/* recved pkt with crc error	*/
-	__u32	rx_frame_errors;	/* recv'd frame alignment error */
-	__u32	rx_fifo_errors;		/* recv'r fifo overrun		*/
-	__u32	rx_missed_errors;	/* receiver missed packet	*/
+	__u32	rx_over_errors;
+	__u32	rx_crc_errors;
+	__u32	rx_frame_errors;
+	__u32	rx_fifo_errors;
+	__u32	rx_missed_errors;
 
 	/* detailed tx_errors */
 	__u32	tx_aborted_errors;
@@ -37,7 +36,7 @@ struct rtnl_link_stats {
 	__u32	rx_compressed;
 	__u32	tx_compressed;
 
-	__u32	rx_nohandler;		/* dropped, no handler found	*/
+	__u32	rx_nohandler;
 };
 
 /**
-- 
2.26.2


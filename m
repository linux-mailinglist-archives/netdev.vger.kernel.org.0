Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685AF301E99
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 21:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbhAXUCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 15:02:50 -0500
Received: from outbound-relay9.guardedhost.com ([216.239.133.221]:54151 "EHLO
        outbound-relay9.guardedhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbhAXUCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 15:02:49 -0500
Received: from mail.guardedhost.com (tev-mx5.omnis.com [216.239.133.152])
        by outbound-relay1.guardedhost.com (Postfix) with ESMTP id 4DP3mw4RVJz4x6yS;
        Sun, 24 Jan 2021 20:02:08 +0000 (GMT)
Received: from localhost.localdomain (unknown [45.86.203.226])
        (Authenticated sender: alanp@snowmoose.com)
        by mail.guardedhost.com (Postfix) with ESMTPSA id 4DP3mt2H0bz30RD;
        Sun, 24 Jan 2021 20:02:05 +0000 (GMT)
From:   Alan Perry <alanp@snowmoose.com>
To:     netdev@vger.kernel.org
Cc:     Alan Perry <alanp@snowmoose.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH iproute2-next] Add description section to rdma man page
Date:   Sun, 24 Jan 2021 12:00:27 -0800
Message-Id: <20210124200026.75071-1-alanp@snowmoose.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: mail.guardedhost.com;auth=pass
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse-Id: 09DCEC3A-5E7F-11EB-A4D0-DF4409F149D9
X-Virus-Scanned: clamav-milter 0.102.2 at tev-mx5.omnis.com
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a description section with basic info about the rdma command for users
unfamiliar with it.

Signed-off-by: Alan Perry <alanp@snowmoose.com>
Acked-by: Leon Romanovsky <leonro@nvidia.com>

---
 man/man8/rdma.8 | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
index c9e5d50d..66ef9902 100644
--- a/man/man8/rdma.8
+++ b/man/man8/rdma.8
@@ -1,4 +1,4 @@
-.TH RDMA 8 "28 Mar 2017" "iproute2" "Linux"
+.TH RDMA 8 "24 Jan 2021" "iproute2" "Linux"
 .SH NAME
 rdma \- RDMA tool
 .SH SYNOPSIS
@@ -29,6 +29,13 @@ rdma \- RDMA tool
 \fB\-j\fR[\fIson\fR] }
 \fB\-p\fR[\fIretty\fR] }
 
+.SH DESCRIPTION
+.B rdma
+is a tool for querying and setting the configuration for RDMA-capable
+devices. Remote direct memory access (RDMA) is the ability of accessing
+(reading, writing) memory on a remote machine without interrupting the
+processing of the CPU(s) on that system.
+
 .SH OPTIONS
 
 .TP
-- 
2.30.0


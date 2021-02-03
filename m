Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2041B30D2B1
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhBCE4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:56:49 -0500
Received: from outbound-relay4.guardedhost.com ([216.239.133.204]:34351 "EHLO
        outbound-relay4.guardedhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231289AbhBCE4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:56:48 -0500
Received: from mail.guardedhost.com (mx04.guardedhost.com [IPv6:2607:fe90:1:1::55:1])
        by outbound-relay1.guardedhost.com (Postfix) with ESMTP id 4DVqBv1Zk0z4x7yV;
        Wed,  3 Feb 2021 04:56:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [178.239.198.140])
        (Authenticated sender: alanp@snowmoose.com)
        by mail.guardedhost.com (Postfix) with ESMTPSA id 4DVqBs09VCz30LB;
        Wed,  3 Feb 2021 04:56:04 +0000 (GMT)
From:   Alan Perry <alanp@snowmoose.com>
To:     netdev@vger.kernel.org
Cc:     Alan Perry <alanp@snowmoose.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH iproute2-next] Add a description section to the rdma man page
Date:   Tue,  2 Feb 2021 20:52:35 -0800
Message-Id: <20210203045234.57492-1-alanp@snowmoose.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: mail.guardedhost.com;auth=pass
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse-Id: 201B1E0E-65DC-11EB-BEDE-EADA428D60A2
X-Virus-Scanned: clamav-milter 0.102.2 at tev-mx4.omnis.com
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Alan Perry <alanp@snowmoose.com>
Acked-by: Leon Romanovsky <leonro@nvidia.com>
---
 man/man8/rdma.8 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
index c9e5d50d..9c016687 100644
--- a/man/man8/rdma.8
+++ b/man/man8/rdma.8
@@ -29,6 +29,12 @@ rdma \- RDMA tool
 \fB\-j\fR[\fIson\fR] }
 \fB\-p\fR[\fIretty\fR] }
 
+.SH DESCRIPTION
+.B rdma
+is a tool for querying and setting the configuration for RDMA, direct
+memory access between the memory of two computers without use of the
+operating system on either computer.
+
 .SH OPTIONS
 
 .TP
-- 
2.30.0


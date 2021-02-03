Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC41030E047
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhBCQ47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:56:59 -0500
Received: from outbound-relay4.guardedhost.com ([216.239.133.204]:34730 "EHLO
        outbound-relay4.guardedhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231584AbhBCQ4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 11:56:34 -0500
Received: from mail.guardedhost.com (tev-mx4.omnis.com [216.239.133.144])
        by outbound-relay1.guardedhost.com (Postfix) with ESMTP id 4DW79G39RVz4x8b1;
        Wed,  3 Feb 2021 16:55:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [178.239.198.140])
        (Authenticated sender: alanp@snowmoose.com)
        by mail.guardedhost.com (Postfix) with ESMTPSA id 4DW79C3wgqz30Kr;
        Wed,  3 Feb 2021 16:55:43 +0000 (GMT)
From:   Alan Perry <alanp@snowmoose.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, Alan Perry <alanp@snowmoose.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH iproute2 v3] Add a description section to the rdma man page
Date:   Wed,  3 Feb 2021 08:45:10 -0800
Message-Id: <20210203164509.41998-1-alanp@snowmoose.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: mail.guardedhost.com;auth=pass
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse-Id: A8E850B2-6640-11EB-8077-EADA428D60A2
X-Virus-Scanned: clamav-milter 0.102.2 at tev-mx4.omnis.com
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a description section to the rdma man page with basic info about the
command for users unfamiliar with it.

Signed-off-by: Alan Perry <alanp@snowmoose.com>
Acked-by: Leon Romanovsky <leonro@nvidia.com>
---
Changelog
Removed man page date change. Reworked description change into several lines
instead of one long line.
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAE72E1835
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 05:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgLWE5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 23:57:44 -0500
Received: from outbound-relay9.guardedhost.com ([216.239.133.221]:44207 "EHLO
        outbound-relay9.guardedhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726161AbgLWE5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 23:57:44 -0500
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Dec 2020 23:57:44 EST
Received: from mail.guardedhost.com (mx01.guardedhost.com [IPv6:2607:fe90:1:1::52:1])
        by outbound-relay1.guardedhost.com (Postfix) with ESMTP id 4D110n20fGz4x8Fn;
        Wed, 23 Dec 2020 04:47:53 +0000 (GMT)
Received: from Alans-MacBook-Pro.local (c-73-254-147-133.hsd1.wa.comcast.net [73.254.147.133])
        (Authenticated sender: alanp@snowmoose.com)
        by mail.guardedhost.com (Postfix) with ESMTPSA id 4D110m2qxnz30BY;
        Wed, 23 Dec 2020 04:47:52 +0000 (GMT)
To:     leonro@mellanox.com, netdev@vger.kernel.org
From:   Alan Perry <alanp@snowmoose.com>
Subject: [PATCH] rdma.8: Add basic description for users unfamiliar with rdma
Organization: Snowmoose Software
Message-ID: <eb358848-49a8-1a8e-3919-c07b6aa3d21d@snowmoose.com>
Date:   Tue, 22 Dec 2020 20:47:51 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Authentication-Results: mail.guardedhost.com;auth=pass
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse-Id: 04462CBE-44DA-11EB-834B-C8F70D9453E0
X-Virus-Scanned: clamav-milter 0.102.2 at tev-mx1.omnis.com
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a description section with basic info about the rdma command for 
users unfamiliar with it.

Signed-off-by: Alan Perry <alanp@snowmoose.com>
---
  man/man8/rdma.8 | 6 +++++-
  1 file changed, 5 insertion(+), 1 deletion(-)

diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
index c9e5d50d..d68d0cf6 100644
--- a/man/man8/rdma.8
+++ b/man/man8/rdma.8
@@ -1,4 +1,4 @@
-.TH RDMA 8 "28 Mar 2017" "iproute2" "Linux"
+.TH RDMA 8 "22 Dec 2020" "iproute2" "Linux"
  .SH NAME
  rdma \- RDMA tool
  .SH SYNOPSIS
@@ -29,6 +29,10 @@ rdma \- RDMA tool
  \fB\-j\fR[\fIson\fR] }
  \fB\-p\fR[\fIretty\fR] }

+.SH DESCRIPTION
+.B rdma
+is a tool for querying and setting the configuration for RDMA, direct 
memory access between the memory of two computers without use of the 
operating system on either computer.
+
  .SH OPTIONS

  .TP

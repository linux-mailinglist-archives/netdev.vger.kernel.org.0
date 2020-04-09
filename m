Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92EEB1A2EC3
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 07:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgDIFSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 01:18:35 -0400
Received: from vip1.b1c1l1.com ([64.57.102.218]:35126 "EHLO vip1.b1c1l1.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgDIFSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 01:18:35 -0400
Received: by vip1.b1c1l1.com (Postfix) with ESMTPSA id B50142736F;
        Thu,  9 Apr 2020 05:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=b1c1l1.com; s=alpha;
        t=1586409163; bh=7tmxli04gqsXwFL8V8pdt9HILVF+J4UeNhyJCdNTUrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=orNhrRx0nZ2+HrkadZGMMGqrFVa3Dg+xiBnDcaGdmlUwPAEfYoWMCkdOfwu5d7VtA
         4dtScVVIXSxKnZogXwtegorNdfSvcnAWUcWT23hEIgo2FqeuGiEYhBo1u83rjkTDwf
         EWkGwK8CObC/MAtR5GZaKg7M5H0L8CtRhSIoqvskUtZBu1AkzMyhmZnUtOjnLqwK9N
         EZdHcXMIVBIYmkuDUrwOrbISTepvGp4cuLU3BeWoKLq8OOs/+Zy8XyPOsC/v+aC/UP
         DnpgmpMmdJsqIAXw4N148REagh5cnkCHhAJDODmSkBqD+n2VeVebemQd7St3+h40YD
         fPUQiU/paAs0A==
From:   Benjamin Lee <ben@b1c1l1.com>
To:     netdev@vger.kernel.org
Cc:     Benjamin Lee <ben@b1c1l1.com>
Subject: [PATCH iproute2 1/3] man: tc-htb.8: add missing qdisc parameter r2q
Date:   Wed,  8 Apr 2020 22:12:13 -0700
Message-Id: <20200409051215.27291-2-ben@b1c1l1.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409051215.27291-1-ben@b1c1l1.com>
References: <20200409051215.27291-1-ben@b1c1l1.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description for htb qdisc parameter r2q.

Signed-off-by: Benjamin Lee <ben@b1c1l1.com>
---
 man/man8/tc-htb.8 | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/man/man8/tc-htb.8 b/man/man8/tc-htb.8
index ae310f43..2bcb9c46 100644
--- a/man/man8/tc-htb.8
+++ b/man/man8/tc-htb.8
@@ -10,6 +10,8 @@ classid
 major:
 .B ] htb [ default
 minor-id
+.B ] [ r2q
+divisor
 .B ]
 
 .B tc class ... dev
@@ -93,6 +95,13 @@ will be generated within this qdisc.
 .TP
 default minor-id
 Unclassified traffic gets sent to the class with this minor-id.
+.TP
+r2q divisor
+Divisor used to calculate
+.B quantum
+values for classes.  Classes divide
+.B rate
+by this number.  Default value is 10.
 
 .SH CLASSES
 Classes have a host of parameters to configure their operation.
-- 
2.25.1


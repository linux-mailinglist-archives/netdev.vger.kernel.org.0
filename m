Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E47761A2EC1
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 07:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgDIFSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 01:18:36 -0400
Received: from vip1.b1c1l1.com ([64.57.102.218]:35128 "EHLO vip1.b1c1l1.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgDIFSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 01:18:35 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2020 01:18:34 EDT
Received: by vip1.b1c1l1.com (Postfix) with ESMTPSA id 30E7427373;
        Thu,  9 Apr 2020 05:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=b1c1l1.com; s=alpha;
        t=1586409164; bh=ZhKKZM0nmR02YSNQ0kMMkdyAXcWngRi6Xmmi03KYRJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=cDpEuzaTv6f09R25N/X0Y9ZQ72D/l76rAF48BRJYu3tEi/IPuW0zdxP7ToLlPeYyu
         Pn9L81++cXIrcctH0pcPZRKY62zA1J9kEJH9z2ItC/Zym6uzZ6FrxO5H5dqZphz0s2
         s14D6lv19iQwfuD1rsuV8nWnC7LRLNE5GXeGBsPnIn6HppVCnXn5JfvHvm/z8n1Mwo
         C7+o6g7xExNb22lyJWRfOBqHJBO17RJT2hCcZ+xg1H2DvJBQvujaQgAilwxDKl3w9L
         yojrXaopbqSflhQEXADEYTt7FP+1YcwbWl1GiblY6Ynp2RCDLO8/eOdvAKXfSXdqNS
         Ix3urQLV6geeA==
From:   Benjamin Lee <ben@b1c1l1.com>
To:     netdev@vger.kernel.org
Cc:     Benjamin Lee <ben@b1c1l1.com>
Subject: [PATCH iproute2 3/3] man: tc-htb.8: fix class prio is not mandatory
Date:   Wed,  8 Apr 2020 22:12:15 -0700
Message-Id: <20200409051215.27291-4-ben@b1c1l1.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409051215.27291-1-ben@b1c1l1.com>
References: <20200409051215.27291-1-ben@b1c1l1.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix description for htb class prio parameter to indicate it's not
mandatory.

Signed-off-by: Benjamin Lee <ben@b1c1l1.com>
---
 man/man8/tc-htb.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/tc-htb.8 b/man/man8/tc-htb.8
index 9accfecd..a4162342 100644
--- a/man/man8/tc-htb.8
+++ b/man/man8/tc-htb.8
@@ -120,7 +120,7 @@ class is going to have children.
 .TP
 prio priority
 In the round-robin process, classes with the lowest priority field are tried
-for packets first. Mandatory.
+for packets first.
 
 .TP
 rate rate
-- 
2.25.1


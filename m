Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7E01A2EC2
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 07:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgDIFSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 01:18:35 -0400
Received: from vip1.b1c1l1.com ([64.57.102.218]:35127 "EHLO vip1.b1c1l1.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgDIFSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 01:18:35 -0400
Received: by vip1.b1c1l1.com (Postfix) with ESMTPSA id ED1DD27371;
        Thu,  9 Apr 2020 05:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=b1c1l1.com; s=alpha;
        t=1586409164; bh=6MB2Q1/hiGdvLh3KKkXPmA82Kjh9f5vW7v6D+/rzBzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ql739Pk/ViPQbbo/RjzcSpl+KGJ4o708KvzrPngBM14mBMo7nWZlmSN/2fhcTZnAS
         lzfum6VcBw6e7kge/EJxRW2UYkTPZfFuf8kmCb3wPr51wgYwtUTBfyB57qbqP9vqml
         QBQMOQnHmw/XaCo0ZibS5CIwL+V8UjPGIS2JNDMoGaqsLwwewvqWqnaS9+O+iY0Ar7
         GPjAMFhXsXkWoCX5KvzgsMEnrbREwLrXgyr8Eu3s0FuE3j/qIqR9c/foHuThWYEaoq
         Tw0Hv23bLvglRH97MKeVhFZbInPsDSA3AfWKHBjoSfHOvEIs8xtdIhHIXknBWXI5Cu
         ZD6QTr1olDufg==
From:   Benjamin Lee <ben@b1c1l1.com>
To:     netdev@vger.kernel.org
Cc:     Benjamin Lee <ben@b1c1l1.com>
Subject: [PATCH iproute2 2/3] man: tc-htb.8: add missing class parameter quantum
Date:   Wed,  8 Apr 2020 22:12:14 -0700
Message-Id: <20200409051215.27291-3-ben@b1c1l1.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409051215.27291-1-ben@b1c1l1.com>
References: <20200409051215.27291-1-ben@b1c1l1.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description for htb class parameter quantum.

Signed-off-by: Benjamin Lee <ben@b1c1l1.com>
---
 man/man8/tc-htb.8 | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/man/man8/tc-htb.8 b/man/man8/tc-htb.8
index 2bcb9c46..9accfecd 100644
--- a/man/man8/tc-htb.8
+++ b/man/man8/tc-htb.8
@@ -30,6 +30,8 @@ bytes
 bytes
 .B ] [ prio
 priority
+.B ] [ quantum
+bytes
 .B ]
 
 .SH DESCRIPTION
@@ -143,6 +145,17 @@ Amount of bytes that can be burst at 'infinite' speed, in other words, as fast
 as the interface can transmit them. For perfect evening out, should be equal to at most one average
 packet. Should be at least as high as the highest cburst of all children.
 
+.TP
+quantum bytes
+Number of bytes to serve from this class before the scheduler moves to the next class.
+Default value is
+.B rate
+divided by the qdisc
+.B r2q
+parameter.  If specified,
+.B r2q
+is ignored.
+
 .SH NOTES
 Due to Unix timing constraints, the maximum ceil rate is not infinite and may in fact be quite low. On Intel,
 there are 100 timer events per second, the maximum rate is that rate at which 'burst' bytes are sent each timer tick.
-- 
2.25.1


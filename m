Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504E52EFB0F
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 23:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbhAHWWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 17:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbhAHWWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 17:22:32 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB95C061757
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 14:21:52 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id q18so4684753wrc.20
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 14:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=0mTBQDZkuLh9ZxzNAwIh5jWhJFjVYDUnsJ+nm65pzXQ=;
        b=CM6XbtNWOwi9ZW4bM5s0kwhLP2WttFHKVCIGezPIcmAc7Bb0hVk5rYZ/6oqmnoXHbF
         08BwkpTancjwvNQtIGyT+1s3GFLu1QGMSKiRTEvZTNGyet/WqsbmD/dXCwiUvC/3MmT9
         fkq+CM3ZPGWbqI4fLPSbUIKDFSj4D0W5bWFiCpD4EAieunRDwNqd/WR37f5fOXzHC1g2
         Cc/XEsz/hsqbRt4c5znEZO4JAIwbjEtwk16Fc9XfOKZe6kEJln6b4Td0/N4cLf57qjKs
         xTtjRSldik3uqciXvDwEysyHLG8YHyknE2W1zoz6nNIxehkYcw7u6iZa+ZYDmmuEx3Wi
         cb6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=0mTBQDZkuLh9ZxzNAwIh5jWhJFjVYDUnsJ+nm65pzXQ=;
        b=oWwBAKFYZx1WqsrzstCFw5juI+1puE/VbB0yXQXWmc3j8qGjAi+/0EYVHqpyRzhnQ+
         W9hBqVhOIZV6yrOqDAK/xdgWXU70yWXYCRPmZ0yTFdSUZZWHQcxqjYJ41oP8mJFbrF0B
         nxFV+hosupOlhShdFI+adRM0vc1i6Ke8KrTimRGtHpd3FU9+jZ423M0AX4abv4kW5Hez
         j7gNyTq38gR4m0wozC6zPzmMVkHD8MDNWbspVlX+2JzJAfraO0WlYI7HDK07PfsrCHKM
         pQlDmpq1suzp/GWL4PUj+kX4SXNOVE/q4vOxsO90WTfM/uSeqOVPUwUb3nny1u8rIhaG
         +MGA==
X-Gm-Message-State: AOAM531qVp0QiazGNyfe1ynmaVmsB/E+udvuTvX3JkZkQZb25FvLw7cF
        GNaxagFjD3CYgUkXZPT5d8KUNzG3
X-Google-Smtp-Source: ABdhPJw1cU7e4agOc1E9Gf9WE5RtShAAUI12aL5UvVt7pm0ivyDd/e7bw4lx27nlAqozLcbk4Hwt59Oe
Sender: "doak via sendgmr" <doak@haruspex.c.googlers.com>
X-Received: from haruspex.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11a0])
 (user=doak job=sendgmr) by 2002:a1c:a1c1:: with SMTP id k184mr4781570wme.101.1610144510990;
 Fri, 08 Jan 2021 14:21:50 -0800 (PST)
Date:   Fri,  8 Jan 2021 22:21:04 +0000
Message-Id: <20210108222104.2079472-1-doak@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH] Fix whitespace in uapi/linux/tcp.h.
From:   Danilo Martins <doak@google.com>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Danilo Carvalho <doak@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danilo Carvalho <doak@google.com>

List of things fixed:
  - Two of the socket options were idented with spaces instead of tabs.
  - Trailing whitespace in some lines.
  - Improper spacing around parenthesis caught by checkpatch.pl.
  - Mix of space and tabs in tcp_word_hdr union.

Signed-off-by: Danilo Carvalho <doak@google.com>
---
 include/uapi/linux/tcp.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 13ceeb395eb8..768e93bd5b51 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -51,7 +51,7 @@ struct tcphdr {
 		fin:1;
 #else
 #error	"Adjust your <asm/byteorder.h> defines"
-#endif	
+#endif
 	__be16	window;
 	__sum16	check;
 	__be16	urg_ptr;
@@ -62,14 +62,14 @@ struct tcphdr {
  *  (union is compatible to any of its members)
  *  This means this part of the code is -fstrict-aliasing safe now.
  */
-union tcp_word_hdr { 
+union tcp_word_hdr {
 	struct tcphdr hdr;
-	__be32 		  words[5];
-}; 
+	__be32        words[5];
+};
 
-#define tcp_flag_word(tp) ( ((union tcp_word_hdr *)(tp))->words [3]) 
+#define tcp_flag_word(tp) (((union tcp_word_hdr *)(tp))->words[3])
 
-enum { 
+enum {
 	TCP_FLAG_CWR = __constant_cpu_to_be32(0x00800000),
 	TCP_FLAG_ECE = __constant_cpu_to_be32(0x00400000),
 	TCP_FLAG_URG = __constant_cpu_to_be32(0x00200000),
@@ -80,7 +80,7 @@ enum {
 	TCP_FLAG_FIN = __constant_cpu_to_be32(0x00010000),
 	TCP_RESERVED_BITS = __constant_cpu_to_be32(0x0F000000),
 	TCP_DATA_OFFSET = __constant_cpu_to_be32(0xF0000000)
-}; 
+};
 
 /*
  * TCP general constants
@@ -103,8 +103,8 @@ enum {
 #define TCP_QUICKACK		12	/* Block/reenable quick acks */
 #define TCP_CONGESTION		13	/* Congestion control algorithm */
 #define TCP_MD5SIG		14	/* TCP MD5 Signature (RFC2385) */
-#define TCP_THIN_LINEAR_TIMEOUTS 16      /* Use linear timeouts for thin streams*/
-#define TCP_THIN_DUPACK         17      /* Fast retrans. after 1 dupack */
+#define TCP_THIN_LINEAR_TIMEOUTS 16	/* Use linear timeouts for thin streams*/
+#define TCP_THIN_DUPACK		17	/* Fast retrans. after 1 dupack */
 #define TCP_USER_TIMEOUT	18	/* How long for loss retry before timeout */
 #define TCP_REPAIR		19	/* TCP sock is under repair right now */
 #define TCP_REPAIR_QUEUE	20
-- 
2.30.0.284.gd98b1dd5eaa7-goog


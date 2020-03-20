Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50CEA18C566
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgCTCjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:39:21 -0400
Received: from mail-qk1-f174.google.com ([209.85.222.174]:46738 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCTCjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:39:21 -0400
Received: by mail-qk1-f174.google.com with SMTP id f28so5424318qkk.13
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 19:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=04qconmLEazi5kRkpGbM2edP1QbpR1jlZYfgCe7OLT0=;
        b=KyWPevWBsheyKkyJWa4rZAdEXO93CqEJFh5o3zpC37OnI24vkivd++eEBPBdXXfk0y
         YSEoDgFigyiQ6lxHf8CwqSMUJ5NVtcNLbqnTWkMHQuiBwksiy0p1nwa3yqpE1yq/N1Ep
         r8nD2JVSRtFomxR2xxAmePKP3z5pMiKxAzQzcDyCwJJpIF1BMCfQ98rV7refdnvjRRY9
         kitkHoZmOJ1N7uU9psvldYGN1y7wCkw2E9S75o8pHxbRzBjYbjXDH7j3DzXLPgNEeQWk
         EiONtjFGAf+2mGGeZs89OG0yWoVtlRR42ROjhC1lLCtdik4juMfn+HGoPwDo6XWHNJJJ
         W3Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=04qconmLEazi5kRkpGbM2edP1QbpR1jlZYfgCe7OLT0=;
        b=hsgn12g/OqdL5Vk8YDSmmkXoaLlt6zb2TEo7gE6q9DGJbjajFtbp1X7GqrNjaHMChh
         /m7bf2ILiGGv6TjlFgTAZrgzIaKANa5a1apjPkWxuDOXtcV9D2AO9W8KJ38Mp0KosUIX
         5hJ7lFvYyHcqWnH1uswwKTH0TUea6ON+PpKNG7pLT2U0msvWi9B6r0dYmibmf1uk64F5
         U5M9m502hkBbEz9ctqFx07Zn1MEGz2YDfkg2CXHMWstUCNZ0pBR3fq45I6WZOboOvqks
         9pSUL5HTbGrvM1DhE+GV5JC/1MHoNd+jDmHv0RCgACOE/mT+B3oi+1W6TIqCImw23X2k
         1u9g==
X-Gm-Message-State: ANhLgQ1x5SN4bXB0wA5nbUItXiWxbmWNVuNz4fxcD+uV4BKunpMrH7m7
        /OLMUIsY/1KdpRuIS35LY08=
X-Google-Smtp-Source: ADFU+vtM1XwExzkm0FAZbcz6r/dyc8f7MnwxTuzwCJdtLLmqdI+Abec615GiIvdo9POb7W5yRgkPIw==
X-Received: by 2002:ae9:f40b:: with SMTP id y11mr6114823qkl.237.1584671960438;
        Thu, 19 Mar 2020 19:39:20 -0700 (PDT)
Received: from localhost.localdomain (69-196-128-153.dsl.teksavvy.com. [69.196.128.153])
        by smtp.gmail.com with ESMTPSA id d9sm2979465qth.34.2020.03.19.19.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 19:39:19 -0700 (PDT)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCHv2 net-next 1/5] include: uapi: linux: add rpl sr header definition
Date:   Thu, 19 Mar 2020 22:38:57 -0400
Message-Id: <20200320023901.31129-2-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200320023901.31129-1-alex.aring@gmail.com>
References: <20200320023901.31129-1-alex.aring@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a uapi header for rpl struct definition. The segments
data can be accessed over rpl_segaddr or rpl_segdata macros. In case of
compri and compre is zero the segment data is not compressed and can be
accessed by rpl_segaddr. In the other case the compressed data can be
accessed by rpl_segdata and interpreted as byte array.

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
---
 include/uapi/linux/rpl.h | 48 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 include/uapi/linux/rpl.h

diff --git a/include/uapi/linux/rpl.h b/include/uapi/linux/rpl.h
new file mode 100644
index 000000000000..1dccb55cf8c6
--- /dev/null
+++ b/include/uapi/linux/rpl.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ *  IPv6 RPL-SR implementation
+ *
+ *  Author:
+ *  (C) 2020 Alexander Aring <alex.aring@gmail.com>
+ */
+
+#ifndef _UAPI_LINUX_RPL_H
+#define _UAPI_LINUX_RPL_H
+
+#include <asm/byteorder.h>
+#include <linux/types.h>
+#include <linux/in6.h>
+
+/*
+ * RPL SR Header
+ */
+struct ipv6_rpl_sr_hdr {
+	__u8	nexthdr;
+	__u8	hdrlen;
+	__u8	type;
+	__u8	segments_left;
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u32	cmpre:4,
+		cmpri:4,
+		reserved:4,
+		pad:4,
+		reserved1:16;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u32	reserved:20,
+		pad:4,
+		cmpri:4,
+		cmpre:4;
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
+
+	union {
+		struct in6_addr addr[0];
+		__u8 data[0];
+	} segments;
+} __attribute__((packed));
+
+#define rpl_segaddr	segments.addr
+#define rpl_segdata	segments.data
+
+#endif
-- 
2.20.1


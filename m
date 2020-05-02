Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079311C28BB
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 00:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgEBW6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 18:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728577AbgEBW6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 18:58:54 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD4BC061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 15:58:54 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id w29so10968332qtv.3
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 15:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RM4pXNTHWpWFkcg8/IMuDbtSOBbIDPJCtAEgS4MZtbE=;
        b=V5HUz+PAdShTXcWGM36HFQ210m9/gHrnjh74Hpqr5eQV3gCmX1pA1Bp0S0Y5FVtFzG
         hQtsQBWELh7gs8DrixZF6MsZKAZBbDxZfgDo1coCw+EahUWq/ke/zPsdEV9aUNjaJU1q
         7Vub+JNMZ0vwbgE7RHiR2ftPi8N2yYsloqNPaOOYyMYtGW5pCcugkJKBJeOw6Si9Fkzu
         xp2M8cJZVkEenhHdDDqQRu/vtUsrFwvKdO7sIVZ+FxP3/QazFBJCe+lUZOIGtBYrmAxl
         zegfyAASudiR8RqEiNN7rtqpljLC3UuCljLOffxG1Co7aq+C4l96kHvb8HxYYxAKmzf2
         5ESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RM4pXNTHWpWFkcg8/IMuDbtSOBbIDPJCtAEgS4MZtbE=;
        b=e16ZbmegDf15QkYtaWtxZnQ9MVDzmofra338bB2SWdiH7tcrVsOyNIP4Pmpsb/rtw8
         QTr0bt4OKW/cBMRieGEG+4xj4gx+vRA6aUU030hNXoDTeoyATaAd5GymDkNhtqnRcZci
         4x0EqHjDLFUkgorXsf2CQeSsKDnHdUNeL9bbPaDqCH7IPxJqAGVtXSitc6mdx2UIZhyN
         Cjc0XZaTUUd+wmqQY/SDMCTbU7BXDv1uEW3tCBlD9WClo6k5iCw+qW25nrZGlVHB72Gb
         4KC39knsxuD0NPrf6/gNS95ObS6ilHZSeS3Ddv9LSI3+JYc38O91ose262s/7oPMC0lC
         tpNg==
X-Gm-Message-State: AGi0PuaYZ5+OyQSbDck2LIvaRqxIGO/s9u3O1SqYyfJMymg3QBwbsuLK
        GdR0J2Ecnbdk13GkZIEAeFSF3fA+
X-Google-Smtp-Source: APiQypLAH6osHqUOt/5QC8HvosKUqKBaXvsjS5CUMGo4axCgvrn4AbOhhmJmhFsHMdL75COg2oMveg==
X-Received: by 2002:ac8:668b:: with SMTP id d11mr10247330qtp.285.1588460332969;
        Sat, 02 May 2020 15:58:52 -0700 (PDT)
Received: from localhost.localdomain ([45.72.161.207])
        by smtp.gmail.com with ESMTPSA id p22sm6784464qte.2.2020.05.02.15.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 15:58:52 -0700 (PDT)
From:   Alexander Aring <alex.aring@gmail.com>
To:     netdev@vger.kernel.org
Cc:     mcr@sandelman.ca, stefan@datenfreihafen.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCH iproute2-next 1/2] uapi: updates to lwtunnel and rpl iptunnel
Date:   Sat,  2 May 2020 18:58:33 -0400
Message-Id: <20200502225834.28938-1-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update uapi headers.

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
---
 include/uapi/linux/rpl.h          | 48 +++++++++++++++++++++++++++++++
 include/uapi/linux/rpl_iptunnel.h | 21 ++++++++++++++
 2 files changed, 69 insertions(+)
 create mode 100644 include/uapi/linux/rpl.h
 create mode 100644 include/uapi/linux/rpl_iptunnel.h

diff --git a/include/uapi/linux/rpl.h b/include/uapi/linux/rpl.h
new file mode 100644
index 00000000..c24b64cd
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
+#ifndef _LINUX_RPL_H
+#define _LINUX_RPL_H
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
diff --git a/include/uapi/linux/rpl_iptunnel.h b/include/uapi/linux/rpl_iptunnel.h
new file mode 100644
index 00000000..c255b92c
--- /dev/null
+++ b/include/uapi/linux/rpl_iptunnel.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ *  IPv6 RPL-SR implementation
+ *
+ *  Author:
+ *  (C) 2020 Alexander Aring <alex.aring@gmail.com>
+ */
+
+#ifndef _LINUX_RPL_IPTUNNEL_H
+#define _LINUX_RPL_IPTUNNEL_H
+
+enum {
+	RPL_IPTUNNEL_UNSPEC,
+	RPL_IPTUNNEL_SRH,
+	__RPL_IPTUNNEL_MAX,
+};
+#define RPL_IPTUNNEL_MAX (__RPL_IPTUNNEL_MAX - 1)
+
+#define RPL_IPTUNNEL_SRH_SIZE(srh) (((srh)->hdrlen + 1) << 3)
+
+#endif
-- 
2.20.1


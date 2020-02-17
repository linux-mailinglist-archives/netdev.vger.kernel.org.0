Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143A2161D62
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgBQWgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:36:53 -0500
Received: from mail-qv1-f47.google.com ([209.85.219.47]:36184 "EHLO
        mail-qv1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgBQWgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:36:52 -0500
Received: by mail-qv1-f47.google.com with SMTP id db9so8304852qvb.3
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 14:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=04qconmLEazi5kRkpGbM2edP1QbpR1jlZYfgCe7OLT0=;
        b=qeU8AYJlgVoWA7Y8PW4kl3b4LkEyhmNWfCODdHbLFcvijKimP5/KVAKpTmn2KLfzmm
         v8aniRftIQdTTs/rYSX9atvVhZ7xJBYkVhgFRqEEG8bMtou/BGEEdXp7maFbUHKhmeva
         xeoI7ru+I9EEkOCs56FFJ+wYppsQmNW5/sm9SJlYzzS3G4hR+YezBVvlaPpd9gd3Jcjo
         KCIFZaYEfpO2dec8MgGKcbibDKnH0R4pu9M0Lro/X3uDtmpSOoTaQsa3cJkQm6Dfz9YG
         qTS4FwPbx7JMPQfpcm04sRzerfuqrsRDgscqD6gZfGQ4VoRuyifM9HIkGXSJFDQ4TQ3G
         fa1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=04qconmLEazi5kRkpGbM2edP1QbpR1jlZYfgCe7OLT0=;
        b=B0vh5UHB3AFSeCMzdtMNjHxaKfk5nPGjacNDvfrTitDlgdcD9R8tC9J/Ajsank2PcH
         4fKWIRcSECUfcSjQqONlGv9RLx3pc9EiVDzvX0jD5/htTxzKFfRpKWcyxtZfSw2Vk5OP
         77/FkOi287DUX4gZ68hcs6zaeqWCc/7SddIwWHhAGgJ9Jfv1enKWAoJNUC7eWqrV6a+N
         TGPh501YTRU7+ThSj+kEyGDlBtwGhYn9/S0Isqtlvh8NXT9lonj+KOQxf35kGaUFDOsN
         d74Lh6K6cte10pjZn37isDibcUihyC7T9FhaBZVBnqfim067+2+UT5Y1we09Ge/kPXfI
         bk3g==
X-Gm-Message-State: APjAAAXOvmITOyirPKUVJlyTHkXCNQ4QrRNmMJaIFocCRH2EXePUFFEA
        xwGFIJi48tdS4ko8RoLh37I=
X-Google-Smtp-Source: APXvYqyBx4g8c9Sm5/3P8fyGV70F+XzyaJ8NIWZQdRzLtAPH8gQCn3cqgeE7VwGByTm4e+ae2n3Srg==
X-Received: by 2002:ad4:59c2:: with SMTP id el2mr13753967qvb.152.1581979010477;
        Mon, 17 Feb 2020 14:36:50 -0800 (PST)
Received: from localhost.localdomain ([216.154.21.195])
        by smtp.gmail.com with ESMTPSA id a2sm964031qka.75.2020.02.17.14.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 14:36:50 -0800 (PST)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PACTH net-next 1/5] include: uapi: linux: add rpl sr header definition
Date:   Mon, 17 Feb 2020 17:35:37 -0500
Message-Id: <20200217223541.18862-2-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200217223541.18862-1-alex.aring@gmail.com>
References: <20200217223541.18862-1-alex.aring@gmail.com>
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


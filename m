Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E74711960C7
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgC0WAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:00:46 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]:43994 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgC0WAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:00:46 -0400
Received: by mail-qk1-f169.google.com with SMTP id o10so12491030qki.10
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 15:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=04qconmLEazi5kRkpGbM2edP1QbpR1jlZYfgCe7OLT0=;
        b=FWP9JUqZksFgdGUN3gB8r9gM3bHEmvad+T9UZ81m/UQyDjdrGgF2wBGEsDIDFgooyu
         m4wZXs/G4U7Ummdbxle1ZjFMmYrehjcKVetEZR4pNk+2w4MZk5gQ3QrcXSBacF3ErD37
         8YM37pE3DL/uqfDgeAgi2rnLV6sufmrs0WlBrw4YWIwZcHl0eGTpvRC6akL5/XsDbKb2
         vCCIhN0z+pLcy2CjIfCpiLU0HYhavUavdrR4Vo66UVu/b7NTAaGK4qyF96AenYWHlDJz
         d9lALffWJ8qWFdplwsEGrTo0XAkEkG8QubhHHzkufF3uUbVMBy/UjO0RrEVfkah2Jl9b
         kbFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=04qconmLEazi5kRkpGbM2edP1QbpR1jlZYfgCe7OLT0=;
        b=Xgc+2z2GppelryU1+UjkAakJBzUrnLW0D2Jeb1TlZRveIqYPNdd+GSf9cXIANlL/F+
         dUaRyROCK1leEdIAUP+PIL6mzWKIujusfAJHFrYMAQ0NdIWu/lnYv2xYu+JMsLr9zuKW
         7fiJQvrrBDsbA146eREqCZKMOxcf9XvOKiCVJHoWaE3VwCMsy3j0X5LUL2Wn8UlSVIah
         xfhI9GZGgLGcDANMHhVwRnl8fn4KQ9VU2zfuMW8kbu8Af1q5H4p+8uwDoo7X9EyWvlbZ
         3gi6xbym15KV/b07q0S64+n1ONyLRbaepOMFkHKaFT1SWHTgssz3LB/K3LZ+1TfiPODm
         3VnQ==
X-Gm-Message-State: ANhLgQ0X+PyZC3pNfQH01imSkWzfTjt795pClc/UOkDsQ0Hmh3eL29t4
        xu95tDRR5ScQw3J1NtowH3Y=
X-Google-Smtp-Source: ADFU+vs4sPgNJoPD1REd6GegN+gVUD7ea7CdZWLfgAs5EOh8fbuTRIumZ13MleGkwaX11/FIKGNiKg==
X-Received: by 2002:a37:b986:: with SMTP id j128mr1471193qkf.109.1585346445166;
        Fri, 27 Mar 2020 15:00:45 -0700 (PDT)
Received: from localhost.localdomain ([45.72.142.47])
        by smtp.gmail.com with ESMTPSA id v20sm5073659qth.10.2020.03.27.15.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 15:00:44 -0700 (PDT)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCHv3 net-next 1/5] include: uapi: linux: add rpl sr header definition
Date:   Fri, 27 Mar 2020 18:00:18 -0400
Message-Id: <20200327220022.15220-2-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200327220022.15220-1-alex.aring@gmail.com>
References: <20200327220022.15220-1-alex.aring@gmail.com>
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


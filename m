Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B8F161D8C
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgBQWpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:45:17 -0500
Received: from mail-qv1-f46.google.com ([209.85.219.46]:40372 "EHLO
        mail-qv1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgBQWpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:45:17 -0500
Received: by mail-qv1-f46.google.com with SMTP id q9so7383223qvu.7
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 14:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gSXQTJ9buN/rNeDG6UuDHZ+3X1XRhIKLh13CScoF424=;
        b=NEDMeCKmmDx8co/hUZEmiQBuczc5gcDursv2UeVouBpkRW3dXR3UO2mBYM4veEVRLC
         thyhSATGqbuiyxGqAvwyVgI77HiCz5wWB53Kqme+thRBcOgMEGXZkQ09FVnSosg07Q7F
         Zg+6GQBjcr99US9q2nKuKtNapZA+MgTXpkyFtnKa7gW+wrhhqTt3TVmfhDJ+lmlB3hAD
         j52Nmmvzf9aDXPC9lVMnv6mWh/DB+DnRDc4+Np7YRAKG59zK9uK6TwlEx9oLqpgyGRRZ
         UuJBc9TEvNU+tgbFP2Pr3aWjv5fYZbK/+6t9lsHOzpqA8ZWFSKolaScF3KRpb8Wi6pnt
         ypTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gSXQTJ9buN/rNeDG6UuDHZ+3X1XRhIKLh13CScoF424=;
        b=JAiySz+qboSyQf6P3zzXyzh+WCF4R70qXmaI0dQIpZSNtPIunvMA4izDcJR6wPJ4PL
         F49PymKkiEuQk3peX+nO4ENcjnionJ0OFFbC4epDlPuZvnIS4GZ+sTR/AudvHfu/YM/V
         Gq7Sijf9T0n7Sh5FyMq2nGmW7qy74IuKJ/GUVgCC3Us4snHRUa+Vm4XFlBB6a1Ecs1Hv
         D9hMX0WlTyXoD2QOlTUjhMPeGDwZno891qs5F7H4eXpiRv3qvBlW0APa6HitWii3awb7
         RcEK0No3EZOZnaUrlTtYn9BdelGY+wOujokHOn59wAMZNZCAQmMupWd//+TqwPJVBGKL
         zI2g==
X-Gm-Message-State: APjAAAXlcMlKpEoPsJonG93KX+B0eyUL354rw400CV03rCLBjWOtQGK9
        9q3/mapX1pb3XzWkM45JGx8=
X-Google-Smtp-Source: APXvYqyzbY4c2HzjI91SEfp2lTn1DgXXe5IQcepCzHM5rcUmeQkvQcRkheAmIfFP85eWlcpYLFp+ew==
X-Received: by 2002:a05:6214:3aa:: with SMTP id m10mr14535171qvy.125.1581979516133;
        Mon, 17 Feb 2020 14:45:16 -0800 (PST)
Received: from localhost.localdomain ([216.154.21.195])
        by smtp.gmail.com with ESMTPSA id w21sm984725qth.17.2020.02.17.14.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 14:45:15 -0800 (PST)
From:   Alexander Aring <alex.aring@gmail.com>
To:     stephen@networkplumber.org
Cc:     dsahern@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [RFC iproute2-next 1/2] uapi: updates to lwtunnel and rpl iptunnel
Date:   Mon, 17 Feb 2020 17:44:53 -0500
Message-Id: <20200217224454.22297-1-alex.aring@gmail.com>
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
 include/uapi/linux/lwtunnel.h     |  1 +
 include/uapi/linux/rpl.h          | 48 +++++++++++++++++++++++++++++++
 include/uapi/linux/rpl_iptunnel.h | 27 +++++++++++++++++
 3 files changed, 76 insertions(+)
 create mode 100644 include/uapi/linux/rpl.h
 create mode 100644 include/uapi/linux/rpl_iptunnel.h

diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
index 532c9370..b7c0191f 100644
--- a/include/uapi/linux/lwtunnel.h
+++ b/include/uapi/linux/lwtunnel.h
@@ -13,6 +13,7 @@ enum lwtunnel_encap_types {
 	LWTUNNEL_ENCAP_SEG6,
 	LWTUNNEL_ENCAP_BPF,
 	LWTUNNEL_ENCAP_SEG6_LOCAL,
+	LWTUNNEL_ENCAP_RPL,
 	__LWTUNNEL_ENCAP_MAX,
 };
 
diff --git a/include/uapi/linux/rpl.h b/include/uapi/linux/rpl.h
new file mode 100644
index 00000000..a55cbb1c
--- /dev/null
+++ b/include/uapi/linux/rpl.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ *  IPv6 RPL-SR implementation
+ *
+ *  Author:
+ *  Alexander Aring <alex.aring@gmail.com>
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
index 00000000..f2839b68
--- /dev/null
+++ b/include/uapi/linux/rpl_iptunnel.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ *  IPv6 RPL-SR implementation
+ *
+ *  Author:
+ *  Alexander Aring <alex.aring@gmail.com>
+ *
+ *
+ *  This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
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


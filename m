Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBAEA2D96A
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfE2Js5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:48:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50334 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfE2Js4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:48:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4T9dENL160939;
        Wed, 29 May 2019 09:48:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=CAdmMbnKLA0aDQzFUwLM9B7Jz5Fvv7zc5ulLdPGF2XA=;
 b=e1cjVjnSw5OnZCtVjPofp3KAc8Nlm3dpTdGE+4DzW0nSGjScq3o+NYss8bebZEYRWjb+
 VXTPFskWzzGtrLjwsqQDXO84OU/Gtm4uplsYyFIywD26RFYd5yF8hHDNFvOdZ/qBUqma
 nlty/xCxls9d53PGYcmCB62xUA9bLLZX6rgSppJy6vhG+PCc2sFAWFJomCp0M8WjE3aq
 2HMG+e9nhdtRDFYN+2YEwWR7eh4k0N6UkyNYYRoPm3bVmruSyCR3F9MPT/evNZpxZZVU
 hS/980JYLQrC/4uzW8T9E5JMuXxy7zviWHmQB8HV/8XQSrwC/c7lGKd6pKaBwX9x6gJb NA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2spw4tgk5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 09:48:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4T9lp3r184396;
        Wed, 29 May 2019 09:48:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2srbdx9mku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 09:48:24 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4T9mMpb030892;
        Wed, 29 May 2019 09:48:22 GMT
Received: from dhcp-10-175-207-187.vpn.oracle.com (/10.175.207.187)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 02:48:22 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        davem@davemloft.net, nicolas.dichtel@6wind.com,
        ktkhai@virtuozzo.com, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next] selftests/bpf: fix compilation error for flow_dissector.c
Date:   Wed, 29 May 2019 10:48:14 +0100
Message-Id: <1559123294-2027-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9271 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9271 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290065
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building the tools/testing/selftest/bpf subdirectory,
(running both a local directory "make" and a
"make -C tools/testing/selftests/bpf") I keep hitting the
following compilation error:

prog_tests/flow_dissector.c: In function ‘create_tap’:
prog_tests/flow_dissector.c:150:38: error: ‘IFF_NAPI’ undeclared (first
use in this function)
   .ifr_flags = IFF_TAP | IFF_NO_PI | IFF_NAPI | IFF_NAPI_FRAGS,
                                      ^
prog_tests/flow_dissector.c:150:38: note: each undeclared identifier is
reported only once for each function it appears in
prog_tests/flow_dissector.c:150:49: error: ‘IFF_NAPI_FRAGS’ undeclared

Adding include/uapi/linux/if_tun.h to tools/include/uapi/linux
resolves the problem and ensures the compilation of the file
does not depend on having up-to-date kernel headers locally.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/include/uapi/linux/if_tun.h | 114 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)
 create mode 100644 tools/include/uapi/linux/if_tun.h

diff --git a/tools/include/uapi/linux/if_tun.h b/tools/include/uapi/linux/if_tun.h
new file mode 100644
index 0000000..454ae31
--- /dev/null
+++ b/tools/include/uapi/linux/if_tun.h
@@ -0,0 +1,114 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ *  Universal TUN/TAP device driver.
+ *  Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#ifndef _UAPI__IF_TUN_H
+#define _UAPI__IF_TUN_H
+
+#include <linux/types.h>
+#include <linux/if_ether.h>
+#include <linux/filter.h>
+
+/* Read queue size */
+#define TUN_READQ_SIZE	500
+/* TUN device type flags: deprecated. Use IFF_TUN/IFF_TAP instead. */
+#define TUN_TUN_DEV 	IFF_TUN
+#define TUN_TAP_DEV	IFF_TAP
+#define TUN_TYPE_MASK   0x000f
+
+/* Ioctl defines */
+#define TUNSETNOCSUM  _IOW('T', 200, int) 
+#define TUNSETDEBUG   _IOW('T', 201, int) 
+#define TUNSETIFF     _IOW('T', 202, int) 
+#define TUNSETPERSIST _IOW('T', 203, int) 
+#define TUNSETOWNER   _IOW('T', 204, int)
+#define TUNSETLINK    _IOW('T', 205, int)
+#define TUNSETGROUP   _IOW('T', 206, int)
+#define TUNGETFEATURES _IOR('T', 207, unsigned int)
+#define TUNSETOFFLOAD  _IOW('T', 208, unsigned int)
+#define TUNSETTXFILTER _IOW('T', 209, unsigned int)
+#define TUNGETIFF      _IOR('T', 210, unsigned int)
+#define TUNGETSNDBUF   _IOR('T', 211, int)
+#define TUNSETSNDBUF   _IOW('T', 212, int)
+#define TUNATTACHFILTER _IOW('T', 213, struct sock_fprog)
+#define TUNDETACHFILTER _IOW('T', 214, struct sock_fprog)
+#define TUNGETVNETHDRSZ _IOR('T', 215, int)
+#define TUNSETVNETHDRSZ _IOW('T', 216, int)
+#define TUNSETQUEUE  _IOW('T', 217, int)
+#define TUNSETIFINDEX	_IOW('T', 218, unsigned int)
+#define TUNGETFILTER _IOR('T', 219, struct sock_fprog)
+#define TUNSETVNETLE _IOW('T', 220, int)
+#define TUNGETVNETLE _IOR('T', 221, int)
+/* The TUNSETVNETBE and TUNGETVNETBE ioctls are for cross-endian support on
+ * little-endian hosts. Not all kernel configurations support them, but all
+ * configurations that support SET also support GET.
+ */
+#define TUNSETVNETBE _IOW('T', 222, int)
+#define TUNGETVNETBE _IOR('T', 223, int)
+#define TUNSETSTEERINGEBPF _IOR('T', 224, int)
+#define TUNSETFILTEREBPF _IOR('T', 225, int)
+#define TUNSETCARRIER _IOW('T', 226, int)
+#define TUNGETDEVNETNS _IO('T', 227)
+
+/* TUNSETIFF ifr flags */
+#define IFF_TUN		0x0001
+#define IFF_TAP		0x0002
+#define IFF_NAPI	0x0010
+#define IFF_NAPI_FRAGS	0x0020
+#define IFF_NO_PI	0x1000
+/* This flag has no real effect */
+#define IFF_ONE_QUEUE	0x2000
+#define IFF_VNET_HDR	0x4000
+#define IFF_TUN_EXCL	0x8000
+#define IFF_MULTI_QUEUE 0x0100
+#define IFF_ATTACH_QUEUE 0x0200
+#define IFF_DETACH_QUEUE 0x0400
+/* read-only flag */
+#define IFF_PERSIST	0x0800
+#define IFF_NOFILTER	0x1000
+
+/* Socket options */
+#define TUN_TX_TIMESTAMP 1
+
+/* Features for GSO (TUNSETOFFLOAD). */
+#define TUN_F_CSUM	0x01	/* You can hand me unchecksummed packets. */
+#define TUN_F_TSO4	0x02	/* I can handle TSO for IPv4 packets */
+#define TUN_F_TSO6	0x04	/* I can handle TSO for IPv6 packets */
+#define TUN_F_TSO_ECN	0x08	/* I can handle TSO with ECN bits. */
+#define TUN_F_UFO	0x10	/* I can handle UFO packets */
+
+/* Protocol info prepended to the packets (when IFF_NO_PI is not set) */
+#define TUN_PKT_STRIP	0x0001
+struct tun_pi {
+	__u16  flags;
+	__be16 proto;
+};
+
+/*
+ * Filter spec (used for SETXXFILTER ioctls)
+ * This stuff is applicable only to the TAP (Ethernet) devices.
+ * If the count is zero the filter is disabled and the driver accepts
+ * all packets (promisc mode).
+ * If the filter is enabled in order to accept broadcast packets
+ * broadcast addr must be explicitly included in the addr list.
+ */
+#define TUN_FLT_ALLMULTI 0x0001 /* Accept all multicast packets */
+struct tun_filter {
+	__u16  flags; /* TUN_FLT_ flags see above */
+	__u16  count; /* Number of addresses */
+	__u8   addr[0][ETH_ALEN];
+};
+
+#endif /* _UAPI__IF_TUN_H */
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A411B5CB5
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 15:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgDWNjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 09:39:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60727 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728153AbgDWNjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 09:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587649160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rZTwgMLw3caVYRs40064X5V57GuxT454mQdHskHDEwE=;
        b=EaecVmlG0AOKlCIIB71LsWDi64RJf4cEe6bc/mdHSdF64hqMbM1DCrOtQvdKRno1+PAfva
        9Wwfqf0lvLs7eqcJ6riMgxCHIdqaaNMgRuFesyiVCnPTx+hM3XAS+ZoEfUeM72FTZMrRMx
        x5cgrtyA3sdlqwxCoAmVdferT52zBxg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-Rl6HRX7SPpWGloYWRqp_Xw-1; Thu, 23 Apr 2020 09:39:18 -0400
X-MC-Unique: Rl6HRX7SPpWGloYWRqp_Xw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8C3018FE866;
        Thu, 23 Apr 2020 13:39:17 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-154.ams2.redhat.com [10.36.114.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8ED321002380;
        Thu, 23 Apr 2020 13:39:16 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     dcaratti@redhat.com
Subject: [PATCH iproute2-next 1/4] uapi: update linux/mptcp.h
Date:   Thu, 23 Apr 2020 15:37:07 +0200
Message-Id: <211c1fcffddd7b820ea2777f9b114d748853c8fc.1587572928.git.pabeni@redhat.com>
In-Reply-To: <cover.1587572928.git.pabeni@redhat.com>
References: <cover.1587572928.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/uapi/linux/mptcp.h | 89 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 include/uapi/linux/mptcp.h

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
new file mode 100644
index 00000000..5f2c7708
--- /dev/null
+++ b/include/uapi/linux/mptcp.h
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+#ifndef _UAPI_MPTCP_H
+#define _UAPI_MPTCP_H
+
+#include <linux/const.h>
+#include <linux/types.h>
+
+#define MPTCP_SUBFLOW_FLAG_MCAP_REM		_BITUL(0)
+#define MPTCP_SUBFLOW_FLAG_MCAP_LOC		_BITUL(1)
+#define MPTCP_SUBFLOW_FLAG_JOIN_REM		_BITUL(2)
+#define MPTCP_SUBFLOW_FLAG_JOIN_LOC		_BITUL(3)
+#define MPTCP_SUBFLOW_FLAG_BKUP_REM		_BITUL(4)
+#define MPTCP_SUBFLOW_FLAG_BKUP_LOC		_BITUL(5)
+#define MPTCP_SUBFLOW_FLAG_FULLY_ESTABLISHED	_BITUL(6)
+#define MPTCP_SUBFLOW_FLAG_CONNECTED		_BITUL(7)
+#define MPTCP_SUBFLOW_FLAG_MAPVALID		_BITUL(8)
+
+enum {
+	MPTCP_SUBFLOW_ATTR_UNSPEC,
+	MPTCP_SUBFLOW_ATTR_TOKEN_REM,
+	MPTCP_SUBFLOW_ATTR_TOKEN_LOC,
+	MPTCP_SUBFLOW_ATTR_RELWRITE_SEQ,
+	MPTCP_SUBFLOW_ATTR_MAP_SEQ,
+	MPTCP_SUBFLOW_ATTR_MAP_SFSEQ,
+	MPTCP_SUBFLOW_ATTR_SSN_OFFSET,
+	MPTCP_SUBFLOW_ATTR_MAP_DATALEN,
+	MPTCP_SUBFLOW_ATTR_FLAGS,
+	MPTCP_SUBFLOW_ATTR_ID_REM,
+	MPTCP_SUBFLOW_ATTR_ID_LOC,
+	MPTCP_SUBFLOW_ATTR_PAD,
+	__MPTCP_SUBFLOW_ATTR_MAX
+};
+
+#define MPTCP_SUBFLOW_ATTR_MAX (__MPTCP_SUBFLOW_ATTR_MAX - 1)
+
+/* netlink interface */
+#define MPTCP_PM_NAME		"mptcp_pm"
+#define MPTCP_PM_CMD_GRP_NAME	"mptcp_pm_cmds"
+#define MPTCP_PM_VER		0x1
+
+/*
+ * ATTR types defined for MPTCP
+ */
+enum {
+	MPTCP_PM_ATTR_UNSPEC,
+
+	MPTCP_PM_ATTR_ADDR,				/* nested address */
+	MPTCP_PM_ATTR_RCV_ADD_ADDRS,			/* u32 */
+	MPTCP_PM_ATTR_SUBFLOWS,				/* u32 */
+
+	__MPTCP_PM_ATTR_MAX
+};
+
+#define MPTCP_PM_ATTR_MAX (__MPTCP_PM_ATTR_MAX - 1)
+
+enum {
+	MPTCP_PM_ADDR_ATTR_UNSPEC,
+
+	MPTCP_PM_ADDR_ATTR_FAMILY,			/* u16 */
+	MPTCP_PM_ADDR_ATTR_ID,				/* u8 */
+	MPTCP_PM_ADDR_ATTR_ADDR4,			/* struct in_addr */
+	MPTCP_PM_ADDR_ATTR_ADDR6,			/* struct in6_addr */
+	MPTCP_PM_ADDR_ATTR_PORT,			/* u16 */
+	MPTCP_PM_ADDR_ATTR_FLAGS,			/* u32 */
+	MPTCP_PM_ADDR_ATTR_IF_IDX,			/* s32 */
+
+	__MPTCP_PM_ADDR_ATTR_MAX
+};
+
+#define MPTCP_PM_ADDR_ATTR_MAX (__MPTCP_PM_ADDR_ATTR_MAX - 1)
+
+#define MPTCP_PM_ADDR_FLAG_SIGNAL			(1 << 0)
+#define MPTCP_PM_ADDR_FLAG_SUBFLOW			(1 << 1)
+#define MPTCP_PM_ADDR_FLAG_BACKUP			(1 << 2)
+
+enum {
+	MPTCP_PM_CMD_UNSPEC,
+
+	MPTCP_PM_CMD_ADD_ADDR,
+	MPTCP_PM_CMD_DEL_ADDR,
+	MPTCP_PM_CMD_GET_ADDR,
+	MPTCP_PM_CMD_FLUSH_ADDRS,
+	MPTCP_PM_CMD_SET_LIMITS,
+	MPTCP_PM_CMD_GET_LIMITS,
+
+	__MPTCP_PM_CMD_AFTER_LAST
+};
+
+#endif /* _UAPI_MPTCP_H */
--=20
2.21.1


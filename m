Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944932A4FAC
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgKCTFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:05:37 -0500
Received: from mga12.intel.com ([192.55.52.136]:49624 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729596AbgKCTF0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:05:26 -0500
IronPort-SDR: jcrSS942onwmChazvmQD6m9BtcqxVqYPfHEkZqKQDOK6i4OtKOW+bq94QBaL/o7ls0IVYuHYQ+
 KF6HPlBB84tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="148386936"
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="148386936"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 11:05:15 -0800
IronPort-SDR: H3M3Txunn8qciUsb7XmHM+qBfh5qXpW6Y8ycSSf5s2Ec+ox1PLp+VPA8Lq5Qy8ISRQ9l94qgha
 +GXtgiJ8vXWw==
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="352430152"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.18.188])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 11:05:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, kuba@kernel.org, davem@davemloft.net,
        Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH net-next v2 6/7] docs: networking: mptcp: Add MPTCP sysctl entries
Date:   Tue,  3 Nov 2020 11:05:08 -0800
Message-Id: <20201103190509.27416-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103190509.27416-1-mathew.j.martineau@linux.intel.com>
References: <20201103190509.27416-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the two MPTCP sysctls, what the values mean, and the default
settings.

Acked-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 Documentation/networking/index.rst        |  1 +
 Documentation/networking/mptcp-sysctl.rst | 26 +++++++++++++++++++++++
 MAINTAINERS                               |  1 +
 3 files changed, 28 insertions(+)
 create mode 100644 Documentation/networking/mptcp-sysctl.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 63ef386afd0a..70c71c9206e2 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -70,6 +70,7 @@ Contents:
    lapb-module
    mac80211-injection
    mpls-sysctl
+   mptcp-sysctl
    multiqueue
    netconsole
    netdev-features
diff --git a/Documentation/networking/mptcp-sysctl.rst b/Documentation/networking/mptcp-sysctl.rst
new file mode 100644
index 000000000000..6af0196c4297
--- /dev/null
+++ b/Documentation/networking/mptcp-sysctl.rst
@@ -0,0 +1,26 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================
+MPTCP Sysfs variables
+=====================
+
+/proc/sys/net/mptcp/* Variables
+===============================
+
+enabled - INTEGER
+	Control whether MPTCP sockets can be created.
+
+	MPTCP sockets can be created if the value is nonzero. This is
+	a per-namespace sysctl.
+
+	Default: 1
+
+add_addr_timeout - INTEGER (seconds)
+	Set the timeout after which an ADD_ADDR control message will be
+	resent to an MPTCP peer that has not acknowledged a previous
+	ADD_ADDR message.
+
+	The default value matches TCP_RTO_MAX. This is a per-namespace
+	sysctl.
+
+	Default: 120
diff --git a/MAINTAINERS b/MAINTAINERS
index 17f5571788c9..badaaa815aa3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12265,6 +12265,7 @@ L:	mptcp@lists.01.org
 S:	Maintained
 W:	https://github.com/multipath-tcp/mptcp_net-next/wiki
 B:	https://github.com/multipath-tcp/mptcp_net-next/issues
+F:	Documentation/networking/mptcp-sysctl.rst
 F:	include/net/mptcp.h
 F:	include/uapi/linux/mptcp.h
 F:	net/mptcp/
-- 
2.29.2


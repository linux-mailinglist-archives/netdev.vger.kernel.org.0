Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A5D49582
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfFQW6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:58:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:10994 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbfFQW6t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:49 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:49 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 02/33] tcp: Define IPPROTO_MPTCP
Date:   Mon, 17 Jun 2019 15:57:37 -0700
Message-Id: <20190617225808.665-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To open a MPTCP socket with socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP),
IPPROTO_MPTCP needs a value that differs from IPPROTO_TCP. The existing
IPPROTO numbers mostly map directly to IANA-specified protocol numbers.
MPTCP does not have a protocol number allocated because MPTCP packets
use the TCP protocol number. Use private number not used OTA.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/in.h       | 2 ++
 tools/include/uapi/linux/in.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index e7ad9d350a28..44df6dc1ff1d 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -76,6 +76,8 @@ enum {
 #define IPPROTO_MPLS		IPPROTO_MPLS
   IPPROTO_RAW = 255,		/* Raw IP packets			*/
 #define IPPROTO_RAW		IPPROTO_RAW
+  IPPROTO_MPTCP = 262,		/* Multipath TCP connection 		*/
+#define IPPROTO_MPTCP		IPPROTO_MPTCP
   IPPROTO_MAX
 };
 #endif
diff --git a/tools/include/uapi/linux/in.h b/tools/include/uapi/linux/in.h
index e7ad9d350a28..44df6dc1ff1d 100644
--- a/tools/include/uapi/linux/in.h
+++ b/tools/include/uapi/linux/in.h
@@ -76,6 +76,8 @@ enum {
 #define IPPROTO_MPLS		IPPROTO_MPLS
   IPPROTO_RAW = 255,		/* Raw IP packets			*/
 #define IPPROTO_RAW		IPPROTO_RAW
+  IPPROTO_MPTCP = 262,		/* Multipath TCP connection 		*/
+#define IPPROTO_MPTCP		IPPROTO_MPTCP
   IPPROTO_MAX
 };
 #endif
-- 
2.22.0


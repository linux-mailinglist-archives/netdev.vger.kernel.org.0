Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8361C123769
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 21:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfLQUiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 15:38:24 -0500
Received: from mga18.intel.com ([134.134.136.126]:16395 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727652AbfLQUiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 15:38:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 12:38:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="298171930"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.1.107])
  by orsmga001.jf.intel.com with ESMTP; 17 Dec 2019 12:38:21 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v3 04/11] tcp: Add MPTCP option number
Date:   Tue, 17 Dec 2019 12:38:00 -0800
Message-Id: <20191217203807.12579-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217203807.12579-1-mathew.j.martineau@linux.intel.com>
References: <20191217203807.12579-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP option 30 is allocated for MPTCP by the IANA.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/tcp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 86b9a8766648..d4b6bf2c5d3c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -182,6 +182,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 #define TCPOPT_SACK             5       /* SACK Block */
 #define TCPOPT_TIMESTAMP	8	/* Better RTT estimations/PAWS */
 #define TCPOPT_MD5SIG		19	/* MD5 Signature (RFC2385) */
+#define TCPOPT_MPTCP		30	/* Multipath TCP (RFC6824) */
 #define TCPOPT_FASTOPEN		34	/* Fast open (RFC7413) */
 #define TCPOPT_EXP		254	/* Experimental */
 /* Magic number to be after the option value for sharing TCP
-- 
2.24.1


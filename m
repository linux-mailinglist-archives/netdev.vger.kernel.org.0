Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1532D6BA5
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391294AbgLJXLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:11:53 -0500
Received: from mga04.intel.com ([192.55.52.120]:9222 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387781AbgLJWbG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 17:31:06 -0500
IronPort-SDR: XmK2rg9RHIUmS6oCgh6JWPgiRjutfBQRXIr0w7Kpqp2QchF7vBwdAUbGkmGGGmCIWJ3tcDJ/mv
 z2BLWZ+tHcng==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="171776485"
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="171776485"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:14 -0800
IronPort-SDR: 9RDwUyKHbz+vBoCGHgJBwAsipL2ZdQqjoq+d0AG7WJHNysZxgEIZ8x0wvq1JAqBEvpuw9hvTGO
 skyUG8+v55UA==
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="338703755"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.112.51])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:13 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/9] mptcp: use MPTCPOPT_HMAC_LEN macro
Date:   Thu, 10 Dec 2020 14:25:01 -0800
Message-Id: <20201210222506.222251-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
References: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

Use the macro MPTCPOPT_HMAC_LEN instead of a constant in struct
mptcp_options_received.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index f6c3c686a34a..a5bc9599ae5c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -119,7 +119,7 @@ struct mptcp_options_received {
 	u32	token;
 	u32	nonce;
 	u64	thmac;
-	u8	hmac[20];
+	u8	hmac[MPTCPOPT_HMAC_LEN];
 	u8	join_id;
 	u8	use_map:1,
 		dsn64:1,
-- 
2.29.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83975EBD35
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiI0I1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiI0I1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:27:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5276DA5715
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 01:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664267223; x=1695803223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aOUryZg2RFJaTZAkeDZYJzOrC0nqhpkz7rzsMMD9XU4=;
  b=ddOMRwCefybW8NSUiH1hK/heN+NZX2qNvVT/Qdndbqjz2/+hY0jcx66o
   CTSzgqTy7Fmv5ctfVpDMHFs1uBTHpSJVZCJmfaSuTsK/wAa9dxvwJZxNa
   jmy4ufBV9JCbYFmZA6vZeLuN0EiqJnvtBigl6m1EqYekCuTRzxmcyFpr0
   ddKEzUAXsUvd7hgTkCxOWNUP/C1YTO7fHBjM0IEj0y1nq56GTZEKnKoiD
   8difAEgKaOeB0gu0TiEqT0RRalfvGmfQN1ToD1D1++5abVZet0D2JHF3C
   wUrlc/rc3StjuVKhuXotCU42+rcvwB+37f4BmbCs/4oFED72CQUJYPnms
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="327612358"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="327612358"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 01:27:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="652199935"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="652199935"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 27 Sep 2022 01:27:01 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 28R8QxxK023862;
        Tue, 27 Sep 2022 09:27:00 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Subject: [PATCH iproute2-next 1/3] uapi: move IPPROTO_L2TP to in.h
Date:   Tue, 27 Sep 2022 10:23:16 +0200
Message-Id: <20220927082318.289252-2-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220927082318.289252-1-wojciech.drewek@intel.com>
References: <20220927082318.289252-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reflect changes in the kernel [1].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=65b32f801bfbc54dc98144a6ec26082b59d131ee

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 include/uapi/linux/in.h   | 2 ++
 include/uapi/linux/l2tp.h | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 42cfea14401d..34b3516c9581 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -68,6 +68,8 @@ enum {
 #define IPPROTO_PIM		IPPROTO_PIM
   IPPROTO_COMP = 108,		/* Compression Header Protocol		*/
 #define IPPROTO_COMP		IPPROTO_COMP
+  IPPROTO_L2TP = 115,		/* Layer 2 Tunnelling Protocol		*/
+#define IPPROTO_L2TP		IPPROTO_L2TP
   IPPROTO_SCTP = 132,		/* Stream Control Transport Protocol	*/
 #define IPPROTO_SCTP		IPPROTO_SCTP
   IPPROTO_UDPLITE = 136,	/* UDP-Lite (RFC 3828)			*/
diff --git a/include/uapi/linux/l2tp.h b/include/uapi/linux/l2tp.h
index 0480d2dbed1a..e7705e875200 100644
--- a/include/uapi/linux/l2tp.h
+++ b/include/uapi/linux/l2tp.h
@@ -13,8 +13,6 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 
-#define IPPROTO_L2TP		115
-
 /**
  * struct sockaddr_l2tpip - the sockaddr structure for L2TP-over-IP sockets
  * @l2tp_family:  address family number AF_L2TPIP.
-- 
2.31.1


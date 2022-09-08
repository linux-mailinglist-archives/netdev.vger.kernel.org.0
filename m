Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217895B2446
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 19:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiIHRRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 13:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiIHRRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 13:17:21 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4FACCD6F
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 10:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662657440; x=1694193440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T7LLJuTTmSSaYItDJH/lrWEXA8IDEXbtQpb/ZqojxZo=;
  b=enjEBWQtOdlv/Im9bZDJEp9xhNRYqYl9J7gaic9gerBfHNHSdU92c+sW
   3/rizgQ0VNzgdLy+CLXXxbEwFhAxPyIddn5Ej/ZZqke7P4cMoTFBVCzyl
   fe9Wsz5GX/NoC5Eqs6PljvStUEF79yCg4/5M9jGy7sU9Wed00lhWtlTn2
   ZtqEbo552Acfy4+E9816UR50X/1QVpRwPnykSrKvTpbdc9Fy/gXMZ6usn
   s2Nyy8rFLERwN5qpURCtHIwwqr2ZVRPl9bl5jQn2s4aNTm+mTZvH67dZR
   XPCqB10wSQEQZCA53XRw3bZcI0rd9DdzlhwWzjM6NEsGjtRbhHXwI1G6l
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="297267563"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="297267563"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 10:16:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="860117814"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 08 Sep 2022 10:16:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        simon.horman@corigine.com, kurt@linutronix.de,
        komachi.yoshiki@gmail.com, jchapman@katalix.com,
        boris.sukholitko@broadcom.com, louis.peens@corigine.com,
        gnault@redhat.com, vladbu@nvidia.com, pablo@netfilter.org,
        baowen.zheng@corigine.com, maksym.glubokiy@plvision.eu,
        jiri@resnulli.us, paulb@nvidia.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH net-next v1 1/5] uapi: move IPPROTO_L2TP to in.h
Date:   Thu,  8 Sep 2022 10:16:40 -0700
Message-Id: <20220908171644.1282191-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220908171644.1282191-1-anthony.l.nguyen@intel.com>
References: <20220908171644.1282191-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

IPPROTO_L2TP is currently defined in l2tp.h, but most of
ip protocols are defined in in.h file. Move it there in order
to keep code clean.

Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/uapi/linux/in.h   | 2 ++
 include/uapi/linux/l2tp.h | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 578daa6f816b..f243ce665f74 100644
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
index bab8c9708611..7d81c3e1ec29 100644
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
2.35.1


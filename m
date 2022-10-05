Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE715F52DE
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 12:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJEKss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 06:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiJEKsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 06:48:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E81B5AA38
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 03:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664966921; x=1696502921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=04U2UlVAhDjuqMarWqmfVMDxlV+0hRbqC3fiFw8K8MI=;
  b=KRiz4o8wZzsCKRUrlGS1nez6In1HJlFoEua3L47pKfw55HCi5xyWm79q
   iXRSzk3ELqC6SkwFBe+3MkEiyMnsR5cw1NvJisf3tU9DXgr4ZScJIjLuh
   yqBpoRNF1QZP1NCIb/Hx6x+qmZkc5BNi4Z7/y3DI8z2NcLqnJwu9OZ3Vm
   d/CZakPuKNVhXFEVNjaySMl8AtBJxG73lalYAB11ZFoQQaXLS/638Ay5r
   w4MImY9UraNy6Q/3xg6uuO1EH/9Wv2slAlNy6hchGgxUdGkaGNsDd9SVZ
   FFl/KDC/Gu9Y/0PgIjhZxzSacg3huwq4U2ZJABAm2Uctld4RHxAmwG6OA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="329543917"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="329543917"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 03:48:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="728611886"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="728611886"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 05 Oct 2022 03:48:39 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 295AmbV4028819;
        Wed, 5 Oct 2022 11:48:38 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Subject: [PATCH iproute2-next v2 2/3] uapi: Add TCA_FLOWER_KEY_L2TPV3_SID
Date:   Wed,  5 Oct 2022 12:44:31 +0200
Message-Id: <20221005104432.369341-3-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221005104432.369341-1-wojciech.drewek@intel.com>
References: <20221005104432.369341-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reflect changes in the kernel [1].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=8b189ea08c334f25dbb3d076f8adb8b80491d01d

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 include/uapi/linux/pkt_cls.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index c142c0f8ed8a..b4fb72ac680a 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -592,6 +592,8 @@ enum {
 	TCA_FLOWER_KEY_PPPOE_SID,	/* be16 */
 	TCA_FLOWER_KEY_PPP_PROTO,	/* be16 */
 
+	TCA_FLOWER_KEY_L2TPV3_SID,	/* be32 */
+
 	__TCA_FLOWER_MAX,
 };
 
-- 
2.31.1


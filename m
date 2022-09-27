Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EBE5EBD36
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiI0I1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiI0I1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:27:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD260A5995
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 01:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664267223; x=1695803223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=04U2UlVAhDjuqMarWqmfVMDxlV+0hRbqC3fiFw8K8MI=;
  b=eMIwx+uoznyFWAyGPQ+9PnaBxe+RPFYNpPNJ1z1eonhMNq2+v8lI6PI3
   n4jbVzGT+I9IVMdkydmlGctyeRIN/sLjBSpEHyM/29jqjI4TfqqxoUKWW
   nm0auUIrI3nQdutiCWRVei7w1zuivsmhcbpA52na3UorBC1XZPQpMN4/u
   A2RpiUB5IND1N8PBHoz8Ht11WJ7FI6MFVjZpKCtr5FyvFYpu0gzNJg5vu
   TfLUTE4s3cwxuf6OVcN2cpRxz2PIZTRUvBhc4r6hMEQgCcPEn9pw4631u
   hYuC77zF/NXpaoo4qFcSR213Crw/gXyG4H0WYp4OaEj0EvmaAxlDd0MiU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="327612359"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="327612359"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 01:27:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="652199937"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="652199937"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 27 Sep 2022 01:27:01 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 28R8QxxL023862;
        Tue, 27 Sep 2022 09:27:00 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Subject: [PATCH iproute2-next 2/3] uapi: Add TCA_FLOWER_KEY_L2TPV3_SID
Date:   Tue, 27 Sep 2022 10:23:17 +0200
Message-Id: <20220927082318.289252-3-wojciech.drewek@intel.com>
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


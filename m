Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17AC14F0958
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 14:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347502AbiDCMaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 08:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240845AbiDCMao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 08:30:44 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE85234B85;
        Sun,  3 Apr 2022 05:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648988928; x=1680524928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ykhv0PHM2+QYmFYUxNK1v3kWBps7WbMwukEDYifJB/Y=;
  b=RELnGWHM5YwJyn38W3I6Ni7k5PAW9PeWBprQl9/SlGurIj9wUYalCSQR
   XsUDxTMFLRC+btS6sG0npWZg8kbAuT+JgD9WlW+TeWTflFIXVijN/ZfV+
   Wjj1o4j4wajO3DgRGJ9QHwEHa6vMQbIichgDDZl/sgtYOu6V5iNWVpvGh
   C37XyD3sCRHN8C1D9Sb0aEYPzmGaOgT35QVD644l0+9sVY0WylL/PVIsD
   Qj/HnyJtCKtV4dPQcRxulnYeXR3DrBFvxrbtppoxscqD2OAKBNDWI6wcI
   aL1dXjop06qFfglZgkZBXzcoE4AhrJIE6Pgp9RVduIH2vSaFn543Z7euB
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10305"; a="285326415"
X-IronPort-AV: E=Sophos;i="5.90,231,1643702400"; 
   d="scan'208";a="285326415"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2022 05:28:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,231,1643702400"; 
   d="scan'208";a="568943543"
Received: from npg-dpdk-haiyue-2.sh.intel.com ([10.67.111.4])
  by orsmga008.jf.intel.com with ESMTP; 03 Apr 2022 05:28:45 -0700
From:   Haiyue Wang <haiyue.wang@intel.com>
To:     bpf@vger.kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] bpf: correct the comment for BTF kind bitfield
Date:   Sun,  3 Apr 2022 19:53:26 +0800
Message-Id: <20220403115327.205964-1-haiyue.wang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220403084433.200701-1-haiyue.wang@intel.com>
References: <20220403084433.200701-1-haiyue.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 8fd886911a6a ("bpf: Add BTF_KIND_FLOAT to uapi") has extended
the BTF kind bitfield from 4 to 5 bits, correct the comment.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
---
v2: update the btf.h under tools directory.
---
 include/uapi/linux/btf.h       | 4 ++--
 tools/include/uapi/linux/btf.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
index b0d8fea1951d..a9162a6c0284 100644
--- a/include/uapi/linux/btf.h
+++ b/include/uapi/linux/btf.h
@@ -33,8 +33,8 @@ struct btf_type {
 	/* "info" bits arrangement
 	 * bits  0-15: vlen (e.g. # of struct's members)
 	 * bits 16-23: unused
-	 * bits 24-27: kind (e.g. int, ptr, array...etc)
-	 * bits 28-30: unused
+	 * bits 24-28: kind (e.g. int, ptr, array...etc)
+	 * bits 29-30: unused
 	 * bit     31: kind_flag, currently used by
 	 *             struct, union and fwd
 	 */
diff --git a/tools/include/uapi/linux/btf.h b/tools/include/uapi/linux/btf.h
index b0d8fea1951d..a9162a6c0284 100644
--- a/tools/include/uapi/linux/btf.h
+++ b/tools/include/uapi/linux/btf.h
@@ -33,8 +33,8 @@ struct btf_type {
 	/* "info" bits arrangement
 	 * bits  0-15: vlen (e.g. # of struct's members)
 	 * bits 16-23: unused
-	 * bits 24-27: kind (e.g. int, ptr, array...etc)
-	 * bits 28-30: unused
+	 * bits 24-28: kind (e.g. int, ptr, array...etc)
+	 * bits 29-30: unused
 	 * bit     31: kind_flag, currently used by
 	 *             struct, union and fwd
 	 */
-- 
2.35.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D5C56A0FB
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbiGGLQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiGGLQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:16:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D842C11C;
        Thu,  7 Jul 2022 04:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657192589; x=1688728589;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kuh4fg7Jvfd8VdWD8+BiwuBbw1q7RLqpORbULPg+8wI=;
  b=LUJaBQ3nqB0lUjt7STyoelrVdjV9rPyCuVM09pLSrigGKrHySs6MtcY0
   VXHqwpzt/bp6uH1blbDin8UZYPX6VuXfVZfKA9VCZdqi22J50Pq35CZc8
   9Q0K8vS81Zjmoj20HrMkMVk26BRnIu2Ds1TkzV51eyUBy6vmS8HsdznSz
   vSd0d4BjK+BiPBi6T1FItL3XTU/RHq5xYRkj2dDgX2+8T38AGEtfn/xv2
   IWeMGQmOJqFj38yAxn6sSFecx4EhL8hE+kFFAyo3A00icXE1yBGB/ZCh0
   yVDUTyhImgthxBYd5H8/fI1cTRm1cAXVMXuav0o2VvCv0h02I2OXPDm6s
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="309556183"
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="309556183"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 04:16:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="543788256"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 07 Jul 2022 04:16:20 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH bpf-next 2/2] MAINTAINERS: add entry for AF_XDP selftests files
Date:   Thu,  7 Jul 2022 13:16:13 +0200
Message-Id: <20220707111613.49031-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220707111613.49031-1-maciej.fijalkowski@intel.com>
References: <20220707111613.49031-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lukas reported that after commit f36600634282 ("libbpf: move xsk.{c,h}
into selftests/bpf") MAINTAINERS file needed an update.

In the meantime, Magnus removed AF_XDP samples in commit cfb5a2dbf141
("bpf, samples: Remove AF_XDP samples"), but selftests part still misses
its entry in MAINTAINERS.

Now that xdpxceiver became xskxceiver, tools/testing/selftests/bpf/*xsk*
will match all of the files related to AF_XDP testing (test_xsk.sh,
xskxceiver, xsk_prereqs.sh, xsk.{c,h}).

Reported-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ccd774c37c56..1da8a8d287d7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21749,6 +21749,7 @@ F:	include/uapi/linux/if_xdp.h
 F:	include/uapi/linux/xdp_diag.h
 F:	include/net/netns/xdp.h
 F:	net/xdp/
+F:	tools/testing/selftests/bpf/*xsk*
 
 XEN BLOCK SUBSYSTEM
 M:	Roger Pau Monné <roger.pau@citrix.com>
-- 
2.27.0


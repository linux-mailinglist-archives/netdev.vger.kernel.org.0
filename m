Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4587033781F
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbhCKPl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:41:28 -0500
Received: from mga06.intel.com ([134.134.136.31]:60959 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234076AbhCKPlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 10:41:08 -0500
IronPort-SDR: Q1WhMKQ9yBcw8z0bQeUTr8/+o7yxS+TEY8XME8004CVjdgymnCVGZ/wV0osMV35VtLbDIMf5Hc
 cVB2M0GcLHQA==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="250048440"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="250048440"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 07:41:08 -0800
IronPort-SDR: KUubkeAhWvMXYArx611evFsqOcjVxdIoi5LdrZhH+3Ywu+2aeQbsXrbHGoceo6mUefGt/5h2cX
 nKLwsVJABDRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="589253444"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 11 Mar 2021 07:41:05 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 03/17] selftests: xsk: remove unused function
Date:   Thu, 11 Mar 2021 16:28:56 +0100
Message-Id: <20210311152910.56760-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
References: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probably it was ported from xdpsock but is not used anywhere.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 04bc007d5b08..6769e9e2de17 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -153,19 +153,6 @@ static void *memset32_htonl(void *dest, u32 val, u32 size)
 	return dest;
 }
 
-/*
- * This function code has been taken from
- * Linux kernel lib/checksum.c
- */
-static inline unsigned short from32to16(unsigned int x)
-{
-	/* add up 16-bit and 16-bit for 16+c bit */
-	x = (x & 0xffff) + (x >> 16);
-	/* add up carry.. */
-	x = (x & 0xffff) + (x >> 16);
-	return x;
-}
-
 /*
  * Fold a partial checksum
  * This function code has been taken from
-- 
2.20.1


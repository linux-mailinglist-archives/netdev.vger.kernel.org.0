Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787F234B2ED
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhCZXVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:21:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:11388 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231329AbhCZXVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 19:21:37 -0400
IronPort-SDR: M1sSeasvqkTYlieFk1CIXZslg9NcudjAFlU8UvRbXT5nOozttnhU/zvG4BdFfac2xDQHRyVJEa
 aatW1W1o8akg==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="190681421"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="190681421"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 16:21:06 -0700
IronPort-SDR: GTfc6/z4wZTSttQSKbfomruTjeR1OgLwWs+A+B67jsRlMkd6DjB8+/d5Co8g1qbnXJozmloYh6
 BIkAa/h7wzrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="410113225"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 26 Mar 2021 16:21:04 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v4 bpf-next 03/17] selftests: xsk: remove unused function
Date:   Sat, 27 Mar 2021 00:09:24 +0100
Message-Id: <20210326230938.49998-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210326230938.49998-1-maciej.fijalkowski@intel.com>
References: <20210326230938.49998-1-maciej.fijalkowski@intel.com>
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


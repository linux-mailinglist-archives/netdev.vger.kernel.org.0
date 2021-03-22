Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C42345176
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhCVVJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:09:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:4966 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhCVVJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:09:05 -0400
IronPort-SDR: GxV2Cm0adoUPsqXxgmVqOAQoOZ7clItRLhMalLMc+BvsUI8gjTOhTjOFdE7EpODJjzbMLMkAj8
 cAN0kpqtWGZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="210423710"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="210423710"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 14:09:05 -0700
IronPort-SDR: qjBlnl31A59doKsJjXK9kW70ZtctIF/kNkP5kY/FQW2yHV7HHV+mUCPIxqvj0jnfc4tuov51DX
 ph2nPphM8Jtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="513448753"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2021 14:09:03 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 03/17] selftests: xsk: remove unused function
Date:   Mon, 22 Mar 2021 21:58:02 +0100
Message-Id: <20210322205816.65159-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
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


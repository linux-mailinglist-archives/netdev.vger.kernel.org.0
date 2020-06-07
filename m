Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7111F0A7E
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 10:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgFGIS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 04:18:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:31987 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgFGIS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 04:18:57 -0400
IronPort-SDR: 8JXZi1dqjYLwqPPkTD74CTO6e58BXsBzhr20j7hMK2hklKMxgPZwxADdLQGFSHlwoDLpzrAkDL
 PJq8lVK7UUmQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2020 01:18:57 -0700
IronPort-SDR: gjwb8QUTEq4mbCPC+UFHGRWEdLhiPsrFxiWuiEJX4DEkJ8vvSApkS0D80Aoqoa5uwCsvyv7GwZ
 bklOsOhhXoWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,483,1583222400"; 
   d="scan'208";a="417728636"
Received: from lkp-server01.sh.intel.com (HELO 3b764b36c89c) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 07 Jun 2020 01:18:55 -0700
Received: from kbuild by 3b764b36c89c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jhqW6-0000Cb-Mf; Sun, 07 Jun 2020 08:18:54 +0000
Date:   Sun, 7 Jun 2020 16:18:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>, jmaloy@redhat.com,
        maloy@donjonn.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: [RFC PATCH] tipc: tipc_named_dequeue() can be static
Message-ID: <20200607081818.GA178212@67076c2573bd>
References: <20200607042443.11104-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607042443.11104-1-hoang.h.le@dektech.com.au>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 name_distr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 481d480609f0a..b4f2351259333 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -320,8 +320,8 @@ static bool tipc_update_nametbl(struct net *net, struct distr_item *i,
 	return false;
 }
 
-struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
-				   u16 *rcv_nxt, bool *open)
+static struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
+					  u16 *rcv_nxt, bool *open)
 {
 	struct sk_buff *skb, *tmp;
 	struct tipc_msg *hdr;

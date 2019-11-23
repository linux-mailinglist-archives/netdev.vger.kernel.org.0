Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCFF107C01
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 01:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfKWAZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 19:25:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:18414 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfKWAZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 19:25:18 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 16:25:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="382240522"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 22 Nov 2019 16:25:15 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iYJEg-000FdD-I1; Sat, 23 Nov 2019 08:25:14 +0800
Date:   Sat, 23 Nov 2019 08:25:06 +0800
From:   kbuild test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [RFC PATCH] bpf: bpf_dispatcher_lookup() can be static
Message-ID: <20191123002506.qpjjlqalcoi77m62@4978f4969bb8>
References: <20191119160757.27714-2-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119160757.27714-2-bjorn.topel@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 316d60dee82c ("bpf: introduce BPF dispatcher")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 dispatcher.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
index 59a565107fd1d..30c964f94a173 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -45,7 +45,7 @@ struct bpf_dispatcher {
 
 static DEFINE_MUTEX(dispatcher_mutex);
 
-struct bpf_dispatcher *bpf_dispatcher_lookup(void *func)
+static struct bpf_dispatcher *bpf_dispatcher_lookup(void *func)
 {
 	struct bpf_dispatcher *d;
 	struct hlist_head *head;

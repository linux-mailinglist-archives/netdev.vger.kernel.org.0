Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B661BCCBB
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 21:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgD1Tuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 15:50:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:5856 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728859AbgD1Tum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 15:50:42 -0400
IronPort-SDR: i1szSE+xJC5zwZLLViAuq4AO7meBXLqieJHFapg1WsT7mJKoq0aMTV2PeqOK4a8PxfycMwWRVO
 u5f/Hl6jz7pg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 12:50:41 -0700
IronPort-SDR: TP6+i8pgfaouteFA2i7sAkzn/WKiOtL8dDrt/2I1ZKxt4ksCR8W1IVKhFcI+iXG1a1SDUR6AhC
 Rk0o3PxRY7rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,328,1583222400"; 
   d="scan'208";a="458928763"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 28 Apr 2020 12:50:38 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jTWFa-000AjK-Oe; Wed, 29 Apr 2020 03:50:38 +0800
Date:   Wed, 29 Apr 2020 03:50:00 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: [RFC PATCH] bpf: __bpf_iter__netlink() can be static
Message-ID: <20200428194957.GA51515@dcd913b51aa6>
References: <20200427201246.2995471-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427201246.2995471-1-yhs@fb.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kbuild test robot <lkp@intel.com>
---
 af_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index b6192cd668013..b8c9a87bd3960 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2640,7 +2640,7 @@ struct bpf_iter__netlink {
 	__bpf_md_ptr(struct netlink_sock *, sk);
 };
 
-int __init __bpf_iter__netlink(struct bpf_iter_meta *meta, struct netlink_sock *sk)
+static int __init __bpf_iter__netlink(struct bpf_iter_meta *meta, struct netlink_sock *sk)
 {
 	return 0;
 }

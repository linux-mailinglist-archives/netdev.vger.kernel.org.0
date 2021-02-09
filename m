Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD4131472F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 04:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBIDqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 22:46:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:20201 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhBIDjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 22:39:48 -0500
IronPort-SDR: klKAYVno2Bhvw9fGH2tjOiXGSAhgaDcSrFvDQrGjP8o5IYL1z1Z0fJdItk/a0PES9h+YUjTTr7
 JAb63WPlnRfw==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="200890254"
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="200890254"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 19:35:58 -0800
IronPort-SDR: 2x2Y/80nYfY2GQk6P2MgkCBHgokWoOEJsZfvfljCW7D/33QGuMl0MBO17N+HAVyC9QPQG2uf7B
 0vakNHN2mmtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="435915059"
Received: from lkp-server02.sh.intel.com (HELO cd560a204411) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 08 Feb 2021 19:35:54 -0800
Received: from kbuild by cd560a204411 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1l9Jof-0001gS-DR; Tue, 09 Feb 2021 03:35:53 +0000
Date:   Tue, 9 Feb 2021 11:34:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, dsahern@kernel.org,
        xiyou.wangcong@gmail.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com
Cc:     kbuild-all@lists.01.org
Subject: [RFC PATCH] mld: mld_check_leave_group() can be static
Message-ID: <20210209033456.GA29327@eacb66f1e73b>
References: <20210208175952.5880-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208175952.5880-1-ap420073@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 mcast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 5fd87659dcefa..c9862a647a4b6 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -330,7 +330,7 @@ void ipv6_sock_mc_close(struct sock *sk)
 }
 
 /* special case - (INCLUDE, empty) == LEAVE_GROUP */
-bool mld_check_leave_group(struct ipv6_mc_socklist *mc_lst, int omode)
+static bool mld_check_leave_group(struct ipv6_mc_socklist *mc_lst, int omode)
 {
 	if (atomic_read(&mc_lst->sl_count) == 1 && omode == MCAST_INCLUDE)
 		return true;

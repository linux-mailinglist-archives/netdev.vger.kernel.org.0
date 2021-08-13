Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEFF3EB924
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242950AbhHMPV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:21:59 -0400
Received: from mga12.intel.com ([192.55.52.136]:12637 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243714AbhHMPUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 11:20:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="195160413"
X-IronPort-AV: E=Sophos;i="5.84,319,1620716400"; 
   d="scan'208";a="195160413"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 08:18:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,319,1620716400"; 
   d="scan'208";a="518191319"
Received: from lkp-server01.sh.intel.com (HELO d053b881505b) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Aug 2021 08:18:14 -0700
Received: from kbuild by d053b881505b with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mEYwo-000NtX-60; Fri, 13 Aug 2021 15:18:14 +0000
Date:   Fri, 13 Aug 2021 23:18:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org
Subject: [RFC PATCH] bpf: bpf_xdp_get_buff_len_proto can be static
Message-ID: <20210813151808.GA61736@170502314c35>
References: <a742a962e3843b1ee85ed56ca934f15f61366a71.1628854454.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a742a962e3843b1ee85ed56ca934f15f61366a71.1628854454.git.lorenzo@kernel.org>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/core/filter.c:3801:29: warning: symbol 'bpf_xdp_get_buff_len_proto' was not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 filter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 93ce775eaadfc..0c496d155aee1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3798,7 +3798,7 @@ BPF_CALL_1(bpf_xdp_get_buff_len, struct  xdp_buff*, xdp)
 	return len;
 }
 
-const struct bpf_func_proto bpf_xdp_get_buff_len_proto = {
+static const struct bpf_func_proto bpf_xdp_get_buff_len_proto = {
 	.func		= bpf_xdp_get_buff_len,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,

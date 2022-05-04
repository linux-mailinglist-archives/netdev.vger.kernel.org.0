Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9ED519627
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 05:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344366AbiEDDyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 23:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbiEDDyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 23:54:16 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D66A17AA0;
        Tue,  3 May 2022 20:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651636241; x=1683172241;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LwV2LNP2LJPn7gTFJuk+IeErW5GWz1kXbWwP9v9zaF8=;
  b=KoCLdxYvl2r2fGyhtlu9LXHpW7qVM19n9x4AGDShz9C+bwPPm4kMimP+
   0zDwbU13R7nULRwgpIgN5sUx3gBWlZHSLpNkmVKKzWMioRx+7w/elTfhe
   lUiMY4KaO1EeHCJPtZ9sUqejYD+kUrDub86jJoMAPqsulPvAiLZ9/3cmC
   MIZ0OsfnPB7EEhcaCKh3B1IYVl16maX6cjb9rDKoVEz97ii8R8j1XohfU
   BHozTbq1ztj8Tn6WK8QcK9/xRz8d/yXKd7hJmCzpNqQjw3J7dGpLOPzry
   rE8JJ/UgEHNAu9onICV3kdXi8yyiqV4lhAckYlj45QP0NEwymMSPmf35H
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="266498179"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="266498179"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 20:50:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="889769095"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 03 May 2022 20:50:37 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nm628-000B2l-Gj;
        Wed, 04 May 2022 03:50:36 +0000
Date:   Wed, 4 May 2022 11:50:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [RFC PATCH] net: netfilter: bpf_ct_refresh_timeout() can be static
Message-ID: <YnH39sfvRu/GUJIB@640551eb7a4c>
References: <1327f8f5696ff2bc60400e8f3b79047914ccc837.1651595019.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327f8f5696ff2bc60400e8f3b79047914ccc837.1651595019.git.lorenzo@kernel.org>
X-Patchwork-Hint: ignore
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/netfilter/nf_conntrack_bpf.c:230:6: warning: symbol 'bpf_ct_refresh_timeout' was not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 net/netfilter/nf_conntrack_bpf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index d6dcadf0e0166..02d2578d4bb89 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -227,7 +227,7 @@ void bpf_ct_release(struct nf_conn *nfct)
  *		   bpf_xdp_ct_lookup or bpf_skb_ct_lookup.
  * @timeout      - delta time in msecs used to increase the ct entry lifetime.
  */
-void bpf_ct_refresh_timeout(struct nf_conn *nfct, u32 timeout)
+static void bpf_ct_refresh_timeout(struct nf_conn *nfct, u32 timeout)
 {
 	if (!nfct)
 		return;

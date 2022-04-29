Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98202515875
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381519AbiD2Wgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358539AbiD2Wgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:36:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6FBDCE22;
        Fri, 29 Apr 2022 15:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651271607; x=1682807607;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A/N5qHDYE8Exw7zJH1sKYTNP5QPCkXQNf3u7DyoyKdg=;
  b=EPSWs0xGTQwuHk73PAf4CBAsW2X3GoWkZeNtqBR1wK056kcf89lO2Stn
   QYyXk3Q4QrMIlzw5MocWm/QEhPmpk7qcRM2RwDSui9UCK+/ykmcQOfi6C
   senxX0HQaA0FpLBY0OnaGnHnMvi2oTiQ7SQZ5ip7ytfDkukJDP2Dr1D43
   yaV1ukCEYpGHfqtu6f8cvj21j0kMw2AaDb//zQSstt1EUlm/pCbFaoAjm
   kIREAtYf/ClZs2jph5EoItxvBe3nnZvIxpnK/t56FAI4y8J9Nz6jNCX3t
   3FhE+zU9UvBygmWFJQP4YdfUijF3fTlSmEOjp2HKIy4+UElWharcTOzhz
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="247344649"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="247344649"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 15:33:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="597556373"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 29 Apr 2022 15:33:24 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nkZAx-0006eB-BH;
        Fri, 29 Apr 2022 22:33:23 +0000
Date:   Sat, 30 Apr 2022 06:33:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH linux-next] bpf: bpf_kptr_xchg_proto can be static
Message-ID: <Ymxnn1ikQ3/B3xZd@5fdacab24e00>
References: <202204300646.B29EmUql-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202204300646.B29EmUql-lkp@intel.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel/bpf/helpers.c:1389:29: warning: symbol 'bpf_kptr_xchg_proto' was not declared. Should it be static?

Fixes: c0a5a21c25f3 ("bpf: Allow storing referenced kptr in map")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 kernel/bpf/helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 3e709fed530612..62864d2c44e4a3 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1386,7 +1386,7 @@ BPF_CALL_2(bpf_kptr_xchg, void *, map_value, void *, ptr)
  */
 #define BPF_PTR_POISON ((void *)((0xeB9FUL << 2) + POISON_POINTER_DELTA))
 
-const struct bpf_func_proto bpf_kptr_xchg_proto = {
+static const struct bpf_func_proto bpf_kptr_xchg_proto = {
 	.func         = bpf_kptr_xchg,
 	.gpl_only     = false,
 	.ret_type     = RET_PTR_TO_BTF_ID_OR_NULL,

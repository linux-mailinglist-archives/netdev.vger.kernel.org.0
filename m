Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82D35356D7
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 01:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244664AbiEZX6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 19:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241821AbiEZX5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 19:57:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89252EBE88;
        Thu, 26 May 2022 16:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653609361; x=1685145361;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IJGf5RepmEDrnwHRwu4dMdbVrN0wb3olBg9WO6yrmPs=;
  b=FZ8FLh8lEmDv89DPI+BITUJhno1Fm35u2MEBinJTbXr6ofE8TtfaYljb
   TChcafjad6+HUjOern/g7IMT3EVFhsfr6M6XE+a9T1UPSIUYGCgxON3C7
   k6ke/jaWZPOk4fECwPq+jfA4hfs3c/xNEzN7iwbJtQMN+Jrsm9C9QhiEq
   DEbtkdKZGdBDF8QHcnPj+CG2V8kSE1p9di5aOeQuCxuVNnWLWyObyCUQx
   YKn+RK1ZM5vQy1tYUzgFX3JD/Ki6HXksXDg13L1kL8Z8VN1Uz0UcaOSz3
   VdpJnehbkJfYZUjQwFCEtDJ6T5bxJJRyAzv/cx7Sizs8vj0EojBv+9pgP
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="273141771"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="273141771"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 16:56:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="603453275"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 26 May 2022 16:55:56 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nuNKd-0004Fs-G4;
        Thu, 26 May 2022 23:55:55 +0000
Date:   Fri, 27 May 2022 07:55:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: Re: [PATCH v4 bpf-next 06/14] bpf: Whitelist some fields in nf_conn
 for BPF_WRITE
Message-ID: <202205270749.blol7EcF-lkp@intel.com>
References: <2954ab26de09afeecf3a56ba93624f9629072102.1653600578.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2954ab26de09afeecf3a56ba93624f9629072102.1653600578.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Bianconi/net-netfilter-add-kfunc-helper-to-update-ct-timeout/20220527-053913
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220527/202205270749.blol7EcF-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/c346565af9b023d9231ca8fca2e1b8c66a782f84
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Lorenzo-Bianconi/net-netfilter-add-kfunc-helper-to-update-ct-timeout/20220527-053913
        git checkout c346565af9b023d9231ca8fca2e1b8c66a782f84
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/core/filter.c: In function 'xdp_tc_btf_struct_access':
>> net/core/filter.c:10479:16: error: implicit declaration of function 'btf_struct_access'; did you mean 'xdp_tc_btf_struct_access'? [-Werror=implicit-function-declaration]
   10479 |         return btf_struct_access(log, btf, t, off, size, atype, next_btf_id, flag);
         |                ^~~~~~~~~~~~~~~~~
         |                xdp_tc_btf_struct_access
   cc1: some warnings being treated as errors


vim +10479 net/core/filter.c

 10459	
 10460	static int xdp_tc_btf_struct_access(struct bpf_verifier_log *log,
 10461					    const struct btf *btf,
 10462					    const struct btf_type *t, int off, int size,
 10463					    enum bpf_access_type atype,
 10464					    u32 *next_btf_id, enum bpf_type_flag *flag)
 10465	{
 10466		int ret;
 10467	
 10468		if (atype == BPF_READ || !READ_ONCE(nf_conn_btf_struct_access))
 10469			goto end;
 10470		mutex_lock(&nf_conn_btf_struct_access_mtx);
 10471		if (!nf_conn_btf_struct_access)
 10472			goto end_unlock;
 10473		ret = nf_conn_btf_struct_access(log, btf, t, off, size, atype, next_btf_id, flag);
 10474		mutex_unlock(&nf_conn_btf_struct_access_mtx);
 10475		return ret;
 10476	end_unlock:
 10477		mutex_unlock(&nf_conn_btf_struct_access_mtx);
 10478	end:
 10479		return btf_struct_access(log, btf, t, off, size, atype, next_btf_id, flag);
 10480	}
 10481	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

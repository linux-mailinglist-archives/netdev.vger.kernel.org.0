Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4797753300C
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240143AbiEXSHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240131AbiEXSHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:07:12 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01FE6AA73;
        Tue, 24 May 2022 11:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653415631; x=1684951631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CKeS45IE/MpZvn0nyHNUsJygS/BGm2jLP5dhifZsips=;
  b=kAmDEIJZwNZM0fjbJnuISS3AvKEzNFDQADJq2GDM8Ism4nVSs4OOuiqJ
   bj5vUVcS3ZANi7oBKEHJuV3mgkjGu5yrF1LNsaLk9R6DVz3sydNAQpKb2
   VcxVtThZe3s2zfXdstPdniJul2XJ+jylXQWMR9EIgoBirJOQkbaND2X70
   kqZjDNE8gvM2m0dwa6YwG4mBBmr1gAzgvGbXZv+bT5u6xHIIsCBAkERrg
   EiMjVcMU17yiQxuRYVBBwqQ3a54H9ioQDKOgJebVsN5ZgAwgJg2sSQaHj
   /q9MTqVRg0jCdj4Wfk9ft2l31NOLLw2B6FrA8q6L4FZkvnN5z1kk2P4xl
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="336670078"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="336670078"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 11:07:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="642044509"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 24 May 2022 11:07:05 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ntYvx-0002KB-0m;
        Tue, 24 May 2022 18:07:05 +0000
Date:   Wed, 25 May 2022 02:06:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     longli@linuxonhyperv.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: Re: [Patch v2 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <202205250235.eGFUDpu1-lkp@intel.com>
References: <1653382572-14788-13-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1653382572-14788-13-git-send-email-longli@linuxonhyperv.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.18 next-20220524]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/longli-linuxonhyperv-com/Introduce-Microsoft-Azure-Network-Adapter-MANA-RDMA-driver/20220524-165958
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 143a6252e1b8ab424b4b293512a97cca7295c182
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220525/202205250235.eGFUDpu1-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 10c9ecce9f6096e18222a331c5e7d085bd813f75)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e448735b8bdeab86ad3736ed37b5539bc2af2681
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review longli-linuxonhyperv-com/Introduce-Microsoft-Azure-Network-Adapter-MANA-RDMA-driver/20220524-165958
        git checkout e448735b8bdeab86ad3736ed37b5539bc2af2681
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from <built-in>:1:
>> ./usr/include/rdma/mana-abi.h:12:10: fatal error: 'net/mana/mana.h' file not found
   #include <net/mana/mana.h>
            ^~~~~~~~~~~~~~~~~
   1 error generated.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

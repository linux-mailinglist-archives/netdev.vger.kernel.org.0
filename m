Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812AE523B20
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 19:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345311AbiEKRIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 13:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiEKRIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 13:08:17 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F936C57B;
        Wed, 11 May 2022 10:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652288896; x=1683824896;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=29BTgKun/aHDSBPi2/2G5XjBcLcLO8+CqMmRCWxs1NM=;
  b=VKqzGxHCFU+9+nLmU/QHD01OXDR9pelRdH1BBqysNc1IR2PpV211fX/K
   NN4ISS1CSLG11bCiAS6CNs2EVTZ+AU6ybwhST0L2hfGV7pwqvTY3byIjt
   LXKrBJPNmyprxie6YwmdPqrlQVTvjk1rmuIjprFgJMM7SWYlnYGayak5j
   2Ez3R2+ktQdZlpSsxPM6SAoPyOZrzfxmIEQsl0yhuHqg9o4msYgSVogO0
   qf7CW53nZ+6ihqW3E658aXSLhQ5LU6xBR6zuvbKjNCJ+NzWoI+7oT6nZK
   oBz3du8meucST5WknndYLEzBPyOEO7RDY5gVjSLTLc9D+mqzhQpenn5B4
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="332795298"
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="332795298"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 10:08:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="636490787"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 11 May 2022 10:08:01 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nopoe-000JLM-D2;
        Wed, 11 May 2022 17:08:00 +0000
Date:   Thu, 12 May 2022 01:07:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Erik Ekman <erik@kryo.se>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [linux-next:master 10569/11094]
 drivers/net/ethernet/sfc/siena/siena_sriov.c:1578:5: sparse: sparse: symbol
 'efx_init_sriov' was not declared. Should it be static?
Message-ID: <202205120012.rvs9fZKN-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

First bad commit (maybe != root cause):

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   6107040c99d5dfc920721c198d45ed2d639b113a
commit: c5a13c319e10e795850b61bc7e3447b08024be2e [10569/11094] sfc: Add a basic Siena module
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20220512/202205120012.rvs9fZKN-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=c5a13c319e10e795850b61bc7e3447b08024be2e
        git remote add linux-next https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
        git fetch --no-tags linux-next master
        git checkout c5a13c319e10e795850b61bc7e3447b08024be2e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ethernet/sfc/siena/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/net/ethernet/sfc/siena/siena_sriov.c:1578:5: sparse: sparse: symbol 'efx_init_sriov' was not declared. Should it be static?
>> drivers/net/ethernet/sfc/siena/siena_sriov.c:1590:6: sparse: sparse: symbol 'efx_fini_sriov' was not declared. Should it be static?

Please review and possibly fold the followup patch.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

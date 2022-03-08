Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9FE4D1CF2
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345399AbiCHQPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239312AbiCHQPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:15:31 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9D250B23;
        Tue,  8 Mar 2022 08:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646756075; x=1678292075;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=LR5CCv6Q3aBeORtqOyOOhZCKfF2QDO9kvzAaK6wB20k=;
  b=ks2GICwVXdh1L3I3MutzB917xG/tdK2Mk8F1urr1sTBoLCLl07XRT2td
   16PW7cQBRlIFAznS46DcprsuqbiO3ri+Xluo0rMxBY41EblqhQEHB0a/R
   yfcJ0MB42EbBZIFJP6KoyQlVowu+FhzkLyuljo6/EoZfEZEGkkpYyhaCY
   UE4Yh29HkaSUowkPBUN7jpAhiNyeTD0Xi9KnF1tAoXssMrspJ+nfgIoyv
   6Xc6RDdf/ZpPObczS53YFfVwWGc/2m9PqUMUTbG0roTBpjf2dbVqu7vtk
   Gd1blTK/AtcTdDCObAB9Qa7b4tyOYJZp51hPdWXgSuPcg9eHkMhafcCWY
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="253554926"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="253554926"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 08:11:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="711580048"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 08 Mar 2022 08:11:31 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nRcQt-0001fZ-5b; Tue, 08 Mar 2022 16:11:31 +0000
Date:   Wed, 9 Mar 2022 00:10:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        lei he <helei.sig11@bytedance.com>,
        Gonglei <arei.gonglei@huawei.com>
Subject: [mst-vhost:vhost 28/60] nios2-linux-ld:
 virtio_crypto_akcipher_algs.c:undefined reference to `rsa_parse_pub_key'
Message-ID: <202203090014.ulENdnAQ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   c5f633abfd09491ae7ecbc7fcfca08332ad00a8b
commit: 8a75f36b5d7a48f1c5a0b46638961c951ec6ecd9 [28/60] virtio-crypto: implement RSA algorithm
config: nios2-randconfig-p002-20220308 (https://download.01.org/0day-ci/archive/20220309/202203090014.ulENdnAQ-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?id=8a75f36b5d7a48f1c5a0b46638961c951ec6ecd9
        git remote add mst-vhost https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
        git fetch --no-tags mst-vhost vhost
        git checkout 8a75f36b5d7a48f1c5a0b46638961c951ec6ecd9
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   nios2-linux-ld: drivers/crypto/virtio/virtio_crypto_akcipher_algs.o: in function `virtio_crypto_rsa_set_key':
   virtio_crypto_akcipher_algs.c:(.text+0x4bc): undefined reference to `rsa_parse_priv_key'
   virtio_crypto_akcipher_algs.c:(.text+0x4bc): relocation truncated to fit: R_NIOS2_CALL26 against `rsa_parse_priv_key'
>> nios2-linux-ld: virtio_crypto_akcipher_algs.c:(.text+0x4e8): undefined reference to `rsa_parse_pub_key'
   virtio_crypto_akcipher_algs.c:(.text+0x4e8): relocation truncated to fit: R_NIOS2_CALL26 against `rsa_parse_pub_key'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A74539858
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347662AbiEaU4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 16:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243326AbiEaU4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 16:56:31 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2279CF75;
        Tue, 31 May 2022 13:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654030588; x=1685566588;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=KmOBMBNjMDvpHex0XEgSTh2uGSxfl8GV13MikE3newM=;
  b=MHoDQ0HOQskKGu5ovr5S7czoNjWNvtm/RRusmxN9w6vAVxpErzBn0qgk
   NgaMYgh8eGYd3d9yY70NrMFDBeG0wF1KvB63Y68hXLb6BarAQ0af4sLBM
   wcCfN6SRUvyAQadMp6WoC5RDDUhshJwNVKbYUzR6vVijOQ8UnhUptHV3X
   fIYDPTZAfjRmgnTgXyN6LKpAIEvVstVkGYAk35YiXIaDpeZ4Vd9NCltHY
   nZ3Ei71nS4b7Ya7iXaE+mCkIn8733KJ5G0v18LUwtkpa0Dl2YJdzXBg27
   a/4Z/U6O6CsBQQzamdISCaLnr+T8oeI+uvhlsGWoPIoeECnNXAjJHabOW
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="274185873"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="274185873"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 13:56:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="706748538"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 31 May 2022 13:56:26 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nw8uf-00034W-Ih;
        Tue, 31 May 2022 20:56:25 +0000
Date:   Wed, 1 Jun 2022 04:55:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [mst-vhost:vhost 62/65] drivers/virtio/virtio_ring.c:1783:9: error:
 use of undeclared identifier 'vq'
Message-ID: <202206010444.EGBXgPMJ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   5e83df49b4993a11b01399f6ce402f775940f965
commit: a50f09346a341984d34ff41f03dbd14dea6f20fe [62/65] virtio_ring: remove unused variable in virtqueue_add()
config: mips-randconfig-c004-20220531 (https://download.01.org/0day-ci/archive/20220601/202206010444.EGBXgPMJ-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c825abd6b0198fb088d9752f556a70705bc99dfd)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mipsel-linux-gnu
        # https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?id=a50f09346a341984d34ff41f03dbd14dea6f20fe
        git remote add mst-vhost https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
        git fetch --no-tags mst-vhost vhost
        git checkout a50f09346a341984d34ff41f03dbd14dea6f20fe
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash drivers/virtio/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/virtio/virtio_ring.c:1783:9: error: use of undeclared identifier 'vq'
           return vq->packed_ring ? virtqueue_add_packed(_vq, sgs, total_sg,
                  ^
   1 error generated.


vim +/vq +1783 drivers/virtio/virtio_ring.c

1ce9e6055fa0a9 Tiwei Bie 2018-11-21  1768  
1ce9e6055fa0a9 Tiwei Bie 2018-11-21  1769  
e6f633e5beab65 Tiwei Bie 2018-11-21  1770  /*
e6f633e5beab65 Tiwei Bie 2018-11-21  1771   * Generic functions and exported symbols.
e6f633e5beab65 Tiwei Bie 2018-11-21  1772   */
e6f633e5beab65 Tiwei Bie 2018-11-21  1773  
e6f633e5beab65 Tiwei Bie 2018-11-21  1774  static inline int virtqueue_add(struct virtqueue *_vq,
e6f633e5beab65 Tiwei Bie 2018-11-21  1775  				struct scatterlist *sgs[],
e6f633e5beab65 Tiwei Bie 2018-11-21  1776  				unsigned int total_sg,
e6f633e5beab65 Tiwei Bie 2018-11-21  1777  				unsigned int out_sgs,
e6f633e5beab65 Tiwei Bie 2018-11-21  1778  				unsigned int in_sgs,
e6f633e5beab65 Tiwei Bie 2018-11-21  1779  				void *data,
e6f633e5beab65 Tiwei Bie 2018-11-21  1780  				void *ctx,
e6f633e5beab65 Tiwei Bie 2018-11-21  1781  				gfp_t gfp)
e6f633e5beab65 Tiwei Bie 2018-11-21  1782  {
1ce9e6055fa0a9 Tiwei Bie 2018-11-21 @1783  	return vq->packed_ring ? virtqueue_add_packed(_vq, sgs, total_sg,
1ce9e6055fa0a9 Tiwei Bie 2018-11-21  1784  					out_sgs, in_sgs, data, ctx, gfp) :
1ce9e6055fa0a9 Tiwei Bie 2018-11-21  1785  				 virtqueue_add_split(_vq, sgs, total_sg,
e6f633e5beab65 Tiwei Bie 2018-11-21  1786  					out_sgs, in_sgs, data, ctx, gfp);
e6f633e5beab65 Tiwei Bie 2018-11-21  1787  }
e6f633e5beab65 Tiwei Bie 2018-11-21  1788  

:::::: The code at line 1783 was first introduced by commit
:::::: 1ce9e6055fa0a9043405c5604cf19169ec5379ff virtio_ring: introduce packed ring support

:::::: TO: Tiwei Bie <tiwei.bie@intel.com>
:::::: CC: David S. Miller <davem@davemloft.net>

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

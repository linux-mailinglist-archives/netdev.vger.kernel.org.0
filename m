Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8E75B64F1
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 03:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiIMBKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 21:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiIMBKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 21:10:45 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6348651421;
        Mon, 12 Sep 2022 18:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663031443; x=1694567443;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IBMJmz447i1H4VhdQmfyA8wQOBBhYHA3uOT0vcuYxlg=;
  b=i7N9zxGzOUIPTfXuMbOlBz6KrzA+sJ3sjm+1DAL27BysZ8aopqATTQp9
   qOTO2Ga8oEWRw0kShSw39H4OwcEDYK6F8panx66uQqmGroKHTVvAEHEJn
   g+XIhUdc7a7dx+15aqsTgyvyHuc+/kLsQw/BgegMaP47cZA0D5Ocn5ICq
   QUBYAJ66rzVlMLa6IIDS++JMSX+6UTVcUBFmmLgqUtwjy2cjHGDEvvmD0
   eUNXZ3djlrt3+72YcUJXha58jDQC4/YdoSd2/YbCuoaaoDvxaU+Ar+cNC
   ihvf8jf+4hPkcG/X19Rux+q94kLRTPTOaNubWdmPjZTXbifU4awLPgUwM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="361959331"
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="361959331"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 18:10:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="684655572"
Received: from lkp-server02.sh.intel.com (HELO 4011df4f4fd3) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 12 Sep 2022 18:10:38 -0700
Received: from kbuild by 4011df4f4fd3 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oXuRh-00033D-2t;
        Tue, 13 Sep 2022 01:10:37 +0000
Date:   Tue, 13 Sep 2022 09:10:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org
Subject: Re: [PATCH net-next 08/12] net: ethernet: mtk_eth_soc: add foe info
 in mtk_soc_data structure
Message-ID: <202209130841.kze95Xi6-lkp@intel.com>
References: <0d0bfa99e313c0b00bf75f943f58b6fe552ed004.1662661555.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d0bfa99e313c0b00bf75f943f58b6fe552ed004.1662661555.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Bianconi/Add-WED-support-for-MT7986-chipset/20220909-033910
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9f8f1933dce555d3c246f447f54fca8de8889da9
config: arm-randconfig-r005-20220911 (https://download.01.org/0day-ci/archive/20220913/202209130841.kze95Xi6-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/8500175ee61539b6c5cb7acb854ce592e78cf639
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Lorenzo-Bianconi/Add-WED-support-for-MT7986-chipset/20220909-033910
        git checkout 8500175ee61539b6c5cb7acb854ce592e78cf639
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__ffsdi2" [drivers/net/ethernet/mediatek/mtk_eth.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

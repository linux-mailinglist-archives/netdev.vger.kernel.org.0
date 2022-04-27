Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DB651137F
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 10:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359410AbiD0Iet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 04:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiD0Ieq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 04:34:46 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAC51FA48;
        Wed, 27 Apr 2022 01:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651048296; x=1682584296;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QB+C2awCS8SI/qOc2hpUsE98FZJLYWnZ8pdyLpOzv+4=;
  b=b4IvlG7W3niYDFGFKVJyuSmramWG3QLNGwMEinku2tRpQ3+uq6l9boS3
   G0uHt1eipZrxTErmSTjADiCxgkFlBz0rP7tI2QYBDfqRNCu2i90nZ/y5P
   xQsXbgLTJ80R8r1eiFIlrheQnzaQa4EepTHL6uvYK/opIOG+vIpSGKzlR
   QgNZMzsGOrFp9XpQOMCl41dbIgCgMhM1gfHfNmjCzZ3mLUgtwG4G1PrFs
   m+8KJo6dN+gxMFwP9uEyX1JiuU3uVHua5MuQ0+tIPgDbf9UvgGlqxTZUc
   ZG6er/jjNGNEGFVkyyCQ7VQjg3J2ZvzO24EdXKTBHE+JMlGayKAHSmSrM
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="291011752"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="291011752"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 01:31:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="539716593"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 27 Apr 2022 01:31:33 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njd5B-0004Vy-5e;
        Wed, 27 Apr 2022 08:31:33 +0000
Date:   Wed, 27 Apr 2022 16:31:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Min Li <min.li.xe@renesas.com>, richardcochran@gmail.com,
        lee.jones@linaro.org
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Min Li <min.li.xe@renesas.com>
Subject: Re: [PATCH net 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS
 support
Message-ID: <202204271653.N6Y5H0EO-lkp@intel.com>
References: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Min,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Min-Li/ptp-ptp_clockmatrix-Add-PTP_CLK_REQ_EXTTS-support/20220427-033506
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git acb16b395c3f3d7502443e0c799c2b42df645642
config: i386-randconfig-a013-20220425 (https://download.01.org/0day-ci/archive/20220427/202204271653.N6Y5H0EO-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/afadc4edd1bf64b40cb61b38dedf67354baeb147
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Min-Li/ptp-ptp_clockmatrix-Add-PTP_CLK_REQ_EXTTS-support/20220427-033506
        git checkout afadc4edd1bf64b40cb61b38dedf67354baeb147
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: drivers/ptp/ptp_clockmatrix.o: in function `idtcm_enable_channel':
>> ptp_clockmatrix.c:(.text+0x2394): undefined reference to `__udivdi3'
>> ld: ptp_clockmatrix.c:(.text+0x23b0): undefined reference to `__udivdi3'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

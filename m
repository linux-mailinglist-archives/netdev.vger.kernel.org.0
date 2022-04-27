Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FA6510EEB
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 04:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357223AbiD0Cre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 22:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbiD0Crb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 22:47:31 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAE888791;
        Tue, 26 Apr 2022 19:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651027462; x=1682563462;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wD0dS6MC7upWfpPn7sW9hLLx0kWgTcp6K+T39+YDyww=;
  b=cAWqjvhMkOFcs5aVcgYJ75+Ox0OcULU2QzPU5Me9a6pbQmYMwZRsS8HN
   /o/B8pboI7ot+3l/fDsgh2Xwfgm4bRkfE2KZ47N4zz5sXw84wjF8JBe8+
   mk6upGembe7oVOCrV+TE8TO2gEPc0e3JFI9XyauDf0pTXCuw6bSqhNbE7
   lpOh3ZFLoZpWW1+L1jBq/d143revkxb4mDohaYPIeE8bBaWZPm/kc+T8P
   gp25XYsdHLRu1tcHrwKMkOYSvhepDQGBKnWEazvarXQSc7HMzqvXOsEFF
   CA6C90LeduM/39QNMl+6d7eE1u3BT9s7CalToebi7WicT7kxQ8k5wKyPE
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="245714164"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="245714164"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 19:44:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="596064017"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 26 Apr 2022 19:44:20 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njXf9-0004Eg-He;
        Wed, 27 Apr 2022 02:44:19 +0000
Date:   Wed, 27 Apr 2022 10:44:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Min Li <min.li.xe@renesas.com>, richardcochran@gmail.com,
        lee.jones@linaro.org
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Min Li <min.li.xe@renesas.com>
Subject: Re: [PATCH net 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS
 support
Message-ID: <202204271014.NroTeynI-lkp@intel.com>
References: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
config: i386-randconfig-a012-20220425 (https://download.01.org/0day-ci/archive/20220427/202204271014.NroTeynI-lkp@intel.com/config)
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

   ld: drivers/ptp/ptp_clockmatrix.o: in function `idtcm_get_dco_delay':
>> drivers/ptp/ptp_clockmatrix.c:2222: undefined reference to `__udivdi3'
>> ld: drivers/ptp/ptp_clockmatrix.c:2225: undefined reference to `__udivdi3'


vim +2222 drivers/ptp/ptp_clockmatrix.c

  2191	
  2192	/*
  2193	 * Compensate for the PTP DCO input-to-output delay.
  2194	 * This delay is 18 FOD cycles.
  2195	 */
  2196	static u32 idtcm_get_dco_delay(struct idtcm_channel *channel)
  2197	{
  2198		struct idtcm *idtcm = channel->idtcm;
  2199		u8 mbuf[8] = {0};
  2200		u8 nbuf[2] = {0};
  2201		u32 fodFreq;
  2202		int err;
  2203		u64 m;
  2204		u16 n;
  2205	
  2206		err = idtcm_read(idtcm, channel->dpll_ctrl_n,
  2207				 DPLL_CTRL_DPLL_FOD_FREQ, mbuf, 6);
  2208		if (err)
  2209			return 0;
  2210	
  2211		err = idtcm_read(idtcm, channel->dpll_ctrl_n,
  2212				 DPLL_CTRL_DPLL_FOD_FREQ + 6, nbuf, 2);
  2213		if (err)
  2214			return 0;
  2215	
  2216		m = get_unaligned_le64(mbuf);
  2217		n = get_unaligned_le16(nbuf);
  2218	
  2219		if (n == 0)
  2220			n = 1;
  2221	
> 2222		fodFreq = m / n;
  2223	
  2224		if (fodFreq >= 500000000)
> 2225			return 18 * (u64)NSEC_PER_SEC / fodFreq;
  2226	
  2227		return 0;
  2228	}
  2229	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

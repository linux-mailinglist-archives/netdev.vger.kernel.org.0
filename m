Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF72511047
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 06:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357717AbiD0Eui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 00:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiD0Euh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 00:50:37 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B4437026;
        Tue, 26 Apr 2022 21:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651034847; x=1682570847;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WzSMSV2TwjL7haK9v+p5S60fiyMUyMDXVixSJO/dIIo=;
  b=Ici5j9AH+lcYEWD0cRmj8drYvdRrgB/qHvR4vxO/IxqfzaSILWisccDd
   S9rFF51c/wGMy/88DtFUiNfa/Wsyd9CGQR0GoKgiQidKGj4ZYbJZTI1Ls
   d5h884pXEbvfeKNGVBIE1M6pSSlFz1hIghJL59eniobRDaKc04HSp6bm9
   PH4fCPA/Q6dsAm9+NEs6h718tuTVkQ4ZfkCLQxRb8dcSmUydTbKmgqqbz
   7EooKEgZY2LaFqOhpROMCypUO+1MINZzC4MGcg5UrBX3x04IpjeS6Y7Cw
   BNxED0g5Q8jjJ2lI/jFO5m0DDHZrNjfJ1UoK1g0rLxd1AfW2RNZiT7uwD
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="264657951"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="264657951"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 21:47:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="513501004"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 26 Apr 2022 21:47:24 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njZaF-0004L0-Vj;
        Wed, 27 Apr 2022 04:47:23 +0000
Date:   Wed, 27 Apr 2022 12:46:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Min Li <min.li.xe@renesas.com>, richardcochran@gmail.com,
        lee.jones@linaro.org
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Min Li <min.li.xe@renesas.com>
Subject: Re: [PATCH net 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS
 support
Message-ID: <202204271207.RNo6doix-lkp@intel.com>
References: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Min,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Min-Li/ptp-ptp_clockmatrix-Add-PTP_CLK_REQ_EXTTS-support/20220427-033506
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git acb16b395c3f3d7502443e0c799c2b42df645642
config: mips-allmodconfig (https://download.01.org/0day-ci/archive/20220427/202204271207.RNo6doix-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/afadc4edd1bf64b40cb61b38dedf67354baeb147
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Min-Li/ptp-ptp_clockmatrix-Add-PTP_CLK_REQ_EXTTS-support/20220427-033506
        git checkout afadc4edd1bf64b40cb61b38dedf67354baeb147
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash drivers/iio/imu/ drivers/ptp/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/ptp/ptp_clockmatrix.c:1734: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * Maximum absolute value for write phase offset in picoseconds


vim +1734 drivers/ptp/ptp_clockmatrix.c

3a6ba7dc779935 Vincent Cheng 2019-10-31  1732  
afadc4edd1bf64 Min Li        2022-04-26  1733  /**
da9facf1c18252 Min Li        2021-09-13 @1734   * Maximum absolute value for write phase offset in picoseconds
da9facf1c18252 Min Li        2021-09-13  1735   *
afadc4edd1bf64 Min Li        2022-04-26  1736   * @channel:  channel
afadc4edd1bf64 Min Li        2022-04-26  1737   * @delta_ns: delta in nanoseconds
afadc4edd1bf64 Min Li        2022-04-26  1738   *
425d2b1c563826 Vincent Cheng 2020-05-01  1739   * Destination signed register is 32-bit register in resolution of 50ps
425d2b1c563826 Vincent Cheng 2020-05-01  1740   *
425d2b1c563826 Vincent Cheng 2020-05-01  1741   * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
425d2b1c563826 Vincent Cheng 2020-05-01  1742   */
425d2b1c563826 Vincent Cheng 2020-05-01  1743  static int _idtcm_adjphase(struct idtcm_channel *channel, s32 delta_ns)
425d2b1c563826 Vincent Cheng 2020-05-01  1744  {
425d2b1c563826 Vincent Cheng 2020-05-01  1745  	struct idtcm *idtcm = channel->idtcm;
425d2b1c563826 Vincent Cheng 2020-05-01  1746  	int err;
425d2b1c563826 Vincent Cheng 2020-05-01  1747  	u8 i;
425d2b1c563826 Vincent Cheng 2020-05-01  1748  	u8 buf[4] = {0};
425d2b1c563826 Vincent Cheng 2020-05-01  1749  	s32 phase_50ps;
425d2b1c563826 Vincent Cheng 2020-05-01  1750  	s64 offset_ps;
425d2b1c563826 Vincent Cheng 2020-05-01  1751  
da9facf1c18252 Min Li        2021-09-13  1752  	if (channel->mode != PTP_PLL_MODE_WRITE_PHASE) {
da9facf1c18252 Min Li        2021-09-13  1753  		err = channel->configure_write_phase(channel);
425d2b1c563826 Vincent Cheng 2020-05-01  1754  		if (err)
425d2b1c563826 Vincent Cheng 2020-05-01  1755  			return err;
425d2b1c563826 Vincent Cheng 2020-05-01  1756  	}
425d2b1c563826 Vincent Cheng 2020-05-01  1757  
425d2b1c563826 Vincent Cheng 2020-05-01  1758  	offset_ps = (s64)delta_ns * 1000;
425d2b1c563826 Vincent Cheng 2020-05-01  1759  
425d2b1c563826 Vincent Cheng 2020-05-01  1760  	/*
425d2b1c563826 Vincent Cheng 2020-05-01  1761  	 * Check for 32-bit signed max * 50:
425d2b1c563826 Vincent Cheng 2020-05-01  1762  	 *
425d2b1c563826 Vincent Cheng 2020-05-01  1763  	 * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
425d2b1c563826 Vincent Cheng 2020-05-01  1764  	 */
425d2b1c563826 Vincent Cheng 2020-05-01  1765  	if (offset_ps > MAX_ABS_WRITE_PHASE_PICOSECONDS)
425d2b1c563826 Vincent Cheng 2020-05-01  1766  		offset_ps = MAX_ABS_WRITE_PHASE_PICOSECONDS;
425d2b1c563826 Vincent Cheng 2020-05-01  1767  	else if (offset_ps < -MAX_ABS_WRITE_PHASE_PICOSECONDS)
425d2b1c563826 Vincent Cheng 2020-05-01  1768  		offset_ps = -MAX_ABS_WRITE_PHASE_PICOSECONDS;
425d2b1c563826 Vincent Cheng 2020-05-01  1769  
7260d1c8fd8667 Min Li        2020-12-08  1770  	phase_50ps = div_s64(offset_ps, 50);
425d2b1c563826 Vincent Cheng 2020-05-01  1771  
425d2b1c563826 Vincent Cheng 2020-05-01  1772  	for (i = 0; i < 4; i++) {
425d2b1c563826 Vincent Cheng 2020-05-01  1773  		buf[i] = phase_50ps & 0xff;
425d2b1c563826 Vincent Cheng 2020-05-01  1774  		phase_50ps >>= 8;
425d2b1c563826 Vincent Cheng 2020-05-01  1775  	}
425d2b1c563826 Vincent Cheng 2020-05-01  1776  
425d2b1c563826 Vincent Cheng 2020-05-01  1777  	err = idtcm_write(idtcm, channel->dpll_phase, DPLL_WR_PHASE,
425d2b1c563826 Vincent Cheng 2020-05-01  1778  			  buf, sizeof(buf));
425d2b1c563826 Vincent Cheng 2020-05-01  1779  
425d2b1c563826 Vincent Cheng 2020-05-01  1780  	return err;
425d2b1c563826 Vincent Cheng 2020-05-01  1781  }
425d2b1c563826 Vincent Cheng 2020-05-01  1782  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

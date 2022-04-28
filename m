Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CD0512C10
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 08:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240467AbiD1G61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 02:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235345AbiD1G60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 02:58:26 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A3BB1E6
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 23:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651128912; x=1682664912;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=f/6Bm9I/pUXlP49N+RK1PmCoUDhG7E16Wj778YaNEAM=;
  b=adyCQvpztjeVqa/i8Ah3sSiiUxd3OR1/P4mUPq77VRSGR826wJxaq8WI
   huooGHuFZneQnyXnwBISz3E2UBWE7WYb5gHrWxaGOxdH1ihA0Ki397e1/
   EtAIzG02BtlWDo+Zr3boNpO8rP6GUf7DE9uX0wXwoQZw1SpxoC4h/nE2w
   +QZecBu1W7G92ri5DOAB5VjhX1PEiQ7wOARDh4AUBL4sc+nVo22TownOw
   rP/r9pkr+cjraftb3DlXrqkc/miLV63eF5CGJHDGYBR9bTg+dNCc4im9b
   JLfIRlRqbsltL1bDvxaNt1Bj1VzTPU8ZaBWVS3EAzfQz197et6bgqBvpo
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="246741325"
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="246741325"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 23:55:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="651089157"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Apr 2022 23:55:11 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njy3S-00058r-Lm;
        Thu, 28 Apr 2022 06:55:10 +0000
Date:   Thu, 28 Apr 2022 14:54:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [net-next:master 13/22]
 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c:342:23: error: implicit
 declaration of function 'ptp_find_pin_unlocked'
Message-ID: <202204281438.dM82P8DP-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   50c6afabfd2ae91a4ff0e2feb14fe702b0688ec5
commit: f3d8e0a9c28ba0bb3716dd5e8697a075ea36fdd8 [13/22] net: lan966x: Add support for PTP_PF_EXTTS
config: microblaze-randconfig-r011-20220428 (https://download.01.org/0day-ci/archive/20220428/202204281438.dM82P8DP-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=f3d8e0a9c28ba0bb3716dd5e8697a075ea36fdd8
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout f3d8e0a9c28ba0bb3716dd5e8697a075ea36fdd8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=microblaze SHELL=/bin/bash drivers/net/ethernet/microchip/lan966x/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c: In function 'lan966x_ptp_ext_irq_handler':
>> drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c:342:23: error: implicit declaration of function 'ptp_find_pin_unlocked' [-Werror=implicit-function-declaration]
     342 |                 pin = ptp_find_pin_unlocked(phc->clock, PTP_PF_EXTTS, 0);
         |                       ^~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/ptp_find_pin_unlocked +342 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c

   323	
   324	irqreturn_t lan966x_ptp_ext_irq_handler(int irq, void *args)
   325	{
   326		struct lan966x *lan966x = args;
   327		struct lan966x_phc *phc;
   328		unsigned long flags;
   329		u64 time = 0;
   330		time64_t s;
   331		int pin, i;
   332		s64 ns;
   333	
   334		if (!(lan_rd(lan966x, PTP_PIN_INTR)))
   335			return IRQ_NONE;
   336	
   337		/* Go through all domains and see which pin generated the interrupt */
   338		for (i = 0; i < LAN966X_PHC_COUNT; ++i) {
   339			struct ptp_clock_event ptp_event = {0};
   340	
   341			phc = &lan966x->phc[i];
 > 342			pin = ptp_find_pin_unlocked(phc->clock, PTP_PF_EXTTS, 0);
   343			if (pin == -1)
   344				continue;
   345	
   346			if (!(lan_rd(lan966x, PTP_PIN_INTR) & BIT(pin)))
   347				continue;
   348	
   349			spin_lock_irqsave(&lan966x->ptp_clock_lock, flags);
   350	
   351			/* Enable to get the new interrupt.
   352			 * By writing 1 it clears the bit
   353			 */
   354			lan_wr(BIT(pin), lan966x, PTP_PIN_INTR);
   355	
   356			/* Get current time */
   357			s = lan_rd(lan966x, PTP_TOD_SEC_MSB(pin));
   358			s <<= 32;
   359			s |= lan_rd(lan966x, PTP_TOD_SEC_LSB(pin));
   360			ns = lan_rd(lan966x, PTP_TOD_NSEC(pin));
   361			ns &= PTP_TOD_NSEC_TOD_NSEC;
   362	
   363			spin_unlock_irqrestore(&lan966x->ptp_clock_lock, flags);
   364	
   365			if ((ns & 0xFFFFFFF0) == 0x3FFFFFF0) {
   366				s--;
   367				ns &= 0xf;
   368				ns += 999999984;
   369			}
   370			time = ktime_set(s, ns);
   371	
   372			ptp_event.index = pin;
   373			ptp_event.timestamp = time;
   374			ptp_event.type = PTP_CLOCK_EXTTS;
   375			ptp_clock_event(phc->clock, &ptp_event);
   376		}
   377	
   378		return IRQ_HANDLED;
   379	}
   380	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

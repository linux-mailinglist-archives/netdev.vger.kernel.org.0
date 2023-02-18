Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE2D69B7C5
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 03:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjBRCtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 21:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBRCs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 21:48:58 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6596642CC
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 18:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676688537; x=1708224537;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p0/1c3WaBnNrs6ZMItZ6J01nHklOnmNFLQx6HCVHSTM=;
  b=FUbbj9efuQbTvbnQ6Pb6FYlN4gezwEtcqniFTMcummfUL6342i3E6uYq
   CVHGCClICIDBDbUa9/3QHkn/AuM+lU66ZU3ggdBoRZ2rRp8BjvGwRJXgZ
   iUhFx8gm4vCMKJq6C/Uo9PNezbCkJ27UiS5Sa2sz0I3w31jMMulglkd1F
   VruWmxLCWNdJ/nlxyHNOn4q20nRY5On9L88TlhNsbInYaTfmaqLJA4oYE
   EUup8UzKzCuJVhHGvo0nfit5cPVuYKGhvfguB8JSfYiXWFWDfOIXZHz3h
   f+0EGKgp/zwL0VMsO0mBqdVZ4fuP3uU4jET/Pw3MAXuIUXNPDAJbSB+W4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="329853754"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="329853754"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 18:48:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="759600383"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="759600383"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Feb 2023 18:48:48 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pTDHI-000C2j-1l;
        Sat, 18 Feb 2023 02:48:44 +0000
Date:   Sat, 18 Feb 2023 10:48:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shannon Nelson <shannon.nelson@amd.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, drivers@pensando.io,
        brett.creeley@amd.com, Shannon Nelson <shannon.nelson@amd.com>
Subject: Re: [PATCH v3 net-next 14/14] pds_core: Kconfig and pds_core.rst
Message-ID: <202302181049.yeUQMeWY-lkp@intel.com>
References: <20230217225558.19837-15-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217225558.19837-15-shannon.nelson@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shannon,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Shannon-Nelson/devlink-add-enable_migration-parameter/20230218-065953
patch link:    https://lore.kernel.org/r/20230217225558.19837-15-shannon.nelson%40amd.com
patch subject: [PATCH v3 net-next 14/14] pds_core: Kconfig and pds_core.rst
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20230218/202302181049.yeUQMeWY-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/18ec7f7bcf0005650ea77647a39a2271f70cf1c2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shannon-Nelson/devlink-add-enable_migration-parameter/20230218-065953
        git checkout 18ec7f7bcf0005650ea77647a39a2271f70cf1c2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302181049.yeUQMeWY-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/amd/pds_core/adminq.c: In function 'pdsc_process_adminq':
>> drivers/net/ethernet/amd/pds_core/adminq.c:97:13: warning: variable 'index' set but not used [-Wunused-but-set-variable]
      97 |         u32 index;
         |             ^~~~~


vim +/index +97 drivers/net/ethernet/amd/pds_core/adminq.c

b708113c48cc6f Shannon Nelson 2023-02-17   85  
b708113c48cc6f Shannon Nelson 2023-02-17   86  void pdsc_process_adminq(struct pdsc_qcq *qcq)
b708113c48cc6f Shannon Nelson 2023-02-17   87  {
b708113c48cc6f Shannon Nelson 2023-02-17   88  	union pds_core_adminq_comp *comp;
b708113c48cc6f Shannon Nelson 2023-02-17   89  	struct pdsc_queue *q = &qcq->q;
b708113c48cc6f Shannon Nelson 2023-02-17   90  	struct pdsc *pdsc = qcq->pdsc;
b708113c48cc6f Shannon Nelson 2023-02-17   91  	struct pdsc_cq *cq = &qcq->cq;
b708113c48cc6f Shannon Nelson 2023-02-17   92  	struct pdsc_q_info *q_info;
b708113c48cc6f Shannon Nelson 2023-02-17   93  	unsigned long irqflags;
b708113c48cc6f Shannon Nelson 2023-02-17   94  	int nq_work = 0;
b708113c48cc6f Shannon Nelson 2023-02-17   95  	int aq_work = 0;
b708113c48cc6f Shannon Nelson 2023-02-17   96  	int credits;
b708113c48cc6f Shannon Nelson 2023-02-17  @97  	u32 index;
b708113c48cc6f Shannon Nelson 2023-02-17   98  
b708113c48cc6f Shannon Nelson 2023-02-17   99  	/* Check for NotifyQ event */
b708113c48cc6f Shannon Nelson 2023-02-17  100  	nq_work = pdsc_process_notifyq(&pdsc->notifyqcq);
b708113c48cc6f Shannon Nelson 2023-02-17  101  
b708113c48cc6f Shannon Nelson 2023-02-17  102  	/* Check for empty queue, which can happen if the interrupt was
b708113c48cc6f Shannon Nelson 2023-02-17  103  	 * for a NotifyQ event and there are no new AdminQ completions.
b708113c48cc6f Shannon Nelson 2023-02-17  104  	 */
b708113c48cc6f Shannon Nelson 2023-02-17  105  	if (q->tail_idx == q->head_idx)
b708113c48cc6f Shannon Nelson 2023-02-17  106  		goto credits;
b708113c48cc6f Shannon Nelson 2023-02-17  107  
b708113c48cc6f Shannon Nelson 2023-02-17  108  	/* Find the first completion to clean,
b708113c48cc6f Shannon Nelson 2023-02-17  109  	 * run the callback in the related q_info,
b708113c48cc6f Shannon Nelson 2023-02-17  110  	 * and continue while we still match done color
b708113c48cc6f Shannon Nelson 2023-02-17  111  	 */
b708113c48cc6f Shannon Nelson 2023-02-17  112  	spin_lock_irqsave(&pdsc->adminq_lock, irqflags);
b708113c48cc6f Shannon Nelson 2023-02-17  113  	comp = cq->info[cq->tail_idx].comp;
b708113c48cc6f Shannon Nelson 2023-02-17  114  	while (pdsc_color_match(comp->color, cq->done_color)) {
b708113c48cc6f Shannon Nelson 2023-02-17  115  		q_info = &q->info[q->tail_idx];
b708113c48cc6f Shannon Nelson 2023-02-17  116  		index = q->tail_idx;
b708113c48cc6f Shannon Nelson 2023-02-17  117  		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
b708113c48cc6f Shannon Nelson 2023-02-17  118  
b708113c48cc6f Shannon Nelson 2023-02-17  119  		/* Copy out the completion data */
b708113c48cc6f Shannon Nelson 2023-02-17  120  		memcpy(q_info->dest, comp, sizeof(*comp));
b708113c48cc6f Shannon Nelson 2023-02-17  121  
b708113c48cc6f Shannon Nelson 2023-02-17  122  		complete_all(&q_info->wc->wait_completion);
b708113c48cc6f Shannon Nelson 2023-02-17  123  
b708113c48cc6f Shannon Nelson 2023-02-17  124  		if (cq->tail_idx == cq->num_descs - 1)
b708113c48cc6f Shannon Nelson 2023-02-17  125  			cq->done_color = !cq->done_color;
b708113c48cc6f Shannon Nelson 2023-02-17  126  		cq->tail_idx = (cq->tail_idx + 1) & (cq->num_descs - 1);
b708113c48cc6f Shannon Nelson 2023-02-17  127  		comp = cq->info[cq->tail_idx].comp;
b708113c48cc6f Shannon Nelson 2023-02-17  128  
b708113c48cc6f Shannon Nelson 2023-02-17  129  		aq_work++;
b708113c48cc6f Shannon Nelson 2023-02-17  130  	}
b708113c48cc6f Shannon Nelson 2023-02-17  131  	spin_unlock_irqrestore(&pdsc->adminq_lock, irqflags);
b708113c48cc6f Shannon Nelson 2023-02-17  132  
b708113c48cc6f Shannon Nelson 2023-02-17  133  	qcq->accum_work += aq_work;
b708113c48cc6f Shannon Nelson 2023-02-17  134  
b708113c48cc6f Shannon Nelson 2023-02-17  135  credits:
b708113c48cc6f Shannon Nelson 2023-02-17  136  	/* Return the interrupt credits, one for each completion */
b708113c48cc6f Shannon Nelson 2023-02-17  137  	credits = nq_work + aq_work;
b708113c48cc6f Shannon Nelson 2023-02-17  138  	if (credits)
b708113c48cc6f Shannon Nelson 2023-02-17  139  		pds_core_intr_credits(&pdsc->intr_ctrl[qcq->intx],
b708113c48cc6f Shannon Nelson 2023-02-17  140  				      credits,
b708113c48cc6f Shannon Nelson 2023-02-17  141  				      PDS_CORE_INTR_CRED_REARM);
b708113c48cc6f Shannon Nelson 2023-02-17  142  }
b708113c48cc6f Shannon Nelson 2023-02-17  143  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

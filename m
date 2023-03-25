Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3666C90C0
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 21:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjCYUlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 16:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCYUlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 16:41:22 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5B0BDEE
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 13:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679776881; x=1711312881;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fGt2+Vx34ILelNnSTtPysf8kah2N3D9GxOynY+elDFE=;
  b=B4n2boaVxfHZa54XFJ45spqbdSCh8or4ckrSfKqEZBDgNmDeGXQ29n7i
   6SaDenN9ToXqurUiZ9nuP4bfPK6AvBxBEB5lub3Fz1VRgUqvJbc7Z01jG
   fji/KDJzGNg+wtpEaJvVal+iq+wVu6oH8I8mbxKBL8+mLjXzBjMbEbzI5
   6ObUB4VVQ2w23WVOuVpoDnlcN8plrfm9HH7tu1ADAkvXohvBIFPeY2NHv
   +122rsIddw5APQGbabrP3eZWRf7PFlg6KVDQvEF+vTyOHavwOZpH69Fgt
   9FWYnARiUmFBlu69HWW9KM1u97WZwUBvpAgJxufxhSwvIUile+/XHPTvP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10660"; a="404935748"
X-IronPort-AV: E=Sophos;i="5.98,291,1673942400"; 
   d="scan'208";a="404935748"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2023 13:41:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10660"; a="683022479"
X-IronPort-AV: E=Sophos;i="5.98,291,1673942400"; 
   d="scan'208";a="683022479"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 25 Mar 2023 13:41:18 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pgAhR-000GeJ-1c;
        Sat, 25 Mar 2023 20:41:17 +0000
Date:   Sun, 26 Mar 2023 04:40:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shannon Nelson <shannon.nelson@amd.com>, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, drivers@pensando.io,
        leon@kernel.org, jiri@resnulli.us
Subject: Re: [PATCH v6 net-next 14/14] pds_core: Kconfig and pds_core.rst
Message-ID: <202303260420.Tgq0qobF-lkp@intel.com>
References: <20230324190243.27722-15-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324190243.27722-15-shannon.nelson@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shannon,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Shannon-Nelson/pds_core-initial-framework-for-pds_core-PF-driver/20230325-030501
patch link:    https://lore.kernel.org/r/20230324190243.27722-15-shannon.nelson%40amd.com
patch subject: [PATCH v6 net-next 14/14] pds_core: Kconfig and pds_core.rst
config: mips-randconfig-r006-20230326 (https://download.01.org/0day-ci/archive/20230326/202303260420.Tgq0qobF-lkp@intel.com/config)
compiler: mips64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/dd8c8b0ffae4db2f83e11b696198afa72d99c1b0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shannon-Nelson/pds_core-initial-framework-for-pds_core-PF-driver/20230325-030501
        git checkout dd8c8b0ffae4db2f83e11b696198afa72d99c1b0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=mips olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash drivers/net/ethernet/amd/pds_core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303260420.Tgq0qobF-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   drivers/net/ethernet/amd/pds_core/core.c: In function 'pdsc_qcq_free':
>> drivers/net/ethernet/amd/pds_core/core.c:161:17: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
     161 |                 vfree(qcq->cq.info);
         |                 ^~~~~
         |                 kvfree
   drivers/net/ethernet/amd/pds_core/core.c: In function 'pdsc_qcq_alloc':
>> drivers/net/ethernet/amd/pds_core/core.c:209:23: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
     209 |         qcq->q.info = vzalloc(num_descs * sizeof(*qcq->q.info));
         |                       ^~~~~~~
         |                       kvzalloc
>> drivers/net/ethernet/amd/pds_core/core.c:209:21: warning: assignment to 'struct pdsc_q_info *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     209 |         qcq->q.info = vzalloc(num_descs * sizeof(*qcq->q.info));
         |                     ^
>> drivers/net/ethernet/amd/pds_core/core.c:232:22: warning: assignment to 'struct pdsc_cq_info *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     232 |         qcq->cq.info = vzalloc(num_descs * sizeof(*qcq->cq.info));
         |                      ^
   cc1: some warnings being treated as errors


vim +161 drivers/net/ethernet/amd/pds_core/core.c

520bb62de695d83 Shannon Nelson 2023-03-24  134  
520bb62de695d83 Shannon Nelson 2023-03-24  135  void pdsc_qcq_free(struct pdsc *pdsc, struct pdsc_qcq *qcq)
520bb62de695d83 Shannon Nelson 2023-03-24  136  {
520bb62de695d83 Shannon Nelson 2023-03-24  137  	struct device *dev = pdsc->dev;
520bb62de695d83 Shannon Nelson 2023-03-24  138  
520bb62de695d83 Shannon Nelson 2023-03-24  139  	if (!(qcq && qcq->pdsc))
520bb62de695d83 Shannon Nelson 2023-03-24  140  		return;
520bb62de695d83 Shannon Nelson 2023-03-24  141  
520bb62de695d83 Shannon Nelson 2023-03-24  142  	pdsc_debugfs_del_qcq(qcq);
520bb62de695d83 Shannon Nelson 2023-03-24  143  
520bb62de695d83 Shannon Nelson 2023-03-24  144  	pdsc_qcq_intr_free(pdsc, qcq);
520bb62de695d83 Shannon Nelson 2023-03-24  145  
520bb62de695d83 Shannon Nelson 2023-03-24  146  	if (qcq->q_base) {
520bb62de695d83 Shannon Nelson 2023-03-24  147  		dma_free_coherent(dev, qcq->q_size,
520bb62de695d83 Shannon Nelson 2023-03-24  148  				  qcq->q_base, qcq->q_base_pa);
520bb62de695d83 Shannon Nelson 2023-03-24  149  		qcq->q_base = NULL;
520bb62de695d83 Shannon Nelson 2023-03-24  150  		qcq->q_base_pa = 0;
520bb62de695d83 Shannon Nelson 2023-03-24  151  	}
520bb62de695d83 Shannon Nelson 2023-03-24  152  
520bb62de695d83 Shannon Nelson 2023-03-24  153  	if (qcq->cq_base) {
520bb62de695d83 Shannon Nelson 2023-03-24  154  		dma_free_coherent(dev, qcq->cq_size,
520bb62de695d83 Shannon Nelson 2023-03-24  155  				  qcq->cq_base, qcq->cq_base_pa);
520bb62de695d83 Shannon Nelson 2023-03-24  156  		qcq->cq_base = NULL;
520bb62de695d83 Shannon Nelson 2023-03-24  157  		qcq->cq_base_pa = 0;
520bb62de695d83 Shannon Nelson 2023-03-24  158  	}
520bb62de695d83 Shannon Nelson 2023-03-24  159  
520bb62de695d83 Shannon Nelson 2023-03-24  160  	if (qcq->cq.info) {
520bb62de695d83 Shannon Nelson 2023-03-24 @161  		vfree(qcq->cq.info);
520bb62de695d83 Shannon Nelson 2023-03-24  162  		qcq->cq.info = NULL;
520bb62de695d83 Shannon Nelson 2023-03-24  163  	}
520bb62de695d83 Shannon Nelson 2023-03-24  164  	if (qcq->q.info) {
520bb62de695d83 Shannon Nelson 2023-03-24  165  		vfree(qcq->q.info);
520bb62de695d83 Shannon Nelson 2023-03-24  166  		qcq->q.info = NULL;
520bb62de695d83 Shannon Nelson 2023-03-24  167  	}
520bb62de695d83 Shannon Nelson 2023-03-24  168  
520bb62de695d83 Shannon Nelson 2023-03-24  169  	qcq->pdsc = NULL;
520bb62de695d83 Shannon Nelson 2023-03-24  170  	memset(&qcq->q, 0, sizeof(qcq->q));
520bb62de695d83 Shannon Nelson 2023-03-24  171  	memset(&qcq->cq, 0, sizeof(qcq->cq));
520bb62de695d83 Shannon Nelson 2023-03-24  172  }
520bb62de695d83 Shannon Nelson 2023-03-24  173  
520bb62de695d83 Shannon Nelson 2023-03-24  174  static void pdsc_q_map(struct pdsc_queue *q, void *base, dma_addr_t base_pa)
520bb62de695d83 Shannon Nelson 2023-03-24  175  {
520bb62de695d83 Shannon Nelson 2023-03-24  176  	struct pdsc_q_info *cur;
520bb62de695d83 Shannon Nelson 2023-03-24  177  	unsigned int i;
520bb62de695d83 Shannon Nelson 2023-03-24  178  
520bb62de695d83 Shannon Nelson 2023-03-24  179  	q->base = base;
520bb62de695d83 Shannon Nelson 2023-03-24  180  	q->base_pa = base_pa;
520bb62de695d83 Shannon Nelson 2023-03-24  181  
520bb62de695d83 Shannon Nelson 2023-03-24  182  	for (i = 0, cur = q->info; i < q->num_descs; i++, cur++)
520bb62de695d83 Shannon Nelson 2023-03-24  183  		cur->desc = base + (i * q->desc_size);
520bb62de695d83 Shannon Nelson 2023-03-24  184  }
520bb62de695d83 Shannon Nelson 2023-03-24  185  
520bb62de695d83 Shannon Nelson 2023-03-24  186  static void pdsc_cq_map(struct pdsc_cq *cq, void *base, dma_addr_t base_pa)
520bb62de695d83 Shannon Nelson 2023-03-24  187  {
520bb62de695d83 Shannon Nelson 2023-03-24  188  	struct pdsc_cq_info *cur;
520bb62de695d83 Shannon Nelson 2023-03-24  189  	unsigned int i;
520bb62de695d83 Shannon Nelson 2023-03-24  190  
520bb62de695d83 Shannon Nelson 2023-03-24  191  	cq->base = base;
520bb62de695d83 Shannon Nelson 2023-03-24  192  	cq->base_pa = base_pa;
520bb62de695d83 Shannon Nelson 2023-03-24  193  
520bb62de695d83 Shannon Nelson 2023-03-24  194  	for (i = 0, cur = cq->info; i < cq->num_descs; i++, cur++)
520bb62de695d83 Shannon Nelson 2023-03-24  195  		cur->comp = base + (i * cq->desc_size);
520bb62de695d83 Shannon Nelson 2023-03-24  196  }
520bb62de695d83 Shannon Nelson 2023-03-24  197  
520bb62de695d83 Shannon Nelson 2023-03-24  198  int pdsc_qcq_alloc(struct pdsc *pdsc, unsigned int type, unsigned int index,
520bb62de695d83 Shannon Nelson 2023-03-24  199  		   const char *name, unsigned int flags, unsigned int num_descs,
520bb62de695d83 Shannon Nelson 2023-03-24  200  		   unsigned int desc_size, unsigned int cq_desc_size,
520bb62de695d83 Shannon Nelson 2023-03-24  201  		   unsigned int pid, struct pdsc_qcq *qcq)
520bb62de695d83 Shannon Nelson 2023-03-24  202  {
520bb62de695d83 Shannon Nelson 2023-03-24  203  	struct device *dev = pdsc->dev;
520bb62de695d83 Shannon Nelson 2023-03-24  204  	dma_addr_t cq_base_pa = 0;
520bb62de695d83 Shannon Nelson 2023-03-24  205  	dma_addr_t q_base_pa = 0;
520bb62de695d83 Shannon Nelson 2023-03-24  206  	void *q_base, *cq_base;
520bb62de695d83 Shannon Nelson 2023-03-24  207  	int err;
520bb62de695d83 Shannon Nelson 2023-03-24  208  
520bb62de695d83 Shannon Nelson 2023-03-24 @209  	qcq->q.info = vzalloc(num_descs * sizeof(*qcq->q.info));
520bb62de695d83 Shannon Nelson 2023-03-24  210  	if (!qcq->q.info) {
520bb62de695d83 Shannon Nelson 2023-03-24  211  		err = -ENOMEM;
520bb62de695d83 Shannon Nelson 2023-03-24  212  		goto err_out;
520bb62de695d83 Shannon Nelson 2023-03-24  213  	}
520bb62de695d83 Shannon Nelson 2023-03-24  214  
520bb62de695d83 Shannon Nelson 2023-03-24  215  	qcq->pdsc = pdsc;
520bb62de695d83 Shannon Nelson 2023-03-24  216  	qcq->flags = flags;
520bb62de695d83 Shannon Nelson 2023-03-24  217  	INIT_WORK(&qcq->work, pdsc_work_thread);
520bb62de695d83 Shannon Nelson 2023-03-24  218  
520bb62de695d83 Shannon Nelson 2023-03-24  219  	qcq->q.type = type;
520bb62de695d83 Shannon Nelson 2023-03-24  220  	qcq->q.index = index;
520bb62de695d83 Shannon Nelson 2023-03-24  221  	qcq->q.num_descs = num_descs;
520bb62de695d83 Shannon Nelson 2023-03-24  222  	qcq->q.desc_size = desc_size;
520bb62de695d83 Shannon Nelson 2023-03-24  223  	qcq->q.tail_idx = 0;
520bb62de695d83 Shannon Nelson 2023-03-24  224  	qcq->q.head_idx = 0;
520bb62de695d83 Shannon Nelson 2023-03-24  225  	qcq->q.pid = pid;
520bb62de695d83 Shannon Nelson 2023-03-24  226  	snprintf(qcq->q.name, sizeof(qcq->q.name), "%s%u", name, index);
520bb62de695d83 Shannon Nelson 2023-03-24  227  
520bb62de695d83 Shannon Nelson 2023-03-24  228  	err = pdsc_qcq_intr_alloc(pdsc, qcq);
520bb62de695d83 Shannon Nelson 2023-03-24  229  	if (err)
520bb62de695d83 Shannon Nelson 2023-03-24  230  		goto err_out_free_q_info;
520bb62de695d83 Shannon Nelson 2023-03-24  231  
520bb62de695d83 Shannon Nelson 2023-03-24 @232  	qcq->cq.info = vzalloc(num_descs * sizeof(*qcq->cq.info));
520bb62de695d83 Shannon Nelson 2023-03-24  233  	if (!qcq->cq.info) {
520bb62de695d83 Shannon Nelson 2023-03-24  234  		err = -ENOMEM;
520bb62de695d83 Shannon Nelson 2023-03-24  235  		goto err_out_free_irq;
520bb62de695d83 Shannon Nelson 2023-03-24  236  	}
520bb62de695d83 Shannon Nelson 2023-03-24  237  
520bb62de695d83 Shannon Nelson 2023-03-24  238  	qcq->cq.bound_intr = &pdsc->intr_info[qcq->intx];
520bb62de695d83 Shannon Nelson 2023-03-24  239  	qcq->cq.num_descs = num_descs;
520bb62de695d83 Shannon Nelson 2023-03-24  240  	qcq->cq.desc_size = cq_desc_size;
520bb62de695d83 Shannon Nelson 2023-03-24  241  	qcq->cq.tail_idx = 0;
520bb62de695d83 Shannon Nelson 2023-03-24  242  	qcq->cq.done_color = 1;
520bb62de695d83 Shannon Nelson 2023-03-24  243  
520bb62de695d83 Shannon Nelson 2023-03-24  244  	if (flags & PDS_CORE_QCQ_F_NOTIFYQ) {
520bb62de695d83 Shannon Nelson 2023-03-24  245  		/* q & cq need to be contiguous in case of notifyq */
520bb62de695d83 Shannon Nelson 2023-03-24  246  		qcq->q_size = PDS_PAGE_SIZE +
520bb62de695d83 Shannon Nelson 2023-03-24  247  			      ALIGN(num_descs * desc_size, PDS_PAGE_SIZE) +
520bb62de695d83 Shannon Nelson 2023-03-24  248  			      ALIGN(num_descs * cq_desc_size, PDS_PAGE_SIZE);
520bb62de695d83 Shannon Nelson 2023-03-24  249  		qcq->q_base = dma_alloc_coherent(dev,
520bb62de695d83 Shannon Nelson 2023-03-24  250  						 qcq->q_size + qcq->cq_size,
520bb62de695d83 Shannon Nelson 2023-03-24  251  						 &qcq->q_base_pa,
520bb62de695d83 Shannon Nelson 2023-03-24  252  						 GFP_KERNEL);
520bb62de695d83 Shannon Nelson 2023-03-24  253  		if (!qcq->q_base) {
520bb62de695d83 Shannon Nelson 2023-03-24  254  			err = -ENOMEM;
520bb62de695d83 Shannon Nelson 2023-03-24  255  			goto err_out_free_cq_info;
520bb62de695d83 Shannon Nelson 2023-03-24  256  		}
520bb62de695d83 Shannon Nelson 2023-03-24  257  		q_base = PTR_ALIGN(qcq->q_base, PDS_PAGE_SIZE);
520bb62de695d83 Shannon Nelson 2023-03-24  258  		q_base_pa = ALIGN(qcq->q_base_pa, PDS_PAGE_SIZE);
520bb62de695d83 Shannon Nelson 2023-03-24  259  		pdsc_q_map(&qcq->q, q_base, q_base_pa);
520bb62de695d83 Shannon Nelson 2023-03-24  260  
520bb62de695d83 Shannon Nelson 2023-03-24  261  		cq_base = PTR_ALIGN(q_base +
520bb62de695d83 Shannon Nelson 2023-03-24  262  				    ALIGN(num_descs * desc_size, PDS_PAGE_SIZE),
520bb62de695d83 Shannon Nelson 2023-03-24  263  				    PDS_PAGE_SIZE);
520bb62de695d83 Shannon Nelson 2023-03-24  264  		cq_base_pa = ALIGN(qcq->q_base_pa +
520bb62de695d83 Shannon Nelson 2023-03-24  265  				   ALIGN(num_descs * desc_size, PDS_PAGE_SIZE),
520bb62de695d83 Shannon Nelson 2023-03-24  266  				   PDS_PAGE_SIZE);
520bb62de695d83 Shannon Nelson 2023-03-24  267  
520bb62de695d83 Shannon Nelson 2023-03-24  268  	} else {
520bb62de695d83 Shannon Nelson 2023-03-24  269  		/* q DMA descriptors */
520bb62de695d83 Shannon Nelson 2023-03-24  270  		qcq->q_size = PDS_PAGE_SIZE + (num_descs * desc_size);
520bb62de695d83 Shannon Nelson 2023-03-24  271  		qcq->q_base = dma_alloc_coherent(dev, qcq->q_size,
520bb62de695d83 Shannon Nelson 2023-03-24  272  						 &qcq->q_base_pa,
520bb62de695d83 Shannon Nelson 2023-03-24  273  						 GFP_KERNEL);
520bb62de695d83 Shannon Nelson 2023-03-24  274  		if (!qcq->q_base) {
520bb62de695d83 Shannon Nelson 2023-03-24  275  			err = -ENOMEM;
520bb62de695d83 Shannon Nelson 2023-03-24  276  			goto err_out_free_cq_info;
520bb62de695d83 Shannon Nelson 2023-03-24  277  		}
520bb62de695d83 Shannon Nelson 2023-03-24  278  		q_base = PTR_ALIGN(qcq->q_base, PDS_PAGE_SIZE);
520bb62de695d83 Shannon Nelson 2023-03-24  279  		q_base_pa = ALIGN(qcq->q_base_pa, PDS_PAGE_SIZE);
520bb62de695d83 Shannon Nelson 2023-03-24  280  		pdsc_q_map(&qcq->q, q_base, q_base_pa);
520bb62de695d83 Shannon Nelson 2023-03-24  281  
520bb62de695d83 Shannon Nelson 2023-03-24  282  		/* cq DMA descriptors */
520bb62de695d83 Shannon Nelson 2023-03-24  283  		qcq->cq_size = PDS_PAGE_SIZE + (num_descs * cq_desc_size);
520bb62de695d83 Shannon Nelson 2023-03-24  284  		qcq->cq_base = dma_alloc_coherent(dev, qcq->cq_size,
520bb62de695d83 Shannon Nelson 2023-03-24  285  						  &qcq->cq_base_pa,
520bb62de695d83 Shannon Nelson 2023-03-24  286  						  GFP_KERNEL);
520bb62de695d83 Shannon Nelson 2023-03-24  287  		if (!qcq->cq_base) {
520bb62de695d83 Shannon Nelson 2023-03-24  288  			err = -ENOMEM;
520bb62de695d83 Shannon Nelson 2023-03-24  289  			goto err_out_free_q;
520bb62de695d83 Shannon Nelson 2023-03-24  290  		}
520bb62de695d83 Shannon Nelson 2023-03-24  291  		cq_base = PTR_ALIGN(qcq->cq_base, PDS_PAGE_SIZE);
520bb62de695d83 Shannon Nelson 2023-03-24  292  		cq_base_pa = ALIGN(qcq->cq_base_pa, PDS_PAGE_SIZE);
520bb62de695d83 Shannon Nelson 2023-03-24  293  	}
520bb62de695d83 Shannon Nelson 2023-03-24  294  
520bb62de695d83 Shannon Nelson 2023-03-24  295  	pdsc_cq_map(&qcq->cq, cq_base, cq_base_pa);
520bb62de695d83 Shannon Nelson 2023-03-24  296  	qcq->cq.bound_q = &qcq->q;
520bb62de695d83 Shannon Nelson 2023-03-24  297  
520bb62de695d83 Shannon Nelson 2023-03-24  298  	pdsc_debugfs_add_qcq(pdsc, qcq);
520bb62de695d83 Shannon Nelson 2023-03-24  299  
520bb62de695d83 Shannon Nelson 2023-03-24  300  	return 0;
520bb62de695d83 Shannon Nelson 2023-03-24  301  
520bb62de695d83 Shannon Nelson 2023-03-24  302  err_out_free_q:
520bb62de695d83 Shannon Nelson 2023-03-24  303  	dma_free_coherent(dev, qcq->q_size, qcq->q_base, qcq->q_base_pa);
520bb62de695d83 Shannon Nelson 2023-03-24  304  err_out_free_cq_info:
520bb62de695d83 Shannon Nelson 2023-03-24  305  	vfree(qcq->cq.info);
520bb62de695d83 Shannon Nelson 2023-03-24  306  err_out_free_irq:
520bb62de695d83 Shannon Nelson 2023-03-24  307  	pdsc_qcq_intr_free(pdsc, qcq);
520bb62de695d83 Shannon Nelson 2023-03-24  308  err_out_free_q_info:
520bb62de695d83 Shannon Nelson 2023-03-24  309  	vfree(qcq->q.info);
520bb62de695d83 Shannon Nelson 2023-03-24  310  	memset(qcq, 0, sizeof(*qcq));
520bb62de695d83 Shannon Nelson 2023-03-24  311  err_out:
520bb62de695d83 Shannon Nelson 2023-03-24  312  	dev_err(dev, "qcq alloc of %s%d failed %d\n", name, index, err);
520bb62de695d83 Shannon Nelson 2023-03-24  313  	return err;
520bb62de695d83 Shannon Nelson 2023-03-24  314  }
520bb62de695d83 Shannon Nelson 2023-03-24  315  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

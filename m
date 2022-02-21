Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0D44BD42B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 04:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344206AbiBUDYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 22:24:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbiBUDY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 22:24:29 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF8B31DEF
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 19:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645413846; x=1676949846;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=e03Kza9q/MCo8dIL4WZXJZXZ9Gl41wRIXkjXBZNNunA=;
  b=fnquUMS2MDZ5r0mc/gx12l51waIecg59ofoMy64RJBjqXj8bSp/NXmd7
   HYf+7WC7hK2mDQFTL3wgoZHZXUzijpUsefGhIChGQ3+QvXdZTVOt//Yyz
   nLzgaaSw2GmQp40rj6Ndk7FPWzIn0YVEAP4NaLFvGcA7B9OX7fRr+PeAh
   0rVhB+SMrD4toeoOFq18fCYKSDo4knYu3zh+vvzhuPQRb9qWg/s43lb76
   lIvo/f8BGqLhKTugLTYs5tQI0B4FX4tPXfGzRfA64LDW9QKq4MZfK0MC3
   nV0WqrS14wzUG/A5RewduOmsuL4u4Tqp3uPhh+VY9FqRXqoobujVjacf8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="249007606"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="249007606"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 19:24:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="683073356"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2022 19:24:05 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nLzIy-0001Fy-Do; Mon, 21 Feb 2022 03:24:04 +0000
Date:   Mon, 21 Feb 2022 11:23:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Brett Creeley <brett@pensando.io>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next:master 36/73]
 drivers/net/ethernet/pensando/ionic/ionic_lif.c:396:17: error: implicit
 declaration of function 'vfree'; did you mean 'kvfree'?
Message-ID: <202202211102.PqdsQa7U-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   adfb62dbda49d66eba6340324547ff89b09a66eb
commit: 116dce0ff047f8e37d99f414c419646c0cc71d0b [36/73] ionic: Use vzalloc for large per-queue related buffers
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20220221/202202211102.PqdsQa7U-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=116dce0ff047f8e37d99f414c419646c0cc71d0b
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout 116dce0ff047f8e37d99f414c419646c0cc71d0b
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=sparc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/pensando/ionic/ionic_lif.c: In function 'ionic_qcq_free':
>> drivers/net/ethernet/pensando/ionic/ionic_lif.c:396:17: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
     396 |                 vfree(qcq->cq.info);
         |                 ^~~~~
         |                 kvfree
   drivers/net/ethernet/pensando/ionic/ionic_lif.c: In function 'ionic_qcq_alloc':
>> drivers/net/ethernet/pensando/ionic/ionic_lif.c:531:23: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
     531 |         new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
         |                       ^~~~~~~
         |                       kvzalloc
   drivers/net/ethernet/pensando/ionic/ionic_lif.c:531:21: warning: assignment to 'struct ionic_desc_info *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     531 |         new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
         |                     ^
   drivers/net/ethernet/pensando/ionic/ionic_lif.c:552:22: warning: assignment to 'struct ionic_cq_info *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     552 |         new->cq.info = vzalloc(num_descs * sizeof(*new->cq.info));
         |                      ^
   cc1: some warnings being treated as errors


vim +396 drivers/net/ethernet/pensando/ionic/ionic_lif.c

   365	
   366	static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
   367	{
   368		struct device *dev = lif->ionic->dev;
   369	
   370		if (!qcq)
   371			return;
   372	
   373		ionic_debugfs_del_qcq(qcq);
   374	
   375		if (qcq->q_base) {
   376			dma_free_coherent(dev, qcq->q_size, qcq->q_base, qcq->q_base_pa);
   377			qcq->q_base = NULL;
   378			qcq->q_base_pa = 0;
   379		}
   380	
   381		if (qcq->cq_base) {
   382			dma_free_coherent(dev, qcq->cq_size, qcq->cq_base, qcq->cq_base_pa);
   383			qcq->cq_base = NULL;
   384			qcq->cq_base_pa = 0;
   385		}
   386	
   387		if (qcq->sg_base) {
   388			dma_free_coherent(dev, qcq->sg_size, qcq->sg_base, qcq->sg_base_pa);
   389			qcq->sg_base = NULL;
   390			qcq->sg_base_pa = 0;
   391		}
   392	
   393		ionic_qcq_intr_free(lif, qcq);
   394	
   395		if (qcq->cq.info) {
 > 396			vfree(qcq->cq.info);
   397			qcq->cq.info = NULL;
   398		}
   399		if (qcq->q.info) {
   400			vfree(qcq->q.info);
   401			qcq->q.info = NULL;
   402		}
   403	}
   404	
   405	static void ionic_qcqs_free(struct ionic_lif *lif)
   406	{
   407		struct device *dev = lif->ionic->dev;
   408		struct ionic_qcq *adminqcq;
   409		unsigned long irqflags;
   410	
   411		if (lif->notifyqcq) {
   412			ionic_qcq_free(lif, lif->notifyqcq);
   413			devm_kfree(dev, lif->notifyqcq);
   414			lif->notifyqcq = NULL;
   415		}
   416	
   417		if (lif->adminqcq) {
   418			spin_lock_irqsave(&lif->adminq_lock, irqflags);
   419			adminqcq = READ_ONCE(lif->adminqcq);
   420			lif->adminqcq = NULL;
   421			spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
   422			if (adminqcq) {
   423				ionic_qcq_free(lif, adminqcq);
   424				devm_kfree(dev, adminqcq);
   425			}
   426		}
   427	
   428		if (lif->rxqcqs) {
   429			devm_kfree(dev, lif->rxqstats);
   430			lif->rxqstats = NULL;
   431			devm_kfree(dev, lif->rxqcqs);
   432			lif->rxqcqs = NULL;
   433		}
   434	
   435		if (lif->txqcqs) {
   436			devm_kfree(dev, lif->txqstats);
   437			lif->txqstats = NULL;
   438			devm_kfree(dev, lif->txqcqs);
   439			lif->txqcqs = NULL;
   440		}
   441	}
   442	
   443	static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
   444					      struct ionic_qcq *n_qcq)
   445	{
   446		if (WARN_ON(n_qcq->flags & IONIC_QCQ_F_INTR)) {
   447			ionic_intr_free(n_qcq->cq.lif->ionic, n_qcq->intr.index);
   448			n_qcq->flags &= ~IONIC_QCQ_F_INTR;
   449		}
   450	
   451		n_qcq->intr.vector = src_qcq->intr.vector;
   452		n_qcq->intr.index = src_qcq->intr.index;
   453	}
   454	
   455	static int ionic_alloc_qcq_interrupt(struct ionic_lif *lif, struct ionic_qcq *qcq)
   456	{
   457		int err;
   458	
   459		if (!(qcq->flags & IONIC_QCQ_F_INTR)) {
   460			qcq->intr.index = IONIC_INTR_INDEX_NOT_ASSIGNED;
   461			return 0;
   462		}
   463	
   464		err = ionic_intr_alloc(lif, &qcq->intr);
   465		if (err) {
   466			netdev_warn(lif->netdev, "no intr for %s: %d\n",
   467				    qcq->q.name, err);
   468			goto err_out;
   469		}
   470	
   471		err = ionic_bus_get_irq(lif->ionic, qcq->intr.index);
   472		if (err < 0) {
   473			netdev_warn(lif->netdev, "no vector for %s: %d\n",
   474				    qcq->q.name, err);
   475			goto err_out_free_intr;
   476		}
   477		qcq->intr.vector = err;
   478		ionic_intr_mask_assert(lif->ionic->idev.intr_ctrl, qcq->intr.index,
   479				       IONIC_INTR_MASK_SET);
   480	
   481		err = ionic_request_irq(lif, qcq);
   482		if (err) {
   483			netdev_warn(lif->netdev, "irq request failed %d\n", err);
   484			goto err_out_free_intr;
   485		}
   486	
   487		/* try to get the irq on the local numa node first */
   488		qcq->intr.cpu = cpumask_local_spread(qcq->intr.index,
   489						     dev_to_node(lif->ionic->dev));
   490		if (qcq->intr.cpu != -1)
   491			cpumask_set_cpu(qcq->intr.cpu, &qcq->intr.affinity_mask);
   492	
   493		netdev_dbg(lif->netdev, "%s: Interrupt index %d\n", qcq->q.name, qcq->intr.index);
   494		return 0;
   495	
   496	err_out_free_intr:
   497		ionic_intr_free(lif->ionic, qcq->intr.index);
   498	err_out:
   499		return err;
   500	}
   501	
   502	static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
   503				   unsigned int index,
   504				   const char *name, unsigned int flags,
   505				   unsigned int num_descs, unsigned int desc_size,
   506				   unsigned int cq_desc_size,
   507				   unsigned int sg_desc_size,
   508				   unsigned int pid, struct ionic_qcq **qcq)
   509	{
   510		struct ionic_dev *idev = &lif->ionic->idev;
   511		struct device *dev = lif->ionic->dev;
   512		void *q_base, *cq_base, *sg_base;
   513		dma_addr_t cq_base_pa = 0;
   514		dma_addr_t sg_base_pa = 0;
   515		dma_addr_t q_base_pa = 0;
   516		struct ionic_qcq *new;
   517		int err;
   518	
   519		*qcq = NULL;
   520	
   521		new = devm_kzalloc(dev, sizeof(*new), GFP_KERNEL);
   522		if (!new) {
   523			netdev_err(lif->netdev, "Cannot allocate queue structure\n");
   524			err = -ENOMEM;
   525			goto err_out;
   526		}
   527	
   528		new->q.dev = dev;
   529		new->flags = flags;
   530	
 > 531		new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
   532		if (!new->q.info) {
   533			netdev_err(lif->netdev, "Cannot allocate queue info\n");
   534			err = -ENOMEM;
   535			goto err_out_free_qcq;
   536		}
   537	
   538		new->q.type = type;
   539		new->q.max_sg_elems = lif->qtype_info[type].max_sg_elems;
   540	
   541		err = ionic_q_init(lif, idev, &new->q, index, name, num_descs,
   542				   desc_size, sg_desc_size, pid);
   543		if (err) {
   544			netdev_err(lif->netdev, "Cannot initialize queue\n");
   545			goto err_out_free_q_info;
   546		}
   547	
   548		err = ionic_alloc_qcq_interrupt(lif, new);
   549		if (err)
   550			goto err_out;
   551	
   552		new->cq.info = vzalloc(num_descs * sizeof(*new->cq.info));
   553		if (!new->cq.info) {
   554			netdev_err(lif->netdev, "Cannot allocate completion queue info\n");
   555			err = -ENOMEM;
   556			goto err_out_free_irq;
   557		}
   558	
   559		err = ionic_cq_init(lif, &new->cq, &new->intr, num_descs, cq_desc_size);
   560		if (err) {
   561			netdev_err(lif->netdev, "Cannot initialize completion queue\n");
   562			goto err_out_free_cq_info;
   563		}
   564	
   565		if (flags & IONIC_QCQ_F_NOTIFYQ) {
   566			int q_size, cq_size;
   567	
   568			/* q & cq need to be contiguous in case of notifyq */
   569			q_size = ALIGN(num_descs * desc_size, PAGE_SIZE);
   570			cq_size = ALIGN(num_descs * cq_desc_size, PAGE_SIZE);
   571	
   572			new->q_size = PAGE_SIZE + q_size + cq_size;
   573			new->q_base = dma_alloc_coherent(dev, new->q_size,
   574							 &new->q_base_pa, GFP_KERNEL);
   575			if (!new->q_base) {
   576				netdev_err(lif->netdev, "Cannot allocate qcq DMA memory\n");
   577				err = -ENOMEM;
   578				goto err_out_free_cq_info;
   579			}
   580			q_base = PTR_ALIGN(new->q_base, PAGE_SIZE);
   581			q_base_pa = ALIGN(new->q_base_pa, PAGE_SIZE);
   582			ionic_q_map(&new->q, q_base, q_base_pa);
   583	
   584			cq_base = PTR_ALIGN(q_base + q_size, PAGE_SIZE);
   585			cq_base_pa = ALIGN(new->q_base_pa + q_size, PAGE_SIZE);
   586			ionic_cq_map(&new->cq, cq_base, cq_base_pa);
   587			ionic_cq_bind(&new->cq, &new->q);
   588		} else {
   589			new->q_size = PAGE_SIZE + (num_descs * desc_size);
   590			new->q_base = dma_alloc_coherent(dev, new->q_size, &new->q_base_pa,
   591							 GFP_KERNEL);
   592			if (!new->q_base) {
   593				netdev_err(lif->netdev, "Cannot allocate queue DMA memory\n");
   594				err = -ENOMEM;
   595				goto err_out_free_cq_info;
   596			}
   597			q_base = PTR_ALIGN(new->q_base, PAGE_SIZE);
   598			q_base_pa = ALIGN(new->q_base_pa, PAGE_SIZE);
   599			ionic_q_map(&new->q, q_base, q_base_pa);
   600	
   601			new->cq_size = PAGE_SIZE + (num_descs * cq_desc_size);
   602			new->cq_base = dma_alloc_coherent(dev, new->cq_size, &new->cq_base_pa,
   603							  GFP_KERNEL);
   604			if (!new->cq_base) {
   605				netdev_err(lif->netdev, "Cannot allocate cq DMA memory\n");
   606				err = -ENOMEM;
   607				goto err_out_free_q;
   608			}
   609			cq_base = PTR_ALIGN(new->cq_base, PAGE_SIZE);
   610			cq_base_pa = ALIGN(new->cq_base_pa, PAGE_SIZE);
   611			ionic_cq_map(&new->cq, cq_base, cq_base_pa);
   612			ionic_cq_bind(&new->cq, &new->q);
   613		}
   614	
   615		if (flags & IONIC_QCQ_F_SG) {
   616			new->sg_size = PAGE_SIZE + (num_descs * sg_desc_size);
   617			new->sg_base = dma_alloc_coherent(dev, new->sg_size, &new->sg_base_pa,
   618							  GFP_KERNEL);
   619			if (!new->sg_base) {
   620				netdev_err(lif->netdev, "Cannot allocate sg DMA memory\n");
   621				err = -ENOMEM;
   622				goto err_out_free_cq;
   623			}
   624			sg_base = PTR_ALIGN(new->sg_base, PAGE_SIZE);
   625			sg_base_pa = ALIGN(new->sg_base_pa, PAGE_SIZE);
   626			ionic_q_sg_map(&new->q, sg_base, sg_base_pa);
   627		}
   628	
   629		INIT_WORK(&new->dim.work, ionic_dim_work);
   630		new->dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
   631	
   632		*qcq = new;
   633	
   634		return 0;
   635	
   636	err_out_free_cq:
   637		dma_free_coherent(dev, new->cq_size, new->cq_base, new->cq_base_pa);
   638	err_out_free_q:
   639		dma_free_coherent(dev, new->q_size, new->q_base, new->q_base_pa);
   640	err_out_free_cq_info:
   641		vfree(new->cq.info);
   642	err_out_free_irq:
   643		if (flags & IONIC_QCQ_F_INTR) {
   644			devm_free_irq(dev, new->intr.vector, &new->napi);
   645			ionic_intr_free(lif->ionic, new->intr.index);
   646		}
   647	err_out_free_q_info:
   648		vfree(new->q.info);
   649	err_out_free_qcq:
   650		devm_kfree(dev, new);
   651	err_out:
   652		dev_err(dev, "qcq alloc of %s%d failed %d\n", name, index, err);
   653		return err;
   654	}
   655	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

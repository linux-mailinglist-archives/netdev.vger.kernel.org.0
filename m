Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A904BD0D9
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 20:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiBTTIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 14:08:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiBTTIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 14:08:11 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B077A40E62
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 11:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645384069; x=1676920069;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=czMxLUH1R2zeItFDk1jZgWeOVjHkLpZwMxy7qzsaKqo=;
  b=h1+bSH1q8e/B9i5PSuKGpLSCdEQPtC928cSv7DCup9BqVkMst8PLh/rw
   BdMPwPBgTkY0F0ii/iv0+fvNMwxIkvA/KPt4tOsXa50f2LBL05yKptRJi
   dPXtNrvYQQq87+tolDm3xgWEpbBEtxKn8SA0DhMvVthHFoxkf5B4k1s1l
   hCtejgNld+9wBP2aUwtii/7PbPhdwidRX92WSqVoV8m3TZjPwMdT67rX6
   rCX9Vo+jtjql/UHG5oU04qt2OV9S152Un3OrYz+qZ9tUXtM+d14Oi6nla
   lmHD3M0+/4u8wNTnlxOsbZPHfQuMEb1NPoJ2Sv4MoMNKzhZaBH/PXBwpc
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="312138265"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="312138265"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 11:07:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="778499530"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 20 Feb 2022 11:07:47 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nLrYh-0000cN-2b; Sun, 20 Feb 2022 19:07:47 +0000
Date:   Mon, 21 Feb 2022 03:07:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Brett Creeley <brett@pensando.io>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next:master 36/73]
 drivers/net/ethernet/pensando/ionic/ionic_lif.c:531:21: warning: assignment
 to 'struct ionic_desc_info *' from 'int' makes pointer from integer without
 a cast
Message-ID: <202202210344.dcgMbwNf-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   adfb62dbda49d66eba6340324547ff89b09a66eb
commit: 116dce0ff047f8e37d99f414c419646c0cc71d0b [36/73] ionic: Use vzalloc for large per-queue related buffers
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20220221/202202210344.dcgMbwNf-lkp@intel.com/config)
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
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=sparc SHELL=/bin/bash drivers/net/ethernet/pensando/ionic/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/pensando/ionic/ionic_lif.c: In function 'ionic_qcq_free':
   drivers/net/ethernet/pensando/ionic/ionic_lif.c:396:17: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
     396 |                 vfree(qcq->cq.info);
         |                 ^~~~~
         |                 kvfree
   drivers/net/ethernet/pensando/ionic/ionic_lif.c: In function 'ionic_qcq_alloc':
   drivers/net/ethernet/pensando/ionic/ionic_lif.c:531:23: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
     531 |         new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
         |                       ^~~~~~~
         |                       kvzalloc
>> drivers/net/ethernet/pensando/ionic/ionic_lif.c:531:21: warning: assignment to 'struct ionic_desc_info *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     531 |         new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
         |                     ^
>> drivers/net/ethernet/pensando/ionic/ionic_lif.c:552:22: warning: assignment to 'struct ionic_cq_info *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     552 |         new->cq.info = vzalloc(num_descs * sizeof(*new->cq.info));
         |                      ^
   cc1: some warnings being treated as errors


vim +531 drivers/net/ethernet/pensando/ionic/ionic_lif.c

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
 > 552		new->cq.info = vzalloc(num_descs * sizeof(*new->cq.info));
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

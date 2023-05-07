Return-Path: <netdev+bounces-731-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BC996F9672
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 03:30:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02A211C21BEC
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 01:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807AE15B3;
	Sun,  7 May 2023 01:30:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF457E
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 01:30:32 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739C659DA;
	Sat,  6 May 2023 18:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683423028; x=1714959028;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MtO0R0FCOQcpoNzvtKmnJchsNJz4oYhO7UXIY2uBX1Q=;
  b=adDadfrhD5ZsBxJxHNLLlQEPx/K9HFjLGGBZ1eTK7xWF6LNYg+U5d5zM
   qgeXmbSv9izzbIhzT7ytLiv40dFXNjD+ACyc1vXNyLXnu3/yO4HJROZ6w
   t/tG+ql0a0J8D/vWK9GaKHbjUJybI7GI49yo6+WpBVQx6z6v9iYa/s8sB
   3zK8TfUQ3PT0OOPiscVPr2+AvdvRuS+Xlk79Wrk0k70+cdTO0u6CxWiYE
   VaAR12668XWVgLfKseLLghMKvT8HzEPkb1cPTYXICzvMbp32nhnJkOIbV
   vMulX8J871Ha0lqChK0lh3koxRGpJHzOe8++cMtOejdlY2z9NF8Bx6/2x
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10702"; a="348259146"
X-IronPort-AV: E=Sophos;i="5.99,256,1677571200"; 
   d="scan'208";a="348259146"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2023 18:30:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10702"; a="728606711"
X-IronPort-AV: E=Sophos;i="5.99,256,1677571200"; 
   d="scan'208";a="728606711"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 06 May 2023 18:30:25 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pvTEH-0000YJ-09;
	Sun, 07 May 2023 01:30:25 +0000
Date: Sun, 7 May 2023 09:29:51 +0800
From: kernel test robot <lkp@intel.com>
To: Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>,
	linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
	netdev@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Chris Leech <cleech@redhat.com>
Subject: Re: [PATCH 06/11] iscsi: set netns for tcp and iser hosts
Message-ID: <202305070938.QRjcW4tq-lkp@intel.com>
References: <20230506232930.195451-7-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230506232930.195451-7-cleech@redhat.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Chris,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next horms-ipvs/master linus/master v6.3 next-20230505]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chris-Leech/iscsi-create-per-net-iscsi-netlink-kernel-sockets/20230507-073308
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230506232930.195451-7-cleech%40redhat.com
patch subject: [PATCH 06/11] iscsi: set netns for tcp and iser hosts
config: powerpc-randconfig-r016-20230507 (https://download.01.org/0day-ci/archive/20230507/202305070938.QRjcW4tq-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project b0fb98227c90adf2536c9ad644a74d5e92961111)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install powerpc cross compiling tool for clang build
        # apt-get install binutils-powerpc-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/a287abe6fb8da0c4af44c1d83fad9ca4fcb7184f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Chris-Leech/iscsi-create-per-net-iscsi-netlink-kernel-sockets/20230507-073308
        git checkout a287abe6fb8da0c4af44c1d83fad9ca4fcb7184f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=powerpc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash drivers/scsi/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305070938.QRjcW4tq-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/scsi_transport_iscsi.c:234:1: warning: no previous prototype for function '__iscsi_create_endpoint' [-Wmissing-prototypes]
   __iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size, struct net *net)
   ^
   drivers/scsi/scsi_transport_iscsi.c:233:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   struct iscsi_endpoint *
   ^
   static 
   1 warning generated.


vim +/__iscsi_create_endpoint +234 drivers/scsi/scsi_transport_iscsi.c

   232	
   233	struct iscsi_endpoint *
 > 234	__iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size, struct net *net)
   235	{
   236		struct iscsi_endpoint *ep;
   237		int err, id;
   238	
   239		ep = kzalloc(sizeof(*ep) + dd_size, GFP_KERNEL);
   240		if (!ep)
   241			return NULL;
   242	
   243		mutex_lock(&iscsi_ep_idr_mutex);
   244	
   245		/*
   246		 * First endpoint id should be 1 to comply with user space
   247		 * applications (iscsid).
   248		 */
   249		id = idr_alloc(&iscsi_ep_idr, ep, 1, -1, GFP_NOIO);
   250		if (id < 0) {
   251			mutex_unlock(&iscsi_ep_idr_mutex);
   252			printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",
   253			       id);
   254			goto free_ep;
   255		}
   256		mutex_unlock(&iscsi_ep_idr_mutex);
   257	
   258		ep->id = id;
   259		ep->dev.class = &iscsi_endpoint_class;
   260		if (shost)
   261			ep->dev.parent = &shost->shost_gendev;
   262		if (net)
   263			ep->netns = net;
   264		dev_set_name(&ep->dev, "ep-%d", id);
   265		err = device_register(&ep->dev);
   266	        if (err)
   267			goto put_dev;
   268	
   269		err = sysfs_create_group(&ep->dev.kobj, &iscsi_endpoint_group);
   270		if (err)
   271			goto unregister_dev;
   272	
   273		if (dd_size)
   274			ep->dd_data = &ep[1];
   275		return ep;
   276	
   277	unregister_dev:
   278		device_unregister(&ep->dev);
   279		return NULL;
   280	
   281	put_dev:
   282		mutex_lock(&iscsi_ep_idr_mutex);
   283		idr_remove(&iscsi_ep_idr, id);
   284		mutex_unlock(&iscsi_ep_idr_mutex);
   285		put_device(&ep->dev);
   286		return NULL;
   287	free_ep:
   288		kfree(ep);
   289		return NULL;
   290	}
   291	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests


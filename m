Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550254B2C45
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352368AbiBKR7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 12:59:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352363AbiBKR7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 12:59:05 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A03CF5;
        Fri, 11 Feb 2022 09:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644602344; x=1676138344;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bG4a0yBTknOUZ8B/vq+2i1CBVRfTMlrNrguDbShw9Fw=;
  b=h22OHUOWzSWW4JVDqGXSHWveIUmj23aMDQUo9WqoFHww1szJFpHpCNJp
   vzNiOfKcNIcbCdb186Zu0FepTH+yHR7trqgvFe56JEQBassdjaKXeChjW
   yIvYkD6c8O6FOQFUGRoTyfeWtMWHU46tAl7T2+cPsg+Ihr6D6evbKHsr9
   mNaKC4qvYyrRivT3XXyg/8wApRpjuy+iBp/k3HdJgj/AwlB7PHjkseJkK
   qTzTYXshFT+K82K9uCW4sNGm333KumvvRE3QA+IhU0Ry+2e0ZEyUurpmx
   +wWAm1aUNOLpjuQ0jSdtqlo8EI8C2jzyaA9+RUvM/mZ8k5C2UiMk9h7j9
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10255"; a="230419969"
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="230419969"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 09:59:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="586424420"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 11 Feb 2022 09:59:01 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nIaCC-0004uC-Vy; Fri, 11 Feb 2022 17:59:00 +0000
Date:   Sat, 12 Feb 2022 01:58:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH 1/4] bpf: Add pin_name into struct bpf_prog_aux
Message-ID: <202202112213.WGiJCCYD-lkp@intel.com>
References: <20220211121145.35237-2-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211121145.35237-2-laoar.shao@gmail.com>
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

Hi Yafang,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf/master]
[also build test WARNING on net/master horms-ipvs/master net-next/master v5.17-rc3 next-20220211]
[cannot apply to bpf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Yafang-Shao/bpf-Add-more-information-into-bpffs/20220211-201319
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220211/202202112213.WGiJCCYD-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/6cd35bc70f99caee380d84f5ba9256ac5fe03860
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Yafang-Shao/bpf-Add-more-information-into-bpffs/20220211-201319
        git checkout 6cd35bc70f99caee380d84f5ba9256ac5fe03860
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   kernel/bpf/inode.c: In function 'bpf_obj_do_pin':
>> kernel/bpf/inode.c:469:24: warning: ignoring return value of 'strncpy_from_user' declared with attribute 'warn_unused_result' [-Wunused-result]
     469 |                 (void) strncpy_from_user(aux->pin_name, pathname, BPF_PIN_NAME_LEN);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +469 kernel/bpf/inode.c

   437	
   438	static int bpf_obj_do_pin(const char __user *pathname, void *raw,
   439				  enum bpf_type type)
   440	{
   441		struct bpf_prog_aux *aux;
   442		struct bpf_prog *prog;
   443		struct dentry *dentry;
   444		struct inode *dir;
   445		struct path path;
   446		umode_t mode;
   447		int ret;
   448	
   449		dentry = user_path_create(AT_FDCWD, pathname, &path, 0);
   450		if (IS_ERR(dentry))
   451			return PTR_ERR(dentry);
   452	
   453		mode = S_IFREG | ((S_IRUSR | S_IWUSR) & ~current_umask());
   454	
   455		ret = security_path_mknod(&path, dentry, mode, 0);
   456		if (ret)
   457			goto out;
   458	
   459		dir = d_inode(path.dentry);
   460		if (dir->i_op != &bpf_dir_iops) {
   461			ret = -EPERM;
   462			goto out;
   463		}
   464	
   465		switch (type) {
   466		case BPF_TYPE_PROG:
   467			prog = raw;
   468			aux = prog->aux;
 > 469			(void) strncpy_from_user(aux->pin_name, pathname, BPF_PIN_NAME_LEN);
   470			aux->pin_name[BPF_PIN_NAME_LEN - 1] = '\0';
   471			ret = vfs_mkobj(dentry, mode, bpf_mkprog, raw);
   472			break;
   473		case BPF_TYPE_MAP:
   474			ret = vfs_mkobj(dentry, mode, bpf_mkmap, raw);
   475			break;
   476		case BPF_TYPE_LINK:
   477			ret = vfs_mkobj(dentry, mode, bpf_mklink, raw);
   478			break;
   479		default:
   480			ret = -EPERM;
   481		}
   482	out:
   483		done_path_create(&path, dentry);
   484		return ret;
   485	}
   486	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

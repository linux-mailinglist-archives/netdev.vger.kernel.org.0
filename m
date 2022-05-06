Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC4A51E04E
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 22:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443719AbiEFUxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 16:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443630AbiEFUxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 16:53:22 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0AD6A000
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 13:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651870177; x=1683406177;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=4pduuR1ZTT1/x3i3zqOnHd9u7V1NBgZUOiuBHA78NYA=;
  b=B2sCDPIRqntVo8F95u3pT2EpUBTVKFwxuVvzLNXQnWrej0JIL42ByKCV
   Go25SmiRNgOSt8FMt5cOUqbM8WEyTMlTsccvKRfvqCgaFS6xUbzgMSgY+
   tLImMs6FtKhz+VGZHEgmeTKjoEoCjSfPGaV3TY83VDNYHR8gdS+1v0+20
   QoFcpjNd3TRbMnfu1STpm7kpY0VE1K01mNqY2msa5ETMZYSBsTT7lJLS6
   7W8AnzAMzx+9/1BYxj6Kd8/Ug2rabicaMf5IbCO9Y3/5ay7k0zc4gZ/BC
   MqFvXwDXTphdbp/01vKp/wtdqHuEzkz5ehr/eilH+fqrI/VKPschahGLw
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="266162137"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="266162137"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 13:49:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="518225119"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 06 May 2022 13:49:35 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nn4tK-000DtF-LJ;
        Fri, 06 May 2022 20:49:34 +0000
Date:   Sat, 7 May 2022 04:48:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [net-next:master 9/16]
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c:567:23: warning:
 variable 'flow6' set but not used
Message-ID: <202205070459.Ht5py3HQ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   95730d65708397828f75ca7dbca838edf6727bfd
commit: c83a0fbe9766b3ae970b96435b7c9786299a9b12 [9/16] nfp: flower: remove unused neighbour cache
config: riscv-randconfig-c024-20220506 (https://download.01.org/0day-ci/archive/20220507/202205070459.Ht5py3HQ-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=c83a0fbe9766b3ae970b96435b7c9786299a9b12
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout c83a0fbe9766b3ae970b96435b7c9786299a9b12
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/ethernet/netronome/nfp/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c: In function 'nfp_tun_neigh_event_handler':
>> drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c:567:23: warning: variable 'flow6' set but not used [-Wunused-but-set-variable]
     567 |         struct flowi6 flow6 = {};
         |                       ^~~~~


vim +/flow6 +567 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c

50b1c86ab0a075 John Hurley 2019-12-17  559  
8e6a9046b66a7d John Hurley 2017-09-25  560  static int
8e6a9046b66a7d John Hurley 2017-09-25  561  nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
8e6a9046b66a7d John Hurley 2017-09-25  562  			    void *ptr)
8e6a9046b66a7d John Hurley 2017-09-25  563  {
8e6a9046b66a7d John Hurley 2017-09-25  564  	struct nfp_flower_priv *app_priv;
8e6a9046b66a7d John Hurley 2017-09-25  565  	struct netevent_redirect *redir;
6c463a059f626b John Hurley 2019-12-17  566  	struct flowi4 flow4 = {};
6c463a059f626b John Hurley 2019-12-17 @567  	struct flowi6 flow6 = {};
8e6a9046b66a7d John Hurley 2017-09-25  568  	struct neighbour *n;
8e6a9046b66a7d John Hurley 2017-09-25  569  	struct nfp_app *app;
9d5447ed44b5dd Louis Peens 2022-05-05  570  	bool neigh_invalid;
6c463a059f626b John Hurley 2019-12-17  571  	bool ipv6 = false;
8e6a9046b66a7d John Hurley 2017-09-25  572  	int err;
8e6a9046b66a7d John Hurley 2017-09-25  573  
8e6a9046b66a7d John Hurley 2017-09-25  574  	switch (event) {
8e6a9046b66a7d John Hurley 2017-09-25  575  	case NETEVENT_REDIRECT:
8e6a9046b66a7d John Hurley 2017-09-25  576  		redir = (struct netevent_redirect *)ptr;
8e6a9046b66a7d John Hurley 2017-09-25  577  		n = redir->neigh;
8e6a9046b66a7d John Hurley 2017-09-25  578  		break;
8e6a9046b66a7d John Hurley 2017-09-25  579  	case NETEVENT_NEIGH_UPDATE:
8e6a9046b66a7d John Hurley 2017-09-25  580  		n = (struct neighbour *)ptr;
8e6a9046b66a7d John Hurley 2017-09-25  581  		break;
8e6a9046b66a7d John Hurley 2017-09-25  582  	default:
8e6a9046b66a7d John Hurley 2017-09-25  583  		return NOTIFY_DONE;
8e6a9046b66a7d John Hurley 2017-09-25  584  	}
8e6a9046b66a7d John Hurley 2017-09-25  585  
6c463a059f626b John Hurley 2019-12-17  586  	if (n->tbl->family == AF_INET6)
6c463a059f626b John Hurley 2019-12-17  587  		ipv6 = true;
6c463a059f626b John Hurley 2019-12-17  588  
9d5447ed44b5dd Louis Peens 2022-05-05  589  	neigh_invalid = !(n->nud_state & NUD_VALID) || n->dead;
9d5447ed44b5dd Louis Peens 2022-05-05  590  
6c463a059f626b John Hurley 2019-12-17  591  	if (ipv6)
6c463a059f626b John Hurley 2019-12-17  592  		flow6.daddr = *(struct in6_addr *)n->primary_key;
6c463a059f626b John Hurley 2019-12-17  593  	else
6c463a059f626b John Hurley 2019-12-17  594  		flow4.daddr = *(__be32 *)n->primary_key;
8e6a9046b66a7d John Hurley 2017-09-25  595  
f3b975778c176b John Hurley 2019-01-15  596  	app_priv = container_of(nb, struct nfp_flower_priv, tun.neigh_nb);
8e6a9046b66a7d John Hurley 2017-09-25  597  	app = app_priv->app;
8e6a9046b66a7d John Hurley 2017-09-25  598  
e8024cb483abb2 John Hurley 2019-08-27  599  	if (!nfp_netdev_is_nfp_repr(n->dev) &&
e8024cb483abb2 John Hurley 2019-08-27  600  	    !nfp_flower_internal_port_can_offload(app, n->dev))
e8024cb483abb2 John Hurley 2019-08-27  601  		return NOTIFY_DONE;
e8024cb483abb2 John Hurley 2019-08-27  602  

:::::: The code at line 567 was first introduced by commit
:::::: 6c463a059f626bc2115b17bee97f014f59dd844a nfp: flower: handle notifiers for ipv6 route changes

:::::: TO: John Hurley <john.hurley@netronome.com>
:::::: CC: David S. Miller <davem@davemloft.net>

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

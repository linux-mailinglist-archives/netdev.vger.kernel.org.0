Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67835953AB
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiHPHYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiHPHY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:24:28 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFA27C331;
        Mon, 15 Aug 2022 20:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660620526; x=1692156526;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=G9FMxJUX6IlQCpmWkMAAX8sP79y8pf8oC3P46/tdATk=;
  b=ZKe3+olznIMrmFRuJ3c2L+k0G+uFrhhxOWbxMH4dWufXUoucAx3Af0YB
   0ifkH9QvbNWMhHX2LhSIB4pZfi+Tx94gXG+fxF52Wji8erzexRRjMu7oq
   dZkl+DWCrdz4mNdFOOEZCOZcG1uBFL52Sim2KOdkrtUTRppTSzlPyKSNr
   1M9YRT8tsIdqDiLeVoUZRIq/okzJ/CGon++tIBEbqXuu4dvk9juZZhBNu
   TO9dkLYMHNIZKMIOerqWn10u4ZVbwWPYWuieeusxyqDtSPD0aic+Z3JGP
   I11tDpSrlPwqKucMDHKPxMWXw0aecVDsyERbPPxEKSI8NkENd7+2gpqVw
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="279076041"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="279076041"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 20:28:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="583132287"
Received: from lkp-server02.sh.intel.com (HELO 3d2a4d02a2a9) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 15 Aug 2022 20:28:44 -0700
Received: from kbuild by 3d2a4d02a2a9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oNnFz-0001P2-1L;
        Tue, 16 Aug 2022 03:28:43 +0000
Date:   Tue, 16 Aug 2022 11:28:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [mst-vhost:vhost 5/8] drivers/virtio/virtio_vdpa.c:291:61: error:
 'sizes' undeclared
Message-ID: <202208161151.sMYdFPvS-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   43ab8a34f3f0c7301813343b9fed2da33c37754a
commit: 71545b3c933acbf165e6596d5cfa4fd15e1ef543 [5/8] virtio: Revert "virtio: find_vqs() add arg sizes"
config: i386-buildonly-randconfig-r004-20220815 (https://download.01.org/0day-ci/archive/20220816/202208161151.sMYdFPvS-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?id=71545b3c933acbf165e6596d5cfa4fd15e1ef543
        git remote add mst-vhost https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
        git fetch --no-tags mst-vhost vhost
        git checkout 71545b3c933acbf165e6596d5cfa4fd15e1ef543
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/virtio/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/virtio/virtio_vdpa.c: In function 'virtio_vdpa_find_vqs':
>> drivers/virtio/virtio_vdpa.c:291:61: error: 'sizes' undeclared (first use in this function)
     291 |                                                   names[i], sizes ? sizes[i] : 0,
         |                                                             ^~~~~
   drivers/virtio/virtio_vdpa.c:291:61: note: each undeclared identifier is reported only once for each function it appears in


vim +/sizes +291 drivers/virtio/virtio_vdpa.c

c043b4a8cf3b16 Jason Wang  2020-03-26  270  
3153234097f6a0 Solomon Tan 2022-04-18  271  static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
c043b4a8cf3b16 Jason Wang  2020-03-26  272  				struct virtqueue *vqs[],
c043b4a8cf3b16 Jason Wang  2020-03-26  273  				vq_callback_t *callbacks[],
c043b4a8cf3b16 Jason Wang  2020-03-26  274  				const char * const names[],
c043b4a8cf3b16 Jason Wang  2020-03-26  275  				const bool *ctx,
c043b4a8cf3b16 Jason Wang  2020-03-26  276  				struct irq_affinity *desc)
c043b4a8cf3b16 Jason Wang  2020-03-26  277  {
c043b4a8cf3b16 Jason Wang  2020-03-26  278  	struct virtio_vdpa_device *vd_dev = to_virtio_vdpa_device(vdev);
c043b4a8cf3b16 Jason Wang  2020-03-26  279  	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
c043b4a8cf3b16 Jason Wang  2020-03-26  280  	const struct vdpa_config_ops *ops = vdpa->config;
c043b4a8cf3b16 Jason Wang  2020-03-26  281  	struct vdpa_callback cb;
c043b4a8cf3b16 Jason Wang  2020-03-26  282  	int i, err, queue_idx = 0;
c043b4a8cf3b16 Jason Wang  2020-03-26  283  
c043b4a8cf3b16 Jason Wang  2020-03-26  284  	for (i = 0; i < nvqs; ++i) {
c043b4a8cf3b16 Jason Wang  2020-03-26  285  		if (!names[i]) {
c043b4a8cf3b16 Jason Wang  2020-03-26  286  			vqs[i] = NULL;
c043b4a8cf3b16 Jason Wang  2020-03-26  287  			continue;
c043b4a8cf3b16 Jason Wang  2020-03-26  288  		}
c043b4a8cf3b16 Jason Wang  2020-03-26  289  
99e8927d8a4da8 Bo Liu      2022-08-10  290  		vqs[i] = virtio_vdpa_setup_vq(vdev, queue_idx++, callbacks[i],
99e8927d8a4da8 Bo Liu      2022-08-10 @291  						  names[i], sizes ? sizes[i] : 0,
99e8927d8a4da8 Bo Liu      2022-08-10  292  						  ctx ? ctx[i] : false);
c043b4a8cf3b16 Jason Wang  2020-03-26  293  		if (IS_ERR(vqs[i])) {
c043b4a8cf3b16 Jason Wang  2020-03-26  294  			err = PTR_ERR(vqs[i]);
c043b4a8cf3b16 Jason Wang  2020-03-26  295  			goto err_setup_vq;
c043b4a8cf3b16 Jason Wang  2020-03-26  296  		}
c043b4a8cf3b16 Jason Wang  2020-03-26  297  	}
c043b4a8cf3b16 Jason Wang  2020-03-26  298  
c043b4a8cf3b16 Jason Wang  2020-03-26  299  	cb.callback = virtio_vdpa_config_cb;
c043b4a8cf3b16 Jason Wang  2020-03-26  300  	cb.private = vd_dev;
c043b4a8cf3b16 Jason Wang  2020-03-26  301  	ops->set_config_cb(vdpa, &cb);
c043b4a8cf3b16 Jason Wang  2020-03-26  302  
c043b4a8cf3b16 Jason Wang  2020-03-26  303  	return 0;
c043b4a8cf3b16 Jason Wang  2020-03-26  304  
c043b4a8cf3b16 Jason Wang  2020-03-26  305  err_setup_vq:
c043b4a8cf3b16 Jason Wang  2020-03-26  306  	virtio_vdpa_del_vqs(vdev);
c043b4a8cf3b16 Jason Wang  2020-03-26  307  	return err;
c043b4a8cf3b16 Jason Wang  2020-03-26  308  }
c043b4a8cf3b16 Jason Wang  2020-03-26  309  

:::::: The code at line 291 was first introduced by commit
:::::: 99e8927d8a4da8eb8a8a5904dc13a3156be8e7c0 virtio_vdpa: support the arg sizes of find_vqs()

:::::: TO: Bo Liu <liubo03@inspur.com>
:::::: CC: Michael S. Tsirkin <mst@redhat.com>

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

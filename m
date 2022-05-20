Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F3852F0CF
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351430AbiETQhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235754AbiETQhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:37:06 -0400
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0A8387B3;
        Fri, 20 May 2022 09:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=JY4A6xv4nS9LZ51NJpN/owFDD24ycphxEf09kh6TztY=;
  b=gSEReqYDO1m/zB9EejV8qw6w5Rr8rJtxx2vBISyzNJIdeEp3WiiAlpzi
   IjleG3XXlW8sfVMlRJortc2Nj2dOt58jjmT39c6/n1ZqI7pEL8L7hSv5L
   BAf26dVn9FlozDXMHuz0CnrJTEV6RwhkOqKHXoYbt7sgANxzLIPIfv1eJ
   U=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,239,1647298800"; 
   d="scan'208";a="37390969"
Received: from 245.122.68.85.rev.sfr.net (HELO hadrien) ([85.68.122.245])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 18:37:01 +0200
Date:   Fri, 20 May 2022 18:37:01 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Gautam Dawar <gautam.dawar@xilinx.com>
cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        kbuild-all@lists.01.org
Subject: [mst-vhost:vhost 26/43] drivers/vhost/vdpa.c:1003:3-9: preceding
 lock on line 991 (fwd)
Message-ID: <alpine.DEB.2.22.394.2205201835450.2929@hadrien>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please check whether an unlock is needed before line 1003.

julia

---------- Forwarded message ----------
Date: Fri, 20 May 2022 17:35:29 +0800
From: kernel test robot <lkp@intel.com>
To: kbuild@lists.01.org
Cc: lkp@intel.com, Julia Lawall <julia.lawall@lip6.fr>
Subject: [mst-vhost:vhost 26/43] drivers/vhost/vdpa.c:1003:3-9: preceding lock
    on line 991

CC: kbuild-all@lists.01.org
BCC: lkp@intel.com
CC: kvm@vger.kernel.org
CC: virtualization@lists.linux-foundation.org
CC: netdev@vger.kernel.org
TO: Gautam Dawar <gautam.dawar@xilinx.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   73211bf1bc3ac0a3c544225e270401c1fe5d395d
commit: a1468175bb17ca5e477147de5d886e7a22d93527 [26/43] vhost-vdpa: support ASID based IOTLB API
:::::: branch date: 10 hours ago
:::::: commit date: 10 hours ago
config: arc-allmodconfig (https://download.01.org/0day-ci/archive/20220520/202205201721.rGqusahl-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>


cocci warnings: (new ones prefixed by >>)
>> drivers/vhost/vdpa.c:1003:3-9: preceding lock on line 991
   drivers/vhost/vdpa.c:1016:2-8: preceding lock on line 991

vim +1003 drivers/vhost/vdpa.c

4c8cf31885f69e Tiwei Bie    2020-03-26   980
0f05062453fb51 Gautam Dawar 2022-03-30   981  static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
4c8cf31885f69e Tiwei Bie    2020-03-26   982  					struct vhost_iotlb_msg *msg)
4c8cf31885f69e Tiwei Bie    2020-03-26   983  {
4c8cf31885f69e Tiwei Bie    2020-03-26   984  	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
25abc060d28213 Jason Wang   2020-08-04   985  	struct vdpa_device *vdpa = v->vdpa;
25abc060d28213 Jason Wang   2020-08-04   986  	const struct vdpa_config_ops *ops = vdpa->config;
a1468175bb17ca Gautam Dawar 2022-03-30   987  	struct vhost_iotlb *iotlb = NULL;
a1468175bb17ca Gautam Dawar 2022-03-30   988  	struct vhost_vdpa_as *as = NULL;
4c8cf31885f69e Tiwei Bie    2020-03-26   989  	int r = 0;
4c8cf31885f69e Tiwei Bie    2020-03-26   990
a9d064524fc3cf Xie Yongji   2021-04-12  @991  	mutex_lock(&dev->mutex);
a9d064524fc3cf Xie Yongji   2021-04-12   992
4c8cf31885f69e Tiwei Bie    2020-03-26   993  	r = vhost_dev_check_owner(dev);
4c8cf31885f69e Tiwei Bie    2020-03-26   994  	if (r)
a9d064524fc3cf Xie Yongji   2021-04-12   995  		goto unlock;
4c8cf31885f69e Tiwei Bie    2020-03-26   996
a1468175bb17ca Gautam Dawar 2022-03-30   997  	if (msg->type == VHOST_IOTLB_UPDATE ||
a1468175bb17ca Gautam Dawar 2022-03-30   998  	    msg->type == VHOST_IOTLB_BATCH_BEGIN) {
a1468175bb17ca Gautam Dawar 2022-03-30   999  		as = vhost_vdpa_find_alloc_as(v, asid);
a1468175bb17ca Gautam Dawar 2022-03-30  1000  		if (!as) {
a1468175bb17ca Gautam Dawar 2022-03-30  1001  			dev_err(&v->dev, "can't find and alloc asid %d\n",
a1468175bb17ca Gautam Dawar 2022-03-30  1002  				asid);
a1468175bb17ca Gautam Dawar 2022-03-30 @1003  			return -EINVAL;
a1468175bb17ca Gautam Dawar 2022-03-30  1004  		}
a1468175bb17ca Gautam Dawar 2022-03-30  1005  		iotlb = &as->iotlb;
a1468175bb17ca Gautam Dawar 2022-03-30  1006  	} else
a1468175bb17ca Gautam Dawar 2022-03-30  1007  		iotlb = asid_to_iotlb(v, asid);
a1468175bb17ca Gautam Dawar 2022-03-30  1008
a1468175bb17ca Gautam Dawar 2022-03-30  1009  	if ((v->in_batch && v->batch_asid != asid) || !iotlb) {
a1468175bb17ca Gautam Dawar 2022-03-30  1010  		if (v->in_batch && v->batch_asid != asid) {
a1468175bb17ca Gautam Dawar 2022-03-30  1011  			dev_info(&v->dev, "batch id %d asid %d\n",
a1468175bb17ca Gautam Dawar 2022-03-30  1012  				 v->batch_asid, asid);
a1468175bb17ca Gautam Dawar 2022-03-30  1013  		}
a1468175bb17ca Gautam Dawar 2022-03-30  1014  		if (!iotlb)
a1468175bb17ca Gautam Dawar 2022-03-30  1015  			dev_err(&v->dev, "no iotlb for asid %d\n", asid);
a1468175bb17ca Gautam Dawar 2022-03-30  1016  		return -EINVAL;
a1468175bb17ca Gautam Dawar 2022-03-30  1017  	}
a1468175bb17ca Gautam Dawar 2022-03-30  1018
4c8cf31885f69e Tiwei Bie    2020-03-26  1019  	switch (msg->type) {
4c8cf31885f69e Tiwei Bie    2020-03-26  1020  	case VHOST_IOTLB_UPDATE:
3111cb7283065a Gautam Dawar 2022-03-30  1021  		r = vhost_vdpa_process_iotlb_update(v, iotlb, msg);
4c8cf31885f69e Tiwei Bie    2020-03-26  1022  		break;
4c8cf31885f69e Tiwei Bie    2020-03-26  1023  	case VHOST_IOTLB_INVALIDATE:
3111cb7283065a Gautam Dawar 2022-03-30  1024  		vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
4c8cf31885f69e Tiwei Bie    2020-03-26  1025  		break;
25abc060d28213 Jason Wang   2020-08-04  1026  	case VHOST_IOTLB_BATCH_BEGIN:
a1468175bb17ca Gautam Dawar 2022-03-30  1027  		v->batch_asid = asid;
25abc060d28213 Jason Wang   2020-08-04  1028  		v->in_batch = true;
25abc060d28213 Jason Wang   2020-08-04  1029  		break;
25abc060d28213 Jason Wang   2020-08-04  1030  	case VHOST_IOTLB_BATCH_END:
25abc060d28213 Jason Wang   2020-08-04  1031  		if (v->in_batch && ops->set_map)
a1468175bb17ca Gautam Dawar 2022-03-30  1032  			ops->set_map(vdpa, asid, iotlb);
25abc060d28213 Jason Wang   2020-08-04  1033  		v->in_batch = false;
a1468175bb17ca Gautam Dawar 2022-03-30  1034  		if (!iotlb->nmaps)
a1468175bb17ca Gautam Dawar 2022-03-30  1035  			vhost_vdpa_remove_as(v, asid);
25abc060d28213 Jason Wang   2020-08-04  1036  		break;
4c8cf31885f69e Tiwei Bie    2020-03-26  1037  	default:
4c8cf31885f69e Tiwei Bie    2020-03-26  1038  		r = -EINVAL;
4c8cf31885f69e Tiwei Bie    2020-03-26  1039  		break;
4c8cf31885f69e Tiwei Bie    2020-03-26  1040  	}
a9d064524fc3cf Xie Yongji   2021-04-12  1041  unlock:
a9d064524fc3cf Xie Yongji   2021-04-12  1042  	mutex_unlock(&dev->mutex);
4c8cf31885f69e Tiwei Bie    2020-03-26  1043
4c8cf31885f69e Tiwei Bie    2020-03-26  1044  	return r;
4c8cf31885f69e Tiwei Bie    2020-03-26  1045  }
4c8cf31885f69e Tiwei Bie    2020-03-26  1046

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

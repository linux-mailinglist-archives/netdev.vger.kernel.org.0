Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABA1591FB8
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 14:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiHNMTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 08:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiHNMTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 08:19:02 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BA61B7A4;
        Sun, 14 Aug 2022 05:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660479541; x=1692015541;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kxVx2KOwxI7ag9xP9ukIW9wSDqF7JOUR+pXT8aaobjM=;
  b=aVDRAMc9p1fLkAglTy9Nf8VXvcZ/CTFYRnKe2rhy0Pnivni9Lf7pfzHt
   O509Qzg9nvv/T/yv98J0OD4+pOsm5fp6gZ3bRDODoNnwIaEXDa4ElVrpD
   /HjBbZ7GfXIWeEK+WxUs8Lnsf6xho+HF231k847kUILQzi34m3Uvq6lgP
   fCdIXIrb75ZWLTjFRD72UbNjelCw8vBJ2XN6Qo7oNQBQNSz3gThyT0/Ws
   nhSS7Tf1vrcSVtRyddi/ihqHpSwcpeggnQPG7Ark3TX+nxGlVcnLyo2vQ
   h5fLHr42vhgP93UhdMbeUy1cFhLpgkJAYruXvYvK2vgxPf+VaA6JPNU7t
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="290574123"
X-IronPort-AV: E=Sophos;i="5.93,236,1654585200"; 
   d="scan'208";a="290574123"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2022 05:19:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,236,1654585200"; 
   d="scan'208";a="639367703"
Received: from lkp-server02.sh.intel.com (HELO 3d2a4d02a2a9) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 14 Aug 2022 05:18:57 -0700
Received: from kbuild by 3d2a4d02a2a9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oNCa0-00004Z-1c;
        Sun, 14 Aug 2022 12:18:56 +0000
Date:   Sun, 14 Aug 2022 20:18:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Zijun Hu <quic_zijuhu@quicinc.com>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        luiz.von.dentz@intel.com
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5] Bluetooth: hci_sync: Remove redundant func definition
Message-ID: <202208142029.Y9YOiT4V-lkp@intel.com>
References: <1658488552-24691-1-git-send-email-quic_zijuhu@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1658488552-24691-1-git-send-email-quic_zijuhu@quicinc.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zijun,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bluetooth/master]
[also build test WARNING on net-next/master net/master linus/master v5.19]
[cannot apply to bluetooth-next/master next-20220812]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Zijun-Hu/Bluetooth-hci_sync-Remove-redundant-func-definition/20220722-191804
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git master
config: x86_64-randconfig-a013 (https://download.01.org/0day-ci/archive/20220814/202208142029.Y9YOiT4V-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/01ff3d2230c220a1387940ed594eccda09dc51fb
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Zijun-Hu/Bluetooth-hci_sync-Remove-redundant-func-definition/20220722-191804
        git checkout 01ff3d2230c220a1387940ed594eccda09dc51fb
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/bluetooth/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/bluetooth/hci_sync.c:2398:6: warning: no previous prototype for 'disconnected_accept_list_entries' [-Wmissing-prototypes]
    2398 | bool disconnected_accept_list_entries(struct hci_dev *hdev)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/disconnected_accept_list_entries +2398 net/bluetooth/hci_sync.c

  2397	
> 2398	bool disconnected_accept_list_entries(struct hci_dev *hdev)
  2399	{
  2400		struct bdaddr_list *b;
  2401	
  2402		list_for_each_entry(b, &hdev->accept_list, list) {
  2403			struct hci_conn *conn;
  2404	
  2405			conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &b->bdaddr);
  2406			if (!conn)
  2407				return true;
  2408	
  2409			if (conn->state != BT_CONNECTED && conn->state != BT_CONFIG)
  2410				return true;
  2411		}
  2412	
  2413		return false;
  2414	}
  2415	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

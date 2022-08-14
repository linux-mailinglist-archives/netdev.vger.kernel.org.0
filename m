Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF371591FB5
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 14:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiHNMTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 08:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiHNMTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 08:19:01 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94111B7A0;
        Sun, 14 Aug 2022 05:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660479540; x=1692015540;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=albSF85CxBJ7JCLgitr0rpDwaThRbxFTzo5X/4+HqRo=;
  b=OiBDpPQu2DOp4H9ujAP06thKjEoTvliwvoSIVkRlJumIqsSAm5N4WwXt
   preWg3t8cMiAGSmItp8Lq4q1dInKKU0+3ZUSR2CLSI2zGMr2wBaGGtQCR
   zhy4snNNgINx4OiKLDRER+QzR4WIAVknuumK0BerFO5xZ7G0F/SJ5d75i
   6UZv9sd7wQdriq/NlDBocOpcFLs2b9Z40kGRiJVX71orsamDSTdVFne1B
   3ER+e2aWWpvAabXs+JTzrI6M4UMURe35QjI9w1Dc5rN2tWjyu5uOAm4vz
   J5eh5/mZIkv0Wd7so4AdXog2x+++2lEMIrQ6D5hvxE5xzNh38hu5vt3JC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="289390263"
X-IronPort-AV: E=Sophos;i="5.93,236,1654585200"; 
   d="scan'208";a="289390263"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2022 05:19:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,236,1654585200"; 
   d="scan'208";a="748649874"
Received: from lkp-server02.sh.intel.com (HELO 3d2a4d02a2a9) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 14 Aug 2022 05:18:57 -0700
Received: from kbuild by 3d2a4d02a2a9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oNCa0-00004b-1g;
        Sun, 14 Aug 2022 12:18:56 +0000
Date:   Sun, 14 Aug 2022 20:18:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Zijun Hu <quic_zijuhu@quicinc.com>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        luiz.von.dentz@intel.com
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5] Bluetooth: hci_sync: Remove redundant func definition
Message-ID: <202208142033.Kav1wBRp-lkp@intel.com>
References: <1658488552-24691-1-git-send-email-quic_zijuhu@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1658488552-24691-1-git-send-email-quic_zijuhu@quicinc.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
config: arm-defconfig (https://download.01.org/0day-ci/archive/20220814/202208142033.Kav1wBRp-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/01ff3d2230c220a1387940ed594eccda09dc51fb
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Zijun-Hu/Bluetooth-hci_sync-Remove-redundant-func-definition/20220722-191804
        git checkout 01ff3d2230c220a1387940ed594eccda09dc51fb
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash net/bluetooth/

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

Return-Path: <netdev+bounces-11711-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C5D734065
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 12:59:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEC4228162E
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 10:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4F379E3;
	Sat, 17 Jun 2023 10:59:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6357491
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 10:59:33 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ED61BD;
	Sat, 17 Jun 2023 03:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686999572; x=1718535572;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=vQxA8vkjHecmo3ite9rgz7G1flxBXK8uNjneOM1CpXE=;
  b=Z89b5rSpC5mr9Kt/6gL5H7vRdFGf651UWM642tL4adQCxkaRuLq+kICN
   D2Bs8GElUIOfv9j4674ttHdv99AnjxJDh2lv55NMBFJKJ0Ghbo/5Q+2Vo
   YjwGcToIUPLU2OWuRIz4+YlZH8SEoQB1VSikHNEf9KezWgdzJy6uDVK8j
   u1aVcVqHezkjy7i3jcQfpMEaltWI7FkXEOVwAmiXsk78stxZREwTTntRR
   ueAi1XSJSr688gDoBIE9T5BLFvdg2Frc3hU5Dxuf1xowytKV/RgUL6FCr
   4II6/ApBvF4OOIolibRZjpkBT1Z+ggkbYpnuZKwckRmPfh4/MTjloGpQ4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="388248447"
X-IronPort-AV: E=Sophos;i="6.00,250,1681196400"; 
   d="scan'208";a="388248447"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2023 03:59:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="1043377579"
X-IronPort-AV: E=Sophos;i="6.00,250,1681196400"; 
   d="scan'208";a="1043377579"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 17 Jun 2023 03:59:30 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qATeT-0002gg-2w;
	Sat, 17 Jun 2023 10:59:29 +0000
Date: Sat, 17 Jun 2023 18:58:36 +0800
From: kernel test robot <lkp@intel.com>
To: David Arinzon <darinzon@amazon.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Arthur Kiyanovski <akiyano@amazon.com>,
	Shay Agroskin <shayagr@amazon.com>, linux-doc@vger.kernel.org
Subject: [net-next:main 3/11] htmldocs:
 Documentation/networking/device_drivers/ethernet/amazon/ena.rst:209:
 WARNING: Explicit markup ends without a blank line; unexpected unindent.
Message-ID: <202306171804.U7E92zoE-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git main
head:   f60ce8a48b97eb970bfbec1f26c914b9017c4a46
commit: f7d625adeb7bc6a9ec83d32d9615889969d64484 [3/11] net: ena: Add dynamic recycling mechanism for rx buffers
reproduce: (https://download.01.org/0day-ci/archive/20230617/202306171804.U7E92zoE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306171804.U7E92zoE-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Documentation/networking/device_drivers/ethernet/amazon/ena.rst:209: WARNING: Explicit markup ends without a blank line; unexpected unindent.

vim +209 Documentation/networking/device_drivers/ethernet/amazon/ena.rst

1738cd3ed34229 Documentation/networking/ena.txt                                Netanel Belgazal      2016-08-10  207  
f7d625adeb7bc6 Documentation/networking/device_drivers/ethernet/amazon/ena.rst David Arinzon         2023-06-12  208  .. _`RX copybreak`:
8d299c7e912bd8 Documentation/networking/device_drivers/amazon/ena.rst          Mauro Carvalho Chehab 2020-05-01 @209  RX copybreak
8d299c7e912bd8 Documentation/networking/device_drivers/amazon/ena.rst          Mauro Carvalho Chehab 2020-05-01  210  ============
1738cd3ed34229 Documentation/networking/ena.txt                                Netanel Belgazal      2016-08-10  211  The rx_copybreak is initialized by default to ENA_DEFAULT_RX_COPYBREAK
1738cd3ed34229 Documentation/networking/ena.txt                                Netanel Belgazal      2016-08-10  212  and can be configured by the ETHTOOL_STUNABLE command of the
1738cd3ed34229 Documentation/networking/ena.txt                                Netanel Belgazal      2016-08-10  213  SIOCETHTOOL ioctl.
1738cd3ed34229 Documentation/networking/ena.txt                                Netanel Belgazal      2016-08-10  214  

:::::: The code at line 209 was first introduced by commit
:::::: 8d299c7e912bd8ebb88b9ac2b8e336c9878783aa docs: networking: device drivers: convert amazon/ena.txt to ReST

:::::: TO: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
:::::: CC: David S. Miller <davem@davemloft.net>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D97A482951
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 06:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiABFY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 00:24:29 -0500
Received: from mga14.intel.com ([192.55.52.115]:8769 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbiABFY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jan 2022 00:24:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641101068; x=1672637068;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mZu8Nbk3CGXRAFyz9oQp7u0LNQ5MZW8iQDBKTnOS0X0=;
  b=IcHJLCUWuN6UcHq6RhwzMl0rXc9uJiZ1QMNI+UQrjME0bIPPws4eCYYo
   3AbOeM7FecomH0nlXuDKKsfR9nLo6lfP2LNEAPPfpBSPTcOfTEa8GxqgA
   o25SwMQJTwBMNFzQhfVeFDLL/iy6swbCaJAb41BJrkDC4M/eWTb20nyS1
   562+RQGKbpBwhs67PitYxEnRTTSH/LxVQrxClb84uSV8HYDInkbeZ94sy
   i4Tu3/qIIbGlGuePWS3x8djnzguhBju5WXZu0Fn8qEhKmhBOXuUOWH7MO
   fRGa+iIm2JTd7B8G8oegSa6O8kEfK+4Zcq7OUbLAiTt6dkTpIZNjCZJhU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10214"; a="242151689"
X-IronPort-AV: E=Sophos;i="5.88,255,1635231600"; 
   d="scan'208";a="242151689"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jan 2022 21:24:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,255,1635231600"; 
   d="scan'208";a="469384577"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 01 Jan 2022 21:24:25 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n3tM0-000D7u-O8; Sun, 02 Jan 2022 05:24:24 +0000
Date:   Sun, 2 Jan 2022 13:23:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Martin Habets <habetsm.xilinx@gmail.com>, kuba@kernel.org,
        jiasheng@iscas.ac.cn, davem@davemloft.net
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ecree.xilinx@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] sfc: The RX page_ring is optional
Message-ID: <202201021335.SbR7I6ht-lkp@intel.com>
References: <164103678041.26263.8354809911405746465.stgit@palantir17.mph.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164103678041.26263.8354809911405746465.stgit@palantir17.mph.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Martin-Habets/sfc-The-RX-page_ring-is-optional/20220101-194123
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git e63a02348958cd7cc8c8401c94de57ad97b5d06c
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220102/202201021335.SbR7I6ht-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project c054402170cd8466683a20385befc0523aba3359)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/162a8e2305bbbba8cd81966114ecce08790c431d
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Martin-Habets/sfc-The-RX-page_ring-is-optional/20220101-194123
        git checkout 162a8e2305bbbba8cd81966114ecce08790c431d
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/sfc/rx_common.c:120:3: error: void function 'efx_recycle_rx_pages' should not return a value [-Wreturn-type]
                   return NULL;
                   ^      ~~~~
   1 error generated.
--
>> drivers/net/ethernet/sfc/falcon/rx.c:299:3: error: void function 'ef4_recycle_rx_pages' should not return a value [-Wreturn-type]
                   return NULL;
                   ^      ~~~~
   1 error generated.


vim +/efx_recycle_rx_pages +120 drivers/net/ethernet/sfc/rx_common.c

   111	
   112	/* Recycle the pages that are used by buffers that have just been received. */
   113	void efx_recycle_rx_pages(struct efx_channel *channel,
   114				  struct efx_rx_buffer *rx_buf,
   115				  unsigned int n_frags)
   116	{
   117		struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
   118	
   119		if (unlikely(!rx_queue->page_ring))
 > 120			return NULL;
   121	
   122		do {
   123			efx_recycle_rx_page(channel, rx_buf);
   124			rx_buf = efx_rx_buf_next(rx_queue, rx_buf);
   125		} while (--n_frags);
   126	}
   127	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

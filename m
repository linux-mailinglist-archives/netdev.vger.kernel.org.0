Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A1552FFE7
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 02:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347672AbiEVASH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 20:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344708AbiEVASG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 20:18:06 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050DA3FD8A;
        Sat, 21 May 2022 17:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653178684; x=1684714684;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ypdycxd2ZYlFwqMvpBBvb9QQxGFHQEAqdNmc9kUCqmA=;
  b=OGUCqoT4X+kFB7+Oz5aC3i8QfcbHQn62337CuYXWc0f1q2nTLnoGVxV7
   +BAOZtcKTksldbrOI2imttrHgE/zXXLG4vRcPwPrByKERXT1z6rmsy/iP
   iarwbkNz34SbdlvcWgyP2sO+4+5SMWOKM+ZDaTd4/XQTUhHdB5mtJqbXe
   xmlcWET6CaeGUlLzJMu0p72vDAJRzbY53pOGe3WmSkrMDf8LpCRGcu2Ql
   tUt6pcuHDOnnlFAVYF6IG4n8vkbX2UN7wTKfQ9C7XEKZ3GwC8GA4fIVGw
   tdkftYtRPIG4ZvxkuZbxsV2r/Rbxrvi3bEp7Bdbx5UL1w06zevKe0ZHKZ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10354"; a="272629607"
X-IronPort-AV: E=Sophos;i="5.91,243,1647327600"; 
   d="scan'208";a="272629607"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 17:17:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,243,1647327600"; 
   d="scan'208";a="675231461"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 21 May 2022 17:17:56 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nsZIB-0006lG-ON;
        Sun, 22 May 2022 00:17:55 +0000
Date:   Sun, 22 May 2022 08:17:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pavel Skripkin <paskripkin@gmail.com>, toke@toke.dk,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, senthilkumar@atheros.com
Cc:     kbuild-all@lists.01.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: Re: [PATCH v5 2/2] ath9k: htc: clean up statistics macros
Message-ID: <202205220831.I9Nd8bqU-lkp@intel.com>
References: <7bb006bb88e280c596d0e86ece7d251a21b8ed1f.1653168225.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bb006bb88e280c596d0e86ece7d251a21b8ed1f.1653168225.git.paskripkin@gmail.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on wireless-next/main]
[also build test ERROR on next-20220520]
[cannot apply to wireless/main linus/master v5.18-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavel-Skripkin/ath9k-fix-use-after-free-in-ath9k_hif_usb_rx_cb/20220522-053020
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20220522/202205220831.I9Nd8bqU-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/712472af928db8726d53f2c63ea05430e57f4727
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Pavel-Skripkin/ath9k-fix-use-after-free-in-ath9k_hif_usb_rx_cb/20220522-053020
        git checkout 712472af928db8726d53f2c63ea05430e57f4727
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from drivers/net/wireless/ath/ath9k/hif_usb.c:18:
   drivers/net/wireless/ath/ath9k/hif_usb.c: In function '__hif_usb_tx':
>> drivers/net/wireless/ath/ath9k/hif_usb.c:372:29: error: 'hiv_dev' undeclared (first use in this function); did you mean 'hif_dev'?
     372 |                 TX_STAT_INC(hiv_dev, buf_queued);
         |                             ^~~~~~~
   drivers/net/wireless/ath/ath9k/htc.h:330:43: note: in definition of macro '__STAT_SAFE'
     330 | #define __STAT_SAFE(hif_dev, expr)      ((hif_dev)->htc_handle->drv_priv ? (expr) : 0)
         |                                           ^~~~~~~
   drivers/net/wireless/ath/ath9k/hif_usb.c:372:17: note: in expansion of macro 'TX_STAT_INC'
     372 |                 TX_STAT_INC(hiv_dev, buf_queued);
         |                 ^~~~~~~~~~~
   drivers/net/wireless/ath/ath9k/hif_usb.c:372:29: note: each undeclared identifier is reported only once for each function it appears in
     372 |                 TX_STAT_INC(hiv_dev, buf_queued);
         |                             ^~~~~~~
   drivers/net/wireless/ath/ath9k/htc.h:330:43: note: in definition of macro '__STAT_SAFE'
     330 | #define __STAT_SAFE(hif_dev, expr)      ((hif_dev)->htc_handle->drv_priv ? (expr) : 0)
         |                                           ^~~~~~~
   drivers/net/wireless/ath/ath9k/hif_usb.c:372:17: note: in expansion of macro 'TX_STAT_INC'
     372 |                 TX_STAT_INC(hiv_dev, buf_queued);
         |                 ^~~~~~~~~~~


vim +372 drivers/net/wireless/ath/ath9k/hif_usb.c

   308	
   309	/* TX lock has to be taken */
   310	static int __hif_usb_tx(struct hif_device_usb *hif_dev)
   311	{
   312		struct tx_buf *tx_buf = NULL;
   313		struct sk_buff *nskb = NULL;
   314		int ret = 0, i;
   315		u16 tx_skb_cnt = 0;
   316		u8 *buf;
   317		__le16 *hdr;
   318	
   319		if (hif_dev->tx.tx_skb_cnt == 0)
   320			return 0;
   321	
   322		/* Check if a free TX buffer is available */
   323		if (list_empty(&hif_dev->tx.tx_buf))
   324			return 0;
   325	
   326		tx_buf = list_first_entry(&hif_dev->tx.tx_buf, struct tx_buf, list);
   327		list_move_tail(&tx_buf->list, &hif_dev->tx.tx_pending);
   328		hif_dev->tx.tx_buf_cnt--;
   329	
   330		tx_skb_cnt = min_t(u16, hif_dev->tx.tx_skb_cnt, MAX_TX_AGGR_NUM);
   331	
   332		for (i = 0; i < tx_skb_cnt; i++) {
   333			nskb = __skb_dequeue(&hif_dev->tx.tx_skb_queue);
   334	
   335			/* Should never be NULL */
   336			BUG_ON(!nskb);
   337	
   338			hif_dev->tx.tx_skb_cnt--;
   339	
   340			buf = tx_buf->buf;
   341			buf += tx_buf->offset;
   342			hdr = (__le16 *)buf;
   343			*hdr++ = cpu_to_le16(nskb->len);
   344			*hdr++ = cpu_to_le16(ATH_USB_TX_STREAM_MODE_TAG);
   345			buf += 4;
   346			memcpy(buf, nskb->data, nskb->len);
   347			tx_buf->len = nskb->len + 4;
   348	
   349			if (i < (tx_skb_cnt - 1))
   350				tx_buf->offset += (((tx_buf->len - 1) / 4) + 1) * 4;
   351	
   352			if (i == (tx_skb_cnt - 1))
   353				tx_buf->len += tx_buf->offset;
   354	
   355			__skb_queue_tail(&tx_buf->skb_queue, nskb);
   356			TX_STAT_INC(hif_dev, skb_queued);
   357		}
   358	
   359		usb_fill_bulk_urb(tx_buf->urb, hif_dev->udev,
   360				  usb_sndbulkpipe(hif_dev->udev, USB_WLAN_TX_PIPE),
   361				  tx_buf->buf, tx_buf->len,
   362				  hif_usb_tx_cb, tx_buf);
   363	
   364		ret = usb_submit_urb(tx_buf->urb, GFP_ATOMIC);
   365		if (ret) {
   366			tx_buf->len = tx_buf->offset = 0;
   367			ath9k_skb_queue_complete(hif_dev, &tx_buf->skb_queue, false);
   368			__skb_queue_head_init(&tx_buf->skb_queue);
   369			list_move_tail(&tx_buf->list, &hif_dev->tx.tx_buf);
   370			hif_dev->tx.tx_buf_cnt++;
   371		} else {
 > 372			TX_STAT_INC(hiv_dev, buf_queued);
   373		}
   374	
   375		return ret;
   376	}
   377	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

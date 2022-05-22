Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A805D530247
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 12:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239366AbiEVKIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 06:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiEVKIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 06:08:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACFE3E5FB;
        Sun, 22 May 2022 03:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653214102; x=1684750102;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pVft9LSqtJKDfrQbwqF0zRGlcBrMn4ja8wUJvCE+/nY=;
  b=TgXqUcUTGFU6F8r0VXovUIBN2fNlx8wzJpIROEyOcNthc90/1Td4D6JC
   RazkWMCmSb85wsCwjmeQe1lFf/gp+TncapCCGiG3VjrcocfKqwaV11qkt
   8Ck95hQtXEXOnO+8rIGOdte3kNDDSud1F1gqqWfSffSd7i95KrE2boQU/
   n/CrAyuaSW0fWEarJ93s/Z+GP9y/rX0afSVgHFRp+xj2n4RWpNrfvKyrz
   nuEY8qIicTfEPFM+HVsAlgZ8aZgzhPyng2h41Pi9kQgAk96mFpUo9V0w+
   8p3MnwGWv60NgoNxEhG6lcrepVh6LmDm7Wxc7RlxWhH5EMFlBOb/atl0v
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10354"; a="333605223"
X-IronPort-AV: E=Sophos;i="5.91,244,1647327600"; 
   d="scan'208";a="333605223"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2022 03:08:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,244,1647327600"; 
   d="scan'208";a="819309267"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 22 May 2022 03:08:18 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nsiVW-0000HU-6O;
        Sun, 22 May 2022 10:08:18 +0000
Date:   Sun, 22 May 2022 18:07:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pavel Skripkin <paskripkin@gmail.com>, toke@toke.dk,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, senthilkumar@atheros.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: Re: [PATCH v5 2/2] ath9k: htc: clean up statistics macros
Message-ID: <202205221713.VsmyJA1I-lkp@intel.com>
References: <7bb006bb88e280c596d0e86ece7d251a21b8ed1f.1653168225.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bb006bb88e280c596d0e86ece7d251a21b8ed1f.1653168225.git.paskripkin@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20220522/202205221713.VsmyJA1I-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 1443dbaba6f0e57be066995db9164f89fb57b413)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/712472af928db8726d53f2c63ea05430e57f4727
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Pavel-Skripkin/ath9k-fix-use-after-free-in-ath9k_hif_usb_rx_cb/20220522-053020
        git checkout 712472af928db8726d53f2c63ea05430e57f4727
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/net/wireless/ath/ath9k/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/wireless/ath/ath9k/hif_usb.c:372:15: error: use of undeclared identifier 'hiv_dev'; did you mean 'hif_dev'?
                   TX_STAT_INC(hiv_dev, buf_queued);
                               ^~~~~~~
                               hif_dev
   drivers/net/wireless/ath/ath9k/htc.h:335:16: note: expanded from macro 'TX_STAT_INC'
                   __STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.tx_stats.c++)
                                ^
   drivers/net/wireless/ath/ath9k/htc.h:330:38: note: expanded from macro '__STAT_SAFE'
   #define __STAT_SAFE(hif_dev, expr)      ((hif_dev)->htc_handle->drv_priv ? (expr) : 0)
                                             ^
   drivers/net/wireless/ath/ath9k/hif_usb.c:310:48: note: 'hif_dev' declared here
   static int __hif_usb_tx(struct hif_device_usb *hif_dev)
                                                  ^
>> drivers/net/wireless/ath/ath9k/hif_usb.c:372:15: error: use of undeclared identifier 'hiv_dev'; did you mean 'hif_dev'?
                   TX_STAT_INC(hiv_dev, buf_queued);
                               ^~~~~~~
                               hif_dev
   drivers/net/wireless/ath/ath9k/htc.h:335:27: note: expanded from macro 'TX_STAT_INC'
                   __STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.tx_stats.c++)
                                           ^
   drivers/net/wireless/ath/ath9k/htc.h:330:72: note: expanded from macro '__STAT_SAFE'
   #define __STAT_SAFE(hif_dev, expr)      ((hif_dev)->htc_handle->drv_priv ? (expr) : 0)
                                                                               ^
   drivers/net/wireless/ath/ath9k/hif_usb.c:310:48: note: 'hif_dev' declared here
   static int __hif_usb_tx(struct hif_device_usb *hif_dev)
                                                  ^
   2 errors generated.


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

Return-Path: <netdev+bounces-12061-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B982735D98
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:55:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83BA11C20B64
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F29913ADC;
	Mon, 19 Jun 2023 18:55:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D0913AC8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 18:55:02 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF68130
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687200901; x=1718736901;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TOI2KZel7r/eYi39KBDvs/B6eovbTx+RJN6I/bClLiA=;
  b=fTgJhtUuI9PmfZkxb+KDvDQF7eg8g9K6LOOaqgf/ryLQ//mFnHnUHy1M
   v+ugQ1h91GsD6jat1mNPIdG7WXPeKHzhIUEeCmVyH2AC3TvOiuIeIiZSf
   WHOAB9pRwAPZctSx6ew7ndoUsCe1eM73V56NFNX9RmxTKscUTrMrvzvRd
   eqMPOWVoCjNEhqpK/TT1nX3DRw7QRBdgTNAKdVMPg68OQd13RqtHM9293
   HDSKlDhOKLBmXzhXMvB2hQ1HxMeUkzNikNpc9u41esJ0KfcWB9lLY9m72
   sqOsJOok3C1PSbIcQAVbie1H5wX98+jGQksHrpVfxRL2PJlh/6Tp7hU9Y
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="344443132"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="344443132"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 11:55:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="713799766"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="713799766"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 19 Jun 2023 11:54:58 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qBK1h-00050q-17;
	Mon, 19 Jun 2023 18:54:57 +0000
Date: Tue, 20 Jun 2023 02:54:02 +0800
From: kernel test robot <lkp@intel.com>
To: Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
	jiawenwu@trustnetic.com, mengyuanlou@net-swift.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, weiyongjun1@huawei.com,
	yuehaibing@huawei.com, shaozhengchao@huawei.com
Subject: Re: [PATCH net-next] net: txgbe: remove unused buffer in
 txgbe_calc_eeprom_checksum
Message-ID: <202306200242.FXsHokaJ-lkp@intel.com>
References: <20230619085709.104271-1-shaozhengchao@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619085709.104271-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Zhengchao,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Zhengchao-Shao/net-txgbe-remove-unused-buffer-in-txgbe_calc_eeprom_checksum/20230619-165935
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230619085709.104271-1-shaozhengchao%40huawei.com
patch subject: [PATCH net-next] net: txgbe: remove unused buffer in txgbe_calc_eeprom_checksum
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20230620/202306200242.FXsHokaJ-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20230620/202306200242.FXsHokaJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306200242.FXsHokaJ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c: In function 'txgbe_calc_eeprom_checksum':
>> drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c:163:13: warning: unused variable 'buffer_size' [-Wunused-variable]
     163 |         u32 buffer_size = 0;
         |             ^~~~~~~~~~~


vim +/buffer_size +163 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c

049fe5365324c8 Jiawen Wu      2022-10-31  152  
049fe5365324c8 Jiawen Wu      2022-10-31  153  /**
049fe5365324c8 Jiawen Wu      2022-10-31  154   *  txgbe_calc_eeprom_checksum - Calculates and returns the checksum
9607a3e62645c2 Jiawen Wu      2023-01-06  155   *  @wx: pointer to hardware structure
049fe5365324c8 Jiawen Wu      2022-10-31  156   *  @checksum: pointer to cheksum
049fe5365324c8 Jiawen Wu      2022-10-31  157   *
049fe5365324c8 Jiawen Wu      2022-10-31  158   *  Returns a negative error code on error
049fe5365324c8 Jiawen Wu      2022-10-31  159   **/
9607a3e62645c2 Jiawen Wu      2023-01-06  160  static int txgbe_calc_eeprom_checksum(struct wx *wx, u16 *checksum)
049fe5365324c8 Jiawen Wu      2022-10-31  161  {
049fe5365324c8 Jiawen Wu      2022-10-31  162  	u16 *eeprom_ptrs = NULL;
049fe5365324c8 Jiawen Wu      2022-10-31 @163  	u32 buffer_size = 0;
049fe5365324c8 Jiawen Wu      2022-10-31  164  	u16 *local_buffer;
049fe5365324c8 Jiawen Wu      2022-10-31  165  	int status;
049fe5365324c8 Jiawen Wu      2022-10-31  166  	u16 i;
049fe5365324c8 Jiawen Wu      2022-10-31  167  
9607a3e62645c2 Jiawen Wu      2023-01-06  168  	wx_init_eeprom_params(wx);
049fe5365324c8 Jiawen Wu      2022-10-31  169  
049fe5365324c8 Jiawen Wu      2022-10-31  170  	eeprom_ptrs = kvmalloc_array(TXGBE_EEPROM_LAST_WORD, sizeof(u16),
049fe5365324c8 Jiawen Wu      2022-10-31  171  				     GFP_KERNEL);
049fe5365324c8 Jiawen Wu      2022-10-31  172  	if (!eeprom_ptrs)
049fe5365324c8 Jiawen Wu      2022-10-31  173  		return -ENOMEM;
049fe5365324c8 Jiawen Wu      2022-10-31  174  	/* Read pointer area */
f5b8ea1c5022db Zhengchao Shao 2023-06-19  175  	status = wx_read_ee_hostif_buffer(wx, 0, TXGBE_EEPROM_LAST_WORD, eeprom_ptrs);
049fe5365324c8 Jiawen Wu      2022-10-31  176  	if (status != 0) {
9607a3e62645c2 Jiawen Wu      2023-01-06  177  		wx_err(wx, "Failed to read EEPROM image\n");
a068d33e542f5d YueHaibing     2022-11-05  178  		kvfree(eeprom_ptrs);
049fe5365324c8 Jiawen Wu      2022-10-31  179  		return status;
049fe5365324c8 Jiawen Wu      2022-10-31  180  	}
049fe5365324c8 Jiawen Wu      2022-10-31  181  	local_buffer = eeprom_ptrs;
049fe5365324c8 Jiawen Wu      2022-10-31  182  
049fe5365324c8 Jiawen Wu      2022-10-31  183  	for (i = 0; i < TXGBE_EEPROM_LAST_WORD; i++)
9607a3e62645c2 Jiawen Wu      2023-01-06  184  		if (i != wx->eeprom.sw_region_offset + TXGBE_EEPROM_CHECKSUM)
049fe5365324c8 Jiawen Wu      2022-10-31  185  			*checksum += local_buffer[i];
049fe5365324c8 Jiawen Wu      2022-10-31  186  
a068d33e542f5d YueHaibing     2022-11-05  187  	if (eeprom_ptrs)
a068d33e542f5d YueHaibing     2022-11-05  188  		kvfree(eeprom_ptrs);
a068d33e542f5d YueHaibing     2022-11-05  189  
5e2ea7801faccc YueHaibing     2022-11-05  190  	if (*checksum > TXGBE_EEPROM_SUM)
049fe5365324c8 Jiawen Wu      2022-10-31  191  		return -EINVAL;
049fe5365324c8 Jiawen Wu      2022-10-31  192  
5e2ea7801faccc YueHaibing     2022-11-05  193  	*checksum = TXGBE_EEPROM_SUM - *checksum;
5e2ea7801faccc YueHaibing     2022-11-05  194  
049fe5365324c8 Jiawen Wu      2022-10-31  195  	return 0;
049fe5365324c8 Jiawen Wu      2022-10-31  196  }
049fe5365324c8 Jiawen Wu      2022-10-31  197  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


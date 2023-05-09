Return-Path: <netdev+bounces-1110-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E7CE6FC3B1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:18:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1463328127A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32FB2DDCD;
	Tue,  9 May 2023 10:18:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D958BE8
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:18:07 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB3A30FA;
	Tue,  9 May 2023 03:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683627479; x=1715163479;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lFaYZaHglXHehMJ3FYW16hTblnm28QwUMGPBW9xCS3A=;
  b=bLCgozb+3t+8MBp6RzVVCqWQ65ebWQp8fPdqdolMY2zDRgR5atvy7WYw
   6Mqca8ahdsuxypLr90rhAutLF2fLw82emLOmjwb2JoMBbHvv/dTN5b4jo
   n86FeJd8CKcDzI2cMNvKHGpIL12E08xOpfMJVRDYqnUjdvOAVIY/CC0X1
   HnT61LRin0RgdaSDmED3hFpHjKOgXhQCvTOfll2FNjX1gQyIC1CTIFg8f
   TJzl5aM97ie1EpOfqpTfK3fats/8/s/1QCKNLS+fFcPm57Fm+gVC/OCpJ
   JsaavMDjV8m2j1YO3T9LZn8FA10lMDGe72FMhIqttBH93IYFHMQvxmW9s
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="413158406"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="413158406"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 03:17:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="873156762"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="873156762"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 09 May 2023 03:17:55 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pwKPq-000244-37;
	Tue, 09 May 2023 10:17:54 +0000
Date: Tue, 9 May 2023 18:17:43 +0800
From: kernel test robot <lkp@intel.com>
To: "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>, wg@grandegger.com,
	mkl@pengutronix.de, michal.swiatkowski@linux.intel.com,
	Steen.Hegelund@microchip.com, mailhol.vincent@wanadoo.fr
Cc: oe-kbuild-all@lists.linux.dev, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, frank.jungclaus@esd.eu,
	linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
	netdev@vger.kernel.org, hpeter+linux_kernel@gmail.com,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>
Subject: Re: [PATCH V7] can: usb: f81604: add Fintek F81604 support
Message-ID: <202305091802.pRFS6n2j-lkp@intel.com>
References: <20230509073821.25289-1-peter_hong@fintek.com.tw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509073821.25289-1-peter_hong@fintek.com.tw>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Ji-Ze,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkl-can-next/testing]
[also build test WARNING on linus/master v6.4-rc1 next-20230509]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ji-Ze-Hong-Peter-Hong/can-usb-f81604-add-Fintek-F81604-support/20230509-154045
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git testing
patch link:    https://lore.kernel.org/r/20230509073821.25289-1-peter_hong%40fintek.com.tw
patch subject: [PATCH V7] can: usb: f81604: add Fintek F81604 support
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20230509/202305091802.pRFS6n2j-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/9549380f8d5eea359f8c83f48e10a0becfd13541
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Ji-Ze-Hong-Peter-Hong/can-usb-f81604-add-Fintek-F81604-support/20230509-154045
        git checkout 9549380f8d5eea359f8c83f48e10a0becfd13541
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305091802.pRFS6n2j-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/can/usb/f81604.c: In function 'f81604_read_bulk_callback':
>> drivers/net/can/usb/f81604.c:440:67: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type 'unsigned int' [-Wformat=]
     440 |                 netdev_warn(netdev, "URB length %u not equal to %lu\n",
         |                                                                 ~~^
         |                                                                   |
         |                                                                   long unsigned int
         |                                                                 %u
     441 |                             urb->actual_length, sizeof(*frame));
         |                                                 ~~~~~~~~~~~~~~     
         |                                                 |
         |                                                 unsigned int


vim +440 drivers/net/can/usb/f81604.c

   411	
   412	static void f81604_read_bulk_callback(struct urb *urb)
   413	{
   414		struct f81604_can_frame *frame = urb->transfer_buffer;
   415		struct net_device *netdev = urb->context;
   416		int ret;
   417	
   418		if (!netif_device_present(netdev))
   419			return;
   420	
   421		if (urb->status)
   422			netdev_info(netdev, "%s: URB aborted %pe\n", __func__,
   423				    ERR_PTR(urb->status));
   424	
   425		switch (urb->status) {
   426		case 0: /* success */
   427			break;
   428	
   429		case -ENOENT:
   430		case -EPIPE:
   431		case -EPROTO:
   432		case -ESHUTDOWN:
   433			return;
   434	
   435		default:
   436			goto resubmit_urb;
   437		}
   438	
   439		if (urb->actual_length != sizeof(*frame)) {
 > 440			netdev_warn(netdev, "URB length %u not equal to %lu\n",
   441				    urb->actual_length, sizeof(*frame));
   442			goto resubmit_urb;
   443		}
   444	
   445		f81604_process_rx_packet(netdev, frame);
   446	
   447	resubmit_urb:
   448		ret = usb_submit_urb(urb, GFP_ATOMIC);
   449		if (ret == -ENODEV)
   450			netif_device_detach(netdev);
   451		else if (ret)
   452			netdev_err(netdev,
   453				   "%s: failed to resubmit read bulk urb: %pe\n",
   454				   __func__, ERR_PTR(ret));
   455	}
   456	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests


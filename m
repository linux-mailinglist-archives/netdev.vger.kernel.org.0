Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2F26E0D17
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 13:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjDMLu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 07:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjDMLu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 07:50:58 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5F52717;
        Thu, 13 Apr 2023 04:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681386654; x=1712922654;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5/91+NqLCJ3u7tp8EZonjuXYniF5+ZOmjo9E0OBcpqY=;
  b=H8FWI9TraZItUw+L4aiGJdInkzYonayKIqFouLc62Ba09L21KD5wKhu7
   ss3iJjrYqpDQ/tO/3xIQbKSqpAksgEXyEhmBK+Qi3ZcNriJ34oPSTZ+Dl
   8nloihmXFGbghyxfDQ/OBqnRUfgtF4xigysSEXVer81qTryETC69kLuMl
   fpqZnGLxP8dlVMNCJ4CWFfjgOvckeVXS8i08QLU6/wUdx1UTKnrpkU6fj
   fAjJzbUSQXlDYMcJO0Sc9pAoB4OcURUsfouE1vpM29mEurBiR7PQnnyG5
   QavrQ4OPW9mg5vDTfbOlnqsvK6chutcY2d/wnno/nZOlr/FREA+HY35qo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="372013460"
X-IronPort-AV: E=Sophos;i="5.99,341,1677571200"; 
   d="scan'208";a="372013460"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 04:50:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="691929749"
X-IronPort-AV: E=Sophos;i="5.99,341,1677571200"; 
   d="scan'208";a="691929749"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 13 Apr 2023 04:50:46 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pmvTT-000YeL-0n;
        Thu, 13 Apr 2023 11:50:47 +0000
Date:   Thu, 13 Apr 2023 19:49:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
        wg@grandegger.com, mkl@pengutronix.de,
        michal.swiatkowski@linux.intel.com, Steen.Hegelund@microchip.com,
        mailhol.vincent@wanadoo.fr
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        frank.jungclaus@esd.eu, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        hpeter+linux_kernel@gmail.com,
        "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>
Subject: Re: [PATCH V4] can: usb: f81604: add Fintek F81604 support
Message-ID: <202304131914.TQf2Z1pL-lkp@intel.com>
References: <20230413084253.1524-1-peter_hong@fintek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413084253.1524-1-peter_hong@fintek.com.tw>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ji-Ze,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkl-can-next/testing]
[also build test WARNING on linus/master v6.3-rc6 next-20230412]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ji-Ze-Hong-Peter-Hong/can-usb-f81604-add-Fintek-F81604-support/20230413-164625
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git testing
patch link:    https://lore.kernel.org/r/20230413084253.1524-1-peter_hong%40fintek.com.tw
patch subject: [PATCH V4] can: usb: f81604: add Fintek F81604 support
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20230413/202304131914.TQf2Z1pL-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/225b03ddc1d9e5b6a8dac065d29288fc8ceb1357
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Ji-Ze-Hong-Peter-Hong/can-usb-f81604-add-Fintek-F81604-support/20230413-164625
        git checkout 225b03ddc1d9e5b6a8dac065d29288fc8ceb1357
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304131914.TQf2Z1pL-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/can/usb/f81604.c: In function 'f81604_clear_reg_work':
>> drivers/net/can/usb/f81604.c:894:28: warning: variable 'netdev' set but not used [-Wunused-but-set-variable]
     894 |         struct net_device *netdev;
         |                            ^~~~~~
   drivers/net/can/usb/f81604.c: In function 'f81604_disconnect':
>> drivers/net/can/usb/f81604.c:1086:34: warning: variable 'port_priv' set but not used [-Wunused-but-set-variable]
    1086 |         struct f81604_port_priv *port_priv;
         |                                  ^~~~~~~~~


vim +/netdev +894 drivers/net/can/usb/f81604.c

   890	
   891	static void f81604_clear_reg_work(struct work_struct *work)
   892	{
   893		struct f81604_port_priv *priv;
 > 894		struct net_device *netdev;
   895		u8 tmp;
   896	
   897		priv = container_of(work, struct f81604_port_priv, clear_reg_work);
   898		netdev = priv->netdev;
   899	
   900		/* dummy read for clear Arbitration lost capture(ALC) register. */
   901		if (test_and_clear_bit(F81604_CLEAR_ALC, &priv->clear_flags))
   902			f81604_sja1000_read(priv, F81604_SJA1000_ALC, &tmp);
   903	
   904		/* dummy read for clear Error code capture(ECC) register. */
   905		if (test_and_clear_bit(F81604_CLEAR_ECC, &priv->clear_flags))
   906			f81604_sja1000_read(priv, F81604_SJA1000_ECC, &tmp);
   907	
   908		/* dummy write for clear data overrun flag. */
   909		if (test_and_clear_bit(F81604_CLEAR_OVERRUN, &priv->clear_flags))
   910			f81604_sja1000_write(priv, F81604_SJA1000_CMR,
   911					     F81604_SJA1000_CMD_CDO);
   912	}
   913	
   914	static netdev_tx_t f81604_start_xmit(struct sk_buff *skb,
   915					     struct net_device *netdev)
   916	{
   917		struct can_frame *cf = (struct can_frame *)skb->data;
   918		struct f81604_port_priv *priv = netdev_priv(netdev);
   919		struct net_device_stats *stats = &netdev->stats;
   920		struct f81604_can_frame *frame;
   921		u32 id = priv->netdev->dev_id;
   922		struct urb *write_urb;
   923		u8 *bulk_write_buffer;
   924		int ret;
   925	
   926		if (can_dev_dropped_skb(netdev, skb))
   927			return NETDEV_TX_OK;
   928	
   929		netif_stop_queue(netdev);
   930	
   931		write_urb = usb_alloc_urb(0, GFP_ATOMIC);
   932		if (!write_urb)
   933			goto nomem_urb;
   934	
   935		bulk_write_buffer = kzalloc(F81604_DATA_SIZE, GFP_ATOMIC);
   936		if (!bulk_write_buffer)
   937			goto nomem_buf;
   938	
   939		usb_fill_bulk_urb(write_urb, priv->dev,
   940				  usb_sndbulkpipe(priv->dev, bulk_out_addr[id]),
   941				  bulk_write_buffer, F81604_DATA_SIZE,
   942				  f81604_write_bulk_callback, priv->netdev);
   943	
   944		write_urb->transfer_flags |= URB_FREE_BUFFER;
   945	
   946		frame = (struct f81604_can_frame *)bulk_write_buffer;
   947		frame->cmd = F81604_CMD_DATA;
   948		frame->dlc = cf->len;
   949	
   950		if (cf->can_id & CAN_RTR_FLAG)
   951			frame->dlc |= F81604_DLC_RTR_BIT;
   952	
   953		if (cf->can_id & CAN_EFF_FLAG) {
   954			id = (cf->can_id & CAN_EFF_MASK) << 3;
   955			put_unaligned_be32(id, &frame->eff.id);
   956	
   957			frame->dlc |= F81604_DLC_EFF_BIT;
   958	
   959			if (!(cf->can_id & CAN_RTR_FLAG))
   960				memcpy(&frame->eff.data, cf->data, cf->len);
   961		} else {
   962			id = (cf->can_id & CAN_SFF_MASK) << 5;
   963			put_unaligned_be16(id, &frame->sff.id);
   964	
   965			if (!(cf->can_id & CAN_RTR_FLAG))
   966				memcpy(&frame->sff.data, cf->data, cf->len);
   967		}
   968	
   969		can_put_echo_skb(skb, netdev, 0, 0);
   970	
   971		ret = usb_submit_urb(write_urb, GFP_ATOMIC);
   972		if (ret) {
   973			netdev_err(netdev, "%s: failed to resubmit tx bulk urb: %pe\n",
   974				   __func__, ERR_PTR(ret));
   975	
   976			can_free_echo_skb(netdev, 0, NULL);
   977			stats->tx_dropped++;
   978	
   979			if (ret == -ENODEV)
   980				netif_device_detach(netdev);
   981			else
   982				netif_wake_queue(netdev);
   983		}
   984	
   985		/* let usb core take care of this urb */
   986		usb_free_urb(write_urb);
   987	
   988		return NETDEV_TX_OK;
   989	
   990	nomem_buf:
   991		usb_free_urb(write_urb);
   992	
   993	nomem_urb:
   994		dev_kfree_skb(skb);
   995		stats->tx_dropped++;
   996		netif_wake_queue(netdev);
   997	
   998		return NETDEV_TX_OK;
   999	}
  1000	
  1001	static int f81604_get_berr_counter(const struct net_device *netdev,
  1002					   struct can_berr_counter *bec)
  1003	{
  1004		struct f81604_port_priv *priv = netdev_priv(netdev);
  1005		u8 txerr, rxerr;
  1006		int ret;
  1007	
  1008		ret = f81604_sja1000_read(priv, F81604_SJA1000_TXERR, &txerr);
  1009		if (ret)
  1010			return ret;
  1011	
  1012		ret = f81604_sja1000_read(priv, F81604_SJA1000_RXERR, &rxerr);
  1013		if (ret)
  1014			return ret;
  1015	
  1016		bec->txerr = txerr;
  1017		bec->rxerr = rxerr;
  1018	
  1019		return 0;
  1020	}
  1021	
  1022	/* Open USB device */
  1023	static int f81604_open(struct net_device *netdev)
  1024	{
  1025		int ret;
  1026	
  1027		ret = open_candev(netdev);
  1028		if (ret)
  1029			return ret;
  1030	
  1031		ret = f81604_start(netdev);
  1032		if (ret)
  1033			goto start_failed;
  1034	
  1035		netif_start_queue(netdev);
  1036		return 0;
  1037	
  1038	start_failed:
  1039		if (ret == -ENODEV)
  1040			netif_device_detach(netdev);
  1041	
  1042		close_candev(netdev);
  1043	
  1044		return ret;
  1045	}
  1046	
  1047	/* Close USB device */
  1048	static int f81604_close(struct net_device *netdev)
  1049	{
  1050		struct f81604_port_priv *priv = netdev_priv(netdev);
  1051	
  1052		f81604_set_reset_mode(priv);
  1053	
  1054		netif_stop_queue(netdev);
  1055		cancel_work_sync(&priv->clear_reg_work);
  1056		close_candev(netdev);
  1057	
  1058		f81604_unregister_urbs(priv);
  1059	
  1060		return 0;
  1061	}
  1062	
  1063	static const struct net_device_ops f81604_netdev_ops = {
  1064		.ndo_open = f81604_open,
  1065		.ndo_stop = f81604_close,
  1066		.ndo_start_xmit = f81604_start_xmit,
  1067		.ndo_change_mtu = can_change_mtu,
  1068	};
  1069	
  1070	static const struct can_bittiming_const f81604_bittiming_const = {
  1071		.name = KBUILD_MODNAME,
  1072		.tseg1_min = 1,
  1073		.tseg1_max = 16,
  1074		.tseg2_min = 1,
  1075		.tseg2_max = 8,
  1076		.sjw_max = 4,
  1077		.brp_min = 1,
  1078		.brp_max = 64,
  1079		.brp_inc = 1,
  1080	};
  1081	
  1082	/* Called by the usb core when driver is unloaded or device is removed */
  1083	static void f81604_disconnect(struct usb_interface *intf)
  1084	{
  1085		struct f81604_priv *priv = usb_get_intfdata(intf);
> 1086		struct f81604_port_priv *port_priv;
  1087		int i;
  1088	
  1089		for (i = 0; i < ARRAY_SIZE(priv->netdev); ++i) {
  1090			if (!priv->netdev[i])
  1091				continue;
  1092	
  1093			port_priv = netdev_priv(priv->netdev[i]);
  1094	
  1095			unregister_netdev(priv->netdev[i]);
  1096			free_candev(priv->netdev[i]);
  1097		}
  1098	}
  1099	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

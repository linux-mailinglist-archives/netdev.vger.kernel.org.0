Return-Path: <netdev+bounces-6982-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B77797191A1
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:12:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE9601C20F8E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 04:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1FCA63DD;
	Thu,  1 Jun 2023 04:12:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3565397
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 04:12:04 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F80FE7
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 21:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685592722; x=1717128722;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=0F7rmJkA/nCMCaVmGgRa3cvFcvXjrbZRm/Mur/lie6k=;
  b=gh+4oTeeDnYJIYV7OSgfTDqrd0tAyAexw7WC6jl3io3x2p+Xhn5nGdY1
   AJmfPZNY6shARvNTJSScW3p9PI39mh8uJiQQHTVzSPhnH7wKHU9/EOxaO
   +P/0OAwX8R+enMlGeza1SGowpUjOJmKN+4FfaoMGusVk8KCNpVJIzWA1p
   4ySqZzJ9WrafF6LQU1Gfq59GjhDp1YlojtyPc2uOKMc5O+UvCBo5I//J+
   7S56k47cLNg0qShn7CZjgjSHh6r8cUse2C6izn6SU/YvKGamDJY/cKSXC
   SZl97AB7l3Q8IfL0F+vSJbUKgikvx2U9B0+lQcum5nBw186MWSc0yyxxE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="383711879"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="383711879"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 21:12:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="796974487"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="796974487"
Received: from lkp-server01.sh.intel.com (HELO fb1ced2c09fb) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 31 May 2023 21:12:00 -0700
Received: from kbuild by fb1ced2c09fb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q4ZfL-0001tl-2R;
	Thu, 01 Jun 2023 04:11:59 +0000
Date: Thu, 1 Jun 2023 12:11:36 +0800
From: kernel test robot <lkp@intel.com>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [net-next:main 12/26] drivers/net/dsa/qca/qca8k-leds.c:377:18:
 error: no member named 'hw_control_is_supported' in 'struct led_classdev'
Message-ID: <202306011219.NQCSpIEG-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git main
head:   60cbd38bb0ad9e4395fba9c6994f258f1d6cad51
commit: e0256648c831af13cbfe4a1787327fcec01c2807 [12/26] net: dsa: qca8k: implement hw_control ops
config: mips-randconfig-r003-20230531 (https://download.01.org/0day-ci/archive/20230601/202306011219.NQCSpIEG-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 4faf3aaf28226a4e950c103a14f6fc1d1fdabb1b)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mipsel-linux-gnu
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=e0256648c831af13cbfe4a1787327fcec01c2807
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next main
        git checkout e0256648c831af13cbfe4a1787327fcec01c2807
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=mips olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash drivers/net/dsa/qca/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306011219.NQCSpIEG-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/dsa/qca/qca8k-leds.c:377:18: error: no member named 'hw_control_is_supported' in 'struct led_classdev'
                   port_led->cdev.hw_control_is_supported = qca8k_cled_hw_control_is_supported;
                   ~~~~~~~~~~~~~~ ^
>> drivers/net/dsa/qca/qca8k-leds.c:378:18: error: no member named 'hw_control_set' in 'struct led_classdev'
                   port_led->cdev.hw_control_set = qca8k_cled_hw_control_set;
                   ~~~~~~~~~~~~~~ ^
>> drivers/net/dsa/qca/qca8k-leds.c:379:18: error: no member named 'hw_control_get' in 'struct led_classdev'
                   port_led->cdev.hw_control_get = qca8k_cled_hw_control_get;
                   ~~~~~~~~~~~~~~ ^
>> drivers/net/dsa/qca/qca8k-leds.c:380:18: error: no member named 'hw_control_trigger' in 'struct led_classdev'
                   port_led->cdev.hw_control_trigger = "netdev";
                   ~~~~~~~~~~~~~~ ^
   4 errors generated.


vim +377 drivers/net/dsa/qca/qca8k-leds.c

   316	
   317	static int
   318	qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
   319	{
   320		struct fwnode_handle *led = NULL, *leds = NULL;
   321		struct led_init_data init_data = { };
   322		struct dsa_switch *ds = priv->ds;
   323		enum led_default_state state;
   324		struct qca8k_led *port_led;
   325		int led_num, led_index;
   326		int ret;
   327	
   328		leds = fwnode_get_named_child_node(port, "leds");
   329		if (!leds) {
   330			dev_dbg(priv->dev, "No Leds node specified in device tree for port %d!\n",
   331				port_num);
   332			return 0;
   333		}
   334	
   335		fwnode_for_each_child_node(leds, led) {
   336			/* Reg represent the led number of the port.
   337			 * Each port can have at most 3 leds attached
   338			 * Commonly:
   339			 * 1. is gigabit led
   340			 * 2. is mbit led
   341			 * 3. additional status led
   342			 */
   343			if (fwnode_property_read_u32(led, "reg", &led_num))
   344				continue;
   345	
   346			if (led_num >= QCA8K_LED_PORT_COUNT) {
   347				dev_warn(priv->dev, "Invalid LED reg %d defined for port %d",
   348					 led_num, port_num);
   349				continue;
   350			}
   351	
   352			led_index = QCA8K_LED_PORT_INDEX(port_num, led_num);
   353	
   354			port_led = &priv->ports_led[led_index];
   355			port_led->port_num = port_num;
   356			port_led->led_num = led_num;
   357			port_led->priv = priv;
   358	
   359			state = led_init_default_state_get(led);
   360			switch (state) {
   361			case LEDS_DEFSTATE_ON:
   362				port_led->cdev.brightness = 1;
   363				qca8k_led_brightness_set(port_led, 1);
   364				break;
   365			case LEDS_DEFSTATE_KEEP:
   366				port_led->cdev.brightness =
   367						qca8k_led_brightness_get(port_led);
   368				break;
   369			default:
   370				port_led->cdev.brightness = 0;
   371				qca8k_led_brightness_set(port_led, 0);
   372			}
   373	
   374			port_led->cdev.max_brightness = 1;
   375			port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
   376			port_led->cdev.blink_set = qca8k_cled_blink_set;
 > 377			port_led->cdev.hw_control_is_supported = qca8k_cled_hw_control_is_supported;
 > 378			port_led->cdev.hw_control_set = qca8k_cled_hw_control_set;
 > 379			port_led->cdev.hw_control_get = qca8k_cled_hw_control_get;
 > 380			port_led->cdev.hw_control_trigger = "netdev";
   381			init_data.default_label = ":port";
   382			init_data.fwnode = led;
   383			init_data.devname_mandatory = true;
   384			init_data.devicename = kasprintf(GFP_KERNEL, "%s:0%d", ds->slave_mii_bus->id,
   385							 port_num);
   386			if (!init_data.devicename)
   387				return -ENOMEM;
   388	
   389			ret = devm_led_classdev_register_ext(priv->dev, &port_led->cdev, &init_data);
   390			if (ret)
   391				dev_warn(priv->dev, "Failed to init LED %d for port %d", led_num, port_num);
   392	
   393			kfree(init_data.devicename);
   394		}
   395	
   396		return 0;
   397	}
   398	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


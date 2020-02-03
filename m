Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30636150017
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 01:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgBCAQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 19:16:18 -0500
Received: from mga14.intel.com ([192.55.52.115]:25300 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbgBCAQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Feb 2020 19:16:17 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Feb 2020 16:16:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,395,1574150400"; 
   d="gz'50?scan'50,208,50";a="310574624"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 02 Feb 2020 16:16:01 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iyPPF-000BM8-4R; Mon, 03 Feb 2020 08:16:01 +0800
Date:   Mon, 3 Feb 2020 08:15:48 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild-all@lists.01.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ajay Gupta <ajayg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] device property: change device_get_phy_mode() to
 prevent signedess bugs
Message-ID: <202002030811.LGxjjsUT%lkp@intel.com>
References: <20200131045953.wbj66jkvijnmf5s2@kili.mountain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5arorcrsjgvmibaf"
Content-Disposition: inline
In-Reply-To: <20200131045953.wbj66jkvijnmf5s2@kili.mountain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5arorcrsjgvmibaf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]
[also build test ERROR on driver-core/driver-core-testing linus/master v5.5 next-20200131]
[cannot apply to sparc-next/master]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Dan-Carpenter/device-property-change-device_get_phy_mode-to-prevent-signedess-bugs/20200203-043126
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git b7c3a17c6062701d97a0959890a2c882bfaac537
config: x86_64-defconfig (attached as .config)
compiler: gcc-7 (Debian 7.5.0-3) 7.5.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/ethtool.h:18:0,
                    from include/linux/phy.h:16,
                    from include/linux/property.h:15,
                    from include/linux/of.h:22,
                    from include/linux/irqdomain.h:35,
                    from include/linux/acpi.h:13,
                    from drivers/gpu/drm/i915/i915_drv.c:30:
>> include/uapi/linux/ethtool.h:1668:20: error: expected identifier before numeric constant
    #define PORT_NONE  0xef
                       ^
>> drivers/gpu/drm/i915/display/intel_display.h:190:2: note: in expansion of macro 'PORT_NONE'
     PORT_NONE = -1,
     ^~~~~~~~~
   In file included from drivers/gpu/drm/i915/display/intel_bw.h:11:0,
                    from drivers/gpu/drm/i915/i915_drv.c:51:
   drivers/gpu/drm/i915/display/intel_display.h: In function 'port_identifier':
>> drivers/gpu/drm/i915/display/intel_display.h:214:7: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
     case PORT_A:
          ^~~~~~
          PORT_DA
   drivers/gpu/drm/i915/display/intel_display.h:214:7: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/gpu/drm/i915/display/intel_display.h:216:7: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_A'?
     case PORT_B:
          ^~~~~~
          PORT_A
>> drivers/gpu/drm/i915/display/intel_display.h:218:7: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
     case PORT_C:
          ^~~~~~
          PORT_B
>> drivers/gpu/drm/i915/display/intel_display.h:220:7: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_C'?
     case PORT_D:
          ^~~~~~
          PORT_C
>> drivers/gpu/drm/i915/display/intel_display.h:222:7: error: 'PORT_E' undeclared (first use in this function); did you mean 'PORT_D'?
     case PORT_E:
          ^~~~~~
          PORT_D
>> drivers/gpu/drm/i915/display/intel_display.h:224:7: error: 'PORT_F' undeclared (first use in this function); did you mean 'PORT_E'?
     case PORT_F:
          ^~~~~~
          PORT_E
>> drivers/gpu/drm/i915/display/intel_display.h:226:7: error: 'PORT_G' undeclared (first use in this function); did you mean 'PORT_F'?
     case PORT_G:
          ^~~~~~
          PORT_F
>> drivers/gpu/drm/i915/display/intel_display.h:228:7: error: 'PORT_H' undeclared (first use in this function); did you mean 'PORT_G'?
     case PORT_H:
          ^~~~~~
          PORT_G
>> drivers/gpu/drm/i915/display/intel_display.h:230:7: error: 'PORT_I' undeclared (first use in this function); did you mean 'PORT_H'?
     case PORT_I:
          ^~~~~~
          PORT_H
   In file included from drivers/gpu/drm/i915/display/intel_display_types.h:46:0,
                    from drivers/gpu/drm/i915/i915_drv.c:53:
   drivers/gpu/drm/i915/i915_drv.h: At top level:
>> drivers/gpu/drm/i915/i915_drv.h:726:41: error: 'I915_MAX_PORTS' undeclared here (not in a function); did you mean 'I915_MAX_PHYS'?
     struct ddi_vbt_port_info ddi_port_info[I915_MAX_PORTS];
                                            ^~~~~~~~~~~~~~
                                            I915_MAX_PHYS
   In file included from drivers/gpu/drm/i915/i915_drv.c:53:0:
   drivers/gpu/drm/i915/display/intel_display_types.h: In function 'vlv_dport_to_channel':
>> drivers/gpu/drm/i915/display/intel_display_types.h:1386:7: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_BNC'?
     case PORT_B:
          ^~~~~~
          PORT_BNC
>> drivers/gpu/drm/i915/display/intel_display_types.h:1387:7: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_B'?
     case PORT_D:
          ^~~~~~
          PORT_B
>> drivers/gpu/drm/i915/display/intel_display_types.h:1389:7: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_D'?
     case PORT_C:
          ^~~~~~
          PORT_D
   drivers/gpu/drm/i915/display/intel_display_types.h: In function 'vlv_dport_to_phy':
   drivers/gpu/drm/i915/display/intel_display_types.h:1400:7: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_BNC'?
     case PORT_B:
          ^~~~~~
          PORT_BNC
>> drivers/gpu/drm/i915/display/intel_display_types.h:1401:7: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
     case PORT_C:
          ^~~~~~
          PORT_B
>> drivers/gpu/drm/i915/display/intel_display_types.h:1403:7: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_C'?
     case PORT_D:
          ^~~~~~
          PORT_C
--
   In file included from include/linux/ethtool.h:18:0,
                    from include/linux/phy.h:16,
                    from include/linux/property.h:15,
                    from include/linux/of.h:22,
                    from include/linux/irqdomain.h:35,
                    from include/linux/acpi.h:13,
                    from include/linux/i2c.h:13,
                    from drivers/gpu/drm/i915/display/intel_display_types.h:30,
                    from drivers/gpu/drm/i915/i915_irq.c:39:
>> include/uapi/linux/ethtool.h:1668:20: error: expected identifier before numeric constant
    #define PORT_NONE  0xef
                       ^
>> drivers/gpu/drm/i915/display/intel_display.h:190:2: note: in expansion of macro 'PORT_NONE'
     PORT_NONE = -1,
     ^~~~~~~~~
   In file included from drivers/gpu/drm/i915/i915_drv.h:68:0,
                    from drivers/gpu/drm/i915/display/intel_display_types.h:46,
                    from drivers/gpu/drm/i915/i915_irq.c:39:
   drivers/gpu/drm/i915/display/intel_display.h: In function 'port_identifier':
>> drivers/gpu/drm/i915/display/intel_display.h:214:7: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
     case PORT_A:
          ^~~~~~
          PORT_DA
   drivers/gpu/drm/i915/display/intel_display.h:214:7: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/gpu/drm/i915/display/intel_display.h:216:7: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_A'?
     case PORT_B:
          ^~~~~~
          PORT_A
>> drivers/gpu/drm/i915/display/intel_display.h:218:7: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
     case PORT_C:
          ^~~~~~
          PORT_B
>> drivers/gpu/drm/i915/display/intel_display.h:220:7: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_C'?
     case PORT_D:
          ^~~~~~
          PORT_C
>> drivers/gpu/drm/i915/display/intel_display.h:222:7: error: 'PORT_E' undeclared (first use in this function); did you mean 'PORT_D'?
     case PORT_E:
          ^~~~~~
          PORT_D
>> drivers/gpu/drm/i915/display/intel_display.h:224:7: error: 'PORT_F' undeclared (first use in this function); did you mean 'PORT_E'?
     case PORT_F:
          ^~~~~~
          PORT_E
>> drivers/gpu/drm/i915/display/intel_display.h:226:7: error: 'PORT_G' undeclared (first use in this function); did you mean 'PORT_F'?
     case PORT_G:
          ^~~~~~
          PORT_F
>> drivers/gpu/drm/i915/display/intel_display.h:228:7: error: 'PORT_H' undeclared (first use in this function); did you mean 'PORT_G'?
     case PORT_H:
          ^~~~~~
          PORT_G
>> drivers/gpu/drm/i915/display/intel_display.h:230:7: error: 'PORT_I' undeclared (first use in this function); did you mean 'PORT_H'?
     case PORT_I:
          ^~~~~~
          PORT_H
   In file included from drivers/gpu/drm/i915/display/intel_display_types.h:46:0,
                    from drivers/gpu/drm/i915/i915_irq.c:39:
   drivers/gpu/drm/i915/i915_drv.h: At top level:
>> drivers/gpu/drm/i915/i915_drv.h:726:41: error: 'I915_MAX_PORTS' undeclared here (not in a function); did you mean 'I915_MAX_PHYS'?
     struct ddi_vbt_port_info ddi_port_info[I915_MAX_PORTS];
                                            ^~~~~~~~~~~~~~
                                            I915_MAX_PHYS
   In file included from drivers/gpu/drm/i915/i915_irq.c:39:0:
   drivers/gpu/drm/i915/display/intel_display_types.h: In function 'vlv_dport_to_channel':
>> drivers/gpu/drm/i915/display/intel_display_types.h:1386:7: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_BNC'?
     case PORT_B:
          ^~~~~~
          PORT_BNC
>> drivers/gpu/drm/i915/display/intel_display_types.h:1387:7: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_B'?
     case PORT_D:
          ^~~~~~
          PORT_B
>> drivers/gpu/drm/i915/display/intel_display_types.h:1389:7: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_D'?
     case PORT_C:
          ^~~~~~
          PORT_D
   drivers/gpu/drm/i915/display/intel_display_types.h: In function 'vlv_dport_to_phy':
   drivers/gpu/drm/i915/display/intel_display_types.h:1400:7: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_BNC'?
     case PORT_B:
          ^~~~~~
          PORT_BNC
>> drivers/gpu/drm/i915/display/intel_display_types.h:1401:7: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
     case PORT_C:
          ^~~~~~
          PORT_B
>> drivers/gpu/drm/i915/display/intel_display_types.h:1403:7: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_C'?
     case PORT_D:
          ^~~~~~
          PORT_C
   In file included from drivers/gpu/drm/i915/i915_drv.h:64:0,
                    from drivers/gpu/drm/i915/display/intel_display_types.h:46,
                    from drivers/gpu/drm/i915/i915_irq.c:39:
   drivers/gpu/drm/i915/i915_irq.c: At top level:
>> drivers/gpu/drm/i915/i915_irq.c:152:37: error: 'PORT_A' undeclared here (not in a function); did you mean 'PORT_DA'?
     [HPD_PORT_A] = SDE_DDI_HOTPLUG_ICP(PORT_A),
                                        ^
   drivers/gpu/drm/i915/i915_reg.h:8021:43: note: in definition of macro 'SDE_DDI_HOTPLUG_ICP'
    #define SDE_DDI_HOTPLUG_ICP(port) (1 << ((port) + 16))
                                              ^~~~
>> drivers/gpu/drm/i915/i915_irq.c:153:37: error: 'PORT_B' undeclared here (not in a function); did you mean 'PORT_A'?
     [HPD_PORT_B] = SDE_DDI_HOTPLUG_ICP(PORT_B),
                                        ^
   drivers/gpu/drm/i915/i915_reg.h:8021:43: note: in definition of macro 'SDE_DDI_HOTPLUG_ICP'
    #define SDE_DDI_HOTPLUG_ICP(port) (1 << ((port) + 16))
                                              ^~~~
>> drivers/gpu/drm/i915/i915_irq.c:163:37: error: 'PORT_C' undeclared here (not in a function); did you mean 'PORT_B'?
     [HPD_PORT_C] = SDE_DDI_HOTPLUG_ICP(PORT_C),
                                        ^
   drivers/gpu/drm/i915/i915_reg.h:8021:43: note: in definition of macro 'SDE_DDI_HOTPLUG_ICP'
    #define SDE_DDI_HOTPLUG_ICP(port) (1 << ((port) + 16))
                                              ^~~~
--
   In file included from include/linux/ethtool.h:18:0,
                    from include/linux/phy.h:16,
                    from include/linux/property.h:15,
                    from include/linux/of.h:22,
                    from include/linux/irqdomain.h:35,
                    from include/linux/acpi.h:13,
                    from include/linux/i2c.h:13,
                    from drivers/gpu/drm/i915/i915_drv.h:37,
                    from drivers/gpu/drm/i915/i915_getparam.c:8:
>> include/uapi/linux/ethtool.h:1668:20: error: expected identifier before numeric constant
    #define PORT_NONE  0xef
                       ^
>> drivers/gpu/drm/i915/display/intel_display.h:190:2: note: in expansion of macro 'PORT_NONE'
     PORT_NONE = -1,
     ^~~~~~~~~
   In file included from drivers/gpu/drm/i915/i915_drv.h:68:0,
                    from drivers/gpu/drm/i915/i915_getparam.c:8:
   drivers/gpu/drm/i915/display/intel_display.h: In function 'port_identifier':
>> drivers/gpu/drm/i915/display/intel_display.h:214:7: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
     case PORT_A:
          ^~~~~~
          PORT_DA
   drivers/gpu/drm/i915/display/intel_display.h:214:7: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/gpu/drm/i915/display/intel_display.h:216:7: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_A'?
     case PORT_B:
          ^~~~~~
          PORT_A
>> drivers/gpu/drm/i915/display/intel_display.h:218:7: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
     case PORT_C:
          ^~~~~~
          PORT_B
>> drivers/gpu/drm/i915/display/intel_display.h:220:7: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_C'?
     case PORT_D:
          ^~~~~~
          PORT_C
>> drivers/gpu/drm/i915/display/intel_display.h:222:7: error: 'PORT_E' undeclared (first use in this function); did you mean 'PORT_D'?
     case PORT_E:
          ^~~~~~
          PORT_D
>> drivers/gpu/drm/i915/display/intel_display.h:224:7: error: 'PORT_F' undeclared (first use in this function); did you mean 'PORT_E'?
     case PORT_F:
          ^~~~~~
          PORT_E
>> drivers/gpu/drm/i915/display/intel_display.h:226:7: error: 'PORT_G' undeclared (first use in this function); did you mean 'PORT_F'?
     case PORT_G:
          ^~~~~~
          PORT_F
>> drivers/gpu/drm/i915/display/intel_display.h:228:7: error: 'PORT_H' undeclared (first use in this function); did you mean 'PORT_G'?
     case PORT_H:
          ^~~~~~
          PORT_G
>> drivers/gpu/drm/i915/display/intel_display.h:230:7: error: 'PORT_I' undeclared (first use in this function); did you mean 'PORT_H'?
     case PORT_I:
          ^~~~~~
          PORT_H
   In file included from drivers/gpu/drm/i915/i915_getparam.c:8:0:
   drivers/gpu/drm/i915/i915_drv.h: At top level:
>> drivers/gpu/drm/i915/i915_drv.h:726:41: error: 'I915_MAX_PORTS' undeclared here (not in a function); did you mean 'I915_MAX_PHYS'?
     struct ddi_vbt_port_info ddi_port_info[I915_MAX_PORTS];
                                            ^~~~~~~~~~~~~~
                                            I915_MAX_PHYS
--
   In file included from include/linux/ethtool.h:18:0,
                    from include/linux/phy.h:16,
                    from include/linux/property.h:15,
                    from include/linux/of.h:22,
                    from include/linux/irqdomain.h:35,
                    from include/linux/acpi.h:13,
                    from include/linux/i2c.h:13,
                    from drivers/gpu/drm/i915/display/intel_display_types.h:30,
                    from drivers/gpu/drm/i915/display/intel_pipe_crc.c:33:
>> include/uapi/linux/ethtool.h:1668:20: error: expected identifier before numeric constant
    #define PORT_NONE  0xef
                       ^
>> drivers/gpu/drm/i915/display/intel_display.h:190:2: note: in expansion of macro 'PORT_NONE'
     PORT_NONE = -1,
     ^~~~~~~~~
   In file included from drivers/gpu/drm/i915/i915_drv.h:68:0,
                    from drivers/gpu/drm/i915/display/intel_display_types.h:46,
                    from drivers/gpu/drm/i915/display/intel_pipe_crc.c:33:
   drivers/gpu/drm/i915/display/intel_display.h: In function 'port_identifier':
>> drivers/gpu/drm/i915/display/intel_display.h:214:7: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
     case PORT_A:
          ^~~~~~
          PORT_DA
   drivers/gpu/drm/i915/display/intel_display.h:214:7: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/gpu/drm/i915/display/intel_display.h:216:7: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_A'?
     case PORT_B:
          ^~~~~~
          PORT_A
>> drivers/gpu/drm/i915/display/intel_display.h:218:7: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
     case PORT_C:
          ^~~~~~
          PORT_B
>> drivers/gpu/drm/i915/display/intel_display.h:220:7: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_C'?
     case PORT_D:
          ^~~~~~
          PORT_C
>> drivers/gpu/drm/i915/display/intel_display.h:222:7: error: 'PORT_E' undeclared (first use in this function); did you mean 'PORT_D'?
     case PORT_E:
          ^~~~~~
          PORT_D
>> drivers/gpu/drm/i915/display/intel_display.h:224:7: error: 'PORT_F' undeclared (first use in this function); did you mean 'PORT_E'?
     case PORT_F:
          ^~~~~~
          PORT_E
>> drivers/gpu/drm/i915/display/intel_display.h:226:7: error: 'PORT_G' undeclared (first use in this function); did you mean 'PORT_F'?
     case PORT_G:
          ^~~~~~
          PORT_F
>> drivers/gpu/drm/i915/display/intel_display.h:228:7: error: 'PORT_H' undeclared (first use in this function); did you mean 'PORT_G'?
     case PORT_H:
          ^~~~~~
          PORT_G
>> drivers/gpu/drm/i915/display/intel_display.h:230:7: error: 'PORT_I' undeclared (first use in this function); did you mean 'PORT_H'?
     case PORT_I:
          ^~~~~~
          PORT_H
   In file included from drivers/gpu/drm/i915/display/intel_display_types.h:46:0,
                    from drivers/gpu/drm/i915/display/intel_pipe_crc.c:33:
   drivers/gpu/drm/i915/i915_drv.h: At top level:
>> drivers/gpu/drm/i915/i915_drv.h:726:41: error: 'I915_MAX_PORTS' undeclared here (not in a function); did you mean 'I915_MAX_PHYS'?
     struct ddi_vbt_port_info ddi_port_info[I915_MAX_PORTS];
                                            ^~~~~~~~~~~~~~
                                            I915_MAX_PHYS
   In file included from drivers/gpu/drm/i915/display/intel_pipe_crc.c:33:0:
   drivers/gpu/drm/i915/display/intel_display_types.h: In function 'vlv_dport_to_channel':
>> drivers/gpu/drm/i915/display/intel_display_types.h:1386:7: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_BNC'?
     case PORT_B:
          ^~~~~~
          PORT_BNC
>> drivers/gpu/drm/i915/display/intel_display_types.h:1387:7: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_B'?
     case PORT_D:
          ^~~~~~
          PORT_B
>> drivers/gpu/drm/i915/display/intel_display_types.h:1389:7: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_D'?
     case PORT_C:
          ^~~~~~
          PORT_D
   drivers/gpu/drm/i915/display/intel_display_types.h: In function 'vlv_dport_to_phy':
   drivers/gpu/drm/i915/display/intel_display_types.h:1400:7: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_BNC'?
     case PORT_B:
          ^~~~~~
          PORT_BNC
>> drivers/gpu/drm/i915/display/intel_display_types.h:1401:7: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
     case PORT_C:
          ^~~~~~
          PORT_B
>> drivers/gpu/drm/i915/display/intel_display_types.h:1403:7: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_C'?
     case PORT_D:
          ^~~~~~
          PORT_C
   drivers/gpu/drm/i915/display/intel_pipe_crc.c: In function 'i9xx_pipe_crc_auto_source':
>> drivers/gpu/drm/i915/display/intel_pipe_crc.c:103:9: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_BNC'?
       case PORT_B:
            ^~~~~~
            PORT_BNC
>> drivers/gpu/drm/i915/display/intel_pipe_crc.c:106:9: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
       case PORT_C:
            ^~~~~~
            PORT_B
>> drivers/gpu/drm/i915/display/intel_pipe_crc.c:109:9: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_C'?
       case PORT_D:
            ^~~~~~
            PORT_C
..

vim +1668 include/uapi/linux/ethtool.h

103a8ad1fa3b26 Nikolay Aleksandrov 2016-02-03  1660  
607ca46e97a1b6 David Howells       2012-10-13  1661  /* Which connector port. */
607ca46e97a1b6 David Howells       2012-10-13  1662  #define PORT_TP			0x00
607ca46e97a1b6 David Howells       2012-10-13  1663  #define PORT_AUI		0x01
607ca46e97a1b6 David Howells       2012-10-13  1664  #define PORT_MII		0x02
607ca46e97a1b6 David Howells       2012-10-13  1665  #define PORT_FIBRE		0x03
607ca46e97a1b6 David Howells       2012-10-13  1666  #define PORT_BNC		0x04
607ca46e97a1b6 David Howells       2012-10-13  1667  #define PORT_DA			0x05
607ca46e97a1b6 David Howells       2012-10-13 @1668  #define PORT_NONE		0xef
607ca46e97a1b6 David Howells       2012-10-13  1669  #define PORT_OTHER		0xff
607ca46e97a1b6 David Howells       2012-10-13  1670  

:::::: The code at line 1668 was first introduced by commit
:::::: 607ca46e97a1b6594b29647d98a32d545c24bdff UAPI: (Scripted) Disintegrate include/linux

:::::: TO: David Howells <dhowells@redhat.com>
:::::: CC: David Howells <dhowells@redhat.com>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--5arorcrsjgvmibaf
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--5arorcrsjgvmibaf--

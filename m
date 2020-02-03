Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 498F9150098
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 03:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgBCCdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 21:33:21 -0500
Received: from mga03.intel.com ([134.134.136.65]:50930 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbgBCCdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Feb 2020 21:33:21 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Feb 2020 18:33:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,396,1574150400"; 
   d="gz'50?scan'50,208,50";a="230879824"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 02 Feb 2020 18:33:10 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iyRXy-0006Nm-0J; Mon, 03 Feb 2020 10:33:10 +0800
Date:   Mon, 3 Feb 2020 10:32:47 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Calvin Johnson <calvin.johnson@nxp.com>
Cc:     kbuild-all@lists.01.org, linux.cj@gmail.com,
        Jon Nettleton <jon@solid-run.com>, linux@armlinux.org.uk,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Matteo Croce <mcroce@redhat.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 4/7] device property: fwnode_get_phy_mode: Change API
 to solve int/unit warnings
Message-ID: <202002031009.jzjqMEFl%lkp@intel.com>
References: <20200131153440.20870-5-calvin.johnson@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xribu7jpgndisfrk"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200131153440.20870-5-calvin.johnson@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xribu7jpgndisfrk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Calvin,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on v5.5]
[cannot apply to driver-core/driver-core-testing net-next/master net/master linus/master sparc-next/master next-20200131]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Calvin-Johnson/ACPI-support-for-xgmac_mdio-and-dpaa2-mac-drivers/20200203-070754
base:    d5226fa6dbae0569ee43ecfc08bdcd6770fc4755
config: x86_64-defconfig (attached as .config)
compiler: gcc-7 (Debian 7.5.0-3) 7.5.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

Note: the linux-review/Calvin-Johnson/ACPI-support-for-xgmac_mdio-and-dpaa2-mac-drivers/20200203-070754 HEAD 90ffe7e2e45e6e2671084e1169a7bd16c6b3cc8d builds fine.
      It only hurts bisectibility.

All error/warnings (new ones prefixed by >>):

          ^~~~~~
          PORT_E
   drivers/gpu/drm/i915/display/intel_display.h:226:7: error: 'PORT_G' undeclared (first use in this function); did you mean 'PORT_F'?
     case PORT_G:
          ^~~~~~
          PORT_F
   drivers/gpu/drm/i915/display/intel_display.h:228:7: error: 'PORT_H' undeclared (first use in this function); did you mean 'PORT_G'?
     case PORT_H:
          ^~~~~~
          PORT_G
   drivers/gpu/drm/i915/display/intel_display.h:230:7: error: 'PORT_I' undeclared (first use in this function); did you mean 'PORT_H'?
     case PORT_I:
          ^~~~~~
          PORT_H
   In file included from drivers/gpu/drm/i915/display/intel_bios.c:34:0:
   drivers/gpu/drm/i915/i915_drv.h: At top level:
   drivers/gpu/drm/i915/i915_drv.h:730:41: error: 'I915_MAX_PORTS' undeclared here (not in a function); did you mean 'I915_MAX_PHYS'?
     struct ddi_vbt_port_info ddi_port_info[I915_MAX_PORTS];
                                            ^~~~~~~~~~~~~~
                                            I915_MAX_PHYS
   In file included from include/linux/bitops.h:5:0,
                    from include/linux/kernel.h:12,
                    from include/linux/delay.h:22,
                    from include/drm/drm_dp_helper.h:26,
                    from drivers/gpu/drm/i915/display/intel_bios.c:28:
   drivers/gpu/drm/i915/display/intel_bios.c: In function 'parse_dsi_backlight_ports':
   drivers/gpu/drm/i915/display/intel_bios.c:807:36: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
      dev_priv->vbt.dsi.bl_ports = BIT(PORT_A);
                                       ^
   include/linux/bits.h:8:30: note: in definition of macro 'BIT'
    #define BIT(nr)   (UL(1) << (nr))
                                 ^~
   drivers/gpu/drm/i915/display/intel_bios.c:810:36: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_A'?
      dev_priv->vbt.dsi.bl_ports = BIT(PORT_C);
                                       ^
   include/linux/bits.h:8:30: note: in definition of macro 'BIT'
    #define BIT(nr)   (UL(1) << (nr))
                                 ^~
   drivers/gpu/drm/i915/display/intel_bios.c: In function 'get_port_by_ddc_pin':
   drivers/gpu/drm/i915/display/intel_bios.c:1249:14: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
     for (port = PORT_A; port < I915_MAX_PORTS; port++) {
                 ^~~~~~
                 PORT_DA
   drivers/gpu/drm/i915/display/intel_bios.c: In function 'get_port_by_aux_ch':
   drivers/gpu/drm/i915/display/intel_bios.c:1300:14: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
     for (port = PORT_A; port < I915_MAX_PORTS; port++) {
                 ^~~~~~
                 PORT_DA
   drivers/gpu/drm/i915/display/intel_bios.c: In function 'dvo_port_to_port':
   drivers/gpu/drm/i915/display/intel_bios.c:1396:4: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
      [PORT_A] = { DVO_PORT_HDMIA, DVO_PORT_DPA, -1},
       ^~~~~~
       PORT_DA
   drivers/gpu/drm/i915/display/intel_bios.c:1396:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:1396:4: note: (near initialization for 'dvo_ports')
   drivers/gpu/drm/i915/display/intel_bios.c:1397:4: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_A'?
      [PORT_B] = { DVO_PORT_HDMIB, DVO_PORT_DPB, -1},
       ^~~~~~
       PORT_A
   drivers/gpu/drm/i915/display/intel_bios.c:1397:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:1397:4: note: (near initialization for 'dvo_ports')
   drivers/gpu/drm/i915/display/intel_bios.c:1398:4: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
      [PORT_C] = { DVO_PORT_HDMIC, DVO_PORT_DPC, -1},
       ^~~~~~
       PORT_B
   drivers/gpu/drm/i915/display/intel_bios.c:1398:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:1398:4: note: (near initialization for 'dvo_ports')
   drivers/gpu/drm/i915/display/intel_bios.c:1399:4: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_C'?
      [PORT_D] = { DVO_PORT_HDMID, DVO_PORT_DPD, -1},
       ^~~~~~
       PORT_C
   drivers/gpu/drm/i915/display/intel_bios.c:1399:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:1399:4: note: (near initialization for 'dvo_ports')
   drivers/gpu/drm/i915/display/intel_bios.c:1400:4: error: 'PORT_E' undeclared (first use in this function); did you mean 'PORT_D'?
      [PORT_E] = { DVO_PORT_CRT, DVO_PORT_HDMIE, DVO_PORT_DPE},
       ^~~~~~
       PORT_D
   drivers/gpu/drm/i915/display/intel_bios.c:1400:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:1400:4: note: (near initialization for 'dvo_ports')
   drivers/gpu/drm/i915/display/intel_bios.c:1401:4: error: 'PORT_F' undeclared (first use in this function); did you mean 'PORT_E'?
      [PORT_F] = { DVO_PORT_HDMIF, DVO_PORT_DPF, -1},
       ^~~~~~
       PORT_E
   drivers/gpu/drm/i915/display/intel_bios.c:1401:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:1401:4: note: (near initialization for 'dvo_ports')
   drivers/gpu/drm/i915/display/intel_bios.c:1402:4: error: 'PORT_G' undeclared (first use in this function); did you mean 'PORT_F'?
      [PORT_G] = { DVO_PORT_HDMIG, DVO_PORT_DPG, -1},
       ^~~~~~
       PORT_F
   drivers/gpu/drm/i915/display/intel_bios.c:1402:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:1402:4: note: (near initialization for 'dvo_ports')
   drivers/gpu/drm/i915/display/intel_bios.c: In function 'parse_ddi_port':
   drivers/gpu/drm/i915/display/intel_bios.c:1446:14: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
     if (port == PORT_A && is_dvi) {
                 ^~~~~~
                 PORT_DA
   drivers/gpu/drm/i915/display/intel_bios.c:1472:24: error: 'PORT_E' undeclared (first use in this function); did you mean 'PORT_A'?
     if (is_crt && port != PORT_E)
                           ^~~~~~
                           PORT_A
>> drivers/gpu/drm/i915/display/intel_bios.c:1482:25: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_E'?
     if (is_edp && (port == PORT_B || port == PORT_C || port == PORT_E))
                            ^~~~~~
                            PORT_E
   drivers/gpu/drm/i915/display/intel_bios.c:1482:43: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
     if (is_edp && (port == PORT_B || port == PORT_C || port == PORT_E))
                                              ^~~~~~
                                              PORT_B
   drivers/gpu/drm/i915/display/intel_bios.c: In function 'init_vbt_defaults':
   drivers/gpu/drm/i915/display/intel_bios.c:1725:14: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
     for (port = PORT_A; port < I915_MAX_PORTS; port++) {
                 ^~~~~~
                 PORT_DA
   drivers/gpu/drm/i915/display/intel_bios.c: In function 'init_vbt_missing_defaults':
   drivers/gpu/drm/i915/display/intel_bios.c:1739:14: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
     for (port = PORT_A; port < I915_MAX_PORTS; port++) {
                 ^~~~~~
                 PORT_DA
   drivers/gpu/drm/i915/display/intel_bios.c:1751:51: error: 'PORT_E' undeclared (first use in this function); did you mean 'PORT_A'?
      info->supports_dvi = (port != PORT_A && port != PORT_E);
                                                      ^~~~~~
                                                      PORT_A
   drivers/gpu/drm/i915/display/intel_bios.c: In function 'intel_bios_is_port_present':
   drivers/gpu/drm/i915/display/intel_bios.c:2027:4: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_BNC'?
      [PORT_B] = { DVO_PORT_DPB, DVO_PORT_HDMIB, },
       ^~~~~~
       PORT_BNC
   drivers/gpu/drm/i915/display/intel_bios.c:2027:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:2027:4: note: (near initialization for 'port_mapping')
   drivers/gpu/drm/i915/display/intel_bios.c:2028:4: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
      [PORT_C] = { DVO_PORT_DPC, DVO_PORT_HDMIC, },
       ^~~~~~
       PORT_B
   drivers/gpu/drm/i915/display/intel_bios.c:2028:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:2028:4: note: (near initialization for 'port_mapping')
   drivers/gpu/drm/i915/display/intel_bios.c:2029:4: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_C'?
      [PORT_D] = { DVO_PORT_DPD, DVO_PORT_HDMID, },
       ^~~~~~
       PORT_C
   drivers/gpu/drm/i915/display/intel_bios.c:2029:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:2029:4: note: (near initialization for 'port_mapping')
   drivers/gpu/drm/i915/display/intel_bios.c:2030:4: error: 'PORT_E' undeclared (first use in this function); did you mean 'PORT_D'?
      [PORT_E] = { DVO_PORT_DPE, DVO_PORT_HDMIE, },
       ^~~~~~
       PORT_D
   drivers/gpu/drm/i915/display/intel_bios.c:2030:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:2030:4: note: (near initialization for 'port_mapping')
   drivers/gpu/drm/i915/display/intel_bios.c:2031:4: error: 'PORT_F' undeclared (first use in this function); did you mean 'PORT_E'?
      [PORT_F] = { DVO_PORT_DPF, DVO_PORT_HDMIF, },
       ^~~~~~
       PORT_E
   drivers/gpu/drm/i915/display/intel_bios.c:2031:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:2031:4: note: (near initialization for 'port_mapping')
   In file included from arch/x86/include/asm/bug.h:83:0,
                    from include/linux/bug.h:5,
                    from include/linux/cpumask.h:14,
                    from arch/x86/include/asm/cpumask.h:5,
                    from arch/x86/include/asm/msr.h:11,
                    from arch/x86/include/asm/processor.h:22,
                    from include/linux/mutex.h:19,
                    from include/linux/kernfs.h:12,
                    from include/linux/sysfs.h:16,
                    from include/linux/kobject.h:20,
                    from include/linux/of.h:17,
                    from include/linux/irqdomain.h:35,
                    from include/linux/acpi.h:13,
                    from include/linux/i2c.h:13,
                    from include/drm/drm_dp_helper.h:27,
                    from drivers/gpu/drm/i915/display/intel_bios.c:28:
   drivers/gpu/drm/i915/display/intel_bios.c:2045:22: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_F'?
     if (WARN_ON(port == PORT_A) || port >= ARRAY_SIZE(port_mapping))
                         ^
   include/asm-generic/bug.h:122:25: note: in definition of macro 'WARN'
     int __ret_warn_on = !!(condition);    \
                            ^~~~~~~~~
   drivers/gpu/drm/i915/display/intel_bios.c:2045:6: note: in expansion of macro 'WARN_ON'
     if (WARN_ON(port == PORT_A) || port >= ARRAY_SIZE(port_mapping))
         ^~~~~~~
   drivers/gpu/drm/i915/display/intel_bios.c: In function 'intel_bios_is_port_edp':
   drivers/gpu/drm/i915/display/intel_bios.c:2075:4: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_BNC'?
      [PORT_B] = DVO_PORT_DPB,
       ^~~~~~
       PORT_BNC
   drivers/gpu/drm/i915/display/intel_bios.c:2075:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:2075:4: note: (near initialization for 'port_mapping')
   drivers/gpu/drm/i915/display/intel_bios.c:2076:4: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
      [PORT_C] = DVO_PORT_DPC,
       ^~~~~~
       PORT_B
   drivers/gpu/drm/i915/display/intel_bios.c:2076:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:2076:4: note: (near initialization for 'port_mapping')
   drivers/gpu/drm/i915/display/intel_bios.c:2077:4: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_C'?
      [PORT_D] = DVO_PORT_DPD,
       ^~~~~~
       PORT_C
   drivers/gpu/drm/i915/display/intel_bios.c:2077:4: error: array index in initializer not of integer type
   drivers/gpu/drm/i915/display/intel_bios.c:2077:4: note: (near initialization for 'port_mapping')
   drivers/gpu/drm/i915/display/intel_bios.c:2078:4: error: 'PORT_E' undeclared (first use in this function); did you mean 'PORT_D'?
      [PORT_E] = DVO_PORT_DPE,
       ^~~~~~
       PORT_D
--
   drivers/gpu/drm/i915/display/intel_display.c: In function 'intel_port_to_phy':
   drivers/gpu/drm/i915/display/intel_display.c:6803:38: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_DA'?
     if (IS_ELKHARTLAKE(i915) && port == PORT_D)
                                         ^~~~~~
                                         PORT_DA
   drivers/gpu/drm/i915/display/intel_display.c: In function 'intel_port_to_tc':
   drivers/gpu/drm/i915/display/intel_display.c:6815:17: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_DA'?
      return port - PORT_D;
                    ^~~~~~
                    PORT_DA
   drivers/gpu/drm/i915/display/intel_display.c:6817:16: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_D'?
     return port - PORT_C;
                   ^~~~~~
                   PORT_D
   drivers/gpu/drm/i915/display/intel_display.c: In function 'intel_port_to_power_domain':
   drivers/gpu/drm/i915/display/intel_display.c:6823:7: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
     case PORT_A:
          ^~~~~~
          PORT_DA
   drivers/gpu/drm/i915/display/intel_display.c:6825:7: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_A'?
     case PORT_B:
          ^~~~~~
          PORT_A
   drivers/gpu/drm/i915/display/intel_display.c:6827:7: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
     case PORT_C:
          ^~~~~~
          PORT_B
   drivers/gpu/drm/i915/display/intel_display.c:6829:7: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_C'?
     case PORT_D:
          ^~~~~~
          PORT_C
   drivers/gpu/drm/i915/display/intel_display.c:6831:7: error: 'PORT_E' undeclared (first use in this function); did you mean 'PORT_D'?
     case PORT_E:
          ^~~~~~
          PORT_D
   drivers/gpu/drm/i915/display/intel_display.c:6833:7: error: 'PORT_F' undeclared (first use in this function); did you mean 'PORT_E'?
     case PORT_F:
          ^~~~~~
          PORT_E
   drivers/gpu/drm/i915/display/intel_display.c:6835:7: error: 'PORT_G' undeclared (first use in this function); did you mean 'PORT_F'?
     case PORT_G:
          ^~~~~~
          PORT_F
   drivers/gpu/drm/i915/display/intel_display.c: In function 'ironlake_init_pch_refclk':
   drivers/gpu/drm/i915/display/intel_display.c:9020:25: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
       if (encoder->port == PORT_A)
                            ^~~~~~
                            PORT_DA
   In file included from drivers/gpu/drm/i915/display/intel_crt.h:9:0,
                    from drivers/gpu/drm/i915/display/intel_display.c:46:
   drivers/gpu/drm/i915/display/intel_display.c: In function 'cannonlake_get_ddi_pll':
   drivers/gpu/drm/i915/i915_reg.h:10005:59: error: 'PORT_F' undeclared (first use in this function); did you mean 'PORT_DA'?
    #define  DPCLKA_CFGCR0_DDI_CLK_SEL_SHIFT(port) ((port) == PORT_F ? 21 : \
                                                              ^
   drivers/gpu/drm/i915/i915_reg.h:10007:53: note: in expansion of macro 'DPCLKA_CFGCR0_DDI_CLK_SEL_SHIFT'
    #define  DPCLKA_CFGCR0_DDI_CLK_SEL_MASK(port) (3 << DPCLKA_CFGCR0_DDI_CLK_SEL_SHIFT(port))
                                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/gpu/drm/i915/display/intel_display.c:10217:36: note: in expansion of macro 'DPCLKA_CFGCR0_DDI_CLK_SEL_MASK'
     temp = I915_READ(DPCLKA_CFGCR0) & DPCLKA_CFGCR0_DDI_CLK_SEL_MASK(port);
                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/gpu/drm/i915/display/intel_display.c: In function 'bxt_get_ddi_pll':
   drivers/gpu/drm/i915/display/intel_display.c:10270:7: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
     case PORT_A:
          ^~~~~~
          PORT_DA
   drivers/gpu/drm/i915/display/intel_display.c:10273:7: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_A'?
     case PORT_B:
          ^~~~~~
          PORT_A
   drivers/gpu/drm/i915/display/intel_display.c:10276:7: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
     case PORT_C:
          ^~~~~~
          PORT_B
   In file included from drivers/gpu/drm/i915/display/intel_ddi.h:11:0,
                    from drivers/gpu/drm/i915/display/intel_display.c:47:
   drivers/gpu/drm/i915/display/intel_display.c: In function 'bxt_get_dsi_transcoder_state':
   drivers/gpu/drm/i915/display/intel_display.h:336:18: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
     for ((__port) = PORT_A; (__port) < I915_MAX_PORTS; (__port)++) \
                     ^
   drivers/gpu/drm/i915/display/intel_display.c:10448:2: note: in expansion of macro 'for_each_port_masked'
     for_each_port_masked(port, BIT(PORT_A) | BIT(PORT_C)) {
     ^~~~~~~~~~~~~~~~~~~~
   In file included from include/drm/drm_connector.h:31:0,
                    from include/drm/drm_modes.h:33,
                    from include/drm/drm_crtc.h:40,
                    from include/drm/drm_atomic.h:31,
                    from drivers/gpu/drm/i915/display/intel_display.c:35:
   drivers/gpu/drm/i915/display/intel_display.c:10448:47: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_A'?
     for_each_port_masked(port, BIT(PORT_A) | BIT(PORT_C)) {
                                                  ^
   include/drm/drm_util.h:63:38: note: in definition of macro 'for_each_if'
    #define for_each_if(condition) if (!(condition)) {} else
                                         ^~~~~~~~~
   drivers/gpu/drm/i915/display/intel_display.c:10448:2: note: in expansion of macro 'for_each_port_masked'
     for_each_port_masked(port, BIT(PORT_A) | BIT(PORT_C)) {
     ^~~~~~~~~~~~~~~~~~~~
   drivers/gpu/drm/i915/display/intel_display.c:10448:43: note: in expansion of macro 'BIT'
     for_each_port_masked(port, BIT(PORT_A) | BIT(PORT_C)) {
                                              ^~~
   drivers/gpu/drm/i915/display/intel_display.c: In function 'haswell_get_ddi_port_state':
>> drivers/gpu/drm/i915/display/intel_display.c:10528:15: error: 'PORT_E' undeclared (first use in this function); did you mean 'PORT_DA'?
         (port == PORT_E) && I915_READ(LPT_TRANSCONF) & TRANS_ENABLE) {
                  ^~~~~~
                  PORT_DA
   In file included from drivers/gpu/drm/i915/display/intel_display_types.h:46:0,
                    from drivers/gpu/drm/i915/display/intel_dsi.h:30,
                    from drivers/gpu/drm/i915/display/intel_display.c:49:
   drivers/gpu/drm/i915/display/intel_display.c: In function 'intel_ddi_crt_present':
   drivers/gpu/drm/i915/display/intel_display.c:15884:28: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
     if (I915_READ(DDI_BUF_CTL(PORT_A)) & DDI_A_4_LANES)
                               ^
   drivers/gpu/drm/i915/i915_drv.h:1981:45: note: in definition of macro '__I915_REG_OP'
     intel_uncore_##op__(&(dev_priv__)->uncore, __VA_ARGS__)
                                                ^~~~~~~~~~~
   drivers/gpu/drm/i915/display/intel_display.c:15884:6: note: in expansion of macro 'I915_READ'
     if (I915_READ(DDI_BUF_CTL(PORT_A)) & DDI_A_4_LANES)
         ^~~~~~~~~
   drivers/gpu/drm/i915/i915_reg.h:237:33: note: in expansion of macro '_MMIO'
    #define _MMIO_PORT(port, a, b)  _MMIO(_PORT(port, a, b))
                                    ^~~~~
   drivers/gpu/drm/i915/i915_reg.h:231:28: note: in expansion of macro '_PICK_EVEN'
    #define _PORT(port, a, b)  _PICK_EVEN(port, a, b)
                               ^~~~~~~~~~
   drivers/gpu/drm/i915/i915_reg.h:237:39: note: in expansion of macro '_PORT'
    #define _MMIO_PORT(port, a, b)  _MMIO(_PORT(port, a, b))
                                          ^~~~~
   drivers/gpu/drm/i915/i915_reg.h:9745:27: note: in expansion of macro '_MMIO_PORT'
    #define DDI_BUF_CTL(port) _MMIO_PORT(port, _DDI_BUF_CTL_A, _DDI_BUF_CTL_B)
                              ^~~~~~~~~~
   drivers/gpu/drm/i915/display/intel_display.c:15884:16: note: in expansion of macro 'DDI_BUF_CTL'
     if (I915_READ(DDI_BUF_CTL(PORT_A)) & DDI_A_4_LANES)
                   ^~~~~~~~~~~
   drivers/gpu/drm/i915/display/intel_display.c: In function 'intel_setup_outputs':
   drivers/gpu/drm/i915/display/intel_display.c:15940:28: error: 'PORT_A' undeclared (first use in this function); did you mean 'PORT_DA'?
      intel_ddi_init(dev_priv, PORT_A);
                               ^~~~~~
                               PORT_DA
   drivers/gpu/drm/i915/display/intel_display.c:15941:28: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_A'?
      intel_ddi_init(dev_priv, PORT_B);
                               ^~~~~~
                               PORT_A
   drivers/gpu/drm/i915/display/intel_display.c:15942:28: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_B'?
      intel_ddi_init(dev_priv, PORT_D);
                               ^~~~~~
                               PORT_B
   drivers/gpu/drm/i915/display/intel_display.c:15943:28: error: 'PORT_E' undeclared (first use in this function); did you mean 'PORT_D'?
      intel_ddi_init(dev_priv, PORT_E);
                               ^~~~~~
                               PORT_D
   drivers/gpu/drm/i915/display/intel_display.c:15944:28: error: 'PORT_F' undeclared (first use in this function); did you mean 'PORT_E'?
      intel_ddi_init(dev_priv, PORT_F);
                               ^~~~~~
                               PORT_E
   drivers/gpu/drm/i915/display/intel_display.c:15945:28: error: 'PORT_G' undeclared (first use in this function); did you mean 'PORT_F'?
      intel_ddi_init(dev_priv, PORT_G);
                               ^~~~~~
                               PORT_F
   drivers/gpu/drm/i915/display/intel_display.c:15946:28: error: 'PORT_H' undeclared (first use in this function); did you mean 'PORT_G'?
      intel_ddi_init(dev_priv, PORT_H);
                               ^~~~~~
                               PORT_G
   drivers/gpu/drm/i915/display/intel_display.c:15947:28: error: 'PORT_I' undeclared (first use in this function); did you mean 'PORT_H'?
      intel_ddi_init(dev_priv, PORT_I);
                               ^~~~~~
                               PORT_H
   drivers/gpu/drm/i915/display/intel_display.c:15952:28: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_I'?
      intel_ddi_init(dev_priv, PORT_C);
                               ^~~~~~
                               PORT_I
   drivers/gpu/drm/i915/display/intel_display.c: In function 'ibx_sanitize_pch_ports':
   drivers/gpu/drm/i915/display/intel_display.c:17557:37: error: 'PORT_B' undeclared (first use in this function); did you mean 'PORT_BNC'?
     ibx_sanitize_pch_dp_port(dev_priv, PORT_B, PCH_DP_B);
                                        ^~~~~~
                                        PORT_BNC
   drivers/gpu/drm/i915/display/intel_display.c:17558:37: error: 'PORT_C' undeclared (first use in this function); did you mean 'PORT_B'?
     ibx_sanitize_pch_dp_port(dev_priv, PORT_C, PCH_DP_C);
                                        ^~~~~~
                                        PORT_B
   drivers/gpu/drm/i915/display/intel_display.c:17559:37: error: 'PORT_D' undeclared (first use in this function); did you mean 'PORT_C'?
     ibx_sanitize_pch_dp_port(dev_priv, PORT_D, PCH_DP_D);
                                        ^~~~~~
                                        PORT_C
   drivers/gpu/drm/i915/display/intel_display.c: In function 'intel_port_to_tc':
   drivers/gpu/drm/i915/display/intel_display.c:6818:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^
..

vim +1482 drivers/gpu/drm/i915/display/intel_bios.c

b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1419  
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1420  static void parse_ddi_port(struct drm_i915_private *dev_priv,
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1421  			   const struct child_device_config *child,
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1422  			   u8 bdb_version)
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1423  {
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1424  	struct ddi_vbt_port_info *info;
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1425  	bool is_dvi, is_hdmi, is_dp, is_edp, is_crt;
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1426  	enum port port;
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1427  
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1428  	port = dvo_port_to_port(child->dvo_port);
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1429  	if (port == PORT_NONE)
6acab15a7b0d27 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1430  		return;
6acab15a7b0d27 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1431  
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1432  	info = &dev_priv->vbt.ddi_port_info[port];
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1433  
7679f9b8f6ee39 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-05-31  1434  	if (info->child) {
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1435  		DRM_DEBUG_KMS("More than one child device for port %c in VBT, using the first.\n",
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1436  			      port_name(port));
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1437  		return;
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1438  	}
b024ab9b2d3aa1 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-03-22  1439  
cc9985893aacc3 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-08-24  1440  	is_dvi = child->device_type & DEVICE_TYPE_TMDS_DVI_SIGNALING;
cc9985893aacc3 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-08-24  1441  	is_dp = child->device_type & DEVICE_TYPE_DISPLAYPORT_OUTPUT;
cc9985893aacc3 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-08-24  1442  	is_crt = child->device_type & DEVICE_TYPE_ANALOG_OUTPUT;
cc9985893aacc3 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-08-24  1443  	is_hdmi = is_dvi && (child->device_type & DEVICE_TYPE_NOT_HDMI_OUTPUT) == 0;
cc9985893aacc3 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-08-24  1444  	is_edp = is_dp && (child->device_type & DEVICE_TYPE_INTERNAL_CONNECTOR);
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1445  
2ba7d7e0437127 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-09-21 @1446  	if (port == PORT_A && is_dvi) {
2ba7d7e0437127 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-09-21  1447  		DRM_DEBUG_KMS("VBT claims port A supports DVI%s, ignoring\n",
2ba7d7e0437127 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-09-21  1448  			      is_hdmi ? "/HDMI" : "");
2ba7d7e0437127 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-09-21  1449  		is_dvi = false;
2ba7d7e0437127 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-09-21  1450  		is_hdmi = false;
2ba7d7e0437127 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-09-21  1451  	}
2ba7d7e0437127 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-09-21  1452  
311a20949f047a drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1453  	info->supports_dvi = is_dvi;
311a20949f047a drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1454  	info->supports_hdmi = is_hdmi;
311a20949f047a drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1455  	info->supports_dp = is_dp;
a98d9c1d7e9bb0 drivers/gpu/drm/i915/intel_bios.c Imre Deak      2016-12-21  1456  	info->supports_edp = is_edp;
311a20949f047a drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1457  
38b3416f3c2f1d drivers/gpu/drm/i915/intel_bios.c Imre Deak      2018-12-14  1458  	if (bdb_version >= 195)
38b3416f3c2f1d drivers/gpu/drm/i915/intel_bios.c Imre Deak      2018-12-14  1459  		info->supports_typec_usb = child->dp_usb_type_c;
38b3416f3c2f1d drivers/gpu/drm/i915/intel_bios.c Imre Deak      2018-12-14  1460  
38b3416f3c2f1d drivers/gpu/drm/i915/intel_bios.c Imre Deak      2018-12-14  1461  	if (bdb_version >= 209)
38b3416f3c2f1d drivers/gpu/drm/i915/intel_bios.c Imre Deak      2018-12-14  1462  		info->supports_tbt = child->tbt;
38b3416f3c2f1d drivers/gpu/drm/i915/intel_bios.c Imre Deak      2018-12-14  1463  
932cd15431567c drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-05-31  1464  	DRM_DEBUG_KMS("Port %c VBT info: CRT:%d DVI:%d HDMI:%d DP:%d eDP:%d LSPCON:%d USB-Type-C:%d TBT:%d\n",
932cd15431567c drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-05-31  1465  		      port_name(port), is_crt, is_dvi, is_hdmi, is_dp, is_edp,
932cd15431567c drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-05-31  1466  		      HAS_LSPCON(dev_priv) && child->lspcon,
38b3416f3c2f1d drivers/gpu/drm/i915/intel_bios.c Imre Deak      2018-12-14  1467  		      info->supports_typec_usb, info->supports_tbt);
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1468  
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1469  	if (is_edp && is_dvi)
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1470  		DRM_DEBUG_KMS("Internal DP port %c is TMDS compatible\n",
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1471  			      port_name(port));
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1472  	if (is_crt && port != PORT_E)
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1473  		DRM_DEBUG_KMS("Port %c is analog\n", port_name(port));
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1474  	if (is_crt && (is_dvi || is_dp))
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1475  		DRM_DEBUG_KMS("Analog port %c is also DP or TMDS compatible\n",
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1476  			      port_name(port));
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1477  	if (is_dvi && (port == PORT_A || port == PORT_E))
9b13494c916dc0 drivers/gpu/drm/i915/intel_bios.c Masanari Iida  2014-08-06  1478  		DRM_DEBUG_KMS("Port %c is TMDS compatible\n", port_name(port));
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1479  	if (!is_dvi && !is_dp && !is_crt)
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1480  		DRM_DEBUG_KMS("Port %c is not DP/TMDS/CRT compatible\n",
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1481  			      port_name(port));
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12 @1482  	if (is_edp && (port == PORT_B || port == PORT_C || port == PORT_E))
554d6af50a4012 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1483  		DRM_DEBUG_KMS("Port %c is internal DP\n", port_name(port));
6bf19e7c548d46 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1484  
6bf19e7c548d46 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1485  	if (is_dvi) {
e53a1058395435 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-04-11  1486  		u8 ddc_pin;
e53a1058395435 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-04-11  1487  
f212bf9abe5de9 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-04-11  1488  		ddc_pin = map_ddc_pin(dev_priv, child->ddc_pin);
f212bf9abe5de9 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-04-11  1489  		if (intel_gmbus_is_valid_pin(dev_priv, ddc_pin)) {
f212bf9abe5de9 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-04-11  1490  			info->alternate_ddc_pin = ddc_pin;
9454fa871edf15 drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2016-10-11  1491  			sanitize_ddc_pin(dev_priv, port);
f212bf9abe5de9 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-04-11  1492  		} else {
f212bf9abe5de9 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-04-11  1493  			DRM_DEBUG_KMS("Port %c has invalid DDC pin %d, "
f212bf9abe5de9 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-04-11  1494  				      "sticking to defaults\n",
f212bf9abe5de9 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-04-11  1495  				      port_name(port), ddc_pin);
f212bf9abe5de9 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-04-11  1496  		}
6bf19e7c548d46 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1497  	}
6bf19e7c548d46 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1498  
6bf19e7c548d46 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1499  	if (is_dp) {
e53a1058395435 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-04-11  1500  		info->alternate_aux_channel = child->aux_channel;
9454fa871edf15 drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2016-10-11  1501  
9454fa871edf15 drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2016-10-11  1502  		sanitize_aux_ch(dev_priv, port);
6bf19e7c548d46 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1503  	}
6bf19e7c548d46 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1504  
0ead5f81d4200b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-09-28  1505  	if (bdb_version >= 158) {
6acab15a7b0d27 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1506  		/* The VBT HDMI level shift values match the table we have. */
e53a1058395435 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-04-11  1507  		u8 hdmi_level_shift = child->hdmi_level_shifter_value;
6acab15a7b0d27 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1508  		DRM_DEBUG_KMS("VBT HDMI level shift for port %c: %d\n",
6acab15a7b0d27 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1509  			      port_name(port),
6acab15a7b0d27 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1510  			      hdmi_level_shift);
6acab15a7b0d27 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1511  		info->hdmi_level_shift = hdmi_level_shift;
6acab15a7b0d27 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1512  	}
75067ddecf2127 drivers/gpu/drm/i915/intel_bios.c Antti Koskipaa 2015-07-10  1513  
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1514  	if (bdb_version >= 204) {
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1515  		int max_tmds_clock;
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1516  
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1517  		switch (child->hdmi_max_data_rate) {
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1518  		default:
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1519  			MISSING_CASE(child->hdmi_max_data_rate);
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1520  			/* fall through */
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1521  		case HDMI_MAX_DATA_RATE_PLATFORM:
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1522  			max_tmds_clock = 0;
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1523  			break;
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1524  		case HDMI_MAX_DATA_RATE_297:
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1525  			max_tmds_clock = 297000;
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1526  			break;
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1527  		case HDMI_MAX_DATA_RATE_165:
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1528  			max_tmds_clock = 165000;
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1529  			break;
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1530  		}
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1531  
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1532  		if (max_tmds_clock)
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1533  			DRM_DEBUG_KMS("VBT HDMI max TMDS clock for port %c: %d kHz\n",
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1534  				      port_name(port), max_tmds_clock);
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1535  		info->max_tmds_clock = max_tmds_clock;
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1536  	}
d6038611aa3d7d drivers/gpu/drm/i915/intel_bios.c Ville Syrjälä  2017-10-30  1537  
75067ddecf2127 drivers/gpu/drm/i915/intel_bios.c Antti Koskipaa 2015-07-10  1538  	/* Parse the I_boost config for SKL and above */
0ead5f81d4200b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-09-28  1539  	if (bdb_version >= 196 && child->iboost) {
f22bb35856ba1e drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-08-25  1540  		info->dp_boost_level = translate_iboost(child->dp_iboost_level);
75067ddecf2127 drivers/gpu/drm/i915/intel_bios.c Antti Koskipaa 2015-07-10  1541  		DRM_DEBUG_KMS("VBT (e)DP boost level for port %c: %d\n",
75067ddecf2127 drivers/gpu/drm/i915/intel_bios.c Antti Koskipaa 2015-07-10  1542  			      port_name(port), info->dp_boost_level);
f22bb35856ba1e drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2017-08-25  1543  		info->hdmi_boost_level = translate_iboost(child->hdmi_iboost_level);
75067ddecf2127 drivers/gpu/drm/i915/intel_bios.c Antti Koskipaa 2015-07-10  1544  		DRM_DEBUG_KMS("VBT HDMI boost level for port %c: %d\n",
75067ddecf2127 drivers/gpu/drm/i915/intel_bios.c Antti Koskipaa 2015-07-10  1545  			      port_name(port), info->hdmi_boost_level);
75067ddecf2127 drivers/gpu/drm/i915/intel_bios.c Antti Koskipaa 2015-07-10  1546  	}
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1547  
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1548  	/* DP max link rate for CNL+ */
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1549  	if (bdb_version >= 216) {
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1550  		switch (child->dp_max_link_rate) {
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1551  		default:
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1552  		case VBT_DP_MAX_LINK_RATE_HBR3:
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1553  			info->dp_max_link_rate = 810000;
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1554  			break;
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1555  		case VBT_DP_MAX_LINK_RATE_HBR2:
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1556  			info->dp_max_link_rate = 540000;
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1557  			break;
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1558  		case VBT_DP_MAX_LINK_RATE_HBR:
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1559  			info->dp_max_link_rate = 270000;
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1560  			break;
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1561  		case VBT_DP_MAX_LINK_RATE_LBR:
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1562  			info->dp_max_link_rate = 162000;
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1563  			break;
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1564  		}
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1565  		DRM_DEBUG_KMS("VBT DP max link rate for port %c: %d\n",
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1566  			      port_name(port), info->dp_max_link_rate);
99b91bda84060b drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2018-02-01  1567  	}
7679f9b8f6ee39 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-05-31  1568  
7679f9b8f6ee39 drivers/gpu/drm/i915/intel_bios.c Jani Nikula    2019-05-31  1569  	info->child = child;
6acab15a7b0d27 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1570  }
6acab15a7b0d27 drivers/gpu/drm/i915/intel_bios.c Paulo Zanoni   2013-09-12  1571  

:::::: The code at line 1482 was first introduced by commit
:::::: 554d6af50a40125c28e4e1035527a684d2607266 drm/i915: add some assertions about VBT DDI port types

:::::: TO: Paulo Zanoni <paulo.r.zanoni@intel.com>
:::::: CC: Daniel Vetter <daniel.vetter@ffwll.ch>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--xribu7jpgndisfrk
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--xribu7jpgndisfrk--

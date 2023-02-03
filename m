Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B45688D23
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 03:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjBCCiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 21:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBCCiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 21:38:19 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85976D5C7;
        Thu,  2 Feb 2023 18:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675391897; x=1706927897;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LeIg3sS9Sk/YKoZDPmvBD6+Ro7uz4Jou7ZE/kE//F1c=;
  b=cGJfBNJdg8f585WZXSGlL39yiLRK+CKeK2WwY+GdxkXVlu0iY3dFBY6S
   M0Jcu5MVJsoqh0Tsmf32V8S9l/8OrO9qNc/GzTRFq4Rqw55R9zDLxNudf
   uwvKNxBQtqnfHB7/ZFXyNinRWGWpqfItXL9uN/j5xypbWGocxWJH/D5Re
   ZkEGuaF6S4D56bO5o5wSNTa0q0sFofk/p/31b9wlTIfwWvs37RoTysrd4
   0NXEMikvOvecmXqRe5+mhM3VnxQe9OeFYuQRsoCUnDMO099Kv7S5JrpoN
   hEkBo/7vcZVYAlg0BXS1gOsfFDLLS6B7S2Q2y/deerwn+7y7jFFK8zqlQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="312291279"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="312291279"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 18:38:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="643113785"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="643113785"
Received: from lkp-server01.sh.intel.com (HELO 0572c01a5cf9) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 02 Feb 2023 18:38:14 -0800
Received: from kbuild by 0572c01a5cf9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNlxt-00002p-1V;
        Fri, 03 Feb 2023 02:38:13 +0000
Date:   Fri, 3 Feb 2023 10:37:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: Re: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <202302031027.lyf8KjKA-lkp@intel.com>
References: <20230202111423.56831-3-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202111423.56831-3-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230202-191843
patch link:    https://lore.kernel.org/r/20230202111423.56831-3-alejandro.lucero-palau%40amd.com
patch subject: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
config: microblaze-randconfig-s042-20230202 (https://download.01.org/0day-ci/archive/20230203/202302031027.lyf8KjKA-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/ae013a0522dccc6ec3db361d23a5cbf2e1de2702
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230202-191843
        git checkout ae013a0522dccc6ec3db361d23a5cbf2e1de2702
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=microblaze olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=microblaze SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   microblaze-linux-ld: drivers/net/ethernet/sfc/efx_devlink.o: in function `efx_devlink_info_running_v2.constprop.0':
>> drivers/net/ethernet/sfc/efx_devlink.c:157: undefined reference to `rtc_time64_to_tm'
>> microblaze-linux-ld: drivers/net/ethernet/sfc/efx_devlink.c:186: undefined reference to `rtc_time64_to_tm'


vim +157 drivers/net/ethernet/sfc/efx_devlink.c

    86	
    87	#define EFX_VER_FLAG(_f)	\
    88		(MC_CMD_GET_VERSION_V5_OUT_ ## _f ## _PRESENT_LBN)
    89	
    90	static void efx_devlink_info_running_v2(struct efx_nic *efx,
    91						struct devlink_info_req *req,
    92						unsigned int flags, efx_dword_t *outbuf)
    93	{
    94		char buf[EFX_MAX_VERSION_INFO_LEN];
    95		union {
    96			const __le32 *dwords;
    97			const __le16 *words;
    98			const char *str;
    99		} ver;
   100		struct rtc_time build_date;
   101		unsigned int build_id;
   102		size_t offset;
   103		u64 tstamp;
   104	
   105		if (flags & BIT(EFX_VER_FLAG(BOARD_EXT_INFO))) {
   106			snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%s",
   107				 MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_NAME));
   108			devlink_info_version_fixed_put(req,
   109						       DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
   110						       buf);
   111	
   112			/* Favour full board version if present (in V5 or later) */
   113			if (~flags & BIT(EFX_VER_FLAG(BOARD_VERSION))) {
   114				snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u",
   115					 MCDI_DWORD(outbuf,
   116						    GET_VERSION_V2_OUT_BOARD_REVISION));
   117				devlink_info_version_fixed_put(req,
   118							       DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
   119							       buf);
   120			}
   121	
   122			ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_SERIAL);
   123			if (ver.str[0])
   124				devlink_info_board_serial_number_put(req, ver.str);
   125		}
   126	
   127		if (flags & BIT(EFX_VER_FLAG(FPGA_EXT_INFO))) {
   128			ver.dwords = (__le32 *)MCDI_PTR(outbuf,
   129							GET_VERSION_V2_OUT_FPGA_VERSION);
   130			offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u_%c%u",
   131					  le32_to_cpu(ver.dwords[0]),
   132					  'A' + le32_to_cpu(ver.dwords[1]),
   133					  le32_to_cpu(ver.dwords[2]));
   134	
   135			ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_FPGA_EXTRA);
   136			if (ver.str[0])
   137				snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
   138					 " (%s)", ver.str);
   139	
   140			devlink_info_version_running_put(req,
   141							 EFX_DEVLINK_INFO_VERSION_FPGA_REV,
   142							 buf);
   143		}
   144	
   145		if (flags & BIT(EFX_VER_FLAG(CMC_EXT_INFO))) {
   146			ver.dwords = (__le32 *)MCDI_PTR(outbuf,
   147							GET_VERSION_V2_OUT_CMCFW_VERSION);
   148			offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
   149					  le32_to_cpu(ver.dwords[0]),
   150					  le32_to_cpu(ver.dwords[1]),
   151					  le32_to_cpu(ver.dwords[2]),
   152					  le32_to_cpu(ver.dwords[3]));
   153	
   154			tstamp = MCDI_QWORD(outbuf,
   155					    GET_VERSION_V2_OUT_CMCFW_BUILD_DATE);
   156			if (tstamp) {
 > 157				rtc_time64_to_tm(tstamp, &build_date);
   158				snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
   159					 " (%ptRd)", &build_date);
   160			}
   161	
   162			devlink_info_version_running_put(req,
   163							 EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC,
   164							 buf);
   165		}
   166	
   167		ver.words = (__le16 *)MCDI_PTR(outbuf, GET_VERSION_V2_OUT_VERSION);
   168		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
   169				  le16_to_cpu(ver.words[0]), le16_to_cpu(ver.words[1]),
   170				  le16_to_cpu(ver.words[2]), le16_to_cpu(ver.words[3]));
   171		if (flags & BIT(EFX_VER_FLAG(MCFW_EXT_INFO))) {
   172			build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_ID);
   173			snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
   174				 " (%x) %s", build_id,
   175				 MCDI_PTR(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_NAME));
   176		}
   177		devlink_info_version_running_put(req,
   178						 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
   179						 buf);
   180	
   181		if (flags & BIT(EFX_VER_FLAG(SUCFW_EXT_INFO))) {
   182			ver.dwords = (__le32 *)MCDI_PTR(outbuf,
   183							GET_VERSION_V2_OUT_SUCFW_VERSION);
   184			tstamp = MCDI_QWORD(outbuf,
   185					    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
 > 186			rtc_time64_to_tm(tstamp, &build_date);
   187			build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
   188	
   189			snprintf(buf, EFX_MAX_VERSION_INFO_LEN,
   190				 "%u.%u.%u.%u type %x (%ptRd)",
   191				 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
   192				 le32_to_cpu(ver.dwords[2]), le32_to_cpu(ver.dwords[3]),
   193				 build_id, &build_date);
   194	
   195			devlink_info_version_running_put(req,
   196							 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC,
   197							 buf);
   198		}
   199	}
   200	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF09667A80B
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 01:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbjAYAzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 19:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbjAYAzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 19:55:40 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AC24F37D
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 16:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674608131; x=1706144131;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x0Rg4siGGf26wzanTPNNmH0HeoXYLps/Gvw1tF+bq8M=;
  b=DVgmcipsy/75XnWGRuYd8eVN0XXyU1jrRbscWLs8CfxgXdIzbpJtPywm
   kQzSlKtaS5cKEn3U2jN7rvn0yw7SSdCyJSJOQCDgU4M0ZOuOjcyoVqmfb
   HpmVrBlLL4P2Bi9z8ZDkmDUsXy+y90EQfMfRezVo0x8YCN3oUqwPEf9wu
   xgSYVBJB2dA6C/otZv1WRJtTcVSe+46kqmLnDAZY5JIPt9KN0mAokJayG
   Vz/2UGUm57nutBRpMmbqCZnc3JAR/LiYTLcRypZqeokiCOVxhHpQHbMVx
   VyCtL2TIm4J6dZL6MlksJm64qAIUP7DRsSZ9pC2zr01jC6jY2RtoxLFvn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="326486750"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="326486750"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 16:55:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="662333242"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="662333242"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 24 Jan 2023 16:55:28 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pKU4V-0006uc-1g;
        Wed, 25 Jan 2023 00:55:27 +0000
Date:   Wed, 25 Jan 2023 08:54:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com, ecree.xilinx@gmail.com,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: Re: [PATCH v2 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <202301250841.TuIjCxZ7-lkp@intel.com>
References: <20230124223029.51306-3-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124223029.51306-3-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230125-063245
patch link:    https://lore.kernel.org/r/20230124223029.51306-3-alejandro.lucero-palau%40amd.com
patch subject: [PATCH v2 net-next 2/8] sfc: add devlink info support for ef100
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20230125/202301250841.TuIjCxZ7-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c6a73da54918310be8c54a4b2caf2ab4a3419594
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230125-063245
        git checkout c6a73da54918310be8c54a4b2caf2ab4a3419594
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash drivers/net/ethernet/sfc/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/sfc/efx_devlink.c: In function 'efx_devlink_info_running_versions':
>> drivers/net/ethernet/sfc/efx_devlink.c:350:27: warning: variable 'offset' set but not used [-Wunused-but-set-variable]
     350 |         size_t outlength, offset;
         |                           ^~~~~~


vim +/offset +350 drivers/net/ethernet/sfc/efx_devlink.c

   338	
   339	static void efx_devlink_info_running_versions(struct efx_nic *efx,
   340						      struct devlink_info_req *req)
   341	{
   342		MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_VERSION_V5_OUT_LEN);
   343		MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_VERSION_EXT_IN_LEN);
   344		char buf[EFX_MAX_VERSION_INFO_LEN];
   345		union {
   346			const __le32 *dwords;
   347			const __le16 *words;
   348			const char *str;
   349		} ver;
 > 350		size_t outlength, offset;
   351		unsigned int flags;
   352		int rc;
   353	
   354		rc = efx_mcdi_rpc(efx, MC_CMD_GET_VERSION, inbuf, sizeof(inbuf),
   355				  outbuf, sizeof(outbuf), &outlength);
   356		if (rc || outlength < MC_CMD_GET_VERSION_OUT_LEN)
   357			return;
   358	
   359		/* Handle previous output */
   360		if (outlength < MC_CMD_GET_VERSION_V2_OUT_LEN) {
   361			ver.words = (__le16 *)MCDI_PTR(outbuf,
   362						       GET_VERSION_EXT_OUT_VERSION);
   363			offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
   364					  le16_to_cpu(ver.words[0]),
   365					  le16_to_cpu(ver.words[1]),
   366					  le16_to_cpu(ver.words[2]),
   367					  le16_to_cpu(ver.words[3]));
   368	
   369			devlink_info_version_running_put(req,
   370							 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
   371							 buf);
   372			return;
   373		}
   374	
   375		/* Handle V2 additions */
   376		flags = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_FLAGS);
   377		efx_devlink_info_running_v2(efx, req, flags, outbuf);
   378	
   379		if (outlength < MC_CMD_GET_VERSION_V3_OUT_LEN)
   380			return;
   381	
   382		/* Handle V3 additions */
   383		efx_devlink_info_running_v3(efx, req, flags, outbuf);
   384	
   385		if (outlength < MC_CMD_GET_VERSION_V4_OUT_LEN)
   386			return;
   387	
   388		/* Handle V4 additions */
   389		efx_devlink_info_running_v4(efx, req, flags, outbuf);
   390	
   391		if (outlength < MC_CMD_GET_VERSION_V5_OUT_LEN)
   392			return;
   393	
   394		/* Handle V5 additions */
   395		efx_devlink_info_running_v5(efx, req, flags, outbuf);
   396	}
   397	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

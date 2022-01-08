Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF19048810E
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 04:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbiAHDOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 22:14:36 -0500
Received: from mga04.intel.com ([192.55.52.120]:50934 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233287AbiAHDOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 22:14:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641611675; x=1673147675;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+u3dTzcaO34xqmBxu4T2D6mrH13SWuF61TSnDFmDAVQ=;
  b=NjLmtqpOvMjYtxml5T7cGkKwlCI8yIOqF2x0wjR6LWf4YJ2mt1QzjKWX
   AcmXjgal2dxyLL4prORybeHgYcptoXkxsnBUUklT3aTvZpig6avUWMynE
   gM9pzoV8ViVUtqzU0rCHZ1N8m96JWHyzw7RwfKyqZBTxr4frLkE8SF4CP
   f5SzmV7OAKfrEOQ3xZxK9/CD2jwUXNFuWbcOVjS8FXgGB39drXcgu5cdq
   t84it7lMRPuL8b+DHxz2hgKYIAlfMs1y8hOtIC95r3yLd9ANBHgEwPBJh
   xl3UBk9hXVsrf6V7XwX3BAs/sBs9QTMKtt5/KoD8dYOYUCWeTvg2Gx+ga
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="241795060"
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="241795060"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 19:14:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="514018652"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 07 Jan 2022 19:14:32 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n62Bb-0000Cp-EK; Sat, 08 Jan 2022 03:14:31 +0000
Date:   Sat, 8 Jan 2022 11:14:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Abhishek Kumar <kuabhs@chromium.org>, kvalo@codeaurora.org,
        dianders@chromium.org
Cc:     kbuild-all@lists.01.org, pillair@codeaurora.org,
        kuabhs@chromium.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, ath10k@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] ath10k: search for default BDF name provided in DT
Message-ID: <202201081118.iN7Rcf4J-lkp@intel.com>
References: <20220107200417.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107200417.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvalo-ath/ath-next]
[also build test WARNING on kvalo-wireless-drivers-next/master kvalo-wireless-drivers/master v5.16-rc8 next-20220107]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Abhishek-Kumar/ath10k-search-for-default-BDF-name-provided-in-DT/20220108-040711
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath-next
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20220108/202201081118.iN7Rcf4J-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/98e7f008cb14b9c4038287915c271bb485a89346
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Abhishek-Kumar/ath10k-search-for-default-BDF-name-provided-in-DT/20220108-040711
        git checkout 98e7f008cb14b9c4038287915c271bb485a89346
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=alpha SHELL=/bin/bash drivers/net/wireless/ath/ath10k/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/wireless/ath/ath10k/core.c: In function 'ath10k_core_parse_default_bdf_dt':
>> drivers/net/wireless/ath/ath10k/core.c:1103:115: warning: format '%d' expects argument of type 'int', but argument 4 has type 'long unsigned int' [-Wformat=]
    1103 |                             "default board name is longer than allocated buffer, board_name: %s; allocated size: %d\n",
         |                                                                                                                  ~^
         |                                                                                                                   |
         |                                                                                                                   int
         |                                                                                                                  %ld
    1104 |                             board_name, sizeof(ar->id.default_bdf));
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~                                                 
         |                                         |
         |                                         long unsigned int


vim +1103 drivers/net/wireless/ath/ath10k/core.c

  1083	
  1084	int ath10k_core_parse_default_bdf_dt(struct ath10k *ar)
  1085	{
  1086		struct device_node *node;
  1087		const char *board_name = NULL;
  1088	
  1089		ar->id.default_bdf[0] = '\0';
  1090	
  1091		node = ar->dev->of_node;
  1092		if (!node)
  1093			return -ENOENT;
  1094	
  1095		of_property_read_string(node, "qcom,ath10k-default-bdf",
  1096					&board_name);
  1097		if (!board_name)
  1098			return -ENODATA;
  1099	
  1100		if (strscpy(ar->id.default_bdf,
  1101			    board_name, sizeof(ar->id.default_bdf)) < 0)
  1102			ath10k_warn(ar,
> 1103				    "default board name is longer than allocated buffer, board_name: %s; allocated size: %d\n",
  1104				    board_name, sizeof(ar->id.default_bdf));
  1105	
  1106		return 0;
  1107	}
  1108	EXPORT_SYMBOL(ath10k_core_parse_default_bdf_dt);
  1109	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

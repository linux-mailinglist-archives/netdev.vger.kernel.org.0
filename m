Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D922948A4B8
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344210AbiAKBIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:08:23 -0500
Received: from mga12.intel.com ([192.55.52.136]:20167 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243225AbiAKBIW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 20:08:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641863302; x=1673399302;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TqZR3QdNhx3+jinaxLje5HX8DuGRHTavYxG9F8g5h7E=;
  b=HwQ9zUvsCi7BgSKjSBAsq0Hy0KTI1vXEH9Oy8U66MDUkoTQ2FjfSmSiU
   dQ/l7f/ibpYvElX1RY1hmhkpvJSgOyRWpQo9cxGWNPKNDoL5KiAuZ5x3Z
   lG7GCeWMlGtVJuuWlf24LlKsEyw2ajEc6kl8L1v7h6qYm7GYhJR3cqH/p
   Vy2Ph6F7tcOpYw2UI9tJ8VJ6SBo0Uf0YApW4gZInoDZuYCcTprndKc+4s
   H8YR8y/Q0TBgLTV81nR7uwZHJM0mYpOYGHQ8mcq+uZHKCMbOtXzr/6ekv
   2my37mwdC761g+LeU+0NAhL66PJuBlajvaXvLKy5sQ5J84I/VqvdFEF8m
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="223356672"
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="223356672"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 17:08:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="490198291"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 10 Jan 2022 17:08:18 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n75e5-00049d-Pv; Tue, 11 Jan 2022 01:08:17 +0000
Date:   Tue, 11 Jan 2022 09:07:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Abhishek Kumar <kuabhs@chromium.org>, kvalo@codeaurora.org,
        ath10k@lists.infradead.org
Cc:     kbuild-all@lists.01.org, pillair@codeaurora.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuabhs@chromium.org, dianders@chromium.org,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ath10k: search for default BDF name provided in DT
Message-ID: <202201110851.5qAxfQJj-lkp@intel.com>
References: <20220110231255.v2.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110231255.v2.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvalo-ath/ath-next]
[also build test WARNING on kvalo-wireless-drivers-next/master kvalo-wireless-drivers/master v5.16 next-20220110]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Abhishek-Kumar/ath10k-search-for-default-BDF-name-provided-in-DT/20220111-071636
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath-next
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220111/202201110851.5qAxfQJj-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/50c4c7cb02cc786afcd9aff27616a6e20296c703
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Abhishek-Kumar/ath10k-search-for-default-BDF-name-provided-in-DT/20220111-071636
        git checkout 50c4c7cb02cc786afcd9aff27616a6e20296c703
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash drivers/net/wireless/ath/ath10k/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/wireless/ath/ath10k/core.c: In function 'ath10k_core_parse_default_bdf_dt':
>> drivers/net/wireless/ath/ath10k/core.c:1103:116: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'unsigned int' [-Wformat=]
    1103 |                             "default board name is longer than allocated buffer, board_name: %s; allocated size: %ld\n",
         |                                                                                                                  ~~^
         |                                                                                                                    |
         |                                                                                                                    long int
         |                                                                                                                  %d
    1104 |                             board_name, sizeof(ar->id.default_bdf));
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~                                                  
         |                                         |
         |                                         unsigned int


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
> 1103				    "default board name is longer than allocated buffer, board_name: %s; allocated size: %ld\n",
  1104				    board_name, sizeof(ar->id.default_bdf));
  1105	
  1106		return 0;
  1107	}
  1108	EXPORT_SYMBOL(ath10k_core_parse_default_bdf_dt);
  1109	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

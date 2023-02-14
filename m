Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C94696373
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 13:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjBNM0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 07:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBNM0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 07:26:13 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9210F252B9
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 04:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676377572; x=1707913572;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oWKyv0ImNgy2R0D2BY9EEktnommad7QOfAQal4ZipJw=;
  b=DZ66oqyBawa4MENhpQTaGMYHoaOiNp4Zrb2nXtDr69w97t4yjNH0CrZM
   TZxrubeb58foHiKcPwR74ahORs3zVy4gONGWNbXMBixg0tsH8FKhk6wAs
   HY8lNJQII2qZBR9dru5GrZvbuXDtH1IVcGxJbRP+h/oQg0WXTI+DjK8kS
   HGTOa+s2gKIc/1MOycnDsoG4uw6CwuOBbAjc4lwQnqS60VqyNc0nx+E9g
   1KNs2OcmaCSmUdXsRKq+xwrOk48H7HRmLKo0fGxWUYVUdQGfaxTtAgcUr
   T6+dNsCiZd3Au0RVMq9OQ8BMc2XWf6KK64ppPMGFM7NfCsDrqCcoH4EIL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="310780788"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="310780788"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 04:26:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="669149503"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="669149503"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 14 Feb 2023 04:26:08 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pRuNr-0008UR-1i;
        Tue, 14 Feb 2023 12:26:07 +0000
Date:   Tue, 14 Feb 2023 20:25:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Harsh Jain <h.jain@amd.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        thomas.lendacky@amd.com, Raju.Rangoju@amd.com,
        Shyam-sundar.S-k@amd.com, harshjain.prof@gmail.com,
        abhijit.gangurde@amd.com, puneet.gupta@amd.com,
        nikhil.agarwal@amd.com, tarak.reddy@amd.com, netdev@vger.kernel.org
Cc:     Paul Gazzillo <paul@pgazz.com>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        oe-kbuild-all@lists.linux.dev, Harsh Jain <h.jain@amd.com>
Subject: Re: [PATCH  6/6]  net: ethernet: efct: Add maintainer, kconfig,
 makefile
Message-ID: <202302142057.zm2vYusI-lkp@intel.com>
References: <20230210130321.2898-7-h.jain@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210130321.2898-7-h.jain@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harsh,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master horms-ipvs/master linus/master v6.2-rc8 next-20230214]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Harsh-Jain/net-ethernet-efct-New-X3-net-driver/20230210-210711
patch link:    https://lore.kernel.org/r/20230210130321.2898-7-h.jain%40amd.com
patch subject: [PATCH  6/6]  net: ethernet: efct: Add maintainer, kconfig, makefile
config: riscv-kismet-CONFIG_PTP_1588_CLOCK-CONFIG_EFCT_PTP-0-0 (https://download.01.org/0day-ci/archive/20230214/202302142057.zm2vYusI-lkp@intel.com/config)
reproduce:
        # https://github.com/intel-lab-lkp/linux/commit/93ed306161ac0259bd72b14922a7f6af60b3748c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Harsh-Jain/net-ethernet-efct-New-X3-net-driver/20230210-210711
        git checkout 93ed306161ac0259bd72b14922a7f6af60b3748c
        # 1. reproduce by kismet
           # install kmax per https://github.com/paulgazz/kmax/blob/master/README.md
           kismet --linux-ksrc=linux --selectees CONFIG_PTP_1588_CLOCK --selectors CONFIG_EFCT_PTP -a=riscv
        # 2. reproduce by make
           # save the config file to linux source tree
           cd linux
           make ARCH=riscv olddefconfig

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302142057.zm2vYusI-lkp@intel.com/

kismet warnings: (new ones prefixed by >>)
>> kismet: WARNING: unmet direct dependencies detected for PTP_1588_CLOCK when selected by EFCT_PTP
   
   WARNING: unmet direct dependencies detected for PTP_1588_CLOCK
     Depends on [n]: NET [=y] && POSIX_TIMERS [=n]
     Selected by [y]:
     - EFCT_PTP [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_AMD [=y] && EFCT [=y]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

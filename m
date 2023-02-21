Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2C369E0FC
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 14:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbjBUNDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 08:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbjBUNDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 08:03:14 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17B512F11;
        Tue, 21 Feb 2023 05:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676984593; x=1708520593;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/YrhD0FczvWSlv0RDCA4ZnD7EmSFcYMbG+9F2BlavwQ=;
  b=DbxR5v1Yj688qn16zPxRn7bVPtNAlNn3imEkvkQHVKKF24lkRdIQKnY3
   PT24HHaaW/wf4lRyu+AuILSqMw8ZMTphOXrPXLRnK+8w212QD40sDjiqt
   S++vM0HhPWlptJajW+YdZQ120dPlreQTzNvHfipzLpVu0llry1ph1e7Tb
   eaU+I3GYo9U9TB7fENGDcsio3Xn5DKnpBx3BlMoc5nr/EV4j3iriYVOJS
   VwhjmhqL2T440y82F8u6E0+btJ+Vy3GjShzQUwkKW2ZFfu47eQsK3/eVZ
   CjBOS+ZuaiwddcExXThGiw4jSZU/WvyycOlTGxZEsr4Hct1s3P/1Gkqao
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="312250426"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="312250426"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 05:03:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="814498922"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="814498922"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 21 Feb 2023 05:03:10 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pUSIX-000En7-2h;
        Tue, 21 Feb 2023 13:03:09 +0000
Date:   Tue, 21 Feb 2023 21:01:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] net/smc: Introduce BPF injection capability
 for SMC
Message-ID: <202302212036.S8wKuQqw-lkp@intel.com>
References: <1676966191-47736-2-git-send-email-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676966191-47736-2-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wythe,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/D-Wythe/net-smc-Introduce-BPF-injection-capability-for-SMC/20230221-155712
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/1676966191-47736-2-git-send-email-alibuda%40linux.alibaba.com
patch subject: [PATCH bpf-next 1/2] net/smc: Introduce BPF injection capability for SMC
config: x86_64-randconfig-a004-20230220 (https://download.01.org/0day-ci/archive/20230221/202302212036.S8wKuQqw-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/e2b31aece49068d7a07ca4bbd5fbdbd92f45a25e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review D-Wythe/net-smc-Introduce-BPF-injection-capability-for-SMC/20230221-155712
        git checkout e2b31aece49068d7a07ca4bbd5fbdbd92f45a25e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302212036.S8wKuQqw-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "smc_sock_perform_collecting_info" [net/smc/smc.ko] undefined!
>> ERROR: modpost: "smc_sock_should_select_smc" [net/smc/smc.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

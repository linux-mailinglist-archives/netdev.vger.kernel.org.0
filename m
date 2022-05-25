Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BE0533DD4
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 15:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244496AbiEYNWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 09:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbiEYNWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 09:22:25 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6591E2FFE9
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 06:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653484918; x=1685020918;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pPJHbvH/CiYdJQCat3sp9UlNnA6L3VzD2OqSB/bcNxw=;
  b=KeUOyyKJEHbiG+f3pFZKB9ZwrM8ffZTHF1nbbeJt+TKc3l/DhFfajJHN
   f2wXFc3wIQK6yytei7hG5StLhELxnv9kQUl+lo+dHVdNhrPLqv9jvxafu
   Qo/ERtX8sE58raQ6oD4SfQWGyiSxUxCavh/6znd6lAnQcrHfuIkR80tlo
   e10nM3r3YpKYJE48imPAJV3BjLGS+NcSfetm4jaJ/Vc7wnInSJRSceEY2
   SD6/tg9tw3Z2ZegBAw70zQRezBT+aBVQsOfjg8kqWZAgQ9F/j9ddwZpHH
   9iUt5knqSOzn051so2hItWRW3k2oM3Y+lVTxKpf7PWK2bHtn44cptQcO/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="261422510"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="261422510"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 06:21:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="609121468"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 25 May 2022 06:21:55 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ntqxW-00032c-L6;
        Wed, 25 May 2022 13:21:54 +0000
Date:   Wed, 25 May 2022 21:21:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tobias Klauser <tklauser@distanz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: Re: [PATCH] socket: Use __u8 instead of u8 in uapi socket.h
Message-ID: <202205252127.cfqhpFVS-lkp@intel.com>
References: <20220525085126.29977-1-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525085126.29977-1-tklauser@distanz.ch>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master horms-ipvs/master linus/master v5.18 next-20220525]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Tobias-Klauser/socket-Use-__u8-instead-of-u8-in-uapi-socket-h/20220525-170053
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 57d7becda9c9e612e6b00676f2eecfac3e719e88
config: x86_64-randconfig-a015 (https://download.01.org/0day-ci/archive/20220525/202205252127.cfqhpFVS-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/283fe3009b96069f17a813f86db8b48d12b5014e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tobias-Klauser/socket-Use-__u8-instead-of-u8-in-uapi-socket-h/20220525-170053
        git checkout 283fe3009b96069f17a813f86db8b48d12b5014e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> usr/include/linux/socket.h:34: found __[us]{8,16,32,64} type without #include <linux/types.h>

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

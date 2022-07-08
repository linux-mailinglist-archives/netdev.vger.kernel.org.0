Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B881C56B2FD
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 08:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbiGHGwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 02:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbiGHGwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 02:52:34 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF006EE9C;
        Thu,  7 Jul 2022 23:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657263153; x=1688799153;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QIOfrS9Mg8mDpfgg0AWFxkQHpTHuQeEmTtCHCmLAbsc=;
  b=EtjtPgeGc73fbn3ugI0CXgz6Sx7nreQ31HvzReNgj/roLiNUAKHuoiK0
   vuR/4T0KZJo6ORII2iSqPgp3ANiAajdCU7vvjmXgBtoMELpCxzO8ydNhG
   XEq8BQ9UuFa9DNe0nrNy6NjVcZ3OVjtN2HArYQ8G7Zi+RnLB2WCH0UyP2
   MH5ZbbDd9nm+L+o+oFu6cxVWD/MVmzeillq4JMkcyuVjeZAQ7i06rxgGi
   JnNg9/IyN5P5B+US3CfgDuB7I3K3/KAkP0Dp4qxhR/Z46sklylwfQoRPI
   IMp9LX4NwGKJ/xEX0H1KC89t6Hg9Lzp2G5R0z52gSKXxHuSfikpuvO+YI
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="284949289"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="284949289"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 23:52:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="736239583"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jul 2022 23:52:30 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o9hqn-000N3q-OY;
        Fri, 08 Jul 2022 06:52:29 +0000
Date:   Fri, 8 Jul 2022 14:52:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Manish Mandlik <mmandlik@google.com>, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     kbuild-all@lists.01.org, linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Manish Mandlik <mmandlik@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/3] Bluetooth: Add sysfs entry to enable/disable
 devcoredump
Message-ID: <202207081448.MghkbBvn-lkp@intel.com>
References: <20220707151420.v3.2.I39885624992dacff236aed268bdaa69107cd1310@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707151420.v3.2.I39885624992dacff236aed268bdaa69107cd1310@changeid>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bluetooth/master]
[also build test WARNING on bluetooth-next/master linus/master v5.19-rc5 next-20220707]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Manish-Mandlik/Bluetooth-Add-support-for-devcoredump/20220708-061724
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git master
config: i386-randconfig-s002 (https://download.01.org/0day-ci/archive/20220708/202207081448.MghkbBvn-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/0d785cbd11ed3a6de29aeb05926177440ab26d54
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Manish-Mandlik/Bluetooth-Add-support-for-devcoredump/20220708-061724
        git checkout 0d785cbd11ed3a6de29aeb05926177440ab26d54
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash net/bluetooth/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/bluetooth/hci_sysfs.c:118:1: sparse: sparse: symbol 'dev_attr_enable_coredump' was not declared. Should it be static?

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

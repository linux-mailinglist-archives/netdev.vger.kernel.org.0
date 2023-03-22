Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B406C5ADC
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjCVXyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjCVXyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:54:04 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FB928D3B
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 16:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679529243; x=1711065243;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xoAgyqqu49oMWpZueFWuEj/HoO1dMC7XQtg6BYrQs0M=;
  b=I+tOxSNtOaw9lHUwRs7KUTxfFoEohMf59dfmBiv6oVPFR5nwJUpV6FD/
   sMpNvQ1qySp7OMc0t+38h/80tBDlO599HqzB3c+1Xm6ocElhxhkdq9bvy
   0kuBBTWUNAxnMrv+JXWsSrxP7WCw0b/VvMDqW8WxiSlI3/UmMDn+XcIM7
   99HzkCvS/6tjLj6TLxZAUoqk0jS2+KM6NmVXjWRzxyRNTyd7VGEioNWBS
   XaTfqCcFJGcSbi1+OrZDfGeXnUFQfMT7sU+ETAIFjqRePrnL/0Gz8VgE3
   nw3ULqtGNDXra+pL8UVwyY7LyvPOvdEDSsdIUoUUEE3uVVkJxQXNaEYhW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="341719308"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="341719308"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 16:54:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="682111188"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="682111188"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 22 Mar 2023 16:54:01 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pf8HI-000DlE-2K;
        Wed, 22 Mar 2023 23:54:00 +0000
Date:   Thu, 23 Mar 2023 07:53:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shannon Nelson <shannon.nelson@amd.com>, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, drivers@pensando.io,
        leon@kernel.org, jiri@resnulli.us
Subject: Re: [PATCH v5 net-next 02/14] pds_core: add devcmd device interfaces
Message-ID: <202303230742.pX3ply0t-lkp@intel.com>
References: <20230322185626.38758-3-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322185626.38758-3-shannon.nelson@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shannon,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Shannon-Nelson/pds_core-initial-framework-for-pds_core-PF-driver/20230323-030131
patch link:    https://lore.kernel.org/r/20230322185626.38758-3-shannon.nelson%40amd.com
patch subject: [PATCH v5 net-next 02/14] pds_core: add devcmd device interfaces
reproduce:
        make versioncheck

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303230742.pX3ply0t-lkp@intel.com/

versioncheck warnings: (new ones prefixed by >>)
   INFO PATH=/opt/cross/clang/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   /usr/bin/timeout -k 100 3h /usr/bin/make W=1 --keep-going HOSTCC=gcc-11 CC=gcc-11 -j32 ARCH=x86_64 versioncheck
   find ./* \( -name SCCS -o -name BitKeeper -o -name .svn -o -name CVS -o -name .pc -o -name .hg -o -name .git \) -prune -o \
   	-name '*.[hcS]' -type f -print | sort \
   	| xargs perl -w ./scripts/checkversion.pl
   ./drivers/accessibility/speakup/genmap.c: 13 linux/version.h not needed.
   ./drivers/accessibility/speakup/makemapdata.c: 13 linux/version.h not needed.
>> ./drivers/net/ethernet/amd/pds_core/dev.c: 4 linux/version.h not needed.
   ./drivers/soc/tegra/cbb/tegra-cbb.c: 19 linux/version.h not needed.
   ./drivers/soc/tegra/cbb/tegra194-cbb.c: 26 linux/version.h not needed.
   ./drivers/soc/tegra/cbb/tegra234-cbb.c: 27 linux/version.h not needed.
   ./drivers/staging/media/atomisp/include/linux/atomisp.h: 23 linux/version.h not needed.
   ./samples/trace_events/trace_custom_sched.c: 11 linux/version.h not needed.
   ./sound/soc/codecs/cs42l42.c: 14 linux/version.h not needed.
   ./tools/lib/bpf/bpf_helpers.h: 289: need linux/version.h
   ./tools/perf/tests/bpf-script-example.c: 60: need linux/version.h
   ./tools/perf/tests/bpf-script-test-kbuild.c: 21: need linux/version.h
   ./tools/perf/tests/bpf-script-test-prologue.c: 49: need linux/version.h
   ./tools/perf/tests/bpf-script-test-relocation.c: 51: need linux/version.h
   ./tools/testing/selftests/bpf/progs/dev_cgroup.c: 9 linux/version.h not needed.
   ./tools/testing/selftests/bpf/progs/netcnt_prog.c: 3 linux/version.h not needed.
   ./tools/testing/selftests/bpf/progs/test_map_lock.c: 4 linux/version.h not needed.
   ./tools/testing/selftests/bpf/progs/test_send_signal_kern.c: 4 linux/version.h not needed.
   ./tools/testing/selftests/bpf/progs/test_spin_lock.c: 4 linux/version.h not needed.
   ./tools/testing/selftests/bpf/progs/test_tcp_estats.c: 37 linux/version.h not needed.
   ./tools/testing/selftests/wireguard/qemu/init.c: 27 linux/version.h not needed.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

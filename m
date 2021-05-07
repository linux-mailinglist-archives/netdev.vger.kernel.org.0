Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA7D37646E
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 13:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhEGL21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 07:28:27 -0400
Received: from mga12.intel.com ([192.55.52.136]:30585 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232081AbhEGL20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 07:28:26 -0400
IronPort-SDR: GS+Qx21i/TfqFbx+n5o8yyWEi6e02thxwHmDgVWANkesc+vvwOTDE0B5UnY9eXCHorIOoh6KJ+
 qQ57CQovtm7w==
X-IronPort-AV: E=McAfee;i="6200,9189,9976"; a="178272535"
X-IronPort-AV: E=Sophos;i="5.82,280,1613462400"; 
   d="gz'50?scan'50,208,50";a="178272535"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2021 04:27:27 -0700
IronPort-SDR: 4qFn9n5D4RNvdDQPGYNYSV6wKxaGnkGnMY4nq3S2as9e17juBWeni2CcGuW4wioP13WeIkiz+F
 SXH9SlUrtjMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,280,1613462400"; 
   d="gz'50?scan'50,208,50";a="453008145"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 07 May 2021 04:27:24 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1leydg-000BAj-7u; Fri, 07 May 2021 11:27:24 +0000
Date:   Fri, 7 May 2021 19:26:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next 1/6] ptp: add ptp virtual clock driver framework
Message-ID: <202105071901.AkYZrUSI-lkp@intel.com>
References: <20210507085756.20427-2-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <20210507085756.20427-2-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Yangbo,

I love your patch! Yet something to improve:

[auto build test ERROR on 9d31d2338950293ec19d9b095fbaa9030899dcb4]

url:    https://github.com/0day-ci/linux/commits/Yangbo-Lu/ptp-support-virtual-clocks-for-multiple-domains/20210507-164927
base:   9d31d2338950293ec19d9b095fbaa9030899dcb4
config: nds32-randconfig-r012-20210507 (attached as .config)
compiler: nds32le-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/1f46e22fa0f24ac9acde10ca897266e0bac0f367
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Yangbo-Lu/ptp-support-virtual-clocks-for-multiple-domains/20210507-164927
        git checkout 1f46e22fa0f24ac9acde10ca897266e0bac0f367
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross W=1 ARCH=nds32 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from drivers/ptp/ptp_private.h:16,
                    from drivers/ptp/ptp_clock.c:20:
>> include/linux/ptp_clock_kernel.h:71:22: error: field 'cc' has incomplete type
      71 |  struct cyclecounter cc;
         |                      ^~
   In file included from drivers/ptp/ptp_clock.c:20:
>> drivers/ptp/ptp_private.h:59:22: error: field 'cc' has incomplete type
      59 |  struct cyclecounter cc;
         |                      ^~
>> drivers/ptp/ptp_private.h:60:21: error: field 'tc' has incomplete type
      60 |  struct timecounter tc;
         |                     ^~
--
   In file included from drivers/ptp/ptp_private.h:16,
                    from drivers/ptp/ptp_vclock.c:8:
>> include/linux/ptp_clock_kernel.h:71:22: error: field 'cc' has incomplete type
      71 |  struct cyclecounter cc;
         |                      ^~
   In file included from drivers/ptp/ptp_vclock.c:8:
>> drivers/ptp/ptp_private.h:59:22: error: field 'cc' has incomplete type
      59 |  struct cyclecounter cc;
         |                      ^~
>> drivers/ptp/ptp_private.h:60:21: error: field 'tc' has incomplete type
      60 |  struct timecounter tc;
         |                     ^~
   drivers/ptp/ptp_vclock.c: In function 'ptp_vclock_adjfine':
>> drivers/ptp/ptp_vclock.c:20:2: error: implicit declaration of function 'timecounter_read'; did you mean 'refcount_read'? [-Werror=implicit-function-declaration]
      20 |  timecounter_read(&vclock->tc);
         |  ^~~~~~~~~~~~~~~~
         |  refcount_read
   drivers/ptp/ptp_vclock.c: In function 'ptp_vclock_adjtime':
>> drivers/ptp/ptp_vclock.c:33:2: error: implicit declaration of function 'timecounter_adjtime' [-Werror=implicit-function-declaration]
      33 |  timecounter_adjtime(&vclock->tc, delta);
         |  ^~~~~~~~~~~~~~~~~~~
   drivers/ptp/ptp_vclock.c: In function 'ptp_vclock_settime':
>> drivers/ptp/ptp_vclock.c:62:2: error: implicit declaration of function 'timecounter_init'; did you mean 'timerqueue_init'? [-Werror=implicit-function-declaration]
      62 |  timecounter_init(&vclock->tc, &vclock->cc, ns);
         |  ^~~~~~~~~~~~~~~~
         |  timerqueue_init
   drivers/ptp/ptp_vclock.c: In function 'ptp_clock_find_domain_tstamp':
>> drivers/ptp/ptp_vclock.c:103:23: error: implicit declaration of function 'timecounter_cyc2time' [-Werror=implicit-function-declaration]
     103 |   domain_ts->tstamp = timecounter_cyc2time(&vclock->tc, domain_ts->tstamp);
         |                       ^~~~~~~~~~~~~~~~~~~~
   In file included from <command-line>:
   drivers/ptp/ptp_vclock.c: In function 'ptp_get_pclock_info':
>> include/linux/kernel.h:709:32: error: dereferencing pointer to incomplete type 'const struct cyclecounter'
     709 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
         |                                ^~~~~~
   include/linux/compiler_types.h:308:9: note: in definition of macro '__compiletime_assert'
     308 |   if (!(condition))     \
         |         ^~~~~~~~~
   include/linux/compiler_types.h:328:2: note: in expansion of macro '_compiletime_assert'
     328 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:709:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     709 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
         |  ^~~~~~~~~~~~~~~~
   include/linux/kernel.h:709:20: note: in expansion of macro '__same_type'
     709 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
         |                    ^~~~~~~~~~~
   drivers/ptp/ptp_private.h:51:25: note: in expansion of macro 'container_of'
      51 | #define cc_to_vclock(d) container_of((d), struct ptp_vclock, cc)
         |                         ^~~~~~~~~~~~
   drivers/ptp/ptp_vclock.c:126:30: note: in expansion of macro 'cc_to_vclock'
     126 |  struct ptp_vclock *vclock = cc_to_vclock(cc);
         |                              ^~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   In file included from include/linux/spi/spi.h:17,
                    from drivers/iio/accel/adxl372.c:14:
>> include/linux/ptp_clock_kernel.h:71:22: error: field 'cc' has incomplete type
      71 |  struct cyclecounter cc;
         |                      ^~


vim +/cc +71 include/linux/ptp_clock_kernel.h

    50	
    51	/**
    52	 * struct ptp_vclock_cc - ptp virtual clock cycle counter info
    53	 *
    54	 * @cc:               cyclecounter structure
    55	 * @refresh_interval: time interval to refresh time counter, to avoid 64-bit
    56	 *                    overflow during delta conversion. For example, with
    57	 *                    cc.mult value 2^28,  there are 36 bits left of cycle
    58	 *                    counter. With 1 ns counter resolution, the overflow time
    59	 *                    is 2^36 ns which is 68.7 s. The refresh_interval may be
    60	 *                    (60 * HZ) less than 68.7 s.
    61	 * @mult_num:         parameter for cc.mult adjustment calculation, see below
    62	 * @mult_dem:         parameter for cc.mult adjustment calculation, see below
    63	 *
    64	 * scaled_ppm to adjustment(mult_adj) of cc.mult
    65	 *
    66	 * mult_adj = mult * (ppb / 10^9)
    67	 *          = mult * (scaled_ppm * 1000 / 2^16) / 10^9
    68	 *          = scaled_ppm * mult_num / mult_dem
    69	 */
    70	struct ptp_vclock_cc {
  > 71		struct cyclecounter cc;
    72		unsigned long refresh_interval;
    73		u32 mult_num;
    74		u32 mult_dem;
    75	};
    76	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--IJpNTDwzlM2Ie8A6
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--IJpNTDwzlM2Ie8A6--

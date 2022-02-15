Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A314B769A
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242716AbiBORxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:53:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbiBORxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:53:18 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFA3FDFBF;
        Tue, 15 Feb 2022 09:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644947586; x=1676483586;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fjS+jLcimlpk3IgAjjxRkS7J2bLZR7vNKhdUAkDnH0s=;
  b=edbVc8amMd0XPgXkRK8/61mMkGK9aavolWBCev63EO+m9Ds9sFFXv65o
   oYF3FFHAn3t1StRdZ/jT258RCC64cFTJI4h83HkcWyQXWiB6r5tPapRB0
   jT4Ojh4xBFHBL5mXxJsw6ZAibRDHB5mDtIx7ISpRCle1X064UguMWAsha
   6q0fZ8tcWfl2PEWLFdOSm4Z5/hZMA/7Dufgz23b6QqrZ0Y3uhm0sgswUu
   bejq82d/yDspDR53UDjbBzySNPrjaTRbxguXzJrDpZAYh54uwh5xe8pX9
   9I4pOlrRJn95wsB8Fqlqj4rmu9E8O1q7inlQIxXDSmwMMxF4+nbPT5gz3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="230374786"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="230374786"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 09:53:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="502570210"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 15 Feb 2022 09:53:01 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nK20b-0009uF-90; Tue, 15 Feb 2022 17:53:01 +0000
Date:   Wed, 16 Feb 2022 01:52:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joseph Hwang <josephsih@chromium.org>,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     kbuild-all@lists.01.org,
        chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/3] Bluetooth: aosp: surface AOSP quality report
 through mgmt
Message-ID: <202202160117.jjnGwidL-lkp@intel.com>
References: <20220215213519.v4.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215213519.v4.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bluetooth-next/master]
[also build test WARNING on net-next/master next-20220215]
[cannot apply to net/master v5.17-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Joseph-Hwang/Bluetooth-aosp-surface-AOSP-quality-report-through-mgmt/20220215-213800
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master
config: h8300-randconfig-s032-20220214 (https://download.01.org/0day-ci/archive/20220216/202202160117.jjnGwidL-lkp@intel.com/config)
compiler: h8300-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/8c2212761e41006d67f3fad819b5bde57bc17773
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Joseph-Hwang/Bluetooth-aosp-surface-AOSP-quality-report-through-mgmt/20220215-213800
        git checkout 8c2212761e41006d67f3fad819b5bde57bc17773
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=h8300 SHELL=/bin/bash net/bluetooth/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   net/bluetooth/hci_event.c:338:15: sparse: sparse: restricted __le16 degrades to integer
>> net/bluetooth/hci_event.c:4288:3: sparse: sparse: symbol 'evt_prefixes' was not declared. Should it be static?
   net/bluetooth/hci_event.c: note: in included file (through include/net/bluetooth/hci_core.h):
   include/net/bluetooth/hci.h:2473:47: sparse: sparse: array of flexible structures
   include/net/bluetooth/hci.h:2559:43: sparse: sparse: array of flexible structures

vim +/evt_prefixes +4288 net/bluetooth/hci_event.c

  4275	
  4276	/* Every distinct vendor specification must have a well-defined vendor
  4277	 * event prefix to determine if a vendor event meets the specification.
  4278	 * If an event prefix is fixed, it should be delcared with FIXED_EVT_PREFIX.
  4279	 * Otherwise, DYNAMIC_EVT_PREFIX should be used for variable prefixes.
  4280	 */
  4281	struct vendor_event_prefix {
  4282		__u8 *prefix;
  4283		__u8 prefix_len;
  4284		void (*vendor_func)(struct hci_dev *hdev, void *data,
  4285				    struct sk_buff *skb);
  4286		__u8 *(*get_prefix)(struct hci_dev *hdev);
  4287		__u8 (*get_prefix_len)(struct hci_dev *hdev);
> 4288	} evt_prefixes[] = {
  4289		FIXED_EVT_PREFIX(AOSP_BQR_PREFIX, aosp_quality_report_evt),
  4290		DYNAMIC_EVT_PREFIX(get_msft_evt_prefix, get_msft_evt_prefix_len,
  4291				   msft_vendor_evt),
  4292	
  4293		/* end with a null entry */
  4294		{},
  4295	};
  4296	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06EE5344C2
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 22:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbiEYURH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 16:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345789AbiEYUQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 16:16:44 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2423E11471;
        Wed, 25 May 2022 13:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653509802; x=1685045802;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8CVZfyXJ3BRW6i3sTZdPRtzPtYDa1DUQhBc/dqRqS4Q=;
  b=M4FnzGmMzYSebCSfQ83FNCGqudMEY+t24/Gde9CQTTUtWIfzs+5wDWXK
   e2Iwy4sBSmGLwHoJseojjszuOaJ6/vWjRk4lPkdCjlLc9v567RUrJK2v4
   h5UjnJiBtJEVg1CgZPQh5j0SnfG7Rk8wyrv+K4tiQ2aU6K2xLmNdWsZ1Y
   fccVaJi5k5TOwnjdCZYUVquVNSv9HSuCN7e3rSXKrddwuQlBzyIQoV/Yk
   BiryJeo9fWNYMIj3/Ya6puQyGXrnRMwBYqx98VUPuz/BS2Ur08F9w+AlT
   Dv7mnFggNkQJe11g2EXIwEdOFVeGYz5/QFcefyi7LT8zkjE9p2ghVA1Ji
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="334572332"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="334572332"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 13:16:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="630512697"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 25 May 2022 13:16:15 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ntxQV-0003I8-2f;
        Wed, 25 May 2022 20:16:15 +0000
Date:   Thu, 26 May 2022 04:15:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joseph Hwang <josephsih@chromium.org>,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     kbuild-all@lists.01.org, josephsih@google.com,
        chromeos-bluetooth-upstreaming@chromium.org,
        Joseph Hwang <josephsih@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 2/5] Bluetooth: aosp: surface AOSP quality report
 through mgmt
Message-ID: <202205260445.F8Xkowrk-lkp@intel.com>
References: <20220525184510.v5.2.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525184510.v5.2.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bluetooth-next/master]
[also build test WARNING on net-next/master net/master v5.18 next-20220525]
[cannot apply to bluetooth/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Joseph-Hwang/Bluetooth-mgmt-add-MGMT_OP_SET_QUALITY_REPORT-for-quality-report/20220525-184722
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master
config: i386-randconfig-s002 (https://download.01.org/0day-ci/archive/20220526/202205260445.F8Xkowrk-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-14-g5a0004b5-dirty
        # https://github.com/intel-lab-lkp/linux/commit/0121eca73c0352b9ac4bc289609b218c0d0fb69e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joseph-Hwang/Bluetooth-mgmt-add-MGMT_OP_SET_QUALITY_REPORT-for-quality-report/20220525-184722
        git checkout 0121eca73c0352b9ac4bc289609b218c0d0fb69e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash net/bluetooth/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   net/bluetooth/hci_event.c:338:15: sparse: sparse: restricted __le16 degrades to integer
>> net/bluetooth/hci_event.c:4275:3: sparse: sparse: symbol 'evt_prefixes' was not declared. Should it be static?
   net/bluetooth/hci_event.c: note: in included file (through include/net/bluetooth/hci_core.h):
   include/net/bluetooth/hci.h:2494:47: sparse: sparse: array of flexible structures
   include/net/bluetooth/hci.h:2580:43: sparse: sparse: array of flexible structures

vim +/evt_prefixes +4275 net/bluetooth/hci_event.c

  4262	
  4263	/* Every distinct vendor specification must have a well-defined vendor
  4264	 * event prefix to determine if a vendor event meets the specification.
  4265	 * Some vendor prefixes are fixed values while some other vendor prefixes
  4266	 * are only available at run time.
  4267	 */
  4268	struct ext_vendor_event_prefix {
  4269		/* Some vendor prefixes are variable length. For convenience,
  4270		 * the prefix in struct ext_vendor_prefix is in little endian.
  4271		 */
  4272		struct ext_vendor_prefix *
  4273			(*get_ext_vendor_prefix)(struct hci_dev *hdev);
  4274		void (*vendor_func)(struct hci_dev *hdev, struct sk_buff *skb);
> 4275	} evt_prefixes[] = {
  4276		{ aosp_get_ext_prefix, aosp_vendor_evt },
  4277		{ msft_get_ext_prefix, msft_vendor_evt },
  4278	
  4279		/* end with a null entry */
  4280		{},
  4281	};
  4282	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

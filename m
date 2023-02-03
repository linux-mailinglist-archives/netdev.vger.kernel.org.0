Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BD96897DF
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 12:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbjBCLjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 06:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbjBCLjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 06:39:02 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EC29B6C3;
        Fri,  3 Feb 2023 03:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675424342; x=1706960342;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wW2yPlV0WET0WIQtrvKs9heRtIzcINYVyF0BE22v1/w=;
  b=Yk979TAGV8uAcypK7h/CdUptvBAFoRNynAsRXjUAavwF7H1KOUKqceTP
   /cSMoM+Wpp1+LIVGXKrxv9QoaNBrrvQ3ZYRk4goZ5AMQnTTFOPg4gUz8H
   8XrR4VXOKsxRzhL/q1gkSoT1zGI7X8+PzUDoJS/ZfQttKu/u6PA3eJoRL
   YdmTuOfCqz5qrFqRBJY0diY/knGPtL5Un08WRQEDTSJx9gG7Xz1Gh6BVf
   RD9xlccWKNePfbnp7tWvbg0RTtdGslmZwu7IVzDWX+WeZah81M4+D080j
   ydNOuMD6Pejm9vzhpzUl8+zABxNjMAv35nYlfjwORKRfQIeAycDDcl82K
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="330012839"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="330012839"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 03:39:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="994497015"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="994497015"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 03 Feb 2023 03:38:57 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNuPB-0000Rd-0l;
        Fri, 03 Feb 2023 11:38:57 +0000
Date:   Fri, 3 Feb 2023 19:38:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: Re: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <202302031928.Iw3RGQ3G-lkp@intel.com>
References: <20230202111423.56831-3-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202111423.56831-3-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230202-191843
patch link:    https://lore.kernel.org/r/20230202111423.56831-3-alejandro.lucero-palau%40amd.com
patch subject: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
reproduce:
        # https://github.com/intel-lab-lkp/linux/commit/ae013a0522dccc6ec3db361d23a5cbf2e1de2702
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230202-191843
        git checkout ae013a0522dccc6ec3db361d23a5cbf2e1de2702
        make menuconfig
        # enable CONFIG_COMPILE_TEST, CONFIG_WARN_MISSING_DOCUMENTS, CONFIG_WARN_ABI_ERRORS
        make htmldocs

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> Documentation/networking/devlink/sfc.rst:27: WARNING: Bullet list ends without a blank line; unexpected unindent.
>> Documentation/networking/devlink/sfc.rst:29: WARNING: Block quote ends without a blank line; unexpected unindent.
>> Documentation/networking/devlink/sfc.rst:15: WARNING: Error parsing content block for the "list-table" directive: exactly one bullet list expected.

vim +27 Documentation/networking/devlink/sfc.rst

    14	
  > 15	.. list-table:: devlink info versions implemented
    16	    :widths: 5 5 90
    17	
    18	   * - Name
    19	     - Type
    20	     - Description
    21	   * - ``fw.mgmt.suc``
    22	     - running
    23	     - For boards where the management function is split between multiple
    24	       control units, this is the SUC control unit's firmware version.
    25	   * - ``fw.mgmt.cmc``
    26	     - running
  > 27	    - For boards where the management function is split between multiple
    28	       control units, this is the CMC control unit's firmware version.
  > 29	   * - ``fpga.rev``

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

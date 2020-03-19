Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 370D718AA12
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgCSAwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:52:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:47453 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgCSAwn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 20:52:43 -0400
IronPort-SDR: 9PHaVMu3wjUu2Eik/Nrw/Ih0HKcWH8KMDjknwLMZ3JRKU1/Ph8kwFRVjsrSkbptzlpaI/c+Naj
 r5ALJnIINnOw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 17:52:42 -0700
IronPort-SDR: eHBdTpIIDAbD0X9BkQOd0Zbhzapxsn9ytadHeP2hjNCnKfvuzFrOvj/zJWu+JafqSZgqI8MpEw
 nvLAhkeegxJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="236792998"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 18 Mar 2020 17:52:39 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jEjQN-0003Ow-A9; Thu, 19 Mar 2020 08:52:39 +0800
Date:   Thu, 19 Mar 2020 08:52:07 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     kbuild-all@lists.01.org, Jes.Sorensen@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Subject: Re: [PATCH 2/2] rtl8xxxu: Feed current txrate information for
 mac80211
Message-ID: <202003190842.5IczJPB8%lkp@intel.com>
References: <20200318082700.71875-3-chiu@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318082700.71875-3-chiu@endlessm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v5.6-rc6]
[also build test WARNING on next-20200318]
[cannot apply to jes/rtl8xxxu-devel]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Chris-Chiu/Feed-current-txrate-information-for-mac80211/20200318-194357
base:    fb33c6510d5595144d585aa194d377cf74d31911
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-180-g0558317d-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4819:17: sparse: sparse: cast from restricted __le16
   drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4892:17: sparse: sparse: cast from restricted __le16
>> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5407:6: sparse: sparse: symbol 'rtl8xxxu_desc_to_mcsrate' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

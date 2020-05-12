Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C5B1CE9EB
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgELBB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 21:01:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:34361 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgELBB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 21:01:58 -0400
IronPort-SDR: ilNp5cTVEZAakuALLJjmlanE0UL6raoFea9Ih9PyY/9bLNBoxbSGBwO5M+CR3TGw4Oq9NpPJ9F
 xoPx7QeAQ5vQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 18:01:58 -0700
IronPort-SDR: 9GM6AE+3iCGMbkikDkFgARWlHneN++7upT0Vhm0jZ3vQ8S/sqL9hI/q/lLBR/VvxHhOht6CV4J
 n3TWCgXj5wEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="340725656"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 11 May 2020 18:01:56 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jYJIy-000F3j-0K; Tue, 12 May 2020 09:01:56 +0800
Date:   Tue, 12 May 2020 09:01:32 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Edward Cree <ecree@solarflare.com>,
        linux-net-drivers@solarflare.com, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/8] sfc: make capability checking a nic_type
 function
Message-ID: <202005120824.MqtuMTak%lkp@intel.com>
References: <ad6213aa-b163-8708-47a4-553cb5aa0a8f@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad6213aa-b163-8708-47a4-553cb5aa0a8f@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Edward,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on linus/master v5.7-rc5 next-20200511]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Edward-Cree/sfc-remove-nic_data-usage-in-common-code/20200512-011744
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git a6f0b26d6a5dcf27980e65f965779a929039f11d
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-191-gc51a0382-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/sfc/siena.c:951:14: sparse: sparse: symbol 'siena_check_caps' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

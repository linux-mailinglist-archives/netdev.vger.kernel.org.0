Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93016392529
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 05:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbhE0DEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 23:04:33 -0400
Received: from mga17.intel.com ([192.55.52.151]:51056 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232802AbhE0DEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 23:04:32 -0400
IronPort-SDR: lu9ekwb4y/sUDxUjDrMqQis0QNtyWkczK6KkAdM1WNUQm5xhxywlDeuH8LpGGpYxnl8Lk03B8F
 PqnnvvWzI6ow==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="182970901"
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="182970901"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 20:02:58 -0700
IronPort-SDR: ACnb7s4qw47MzweZRIwc4bDLtqYH5jiZa4kHFfC682dImlWA7Cpq6ixEWOzgQiHzWTXcvEdsYI
 r+lKOiKl3H9g==
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="477295168"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.11])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 20:02:55 -0700
Date:   Thu, 27 May 2021 11:01:41 +0800
From:   kernel test robot <rong.a.chen@intel.com>
To:     Sharath Chandra Vurukala <sharathv@codeaurora.org>,
        davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: Re: [PATCH net-next v6 3/3] net: ethernet: rmnet: Add support for
 MAPv5 egress packets
Message-ID: <20210527030141.GU2687475@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1622040882-27526-4-git-send-email-sharathv@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sharath,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Sharath-Chandra-Vurukala/net-qualcomm-rmnet-Enable-Mapv5/20210526-225721
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git e4e92ee78702b13ad55118d8b66f06e1aef62586
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


includecheck warnings: (new ones prefixed by >>)
>> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c: linux/bitfield.h is included more than once.

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

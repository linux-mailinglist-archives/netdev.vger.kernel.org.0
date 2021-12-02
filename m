Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED274662B7
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 12:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357323AbhLBLw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 06:52:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:1837 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346549AbhLBLw4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 06:52:56 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="223923161"
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="223923161"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 03:49:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="459630558"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 02 Dec 2021 03:49:30 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mskaf-000GGw-K4; Thu, 02 Dec 2021 11:49:29 +0000
Date:   Thu, 2 Dec 2021 19:48:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        arkadiusz.kubalewski@intel.com
Cc:     kbuild-all@lists.01.org, richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Message-ID: <202112021948.p1Sqfiw5-lkp@intel.com>
References: <20211201180208.640179-3-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201180208.640179-3-maciej.machnikowski@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maciej,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Maciej-Machnikowski/Add-ethtool-interface-for-SyncE/20211202-021915
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 23ea630f86c70cbe6691f9f839e7b6742f0e9ad3
reproduce: make htmldocs

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

include/uapi/linux/ethtool.h:1: warning: 'ethtool_rclk_pin_state' not found

vim +/ethtool_rclk_pin_state +1 include/uapi/linux/ethtool.h

6f52b16c5b29b8 Greg Kroah-Hartman 2017-11-01  @1  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
607ca46e97a1b6 David Howells      2012-10-13   2  /*
607ca46e97a1b6 David Howells      2012-10-13   3   * ethtool.h: Defines for Linux ethtool.
607ca46e97a1b6 David Howells      2012-10-13   4   *
607ca46e97a1b6 David Howells      2012-10-13   5   * Copyright (C) 1998 David S. Miller (davem@redhat.com)
607ca46e97a1b6 David Howells      2012-10-13   6   * Copyright 2001 Jeff Garzik <jgarzik@pobox.com>
607ca46e97a1b6 David Howells      2012-10-13   7   * Portions Copyright 2001 Sun Microsystems (thockin@sun.com)
607ca46e97a1b6 David Howells      2012-10-13   8   * Portions Copyright 2002 Intel (eli.kupermann@intel.com,
607ca46e97a1b6 David Howells      2012-10-13   9   *                                christopher.leech@intel.com,
607ca46e97a1b6 David Howells      2012-10-13  10   *                                scott.feldman@intel.com)
607ca46e97a1b6 David Howells      2012-10-13  11   * Portions Copyright (C) Sun Microsystems 2008
607ca46e97a1b6 David Howells      2012-10-13  12   */
607ca46e97a1b6 David Howells      2012-10-13  13  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3C1D65CE
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 17:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733215AbfJNPEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 11:04:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:58874 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732854AbfJNPEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 11:04:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 08:04:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="370149654"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 14 Oct 2019 08:04:41 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iK1to-00036I-Pi; Mon, 14 Oct 2019 23:04:40 +0800
Date:   Mon, 14 Oct 2019 23:04:27 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Pankaj Sharma <pankj.sharma@samsung.com>
Cc:     kbuild-all@lists.01.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        eugen.hristev@microchip.com, ludovic.desroches@microchip.com,
        pankaj.dubey@samsung.com, rcsekar@samsung.com,
        Pankaj Sharma <pankj.sharma@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>
Subject: Re: [PATCH] can: m_can: add support for handling arbitration error
Message-ID: <201910142340.H1Itv6kZ%lkp@intel.com>
References: <1571052844-22633-1-git-send-email-pankj.sharma@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571052844-22633-1-git-send-email-pankj.sharma@samsung.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pankaj,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[cannot apply to v5.4-rc3 next-20191014]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Pankaj-Sharma/can-m_can-add-support-for-handling-arbitration-error/20191014-193532

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/can/m_can/m_can.c:783:9-10: WARNING: return of 0/1 in function 'is_protocol_err' with return type bool

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

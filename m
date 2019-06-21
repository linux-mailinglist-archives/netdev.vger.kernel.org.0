Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 858534E5EB
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 12:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfFUKa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 06:30:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:51430 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfFUKaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 06:30:55 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jun 2019 03:30:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,400,1557212400"; 
   d="scan'208";a="183373224"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 21 Jun 2019 03:30:53 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1heGom-000J0N-DA; Fri, 21 Jun 2019 18:30:52 +0800
Date:   Fri, 21 Jun 2019 18:30:45 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     kbuild-all@01.org, snelson@pensando.io, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 11/18] ionic: Add Rx filter and rx_mode nod
 support
Message-ID: <201906211828.LvKZHqqH%lkp@intel.com>
References: <20190620202424.23215-12-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620202424.23215-12-snelson@pensando.io>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shannon,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Shannon-Nelson/ionic-Add-basic-framework-for-IONIC-Network-device-driver/20190621-110046

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/pensando/ionic/ionic_lif.c:48:3-4: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

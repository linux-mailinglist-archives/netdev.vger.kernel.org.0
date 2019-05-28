Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF9C2BDCB
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 05:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbfE1Dgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 23:36:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:12919 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbfE1Dgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 23:36:49 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 20:36:49 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 27 May 2019 20:36:46 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hVSus-0003j4-Bm; Tue, 28 May 2019 11:36:46 +0800
Date:   Tue, 28 May 2019 11:36:40 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     kbuild-all@01.org, linux@armlinux.org.uk, f.fainelli@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, olteanv@gmail.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        vivien.didelot@gmail.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH 10/11] net: dsa: Use PHYLINK for the CPU/DSA ports
Message-ID: <201905281145.my9LFxun%lkp@intel.com>
References: <1558992127-26008-11-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558992127-26008-11-git-send-email-ioana.ciornei@nxp.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on v5.2-rc2 next-20190524]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Ioana-Ciornei/Decoupling-PHYLINK-from-struct-net_device/20190528-061507
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/dsa/port.c:604:5: sparse: sparse: symbol 'dsa_port_phylink_register' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

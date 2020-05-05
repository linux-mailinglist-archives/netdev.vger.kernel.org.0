Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F421C646A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 01:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgEEXWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 19:22:01 -0400
Received: from mga05.intel.com ([192.55.52.43]:7747 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbgEEXWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 19:22:01 -0400
IronPort-SDR: 44b9/rRsizEMGnQWd8Q2iV5H5oQVTLavdIAgiEdemxIYNVVDQ9EgUH67r/t+ESyI/3Chwg7h49
 fa9brIgTvvAQ==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2020 16:21:44 -0700
IronPort-SDR: TMR2CBLCcDqQLvQNrMjjQjHZxjCJtBkuOXNDdXZtrspHlg4VbSyxp98DEJOZNvBpWH9HwfIqYZ
 4Q7coydLtDtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,357,1583222400"; 
   d="gz'50?scan'50,208,50";a="263354096"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 05 May 2020 16:21:38 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jW6sb-0005mC-Cz; Wed, 06 May 2020 07:21:37 +0800
Date:   Wed, 6 May 2020 07:21:19 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     kbuild-all@lists.01.org, Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>
Subject: Re: [net-next PATCH v3 1/5] net: phy: Introduce phy related fwnode
 functions
Message-ID: <202005060726.lesGOGgH%lkp@intel.com>
References: <20200505132905.10276-2-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20200505132905.10276-2-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Calvin,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on linus/master v5.7-rc4 next-20200505]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Calvin-Johnson/Introduce-new-fwnode-based-APIs-to-support-phylink-and-phy-layers/20200506-051400
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 3e1853e4e1137ba0a4d314521d153852dbf4aff5
config: sh-allnoconfig (attached as .config)
compiler: sh4-linux-gcc (GCC) 9.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day GCC_VERSION=9.3.0 make.cross ARCH=sh 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   sh4-linux-ld: drivers/base/property.o: in function `fwnode_get_phy_node':
>> property.c:(.text+0xf4): multiple definition of `fwnode_get_phy_node'; arch/sh/kernel/cpu/sh2/setup-sh7619.o:setup-sh7619.c:(.text+0x0): first defined here

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--ZPt4rx8FFjLCG7dd
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
98EGs4rlk9seBKC0u/y/h2u2jRBUAAA=

--ZPt4rx8FFjLCG7dd--

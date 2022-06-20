Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891305526B4
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 23:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243029AbiFTVuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 17:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242723AbiFTVuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 17:50:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921C519F89
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 14:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655761810; x=1687297810;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W2hCt0J4nw3iqmim+wkUeuO2MDzkf8G2luoHgIWgieA=;
  b=CYRNrpIP5xlmrk69VGF/b+qVVDXUk4iz+1I4JAr82NubF3nuUCQJ2+Xv
   5UNUsetVHLknLu2u3TxvdK6zK9cROpZKQp7G5EbyMc+DCt2JyHzz8uwtG
   +GZFKmdbo0SnV0kRranXdd/q6dj6MXca9JixUnIItFHAXqg7X8qKwH3X4
   J8eRubrxArS+sYygLuhiIJKfiHYM2C6o39E+iCDXqgIVyf5F2+V6+Zcjj
   Cexc0NQzeU2+cWFOE9hFKOosKkdhQCCxVviB4xTgK870nu1k0+LKuEw79
   4tORd92wzPhTfrvkNgbpPNW7tnJqwoP3Ux6cW6r/rM2rGUBDUXhyxv5Tp
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="277525355"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="277525355"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 14:50:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="714754202"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 20 Jun 2022 14:50:06 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o3PHa-000WaZ-1Q;
        Mon, 20 Jun 2022 21:50:06 +0000
Date:   Tue, 21 Jun 2022 05:49:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        boon.leong.ong@intel.com, rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH net-next] net: pcs: xpcs: select PHYLINK in Kconfig
Message-ID: <202206210551.Fhz4xcTc-lkp@intel.com>
References: <20220620201915.1195280-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620201915.1195280-1-kuba@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Kicinski/net-pcs-xpcs-select-PHYLINK-in-Kconfig/20220621-042123
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git dbca1596bbb08318f5e3b3b99f8ca0a0d3830a65
config: i386-tinyconfig
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/a3120516f7ee66896bb0d3c90fe653ce0cb3a09f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jakub-Kicinski/net-pcs-xpcs-select-PHYLINK-in-Kconfig/20220621-042123
        git checkout a3120516f7ee66896bb0d3c90fe653ce0cb3a09f
        make W=1 ARCH=i386  tinyconfig
        make W=1 ARCH=i386 

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/phy/Kconfig:16:error: recursive dependency detected!
   drivers/net/phy/Kconfig:16: symbol PHYLIB is selected by PHYLINK
   drivers/net/phy/Kconfig:6: symbol PHYLINK is selected by PCS_XPCS
   drivers/net/pcs/Kconfig:8: symbol PCS_XPCS depends on MDIO_DEVICE
   drivers/net/mdio/Kconfig:6: symbol MDIO_DEVICE is selected by PHYLIB
   For a resolution refer to Documentation/kbuild/kconfig-language.rst
   subsection "Kconfig recursive dependency limitations"


vim +16 drivers/net/phy/Kconfig

00db8189d984d6 Andy Fleming        2005-07-30   5  
9525ae83959b60 Russell King        2017-07-25   6  config PHYLINK
9525ae83959b60 Russell King        2017-07-25   7  	tristate
9525ae83959b60 Russell King        2017-07-25   8  	depends on NETDEVICES
9525ae83959b60 Russell King        2017-07-25   9  	select PHYLIB
9525ae83959b60 Russell King        2017-07-25  10  	select SWPHY
9525ae83959b60 Russell King        2017-07-25  11  	help
9525ae83959b60 Russell King        2017-07-25  12  	  PHYlink models the link between the PHY and MAC, allowing fixed
9525ae83959b60 Russell King        2017-07-25  13  	  configuration links, PHYs, and Serdes links with MAC level
9525ae83959b60 Russell King        2017-07-25  14  	  autonegotiation modes.
9525ae83959b60 Russell King        2017-07-25  15  
6073512cc8e2c4 Jerome Brunet       2017-09-18 @16  menuconfig PHYLIB
9e8d438e8ba43a Florian Fainelli    2018-04-27  17  	tristate "PHY Device support and infrastructure"
6073512cc8e2c4 Jerome Brunet       2017-09-18  18  	depends on NETDEVICES
6073512cc8e2c4 Jerome Brunet       2017-09-18  19  	select MDIO_DEVICE
1814cff26739de Bartosz Golaszewski 2020-07-05  20  	select MDIO_DEVRES
6073512cc8e2c4 Jerome Brunet       2017-09-18  21  	help
6073512cc8e2c4 Jerome Brunet       2017-09-18  22  	  Ethernet controllers are usually attached to PHY
6073512cc8e2c4 Jerome Brunet       2017-09-18  23  	  devices.  This option provides infrastructure for
6073512cc8e2c4 Jerome Brunet       2017-09-18  24  	  managing PHY devices.
6073512cc8e2c4 Jerome Brunet       2017-09-18  25  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

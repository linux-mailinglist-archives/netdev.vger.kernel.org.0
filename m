Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02023550243
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383937AbiFRDDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiFRDDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:03:08 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDA16C578;
        Fri, 17 Jun 2022 20:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655521387; x=1687057387;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=u1YpkbtOcUOCaYwksF0M3zdyzUGActOf3AeMErr9Tsk=;
  b=ArW/IIczv2XGxlozAANxXDL6PPCNB+oCYKzP2HIj7WmSiAlvn/2nHlOP
   4th71OUf4JvIE6RfkHT6yFYkHDk0MfGDaysKJMBI6s+BR1STCdfgB0Dfj
   7JJqKaDustYyItQPn0IkHAjQnK7xYVSI/cWx+TK65n4HtTkvojVmETNtm
   oTMJi2IMjnSWWfXIieFyZ4UrZaJ8yBI/IMbzrWDGPJ8prhUWmumXwU3lp
   KaX+7P+noG7tUupOkuMALsFjx8oUVWNautvkchNmtFWWt91G98Sn3gpOa
   hyWKk/+Q8ouI9k3Br5aW2stc1UXReW0Hh/anfKh846DiPNZV16bcjDdLq
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="343615138"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="343615138"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 20:03:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="653869079"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jun 2022 20:03:03 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o2Ojm-000PyF-Bw;
        Sat, 18 Jun 2022 03:03:02 +0000
Date:   Sat, 18 Jun 2022 11:02:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org
Subject: Re: [PATCH net-next 03/28] phy: fsl: Add QorIQ SerDes driver
Message-ID: <202206181015.BLEIZObf-lkp@intel.com>
References: <20220617203312.3799646-4-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617203312.3799646-4-sean.anderson@seco.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Sean-Anderson/net-dpaa-Convert-to-phylink/20220618-044003
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 4875d94c69d5a4836c4225b51429d277c297aae8
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20220618/202206181015.BLEIZObf-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d9c7b1e909ace0c4229445647587ae1f64cf52c0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sean-Anderson/net-dpaa-Convert-to-phylink/20220618-044003
        git checkout d9c7b1e909ace0c4229445647587ae1f64cf52c0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash drivers/net/ethernet/freescale/fman/ drivers/phy/freescale/ net/ipv6/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/phy/freescale/phy-qoriq.c:382:16: warning: no previous prototype for 'qs_clk_hw_to_priv' [-Wmissing-prototypes]
     382 | struct qs_clk *qs_clk_hw_to_priv(struct clk_hw *hw)
         |                ^~~~~~~~~~~~~~~~~


vim +/qs_clk_hw_to_priv +382 drivers/phy/freescale/phy-qoriq.c

   381	
 > 382	struct qs_clk *qs_clk_hw_to_priv(struct clk_hw *hw)
   383	{
   384		return container_of(hw, struct qs_clk, hw);
   385	}
   386	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

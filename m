Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786F53D4473
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 04:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhGXCII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 22:08:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:15285 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233358AbhGXCII (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 22:08:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10054"; a="233828263"
X-IronPort-AV: E=Sophos;i="5.84,265,1620716400"; 
   d="scan'208";a="233828263"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2021 19:48:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,265,1620716400"; 
   d="scan'208";a="471737085"
Received: from lkp-server01.sh.intel.com (HELO d053b881505b) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 23 Jul 2021 19:48:35 -0700
Received: from kbuild by d053b881505b with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1m77iN-0002ik-A9; Sat, 24 Jul 2021 02:48:35 +0000
Date:   Sat, 24 Jul 2021 10:48:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v14 2/3] dt-bindings: net: Add bindings for
 AX88796C SPI Ethernet Adapter
Message-ID: <202107241054.gJYNnMtG-lkp@intel.com>
References: <20210719192852.27404-3-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210719192852.27404-3-l.stelmach@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi "Łukasz,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/ukasz-Stelmach/dt-bindings-vendor-prefixes-Add-asix-prefix/20210720-144740
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 0d6835ffe50c9c1f098b5704394331710b67af48
compiler: arm-linux-gnueabi-gcc (GCC) 10.3.0
reproduce: make ARCH=arm dtbs_check

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


dtcheck warnings: (new ones prefixed by >>)
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/i2c@13860000/pmic@66: failed to match any schema with compatible: ['samsung,s2mps14-pmic']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/i2c@13860000/pmic@66/clocks: failed to match any schema with compatible: ['samsung,s2mps14-clk']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/i2c@13870000: failed to match any schema with compatible: ['samsung,s3c2440-i2c']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/i2c@13880000: failed to match any schema with compatible: ['samsung,s3c2440-i2c']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/i2c@13890000: failed to match any schema with compatible: ['samsung,s3c2440-i2c']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/i2c@138a0000: failed to match any schema with compatible: ['samsung,s3c2440-i2c']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/i2c@138b0000: failed to match any schema with compatible: ['samsung,s3c2440-i2c']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/i2c@138c0000: failed to match any schema with compatible: ['samsung,s3c2440-i2c']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/i2c@138d0000: failed to match any schema with compatible: ['samsung,s3c2440-i2c']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/spi@13920000: failed to match any schema with compatible: ['samsung,exynos4210-spi']
>> arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml: ethernet@0: 'controller-data' does not match any of the regexes: 'pinctrl-[0-9]+'
   	From schema: Documentation/devicetree/bindings/net/asix,ax88796c.yaml
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/spi@13930000: failed to match any schema with compatible: ['samsung,exynos4210-spi']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/ppmu@106a0000: failed to match any schema with compatible: ['samsung,exynos-ppmu']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/ppmu@106b0000: failed to match any schema with compatible: ['samsung,exynos-ppmu']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/ppmu@106c0000: failed to match any schema with compatible: ['samsung,exynos-ppmu']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/ppmu@112a0000: failed to match any schema with compatible: ['samsung,exynos-ppmu']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/ppmu@116a0000: failed to match any schema with compatible: ['samsung,exynos-ppmu']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/ppmu@11ac0000: failed to match any schema with compatible: ['samsung,exynos-ppmu']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/ppmu@11e40000: failed to match any schema with compatible: ['samsung,exynos-ppmu']
   arch/arm/boot/dts/exynos3250-artik5-eval.dt.yaml:0:0: /soc/ppmu@12630000: failed to match any schema with compatible: ['samsung,exynos-ppmu']

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

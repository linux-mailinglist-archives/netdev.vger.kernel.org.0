Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE5A51B85
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 21:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbfFXTkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 15:40:22 -0400
Received: from mga18.intel.com ([134.134.136.126]:32540 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfFXTkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 15:40:22 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jun 2019 12:40:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,413,1557212400"; 
   d="scan'208";a="161696199"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 24 Jun 2019 12:40:19 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hfUp9-000Brn-3P; Tue, 25 Jun 2019 03:40:19 +0800
Date:   Tue, 25 Jun 2019 03:39:47 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Marek Vasut <marex@denx.de>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: Re: [PATCH V3 07/10] net: dsa: microchip: Initial SPI regmap support
Message-ID: <201906250307.M3Y3iuDk%lkp@intel.com>
References: <20190623223508.2713-8-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623223508.2713-8-marex@denx.de>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[also build test WARNING on v5.2-rc6 next-20190621]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Marek-Vasut/net-dsa-microchip-Convert-to-regmap/20190625-021215
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/dsa/microchip/ksz9477_spi.c:44:9: sparse: sparse: incorrect type in initializer (different base types) @@    expected unsigned long read_flag_mask @@    got restricted __beunsigned long read_flag_mask @@
>> drivers/net/dsa/microchip/ksz9477_spi.c:44:9: sparse:    expected unsigned long read_flag_mask
   drivers/net/dsa/microchip/ksz9477_spi.c:44:9: sparse:    got restricted __be32 [usertype]
>> drivers/net/dsa/microchip/ksz9477_spi.c:44:9: sparse: sparse: incorrect type in initializer (different base types) @@    expected unsigned long write_flag_mask @@    got restricted __beunsigned long write_flag_mask @@
>> drivers/net/dsa/microchip/ksz9477_spi.c:44:9: sparse:    expected unsigned long write_flag_mask
   drivers/net/dsa/microchip/ksz9477_spi.c:44:9: sparse:    got restricted __be32 [usertype]
   drivers/net/dsa/microchip/ksz9477_spi.c:45:9: sparse: sparse: incorrect type in initializer (different base types) @@    expected unsigned long read_flag_mask @@    got restricted __beunsigned long read_flag_mask @@
   drivers/net/dsa/microchip/ksz9477_spi.c:45:9: sparse:    expected unsigned long read_flag_mask
   drivers/net/dsa/microchip/ksz9477_spi.c:45:9: sparse:    got restricted __be32 [usertype]
   drivers/net/dsa/microchip/ksz9477_spi.c:45:9: sparse: sparse: incorrect type in initializer (different base types) @@    expected unsigned long write_flag_mask @@    got restricted __beunsigned long write_flag_mask @@
   drivers/net/dsa/microchip/ksz9477_spi.c:45:9: sparse:    expected unsigned long write_flag_mask
   drivers/net/dsa/microchip/ksz9477_spi.c:45:9: sparse:    got restricted __be32 [usertype]
   drivers/net/dsa/microchip/ksz9477_spi.c:46:9: sparse: sparse: incorrect type in initializer (different base types) @@    expected unsigned long read_flag_mask @@    got restricted __beunsigned long read_flag_mask @@
   drivers/net/dsa/microchip/ksz9477_spi.c:46:9: sparse:    expected unsigned long read_flag_mask
   drivers/net/dsa/microchip/ksz9477_spi.c:46:9: sparse:    got restricted __be32 [usertype]
   drivers/net/dsa/microchip/ksz9477_spi.c:46:9: sparse: sparse: incorrect type in initializer (different base types) @@    expected unsigned long write_flag_mask @@    got restricted __beunsigned long write_flag_mask @@
   drivers/net/dsa/microchip/ksz9477_spi.c:46:9: sparse:    expected unsigned long write_flag_mask
   drivers/net/dsa/microchip/ksz9477_spi.c:46:9: sparse:    got restricted __be32 [usertype]
   drivers/net/dsa/microchip/ksz9477_spi.c:52:31: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected struct regmap *map @@    got sstruct regmap *map @@
   drivers/net/dsa/microchip/ksz9477_spi.c:52:31: sparse:    expected struct regmap *map
   drivers/net/dsa/microchip/ksz9477_spi.c:52:31: sparse:    got struct regmap **
   drivers/net/dsa/microchip/ksz9477_spi.c:60:36: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected struct regmap *map @@    got sstruct regmap *map @@
   drivers/net/dsa/microchip/ksz9477_spi.c:60:36: sparse:    expected struct regmap *map
   drivers/net/dsa/microchip/ksz9477_spi.c:60:36: sparse:    got struct regmap **
   drivers/net/dsa/microchip/ksz9477_spi.c:63:24: sparse: sparse: cast to restricted __be16
   drivers/net/dsa/microchip/ksz9477_spi.c:63:24: sparse: sparse: cast to restricted __be16
   drivers/net/dsa/microchip/ksz9477_spi.c:63:24: sparse: sparse: cast to restricted __be16
   drivers/net/dsa/microchip/ksz9477_spi.c:63:24: sparse: sparse: cast to restricted __be16
   drivers/net/dsa/microchip/ksz9477_spi.c:70:36: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected struct regmap *map @@    got sstruct regmap *map @@
   drivers/net/dsa/microchip/ksz9477_spi.c:70:36: sparse:    expected struct regmap *map
   drivers/net/dsa/microchip/ksz9477_spi.c:70:36: sparse:    got struct regmap **
   drivers/net/dsa/microchip/ksz9477_spi.c:73:24: sparse: sparse: cast to restricted __be32
   drivers/net/dsa/microchip/ksz9477_spi.c:73:24: sparse: sparse: cast to restricted __be32
   drivers/net/dsa/microchip/ksz9477_spi.c:73:24: sparse: sparse: cast to restricted __be32
   drivers/net/dsa/microchip/ksz9477_spi.c:73:24: sparse: sparse: cast to restricted __be32
   drivers/net/dsa/microchip/ksz9477_spi.c:73:24: sparse: sparse: cast to restricted __be32
   drivers/net/dsa/microchip/ksz9477_spi.c:73:24: sparse: sparse: cast to restricted __be32
   drivers/net/dsa/microchip/ksz9477_spi.c:80:29: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected struct regmap *map @@    got sstruct regmap *map @@
   drivers/net/dsa/microchip/ksz9477_spi.c:80:29: sparse:    expected struct regmap *map
   drivers/net/dsa/microchip/ksz9477_spi.c:80:29: sparse:    got struct regmap **
   drivers/net/dsa/microchip/ksz9477_spi.c:85:15: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] value @@    got resunsigned short [usertype] value @@
   drivers/net/dsa/microchip/ksz9477_spi.c:85:15: sparse:    expected unsigned short [usertype] value
   drivers/net/dsa/microchip/ksz9477_spi.c:85:15: sparse:    got restricted __be16 [usertype]
   drivers/net/dsa/microchip/ksz9477_spi.c:86:34: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected struct regmap *map @@    got sstruct regmap *map @@
   drivers/net/dsa/microchip/ksz9477_spi.c:86:34: sparse:    expected struct regmap *map
   drivers/net/dsa/microchip/ksz9477_spi.c:86:34: sparse:    got struct regmap **
   drivers/net/dsa/microchip/ksz9477_spi.c:91:15: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] value @@    got restrunsigned int [usertype] value @@
   drivers/net/dsa/microchip/ksz9477_spi.c:91:15: sparse:    expected unsigned int [usertype] value
   drivers/net/dsa/microchip/ksz9477_spi.c:91:15: sparse:    got restricted __be32 [usertype]
   drivers/net/dsa/microchip/ksz9477_spi.c:92:34: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected struct regmap *map @@    got sstruct regmap *map @@
   drivers/net/dsa/microchip/ksz9477_spi.c:92:34: sparse:    expected struct regmap *map
   drivers/net/dsa/microchip/ksz9477_spi.c:92:34: sparse:    got struct regmap **

vim +44 drivers/net/dsa/microchip/ksz9477_spi.c

    25	
    26	#define KS_SPIOP_FLAG_MASK(opcode)		\
    27		cpu_to_be32((opcode) << (SPI_ADDR_SHIFT + SPI_TURNAROUND_SHIFT))
    28	
    29	#define KSZ_REGMAP_COMMON(width)					\
    30		{								\
    31			.val_bits = (width),					\
    32			.reg_stride = (width) / 8,				\
    33			.reg_bits = SPI_ADDR_SHIFT + SPI_ADDR_ALIGN,		\
    34			.pad_bits = SPI_TURNAROUND_SHIFT,			\
    35			.max_register = BIT(SPI_ADDR_SHIFT) - 1,		\
    36			.cache_type = REGCACHE_NONE,				\
    37			.read_flag_mask = KS_SPIOP_FLAG_MASK(KS_SPIOP_RD),	\
    38			.write_flag_mask = KS_SPIOP_FLAG_MASK(KS_SPIOP_WR),	\
    39			.reg_format_endian = REGMAP_ENDIAN_BIG,			\
    40			.val_format_endian = REGMAP_ENDIAN_BIG			\
    41		}
    42	
    43	static const struct regmap_config ksz9477_regmap_config[] = {
  > 44		KSZ_REGMAP_COMMON(8),
    45		KSZ_REGMAP_COMMON(16),
    46		KSZ_REGMAP_COMMON(32),
    47	};
    48	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

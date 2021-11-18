Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0F24554AA
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 07:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243305AbhKRGTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 01:19:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:20307 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243299AbhKRGTk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 01:19:40 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="257901148"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="gz'50?scan'50,208,50";a="257901148"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 22:16:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="gz'50?scan'50,208,50";a="507290566"
Received: from lkp-server02.sh.intel.com (HELO c20d8bc80006) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 17 Nov 2021 22:16:37 -0800
Received: from kbuild by c20d8bc80006 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mnaiq-0002lL-7x; Thu, 18 Nov 2021 06:16:36 +0000
Date:   Thu, 18 Nov 2021 14:15:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 5/9] net: constify netdev->dev_addr
Message-ID: <202111181418.kYTharVo-lkp@intel.com>
References: <20211118041501.3102861-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <20211118041501.3102861-6-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jakub,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Jakub-Kicinski/net-constify-netdev-dev_addr/20211118-121649
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 75082e7f46809432131749f4ecea66864d0f7438
config: m68k-defconfig (attached as .config)
compiler: m68k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/ea5373ba01c0915c0dceb67e2df2b05343642b84
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jakub-Kicinski/net-constify-netdev-dev_addr/20211118-121649
        git checkout ea5373ba01c0915c0dceb67e2df2b05343642b84
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross ARCH=m68k 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/8390/mac8390.c: In function 'mac8390_rsrc_init':
>> drivers/net/ethernet/8390/mac8390.c:317:31: warning: passing argument 1 of 'nubus_get_rsrc_mem' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     317 |         nubus_get_rsrc_mem(dev->dev_addr, &ent, 6);
         |                            ~~~^~~~~~~~~~
   In file included from drivers/net/ethernet/8390/mac8390.c:29:
   include/linux/nubus.h:156:31: note: expected 'void *' but argument is of type 'const unsigned char *'
     156 | void nubus_get_rsrc_mem(void *dest, const struct nubus_dirent *dirent,
         |                         ~~~~~~^~~~
--
   drivers/net/ethernet/amd/atarilance.c:370:28: warning: no previous prototype for 'atarilance_probe' [-Wmissing-prototypes]
     370 | struct net_device * __init atarilance_probe(void)
         |                            ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/amd/atarilance.c: In function 'lance_probe1':
>> drivers/net/ethernet/amd/atarilance.c:588:33: warning: passing argument 1 of 'lp->memcpy_f' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     588 |                 lp->memcpy_f(dev->dev_addr, RIEBL_HWADDR_ADDR, ETH_ALEN);
         |                              ~~~^~~~~~~~~~
   drivers/net/ethernet/amd/atarilance.c:588:33: note: expected 'void *' but argument is of type 'const unsigned char *'
   drivers/net/ethernet/amd/atarilance.c:593:42: error: assignment of read-only location '*(dev->dev_addr + (sizetype)i)'
     593 |                         dev->dev_addr[i] =
         |                                          ^
--
   drivers/net/ethernet/apple/macmace.c: In function 'mace_probe':
   drivers/net/ethernet/apple/macmace.c:232:34: error: assignment of read-only location '*(dev->dev_addr + (sizetype)j)'
     232 |                 dev->dev_addr[j] = v;
         |                                  ^
   drivers/net/ethernet/apple/macmace.c: In function 'mace_reset':
>> drivers/net/ethernet/apple/macmace.c:294:36: warning: passing argument 2 of '__mace_set_address' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     294 |         __mace_set_address(dev, dev->dev_addr);
         |                                 ~~~^~~~~~~~~~
   drivers/net/ethernet/apple/macmace.c:95:62: note: expected 'void *' but argument is of type 'const unsigned char *'
      95 | static void __mace_set_address(struct net_device *dev, void *addr);
         |                                                        ~~~~~~^~~~
   drivers/net/ethernet/apple/macmace.c: In function '__mace_set_address':
   drivers/net/ethernet/apple/macmace.c:334:45: error: assignment of read-only location '*(dev->dev_addr + (sizetype)i)'
     334 |                 mb->padr = dev->dev_addr[i] = p[i];
         |                                             ^
--
   drivers/net/ethernet/natsemi/macsonic.c: In function 'mac_onboard_sonic_ethernet_addr':
   drivers/net/ethernet/natsemi/macsonic.c:216:42: error: assignment of read-only location '*(dev->dev_addr + (sizetype)i)'
     216 |                         dev->dev_addr[i] = SONIC_READ_PROM(i);
         |                                          ^
>> drivers/net/ethernet/natsemi/macsonic.c:225:37: warning: passing argument 1 of 'bit_reverse_addr' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     225 |                 bit_reverse_addr(dev->dev_addr);
         |                                  ~~~^~~~~~~~~~
   drivers/net/ethernet/natsemi/macsonic.c:109:51: note: expected 'unsigned char *' but argument is of type 'const unsigned char *'
     109 | static inline void bit_reverse_addr(unsigned char addr[6])
         |                                     ~~~~~~~~~~~~~~^~~~~~~
   drivers/net/ethernet/natsemi/macsonic.c:246:26: error: assignment of read-only location '*(dev->dev_addr + 5)'
     246 |         dev->dev_addr[5] = val >> 8;
         |                          ^
   drivers/net/ethernet/natsemi/macsonic.c:247:26: error: assignment of read-only location '*(dev->dev_addr + 4)'
     247 |         dev->dev_addr[4] = val & 0xff;
         |                          ^
   drivers/net/ethernet/natsemi/macsonic.c:249:26: error: assignment of read-only location '*(dev->dev_addr + 3)'
     249 |         dev->dev_addr[3] = val >> 8;
         |                          ^
   drivers/net/ethernet/natsemi/macsonic.c:250:26: error: assignment of read-only location '*(dev->dev_addr + 2)'
     250 |         dev->dev_addr[2] = val & 0xff;
         |                          ^
   drivers/net/ethernet/natsemi/macsonic.c:252:26: error: assignment of read-only location '*(dev->dev_addr + 1)'
     252 |         dev->dev_addr[1] = val >> 8;
         |                          ^
   drivers/net/ethernet/natsemi/macsonic.c:253:26: error: assignment of read-only location '*dev->dev_addr'
     253 |         dev->dev_addr[0] = val & 0xff;
         |                          ^
   drivers/net/ethernet/natsemi/macsonic.c: In function 'mac_sonic_nubus_ethernet_addr':
   drivers/net/ethernet/natsemi/macsonic.c:360:34: error: assignment of read-only location '*(dev->dev_addr + (sizetype)i)'
     360 |                 dev->dev_addr[i] = SONIC_READ_PROM(i);
         |                                  ^
   drivers/net/ethernet/natsemi/macsonic.c:364:37: warning: passing argument 1 of 'bit_reverse_addr' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     364 |                 bit_reverse_addr(dev->dev_addr);
         |                                  ~~~^~~~~~~~~~
   drivers/net/ethernet/natsemi/macsonic.c:109:51: note: expected 'unsigned char *' but argument is of type 'const unsigned char *'
     109 | static inline void bit_reverse_addr(unsigned char addr[6])
         |                                     ~~~~~~~~~~~~~~^~~~~~~


vim +317 drivers/net/ethernet/8390/mac8390.c

^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  285  
494a973e229542 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  286  static bool mac8390_rsrc_init(struct net_device *dev,
494a973e229542 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  287  			      struct nubus_rsrc *fres,
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  288  			      enum mac8390_type cardtype)
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  289  {
494a973e229542 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  290  	struct nubus_board *board = fres->board;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  291  	struct nubus_dir dir;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  292  	struct nubus_dirent ent;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  293  	int offset;
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  294  	volatile unsigned short *i;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  295  
494a973e229542 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  296  	dev->irq = SLOT2IRQ(board->slot);
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  297  	/* This is getting to be a habit */
494a973e229542 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  298  	dev->base_addr = board->slot_addr | ((board->slot & 0xf) << 20);
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  299  
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  300  	/*
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  301  	 * Get some Nubus info - we will trust the card's idea
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  302  	 * of where its memory and registers are.
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  303  	 */
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  304  
494a973e229542 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  305  	if (nubus_get_func_dir(fres, &dir) == -1) {
4a1b27c9e32c39 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  306  		dev_err(&board->dev,
4a1b27c9e32c39 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  307  			"Unable to get Nubus functional directory\n");
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  308  		return false;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  309  	}
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  310  
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  311  	/* Get the MAC address */
8e4d9696b45d96 drivers/net/mac8390.c               Joe Perches    2010-01-04  312  	if (nubus_find_rsrc(&dir, NUBUS_RESID_MAC_ADDRESS, &ent) == -1) {
4a1b27c9e32c39 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  313  		dev_info(&board->dev, "MAC address resource not found\n");
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  314  		return false;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  315  	}
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  316  
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04 @317  	nubus_get_rsrc_mem(dev->dev_addr, &ent, 6);
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  318  
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  319  	if (useresources[cardtype] == 1) {
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  320  		nubus_rewinddir(&dir);
8e4d9696b45d96 drivers/net/mac8390.c               Joe Perches    2010-01-04  321  		if (nubus_find_rsrc(&dir, NUBUS_RESID_MINOR_BASEOS,
8e4d9696b45d96 drivers/net/mac8390.c               Joe Perches    2010-01-04  322  				    &ent) == -1) {
4a1b27c9e32c39 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  323  			dev_err(&board->dev,
4a1b27c9e32c39 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  324  				"Memory offset resource not found\n");
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  325  			return false;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  326  		}
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  327  		nubus_get_rsrc_mem(&offset, &ent, 4);
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  328  		dev->mem_start = dev->base_addr + offset;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  329  		/* yes, this is how the Apple driver does it */
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  330  		dev->base_addr = dev->mem_start + 0x10000;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  331  		nubus_rewinddir(&dir);
8e4d9696b45d96 drivers/net/mac8390.c               Joe Perches    2010-01-04  332  		if (nubus_find_rsrc(&dir, NUBUS_RESID_MINOR_LENGTH,
8e4d9696b45d96 drivers/net/mac8390.c               Joe Perches    2010-01-04  333  				    &ent) == -1) {
4a1b27c9e32c39 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  334  			dev_info(&board->dev,
4a1b27c9e32c39 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  335  				 "Memory length resource not found, probing\n");
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  336  			offset = mac8390_memsize(dev->mem_start);
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  337  		} else {
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  338  			nubus_get_rsrc_mem(&offset, &ent, 4);
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  339  		}
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  340  		dev->mem_end = dev->mem_start + offset;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  341  	} else {
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  342  		switch (cardtype) {
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  343  		case MAC8390_KINETICS:
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  344  		case MAC8390_DAYNA: /* it's the same */
494a973e229542 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  345  			dev->base_addr = (int)(board->slot_addr +
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  346  					       DAYNA_8390_BASE);
494a973e229542 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  347  			dev->mem_start = (int)(board->slot_addr +
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  348  					       DAYNA_8390_MEM);
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  349  			dev->mem_end = dev->mem_start +
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  350  				       mac8390_memsize(dev->mem_start);
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  351  			break;
2964db0f590437 drivers/net/mac8390.c               Finn Thain     2007-05-01  352  		case MAC8390_INTERLAN:
494a973e229542 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  353  			dev->base_addr = (int)(board->slot_addr +
2964db0f590437 drivers/net/mac8390.c               Finn Thain     2007-05-01  354  					       INTERLAN_8390_BASE);
494a973e229542 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  355  			dev->mem_start = (int)(board->slot_addr +
2964db0f590437 drivers/net/mac8390.c               Finn Thain     2007-05-01  356  					       INTERLAN_8390_MEM);
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  357  			dev->mem_end = dev->mem_start +
2964db0f590437 drivers/net/mac8390.c               Finn Thain     2007-05-01  358  				       mac8390_memsize(dev->mem_start);
2964db0f590437 drivers/net/mac8390.c               Finn Thain     2007-05-01  359  			break;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  360  		case MAC8390_CABLETRON:
494a973e229542 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  361  			dev->base_addr = (int)(board->slot_addr +
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  362  					       CABLETRON_8390_BASE);
494a973e229542 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  363  			dev->mem_start = (int)(board->slot_addr +
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  364  					       CABLETRON_8390_MEM);
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  365  			/* The base address is unreadable if 0x00
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  366  			 * has been written to the command register
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  367  			 * Reset the chip by writing E8390_NODMA +
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  368  			 *   E8390_PAGE0 + E8390_STOP just to be
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  369  			 *   sure
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  370  			 */
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  371  			i = (void *)dev->base_addr;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  372  			*i = 0x21;
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  373  			dev->mem_end = dev->mem_start +
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  374  				       mac8390_memsize(dev->mem_start);
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  375  			break;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  376  
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  377  		default:
4a1b27c9e32c39 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  378  			dev_err(&board->dev,
4a1b27c9e32c39 drivers/net/ethernet/8390/mac8390.c Finn Thain     2018-02-18  379  				"No known base address for card type\n");
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  380  			return false;
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  381  		}
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  382  	}
^1da177e4c3f41 drivers/net/mac8390.c               Linus Torvalds 2005-04-16  383  
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  384  	return true;
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  385  }
f6de7acc42de90 drivers/net/mac8390.c               Joe Perches    2010-01-04  386  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--k+w/mQv8wyuph6w0
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--k+w/mQv8wyuph6w0--

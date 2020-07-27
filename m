Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C1B22F5CD
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbgG0Quu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:50:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:19980 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbgG0Quu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 12:50:50 -0400
IronPort-SDR: 5MI3maV2M/ttCOptotsoC+PMqjwqDjwcjJcUNoVZjYskb5STNwChwofKYM2/oE9opEljY5ffzP
 gsxUhIjTj2rw==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="139100671"
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="gz'50?scan'50,208,50";a="139100671"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 09:50:44 -0700
IronPort-SDR: GxP2qgPDXqLbyT7tdi0Oz8Wa4SuMgREpL26/GmJRS5XBXFpmQRS7OsJ52bHoEASfLdkEYmH5KL
 wn5v+PyPVCjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="gz'50?scan'50,208,50";a="285829753"
Received: from lkp-server01.sh.intel.com (HELO df0563f96c37) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 27 Jul 2020 09:50:40 -0700
Received: from kbuild by df0563f96c37 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1k06Kl-0001yR-R5; Mon, 27 Jul 2020 16:50:39 +0000
Date:   Tue, 28 Jul 2020 00:50:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Ooi, Joyce" <joyce.ooi@intel.com>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>
Subject: Re: [PATCH v5 08/10] net: eth: altera: add support for ptp and
 timestamping
Message-ID: <202007280056.OcpsOhB7%lkp@intel.com>
References: <20200727092157.115937-9-joyce.ooi@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20200727092157.115937-9-joyce.ooi@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Joyce",

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master robh/for-next linus/master v5.8-rc7 next-20200727]
[cannot apply to sparc-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Ooi-Joyce/net-eth-altera-tse-Add-PTP-and-mSGDMA-prefetcher/20200727-173217
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git a57066b1a01977a646145f4ce8dfb4538b08368a
config: nios2-randconfig-s032-20200727 (attached as .config)
compiler: nios2-linux-gcc (GCC) 9.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.2-94-geb6779f6-dirty
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=nios2 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/altera/intel_fpga_tod.c:334:55: sparse: sparse: Using plain integer as NULL pointer
   drivers/net/ethernet/altera/intel_fpga_tod.c: note: in included file (through arch/nios2/include/asm/io.h, include/linux/io.h, arch/nios2/include/asm/pgtable.h, ...):
   include/asm-generic/io.h:225:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   include/asm-generic/io.h:225:22: sparse:     expected unsigned int [usertype] value
   include/asm-generic/io.h:225:22: sparse:     got restricted __le32 [usertype]
   include/asm-generic/io.h:225:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   include/asm-generic/io.h:225:22: sparse:     expected unsigned int [usertype] value
   include/asm-generic/io.h:225:22: sparse:     got restricted __le32 [usertype]
   include/asm-generic/io.h:179:15: sparse: sparse: cast to restricted __le32
   include/asm-generic/io.h:179:15: sparse: sparse: cast to restricted __le32
   include/asm-generic/io.h:179:15: sparse: sparse: cast to restricted __le32
   include/asm-generic/io.h:179:15: sparse: sparse: cast to restricted __le32
   include/asm-generic/io.h:225:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   include/asm-generic/io.h:225:22: sparse:     expected unsigned int [usertype] value
   include/asm-generic/io.h:225:22: sparse:     got restricted __le32 [usertype]
   include/asm-generic/io.h:225:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   include/asm-generic/io.h:225:22: sparse:     expected unsigned int [usertype] value
   include/asm-generic/io.h:225:22: sparse:     got restricted __le32 [usertype]
   include/asm-generic/io.h:225:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   include/asm-generic/io.h:225:22: sparse:     expected unsigned int [usertype] value
   include/asm-generic/io.h:225:22: sparse:     got restricted __le32 [usertype]
   include/asm-generic/io.h:225:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   include/asm-generic/io.h:225:22: sparse:     expected unsigned int [usertype] value
   include/asm-generic/io.h:225:22: sparse:     got restricted __le32 [usertype]
   include/asm-generic/io.h:225:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   include/asm-generic/io.h:225:22: sparse:     expected unsigned int [usertype] value
   include/asm-generic/io.h:225:22: sparse:     got restricted __le32 [usertype]
   include/asm-generic/io.h:225:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   include/asm-generic/io.h:225:22: sparse:     expected unsigned int [usertype] value
   include/asm-generic/io.h:225:22: sparse:     got restricted __le32 [usertype]
   include/asm-generic/io.h:225:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   include/asm-generic/io.h:225:22: sparse:     expected unsigned int [usertype] value
   include/asm-generic/io.h:225:22: sparse:     got restricted __le32 [usertype]
   include/asm-generic/io.h:225:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   include/asm-generic/io.h:225:22: sparse:     expected unsigned int [usertype] value
   include/asm-generic/io.h:225:22: sparse:     got restricted __le32 [usertype]
   include/asm-generic/io.h:179:15: sparse: sparse: cast to restricted __le32
   include/asm-generic/io.h:179:15: sparse: sparse: cast to restricted __le32
   include/asm-generic/io.h:179:15: sparse: sparse: cast to restricted __le32
   include/asm-generic/io.h:179:15: sparse: sparse: cast to restricted __le32
   include/asm-generic/io.h:225:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   include/asm-generic/io.h:225:22: sparse:     expected unsigned int [usertype] value
   include/asm-generic/io.h:225:22: sparse:     got restricted __le32 [usertype]
   include/asm-generic/io.h:225:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   include/asm-generic/io.h:225:22: sparse:     expected unsigned int [usertype] value
   include/asm-generic/io.h:225:22: sparse:     got restricted __le32 [usertype]
   include/asm-generic/io.h:225:22: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 [usertype] @@
   include/asm-generic/io.h:225:22: sparse:     expected unsigned int [usertype] value
   include/asm-generic/io.h:225:22: sparse:     got restricted __le32 [usertype]

vim +334 drivers/net/ethernet/altera/intel_fpga_tod.c

   306	
   307	/* Common PTP probe function */
   308	int intel_fpga_tod_probe(struct platform_device *pdev,
   309				 struct intel_fpga_tod_private *priv)
   310	{
   311		struct resource *ptp_res;
   312		int ret = -ENODEV;
   313	
   314		priv->dev = (struct net_device *)platform_get_drvdata(pdev);
   315	
   316		/* Time-of-Day (ToD) Clock address space */
   317		ret = request_and_map(pdev, "tod_ctrl", &ptp_res,
   318				      (void __iomem **)&priv->tod_ctrl);
   319		if (ret)
   320			goto err;
   321	
   322		dev_info(&pdev->dev, "\tTOD Ctrl at 0x%08lx\n",
   323			 (unsigned long)ptp_res->start);
   324	
   325		/* Time-of-Day (ToD) Clock period clock */
   326		priv->tod_clk = devm_clk_get(&pdev->dev, "tod_clk");
   327		if (IS_ERR(priv->tod_clk)) {
   328			dev_err(&pdev->dev, "cannot obtain ToD period clock\n");
   329			ret = -ENXIO;
   330			goto err;
   331		}
   332	
   333		/* Initialize the hardware clock to zero */
 > 334		intel_fpga_tod_set_time(&priv->ptp_clock_ops, 0);
   335	
   336		spin_lock_init(&priv->tod_lock);
   337	err:
   338		return ret;
   339	}
   340	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--cWoXeonUoKmBZSoM
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
8uBYeo5Uyqz8HwCvoy3mXQEA

--cWoXeonUoKmBZSoM--

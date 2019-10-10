Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1175BD2603
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387786AbfJJJOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:14:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:54140 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733250AbfJJJOH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 05:14:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 02:14:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,279,1566889200"; 
   d="gz'50?scan'50,208,50";a="206029697"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 10 Oct 2019 02:14:02 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iIUWH-0003x0-Q4; Thu, 10 Oct 2019 17:14:01 +0800
Date:   Thu, 10 Oct 2019 17:13:52 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     kbuild-all@01.org, outreachy-kernel@googlegroups.com,
        devel@driverdev.osuosl.org, grekh@linuxfoundation.org,
        Jules Irenge <jbi.octave@gmail.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Fix multiple assignments warning by
 splitting the assignement into two each
Message-ID: <201910101600.r5l9ypVd%lkp@intel.com>
References: <20191009201029.7051-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ztueu6g6l3fgc4bd"
Content-Disposition: inline
In-Reply-To: <20191009201029.7051-1-jbi.octave@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ztueu6g6l3fgc4bd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jules,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on staging/staging-testing]

url:    https://github.com/0day-ci/linux/commits/Jules-Irenge/staging-qlge-Fix-multiple-assignments-warning-by-splitting-the-assignement-into-two-each/20191010-141520
config: x86_64-randconfig-g004-201940 (attached as .config)
compiler: gcc-7 (Debian 7.4.0-13) 7.4.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/staging/qlge/qlge_dbg.c: In function 'ql_get_serdes_regs':
>> drivers/staging/qlge/qlge_dbg.c:150:2: error: expected ';' before 'status'
     status = ql_read_other_func_serdes_reg(qdev,
     ^~~~~~

vim +150 drivers/staging/qlge/qlge_dbg.c

a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  134  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  135  static int ql_get_serdes_regs(struct ql_adapter *qdev,
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  136  				struct ql_mpi_coredump *mpi_coredump)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  137  {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  138  	int status;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  139  	unsigned int xfi_direct_valid, xfi_indirect_valid, xaui_direct_valid;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  140  	unsigned int xaui_indirect_valid, i;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  141  	u32 *direct_ptr, temp;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  142  	u32 *indirect_ptr;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  143  
53cbe4642113f8 drivers/staging/qlge/qlge_dbg.c             Jules Irenge        2019-10-09  144  	xfi_indirect_valid = 0;
53cbe4642113f8 drivers/staging/qlge/qlge_dbg.c             Jules Irenge        2019-10-09  145  	xfi_direct_valid = xfi_indirect_valid;
53cbe4642113f8 drivers/staging/qlge/qlge_dbg.c             Jules Irenge        2019-10-09  146  	xaui_indirect_valid = 1;
53cbe4642113f8 drivers/staging/qlge/qlge_dbg.c             Jules Irenge        2019-10-09  147  	xaui_direct_valid = xaui_indirect_valid
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  148  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  149  	/* The XAUI needs to be read out per port */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15 @150  	status = ql_read_other_func_serdes_reg(qdev,
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  151  			XG_SERDES_XAUI_HSS_PCS_START, &temp);
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  152  	if (status)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  153  		temp = XG_SERDES_ADDR_XAUI_PWR_DOWN;
4db93fb8aca3e9 drivers/net/ethernet/qlogic/qlge/qlge_dbg.c Gustavo A. R. Silva 2017-08-12  154  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  155  	if ((temp & XG_SERDES_ADDR_XAUI_PWR_DOWN) ==
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  156  				XG_SERDES_ADDR_XAUI_PWR_DOWN)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  157  		xaui_indirect_valid = 0;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  158  
4db93fb8aca3e9 drivers/net/ethernet/qlogic/qlge/qlge_dbg.c Gustavo A. R. Silva 2017-08-12  159  	status = ql_read_serdes_reg(qdev, XG_SERDES_XAUI_HSS_PCS_START, &temp);
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  160  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  161  	if (status)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  162  		temp = XG_SERDES_ADDR_XAUI_PWR_DOWN;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  163  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  164  	if ((temp & XG_SERDES_ADDR_XAUI_PWR_DOWN) ==
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  165  				XG_SERDES_ADDR_XAUI_PWR_DOWN)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  166  		xaui_direct_valid = 0;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  167  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  168  	/*
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  169  	 * XFI register is shared so only need to read one
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  170  	 * functions and then check the bits.
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  171  	 */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  172  	status = ql_read_serdes_reg(qdev, XG_SERDES_ADDR_STS, &temp);
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  173  	if (status)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  174  		temp = 0;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  175  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  176  	if ((temp & XG_SERDES_ADDR_XFI1_PWR_UP) ==
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  177  					XG_SERDES_ADDR_XFI1_PWR_UP) {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  178  		/* now see if i'm NIC 1 or NIC 2 */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  179  		if (qdev->func & 1)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  180  			/* I'm NIC 2, so the indirect (NIC1) xfi is up. */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  181  			xfi_indirect_valid = 1;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  182  		else
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  183  			xfi_direct_valid = 1;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  184  	}
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  185  	if ((temp & XG_SERDES_ADDR_XFI2_PWR_UP) ==
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  186  					XG_SERDES_ADDR_XFI2_PWR_UP) {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  187  		/* now see if i'm NIC 1 or NIC 2 */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  188  		if (qdev->func & 1)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  189  			/* I'm NIC 2, so the indirect (NIC1) xfi is up. */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  190  			xfi_direct_valid = 1;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  191  		else
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  192  			xfi_indirect_valid = 1;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  193  	}
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  194  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  195  	/* Get XAUI_AN register block. */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  196  	if (qdev->func & 1) {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  197  		/* Function 2 is direct	*/
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  198  		direct_ptr = mpi_coredump->serdes2_xaui_an;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  199  		indirect_ptr = mpi_coredump->serdes_xaui_an;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  200  	} else {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  201  		/* Function 1 is direct	*/
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  202  		direct_ptr = mpi_coredump->serdes_xaui_an;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  203  		indirect_ptr = mpi_coredump->serdes2_xaui_an;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  204  	}
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  205  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  206  	for (i = 0; i <= 0x000000034; i += 4, direct_ptr++, indirect_ptr++)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  207  		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  208  					xaui_direct_valid, xaui_indirect_valid);
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  209  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  210  	/* Get XAUI_HSS_PCS register block. */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  211  	if (qdev->func & 1) {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  212  		direct_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  213  			mpi_coredump->serdes2_xaui_hss_pcs;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  214  		indirect_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  215  			mpi_coredump->serdes_xaui_hss_pcs;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  216  	} else {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  217  		direct_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  218  			mpi_coredump->serdes_xaui_hss_pcs;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  219  		indirect_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  220  			mpi_coredump->serdes2_xaui_hss_pcs;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  221  	}
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  222  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  223  	for (i = 0x800; i <= 0x880; i += 4, direct_ptr++, indirect_ptr++)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  224  		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  225  					xaui_direct_valid, xaui_indirect_valid);
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  226  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  227  	/* Get XAUI_XFI_AN register block. */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  228  	if (qdev->func & 1) {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  229  		direct_ptr = mpi_coredump->serdes2_xfi_an;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  230  		indirect_ptr = mpi_coredump->serdes_xfi_an;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  231  	} else {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  232  		direct_ptr = mpi_coredump->serdes_xfi_an;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  233  		indirect_ptr = mpi_coredump->serdes2_xfi_an;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  234  	}
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  235  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  236  	for (i = 0x1000; i <= 0x1034; i += 4, direct_ptr++, indirect_ptr++)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  237  		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  238  					xfi_direct_valid, xfi_indirect_valid);
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  239  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  240  	/* Get XAUI_XFI_TRAIN register block. */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  241  	if (qdev->func & 1) {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  242  		direct_ptr = mpi_coredump->serdes2_xfi_train;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  243  		indirect_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  244  			mpi_coredump->serdes_xfi_train;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  245  	} else {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  246  		direct_ptr = mpi_coredump->serdes_xfi_train;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  247  		indirect_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  248  			mpi_coredump->serdes2_xfi_train;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  249  	}
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  250  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  251  	for (i = 0x1050; i <= 0x107c; i += 4, direct_ptr++, indirect_ptr++)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  252  		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  253  					xfi_direct_valid, xfi_indirect_valid);
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  254  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  255  	/* Get XAUI_XFI_HSS_PCS register block. */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  256  	if (qdev->func & 1) {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  257  		direct_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  258  			mpi_coredump->serdes2_xfi_hss_pcs;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  259  		indirect_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  260  			mpi_coredump->serdes_xfi_hss_pcs;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  261  	} else {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  262  		direct_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  263  			mpi_coredump->serdes_xfi_hss_pcs;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  264  		indirect_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  265  			mpi_coredump->serdes2_xfi_hss_pcs;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  266  	}
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  267  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  268  	for (i = 0x1800; i <= 0x1838; i += 4, direct_ptr++, indirect_ptr++)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  269  		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  270  					xfi_direct_valid, xfi_indirect_valid);
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  271  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  272  	/* Get XAUI_XFI_HSS_TX register block. */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  273  	if (qdev->func & 1) {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  274  		direct_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  275  			mpi_coredump->serdes2_xfi_hss_tx;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  276  		indirect_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  277  			mpi_coredump->serdes_xfi_hss_tx;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  278  	} else {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  279  		direct_ptr = mpi_coredump->serdes_xfi_hss_tx;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  280  		indirect_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  281  			mpi_coredump->serdes2_xfi_hss_tx;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  282  	}
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  283  	for (i = 0x1c00; i <= 0x1c1f; i++, direct_ptr++, indirect_ptr++)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  284  		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  285  					xfi_direct_valid, xfi_indirect_valid);
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  286  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  287  	/* Get XAUI_XFI_HSS_RX register block. */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  288  	if (qdev->func & 1) {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  289  		direct_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  290  			mpi_coredump->serdes2_xfi_hss_rx;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  291  		indirect_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  292  			mpi_coredump->serdes_xfi_hss_rx;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  293  	} else {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  294  		direct_ptr = mpi_coredump->serdes_xfi_hss_rx;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  295  		indirect_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  296  			mpi_coredump->serdes2_xfi_hss_rx;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  297  	}
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  298  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  299  	for (i = 0x1c40; i <= 0x1c5f; i++, direct_ptr++, indirect_ptr++)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  300  		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  301  					xfi_direct_valid, xfi_indirect_valid);
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  302  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  303  
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  304  	/* Get XAUI_XFI_HSS_PLL register block. */
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  305  	if (qdev->func & 1) {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  306  		direct_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  307  			mpi_coredump->serdes2_xfi_hss_pll;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  308  		indirect_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  309  			mpi_coredump->serdes_xfi_hss_pll;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  310  	} else {
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  311  		direct_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  312  			mpi_coredump->serdes_xfi_hss_pll;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  313  		indirect_ptr =
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  314  			mpi_coredump->serdes2_xfi_hss_pll;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  315  	}
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  316  	for (i = 0x1e00; i <= 0x1e1f; i++, direct_ptr++, indirect_ptr++)
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  317  		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  318  					xfi_direct_valid, xfi_indirect_valid);
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  319  	return 0;
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  320  }
a48c86fdb1253f drivers/net/qlge/qlge_dbg.c                 Ron Mercer          2010-01-15  321  

:::::: The code at line 150 was first introduced by commit
:::::: a48c86fdb1253f36167bab1fc30a51211d49a901 qlge: Add serdes reg blocks dump to firmware dump.

:::::: TO: Ron Mercer <ron.mercer@qlogic.com>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--ztueu6g6l3fgc4bd
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--ztueu6g6l3fgc4bd--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9DC179E08
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 03:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbfG3BoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 21:44:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:33803 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730651AbfG3BoU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 21:44:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 18:44:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,325,1559545200"; 
   d="gz'50?scan'50,208,50";a="371358538"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 29 Jul 2019 18:44:12 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hsHBU-0001BX-9N; Tue, 30 Jul 2019 09:44:12 +0800
Date:   Tue, 30 Jul 2019 07:23:15 +0800
From:   kbuild test robot <lkp@intel.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org
Subject: [net-next:master 57/61]
 arch/mips/include/asm/octeon/cvmx-ipd.h:330:27: error: storage size of
 'pip_sft_rst' isn't known
Message-ID: <201907300706.RZDUiXZb%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jvkmbtajce6hg3rj"
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jvkmbtajce6hg3rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/davem/net-next.git master
head:   85fd8011475e86265beff7b7617c493c247f5356
commit: 171a9bae68c72f2d1260c3825203760856e6793b [57/61] staging/octeon: Allow test build on !MIPS
config: mips-allmodconfig (attached as .config)
compiler: mips-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout 171a9bae68c72f2d1260c3825203760856e6793b
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=mips 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   In file included from arch/mips/include/asm/octeon/octeon.h:11:0,
                    from drivers/staging/octeon/octeon-ethernet.h:19,
                    from drivers/staging/octeon/ethernet.c:22:
   arch/mips/include/asm/octeon/cvmx.h: In function 'cvmx_writeq_csr':
>> arch/mips/include/asm/octeon/cvmx.h:282:17: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     cvmx_write_csr((__force uint64_t)csr_addr, val);
                    ^
   arch/mips/include/asm/octeon/cvmx.h: In function 'cvmx_readq_csr':
   arch/mips/include/asm/octeon/cvmx.h:299:23: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     return cvmx_read_csr((__force uint64_t) csr_addr);
                          ^
   In file included from drivers/staging/octeon/octeon-ethernet.h:27:0,
                    from drivers/staging/octeon/ethernet.c:22:
   arch/mips/include/asm/octeon/cvmx-ipd.h: In function 'cvmx_ipd_free_ptr':
>> arch/mips/include/asm/octeon/cvmx-ipd.h:330:27: error: storage size of 'pip_sft_rst' isn't known
       union cvmx_pip_sft_rst pip_sft_rst;
                              ^~~~~~~~~~~
>> arch/mips/include/asm/octeon/cvmx-ipd.h:331:36: error: 'CVMX_PIP_SFT_RST' undeclared (first use in this function); did you mean 'CVMX_CIU_SOFT_RST'?
       pip_sft_rst.u64 = cvmx_read_csr(CVMX_PIP_SFT_RST);
                                       ^~~~~~~~~~~~~~~~
                                       CVMX_CIU_SOFT_RST
   arch/mips/include/asm/octeon/cvmx-ipd.h:331:36: note: each undeclared identifier is reported only once for each function it appears in
   arch/mips/include/asm/octeon/cvmx-ipd.h:330:27: warning: unused variable 'pip_sft_rst' [-Wunused-variable]
       union cvmx_pip_sft_rst pip_sft_rst;
                              ^~~~~~~~~~~
--
   In file included from arch/mips/include/asm/octeon/octeon.h:11:0,
                    from drivers/staging/octeon/octeon-ethernet.h:19,
                    from drivers/staging/octeon/ethernet-rx.c:26:
   arch/mips/include/asm/octeon/cvmx.h: In function 'cvmx_writeq_csr':
>> arch/mips/include/asm/octeon/cvmx.h:282:17: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     cvmx_write_csr((__force uint64_t)csr_addr, val);
                    ^
   arch/mips/include/asm/octeon/cvmx.h: In function 'cvmx_readq_csr':
   arch/mips/include/asm/octeon/cvmx.h:299:23: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     return cvmx_read_csr((__force uint64_t) csr_addr);
                          ^
   In file included from drivers/staging/octeon/octeon-ethernet.h:27:0,
                    from drivers/staging/octeon/ethernet-rx.c:26:
   arch/mips/include/asm/octeon/cvmx-ipd.h: In function 'cvmx_ipd_free_ptr':
>> arch/mips/include/asm/octeon/cvmx-ipd.h:330:27: error: storage size of 'pip_sft_rst' isn't known
       union cvmx_pip_sft_rst pip_sft_rst;
                              ^~~~~~~~~~~
>> arch/mips/include/asm/octeon/cvmx-ipd.h:331:36: error: 'CVMX_PIP_SFT_RST' undeclared (first use in this function); did you mean 'CVMX_CIU_SOFT_RST'?
       pip_sft_rst.u64 = cvmx_read_csr(CVMX_PIP_SFT_RST);
                                       ^~~~~~~~~~~~~~~~
                                       CVMX_CIU_SOFT_RST
   arch/mips/include/asm/octeon/cvmx-ipd.h:331:36: note: each undeclared identifier is reported only once for each function it appears in
   arch/mips/include/asm/octeon/cvmx-ipd.h:330:27: warning: unused variable 'pip_sft_rst' [-Wunused-variable]
       union cvmx_pip_sft_rst pip_sft_rst;
                              ^~~~~~~~~~~
   In file included from drivers/staging/octeon/ethernet-rx.c:27:0:
   drivers/staging/octeon/ethernet-rx.c: In function 'cvm_oct_poll':
>> drivers/staging/octeon/ethernet-defines.h:30:38: error: 'CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE' undeclared (first use in this function); did you mean 'CONFIG_MDIO_OCTEON_MODULE'?
    #define USE_ASYNC_IOBDMA            (CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE > 0)
                                         ^
>> drivers/staging/octeon/ethernet-rx.c:190:6: note: in expansion of macro 'USE_ASYNC_IOBDMA'
     if (USE_ASYNC_IOBDMA) {
         ^~~~~~~~~~~~~~~~
   drivers/staging/octeon/ethernet-rx.c: In function 'cvm_oct_rx_initialize':
>> drivers/staging/octeon/ethernet-rx.c:472:25: error: 'OCTEON_IRQ_WORKQ0' undeclared (first use in this function); did you mean 'OCTEON_IS_MODEL'?
      oct_rx_group[i].irq = OCTEON_IRQ_WORKQ0 + i;
                            ^~~~~~~~~~~~~~~~~
                            OCTEON_IS_MODEL
--
   In file included from arch/mips/include/asm/octeon/octeon.h:11:0,
                    from drivers/staging/octeon/octeon-ethernet.h:19,
                    from drivers/staging/octeon/ethernet-spi.c:13:
   arch/mips/include/asm/octeon/cvmx.h: In function 'cvmx_writeq_csr':
>> arch/mips/include/asm/octeon/cvmx.h:282:17: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     cvmx_write_csr((__force uint64_t)csr_addr, val);
                    ^
   arch/mips/include/asm/octeon/cvmx.h: In function 'cvmx_readq_csr':
   arch/mips/include/asm/octeon/cvmx.h:299:23: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     return cvmx_read_csr((__force uint64_t) csr_addr);
                          ^
   In file included from drivers/staging/octeon/octeon-ethernet.h:27:0,
                    from drivers/staging/octeon/ethernet-spi.c:13:
   arch/mips/include/asm/octeon/cvmx-ipd.h: In function 'cvmx_ipd_free_ptr':
>> arch/mips/include/asm/octeon/cvmx-ipd.h:330:27: error: storage size of 'pip_sft_rst' isn't known
       union cvmx_pip_sft_rst pip_sft_rst;
                              ^~~~~~~~~~~
>> arch/mips/include/asm/octeon/cvmx-ipd.h:331:36: error: 'CVMX_PIP_SFT_RST' undeclared (first use in this function); did you mean 'CVMX_CIU_SOFT_RST'?
       pip_sft_rst.u64 = cvmx_read_csr(CVMX_PIP_SFT_RST);
                                       ^~~~~~~~~~~~~~~~
                                       CVMX_CIU_SOFT_RST
   arch/mips/include/asm/octeon/cvmx-ipd.h:331:36: note: each undeclared identifier is reported only once for each function it appears in
   arch/mips/include/asm/octeon/cvmx-ipd.h:330:27: warning: unused variable 'pip_sft_rst' [-Wunused-variable]
       union cvmx_pip_sft_rst pip_sft_rst;
                              ^~~~~~~~~~~
   drivers/staging/octeon/ethernet-spi.c: In function 'cvm_oct_spi_init':
>> drivers/staging/octeon/ethernet-spi.c:198:19: error: 'OCTEON_IRQ_RML' undeclared (first use in this function); did you mean 'OCTEON_IS_MODEL'?
      r = request_irq(OCTEON_IRQ_RML, cvm_oct_spi_rml_interrupt,
                      ^~~~~~~~~~~~~~
                      OCTEON_IS_MODEL
   drivers/staging/octeon/ethernet-spi.c: In function 'cvm_oct_spi_uninit':
   drivers/staging/octeon/ethernet-spi.c:224:12: error: 'OCTEON_IRQ_RML' undeclared (first use in this function); did you mean 'OCTEON_IS_MODEL'?
      free_irq(OCTEON_IRQ_RML, &number_spi_ports);
               ^~~~~~~~~~~~~~
               OCTEON_IS_MODEL
--
   In file included from arch/mips/include/asm/octeon/octeon.h:11:0,
                    from drivers/staging/octeon/octeon-ethernet.h:19,
                    from drivers/staging/octeon/ethernet-tx.c:25:
   arch/mips/include/asm/octeon/cvmx.h: In function 'cvmx_writeq_csr':
>> arch/mips/include/asm/octeon/cvmx.h:282:17: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     cvmx_write_csr((__force uint64_t)csr_addr, val);
                    ^
   arch/mips/include/asm/octeon/cvmx.h: In function 'cvmx_readq_csr':
   arch/mips/include/asm/octeon/cvmx.h:299:23: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     return cvmx_read_csr((__force uint64_t) csr_addr);
                          ^
   In file included from drivers/staging/octeon/octeon-ethernet.h:27:0,
                    from drivers/staging/octeon/ethernet-tx.c:25:
   arch/mips/include/asm/octeon/cvmx-ipd.h: In function 'cvmx_ipd_free_ptr':
>> arch/mips/include/asm/octeon/cvmx-ipd.h:330:27: error: storage size of 'pip_sft_rst' isn't known
       union cvmx_pip_sft_rst pip_sft_rst;
                              ^~~~~~~~~~~
>> arch/mips/include/asm/octeon/cvmx-ipd.h:331:36: error: 'CVMX_PIP_SFT_RST' undeclared (first use in this function); did you mean 'CVMX_CIU_SOFT_RST'?
       pip_sft_rst.u64 = cvmx_read_csr(CVMX_PIP_SFT_RST);
                                       ^~~~~~~~~~~~~~~~
                                       CVMX_CIU_SOFT_RST
   arch/mips/include/asm/octeon/cvmx-ipd.h:331:36: note: each undeclared identifier is reported only once for each function it appears in
   arch/mips/include/asm/octeon/cvmx-ipd.h:330:27: warning: unused variable 'pip_sft_rst' [-Wunused-variable]
       union cvmx_pip_sft_rst pip_sft_rst;
                              ^~~~~~~~~~~
   In file included from drivers/staging/octeon/ethernet-tx.c:26:0:
   drivers/staging/octeon/ethernet-tx.c: In function 'cvm_oct_xmit':
>> drivers/staging/octeon/ethernet-defines.h:30:38: error: 'CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE' undeclared (first use in this function); did you mean 'CONFIG_MDIO_OCTEON_MODULE'?
    #define USE_ASYNC_IOBDMA            (CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE > 0)
                                         ^
>> drivers/staging/octeon/ethernet-tx.c:169:6: note: in expansion of macro 'USE_ASYNC_IOBDMA'
     if (USE_ASYNC_IOBDMA) {
         ^~~~~~~~~~~~~~~~
   In file included from arch/mips/include/asm/barrier.h:11:0,
                    from include/linux/compiler.h:256,
                    from include/linux/kernel.h:11,
                    from include/linux/list.h:9,
                    from include/linux/module.h:9,
                    from drivers/staging/octeon/ethernet-tx.c:8:
   drivers/staging/octeon/ethernet-tx.c:264:37: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)skb->data);
                                        ^
   arch/mips/include/asm/addrspace.h:128:30: note: in definition of macro 'XKPHYS_TO_PHYS'
    #define XKPHYS_TO_PHYS(p)  ((p) & TO_PHYS_MASK)
                                 ^
   drivers/staging/octeon/ethernet-tx.c:268:37: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)skb->data);
                                        ^
   arch/mips/include/asm/addrspace.h:128:30: note: in definition of macro 'XKPHYS_TO_PHYS'
    #define XKPHYS_TO_PHYS(p)  ((p) & TO_PHYS_MASK)
                                 ^
   drivers/staging/octeon/ethernet-tx.c:276:20: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
        XKPHYS_TO_PHYS((u64)skb_frag_address(fs));
                       ^
   arch/mips/include/asm/addrspace.h:128:30: note: in definition of macro 'XKPHYS_TO_PHYS'
    #define XKPHYS_TO_PHYS(p)  ((p) & TO_PHYS_MASK)
                                 ^
   drivers/staging/octeon/ethernet-tx.c:280:37: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)CVM_OCT_SKB_CB(skb));
                                        ^
   arch/mips/include/asm/addrspace.h:128:30: note: in definition of macro 'XKPHYS_TO_PHYS'
    #define XKPHYS_TO_PHYS(p)  ((p) & TO_PHYS_MASK)
                                 ^
   drivers/staging/octeon/ethernet-tx.c: In function 'cvm_oct_tx_initialize':
>> drivers/staging/octeon/ethernet-tx.c:706:18: error: 'OCTEON_IRQ_TIMER1' undeclared (first use in this function); did you mean 'OCTEON_IS_MODEL'?
     i = request_irq(OCTEON_IRQ_TIMER1,
                     ^~~~~~~~~~~~~~~~~
                     OCTEON_IS_MODEL
   drivers/staging/octeon/ethernet-tx.c: In function 'cvm_oct_tx_shutdown':
   drivers/staging/octeon/ethernet-tx.c:717:11: error: 'OCTEON_IRQ_TIMER1' undeclared (first use in this function); did you mean 'OCTEON_IS_MODEL'?
     free_irq(OCTEON_IRQ_TIMER1, cvm_oct_device);
              ^~~~~~~~~~~~~~~~~
              OCTEON_IS_MODEL

vim +330 arch/mips/include/asm/octeon/cvmx-ipd.h

80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  154  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  155  /**
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  156   * Supportive function for cvmx_fpa_shutdown_pool.
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  157   */
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  158  static inline void cvmx_ipd_free_ptr(void)
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  159  {
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  160  	/* Only CN38XXp{1,2} cannot read pointer out of the IPD */
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  161  	if (!OCTEON_IS_MODEL(OCTEON_CN38XX_PASS1)
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  162  	    && !OCTEON_IS_MODEL(OCTEON_CN38XX_PASS2)) {
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  163  		int no_wptr = 0;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  164  		union cvmx_ipd_ptr_count ipd_ptr_count;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  165  		ipd_ptr_count.u64 = cvmx_read_csr(CVMX_IPD_PTR_COUNT);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  166  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  167  		/* Handle Work Queue Entry in cn56xx and cn52xx */
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  168  		if (octeon_has_feature(OCTEON_FEATURE_NO_WPTR)) {
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  169  			union cvmx_ipd_ctl_status ipd_ctl_status;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  170  			ipd_ctl_status.u64 = cvmx_read_csr(CVMX_IPD_CTL_STATUS);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  171  			if (ipd_ctl_status.s.no_wptr)
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  172  				no_wptr = 1;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  173  		}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  174  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  175  		/* Free the prefetched WQE */
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  176  		if (ipd_ptr_count.s.wqev_cnt) {
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  177  			union cvmx_ipd_wqe_ptr_valid ipd_wqe_ptr_valid;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  178  			ipd_wqe_ptr_valid.u64 =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  179  			    cvmx_read_csr(CVMX_IPD_WQE_PTR_VALID);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  180  			if (no_wptr)
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  181  				cvmx_fpa_free(cvmx_phys_to_ptr
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  182  					      ((uint64_t) ipd_wqe_ptr_valid.s.
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  183  					       ptr << 7), CVMX_FPA_PACKET_POOL,
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  184  					      0);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  185  			else
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  186  				cvmx_fpa_free(cvmx_phys_to_ptr
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  187  					      ((uint64_t) ipd_wqe_ptr_valid.s.
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  188  					       ptr << 7), CVMX_FPA_WQE_POOL, 0);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  189  		}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  190  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  191  		/* Free all WQE in the fifo */
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  192  		if (ipd_ptr_count.s.wqe_pcnt) {
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  193  			int i;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  194  			union cvmx_ipd_pwp_ptr_fifo_ctl ipd_pwp_ptr_fifo_ctl;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  195  			ipd_pwp_ptr_fifo_ctl.u64 =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  196  			    cvmx_read_csr(CVMX_IPD_PWP_PTR_FIFO_CTL);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  197  			for (i = 0; i < ipd_ptr_count.s.wqe_pcnt; i++) {
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  198  				ipd_pwp_ptr_fifo_ctl.s.cena = 0;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  199  				ipd_pwp_ptr_fifo_ctl.s.raddr =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  200  				    ipd_pwp_ptr_fifo_ctl.s.max_cnts +
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  201  				    (ipd_pwp_ptr_fifo_ctl.s.wraddr +
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  202  				     i) % ipd_pwp_ptr_fifo_ctl.s.max_cnts;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  203  				cvmx_write_csr(CVMX_IPD_PWP_PTR_FIFO_CTL,
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  204  					       ipd_pwp_ptr_fifo_ctl.u64);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  205  				ipd_pwp_ptr_fifo_ctl.u64 =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  206  				    cvmx_read_csr(CVMX_IPD_PWP_PTR_FIFO_CTL);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  207  				if (no_wptr)
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  208  					cvmx_fpa_free(cvmx_phys_to_ptr
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  209  						      ((uint64_t)
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  210  						       ipd_pwp_ptr_fifo_ctl.s.
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  211  						       ptr << 7),
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  212  						      CVMX_FPA_PACKET_POOL, 0);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  213  				else
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  214  					cvmx_fpa_free(cvmx_phys_to_ptr
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  215  						      ((uint64_t)
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  216  						       ipd_pwp_ptr_fifo_ctl.s.
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  217  						       ptr << 7),
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  218  						      CVMX_FPA_WQE_POOL, 0);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  219  			}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  220  			ipd_pwp_ptr_fifo_ctl.s.cena = 1;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  221  			cvmx_write_csr(CVMX_IPD_PWP_PTR_FIFO_CTL,
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  222  				       ipd_pwp_ptr_fifo_ctl.u64);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  223  		}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  224  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  225  		/* Free the prefetched packet */
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  226  		if (ipd_ptr_count.s.pktv_cnt) {
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  227  			union cvmx_ipd_pkt_ptr_valid ipd_pkt_ptr_valid;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  228  			ipd_pkt_ptr_valid.u64 =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  229  			    cvmx_read_csr(CVMX_IPD_PKT_PTR_VALID);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  230  			cvmx_fpa_free(cvmx_phys_to_ptr
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  231  				      (ipd_pkt_ptr_valid.s.ptr << 7),
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  232  				      CVMX_FPA_PACKET_POOL, 0);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  233  		}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  234  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  235  		/* Free the per port prefetched packets */
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  236  		if (1) {
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  237  			int i;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  238  			union cvmx_ipd_prc_port_ptr_fifo_ctl
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  239  			    ipd_prc_port_ptr_fifo_ctl;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  240  			ipd_prc_port_ptr_fifo_ctl.u64 =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  241  			    cvmx_read_csr(CVMX_IPD_PRC_PORT_PTR_FIFO_CTL);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  242  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  243  			for (i = 0; i < ipd_prc_port_ptr_fifo_ctl.s.max_pkt;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  244  			     i++) {
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  245  				ipd_prc_port_ptr_fifo_ctl.s.cena = 0;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  246  				ipd_prc_port_ptr_fifo_ctl.s.raddr =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  247  				    i % ipd_prc_port_ptr_fifo_ctl.s.max_pkt;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  248  				cvmx_write_csr(CVMX_IPD_PRC_PORT_PTR_FIFO_CTL,
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  249  					       ipd_prc_port_ptr_fifo_ctl.u64);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  250  				ipd_prc_port_ptr_fifo_ctl.u64 =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  251  				    cvmx_read_csr
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  252  				    (CVMX_IPD_PRC_PORT_PTR_FIFO_CTL);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  253  				cvmx_fpa_free(cvmx_phys_to_ptr
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  254  					      ((uint64_t)
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  255  					       ipd_prc_port_ptr_fifo_ctl.s.
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  256  					       ptr << 7), CVMX_FPA_PACKET_POOL,
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  257  					      0);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  258  			}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  259  			ipd_prc_port_ptr_fifo_ctl.s.cena = 1;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  260  			cvmx_write_csr(CVMX_IPD_PRC_PORT_PTR_FIFO_CTL,
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  261  				       ipd_prc_port_ptr_fifo_ctl.u64);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  262  		}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  263  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  264  		/* Free all packets in the holding fifo */
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  265  		if (ipd_ptr_count.s.pfif_cnt) {
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  266  			int i;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  267  			union cvmx_ipd_prc_hold_ptr_fifo_ctl
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  268  			    ipd_prc_hold_ptr_fifo_ctl;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  269  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  270  			ipd_prc_hold_ptr_fifo_ctl.u64 =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  271  			    cvmx_read_csr(CVMX_IPD_PRC_HOLD_PTR_FIFO_CTL);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  272  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  273  			for (i = 0; i < ipd_ptr_count.s.pfif_cnt; i++) {
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  274  				ipd_prc_hold_ptr_fifo_ctl.s.cena = 0;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  275  				ipd_prc_hold_ptr_fifo_ctl.s.raddr =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  276  				    (ipd_prc_hold_ptr_fifo_ctl.s.praddr +
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  277  				     i) % ipd_prc_hold_ptr_fifo_ctl.s.max_pkt;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  278  				cvmx_write_csr(CVMX_IPD_PRC_HOLD_PTR_FIFO_CTL,
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  279  					       ipd_prc_hold_ptr_fifo_ctl.u64);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  280  				ipd_prc_hold_ptr_fifo_ctl.u64 =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  281  				    cvmx_read_csr
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  282  				    (CVMX_IPD_PRC_HOLD_PTR_FIFO_CTL);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  283  				cvmx_fpa_free(cvmx_phys_to_ptr
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  284  					      ((uint64_t)
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  285  					       ipd_prc_hold_ptr_fifo_ctl.s.
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  286  					       ptr << 7), CVMX_FPA_PACKET_POOL,
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  287  					      0);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  288  			}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  289  			ipd_prc_hold_ptr_fifo_ctl.s.cena = 1;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  290  			cvmx_write_csr(CVMX_IPD_PRC_HOLD_PTR_FIFO_CTL,
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  291  				       ipd_prc_hold_ptr_fifo_ctl.u64);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  292  		}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  293  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  294  		/* Free all packets in the fifo */
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  295  		if (ipd_ptr_count.s.pkt_pcnt) {
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  296  			int i;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  297  			union cvmx_ipd_pwp_ptr_fifo_ctl ipd_pwp_ptr_fifo_ctl;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  298  			ipd_pwp_ptr_fifo_ctl.u64 =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  299  			    cvmx_read_csr(CVMX_IPD_PWP_PTR_FIFO_CTL);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  300  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  301  			for (i = 0; i < ipd_ptr_count.s.pkt_pcnt; i++) {
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  302  				ipd_pwp_ptr_fifo_ctl.s.cena = 0;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  303  				ipd_pwp_ptr_fifo_ctl.s.raddr =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  304  				    (ipd_pwp_ptr_fifo_ctl.s.praddr +
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  305  				     i) % ipd_pwp_ptr_fifo_ctl.s.max_cnts;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  306  				cvmx_write_csr(CVMX_IPD_PWP_PTR_FIFO_CTL,
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  307  					       ipd_pwp_ptr_fifo_ctl.u64);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  308  				ipd_pwp_ptr_fifo_ctl.u64 =
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  309  				    cvmx_read_csr(CVMX_IPD_PWP_PTR_FIFO_CTL);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  310  				cvmx_fpa_free(cvmx_phys_to_ptr
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  311  					      ((uint64_t) ipd_pwp_ptr_fifo_ctl.
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  312  					       s.ptr << 7),
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  313  					      CVMX_FPA_PACKET_POOL, 0);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  314  			}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  315  			ipd_pwp_ptr_fifo_ctl.s.cena = 1;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  316  			cvmx_write_csr(CVMX_IPD_PWP_PTR_FIFO_CTL,
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  317  				       ipd_pwp_ptr_fifo_ctl.u64);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  318  		}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  319  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  320  		/* Reset the IPD to get all buffers out of it */
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  321  		{
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  322  			union cvmx_ipd_ctl_status ipd_ctl_status;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  323  			ipd_ctl_status.u64 = cvmx_read_csr(CVMX_IPD_CTL_STATUS);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  324  			ipd_ctl_status.s.reset = 1;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  325  			cvmx_write_csr(CVMX_IPD_CTL_STATUS, ipd_ctl_status.u64);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  326  		}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  327  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  328  		/* Reset the PIP */
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  329  		{
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05 @330  			union cvmx_pip_sft_rst pip_sft_rst;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05 @331  			pip_sft_rst.u64 = cvmx_read_csr(CVMX_PIP_SFT_RST);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  332  			pip_sft_rst.s.rst = 1;
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  333  			cvmx_write_csr(CVMX_PIP_SFT_RST, pip_sft_rst.u64);
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  334  		}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  335  	}
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  336  }
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  337  
80ff0fd3ab64514 drivers/staging/octeon/cvmx-ipd.h David Daney 2009-05-05  338  #endif /*  __CVMX_IPD_H__ */

:::::: The code at line 330 was first introduced by commit
:::::: 80ff0fd3ab6451407a20c19b80c1643c4a6d6434 Staging: Add octeon-ethernet driver files.

:::::: TO: David Daney <ddaney@caviumnetworks.com>
:::::: CC: Ralf Baechle <ralf@linux-mips.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--jvkmbtajce6hg3rj
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICCJ3P10AAy5jb25maWcAjDzZcty2su/5iin74SZ14kSbZefe0gMIghxkSIIGwFn0wlLk
saOKFtdIPon//naDGzaOkzp1ZHY3GlujNzTm9Q+vF+Try9PDzcvd7c39/bfF5/3j/nDzsv+4
+HR3v/+/RSoWldALlnL9CxAXd49f//n14e7L8+LtL+e/nLw53J4uVvvD4/5+QZ8eP919/gqt
754ef3j9A/zvNQAfvgCjw/8usNGbe2z/5vPt7eLHnNKfFu9+ufjlBAipqDKet5S2XLWAufo2
gOCjXTOpuKiu3p1cnJyMtAWp8hF1YrFYEtUSVba50GJi1CM2RFZtSXYJa5uKV1xzUvBrllqE
olJaNlQLqSYolx/ajZCrCZI0vEg1L1nLtpokBWuVkBrwZuK5Wcj7xfP+5euXaYbYY8uqdUtk
3ha85Prq/Gzquaw58NFM6amfJSMpkx5wxWTFijiuEJQUw8K8euWMt1Wk0BYwZRlpCt0uhdIV
KdnVqx8fnx73P40EakPqibXaqTWvaQDAv1QXE7wWim/b8kPDGhaHBk2oFEq1JSuF3LVEa0KX
E7JRrODJ9E0akMhhrWFvFs9f/3j+9vyyf5jWOmcVk5yaraulSKyB2Ci1FJs4hmUZo5qvWUuy
DIRGreJ0dMlrV1JSURJeuTDFyxhRu+RMEkmXuzhzXvMQUSqOSEtISJWC5PQsHRQyyYSkLG31
UoLA8CqPd5WypMkzFPrXi/3jx8XTJ29px9WH4cIBFHSlRAOc25RoEvI0h2ON+0yKIkQbBmzN
Km2dM8MaD6rmdNUmUpCUElu6I62PkpVCtU0NA2SDuOi7h/3hOSYxpk9RMRAJi1Ul2uU1Hs5S
VGZthjW/bmvoQ6ScLu6eF49PL3ja3VYcdsXjZG0az5etZMoslHTWPRjjeIQkY2WtgVXF7MEM
8LUomkoTubOH5FNFhju0pwKaDytF6+ZXffP81+IFhrO4gaE9v9y8PC9ubm+fvj6+3D1+9tYO
GrSEGh6OlKF0GWmIIZcETpiiSxBQss5d4U1UimeXMlAN0FbPY9r1+YTUcFaVJrZgIQgkvCA7
j5FBbCMwLqLDrRV3PkYdmnKFZiC19/FfrOCo/2DtuBIF0dzImdkBSZuFiggq7FYLuGkg8AF2
COTRmoVyKEwbD4TLFPKBlSuKSeAtTMVgkxTLaVJw+7QhLiOVaGxzNgHbgpHs6vTSxSjtHwjT
haAJroW9iu4quAYt4dWZZZD4qvvH1YMPMdJiE3bGU02UhUCmGVgEnumr03c2HHenJFsbfzad
HV7pFZjWjPk8zn191Mm5UV7DHqvbP/cfv4KTtPi0v3n5etg/G3A/9wh2lJhciqa2ZLwmOetO
MJMTFEwqzb1Pz65PMHBOBiF2cCv4Yx2+YtX3btlv891uJNcsIXQVYMzUJ2hGuGyjGJqBSgeD
tuGptnwAqWfIO2jNUxUAZVqSAJjBSbi2Vwg2VzFbWaCoIMMeE3BI2ZpTFoCB2tUjw9CYzAJg
UocwY4GtAyzoakQ5JhZ9NVUT0H6WjwSWsLJdVvDL7G+YiXQAOEH7u2La+YZlpqtagHCjlQJ/
2Jpxr68bLTwxAHMP25cyMCgUjG46j2nXZ9bmomZ2BQwW2fjL0uJhvkkJfDrPw3JlZdrm17Yj
BoAEAGcOpLi2BQIA22sPL7zvCyeGEDXYMQgY0KUy+ypkSSrq2GKfTME/IibX2D3QYCnoITi1
aedGtQzDgmqwAoMK+ndkvk/dfYNhoKxGSjACxJZbRwZ981GCUeMoNBa/nGn0g9vAqes2NwbG
AQTwrHNY/dBgdIQczep/t1VpmWDnxLAigzWyBTUhCnahcTpvNNt6n63tZrNaOJPgeUWKzBJD
M04bYBxRG6CWjsIk3BIrcCwa6fgUJF1zxYZlshYAmCRESm5vwgpJdqUKIa2zxiPULAEeMIxl
nM0PNwaBv0OMSooN2anWFi4UBePp2POUilnumtFfHgxmwNLUVgRG8PHstL73b4DQT7suYVS2
ua7p6cnFYDH7jEO9P3x6OjzcPN7uF+y/+0fwqwgYTYqeFXjPk7sU7asba6TH0fT+y24Ghuuy
62OwwFZfqmiSQLkjrDe85vDYa42pAKIhsFnZikUVJIkoEuTkkok4GcEOJfgIvctqDwZwaBfR
r2slHE5RzmGXRKbgzTjC3mQZhJ/G/zDLSMBaeFNFD6omEhMujn7QrOw02hocpIxTT6WBKc54
4ZwWo8SMXXJiJjflMp4gbjwkIzflze2fd497oLjf3/ZpKotscNLstTRwUoC1K+MhFZHv4nC9
PHs7h3n3WxST2KOIU9Dy4t12O4e7PJ/BGcZUJKTQcTyBsDtlFIMmWP55mt/J9fU8FraJVTND
LwgEUh9mUIocGVchRJUrUZ2ffZ/m8mKepgbphb9czC8RKAFNjnGgM4OoGAUSuWK8UvPt1/Li
dGaHqi04tjo5Ozs5jo7LVF1iUqiO4iSB47OKolTOwU08i0+pR8bFu0e+P4KcWSnFk52GMEUu
ecWOUhBZsuI7PMRxHt8lgJhHlscICq51wVQjj3IBtS9UXHB6koTns0wq3s4MwkiN3p7/Nneu
O/zFLJ6vpNB81crk7cx+ULLmTdkKqhk4iBByxOWvKNttIdtEgPY/QlEfoTAnDEwAdChjOaiC
5YTuOgaW8dyREgaWaoypy0GVF/vPN7ffFpitftMs+a/4N+P6p0XydHP4aNl+mynsE0nPR2ug
KF2I2/09jOLj0/758X9eFn8/Hf5a/H338ufCkIJpufnjfv/RshMKvXvKCjFmyaDbX2EIQc8A
b3mJJjGDwScCIijLrrnYip9e/nZx8XYOv+VFVudkDj0OaHBFYIH7KYMtp0snmxJaQT9Jsdww
ni9j2VRQJYmE4K3LpPnhoChhVBnEZ+AKoHm2vdZECHQsrFQ7ZWuAXNiJAiWpC+nsFmZLIolk
kytWTV0LqTHJizl+28ErCbp3GEZSsWSSVdpFVqIKEdDLxHMpdF00eZ+PGikqb5ROG3C00f/B
LIo3D9Y7107iARVDy6qUEye5jJhO9fTImENnd+uwiRE43KygX/ThIYiUE/RgMggiFZNl8CZS
nIIkwI53Wa723VH01bsxmRxzvExiDVqdn7Xy1F+BATGjuSyKy6MUlxfA/LsUx3tBisuZXcAL
C38iR9Bnx9GX82gzkePoI8zNFCb0hpFVK+CA9MGonbWOaIdpiK4AI8welCYQYoB2UgTOwvrq
NCqN52cJ6IruGnNGYC8vYiTY43e4YIACZp21G6LpcgwU7NDx5duX/SSDho0VcqBaxaRNe7Fy
AqsJcXq5SuKO2EhyebGKRWHmKs6kkq/BNTGrf3U6rlFvpszx8bUgTtxDIAw3uJYsY9q+MEXM
oLXTpqxbXSQew6weFtJtBqoNcE0I7A51yKgE01zWAdC3DqqcU7Pfw5tMVOTycug9q0mWBcul
Qgj4yT4wANjX2zhzvPNQqCYV+Pfa0AgJtFSKPrZ0VAVux0h5RKH0zSMSMnApBIFFwbRrW8jI
kTsz12prPotiPJQUNF7ejIniaa+qT0IEnAx19X48WuAXOIkt5zgGWNeYHsWOazYnA9aCx/G1
OrWUm3EOsoJo6LK/1LA0xCaeE3LEOG784Sh56W53DK7geVO0GlbSXC5cnTlLbkalQIHhbT2N
ZJIMVdcW/5SkBg72lfRZPAAGzEU8WAPM6Uk86ESUG+JZ/bw9uXIvw8/exo1w18F8DyfukGMr
RyTqeefu/PoKRuAqmKXES2grAcq2zD7MkqilUYaWql/uFAevEu88QQ+e/POp/+/9xYn5b+yB
UczJeRshwFxnNZjVQJFiSlFYOgkCBOMCWw5xw0GrYWDj61PQNaSuwVGDOXVYN4TCJLdNMB9s
gb99hNJNcxqTOEZN4HGnLGIgMIOyMgm4ENddaEB0UNGdFpHGdd4VShVw7gpf9PEuqa2zCpYt
6+7cjMFOvj4vnr6gI/K8+LGm/OdFTUvKyc8LBh7Gzwvzf5r+ZGV7KW9TybECysroDV2Vjacj
SjhDraw6TQdDqSZtF8OT7dXp2zjBkLT9Dh+HrGM37sW/nq2VC037C4rRx6mf/t4fFg83jzef
9w/7x5eB47REXZUNT8BxMvk+vH5R3FGRfXClUHgi6B4TAMLL1QGhVrz2zM8wAsz1FAVeGqsQ
6WaDS5DAtMsja7e+DVEFY7VLjBBX8QIURS2k3ZAVMzVNcWhfrnc66QQHm9uXFaXDwkv84wDS
NV4aphEU1vKFqztOxWuQmjGA55eKGai5q8LCjNMze+C0WDncR1/RVJBZS7D5ALu/YRKr4Tjl
eL8R3B6E7SNb4VPY2tHcDZR2CDIrw2Ms2VGUI8VYcgo4/vF+74aYbiHWAGlzsQaNlaZeNcCE
LFnVzKA0E2MqCT25oeNFerj7r3P/NLqfQNIPZMrGRJs6p7DzQMe+wSmowzKjfs42JFihLl11
d3j4++YQGSaRIGW05HjnogUVTqplQBlZ6OsbH1x0bbWMoKItMy5LE6uBm1baJSm5EDlMdsAH
CLzlNTmlLtPy4KHxYk1UShxFjUwCmnWdTjCW8ZYRWeyorYp4uYWJNQGgrdNBLPT+8+Fm8WlY
8I9mwe3inhmCAR1s1dAV5vcaLFz21OMa63ixjmMafAdSVHEftsbyEg/o03RFuV3OqE+lXnkV
zjeH2z/vXva3WJv05uP+C4w9anM698u9nDcemgcT3Y2ftW/GrxjBU2M/4fc7xrkFSZyMAl5o
UegI3UlwnNxS6SBnaM4b+m6Dd5a4hVIrybTfxgyPwxzQwOMB8FDBODvoHCenuMFAzKCMz7UU
YuUhMZEJ35rnjWgsXmPBGayJURtd/OxNFUPCpjKBvSnsK51cqCHpcizglLX+xCTLwW1D045O
IRZLmmLM2h+/Ww9gQI75mSYZ20GD2BCwO1jQBJYfL+v76vYIi95Rx2ymk3+eg3fVpzgB3DpG
nYvr/tGAix5qb22PONLWa6S0FEHVK24c22qzuauwKPb7ZbOlSPtp14zi7bnl6Yq0KZgy0owR
g3RTZD17tsXNrboKde2U7Y0CYlqbkgB+zWJr7rjIHoHpICp7bqv33sLUu75Vq+2CGFrA4rfo
Km7cW6IuW4irZRF3nnYnwS5KsswsqVcaNM2pf4wh26U3bFxPMCGx427uKawakNEjz6lYv/nj
5nn/cfFXF219OTx9urt3KqiRKMhlGqApMtPthcm0T/UOR5iOflfR5PjGAHQ5pVevPv/nP6/C
gonvaPBxyXRbYqmUrbFMaZHC0hkrd9QJni+JfeYTs1oBqqmi4K7FiJxiW5H2GmDmrr1rriTt
ybAoJZJjGOh4HnSteJ+qjWKcaygLrpbk1BuohTqbyc14VDNpFJfq/P2/4fX29OzotPF4L69e
Pf95c/rKw6L8S9DnwTwHxFBt6Xc94rfXs32rrhq9AHNmJ9OSvix6/FwZxwUO64fGsdtDeWii
8ijQeSs01ZJqlkuuI2WmmIpPQzAoIKG1W3wU4mAaGxdPyxQQrDNW0sVtEm8efX0vF33mJCBv
yw9+91i5lqk4NDYZhZeztSm86jIEN4eXOzzdC/3ty96ulBsC6zFEtbQf+GmVFXrPIVralKQi
83jGlNjOozlV80iSZkewJsbQdtLPp5BcUW53zrexKQmVRWda8pxEEZpIHkOUhEbBKhUqhsBn
LSlXK88JKnkFA1VNEmmCb0ZgWu32/WWMYwMtTYQVYVukZawJgv1qxTw6vabQMr6CqonKygri
wegKYpAVY7NT68v3MYx1yEbUlD7wBNw+DOUHTBG6B6T8YGIqu0oXwfVYb8LF9BLDjuw/wMHt
ss9Yn40DsjZtQq52CSiC6U1KD06yDxMQPtpBF3hPHBDlPRGYnug5I5sOsvtggKjq1JGJyiye
qsE7QAMbOH7o5piHmqkh8hJj8xi/sdzEmwbwKXFoFpz9s7/9+oLVN+Yp8sKU4L5YS5/wKis1
Oqde5xPCRH/WhgDIjTXxq7seHR5xYavhYdA3rytFJa+tELkHl6BSJiCy7O8Yxi2am0uXO9o/
PB2+WWmaMHTur7GstQIAhCGp8URbJ2/ShQWsNLa0pwnw5vFV3rgvgPDdrf0AbTiBdQHec60N
P3NldeE1SrDk11FiHaDzv6l3bCMw0KqS+GQY0rZeFXgCXrXtkpk6Jy0gWrer4ZW1UsO+mmAD
tCgYkFReXZz8Nj5GowUjlXevnkGspt3InzoPiUCHeQpyBNn2CYGgeom6Gh+TXbtsr2th59mu
k8ZKPF2fZ6Kwv1VfpD5ChhsVmF3tuCkDqTkCE9hkAkyNQhhydoVbay+MrZk0d7zua8ocHzCB
t7LEmldb1OeleWha2e+p8MkRDMJ1NBHIPJhaJfjOnlXG6x+URLV/wYo9iHjCQwNStrITYd03
WEFiPQ5E4+h+YZrTNZ5eEwxH7Y/gMdg2k6X7hdkTN8AxUFLkYmJlQOa5jQsydXQZFmG5cHAG
wN8puO0xGkR3mrwBdYkwpR3nquNfm4vNB3v1V2wXACJ809o8UXOezllAb+G4s/O87so63Gfb
AB3vRsDcOZkajsmbBASXM18cB2Y15rnwQLg4w6mnIPaTwhEHcWIiFItgaEGU4qmDqava/27T
JQ2BmFsOoZLI2jsCNfd2gNc5miZWNlsf0eqmwhxBSB9jEXkbj6vVT8574ztiYsTHVrjmpSrb
9WkM6BSkoVEQK86UvwBrzd3hN2l8pploAsC0KvawEEmWrgC2TNUhZDygLsY/GgZoDo0/MIOJ
AsMz0Gpax8A44QgY7/AjYASBfGBa0VIAyBr+mUfCtxGVcMuAjFDaxOEb6GIjRBpBLeFfMbCa
ge+SgkTga5YTFYFX6wgQS4DdC58RVcQ6XbNKRMA7ZgvGCOYFeMWCx0aT0visaJpHoEliqfHB
B5E4lsAzGdpcvTrsH59e2azK9K2Tm4JTcmmJAXz1StIUALp0vfoCF1V4iO5tKpqCNiWpe14u
gwNzGZ6Yy/kjcxmeGeyy5LU/cG7LQtd09mRdhlBk4agMA1Fch5D20nlBjNAKYmFqnGO9q5mH
jPblaFcDcfTQAIk3PqI5cYhNgtkwHxwq4hH4HYah3u36YfllW2z6EUZw4MxRRy172QKA4E8g
4VVK7/ZZWrjWdW8rs13YpF7uTAIe7HbpOqpA4V/JjKCIFkskT8F7nVo9DD80ddijOwjx1cv+
EPwYVcA55nT2KJw4r6yb0QmVkZIXu34QsbY9gW/gXc7dD5BE2A/47meTjhAUIj+GFiqz0Pgi
uqqMv+9Azc9adA6ADwZG4NXGukBW3W/ERDtoPcGwUaHY2FjMWqoZHP4cQzaH9Gs4HeRQ/DKP
NRI5gzfy77HWXY0D2ANaxzG5nWGwEYrqmSZg+iHIZjPDICWpUjKz4JmuZzDL87PzGRSXdAYz
uYtxPEhCwoX5oYk4garKuQHV9exYFanYHIrPNdLB3HXk8NrgUR5m0EtW1HYAFh6tvGjAbXYF
qiIuQ/iO7RmC/REjzN8MhPmTRlgwXQRKlnLJwgHhz5WBGpEkjeqp/+fsTZvjxpU20b+ieCdi
4py4b08XyVpYN6I/cK2ixU0Eq4ryF4baVncrjmx5JPmc7vvrLxLgkgkkyz3TEW27ngcbsSaA
RKYUxGXP6+5JesNiYkO9SFoOpju6GR+mD8TIKj4Vh4TMNG1PZkH5WwoUF1uuUCEHozYGWJZa
KY/AdHIEwA4DtUMRVZEUMtrVFvABq8IPIHsRzJy/FVS1gZnjh8SsAY3pijW+Fa6yKaYu72gF
ZqEFMImpEwqC6B278WXC+KzW6jIt35HiU20vITLwEp5eYh6Xpbdx3U30uZf5bYjjRnE3dXEl
NHTqTPbt5tPLl1+fvj5+vvnyAsfob5zA0LV6bWNTVV3xCq3HD8nz/eH198f3payGN1TazCGf
5hBEGekRp+IHoUbJ7Hqo61+BQo1r+fWAPyh6LKL6eohj/gP+x4WAE09lruV6MFCovB6AF7nm
AFeKQicSJm4JZnV+UBdl+sMilOmi5IgCVaYoyASCg75E/KDU09rzg3qZFqKr4WSGPwhgTjRc
mIYclHJB/lbXlbvvQogfhpFbadE2aq0mg/vLw/unP67MI210VBcRavfJZ6IDgYGma/xghO1q
kPwk2sXuP4SR24CkXGrIMUxZgiWDpVqZQ+lt4w9DGasyH+pKU82BrnXoIVR9usoraf5qgOT8
46q+MqHpAElUXufF9fiw4v+43pal2DnI9fZh7gTsIE1QHq733qw+X+8tudtezyVPykN7vB7k
h/UBxxrX+R/0MX3cAk+ZroUq06V9/RSEilQMfyl/0HDDjc/VIMd7sbB7n8Pctj+ce0yR1Q5x
fZUYwiRBviScjCGiH809aud8NYApvzJBlC7Aj0Koc9EfhFLP5a8Fubp6DEFAG/VagJPnSn5+
z3HtfGtMBh5YJeQEFH6rR2buZmugYQYyR5/VVviJIQOHknQ0DBxMT1yCA07HGeWupQfccqrA
lsxXT5na36CoRUImdjXNa8Q1bvkTJZnRG96BVfbWzCbFc6r6qe8F/qKYoZ6gQbn90drWjjuo
NckZ+ub99eHr27eX13dQIH5/+fTyfPP88vD55teH54evn+By/e37N+CRHXuVnD68ao2Lz4k4
xQtEoFc6llskgiOPD6dq8+e8jdpQZnGbxqy4iw3lkRXIhtLKRKpzaqUU2hEBs7KMjyYiLKSw
w+Adi4bKu1EQVRUhjst1IXvd1Bl8FKe4EqfQcbIyTjragx6+fXt++qQmo5s/Hp+/2XHJ2dVQ
2jRqrSZNhqOvIe3/92+c6adwldYE6iZjTQ4D9Kpg43onweDDsRbg5PBqPJYxIugTDRtVpy4L
idOrAXqYYUbhUlfn85CIiVkBFwqtzxfLogbl/cw+erROaQGkZ8myrSSe1eaBocaH7c2Rx4kI
jImmnm50GLZtc5Pgg097U3q4Rkj70ErTZJ9OYnCbWBLA3MEbhTE3yuOnlYd8KcVh35YtJcpU
5LgxtesKDG8ZkNwHn5Q2vIHLvsW3a7DUQpKYP2XWS70yeIfR/e/t3xvf8zje0iE1jeMtN9To
skjHMYkwjWMDHcYxTZwOWMpxySxlOg5acjG+XRpY26WRhYjklG3XCxxMkAsUHGIsUMd8gYBy
azXZhQDFUiG5ToTpdoEQjZ0ic0o4MAt5LE4OmOVmhy0/XLfM2NouDa4tM8XgfPk5BocolfYx
GmHXBhC7Pm7HpTVOoq+P739j+MmApTpa7A9NEJ5yZdkXFeJHCdnDcrg9JyNtuNYvEvOSZCDs
uxLtacFKilxlUnJUHUj7JDQH2MBJAm5AT60dDajW6leEJG2LGH/l9h7LgGXLA8/gFR7h2RK8
ZXHjcAQxdDOGCOtoAHGi5bM/50G59BlNUuf3LBkvVRiUrecpeynFxVtKkJycI9w4Uw/HuQlL
pfRoUOveRbMGnx5NEriJoix+WxpGQ0I9BHKZzdlEegvwUpw2baKevHcjjPVcZLGo84cMBoGO
D5/+RR6ojgnzaRqxUCR6egO/+jg8wM1pRCxvKmLQitNaokolCdTgfsHmzZfCwetL3sDuUozS
sA6Mw9slWGKHV5+4h+gcidYmvFbGP3qiTwiA0cIteFr7gn/J+VGmSffVCqc5BW1BfkhREk8b
IwJ2prIIK78AkxNNDECKugooEjbu1l9zmGxucwjRM174Nb2ToCh24KSAzIyX4KNgMhcdyHxZ
2JOnNfyzg9wBibKqqDrawMKENkz29qN7NQUI7I1lAL4YgFzxDjD7O3c8FTZRYatgGQGuRIW5
FcwEsSEO4mIqlY/UYlmTRaZob3niVny8+gmSXyT2692OJ++ihXLIdtl7K48nxYfAcVYbnpRC
Abznn0nVxkbrzFh/OOOdOiIKQmj5aE5hkJfMxws5PguSP1w8eoL8FidwBptteULhrI7j2vjZ
J2WEHxN1Lvr2PKiRMkgNhtBRMbdyF1PjRXsA7DdMI1EeIzu0BJUSOs+A1EnvFTF7rGqeoJsi
zBRVmOVErMYs1Dk5msfkKWZyO0gC7G8c44YvzuFaTJg8uZLiVPnKwSHozowLYQikWZIk0BM3
aw7ry3z4h/Lnk0H9Y48bKKR5aYIoq3vIdc7MU69z+p2qEh7uvj9+f5Rr/8/De1QiPAyh+yi8
s5Loj23IgKmIbJQsbiNYN1llo+rajsmtMXQ9FChSpggiZaK3yV3OoGFqg1EobDBpmZBtwH/D
gS1sLKw7S4XLvxOmeuKmYWrnjs9R3IY8ER2r28SG77g6Aj9VTCXBM2aeiQIubS7p45Gpvjpj
Yo863nbo/HRgamkyazcJjqPMmPJ+S2aRMl5wVDEn8DcCCZqNwUrBKq3Uy137DcnwCb/817ff
nn576X97eHv/r0Ev/vnh7e3pt+Fwng7HKDdeYUnAOhQe4DbSx/4WoSantY2nFxvTd5oDOACm
c7wBtR8YqMzEuWaKINEtUwKwy2GhjMaM/m5D02ZKwriQV7g6kgIjMIRJFGy8Y52ulqNb5BsT
UZH5+HLAlbINy5BqRLhxejITYGOKJaKgzGKWyWqR8HHIE/ixQoLIeNQbgG476CoYnwD4IcD7
90Og1eBDO4Eia6zpD3ARFHXOJGwVDUBT+U4XLTEVK3XCmdkYCr0N+eCRqXepS13nwkbpEcmI
Wr1OJcvpPWmmVe+5uBIWFVNRWcrUktZitt/46gwoJhNQiVulGQh7pRgIdr5QU3qGH6TFEWr2
uATvGaIC5+VovyZX/EDZo+Gw8Z9I2xyTecDiMX4Tj3BsnBbBBX0/ixMypWWTYxnl741l4OSS
bDgrucE7y50cTCxfGJA+TMPEuSM9jsRJyuSMop3HV9wWYpwsaBspXHhKcDtC9XyCJqdGChn1
gMida0XD2JK9QuVwZ94Hl/jy/ChMyUfVAH2dAIoWHhy/gwIOoe6aFsWHX70oYgORhTBKEGEX
0fCrr5ICDNb0+pwf9bIGW4tvUuXLGr+56zB/vITY9L42CAM5qmHIEdbrdbU3BTfG4r6nXi7D
O9sNJAVE2yRBYVm1giTVpZg+bKamGW7eH9/erY1AfdvSxyCwT2+qWm7wysy4YLASMghs/GGq
qKBogjib7PPWD5/+9fh+0zx8fnqZlFyw5Vuyc4ZfcoooAnB8eKbvZ5oKzfgNmAwYjoCD7n+5
m5uvQ2E/P/776dNo0BXbC7rNsEC6rYnialjfJe2RTn73cij14Lk3jTsWPzK4bCILS2q0tN0H
Ba7jq4WfuhWeTuQPevEFQIhPqwA4XMbqkb9uYp2uZXcYQp6t1M+dBYncgoiiIwBRkEeg1gJv
nPFEClzQ7h0aOs0TO5tDY0EfgvKj3O8HpUfx23MAbVBHWZLGRmFP5TqjUAeOLGl+tZbCjG9Y
gOTGJWjBGCTLRUZuUbTbrRgIPPNwMJ94lmbwt/l1hV3E4koRNdfKP9bdpqNcDW6I2Br8EIDj
CAomhbA/VYNgKN9oXt/ZrpylJuOLsVC4iHalAbezrPPOTmX4ErvmR4KvNVGldNlDoBQ+8dgS
dXbzBP5of3v49GiMrWPmOY5R6UVUuxsFziqmdjJT8icRLibvw4mlDGA3iQ2KGECXogcm5NBK
Fl5EYWCjqjUs9KS7KPlA40PoVAIGFLU1H+JYlpm7prkV3zfC3XESY3uPcq1NQRQigTTUt8QQ
pYxbJjVNTALyey2LxSOl1R8ZNipamtIxiw1AkAjYqrb8aR3+qSAxjWMb00Zgn0TxkWeILwa4
BJ4kaO3u4/n74/vLy/sfi0so3HaXLZb6oEIio45bypP7BKiAKAtb0mEQqP1DmC4YcIAQ24jC
RIG9lWOiwW7ZR0LEePek0VPQtBwGaz2RTRF1XLNwWd1m1mcrJoxEzUYJ2qNnfYFicqv8CvYu
WZOwjG4kjmFqT+HQSGyhDtuuY5miOdvVGhXuyuuslq3lTGujKdMJ4jZ37I7hRRaWn5IoaGIT
Px/x/B8OxTSB3mp9XfkYuWT0MTtEbW+tiBKzus2dnGTIXkWXrVF+AGZ/M0vDbZKFU7ldaPBF
9IgY6nUzXCp1t7zC1jUm1tgUN90tsQue9rd4JC/sOEAvr6E2pqEb5sSgx4jANQpCE/VaF/dZ
BYGJCQMS9b0VKEMDMEoPcCWCuoq+enGUD5eiwi/vx7CwvCS53Is3/SVoSrmOCyZQlMjd9OgK
va/KExcIjCLLT1TOf8BaWnKIQyYYmOLURsV1EOUKgQknv68J5iDwGH72rYMyBb+teX7KA7nz
yIjhDRJI1n3QKQ2Dhq2F4Uybi25bUZzqpYkDxmfhSF9ISxMYLsNIpDwLjcYbEZnLfS2HHl6N
DS4iZ7YG2d5mHGl0/OE+DeU/IsrkfhPZQSUIFixhTOQ8Oxm7/DuhfvmvL09f395fH5/7P97/
ywpYJOLIxKdywARbbYbTEaO9Seq8kcQ1HO1MZFlpS7UMNdjsW6rZvsiLZVK0lgXPuQHaRaqK
wkUuC4WlwzOR9TJV1PkVTi4Ky+zxUlguoUgLamfFV0NEYrkmVIArRW/jfJnU7cq4MMRtMDzF
6pTP1NmHwCWDR2tfyM8hQeU8bnYX0aS3Gb6I0b+NfjqAWVljW0ADeqjNM+x9bf4erUObsGkE
NsjQeT784kJAZOPcQoJ0+5LUR6XVZyGg9CO3DmayIwvTPTlHnw+vUvLWA5TGDhmoBhCwxKLL
AICZZxukEgegRzOuOMZ5NB8IPrzepE+Pz59vopcvX75/HR8M/UMG/ecgf+An8zKBtkl3+90q
MJLNCgrA1O7ggwIAU7znGYA+c41KqMvNes1AbEjPYyDacDNsJaA8mCo/KDzMxCBy44jYGWrU
ag8Fs4naLSpa15F/mzU9oHYq4GbKam6FLYVlelFXM/1Ng0wqXnppyg0LcnnuN0pRAB0X/63+
NyZSc5eM5D7NNqU3Iupab77WAj9a1L70oamUGIUNHCsf90GexeAPsSsy40JV8YWglvNAnFQ7
hAlUtp2pTek0yPKKXKlpxzzzGb9W/V04nVWBicF884ftNBCBtgtOOE2DEUuMdo/OdiEmBKDB
AzyRDcCw0cBHqZn8qqgxsgoEccc4IJbnxRm3tEAmTrmXELI+eNffJBjIqX8rcNIo9z5lxGki
q2+qC6M6+rg2PrKvW+Mj+/BC26MQRqvB9uHWbDSrVtQDfjAkrn0oq7MRGkC0p5C0Qq/uikyQ
GGwGQO6daZn7rDpTQG64DCAgt1mo1/BdKVpkxLGelib5++bTy9f315fn58dXdOSkzz8fPj9+
lSNDhnpEwd7sV9Gq3qMgToiReowqT0wLVEJ8BvwwV1wtaSv/hBWQVJb24GeYeJ4IdlwOVxQ0
eAdBKXT2epEUmRE5gKPIgDa7yqs9nsoYDt2TginJyFodIunlrvw2Omb1AqzrbJi+3p5+/3oB
b4nQnMpegmAbKL6Yo+nSJ7UxDppg13UcZgYFd2FtnURbHjVa9WopJ+clfHecumry9fO3l6ev
9LvASWMtN0utMcgGtNdYao5BOVRbraJKsp+ymDJ9+8/T+6c/+GGCJ4PLcMUOXniMRJeTmFOg
52nmBYv+rXyI9VGGjwhkNL2eDAX+6dPD6+ebX1+fPv+Ohcp70Iad01M/+wpZytWIHBfV0QTb
zETksIDb/8QKWYljFqLDzDre7tz9nG/mu6u9i78LPgCeo2h/lWiPEtQZOe4bgL4V2c51bFxZ
Nh7NXHorkx5m8abr207JzcLKS7mUTMoD2XVPnHF+NyV7KkzVwZEDJxGlDReQex/pjZBqtebh
29NncGej+4nVv9Cnb3Ydk5HcqXYMDuG3Ph9eTm2uzTSdYjzcgxdKN/tCffo0CE83lemL4qSd
Ag6Gmf5i4V65JpjP3GTFtEWNB+yI9IUywDuLji3YGs2JV0q5S1RpT/51waHppKk9OZYFOx/Y
WEN6UYMLC4sTpGTLWCaEZFt9ajg56Z1LP8c6KSUF48tZWkqq2gs4Fw75o7P94w6fMcZS3kLh
VhI54xkokGUuC9wSqq4FlUN5C03OTSJMVN1z6QhSeioqrEKiuECfyugQygnsXN2j31ZwugKy
lqbxNoF6u2mSA/Hvo3/3QbRHT2sGkOySBkzkWQEJWjh24zphRWYFvDgWVBRYHWnMvLmzE4wi
JCXCvCOOsh+pTpaS6pZUqqQkbeEPu8Hkx56+Tfz+Zh8swNMp0Yb9IYOrvgYdmt8pPZkwwx4r
MtgFgv9yXUnzzQlKelqFKrn7i7T+0ticJdb3gV9wkZfhYxcFFu0tT4isSXnmFHYWUbQx+aH6
m6AQdpxmUFXKoUGz4+AwKrZe102U4Vnw28PrG9V9knH0TU6fFXIqaYkq4Ey2TUdx6BO1yLky
yL6inIBfofR7YeWnSrk5+8lZTKA/lWqvI3fg2BmpFQxOa6oyv/+F9Tg3friqj9MbuGDXZmVv
Ahm0BWNLz/rkIX/4y6qhML+Vs4pZ1Tlx1T1BUhBGE3VLTRMbv/oGyb0Z5Zs0ptGFSGM0V4iC
0qqvVLVRSuXZymxR7ZtPDmmtXzmuQE1Q/NxUxc/p88ObFAn/ePrGKMtBZ00zmuSHJE4iY84E
XM6b5lQ6xFeKteD0osJHFCNZVoNDrtmP6cCEctG8bxP1Wbyv1SFgvhDQCHZIqiJpm3taBpgG
w6C87S9Z3B575yrrXmXXV1n/er7bq7Tn2jWXOQzGhVszmFEa4iZpCgQaBOTpwtSiRSzMmQ5w
KQkFNnpqM6PvNkFhAJUBBKHQDxdn+W+5x2o/fg/fvoEu6gCCkz8d6uGTXCPMbl3BstKNftuM
fgkWHAtrLGlwtATORYDvb9pfVn/6K/UfFyRPyl9YAlpbNfYvLkdXKZ8leFiWWxasQoTpQwKu
Sxe4Worayh8foUW0cVdRbHx+mbSKMJY3sdmsDIxo32mA7iJnrA/kluteitNGA6ie15/B1Xtj
xMuDtqHKsz9qeNU7xOPzbz/BzvdBGRqXSS3rCEM2RbTZOEbWCuvhohV7sEWUeRMnGfACmubE
UDyB+0uTaf9nxG8LDWONzsLd1L5R7UV0rF3v1t1sjVVBtO7GGH9SdFjvuk4wJRO5NTjrowXJ
/01M/pYb7zbI9VUidvE4sEmjvJUD67g+KQ8spq4WnvRp0tPbv36qvv4UQTsunYyrSqqiA7bt
oi0SSxm/+MVZ22j7y3ruOD/uE2QAyE2e1lyhy3CZAMOCQ7PqNjYm3CHEeArIRrfafSTcDtba
Q4PP66YyJlEEx0DHoCjomw0+gBQuIkPYCi69/U04aqie2Q2HBv/5WUpcD8/Pj883EObmNz1B
z0emtMVUOrH8jjxjMtCEPYdgMm4ZLijgJjxvA4ar5GznLuDDtyxRw77djiv3/Nh75IQPwjLD
REGacAVvi4QLXgTNOck5RuRRn9eR53YdF+8qC5uvhbYdJoWSmRR0lXRlIBj8IHelS/0llduG
LI0Y5pxunRW9FJ8/oeNQORGmeWSKwbpjBOesZLtM23X7Mk4LLsHyFO3NxUsRHz6ud+slwpx3
FSHHUVJmEYwPpjPp9BTJp+luQtUPl3JcIFPBfpc4lR1XF8dMZJvVmmFg4821Q3vLVWlyaLhR
JtrCc3tZ1dxQKxKB36OhzpNxowjp42vh7untE51GhG25ZW5Y+QdRUpgYfbDMdKBM3Faluum4
RuodDuMW7VrYWB2brX4c9JgduKkIhQvDlllLRD2NP1VZeS3zvPmf+m/3RopaN1+0W2BW1lHB
6GffwTPXaTs3LZg/Ttgqlim/DaDSk1krn2RthZWTgA9EnYBzc9y5AR8v6u5OQUyUGYCEzt2L
1IgCxzpscFBzkH+bu9tTaAP9Je/bo2zEIziDNuQaFSBMwuHxnbsyOTAYQA4IRwI8WXG5hdQZ
PMDH+zppyCHhMSwiueRtsT2QuEVzD94uVCn4UW7pawEJBnkuI4WCgODaHNwhEjAJmvyep26r
8AMB4vsyKLKI5jQMAoyR88hKKWWR3wW5dqnAjqdI5JIIc0lBQg66VgQDhYs8QBJ1LZdlYgB8
APqg8/3dfmsTUkZdW/HBfUuPb//D/Ja+WR0AubrI6g2xCSGT6bW2qNajoN7XY7IhHiPCxaYQ
MC9n9bC+T4chH6UwyBx+jFFPRcIkmFfY6A5Gla927WjQN3mlZ1vxceMmRHIA/Fr+yqk+cJQR
FJ1vg2TPgcChpM6W46ztiKpdeAMbxWf85A3Dwwm4mL+e0hdDoyiAe0y4TiA20oZn2aQXzJjc
aWOdkKnMXHU0QjW31uQ7F4l9tw6osT+ZKvhMnB1AQMYZt8LTIGyySBihieoiAMR2nkaUiVQW
NLoZZuyER3w5js571ivDtTEJC/a1g0hKIZcasOnv5eeViyo5iDfupuvjumpZkF7cYIKsK/Gp
KO7VvDbPJcegbPFQ1icbRSZFHOw9VxxA+yZCs3mbpYXRnAqSEjo6l5BNtfdcscaPLNWGQm77
UZHlsplX4gSvFeQUqt7XzUtJ3Wc5mmnVJUxUSXma7D4UDIsZfYxSx2Lvr9wAm9zIRO5Kwdoz
EXx4NLZGK5nNhiHCo0Oez464ynGPXxIdi2jrbZDQGQtn65PbfXDKgvWhYCHLQOUnqr1BMwPl
1Jh6UZMSR0usiWldnV7EaYLFcFAAaFqBSlif66DEm/zIHdYi1V+TREpaha3OpHHZni7qFzO4
scA8OQTYOc0AF0G39Xd28L0XdVsG7bq1DWdx2/v7Y53gDxu4JHFWal8xDUrjk6bvDndy00d7
tcZMfeoZlOKgOBXT9YGqsfbxz4e3mwyeT3z/8vj1/e3m7Y+H18fPyJXG89PXx5vPciZ4+gb/
nGu1hWNqXNb/i8S4OYXOBYTR04c2UwAmmh9u0voQ3Pw2Xp9/fvnPV+XxQ/s/vPnH6+P//v70
+ihL5Ub/RGYSlH4XnDLX+Zhg9vX98flGClxSLn99fH54lwWfe5IRBC5N9THayIkoSxn4XNUU
HRcvKRloQdRI+fjy9m6kMZMR6AIx+S6Gf/n2+gJnty+vN+JdftJN8fD14fdHaJ2bf0SVKP6J
TgOnAjOFRcuuUnUbXAfNJryv1N7UyaNjZQzvIJd92DikGof9Eky0xo9BGJRBH5DHgGTdmkOe
Ezn4sCPyeDJ6UT8/Prw9Snnv8SZ++aR6r7rZ/Pnp8yP8/79eZavAeTg4Bfn56etvLzcvX29k
AnrDhlZHifWdFHh6+m4OYG3JQVBQyjs1I7sAJSRHAx+wpxT1u2fCXEkTCySTpJnkt1lp4xCc
EaAUPL1ZSpqGbDtRKFmIhBa3DcQtrM74CTHg8Gaxn59OQ7XCvYOUvsc+9POv33//7elPs6Kt
Q99JwLfMEKCCKfWMNP0FKc2iLBl1WBSXqOGOeJWmYQX6fhazWEC4xt1itTejfGw+QRJtyWnk
ROSZs+k8hiji3ZqLERXxds3gbZOBKREmgtiQSyuMewx+rFtvu7XxD+qZCNPdROS4KyahOsuY
4mSt7+xcFncdpiIUzqRTCn+3djZMtnHkrmRl91XODIKJLZML8ynnyy0z0ESm1EUYIo/2q4Sr
rbYppLxn4+cs8N2o41q2jfxttFotdq2x28OeabymsXo8kD2xxNYEGUwsbYM+TG27yK9eZ4CR
wWKWgRpDXhVmKMXN+1/f5NItpYR//ffN+8O3x/++ieKfpBT0T3tECrztPDYaa5kabjhMzmJl
XOF3vWMSByZZfHKsvmHaDBh4pLRfyZNihefV4UBejipUKIM+oEhHKqMdZaY3o1XUwZ7dDnKn
x8KZ+pNjRCAW8TwLRcBHMNsXUCUSEIMYmmrqKYf5stD4OqOKLvpZ5Lw+KJxskzWk1Ji0ATqj
+rtD6OlADLNmmbDs3EWik3Vb4WGbuEbQsUt5l16OyU4NFiOhY41N5ihIht6TITyidtUHVJ1c
Y0HE5BNk0Y4kOgAw44NbsmYwDINseI4h4FwQ1E3z4L4vxC8bpHgxBtEbCa17jc5sCFvIVf4X
Kya8pdcvPuExDHWXMBR7bxZ7/8Ni739c7P3VYu+vFHv/t4q9XxvFBsDchukukOnhYvaMAaby
rp6Bz3ZwhbHpawaErDwxC1qcT4U1V9dwIFOZHQjuZOS4MmFQNm3MGVBm6OKLCblvVguFXBbB
Lt5fFoFNCM1gkOVh1TGMuRGfCKZepMDBoi7UinqZfSD6EjjWNd7VqSInHNBeBbyLuctYpxuS
P6XiGJljU4NMO0uijy+RnOZ4UsWyRNopagQPpa/wY9LLIaAPMnAorD4M5we1Wcn3TWhD2C1G
FuIDSvUTz6j0l65gcs4zQcNgTc21NS46z9k7Zo2n+vEmjzJ1fYhbc5XPamtJLTPyhH4EA/J0
Wxe5Tcz5XdwXGy/y5RzhLjKwAxiuekCxRG0lnaWwg62MNpBby/ng3ggF/VuF2K6XQhBd9+HT
zQEvkUlx3cTpawMF30mRR7aZHFRmxdzlATmzbqMCMJcsXQhkJzxIZFyJp+F5l8QZq+UqiXTB
qw5IHnUaLQ3mOPL2mz/NCREqbr9bG3Apas9s2Eu8c/ZmP9AfRLG64Jb0uvC1PE9LHKZQhUtl
Nu08aAHomOQiq7jxNkpeo5IhOrfVCobHwNm4+CxW49YIG/AyKz8Exg5hoHSvsGDdFTfWGMIG
2Aagb+LAnB0keqx7cbHhpGDCBvkpsMRSYzs0Leot8RsU0NMPVDrg6mJ6yhmh167/eXr/QzbU
159Emt58fXh/+vfjbL8PifiQREAMUChIOQxJZC8tRs/pKysKM8ErOCs6A4mSc2BA+m0sxe6q
BrudUBkNerAUlEjkbHHv0IVSjwGZrxFZjo/iFTQfyEANfTKr7tP3t/eXLzdyZuSqTe7H5YRZ
BEY+d4K8YdF5d0bOYYF3xRLhC6CCoSNkaGpyNKFSl0utjcAZgrEzHhlzWhvxM0eAXgtoN5t9
42wApQnAHUImEgNtosCqHKxgPiDCRM4XAznlZgOfM7MpzlkrV7P5wPXv1nOtOhLOQCPYIpxG
mkCACdjUwlsssGislS1ng7W/xc8xFWoelGnQOAybQI8FtyZ4X1N/HgqV63hjQOYh2gRaxQSw
c0sO9ViQ9kdFmGdnM2jmZh3iKdRStFRombQRg8LygBdKjZqncQqVo4eONI1KSZSMeIXqgzmr
emB+IAd5CgXT2mSno1H8YEgh5tHkAB5NBLRqmkvV3JpJymG19a0EMjPY+NzaQM0j2doaYQq5
ZGVYzcprdVb99PL1+S9zlBlDS/XvFRWFdWsyda7bx/yQitzA6/o237sr0FqedPR0iWk+DmaT
ydvk3x6en399+PSvm59vnh9/f/jEaOPphco4eldJWhtK5tAeTy2F3INmZYJHZhGr852VhTg2
Ygdak2cFMdIfwagS6UkxRzfaMxZqzRnjt7miDOhwUmkdHEyXQIVS0G4zRq0oRu0SWwZnVMwU
i5pjmOFpXxGUwSFpevhBjj+NcMq1jG1eD9LPQIcyI4qvsbI4I8dQC6/DYyKiSe4EhgOzGjtd
kahSuCKIKINaHCsKtsdMvcE7y11xVRLdf0iEVvuI9KK4I6hSMLUDE8Mi8jf4hsFCioTAIzA8
Jxd1ENHIdHcggY9JQ2ue6U8Y7bHLL0KI1mhB0PojyMkIol/9k5ZK84C4Y5EQPN1oOahPsS1y
aAvDO8hQE6oeBYFB+edgJfsRnmfOyOh+nqr+yC1lZrxCBSyV0jXuw4DVdPcCELQKWrRAtypU
vdZQ2lJJorlnOMU2QmFUH04joSmsrfDpSRC9P/2b6ksMGM58DIYPxwaMOfYaGPI+YMCIH5YR
my419N1tkiQ3jrdf3/wjfXp9vMj//2lfL6VZkyh7y19MpK/IbmGCZXW4DExcQc5oJaBnzMoJ
1wo1xta2DAeT6eO0m2GjbolpcBeWWzo7gOLa/DO5O0nJ9aPpeCtF3T4zvfW1CVbNHBF1BAQe
vYNYufBZCNBUpzJu5FaxXAwRlHG1mEEQtdk5gR5tehabw4AZizDIQW8frU9BRP1CAdDil59Z
rTyP5h7Wf6hpJPmbxDE8/5jefg7YOrzMUGDtMRA7q1JUhuW7AbOVqyVH3cgo9y4Sgeu8tpH/
IDYo29Ayftlk1DOp/g3macyXegPT2AxxwUPqQjL9WXXBphKCWLo/c6qypChlbrm1PTdoo6Tc
HZEg4lTKnT68cJ2xoKEeYvXvXsrGjg2uNjZI/KwMWIQ/csSqYr/6888lHM/TY8qZnNa58FJu
xxs1g6Bir0liZRnwDK3tnGBj4ADSIQ8QuawcXFEHGYWS0gZMyWqEwTKTlLEa/Opg5BQMfczZ
Xq6w/jVyfY10F8nmaqbNtUyba5k2dqYws2sT6rTSPloewj+qNrHrscwieFNOAw+gekMjO3zG
RlFsFre7HXhkJiEU6mKNWYxyxZi4JgKtnXyB5QsUFGEgRBBXxmfMOJflsWqyj3hoI5AtouEj
PbOsKqsWkQuhHCWGh/URVR9gXUSSEC3crYIRifnKgvA6zxUptJHbMVmoKDnDV8ipTJYiDVRr
r6hsFrdYlFQIqFlor1kMfl8SLzoSPmJJUSHTAfz4Dvv99enX76AXORjeCl4//fH0/vjp/fsr
5x1kg7WYNkordjTeRPBCWTPjCHh5yxGiCUKeAM8chstH8DoeSmlWpK5NGG8LRjQo2+xuyW97
0e7IMdmEn30/2a62HAWnTerd3jUn7SQU75HdCmLY8iVFIVdRFtUf8kqKQS4VGGiQGj87H+lF
3+4Dwce6iwKfcVwPNk3bRO6dC+YzRCGiZT/zmDXMDnMh6CuyMchwqisFiGjncfVlBODr2wyE
joNmg5N/cwBNsjf4nyNP4ewv0OpfvQePds37Li/a4Lu9GfWR+cNz1ZAL3va+PlaWpKVzCeKg
bvGOdwCUrZOUbIZwrEOCdxxJ63hOx4fMg0idOODrsjyLKtNx9BS+TfBmMogScuWuf/dVkUk5
IDvIxQLPslqBvhULpS6CjzhtQmE3KUXsO+CzAwuwNUhh5Gh4uFEsIrIdkJF7uWdObIR6Y4XM
jdutCerPLv8BcucmJzF0Qh7cqTd3bGBsqVn+AAfDkXHuMMJocwiBJrOwbLrQhSsib+ZE1sgd
+iuhP3Fj5gud5tRUDf5K9bsvQ99frdgYeg+KB0yI7c7LpQLqFatglh12k0b6mOpXnvm7P16I
pV+lg0cTlBNJQ4wshwdSueonFCYwMUYJ5l60SUHftMo8jF9WhoBpt9qg/w27YoMknVAhxnfR
WoVH2Th8wFa/ZZRZfhM6QYBfSig6XuS0gvUxFEO2O3r3lXdJHMjBQKqPZHjOTgVb6EGbAKvP
avWCFnsqnLDeOTBBPSbomsNofSJcKTMwxDm1kyGeKPCnZCJCH0JnQhxO9pKsRANGX4fPq82c
YwdmoMmB6Z74gNS/QeCNksk649F0ZhuXpvfyoSRxQg8v5C4xz4i1T9dZ4YvLAZALbj6L1TrS
F/KzLy5oph8gohyksZI8Mpkx2fekoCWHckBfKcfJukNiz3Bd1ftrWinOCk0XMtGNu7W1Trqs
icxjrLFiqLZ5nLv4vvxUxvTkakSMT0QJJsUJrt/moZm4dIJTv61JS6PyLwbzLEydpzUWLG7v
j8Hlli/XR2pQXP/uy1oMVy4F3IwkSx0oDRopgaCH/Wkr5wCiwpa2BxPCCTRJIuQEggYfeb8J
JmtSYjEZkPrOEMQAVNOPgR+yoCQ34hAQviZioB4P9hmVojTcfOHD/pmU3RTMS6t5ktw44W88
fchagfw5jVpPxfmD4/Nr6qGqDrhSDmdeSAKdS5DPUKc5Zt3mGLs9nY2VgnCaGFi9WlO56Zg5
XufouHOKpTDqVSLkB0jgKUVon5GIR3/1xyjH71gURqbnORRuGPzxqOMe66UudjwFlyRjWybz
3Q02bI8p6rAxIakn1BOv+omfqR1C8sMc1hLCX5R1JDwVR9VPKwFbQNVQVgs8pSvQzEoCVrg1
Kf56ZSYekEQkT37jqTAtnNUt/nrU3z4UfCcedT5mOeO8XcMejnTN4kz7YAEn2aB5NerkGwwT
EkM1vguqu8DZ+jQ/cYu7J/yyFK0AA0lVYOv7crrFupvylxkPf7r87qCssAXDvJNjEt+CaIC2
iAIN+3cAmUYPx2DatDu265p3G8XwxlzzTlyu0umFURrFH5ZFxOferfD9NaoX+I1P9/VvmXKO
sY8yUmdLnCiPyli/ysj1P+DznxHRV8CmaUfJdu5a0iiGbJDd2uPnZZUldfZRiEjucKMkh6dE
xu2zzQ2/+MTvsYcX+OWscB9MkyAv+XKVQUtLNQJzYOF7vstPkfKfSUPkLOHioXbucDHg12jc
HdS46Rk0Tbapygo77ClT4oes7oO6HnZAJJDCg1AdoFNieSzhE9xSKaP+LRnG9/bEVYzWVO7o
LZVplmgABqsNqDSu4TZ9SK+OlrIvz1mMzwiULB+TmQiFrm6Jm5ljTxYLGavi9xx1EN0m7eDI
AnuaCuRKf0TlvU/AJ0BqXv4OyQxa11P0uzzwyBHnXU435/q3ue8dUDKjDZi9ve3k3EfTxAoa
d2CbzEg9ifl1Bm7SlQPyOWgU7MhSPgD0iHEEqVM5bR+fCFRNsdTKoA845dpsV2t+IA5HsXNQ
3/H2+CYQfrdVZQF9jTceI6gu/dpLJohT9JH1HXdPUaVj3Ayv4VB5fWe7XyhvCc+30LxxpIto
E5z5zTIcWuFCDb+5oCIo4CYZZaJknaUhIpLkjp0fRJUHTZoH+CyU2qgDh4BtTNi+iGJ4xVxS
1OhyU0D7eS74WoRuV9J8NEazw2XN4JhyTiXauyvP4b+XCB+ZIFY05W9nz/c1OJlHEYto79h7
ZAVH2DtPUmd0Nwfp7B0cVyHrhbVGVBFoLmDnxELO1uSSDAAZxdTFmJJo1TKMEmgL2PtR8U1j
IslT7fbBDG0f4sUXwEFz/q4SNDVNWeqgGpaLTEPOdTWc1Xf+Cp87aDivI7nrs+AikcsAjH0L
F3bShvVXDeoJqT3eVRZlHxFrXDYGGL+xYKyLO0IFPk4fQGrbdAL9zGqHJRlOhsarUV3fFwn2
4aF1SObfUQDP2XBa2YlP+L6saoG9e0PDdjndFs/YYgnb5HjC3q6G32xQHCwbDeEaiwQi6Iam
BQ99UuyGAzyBZeeBMELiLj0A1NpCS246cDFNj1xt5G18Z8MGPmPhRP7om2OGr0EmyDj8Ahy8
u0dEwxIlfMk+kqs1/bu/bMjsMqGeQqctyICHJzH4NGE3KihUVtrh7FBBec+XyL50HD7D9BE4
2CGDNs/BOOwXgwg6s0MMRJ7LrrV0gj6cVZpiKsAufluaxjEekElKJhr4ab7RvMUSuZwiiKej
KogbcOKKFuYZkxulRsrYjeGyQTtGO5NTAQUSm6kaAUVasOLB4KcyI5WhiawNA2JGfUi4L04d
jy5nMvCG0WNMqbm3PzhusBRA1mWTLJRn0IvOky5pjBBMntwBnSLItbpCiqojkqgGYatZZMTQ
MuBVpK5oKShn1XVmYMb1ppyF1CE4BfAT7Qso9k3tnktBvG2yA2jpa0Kbf8yyG/lz0b+DwN0P
7l6ptuBwhWqgevMVGmjrr7yOYpNXJgNU1iRM0N8xYB/dH0rZnhYOg9OskvFek4aOsiiIjU8Y
7oAoCMuCFTuuYd/u2mAb+Y7DhF37DLjdUTDNusSo6yyqc/NDtYHM7hLcUzwHuw2ts3KcyCC6
lgLD2R4POquDQegB15nh1WGSjWk1nAW4dRgGzkQoXKobpsBIHSxSt6BLY3aJOzuFUX/GANXO
yABHT60EVSoyFGkTZ4XfFoKihOxwWWQkOCq9EHBYTw5y6LnNgaifDxV5K/z9fkPevZErvLqm
P/pQQLc2QLmcSBE6oWCa5WSzCVhR10YoNTMavrrruiKamACQaC3Nv8pdAxksIBFIORckmnmC
fKrIjxHlJueK2KS8IpS9DgNT6uzwr+0444HxxZ/enj4/3pxEONmjAqnj8fHz42dlARCY8vH9
Py+v/7oJPj98e398tR84yEBau2lQGf6CiSjAd1iA3AYXsmUBrE4OgTgZUZs2l8LeigNdCsJJ
KNmqACj/J6ccYzFhVnZ23RKx752dH9hsFEfq4ptl+gTL/pgoI4bQVz3LPBBFmDFMXOy3WAN9
xEWz361WLO6zuBzLu41ZZSOzZ5lDvnVXTM2UMMP6TCYwT4c2XERi53tM+EaKvtq+Fl8l4hQK
dThIr1HsIJQD7y/FZou9oSm4dHfuimKhNg9JwzWFnAFOHUWTWq4Aru/7FL6NXGdvJApl+xic
GrN/qzJ3vus5q94aEUDeBnmRMRV+J2f2ywVvmoA5isoOKhfGjdMZHQYqqj5W1ujI6qNVDpEl
TRP0VthzvuX6VXTcuxwe3EWOg4pxIcdG8JAplzNZf4mRhA5hZoXCgpw3yt++6xCVsKOlLEsS
wEbLIbCl533UtwTKZrOgBBjGGh7RaNe3ABz/RrgoabT9Z3LWJoNubknRN7dMeTb6gShepTRK
7GUOAcFDbXQM5H4np4Xa3/bHC8lMImZNYZQpieTCNqqSTo6vWimPoRs6xTO71SFvPP1PkM4j
tUo6lEDUcgPcBDnOJgqafO/sVnxO29ucZCN/94KcWgwgmZEGzP5gQK3HuQMuG3kwAzMzzWbj
ar/TU4+Wk6WzYjf7Mh1nxdXYJSq9LZ55B8CuLdqzi4S+rcCeocASuQXpqyOKBu1uG21Whslh
nBGnDYn19teeVkLEdC9ESAG56UyECtgr/z+Kn+qGhmCrbw4i43LOKyDXGJ8djCWjlw+A2sDx
vj/YUGlDeW1jx5Zicq8pKHK8NKWRvvlIfe2Z7/YnyE5wwO1kB2IpcWoRY4bNCplDq9aq1a4+
TowmQ6GAXWq2OY8rwcD0XhFEi2RqkExHNRQcg6ypyPs2HNbQn8nqi0vO9QYAblayFts/Ggmj
hgF2zQTcpQSAAMMcVYud/YyMtmQTnYiny5G8qxjQKIzc9EsG7XrVb6vIF7PDSWS9324I4O3X
AKitw9N/nuHnzc/wLwh5Ez/++v3338Gh5ujK+3+YyS9li2a36QHE38kApXMhLpkGwBgsEo3P
BQlVGL9VrKpWWyX5xykPGhJf8SG8SR62j2R5GAOAvx25TamLcaN1vW5UHLtqZjgVHAHnlmiJ
mp+OLNaT2esbsH80X2lUgjzB1b/hMWJxITeRBtGXZ+L5YqBrrIM/YvjiYsDwsJSbqyKxfitj
GDgDjWozFOmlh7cacmShDXreWUm1RWxhJbxnyS0YFkwbUyvmAqyllRPqS5XsGVVU0aW03qwt
uQswKxDVy5AAOdIfgMkUonaagT5f8rTnqwrEPr9wT7B02uQcIYVWfGs3IrSkExpxQansNcP4
SybUnrU0Liv7yMBgsQS6H5PSSC0mOQXQ3zJrisGwSjpei+yS+6y4hqtxvBWd7xekPLVy0J0f
AJYrWAnRxlIQqWhA/ly5VJ1/BJmQjIdDgE8mYJTjT5eP6FrhjJRWnhHC2SR8X5MSvT5Km6q2
ad1uxYn0JJqpbKLOgHxyzaahHZOSZGDvEKNeqgLvXXzxM0DChmID2rleYEOhGdH3EzstE5Jb
WDMtKNeJQHRxGwA6SYwg6Q0jaAyFMROrtYcv4XC9+cvwuQyE7rruZCP9qYTdKD6VbNqL7+OQ
8qcxFDRmfBVAspLcMDHSUmhkodanTuDS5qnBvtTkj54olzSCWYMBpNMbILTqlWF8/I4C54lN
G0QXam1N/9bBaSaEwdMoThpf7F9yx92QIxf4bcbVGMkJQLILzakeyCWnTad/mwlrjCasjtIn
hRZtyIqtoo/3MdbWglOkjzG1vQG/Hae52IjZDXDC6p4uKfGrpru2TMlt5gAoQc5a7JvgPrJF
ACkeb3DhZHR/JQsDT9O4Y1x90nkhig/whr4fBruSGy9PRdDdgAGf58e3t5vw9eXh868PUsyz
vNRdMrBtlLnr1arA1T2jxq4eM1pDVnsi8GdB8oe5T4nhkzz5RWopRFJcnEf0FzWNMiLG+w5A
9T6OYmljAOQOSCEddnImG1EOG3GPjwWDsiPHId5qRXQV06ChFzSxiLCXPXhpLDF3u3FdIxDk
Ry0mTHBPbJrIgmIFiBy0bIJudhyZB3Vo3DfI74KbI7RlSZIEupmU+Ky7F8SlwW2ShywVtP62
SV18GM+xzEZkDlXIIOsPaz6JKHKJ8VCSOumTmInTnYuV8HGCgVw0F/JS1PWyRg25wkCUMVLP
BWhW4+e6x1MZgynkvKWn4aUyjUQiwxBPgyyviNWJTMT4bYz8BQaBiCkNKdcbFsenYOoPUpUT
U2RxnCd0m1ao3L6Qn7Iv1iaUO5W6ZlQzzheAbv54eP2sPcxZjp9VlGMamd7KNKpuSxmcCqkK
Dc5F2mTtRxNXTpzToDNxkNpLqh+i8Mt2i5U+NSir/wNuoaEgZCIakq0DGxP4IV55xu+Bz0Vf
E7+sIzKtOYNTum/f3xf9DWVlfUIzgfqpdwFfKJam4LU4J9ZzNQPvZok9Lg2LWs5cyW1BbJEp
pgjaJusGRpXx9Pb4+gzz+WRh+s0oYl9UJ5Ew2Yx4X4sA34sZrIiaJCn77hdn5a6vh7n/Zbf1
aZAP1T2TdXJmQW1dHtV9rOs+NnuwjnCb3Bs+zEZEzj2oQyC03mywCGswe45pb7FP3gm/a50V
vtUmxI4nXGfLEVFeix1RaZ4o9TIYVA63/oah81u+cEm9J6ZNJoJqghFY9caES62Ngu3a2fKM
v3a4CtU9lSty4Xuut0B4HCEX1J234dqmwDLcjNaNg93UTYQoz6KvLw0x9zmxZXJp8cw0EVWd
lCAGc3nVRQaeKLgPHd8RMLVd5XGawdsFMEbKJSva6hJcAq6YQvV78MDFkaeS7xAyMxWLTbDA
+jLzZ8tZZs21eeH2bXWKjnw1dgvjBbSh+oQrgFz8QPGJYUKsVTG3b3ur6p2dz9DSCT/l3IbX
lRHqAznkmKB9eB9zMLxDkn/XNUdKQTGoQVnqKtmLIjyxQUbT6gwFUsStusrm2ASsVhHjOTa3
nK1I4M4EP69C+ar2zdhc0yqCgxw+WzY3kTQZVrLXaFDXeaIyMhnZ7BvipUTD0X1QByYI32no
rBJccX8tcGxpz0KO58DKyNCh1R82NS5TgpmkAvK4LArJodOwEYHnHbK7zRFmwos5FGtgT2hU
hdhm84QfUmxaYoYbrKRG4L5gmVMmF4sCvyydOHUrEUQcJbI4uWQggDNkW+BFe05OPVFcJGjt
mqSLX5FMpJSxm6ziygDOLnOyn5/LDpatq4bLTFFhgB8TzxwojfDfe8li+YNhPh6T8nji2i8O
91xrBEUSVVyh25Pc6hyaIO24riM2K6x8MxEgtJ3Ydu/qgOuEAPfKGwrL0LNx1Az5rewpUlri
ClELFZecRzEkn23dNdb60IK+GZrS9G+tHBYlUUDscM9UVpNnUog6tPhcAxHHoLyQdwOIuw3l
D5axtCcHTk+fsraiqlhbHwUTqBa/0ZfNINw+10nTZvgZLuaDWOx87POdkjsfGyW0uP01js6K
DE/alvJLERu5C3GuJAzaMH2BLWGxdN96u4X6OMHr1i7KGj6J8OQ6K+xyxCLdhUoBVeyqTPos
Kn0PC80k0L0ftcXBwYcjlG9bUZsW4u0AizU08ItVr3nT2gMX4gdZrJfziIP9Civ/Eg6WTewg
AJPHoKjFMVsqWZK0CznKoZXj4wibs6QUEqSD08WFJhkN7rDkoaribCHjo1wNk5rnsjyTXWkh
ovG+CFNiK+53W2ehMKfy41LV3bap67gLYz0hSyJlFppKTVf9xSdune0Ai51I7vocx1+KLHd+
m8UGKQrhOOsFLslTuJPO6qUAhkhK6r3otqe8b8VCmbMy6bKF+ihud85Cl5f7SykylgtzVhK3
fdpuutXCHN0Eog6TprmHtfCykHl2qBbmM/XvJjscF7JX/75kC83fglNBz9t0y5VyikJnvdRU
12baS9yqN1KLXeRS+MSyKOX2u+4Kh+1im5zjXuE8nlMK2VVRV4K8wiSN0Ik+bxaXtoJceNDO
7ng7f2HJUVrsenZbLFgdlB/wZs7kvWKZy9orZKLky2VeTziLdFxE0G+c1ZXsGz0elwPEpl6B
VQh4Ri8FqB8kdKjA6doi/SEQxBSuVRX5lXpI3GyZ/HgPdmuya2m3UmCJ1psT1sI1A+m5ZzmN
QNxfqQH176x1lySbVqz9pUEsm1Ctngszn6Td1aq7IlHoEAsTsiYXhoYmF1atgeyzpXqpiScH
MqkWPT6YIytslidkr0A4sTxdidYh21HKFelihvSAjlD0YS2lmvVCe0kqlTseb1lAE52/3Sy1
Ry22m9VuYW79mLRb113oRB+NrTwRGqs8C5usP6ebhWI31bEYJOyF9LM7QZ48DeeCGbY8ojHf
Bw+1XV+V5BRTk3J34qytZDRKm5cwpDYHRrksCMDShDogNGm1HZGd0JA5NBsWAXk3N9ySeN1K
1kJLzqqHDxVFf5aVGBAPosNVU+Hv1451+j2R8EJ5Oa4+5F6IDefzO9kl+MrU7N4b6sCi9doG
SS98VBH4a7saDjV+JT9i8BpeitSJ9QmKipOoihc49e0mE8EEsVy0QEo/DRyCJa5JwWG7XHUH
2mK79sOeBYdLmFE7nzYDmC0rAju5+ySgb+eH0hfOysqlSQ6nHBp5oT0auaQvf7Ea+67jX6mT
rnbluKoTqzgnfWFq9q1IjvetJztAcWI4n1i0H+BLsdDKwLAN2dz64KWA7b6q+ZuqDZp7sM/H
9RC9X+X7N3Bbj+e0gNrbtUQXnnEW6XKPm3YUzM87mmImnqwQMhOrRqMioPtYAnN5iCoaZhs5
mTWB/fnN2d3KBl+Y4RS93Vynd0u0MlKhuj1TuU1wBm215a4oV//dOKvNXFNk5uGGgsi3K4RU
q0aK0EDSFdoPjIgpDCncjeHGReCnIzq841iIayLeykLWJrKxkc2oyXAcdUGyn6sbUGPAJjFo
YdVP+JNal9dwHTTkdm9Ao4xcs2lULucMSpTGNDQ4ZmACSwiUUawITcSFDmouwyqvI0lhlZnh
E0F24tLRl+EYPxl1BOfttHpGpC/FZuMzeL5mwKQ4Oatbh2HSQh99THp8XAtOvgI5PRXtSOiP
h9eHT/Dc31I2BCMFU385Y13Wwd1c2wSlyJW5CoFDjgE4rBc5nGjNrzwubOgZ7sNM+yOclUTL
rNvLBabFtrTGJ2cLoEwNjk/czRa3pNzylTKXNihjoiSibP+1tP2i+ygPiCOh6P4j3GSh4Qp2
cPRDs5xeBXaBttVAhtF9GcGijG9RRqw/YL2z6mOFDadm2CuTqe5U9geBrsS1PdSmOhEnuxoV
RCIoT2DvCdulmJQQCJrHUljug1NbUe8QcXIukoL8vtWAdkH/+Pr08MyY29HNkARNfh8Ro4aa
8F0s2SFQZlA34IwgiZWvZtIHcbgUGuSW56j7ekQQvTdMJB1xL48YvDhhvFDnMyFPlo0y4il+
WXNsI/tsViTXgiRdm5QxsQyC8w5K8L3QtAt1Eyg1vP5MDYniEOIIb7+y5m6hApM2idplvhEL
FRxGhet7mwBbySIJX3i8aV3f7/g0LUOGmJSzRn3MkoXGgxtYYtOVpiuW2jaLFwg55C2G+gRX
w6J8+foTRLh50+NDmWaxFAmH+MYDcIzakyhha2ztlTBybAetxd0e4rAvsfnmgbAV0QZCbuI8
aoUT43b4rLAx6IXURJ1BzMPFMULIWUowQ1bDczSX57lpgDrFRaBd1eNKRZ2cDFE+4Ol4wJRh
zAPxljkWKEuzs10BIorKrmZgZ5sJEGGpuGrSVyIS5ReLFbXdBeSMFCZNHOR2hoN1Mwsf5LcP
bXBgZ5qB/xEHnUlPZuZUiAOFwSluYA/sOBt3tTL7Xdptu63dT8F0NZs/nMkHLDOYtarFQkTQ
dlIlWhqbUwh7bDb2VAQyrezIugLM/t/UrhVBYnPP98yuDy5D8poteQTmcANwQJ8dskiu8/ak
KeTeUthlhLXuo+NtmPDEWusY/JyEJ74GNLVUc9Ultz83tgexxJZrP8vDJIBjB2Hubky2H3vd
JFAb4owZOWqbXOuDmbmCLjSxOyknYHi4W7a3HDY815mkVoXiRSyv7Q+sa6I7fTxHo2PMWcTW
/pQj05l0VhcZKKfEOTnjABSWLuMll8YDMJOuFFVZRrTG83mghnft6mPgpNnIC0u4GpATowFd
gjY6xlgPTmcKhwFVaoa+jUQfFthEjRZ9AFcBCFnWyiTjAjtEDVuGk0h45evkvsZ0Vj5BynGP
3EUWCctOrlctxhhcM2GYakYE7m0znHT3JbbVDAqYmXZJpaQV/Qju5tPynnHawGBpGF7lSkm0
X5ODpRnFtxAialxyxFWPNqPwXnexIGM0eGdmOoOFp3AKT84C7wTbSP5f4ztMADJhXkdp1AKM
O5IBBOVRw/AOpuxnLpgtT+eqNUkmtbMsNqhvdfdMqVrP+1i762XGuIcyWfJZss4Gc1ADIBe/
/J5MZCNiPKec4CrFLWifO+hHHW7EvKMhh46yfpSWt6xCNL1m+qFzjYVZhcn9C31JIkFtm1eb
g/3+/P707fnxT1kSyDz64+kbWwK5/ob64EcmmedJiT2QDIkaKsAzSowBj3DeRmsP62yMRB0F
+83aWSL+ZIishCXHJogtYADj5Gr4Iu+iOo9xS12tIRz/mOR10qijAdoGWoma5BXkhyrMWhuU
nzg2DWQ2HWqF399Qswyz0Y1MWeJ/vLy933x6+fr++vL8DD3KegykEs+cDZZMJnDrMWBngkW8
22wtzCfG7lQtaG9nFMyImpJCBLnOk0idZd2aQqW6DTXS0v5ZZKc6UVxkYrPZbyxwSx59amy/
NfrjGb/kHQCtYzcPy7/e3h+/3PwqK3yo4Jt/fJE1//zXzeOXXx8/gynRn4dQP8lt7SfZT/5p
tIFaOI1K7Dozb8ZAtoLBYlQbUjCCqcUednEiskOp7NbQWdwgbZ8LRgDtLf2vpeh4zwlckpKl
WEEHd2V09KRIzkYo+xPUXKNNv2TlhySiNqWgCxXG2JZ7aikPWrPlh4/rnW/0gduk0MMcYXkd
YdV/NSVQAUJB7ZbeoCtst3WNDl4ZD6IUdjGmHDnaF5qA2SID3GSZ8XXNrWeURm7qCzm55InZ
7Ys2MSIrySldc+DOAE/lVgqX7sUokBR47k7KdiOB7dMmjPYpxeFFd9BaJR4s+VMsr/dm9TeR
OpNUIzX5U66pX+XWRBI/6+nxYbDny06LcVbBW5eT2WnivDR6aB0YFz4I7HOqHqhKVYVVm54+
fuwrKrxLrg3gqdfZaPM2K++NpzBqJqrhNTYc0A/fWL3/odei4QPRlEQ/bnhRBm6HysToeqna
Y8w3JEuLDe0ZJ6NwzPSgoNFakzGtgAEGerA047D6cbh+gEQKapXNQ60XxaUARMq7gmwV4wsL
0zOe2rIjA9AQh2LocL/OboqHN+hk0bwMW29yIZY+qSG5g51M/ExAQU0BJuo9YutYhyVSsIb2
juw29CQD8C5Tf2sfY5Qbjp9ZkJ5Ja9w41prB/iiIoDxQ/Z2Nmq4iFHhqYY+Y31N4dIhNQfvs
VbXWuBoZ+MW4xNBYkcXGceeAF+QQBEAyA6iKNN4Mq7c16hjJ+liA5bwYWwTYsU/zpLMIugAC
Itc3+XeamahRgg/G2aeE8mK36vO8NtDa99dO32BDtdMnEEcSA8h+lf1J2keA/FcULRCpSRhr
qMboGqoqS+5ze7ty4eFmdtcLYSRb6SnUAItA7ubM3NqM6aEQtHdW2F2qgqkvKYDkt3ouA/Xi
zkiz7gLXzFxjdve0nUIp1Cond3wuYeFFW+tDReT4UgZeGaUFGUFkVWqiVqijlbt1RA+YmvOL
1t1Z+ddNbCP0TaZCjQPSEWKaSbTQ9GsDpHqeA7Q1IVtaUX2vy4yu1CaHJiBPJCbUXfUizQOz
riaOKpopSu7q8ixN4ZDdYLrOmPiZazqJdspLIoUM4Uhh5pCHy1ERyL+oUzGgPsqqYCoX4KLu
DwMzLW/168v7y6eX52GdM1Y1+T85ZFCjtKrqMIi0yW7js/Nk63Yrpg/ReVl3KzgW5LqbuJeL
cgFnuG1TkTWxyOgvpfcJOppwiDFTR3zMKn+QcxWtFSQytLF+G3feCn5+evyKtYQgAThtmZOs
8Qt6+YPaTpHAmIh94AKhZZ8BP6m36liUpDpSSheBZSxhFXHDSjMV4vfHr4+vD+8vr/YJQ1vL
Ir58+hdTwFZOlRuwbqc8sf/F431M3JFQ7k5OrHdIPKt9b7teUdcpRhQ9gOZjUKt8U7zhgGcq
1+ApcCT6Q1OdSPNkZYFNvKDwcC6UnmQ0qmMBKcl/8VkQQsuxVpHGoiiFUDQNTHgR22BYOL6/
shOJAx/UNk41E2fUC7AiFVHtemLl21Gaj4Fjh5eoy6ElE1Zk5QFv6Ca8LfBT6xEeFRDs1EEx
1Q4/eG22gsMW2y4LiNE2uufQ4YxmAe8P62VqY1NKpHa4uh8lcItQJz/G5dnIDb6vSE8dObNv
aqxeSKkU7lIyNU+ESZNjXwDz18tdylLwPjysI6aZhgsmm5CyEQu6G6bTAL5j8ALbUZ7Kqbx/
rplxBoTPEFl9t145zMjMlpJSxI4hZIn8Lb52x8SeJcADjsP0fIjRLeWxx0aICLFfirFfjMHM
C3eRWK+YlJRIqpZaaneG8iJc4kVcsNUjcX/NVIIsH3n5MeHHvk6ZWUTjC2NBkjC/L7AQTx9Y
slTjBzsvYGaFkdytmdExk9418mqyzNwxk9yQnFlucp/Z6FrcnX+N3F8h99eS3V8r0f5K3e/2
12pwf60G99dqcL+9Sl6NerXy99zyPbPXa2mpyOK4c1cLFQHcdqEeFLfQaJLzgoXSSI74lLK4
hRZT3HI5d+5yOXfeFW6zW+b85Trb+QutLI4dU0q1mWVRcAjubzkhQ+1reThdu0zVDxTXKsPJ
/Jop9EAtxjqyM42iitrhqq/N+qyKkxy/aBm5aZdqxZqO+POYaa6JlTLONVrkMTPN4NhMm850
J5gqRyXbhldph5mLEM31e5y3N+7wisfPTw/t479uvj19/fT+ymh/J5ncj4Eyii2aL4B9UZHz
c0zJTV/GCIFwLLNiPkmduDGdQuFMPypa3+EEVsBdpgNBvg7TEEW73XHzJ+B7Nh1ZHjYd39mx
5fcdn8c3DjN0ZL6eyne+8l9qOCtqEJPT/ElOF+tdztWVIrgJSRF47gdhBE5lTaBPA9HW4IQt
z4qs/WXjTJqNVWqIMGOUrLlT54rGjtQODGcq2KKwwoZ9rYEqm5OrWY/k8cvL6183Xx6+fXv8
fAMh7N6u4u3Wo8vrLwQ3L0Y0aFyYa5Bel+jXicjER4I1hfWL16jobytsC13D5oW6Vm8x7x40
al0+6Aezl6A2E0hA6Y8ce2q4MAHylEJfd7fw18pZ8U3A3BVruqG3Bwo85hezCFll1oz1ZEC3
behvxc5Ck/IjsX+j0Vqb9zR6hz7Np6A6gVuoneEOl/TFoAg2sSuHSBWeTC6rzOKJEo64QOHH
6NJ2ZnIAKR/KdueP8Em/AtW5rhFQnw77WzOoYQFCgfaBrn5N3fmbjYGZR7oazM02+2hWNnjp
TunJ2JXhOCm0KPTxz28PXz/bw9QyBDygpVmaw6UnmhRocjCrQqGu+YFKqcuzUXjZbKJtnUWu
75gJy4rfr1a/GNfZxvfpaSqNf/Dd2h6BOYHE+83OKS5nAzfNdGmQXBwq6ENQfuzbNjdgUwtl
GJLeHrsbHEB/Z9URgJut2YvMNWmqerBAYA0EMJxhdO75fYNBKLMWdq8fXrxz8N4xa6K9Kzor
CcsAkkJN40UjqI8y5q5uN+mgHpf9oKlN9TVdU7mcJo9Wb7QRKR7H8h+O+THKLZqisPKpnuTi
yHPVJyFNXquU053L1dLLddTZmhmo10Z7q9L0cLS+NPI83zdrvc5EJczZqpPT3Xrl4YIzBdTm
1kV4veBEn2VKjolGC1tFtyc091ywwxcHLoFGqdv56T9Pgw6LdVclQ2pVDmV9Gy8hMxMLV84m
S4zvckzRRXwE51JwxLBcT1/PlBl/i3h++Pcj/Yzhagw8tZEMhqsxokM/wfAB+DCdEv4iAZ6p
YrjLm2cEEgKbRKJRtwuEuxDDXyye5ywRS5l7nhQHooUiewtfSzQFKbFQAD/BB6KUcXZMKw+t
Oe0A4MFGH5zxzk1BTSKwMVYEKsmVCrQmC3ItSx6SIivRMxE+ED0JNRj4Z0seLeEQ+mbmWumV
pi/zUAWHydvI3W9cPoGr+YNhmbYqE54dZLwr3A+qpjF1KzH5EfvUSsKqarWdmgkcsmA5UhRl
mWMuQQmPy69FA3/V+b1ZZI2aGm11HGgezfLDBiOIoz4MQCcLnfoMRlpgAiBTsIaNlJSDbgOD
a/EDdHIpVK6w6c0hqz6IWn+/3gQ2E1FDMCMMAxLfF2DcX8KZjBXu2nieHOQG7ezZDFjLsFHr
/fRIiFDY9UDAIigDCxyjh3fQD7pFgr4NMcljfLdMxm1/kj1Bthf1/TJVjSHbjoWXOLl6QeEJ
PjW6snfEtLmBj3aRaNcB1Pf79JTk/SE44UcnY0JgB3VHHlEZDNO+inGxoDQWdzS3ZDNGVxzh
TNSQiU3IPPz9ikkI5Ha8jx5xuomfk1H9Y26gKZnW22K/dyhfZ73ZMRloawXVEGSL33OgyMZG
gTJ75nv05V4RhjYlO9va2TDVrIg9kw0Q7oYpPBA7rLKKiI3PJSWL5K2ZlIYdy87uFqqH6bVn
zcwWo0UQm2nazYrrM00rpzWmzEozW8q8WF1jKrac+7G0M/f9cVmwopwi4aywjt/xUtCXj/Kn
lLxjExpUsvXhoLbI8PD+9G/GJZY2zSTAlJ9H9OJmfL2I+xxegKHyJWKzRGyXiP0C4fF57F3y
7HIi2l3nLBDeErFeJtjMJbF1F4jdUlI7rkpEZGjNjkQjR2RE9OAIU3OMcdg64W1XM1nEYusy
ZZV7HrZEg4U4Ytx35LLNrdyNhzaR7hy5I0h5wnfTA8dsvN1G2MRoR5EtQdrKfdmphdXQJg/5
xvGpGYuJcFcsIYWTgIWZZh8eOpU2c8yOW8djKjkLiyBh8pV4nXQMDufBdEqYqNbf2eiHaM2U
VK7NjeNyrZ5nZRIcEoZQcynTdRWx55JqI7lkMD0ICNfhk1q7LlNeRSxkvna3C5m7WyZzZWyd
G81AbFdbJhPFOMy0pIgtMycCsWdaQx3r7LgvlMyWHW6K8PjMt1uucRWxYepEEcvF4tqwiGqP
ndyLvGuSA9/b24hY1J2iJGXqOmERLfVgOaA7ps/nBX7YOqPcBCtRPizXd4odUxcSZRo0L3w2
N5/NzWdz44ZnXrAjp9hzg6DYs7nJ3bXHVLci1tzwUwRTxDrydx43mIBYu0zxyzbSR1eZaKlx
lYGPWjk+mFIDseMaRRJy38d8PRD7FfOdowaiTYjA46a4Kor62qcbLsLt5RaOmQGriImgrjf2
qJZr+kZ8CsfDINi4XD3IBaCP0rRm4mSNt3G5MSkJqs04E7XYrFdcFJFvfbmccr3EldsnRkhT
8z07RjQx292ddzooiOdzM/8w+XKzRtC5qx23jOhZixtrwKzXnFgIW7mtzxS+7hI5xzMx5B5j
LXeeTI+UzMbb7pip+RTF+9WKSQwIlyM+5luHw8HMLzvH4nvyhelUHFuuqiXMdR4Je3+ycMSF
Nt/oT9JhkTg7rj8lUmxbr5ipQBKus0BsLy7Xa0UhovWuuMJw86fmQo9bAUV03GyV+bGCr0vg
uRlQER4zTETbCrbbiqLYclKGXP0c1499fo8lt4VcYyqXVi4fY+fvuA2FrFWfnT3KgLxewDg3
vUrcY6ehNtox47g9FhEnlLRF7XDzvcKZXqFw5oMlzs5wgHOlPGfB1t8ysv25dVxOPjy3vstt
QS++t9t5zAYGCN9h9mFA7BcJd4lgKkPhTLfQOMwcoJNkz8OSz+XM2TKri6a2Jf9BcgwcmV2c
ZhKWMj3XgLgQoDINgBwwQZsJ6lx05JIiaQ5JCSZwhzP9Xik09oX4ZWUGrlI7gUuTKRdzfdtk
NZNBnGgDFYfqLAuS1P0lUw5W/8fNlYBpkDXarujN09vN15f3m7fH9+tRwLyy9qH4t6MM10p5
XkWwqOJ4RixaJvsjzY9jaHjYrf7g6bn4PG+UFR11qldfVtvHyTltkrvlTpEUJ22X2aao6pmy
nz4mM6FgSMQC1XM1GxZ1EjQ2PL7lZZiIDQ+o7KueTd1mze2lqmKbiavxDhijg+0AOzTY4Xdt
HFRHZ3DwLf7++HwDZia+EKPFigyiOrvJytZbrzomzHTdeT3cbJqby0qlE76+PHz+9PKFyWQo
+vCIyv6m4QqUIaJCSvg8LnC7TAVcLIUqY/v458Ob/Ii399fvX9RbzsXCtpnyFWBl3WZ2R4an
6B4Pr3l4wwyTJthtXIRP3/TjUmsllIcvb9+//r78SdpgHldrS1Gnj5aTRWXXBb6HNPrk3feH
Z9kMV3qDuodoYQVBo3Z6mNQmRS3nmEApTEzlXEx1TOBj5+63O7ukk8a3xUyGGf8yEcP2yQSX
1SW4r04tQ2lblL26901KWItiJhQ4YFfvpCGRlUWPWr2qHi8P75/++Pzy+039+vj+9OXx5fv7
zeFFfvPXF6IqM0aum2RIGeZqJnMaQK7gTF2YgcoKq6IuhVIGNFVrXQmIFz1IllnpfhRN52PW
T6zdBdhmXKq0ZaxvEhjlhMajPgK3oypis0BsvSWCS0oryVnwfIjGch9X2z3DqEHaMcRw9W8T
g01gm/iYZcodic2MXkqYguUduDi0VjYPTJPawQNR7N3timPavdMUsIVeIEVQ7LkktQrymmEG
LXGGSVtZ5pXDZSW8yF2zTHxhQG1vhiGUoRKuU5yzMuIswzblpt06PlekU9lxMUYLsEwMuTXy
QIGgabneVJ6iPVvPWjuaJXYumxMcPPMVoO+iXS41Kbu5tNcoh01MGlUHxqlJUJE1KazR3FeD
rjxXetAFZ3C18JDEtTmcQxeG7CAEksPjLGiTW665R+vUDDfo9bPdPQ/EjusjcukVgTDrToPN
x4CORP3k3U5lWhaZDNrYcfAwm/eX8ILOjlCr98zcN+RZsXNWjtF40QZ6BIayrbdaJSKkqFa7
Nj5Uq+ZSUAqFazUIMCh/SJG5w1v6LLxv5VRAy9jsaDyw9WIlr6RXE1RvVZZRU51LcruV5xtf
XhxqKUMRTJsoYqC4wN20hnrUFTnlUZy36267Mjt02Qeu0QqnIsctNqpi//Trw9vj53lxjR5e
P6M1FRwkRcw6E7faStKoWvyDZECjgklGgIfXSsh2InbQsaU9CCKUyTrM9yFsQIkZc0hKWV8+
VkrRjUkVBaC4iLPqSrSRNlDtdZtg2rQz+GgWRmBtmYgLnHRtlrIM1faU3SlgCggw6Y+BXTkK
1R8YZQtpTDwHy7nXgIci2uHZKtBlN+pAgWbFKLDkwLFSiiDqo6JcYO0qI8Z9lNHg375//fT+
9PJ1dDxlbViKNDa2BIDYypCAamdch5qoL6jgs/k/mozybwK25iJsiHGmjnlkpwWEKCKalPy+
zX6FT3MVaj+KUWkYen0zRu/O1MdrA5UsaJuuBtJ83TJjduoDTmxcqQzgraWzod9oPdmcQJ8D
8VPNGcT6yvDYbdChJCGHXQAxOzniWD1kwjwLI3qWCiNPjgAZduZ5HWDfPapWIsfrzLYcQLuu
RsKuXNtXt4bdjZToLPyYbddyqaDWPwZis+kM4tiCaVUhFyci0vQZfocDALEiDcmpl1ZRUcXE
AZkkzLdWgGkftysO3JhdydSpHFBDWXJG8SOnGd17FurvV2ay+kEyxcYNHNoefOy0m0zaEamW
KkDkxQ3CQTCmiK38OnkfJS06oVRldXjHZZicVgkr/7nGjGabi1Glmh5JYdDQr1TYrY9vdBSk
9zlGPtl6tzVdBCmi2OCrnwkyZneF3977sgMYg2zwn0m/IQi7zVgHNI3hsZ0+WmuLp0+vL4/P
j5/eX1++Pn16u1G8Og99/e2BPXiAAMPEMR+0/f2EjOUE7Dk3UWEU0ngfAVib9UHheXKUtiKy
Rrb5XnGIkWNvtaBx66ywHrB+TIhvzm2v2Sol69HhhBIN3jFX450kgslLSZSIz6Dk3SJG7Xlw
Yqyp85I77s5j+l1eeBuzM3NepRRuvJdU45m+HVYL7PBs9S8GtMs8EvzKiG2wqO8oNnDVamHO
ysT8PbbfMGG+hcHVHoPZi+LFsFylx9Fl7ZsThDYWmteGscSZUoSwGGyLbjyJGlqMeoBYEuam
yLb6yuxJ2tixzUSadeB/sMpboj05BwCvNyftk0qcyKfNYeB6Td2uXQ0l17WDj/0eEIqugzMF
wqiPRw6lqJyKuHjjYfthiCnlXzXLDL0yjyvnGi9nW3jXxAYxZM+ZsUVYxNmC7Ewa6ylqU+N9
DGW2y4y3wLgO2wKKYSskDcqNt9mwjUMXZuTTXMlhy8x547Gl0GIax2Qi33srthCgJubuHLaH
yElw67EJwoKyY4uoGLZi1ZOahdToikAZvvKs5QJRbeRt/P0Std1tOcoWHym38ZeiGfIl4fzt
mi2IoraLsYi8aVB8h1bUju23trBrcvvleERjE3HDnsPwQU74nc8nKyl/v5Bq7ci65DkpcfNj
DBiXz0oyPl/Jhvw+M3WYBYIlFiYZWyBHXHr6mDj8tF2ffX/FdwFF8QVX1J6n8EP2GVan3E1d
HBdJUcQQYJkn1ppn0pDuEWHK+IgydgkzY76pQowl2SMuP0jRh69hLVWEVUW9SZgBzk2Shqd0
OUB9YSWGQcjpzwU+jEG8LPVqy86soGDqbD32i2xBnHKux3caLYbzA8EW3E2Onx4U5yyXkwr4
Fsf2AM2tl8tCJHskQllWepAIppThGMLUUSMMEVsjOM4iG0JAyqrNUmJFD9AaG9ltInMWBAcm
aKrIM2zioAGnKVEVg6Q7gVnTl8lEzFEl3kSbBXzL4h/OfDqiKu95IijvK545Bk3NMoUUZG/D
mOW6go+T6ceM3JcUhU2oegIflYLUXSC3ik1SVNhouUwjKelv28WZLoBdoia4mJ9G/fvIcK0U
2zNa6MFlO4lpeKJqqA9LaGPTaSJ8fQKugD1a8XjTB7/bJgmKj7hTSfSSlWFVxlbRskPV1Pnp
YH3G4RRgs0kSalsZyIjedFi3WVXTwfytau0vAzvakOzUFiY7qIVB57RB6H42Ct3VQuUoYbAt
6TqjtwPyMdpynFEF2gxSRzDQ18dQA76WaCvBPT1F9L2QDfVtE5SiyFrisghooyRKvYNk2oVV
18fnmATDRi3UdbQyK6G9C8yXHV/AZuLNp5fXR9tZgI4VBYU6jh8i/0VZ2Xvy6tC356UAcN3d
wtcthmgCsLq0QIq4WaJg1rWoYSruk6aBnUz5wYql/U7kuJJNRtZleIVtkrsTmMsI8LHHOYsT
mDLRblRD53XuynKG4EKZiQG0GSWIz+bZgyb0uUORlSA1yW6AJ0Idoj2VeMZUmRdJ4YIdElo4
YNRFWp/LNKOc3Dho9lISkyUqBykVgbofg8ZwX3dgiHOhdIQXokDFZlg/4hwaiycgRYFPzAEp
sZ2aFi6cLe9lKmLQyfoM6hYWV2eLqfi+DOC6R9WnoKlrh6MiUe4j5DQhhPzjQMOc8sS4PlSD
yb4vVB3oBPe8U3fVOmuPv356+GK7I4agujmNZjEI2b/rU9snZ2jZv3Cgg9AeSRFUbIg7IVWc
9rza4sMVFTX3sTA5pdaHSXnH4RH4XWeJOgscjojbSBCJf6aStioER4Dj4Tpj8/mQgPraB5bK
3dVqE0YxR97KJKOWZaoyM+tPM0XQsMUrmj0YGmDjlBd/xRa8Om/wQ2NC4EeeBtGzceogcvER
AWF2ntn2iHLYRhIJeWGDiHIvc8LPkEyO/Vi5nmdduMiwzQd/bFZsb9QUX0BFbZap7TLFfxVQ
28W8nM1CZdztF0oBRLTAeAvV196uHLZPSMZxPD4jGOA+X3+nUgqEbF+W+3R2bLaV9q3LEKea
SL6IOvsbj+1652hFrIoiRo69giO6rNFe2jN21H6MPHMyqy+RBZhL6wizk+kw28qZzPiIj41H
3bbpCfX2koRW6YXr4hNLnaYk2vMoiwVfH55ffr9pz8qiorUg6Bj1uZGsJS0MsGkEmpJEojEo
qI4Mu9/Q/DGWIZhSnzNBPOtpQvXC7cp6U0lYEz5UuxWeszBKXaoSJq8Csi80o6kKX/XE+6qu
4Z8/P/3+9P7w/IOaDk4r8s4So1pi+4ulGqsSo871HNxNCLwcoQ9yESzFgsY0qLbYkhMvjLJp
DZROStVQ/IOqUSIPbpMBMMfTBGehJ7PAug8jFZBrKxRBCSpcFiOlXUvfs7mpEExuklrtuAxP
RduTy+yRiDr2QxU8bHnsEoCmesflLjdAZxs/17sVtsuAcZdJ51D7tbi18bI6y2m2pzPDSKrN
PIPHbSsFo5NNVLXc7DlMi6X71Yoprcat45eRrqP2vN64DBNfXPISeKpjKZQ1h/u+ZUt93jhc
QwYfpWy7Yz4/iY5lJoKl6jkzGHyRs/ClHoeX9yJhPjA4bbdc34KyrpiyRsnW9ZjwSeRgozNT
d5BiOtNOeZG4Gy7bossdxxGpzTRt7vpdx3QG+be4vbfxj7FD7BIDrnpaH57iQ9JyTIz1BUUh
dAaNMTBCN3IH5cfanmxMlpt5AqG7Fdpg/TdMaf94IAvAP69N/3K/7NtztkbZDftAcfPsQDFT
9sA00Vha8fLbu3Lk/fnxt6evj59vXh8+P73wBVU9KWtEjZoHsGMQ3TYpxQqRuVqKnkw9H+Mi
u4mSaPSybqRcn3KR+HCYQlNqgqwUxyCuLpTTO1zYghs7XL0j/iTz+M6dMA3CQZVXW2q+rQ3c
znFABc5aty4bH1sOGdGttVwDtkWeLlBJfn6Y5K2FMmXn1jrJAUx2ubpJoqBN4j6roja3JC4V
iusJacimeky67FQMBn4XSMOXseaKzupSces5StJc/OSf//jr19enz1e+POocqyoBW5RIfGyU
ZTgVVF5B+sj6Hhl+Q+xREHghC58pj79UHkmEuRwEYYb1JhHLjESF62eacvn1Vpu1LZXJEAPF
RS7qxDz56sPWXxsTt4TseUUEwc7xrHQHmP3MkbPFx5FhvnKkeKFbsfbAiqpQNibtUUiGBjv4
gTWFqHn4vHOcVZ81xvSsYForQ9BKxDSsXkyYw0BulRkDZywcmOuMhmt4c3Jljamt5AyWW4Hk
trqtDMEiLuQXGsJD3TomgLULwVu64E5CFUGxY1XXeEOkzkcP5AJMlSIOmyw+LKCwTuhBQL9H
FBk4RzBST9pTDfevTEfL6pMnGwLXgVw0Jy84w2MMa+KMgjTpoygzD4r7oqiHWwiTOU/3E1a/
HdwBWXno95+RXBIbe1eG2NZix3ea5zpLpVQvauJjjQkTBXV7aswDdNkXtuv1Vn5pbH1pXHib
zRKz3fRy550uZxkmS8WCl6duf4YH1OcmtU4CZtra8hrGRYe54giB7cawIPBIyxTFY0H+ykM5
i/3TjKB0UGTLkzsLXTYvAsKuJ623ERPrqpoZX0tGifUBQmZxKkeLCes+s/KbmaWjj03dp1lh
tSjgcmRl0NsWUlXx+jxrrT405qoCXCtUre9Yhp5onloUa28nJdo6tTIwnRphtG9ra7EbmHNr
facykQIjiiVk37X6nHrNRFykU8JqQK0VH9lEK1F82QrT0HQbtjALVbE1mYBhmXNcsXjdWSLq
9Pj3AyMVTOS5tofLyBXxcqJnUIqw58jpjg+UEJo8iKwmHfsydLyDaw9qRHMFx3yR2gXoXLmj
keO4sYpOB1F/sFtWyIYKYe7iiOPZln80rGcM+9AT6DjJWzaeIvpCfeJSvKFzcPOePUeM00ca
15ZgO3If7MaeokXWV4/UWTApjhaKmoN9pgergNXuGuVnVzWPnpPyZE0hKlZccHnY7QfjjKBy
nCmPEguD7MzMh+fsnFmdUoFqr2mlAARc7sbJWfyyXVsZuIWdmDF0tLS2JJWoi2gfroDJ/Kg0
DH4kyoxvIbmBChYDgmqZOzhuYAWAXKlyuD0qmRTVQJF7fZ6DBXGJ1QYSbBYUMn70+Wpml1w6
7huE3mo+fr4piuhneDDNHDzAoRBQ9FRIa4dMN/h/UbxNgs2O6EVqZZJsvTOv0UwscyMLm2Ob
N2AmNlWBSYzJYmxOdmsUqmh883ozFmFjRpX9PFP/stI8Bs0tCxrXVbcJ2Q3owxw4tS2NG70i
2OOjPVTNeHM4ZCT3jLvV9mgHT7c+eUqhYeaxlGb0m6uxt9hmroD3/7xJi0G54uYfor1RNgX+
OfefOSmf+Gr7P0sOT2E6xUwEdkefKPNTYA/RmmDTNkTJDKNWNQUf4djaRA9JQa5YhxZInW1K
NLER3NgtkDSNFCIiC29Owip0e18fKyzPavhjlbdNNp2rzUM7fXp9vICnrH9kSZLcON5+/c+F
w4E0a5LYvBQZQH0Pa6tfgWzdVzXo40xGscAEGLzt0q348g1eelmnuXBGtXYsWbY9m+pC0X3d
JAKk7qa4BNbGLTylrrEfn3HmVFjhUiaranNxVQyn+4TSW9KZchf1rFx66GMeVywzvGigDoTW
W7PaBrg/o9ZTM3cWlHKiIq064/igakYXxDelfKb3GOjU6eHrp6fn54fXv0YFq5t/vH//Kv/+
75u3x69vL/CPJ/eT/PXt6b9vfnt9+fouJ4C3f5p6WKCK15z74NRWIslBAchUaWzbIDpax7rN
8CBzcsSafP308lnl//lx/NdQEllYOfWAbbqbPx6fv8m/Pv3x9G02xfgdzvXnWN9eXz49vk0R
vzz9SUbM2F+DU2wLAG0c7NaetbmS8N5f2xfCceDs9zt7MCTBdu1sGClA4q6VTCFqb21fN0fC
81b2Ya3YeGtL/QHQ3HNt+TI/e+4qyCLXsw6WTrL03tr61kvhE+vyM4o9KQx9q3Z3oqjtQ1hQ
hQ/btNecaqYmFlMjWXcWQbDVjnZV0PPT58eXxcBBfAaPKNZ+VsHWYQjAa98qIcDblXVAO8Cc
jAyUb1fXAHMxwtZ3rCqT4MaaBiS4tcBbsSKepofOkvtbWcYtf+TsWNWiYbuLwgu+3dqqrhHn
vqc91xtnzUz9Et7YgwOu3lf2ULq4vl3v7WVPvIQh1KoXQO3vPNedp72yoC4E4/+BTA9Mz9s5
9ghWVyhrI7XHr1fSsFtKwb41klQ/3fHd1x53AHt2Myl4z8Ibx9rlDjDfq/eev7fmhuDW95lO
cxS+O199Rg9fHl8fhll6UflHyhhlICX83KqfIgvqmmPAfJ1j9RFAN9Z8COiOC+vZYw9QW3Ws
Ortbe24HdGOlAKg99SiUSXfDpitRPqzVg6ozdUYzh7X7D6B7Jt2du7H6g0TJQ+EJZcu7Y3Pb
7biwPjO5Vec9m+6e/TbH8+1GPovt1rUauWj3xWplfZ2C7TUcYMceGxKuiXu0CW75tFvH4dI+
r9i0z3xJzkxJRLPyVnXkWZVSyn3DymGpYlNUuXXa1HzYrEs7/c3tNrAP8QC1JhKJrpPoYC/s
m9tNGNi3AWoom2jS+smt1ZZiE+28Ytqe5nL2sJX8x8lp49viUnC78+yJMr7sd/acIVF/tevP
UTHmlz4/vP2xOFnF8Dzaqg2wVWKrW8LjfSXRoyXi6YuUPv/9CBvjSUilQlcdy8HgOVY7aMKf
6kVJtT/rVOXG7NurFGnB8gabKshPu417FNM+Mm5ulDxvhocDJ3ALo5cavSF4evv0KPcCXx9f
vr+ZErY5/+88e5kuNi5xgDVMti5zRqbuaGIlFczGz//vpP/JQ/y1Eh+Es92S3KwYaFMEnL3F
jrrY9f0VvBkcDtNmoyh2NLr7GR8Q6fXy+9v7y5en/+8R7vr1bsvcTqnwcj9X1MQGDuJgz+G7
xNwWZX13f40ktoWsdLHJCYPd+9gJFyHVedZSTEUuxCxERiZZwrUutbZncNuFr1Sct8i5WNA2
OMdbKMtd6xDNVsx1xvMNym2IHjHl1otc0eUyInbgaLO7doGN1mvhr5ZqAMb+1lIxwn3AWfiY
NFqRNc7i3CvcQnGGHBdiJss1lEZSFlyqPd9vBOhjL9RQewr2i91OZK6zWeiuWbt3vIUu2ciV
aqlFutxbOViPkPStwokdWUXrhUpQfCi/Zo1nHm4uwZPM2+NNfA5v0vHgZjwsUc9U397lnPrw
+vnmH28P73Lqf3p//Od8xkMPF0Ubrvw9EoQHcGupDsPzmP3qTwY0VZQkuJVbVTvolohFSj9H
9nU8CyjM92PhaQ9H3Ed9evj1+fHm/7mR87FcNd9fn0BBdeHz4qYztMDHiTBy49goYEaHjipL
6fvrncuBU/Ek9JP4O3Utd51rS59LgdjohMqh9Rwj04+5bBHsTWsGzdbbHB1yDDU2lIt1A8d2
XnHt7No9QjUp1yNWVv36K9+zK31FTGSMQV1TL/ucCKfbm/GH8Rk7VnE1pavWzlWm35nhA7tv
6+hbDtxxzWVWhOw5Zi9uhVw3jHCyW1vlL0J/G5hZ6/pSq/XUxdqbf/ydHi9quZCb5QOssz7E
td55aNBl+pNn6ug1nTF8crnD9U09d/UdayPrsmvtbie7/Ibp8t7GaNTxoUzIw5EF7wBm0dpC
93b30l9gDBz17MEoWBKxU6a3tXqQlDfdVcOga8fUS1TPDcyHDhp0WRB2AMy0ZpYf9P771FBT
1C8V4DV3ZbStfk5jRRhEZ9xLo2F+XuyfML59c2DoWnbZ3mPOjXp+2k0bqVbIPMuX1/c/boIv
j69Pnx6+/nz78vr48PWmncfLz5FaNeL2vFgy2S3dlfkoqWo21OfdCDpmA4SR3EaaU2R+iFvP
MxMd0A2LYoNHGnbJY8BpSK6MOTo4+RvX5bDeuj4c8PM6ZxJ2pnknE/Hfn3j2ZvvJAeXz8527
EiQLunz+z/+jfNsIbBRyS/Tam24nxud6KMGbl6/Pfw2y1c91ntNUybHlvM7A67iVOb0iaj8N
BpFEcmP/9f315Xk8jrj57eVVSwuWkOLtu/sPRruX4dE1uwhgewurzZpXmFElYKhwbfY5BZqx
NWgMO9h4embPFP4ht3qxBM3FMGhDKdWZ85gc39vtxhATs07ufjdGd1Uiv2v1JfXKzCjUsWpO
wjPGUCCiqjUf1h2TXKt5aMFa347PFoX/kZSbles6/xyb8fnx1T7JGqfBlSUx1dPDqvbl5fnt
5h1uKf79+Pzy7ebr438WBdZTUdzridbcDFgyv0r88Prw7Q+wiGy/UDkEfdBg/WUNKEWwQ33C
Fj5AOTOrT2fTlG/cFOSHVsKNBbLMAmhcyxmlm6zZUw7urcFjVgpKbjS120JAM1B1/AFPw5Ei
yaXKNgzj/HAmq3PSaIUAuXzYdJ4Et319vAd/s0lBE4DH0r3cncWzXoP5oeSWBbC2Nero3AQF
+1mHpOiVHwjmu+CTlziIJ46gscqxZ+MbRHRMppfccPo2XGzdvFgX7CgWqGJFRykWbWmZtYpW
Tl67jHjZ1eroaI8vYC1SHWaR48ClAukFvSmY59RQQ5XcNwc4LRx0dqAGYZsgTqqSdSQKdFDE
cgBgevT6ePMPrW8QvdSjnsE/5Y+vvz39/v31AVRmDPePfyMCzbusTuckODEu3FRjyrY2etMt
tvGiSt9m8JzmQNxhAKF1hqcZrWkjowpnTfmYi7lZe54yJFdy7G6ZktNCZ3bLgTlncTZqII3H
wOrMN3x9+vy72cZDpLjO2MSsiWcKz8KgkLlQ3MkVnvj+60/2rD4HBeVvLoms5vNUrxc4oqla
ajobcSIK8oX6AwVwgp/i3OgO5qxaHIIDcaUOYJQ1cmHs7xJss14NFaV/etGVZTP5OTa6311n
FCCsoqMRBkx6gx5ebWRWB2WSj1UfP719e37466Z++Pr4bNS+CgjO8HpQJZQ9Pk+YlJjSadw8
Yp+ZNMnuwZNvei/lOHcdZ+428FYxFzSDxyS38q+9R4QpO0C2930nYoOUZZXLpbFe7fYfsZWk
OciHOOvzVpamSFb0PHkOc5uVh+G5Un8br/a7eLVmv3vQcM7j/WrNppRL8rDeYEvHM1nlWZF0
fR7F8M/y1GVY4xWFazKRgOJlX7VgVX3PflglYvjfWTmtu/F3/cZr2caSfwZg1ijqz+fOWaUr
b13y1dAEog6TprmXQkhbnWS3i5oE21fDQe9jeA3cFFvfGgxDkCq6VR/x4bja7MqVcZiFwpVh
1TdgFyP22BCTYvk2drbxD4Ik3jFguxMKsvU+rLoV20YkVPGjvPwg4IMk2W3Vr73LOXUObABl
uzS/k63XOKIjFgzMQGK19lonTxYCZW0DRqvkzn23+xtB/P2ZC9PWFeg50lPImW1O+X1ftt5m
s9/1l7vuQCQFY6ohs5d+5fmXnebEkNlq3iGwK5g2eCI/JSi7HXnArGbhuNSrGEGl0B8q6TwO
jEkE5rc+KQ3TrmqSTw4BPG2Ri0cb1x3YEj8kfehvVlKITy80MMhidVt6661VeSAp9bXwt+YU
J4U++X8miZVJZHtqdGUAXc+Yk9pjVoLz7mjryQ9xVq7JV+KYhcGglWZKmAa7M1g5A6T12uwN
8OKm3G5kFfuGIDs1DH4uNgqrlmaVQfRanfQvlpZbUJ4wdbJUW3Mr7QD2wTHsDcVVTGeuuEbr
pydWn7c7LClsYcru8E4vgA2UHALWE9kxRHtObDCPQxu0vzaD19aZ0dPPnrEGn6O1BczfSUWl
tgzOmTFrDCDnMlx2hiaqD4ZscsxEJv8g/qfUSOsEjSyBNDS7XXkf473yAAz75TCzmWPne5td
bBMgTrj45AcT3trhMlm5vnfX2kyT1AHZho6EnGiJQwaE77yNMdfUuWOODdn+1qoqhQdDDhhc
qB5So48VUWx0nxyms3tjYx2b8RoHX8UPsq4peRqACM7E7wyRYpKyVccI/d0pa26F+T3w7qeM
lcNMrV30+vDl8ebX77/9JvessblJTUO5g4+l3IRWkzTUJtDvMTRnM54yqDMHEivGz9oh5RQe
feR5Q6xwDkRU1fcylcAiZIsckjDP7ChNcu5ruWvLwTBqD85dSfbiXvDZAcFmBwSfXVo1SXYo
5ToWZ0FJsgmr9jjj0z4ZGPmXJthdvAwhs2nzhAlkfAV5UgI1m6RShFQmaegnyxVYNjkJC+au
8+xwpB9UyOV4OIoRJAnYpsDny9F0YPvMHw+vn7XVInPLCc2itmgkp7pwzd+yWdIKJmaJluRF
BiSR14Lqg6tOQH9H91KGpqepGFVdDyd6OieCtnV9bmi5qhqElCahpRdObPhhTEP9MJ0gJZwR
BAyklMz+smHjCc5MzM2FySY709QBsNJWoJ2ygvl0M6IjC/0ikGJsx0ByhpbLaSn3IySBkbwX
bXZ3SjjuwIFE9w6lE5zxXggKr47BGMj+eg0vVKAm7coJ2nsyI0/QQkKSNAP3kRUETGYnjdwO
yn2ozXUWxOclPNoXPatfmyvDBFm1M8BBFCU5JTKjx2ei91YrM0zvYVesaUhXKf1bDmmYbPta
bktTYYbuwVVQUcvFKoRTh3va+5NKTrwZ7RS399j+rAQ8spwOAPNNCjZr4FxVcYV9lgHWys0B
reVWbpnkmkobGT+6VXMYjRMFTZGVCYfJZTiQktxZiW/T3E/I6CTaquCn/7oLyNU3FLDIKgvQ
lWC0rBcZ/WewhQsuUC5NZq6X1M+mQkR0MmqcnN3BDBIWskO3640xFx+qPE4zcSRgHPjGVDo4
zqNzQQJb6aqg9Qm3rq4Re8CUZaaDMTRGzuwGYVMFsTgmiSEUCFAd2Bnfv3OMRQIs59jIeENk
eieY+PIEVzfiF8+Oqcy6Z1ykWAguKxnBnsYMzhh9MxuBSwM5RLPmDqzutUvhyPE1YeQEHS1Q
emujreKYIdZTCIvaLFM6XREvMeQ0nTByePVpdNvXyi357S8rPuU8Seo+SFsZCj5MjgyRTNYM
IVwa6hMXdeA/nP7bPl+nRIeDDilNBN6W6yljAHPnbweoY8cVxDTpFGaQm8Dt4Dm7ytOtKxNg
cujBhNJ7jLjmUhg4ud+MikVavbIMom6z3QS3y8HyQ32US0It+jxceZu7FVdxxnGdtzvv4osx
YeGQ6rAtlrvKtk2iHwZbe0WbBMvBwDVTmfurtX/M1UZyOqP4cScZQ7JbL9XRwodP/3p++v2P
95v/eSMlhtF5qXUfDqfa2hOE9os0FxeYfJ2uVu7abfGpqyIKITfXhxSrTii8PXub1d2Zonrz
3tmgh4/RAGzjyl0XFDsfDu7ac4M1hUf7GRQNCuFt9+kB39gOBZZr0W1qfog+cKDY/8/YtS25
jSPZX6kfmF2Rus+GHyCSktjizQRZYvmFUW1rehxRdvW63DHbf7/IBC9AIqHyi106BwCBxC1x
yyzBrElo+jedlCmPrGZeW5jKInPqmNlBh+MiUt/AM2N54Jth6obUiJDv9qugv2am3bWZpt7L
jMzH1c5y3UGoLUu5rgqtUm2WC1aSSO1ZptpZLkdnxvXZN3Ou5zhD7pbdG+NLj+twsc0qjjvE
m2DBpibqqIuKgqMGT8Jmb36nJ45pqHU2zJ7UNAS/qh5mtuGOzve31xe1eB52NgdTFuzNF/Wn
LE3rjApUf6lR9aiEG4F3IvRl9Q6vtPdPiWkxiQ8FeU5lo1Tf0TTqAZzFof11Y1MLL/c4ObNg
UDLavJAfdguer8ur/BCup6FWKcFKaTke4RY0TZkhVa4avcxIc1E/3Q+LZ9b6ls18G+l+JUyj
S3kytlfgV48nij1a0eEIJdpgwzJR1jYhuuyecuFcexqjybItjLEAf/allMQ3oY33YKY4E6mx
PJdWKkXcE6/bAFXm7D0AfZLFVioIpkm0X+9sPM5FUpxgIeOkc77GSWVDMvnojMWA1+KawxUL
C4SlIlpnKY9HuNJks79Z7X5EBpce1v0tqWUEt61sEO97AOWW3weCqVdVWukKR0vWgs81I26f
CyrMkOhgXRirVUJoiU2vKnq1oLIdiuHH1VK7P5KUHpP6UMrEWYfbXFo0RIZkWTFBYyS33F3d
Opsq+JVcyIZKRIIftSKiMsFmAeODA+vQbnVAjEG87gg1BoAmpdbd1lLe5HgUr+W5lFqmunHy
ql0tgr4VNflEWWXL3tqHNVFI0GYeOze0iPbbntivwwqhlqkQdMUnwNUh+QxbiKYyjSVrSJoH
mVoG6LKwDTZr82HnLAXSX1R7zUURdiumUFV5hVdsau61C0HIqWYXdqMjHUDEwc509I1Yk6Zd
xWG4701GKtHudsHCxUIGW1LsGtrAobGeqUwQ3uiMspIOW5FYBKb2ixgaYCaNp3tS6ijTqBAn
8eUq3AUOZnl+mzG1tLmqdVxF8iXX6+WanNQi0XRHkrdY1Jmg0lLjpINl4skNqGOvmNgrLjYB
1VQsCJISIInO5fJkY2kRp6eSw2h5NRr/xoft+MAETgoZLLcLDiTVdMx3tC8hNBo+BE/WZB47
x5I0dUBIG1dzbrClsgPLsdmuW/AoSeFS1qfAegeLdVJmRNpZt1ltVomkldI5o2SRh2vS8quo
O5PZoU6rJo2pxpAny9CB9hsGWpNwj6nYhbQnDCA3OuAGZSlJq3jswpAk/JQfda9FPf8c/wMv
1Rp2DbBmBK0qoQXuwlqB+pvCdaIBl9HKzyHhYs0clvFDQAOgZfzR0ZYTHech9Wnw83Bxs6rp
wU+Sh5XpKRdsQTX/SLvtTNl7WDZHDxwJC64qBdUADF6NvnTot1nazCjrjpxGCHwk7ReI7V1i
ZJ1dh6mKuKlxWk1MDc79Wp24ialse2s76agThikL0ATUJEaXlNh3OwFdyJmhJFVZRbNdRqH5
9tBE+0bU4KrhkDZguvLDCt5f2UNJRbQf8BtEAXrJyILVX8kd98Bj2FYEdDBGx00iFR89MDVm
OSUlgzDM3EgbMILpwuf0KOgq6RDF9oH3GBhua2xcuCpjFjwzcKP6yeAqmjCPQil+ZLSEPF/T
mqhvI+q2gNhZ8ZWdeb0PZx1pX1GYUiytOy0oiORQHvgcofM16wGkxTZCWr4aLTIvm9al3HpQ
y55I9Wp7udNVSrNLSP6rGFtbdCQdoowcQCu/h5a0bGDGk2R7re0EG9fLLtOUVakG5ieXEc4q
SIO96PCmnp+UVZy6xYJHKaokdNk/ENEnpettw2Cfd3vYxlULXtPsLQlaN2CFjAmj92wdIU6w
EruXkvIubZk/d2Pepym1DzQj8v0pXGjzlIEvvmL3C7pYMpPo1u+kgFvdsV8mOZ1SZpKt6Ty9
1CVuITRkGM2jczXGUz9IsocoD1Xt+hOOnk4FnbGTar9Uc4dTqXGihoUCb5c5aRmc7hCDT7Vo
MLcKL1WPP263t8/PL7eHqGonCyPDO8k56GBImInyT1t/k7jZkvVC1kwfBkYKpkthlFZVQeeJ
JD2RPN0MqMT7JVXTx5TuYUBtwK3YKHeb8UhCFlu6osnHaiHiHTYticy+/lfePfz++vzjCyc6
SCyRu6V538bk5KnJ1s4cN7F+YQhsWKKO/QVLLRvhd5uJVX7Vxs/pJgTXVrQF/vZptV0t3FY7
4/fi9B/TPjtsSGEvaX25liUzS5gMvCoSsVBryj6m6haW+eQO9grE0qQFGwE5yyOQSU63qb0h
sHa8iWvWn3wqwQYzWFgHbyZqIWG/I5jCwlJJdZcGJrUseUwyZlKLqnQImNvuvuxUcsvos80d
4itOQFvfJDUEg6sk1yTLPKHy5tIfmuhRzl6JoeGZXUd8e3n94+vnhz9fnn+q39/e7F4zeI/o
TnhlkozDM1fHce0jm/IeGedwt1UJqqHbsnYgrBdXGbIC0cq3SKfuZ1YfZLjd1wgBzedeCsD7
P69mP45CxxtNCcvLxhodfqGWrNQ6ySt1SLBj2rBYYmOBjxYXzSo4yo6q1ke5J+w2n1Yfd4sN
MwNpWgAdbFxaNmyiQ/heHjxFcNxjTaRae27eZemyaObE8R6lBg5mXhxo2g5mqlatC248+2JK
b0xF3fkm0yik0vXoVhUKOs53pt3dER89APkZXtGaWKf5W6xnWp34XCh1fbFnJuXZNVFjWwye
AlzUVL8b3gUxu0NDmOV+35/q1jn3HOWinwISYngf6Jw7Tg8HmWINFCutKV4eX0DVtmz3TYFy
UTcf34nsEaiskifp7GTqBdohqfOypgdgijqoyYXJbFZeM8HJSj8ogKvaTAaK8uqiZVyXKZOS
qAvw3IJ1uwRPrRH87y96k4dKbGu9nXZHV6xv329vz2/AvrkaojyvlELHdCZ4yM0rcN7EnbTT
mqsWhXKbRTbXu7sjU4CW7r8jUx7v6CjAOkc8IwEKDM+M3lBYsiiZ00JCujdUzUCyqdOo6cUh
7aNzEl2YvQQIxhz3jpSaf6Jk+hjuNPuT0IfHanqp7gUaz6vTKroXTH9ZBVI1JVPbrIoberjg
MlyVVaqHKu+98JDuMQPlGw3AcCF5uWs98X5D0GH8ta55b3PR9FnpP2oZjWK6E0w0ZT6GvRfO
NztDiIN4amoBT2vvNaYxlCeNSXO+n8gYjE8lT+palSXJ4vvJzOE8Pa4qMzjJuiT305nD8elo
n97vpzOH49OJRFGUxfvpzOE86ZTHY5L8QjpTOE+biH4hkSGQLyd50mAamafdmSHey+0Yklly
kQD3U9LHI/6WDnyWFmoRJ2SSWQ88zGBdkxSS2VORFbchASi8HuXy1Eznh7LJv37+8Xp7uX3+
+eP1O1wTQ/99Dyrc4DDEuTM4JwOO/tj9IU3xCpCOBcpLzawSBne6R4nK5DwP/3o+9QL45eU/
X7+D2XdnBicFaYtVyl2AUcTuPYLXNttivXgnwIrb90aY0+rwgyLGgzF4U5ML6y7pvbI6OiC4
X2RUQ4DDBR4P+NlYMPU5kmxlj6RHV0V6qT57bpntpZH1p6xXBIwCrVnYyV4v77CWpx3K7rf0
FsLMKg0ml5lz3jQH0HqsN75/sTOXa+urCXOtb/j9MhVU1zchrwc3aoIGv2/u8kaTciY9LhTV
ktT8MrMbOzoSF5z+OpJ5dJd+jLjmA08ievfEYaLy6MAlOnB6ueoRoN5bfvjP15///mVhYrrD
JYK5c/5q3dDU2iKtzqlzidFgesEtJiY2iwNmHTXRVSeZ5jnRSo8U7OinAg1Oudl+OXB6NePZ
8jPCeQaGrjlWJ2F/4ZMT+lPnhGi4PQi0MgJ/V9O8hyVzn5ZPq9Is04Xnzibr9JNzGwyIq1J5
2wMTQxHCuT2FSYERmoVPzL6rmcjFwW7JbO4ofL9kplWNDxLgOeuptMlxOxQi3i6XXPsSsWj7
tkm57QTgguWWGXOR2dJbEDPTeZnNHcZXpIH1CANYeq3RZO6luruX6p4b0Ufmfjz/N23Pcgbz
uKP3E2aCL93jjpsOVcsNAnrXFInLKqBnySMeMCdvCl+teXy9ZHb1AKcXlwZ8Q2/1jPiKKxng
nIwUTu9Fany93HFd67Jes/mHqT7kMuTTAQ5xuGNjHOClDDOmR1UkmOEj+rhY7JePTMuYHIXz
o0ckl+uMy5kmmJxpgqkNTTDVpwlGjnBtOOMqBIk1UyMDwXcCTXqT82WAG4WA2LBFWYX0Wu2E
e/K7vZPdrWeUAK7rmCY2EN4UlwG9MD4SXIdAfM/i24xe3p0Ivo4VsfMRnHqr3bNyRBcuVmyr
UITlo28khiNuTxMHNlwffHTGVD/eGmKyhrgvPFNb+vYRiy+5guCbTUaIvGY7PH5nS5XIbcB1
UoWHXEuASxLcWZzv8oTG+WY4cGzDPjX5hpt0zrHgrt0aFHeFBNsvN3qBBVE46Flww04qBZxy
MCu2LF/tV9w6MYd7q0wO9OptxwjIv64bGKaakVmut74POZf3J2bNTb/IbBhNA4l96MvBPuQO
ETXjS43V5Yas+XLGEXBUGWz6KzzV9pzfmWHg9mUjmM1atVINNpzuBsSWPt8xCL5JI7lneuxA
3I3F9wQgd9zp+ED4kwTSl+RysWAaIxKcvAfC+y0kvd9SEmaa6sj4E0XWl+o6WIR8qusg/D8v
4f0akuzH4CCYG9vqTKlkTNNR+HLFdc66sdztGjCnPSp4z30V/OlxX20Cy+uJhbPprNcBmxvA
PZJo1htu9NdHsTzObbZ5j+UVzqlziDN9EXCuuSLODDSIe7674WW04dQ432bbcDPLK7sdMwX5
rxbKdLXlOj4+WGF3B0aGb+QTO20IOwHAsHcv1L9wKMXswRjnzr4zXc8dA5mHbPMEYs3pREBs
uJXqQPBSHkleADJfrbmJTjaC1bMA5+Ylha9Dpj3CXcH9dsPeVUp7yW6GCxmuucWIItYLblwA
YhswuUWCPmIcCLWeZfp6oxTMFad4Nkex3205IntchguRRtxi1CD5CjADsNU3B+AKPpLLgD6T
s2nnda9Dv5M9DHI/g9yWmSaVGsqthxu5FGG45fb/pV6teRhuR6ONhVLbmRhIcNtvSgvaL7kV
2TULQk4pu4J/cC6hPAjXiz55ZMbpa+4+BBrwkMfXgRdn+sR0jcfBd2sfzjVUxBmx+m5XwbEQ
N+cCzqm6iDNjGvdQYsI96XCrMDym8uSTW5YAzs1jiDM9DXBurlL4jltBaJzvVAPH9iY8UOPz
xR60cY9RRpzTMwDn1smAc3oD4ry89xteHnturYW4J59bvl3sd57ycpsliHvS4ZaSiHvyufd8
d+/JP7cgvXoujiLOt+s9p9te8/2CW4wBzpdrv+WUCt9RLOJMeT/h8dN+U9Gn00Cqxf5u7VnP
bjmtFAlOncTlLKc35lGw3HINIM/CTcCNVHmzWXKaMuLMpwtwSsh1kYIzMjERnDw0weRJE0x1
NJXYqEWIsJzJ2+dpVhSthsK1e/ZcaKZtQuulp1pUZ8JObxjHN/Bp7N7tOJuXTdWP/oAHkU9w
+zApTo3xJkOxtbjOv1sn7vxWWl+a+fP2GdwiwoedI0QIL1bgLMVOQ0RRi45YKFybb6EmqD8e
rRz2orLc9ExQWhNQmq/eEGnhOTWRRpJdzIcMGmvKCr5ro+npkBQOHJ3BuQzFUvWLgmUtBc1k
VLYnQbBcRCLLSOyqLuP0kjyRItEn74hVYWAOE4g96ceqFqhq+1QW4JdnxmfMEXwCHvZI6ZNM
FBRJrPcUGisJ8EkVhTat/JDWtL0da5LUubRNIujfTl5PZXlSvekscsskFFLNZrckmMoN0yQv
T6SdtRG4A4ls8CqyxrT8A9hjmlzRPRH59FOtbaNZaBqJmHwobQjwmzjUpJqba1qcqfQvSSFT
1avpN7IIrRkQMIkpUJSPpKqgxG4nHtHeNNRiEepHZUhlws2aArBu80OWVCIOHeqktB8HvJ4T
cEBAKxyNWedlK4ngclU7NZVGLp6OmZCkTHWiGz8Jm8IZYnlsCFzCAy3aiPM2a1KmJRVNSoE6
PdlQWdsNGzq9KMAVSVaa/cIAHSlUSaFkUJC8VkkjsqeCjK6VGqPAWjoH9scDSXjAGbvpJm1Z
X7eIJJY8E6U1IdSQgq6dIjJcofnBjtaZCkp7T11GkSAyUEOvI17noQuC1sCNBnWplNFDCdxT
JTGbROQOpBqrmjITUhb13Sqj81Odk1ZyAk9lQpoD/AS5uYK3Mr+VT3a6JupEaVLa29VIJhM6
LIBPplNOsbqVzWB1bmJM1PlaC9pFX5lG9hEOj5+SmuTjKpxJ5JqmeUnHxS5VDd6GIDFbBiPi
5OjTU6x0DNrjpRpDwZKzeRXTwLX1+OEXUTAy9BsyX9Zl9CNUnFp54LU1bYzE6ZRGrxpCaJuL
VmKH19efD9WP15+vn8GBNNXHIOLlYCQNwDhiTll+JzEazLprDH5a2VLBvTNdKsunq5vA95+3
l4dUnj3J4FMJRTuJ8fEmUz3md4zCl+coNZzGgIWDyBY0DZHnpgOYKYTlVsbmk3dToCHcXLTv
pkFDuGk49/LRhA65i48Ge2qYvIXsz5Hd6uxgll1AjFcUauaB10hg3g6tjsqxheZf3z7fXl6e
v99e/3rDtjNYgLBb52BlabSMa6fvs+SJldCcHKC/ntWInznpAHXIcBqTDXZyhz6aj0/R4o+a
veCq8+mkhjUF2I/TtJmjplTrDTX/gqEMcH8W2t2MSPnqCPSKFXIQRw88PQOb+/zr208wrTs6
GneM5GPUzbZbLLAyrXQ7aDE8Gh9OcMvqb4ewnkTNqPMOek5fifjA4Hlz4dBHVUIGH54i0i7j
ZB7RuiyxVvumYbpZ00Dz1N6uXdYpH6JHmfFf74sqyrfmBrfF8nIpuzYMFufKzX4qqyDYdDyx
3IQucVSNFQxlOIRSk5arMHCJkhVcOWWZCmBipKT95H4xW/ZDLRhwc1CZ7QImrxOsBECGO02Z
+iGg9U5sNuDK00mqTopEqiFN/X2WLn1lM3u+CgaM0OKOcFFJOzSA8HqRPMt08vPh29yltZOC
h+jl+e2Nn8FFRCSNdoUT0kGuMQnV5NOmTaGUqH8+oBibUi14kocvtz/VTPn2ADZ6Ipk+/P7X
z4dDdoFRvJfxw7fnv0dLPs8vb68Pv98evt9uX25f/ufh7XazUjrfXv7Eu/3fXn/cHr5+/9er
nfshHKloDdJ3riblWEIcABx3q5yPFItGHMWB/9hR6dGWimmSqYytgx2TU3+LhqdkHNeLvZ8z
9+xN7rc2r+S59KQqMtHGgufKIiGrTZO9gNUanhr2g3olosgjIdVG+/awCddEEK2wmmz67fmP
r9//GAz3k9aax9GOChIX1FZlKjStiAkKjT1yPXPG8ZW4/LBjyEIp8GqACGzqXMrGSas1DZRp
jGmKedMuUeckGKbJ+hucQpxEfEoaxt/UFCJuBfiMzhL3m2xecHyJ68jJEBJ3MwT/3M8QaltG
hrCqq8ESy8Pp5a/bQ/b89+0HqWocZtQ/G+t8dU5RVpKB227tNBAc5/Llct3BTmo2GfPJcYjM
hRpdvtzmr2P4Ki1Vb8ieiNJ4jZZ24oD0bYY2Mi3BIHFXdBjirugwxDui01rag+RWfhi/tC6x
THDSPRWlZIizoIJFGPaKwcwkQ83WeBgS7BLgUQTDkc6jwY/OMKrgkLZMwBzxonhOz1/+uP38
7/iv55d//AAvEVC7Dz9u//vX1x83vVrQQabHYz9xDrp9f/795fZleMVkf0itINLqnNQi89dU
6Ot1OgWqCukYbl9E3LHXPzFNDX4S8lTKBPaWjpIJo20eQJ7LOCXrNrD3ksYJqakR7cujh3Dy
PzFt7PmEHh0tClTP7Yb0zwF0FogDEQxfsGpliqM+gSL39rIxpO5oTlgmpNPhoMlgQ2E1qFZK
6zoRznlobp/DpiOvvxmO6ygDJVK1bDn4yPqyDMwbhwZHD6QMKjpbzxgMBte658RRTDQL14S1
v8LEXbmOaVdqJdHx1KAr5DuWTvIqObHMsYlTJaOSJR9Ta/vMYNLKNPdrEnz4RDUUb7lGsm9S
Po+7IDSv0NvUesmL5ITuJD25v/J427I4jNOVKMB47T2e5zLJl+pSHsBeSMTLJI+avvWVGp1B
8kwpt56eo7lgDXYL3W0mI8xu5Ynftd4qLMRj/v+cXVtz4zay/iuuPO1WnZyIpEhRD3ngTRIj
gqQJUpbnheX1KBPXTOwp26ld768/aIAXNNDUpM7LePR9uBFoNG6NxkIF1IXrrTySqto8CH1a
ZG+TqKMb9lboEtgVI0leJ3V4NifxA4e8pBmEqJY0NbccJh2SNU0EHpELdECrB7lncUVrpwWp
lg8zyzd7KPYsdJO19BkUyd1CTStXSDTFyrzM6LaDaMlCvDNsoYs5Ll2QnB9ia/oyVgjvHGt9
NjRgS4t1V6ebcLfaeHQ0NbBryxq8ZUkOJBnLAyMzAbmGWo/SrrWF7cRNnSkGf2smXGT7qsXn
thI2dyVGDZ3cb5LAMzk4LTRaO0+No1IApbrGB/ryA8C4IhWDLexq4s/Iufhz2puKa4TB2TuW
+cIouJgdlUl2yuMmas3RIK/uokbUigFLh1C40g9cTBTkVssuP7edsYwcXJ3vDLV8L8KZW3ef
ZDWcjUaF3UTx1/Wds7nFw/ME/uP5phIamXWgG/bJKgD/NqIq4cVR61OSQ1RxZBohW6A1Oysc
QBIL/+QMJjPGcj2L9kVmJXHuYB+D6SJf//Hx9vT48E2t7miZrw/aCmtcYkzMlENZ1SqXJMu1
x47GRZ16AwBCWJxIBuOQDDxQ2J9i/UyvjQ6nCoecIDXLpF7TG6eN3go9KXrl61Ex5JTUKJqa
phILg4EhlwZ6LCG0Rcav8TQJ9dFLgy2XYMddHHgIWb3Qx7Vw0zgxvf43S8Hl9en7H5dXURPz
2QIWgh2IvKmrxs1oczel3zc2Nm7VGijaprUjzbTR28C768bozOxkpwCYZ24zl8TWk0RFdLm7
baQBBTc0RJwmQ2Z4wU8u8iGwtTqLWOr7XmCVWIyrrrtxSVA6Fv+wiNBomH11NFRCtndXtBgr
ZyRG0aS26U/oPBwI9cak2p3DXYkUIawEY3g/ATwHmoOQvcO9E+N9XxiZjyJsohmMdiZouJsc
EiXi7/oqNkeFXV/aJcpsqD5U1ixIBMzsr+libgdsSjHGmiADT8HkpvkO1IKBdFHiUBjMI6Lk
nqBcCzslVhnQE3YKQyYKw+dT5xC7vjUrSv3XLPyIjq3yQZJRwhYY2Ww0VS5Gyq4xYzPRAVRr
LUTOlpIdRIQmUVvTQXaiG/R8Kd+dNVJolJSNa+QoJFfCuIuklJEl8mCar+ipnszNqJkbJWqJ
b83mw2ZEI9Ifyhp7EZVaDauEQf/hWtJAsnaErjEUa3ugJANgSyj2tlpR+Vn9uisTWHst47Ig
HwscUR6NJXe3lrXOUCPqySiDIhWqfOKTnDfRCiNJ1cs6xMgAs8pjHpmg0Ak94yYqDTFJkKqQ
kUrMrdG9ren2YB+h3A5a6PDI68J+5RCG0nD7/i6L0VNJ7X2t30OVP4XE12YQwPTJhAKb1tk4
zsGE1cTNtZKAt8G34VlfDLQf3y8/Jzfsr2/vT9+/Xf5zef0lvWi/bvi/n94f/7CNtFSSrBNT
+dyT+fkeuiHx/0ndLFb07f3y+vzwfrlhcFhgLVVUIdK6j4qWIftQxZSnHB4jm1mqdAuZoCkp
vHjN7/LWXImJFbM0GDLMtIo679EypruL0Q+wOsAAGCdgJHfW4Uqb0jGmCUp918D7uRkF8jTc
hBsbNnaxRdQ+li+n2tBofjUduXL5vBt6axICD0tbdWzHkl94+guE/LHNEkQ2FlMA8RRVwwT1
InfY2eYcGYXNfG1GE9quOsg6o0IX7Y5R2YAz4ibi+t4IJlv9Ihqi0ruE8UNCsWD4XyYZRYkl
zclbIlyK2MFffXtLqyR4mBoT6gwQXvlB4yBQyn0jxyBsizZGG+c7MUtKMbivinSX66b1shi1
1XiqHRIjm5bJO/iNXSd26+c9v+ewCLLrNtfetbF426EkoEm8cYzKOwkVwVPUk6R43pm/KbkR
aFx0meEFe2DMw9wBPuTeZhsmJ2R8MnBHz87V6hJSsHVHBYAq/1DGp3V4BS/rxZLSDqoyEErO
CDla39idayDQvoys3Vur/7YVP+RxZCcyvGhmyGt7tFpZSPY5Kyu6T6JT9BmPWKDfPGcZ422O
VN2AYHtLdvnz5fWDvz89frVHmylKV8rd/ibjHdPm8IyL/mepVD4hVg4/1pJjjrIP6tOfiflN
2tmUvReeCbZBexgzTDasyaLWBXNffLtDWsvK5/HmUDPWGzdvJBM3sEVbwh724Q52Qcu9PC6R
NSNC2HUuo0VR67j6DVqFlmKO428jE+ZesPZNVAhbgNzgzKhvoob3QYU1q5WzdnSXMxIvmOd7
Zskk6FKgZ4PIV+MEbnWHHhO6ckwUbsy6Zqqi/Fu7AAMqd1mNVpSQkV3tbdfW1wrQt4pb+/75
bBmZT5zrUKBVEwIM7KRDf2VHD5FXrfnjfLN2BpT6ZKACz4xwx0LPOYMnlLYzxVq6rTNLmIpF
o7vmK/2eu0r/jhlIk+27Ap9/KCFM3XBlfXnr+VuzjqyL1spgPYkCf7Ux0SLxt8jTiEoiOm82
gW9Wn4KtDEFm/f8YYNWicUvFz8qd68T6ECrxY5u6wdb8uJx7zq7wnK1ZuoFwrWLzxN0IGYuL
dtp9ndWFcmD97en56z+cf8qZfbOPJS8WaH89f4Z1hn1D5+Yf852nfxoKJ4bTG7P9ahauLF3B
inOjH/FJsOOZ2cgcVgT3+lpXtVIu6rhb6DugBsxmBVC54ZoqoX19+vLFVprDPQZTYY/XG9qc
WYUcuUpoaGSnilixrD4uJMradIE5ZGLtECPLFcTPFw5pHh5oo1OOkjY/5e39QkRCtU0fMtxD
kTUvq/Pp+zsYm73dvKs6nQWovLz//gQLxZvHl+ffn77c/AOq/v3h9cvl3ZSeqYqbqOR5Vi5+
U8SQu0VE1lGp79cgrsxauBe2FBHu/ZvCNNUW3g9Ta6o8zguowSm3yHHuxWAd5QW4KpgOj6at
kFz8W4pJXZkSeyBNm8i3qj90QKiudRA6oc2oGQSCDomYNN7T4HDn6NefXt8fVz/pATicUh4S
HGsAl2MZi1CAyhPLpodvBXDz9Cwa/vcHZPYMAcXiYwc57IyiSlyuxWxYXegj0L7LM7Ge7wpM
p80JrbLhQh2UyZopjYHDEBSVpkBHIopj/1OmX8ucmaz6tKXwM5lS3Iilrn7jZyRS7nj6SITx
PhF9oWvu7Q8EXvc4g/H+Tn/UReMC/cRsxA/3LPQD4ivFGBcgfz0aEW6pYqtRUfdiNjLNMdS9
Ek4w9xOPKlTOC8elYijCXYziEpmfBe7bcJ3ssL8oRKyoKpGMt8gsEiFVvWunDanalTjdhnG6
EVMqolriW8892jAXU+jtKrKJHcMuoacGEQLs0Livu+rRw7tE3WZMrDUICWlOAqcE4RQi5/LT
B/iMAFPROcKxg4uZwvUODhW6XWiA7UInWhECJnHiWwFfE+lLfKFzb+luFWwdqvNs0csHc92v
F9okcMg2hM62JipfdXTii4Xsug7VQ1hSb7ZGVRCPaEDTPDx//rEOTrmH7C4xLta+TLeYwsVb
krJtQiSomClBbJZwtYgJ0zemtLZ0KX0ncN8h2gZwn5aVIPT7XcRy3cMNpvUZBWK2pNW4FmTj
hv4Pw6z/RpgQh6FSIZvRXa+onmasEHWc0qW8PTqbNqJEeB22VDsA7hF9FnCfGMEZZ4FLfUJ8
uw6pLtLUfkJ1TpAzog+q9TLxZXK9RuB1pl/y1SQfBiiiisouIcfsT/flLattfHgIYuyxL88/
i5XD9Z4QcbZ1AyKP4TEmgsj34NWkIr5E7rfbMN6mnIezxAazeutRVXdq1g6Fw5FEI76AqiXg
eMQIwZg9fJnZtKFPJcW7MshtnSXgM1FD7Xm99Sh5PBGFbFiURmj/cmpN8+BkGu9b8T9yZE+q
w3bleB4hw7ylJAZv9s0jgiNagSiSucs+4kWduGsqgiDwhsaUMQvJHIwn66bSlydCYbPqjA7l
JrwNvC01pW03ATXbPINAEOpg41HaQD5FSNQ9XZdNmzqw12MJjzI5+1Vza8cvz2/w3vC1/qr5
aIFNDEK2rbOpFF42GF1VWJi5BtSYEzodgDuJqXn/NeL3ZSIEfnz8Fna1y6wYj4v1VEWQPbx2
ibBT3rSdvPUj4+ESwsWveVVeiIV9JHT6PtXv+0bn3Dj9isGsKY56sYDXzqSGnuGEOAdToEcs
NDAeOc7ZxKRSmKE7ojBKn2Ejxh0v5Dt8c6ic7eEWcY9B5QhGYIE22h49HIolOyMxxuTj7FqG
gLQYETJfaUZH7MxxGcu43g1fM6dcgys0HRie79QjThDrzibKcEh4shQn50ktoqpwCqdelXRW
fYQCC+mPcfTpNTuG20D2bhz009moxfbYH7gFJbcIgkug0AFF27O9fqVjJpA4QDGMc94BtYOh
wyg4PDUTG15uzHXfULzDnzEaD+N6lo2WyedmLVSLm0SNUTbNFtlghpckcX/Aw3wrhUdOSURv
bHQtknx7gpcQCS2CCi5+4MsDsxJRnXtOMu52trcdmSjYnWtffSdRzWBFRZaT8cE4xkhuKmN3
Hu+HTLEP6RqrCujIEU/yHF9fObROcNQneMMNMtjnzAodBt05Xi9bGXBTyY/xMazOEWHqxZFN
pWJj8BQzcj/9NK8DRLRG+rorhJbdkUsFPUhJLBQ0Xh134rw13asCaj0VGSqDMYR+nA9APUzT
8uYWEynLGElEuiUZADxrkkrf8JPpJrk9+wOizNqzEbTp0FU1AbFdoDvPhcFLjLn5CR00AKp/
n/oNh0SdGQj3+hmzDDEHKo6KotJn2AOel3XX2jkyqhjS9oSBZ7/M9mD1+Pry9vL7+83h4/vl
9efTzZe/Lm/vmvnb1El+FHRW/JHor9r0om5yzlx8ug5Pa+vm1+q3OTGZUHVuIfpoz/NPWX+M
f3VX6/BKMBad9ZArIyjLeWI340DGVZlaJcNqaQDHbmvinIs1U1lbeM6jxVzrpEBO6zVYF0Ad
DkhY3xac4VD3nKvDZCKh/sTHBDOPKgq8PyIqM6/Eigy+cCGAWC54wXU+8EheCDFytqLD9kel
UUKi3AmYXb0CX4VkrjIGhVJlgcALeLCmitO66JFODSZkQMJ2xUvYp+ENCes2FiPMxDQtskV4
V/iExESgdfPKcXtbPoDL86bqiWrLpcGiuzomFpUEZ9heqCyC1UlAiVt667iWJulLwbS9mDT6
disMnJ2FJBiR90g4ga0JBFdEcZ2QUiM6SWRHEWgakR2QUbkLuKMqBGy5bz0L5z6pCfJJ1Zhc
6Po+HoemuhX/3EViGZfqT7TpbAQJOyuPkI2Z9omuoNOEhOh0QLX6RAdnW4pn2r1eNPywiUV7
jnuV9olOq9FnsmgF1HWATsMwtzl7i/GEgqZqQ3Jbh1AWM0flB9s/uYMsQk2OrIGRs6Vv5qhy
DlywmGafEpKOhhRSULUh5SovhpRrfO4uDmhAEkNpAv6xk8WSq/GEyjJtvRU1QtyXco3nrAjZ
2YtZyqEm5kliVnq2C54ntXlBZCrWbVxFTepSRfitoSvpCKYQHb7LMtaCdJQqR7dlbolJbbWp
GLYciVGxWLamvoeBi7xbCxZ6O/Bde2CUOFH5gAcrGt/QuBoXqLospUamJEYx1DDQtKlPdEYe
EOqeoWtFc9Ji/i/GHmqESfJocYAQdS6nP8iMHUk4QZRSzPoNvHe/yEKfXi/wqvZoTi5hbOa2
i5S3/ui2pni5jbHwkWm7pSbFpYwVUJpe4GlnN7yCdxGxQFCUfMnP4k7sGFKdXozOdqeCIZse
x4lJyFH9Bcuja5r1mlalm32x1RZEj4Kbqmtz3Tl904rlxtbtEILKrn73SXNft0IMEnyqoXPt
MV/k7rLayjTDiBjfYv3MIdw4qFxiWRRmGgC/xNBveEJtWjEj0yurStqsKtUVbnSV+tQGgd6u
8jfUvbJ8yqubt/fBC+V0OCCp6PHx8u3y+vLn5R0dGURpLrqtq1tiDJDc8Z7W8kZ8lebzw7eX
L+CE7vPTl6f3h29g+ScyNXPYoDWj+O3o9q7it7qpP+d1LV0955H+19PPn59eL4+wGbdQhnbj
4UJIAF/HGUH1zJlZnB9lptzvPXx/eBTBnh8vf6Ne0NJD/N6sAz3jHyemtjZlacQfRfOP5/c/
Lm9PKKtt6KEqF7/XelaLaShHuZf3f7+8fpU18fHfy+v/3OR/fr98lgVLyE/zt56np/83UxhE
9V2Iroh5ef3ycSMFDgQ6T/QMsk2oK70BwC/UjaBqZE2Ul9JX5oyXt5dvYDP9w/ZzuaNeh5+S
/lHcyU0/0VHHdHdxz5l6/W98Wurh61/fIZ03cAr59v1yefxD28Gus+jY6a+9KgA2sdtDHyVl
q2t8m9WVscHWVaE/WGSwXVq3zRIbl3yJSrOkLY5X2OzcXmGXy5teSfaY3S9HLK5ExC/eGFx9
rLpFtj3XzfKHgM+QX/ETGVQ7T7HVJmkPo2Kkb/qmWdVHRZHtm6pPT1p+YJ4FN8hWugWYCp8y
L/D7U617alPMQT45Q6PwnMwRfGSa2efsPJRrtBL/X3b2fwl+2dywy+enhxv+179st8hz3ITn
Zo4C3gz4VEPXUsWx1Z3OE3rAWDFw/rQ2QWWi8UGAfZKlDfK2BAeNkPL4qW8vj/3jw5+X14eb
N3U0b468z59fX54+6wdZB6b7QIjKtKngqSyuX03Ndfs38UPaaWcMrgnUmEhYNKLamKUyNaVH
ruk0m/k26/cpEytxbVa5y5sMvPBZbgx2d217DxvlfVu14HNQ+pwO1jYvn/ZTtDf5WhqNDiyP
E7zf1fsITqFmsCtz8cG8jhq0783ge4tjfy7KM/zn7pP+IJRQna3eWdXvPtozxw3Wx35XWFyc
BvCY+9oiDmcxRK7ikiY2Vq4S970FnAgvZttbR7d503BPX8Uh3Kfx9UJ43Uuqhq/DJTyw8DpJ
xSBqV1ATheHGLg4P0pUb2ckL3HFcAj84zsrOlfPUccMtiSObXITT6SBTJx33CbzdbDy/IfFw
e7JwsTK5R8eWI17w0F3ZtdYlTuDY2QoYWfyOcJ2K4BsinTt5h6VqsbTvCt1n0xB0F8O/w/WO
ibzLi8RBmyEjYlyEn2F9rjyhh7u+qmIwRNFNRZB3efjVJ+g+joTQykYivOr0kzSJSW1sYGnO
XANCMz+JoOPDI98gY7h9k90j/xMD0GfctUFTYw0wqKxG9x86EkKFsrtIt+kYGeRFZQSNa10T
rG+pz2BVx8if6cgY7xqOMPjFs0Db0eT0TU2e7rMUezEcSXxVbERR1U+luSPqhZPViARrBLEn
jQnV23RqnSY5aFUNtl1SaLBVzXCZvj+JGYy21wcPy1r37NUMwILrfC2XNYO39revl3dtWjMN
vgYzxj7nBRh/gXTstFoQvRicOHEbMQ+3J/wsOn9D4OAs6Czm9AXB8SzpGnSFbaI6nvUn1oOz
iyZiVgB5RJ6Xv2XSVRIRHywGxKAPLxDC836+FeCTPmWc0KTo5Ot4NXhnLHKWt786s2GJHrkv
KzGlEI1MmqCgkDKYtPKqiqghDFKI0LEKrBnfgasK6VRS11kHBjfqQeI4dl0j5O88MHK3vxGr
JvTCqIgoDXOQwjvWidxc/zCAHovtiKJOMoKo542gsrlSG0I8LW+SqM5tW1FA++ikNTcEVkan
JxY7feygbWmKPa2vxoYd48UExL9o/9Wg26u5J2uC2uf7CLkTHAD5qZovswGVpm5WWObokwsN
dWzU6J6He1ESrdXh55j3vPK3WmQMf1voPsZYXvPpRaneMs2dDHgtRCipWt/YP4gBKptS0q1I
1D0ALEMj2NSM721YpN/WNoxkcwSFxLeVnZ0c62L9isPInGKiILKOdeU45SkvlWJYjA61fHh3
j3zaZEURldV5fqBrnqfIu+n9oWrrotO+d8D1waoq6gSuTXwg4Fw5G5/Cen3pKRYqcH1VDN2w
UTMLTHTK5GqmbrIaZgvESmc0u0pe/vzz5fkm+fby+PVm9yoWnLCfpnXneW1k3jjRKDjWiFpk
7Qgwr+GFeAQdeHokV172jU9MijWET3LGhVCNOeQBckyhUTxh+f+xdm3NbetI+q+45mmmaqcO
LyJFPlIkJTEmKZigFCUvLI+tk6g2trK2sxvvr180AErdACjPqdqHOOLXDRAgbg2gLxMENkGo
IrLrMUjRJMnQl0GU2SRl7jkpeZGXc8/9iYCWBu5PlHO1ADAndVU2VVs5G0WbCbhIPGgY9921
BuVt8f+qbElfHe42nRCRnPtuaQThohB5D+GbfZtxZ4pd7v4Ky2ov5E8a2lOWVsofnIKbz/XA
I89zoHMnmppo1mZixlhUPR8+d6yuBdgGyZrllG0UBk1wiMEWyYkOq6wvbdLtps2cH6SiBvEj
f/5l1W65ja+7wAZbzlygg5N3FOtEJ1qUXfdlYmCtKzF44nwXeu5OL+npFCmOPWedgTSfJNk+
wOi0EQQoaVfCoryuOBojvN8unMyIMFm2xQacuo8zcPX87fB8fLgBy4/fv2/y1dYWqqoWtI7z
QRB1RkhAQjRtUTJJC6LFNHF+JWHiEWFjusiO6qI4WWrJkWsNciAjT137w3/e8FPuXHnkGTAE
tHMuHH0ARxzTJDHkiUsLm6FqVh9wwJHvByzravkBR9mvP+BYFOwDjmxbfMCxCq9y+MEV0kcF
EBwffCvB8YmtPvhagqlZrvLl6irH1VYTDB+1CbCU7RWWeJ7Or5CulkAyXP0WkuN6GRXL1TJK
m8Fp0vU+JTmu9kvJcbVPCY70CunDAqTXC5D4ZO2jpHk4SUqukdS52rWXCp48u9K8kuNq8yoO
tpXbavc8bzBNzVFnpqyoP86nba/xXB1WiuOjWl/vsorlapdNQKt2mnTpbheFhKsrwpiTNHRb
FTjuuoTEnjLPnS+kgRMlcxaFQhYzQCmusZyD0X5CHGecybwp4EUOikCRvWvG7oZVng9iTzKj
aNNYcKWZZx4WcKpzFvGeorUTVbz4qklUQ6ExVnc9o6SGF9TkrW20ULxpjLX9Aa1tVOSgqmxl
rF5nFlgzO+uRpm40dmZhwpo5wY3H9YdH+XJRDzEpAPMsojDwkm8JGfTbDq4+rTxWzhzY1gWr
82QHAcz9XHjNMs4tAmuqQfzL5YkAjgekjEOXpMvfMs6HfU7PEUZ7S0N210aYpkkY0Mqm3Bni
f/c18w1kztPAPAPokmweZjMbJLLrBQxdYOQC5870VqEkmrt454kLTB1g6kqeut6Uml9Jgq7q
p65KpbETdLI6658mTtRdAasIaebFKzBloCc7a9GCZgZgxCu2DWZ1R3jI2cpNCidIW74QqaRX
dF7W7q4pUopBbm06CbVnbqoYKu6VigvZYIstB5U7aXCYEc/oKZrBINY2rs5csKmkNC73PWdK
RQumabPQSZPlrJbVzjx0k9iw3EYzb2BdjnetYPWO8noiBJ6nSexRgsyQarGcIdUy3EURr21M
vyU2NblKTXHB1fvyLYGq3bD04baYW6TIq4YMmsqBr+MpuLMIM5ENtJvJbxcmFpyhb8GJgIPQ
CYduOAl7F752cu9Cu+4JGKAGLrib2VVJ4ZU2DNwURMOjB6MZsqYAevb6jiU79/HymGz9mbOq
lU663/HhAD/9enlwRZ0A16nEM4dCWLdZ0GHAu9w46hvvaZX7VQzLkzMT1y6ILHh0QGQRPgsp
b2Giy75vOk/0IAOv9gycTRioVC+LTRSOFw2oK6zyqs5qg6KrrrkBK2UzA1Tuh0y0ZXkzt0uq
3QMNfZ+bJO3UyUqh2qRYQDh6Ochx36oZn/u+9ZqsrzM+tz7TnpsQ66omC6zCi97Vlda3b2X9
e9GGGZsoJqt4n+Vr46gYKKLvg4NEE24Zt/sfw+ejWac/FXdhQzxbVD2mNLpvc5Z4M0LYzRup
tVflt/hTNeCngeQhIW4hfb7QRbSKrBc+eep+6cQcIk03Vr+EE3ix/bEaA7yXmB0RFhj3p/4E
e2NacL7Wdc8bF9r0W/Rdx8V8w/vGwdzjflaeP2pfWQVxX2LJhoRL01Vlfy62Ryfu6ySE8dN0
iQPDW2INYr/KqlSgswqOdvPe/ky8B39WuClz8c18NGKN7bQxh54bJ6vqxQbdLEglW0Au6ijj
9XCzRiYmylnYEMJs0H0W3YEmGnV4FXwppvacRHjV2bgFwkm6AerSGk4P1E4eNuwVM5wvsSI3
swBfOk1xZ8CVWM624u8uMzG+ZTrCttLHAYX+48ONJN6w+28H6anaDj055jiwVS8D079PUdQg
5h8ygNS71JHVLlpAH5SH5jnec48+lQ9Pp7fDz5fTg8PLV9ls+lIHskGmB1YKldPPp9dvjkzo
Bb98lD5YTEyd5shYva0YdbvyCgM5eLGovCndZI7tDRV+9o9yqR+px3n6AIVBUFYeP5wYTc+P
n48vB+SGTBE2+c3f+fvr2+HpZiMkne/Hn/8AHfuH45+ikay4IrCYM7G934ie3fJhXdbMXOsv
5PHl2dOP0zeRGz85nLMpnfQ8a3fYZlWj8vIk41usBKBIKzHVbPKqXW4cFFIEQmxwsotauKOA
quRgbfDoLrjIx7pg1qFQQd1BTIJIwEQE3m42zKKwIBuTXIplv/0yfaa+LMHFldPi5XT/+HB6
cpd2FB+VNuQ7rsTolBt9EGdeyuZpz/5YvhwOrw/3YtDenV6qO/cLC5ZlsCtULuCxzdMHOZwt
Jdz5wny/YvkucLayXILyLdQL18fKTl1dCin29++J1ygJ965ZoaGvwZaRCjmy0QF7LqfAjn6v
53U604ue2WXkCBxQeTb2uSMBi3qp7GGcRDtfKQtz9+v+h2jQid6hVqSN2PsT36jqkFhMxODO
uEB3r2r6KttqwMpiCuWLyoDqGp/WqbmtaJJZ5KLcNZWeVrhBkSfV7xbECgOkE+o4lTqOv4FR
RmwprRxYYH4G3nAz/ee85dwY6Hpt73AHcX57PAKtw0vRrLl9eojQyIni8zME4wNEBOdObnxa
eEFTJ2/qzBgfGCJ05kSdFcFnhhh1M7trTY4NETxRE1yQTgircIBnMjqgZrMgEvdZjFx1Swfq
mrKgA0wd2Dn55WESJyrJkAfeEmzlLpWuD/vjj+PzxGynwnoPu3yL+60jBX7hVzxuvu6DNJ7T
Al9s+P4tIeMsv0vFzmVX3o1F1483q5NgfD6RZUaRhtVmp+NUDpu2KGHGugxKzCQmFtgcZMQ7
MGGAFZJnuwkyhOjhLJtMnXGupEFSckuQgg2ybmStUS0r/GR/hKHcQSSYd/NtEh7zaDdYO87J
wliDtkPlvs8vSjzl77eH07OWDe3CKuYhE5uTT8TGYiR01VfQ3jLxJc/SGfbxqHFqL6HBJtv7
s2g+dxHCEFv3X3Aj9JQmsL6NiA25xtU8DpdN4LbOInd9ks5Duxa8iSLsekzDMiyvqyKCkCN3
4mf5s9ngCCZwKlEt0Y5Y6SkNbYkjj44HGhjT7cnBxOYi+OCCVODvcLtckmOjMzbkCxerDKwn
xLUtCe8E9FuwzAAuCuvIQEJ41e8iVPUT6yKjNLRY41s5DM4zS4BZ+GfLUkvDI/tE0dTgefr3
vD0gddARSjG0r0mMFg2Y3hIUSPTHF03m43EgnoOAPOeiw8qgSrUbNfNDFPL6IguI/+UsxEqu
RZN1BdbAVUBqANgiDDnNVq/Dtpyy9bTmuaLqq1baSv2YFOx8Jmhgln2NDnHQDPrtnhep8WgY
hEiImoPs80+3vufjaKl5GNC4uJmQsCILMIzpNGiErs3mVGuhyYSgS+LxQmRBfzBj2ErUBHAh
9/nMw0YYAoiJMxueZ9QzFu9vkxB75gFgkUX/bx5MBumQR4zMusduxYu5j72BgSeTmHo6CVLf
eE7I82xO+WPPehaTp1iEwXMoWPnXE2RjaIr1Ijaek4EWhfgkhmejqPOU+ISZJzhgtnhOA0pP
Zyl9xrEL9eZfLKwIk1v7rMmiIjAoexZ4extLEorBQaJUmqZwLi1TfQMEz/sUKrIUJpcVo2jd
GsUp211Zbxi4wu3LnFhNjtfJmB2uPeoOZAgCwzrY7IOIousqmWETw/We+HSt2izYG19i1Pml
YLOfG9+3ZrmfmIl1rAUD7PNgNvcNgATsBABHSwAhhsR7AsD3SSRliSQUIKG0wFyEWEM3OQsD
7CkNgBmOxgBASpJonWNQ0xRCFbjgpq1RtsNX3+w56pCMZx1B22w7Jx5i4VaNJpSi1Q4aNzci
UkqKilgx7Dd2IimPVRP4bgIXMI5lI/UwvnQbWiYd+pNiEEbGgGT/ANdTZpBV5XlfVQpP1mfc
hIqlVMJyMCuKmUSMHQrJS1Bj4Mnb6txLfAeGvReN2Ix72J+Agv3ADxML9BLue1YWfpBwEo1I
w7FPPeZJWGSA1eYUJrb1noklIbYX0licmIXiKiguRRsh/xsNKeC+zmcRtmnaLWMZ6oB4NxEi
pfTuQXG94dVj4q+72Fq+nJ7fbsrnR3xkKMSVrhSrMD3vtFPoQ/GfP8T211hRkzAmvq4Ql9Iv
+H54Oj6AKyrpVAWnhbvmga21sIZlxTKmsic8m/KkxKjBYs6JD+Uqu6M9mzVgS4TmLXhz1Umn
LCuGBSrOOH7cfU3kIni58TNr5ZIvVb24MbwcHFeJQy3k2axd1ect+vr4OEaPAf9TSuXj8l2R
/Kv2KnR6M8iX3ci5cu78cREbfi6dahV1M8PZmM4skxSMOUOfBAplSs5nhvV2gQtkZ2wI3LQw
bhrpKgZNt5D2wqbGkRhS92oguEXJyIuJyBiFsUefqVwWzQKfPs9i45nIXVGUBp1h3KxRAwgN
wKPlioNZR2svhACfyPwgFcTUsVxETEPVsymcRnEam57aojmW8OVzQp9j33imxTXF15C6NEyI
9/SCbXrw+44QPpthWX4UnghTEwchrq6QXyKfykBRElB5Boy5KJAGZKciV83MXmKtsDC9clWf
BDSWuoKjaO6b2JxsiTUW432SWkjU25EvwCs9+exn8vHX09O7Pi6lA1Z6NhvKHTErlSNHHVuO
ns8mKOokg9OTE8JwPvEh/vRIgWQxly+H//p1eH54P/sz/F+Ial4U/A9W1+PFsNLCkLf192+n
lz+K4+vby/Ffv8C/I3GhqCLHGtobE+lUmMnv96+Hf9aC7fB4U59OP2/+Lt77j5s/z+V6ReXC
71qKPQGZBQQg2/f89r+a95jug29CprJv7y+n14fTz4P2bGYdJHl0qgKIxJgdodiEAjrn7Ts+
i8jKvfJj69lcySVGppblPuOB2INgvgtG0yOc5IHWOSlp41Oghm1DDxdUA84FRKV2HvRI0vQ5
kCQ7joGqfhUqY1hrrNpNpZb8w/2Pt+9IhhrRl7eb7v7tcNOcno9vtGWX5WxG5k4JYLuObB96
5k4PkIBIA66XICIulyrVr6fj4/Ht3dHZmiDEsnex7vHEtgYB39s7m3C9baoCvN5ciD0P8BSt
nmkLaoz2i36Lk/FqTg6p4DkgTWPVR1sRi4n0KFrs6XD/+uvl8HQQwvIv8X2swTXzrJE0o+Jt
ZQySyjFIKmuQ3Db7mJww7KAbx7Ibk7N1TCD9GxFc0lHNm7jg+yncOVhGmuGq9crXwhnA1xmI
A2iMXtYL2QL18dv3N9eM9kn0GrJiZrVY7XEs7YwVPCX27xIhhlOLtT+PjGfcbLlY3H3sfg8A
EoFCbAJJ1IRGSIgRfY7xCSoW/qV3FVCzRp9/xYKMic6ZeR662DjLvrwOUg8f01AKjt0tER/L
M/jQvOZOnBbmE8/EFh1HxmSd2IP79uvrJoxwOLS674iL9XonppwZdiEkpqEZ9e+vESQgbxhE
VUDZMFGewKMYr3wfvxqeiR1XfxuGPjmAHra7igeRA6L9/QKTodPnPJxhDyQSwHcw42fpRRuQ
sPMSSAxgjpMKYBZhH4hbHvlJgBa2Xd7W9MsphPhEK5s69rDHk10dk8uer+LjBupy6TyC6WhT
6kL3354Pb+oc3jEOb6ltoXzGW4NbLyUHgPqKqMlWrRN0XihJAr3QyFahP3EfBNxlv2lKcFdG
BIImD6MAO9/U85nM3726j2W6RnYs/mP7r5s8SmbhJMHobgaRVHkkdk1IlnOKuzPUNGO+djat
avRfP96OP38cflPlMzgU2JIjEsKol8yHH8fnqf6CzyXavK5aRzMhHnW5OnSbPpPe7Mhi43iP
LEH/cvz2DcTkf4LX7udHsSl6PtBarDutxu66pQVLhq7bst5NVhu+ml3JQbFcYehh4gffkBPp
wVuW69DGXTWyDfh5ehPL7tFxmRwFeJopIKIZPd2PiKNZBeD9stgNk6UHAD80NtCRCfjEk2fP
alP2nCi5s1ai1lj2qhuWareok9mpJGqL93J4BcHEMY8tmBd7DdKxXjQsoAIcPJvTk8QssWpc
3xcZds5dMB5OTFmsK3FgyjUjLcNqn9iAy2fj1ldhdI5kdUgT8oje38hnIyOF0YwEFs7NLm4W
GqNOqVFR6EIakc3LmgVejBJ+ZZkQtmILoNmPoDG7WY19kSefwZO/3Qd4mMollC6HhFl3o9Pv
4xNsFsQQvHk8vqqgD1aGUgCjUlBVZJ3425fDDp9MLXwiVHZLiC6Br0B4tyQG8fuUxGADMnYb
X0dh7Y2yO/oiV8v9l+MppGTLA/EV6Ej8IC81WR+efsKRjHNUiimoagYIq9Js8s2W1aVz9PQl
1g5u6n3qxVg6Uwi5lGqYh+/u5TPq4b2YgXG7yWcsgsEe2k8iciniqsrI3/ZouyMexJhCepEA
VEVPOVS89R4rawHMqnbFNjjADqD9ZlMbfGW3tF5pWPzIlF3WchrldNeU0mWq3oKJx5vFy/Hx
m0MFD1jzLPXz/SygGfRCDCehDAS2zG7PJ/Ay19P9y6Mr0wq4xUYswtxTaoDAC+qPaJeA7ezE
g3Y/SSBltLeu8yKn3vCAeFZVsOFbolEI6GhmaaCmph2A2uaPgutqgQNBAFThlUgBe7F0Gglr
FqZYtgQMFPDBy4WBjq6+CMpEy8X4cBpAqU5MEW0KCKZ1hKDt5CkGoo8DEoW1UFYarQT3zGOL
V93dzcP3408UqnicVrs7GtYiEx8VmxE2WQHWcSSetHhQBoc5NhD8JK0kM5x4rK2QAnNIJcab
gyiKYKPgqMMg9XyWgFCOi2LbPY4ZrBP1XlQV8Eqyyct608tMLtqWX1szF6jiaC0u6lSUSDsX
+ZvFKUSvEql4XxoH9Oa3PydgWX5L3SmrW+xehn8luxKIRiESbPIeR6VQbv/yi9/ld0rJ+jVW
9dfgnvve3kQXZVfTxpGoNhsy3kg9pCoMtHBMrM7aHnvT1Ki6XzJhqZfiBJWvrCHrrII4bKAV
4Wzs4iQwrCagcHXLYnLL0dYwP7Kqxjc5RO6wYOqIQoF9JS0J8JWyIpzdEUzgw6relibx65fW
dlA6OoAMYyN6KCbGSh9ViV3rLxBE5lUq7F+mAx37XbrAf3eAMN4qIXxjMsDjnSEoTG96PN8K
ovKcSiClBUNc2ms4rtA7TGLqSCO7SLKQnlgclGG1rz+ihU6aH2TTCTVRBgM16qacljoIyvUo
rcHZt4N0JGPVWbkwdRTjQjAK3/LA8WpAVXzHwshHujLJsG4nKqqjctqrQsGmcLMKI4WLDt0Z
r5EK8s0+ae4c7VrthUwx0Re0JbaVSJttO3AxjcF4WDiyEqJc1bYbx1dWE5hYxrcGUVmah/NI
WgKM3vzNUdHsysV2EGxi1dr22J0zpiZ7KJhVLkXOma+c8lh0ts+GIGmFyMOrfIJk10jpgtof
O2NsvWlL8JQmPqBHqXrNFMtQUXJKkkuMnZ+aZkXvCRw4sT+8oHZhJQ7dds0nCWbdu0xaXFsl
ujhyssfM2XZLdoN1YbYUpdvlvNh+WePlTOq/sNIoqtagLZgZ6AURZf+fJssXkj43WpPYpTyv
KtdJ4QTJrhuoA4GupR+KLioKak3YZ/psgl6tZ97csQxIIRdc2q+/GN8sa2IIa2j0RAhtNspB
dBIVay9EBTAq1Yu8dQBDjFbDqqkq6cgL7/TJUnlOACZkOQlIVtSlDhaCZE5siNOo+MwUqNlZ
HYwdXv48vTzJg4QndXOMJPZLga6wnWUFbGrar7dtATqS9cVMxgrNpkKxoY2Ajs22qCCtdGMx
QcO7QSPVGL3hb/86Pj8eXv7j+//oH//9/Kh+/W36fU7fEmZ4tyJDe8V2R8LLyUdzv6pAKa1X
jZFUwpt8gyM9GAQwPTeJo/RTgmsKK8+R6sgV9OWN18Ges1xuLZvruyXN+zyxGMwqY1i/nfVQ
QwsCY6C8zmPcmZfSlDKLObpacCbh7Y6Leq8YFm0h5ANn1kfSKtxjPkoh4vPN28v9gzwsNHes
/P8qu7LeOHIY/VcMP+0CmYnbV5wF8lBdR3dN1+U67LZfCh6nJzEmtgMfu8n++iWpUhUpsZws
EMDpj9RREiVRFEXxLT/8MK9toNtfGmoEjFbTSoLjhoVQU3Z1GLNYBj5tDVNZu4yDVqUmbS0u
jOLBRwYjz0fkFDCiK5W3UVGY4rV8Wy1f+1TL5J3hN65NRFuae/6rz1f1uNmZpWAEOqYcmYA6
FQ5ix5HPI1EkHyVjy+jYuF16eFEpRNwizX3L4BWu5wpz1bHrWGVpOWw0t+WhQjXvhnkfmdRx
fB171KECFU6Oxg5bO/nV8Srlm8Uy0XECI/Gy44D0SR7raC+CXQiKW1FBnCu7D5JOQYWIi37J
K7dn+Auo8KMvYroI2hfioXCk5AHp2fJGLiMYJ2gfD/ARvkSSGhF4mZBlLJ8nQ7DkwSvaeJyh
4L/siv1ktmbwOFV2WZtCN2+po90jYSVqSIf3IFYfPh6yVhrAZnHMzyYQla2BCAUV1M+VvcpV
sE5UTIlpUu6ygr96//W7JktzYbdCYIgkIiJlTHixihwanQzD/wvUl0YURgTiYoodj3/DonUJ
9uhYkDAS3HkXROYR3OkwU9q8jaPsHb43TKodt4IHeLjUxvSyXFA3Il4ivvqWc8Uv3raH8hU7
A3iP1Q2w9lbdQFKeqtu2R27mR/O5HM3mcuzmcjyfy/EbuThPf/21jNhmAn+5HJBVvqTn5pgy
EKcNKo6iTiMIrKEwMA443XeU8aBYRm5zc5LymZzsf+pfTt3+0jP5azax20zIiI4XGBORaaNb
pxz8fd6VbSBZlKIRrlv5uyxgbQEtK6y7pUrB17ZSY55mxMugLtT3Bbf2Q5TXBFdJI6V+AHqM
lYpRx6OMqeKgJzjsFunLQ75HGuExCEc/2FcUHmzRxi2EKoxT/wZfEVWJfD+wbF05tIjW6iON
ZHQI1Ck6f+SoO7xmWQCRTgq9Ih0JMWDQwGe3Wm5xguEf04QVVaSZ26rJofMxBGA7iY8e2Nwh
Y2Hlwy3Jl3aimObwiqDrUqgXO/nMPaw5NyPhmSrP3CL9kkJvlzy0aZLCPnwQQn6OVUR49fNq
hg55xUVYX1VuhYqyFY0euUBqAHNsOiUMXD6LULCDhgJh5GnTyIe9nLFPP/G1YDJq0ZKZiOas
agAHNhzG4psM7MiZAds65jvMJG/7i4ULsImdUoUt65Sga8ukkauKwaT84ROr4rlCsV8sQaaz
4ErODCMGUh+lNQhJH6U8BKHCEGSXAez0kjLLykuVFe0KW5WyhS6kuqvUPIYvL6sre4Qf3tx+
3TFlIWmcxW0A3NnJwmiLLlcitpMleSungcslDpQ+S3mgXCKhLPO2HTE3K0bh5U9XesxHmQ+M
/oAd+vvoIiL1yNOO0qb8iFZ2sT6WWcrPSK+BiQ/YLkoM/1SiXorxVCub90nQvi9avQaJmc4m
rbeBFAK5cFnwdxSbiSeEnQU+vfvp+OiDRk9LDAeKD6ru3z0/np2dfPxjsa8xdm3CIukWrSP7
BDgdQVh9ydt+5muNSfB59/r5ce8frRVIHRKuGAhsaMctsYt8FrRuoVGXVw4DHlryEU8gPVmc
l7CslbVDCtdpFtUxmz03cV0kMuYd/9nmlfdTm/8NwVmr8jhPYE9Rx/KlQfpj+oE1sdKMYz5p
E9KagPGqY/5MbFkHxSp2+jSIdMD0qcUS911rWll0CG1pTbASM/faSQ+/q6xz1BS3agS4WoVb
EU+vdTUIiww5HXj4JSz/sRt6aqICxVNUDLXp8jyoPdjv2hFXNW6r+ylqN5LwrAydI/GOelk5
72Yalmu8MONg2XXpQuTX7IHdkvwkRh15KDWHOaUvyiJWVGXOAgt2OVRbzaJJr/W3vjlTElyU
XQ1VVgqD+jl9bBEQ1QuMiReZNmKTs2UQjTCisrkmuGkjFw6wyVh4ajeN09Ej7nfmVOmuXccF
7JoCqZmFsILJZ5Dxt1EI8fFyh7HPeW2b8y5o1jy5RYx6aFZ01kWSbHQOpfFHNrTt5RX0JoUh
0DIaOMg6pHa4yolaY1h1bxXttPGIy24c4ez6WEVLBd1ea/k2Wsv2xxtcWpb03Mt1rDDE+TKO
olhLm9TBKse4hoMihRkcjUu7u2fGt4G3KjLE7QbNPkoDJjtl7s6vlQOcF9tjHzrVIWfOrb3s
DbIMwg1G0rsyQsqlwmUAYVVlwsuobNeKLBg2mABtQXaZBs1PhPeg36jOZGjtslOnxwDS8Bbx
+E3iOpwnnx1PE7ZbTRKseeoswf0aq63x9la+y7Kp7a586m/ys6//nRS8QX6HX7SRlkBvtLFN
9j/v/vl287Lb9xjNQZjbuBQ73wUTZ48/wLjFmObXq+ZCrkruKmWme9Iu2DKgaNBxe1nWG11n
K1wVHH7zfSz9PnJ/SxWDsGPJ01xyi6/h6BcewsIiV4VdLWAfWXbcKbmw65SDJVm8VVPY8nry
UsSZkRbDPo2GULyf9v/dPT3svv35+PRl30uVp/iYjFg9B5pdd6HEZZy5zWhXQQbibt7Ef+yj
wml3t5+SJhKfEEFPeC0dYXe4gMZ17ACV2FkQRG06tJ2kNGGTqgTb5Crx7QaK5s1Yq5riFoIW
XLImIM3E+el+F375qD+J/g+dR7Wbrqj50yLmd7/is+yA4XoBO9qi4F8w0KRgAwJfjJn0m3p5
4uUUpQ09/pEW1DC4sobo2dR4+br2h7haSzOQARwRG1BN8bekuR4JU5F9as3Dh5KlD9BANH2A
924k8lzGwaavLvs1qCMOqatCyMEBHZWLMPoEB3MbZcTcShozNe7J6W1ylzpXD789yyiQu1V3
9+rXKtAyGvl6aLWGb/0/ViJD+ukkJkzrU0Pwlf+CX6iHH9Ny5dtjkGwNOv0xv1onKB/mKfyO
taCc8WgGDuVwljKf21wNzk5ny+HxKhzKbA34FXmHcjxLma01j6bqUD7OUD4ezaX5ONuiH4/m
vkdEV5U1+OB8T9qUKB392UyCxeFs+UBymjpowjTV81/o8KEOH+nwTN1PdPhUhz/o8MeZes9U
ZTFTl4VTmU2ZnvW1gnUSy4MQ9yBB4cNhDLvYUMOLNu74Fd+RUpegvKh5XdVplmm5rYJYx+uY
X9yycAq1Eq8JjISiS9uZb1Or1Hb1Jm3WkkBm4hHBc1H+w51/uyINhevLAPQFvmmQpddG9xud
I5lNXXgzmAiDu9vXJ7yl+vgdo3Mx67FcV/BXX8fnXdy0vTN94zstKejZsB8HNnxRmp9lelm1
NR7XRgadDI/mcM3ivOA+WvclFBI4xrpxpY/yuKHrL22dcudaf+EYk+A2gjSVdVlulDwTrZxh
ZzFP6bdJnSvkKmiZnpDRO99BhWaIPoii+tPpycnRqSWv0RFyHdRRXEBr4Kkhni6RXhIGwqru
Mb1BAmU0y1DRe4sHZ7qm4pYQ8kkIiQMti+5jXyrZfO7+++e/7x7evz7vnu4fP+/++Lr79p25
845tA3IKo2irtNpA6Zdl2WKMb61lLc+geL7FEVOo6jc4govQPZPzeOgcG8YB+o6iG1AXTxbw
iTkX7Sxx9KMrVp1aEaKDLMGOoxXNLDmCqooLirxeYGghn60t8/KqnCXgjWo6Za5aGHdtffXp
8OD47E3mLkrbHv0lFgeHx3OcZQ5Mk19GVuLd0PlajDr2soPvTXHKaltxzDGmgC8OQMK0zCzJ
UcZ1OrP1zPI50+0Mw+CJobW+w2iOb2KNE1tI3Hl1KdA9SVmHmlxfBXmgSUiQ4HU+7qmvOKGM
kBGiVryuNxGD5irPY5xVnVl5YmGzeS36bmIZH+N8g4cEjBH4t8EP+wRgX4V1n0ZbEENOxRm1
7rK44TY8JGC0AjT2KRYvJBerkcNN2aSrX6W2p7xjFvt39zd/PEwGFs5E0tes6R0uUZDLcHhy
+ovySND3n7/eLERJZBmDXRQoNley8eo4iFQCSGodpE3soHW4fpOdBuzbOZKugC8XJ2mdXwY1
Gum5WqDybuItRmn+NSMFav+tLE0dFc55uQWiVWOMD05Lg2QwqA9TFYxuGHJlEYkDS0y7zGCK
RlcMPWsc2P325OCjhBGx6+bu5fb9v7ufz+9/IAgy9Se/ByM+c6hYWvDBE1/k4keP1gfYSHcd
nxWQEG/bOhgWFbJRNE7CKFJx5SMQnv+I3X/fi4+woqxoAePg8Hmwnqqx22M1K8zv8drp+ve4
oyBUhidMQJ/2f97c37z79njz+fvdw7vnm392wHD3+d3dw8vuC+rY75533+4eXn+8e76/uf33
3cvj/ePPx3c337/fgIYEbUMK+YbstHtfb54+7ygazqSYDy9KAu/PvbuHO4z+ePe/NzIYL0oC
KjGoR5SFmNSBgHflUY0cP4sbDC0H3kuQDOxtSbVwS56v+xh33N1u2MK3MKDIPMttT81V4UZ6
Nlge52F15aJbHvLeQNW5i8C4iU5hegjLC5fUjmokpEPlDl9CYiYulwnr7HHRLgZVL+Mq9fTz
+8vj3u3j027v8WnP6MBTbxlm6JNVUKVuHgN86OMwnaugz7rMNmFarcWb5Q7FT+RYNSfQZ635
9DZhKqOve9mqz9YkmKv9pqp87g2/qGBzwBMtnxW258FKyXfA/QQy5o3kHgXCceMduFbJ4vAs
7zKPUHSZDvrFV/TXqwD9iTzYuESEHi4DEg1gXKzSYry3Ur3+/e3u9g+YufduSXa/PN18//rT
E9m68WQetukeFId+LeIwWitgHTWBrUXw+vIV48nd3rzsPu/FD1QVmC/2/ufu5ete8Pz8eHtH
pOjm5carWxjmXv6rMPcqF64D+Hd4ADrC1eJIBJK1Y2qVNgse5tUhZDrl8OTUl5USFI5THg+T
ExYi/N1AaeLz9EJp0nUAU/WFbaslBVvHLfaz3xLL0P/qZOnLUesPhVAR5ThcelhWX3r5lUoZ
FVbGBbdKIaA2yXeO7chYz3cUum+0XW7bZH3z/HWuSfLAr8YaQbceW63CFya5jZe4e37xS6jD
o0M/JcF+A2xptlWY28VBlCb+bKLOzrMtk0fHCnbiT3wpiBXF0/BrXueRNggQPvWlFmBN/gE+
OlRkfM1fJp5AzEKBTxZ+EwJ85IO5gqFT+7JceYR2VS8++hlfVqY4s5Lfff8qruGNA96XYMB6
ftfWwkW3TBsPxjjcsOXy+0kFQUm6TFJFZCzBe57GilSQx1mWBgoBTbpziZrWFypE/R4WERcG
LNHXrc06uA78dasJsiZQhMRO1MoMGSu5xHUVF36hTe63Zhv77dFelmoDD/jUVEYuHu+/Y/BL
oYWPLUKeRn6Pc+e5ATs79gUQXe8UbO0PUfKxG2pU3zx8frzfK17v/9492Vc4tOoFRZP2YVUX
/oiI6iW9D9f5izxS1PnSULTZiSjaGoMED/wrbdu4RruksGgzRawPKn90WUKvTqgjtbEq5SyH
1h4jkXRvf2IJlHWMDDryNqKlXPotEV/06zQp+g8fT7bK0GJUVelGjioNy20Ig1xNP0SEUXsb
yM2Jv+IibkI3zmmUjEMZ/RO11SaHiQxT+BvUVFlNJ6qmYoqcDw+O9dzPQ39oGrzMZ9spzVdt
HOpChnQ/+iMjhus4a/hN6QHo0wrdalK6hKn2rWVsM70dL9K6FRmzpKG4yyVECq+187BD0uBL
QYnEBtgSq26ZDTxNt5xla6tc8IzlkKUojKHOCTpux94t6moTNmfoDH+BVMxj4BizsHm7OKb8
YI3uar4faCOEiadUgyGtio1LHl1QmFzKzUyPD278Q3uS571/MKbO3ZcHE4H29uvu9t+7hy/s
kv5ooaRy9m8h8fN7TAFsPWyv/vy+u58Ow8hNcd4m6dObT/tuamPMY43qpfc4jOf08cHH8fBx
NGr+sjJv2Dk9DpoK6Xoa1Hq64fUbDWqzXKYFVoquMyafxvdK/n66efq59/T4+nL3wJV9Y+Xh
1h+L9EuYx2D94se4GGhTfMAyBVURZIBbxm2UwwIDMLYpP3cLyzoSccZqvOVQdPky5k8RmgPs
IPPzrMLUDRpgSQ6MkVztM+hsnghhlMOyyUd5uBAqGgxGb0MBubddL1MdCeMD/OSOBBKHGSBe
Xp1xm62gHKsW1YElqC+dkxWHA/pAMbQC7VQoRVJFDpm/C+jV/lYsZPuYYe81TVx0yDk0/ATX
QRGVOW+IkSTc0+85au5kSBwvWKBCkImxSainKQqP+p8cZTkzXHOxn/OtR24tF+lPfy9g7Xu2
1whP6c3vfnt26mEUDa3yedPg9NgDA+5DMWHtGgaUR2hghvfzXYZ/eZiU4emD+tU1D3DMCEsg
HKqU7JrbfBmB34AR/OUMfuwPecXTo8YnwpsyK3MZJXZC0YHmTE+ABc6RINXidD4Zpy1DpvG0
sJY0MZ4UTgwT1m94CEeGL3MVThqGL+nuOVMnmjJMzT2doK4D4eRCsVZ4SDcDoXd0L+ZNxIWd
vsAvjfBkOahIgWdFRnTYGmYBXXRY02aEVQhrjPk1cdtVxCziC0x0PC9AcjK+rvIrLhEwe2RB
KshL9VZlkMeSe7QIJcUMF7keYey1spWfXJTFmMNwsQrqJnlCakNj/tr9c/P67QVfGXi5+/L6
+Pq8d2/Oh26edjd7+Hzif7E9J52pX8d9vryCkfhpcepRGrQ/GSpfUjgZb7fh7YbVzMohskr1
oCWSKdhqqwyesWagEuJVik9nvAFwE+h4iAi45/dfmlVmRjNbUykQhuJ1AV2PMUn6Mkno/E5Q
+lpIc3TOlYisXMpfypJdZNIFfZxr2jJPQz4JZ3XXOwELwuy6bwNWCEY/r0p+epFXqbw+6H9g
lOaCBX4kERNBDO6IYcSalh+pJ2XR+hdGEW0cprMfZx7C5y+CTn8sFg704cfi2IEwKmmmZBiA
plcoON4n7I9/KIUdONDi4MfCTd10hVJTQBeHPw4PHbiN68XpD66lNfi4dsYdABoMP1ryuxwo
UFFc8RHfgIIlhApPwbnLKnpTFivVj9RTvF2xIptms86i9MiXuYFYzxKzt4hhXkX8UJTTOpdY
Lv8KVitrGRvPp+1mjdDvT3cPL/+aZ1rud89ffFdY2nVsenndewDxloU4SDQX49BXLkOPw/HU
88Msx3mHoTFGrzq7dfVyGDnQIdKWH+HVJDbIrooABrQf1XH2K0cr5t233R8vd/fD5uuZWG8N
/uS3SVzQkWfeofFYxuNK6gC2PxhtRnoLgjxV0PEYcZVfyUPvJMoLSBPaFV2DushVviz5XssP
0LSO0c0Q47eAmPM5yRKc6uGl/xznfzK3iH3fMIOb61oY+SEP2lA6FQoKfSTGzrryKohee8M9
odiu69PO93ebe5SJYJVSwA3+LAUDR38N0y2fYJbRuMxDEW5dMQpH7KEY98Iu9YPfR7T7+/XL
F2HnoLsRoMjFRSNuuBFeXhbC9kIGmTJtStnqEgc1ZAiLNctxHdelW11iqePExU1sHE+ABljZ
00l6InRRSaPIgrM5S09xScOA8WvhxSHp5hL/GOxwhmsYgnZ6GHu8ybqlZeW+pQg7pmryNR+k
APToDOTVk45f4D2uleiwurLWpIMZRncDJoijw1HideHIgyGY+ibk/unDiCWHpw6nTZfEfeEs
Qqe48g7DSKqXClitYHu+8roa6oUBw6T33SCOZtDj7sJLtk5Xa2fTMvYCfQkGl0pEmKo3iZsA
xoshghC4zlrToB0XoNBsPAJQ9y9M/LWe782HwtbmDZxB14dM9vBN9dfvZqpa3zx84Y8DluEG
N0NxC6Ip/LTLpJ0ljp79nK2CwR/+Ds/gf7/g3npYQr/GAPctKNOKan95DpM2TN1RKZbHuQ+c
ZiAsEEPGiL2egMf6CCLOEnh1eLomAIIXeV7mBMrTIsLcCwnEZ+Qd7wA4a5vpOixyE8eVmWWN
qRSdREZR2PuP5+93D+g48vxu7/71ZfdjB//Zvdz++eef/yk71WS5Ik3Q1cJhC3mhhMqjZFhv
t164Ke9g2x97Q6KBuspQFMMI09kvLw0F5rTyUl6uGUq6bMS1f4NSxZz9mAkHU30SjqeWGQiK
CA3+/7RzghrEcaUVhC1GB47DCtM4DQQDAfdHzqw4fZmmdv8/OtFmaIY3DGVnBiMRcuIykDYD
7QPKF56sg6AZ26c3IZsVaAaGVRhm68abXGV4umGa1MDG08goMGKqLLZhDdUs2tRcgzHH32Gn
Kiokq0CcstB7ANdmfM9PgecT4FRP2uc43A8XIqVsaITi8+lm9fSKo6i8I/Tng1ZZO3YiQzaR
LkEVQ1MTd7KEqq1hCs3MAkKBT+ghjInFNm8f1zU9FmwDFkwnGrnONHGUCTnVzufHbBFxa+J3
v8k1HwM0SLMm4+YIRIwC6AxuIuTBJrZXFx0SvQ5s+ksSEhyDHBN1UTYhpqQ81AqSaaeB17vX
vPAIoAivWn5LraB3i4Fb3PsDUU66wmT4NnVVB9Va57F7RTc8i8nAVDEnHZS6to4cFoz/RyKP
nKCdF55mGQ4JTS5s5FF16GaZU7YpNZRrAdkh3IhysDVGcwjwi8UHhRsHgXnR0/twltUQ6UEG
uKhA389hgwibJfWzvPKs+cEtaGBUTFduwNu5fvxFF7KaUlPw+y31OehKiZfEKA+eLFyC3Pml
m54Y+rjx+q4pQLNdl36nWsKoAssGXsKSgteL6pIO2odLClPYogEPigLfIcdLN5QgbvQoR5Yd
xFBj5Iud94kYe4xcOrwgxBvIdxl77drp8LJKPMyOLRfXc5gbiaMIDN/p98/M+LS95+1uLaEN
ajy8kMRpSP0OBzlRzMgHDRvtqJ2Pv4l8r5H1GjCxJ9OXsxibqsV4LQOPObDR2FjF/Y4VGbet
a2hHPLbH/LAWg/fbKGrZJmpzVQipIcjPoYGRPs8ySzXi1vBo4Crfclw5sGPn+Wo6QvPolsrP
+EYV004daHDA1lNzmMadMVDMlGAPFaQSa4nsGs5s/tRe63iLEW7eaFBjoTa3zrVxb7kac1tI
pt4AoS214x8iD64m9wIcbOZuVgCDJpPpMfmIA+/ezVO3dLA5T7d7/nmOGl0ZKKLBG+0JLPPU
NArmieZsYK6psk3uNclFTrrYXBJyqKSQBU4DV16ToxfRuiRD1wUvJkkLfA2MTTNzhdk7qE7O
Q/xit+YdzSvz0kQRD2TwCiNPOQXzkpnhTTVYXbVtpOlZe0DhlIH7Rx5ZxGYmUQDk7Ghsfn0U
tHgaXNedDVc/RQ0NMEScNlhIYzOn96uIadf+L/vgcOi+hkVEZ7M7YRRwsuQqA6PRmYYZ0J/2
LxbJ4uBgX7ChrmbOQ9qaKxRE3IgqRss37OFIhd6jp5RlGlQd06LD6K5t0KD78ToNJ7vNeIje
LcnehpM1HiOIMweiOT/Roj2dJv+U44D4neXL7tZ95THMI3qnYymO9waUuQRaPpw46pQHi7GW
FmdZ5QHm+b5meMa76YtmcXpycuCU7JNx438wS27WaYKmMP/KqHT3I0sEvX6A9wbLsMsHhen/
AE+0tazZ2gMA

--jvkmbtajce6hg3rj--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3F7279424
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgIYWZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbgIYWZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 18:25:12 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C6FC0613D4
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:11 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id g29so3781385pgl.2
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ZBqDKCs3UV91tNNKDUdZObPVPhiHXGTe00G+Dh902U=;
        b=kvswmXAx/lTjvOat5tj2IBpVshR/zgo+wh3QK4Odd6iBMtWs83T31l6BoSyODUktXs
         8rHi8oIMOKPJlGx00qgKCvckCqYtsk+v0XpAs7cfT9hSN5Nz6A1SbwW2UX54A+kLUHDO
         W80HgNkWDeWD16tFH5BSsVJhu4VvPtOOx8cKWJsGo2pdb50bbI1nShUW+6pC+MIpyww5
         Qlk9PuWn++OPjSAyRKlhOZ2o9Pk8oU5oVp+9eBYYKIjUtgSRpri4CfN71sFO78gX5CFs
         Dyunx4nR/liUx6BlPHJpeD3EWYUtC8QYw83MERPBleCTW2j+kIAAFTxJfig9TC91Bf8W
         Vkfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ZBqDKCs3UV91tNNKDUdZObPVPhiHXGTe00G+Dh902U=;
        b=nwNuLF47+PNnOChwsw5Spchi54/rOCodCB1ODBfv4bQ7p9TV+PDiwZsUfBJ4PrR7gE
         mx+70rgplsHToAdPtABNaVMPhOpo7fJ7FWsaF6aBQiYZIRxWjZXbVXYkIXIFutdu3jRZ
         n6Zg0ihBSk9GFQgajR0oj72RyQlFNYRBhoEf1VM+yel3HMO2N/IZTRLq5pNLBFOzcHq0
         CkWr5VgVaUAU9PyxBEA4V988y4Z32OgF+a73MUfx69Tw44pPAkLdQwBYIWfnTZWb7xZ9
         JAYfwFItuumCpqR1OMV7yA3+srGN6DGY5xl60gdrM8Ge0QQt6ujxML+Dbpx56nv8wBiM
         Io+w==
X-Gm-Message-State: AOAM530oostkEeG3zaFktKZ2iW93D/WuCy13hdRUp45raFAfueQ0tGhd
        gOidbCwwfwgWzDLT2+DrVKNE9GE14TlgYP+Z
X-Google-Smtp-Source: ABdhPJw9UMO29aozSA6lfEKSgsY5EN2YoPW5xDRUS4Q8sGQ9DjYgvEkod3avkVLtYwgmwnG2y65itw==
X-Received: by 2002:a62:4e8a:0:b029:13c:1611:653b with SMTP id c132-20020a624e8a0000b029013c1611653bmr1261567pfb.13.1601072708911;
        Fri, 25 Sep 2020 15:25:08 -0700 (PDT)
Received: from jesse-ThinkPad-T570.lan (50-39-107-76.bvtn.or.frontiernet.net. [50.39.107.76])
        by smtp.gmail.com with ESMTPSA id q15sm169343pje.29.2020.09.25.15.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 15:25:07 -0700 (PDT)
From:   Jesse Brandeburg <jesse.brandeburg@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@gmail.com>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next v3 9/9] drivers/net/ethernet: clean up mis-targeted comments
Date:   Fri, 25 Sep 2020 15:24:45 -0700
Message-Id: <20200925222445.74531-10-jesse.brandeburg@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
References: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

As part of the W=1 cleanups for ethernet, a million [*] driver
comments had to be cleaned up to get the W=1 compilation to
succeed. This change finally makes the drivers/net/ethernet tree
compile with W=1 set on the command line. NOTE: The kernel uses
kdoc style (see Documentation/process/kernel-doc.rst) when
documenting code, not doxygen or other styles.

After this patch the x86_64 build has no warnings from W=1, however
scripts/kernel-doc says there are 1545 more warnings in source files, that
I need to develop a script to fix in a followup patch.

The errors fixed here are all kdoc of a few classes, with a few outliers:
In file included from drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c:10:
drivers/net/ethernet/qlogic/netxen/netxen_nic.h:1193:18: warning: ‘FW_DUMP_LEVELS’ defined but not used [-Wunused-const-variable=]
 1193 | static const u32 FW_DUMP_LEVELS[] = { 0x3, 0x7, 0xf, 0x1f, 0x3f, 0x7f, 0xff };
      |                  ^~~~~~~~~~~~~~
... repeats 4 times...
drivers/net/ethernet/sun/cassini.c:2084:24: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
 2084 |    RX_USED_ADD(page, i);
drivers/net/ethernet/natsemi/ns83820.c: In function ‘phy_intr’:
drivers/net/ethernet/natsemi/ns83820.c:603:6: warning: variable ‘tbisr’ set but not used [-Wunused-but-set-variable]
  603 |  u32 tbisr, tanar, tanlpar;
      |      ^~~~~
drivers/net/ethernet/natsemi/ns83820.c: In function ‘ns83820_get_link_ksettings’:
drivers/net/ethernet/natsemi/ns83820.c:1207:11: warning: variable ‘tanar’ set but not used [-Wunused-but-set-variable]
 1207 |  u32 cfg, tanar, tbicr;
      |           ^~~~~
drivers/net/ethernet/packetengines/yellowfin.c:1063:18: warning: variable ‘yf_size’ set but not used [-Wunused-but-set-variable]
 1063 |   int data_size, yf_size;
      |                  ^~~~~~~

Normal kdoc fixes:
warning: Function parameter or member 'x' not described in 'y'
warning: Excess function parameter 'x' description in 'y'
warning: Cannot understand <string> on line <NNN> - I thought it was a doc line

[*] - ok it wasn't quite a million, but it felt like it.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---

Testing Hints: build with W=1 in the drivers/net/ethernet directory,
I used:
 # yes this first step may be un-necessary, sorry
make allyesconfig
make allmodconfig
make modules_prepare
make M=drivers/net/ethernet W=1 modules
[optional -j N arguments to the above]

v3: Rebase to latest net-next, absorb/repair some fixes that were accepted
    upstream while I was working on this. include detailed warnings, fix
    extra warnings that popped up in a few files when rebasing.
v2: moved sfc change to separate patch. added note about kernel expecting
    kdoc.

Full List of Warnings:
drivers/net/ethernet/atheros/atlx/atl1.c:2558: warning: Function parameter or member 't' not described in 'atl1_phy_config'
drivers/net/ethernet/atheros/atlx/atl1.c:2558: warning: Excess function parameter 'data' description in 'atl1_phy_config'
drivers/net/ethernet/cadence/macb_main.c:466: warning: Function parameter or member 'clk' not described in 'macb_set_tx_clk'
drivers/net/ethernet/cadence/macb_main.c:466: warning: Function parameter or member 'speed' not described in 'macb_set_tx_clk'
drivers/net/ethernet/cadence/macb_main.c:466: warning: Function parameter or member 'dev' not described in 'macb_set_tx_clk'
drivers/net/ethernet/atheros/atl1e/atl1e_main.c:117: warning: Function parameter or member 't' not described in 'atl1e_phy_config'
drivers/net/ethernet/atheros/atl1e/atl1e_main.c:117: warning: Excess function parameter 'data' description in 'atl1e_phy_config'
drivers/net/ethernet/atheros/atl1e/atl1e_main.c:202: warning: Function parameter or member 'work' not described in 'atl1e_link_chg_task'
drivers/net/ethernet/atheros/atl1e/atl1e_main.c:202: warning: Excess function parameter 'netdev' description in 'atl1e_link_chg_task'
drivers/net/ethernet/atheros/atl1e/atl1e_main.c:251: warning: Function parameter or member 'txqueue' not described in 'atl1e_tx_timeout'
drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1507: warning: Function parameter or member 'napi' not described in 'atl1e_clean'
drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1507: warning: Function parameter or member 'budget' not described in 'atl1e_clean'
drivers/net/ethernet/atheros/atlx/atl2.c:999: warning: Function parameter or member 'txqueue' not described in 'atl2_tx_timeout'
drivers/net/ethernet/atheros/atlx/atl2.c:1011: warning: Function parameter or member 't' not described in 'atl2_watchdog'
drivers/net/ethernet/atheros/atlx/atl2.c:1011: warning: Excess function parameter 'data' description in 'atl2_watchdog'
drivers/net/ethernet/atheros/atlx/atl2.c:1036: warning: Function parameter or member 't' not described in 'atl2_phy_config'
drivers/net/ethernet/atheros/atlx/atl2.c:1036: warning: Excess function parameter 'data' description in 'atl2_phy_config'
drivers/net/ethernet/atheros/atlx/atl2.c:1240: warning: Function parameter or member 'work' not described in 'atl2_link_chg_task'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:19: warning: Cannot understand  * @file octeon_console.c
drivers/net/ethernet/cavium/liquidio/octeon_console.c:151: warning: Function parameter or member 'oct' not described in '__cvmx_bootmem_desc_get'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:151: warning: Function parameter or member 'base' not described in '__cvmx_bootmem_desc_get'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:151: warning: Function parameter or member 'offset' not described in '__cvmx_bootmem_desc_get'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:151: warning: Function parameter or member 'size' not described in '__cvmx_bootmem_desc_get'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:177: warning: Function parameter or member 'oct' not described in 'CVMX_BOOTMEM_NAMED_GET_NAME'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:177: warning: Function parameter or member 'addr' not described in 'CVMX_BOOTMEM_NAMED_GET_NAME'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:177: warning: Function parameter or member 'str' not described in 'CVMX_BOOTMEM_NAMED_GET_NAME'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:177: warning: Function parameter or member 'len' not described in 'CVMX_BOOTMEM_NAMED_GET_NAME'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:197: warning: Function parameter or member 'oct' not described in '__cvmx_bootmem_check_version'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:197: warning: Function parameter or member 'exact_match' not described in '__cvmx_bootmem_check_version'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:337: warning: Function parameter or member 'oct' not described in 'octeon_named_block_find'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:337: warning: Function parameter or member 'name' not described in 'octeon_named_block_find'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:337: warning: Function parameter or member 'base_addr' not described in 'octeon_named_block_find'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:337: warning: Function parameter or member 'size' not described in 'octeon_named_block_find'
drivers/net/ethernet/cavium/liquidio/octeon_console.c:716: warning: Function parameter or member 'oct' not described in 'octeon_remove_consoles'
drivers/net/ethernet/atheros/atl1c/atl1c_main.c:210: warning: Function parameter or member 't' not described in 'atl1c_phy_config'
drivers/net/ethernet/atheros/atl1c/atl1c_main.c:210: warning: Excess function parameter 'data' description in 'atl1c_phy_config'
drivers/net/ethernet/atheros/atl1c/atl1c_main.c:351: warning: Function parameter or member 'txqueue' not described in 'atl1c_tx_timeout'
drivers/net/ethernet/atheros/atl1c/atl1c_main.c:852: warning: Function parameter or member 'type' not described in 'atl1c_clean_tx_ring'
drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1866: warning: Function parameter or member 'napi' not described in 'atl1c_clean'
drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1866: warning: Function parameter or member 'budget' not described in 'atl1c_clean'
drivers/net/ethernet/freescale/fman/fman_muram.c:155: warning: Function parameter or member 'muram' not described in 'fman_muram_free_mem'
drivers/net/ethernet/freescale/fman/fman_muram.c:155: warning: Function parameter or member 'offset' not described in 'fman_muram_free_mem'
drivers/net/ethernet/freescale/fman/fman_muram.c:155: warning: Function parameter or member 'size' not described in 'fman_muram_free_mem'
drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c:156: warning: Function parameter or member 'dev' not described in 'link_report'
drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c:156: warning: Excess function parameter 'p' description in 'link_report'
drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c:315: warning: Function parameter or member 'adap' not described in 't3_os_phymod_changed'
drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c:315: warning: Function parameter or member 'port_id' not described in 't3_os_phymod_changed'
drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c:315: warning: Excess function parameter 'phy' description in 't3_os_phymod_changed'
drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c:315: warning: Excess function parameter 'mod_type' description in 't3_os_phymod_changed'
drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c:1212: warning: Function parameter or member 'adap' not described in 'cxgb_up'
drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c:1212: warning: Excess function parameter 'adapter' description in 'cxgb_up'
drivers/net/ethernet/brocade/bna/bfa_ioc.c:1771: warning: Function parameter or member 'ioc' not described in 'bfa_nw_ioc_fwver_cmp'
drivers/net/ethernet/brocade/bna/bfa_ioc.c:1771: warning: Function parameter or member 'fwhdr' not described in 'bfa_nw_ioc_fwver_cmp'
drivers/net/ethernet/brocade/bna/bfa_ioc.c:2475: warning: Function parameter or member 'cbfn' not described in 'bfa_nw_ioc_attach'
drivers/net/ethernet/brocade/bna/bfa_ioc.c:2508: warning: Function parameter or member 'ioc' not described in 'bfa_nw_ioc_pci_init'
drivers/net/ethernet/brocade/bna/bfa_ioc.c:2508: warning: Function parameter or member 'clscode' not described in 'bfa_nw_ioc_pci_init'
drivers/net/ethernet/brocade/bna/bfa_ioc.c:2577: warning: Function parameter or member 'ioc' not described in 'bfa_nw_ioc_mem_claim'
drivers/net/ethernet/brocade/bna/bfa_ioc.c:2645: warning: Function parameter or member 'cbfn' not described in 'bfa_nw_ioc_mbox_queue'
drivers/net/ethernet/brocade/bna/bfa_ioc.c:2645: warning: Function parameter or member 'cbarg' not described in 'bfa_nw_ioc_mbox_queue'
drivers/net/ethernet/cortina/gemini.c:92: warning: Function parameter or member 'page' not described in 'gmac_queue_page'
drivers/net/ethernet/cortina/gemini.c:92: warning: Function parameter or member 'mapping' not described in 'gmac_queue_page'
drivers/net/ethernet/freescale/fman/fman.c:2079: warning: Function parameter or member 'module' not described in 'fman_register_intr'
drivers/net/ethernet/freescale/fman/fman.c:2079: warning: Function parameter or member 'isr_cb' not described in 'fman_register_intr'
drivers/net/ethernet/freescale/fman/fman.c:2079: warning: Function parameter or member 'src_arg' not described in 'fman_register_intr'
drivers/net/ethernet/freescale/fman/fman.c:2079: warning: Excess function parameter 'mod' description in 'fman_register_intr'
drivers/net/ethernet/freescale/fman/fman.c:2079: warning: Excess function parameter 'f_isr' description in 'fman_register_intr'
drivers/net/ethernet/freescale/fman/fman.c:2079: warning: Excess function parameter 'h_src_arg' description in 'fman_register_intr'
drivers/net/ethernet/freescale/fman/fman.c:2104: warning: Function parameter or member 'module' not described in 'fman_unregister_intr'
drivers/net/ethernet/freescale/fman/fman.c:2104: warning: Excess function parameter 'mod' description in 'fman_unregister_intr'
drivers/net/ethernet/freescale/fman/fman.c:2355: warning: Function parameter or member 'fman' not described in 'fman_get_revision'
drivers/net/ethernet/freescale/fman/fman.c:2355: warning: Function parameter or member 'rev_info' not described in 'fman_get_revision'
drivers/net/ethernet/freescale/fman/fman.c:2520: warning: Function parameter or member 'fm_dev' not described in 'fman_bind'
drivers/net/ethernet/freescale/fman/fman.c:2520: warning: Excess function parameter 'dev' description in 'fman_bind'
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:1352: warning: Function parameter or member 'priv' not described in 'dpaa2_eth_drain_bufs'
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:1352: warning: Function parameter or member 'count' not described in 'dpaa2_eth_drain_bufs'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c:851: warning: Function parameter or member 'bp' not described in 'bnx2x_read_pages_regs'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c:851: warning: Function parameter or member 'p' not described in 'bnx2x_read_pages_regs'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c:851: warning: Function parameter or member 'preset' not described in 'bnx2x_read_pages_regs'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c:3569: warning: Function parameter or member 'num_rss' not described in 'bnx2x_change_num_queues'
drivers/net/ethernet/freescale/fman/mac.c:372: warning: Function parameter or member 'rx_pause' not described in 'fman_get_pause_cfg'
drivers/net/ethernet/freescale/fman/mac.c:372: warning: Function parameter or member 'tx_pause' not described in 'fman_get_pause_cfg'
drivers/net/ethernet/freescale/fman/mac.c:372: warning: Excess function parameter 'rx' description in 'fman_get_pause_cfg'
drivers/net/ethernet/freescale/fman/mac.c:372: warning: Excess function parameter 'tx' description in 'fman_get_pause_cfg'
drivers/net/ethernet/cisco/enic/enic_ethtool.c:30: warning: cannot understand function prototype: 'struct enic_stat '
drivers/net/ethernet/cavium/liquidio/lio_core.c:35: warning: Cannot understand  * \brief Delete gather lists
drivers/net/ethernet/cavium/liquidio/lio_core.c:76: warning: Cannot understand  * \brief Setup gather lists
drivers/net/ethernet/cavium/liquidio/lio_core.c:524: warning: Cannot understand  * \brief Setup output queue
drivers/net/ethernet/cavium/liquidio/lio_core.c:701: warning: Cannot understand  * \brief wrapper for calling napi_schedule
drivers/net/ethernet/cavium/liquidio/lio_core.c:714: warning: Cannot understand  * \brief callback when receive interrupt occurs and we are in NAPI mode
drivers/net/ethernet/cavium/liquidio/lio_core.c:740: warning: Cannot understand  * \brief Entry point for NAPI polling
drivers/net/ethernet/cavium/liquidio/lio_core.c:795: warning: Cannot understand  * \brief Setup input and output queues
drivers/net/ethernet/cavium/liquidio/lio_core.c:946: warning: Cannot understand  * \brief Droq packet processor sceduler
drivers/net/ethernet/cavium/liquidio/lio_core.c:975: warning: Cannot understand  * \brief Interrupt handler for octeon
drivers/net/ethernet/cavium/liquidio/lio_core.c:1002: warning: Cannot understand  * \brief Setup interrupt for octeon device
drivers/net/ethernet/cavium/liquidio/lio_core.c:1200: warning: Cannot understand  * \brief Net device change_mtu
drivers/net/ethernet/cisco/enic/enic_api.c:31: warning: Function parameter or member 'netdev' not described in 'enic_api_devcmd_proxy_by_index'
drivers/net/ethernet/cisco/enic/enic_api.c:31: warning: Function parameter or member 'vf' not described in 'enic_api_devcmd_proxy_by_index'
drivers/net/ethernet/cisco/enic/enic_api.c:31: warning: Function parameter or member 'cmd' not described in 'enic_api_devcmd_proxy_by_index'
drivers/net/ethernet/cisco/enic/enic_api.c:31: warning: Function parameter or member 'a0' not described in 'enic_api_devcmd_proxy_by_index'
drivers/net/ethernet/cisco/enic/enic_api.c:31: warning: Function parameter or member 'a1' not described in 'enic_api_devcmd_proxy_by_index'
drivers/net/ethernet/cisco/enic/enic_api.c:31: warning: Function parameter or member 'wait' not described in 'enic_api_devcmd_proxy_by_index'
drivers/net/ethernet/brocade/bna/bfa_cee.c:116: warning: Function parameter or member 'cee' not described in 'bfa_cee_reset_stats_isr'
drivers/net/ethernet/brocade/bna/bfa_cee.c:116: warning: Function parameter or member 'status' not described in 'bfa_cee_reset_stats_isr'
drivers/net/ethernet/brocade/bna/bfa_cee.c:160: warning: Function parameter or member 'attr' not described in 'bfa_nw_cee_get_attr'
drivers/net/ethernet/brocade/bna/bfa_cee.c:160: warning: Function parameter or member 'cbfn' not described in 'bfa_nw_cee_get_attr'
drivers/net/ethernet/brocade/bna/bfa_cee.c:160: warning: Function parameter or member 'cbarg' not described in 'bfa_nw_cee_get_attr'
drivers/net/ethernet/brocade/bna/bfa_cee.c:189: warning: Function parameter or member 'cbarg' not described in 'bfa_cee_isr'
drivers/net/ethernet/brocade/bna/bfa_cee.c:189: warning: Function parameter or member 'm' not described in 'bfa_cee_isr'
drivers/net/ethernet/brocade/bna/bfa_cee.c:218: warning: Function parameter or member 'arg' not described in 'bfa_cee_notify'
drivers/net/ethernet/cavium/liquidio/lio_main.c:72: warning: Cannot understand  * \brief determines if a given console has debug enabled.
drivers/net/ethernet/cavium/liquidio/lio_main.c:225: warning: Cannot understand  * \brief Forces all IO queues off on a given device
drivers/net/ethernet/cavium/liquidio/lio_main.c:241: warning: Cannot understand  * \brief Cause device to go quiet so it can be safely removed/reset/etc
drivers/net/ethernet/cavium/liquidio/lio_main.c:286: warning: Cannot understand  * \brief Cleanup PCI AER uncorrectable error status
drivers/net/ethernet/cavium/liquidio/lio_main.c:306: warning: Cannot understand  * \brief Stop all PCI IO to a given device
drivers/net/ethernet/cavium/liquidio/lio_main.c:335: warning: Cannot understand  * \brief called when PCI error is detected
drivers/net/ethernet/cavium/liquidio/lio_main.c:365: warning: Cannot understand  * \brief mmio handler
drivers/net/ethernet/cavium/liquidio/lio_main.c:379: warning: Cannot understand  * \brief called after the pci bus has been reset.
drivers/net/ethernet/cavium/liquidio/lio_main.c:396: warning: Cannot understand  * \brief called when traffic can start flowing again.
drivers/net/ethernet/cavium/liquidio/lio_main.c:450: warning: Cannot understand  * \brief register PCI driver
drivers/net/ethernet/cavium/liquidio/lio_main.c:458: warning: Cannot understand  * \brief unregister PCI driver
drivers/net/ethernet/cavium/liquidio/lio_main.c:466: warning: Cannot understand  * \brief Check Tx queue status, and take appropriate action
drivers/net/ethernet/cavium/liquidio/lio_main.c:494: warning: Cannot understand  * \brief Print link information
drivers/net/ethernet/cavium/liquidio/lio_main.c:516: warning: Cannot understand  * \brief Routine to notify MTU change
drivers/net/ethernet/cavium/liquidio/lio_main.c:534: warning: Cannot understand  * \brief Sets up the mtu status change work
drivers/net/ethernet/cavium/liquidio/lio_main.c:566: warning: Cannot understand  * \brief Update link status
drivers/net/ethernet/cavium/liquidio/lio_main.c:672: warning: Function parameter or member 'netdev' not described in 'setup_sync_octeon_time_wq'
drivers/net/ethernet/cavium/liquidio/lio_main.c:699: warning: Function parameter or member 'netdev' not described in 'cleanup_sync_octeon_time_wq'
drivers/net/ethernet/cavium/liquidio/lio_main.c:831: warning: Cannot understand  * \brief PCI probe handler
drivers/net/ethernet/cavium/liquidio/lio_main.c:927: warning: Cannot understand  * \brief PCI FLR for each Octeon device.
drivers/net/ethernet/cavium/liquidio/lio_main.c:954: warning: Cannot understand  *\brief Destroy resources associated with octeon device
drivers/net/ethernet/cavium/liquidio/lio_main.c:1155: warning: Cannot understand  * \brief Send Rx control command
drivers/net/ethernet/cavium/liquidio/lio_main.c:1213: warning: Cannot understand  * \brief Destroy NIC device interface
drivers/net/ethernet/cavium/liquidio/lio_main.c:1275: warning: Cannot understand  * \brief Stop complete NIC functionality
drivers/net/ethernet/cavium/liquidio/lio_main.c:1316: warning: Cannot understand  * \brief Cleans up resources at unload time
drivers/net/ethernet/cavium/liquidio/lio_main.c:1349: warning: Cannot understand  * \brief Identify the Octeon device and to map the BAR address space
drivers/net/ethernet/cavium/liquidio/lio_main.c:1393: warning: Cannot understand  * \brief PCI initialization for each Octeon device.
drivers/net/ethernet/cavium/liquidio/lio_main.c:1417: warning: Cannot understand  * \brief Unmap and free network buffer
drivers/net/ethernet/cavium/liquidio/lio_main.c:1437: warning: Cannot understand  * \brief Unmap and free gather buffer
drivers/net/ethernet/cavium/liquidio/lio_main.c:1477: warning: Cannot understand  * \brief Unmap and free gather buffer with response
drivers/net/ethernet/cavium/liquidio/lio_main.c:1521: warning: Cannot understand  * \brief Adjust ptp frequency
drivers/net/ethernet/cavium/liquidio/lio_main.c:1558: warning: Cannot understand  * \brief Adjust ptp time
drivers/net/ethernet/cavium/liquidio/lio_main.c:1575: warning: Cannot understand  * \brief Get hardware clock time, including any adjustment
drivers/net/ethernet/cavium/liquidio/lio_main.c:1598: warning: Cannot understand  * \brief Set hardware clock time. Reset adjustment
drivers/net/ethernet/cavium/liquidio/lio_main.c:1621: warning: Cannot understand  * \brief Check if PTP is enabled
drivers/net/ethernet/cavium/liquidio/lio_main.c:1635: warning: Cannot understand  * \brief Open PTP clock source
drivers/net/ethernet/cavium/liquidio/lio_main.c:1668: warning: Cannot understand  * \brief Init PTP clock
drivers/net/ethernet/cavium/liquidio/lio_main.c:1685: warning: Cannot understand  * \brief Load firmware to device
drivers/net/ethernet/cavium/liquidio/lio_main.c:1724: warning: Cannot understand  * \brief Poll routine for checking transmit queue status
drivers/net/ethernet/cavium/liquidio/lio_main.c:1741: warning: Cannot understand  * \brief Sets up the txq poll check
drivers/net/ethernet/cavium/liquidio/lio_main.c:1774: warning: Cannot understand  * \brief Net device open for LiquidIO
drivers/net/ethernet/cavium/liquidio/lio_main.c:1834: warning: Cannot understand  * \brief Net device stop for LiquidIO
drivers/net/ethernet/cavium/liquidio/lio_main.c:1899: warning: Cannot understand  * \brief Converts a mask based on net device flags
drivers/net/ethernet/cavium/liquidio/lio_main.c:1932: warning: Cannot understand  * \brief Net device set_multicast_list
drivers/net/ethernet/cavium/liquidio/lio_main.c:1980: warning: Cannot understand  * \brief Net device set_mac_address
drivers/net/ethernet/cavium/liquidio/lio_main.c:2099: warning: Cannot understand  * \brief Handler for SIOCSHWTSTAMP ioctl
drivers/net/ethernet/cavium/liquidio/lio_main.c:2157: warning: Cannot understand  * \brief ioctl handler
drivers/net/ethernet/cavium/liquidio/lio_main.c:2177: warning: Cannot understand  * \brief handle a Tx timestamp response
drivers/net/ethernet/cavium/liquidio/lio_main.c:3310: warning: Cannot understand  * \brief Setup network interfaces
drivers/net/ethernet/cavium/liquidio/lio_main.c:3875: warning: Cannot understand  * \brief initialize the NIC
drivers/net/ethernet/cavium/liquidio/lio_main.c:3931: warning: Cannot understand  * \brief starter callback that invokes the remaining initialization work after
drivers/net/ethernet/cavium/liquidio/lio_main.c:4026: warning: Cannot understand  * \brief Device initialization for each Octeon device that is probed
drivers/net/ethernet/cavium/liquidio/lio_main.c:4306: warning: Cannot understand  * \brief Debug console print function
drivers/net/ethernet/cavium/liquidio/lio_main.c:4333: warning: Cannot understand  * \brief Exits the module
drivers/net/ethernet/freescale/fman/fman_port.c:1420: warning: Function parameter or member 'port' not described in 'fman_port_use_kg_hash'
drivers/net/ethernet/freescale/fman/fman_port.c:1420: warning: Function parameter or member 'enable' not described in 'fman_port_use_kg_hash'
drivers/net/ethernet/freescale/fman/fman_port.c:1440: warning: Function parameter or member 'port' not described in 'fman_port_init'
drivers/net/ethernet/freescale/fman/fman_port.c:1553: warning: Function parameter or member 'port' not described in 'fman_port_cfg_buf_prefix_content'
drivers/net/ethernet/freescale/fman/fman_port.c:1553: warning: Function parameter or member 'buffer_prefix_content' not described in 'fman_port_cfg_buf_prefix_content'
drivers/net/ethernet/freescale/fman/fman_port.c:1586: warning: Function parameter or member 'port' not described in 'fman_port_disable'
drivers/net/ethernet/freescale/fman/fman_port.c:1663: warning: Function parameter or member 'port' not described in 'fman_port_enable'
drivers/net/ethernet/freescale/fman/fman_port.c:1709: warning: Function parameter or member 'dev' not described in 'fman_port_bind'
drivers/net/ethernet/freescale/fman/fman_port.c:1723: warning: Function parameter or member 'port' not described in 'fman_port_get_qman_channel_id'
drivers/net/ethernet/freescale/fman/fman_port.c:1737: warning: Function parameter or member 'port' not described in 'fman_port_get_device'
drivers/net/ethernet/hisilicon/hns/hnae.c:276: warning: Function parameter or member 'ae_chain' not described in 'RAW_NOTIFIER_HEAD'
drivers/net/ethernet/freescale/fec_ptp.c:520: warning: Function parameter or member 'work' not described in 'fec_time_keep'
drivers/net/ethernet/freescale/fec_ptp.c:577: warning: Function parameter or member 'pdev' not described in 'fec_ptp_init'
drivers/net/ethernet/freescale/fec_ptp.c:577: warning: Function parameter or member 'irq_idx' not described in 'fec_ptp_init'
drivers/net/ethernet/freescale/fec_ptp.c:577: warning: Excess function parameter 'ndev' description in 'fec_ptp_init'
drivers/net/ethernet/cavium/liquidio/octeon_droq.c:785: warning: Function parameter or member 'oct' not described in 'octeon_droq_process_poll_pkts'
drivers/net/ethernet/cavium/liquidio/octeon_droq.c:785: warning: Function parameter or member 'droq' not described in 'octeon_droq_process_poll_pkts'
drivers/net/ethernet/cavium/liquidio/octeon_droq.c:785: warning: Function parameter or member 'budget' not described in 'octeon_droq_process_poll_pkts'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:515: warning: Function parameter or member 'num_of_coalesced_segs' not described in 'bnx2x_set_gro_params'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:1980: warning: Function parameter or member 'include_cnic' not described in 'bnx2x_set_real_num_queues'
drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:2494: warning: Function parameter or member 'credits' not described in 't3_sge_cqcntxt_op'
drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:2899: warning: Function parameter or member 'alpha' not described in 't3_load_mtus'
drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:2899: warning: Excess function parameter 'alphs' description in 't3_load_mtus'
drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:3493: warning: Function parameter or member 'caps' not described in 'init_link_config'
drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:3493: warning: Excess function parameter 'ai' description in 'init_link_config'
drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c:37: warning: Function parameter or member 'mbox' not described in 'octeon_mbox_read'
drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c:37: warning: Excess function parameter 'oct' description in 'octeon_mbox_read'
drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c:293: warning: Function parameter or member 'mbox' not described in 'octeon_mbox_process_message'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:57: warning: Function parameter or member 'bp' not described in 'bnx2x_exe_queue_init'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:57: warning: Function parameter or member 'remove' not described in 'bnx2x_exe_queue_init'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:115: warning: Function parameter or member 'elem' not described in 'bnx2x_exe_queue_add'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:115: warning: Excess function parameter 'cmd' description in 'bnx2x_exe_queue_add'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:285: warning: Function parameter or member 'pstate' not described in 'bnx2x_state_wait'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:285: warning: Excess function parameter 'state_p' description in 'bnx2x_state_wait'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:432: warning: Excess function parameter 'details' description in '__bnx2x_vlan_mac_h_write_trylock'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:980: warning: Function parameter or member 'type' not described in 'bnx2x_vlan_mac_set_rdata_hdr_e1x'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:1619: warning: Function parameter or member 'cqe' not described in 'bnx2x_complete_vlan_mac'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:1619: warning: Function parameter or member 'ramrod_flags' not described in 'bnx2x_complete_vlan_mac'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:1619: warning: Excess function parameter 'cont' description in 'bnx2x_complete_vlan_mac'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:1665: warning: Function parameter or member 'qo' not described in 'bnx2x_optimize_vlan_mac'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:1665: warning: Excess function parameter 'o' description in 'bnx2x_optimize_vlan_mac'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:1730: warning: Function parameter or member 'o' not described in 'bnx2x_vlan_mac_get_registry_elem'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:1730: warning: Function parameter or member 'elem' not described in 'bnx2x_vlan_mac_get_registry_elem'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:1730: warning: Function parameter or member 'restore' not described in 'bnx2x_vlan_mac_get_registry_elem'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:1781: warning: Function parameter or member 'qo' not described in 'bnx2x_execute_vlan_mac'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:1781: warning: Function parameter or member 'exe_chunk' not described in 'bnx2x_execute_vlan_mac'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:2022: warning: Function parameter or member 'o' not described in 'bnx2x_vlan_mac_del_all'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:2022: warning: Function parameter or member 'vlan_mac_flags' not described in 'bnx2x_vlan_mac_del_all'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:2776: warning: Function parameter or member 'o' not described in 'bnx2x_mcast_get_next_bin'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:2904: warning: Function parameter or member 'o' not described in 'bnx2x_mcast_handle_restore_cmd_e2'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:3220: warning: Function parameter or member 'p' not described in 'bnx2x_mcast_handle_current_cmd'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:3220: warning: Function parameter or member 'cmd' not described in 'bnx2x_mcast_handle_current_cmd'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:3332: warning: Function parameter or member 'p' not described in 'bnx2x_mcast_set_rdata_hdr_e2'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:3693: warning: Function parameter or member 'p' not described in 'bnx2x_mcast_set_rdata_hdr_e1'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:3726: warning: Function parameter or member 'o' not described in 'bnx2x_mcast_handle_restore_cmd_e1'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:3808: warning: Function parameter or member 'fw_hi' not described in 'bnx2x_get_fw_mac_addr'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:3808: warning: Function parameter or member 'fw_mid' not described in 'bnx2x_get_fw_mac_addr'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:3808: warning: Function parameter or member 'fw_lo' not described in 'bnx2x_get_fw_mac_addr'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:3808: warning: Function parameter or member 'mac' not described in 'bnx2x_get_fw_mac_addr'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:3830: warning: Function parameter or member 'o' not described in 'bnx2x_mcast_refresh_registry_e1'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:3830: warning: Excess function parameter 'cnt' description in 'bnx2x_mcast_refresh_registry_e1'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:4324: warning: Function parameter or member 'p' not described in 'bnx2x_init_credit_pool'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:4736: warning: Function parameter or member 'o' not described in 'bnx2x_queue_comp_cmd'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:5495: warning: Function parameter or member 'o' not described in 'bnx2x_queue_chk_transition'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:5747: warning: Function parameter or member 'o' not described in 'bnx2x_func_state_change_comp'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:5787: warning: Function parameter or member 'o' not described in 'bnx2x_func_comp_cmd'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:5813: warning: Function parameter or member 'o' not described in 'bnx2x_func_chk_transition'
drivers/net/ethernet/chelsio/cxgb3/sge.c:381: warning: Function parameter or member 'q' not described in 'free_rx_bufs'
drivers/net/ethernet/chelsio/cxgb3/sge.c:381: warning: Excess function parameter 'rxq' description in 'free_rx_bufs'
drivers/net/ethernet/chelsio/cxgb3/sge.c:506: warning: Function parameter or member 'adap' not described in 'refill_fl'
drivers/net/ethernet/chelsio/cxgb3/sge.c:506: warning: Excess function parameter 'adapter' description in 'refill_fl'
drivers/net/ethernet/chelsio/cxgb3/sge.c:580: warning: Function parameter or member 'adap' not described in 'recycle_rx_buf'
drivers/net/ethernet/chelsio/cxgb3/sge.c:580: warning: Excess function parameter 'adapter' description in 'recycle_rx_buf'
drivers/net/ethernet/chelsio/cxgb3/sge.c:845: warning: Function parameter or member 'q' not described in 'get_packet_pg'
drivers/net/ethernet/chelsio/cxgb3/sge.c:1184: warning: Function parameter or member 'addr' not described in 'write_tx_pkt_wr'
drivers/net/ethernet/chelsio/cxgb3/sge.c:1633: warning: Function parameter or member 'addr' not described in 'write_ofld_wr'
drivers/net/ethernet/chelsio/cxgb3/sge.c:1896: warning: Function parameter or member 'napi' not described in 'ofld_poll'
drivers/net/ethernet/chelsio/cxgb3/sge.c:1896: warning: Excess function parameter 'dev' description in 'ofld_poll'
drivers/net/ethernet/chelsio/cxgb3/sge.c:2017: warning: Function parameter or member 'pi' not described in 'cxgb3_arp_process'
drivers/net/ethernet/chelsio/cxgb3/sge.c:2017: warning: Excess function parameter 'adapter' description in 'cxgb3_arp_process'
drivers/net/ethernet/chelsio/cxgb3/sge.c:2080: warning: Function parameter or member 'lro' not described in 'rx_eth'
drivers/net/ethernet/chelsio/cxgb3/sge.c:2252: warning: Function parameter or member 'adap' not described in 'check_ring_db'
drivers/net/ethernet/chelsio/cxgb3/sge.c:2252: warning: Excess function parameter 'adapter' description in 'check_ring_db'
drivers/net/ethernet/chelsio/cxgb3/sge.c:2919: warning: Function parameter or member 't' not described in 'sge_timer_tx'
drivers/net/ethernet/chelsio/cxgb3/sge.c:2919: warning: Excess function parameter 'data' description in 'sge_timer_tx'
drivers/net/ethernet/chelsio/cxgb3/sge.c:2959: warning: Function parameter or member 't' not described in 'sge_timer_rx'
drivers/net/ethernet/chelsio/cxgb3/sge.c:2959: warning: Excess function parameter 'data' description in 'sge_timer_rx'
drivers/net/ethernet/chelsio/cxgb3/sge.c:3036: warning: Function parameter or member 'dev' not described in 't3_sge_alloc_qset'
drivers/net/ethernet/chelsio/cxgb3/sge.c:3036: warning: Excess function parameter 'netdev' description in 't3_sge_alloc_qset'
drivers/net/ethernet/microchip/encx24j600-regmap.c:22: warning: Function parameter or member 'ctx' not described in 'encx24j600_switch_bank'
drivers/net/ethernet/microchip/encx24j600-regmap.c:22: warning: Function parameter or member 'bank' not described in 'encx24j600_switch_bank'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:385: warning: Function parameter or member 'port_num' not described in 'hns_mac_port_config_bc_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:385: warning: Function parameter or member 'vlan_id' not described in 'hns_mac_port_config_bc_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:385: warning: Function parameter or member 'enable' not described in 'hns_mac_port_config_bc_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:385: warning: Excess function parameter 'queue' description in 'hns_mac_port_config_bc_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:385: warning: Excess function parameter 'en' description in 'hns_mac_port_config_bc_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:418: warning: Function parameter or member 'enable' not described in 'hns_mac_vm_config_bc_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:418: warning: Excess function parameter 'en' description in 'hns_mac_vm_config_bc_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:549: warning: Function parameter or member 'auto_neg' not described in 'hns_mac_get_autoneg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:549: warning: Excess function parameter 'enable' description in 'hns_mac_get_autoneg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:807: warning: Excess function parameter 'np' description in 'hns_mac_get_info'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c:618: warning: Function parameter or member 'en' not described in 'hns_mac_config_sds_loopback'
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:102: warning: Cannot understand  * \brief Cause device to go quiet so it can be safely removed/reset/etc
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:146: warning: Cannot understand  * \brief Cleanup PCI AER uncorrectable error status
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:166: warning: Cannot understand  * \brief Stop all PCI IO to a given device
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:208: warning: Cannot understand  * \brief called when PCI error is detected
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:259: warning: Cannot understand  * \brief Print link information
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:281: warning: Cannot understand  * \brief Routine to notify MTU change
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:299: warning: Cannot understand  * \brief Sets up the mtu status change work
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:331: warning: Cannot understand  * \brief Update link status
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:377: warning: Cannot understand  * \brief PCI probe handler
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:419: warning: Cannot understand  * \brief PCI FLR for each Octeon device.
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:440: warning: Cannot understand  *\brief Destroy resources associated with octeon device
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:595: warning: Cannot understand  * \brief Send Rx control command
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:647: warning: Cannot understand  * \brief Destroy NIC device interface
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:707: warning: Cannot understand  * \brief Stop complete NIC functionality
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:740: warning: Cannot understand  * \brief Cleans up resources at unload time
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:766: warning: Cannot understand  * \brief PCI initialization for each Octeon device.
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:795: warning: Cannot understand  * \brief Unmap and free network buffer
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:815: warning: Cannot understand  * \brief Unmap and free gather buffer
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:856: warning: Cannot understand  * \brief Unmap and free gather buffer with response
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:900: warning: Cannot understand  * \brief Net device open for LiquidIO
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:944: warning: Cannot understand  * \brief Net device stop for LiquidIO
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:994: warning: Cannot understand  * \brief Converts a mask based on net device flags
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:1063: warning: Cannot understand  * \brief Net device set_multicast_list
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:1113: warning: Cannot understand  * \brief Net device set_mac_address
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:1232: warning: Cannot understand  * \brief Handler for SIOCSHWTSTAMP ioctl
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:1290: warning: Cannot understand  * \brief ioctl handler
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:1920: warning: Cannot understand  * \brief Setup network interfaces
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:2232: warning: Cannot understand  * \brief initialize the NIC
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c:2273: warning: Cannot understand  * \brief Device initialization for each Octeon device that is probed
drivers/net/ethernet/micrel/ksz884x.c:9: warning: Function parameter or member 'fmt' not described in 'pr_fmt'
drivers/net/ethernet/micrel/ksz884x.c:968: warning: Function parameter or member 'len' not described in 'ksz_dma_buf'
drivers/net/ethernet/micrel/ksz884x.c:1305: warning: Function parameter or member 'reserved2' not described in 'ksz_hw'
drivers/net/ethernet/micrel/ksz884x.c:1475: warning: Function parameter or member 'monitor_timer_info' not described in 'dev_priv'
drivers/net/ethernet/micrel/ksz884x.c:1576: warning: Function parameter or member 'hw' not described in 'hw_block_intr'
drivers/net/ethernet/micrel/ksz884x.c:1827: warning: Function parameter or member 'last' not described in 'port_r_mib_pkt'
drivers/net/ethernet/micrel/ksz884x.c:1983: warning: Function parameter or member 'addr' not described in 'port_chk_shift'
drivers/net/ethernet/micrel/ksz884x.c:1983: warning: Excess function parameter 'offset' description in 'port_chk_shift'
drivers/net/ethernet/micrel/ksz884x.c:2004: warning: Function parameter or member 'addr' not described in 'port_cfg_shift'
drivers/net/ethernet/micrel/ksz884x.c:2004: warning: Excess function parameter 'offset' description in 'port_cfg_shift'
drivers/net/ethernet/micrel/ksz884x.c:4432: warning: Function parameter or member 'dma_buf' not described in 'free_dma_buf'
drivers/net/ethernet/micrel/ksz884x.c:4432: warning: Function parameter or member 'direction' not described in 'free_dma_buf'
drivers/net/ethernet/micrel/ksz884x.c:4569: warning: Function parameter or member 'direction' not described in 'ksz_free_buffers'
drivers/net/ethernet/micrel/ksz884x.c:4728: warning: Function parameter or member 'hw_priv' not described in 'transmit_cleanup'
drivers/net/ethernet/micrel/ksz884x.c:4728: warning: Function parameter or member 'normal' not described in 'transmit_cleanup'
drivers/net/ethernet/micrel/ksz884x.c:4728: warning: Excess function parameter 'dev' description in 'transmit_cleanup'
drivers/net/ethernet/micrel/ksz884x.c:4785: warning: Function parameter or member 'hw_priv' not described in 'tx_done'
drivers/net/ethernet/micrel/ksz884x.c:4785: warning: Excess function parameter 'dev' description in 'tx_done'
drivers/net/ethernet/micrel/ksz884x.c:4892: warning: Function parameter or member 'txqueue' not described in 'netdev_tx_timeout'
drivers/net/ethernet/micrel/ksz884x.c:6085: warning: cannot understand function prototype: 'struct hw_regs '
drivers/net/ethernet/micrel/ksz884x.c:6249: warning: Excess function parameter 'dev' description in 'EEPROM_MAGIC'
drivers/net/ethernet/micrel/ksz884x.c:6249: warning: Excess function parameter 'eeprom' description in 'EEPROM_MAGIC'
drivers/net/ethernet/micrel/ksz884x.c:6249: warning: Excess function parameter 'data' description in 'EEPROM_MAGIC'
drivers/net/ethernet/micrel/ksz884x.c:6393: warning: Function parameter or member 'ring' not described in 'netdev_get_ringparam'
drivers/net/ethernet/micrel/ksz884x.c:6393: warning: Excess function parameter 'pause' description in 'netdev_get_ringparam'
drivers/net/ethernet/micrel/ksz884x.c:6696: warning: Function parameter or member 't' not described in 'dev_monitor'
drivers/net/ethernet/micrel/ksz884x.c:6696: warning: Excess function parameter 'ptr' description in 'dev_monitor'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:3098: warning: Function parameter or member 'bp' not described in 'bnx2x_get_common_flags'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:3098: warning: Function parameter or member 'fp' not described in 'bnx2x_get_common_flags'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:3098: warning: Function parameter or member 'zero_stats' not described in 'bnx2x_get_common_flags'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13599: warning: Function parameter or member 'pdev' not described in 'bnx2x_get_num_non_def_sbs'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13599: warning: Function parameter or member 'cnic_cnt' not described in 'bnx2x_get_num_non_def_sbs'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13599: warning: Excess function parameter 'dev' description in 'bnx2x_get_num_non_def_sbs'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:14462: warning: Excess function parameter 'set' description in 'bnx2x_set_iscsi_eth_mac_addr'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:213: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_sbm_link_sram_init_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:213: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_sbm_link_sram_init_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:224: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_reg_cnt_clr_ce'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:224: warning: Function parameter or member 'reg_cnt_clr_ce' not described in 'hns_dsaf_reg_cnt_clr_ce'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:224: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_reg_cnt_clr_ce'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:224: warning: Excess function parameter 'hns_dsaf_reg_cnt_clr_ce' description in 'hns_dsaf_reg_cnt_clr_ce'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:236: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_ppe_qid_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:236: warning: Function parameter or member 'qid_cfg' not described in 'hns_dsaf_ppe_qid_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:236: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_ppe_qid_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:236: warning: Excess function parameter 'pppe_qid_cfg' description in 'hns_dsaf_ppe_qid_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:293: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_sw_port_type_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:293: warning: Function parameter or member 'port_type' not described in 'hns_dsaf_sw_port_type_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:293: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_sw_port_type_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:293: warning: Excess function parameter 'psw_port_type' description in 'hns_dsaf_sw_port_type_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:311: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_stp_port_type_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:311: warning: Function parameter or member 'port_type' not described in 'hns_dsaf_stp_port_type_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:311: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_stp_port_type_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:311: warning: Excess function parameter 'pstp_port_type' description in 'hns_dsaf_stp_port_type_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:329: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_sbm_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:329: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_sbm_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:348: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_sbm_cfg_mib_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:348: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_sbm_cfg_mib_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:393: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_sbm_bp_wl_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:393: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_sbm_bp_wl_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:562: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_voq_bp_all_thrd_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:562: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_voq_bp_all_thrd_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:608: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tbl_tcam_data_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:608: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tbl_tcam_data_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:623: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tbl_tcam_mcast_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:623: warning: Function parameter or member 'mcast' not described in 'hns_dsaf_tbl_tcam_mcast_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:623: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tbl_tcam_mcast_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:623: warning: Excess function parameter 'ptbl_tcam_mcast' description in 'hns_dsaf_tbl_tcam_mcast_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:657: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tbl_tcam_ucast_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:657: warning: Function parameter or member 'tbl_tcam_ucast' not described in 'hns_dsaf_tbl_tcam_ucast_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:657: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tbl_tcam_ucast_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:657: warning: Excess function parameter 'ptbl_tcam_ucast' description in 'hns_dsaf_tbl_tcam_ucast_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:682: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tbl_line_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:682: warning: Function parameter or member 'tbl_lin' not described in 'hns_dsaf_tbl_line_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:682: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tbl_line_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:682: warning: Excess function parameter 'ptbl_lin' description in 'hns_dsaf_tbl_line_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:701: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tbl_tcam_mcast_pul'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:701: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tbl_tcam_mcast_pul'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:716: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tbl_line_pul'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:716: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tbl_line_pul'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:732: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tbl_tcam_data_mcast_pul'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:732: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tbl_tcam_data_mcast_pul'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:750: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tbl_tcam_data_ucast_pul'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:750: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tbl_tcam_data_ucast_pul'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:775: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tbl_stat_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:775: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tbl_stat_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:775: warning: Excess function parameter 'ptbl_stat_en' description in 'hns_dsaf_tbl_stat_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:791: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_rocee_bp_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:791: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_rocee_bp_en'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:862: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_single_line_tbl_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:862: warning: Function parameter or member 'address' not described in 'hns_dsaf_single_line_tbl_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:862: warning: Function parameter or member 'ptbl_line' not described in 'hns_dsaf_single_line_tbl_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:862: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_single_line_tbl_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:887: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tcam_uc_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:887: warning: Function parameter or member 'address' not described in 'hns_dsaf_tcam_uc_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:887: warning: Function parameter or member 'ptbl_tcam_data' not described in 'hns_dsaf_tcam_uc_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:887: warning: Function parameter or member 'ptbl_tcam_ucast' not described in 'hns_dsaf_tcam_uc_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:887: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tcam_uc_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:914: warning: Function parameter or member 'ptbl_tcam_mask' not described in 'hns_dsaf_tcam_mc_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:944: warning: Function parameter or member 'address' not described in 'hns_dsaf_tcam_uc_cfg_vague'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:944: warning: Function parameter or member 'tcam_data' not described in 'hns_dsaf_tcam_uc_cfg_vague'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:944: warning: Function parameter or member 'tcam_mask' not described in 'hns_dsaf_tcam_uc_cfg_vague'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:944: warning: Function parameter or member 'tcam_uc' not described in 'hns_dsaf_tcam_uc_cfg_vague'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:973: warning: Function parameter or member 'address' not described in 'hns_dsaf_tcam_mc_cfg_vague'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:973: warning: Function parameter or member 'tcam_data' not described in 'hns_dsaf_tcam_mc_cfg_vague'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:973: warning: Function parameter or member 'tcam_mask' not described in 'hns_dsaf_tcam_mc_cfg_vague'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:973: warning: Function parameter or member 'tcam_mc' not described in 'hns_dsaf_tcam_mc_cfg_vague'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:995: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tcam_mc_invld'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:995: warning: Function parameter or member 'address' not described in 'hns_dsaf_tcam_mc_invld'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:995: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tcam_mc_invld'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1036: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tcam_uc_get'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1036: warning: Function parameter or member 'address' not described in 'hns_dsaf_tcam_uc_get'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1036: warning: Function parameter or member 'ptbl_tcam_data' not described in 'hns_dsaf_tcam_uc_get'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1036: warning: Function parameter or member 'ptbl_tcam_ucast' not described in 'hns_dsaf_tcam_uc_get'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1036: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tcam_uc_get'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1089: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tcam_mc_get'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1089: warning: Function parameter or member 'address' not described in 'hns_dsaf_tcam_mc_get'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1089: warning: Function parameter or member 'ptbl_tcam_data' not described in 'hns_dsaf_tcam_mc_get'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1089: warning: Function parameter or member 'ptbl_tcam_mcast' not described in 'hns_dsaf_tcam_mc_get'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1089: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tcam_mc_get'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1133: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tbl_line_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1133: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tbl_line_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1147: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tbl_tcam_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1147: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tbl_tcam_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1163: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_pfc_en_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1163: warning: Function parameter or member 'mac_id' not described in 'hns_dsaf_pfc_en_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1163: warning: Function parameter or member 'tc_en' not described in 'hns_dsaf_pfc_en_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1163: warning: Excess function parameter 'mac_cb' description in 'hns_dsaf_pfc_en_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1216: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_comm_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1216: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_comm_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1269: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_inode_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1269: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_inode_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1321: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_sbm_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1321: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_sbm_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1375: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_tbl_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1375: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_tbl_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1387: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_voq_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1387: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_voq_init'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2105: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_free_dev'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2105: warning: Excess function parameter 'dev' description in 'hns_dsaf_free_dev'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2117: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_pfc_unit_cnt'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2117: warning: Function parameter or member 'mac_id' not described in 'hns_dsaf_pfc_unit_cnt'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2117: warning: Function parameter or member 'rate' not described in 'hns_dsaf_pfc_unit_cnt'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2117: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_pfc_unit_cnt'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2117: warning: Excess function parameter 'pport_rate' description in 'hns_dsaf_pfc_unit_cnt'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2117: warning: Excess function parameter 'pdsaf_pfc_unit_cnt' description in 'hns_dsaf_pfc_unit_cnt'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2148: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_port_work_rate_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2148: warning: Function parameter or member 'mac_id' not described in 'hns_dsaf_port_work_rate_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2148: warning: Function parameter or member 'rate_mode' not described in 'hns_dsaf_port_work_rate_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2148: warning: Excess function parameter 'dsaf_id' description in 'hns_dsaf_port_work_rate_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2260: warning: Function parameter or member 'ddev' not described in 'hns_dsaf_get_regs'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2260: warning: Function parameter or member 'port' not described in 'hns_dsaf_get_regs'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2260: warning: Excess function parameter 'dsaf_dev' description in 'hns_dsaf_get_regs'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2697: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_get_sset_count'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2717: warning: Function parameter or member 'dsaf_dev' not described in 'hns_dsaf_get_strings'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:3045: warning: Function parameter or member 'dereset' not described in 'hns_dsaf_roce_reset'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:3045: warning: Excess function parameter 'enable' description in 'hns_dsaf_roce_reset'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:73: warning: Function parameter or member 'comm_index' not described in 'hns_ppe_common_get_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:150: warning: Function parameter or member 'ppe_cb' not described in 'hns_ppe_checksum_hw'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:150: warning: Excess function parameter 'ppe_device' description in 'hns_ppe_checksum_hw'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:187: warning: Function parameter or member 'ppe_cb' not described in 'hns_ppe_set_port_mode'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:187: warning: Excess function parameter 'ppe_device' description in 'hns_ppe_set_port_mode'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:350: warning: Function parameter or member 'ppe_cb' not described in 'hns_ppe_uninit_hw'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:350: warning: Excess function parameter 'ppe_device' description in 'hns_ppe_uninit_hw'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:390: warning: Function parameter or member 'ppe_common_index' not described in 'hns_ppe_reset_common'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:463: warning: Function parameter or member 'ppe_cb' not described in 'hns_ppe_get_strings'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:463: warning: Excess function parameter 'ppe_device' description in 'hns_ppe_get_strings'
drivers/net/ethernet/natsemi/ns83820.c:603:6: warning: variable ‘tbisr’ set but not used [-Wunused-but-set-variable]
drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c:41: warning: Function parameter or member 'q_num' not described in 'hns_rcb_wait_fbd_clean'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c:41: warning: Excess function parameter 'qnum' description in 'hns_rcb_wait_fbd_clean'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c:197: warning: Function parameter or member 'q' not described in 'hns_rcb_ring_enable_hw'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c:197: warning: Function parameter or member 'val' not described in 'hns_rcb_ring_enable_hw'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c:197: warning: Excess function parameter 'ring' description in 'hns_rcb_ring_enable_hw'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c:851: warning: Function parameter or member 'queue' not described in 'hns_rcb_get_stats'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c:851: warning: Excess function parameter 'ring' description in 'hns_rcb_get_stats'
drivers/net/ethernet/neterion/vxge/vxge-ethtool.c:129: warning: Function parameter or member 'space' not described in 'vxge_ethtool_gregs'
drivers/net/ethernet/neterion/vxge/vxge-ethtool.c:129: warning: Excess function parameter 'reg_space' description in 'vxge_ethtool_gregs'
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c:21: warning: cannot understand function prototype: 'int TxDescriptors = OPTION_UNSET; '
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c:30: warning: cannot understand function prototype: 'int RxDescriptors = OPTION_UNSET; '
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c:43: warning: cannot understand function prototype: 'int Speed = OPTION_UNSET; '
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c:55: warning: cannot understand function prototype: 'int Duplex = OPTION_UNSET; '
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c:76: warning: cannot understand function prototype: 'int AutoNeg = OPTION_UNSET; '
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c:97: warning: cannot understand function prototype: 'int FlowControl = OPTION_UNSET; '
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c:134: warning: cannot understand function prototype: 'struct pch_gbe_option '
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c:14: warning: cannot understand function prototype: 'struct pch_gbe_stats '
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c:30: warning: cannot understand function prototype: 'const struct pch_gbe_stats pch_gbe_gstrings_stats[] = '
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:289: warning: Function parameter or member 'channel' not described in 'vxge_hw_channel_msix_mask'
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:289: warning: Excess function parameter 'channeh' description in 'vxge_hw_channel_msix_mask'
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:307: warning: Function parameter or member 'channel' not described in 'vxge_hw_channel_msix_unmask'
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:307: warning: Excess function parameter 'channeh' description in 'vxge_hw_channel_msix_unmask'
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:362: warning: Excess function parameter 'op' description in 'vxge_hw_device_intr_enable'
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:416: warning: Excess function parameter 'op' description in 'vxge_hw_device_intr_disable'
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:1430: warning: Function parameter or member 'fifo' not described in 'vxge_hw_fifo_txdl_reserve'
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:1430: warning: Excess function parameter 'fifoh' description in 'vxge_hw_fifo_txdl_reserve'
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:1529: warning: Excess function parameter 'frags' description in 'vxge_hw_fifo_txdl_post'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c:248: warning: Function parameter or member 'rx_en' not described in 'hns_xgmac_pausefrm_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c:248: warning: Function parameter or member 'tx_en' not described in 'hns_xgmac_pausefrm_cfg'
drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c:248: warning: Excess function parameter 'newval' description in 'hns_xgmac_pausefrm_cfg'
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:2420: warning: Function parameter or member 'skb_ptr' not described in 'vxge_hw_vpath_poll_tx'
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:2420: warning: Function parameter or member 'nr_skb' not described in 'vxge_hw_vpath_poll_tx'
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:2420: warning: Function parameter or member 'more' not described in 'vxge_hw_vpath_poll_tx'
drivers/net/ethernet/neterion/vxge/vxge-config.c:998: warning: Function parameter or member 'bar0' not described in 'vxge_hw_device_hw_info_get'
drivers/net/ethernet/neterion/vxge/vxge-config.c:998: warning: Function parameter or member 'hw_info' not described in 'vxge_hw_device_hw_info_get'
drivers/net/ethernet/neterion/vxge/vxge-config.c:3938: warning: Function parameter or member 'ring' not described in 'vxge_hw_vpath_check_leak'
drivers/net/ethernet/neterion/vxge/vxge-config.c:3938: warning: Excess function parameter 'ringh' description in 'vxge_hw_vpath_check_leak'
drivers/net/ethernet/packetengines/yellowfin.c:1063:18: warning: variable ‘yf_size’ set but not used [-Wunused-but-set-variable]
drivers/net/ethernet/hisilicon/hns_mdio.c:219: warning: Function parameter or member 'data' not described in 'hns_mdio_write'
drivers/net/ethernet/hisilicon/hns_mdio.c:219: warning: Excess function parameter 'value' description in 'hns_mdio_write'
drivers/net/ethernet/hisilicon/hns_mdio.c:281: warning: Excess function parameter 'value' description in 'hns_mdio_read'
drivers/net/ethernet/qualcomm/emac/emac.c:302: warning: Function parameter or member 'adpt' not described in 'emac_update_hw_stats'
drivers/net/ethernet/hisilicon/hns/hns_enet.c:757: warning: Function parameter or member 'new_param' not described in 'smooth_alg'
drivers/net/ethernet/hisilicon/hns/hns_enet.c:757: warning: Function parameter or member 'old_param' not described in 'smooth_alg'
drivers/net/ethernet/neterion/vxge/vxge-main.c:1282: warning: Function parameter or member 'p' not described in 'vxge_set_mac_addr'
drivers/net/ethernet/neterion/vxge/vxge-main.c:1813: warning: Function parameter or member 'napi' not described in 'vxge_poll_msix'
drivers/net/ethernet/neterion/vxge/vxge-main.c:1813: warning: Excess function parameter 'dev' description in 'vxge_poll_msix'
drivers/net/ethernet/neterion/vxge/vxge-main.c:3104: warning: Function parameter or member 'net_stats' not described in 'vxge_get_stats64'
drivers/net/ethernet/neterion/vxge/vxge-main.c:3104: warning: Excess function parameter 'stats' description in 'vxge_get_stats64'
drivers/net/ethernet/neterion/vxge/vxge-main.c:3256: warning: Function parameter or member 'rq' not described in 'vxge_ioctl'
drivers/net/ethernet/neterion/vxge/vxge-main.c:3256: warning: Excess function parameter 'ifr' description in 'vxge_ioctl'
drivers/net/ethernet/neterion/vxge/vxge-main.c:3278: warning: Function parameter or member 'txqueue' not described in 'vxge_tx_watchdog'
drivers/net/ethernet/neterion/vxge/vxge-main.c:4008: warning: Function parameter or member 'dev_d' not described in 'vxge_pm_suspend'
drivers/net/ethernet/neterion/vxge/vxge-main.c:4016: warning: Function parameter or member 'dev_d' not described in 'vxge_pm_resume'
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:301: warning: Function parameter or member 'bit' not described in 'pch_gbe_wait_clr_bit'
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:301: warning: Excess function parameter 'busy' description in 'pch_gbe_wait_clr_bit'
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:1040: warning: Function parameter or member 't' not described in 'pch_gbe_watchdog'
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:1040: warning: Excess function parameter 'data' description in 'pch_gbe_watchdog'
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:2275: warning: Function parameter or member 'txqueue' not described in 'pch_gbe_tx_timeout'
drivers/net/ethernet/neterion/s2io.c:1008: warning: Function parameter or member 'nic' not described in 's2io_verify_pci_mode'
drivers/net/ethernet/neterion/s2io.c:1042: warning: Function parameter or member 'nic' not described in 's2io_print_pci_mode'
drivers/net/ethernet/neterion/s2io.c:2071: warning: Function parameter or member 'sp' not described in 'verify_pcc_quiescent'
drivers/net/ethernet/neterion/s2io.c:2071: warning: Function parameter or member 'flag' not described in 'verify_pcc_quiescent'
drivers/net/ethernet/neterion/s2io.c:2111: warning: Function parameter or member 'sp' not described in 'verify_xena_quiescence'
drivers/net/ethernet/neterion/s2io.c:2311: warning: Function parameter or member 'fifo_data' not described in 's2io_txdl_getskb'
drivers/net/ethernet/neterion/s2io.c:2311: warning: Function parameter or member 'txdlp' not described in 's2io_txdl_getskb'
drivers/net/ethernet/neterion/s2io.c:2311: warning: Function parameter or member 'get_off' not described in 's2io_txdl_getskb'
drivers/net/ethernet/neterion/s2io.c:2403: warning: Function parameter or member 'nic' not described in 'stop_nic'
drivers/net/ethernet/neterion/s2io.c:2444: warning: Function parameter or member 'nic' not described in 'fill_rx_buffers'
drivers/net/ethernet/neterion/s2io.c:2444: warning: Function parameter or member 'ring' not described in 'fill_rx_buffers'
drivers/net/ethernet/neterion/s2io.c:2444: warning: Excess function parameter 'ring_info' description in 'fill_rx_buffers'
drivers/net/ethernet/neterion/s2io.c:2879: warning: Function parameter or member 'ring_data' not described in 'rx_intr_handler'
drivers/net/ethernet/neterion/s2io.c:2879: warning: Excess function parameter 'ring_info' description in 'rx_intr_handler'
drivers/net/ethernet/neterion/s2io.c:2986: warning: Function parameter or member 'fifo_data' not described in 'tx_intr_handler'
drivers/net/ethernet/neterion/s2io.c:2986: warning: Excess function parameter 'nic' description in 'tx_intr_handler'
drivers/net/ethernet/neterion/s2io.c:3165: warning: Function parameter or member 'regs_stat' not described in 's2io_chk_xpak_counter'
drivers/net/ethernet/neterion/s2io.c:3165: warning: Function parameter or member 'index' not described in 's2io_chk_xpak_counter'
drivers/net/ethernet/neterion/s2io.c:3323: warning: Function parameter or member 'addr' not described in 'wait_for_cmd_complete'
drivers/net/ethernet/neterion/s2io.c:3323: warning: Function parameter or member 'busy_bit' not described in 'wait_for_cmd_complete'
drivers/net/ethernet/neterion/s2io.c:3323: warning: Function parameter or member 'bit_state' not described in 'wait_for_cmd_complete'
drivers/net/ethernet/neterion/s2io.c:3323: warning: Excess function parameter 'sp' description in 'wait_for_cmd_complete'
drivers/net/ethernet/neterion/s2io.c:4345: warning: Function parameter or member 'dev_id' not described in 's2io_handle_errors'
drivers/net/ethernet/neterion/s2io.c:4345: warning: Excess function parameter 'nic' description in 's2io_handle_errors'
drivers/net/ethernet/neterion/s2io.c:4746: warning: Function parameter or member 'sp' not described in 's2io_updt_stats'
drivers/net/ethernet/neterion/s2io.c:5176: warning: Function parameter or member 'dev' not described in 's2io_set_mac_addr'
drivers/net/ethernet/neterion/s2io.c:5176: warning: Function parameter or member 'p' not described in 's2io_set_mac_addr'
drivers/net/ethernet/neterion/s2io.c:5260: warning: Function parameter or member 'dev' not described in 's2io_ethtool_set_link_ksettings'
drivers/net/ethernet/neterion/s2io.c:5260: warning: Excess function parameter 'sp' description in 's2io_ethtool_set_link_ksettings'
drivers/net/ethernet/neterion/s2io.c:5289: warning: Function parameter or member 'dev' not described in 's2io_ethtool_get_link_ksettings'
drivers/net/ethernet/neterion/s2io.c:5289: warning: Excess function parameter 'sp' description in 's2io_ethtool_get_link_ksettings'
drivers/net/ethernet/neterion/s2io.c:5328: warning: Function parameter or member 'dev' not described in 's2io_ethtool_gdrvinfo'
drivers/net/ethernet/neterion/s2io.c:5328: warning: Excess function parameter 'sp' description in 's2io_ethtool_gdrvinfo'
drivers/net/ethernet/neterion/s2io.c:5352: warning: Function parameter or member 'dev' not described in 's2io_ethtool_gregs'
drivers/net/ethernet/neterion/s2io.c:5352: warning: Function parameter or member 'space' not described in 's2io_ethtool_gregs'
drivers/net/ethernet/neterion/s2io.c:5352: warning: Excess function parameter 'sp' description in 's2io_ethtool_gregs'
drivers/net/ethernet/neterion/s2io.c:5352: warning: Excess function parameter 'reg_space' description in 's2io_ethtool_gregs'
drivers/net/ethernet/neterion/s2io.c:5484: warning: Function parameter or member 'dev' not described in 's2io_ethtool_getpause_data'
drivers/net/ethernet/neterion/s2io.c:5484: warning: Excess function parameter 'sp' description in 's2io_ethtool_getpause_data'
drivers/net/ethernet/neterion/s2io.c:5511: warning: Function parameter or member 'dev' not described in 's2io_ethtool_setpause_data'
drivers/net/ethernet/neterion/s2io.c:5511: warning: Excess function parameter 'sp' description in 's2io_ethtool_setpause_data'
drivers/net/ethernet/neterion/s2io.c:5545: warning: Excess function parameter 'sp' description in 'S2IO_DEV_ID'
drivers/net/ethernet/neterion/s2io.c:5545: warning: Excess function parameter 'off' description in 'S2IO_DEV_ID'
drivers/net/ethernet/neterion/s2io.c:5545: warning: Excess function parameter 'data' description in 'S2IO_DEV_ID'
drivers/net/ethernet/neterion/s2io.c:5751: warning: Function parameter or member 'dev' not described in 's2io_ethtool_geeprom'
drivers/net/ethernet/neterion/s2io.c:5751: warning: Excess function parameter 'sp' description in 's2io_ethtool_geeprom'
drivers/net/ethernet/neterion/s2io.c:5789: warning: Function parameter or member 'dev' not described in 's2io_ethtool_seeprom'
drivers/net/ethernet/neterion/s2io.c:5789: warning: Function parameter or member 'data_buf' not described in 's2io_ethtool_seeprom'
drivers/net/ethernet/neterion/s2io.c:5789: warning: Excess function parameter 'sp' description in 's2io_ethtool_seeprom'
drivers/net/ethernet/neterion/s2io.c:6042: warning: Function parameter or member 'sp' not described in 's2io_link_test'
drivers/net/ethernet/neterion/s2io.c:6169: warning: Function parameter or member 'dev' not described in 's2io_ethtool_test'
drivers/net/ethernet/neterion/s2io.c:6169: warning: Excess function parameter 'sp' description in 's2io_ethtool_test'
drivers/net/ethernet/neterion/s2io.c:6610: warning: Function parameter or member 'rq' not described in 's2io_ioctl'
drivers/net/ethernet/neterion/s2io.c:6610: warning: Excess function parameter 'ifr' description in 's2io_ioctl'
drivers/net/ethernet/neterion/s2io.c:6658: warning: Function parameter or member 'work' not described in 's2io_set_link'
drivers/net/ethernet/neterion/s2io.c:6658: warning: Excess function parameter 'data' description in 's2io_set_link'
drivers/net/ethernet/neterion/s2io.c:7199: warning: Function parameter or member 'work' not described in 's2io_restart_nic'
drivers/net/ethernet/neterion/s2io.c:7199: warning: Excess function parameter 'data' description in 's2io_restart_nic'
drivers/net/ethernet/neterion/s2io.c:7232: warning: Function parameter or member 'txqueue' not described in 's2io_tx_watchdog'
drivers/net/ethernet/neterion/s2io.c:7261: warning: Function parameter or member 'ring_data' not described in 'rx_osm_handler'
drivers/net/ethernet/neterion/s2io.c:7261: warning: Function parameter or member 'rxdp' not described in 'rx_osm_handler'
drivers/net/ethernet/neterion/s2io.c:7261: warning: Excess function parameter 'sp' description in 'rx_osm_handler'
drivers/net/ethernet/neterion/s2io.c:7261: warning: Excess function parameter 'skb' description in 'rx_osm_handler'
drivers/net/ethernet/neterion/s2io.c:7261: warning: Excess function parameter 'len' description in 'rx_osm_handler'
drivers/net/ethernet/neterion/s2io.c:7261: warning: Excess function parameter 'cksum' description in 'rx_osm_handler'
drivers/net/ethernet/neterion/s2io.c:7261: warning: Excess function parameter 'ring_no' description in 'rx_osm_handler'
drivers/net/ethernet/neterion/s2io.c:7588: warning: Function parameter or member 'ds_codepoint' not described in 'rts_ds_steer'
drivers/net/ethernet/neterion/s2io.c:7588: warning: Function parameter or member 'ring' not described in 'rts_ds_steer'
drivers/net/ethernet/qlogic/netxen/netxen_nic.h:1193:18: warning: ‘FW_DUMP_LEVELS’ defined but not used [-Wunused-const-variable=]
drivers/net/ethernet/qlogic/netxen/netxen_nic.h:1193:18: warning: ‘FW_DUMP_LEVELS’ defined but not used [-Wunused-const-variable=]
drivers/net/ethernet/qlogic/netxen/netxen_nic.h:1193:18: warning: ‘FW_DUMP_LEVELS’ defined but not used [-Wunused-const-variable=]
drivers/net/ethernet/qlogic/netxen/netxen_nic.h:1193:18: warning: ‘FW_DUMP_LEVELS’ defined but not used [-Wunused-const-variable=]
drivers/net/ethernet/sfc/falcon/selftest.c:77: warning: cannot understand function prototype: 'struct ef4_loopback_state '
drivers/net/ethernet/sis/sis900.c:1311: warning: Function parameter or member 't' not described in 'sis900_timer'
drivers/net/ethernet/sis/sis900.c:1311: warning: Excess function parameter 'data' description in 'sis900_timer'
drivers/net/ethernet/sis/sis900.c:1544: warning: Function parameter or member 'txqueue' not described in 'sis900_tx_timeout'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:106: warning: Function parameter or member 't' not described in 'sxgbe_eee_ctrl_timer'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:106: warning: Excess function parameter 'arg' description in 'sxgbe_eee_ctrl_timer'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:265: warning: Function parameter or member 'ndev' not described in 'sxgbe_init_phy'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:265: warning: Excess function parameter 'dev' description in 'sxgbe_init_phy'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:375: warning: Function parameter or member 'p' not described in 'sxgbe_free_rx_buffers'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:375: warning: Function parameter or member 'i' not described in 'sxgbe_free_rx_buffers'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:375: warning: Function parameter or member 'dma_buf_sz' not described in 'sxgbe_free_rx_buffers'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:375: warning: Excess function parameter 'rx_rsize' description in 'sxgbe_free_rx_buffers'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:392: warning: Function parameter or member 'queue_no' not described in 'init_tx_ring'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:458: warning: Function parameter or member 'queue_no' not described in 'init_rx_ring'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:557: warning: Function parameter or member 'netd' not described in 'init_dma_desc_rings'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:557: warning: Excess function parameter 'dev' description in 'init_dma_desc_rings'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:731: warning: Function parameter or member 'tqueue' not described in 'sxgbe_tx_queue_clean'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:731: warning: Excess function parameter 'priv' description in 'sxgbe_tx_queue_clean'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:814: warning: Function parameter or member 'queue_num' not described in 'sxgbe_restart_tx_queue'
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c:1576: warning: Function parameter or member 'txqueue' not described in 'sxgbe_tx_timeout'
drivers/net/ethernet/via/via-rhine.c:1523: warning: Function parameter or member 'dev' not described in 'rhine_update_vcam'
drivers/net/ethernet/via/via-rhine.c:1523: warning: Excess function parameter 'rp' description in 'rhine_update_vcam'
drivers/net/ethernet/sfc/falcon/rx.c:150: warning: Function parameter or member 'atomic' not described in 'ef4_init_rx_buffers'
drivers/net/ethernet/sfc/falcon/rx.c:325: warning: Function parameter or member 'atomic' not described in 'ef4_fast_push_rx_descriptors'
drivers/net/ethernet/ti/davinci_cpdma.c:726: warning: Function parameter or member 'ctlr' not described in 'cpdma_chan_split_pool'
drivers/net/ethernet/tehuti/tehuti.c:152: warning: Function parameter or member 'reg_CFG0' not described in 'bdx_fifo_init'
drivers/net/ethernet/tehuti/tehuti.c:152: warning: Function parameter or member 'reg_CFG1' not described in 'bdx_fifo_init'
drivers/net/ethernet/tehuti/tehuti.c:152: warning: Function parameter or member 'reg_RPTR' not described in 'bdx_fifo_init'
drivers/net/ethernet/tehuti/tehuti.c:152: warning: Function parameter or member 'reg_WPTR' not described in 'bdx_fifo_init'
drivers/net/ethernet/tehuti/tehuti.c:152: warning: Excess function parameter 'reg_XXX' description in 'bdx_fifo_init'
drivers/net/ethernet/tehuti/tehuti.c:571: warning: Function parameter or member 'ndev' not described in 'bdx_close'
drivers/net/ethernet/tehuti/tehuti.c:571: warning: Excess function parameter 'netdev' description in 'bdx_close'
drivers/net/ethernet/tehuti/tehuti.c:599: warning: Function parameter or member 'ndev' not described in 'bdx_open'
drivers/net/ethernet/tehuti/tehuti.c:599: warning: Excess function parameter 'netdev' description in 'bdx_open'
drivers/net/ethernet/tehuti/tehuti.c:706: warning: Function parameter or member 'enable' not described in '__bdx_vlan_rx_vid'
drivers/net/ethernet/tehuti/tehuti.c:706: warning: Excess function parameter 'op' description in '__bdx_vlan_rx_vid'
drivers/net/ethernet/tehuti/tehuti.c:735: warning: Function parameter or member 'proto' not described in 'bdx_vlan_rx_add_vid'
drivers/net/ethernet/tehuti/tehuti.c:746: warning: Function parameter or member 'proto' not described in 'bdx_vlan_rx_kill_vid'
drivers/net/ethernet/tehuti/tehuti.c:759: warning: Function parameter or member 'ndev' not described in 'bdx_change_mtu'
drivers/net/ethernet/tehuti/tehuti.c:759: warning: Excess function parameter 'netdev' description in 'bdx_change_mtu'
drivers/net/ethernet/tehuti/tehuti.c:1759: warning: Function parameter or member 'priv' not described in 'bdx_tx_free_skbs'
drivers/net/ethernet/ti/davinci_emac.c:680: warning: Function parameter or member 'mac_addr' not described in 'emac_add_mcast'
drivers/net/ethernet/ti/davinci_emac.c:988: warning: Function parameter or member 'txqueue' not described in 'emac_dev_tx_timeout'
drivers/net/ethernet/ti/davinci_emac.c:1224: warning: Function parameter or member 'napi' not described in 'emac_poll'
drivers/net/ethernet/ti/davinci_emac.c:1224: warning: Excess function parameter 'ndev' description in 'emac_poll'
drivers/net/ethernet/sun/cassini.c:2084:24: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
drivers/net/ethernet/via/via-velocity.c:379: warning: cannot understand function prototype: 'const struct of_device_id velocity_of_ids[] = '
drivers/net/ethernet/via/via-velocity.c:393: warning: Function parameter or member 'chip_id' not described in 'get_chip_name'
drivers/net/ethernet/via/via-velocity.c:393: warning: Excess function parameter 'id' description in 'get_chip_name'
drivers/net/ethernet/via/via-velocity.c:758: warning: Function parameter or member 'mii_addr' not described in 'velocity_mii_write'
drivers/net/ethernet/via/via-velocity.c:758: warning: Excess function parameter 'index' description in 'velocity_mii_write'
drivers/net/ethernet/via/via-velocity.c:879: warning: Function parameter or member 'vptr' not described in 'velocity_set_media_mode'
drivers/net/ethernet/via/via-velocity.c:1264: warning: Function parameter or member 'vptr' not described in 'setup_queue_timers'
drivers/net/ethernet/via/via-velocity.c:1290: warning: Function parameter or member 'vptr' not described in 'setup_adaptive_interrupts'
drivers/net/ethernet/via/via-velocity.c:1731: warning: Function parameter or member 'td' not described in 'velocity_free_tx_buf'
drivers/net/ethernet/via/via-velocity.c:1906: warning: Function parameter or member 'vptr' not described in 'velocity_tx_srv'
drivers/net/ethernet/via/via-velocity.c:2003: warning: Function parameter or member 'vptr' not described in 'velocity_rx_copy'
drivers/net/ethernet/via/via-velocity.c:2003: warning: Excess function parameter 'rd' description in 'velocity_rx_copy'
drivers/net/ethernet/via/via-velocity.c:2003: warning: Excess function parameter 'dev' description in 'velocity_rx_copy'
drivers/net/ethernet/via/via-velocity.c:2106: warning: Function parameter or member 'budget_left' not described in 'velocity_rx_srv'
drivers/net/ethernet/via/via-velocity.c:2657: warning: Excess function parameter 'pdev' description in 'velocity_init_info'
drivers/net/ethernet/via/via-velocity.c:2673: warning: Excess function parameter 'pdev' description in 'velocity_get_pci_info'
drivers/net/ethernet/via/via-velocity.c:2709: warning: Excess function parameter 'pdev' description in 'velocity_get_platform_info'
drivers/net/ethernet/via/via-velocity.c:2764: warning: Function parameter or member 'dev' not described in 'velocity_probe'
drivers/net/ethernet/via/via-velocity.c:2764: warning: Function parameter or member 'irq' not described in 'velocity_probe'
drivers/net/ethernet/via/via-velocity.c:2764: warning: Function parameter or member 'info' not described in 'velocity_probe'
drivers/net/ethernet/via/via-velocity.c:2764: warning: Excess function parameter 'pdev' description in 'velocity_probe'
drivers/net/ethernet/via/via-velocity.c:2764: warning: Excess function parameter 'ent' description in 'velocity_probe'
drivers/net/ethernet/via/via-velocity.c:2979: warning: Function parameter or member 'size' not described in 'wol_calc_crc'
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:343: warning: Function parameter or member 't' not described in 'stmmac_eee_ctrl_timer'
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:343: warning: Excess function parameter 'arg' description in 'stmmac_eee_ctrl_timer'
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:712: warning: bad line:     as requested.
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:775: warning: Function parameter or member 'duplex' not described in 'stmmac_mac_flow_ctrl'
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:1949: warning: Function parameter or member 'budget' not described in 'stmmac_tx_clean'
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2343: warning: Function parameter or member 't' not described in 'stmmac_tx_timer'
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2343: warning: Excess function parameter 'data' description in 'stmmac_tx_timer'
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2611: warning: Function parameter or member 'init_ptp' not described in 'stmmac_hw_setup'
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2969: warning: Function parameter or member 'last_segment' not described in 'stmmac_tso_allocator'
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2969: warning: Excess function parameter 'last_segmant' description in 'stmmac_tso_allocator'
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3936: warning: Function parameter or member 'txqueue' not described in 'stmmac_tx_timeout'
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:5168: warning: Function parameter or member 'priv' not described in 'stmmac_reset_queues_param'
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:5168: warning: Excess function parameter 'dev' description in 'stmmac_reset_queues_param'
drivers/net/ethernet/calxeda/xgmac.c:1255: warning: Function parameter or member 'txqueue' not described in 'xgmac_tx_timeout'
drivers/net/ethernet/sfc/ptp.c:186: warning: Function parameter or member 'link' not described in 'efx_ptp_event_rx'
drivers/net/ethernet/sfc/ptp.c:186: warning: Function parameter or member 'expiry' not described in 'efx_ptp_event_rx'
drivers/net/ethernet/sfc/ptp.c:343: warning: Function parameter or member 'rxfilter_installed' not described in 'efx_ptp_data'
drivers/net/ethernet/sfc/ptp.c:343: warning: Function parameter or member 'nic_time' not described in 'efx_ptp_data'
drivers/net/ethernet/sfc/ptp.c:343: warning: Function parameter or member 'ts_corrections' not described in 'efx_ptp_data'
drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c:28: warning: cannot understand function prototype: 'struct rk_priv_data; '
drivers/net/ethernet/ethoc.c:221: warning: Function parameter or member 'big_endian' not described in 'ethoc'
drivers/net/ethernet/ethoc.c:221: warning: Function parameter or member 'clk' not described in 'ethoc'
drivers/net/ethernet/ethoc.c:221: warning: Function parameter or member 'old_link' not described in 'ethoc'
drivers/net/ethernet/ethoc.c:221: warning: Function parameter or member 'old_duplex' not described in 'ethoc'
drivers/net/ethernet/ethoc.c:1021: warning: Function parameter or member 'pdev' not described in 'ethoc_probe'
drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:131: warning: Function parameter or member 'plat' not described in 'stmmac_mtl_setup'
drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:371: warning: Function parameter or member 'np' not described in 'stmmac_of_get_mac_mode'
---
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |   6 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |   7 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |   2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |   6 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |   2 +
 .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |   6 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  12 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  98 ++---
 drivers/net/ethernet/brocade/bna/bfa_cee.c    |  20 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.c    |   8 +-
 drivers/net/ethernet/cadence/macb_main.c      |   6 +-
 drivers/net/ethernet/calxeda/xgmac.c          |   2 +
 .../net/ethernet/cavium/liquidio/lio_core.c   |  92 ++---
 .../net/ethernet/cavium/liquidio/lio_main.c   | 351 +++++++++---------
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 158 ++++----
 .../ethernet/cavium/liquidio/octeon_console.c |  12 +-
 .../ethernet/cavium/liquidio/octeon_device.c  |   4 +-
 .../ethernet/cavium/liquidio/octeon_droq.c    |   2 +-
 .../ethernet/cavium/liquidio/octeon_mailbox.c |   5 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |   8 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  24 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c    |   5 +-
 drivers/net/ethernet/cisco/enic/enic_api.c    |   2 +-
 .../net/ethernet/cisco/enic/enic_ethtool.c    |   2 +-
 drivers/net/ethernet/cortina/gemini.c         |   2 +
 drivers/net/ethernet/ethoc.c                  |   6 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   2 +-
 drivers/net/ethernet/freescale/fec_ptp.c      |   5 +-
 drivers/net/ethernet/freescale/fman/fman.c    |  14 +-
 .../net/ethernet/freescale/fman/fman_muram.c  |   6 +-
 .../net/ethernet/freescale/fman/fman_port.c   |  23 +-
 drivers/net/ethernet/freescale/fman/mac.c     |   4 +-
 drivers/net/ethernet/hisilicon/hns/hnae.c     |   2 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_mac.c |  34 +-
 .../ethernet/hisilicon/hns/hns_dsaf_main.c    | 148 ++++----
 .../ethernet/hisilicon/hns/hns_dsaf_misc.c    |   9 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_ppe.c |  17 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_rcb.c |   7 +-
 .../ethernet/hisilicon/hns/hns_dsaf_xgmac.c   |   3 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |   4 +-
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  |   8 +-
 drivers/net/ethernet/hisilicon/hns_mdio.c     |   3 +-
 drivers/net/ethernet/micrel/ksz884x.c         |  46 ++-
 .../ethernet/microchip/encx24j600-regmap.c    |   2 +-
 drivers/net/ethernet/natsemi/ns83820.c        |   4 +-
 drivers/net/ethernet/neterion/s2io.c          |  91 ++---
 .../net/ethernet/neterion/vxge/vxge-config.c  |   5 +-
 .../net/ethernet/neterion/vxge/vxge-ethtool.c |   2 +-
 .../net/ethernet/neterion/vxge/vxge-main.c    |  10 +-
 .../net/ethernet/neterion/vxge/vxge-traffic.c |  40 +-
 .../oki-semi/pch_gbe/pch_gbe_ethtool.c        |   4 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |   5 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_param.c |  14 +-
 .../net/ethernet/packetengines/yellowfin.c    |   2 +-
 .../net/ethernet/qlogic/netxen/netxen_nic.h   |   3 -
 .../qlogic/netxen/netxen_nic_ethtool.c        |   3 +
 drivers/net/ethernet/qualcomm/emac/emac.c     |   1 +
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  17 +-
 drivers/net/ethernet/sfc/falcon/rx.c          |   2 +
 drivers/net/ethernet/sfc/falcon/selftest.c    |   2 +-
 drivers/net/ethernet/sfc/net_driver.h         |   2 +-
 drivers/net/ethernet/sfc/ptp.c                |   5 +
 drivers/net/ethernet/sis/sis900.c             |   3 +-
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  14 +-
 .../ethernet/stmicro/stmmac/stmmac_platform.c |   3 +-
 drivers/net/ethernet/sun/cassini.c            |   4 +-
 drivers/net/ethernet/tehuti/tehuti.c          |  17 +-
 drivers/net/ethernet/ti/davinci_cpdma.c       |   2 +-
 drivers/net/ethernet/ti/davinci_emac.c        |   5 +-
 drivers/net/ethernet/via/via-rhine.c          |   2 +-
 drivers/net/ethernet/via/via-velocity.c       |  27 +-
 72 files changed, 794 insertions(+), 682 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index c7288e1fa3a2..00de463268a8 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -204,7 +204,7 @@ static u32 atl1c_wait_until_idle(struct atl1c_hw *hw, u32 modu_ctrl)
 
 /**
  * atl1c_phy_config - Timer Call-back
- * @data: pointer to netdev cast into an unsigned long
+ * @t: timer list containing pointer to netdev cast into an unsigned long
  */
 static void atl1c_phy_config(struct timer_list *t)
 {
@@ -346,6 +346,7 @@ static void atl1c_del_timer(struct atl1c_adapter *adapter)
 /**
  * atl1c_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: index of hanging tx queue
  */
 static void atl1c_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
@@ -846,6 +847,7 @@ static inline void atl1c_clean_buffer(struct pci_dev *pdev,
 /**
  * atl1c_clean_tx_ring - Free Tx-skb
  * @adapter: board private structure
+ * @type: type of transmit queue
  */
 static void atl1c_clean_tx_ring(struct atl1c_adapter *adapter,
 				enum atl1c_trans_queue type)
@@ -1861,6 +1863,8 @@ static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
 
 /**
  * atl1c_clean - NAPI Rx polling callback
+ * @napi: napi info
+ * @budget: limit of packets to clean
  */
 static int atl1c_clean(struct napi_struct *napi, int budget)
 {
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index fb78f6c31708..e43f71849daf 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -111,7 +111,7 @@ static inline void atl1e_irq_reset(struct atl1e_adapter *adapter)
 
 /**
  * atl1e_phy_config - Timer Call-back
- * @data: pointer to netdev cast into an unsigned long
+ * @t: timer list containing pointer to netdev cast into an unsigned long
  */
 static void atl1e_phy_config(struct timer_list *t)
 {
@@ -196,7 +196,7 @@ static int atl1e_check_link(struct atl1e_adapter *adapter)
 
 /**
  * atl1e_link_chg_task - deal with link change event Out of interrupt context
- * @netdev: network interface device structure
+ * @work: work struct with driver info
  */
 static void atl1e_link_chg_task(struct work_struct *work)
 {
@@ -246,6 +246,7 @@ static void atl1e_cancel_work(struct atl1e_adapter *adapter)
 /**
  * atl1e_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: the index of the hanging queue
  */
 static void atl1e_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
@@ -1502,6 +1503,8 @@ static void atl1e_clean_rx_irq(struct atl1e_adapter *adapter, u8 que,
 
 /**
  * atl1e_clean - NAPI Rx polling callback
+ * @napi: napi info
+ * @budget: number of packets to clean
  */
 static int atl1e_clean(struct napi_struct *napi, int budget)
 {
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 60f8aa79deb2..eaf96d002fa5 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2552,7 +2552,7 @@ static irqreturn_t atl1_intr(int irq, void *data)
 
 /**
  * atl1_phy_config - Timer Call-back
- * @data: pointer to netdev cast into an unsigned long
+ * @t: timer_list containing pointer to netdev cast into an unsigned long
  */
 static void atl1_phy_config(struct timer_list *t)
 {
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index e2526c0fb7cf..021fb0e6417a 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -994,6 +994,7 @@ static int atl2_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 /**
  * atl2_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: index of the hanging transmit queue
  */
 static void atl2_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
@@ -1005,7 +1006,7 @@ static void atl2_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 
 /**
  * atl2_watchdog - Timer Call-back
- * @data: pointer to netdev cast into an unsigned long
+ * @t: timer list containing a pointer to netdev cast into an unsigned long
  */
 static void atl2_watchdog(struct timer_list *t)
 {
@@ -1030,7 +1031,7 @@ static void atl2_watchdog(struct timer_list *t)
 
 /**
  * atl2_phy_config - Timer Call-back
- * @data: pointer to netdev cast into an unsigned long
+ * @t: timer list containing a pointer to netdev cast into an unsigned long
  */
 static void atl2_phy_config(struct timer_list *t)
 {
@@ -1235,6 +1236,7 @@ static int atl2_check_link(struct atl2_adapter *adapter)
 
 /**
  * atl2_link_chg_task - deal with link change event Out of interrupt context
+ * @work: pointer to work struct with private info
  */
 static void atl2_link_chg_task(struct work_struct *work)
 {
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 2c0ccd4fba9b..1a6ec1a12d53 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -504,6 +504,7 @@ static void bnx2x_tpa_start(struct bnx2x_fastpath *fp, u16 queue,
  * @len_on_bd:		total length of the first packet for the
  *			aggregation.
  * @pkt_len:		length of all segments
+ * @num_of_coalesced_segs: count of segments
  *
  * Approximate value of the MSS for this aggregation calculated using
  * the first packet of it.
@@ -1958,6 +1959,7 @@ void bnx2x_set_num_queues(struct bnx2x *bp)
  * bnx2x_set_real_num_queues - configure netdev->real_num_[tx,rx]_queues
  *
  * @bp:		Driver handle
+ * @include_cnic: handle cnic case
  *
  * We currently support for at most 16 Tx queues for each CoS thus we will
  * allocate a multiple of 16 for ETH L2 rings according to the value of the
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index 7cea33803f7f..32245bbe88a8 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -839,8 +839,9 @@ static bool bnx2x_is_wreg_in_chip(struct bnx2x *bp,
 /**
  * bnx2x_read_pages_regs - read "paged" registers
  *
- * @bp		device handle
- * @p		output buffer
+ * @bp:		device handle
+ * @p:		output buffer
+ * @preset:	the preset value
  *
  * Reads "paged" memories: memories that may only be read by first writing to a
  * specific address ("write address") and then reading from a specific address
@@ -3561,6 +3562,7 @@ static void bnx2x_get_channels(struct net_device *dev,
  * bnx2x_change_num_queues - change the number of RSS queues.
  *
  * @bp:			bnx2x private structure
+ * @num_rss:		rss count
  *
  * Re-configure interrupt mode to get the new number of MSI-X
  * vectors and re-add NAPI objects.
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 35f659310084..9e258fc50a7e 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -3086,9 +3086,9 @@ void bnx2x_func_init(struct bnx2x *bp, struct bnx2x_func_init_params *p)
 /**
  * bnx2x_get_common_flags - Return common flags
  *
- * @bp		device handle
- * @fp		queue handle
- * @zero_stats	TRUE if statistics zeroing is needed
+ * @bp:		device handle
+ * @fp:		queue handle
+ * @zero_stats:	TRUE if statistics zeroing is needed
  *
  * Return the flags that are common for the Tx-only and not normal connections.
  */
@@ -13591,8 +13591,8 @@ static int bnx2x_set_qm_cid_count(struct bnx2x *bp)
 
 /**
  * bnx2x_get_num_none_def_sbs - return the number of none default SBs
- *
- * @dev:	pci device
+ * @pdev: pci device
+ * @cnic_cnt: count
  *
  */
 static int bnx2x_get_num_non_def_sbs(struct pci_dev *pdev, int cnic_cnt)
@@ -14451,9 +14451,7 @@ module_exit(bnx2x_cleanup);
 
 /**
  * bnx2x_set_iscsi_eth_mac_addr - set iSCSI MAC(s).
- *
  * @bp:		driver handle
- * @set:	set or clear the CAM entry
  *
  * This function will wait until the ramrod completion returns.
  * Return 0 if success, -ENODEV if ramrod doesn't return.
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index e26f4da5a6d7..6cd1523ad9e5 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -37,10 +37,12 @@
 /**
  * bnx2x_exe_queue_init - init the Exe Queue object
  *
+ * @bp:		driver handle
  * @o:		pointer to the object
  * @exe_len:	length
  * @owner:	pointer to the owner
  * @validate:	validate function pointer
+ * @remove:	remove function pointer
  * @optimize:	optimize function pointer
  * @exec:	execute function pointer
  * @get:	get function pointer
@@ -103,7 +105,7 @@ static inline int bnx2x_exe_queue_length(struct bnx2x_exe_queue_obj *o)
  *
  * @bp:		driver handle
  * @o:		queue
- * @cmd:	new command to add
+ * @elem:	new command to add
  * @restore:	true - do not optimize the command
  *
  * If the element is optimized or is illegal, frees it.
@@ -277,7 +279,7 @@ static void bnx2x_raw_set_pending(struct bnx2x_raw_obj *o)
  *
  * @bp:		device handle
  * @state:	state which is to be cleared
- * @state_p:	state buffer
+ * @pstate:	state buffer
  *
  */
 static inline int bnx2x_state_wait(struct bnx2x *bp, int state,
@@ -424,8 +426,8 @@ static bool bnx2x_put_credit_vlan_mac(struct bnx2x_vlan_mac_obj *o)
  * @bp:		device handle
  * @o:		vlan_mac object
  *
- * @details: Non-blocking implementation; should be called under execution
- *           queue lock.
+ * Context: Non-blocking implementation; should be called under execution
+ *          queue lock.
  */
 static int __bnx2x_vlan_mac_h_write_trylock(struct bnx2x *bp,
 					    struct bnx2x_vlan_mac_obj *o)
@@ -445,7 +447,7 @@ static int __bnx2x_vlan_mac_h_write_trylock(struct bnx2x *bp,
  * @bp:		device handle
  * @o:		vlan_mac object
  *
- * @details Should be called under execution queue lock; notice it might release
+ * details Should be called under execution queue lock; notice it might release
  *          and reclaim it during its run.
  */
 static void __bnx2x_vlan_mac_h_exec_pending(struct bnx2x *bp,
@@ -475,7 +477,7 @@ static void __bnx2x_vlan_mac_h_exec_pending(struct bnx2x *bp,
  * @o:			vlan_mac object
  * @ramrod_flags:	ramrod flags of missed execution
  *
- * @details Should be called under execution queue lock.
+ * Context: Should be called under execution queue lock.
  */
 static void __bnx2x_vlan_mac_h_pend(struct bnx2x *bp,
 				    struct bnx2x_vlan_mac_obj *o,
@@ -493,7 +495,7 @@ static void __bnx2x_vlan_mac_h_pend(struct bnx2x *bp,
  * @bp:			device handle
  * @o:			vlan_mac object
  *
- * @details Should be called under execution queue lock. Notice if a pending
+ * Context: Should be called under execution queue lock. Notice if a pending
  *          execution exists, it would perform it - possibly releasing and
  *          reclaiming the execution queue lock.
  */
@@ -516,7 +518,7 @@ static void __bnx2x_vlan_mac_h_write_unlock(struct bnx2x *bp,
  * @bp:			device handle
  * @o:			vlan_mac object
  *
- * @details Should be called under the execution queue lock. May sleep. May
+ * Context: Should be called under the execution queue lock. May sleep. May
  *          release and reclaim execution queue lock during its run.
  */
 static int __bnx2x_vlan_mac_h_read_lock(struct bnx2x *bp,
@@ -536,7 +538,7 @@ static int __bnx2x_vlan_mac_h_read_lock(struct bnx2x *bp,
  * @bp:			device handle
  * @o:			vlan_mac object
  *
- * @details May sleep. Claims and releases execution queue lock during its run.
+ * Context: May sleep. Claims and releases execution queue lock during its run.
  */
 int bnx2x_vlan_mac_h_read_lock(struct bnx2x *bp,
 			       struct bnx2x_vlan_mac_obj *o)
@@ -556,7 +558,7 @@ int bnx2x_vlan_mac_h_read_lock(struct bnx2x *bp,
  * @bp:			device handle
  * @o:			vlan_mac object
  *
- * @details Should be called under execution queue lock. Notice if a pending
+ * Context: Should be called under execution queue lock. Notice if a pending
  *          execution exists, it would be performed if this was the last
  *          reader. possibly releasing and reclaiming the execution queue lock.
  */
@@ -591,7 +593,7 @@ static void __bnx2x_vlan_mac_h_read_unlock(struct bnx2x *bp,
  * @bp:			device handle
  * @o:			vlan_mac object
  *
- * @details Notice if a pending execution exists, it would be performed if this
+ * Context: Notice if a pending execution exists, it would be performed if this
  *          was the last reader. Claims and releases the execution queue lock
  *          during its run.
  */
@@ -968,7 +970,7 @@ static void bnx2x_set_one_mac_e2(struct bnx2x *bp,
  *
  * @bp:		device handle
  * @o:		queue
- * @type:
+ * @type:	the type of echo
  * @cam_offset:	offset in cam memory
  * @hdr:	pointer to a header to setup
  *
@@ -1608,8 +1610,8 @@ static int __bnx2x_vlan_mac_execute_step(struct bnx2x *bp,
  *
  * @bp:		device handle
  * @o:		bnx2x_vlan_mac_obj
- * @cqe:
- * @cont:	if true schedule next execution chunk
+ * @cqe:	completion element
+ * @ramrod_flags: if set schedule next execution chunk
  *
  */
 static int bnx2x_complete_vlan_mac(struct bnx2x *bp,
@@ -1656,7 +1658,7 @@ static int bnx2x_complete_vlan_mac(struct bnx2x *bp,
  * bnx2x_optimize_vlan_mac - optimize ADD and DEL commands.
  *
  * @bp:		device handle
- * @o:		bnx2x_qable_obj
+ * @qo:		bnx2x_qable_obj
  * @elem:	bnx2x_exeq_elem
  */
 static int bnx2x_optimize_vlan_mac(struct bnx2x *bp,
@@ -1714,10 +1716,10 @@ static int bnx2x_optimize_vlan_mac(struct bnx2x *bp,
  * bnx2x_vlan_mac_get_registry_elem - prepare a registry element
  *
  * @bp:	  device handle
- * @o:
- * @elem:
- * @restore:
- * @re:
+ * @o:	vlan object
+ * @elem: element
+ * @restore: to restore or not
+ * @re: registry
  *
  * prepare a registry element according to the current command request.
  */
@@ -1768,9 +1770,9 @@ static inline int bnx2x_vlan_mac_get_registry_elem(
  * bnx2x_execute_vlan_mac - execute vlan mac command
  *
  * @bp:			device handle
- * @qo:
- * @exe_chunk:
- * @ramrod_flags:
+ * @qo:			bnx2x_qable_obj pointer
+ * @exe_chunk:		chunk
+ * @ramrod_flags:	flags
  *
  * go and send a ramrod!
  */
@@ -2006,8 +2008,8 @@ int bnx2x_config_vlan_mac(struct bnx2x *bp,
  * bnx2x_vlan_mac_del_all - delete elements with given vlan_mac_flags spec
  *
  * @bp:			device handle
- * @o:
- * @vlan_mac_flags:
+ * @o:			vlan object info
+ * @vlan_mac_flags:	vlan flags
  * @ramrod_flags:	execution flags to be used for this deletion
  *
  * if the last operation has completed successfully and there are no
@@ -2767,7 +2769,7 @@ static int bnx2x_mcast_enqueue_cmd(struct bnx2x *bp,
 /**
  * bnx2x_mcast_get_next_bin - get the next set bin (index)
  *
- * @o:
+ * @o:		multicast object info
  * @last:	index to start looking from (including)
  *
  * returns the next found (set) bin or a negative value if none is found.
@@ -2892,7 +2894,7 @@ static void bnx2x_mcast_set_one_rule_e2(struct bnx2x *bp,
  * bnx2x_mcast_handle_restore_cmd_e2 - restore configuration from the registry
  *
  * @bp:		device handle
- * @o:
+ * @o:		multicast object info
  * @start_bin:	index in the registry to start from (including)
  * @rdata_idx:	index in the ramrod data to start from
  *
@@ -3202,11 +3204,11 @@ static inline void bnx2x_mcast_hdl_del(struct bnx2x *bp,
 }
 
 /**
- * bnx2x_mcast_handle_current_cmd -
+ * bnx2x_mcast_handle_current_cmd - send command if room
  *
  * @bp:		device handle
- * @p:
- * @cmd:
+ * @p:		ramrod mcast info
+ * @cmd:	command
  * @start_cnt:	first line in the ramrod data that may be used
  *
  * This function is called iff there is enough place for the current command in
@@ -3323,7 +3325,7 @@ static void bnx2x_mcast_revert_e2(struct bnx2x *bp,
  * bnx2x_mcast_set_rdata_hdr_e2 - sets a header values
  *
  * @bp:		device handle
- * @p:
+ * @p:		ramrod parameters
  * @len:	number of rules to handle
  */
 static inline void bnx2x_mcast_set_rdata_hdr_e2(struct bnx2x *bp,
@@ -3684,7 +3686,7 @@ static void bnx2x_mcast_set_one_rule_e1(struct bnx2x *bp,
  * bnx2x_mcast_set_rdata_hdr_e1  - set header values in mac_configuration_cmd
  *
  * @bp:		device handle
- * @p:
+ * @p:		ramrod parameters
  * @len:	number of rules to handle
  */
 static inline void bnx2x_mcast_set_rdata_hdr_e1(struct bnx2x *bp,
@@ -3711,7 +3713,7 @@ static inline void bnx2x_mcast_set_rdata_hdr_e1(struct bnx2x *bp,
  * bnx2x_mcast_handle_restore_cmd_e1 - restore command for 57710
  *
  * @bp:		device handle
- * @o:
+ * @o:		multicast info
  * @start_idx:	index in the registry to start from
  * @rdata_idx:	index in the ramrod data to start from
  *
@@ -3798,10 +3800,10 @@ static inline int bnx2x_mcast_handle_pending_cmds_e1(
 /**
  * bnx2x_get_fw_mac_addr - revert the bnx2x_set_fw_mac_addr().
  *
- * @fw_hi:
- * @fw_mid:
- * @fw_lo:
- * @mac:
+ * @fw_hi: address
+ * @fw_mid: address
+ * @fw_lo: address
+ * @mac: mac address
  */
 static inline void bnx2x_get_fw_mac_addr(__le16 *fw_hi, __le16 *fw_mid,
 					 __le16 *fw_lo, u8 *mac)
@@ -3818,7 +3820,7 @@ static inline void bnx2x_get_fw_mac_addr(__le16 *fw_hi, __le16 *fw_mid,
  * bnx2x_mcast_refresh_registry_e1 -
  *
  * @bp:		device handle
- * @cnt:
+ * @o:		multicast info
  *
  * Check the ramrod data first entry flag to see if it's a DELETE or ADD command
  * and update the registry correspondingly: if ADD - allocate a memory and add
@@ -4311,7 +4313,7 @@ static bool bnx2x_credit_pool_get_entry_always_true(
 /**
  * bnx2x_init_credit_pool - initialize credit pool internals.
  *
- * @p:
+ * @p:		credit pool
  * @base:	Base entry in the CAM to use.
  * @credit:	pool size.
  *
@@ -4725,8 +4727,8 @@ static int bnx2x_queue_wait_comp(struct bnx2x *bp,
  * bnx2x_queue_comp_cmd - complete the state change command.
  *
  * @bp:		device handle
- * @o:
- * @cmd:
+ * @o:		queue info
+ * @cmd:	command to exec
  *
  * Checks that the arrived completion is expected.
  */
@@ -5477,8 +5479,8 @@ static int bnx2x_queue_send_cmd_e2(struct bnx2x *bp,
  * bnx2x_queue_chk_transition - check state machine of a regular Queue
  *
  * @bp:		device handle
- * @o:
- * @params:
+ * @o:		queue info
+ * @params:	queue state
  *
  * (not Forwarding)
  * It both checks if the requested command is legal in a current
@@ -5735,8 +5737,8 @@ static int bnx2x_func_wait_comp(struct bnx2x *bp,
  * bnx2x_func_state_change_comp - complete the state machine transition
  *
  * @bp:		device handle
- * @o:
- * @cmd:
+ * @o:		function info
+ * @cmd:	more info
  *
  * Called on state change transition. Completes the state
  * machine transition only - no HW interaction.
@@ -5776,8 +5778,8 @@ static inline int bnx2x_func_state_change_comp(struct bnx2x *bp,
  * bnx2x_func_comp_cmd - complete the state change command
  *
  * @bp:		device handle
- * @o:
- * @cmd:
+ * @o:		function info
+ * @cmd:	more info
  *
  * Checks that the arrived completion is expected.
  */
@@ -5796,8 +5798,8 @@ static int bnx2x_func_comp_cmd(struct bnx2x *bp,
  * bnx2x_func_chk_transition - perform function state machine transition
  *
  * @bp:		device handle
- * @o:
- * @params:
+ * @o:		function info
+ * @params:	state parameters
  *
  * It both checks if the requested command is legal in a current
  * state and, if it's legal, sets a `next_state' in the object
diff --git a/drivers/net/ethernet/brocade/bna/bfa_cee.c b/drivers/net/ethernet/brocade/bna/bfa_cee.c
index 09fb9315d1ae..06f221c44802 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_cee.c
+++ b/drivers/net/ethernet/brocade/bna/bfa_cee.c
@@ -102,14 +102,10 @@ bfa_cee_get_stats_isr(struct bfa_cee *cee, enum bfa_status status)
 }
 
 /**
- * bfa_cee_get_attr_isr()
+ * bfa_cee_reset_stats_isr - CEE ISR for reset-stats responses from f/w
  *
- * @brief CEE ISR for reset-stats responses from f/w
- *
- * @param[in] cee - Pointer to the CEE module
- *            status - Return status from the f/w
- *
- * @return void
+ * @cee: Input Pointer to the CEE module
+ * @status: Return status from the f/w
  */
 static void
 bfa_cee_reset_stats_isr(struct bfa_cee *cee, enum bfa_status status)
@@ -148,9 +144,12 @@ bfa_nw_cee_mem_claim(struct bfa_cee *cee, u8 *dma_kva, u64 dma_pa)
 }
 
 /**
- * bfa_cee_get_attr - Send the request to the f/w to fetch CEE attributes.
+ * bfa_nw_cee_get_attr - Send the request to the f/w to fetch CEE attributes.
  *
  * @cee: Pointer to the CEE module data structure.
+ * @attr: attribute requested
+ * @cbfn: function pointer
+ * @cbarg: function pointer arguments
  *
  * Return: status
  */
@@ -181,7 +180,9 @@ bfa_nw_cee_get_attr(struct bfa_cee *cee, struct bfa_cee_attr *attr,
 }
 
 /**
- * bfa_cee_isrs - Handles Mail-box interrupts for CEE module.
+ * bfa_cee_isr - Handles Mail-box interrupts for CEE module.
+ * @cbarg: argument passed containing pointer to the CEE module data structure.
+ * @m: message pointer
  */
 
 static void
@@ -210,6 +211,7 @@ bfa_cee_isr(void *cbarg, struct bfi_mbmsg *m)
 /**
  * bfa_cee_notify - CEE module heart-beat failure handler.
  *
+ * @arg: argument passed containing pointer to the CEE module data structure.
  * @event: IOC event type
  */
 
diff --git a/drivers/net/ethernet/brocade/bna/bfa_ioc.c b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
index b9dd06b12945..fd805c685d92 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_ioc.c
+++ b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
@@ -1763,7 +1763,7 @@ bfa_ioc_flash_fwver_cmp(struct bfa_ioc *ioc,
 		return BFI_IOC_IMG_VER_INCOMP;
 }
 
-/**
+/*
  * Returns TRUE if driver is willing to work with current smem f/w version.
  */
 bool
@@ -2469,6 +2469,7 @@ bfa_ioc_isr(struct bfa_ioc *ioc, struct bfi_mbmsg *m)
  *
  * @ioc:	memory for IOC
  * @bfa:	driver instance structure
+ * @cbfn:	callback function
  */
 void
 bfa_nw_ioc_attach(struct bfa_ioc *ioc, void *bfa, struct bfa_ioc_cbfn *cbfn)
@@ -2500,7 +2501,9 @@ bfa_nw_ioc_detach(struct bfa_ioc *ioc)
 /**
  * bfa_nw_ioc_pci_init - Setup IOC PCI properties.
  *
+ * @ioc:	memory for IOC
  * @pcidev:	PCI device information for this IOC
+ * @clscode:	class code
  */
 void
 bfa_nw_ioc_pci_init(struct bfa_ioc *ioc, struct bfa_pcidev *pcidev,
@@ -2569,6 +2572,7 @@ bfa_nw_ioc_pci_init(struct bfa_ioc *ioc, struct bfa_pcidev *pcidev,
 /**
  * bfa_nw_ioc_mem_claim - Initialize IOC dma memory
  *
+ * @ioc:	memory for IOC
  * @dm_kva:	kernel virtual address of IOC dma memory
  * @dm_pa:	physical address of IOC dma memory
  */
@@ -2636,6 +2640,8 @@ bfa_nw_ioc_mbox_regisr(struct bfa_ioc *ioc, enum bfi_mclass mc,
  *
  * @ioc:	IOC instance
  * @cmd:	Mailbox command
+ * @cbfn:	callback function
+ * @cbarg:	arguments to callback
  *
  * Waits if mailbox is busy. Responsibility of caller to serialize
  */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 9c8f40e8a721..f00ad73ea8e3 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -458,9 +458,9 @@ static void macb_init_buffers(struct macb *bp)
 
 /**
  * macb_set_tx_clk() - Set a clock to a new frequency
- * @clk		Pointer to the clock to change
- * @rate	New frequency in Hz
- * @dev		Pointer to the struct net_device
+ * @clk:	Pointer to the clock to change
+ * @speed:	New frequency in Hz
+ * @dev:	Pointer to the struct net_device
  */
 static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
 {
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 05a3d067c3fc..bbb453c6a5f7 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1246,6 +1246,8 @@ static int xgmac_poll(struct napi_struct *napi, int budget)
 /**
  *  xgmac_tx_timeout
  *  @dev : Pointer to net device structure
+ *  @txqueue: index of the hung transmit queue
+ *
  *  Description: this function is called when a packet transmission fails to
  *   complete within a reasonable tmrate. The driver will mark the error in the
  *   netdev structure and arrange for the device to be reset to a sane state
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index e40c64b79f66..9ef172976b35 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -32,8 +32,8 @@
 #define OCTNIC_MAX_SG  MAX_SKB_FRAGS
 
 /**
- * \brief Delete gather lists
- * @param lio per-network private data
+ * lio_delete_glists - Delete gather lists
+ * @lio: per-network private data
  */
 void lio_delete_glists(struct lio *lio)
 {
@@ -73,8 +73,10 @@ void lio_delete_glists(struct lio *lio)
 }
 
 /**
- * \brief Setup gather lists
- * @param lio per-network private data
+ * lio_setup_glists - Setup gather lists
+ * @oct: octeon_device
+ * @lio: per-network private data
+ * @num_iqs: count of iqs to allocate
  */
 int lio_setup_glists(struct octeon_device *oct, struct lio *lio, int num_iqs)
 {
@@ -521,12 +523,12 @@ static void lio_update_txq_status(struct octeon_device *oct, int iq_num)
 }
 
 /**
- * \brief Setup output queue
- * @param oct octeon device
- * @param q_no which queue
- * @param num_descs how many descriptors
- * @param desc_size size of each descriptor
- * @param app_ctx application context
+ * octeon_setup_droq - Setup output queue
+ * @oct: octeon device
+ * @q_no: which queue
+ * @num_descs: how many descriptors
+ * @desc_size: size of each descriptor
+ * @app_ctx: application context
  */
 static int octeon_setup_droq(struct octeon_device *oct, int q_no, int num_descs,
 			     int desc_size, void *app_ctx)
@@ -555,16 +557,17 @@ static int octeon_setup_droq(struct octeon_device *oct, int q_no, int num_descs,
 	return ret_val;
 }
 
-/** Routine to push packets arriving on Octeon interface upto network layer.
- * @param oct_id   - octeon device id.
- * @param skbuff   - skbuff struct to be passed to network layer.
- * @param len      - size of total data received.
- * @param rh       - Control header associated with the packet
- * @param param    - additional control data with the packet
- * @param arg      - farg registered in droq_ops
+/**
+ * liquidio_push_packet - Routine to push packets arriving on Octeon interface upto network layer.
+ * @octeon_id:octeon device id.
+ * @skbuff:   skbuff struct to be passed to network layer.
+ * @len:      size of total data received.
+ * @rh:       Control header associated with the packet
+ * @param:    additional control data with the packet
+ * @arg:      farg registered in droq_ops
  */
 static void
-liquidio_push_packet(u32 octeon_id __attribute__((unused)),
+liquidio_push_packet(u32 __maybe_unused octeon_id,
 		     void *skbuff,
 		     u32 len,
 		     union octeon_rh *rh,
@@ -698,8 +701,8 @@ liquidio_push_packet(u32 octeon_id __attribute__((unused)),
 }
 
 /**
- * \brief wrapper for calling napi_schedule
- * @param param parameters to pass to napi_schedule
+ * napi_schedule_wrapper - wrapper for calling napi_schedule
+ * @param: parameters to pass to napi_schedule
  *
  * Used when scheduling on different CPUs
  */
@@ -711,8 +714,8 @@ static void napi_schedule_wrapper(void *param)
 }
 
 /**
- * \brief callback when receive interrupt occurs and we are in NAPI mode
- * @param arg pointer to octeon output queue
+ * liquidio_napi_drv_callback - callback when receive interrupt occurs and we are in NAPI mode
+ * @arg: pointer to octeon output queue
  */
 static void liquidio_napi_drv_callback(void *arg)
 {
@@ -737,9 +740,9 @@ static void liquidio_napi_drv_callback(void *arg)
 }
 
 /**
- * \brief Entry point for NAPI polling
- * @param napi NAPI structure
- * @param budget maximum number of items to process
+ * liquidio_napi_poll - Entry point for NAPI polling
+ * @napi: NAPI structure
+ * @budget: maximum number of items to process
  */
 static int liquidio_napi_poll(struct napi_struct *napi, int budget)
 {
@@ -792,9 +795,11 @@ static int liquidio_napi_poll(struct napi_struct *napi, int budget)
 }
 
 /**
- * \brief Setup input and output queues
- * @param octeon_dev octeon device
- * @param ifidx Interface index
+ * liquidio_setup_io_queues - Setup input and output queues
+ * @octeon_dev: octeon device
+ * @ifidx: Interface index
+ * @num_iqs: input io queue count
+ * @num_oqs: output io queue count
  *
  * Note: Queues are with respect to the octeon device. Thus
  * an input queue is for egress packets, and output queues
@@ -927,7 +932,7 @@ int liquidio_schedule_msix_droq_pkt_handler(struct octeon_droq *droq, u64 ret)
 }
 
 irqreturn_t
-liquidio_msix_intr_handler(int irq __attribute__((unused)), void *dev)
+liquidio_msix_intr_handler(int __maybe_unused irq, void *dev)
 {
 	struct octeon_ioq_vector *ioq_vector = (struct octeon_ioq_vector *)dev;
 	struct octeon_device *oct = ioq_vector->oct_dev;
@@ -943,8 +948,8 @@ liquidio_msix_intr_handler(int irq __attribute__((unused)), void *dev)
 }
 
 /**
- * \brief Droq packet processor sceduler
- * @param oct octeon device
+ * liquidio_schedule_droq_pkt_handlers - Droq packet processor sceduler
+ * @oct: octeon device
  */
 static void liquidio_schedule_droq_pkt_handlers(struct octeon_device *oct)
 {
@@ -972,13 +977,12 @@ static void liquidio_schedule_droq_pkt_handlers(struct octeon_device *oct)
 }
 
 /**
- * \brief Interrupt handler for octeon
- * @param irq unused
- * @param dev octeon device
+ * liquidio_legacy_intr_handler - Interrupt handler for octeon
+ * @irq: unused
+ * @dev: octeon device
  */
 static
-irqreturn_t liquidio_legacy_intr_handler(int irq __attribute__((unused)),
-					 void *dev)
+irqreturn_t liquidio_legacy_intr_handler(int __maybe_unused irq, void *dev)
 {
 	struct octeon_device *oct = (struct octeon_device *)dev;
 	irqreturn_t ret;
@@ -999,8 +1003,9 @@ irqreturn_t liquidio_legacy_intr_handler(int irq __attribute__((unused)),
 }
 
 /**
- * \brief Setup interrupt for octeon device
- * @param oct octeon device
+ * octeon_setup_interrupt - Setup interrupt for octeon device
+ * @oct: octeon device
+ * @num_ioqs: number of queues
  *
  *  Enable interrupt in Octeon device as given in the PCI interrupt mask.
  */
@@ -1083,7 +1088,7 @@ int octeon_setup_interrupt(struct octeon_device *oct, u32 num_ioqs)
 		dev_dbg(&oct->pci_dev->dev, "OCTEON: Enough MSI-X interrupts are allocated...\n");
 
 		num_ioq_vectors = oct->num_msix_irqs;
-		/** For PF, there is one non-ioq interrupt handler */
+		/* For PF, there is one non-ioq interrupt handler */
 		if (OCTEON_CN23XX_PF(oct)) {
 			num_ioq_vectors -= 1;
 
@@ -1126,13 +1131,13 @@ int octeon_setup_interrupt(struct octeon_device *oct, u32 num_ioqs)
 				dev_err(&oct->pci_dev->dev,
 					"Request_irq failed for MSIX interrupt Error: %d\n",
 					irqret);
-				/** Freeing the non-ioq irq vector here . */
+				/* Freeing the non-ioq irq vector here . */
 				free_irq(msix_entries[num_ioq_vectors].vector,
 					 oct);
 
 				while (i) {
 					i--;
-					/** clearing affinity mask. */
+					/* clearing affinity mask. */
 					irq_set_affinity_hint(
 						      msix_entries[i].vector,
 						      NULL);
@@ -1197,8 +1202,9 @@ int octeon_setup_interrupt(struct octeon_device *oct, u32 num_ioqs)
 }
 
 /**
- * \brief Net device change_mtu
- * @param netdev network device
+ * liquidio_change_mtu - Net device change_mtu
+ * @netdev: network device
+ * @new_mtu: the new max transmit unit size
  */
 int liquidio_change_mtu(struct net_device *netdev, int new_mtu)
 {
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 9eac0d43b58d..7d00d3a8ded4 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -69,9 +69,9 @@ MODULE_PARM_DESC(console_bitmask,
 		 "Bitmask indicating which consoles have debug output redirected to syslog.");
 
 /**
- * \brief determines if a given console has debug enabled.
- * @param console console to check
- * @returns  1 = enabled. 0 otherwise
+ * octeon_console_debug_enabled - determines if a given console has debug enabled.
+ * @console: console to check
+ * Return:  1 = enabled. 0 otherwise
  */
 static int octeon_console_debug_enabled(u32 console)
 {
@@ -126,7 +126,7 @@ union tx_info {
 	} s;
 };
 
-/** Octeon device properties to be used by the NIC module.
+/* Octeon device properties to be used by the NIC module.
  * Each octeon device in the system will be represented
  * by this structure in the NIC module.
  */
@@ -222,8 +222,8 @@ static int lio_wait_for_oq_pkts(struct octeon_device *oct)
 }
 
 /**
- * \brief Forces all IO queues off on a given device
- * @param oct Pointer to Octeon device
+ * force_io_queues_off - Forces all IO queues off on a given device
+ * @oct: Pointer to Octeon device
  */
 static void force_io_queues_off(struct octeon_device *oct)
 {
@@ -238,8 +238,8 @@ static void force_io_queues_off(struct octeon_device *oct)
 }
 
 /**
- * \brief Cause device to go quiet so it can be safely removed/reset/etc
- * @param oct Pointer to Octeon device
+ * pcierror_quiesce_device - Cause device to go quiet so it can be safely removed/reset/etc
+ * @oct: Pointer to Octeon device
  */
 static inline void pcierror_quiesce_device(struct octeon_device *oct)
 {
@@ -283,8 +283,8 @@ static inline void pcierror_quiesce_device(struct octeon_device *oct)
 }
 
 /**
- * \brief Cleanup PCI AER uncorrectable error status
- * @param dev Pointer to PCI device
+ * cleanup_aer_uncorrect_error_status - Cleanup PCI AER uncorrectable error status
+ * @dev: Pointer to PCI device
  */
 static void cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
 {
@@ -303,8 +303,8 @@ static void cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
 }
 
 /**
- * \brief Stop all PCI IO to a given device
- * @param dev Pointer to Octeon device
+ * stop_pci_io - Stop all PCI IO to a given device
+ * @oct: Pointer to Octeon device
  */
 static void stop_pci_io(struct octeon_device *oct)
 {
@@ -332,9 +332,9 @@ static void stop_pci_io(struct octeon_device *oct)
 }
 
 /**
- * \brief called when PCI error is detected
- * @param pdev Pointer to PCI device
- * @param state The current pci connection state
+ * liquidio_pcie_error_detected - called when PCI error is detected
+ * @pdev: Pointer to PCI device
+ * @state: The current pci connection state
  *
  * This function is called after a PCI bus error affecting
  * this device has been detected.
@@ -362,11 +362,10 @@ static pci_ers_result_t liquidio_pcie_error_detected(struct pci_dev *pdev,
 }
 
 /**
- * \brief mmio handler
- * @param pdev Pointer to PCI device
+ * liquidio_pcie_mmio_enabled - mmio handler
+ * @pdev: Pointer to PCI device
  */
-static pci_ers_result_t liquidio_pcie_mmio_enabled(
-				struct pci_dev *pdev __attribute__((unused)))
+static pci_ers_result_t liquidio_pcie_mmio_enabled(struct pci_dev __maybe_unused *pdev)
 {
 	/* We should never hit this since we never ask for a reset for a Fatal
 	 * Error. We always return DISCONNECT in io_error above.
@@ -376,14 +375,13 @@ static pci_ers_result_t liquidio_pcie_mmio_enabled(
 }
 
 /**
- * \brief called after the pci bus has been reset.
- * @param pdev Pointer to PCI device
+ * liquidio_pcie_slot_reset - called after the pci bus has been reset.
+ * @pdev: Pointer to PCI device
  *
  * Restart the card from scratch, as if from a cold-boot. Implementation
  * resembles the first-half of the octeon_resume routine.
  */
-static pci_ers_result_t liquidio_pcie_slot_reset(
-				struct pci_dev *pdev __attribute__((unused)))
+static pci_ers_result_t liquidio_pcie_slot_reset(struct pci_dev __maybe_unused *pdev)
 {
 	/* We should never hit this since we never ask for a reset for a Fatal
 	 * Error. We always return DISCONNECT in io_error above.
@@ -393,14 +391,14 @@ static pci_ers_result_t liquidio_pcie_slot_reset(
 }
 
 /**
- * \brief called when traffic can start flowing again.
- * @param pdev Pointer to PCI device
+ * liquidio_pcie_resume - called when traffic can start flowing again.
+ * @pdev: Pointer to PCI device
  *
  * This callback is called when the error recovery driver tells us that
  * its OK to resume normal operation. Implementation resembles the
  * second-half of the octeon_resume routine.
  */
-static void liquidio_pcie_resume(struct pci_dev *pdev __attribute__((unused)))
+static void liquidio_pcie_resume(struct pci_dev __maybe_unused *pdev)
 {
 	/* Nothing to be done here. */
 }
@@ -447,7 +445,7 @@ static struct pci_driver liquidio_pci_driver = {
 };
 
 /**
- * \brief register PCI driver
+ * liquidio_init_pci - register PCI driver
  */
 static int liquidio_init_pci(void)
 {
@@ -455,7 +453,7 @@ static int liquidio_init_pci(void)
 }
 
 /**
- * \brief unregister PCI driver
+ * liquidio_deinit_pci - unregister PCI driver
  */
 static void liquidio_deinit_pci(void)
 {
@@ -463,9 +461,9 @@ static void liquidio_deinit_pci(void)
 }
 
 /**
- * \brief Check Tx queue status, and take appropriate action
- * @param lio per-network private data
- * @returns 0 if full, number of queues woken up otherwise
+ * check_txq_status - Check Tx queue status, and take appropriate action
+ * @lio: per-network private data
+ * Return: 0 if full, number of queues woken up otherwise
  */
 static inline int check_txq_status(struct lio *lio)
 {
@@ -491,8 +489,8 @@ static inline int check_txq_status(struct lio *lio)
 }
 
 /**
- * \brief Print link information
- * @param netdev network device
+ * print_link_info -  Print link information
+ * @netdev: network device
  */
 static void print_link_info(struct net_device *netdev)
 {
@@ -513,8 +511,8 @@ static void print_link_info(struct net_device *netdev)
 }
 
 /**
- * \brief Routine to notify MTU change
- * @param work work_struct data structure
+ * octnet_link_status_change - Routine to notify MTU change
+ * @work: work_struct data structure
  */
 static void octnet_link_status_change(struct work_struct *work)
 {
@@ -531,8 +529,8 @@ static void octnet_link_status_change(struct work_struct *work)
 }
 
 /**
- * \brief Sets up the mtu status change work
- * @param netdev network device
+ * setup_link_status_change_wq - Sets up the mtu status change work
+ * @netdev: network device
  */
 static inline int setup_link_status_change_wq(struct net_device *netdev)
 {
@@ -563,9 +561,9 @@ static inline void cleanup_link_status_change_wq(struct net_device *netdev)
 }
 
 /**
- * \brief Update link status
- * @param netdev network device
- * @param ls link status structure
+ * update_link_status - Update link status
+ * @netdev: network device
+ * @ls: link status structure
  *
  * Called on receipt of a link status response from the core application to
  * update each interface's link status.
@@ -663,10 +661,9 @@ static void lio_sync_octeon_time(struct work_struct *work)
 }
 
 /**
- * setup_sync_octeon_time_wq - Sets up the work to periodically update
- * local time to octeon firmware
+ * setup_sync_octeon_time_wq - prepare work to periodically update local time to octeon firmware
  *
- * @netdev - network device which should send time update to firmware
+ * @netdev: network device which should send time update to firmware
  **/
 static inline int setup_sync_octeon_time_wq(struct net_device *netdev)
 {
@@ -690,10 +687,12 @@ static inline int setup_sync_octeon_time_wq(struct net_device *netdev)
 }
 
 /**
- * cleanup_sync_octeon_time_wq - stop scheduling and destroy the work created
- * to periodically update local time to octeon firmware
+ * cleanup_sync_octeon_time_wq - destroy wq
  *
- * @netdev - network device which should send time update to firmware
+ * @netdev: network device which should send time update to firmware
+ *
+ * Stop scheduling and destroy the work created to periodically update local
+ * time to octeon firmware.
  **/
 static inline void cleanup_sync_octeon_time_wq(struct net_device *netdev)
 {
@@ -828,13 +827,12 @@ static int liquidio_watchdog(void *param)
 }
 
 /**
- * \brief PCI probe handler
- * @param pdev PCI device structure
- * @param ent unused
+ * liquidio_probe - PCI probe handler
+ * @pdev: PCI device structure
+ * @ent: unused
  */
 static int
-liquidio_probe(struct pci_dev *pdev,
-	       const struct pci_device_id *ent __attribute__((unused)))
+liquidio_probe(struct pci_dev *pdev, const struct pci_device_id __maybe_unused *ent)
 {
 	struct octeon_device *oct_dev = NULL;
 	struct handshake *hs;
@@ -924,8 +922,8 @@ static bool fw_type_is_auto(void)
 }
 
 /**
- * \brief PCI FLR for each Octeon device.
- * @param oct octeon device
+ * octeon_pci_flr - PCI FLR for each Octeon device.
+ * @oct: octeon device
  */
 static void octeon_pci_flr(struct octeon_device *oct)
 {
@@ -951,9 +949,8 @@ static void octeon_pci_flr(struct octeon_device *oct)
 }
 
 /**
- *\brief Destroy resources associated with octeon device
- * @param pdev PCI device structure
- * @param ent unused
+ * octeon_destroy_resources - Destroy resources associated with octeon device
+ * @oct: octeon device
  */
 static void octeon_destroy_resources(struct octeon_device *oct)
 {
@@ -1152,9 +1149,9 @@ static void octeon_destroy_resources(struct octeon_device *oct)
 }
 
 /**
- * \brief Send Rx control command
- * @param lio per-network private data
- * @param start_stop whether to start or stop
+ * send_rx_ctrl_cmd - Send Rx control command
+ * @lio: per-network private data
+ * @start_stop: whether to start or stop
  */
 static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 {
@@ -1210,9 +1207,9 @@ static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 }
 
 /**
- * \brief Destroy NIC device interface
- * @param oct octeon device
- * @param ifidx which interface to destroy
+ * liquidio_destroy_nic_device - Destroy NIC device interface
+ * @oct: octeon device
+ * @ifidx: which interface to destroy
  *
  * Cleanup associated with each interface for an Octeon device  when NIC
  * module is being unloaded or if initialization fails during load.
@@ -1272,8 +1269,8 @@ static void liquidio_destroy_nic_device(struct octeon_device *oct, int ifidx)
 }
 
 /**
- * \brief Stop complete NIC functionality
- * @param oct octeon device
+ * liquidio_stop_nic_module - Stop complete NIC functionality
+ * @oct: octeon device
  */
 static int liquidio_stop_nic_module(struct octeon_device *oct)
 {
@@ -1313,8 +1310,8 @@ static int liquidio_stop_nic_module(struct octeon_device *oct)
 }
 
 /**
- * \brief Cleans up resources at unload time
- * @param pdev PCI device structure
+ * liquidio_remove - Cleans up resources at unload time
+ * @pdev: PCI device structure
  */
 static void liquidio_remove(struct pci_dev *pdev)
 {
@@ -1346,8 +1343,8 @@ static void liquidio_remove(struct pci_dev *pdev)
 }
 
 /**
- * \brief Identify the Octeon device and to map the BAR address space
- * @param oct octeon device
+ * octeon_chip_specific_setup - Identify the Octeon device and to map the BAR address space
+ * @oct: octeon device
  */
 static int octeon_chip_specific_setup(struct octeon_device *oct)
 {
@@ -1390,8 +1387,8 @@ static int octeon_chip_specific_setup(struct octeon_device *oct)
 }
 
 /**
- * \brief PCI initialization for each Octeon device.
- * @param oct octeon device
+ * octeon_pci_os_setup - PCI initialization for each Octeon device.
+ * @oct: octeon device
  */
 static int octeon_pci_os_setup(struct octeon_device *oct)
 {
@@ -1414,8 +1411,8 @@ static int octeon_pci_os_setup(struct octeon_device *oct)
 }
 
 /**
- * \brief Unmap and free network buffer
- * @param buf buffer
+ * free_netbuf - Unmap and free network buffer
+ * @buf: buffer
  */
 static void free_netbuf(void *buf)
 {
@@ -1434,8 +1431,8 @@ static void free_netbuf(void *buf)
 }
 
 /**
- * \brief Unmap and free gather buffer
- * @param buf buffer
+ * free_netsgbuf - Unmap and free gather buffer
+ * @buf: buffer
  */
 static void free_netsgbuf(void *buf)
 {
@@ -1474,8 +1471,8 @@ static void free_netsgbuf(void *buf)
 }
 
 /**
- * \brief Unmap and free gather buffer with response
- * @param buf buffer
+ * free_netsgbuf_with_resp - Unmap and free gather buffer with response
+ * @buf: buffer
  */
 static void free_netsgbuf_with_resp(void *buf)
 {
@@ -1518,9 +1515,9 @@ static void free_netsgbuf_with_resp(void *buf)
 }
 
 /**
- * \brief Adjust ptp frequency
- * @param ptp PTP clock info
- * @param ppb how much to adjust by, in parts-per-billion
+ * liquidio_ptp_adjfreq - Adjust ptp frequency
+ * @ptp: PTP clock info
+ * @ppb: how much to adjust by, in parts-per-billion
  */
 static int liquidio_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 {
@@ -1555,9 +1552,9 @@ static int liquidio_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 }
 
 /**
- * \brief Adjust ptp time
- * @param ptp PTP clock info
- * @param delta how much to adjust by, in nanosecs
+ * liquidio_ptp_adjtime - Adjust ptp time
+ * @ptp: PTP clock info
+ * @delta: how much to adjust by, in nanosecs
  */
 static int liquidio_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
@@ -1572,9 +1569,9 @@ static int liquidio_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 }
 
 /**
- * \brief Get hardware clock time, including any adjustment
- * @param ptp PTP clock info
- * @param ts timespec
+ * liquidio_ptp_gettime - Get hardware clock time, including any adjustment
+ * @ptp: PTP clock info
+ * @ts: timespec
  */
 static int liquidio_ptp_gettime(struct ptp_clock_info *ptp,
 				struct timespec64 *ts)
@@ -1595,9 +1592,9 @@ static int liquidio_ptp_gettime(struct ptp_clock_info *ptp,
 }
 
 /**
- * \brief Set hardware clock time. Reset adjustment
- * @param ptp PTP clock info
- * @param ts timespec
+ * liquidio_ptp_settime - Set hardware clock time. Reset adjustment
+ * @ptp: PTP clock info
+ * @ts: timespec
  */
 static int liquidio_ptp_settime(struct ptp_clock_info *ptp,
 				const struct timespec64 *ts)
@@ -1618,22 +1615,22 @@ static int liquidio_ptp_settime(struct ptp_clock_info *ptp,
 }
 
 /**
- * \brief Check if PTP is enabled
- * @param ptp PTP clock info
- * @param rq request
- * @param on is it on
+ * liquidio_ptp_enable - Check if PTP is enabled
+ * @ptp: PTP clock info
+ * @rq: request
+ * @on: is it on
  */
 static int
-liquidio_ptp_enable(struct ptp_clock_info *ptp __attribute__((unused)),
-		    struct ptp_clock_request *rq __attribute__((unused)),
-		    int on __attribute__((unused)))
+liquidio_ptp_enable(struct ptp_clock_info __maybe_unused *ptp,
+		    struct ptp_clock_request __maybe_unused *rq,
+		    int __maybe_unused on)
 {
 	return -EOPNOTSUPP;
 }
 
 /**
- * \brief Open PTP clock source
- * @param netdev network device
+ * oct_ptp_open - Open PTP clock source
+ * @netdev: network device
  */
 static void oct_ptp_open(struct net_device *netdev)
 {
@@ -1665,8 +1662,8 @@ static void oct_ptp_open(struct net_device *netdev)
 }
 
 /**
- * \brief Init PTP clock
- * @param oct octeon device
+ * liquidio_ptp_init - Init PTP clock
+ * @oct: octeon device
  */
 static void liquidio_ptp_init(struct octeon_device *oct)
 {
@@ -1682,8 +1679,8 @@ static void liquidio_ptp_init(struct octeon_device *oct)
 }
 
 /**
- * \brief Load firmware to device
- * @param oct octeon device
+ * load_firmware - Load firmware to device
+ * @oct: octeon device
  *
  * Maps device to firmware filename, requests firmware, and downloads it
  */
@@ -1721,8 +1718,8 @@ static int load_firmware(struct octeon_device *oct)
 }
 
 /**
- * \brief Poll routine for checking transmit queue status
- * @param work work_struct data structure
+ * octnet_poll_check_txq_status - Poll routine for checking transmit queue status
+ * @work: work_struct data structure
  */
 static void octnet_poll_check_txq_status(struct work_struct *work)
 {
@@ -1738,8 +1735,8 @@ static void octnet_poll_check_txq_status(struct work_struct *work)
 }
 
 /**
- * \brief Sets up the txq poll check
- * @param netdev network device
+ * setup_tx_poll_fn - Sets up the txq poll check
+ * @netdev: network device
  */
 static inline int setup_tx_poll_fn(struct net_device *netdev)
 {
@@ -1771,8 +1768,8 @@ static inline void cleanup_tx_poll_fn(struct net_device *netdev)
 }
 
 /**
- * \brief Net device open for LiquidIO
- * @param netdev network device
+ * liquidio_open - Net device open for LiquidIO
+ * @netdev: network device
  */
 static int liquidio_open(struct net_device *netdev)
 {
@@ -1831,8 +1828,8 @@ static int liquidio_open(struct net_device *netdev)
 }
 
 /**
- * \brief Net device stop for LiquidIO
- * @param netdev network device
+ * liquidio_stop - Net device stop for LiquidIO
+ * @netdev: network device
  */
 static int liquidio_stop(struct net_device *netdev)
 {
@@ -1896,8 +1893,8 @@ static int liquidio_stop(struct net_device *netdev)
 }
 
 /**
- * \brief Converts a mask based on net device flags
- * @param netdev network device
+ * get_new_flags - Converts a mask based on net device flags
+ * @netdev: network device
  *
  * This routine generates a octnet_ifflags mask from the net device flags
  * received from the OS.
@@ -1929,8 +1926,8 @@ static inline enum octnet_ifflags get_new_flags(struct net_device *netdev)
 }
 
 /**
- * \brief Net device set_multicast_list
- * @param netdev network device
+ * liquidio_set_mcast_list - Net device set_multicast_list
+ * @netdev: network device
  */
 static void liquidio_set_mcast_list(struct net_device *netdev)
 {
@@ -1977,8 +1974,9 @@ static void liquidio_set_mcast_list(struct net_device *netdev)
 }
 
 /**
- * \brief Net device set_mac_address
- * @param netdev network device
+ * liquidio_set_mac - Net device set_mac_address
+ * @netdev: network device
+ * @p: pointer to sockaddr
  */
 static int liquidio_set_mac(struct net_device *netdev, void *p)
 {
@@ -2096,10 +2094,9 @@ liquidio_get_stats64(struct net_device *netdev,
 }
 
 /**
- * \brief Handler for SIOCSHWTSTAMP ioctl
- * @param netdev network device
- * @param ifr interface request
- * @param cmd command
+ * hwtstamp_ioctl - Handler for SIOCSHWTSTAMP ioctl
+ * @netdev: network device
+ * @ifr: interface request
  */
 static int hwtstamp_ioctl(struct net_device *netdev, struct ifreq *ifr)
 {
@@ -2154,10 +2151,10 @@ static int hwtstamp_ioctl(struct net_device *netdev, struct ifreq *ifr)
 }
 
 /**
- * \brief ioctl handler
- * @param netdev network device
- * @param ifr interface request
- * @param cmd command
+ * liquidio_ioctl - ioctl handler
+ * @netdev: network device
+ * @ifr: interface request
+ * @cmd: command
  */
 static int liquidio_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 {
@@ -2174,9 +2171,10 @@ static int liquidio_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 }
 
 /**
- * \brief handle a Tx timestamp response
- * @param status response status
- * @param buf pointer to skb
+ * handle_timestamp - handle a Tx timestamp response
+ * @oct: octeon device
+ * @status: response status
+ * @buf: pointer to skb
  */
 static void handle_timestamp(struct octeon_device *oct,
 			     u32 status,
@@ -2217,10 +2215,12 @@ static void handle_timestamp(struct octeon_device *oct,
 	tx_buffer_free(skb);
 }
 
-/* \brief Send a data packet that will be timestamped
- * @param oct octeon device
- * @param ndata pointer to network data
- * @param finfo pointer to private network data
+/**
+ * send_nic_timestamp_pkt - Send a data packet that will be timestamped
+ * @oct: octeon device
+ * @ndata: pointer to network data
+ * @finfo: pointer to private network data
+ * @xmit_more: more is coming
  */
 static inline int send_nic_timestamp_pkt(struct octeon_device *oct,
 					 struct octnic_data_pkt *ndata,
@@ -2276,10 +2276,12 @@ static inline int send_nic_timestamp_pkt(struct octeon_device *oct,
 	return retval;
 }
 
-/** \brief Transmit networks packets to the Octeon interface
- * @param skbuff   skbuff struct to be passed to network layer.
- * @param netdev    pointer to network device
- * @returns whether the packet was transmitted to the device okay or not
+/**
+ * liquidio_xmit - Transmit networks packets to the Octeon interface
+ * @skb: skbuff struct to be passed to network layer.
+ * @netdev: pointer to network device
+ *
+ * Return: whether the packet was transmitted to the device okay or not
  *             (NETDEV_TX_OK or NETDEV_TX_BUSY)
  */
 static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
@@ -2524,8 +2526,10 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
-/** \brief Network device Tx timeout
- * @param netdev    pointer to network device
+/**
+ * liquidio_tx_timeout - Network device Tx timeout
+ * @netdev:    pointer to network device
+ * @txqueue: index of the hung transmit queue
  */
 static void liquidio_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
@@ -2597,12 +2601,12 @@ static int liquidio_vlan_rx_kill_vid(struct net_device *netdev,
 	return ret;
 }
 
-/** Sending command to enable/disable RX checksum offload
- * @param netdev                pointer to network device
- * @param command               OCTNET_CMD_TNL_RX_CSUM_CTL
- * @param rx_cmd_bit            OCTNET_CMD_RXCSUM_ENABLE/
- *                              OCTNET_CMD_RXCSUM_DISABLE
- * @returns                     SUCCESS or FAILURE
+/**
+ * liquidio_set_rxcsum_command - Sending command to enable/disable RX checksum offload
+ * @netdev:                pointer to network device
+ * @command:               OCTNET_CMD_TNL_RX_CSUM_CTL
+ * @rx_cmd:                OCTNET_CMD_RXCSUM_ENABLE/OCTNET_CMD_RXCSUM_DISABLE
+ * Returns:                SUCCESS or FAILURE
  */
 static int liquidio_set_rxcsum_command(struct net_device *netdev, int command,
 				       u8 rx_cmd)
@@ -2632,13 +2636,14 @@ static int liquidio_set_rxcsum_command(struct net_device *netdev, int command,
 	return ret;
 }
 
-/** Sending command to add/delete VxLAN UDP port to firmware
- * @param netdev                pointer to network device
- * @param command               OCTNET_CMD_VXLAN_PORT_CONFIG
- * @param vxlan_port            VxLAN port to be added or deleted
- * @param vxlan_cmd_bit         OCTNET_CMD_VXLAN_PORT_ADD,
+/**
+ * liquidio_vxlan_port_command - Sending command to add/delete VxLAN UDP port to firmware
+ * @netdev:                pointer to network device
+ * @command:               OCTNET_CMD_VXLAN_PORT_CONFIG
+ * @vxlan_port:            VxLAN port to be added or deleted
+ * @vxlan_cmd_bit:         OCTNET_CMD_VXLAN_PORT_ADD,
  *                              OCTNET_CMD_VXLAN_PORT_DEL
- * @returns                     SUCCESS or FAILURE
+ * Return:                     SUCCESS or FAILURE
  */
 static int liquidio_vxlan_port_command(struct net_device *netdev, int command,
 				       u16 vxlan_port, u8 vxlan_cmd_bit)
@@ -2698,10 +2703,11 @@ static const struct udp_tunnel_nic_info liquidio_udp_tunnels = {
 	},
 };
 
-/** \brief Net device fix features
- * @param netdev  pointer to network device
- * @param request features requested
- * @returns updated features list
+/**
+ * liquidio_fix_features - Net device fix features
+ * @netdev:  pointer to network device
+ * @request: features requested
+ * Return: updated features list
  */
 static netdev_features_t liquidio_fix_features(struct net_device *netdev,
 					       netdev_features_t request)
@@ -2737,9 +2743,10 @@ static netdev_features_t liquidio_fix_features(struct net_device *netdev,
 	return request;
 }
 
-/** \brief Net device set features
- * @param netdev  pointer to network device
- * @param features features to enable/disable
+/**
+ * liquidio_set_features - Net device set features
+ * @netdev:  pointer to network device
+ * @features: features to enable/disable
  */
 static int liquidio_set_features(struct net_device *netdev,
 				 netdev_features_t features)
@@ -3224,7 +3231,8 @@ static const struct net_device_ops lionetdevops = {
 	.ndo_get_port_parent_id	= liquidio_get_port_parent_id,
 };
 
-/** \brief Entry point for the liquidio module
+/**
+ * liquidio_init - Entry point for the liquidio module
  */
 static int __init liquidio_init(void)
 {
@@ -3307,8 +3315,8 @@ static int lio_nic_info(struct octeon_recv_info *recv_info, void *buf)
 }
 
 /**
- * \brief Setup network interfaces
- * @param octeon_dev  octeon device
+ * setup_nic_devices - Setup network interfaces
+ * @octeon_dev:  octeon device
  *
  * Called during init time for each device. It assumes the NIC
  * is already up and running.  The link information for each
@@ -3872,8 +3880,8 @@ static int liquidio_enable_sriov(struct pci_dev *dev, int num_vfs)
 #endif
 
 /**
- * \brief initialize the NIC
- * @param oct octeon device
+ * liquidio_init_nic_module - initialize the NIC
+ * @oct: octeon device
  *
  * This initialization routine is called once the Octeon device application is
  * up and running
@@ -3928,9 +3936,10 @@ static int liquidio_init_nic_module(struct octeon_device *oct)
 }
 
 /**
- * \brief starter callback that invokes the remaining initialization work after
- * the NIC is up and running.
- * @param octptr  work struct work_struct
+ * nic_starter - finish init
+ * @work:  work struct work_struct
+ *
+ * starter callback that invokes the remaining initialization work after the NIC is up and running.
  */
 static void nic_starter(struct work_struct *work)
 {
@@ -4023,8 +4032,8 @@ octeon_recv_vf_drv_notice(struct octeon_recv_info *recv_info, void *buf)
 }
 
 /**
- * \brief Device initialization for each Octeon device that is probed
- * @param octeon_dev  octeon device
+ * octeon_device_init - Device initialization for each Octeon device that is probed
+ * @octeon_dev:  octeon device
  */
 static int octeon_device_init(struct octeon_device *octeon_dev)
 {
@@ -4303,11 +4312,11 @@ static int octeon_device_init(struct octeon_device *octeon_dev)
 }
 
 /**
- * \brief Debug console print function
- * @param octeon_dev  octeon device
- * @param console_num console number
- * @param prefix      first portion of line to display
- * @param suffix      second portion of line to display
+ * octeon_dbg_console_print - Debug console print function
+ * @oct:  octeon device
+ * @console_num: console number
+ * @prefix:      first portion of line to display
+ * @suffix:      second portion of line to display
  *
  * The OCTEON debug console outputs entire lines (excluding '\n').
  * Normally, the line will be passed in the 'prefix' parameter.
@@ -4330,7 +4339,7 @@ static int octeon_dbg_console_print(struct octeon_device *oct, u32 console_num,
 }
 
 /**
- * \brief Exits the module
+ * liquidio_exit - Exits the module
  */
 static void __exit liquidio_exit(void)
 {
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 8c5879e31240..103440f97bc8 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -99,8 +99,8 @@ static int lio_wait_for_oq_pkts(struct octeon_device *oct)
 }
 
 /**
- * \brief Cause device to go quiet so it can be safely removed/reset/etc
- * @param oct Pointer to Octeon device
+ * pcierror_quiesce_device - Cause device to go quiet so it can be safely removed/reset/etc
+ * @oct: Pointer to Octeon device
  */
 static void pcierror_quiesce_device(struct octeon_device *oct)
 {
@@ -143,8 +143,8 @@ static void pcierror_quiesce_device(struct octeon_device *oct)
 }
 
 /**
- * \brief Cleanup PCI AER uncorrectable error status
- * @param dev Pointer to PCI device
+ * cleanup_aer_uncorrect_error_status - Cleanup PCI AER uncorrectable error status
+ * @dev: Pointer to PCI device
  */
 static void cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
 {
@@ -163,8 +163,8 @@ static void cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
 }
 
 /**
- * \brief Stop all PCI IO to a given device
- * @param dev Pointer to Octeon device
+ * stop_pci_io - Stop all PCI IO to a given device
+ * @oct: Pointer to Octeon device
  */
 static void stop_pci_io(struct octeon_device *oct)
 {
@@ -205,9 +205,9 @@ static void stop_pci_io(struct octeon_device *oct)
 }
 
 /**
- * \brief called when PCI error is detected
- * @param pdev Pointer to PCI device
- * @param state The current pci connection state
+ * liquidio_pcie_error_detected - called when PCI error is detected
+ * @pdev: Pointer to PCI device
+ * @state: The current pci connection state
  *
  * This function is called after a PCI bus error affecting
  * this device has been detected.
@@ -256,8 +256,8 @@ static struct pci_driver liquidio_vf_pci_driver = {
 };
 
 /**
- * \brief Print link information
- * @param netdev network device
+ * print_link_info - Print link information
+ * @netdev: network device
  */
 static void print_link_info(struct net_device *netdev)
 {
@@ -278,8 +278,8 @@ static void print_link_info(struct net_device *netdev)
 }
 
 /**
- * \brief Routine to notify MTU change
- * @param work work_struct data structure
+ * octnet_link_status_change - Routine to notify MTU change
+ * @work: work_struct data structure
  */
 static void octnet_link_status_change(struct work_struct *work)
 {
@@ -296,8 +296,8 @@ static void octnet_link_status_change(struct work_struct *work)
 }
 
 /**
- * \brief Sets up the mtu status change work
- * @param netdev network device
+ * setup_link_status_change_wq - Sets up the mtu status change work
+ * @netdev: network device
  */
 static int setup_link_status_change_wq(struct net_device *netdev)
 {
@@ -328,9 +328,9 @@ static void cleanup_link_status_change_wq(struct net_device *netdev)
 }
 
 /**
- * \brief Update link status
- * @param netdev network device
- * @param ls link status structure
+ * update_link_status - Update link status
+ * @netdev: network device
+ * @ls: link status structure
  *
  * Called on receipt of a link status response from the core application to
  * update each interface's link status.
@@ -374,13 +374,13 @@ static void update_link_status(struct net_device *netdev,
 }
 
 /**
- * \brief PCI probe handler
- * @param pdev PCI device structure
- * @param ent unused
+ * liquidio_vf_probe - PCI probe handler
+ * @pdev: PCI device structure
+ * @ent: unused
  */
 static int
 liquidio_vf_probe(struct pci_dev *pdev,
-		  const struct pci_device_id *ent __attribute__((unused)))
+		  const struct pci_device_id __maybe_unused *ent)
 {
 	struct octeon_device *oct_dev = NULL;
 
@@ -416,8 +416,8 @@ liquidio_vf_probe(struct pci_dev *pdev,
 }
 
 /**
- * \brief PCI FLR for each Octeon device.
- * @param oct octeon device
+ * octeon_pci_flr - PCI FLR for each Octeon device.
+ * @oct: octeon device
  */
 static void octeon_pci_flr(struct octeon_device *oct)
 {
@@ -437,9 +437,8 @@ static void octeon_pci_flr(struct octeon_device *oct)
 }
 
 /**
- *\brief Destroy resources associated with octeon device
- * @param pdev PCI device structure
- * @param ent unused
+ * octeon_destroy_resources - Destroy resources associated with octeon device
+ * @oct: octeon device
  */
 static void octeon_destroy_resources(struct octeon_device *oct)
 {
@@ -592,9 +591,9 @@ static void octeon_destroy_resources(struct octeon_device *oct)
 }
 
 /**
- * \brief Send Rx control command
- * @param lio per-network private data
- * @param start_stop whether to start or stop
+ * send_rx_ctrl_cmd - Send Rx control command
+ * @lio: per-network private data
+ * @start_stop: whether to start or stop
  */
 static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 {
@@ -644,9 +643,9 @@ static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 }
 
 /**
- * \brief Destroy NIC device interface
- * @param oct octeon device
- * @param ifidx which interface to destroy
+ * liquidio_destroy_nic_device - Destroy NIC device interface
+ * @oct: octeon device
+ * @ifidx: which interface to destroy
  *
  * Cleanup associated with each interface for an Octeon device  when NIC
  * module is being unloaded or if initialization fails during load.
@@ -704,8 +703,8 @@ static void liquidio_destroy_nic_device(struct octeon_device *oct, int ifidx)
 }
 
 /**
- * \brief Stop complete NIC functionality
- * @param oct octeon device
+ * liquidio_stop_nic_module - Stop complete NIC functionality
+ * @oct: octeon device
  */
 static int liquidio_stop_nic_module(struct octeon_device *oct)
 {
@@ -737,8 +736,8 @@ static int liquidio_stop_nic_module(struct octeon_device *oct)
 }
 
 /**
- * \brief Cleans up resources at unload time
- * @param pdev PCI device structure
+ * liquidio_vf_remove - Cleans up resources at unload time
+ * @pdev: PCI device structure
  */
 static void liquidio_vf_remove(struct pci_dev *pdev)
 {
@@ -763,8 +762,8 @@ static void liquidio_vf_remove(struct pci_dev *pdev)
 }
 
 /**
- * \brief PCI initialization for each Octeon device.
- * @param oct octeon device
+ * octeon_pci_os_setup - PCI initialization for each Octeon device.
+ * @oct: octeon device
  */
 static int octeon_pci_os_setup(struct octeon_device *oct)
 {
@@ -792,8 +791,8 @@ static int octeon_pci_os_setup(struct octeon_device *oct)
 }
 
 /**
- * \brief Unmap and free network buffer
- * @param buf buffer
+ * free_netbuf - Unmap and free network buffer
+ * @buf: buffer
  */
 static void free_netbuf(void *buf)
 {
@@ -812,8 +811,8 @@ static void free_netbuf(void *buf)
 }
 
 /**
- * \brief Unmap and free gather buffer
- * @param buf buffer
+ * free_netsgbuf - Unmap and free gather buffer
+ * @buf: buffer
  */
 static void free_netsgbuf(void *buf)
 {
@@ -853,8 +852,8 @@ static void free_netsgbuf(void *buf)
 }
 
 /**
- * \brief Unmap and free gather buffer with response
- * @param buf buffer
+ * free_netsgbuf_with_resp - Unmap and free gather buffer with response
+ * @buf: buffer
  */
 static void free_netsgbuf_with_resp(void *buf)
 {
@@ -897,8 +896,8 @@ static void free_netsgbuf_with_resp(void *buf)
 }
 
 /**
- * \brief Net device open for LiquidIO
- * @param netdev network device
+ * liquidio_open - Net device open for LiquidIO
+ * @netdev: network device
  */
 static int liquidio_open(struct net_device *netdev)
 {
@@ -941,8 +940,8 @@ static int liquidio_open(struct net_device *netdev)
 }
 
 /**
- * \brief Net device stop for LiquidIO
- * @param netdev network device
+ * liquidio_stop - jNet device stop for LiquidIO
+ * @netdev: network device
  */
 static int liquidio_stop(struct net_device *netdev)
 {
@@ -991,8 +990,8 @@ static int liquidio_stop(struct net_device *netdev)
 }
 
 /**
- * \brief Converts a mask based on net device flags
- * @param netdev network device
+ * get_new_flags - Converts a mask based on net device flags
+ * @netdev: network device
  *
  * This routine generates a octnet_ifflags mask from the net device flags
  * received from the OS.
@@ -1060,8 +1059,8 @@ static void liquidio_set_uc_list(struct net_device *netdev)
 }
 
 /**
- * \brief Net device set_multicast_list
- * @param netdev network device
+ * liquidio_set_mcast_list - Net device set_multicast_list
+ * @netdev: network device
  */
 static void liquidio_set_mcast_list(struct net_device *netdev)
 {
@@ -1110,8 +1109,9 @@ static void liquidio_set_mcast_list(struct net_device *netdev)
 }
 
 /**
- * \brief Net device set_mac_address
- * @param netdev network device
+ * liquidio_set_mac - Net device set_mac_address
+ * @netdev: network device
+ * @p: opaque pointer to sockaddr
  */
 static int liquidio_set_mac(struct net_device *netdev, void *p)
 {
@@ -1229,10 +1229,9 @@ liquidio_get_stats64(struct net_device *netdev,
 }
 
 /**
- * \brief Handler for SIOCSHWTSTAMP ioctl
- * @param netdev network device
- * @param ifr interface request
- * @param cmd command
+ * hwtstamp_ioctl - Handler for SIOCSHWTSTAMP ioctl
+ * @netdev: network device
+ * @ifr: interface request
  */
 static int hwtstamp_ioctl(struct net_device *netdev, struct ifreq *ifr)
 {
@@ -1287,10 +1286,10 @@ static int hwtstamp_ioctl(struct net_device *netdev, struct ifreq *ifr)
 }
 
 /**
- * \brief ioctl handler
- * @param netdev network device
- * @param ifr interface request
- * @param cmd command
+ * liquidio_ioctl - ioctl handler
+ * @netdev: network device
+ * @ifr: interface request
+ * @cmd: command
  */
 static int liquidio_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 {
@@ -1339,10 +1338,10 @@ static void handle_timestamp(struct octeon_device *oct, u32 status, void *buf)
 	tx_buffer_free(skb);
 }
 
-/* \brief Send a data packet that will be timestamped
- * @param oct octeon device
- * @param ndata pointer to network data
- * @param finfo pointer to private network data
+/* send_nic_timestamp_pkt - Send a data packet that will be timestamped
+ * @oct: octeon device
+ * @ndata: pointer to network data
+ * @finfo: pointer to private network data
  */
 static int send_nic_timestamp_pkt(struct octeon_device *oct,
 				  struct octnic_data_pkt *ndata,
@@ -1393,9 +1392,10 @@ static int send_nic_timestamp_pkt(struct octeon_device *oct,
 	return retval;
 }
 
-/** \brief Transmit networks packets to the Octeon interface
- * @param skbuff   skbuff struct to be passed to network layer.
- * @param netdev   pointer to network device
+/**
+ * liquidio_xmit - Transmit networks packets to the Octeon interface
+ * @skb: skbuff struct to be passed to network layer.
+ * @netdev: pointer to network device
  * @returns whether the packet was transmitted to the device okay or not
  *             (NETDEV_TX_OK or NETDEV_TX_BUSY)
  */
@@ -1623,8 +1623,10 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
-/** \brief Network device Tx timeout
- * @param netdev    pointer to network device
+/**
+ * liquidio_tx_timeout - Network device Tx timeout
+ * @netdev: pointer to network device
+ * @txqueue: index of the hung transmit queue
  */
 static void liquidio_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
@@ -1917,8 +1919,8 @@ static int lio_nic_info(struct octeon_recv_info *recv_info, void *buf)
 }
 
 /**
- * \brief Setup network interfaces
- * @param octeon_dev  octeon device
+ * setup_nic_devices - Setup network interfaces
+ * @octeon_dev:  octeon device
  *
  * Called during init time for each device. It assumes the NIC
  * is already up and running.  The link information for each
@@ -2229,8 +2231,8 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 }
 
 /**
- * \brief initialize the NIC
- * @param oct octeon device
+ * liquidio_init_nic_module - initialize the NIC
+ * @oct: octeon device
  *
  * This initialization routine is called once the Octeon device application is
  * up and running
@@ -2270,8 +2272,8 @@ static int liquidio_init_nic_module(struct octeon_device *oct)
 }
 
 /**
- * \brief Device initialization for each Octeon device that is probed
- * @param octeon_dev  octeon device
+ * octeon_device_init - Device initialization for each Octeon device that is probed
+ * @oct:  octeon device
  */
 static int octeon_device_init(struct octeon_device *oct)
 {
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_console.c b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
index 0d2831d10f65..28feabec8fbb 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_console.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
@@ -15,7 +15,7 @@
  * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, TITLE, or
  * NONINFRINGEMENT.  See the GNU General Public License for more details.
  ***********************************************************************/
-/**
+/*
  * @file octeon_console.c
  */
 #include <linux/moduleparam.h>
@@ -131,7 +131,7 @@ struct octeon_pci_console_desc {
 	/* Implicit storage for console_addr_array */
 };
 
-/**
+/*
  * This function is the implementation of the get macros defined
  * for individual structure members. The argument are generated
  * by the macros inorder to read only the needed memory.
@@ -160,7 +160,7 @@ static inline u64 __cvmx_bootmem_desc_get(struct octeon_device *oct,
 	}
 }
 
-/**
+/*
  * This function retrieves the string name of a named block. It is
  * more complicated than a simple memcpy() since the named block
  * descriptor may not be directly accessible.
@@ -182,7 +182,7 @@ static void CVMX_BOOTMEM_NAMED_GET_NAME(struct octeon_device *oct,
 
 /* See header file for descriptions of functions */
 
-/**
+/*
  * Check the version information on the bootmem descriptor
  *
  * @param exact_match
@@ -323,7 +323,7 @@ static u64 cvmx_bootmem_phy_named_block_find(struct octeon_device *oct,
 	return result;
 }
 
-/**
+/*
  * Find a named block on the remote Octeon
  *
  * @param name      Name of block to find
@@ -707,7 +707,7 @@ int octeon_add_console(struct octeon_device *oct, u32 console_num,
 	return ret;
 }
 
-/**
+/*
  * Removes all consoles
  *
  * @param oct         octeon device
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.c b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
index fbde7c58c4db..387a57cbfb73 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
@@ -1307,7 +1307,7 @@ struct octeon_config *octeon_get_conf(struct octeon_device *oct)
 /* scratch register address is same in all the OCT-II and CN70XX models */
 #define CNXX_SLI_SCRATCH1   0x3C0
 
-/** Get the octeon device pointer.
+/* Get the octeon device pointer.
  *  @param octeon_id  - The id for which the octeon device pointer is required.
  *  @return Success: Octeon device pointer.
  *  @return Failure: NULL.
@@ -1410,7 +1410,7 @@ int octeon_wait_for_ddr_init(struct octeon_device *oct, u32 *timeout)
 	return ret;
 }
 
-/** Get the octeon id assigned to the octeon device passed as argument.
+/* Get the octeon id assigned to the octeon device passed as argument.
  *  This function is exported to other modules.
  *  @param dev - octeon device pointer passed as a void *.
  *  @return octeon device id
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_droq.c b/drivers/net/ethernet/cavium/liquidio/octeon_droq.c
index cf4fe5b17f8a..d4080bddcb6b 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_droq.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_droq.c
@@ -774,7 +774,7 @@ octeon_droq_process_packets(struct octeon_device *oct,
 	return 0;
 }
 
-/**
+/*
  * Utility function to poll for packets. check_hw_for_packets must be
  * called before calling this routine.
  */
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c b/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c
index 614d07be7181..ad685f5d0a13 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c
@@ -28,7 +28,7 @@
 
 /**
  * octeon_mbox_read:
- * @oct: Pointer mailbox
+ * @mbox: Pointer mailbox
  *
  * Reads the 8-bytes of data from the mbox register
  * Writes back the acknowldgement inidcating completion of read
@@ -285,7 +285,8 @@ static int octeon_mbox_process_cmd(struct octeon_mbox *mbox,
 }
 
 /**
- *octeon_mbox_process_message:
+ * octeon_mbox_process_message
+ * @mbox: mailbox
  *
  * Process the received mbox message.
  */
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 387c357e1b8e..6ed58bc12020 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -148,7 +148,7 @@ struct workqueue_struct *cxgb3_wq;
 
 /**
  *	link_report - show link status and link speed/duplex
- *	@p: the port whose settings are to be reported
+ *	@dev: the port whose settings are to be reported
  *
  *	Shows the link status, speed, and duplex of a port.
  */
@@ -304,8 +304,8 @@ void t3_os_link_changed(struct adapter *adapter, int port_id, int link_stat,
 
 /**
  *	t3_os_phymod_changed - handle PHY module changes
- *	@phy: the PHY reporting the module change
- *	@mod_type: new module type
+ *	@adap: the adapter associated with the link change
+ *	@port_id: the port index whose limk status has changed
  *
  *	This is the OS-dependent handler for PHY module changes.  It is
  *	invoked when a PHY module is removed or inserted for any OS-specific
@@ -1200,7 +1200,7 @@ static void cxgb_vlan_mode(struct net_device *dev, netdev_features_t features)
 
 /**
  *	cxgb_up - enable the adapter
- *	@adapter: adapter being enabled
+ *	@adap: adapter being enabled
  *
  *	Called when the first port is enabled, this function performs the
  *	actions necessary to make an adapter operational, such as completing
diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index a978a00acc1e..5bb3f0cb36ed 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -372,7 +372,7 @@ static void clear_rx_desc(struct pci_dev *pdev, const struct sge_fl *q,
 /**
  *	free_rx_bufs - free the Rx buffers on an SGE free list
  *	@pdev: the PCI device associated with the adapter
- *	@rxq: the SGE free list to clean up
+ *	@q: the SGE free list to clean up
  *
  *	Release the buffers on an SGE free-buffer Rx queue.  HW fetching from
  *	this queue should be stopped before calling this function.
@@ -493,7 +493,7 @@ static inline void ring_fl_db(struct adapter *adap, struct sge_fl *q)
 
 /**
  *	refill_fl - refill an SGE free-buffer list
- *	@adapter: the adapter
+ *	@adap: the adapter
  *	@q: the free-list to refill
  *	@n: the number of new buffers to allocate
  *	@gfp: the gfp flags for allocating new buffers
@@ -568,7 +568,7 @@ static inline void __refill_fl(struct adapter *adap, struct sge_fl *fl)
 
 /**
  *	recycle_rx_buf - recycle a receive buffer
- *	@adapter: the adapter
+ *	@adap: the adapter
  *	@q: the SGE free list
  *	@idx: index of buffer to recycle
  *
@@ -825,6 +825,7 @@ static struct sk_buff *get_packet(struct adapter *adap, struct sge_fl *fl,
  *	get_packet_pg - return the next ingress packet buffer from a free list
  *	@adap: the adapter that received the packet
  *	@fl: the SGE free list holding the packet
+ *	@q: the queue
  *	@len: the packet length including any SGE padding
  *	@drop_thres: # of remaining buffers before we start dropping packets
  *
@@ -1173,6 +1174,7 @@ static void write_wr_hdr_sgl(unsigned int ndesc, struct sk_buff *skb,
  *	@q: the Tx queue
  *	@ndesc: number of descriptors the packet will occupy
  *	@compl: the value of the COMPL bit to use
+ *	@addr: address
  *
  *	Generate a TX_PKT work request to send the supplied packet.
  */
@@ -1622,6 +1624,7 @@ static void setup_deferred_unmapping(struct sk_buff *skb, struct pci_dev *pdev,
  *	@pidx: index of the first Tx descriptor to write
  *	@gen: the generation value to use
  *	@ndesc: number of descriptors the packet will occupy
+ *	@addr: the address
  *
  *	Write an offload work request to send the supplied packet.  The packet
  *	data already carry the work request with most fields populated.
@@ -1883,7 +1886,7 @@ static inline void deliver_partial_bundle(struct t3cdev *tdev,
 
 /**
  *	ofld_poll - NAPI handler for offload packets in interrupt mode
- *	@dev: the network device doing the polling
+ *	@napi: the network device doing the polling
  *	@budget: polling budget
  *
  *	The NAPI handler for offload packets when a response queue is serviced
@@ -2007,7 +2010,7 @@ static void restart_tx(struct sge_qset *qs)
 
 /**
  *	cxgb3_arp_process - process an ARP request probing a private IP address
- *	@adapter: the adapter
+ *	@pi: the port info
  *	@skb: the skbuff containing the ARP request
  *
  *	Check if the ARP request is probing the private IP address
@@ -2069,7 +2072,8 @@ static void cxgb3_process_iscsi_prov_pack(struct port_info *pi,
  *	@adap: the adapter
  *	@rq: the response queue that received the packet
  *	@skb: the packet
- *	@pad: amount of padding at the start of the buffer
+ *	@pad: padding
+ *	@lro: large receive offload
  *
  *	Process an ingress ethernet pakcet and deliver it to the stack.
  *	The padding is 2 if the packet was delivered in an Rx buffer and 0
@@ -2239,7 +2243,7 @@ static inline void handle_rsp_cntrl_info(struct sge_qset *qs, u32 flags)
 
 /**
  *	check_ring_db - check if we need to ring any doorbells
- *	@adapter: the adapter
+ *	@adap: the adapter
  *	@qs: the queue set whose Tx queues are to be examined
  *	@sleeping: indicates which Tx queue sent GTS
  *
@@ -2899,7 +2903,7 @@ void t3_sge_err_intr_handler(struct adapter *adapter)
 
 /**
  *	sge_timer_tx - perform periodic maintenance of an SGE qset
- *	@data: the SGE queue set to maintain
+ *	@t: a timer list containing the SGE queue set to maintain
  *
  *	Runs periodically from a timer to perform maintenance of an SGE queue
  *	set.  It performs two tasks:
@@ -2943,7 +2947,7 @@ static void sge_timer_tx(struct timer_list *t)
 
 /**
  *	sge_timer_rx - perform periodic maintenance of an SGE qset
- *	@data: the SGE queue set to maintain
+ *	@t: the timer list containing the SGE queue set to maintain
  *
  *	a) Replenishes Rx queues that have run out due to memory shortage.
  *	Normally new Rx buffers are added when existing ones are consumed but
@@ -3021,7 +3025,7 @@ void t3_update_qset_coalesce(struct sge_qset *qs, const struct qset_params *p)
  *	@irq_vec_idx: the IRQ vector index for response queue interrupts
  *	@p: configuration parameters for this queue set
  *	@ntxq: number of Tx queues for the queue set
- *	@netdev: net device associated with this queue set
+ *	@dev: net device associated with this queue set
  *	@netdevq: net device TX queue associated with this queue set
  *
  *	Allocate resources and initialize an SGE queue set.  A queue set
diff --git a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
index 311fed38c101..7ff31d1026fb 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
@@ -2484,6 +2484,7 @@ int t3_sge_disable_cqcntxt(struct adapter *adapter, unsigned int id)
  *	@adapter: the adapter
  *	@id: the context id
  *	@op: the operation to perform
+ *	@credits: credit value to write
  *
  *	Perform the selected operation on an SGE completion queue context.
  *	The caller is responsible for ensuring only one context operation
@@ -2885,7 +2886,7 @@ static void init_cong_ctrl(unsigned short *a, unsigned short *b)
  *	t3_load_mtus - write the MTU and congestion control HW tables
  *	@adap: the adapter
  *	@mtus: the unrestricted values for the MTU table
- *	@alphs: the values for the congestion control alpha parameter
+ *	@alpha: the values for the congestion control alpha parameter
  *	@beta: the values for the congestion control beta parameter
  *	@mtu_cap: the maximum permitted effective MTU
  *
@@ -3483,7 +3484,7 @@ static void get_pci_mode(struct adapter *adapter, struct pci_params *p)
 /**
  *	init_link_config - initialize a link's SW state
  *	@lc: structure holding the link state
- *	@ai: information about the current card
+ *	@caps: information about the current card
  *
  *	Initializes the SW state maintained for each link, including the link's
  *	capabilities and default speed/duplex/flow-control/autonegotiation
diff --git a/drivers/net/ethernet/cisco/enic/enic_api.c b/drivers/net/ethernet/cisco/enic/enic_api.c
index b161f24522b8..89915681473c 100644
--- a/drivers/net/ethernet/cisco/enic/enic_api.c
+++ b/drivers/net/ethernet/cisco/enic/enic_api.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright 2013 Cisco Systems, Inc.  All rights reserved.
  *
  * This program is free software; you may redistribute it and/or modify
diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index 4d8e0aa447fb..a4dd52bba2c3 100644
--- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
+++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright 2013 Cisco Systems, Inc.  All rights reserved.
  *
  * This program is free software; you may redistribute it and/or modify
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 07e9dee03c98..8df6f081f244 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -85,6 +85,8 @@ MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 
 /**
  * struct gmac_queue_page - page buffer per-page info
+ * @page: the page struct
+ * @mapping: the dma address handle
  */
 struct gmac_queue_page {
 	struct page *page;
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index a817ca661c1f..0981fe9652e5 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -177,6 +177,7 @@ MODULE_PARM_DESC(buffer_size, "DMA buffer allocation size");
  * struct ethoc - driver-private device structure
  * @iobase:	pointer to I/O memory region
  * @membase:	pointer to buffer memory region
+ * @big_endian: just big or little (endian)
  * @num_bd:	number of buffer descriptors
  * @num_tx:	number of send buffers
  * @cur_tx:	last send buffer written
@@ -189,7 +190,10 @@ MODULE_PARM_DESC(buffer_size, "DMA buffer allocation size");
  * @msg_enable:	device state flags
  * @lock:	device lock
  * @mdio:	MDIO bus for PHY access
+ * @clk:	clock
  * @phy_id:	address of attached PHY
+ * @old_link:	previous link info
+ * @old_duplex: previous duplex info
  */
 struct ethoc {
 	void __iomem *iobase;
@@ -1015,7 +1019,7 @@ static const struct net_device_ops ethoc_netdev_ops = {
 
 /**
  * ethoc_probe - initialize OpenCores ethernet MAC
- * pdev:	platform device
+ * @pdev:	platform device
  */
 static int ethoc_probe(struct platform_device *pdev)
 {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 5bc965186f8c..32677521504c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1344,7 +1344,7 @@ static int dpaa2_eth_seed_pool(struct dpaa2_eth_priv *priv, u16 bpid)
 	return 0;
 }
 
-/**
+/*
  * Drain the specified number of buffers from the DPNI's private buffer pool.
  * @count must not exceeed DPAA2_ETH_BUFS_PER_CMD
  */
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 0405a3975f3f..2e344aada4c6 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -512,7 +512,7 @@ int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr)
 		-EFAULT : 0;
 }
 
-/**
+/*
  * fec_time_keep - call timecounter_read every second to avoid timer overrun
  *                 because ENET just support 32bit counter, will timeout in 4s
  */
@@ -566,7 +566,8 @@ static irqreturn_t fec_pps_interrupt(int irq, void *dev_id)
 
 /**
  * fec_ptp_init
- * @ndev: The FEC network adapter
+ * @pdev: The FEC network adapter
+ * @irq_idx: the interrupt index
  *
  * This function performs the required steps for enabling ptp
  * support. If ptp support has already been loaded it simply calls the
diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ethernet/freescale/fman/fman.c
index ef67e8599b39..ce0a121580f6 100644
--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -2063,11 +2063,11 @@ static int fman_set_exception(struct fman *fman,
 /**
  * fman_register_intr
  * @fman:	A Pointer to FMan device
- * @mod:	Calling module
+ * @module:	Calling module
  * @mod_id:	Module id (if more than 1 exists, '0' if not)
  * @intr_type:	Interrupt type (error/normal) selection.
- * @f_isr:	The interrupt service routine.
- * @h_src_arg:	Argument to be passed to f_isr.
+ * @isr_cb:	The interrupt service routine.
+ * @src_arg:	Argument to be passed to isr_cb.
  *
  * Used to register an event handler to be processed by FMan
  *
@@ -2091,7 +2091,7 @@ EXPORT_SYMBOL(fman_register_intr);
 /**
  * fman_unregister_intr
  * @fman:	A Pointer to FMan device
- * @mod:	Calling module
+ * @module:	Calling module
  * @mod_id:	Module id (if more than 1 exists, '0' if not)
  * @intr_type:	Interrupt type (error/normal) selection.
  *
@@ -2342,8 +2342,8 @@ EXPORT_SYMBOL(fman_get_bmi_max_fifo_size);
 
 /**
  * fman_get_revision
- * @fman		- Pointer to the FMan module
- * @rev_info		- A structure of revision information parameters.
+ * @fman:		- Pointer to the FMan module
+ * @rev_info:		- A structure of revision information parameters.
  *
  * Returns the FM revision
  *
@@ -2508,7 +2508,7 @@ EXPORT_SYMBOL(fman_get_rx_extra_headroom);
 
 /**
  * fman_bind
- * @dev:	FMan OF device pointer
+ * @fm_dev:	FMan OF device pointer
  *
  * Bind to a specific FMan device.
  *
diff --git a/drivers/net/ethernet/freescale/fman/fman_muram.c b/drivers/net/ethernet/freescale/fman/fman_muram.c
index 5ec94d243da0..7ad317e622bc 100644
--- a/drivers/net/ethernet/freescale/fman/fman_muram.c
+++ b/drivers/net/ethernet/freescale/fman/fman_muram.c
@@ -144,9 +144,9 @@ unsigned long fman_muram_alloc(struct muram_info *muram, size_t size)
 
 /**
  * fman_muram_free_mem
- * muram:	FM-MURAM module pointer.
- * offset:	offset of the memory region to be freed.
- * size:	size of the memory to be freed.
+ * @muram:	FM-MURAM module pointer.
+ * @offset:	offset of the memory region to be freed.
+ * @size:	size of the memory to be freed.
  *
  * Free an allocated memory from FM-MURAM partition.
  */
diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index 624b2eb6f01d..d9baac0dbc7d 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -1410,9 +1410,11 @@ int fman_port_config(struct fman_port *port, struct fman_port_params *params)
 }
 EXPORT_SYMBOL(fman_port_config);
 
-/**
+/*
  * fman_port_use_kg_hash
- * port:        A pointer to a FM Port module.
+ * @port: A pointer to a FM Port module.
+ * @enable: enable or disable
+ *
  * Sets the HW KeyGen or the BMI as HW Parser next engine, enabling
  * or bypassing the KeyGen hashing of Rx traffic
  */
@@ -1430,7 +1432,8 @@ EXPORT_SYMBOL(fman_port_use_kg_hash);
 
 /**
  * fman_port_init
- * port:	A pointer to a FM Port module.
+ * @port:	A pointer to a FM Port module.
+ *
  * Initializes the FM PORT module by defining the software structure and
  * configuring the hardware registers.
  *
@@ -1524,8 +1527,8 @@ EXPORT_SYMBOL(fman_port_init);
 
 /**
  * fman_port_cfg_buf_prefix_content
- * @port			A pointer to a FM Port module.
- * @buffer_prefix_content	A structure of parameters describing
+ * @port:			A pointer to a FM Port module.
+ * @buffer_prefix_content:	A structure of parameters describing
  *				the structure of the buffer.
  *				Out parameter:
  *				Start margin - offset of data from
@@ -1570,7 +1573,7 @@ EXPORT_SYMBOL(fman_port_cfg_buf_prefix_content);
 
 /**
  * fman_port_disable
- * port:	A pointer to a FM Port module.
+ * @port:	A pointer to a FM Port module.
  *
  * Gracefully disable an FM port. The port will not start new	tasks after all
  * tasks associated with the port are terminated.
@@ -1651,7 +1654,7 @@ EXPORT_SYMBOL(fman_port_disable);
 
 /**
  * fman_port_enable
- * port:	A pointer to a FM Port module.
+ * @port:	A pointer to a FM Port module.
  *
  * A runtime routine provided to allow disable/enable of port.
  *
@@ -1697,7 +1700,7 @@ EXPORT_SYMBOL(fman_port_enable);
 
 /**
  * fman_port_bind
- * dev:		FMan Port OF device pointer
+ * @dev:		FMan Port OF device pointer
  *
  * Bind to a specific FMan Port.
  *
@@ -1713,7 +1716,7 @@ EXPORT_SYMBOL(fman_port_bind);
 
 /**
  * fman_port_get_qman_channel_id
- * port:	Pointer to the FMan port devuce
+ * @port:	Pointer to the FMan port devuce
  *
  * Get the QMan channel ID for the specific port
  *
@@ -1727,7 +1730,7 @@ EXPORT_SYMBOL(fman_port_get_qman_channel_id);
 
 /**
  * fman_port_get_device
- * port:	Pointer to the FMan port device
+ * @port:	Pointer to the FMan port device
  *
  * Get the 'struct device' associated to the specified FMan port device
  *
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 43427c5b9396..901749a7a318 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -359,8 +359,8 @@ EXPORT_SYMBOL(fman_set_mac_active_pause);
 /**
  * fman_get_pause_cfg
  * @mac_dev:	A pointer to the MAC device
- * @rx:		Return value for RX setting
- * @tx:		Return value for TX setting
+ * @rx_pause:	Return value for RX setting
+ * @tx_pause:	Return value for TX setting
  *
  * Determine the MAC RX/TX PAUSE frames settings based on PHY
  * autonegotiation or values set by eththool.
diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.c b/drivers/net/ethernet/hisilicon/hns/hnae.c
index e017b7c34140..00fafc0f8512 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.c
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
@@ -270,7 +270,7 @@ static void hnae_fini_queue(struct hnae_queue *q)
 	hnae_fini_ring(&q->rx_ring);
 }
 
-/**
+/*
  * ae_chain - define ae chain head
  */
 static RAW_NOTIFIER_HEAD(ae_chain);
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
index 9a907947ba19..4a448138b4ec 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -374,11 +374,12 @@ static void hns_mac_param_get(struct mac_params *param,
 }
 
 /**
- *hns_mac_queue_config_bc_en - set broadcast rx&tx enable
- *@mac_cb: mac device
- *@queue: queue number
- *@en:enable
- *retuen 0 - success , negative --fail
+ * hns_mac_queue_config_bc_en - set broadcast rx&tx enable
+ * @mac_cb: mac device
+ * @port_num: queue number
+ * @vlan_id: vlan id`
+ * @enable: enable
+ * return 0 - success , negative --fail
  */
 static int hns_mac_port_config_bc_en(struct hns_mac_cb *mac_cb,
 				     u32 port_num, u16 vlan_id, bool enable)
@@ -408,11 +409,11 @@ static int hns_mac_port_config_bc_en(struct hns_mac_cb *mac_cb,
 }
 
 /**
- *hns_mac_vm_config_bc_en - set broadcast rx&tx enable
- *@mac_cb: mac device
- *@vmid: vm id
- *@en:enable
- *retuen 0 - success , negative --fail
+ * hns_mac_vm_config_bc_en - set broadcast rx&tx enable
+ * @mac_cb: mac device
+ * @vmid: vm id
+ * @enable: enable
+ * return 0 - success , negative --fail
  */
 int hns_mac_vm_config_bc_en(struct hns_mac_cb *mac_cb, u32 vmid, bool enable)
 {
@@ -542,8 +543,8 @@ void hns_mac_stop(struct hns_mac_cb *mac_cb)
 /**
  * hns_mac_get_autoneg - get auto autonegotiation
  * @mac_cb: mac control block
- * @enable: enable or not
- * retuen 0 - success , negative --fail
+ * @auto_neg: output pointer to autoneg result
+ * return 0 - success , negative --fail
  */
 void hns_mac_get_autoneg(struct hns_mac_cb *mac_cb, u32 *auto_neg)
 {
@@ -560,7 +561,7 @@ void hns_mac_get_autoneg(struct hns_mac_cb *mac_cb, u32 *auto_neg)
  * @mac_cb: mac control block
  * @rx_en: rx enable status
  * @tx_en: tx enable status
- * retuen 0 - success , negative --fail
+ * return 0 - success , negative --fail
  */
 void hns_mac_get_pauseparam(struct hns_mac_cb *mac_cb, u32 *rx_en, u32 *tx_en)
 {
@@ -578,7 +579,7 @@ void hns_mac_get_pauseparam(struct hns_mac_cb *mac_cb, u32 *rx_en, u32 *tx_en)
  * hns_mac_set_autoneg - set auto autonegotiation
  * @mac_cb: mac control block
  * @enable: enable or not
- * retuen 0 - success , negative --fail
+ * return 0 - success , negative --fail
  */
 int hns_mac_set_autoneg(struct hns_mac_cb *mac_cb, u8 enable)
 {
@@ -623,7 +624,7 @@ int hns_mac_set_pauseparam(struct hns_mac_cb *mac_cb, u32 rx_en, u32 tx_en)
 /**
  * hns_mac_init_ex - mac init
  * @mac_cb: mac control block
- * retuen 0 - success , negative --fail
+ * return 0 - success , negative --fail
  */
 static int hns_mac_init_ex(struct hns_mac_cb *mac_cb)
 {
@@ -800,7 +801,6 @@ static const struct {
 /**
  *hns_mac_get_info  - get mac information from device node
  *@mac_cb: mac device
- *@np:device node
  * return: 0 --success, negative --fail
  */
 static int hns_mac_get_info(struct hns_mac_cb *mac_cb)
@@ -951,7 +951,7 @@ static int hns_mac_get_info(struct hns_mac_cb *mac_cb)
 /**
  * hns_mac_get_mode - get mac mode
  * @phy_if: phy interface
- * retuen 0 - gmac, 1 - xgmac , negative --fail
+ * return 0 - gmac, 1 - xgmac , negative --fail
  */
 static int hns_mac_get_mode(phy_interface_t phy_if)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
index acfa86e5296f..87d3db4666df 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
@@ -207,7 +207,7 @@ static int hns_dsaf_get_cfg(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_sbm_link_sram_init_en - config dsaf_sbm_init_en
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_sbm_link_sram_init_en(struct dsaf_device *dsaf_dev)
 {
@@ -216,8 +216,8 @@ static void hns_dsaf_sbm_link_sram_init_en(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_reg_cnt_clr_ce - config hns_dsaf_reg_cnt_clr_ce
- * @dsaf_id: dsa fabric id
- * @hns_dsaf_reg_cnt_clr_ce: config value
+ * @dsaf_dev: dsa fabric id
+ * @reg_cnt_clr_ce: config value
  */
 static void
 hns_dsaf_reg_cnt_clr_ce(struct dsaf_device *dsaf_dev, u32 reg_cnt_clr_ce)
@@ -228,8 +228,8 @@ hns_dsaf_reg_cnt_clr_ce(struct dsaf_device *dsaf_dev, u32 reg_cnt_clr_ce)
 
 /**
  * hns_ppe_qid_cfg - config ppe qid
- * @dsaf_id: dsa fabric id
- * @pppe_qid_cfg: value array
+ * @dsaf_dev: dsa fabric id
+ * @qid_cfg: value array
  */
 static void
 hns_dsaf_ppe_qid_cfg(struct dsaf_device *dsaf_dev, u32 qid_cfg)
@@ -285,8 +285,8 @@ static void hns_dsaf_inner_qid_cfg(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_sw_port_type_cfg - cfg sw type
- * @dsaf_id: dsa fabric id
- * @psw_port_type: array
+ * @dsaf_dev: dsa fabric id
+ * @port_type: array
  */
 static void hns_dsaf_sw_port_type_cfg(struct dsaf_device *dsaf_dev,
 				      enum dsaf_sw_port_type port_type)
@@ -303,8 +303,8 @@ static void hns_dsaf_sw_port_type_cfg(struct dsaf_device *dsaf_dev,
 
 /**
  * hns_dsaf_stp_port_type_cfg - cfg stp type
- * @dsaf_id: dsa fabric id
- * @pstp_port_type: array
+ * @dsaf_dev: dsa fabric id
+ * @port_type: array
  */
 static void hns_dsaf_stp_port_type_cfg(struct dsaf_device *dsaf_dev,
 				       enum dsaf_stp_port_type port_type)
@@ -323,7 +323,7 @@ static void hns_dsaf_stp_port_type_cfg(struct dsaf_device *dsaf_dev,
 	(AE_IS_VER1((dev)->dsaf_ver) ? DSAF_SBM_NUM : DSAFV2_SBM_NUM)
 /**
  * hns_dsaf_sbm_cfg - config sbm
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_sbm_cfg(struct dsaf_device *dsaf_dev)
 {
@@ -342,7 +342,7 @@ static void hns_dsaf_sbm_cfg(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_sbm_cfg_mib_en - config sbm
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static int hns_dsaf_sbm_cfg_mib_en(struct dsaf_device *dsaf_dev)
 {
@@ -387,7 +387,7 @@ static int hns_dsaf_sbm_cfg_mib_en(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_sbm_bp_wl_cfg - config sbm
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_sbm_bp_wl_cfg(struct dsaf_device *dsaf_dev)
 {
@@ -556,7 +556,7 @@ static void hns_dsafv2_sbm_bp_wl_cfg(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_voq_bp_all_thrd_cfg -  voq
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_voq_bp_all_thrd_cfg(struct dsaf_device *dsaf_dev)
 {
@@ -599,7 +599,7 @@ static void hns_dsaf_tbl_tcam_match_cfg(
 
 /**
  * hns_dsaf_tbl_tcam_data_cfg - tbl
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  * @ptbl_tcam_data: addr
  */
 static void hns_dsaf_tbl_tcam_data_cfg(
@@ -614,8 +614,8 @@ static void hns_dsaf_tbl_tcam_data_cfg(
 
 /**
  * dsaf_tbl_tcam_mcast_cfg - tbl
- * @dsaf_id: dsa fabric id
- * @ptbl_tcam_mcast: addr
+ * @dsaf_dev: dsa fabric id
+ * @mcast: addr
  */
 static void hns_dsaf_tbl_tcam_mcast_cfg(
 	struct dsaf_device *dsaf_dev,
@@ -648,8 +648,8 @@ static void hns_dsaf_tbl_tcam_mcast_cfg(
 
 /**
  * hns_dsaf_tbl_tcam_ucast_cfg - tbl
- * @dsaf_id: dsa fabric id
- * @ptbl_tcam_ucast: addr
+ * @dsaf_dev: dsa fabric id
+ * @tbl_tcam_ucast: addr
  */
 static void hns_dsaf_tbl_tcam_ucast_cfg(
 	struct dsaf_device *dsaf_dev,
@@ -674,8 +674,8 @@ static void hns_dsaf_tbl_tcam_ucast_cfg(
 
 /**
  * hns_dsaf_tbl_line_cfg - tbl
- * @dsaf_id: dsa fabric id
- * @ptbl_lin: addr
+ * @dsaf_dev: dsa fabric id
+ * @tbl_lin: addr
  */
 static void hns_dsaf_tbl_line_cfg(struct dsaf_device *dsaf_dev,
 				  struct dsaf_tbl_line_cfg *tbl_lin)
@@ -695,7 +695,7 @@ static void hns_dsaf_tbl_line_cfg(struct dsaf_device *dsaf_dev,
 
 /**
  * hns_dsaf_tbl_tcam_mcast_pul - tbl
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_tbl_tcam_mcast_pul(struct dsaf_device *dsaf_dev)
 {
@@ -710,7 +710,7 @@ static void hns_dsaf_tbl_tcam_mcast_pul(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_tbl_line_pul - tbl
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_tbl_line_pul(struct dsaf_device *dsaf_dev)
 {
@@ -725,7 +725,7 @@ static void hns_dsaf_tbl_line_pul(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_tbl_tcam_data_mcast_pul - tbl
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_tbl_tcam_data_mcast_pul(
 	struct dsaf_device *dsaf_dev)
@@ -743,7 +743,7 @@ static void hns_dsaf_tbl_tcam_data_mcast_pul(
 
 /**
  * hns_dsaf_tbl_tcam_data_ucast_pul - tbl
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_tbl_tcam_data_ucast_pul(
 	struct dsaf_device *dsaf_dev)
@@ -768,8 +768,7 @@ void hns_dsaf_set_promisc_mode(struct dsaf_device *dsaf_dev, u32 en)
 
 /**
  * hns_dsaf_tbl_stat_en - tbl
- * @dsaf_id: dsa fabric id
- * @ptbl_stat_en: addr
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_tbl_stat_en(struct dsaf_device *dsaf_dev)
 {
@@ -785,7 +784,7 @@ static void hns_dsaf_tbl_stat_en(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_rocee_bp_en - rocee back press enable
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_rocee_bp_en(struct dsaf_device *dsaf_dev)
 {
@@ -852,9 +851,9 @@ static void hns_dsaf_int_tbl_src_clr(struct dsaf_device *dsaf_dev,
 
 /**
  * hns_dsaf_single_line_tbl_cfg - INT
- * @dsaf_id: dsa fabric id
- * @address:
- * @ptbl_line:
+ * @dsaf_dev: dsa fabric id
+ * @address: the address
+ * @ptbl_line: the line
  */
 static void hns_dsaf_single_line_tbl_cfg(
 	struct dsaf_device *dsaf_dev,
@@ -876,9 +875,10 @@ static void hns_dsaf_single_line_tbl_cfg(
 
 /**
  * hns_dsaf_tcam_uc_cfg - INT
- * @dsaf_id: dsa fabric id
- * @address,
- * @ptbl_tcam_data,
+ * @dsaf_dev: dsa fabric id
+ * @address: the address
+ * @ptbl_tcam_data: the data
+ * @ptbl_tcam_ucast: unicast
  */
 static void hns_dsaf_tcam_uc_cfg(
 	struct dsaf_device *dsaf_dev, u32 address,
@@ -904,7 +904,8 @@ static void hns_dsaf_tcam_uc_cfg(
  * @dsaf_dev: dsa fabric device struct pointer
  * @address: tcam index
  * @ptbl_tcam_data: tcam data struct pointer
- * @ptbl_tcam_mcast: tcam mask struct pointer, it must be null for HNSv1
+ * @ptbl_tcam_mask: tcam mask struct pointer, it must be null for HNSv1
+ * @ptbl_tcam_mcast: tcam data struct pointer
  */
 static void hns_dsaf_tcam_mc_cfg(
 	struct dsaf_device *dsaf_dev, u32 address,
@@ -933,8 +934,10 @@ static void hns_dsaf_tcam_mc_cfg(
 /**
  * hns_dsaf_tcam_uc_cfg_vague - INT
  * @dsaf_dev: dsa fabric device struct pointer
- * @address,
- * @ptbl_tcam_data,
+ * @address: the address
+ * @tcam_data: the data
+ * @tcam_mask: the mask
+ * @tcam_uc: the unicast data
  */
 static void hns_dsaf_tcam_uc_cfg_vague(struct dsaf_device *dsaf_dev,
 				       u32 address,
@@ -960,10 +963,10 @@ static void hns_dsaf_tcam_uc_cfg_vague(struct dsaf_device *dsaf_dev,
 /**
  * hns_dsaf_tcam_mc_cfg_vague - INT
  * @dsaf_dev: dsa fabric device struct pointer
- * @address,
- * @ptbl_tcam_data,
- * @ptbl_tcam_mask
- * @ptbl_tcam_mcast
+ * @address: the address
+ * @tcam_data: the data
+ * @tcam_mask: the mask
+ * @tcam_mc: the multicast data
  */
 static void hns_dsaf_tcam_mc_cfg_vague(struct dsaf_device *dsaf_dev,
 				       u32 address,
@@ -988,8 +991,8 @@ static void hns_dsaf_tcam_mc_cfg_vague(struct dsaf_device *dsaf_dev,
 
 /**
  * hns_dsaf_tcam_mc_invld - INT
- * @dsaf_id: dsa fabric id
- * @address
+ * @dsaf_dev: dsa fabric id
+ * @address: the address
  */
 static void hns_dsaf_tcam_mc_invld(struct dsaf_device *dsaf_dev, u32 address)
 {
@@ -1024,10 +1027,10 @@ hns_dsaf_tcam_addr_get(struct dsaf_drv_tbl_tcam_key *mac_key, u8 *addr)
 
 /**
  * hns_dsaf_tcam_uc_get - INT
- * @dsaf_id: dsa fabric id
- * @address
- * @ptbl_tcam_data
- * @ptbl_tcam_ucast
+ * @dsaf_dev: dsa fabric id
+ * @address: the address
+ * @ptbl_tcam_data: the data
+ * @ptbl_tcam_ucast: unicast
  */
 static void hns_dsaf_tcam_uc_get(
 	struct dsaf_device *dsaf_dev, u32 address,
@@ -1077,10 +1080,10 @@ static void hns_dsaf_tcam_uc_get(
 
 /**
  * hns_dsaf_tcam_mc_get - INT
- * @dsaf_id: dsa fabric id
- * @address
- * @ptbl_tcam_data
- * @ptbl_tcam_ucast
+ * @dsaf_dev: dsa fabric id
+ * @address: the address
+ * @ptbl_tcam_data: the data
+ * @ptbl_tcam_mcast: tcam multicast data
  */
 static void hns_dsaf_tcam_mc_get(
 	struct dsaf_device *dsaf_dev, u32 address,
@@ -1127,7 +1130,7 @@ static void hns_dsaf_tcam_mc_get(
 
 /**
  * hns_dsaf_tbl_line_init - INT
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_tbl_line_init(struct dsaf_device *dsaf_dev)
 {
@@ -1141,7 +1144,7 @@ static void hns_dsaf_tbl_line_init(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_tbl_tcam_init - INT
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_tbl_tcam_init(struct dsaf_device *dsaf_dev)
 {
@@ -1156,7 +1159,9 @@ static void hns_dsaf_tbl_tcam_init(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_pfc_en_cfg - dsaf pfc pause cfg
- * @mac_cb: mac contrl block
+ * @dsaf_dev: dsa fabric id
+ * @mac_id: mac contrl block
+ * @tc_en: traffic class
  */
 static void hns_dsaf_pfc_en_cfg(struct dsaf_device *dsaf_dev,
 				int mac_id, int tc_en)
@@ -1209,8 +1214,7 @@ void hns_dsaf_get_rx_mac_pause_en(struct dsaf_device *dsaf_dev, int mac_id,
 
 /**
  * hns_dsaf_tbl_tcam_init - INT
- * @dsaf_id: dsa fabric id
- * @dsaf_mode
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_comm_init(struct dsaf_device *dsaf_dev)
 {
@@ -1263,7 +1267,7 @@ static void hns_dsaf_comm_init(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_inode_init - INT
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_inode_init(struct dsaf_device *dsaf_dev)
 {
@@ -1315,7 +1319,7 @@ static void hns_dsaf_inode_init(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_sbm_init - INT
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static int hns_dsaf_sbm_init(struct dsaf_device *dsaf_dev)
 {
@@ -1369,7 +1373,7 @@ static int hns_dsaf_sbm_init(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_tbl_init - INT
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_tbl_init(struct dsaf_device *dsaf_dev)
 {
@@ -1381,7 +1385,7 @@ static void hns_dsaf_tbl_init(struct dsaf_device *dsaf_dev)
 
 /**
  * hns_dsaf_voq_init - INT
- * @dsaf_id: dsa fabric id
+ * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_voq_init(struct dsaf_device *dsaf_dev)
 {
@@ -1435,7 +1439,7 @@ static void hns_dsaf_remove_hw(struct dsaf_device *dsaf_dev)
 /**
  * hns_dsaf_init - init dsa fabric
  * @dsaf_dev: dsa fabric device struct pointer
- * retuen 0 - success , negative --fail
+ * return 0 - success , negative --fail
  */
 static int hns_dsaf_init(struct dsaf_device *dsaf_dev)
 {
@@ -2099,7 +2103,7 @@ static struct dsaf_device *hns_dsaf_alloc_dev(struct device *dev,
 
 /**
  * hns_dsaf_free_dev - free dev mem
- * @dev: struct device pointer
+ * @dsaf_dev: struct device pointer
  */
 static void hns_dsaf_free_dev(struct dsaf_device *dsaf_dev)
 {
@@ -2108,9 +2112,9 @@ static void hns_dsaf_free_dev(struct dsaf_device *dsaf_dev)
 
 /**
  * dsaf_pfc_unit_cnt - set pfc unit count
- * @dsaf_id: dsa fabric id
- * @pport_rate:  value array
- * @pdsaf_pfc_unit_cnt:  value array
+ * @dsaf_dev: dsa fabric id
+ * @mac_id: id in use
+ * @rate:  value array
  */
 static void hns_dsaf_pfc_unit_cnt(struct dsaf_device *dsaf_dev, int  mac_id,
 				  enum dsaf_port_rate_mode rate)
@@ -2139,8 +2143,9 @@ static void hns_dsaf_pfc_unit_cnt(struct dsaf_device *dsaf_dev, int  mac_id,
 
 /**
  * dsaf_port_work_rate_cfg - fifo
- * @dsaf_id: dsa fabric id
- * @xge_ge_work_mode
+ * @dsaf_dev: dsa fabric id
+ * @mac_id: mac contrl block
+ * @rate_mode: value array
  */
 static void
 hns_dsaf_port_work_rate_cfg(struct dsaf_device *dsaf_dev, int mac_id,
@@ -2253,7 +2258,8 @@ void hns_dsaf_update_stats(struct dsaf_device *dsaf_dev, u32 node_num)
 
 /**
  *hns_dsaf_get_regs - dump dsaf regs
- *@dsaf_dev: dsaf device
+ *@ddev: dsaf device
+ *@port: port
  *@data:data for value of regs
  */
 void hns_dsaf_get_regs(struct dsaf_device *ddev, u32 port, void *data)
@@ -2690,6 +2696,7 @@ void hns_dsaf_get_stats(struct dsaf_device *ddev, u64 *data, int port)
 
 /**
  *hns_dsaf_get_sset_count - get dsaf string set count
+ *@dsaf_dev: dsaf device
  *@stringset: type of values in data
  *return dsaf string name count
  */
@@ -2711,6 +2718,7 @@ int hns_dsaf_get_sset_count(struct dsaf_device *dsaf_dev, int stringset)
  *@stringset:srting set index
  *@data:strings name value
  *@port:port index
+ *@dsaf_dev: dsaf device
  */
 void hns_dsaf_get_strings(int stringset, u8 *data, int port,
 			  struct dsaf_device *dsaf_dev)
@@ -2943,7 +2951,7 @@ int hns_dsaf_wait_pkt_clean(struct dsaf_device *dsaf_dev, int port)
 /**
  * dsaf_probe - probo dsaf dev
  * @pdev: dasf platform device
- * retuen 0 - success , negative --fail
+ * return 0 - success , negative --fail
  */
 static int hns_dsaf_probe(struct platform_device *pdev)
 {
@@ -3038,8 +3046,8 @@ module_platform_driver(g_dsaf_driver);
 /**
  * hns_dsaf_roce_reset - reset dsaf and roce
  * @dsaf_fwnode: Pointer to framework node for the dasf
- * @enable: false - request reset , true - drop reset
- * retuen 0 - success , negative -fail
+ * @dereset: false - request reset , true - drop reset
+ * return 0 - success , negative -fail
  */
 int hns_dsaf_roce_reset(struct fwnode_handle *dsaf_fwnode, bool dereset)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
index a769273b36f7..a9aca8c24e90 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -330,11 +330,12 @@ static void hns_dsaf_xge_srst_by_port_acpi(struct dsaf_device *dsaf_dev,
  * hns_dsaf_srst_chns - reset dsaf channels
  * @dsaf_dev: dsaf device struct pointer
  * @msk: xbar channels mask value:
+ * @dereset: false - request reset , true - drop reset
+ *
  * bit0-5 for xge0-5
  * bit6-11 for ppe0-5
  * bit12-17 for roce0-5
  * bit18-19 for com/dfx
- * @dereset: false - request reset , true - drop reset
  */
 static void
 hns_dsaf_srst_chns(struct dsaf_device *dsaf_dev, u32 msk, bool dereset)
@@ -353,11 +354,12 @@ hns_dsaf_srst_chns(struct dsaf_device *dsaf_dev, u32 msk, bool dereset)
  * hns_dsaf_srst_chns - reset dsaf channels
  * @dsaf_dev: dsaf device struct pointer
  * @msk: xbar channels mask value:
+ * @dereset: false - request reset , true - drop reset
+ *
  * bit0-5 for xge0-5
  * bit6-11 for ppe0-5
  * bit12-17 for roce0-5
  * bit18-19 for com/dfx
- * @dereset: false - request reset , true - drop reset
  */
 static void
 hns_dsaf_srst_chns_acpi(struct dsaf_device *dsaf_dev, u32 msk, bool dereset)
@@ -612,7 +614,8 @@ static int hns_mac_get_sfp_prsnt_acpi(struct hns_mac_cb *mac_cb, int *sfp_prsnt)
 /**
  * hns_mac_config_sds_loopback - set loop back for serdes
  * @mac_cb: mac control block
- * retuen 0 == success
+ * @en: enable or disable
+ * return 0 == success
  */
 static int hns_mac_config_sds_loopback(struct hns_mac_cb *mac_cb, bool en)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c
index 2b34b553acf3..d0f8b1fff333 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c
@@ -66,8 +66,8 @@ hns_ppe_common_get_ioaddr(struct ppe_common_cb *ppe_common)
 /**
  * hns_ppe_common_get_cfg - get ppe common config
  * @dsaf_dev: dasf device
- * comm_index: common index
- * retuen 0 - success , negative --fail
+ * @comm_index: common index
+ * return 0 - success , negative --fail
  */
 static int hns_ppe_common_get_cfg(struct dsaf_device *dsaf_dev, int comm_index)
 {
@@ -143,7 +143,7 @@ static void hns_ppe_set_vlan_strip(struct hns_ppe_cb *ppe_cb, int en)
 
 /**
  * hns_ppe_checksum_hw - set ppe checksum caculate
- * @ppe_device: ppe device
+ * @ppe_cb: ppe device
  * @value: value
  */
 static void hns_ppe_checksum_hw(struct hns_ppe_cb *ppe_cb, u32 value)
@@ -179,7 +179,7 @@ static void hns_ppe_set_qid(struct ppe_common_cb *ppe_common, u32 qid)
 
 /**
  * hns_ppe_set_port_mode - set port mode
- * @ppe_device: ppe device
+ * @ppe_cb: ppe device
  * @mode: port mode
  */
 static void hns_ppe_set_port_mode(struct hns_ppe_cb *ppe_cb,
@@ -344,7 +344,7 @@ static void hns_ppe_init_hw(struct hns_ppe_cb *ppe_cb)
 
 /**
  * ppe_uninit_hw - uninit ppe
- * @ppe_device: ppe device
+ * @ppe_cb: ppe device
  */
 static void hns_ppe_uninit_hw(struct hns_ppe_cb *ppe_cb)
 {
@@ -384,7 +384,8 @@ void hns_ppe_uninit(struct dsaf_device *dsaf_dev)
 /**
  * hns_ppe_reset - reinit ppe/rcb hw
  * @dsaf_dev: dasf device
- * retuen void
+ * @ppe_common_index: the index
+ * return void
  */
 void hns_ppe_reset_common(struct dsaf_device *dsaf_dev, u8 ppe_common_index)
 {
@@ -455,7 +456,7 @@ int hns_ppe_get_regs_count(void)
 
 /**
  * ppe_get_strings - get ppe srting
- * @ppe_device: ppe device
+ * @ppe_cb: ppe device
  * @stringset: string set type
  * @data: output string
  */
@@ -513,7 +514,7 @@ void hns_ppe_get_stats(struct hns_ppe_cb *ppe_cb, u64 *data)
 /**
  * hns_ppe_init - init ppe device
  * @dsaf_dev: dasf device
- * retuen 0 - success , negative --fail
+ * return 0 - success , negative --fail
  */
 int hns_ppe_init(struct dsaf_device *dsaf_dev)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c
index 5453597ec629..b6c8910cf7ba 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c
@@ -34,7 +34,7 @@
 /**
  *hns_rcb_wait_fbd_clean - clean fbd
  *@qs: ring struct pointer array
- *@qnum: num of array
+ *@q_num: num of array
  *@flag: tx or rx flag
  */
 void hns_rcb_wait_fbd_clean(struct hnae_queue **qs, int q_num, u32 flag)
@@ -191,7 +191,8 @@ void hns_rcbv2_int_clr_hw(struct hnae_queue *q, u32 flag)
 
 /**
  *hns_rcb_ring_enable_hw - enable ring
- *@ring: rcb ring
+ *@q: rcb ring
+ *@val: value to write
  */
 void hns_rcb_ring_enable_hw(struct hnae_queue *q, u32 val)
 {
@@ -844,7 +845,7 @@ void hns_rcb_update_stats(struct hnae_queue *queue)
 
 /**
  *hns_rcb_get_stats - get rcb statistic
- *@ring: rcb ring
+ *@queue: rcb ring
  *@data:statistic value
  */
 void hns_rcb_get_stats(struct hnae_queue *queue, u64 *data)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
index d832cd018c1c..7e3609ce112a 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
@@ -242,7 +242,8 @@ static void hns_xgmac_config_pad_and_crc(void *mac_drv, u8 newval)
 /**
  *hns_xgmac_pausefrm_cfg - set pause param about xgmac
  *@mac_drv: mac driver
- *@newval:enable of pad and crc
+ *@rx_en: enable receive
+ *@tx_en: enable transmit
  */
 static void hns_xgmac_pausefrm_cfg(void *mac_drv, u32 rx_en, u32 tx_en)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 3cdc65d38fb7..858cb293152a 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -752,6 +752,8 @@ static void hns_update_rx_rate(struct hnae_ring *ring)
 
 /**
  * smooth_alg - smoothing algrithm for adjusting coalesce parameter
+ * @new_param: new value
+ * @old_param: old value
  **/
 static u32 smooth_alg(u32 new_param, u32 old_param)
 {
@@ -1829,7 +1831,7 @@ static int hns_nic_uc_unsync(struct net_device *netdev,
 }
 
 /**
- * nic_set_multicast_list - set mutl mac address
+ * hns_set_multicast_list - set mutl mac address
  * @ndev: net device
  *
  * return void
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index 14e60c9e491d..7165da0ee9aa 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -462,7 +462,7 @@ static int __lb_clean_rings(struct hns_nic_priv *priv,
 }
 
 /**
- * nic_run_loopback_test -  run loopback test
+ * __lb_run_test -  run loopback test
  * @ndev: net device
  * @loop_mode: loopback mode
  */
@@ -971,7 +971,7 @@ static void hns_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 }
 
 /**
- * nic_get_sset_count - get string set count witch returned by nic_get_strings.
+ * hns_get_sset_count - get string set count returned by nic_get_strings
  * @netdev: net device
  * @stringset: string set index, 0: self test string; 1: statistics string.
  *
@@ -1027,7 +1027,7 @@ static int hns_phy_led_set(struct net_device *netdev, int value)
 }
 
 /**
- * nic_set_phys_id - set phy identify LED.
+ * hns_set_phys_id - set phy identify LED.
  * @netdev: net device
  * @state: LED state.
  *
@@ -1125,7 +1125,7 @@ static void hns_get_regs(struct net_device *net_dev, struct ethtool_regs *cmd,
 }
 
 /**
- * nic_get_regs_len - get total register len.
+ * hns_get_regs_len - get total register len.
  * @net_dev: net device
  *
  * Return total register len.
diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
index 7df5d7d211d4..883d0d7c6858 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -210,7 +210,7 @@ static void hns_mdio_cmd_write(struct hns_mdio_device *mdio_dev,
  * @bus: mdio bus
  * @phy_id: phy id
  * @regnum: register num
- * @value: register value
+ * @data: register value
  *
  * Return 0 on success, negative on failure
  */
@@ -273,7 +273,6 @@ static int hns_mdio_write(struct mii_bus *bus,
  * @bus: mdio bus
  * @phy_id: phy id
  * @regnum: register num
- * @value: register value
  *
  * Return phy register value
  */
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 67d3d80b8366..cefbb2298004 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * drivers/net/ethernet/micrel/ksx884x.c - Micrel KSZ8841/2 PCI Ethernet driver
  *
  * Copyright (c) 2009-2010 Micrel, Inc.
@@ -959,7 +959,7 @@ struct ksz_sw_desc {
  * struct ksz_dma_buf - OS dependent DMA buffer data structure
  * @skb:	Associated socket buffer.
  * @dma:	Associated physical DMA address.
- * len:		Actual len used.
+ * @len:	Actual len used.
  */
 struct ksz_dma_buf {
 	struct sk_buff *skb;
@@ -1254,6 +1254,7 @@ struct ksz_port_info {
  * @multi_list_size:	Multicast address list size.
  * @enabled:		Indication of hardware enabled.
  * @rx_stop:		Indication of receive process stop.
+ * @reserved2:		none
  * @features:		Hardware features to enable.
  * @overrides:		Hardware features to override.
  * @parent:		Pointer to parent, network device private structure.
@@ -1447,7 +1448,7 @@ struct dev_info {
  * struct dev_priv - Network device private data structure
  * @adapter:		Adapter device information.
  * @port:		Port information.
- * @monitor_time_info:	Timer to monitor ports.
+ * @monitor_timer_info:	Timer to monitor ports.
  * @proc_sem:		Semaphore for proc accessing.
  * @id:			Device ID.
  * @mii_if:		MII interface information.
@@ -1566,6 +1567,7 @@ static inline void hw_restore_intr(struct ksz_hw *hw, uint interrupt)
 
 /**
  * hw_block_intr - block hardware interrupts
+ * @hw: The hardware instance.
  *
  * This function blocks all interrupts of the hardware and returns the current
  * interrupt enable mask so that interrupts can be restored later.
@@ -1818,6 +1820,7 @@ static void port_r_mib_cnt(struct ksz_hw *hw, int port, u16 addr, u64 *cnt)
  * port_r_mib_pkt - read dropped packet counts
  * @hw: 	The hardware instance.
  * @port:	The port index.
+ * @last:	last one
  * @cnt:	Buffer to store the receive and transmit dropped packet counts.
  *
  * This routine reads the dropped packet counts of the port.
@@ -1971,7 +1974,7 @@ static void port_cfg(struct ksz_hw *hw, int port, int offset, u16 bits,
  * port_chk_shift - check port bit
  * @hw: 	The hardware instance.
  * @port:	The port index.
- * @offset:	The offset of the register.
+ * @addr:	The offset of the register.
  * @shift:	Number of bits to shift.
  *
  * This function checks whether the specified port is set in the register or
@@ -1993,7 +1996,7 @@ static int port_chk_shift(struct ksz_hw *hw, int port, u32 addr, int shift)
  * port_cfg_shift - set port bit
  * @hw: 	The hardware instance.
  * @port:	The port index.
- * @offset:	The offset of the register.
+ * @addr:	The offset of the register.
  * @shift:	Number of bits to shift.
  * @set:	The flag indicating whether the port is to be set or not.
  *
@@ -4424,6 +4427,8 @@ static int ksz_alloc_desc(struct dev_info *adapter)
 /**
  * free_dma_buf - release DMA buffer resources
  * @adapter:	Adapter information structure.
+ * @dma_buf:	pointer to buf
+ * @direction:	to or from device
  *
  * This routine is just a helper function to release the DMA buffer resources.
  */
@@ -4561,6 +4566,7 @@ static void ksz_free_desc(struct dev_info *adapter)
  * ksz_free_buffers - free buffers used in the descriptors
  * @adapter:	Adapter information structure.
  * @desc_info:	Descriptor information structure.
+ * @direction:	to or from device
  *
  * This local routine frees buffers used in the DMA buffers.
  */
@@ -4720,7 +4726,8 @@ static void send_packet(struct sk_buff *skb, struct net_device *dev)
 
 /**
  * transmit_cleanup - clean up transmit descriptors
- * @dev:	Network device.
+ * @hw_priv:	Network device.
+ * @normal:	break if owned
  *
  * This routine is called to clean up the transmitted buffers.
  */
@@ -4776,7 +4783,7 @@ static void transmit_cleanup(struct dev_info *hw_priv, int normal)
 
 /**
  * transmit_done - transmit done processing
- * @dev:	Network device.
+ * @hw_priv:	Network device.
  *
  * This routine is called when the transmit interrupt is triggered, indicating
  * either a packet is sent successfully or there are transmit errors.
@@ -4882,6 +4889,7 @@ static netdev_tx_t netdev_tx(struct sk_buff *skb, struct net_device *dev)
 /**
  * netdev_tx_timeout - transmit timeout processing
  * @dev:	Network device.
+ * @txqueue:	index of hanging queue
  *
  * This routine is called when the transmit timer expires.  That indicates the
  * hardware is not running correctly because transmit interrupts are not
@@ -6074,14 +6082,6 @@ static void netdev_get_drvinfo(struct net_device *dev,
 		sizeof(info->bus_info));
 }
 
-/**
- * netdev_get_regs_len - get length of register dump
- * @dev:	Network device.
- *
- * This function returns the length of the register dump.
- *
- * Return length of the register dump.
- */
 static struct hw_regs {
 	int start;
 	int end;
@@ -6095,6 +6095,14 @@ static struct hw_regs {
 	{ 0, 0 }
 };
 
+/**
+ * netdev_get_regs_len - get length of register dump
+ * @dev:	Network device.
+ *
+ * This function returns the length of the register dump.
+ *
+ * Return length of the register dump.
+ */
 static int netdev_get_regs_len(struct net_device *dev)
 {
 	struct hw_regs *range = hw_regs_range;
@@ -6236,6 +6244,8 @@ static int netdev_get_eeprom_len(struct net_device *dev)
 	return EEPROM_SIZE * 2;
 }
 
+#define EEPROM_MAGIC			0x10A18842
+
 /**
  * netdev_get_eeprom - get EEPROM data
  * @dev:	Network device.
@@ -6246,8 +6256,6 @@ static int netdev_get_eeprom_len(struct net_device *dev)
  *
  * Return 0 if successful; otherwise an error code.
  */
-#define EEPROM_MAGIC			0x10A18842
-
 static int netdev_get_eeprom(struct net_device *dev,
 	struct ethtool_eeprom *eeprom, u8 *data)
 {
@@ -6384,7 +6392,7 @@ static int netdev_set_pauseparam(struct net_device *dev,
 /**
  * netdev_get_ringparam - get tx/rx ring parameters
  * @dev:	Network device.
- * @pause:	Ethtool RING settings data structure.
+ * @ring:	Ethtool RING settings data structure.
  *
  * This procedure returns the TX/RX ring settings.
  */
@@ -6688,7 +6696,7 @@ static void mib_monitor(struct timer_list *t)
 
 /**
  * dev_monitor - periodic monitoring
- * @ptr:	Network device pointer.
+ * @t:	timer list containing a network device pointer.
  *
  * This routine is run in a kernel timer to monitor the network device.
  */
diff --git a/drivers/net/ethernet/microchip/encx24j600-regmap.c b/drivers/net/ethernet/microchip/encx24j600-regmap.c
index 5bd7fb917b7a..796e46a53926 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * Register map access API - ENCX24J600 support
  *
  * Copyright 2015 Gridpoint
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 4c1f53339019..72794d158871 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -600,12 +600,14 @@ static void phy_intr(struct net_device *ndev)
 	struct ns83820 *dev = PRIV(ndev);
 	static const char *speeds[] = { "10", "100", "1000", "1000(?)", "1000F" };
 	u32 cfg, new_cfg;
-	u32 tbisr, tanar, tanlpar;
+	u32 tanar, tanlpar;
 	int speed, fullduplex, newlinkstate;
 
 	cfg = readl(dev->base + CFG) ^ SPDSTS_POLARITY;
 
 	if (dev->CFG_cache & CFG_TBI_EN) {
+		u32 __maybe_unused tbisr;
+
 		/* we have an optical transceiver */
 		tbisr = readl(dev->base + TBISR);
 		tanar = readl(dev->base + TANAR);
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index bc94970bea45..d13d92bf7447 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -1000,7 +1000,7 @@ static void free_shared_mem(struct s2io_nic *nic)
 	}
 }
 
-/**
+/*
  * s2io_verify_pci_mode -
  */
 
@@ -1035,7 +1035,7 @@ static int s2io_on_nec_bridge(struct pci_dev *s2io_pdev)
 }
 
 static int bus_speed[8] = {33, 133, 133, 200, 266, 133, 200, 266};
-/**
+/*
  * s2io_print_pci_mode -
  */
 static int s2io_print_pci_mode(struct s2io_nic *nic)
@@ -2064,6 +2064,9 @@ static void en_dis_able_nic_intrs(struct s2io_nic *nic, u16 mask, int flag)
 
 /**
  *  verify_pcc_quiescent- Checks for PCC quiescent state
+ *  @sp : private member of the device structure, which is a pointer to the
+ *  s2io_nic structure.
+ *  @flag: boolean controlling function path
  *  Return: 1 If PCC is quiescence
  *          0 If PCC is not quiescence
  */
@@ -2099,6 +2102,8 @@ static int verify_pcc_quiescent(struct s2io_nic *sp, int flag)
 }
 /**
  *  verify_xena_quiescence - Checks whether the H/W is ready
+ *  @sp : private member of the device structure, which is a pointer to the
+ *  s2io_nic structure.
  *  Description: Returns whether the H/W is ready to go or not. Depending
  *  on whether adapter enable bit was written or not the comparison
  *  differs and the calling function passes the input argument flag to
@@ -2305,6 +2310,9 @@ static int start_nic(struct s2io_nic *nic)
 }
 /**
  * s2io_txdl_getskb - Get the skb from txdl, unmap and return skb
+ * @fifo_data: fifo data pointer
+ * @txdlp: descriptor
+ * @get_off: unused
  */
 static struct sk_buff *s2io_txdl_getskb(struct fifo_info *fifo_data,
 					struct TxD *txdlp, int get_off)
@@ -2391,7 +2399,7 @@ static void free_tx_buffers(struct s2io_nic *nic)
 
 /**
  *   stop_nic -  To stop the nic
- *   @nic ; device private variable.
+ *   @nic : device private variable.
  *   Description:
  *   This function does exactly the opposite of what the start_nic()
  *   function does. This function is called to stop the device.
@@ -2419,7 +2427,8 @@ static void stop_nic(struct s2io_nic *nic)
 
 /**
  *  fill_rx_buffers - Allocates the Rx side skbs
- *  @ring_info: per ring structure
+ *  @nic : device private variable.
+ *  @ring: per ring structure
  *  @from_card_up: If this is true, we will map the buffer to get
  *     the dma address for buf0 and buf1 to give it to the card.
  *     Else we will sync the already mapped buffer to give it to the card.
@@ -2864,7 +2873,7 @@ static void s2io_netpoll(struct net_device *dev)
 
 /**
  *  rx_intr_handler - Rx interrupt handler
- *  @ring_info: per ring structure.
+ *  @ring_data: per ring structure.
  *  @budget: budget for napi processing.
  *  Description:
  *  If the interrupt is because of a received frame or if the
@@ -2972,7 +2981,7 @@ static int rx_intr_handler(struct ring_info *ring_data, int budget)
 
 /**
  *  tx_intr_handler - Transmit interrupt handler
- *  @nic : device private variable
+ *  @fifo_data : fifo data pointer
  *  Description:
  *  If an interrupt was raised to indicate DMA complete of the
  *  Tx packet, this function is called. It identifies the last TxD
@@ -3153,6 +3162,8 @@ static u64 s2io_mdio_read(u32 mmd_type, u64 addr, struct net_device *dev)
 /**
  *  s2io_chk_xpak_counter - Function to check the status of the xpak counters
  *  @counter      : counter value to be updated
+ *  @regs_stat    : registers status
+ *  @index        : index
  *  @flag         : flag to indicate the status
  *  @type         : counter type
  *  Description:
@@ -3309,8 +3320,9 @@ static void s2io_updt_xpak_counter(struct net_device *dev)
 
 /**
  *  wait_for_cmd_complete - waits for a command to complete.
- *  @sp : private member of the device structure, which is a pointer to the
- *  s2io_nic structure.
+ *  @addr: address
+ *  @busy_bit: bit to check for busy
+ *  @bit_state: state to check
  *  Description: Function that waits for a command to Write into RMAC
  *  ADDR DATA registers to be completed and returns either success or
  *  error depending on whether the command was complete or not.
@@ -4335,7 +4347,7 @@ static int do_s2io_chk_alarm_bit(u64 value, void __iomem *addr,
 
 /**
  *  s2io_handle_errors - Xframe error indication handler
- *  @nic: device private variable
+ *  @dev_id: opaque handle to dev
  *  Description: Handle alarms such as loss of link, single or
  *  double ECC errors, critical and serious errors.
  *  Return Value:
@@ -4739,7 +4751,7 @@ static irqreturn_t s2io_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-/**
+/*
  * s2io_updt_stats -
  */
 static void s2io_updt_stats(struct s2io_nic *sp)
@@ -5168,7 +5180,7 @@ static u64 do_s2io_read_unicast_mc(struct s2io_nic *sp, int offset)
 	return tmp64 >> 16;
 }
 
-/**
+/*
  * s2io_set_mac_addr - driver entry point
  */
 
@@ -5243,8 +5255,7 @@ static int do_s2io_prog_unicast(struct net_device *dev, u8 *addr)
 
 /**
  * s2io_ethtool_set_link_ksettings - Sets different link parameters.
- * @sp : private member of the device structure, which is a pointer to the
- * s2io_nic structure.
+ * @dev : pointer to netdev
  * @cmd: pointer to the structure with parameters given by ethtool to set
  * link information.
  * Description:
@@ -5273,8 +5284,7 @@ s2io_ethtool_set_link_ksettings(struct net_device *dev,
 
 /**
  * s2io_ethtol_get_link_ksettings - Return link specific information.
- * @sp : private member of the device structure, pointer to the
- *      s2io_nic structure.
+ * @dev: pointer to netdev
  * @cmd : pointer to the structure with parameters given by ethtool
  * to return link information.
  * Description:
@@ -5313,8 +5323,7 @@ s2io_ethtool_get_link_ksettings(struct net_device *dev,
 
 /**
  * s2io_ethtool_gdrvinfo - Returns driver specific information.
- * @sp : private member of the device structure, which is a pointer to the
- * s2io_nic structure.
+ * @dev: pointer to netdev
  * @info : pointer to the structure with parameters given by ethtool to
  * return driver information.
  * Description:
@@ -5335,11 +5344,10 @@ static void s2io_ethtool_gdrvinfo(struct net_device *dev,
 
 /**
  *  s2io_ethtool_gregs - dumps the entire space of Xfame into the buffer.
- *  @sp: private member of the device structure, which is a pointer to the
- *  s2io_nic structure.
+ *  @dev: pointer to netdev
  *  @regs : pointer to the structure with parameters given by ethtool for
- *  dumping the registers.
- *  @reg_space: The input argument into which all the registers are dumped.
+ *          dumping the registers.
+ *  @space: The input argument into which all the registers are dumped.
  *  Description:
  *  Dumps the entire register space of xFrame NIC into the user given
  *  buffer area.
@@ -5471,8 +5479,7 @@ static void s2io_ethtool_gringparam(struct net_device *dev,
 
 /**
  * s2io_ethtool_getpause_data -Pause frame frame generation and reception.
- * @sp : private member of the device structure, which is a pointer to the
- *	s2io_nic structure.
+ * @dev: pointer to netdev
  * @ep : pointer to the structure with pause parameters given by ethtool.
  * Description:
  * Returns the Pause frame generation and reception capability of the NIC.
@@ -5496,8 +5503,7 @@ static void s2io_ethtool_getpause_data(struct net_device *dev,
 
 /**
  * s2io_ethtool_setpause_data -  set/reset pause frame generation.
- * @sp : private member of the device structure, which is a pointer to the
- *      s2io_nic structure.
+ * @dev: pointer to netdev
  * @ep : pointer to the structure with pause parameters given by ethtool.
  * Description:
  * It can be used to set or reset Pause frame generation or reception
@@ -5526,6 +5532,7 @@ static int s2io_ethtool_setpause_data(struct net_device *dev,
 	return 0;
 }
 
+#define S2IO_DEV_ID		5
 /**
  * read_eeprom - reads 4 bytes of data from user given offset.
  * @sp : private member of the device structure, which is a pointer to the
@@ -5541,8 +5548,6 @@ static int s2io_ethtool_setpause_data(struct net_device *dev,
  * Return value:
  *  -1 on failure and 0 on success.
  */
-
-#define S2IO_DEV_ID		5
 static int read_eeprom(struct s2io_nic *sp, int off, u64 *data)
 {
 	int ret = -1;
@@ -5734,8 +5739,7 @@ static void s2io_vpd_read(struct s2io_nic *nic)
 
 /**
  *  s2io_ethtool_geeprom  - reads the value stored in the Eeprom.
- *  @sp : private member of the device structure, which is a pointer to the
- *  s2io_nic structure.
+ *  @dev: pointer to netdev
  *  @eeprom : pointer to the user level structure provided by ethtool,
  *  containing all relevant information.
  *  @data_buf : user defined value to be written into Eeprom.
@@ -5771,11 +5775,10 @@ static int s2io_ethtool_geeprom(struct net_device *dev,
 
 /**
  *  s2io_ethtool_seeprom - tries to write the user provided value in Eeprom
- *  @sp : private member of the device structure, which is a pointer to the
- *  s2io_nic structure.
+ *  @dev: pointer to netdev
  *  @eeprom : pointer to the user level structure provided by ethtool,
  *  containing all relevant information.
- *  @data_buf ; user defined value to be written into Eeprom.
+ *  @data_buf : user defined value to be written into Eeprom.
  *  Description:
  *  Tries to write the user provided value in the Eeprom, at the offset
  *  given by the user.
@@ -6027,7 +6030,7 @@ static int s2io_bist_test(struct s2io_nic *sp, uint64_t *data)
 
 /**
  * s2io_link_test - verifies the link state of the nic
- * @sp ; private member of the device structure, which is a pointer to the
+ * @sp: private member of the device structure, which is a pointer to the
  * s2io_nic structure.
  * @data: variable that returns the result of each of the test conducted by
  * the driver.
@@ -6150,8 +6153,7 @@ static int s2io_rldram_test(struct s2io_nic *sp, uint64_t *data)
 
 /**
  *  s2io_ethtool_test - conducts 6 tsets to determine the health of card.
- *  @sp : private member of the device structure, which is a pointer to the
- *  s2io_nic structure.
+ *  @dev: pointer to netdev
  *  @ethtest : pointer to a ethtool command specific structure that will be
  *  returned to the user.
  *  @data : variable that returns the result of each of the test
@@ -6597,7 +6599,7 @@ static const struct ethtool_ops netdev_ethtool_ops = {
 /**
  *  s2io_ioctl - Entry point for the Ioctl
  *  @dev :  Device pointer.
- *  @ifr :  An IOCTL specefic structure, that can contain a pointer to
+ *  @rq :  An IOCTL specefic structure, that can contain a pointer to
  *  a proprietary structure used to pass information to the driver.
  *  @cmd :  This is used to distinguish between the different commands that
  *  can be passed to the IOCTL functions.
@@ -6650,7 +6652,7 @@ static int s2io_change_mtu(struct net_device *dev, int new_mtu)
 
 /**
  * s2io_set_link - Set the LInk status
- * @data: long pointer to device private structue
+ * @work: work struct containing a pointer to device private structue
  * Description: Sets the link status for the adapter
  */
 
@@ -7187,7 +7189,7 @@ static int s2io_card_up(struct s2io_nic *sp)
 
 /**
  * s2io_restart_nic - Resets the NIC.
- * @data : long pointer to the device private structure
+ * @work : work struct containing a pointer to the device private structure
  * Description:
  * This function is scheduled to be run by the s2io_tx_watchdog
  * function after 0.5 secs to reset the NIC. The idea is to reduce
@@ -7218,6 +7220,7 @@ static void s2io_restart_nic(struct work_struct *work)
 /**
  *  s2io_tx_watchdog - Watchdog for transmit side.
  *  @dev : Pointer to net device structure
+ *  @txqueue: index of the hanging queue
  *  Description:
  *  This function is triggered if the Tx Queue is stopped
  *  for a pre-defined amount of time when the Interface is still up.
@@ -7242,11 +7245,8 @@ static void s2io_tx_watchdog(struct net_device *dev, unsigned int txqueue)
 
 /**
  *   rx_osm_handler - To perform some OS related operations on SKB.
- *   @sp: private member of the device structure,pointer to s2io_nic structure.
- *   @skb : the socket buffer pointer.
- *   @len : length of the packet
- *   @cksum : FCS checksum of the frame.
- *   @ring_no : the ring from which this RxD was extracted.
+ *   @ring_data : the ring from which this RxD was extracted.
+ *   @rxdp: descriptor
  *   Description:
  *   This function is called by the Rx interrupt serivce routine to perform
  *   some OS related operations on the SKB before passing it to the upper
@@ -7576,9 +7576,10 @@ static int s2io_verify_parm(struct pci_dev *pdev, u8 *dev_intr_type,
 }
 
 /**
- * rts_ds_steer - Receive traffic steering based on IPv4 or IPv6 TOS
- * or Traffic class respectively.
+ * rts_ds_steer - Receive traffic steering based on IPv4 or IPv6 TOS or Traffic class respectively.
  * @nic: device private variable
+ * @ds_codepoint: data
+ * @ring: ring index
  * Description: The function configures the receive steering to
  * desired receive ring.
  * Return Value:  SUCCESS on success and
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index 78eba10300ae..6aba267036dd 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -988,6 +988,9 @@ __vxge_hw_vpath_addr_get(struct __vxge_hw_virtualpath *vpath,
 
 /**
  * vxge_hw_device_hw_info_get - Get the hw information
+ * @bar0: the bar
+ * @hw_info: the hw_info struct
+ *
  * Returns the vpath mask that has the bits set for each vpath allocated
  * for the driver, FW version information, and the first mac address for
  * each vpath
@@ -3926,7 +3929,7 @@ enum vxge_hw_status vxge_hw_vpath_rts_rth_itable_set(
 
 /**
  * vxge_hw_vpath_check_leak - Check for memory leak
- * @ringh: Handle to the ring object used for receive
+ * @ring: Handle to the ring object used for receive
  *
  * If PRC_RXD_DOORBELL_VPn.NEW_QW_CNT is larger or equal to
  * PRC_CFG6_VPn.RXD_SPAT then a leak has occurred.
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-ethtool.c b/drivers/net/ethernet/neterion/vxge/vxge-ethtool.c
index 03c3d1230c17..4d91026485ae 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-ethtool.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-ethtool.c
@@ -119,7 +119,7 @@ static void vxge_ethtool_gdrvinfo(struct net_device *dev,
  * @dev: device pointer.
  * @regs: pointer to the structure with parameters given by ethtool for
  * dumping the registers.
- * @reg_space: The input argument into which all the registers are dumped.
+ * @space: The input argument into which all the registers are dumped.
  *
  * Dumps the vpath register space of Titan NIC into the user given
  * buffer area.
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 7afdb3bc631c..87892bd992b1 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -1275,6 +1275,7 @@ static void vxge_set_multicast(struct net_device *dev)
 /**
  * vxge_set_mac_addr
  * @dev: pointer to the device structure
+ * @p: socket info
  *
  * Update entry "0" (default MAC addr)
  */
@@ -1799,7 +1800,7 @@ static void vxge_reset(struct work_struct *work)
 
 /**
  * vxge_poll - Receive handler when Receive Polling is used.
- * @dev: pointer to the device structure.
+ * @napi: pointer to the napi structure.
  * @budget: Number of packets budgeted to be processed in this iteration.
  *
  * This function comes into picture only if Receive side is being handled
@@ -3096,7 +3097,7 @@ static int vxge_change_mtu(struct net_device *dev, int new_mtu)
 /**
  * vxge_get_stats64
  * @dev: pointer to the device structure
- * @stats: pointer to struct rtnl_link_stats64
+ * @net_stats: pointer to struct rtnl_link_stats64
  *
  */
 static void
@@ -3245,7 +3246,7 @@ static int vxge_hwtstamp_get(struct vxgedev *vdev, void __user *data)
 /**
  * vxge_ioctl
  * @dev: Device pointer.
- * @ifr: An IOCTL specific structure, that can contain a pointer to
+ * @rq: An IOCTL specific structure, that can contain a pointer to
  *       a proprietary structure used to pass information to the driver.
  * @cmd: This is used to distinguish between the different commands that
  *       can be passed to the IOCTL functions.
@@ -3269,6 +3270,7 @@ static int vxge_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 /**
  * vxge_tx_watchdog
  * @dev: pointer to net device structure
+ * @txqueue: index of the hanging queue
  *
  * Watchdog for transmit side.
  * This function is triggered if the Tx Queue is stopped
@@ -4002,6 +4004,7 @@ static void vxge_print_parm(struct vxgedev *vdev, u64 vpath_mask)
 
 /**
  * vxge_pm_suspend - vxge power management suspend entry point
+ * @dev_d: device pointer
  *
  */
 static int __maybe_unused vxge_pm_suspend(struct device *dev_d)
@@ -4010,6 +4013,7 @@ static int __maybe_unused vxge_pm_suspend(struct device *dev_d)
 }
 /**
  * vxge_pm_resume - vxge power management resume entry point
+ * @dev_d: device pointer
  *
  */
 static int __maybe_unused vxge_pm_resume(struct device *dev_d)
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-traffic.c b/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
index bd525e8eda10..ee164970b267 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
@@ -278,7 +278,7 @@ void vxge_hw_vpath_dynamic_rti_rtimer_set(struct __vxge_hw_ring *ring)
 
 /**
  * vxge_hw_channel_msix_mask - Mask MSIX Vector.
- * @channeh: Channel for rx or tx handle
+ * @channel: Channel for rx or tx handle
  * @msix_id:  MSIX ID
  *
  * The function masks the msix interrupt for the given msix_id
@@ -295,7 +295,7 @@ void vxge_hw_channel_msix_mask(struct __vxge_hw_channel *channel, int msix_id)
 
 /**
  * vxge_hw_channel_msix_unmask - Unmask the MSIX Vector.
- * @channeh: Channel for rx or tx handle
+ * @channel: Channel for rx or tx handle
  * @msix_id:  MSI ID
  *
  * The function unmasks the msix interrupt for the given msix_id
@@ -350,8 +350,6 @@ u32 vxge_hw_device_set_intr_type(struct __vxge_hw_device *hldev, u32 intr_mode)
 /**
  * vxge_hw_device_intr_enable - Enable interrupts.
  * @hldev: HW device handle.
- * @op: One of the enum vxge_hw_device_intr enumerated values specifying
- *      the type(s) of interrupts to enable.
  *
  * Enable Titan interrupts. The function is to be executed the last in
  * Titan initialization sequence.
@@ -405,8 +403,6 @@ void vxge_hw_device_intr_enable(struct __vxge_hw_device *hldev)
 /**
  * vxge_hw_device_intr_disable - Disable Titan interrupts.
  * @hldev: HW device handle.
- * @op: One of the enum vxge_hw_device_intr enumerated values specifying
- *      the type(s) of interrupts to disable.
  *
  * Disable Titan interrupts.
  *
@@ -1406,7 +1402,7 @@ u32 vxge_hw_fifo_free_txdl_count_get(struct __vxge_hw_fifo *fifoh)
 
 /**
  * vxge_hw_fifo_txdl_reserve - Reserve fifo descriptor.
- * @fifoh: Handle to the fifo object used for non offload send
+ * @fifo: Handle to the fifo object used for non offload send
  * @txdlh: Reserved descriptor. On success HW fills this "out" parameter
  *        with a valid handle.
  * @txdl_priv: Buffer to return the pointer to per txdl space
@@ -1517,8 +1513,6 @@ void vxge_hw_fifo_txdl_buffer_set(struct __vxge_hw_fifo *fifo,
  * vxge_hw_fifo_txdl_post - Post descriptor on the fifo channel.
  * @fifo: Handle to the fifo object used for non offload send
  * @txdlh: Descriptor obtained via vxge_hw_fifo_txdl_reserve()
- * @frags: Number of contiguous buffers that are part of a single
- *         transmit operation.
  *
  * Post descriptor on the 'fifo' type channel for transmission.
  * Prior to posting the descriptor should be filled in accordance with
@@ -1691,8 +1685,7 @@ void vxge_hw_fifo_txdl_free(struct __vxge_hw_fifo *fifo, void *txdlh)
 }
 
 /**
- * vxge_hw_vpath_mac_addr_add - Add the mac address entry for this vpath
- *               to MAC address table.
+ * vxge_hw_vpath_mac_addr_add - Add the mac address entry for this vpath to MAC address table.
  * @vp: Vpath handle.
  * @macaddr: MAC address to be added for this vpath into the list
  * @macaddr_mask: MAC address mask for macaddr
@@ -1757,13 +1750,13 @@ vxge_hw_vpath_mac_addr_add(
 }
 
 /**
- * vxge_hw_vpath_mac_addr_get - Get the first mac address entry for this vpath
- *               from MAC address table.
+ * vxge_hw_vpath_mac_addr_get - Get the first mac address entry
  * @vp: Vpath handle.
  * @macaddr: First MAC address entry for this vpath in the list
  * @macaddr_mask: MAC address mask for macaddr
  *
- * Returns the first mac address and mac address mask in the list for this
+ * Get the first mac address entry for this vpath from MAC address table.
+ * Return: the first mac address and mac address mask in the list for this
  * vpath.
  * see also: vxge_hw_vpath_mac_addr_get_next
  *
@@ -1808,14 +1801,13 @@ vxge_hw_vpath_mac_addr_get(
 }
 
 /**
- * vxge_hw_vpath_mac_addr_get_next - Get the next mac address entry for this
- * vpath
- *               from MAC address table.
+ * vxge_hw_vpath_mac_addr_get_next - Get the next mac address entry
  * @vp: Vpath handle.
  * @macaddr: Next MAC address entry for this vpath in the list
  * @macaddr_mask: MAC address mask for macaddr
  *
- * Returns the next mac address and mac address mask in the list for this
+ * Get the next mac address entry for this vpath from MAC address table.
+ * Return: the next mac address and mac address mask in the list for this
  * vpath.
  * see also: vxge_hw_vpath_mac_addr_get
  *
@@ -1861,8 +1853,7 @@ vxge_hw_vpath_mac_addr_get_next(
 }
 
 /**
- * vxge_hw_vpath_mac_addr_delete - Delete the mac address entry for this vpath
- *               to MAC address table.
+ * vxge_hw_vpath_mac_addr_delete - Delete the mac address entry for this vpath to MAC address table.
  * @vp: Vpath handle.
  * @macaddr: MAC address to be added for this vpath into the list
  * @macaddr_mask: MAC address mask for macaddr
@@ -1908,8 +1899,7 @@ vxge_hw_vpath_mac_addr_delete(
 }
 
 /**
- * vxge_hw_vpath_vid_add - Add the vlan id entry for this vpath
- *               to vlan id table.
+ * vxge_hw_vpath_vid_add - Add the vlan id entry for this vpath to vlan id table.
  * @vp: Vpath handle.
  * @vid: vlan id to be added for this vpath into the list
  *
@@ -2403,9 +2393,11 @@ enum vxge_hw_status vxge_hw_vpath_poll_rx(struct __vxge_hw_ring *ring)
 }
 
 /**
- * vxge_hw_vpath_poll_tx - Poll Tx for completed descriptors and process
- * the same.
+ * vxge_hw_vpath_poll_tx - Poll Tx for completed descriptors and process the same.
  * @fifo: Handle to the fifo object used for non offload send
+ * @skb_ptr: pointer to skb
+ * @nr_skb: number of skbs
+ * @more: more is coming
  *
  * The function polls the Tx for the completed descriptors and calls
  * the driver via supplied completion callback.
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
index b36aa5bf3c5f..a58f14aca10c 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
@@ -8,7 +8,7 @@
 #include "pch_gbe.h"
 #include "pch_gbe_phy.h"
 
-/**
+/*
  * pch_gbe_stats - Stats item information
  */
 struct pch_gbe_stats {
@@ -24,7 +24,7 @@ struct pch_gbe_stats {
 	.offset = offsetof(struct pch_gbe_hw_stats, m),		\
 }
 
-/**
+/*
  * pch_gbe_gstrings_stats - ethtool information status name list
  */
 static const struct pch_gbe_stats pch_gbe_gstrings_stats[] = {
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 23f7c76737c9..ade8c44c01cd 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -295,7 +295,7 @@ static s32 pch_gbe_mac_read_mac_addr(struct pch_gbe_hw *hw)
 /**
  * pch_gbe_wait_clr_bit - Wait to clear a bit
  * @reg:	Pointer of register
- * @busy:	Busy bit
+ * @bit:	Busy bit
  */
 static void pch_gbe_wait_clr_bit(void *reg, u32 bit)
 {
@@ -1034,7 +1034,7 @@ static void pch_gbe_set_mode(struct pch_gbe_adapter *adapter, u16 speed,
 
 /**
  * pch_gbe_watchdog - Watchdog process
- * @data:  Board private structure
+ * @t:  timer list containing a Board private structure
  */
 static void pch_gbe_watchdog(struct timer_list *t)
 {
@@ -2270,6 +2270,7 @@ static int pch_gbe_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 /**
  * pch_gbe_tx_timeout - Respond to a Tx Hang
  * @netdev:   Network interface device structure
+ * @txqueue: index of hanging queue
  */
 static void pch_gbe_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
index dceec80fd642..81fc5a6e3221 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
@@ -13,7 +13,7 @@
 #define OPTION_DISABLED 0
 #define OPTION_ENABLED  1
 
-/**
+/*
  * TxDescriptors - Transmit Descriptor Count
  * @Valid Range:   PCH_GBE_MIN_TXD - PCH_GBE_MAX_TXD
  * @Default Value: PCH_GBE_DEFAULT_TXD
@@ -22,7 +22,7 @@ static int TxDescriptors = OPTION_UNSET;
 module_param(TxDescriptors, int, 0);
 MODULE_PARM_DESC(TxDescriptors, "Number of transmit descriptors");
 
-/**
+/*
  * RxDescriptors -Receive Descriptor Count
  * @Valid Range:   PCH_GBE_MIN_RXD - PCH_GBE_MAX_RXD
  * @Default Value: PCH_GBE_DEFAULT_RXD
@@ -31,7 +31,7 @@ static int RxDescriptors = OPTION_UNSET;
 module_param(RxDescriptors, int, 0);
 MODULE_PARM_DESC(RxDescriptors, "Number of receive descriptors");
 
-/**
+/*
  * Speed - User Specified Speed Override
  * @Valid Range: 0, 10, 100, 1000
  *   - 0:    auto-negotiate at all supported speeds
@@ -44,7 +44,7 @@ static int Speed = OPTION_UNSET;
 module_param(Speed, int, 0);
 MODULE_PARM_DESC(Speed, "Speed setting");
 
-/**
+/*
  * Duplex - User Specified Duplex Override
  * @Valid Range: 0-2
  *   - 0:  auto-negotiate for duplex
@@ -59,7 +59,7 @@ MODULE_PARM_DESC(Duplex, "Duplex setting");
 #define HALF_DUPLEX 1
 #define FULL_DUPLEX 2
 
-/**
+/*
  * AutoNeg - Auto-negotiation Advertisement Override
  * @Valid Range: 0x01-0x0F, 0x20-0x2F
  *
@@ -85,7 +85,7 @@ MODULE_PARM_DESC(AutoNeg, "Advertised auto-negotiation setting");
 #define PHY_ADVERTISE_1000_FULL    0x0020
 #define PCH_AUTONEG_ADVERTISE_DEFAULT   0x2F
 
-/**
+/*
  * FlowControl - User Specified Flow Control Override
  * @Valid Range: 0-3
  *    - 0:  No Flow Control
@@ -124,7 +124,7 @@ MODULE_PARM_DESC(XsumTX, "Disable or enable Transmit Checksum offload");
 
 #define PCH_GBE_DEFAULT_TX_CSUM             true	/* trueorfalse */
 
-/**
+/*
  * pch_gbe_option - Force the MAC's flow control settings
  * @hw:	            Pointer to the HW structure
  * Returns:
diff --git a/drivers/net/ethernet/packetengines/yellowfin.c b/drivers/net/ethernet/packetengines/yellowfin.c
index 3da075307178..d1dd9bc1bc7f 100644
--- a/drivers/net/ethernet/packetengines/yellowfin.c
+++ b/drivers/net/ethernet/packetengines/yellowfin.c
@@ -1060,7 +1060,7 @@ static int yellowfin_rx(struct net_device *dev)
 		struct sk_buff *rx_skb = yp->rx_skbuff[entry];
 		s16 frame_status;
 		u16 desc_status;
-		int data_size, yf_size;
+		int data_size, __maybe_unused yf_size;
 		u8 *buf_addr;
 
 		if(!desc->result_status)
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic.h b/drivers/net/ethernet/qlogic/netxen/netxen_nic.h
index 86153660d245..e5c51256243a 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic.h
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic.h
@@ -1189,9 +1189,6 @@ typedef struct {
 #define NX_FORCE_FW_RESET               0xdeaddead
 
 
-/* Fw dump levels */
-static const u32 FW_DUMP_LEVELS[] = { 0x3, 0x7, 0xf, 0x1f, 0x3f, 0x7f, 0xff };
-
 /* Flash read/write address */
 #define NX_FW_DUMP_REG1         0x00130060
 #define NX_FW_DUMP_REG2         0x001e0000
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
index c3f50ddbe824..dd22cb056d03 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
@@ -814,6 +814,9 @@ netxen_get_dump_flag(struct net_device *netdev, struct ethtool_dump *dump)
 	return 0;
 }
 
+/* Fw dump levels */
+static const u32 FW_DUMP_LEVELS[] = { 0x3, 0x7, 0xf, 0x1f, 0x3f, 0x7f, 0xff };
+
 static int
 netxen_set_dump(struct net_device *netdev, struct ethtool_dump *val)
 {
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 1166b98d8bb2..8543bf3c3484 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -292,6 +292,7 @@ static void emac_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 
 /**
  * emac_update_hw_stats - read the EMAC stat registers
+ * @adpt: pointer to adapter struct
  *
  * Reads the stats registers and write the values to adpt->stats.
  *
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 2cc8184b7e6b..971f1e54b652 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -97,7 +97,7 @@ void sxgbe_disable_eee_mode(struct sxgbe_priv_data * const priv)
 
 /**
  * sxgbe_eee_ctrl_timer
- * @arg : data hook
+ * @t: timer list containing a data
  * Description:
  *  If there is no data transfer and if we are not in LPI state,
  *  then MAC Transmitter can be moved to LPI state.
@@ -255,7 +255,7 @@ static void sxgbe_adjust_link(struct net_device *dev)
 
 /**
  * sxgbe_init_phy - PHY initialization
- * @dev: net device structure
+ * @ndev: net device structure
  * Description: it initializes the driver's PHY state, and attaches the PHY
  * to the mac driver.
  *  Return value:
@@ -364,8 +364,11 @@ static int sxgbe_init_rx_buffers(struct net_device *dev,
 /**
  * sxgbe_free_rx_buffers - free what sxgbe_init_rx_buffers() allocated
  * @dev: net device structure
+ * @p: dec pointer
+ * @i: index
+ * @dma_buf_sz: size
  * @rx_ring: ring to be freed
- * @rx_rsize: ring size
+ *
  * Description:  this function initializes the DMA RX descriptor
  */
 static void sxgbe_free_rx_buffers(struct net_device *dev,
@@ -383,6 +386,7 @@ static void sxgbe_free_rx_buffers(struct net_device *dev,
 /**
  * init_tx_ring - init the TX descriptor ring
  * @dev: net device structure
+ * @queue_no: queue
  * @tx_ring: ring to be initialised
  * @tx_rsize: ring size
  * Description:  this function initializes the DMA TX descriptor
@@ -449,6 +453,7 @@ static void free_rx_ring(struct device *dev, struct sxgbe_rx_queue *rx_ring,
 /**
  * init_rx_ring - init the RX descriptor ring
  * @dev: net device structure
+ * @queue_no: queue
  * @rx_ring: ring to be initialised
  * @rx_rsize: ring size
  * Description:  this function initializes the DMA RX descriptor
@@ -548,7 +553,7 @@ static void free_tx_ring(struct device *dev, struct sxgbe_tx_queue *tx_ring,
 
 /**
  * init_dma_desc_rings - init the RX/TX descriptor rings
- * @dev: net device structure
+ * @netd: net device structure
  * Description:  this function initializes the DMA RX/TX descriptors
  * and allocates the socket buffers. It suppors the chained and ring
  * modes.
@@ -724,7 +729,7 @@ static void sxgbe_mtl_operation_mode(struct sxgbe_priv_data *priv)
 
 /**
  * sxgbe_tx_queue_clean:
- * @priv: driver private structure
+ * @tqueue: queue pointer
  * Description: it reclaims resources after transmission completes.
  */
 static void sxgbe_tx_queue_clean(struct sxgbe_tx_queue *tqueue)
@@ -807,6 +812,7 @@ static void sxgbe_tx_all_clean(struct sxgbe_priv_data * const priv)
 /**
  * sxgbe_restart_tx_queue: irq tx error mng function
  * @priv: driver private structure
+ * @queue_num: queue number
  * Description: it cleans the descriptors and restarts the transmission
  * in case of errors.
  */
@@ -1567,6 +1573,7 @@ static int sxgbe_poll(struct napi_struct *napi, int budget)
 /**
  *  sxgbe_tx_timeout
  *  @dev : Pointer to net device structure
+ *  @txqueue: index of the hanging queue
  *  Description: this function is called when a packet transmission fails to
  *   complete within a reasonable time. The driver will mark the error in the
  *   netdev structure and arrange for the device to be reset to a sane state
diff --git a/drivers/net/ethernet/sfc/falcon/rx.c b/drivers/net/ethernet/sfc/falcon/rx.c
index 05ea3523890a..966f13e7475d 100644
--- a/drivers/net/ethernet/sfc/falcon/rx.c
+++ b/drivers/net/ethernet/sfc/falcon/rx.c
@@ -140,6 +140,7 @@ static struct page *ef4_reuse_page(struct ef4_rx_queue *rx_queue)
  * ef4_init_rx_buffers - create EF4_RX_BATCH page-based RX buffers
  *
  * @rx_queue:		Efx RX queue
+ * @atomic:		control memory allocation flags
  *
  * This allocates a batch of pages, maps them for DMA, and populates
  * struct ef4_rx_buffers for each one. Return a negative error code or
@@ -316,6 +317,7 @@ static void ef4_discard_rx_packet(struct ef4_channel *channel,
  * This will aim to fill the RX descriptor queue up to
  * @rx_queue->@max_fill. If there is insufficient atomic
  * memory to do so, a slow fill will be scheduled.
+ * @atomic: control memory allocation flags
  *
  * The caller must provide serialisation (none is used here). In practise,
  * this means this function must run from the NAPI handler, or be called
diff --git a/drivers/net/ethernet/sfc/falcon/selftest.c b/drivers/net/ethernet/sfc/falcon/selftest.c
index 147677c7c72f..6a454ac6f876 100644
--- a/drivers/net/ethernet/sfc/falcon/selftest.c
+++ b/drivers/net/ethernet/sfc/falcon/selftest.c
@@ -65,7 +65,7 @@ static const char *const ef4_interrupt_mode_names[] = {
 	STRING_TABLE_LOOKUP(efx->interrupt_mode, ef4_interrupt_mode)
 
 /**
- * ef4_loopback_state - persistent state during a loopback selftest
+ * struct ef4_loopback_state - persistent state during a loopback selftest
  * @flush:		Drop all packets in ef4_loopback_rx_packet
  * @packet_count:	Number of packets being used in this test
  * @skbs:		An array of skbs transmitted
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index a4c0445a3e88..47aa753e64bd 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -458,7 +458,7 @@ enum efx_sync_events_state {
  *	were checked for expiry
  * @rfs_expire_index: next accelerated RFS filter ID to check for expiry
  * @n_rfs_succeeded: number of successful accelerated RFS filter insertions
- * @n_rfs_failed; number of failed accelerated RFS filter insertions
+ * @n_rfs_failed: number of failed accelerated RFS filter insertions
  * @filter_work: Work item for efx_filter_rfs_expire()
  * @rps_flow_id: Flow IDs of filters allocated for accelerated RFS,
  *      indexed by filter ID
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index aae208fe6b6e..a39c5143b386 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -173,9 +173,11 @@ struct efx_ptp_match {
 
 /**
  * struct efx_ptp_event_rx - A PTP receive event (from MC)
+ * @link: list of events
  * @seq0: First part of (PTP) UUID
  * @seq1: Second part of (PTP) UUID and sequence number
  * @hwtimestamp: Event timestamp
+ * @expiry: Time which the packet arrived
  */
 struct efx_ptp_event_rx {
 	struct list_head link;
@@ -223,11 +225,13 @@ struct efx_ptp_timeset {
  *                  reset (disable, enable).
  * @rxfilter_event: Receive filter when operating
  * @rxfilter_general: Receive filter when operating
+ * @rxfilter_installed: Receive filter installed
  * @config: Current timestamp configuration
  * @enabled: PTP operation enabled
  * @mode: Mode in which PTP operating (PTP version)
  * @ns_to_nic_time: Function to convert from scalar nanoseconds to NIC time
  * @nic_to_kernel_time: Function to convert from NIC to kernel time
+ * @nic_time: contains time details
  * @nic_time.minor_max: Wrap point for NIC minor times
  * @nic_time.sync_event_diff_min: Minimum acceptable difference between time
  * in packet prefix and last MCDI time sync event i.e. how much earlier than
@@ -239,6 +243,7 @@ struct efx_ptp_timeset {
  * field in MCDI time sync event.
  * @min_synchronisation_ns: Minimum acceptable corrected sync window
  * @capabilities: Capabilities flags from the NIC
+ * @ts_corrections: contains corrections details
  * @ts_corrections.ptp_tx: Required driver correction of PTP packet transmit
  *                         timestamps
  * @ts_corrections.ptp_rx: Required driver correction of PTP packet receive
diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 869b7618e2ba..620c26f71be8 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -1301,7 +1301,7 @@ static void sis630_set_eq(struct net_device *net_dev, u8 revision)
 
 /**
  *	sis900_timer - sis900 timer routine
- *	@data: pointer to sis900 net device
+ *	@t: timer list containing a pointer to sis900 net device
  *
  *	On each timer ticks we check two things,
  *	link status (ON/OFF) and link mode (10/100/Full/Half)
@@ -1535,6 +1535,7 @@ static void sis900_read_mode(struct net_device *net_dev, int *speed, int *duplex
 /**
  *	sis900_tx_timeout - sis900 transmit timeout routine
  *	@net_dev: the net device to transmit
+ *	@txqueue: index of hanging queue
  *
  *	print transmit timeout status
  *	disable interrupts and do some tasks
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 2d5573b3dee1..6ef30252bfe0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /**
- * dwmac-rk.c - Rockchip RK3288 DWMAC specific glue layer
+ * DOC: dwmac-rk.c - Rockchip RK3288 DWMAC specific glue layer
  *
  * Copyright (C) 2014 Chen-Zhi (Roger Chen)
  *
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index df2c74bbfcff..5e13e6f18dad 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -334,7 +334,7 @@ void stmmac_disable_eee_mode(struct stmmac_priv *priv)
 
 /**
  * stmmac_eee_ctrl_timer - EEE TX SW timer.
- * @arg : data hook
+ * @t:  timer_list struct containing private info
  * Description:
  *  if there is no data transfer and if we are not in LPI state,
  *  then MAC Transmitter can be moved to LPI state.
@@ -709,7 +709,7 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
  *  a proprietary structure used to pass information to the driver.
  *  Description:
  *  This function obtain the current hardware timestamping settings
-    as requested.
+ *  as requested.
  */
 static int stmmac_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
 {
@@ -769,6 +769,7 @@ static void stmmac_release_ptp(struct stmmac_priv *priv)
 /**
  *  stmmac_mac_flow_ctrl - Configure flow control in all queues
  *  @priv: driver private structure
+ *  @duplex: duplex passed to the next function
  *  Description: It is used for configuring the flow control in all queues
  */
 static void stmmac_mac_flow_ctrl(struct stmmac_priv *priv, u32 duplex)
@@ -1942,6 +1943,7 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 /**
  * stmmac_tx_clean - to manage the transmission completion
  * @priv: driver private structure
+ * @budget: napi budget limiting this functions packet handling
  * @queue: TX queue index
  * Description: it reclaims the transmit resources after transmission completes.
  */
@@ -2335,7 +2337,7 @@ static void stmmac_tx_timer_arm(struct stmmac_priv *priv, u32 queue)
 
 /**
  * stmmac_tx_timer - mitigation sw timer for tx.
- * @data: data pointer
+ * @t: data pointer
  * Description:
  * This is the timer handler to directly invoke the stmmac_tx_clean.
  */
@@ -2598,6 +2600,7 @@ static void stmmac_safety_feat_configuration(struct stmmac_priv *priv)
 /**
  * stmmac_hw_setup - setup mac in a usable state.
  *  @dev : pointer to the device structure.
+ *  @init_ptp: initialize PTP if set
  *  Description:
  *  this is the main function to setup the HW in a usable state because the
  *  dma engine is reset, the core registers are configured (e.g. AXI,
@@ -2958,7 +2961,7 @@ static bool stmmac_vlan_insert(struct stmmac_priv *priv, struct sk_buff *skb,
  *  @priv: driver private structure
  *  @des: buffer start address
  *  @total_len: total length to fill in descriptors
- *  @last_segmant: condition for the last descriptor
+ *  @last_segment: condition for the last descriptor
  *  @queue: TX queue index
  *  Description:
  *  This function fills descriptor and request new descriptors according to
@@ -3927,6 +3930,7 @@ static int stmmac_napi_poll_tx(struct napi_struct *napi, int budget)
 /**
  *  stmmac_tx_timeout
  *  @dev : Pointer to net device structure
+ *  @txqueue: the index of the hanging transmit queue
  *  Description: this function is called when a packet transmission fails to
  *   complete within a reasonable time. The driver will mark the error in the
  *   netdev structure and arrange for the device to be reset to a sane state
@@ -5162,7 +5166,7 @@ EXPORT_SYMBOL_GPL(stmmac_suspend);
 
 /**
  * stmmac_reset_queues_param - reset queue parameters
- * @dev: device pointer
+ * @priv: device pointer
  */
 static void stmmac_reset_queues_param(struct stmmac_priv *priv)
 {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index f32317fa75c8..af34a4cadbb0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -125,6 +125,7 @@ static struct stmmac_axi *stmmac_axi_setup(struct platform_device *pdev)
 /**
  * stmmac_mtl_setup - parse DT parameters for multiple queues configuration
  * @pdev: platform device
+ * @plat: enet data
  */
 static int stmmac_mtl_setup(struct platform_device *pdev,
 			    struct plat_stmmacenet_data *plat)
@@ -360,7 +361,7 @@ static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
 
 /**
  * stmmac_of_get_mac_mode - retrieves the interface of the MAC
- * @np - device-tree node
+ * @np: - device-tree node
  * Description:
  * Similar to `of_get_phy_mode()`, this function will retrieve (from
  * the device-tree) the interface mode on the MAC side. This assumes
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index b624e177ec71..9ff894ba8d3e 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -454,8 +454,8 @@ static int cas_page_free(struct cas *cp, cas_page_t *page)
 #define RX_USED_ADD(x, y)       ((x)->used += (y))
 #define RX_USED_SET(x, y)       ((x)->used  = (y))
 #else
-#define RX_USED_ADD(x, y)
-#define RX_USED_SET(x, y)
+#define RX_USED_ADD(x, y) do { } while(0)
+#define RX_USED_SET(x, y) do { } while(0)
 #endif
 
 /* local page allocation routines for the receive buffers. jumbo pages
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index a142e4c9fc03..b8f4f419173f 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -138,7 +138,10 @@ static void print_eth_id(struct net_device *ndev)
  * @priv: NIC private structure
  * @f: fifo to initialize
  * @fsz_type: fifo size type: 0-4KB, 1-8KB, 2-16KB, 3-32KB
- * @reg_XXX: offsets of registers relative to base address
+ * @reg_CFG0: offsets of registers relative to base address
+ * @reg_CFG1: offsets of registers relative to base address
+ * @reg_RPTR: offsets of registers relative to base address
+ * @reg_WPTR: offsets of registers relative to base address
  *
  * 1K extra space is allocated at the end of the fifo to simplify
  * processing of descriptors that wraps around fifo's end
@@ -558,7 +561,7 @@ static int bdx_reset(struct bdx_priv *priv)
 
 /**
  * bdx_close - Disables a network interface
- * @netdev: network interface device structure
+ * @ndev: network interface device structure
  *
  * Returns 0, this is not allowed to fail
  *
@@ -585,7 +588,7 @@ static int bdx_close(struct net_device *ndev)
 
 /**
  * bdx_open - Called when a network interface is made active
- * @netdev: network interface device structure
+ * @ndev: network interface device structure
  *
  * Returns 0 on success, negative value on failure
  *
@@ -698,7 +701,7 @@ static int bdx_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
  * __bdx_vlan_rx_vid - private helper for adding/killing VLAN vid
  * @ndev: network device
  * @vid:  VLAN vid
- * @op:   add or kill operation
+ * @enable: enable or disable vlan
  *
  * Passes VLAN filter table to hardware
  */
@@ -729,6 +732,7 @@ static void __bdx_vlan_rx_vid(struct net_device *ndev, uint16_t vid, int enable)
 /**
  * bdx_vlan_rx_add_vid - kernel hook for adding VLAN vid to hw filtering table
  * @ndev: network device
+ * @proto: unused
  * @vid:  VLAN vid to add
  */
 static int bdx_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid)
@@ -740,6 +744,7 @@ static int bdx_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid)
 /**
  * bdx_vlan_rx_kill_vid - kernel hook for killing VLAN vid in hw filtering table
  * @ndev: network device
+ * @proto: unused
  * @vid:  VLAN vid to kill
  */
 static int bdx_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vid)
@@ -750,7 +755,7 @@ static int bdx_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vid)
 
 /**
  * bdx_change_mtu - Change the Maximum Transfer Unit
- * @netdev: network interface device structure
+ * @ndev: network interface device structure
  * @new_mtu: new value for maximum frame size
  *
  * Returns 0 on success, negative on failure
@@ -1753,6 +1758,8 @@ static void bdx_tx_cleanup(struct bdx_priv *priv)
 
 /**
  * bdx_tx_free_skbs - frees all skbs from TXD fifo.
+ * @priv: NIC private structure
+ *
  * It gets called when OS stops this dev, eg upon "ifconfig down" or rmmod
  */
 static void bdx_tx_free_skbs(struct bdx_priv *priv)
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 6614fa3089b2..d2eab5cd1e0c 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -718,7 +718,7 @@ static void cpdma_chan_set_descs(struct cpdma_ctlr *ctlr,
 		most_chan->desc_num += desc_cnt;
 }
 
-/**
+/*
  * cpdma_chan_split_pool - Splits ctrl pool between all channels.
  * Has to be called under ctlr lock
  */
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index b36d0e412d23..c7031e1960d4 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -671,7 +671,7 @@ static int emac_hash_del(struct emac_priv *priv, u8 *mac_addr)
  * emac_add_mcast - Set multicast address in the EMAC adapter (Internal)
  * @priv: The DaVinci EMAC private adapter structure
  * @action: multicast operation to perform
- * mac_addr: mac address to set
+ * @mac_addr: mac address to set
  *
  * Set multicast addresses in EMAC adapter - internal function
  *
@@ -977,6 +977,7 @@ static int emac_dev_xmit(struct sk_buff *skb, struct net_device *ndev)
 /**
  * emac_dev_tx_timeout - EMAC Transmit timeout function
  * @ndev: The DaVinci EMAC network adapter
+ * @txqueue: the index of the hung transmit queue
  *
  * Called when system detects that a skb timeout period has expired
  * potentially due to a fault in the adapter in not being able to send
@@ -1209,7 +1210,7 @@ static int emac_hw_enable(struct emac_priv *priv)
 
 /**
  * emac_poll - EMAC NAPI Poll function
- * @ndev: The DaVinci EMAC network adapter
+ * @napi: pointer to the napi_struct containing The DaVinci EMAC network adapter
  * @budget: Number of receive packets to process (as told by NAPI layer)
  *
  * NAPI Poll function implemented to process packets as per budget. We check
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 803247d51fe9..26e6b087c0e4 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -1515,7 +1515,7 @@ static void rhine_init_cam_filter(struct net_device *dev)
 
 /**
  * rhine_update_vcam - update VLAN CAM filters
- * @rp: rhine_private data of this Rhine
+ * @dev: rhine_private data of this Rhine
  *
  * Update VLAN CAM filters to match configuration change.
  */
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 722b44604ea8..b65767f9e499 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -372,7 +372,7 @@ static const struct pci_device_id velocity_pci_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, velocity_pci_id_table);
 
-/**
+/*
  *	Describe the OF device identifiers that we support in this
  *	device driver. Used for devicetree nodes.
  */
@@ -384,7 +384,7 @@ MODULE_DEVICE_TABLE(of, velocity_of_ids);
 
 /**
  *	get_chip_name	- 	identifier to name
- *	@id: chip identifier
+ *	@chip_id: chip identifier
  *
  *	Given a chip identifier return a suitable description. Returns
  *	a pointer a static string valid while the driver is loaded.
@@ -748,7 +748,7 @@ static u32 mii_check_media_mode(struct mac_regs __iomem *regs)
 /**
  *	velocity_mii_write	-	write MII data
  *	@regs: velocity registers
- *	@index: MII register index
+ *	@mii_addr: MII register index
  *	@data: 16bit data for the MII register
  *
  *	Perform a single write to an MII 16bit register. Returns zero
@@ -869,6 +869,7 @@ static u32 check_connection_type(struct mac_regs __iomem *regs)
 
 /**
  *	velocity_set_media_mode		-	set media mode
+ *	@vptr: velocity adapter
  *	@mii_status: old MII link state
  *
  *	Check the media link state and configure the flow control
@@ -1256,6 +1257,7 @@ static void mii_init(struct velocity_info *vptr, u32 mii_status)
 
 /**
  * setup_queue_timers	-	Setup interrupt timers
+ * @vptr: velocity adapter
  *
  * Setup interrupt frequency during suppression (timeout if the frame
  * count isn't filled).
@@ -1280,8 +1282,7 @@ static void setup_queue_timers(struct velocity_info *vptr)
 
 /**
  * setup_adaptive_interrupts  -  Setup interrupt suppression
- *
- * @vptr velocity adapter
+ * @vptr: velocity adapter
  *
  * The velocity is able to suppress interrupt during high interrupt load.
  * This function turns on that feature.
@@ -1722,6 +1723,7 @@ static int velocity_init_rings(struct velocity_info *vptr, int mtu)
  *	velocity_free_tx_buf	-	free transmit buffer
  *	@vptr: velocity
  *	@tdinfo: buffer
+ *	@td: transmit descriptor to free
  *
  *	Release an transmit buffer. If the buffer was preallocated then
  *	recycle it, if not then unmap the buffer.
@@ -1896,7 +1898,7 @@ static void velocity_error(struct velocity_info *vptr, int status)
 
 /**
  *	tx_srv		-	transmit interrupt service
- *	@vptr; Velocity
+ *	@vptr: Velocity
  *
  *	Scan the queues looking for transmitted packets that
  *	we can complete and clean up. Update any statistics as
@@ -1990,8 +1992,7 @@ static inline void velocity_rx_csum(struct rx_desc *rd, struct sk_buff *skb)
  *	velocity_rx_copy	-	in place Rx copy for small packets
  *	@rx_skb: network layer packet buffer candidate
  *	@pkt_size: received data size
- *	@rd: receive packet descriptor
- *	@dev: network device
+ *	@vptr: velocity adapter
  *
  *	Replace the current skb that is scheduled for Rx processing by a
  *	shorter, immediately allocated skb, if the received packet is small
@@ -2097,6 +2098,7 @@ static int velocity_receive_frame(struct velocity_info *vptr, int idx)
 /**
  *	velocity_rx_srv		-	service RX interrupt
  *	@vptr: velocity
+ *	@budget_left: remaining budget
  *
  *	Walk the receive ring of the velocity adapter and remove
  *	any received packets from the receive queue. Hand the ring
@@ -2645,7 +2647,6 @@ static const struct net_device_ops velocity_netdev_ops = {
 
 /**
  *	velocity_init_info	-	init private data
- *	@pdev: PCI device
  *	@vptr: Velocity info
  *	@info: Board type
  *
@@ -2664,7 +2665,6 @@ static void velocity_init_info(struct velocity_info *vptr,
 /**
  *	velocity_get_pci_info	-	retrieve PCI info for device
  *	@vptr: velocity device
- *	@pdev: PCI device it matches
  *
  *	Retrieve the PCI configuration space data that interests us from
  *	the kernel PCI layer
@@ -2701,7 +2701,6 @@ static int velocity_get_pci_info(struct velocity_info *vptr)
 /**
  *	velocity_get_platform_info - retrieve platform info for device
  *	@vptr: velocity device
- *	@pdev: platform device it matches
  *
  *	Retrieve the Platform configuration data that interests us
  */
@@ -2751,8 +2750,9 @@ static u32 velocity_get_link(struct net_device *dev)
 
 /**
  *	velocity_probe - set up discovered velocity device
- *	@pdev: PCI device
- *	@ent: PCI device table entry that matched
+ *	@dev: PCI device
+ *	@info: table of match
+ *	@irq: interrupt info
  *	@bustype: bus that device is connected to
  *
  *	Configure a discovered adapter from scratch. Return a negative
@@ -2969,6 +2969,7 @@ static int velocity_platform_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM_SLEEP
 /**
  *	wol_calc_crc		-	WOL CRC
+ *	@size: size of the wake mask
  *	@pattern: data pattern
  *	@mask_pattern: mask
  *
-- 
2.25.4


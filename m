Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA5F279423
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgIYWZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbgIYWZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 18:25:02 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B62C0613D4
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:02 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id v14so211055pjd.4
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zehjmNXP57LJOwQKlBteaXKw/OtlzhRkSxQvM6rRxfY=;
        b=igPD+A7+Q04GmoGBKrsyTKottPR8Qu/mYB4AJJbGXAIDDJsJsXRTXrqXUF+d/SrbwX
         +PR1YWc3Dx1lsaUkZv5aSptTk+fgC8MEXk/FZCZrnTcjBdwHtsn1oG6ymhRHUMPI93bm
         FPSSsOnX6KAgoqPtWrOl5uFfNkC2Gf7hqlhoA2eakoewSvnUdXFzGMJmlUvgXq+IjzFx
         QV7seuNTz4tjzvnGevFVQdMmRZ3oNMmrtsfSfzlVAhs47QuqUFKVELRWPJTj/F24dB6m
         j8QHPowIlwDeFabOy27dcSO/nYAgHQk94h3ZKT/5RguidRlNjgchV/6tf5P3yPLQlaoC
         xBKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zehjmNXP57LJOwQKlBteaXKw/OtlzhRkSxQvM6rRxfY=;
        b=bEKeuQLa1CsKpp0xG4W2A4uZgMMiJGPooClWaaxrndc6VQvgqJ/blZTM6yRYcM6qNE
         4Idy1PCHM5BpSG6c6I/jU30IZTu1AcLWh75KhG2VO228PxX0PeEbJvjm90LQRxaW/BQn
         nsVfieC9Gkm1e8tTZ4jmd4XSOKgMQR6f1KFfvXqjP+vfEKH5lki5LYU4pH0jQkHHREit
         2Rk798ewzXccXCDV/uu+ILViVod7iQ75gq9HqDJlpjqvmAPhc9PZj06HTLuy32ufq1DV
         +m9sdFt0ar6GuMUoSB8a2JCOTd99PwPrj4JWYd2VoHiw9HcKziAQ+aFo0/Z7ipUv7Ekc
         v3MQ==
X-Gm-Message-State: AOAM530w68znMuMFMrhPve7fTzy7OiEsEsa1q2KI1Gu56PIxHLRkAFWM
        VSPpBzcNQ1BAqQLOX0LocStG8OUOygMPqP43
X-Google-Smtp-Source: ABdhPJy2g3oMd8kCFwo8XHuLOjI4SwrUJr2E7D7y+O/kKGKqD3zvH9MbX9bS5qxWYiRwHMpe9aLUHw==
X-Received: by 2002:a17:90a:e545:: with SMTP id ei5mr584367pjb.45.1601072701179;
        Fri, 25 Sep 2020 15:25:01 -0700 (PDT)
Received: from jesse-ThinkPad-T570.lan (50-39-107-76.bvtn.or.frontiernet.net. [50.39.107.76])
        by smtp.gmail.com with ESMTPSA id q15sm169343pje.29.2020.09.25.15.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 15:25:00 -0700 (PDT)
From:   Jesse Brandeburg <jesse.brandeburg@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next v3 3/9] drivers/net/ethernet: clean up unused assignments
Date:   Fri, 25 Sep 2020 15:24:39 -0700
Message-Id: <20200925222445.74531-4-jesse.brandeburg@gmail.com>
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

As part of the W=1 compliation series, these lines all created
warnings about unused variables that were assigned a value. Most
of them are from register reads, but some are just picking up
a return value from a function and never doing anything with it.

Fixed warnings:
.../ethernet/brocade/bna/bnad.c:3280:6: warning: variable ‘rx_count’ set but not used [-Wunused-but-set-variable]
.../ethernet/brocade/bna/bnad.c:3280:6: warning: variable ‘rx_count’ set but not used [-Wunused-but-set-variable]
.../ethernet/cortina/gemini.c:512:6: warning: variable ‘val’ set but not used [-Wunused-but-set-variable]
.../ethernet/cortina/gemini.c:2110:21: warning: variable ‘config0’ set but not used [-Wunused-but-set-variable]
.../ethernet/cavium/liquidio/octeon_device.c:1327:6: warning: variable ‘val32’ set but not used [-Wunused-but-set-variable]
.../ethernet/cavium/liquidio/octeon_device.c:1358:6: warning: variable ‘val32’ set but not used [-Wunused-but-set-variable]
.../ethernet/dec/tulip/media.c:322:8: warning: variable ‘setup’ set but not used [-Wunused-but-set-variable]
.../ethernet/dec/tulip/de4x5.c:4928:13: warning: variable ‘r3’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:1652:7: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:1652:7: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:1652:7: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:1652:7: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:4981:6: warning: variable ‘rx_status’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:6510:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:6087: warning: cannot understand function prototype: 'struct hw_regs '
.../ethernet/microchip/lan743x_main.c:161:6: warning: variable ‘int_en’ set but not used [-Wunused-but-set-variable]
.../ethernet/microchip/lan743x_main.c:1702:6: warning: variable ‘int_sts’ set but not used [-Wunused-but-set-variable]
.../ethernet/microchip/lan743x_main.c:3041:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
.../ethernet/natsemi/ns83820.c:603:6: warning: variable ‘tbisr’ set but not used [-Wunused-but-set-variable]
.../ethernet/natsemi/ns83820.c:1207:11: warning: variable ‘tanar’ set but not used [-Wunused-but-set-variable]
.../ethernet/marvell/mvneta.c:754:6: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
.../ethernet/neterion/vxge/vxge-traffic.c:33:6: warning: variable ‘val64’ set but not used [-Wunused-but-set-variable]
.../ethernet/neterion/vxge/vxge-traffic.c:160:6: warning: variable ‘val64’ set but not used [-Wunused-but-set-variable]
.../ethernet/neterion/vxge/vxge-traffic.c:490:6: warning: variable ‘val32’ set but not used [-Wunused-but-set-variable]
.../ethernet/neterion/vxge/vxge-traffic.c:2378:6: warning: variable ‘val64’ set but not used [-Wunused-but-set-variable]
.../ethernet/packetengines/yellowfin.c:1063:18: warning: variable ‘yf_size’ set but not used [-Wunused-but-set-variable]
.../ethernet/realtek/8139cp.c:1242:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
.../ethernet/mellanox/mlx4/en_tx.c:858:6: warning: variable ‘ring_cons’ set but not used [-Wunused-but-set-variable]
.../ethernet/sis/sis900.c:792:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
.../ethernet/sfc/falcon/farch.c:878:11: warning: variable ‘rx_ev_pkt_type’ set but not used [-Wunused-but-set-variable]
.../ethernet/sfc/falcon/farch.c:877:23: warning: variable ‘rx_ev_mcast_pkt’ set but not used [-Wunused-but-set-variable]
.../ethernet/sfc/falcon/farch.c:877:7: warning: variable ‘rx_ev_hdr_type’ set but not used [-Wunused-but-set-variable]
.../ethernet/sfc/falcon/farch.c:876:7: warning: variable ‘rx_ev_other_err’ set but not used [-Wunused-but-set-variable]
.../ethernet/sfc/falcon/farch.c:1646:21: warning: variable ‘buftbl_min’ set but not used [-Wunused-but-set-variable]
.../ethernet/sfc/falcon/farch.c:2535:32: warning: variable ‘spec’ set but not used [-Wunused-but-set-variable]
.../ethernet/via/via-velocity.c:880:6: warning: variable ‘curr_status’ set but not used [-Wunused-but-set-variable]
.../ethernet/ti/tlan.c:656:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
.../ethernet/ti/davinci_emac.c:1230:6: warning: variable ‘num_tx_pkts’ set but not used [-Wunused-but-set-variable]
.../ethernet/synopsys/dwc-xlgmac-common.c:516:8: warning: variable ‘str’ set but not used [-Wunused-but-set-variable]
.../ethernet/ti/cpsw_new.c:1662:22: warning: variable ‘priv’ set but not used [-Wunused-but-set-variable]

The register reads should be OK, because the current
implementation of readl and friends will always execute even
without an lvalue.

When it makes sense, just remove the lvalue assignment and the
local. Other times, just remove the offending code, and
occasionally, just mark the variable as maybe unused since it
could be used in an ifdef or debug scenario.

Only compile tested with W=1.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Edward Cree <ecree@solarflare.com>
---

v3: added warnings details, Ed only acked the SFC bits
v2: addressed some comments and got rid of a few kdoc changes that snuck
    into this version.

Full list of warnings:
======================
drivers/net/ethernet/brocade/bna/bnad.c: In function ‘bnad_change_mtu’:
drivers/net/ethernet/brocade/bna/bnad.c:3280:6: warning: variable ‘rx_count’ set but not used [-Wunused-but-set-variable]
 3280 |  u32 rx_count = 0, frame, new_frame;
      |      ^~~~~~~~
drivers/net/ethernet/cortina/gemini.c: In function ‘gmac_init’:
drivers/net/ethernet/cortina/gemini.c:512:6: warning: variable ‘val’ set but not used [-Wunused-but-set-variable]
  512 |  u32 val;
      |      ^~~
drivers/net/ethernet/cortina/gemini.c: In function ‘gmac_get_ringparam’:
drivers/net/ethernet/cortina/gemini.c:2110:21: warning: variable ‘config0’ set but not used [-Wunused-but-set-variable]
 2110 |  union gmac_config0 config0;
      |                     ^~~~~~~
drivers/net/ethernet/cavium/liquidio/octeon_device.c: In function ‘lio_pci_readq’:
drivers/net/ethernet/cavium/liquidio/octeon_device.c:1327:6: warning: variable ‘val32’ set but not used [-Wunused-but-set-variable]
 1327 |  u32 val32, addrhi;
      |      ^~~~~
drivers/net/ethernet/cavium/liquidio/octeon_device.c: In function ‘lio_pci_writeq’:
drivers/net/ethernet/cavium/liquidio/octeon_device.c:1358:6: warning: variable ‘val32’ set but not used [-Wunused-but-set-variable]
 1358 |  u32 val32;
      |      ^~~~~
drivers/net/ethernet/dec/tulip/media.c: In function ‘tulip_select_media’:
drivers/net/ethernet/dec/tulip/media.c:322:8: warning: variable ‘setup’ set but not used [-Wunused-but-set-variable]
  322 |    u16 setup[5];
      |        ^~~~~
drivers/net/ethernet/dec/tulip/de4x5.c: In function ‘mii_get_oui’:
drivers/net/ethernet/dec/tulip/de4x5.c:4928:13: warning: variable ‘r3’ set but not used [-Wunused-but-set-variable]
 4928 |     int r2, r3;
      |             ^~
drivers/net/ethernet/micrel/ksz884x.c: In function ‘sw_r_table’:
drivers/net/ethernet/micrel/ksz884x.c:1652:7: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
 1652 |   u16 dummy;   \
      |       ^~~~~
drivers/net/ethernet/micrel/ksz884x.c:1676:2: note: in expansion of macro ‘HW_DELAY’
 1676 |  HW_DELAY(hw, KS884X_IACR_OFFSET);
      |  ^~~~~~~~
drivers/net/ethernet/micrel/ksz884x.c: In function ‘sw_w_table_64’:
drivers/net/ethernet/micrel/ksz884x.c:1652:7: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
 1652 |   u16 dummy;   \
      |       ^~~~~
drivers/net/ethernet/micrel/ksz884x.c:1707:2: note: in expansion of macro ‘HW_DELAY’
 1707 |  HW_DELAY(hw, KS884X_IACR_OFFSET);
      |  ^~~~~~~~
drivers/net/ethernet/micrel/ksz884x.c: In function ‘port_r_mib_cnt’:
drivers/net/ethernet/micrel/ksz884x.c:1652:7: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
 1652 |   u16 dummy;   \
      |       ^~~~~
drivers/net/ethernet/micrel/ksz884x.c:1802:2: note: in expansion of macro ‘HW_DELAY’
 1802 |  HW_DELAY(hw, KS884X_IACR_OFFSET);
      |  ^~~~~~~~
drivers/net/ethernet/micrel/ksz884x.c: In function ‘port_r_mib_pkt’:
drivers/net/ethernet/micrel/ksz884x.c:1652:7: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
 1652 |   u16 dummy;   \
      |       ^~~~~
drivers/net/ethernet/micrel/ksz884x.c:1843:3: note: in expansion of macro ‘HW_DELAY’
 1843 |   HW_DELAY(hw, KS884X_IACR_OFFSET);
      |   ^~~~~~~~
drivers/net/ethernet/micrel/ksz884x.c: In function ‘rx_proc’:
drivers/net/ethernet/micrel/ksz884x.c:4981:6: warning: variable ‘rx_status’ set but not used [-Wunused-but-set-variable]
 4981 |  int rx_status;
      |      ^~~~~~~~~
drivers/net/ethernet/micrel/ksz884x.c: In function ‘netdev_get_ethtool_stats’:
drivers/net/ethernet/micrel/ksz884x.c:6510:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
 6510 |  int rc;
      |      ^~
drivers/net/ethernet/micrel/ksz884x.c:6087: warning: cannot understand function prototype: 'struct hw_regs '
drivers/net/ethernet/microchip/lan743x_main.c: In function ‘lan743x_tx_isr’:
drivers/net/ethernet/microchip/lan743x_main.c:161:6: warning: variable ‘int_en’ set but not used [-Wunused-but-set-variable]
  161 |  u32 int_en = 0;
      |      ^~~~~~
drivers/net/ethernet/microchip/lan743x_main.c: In function ‘lan743x_tx_napi_poll’:
drivers/net/ethernet/microchip/lan743x_main.c:1702:6: warning: variable ‘int_sts’ set but not used [-Wunused-but-set-variable]
 1702 |  u32 int_sts = 0;
      |      ^~~~~~~
drivers/net/ethernet/microchip/lan743x_main.c: In function ‘lan743x_pm_suspend’:
drivers/net/ethernet/microchip/lan743x_main.c:3041:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
 3041 |  int ret;
      |      ^~~
drivers/net/ethernet/natsemi/ns83820.c: In function ‘phy_intr’:
drivers/net/ethernet/natsemi/ns83820.c:603:6: warning: variable ‘tbisr’ set but not used [-Wunused-but-set-variable]
  603 |  u32 tbisr, tanar, tanlpar;
      |      ^~~~~
drivers/net/ethernet/natsemi/ns83820.c: In function ‘ns83820_get_link_ksettings’:
drivers/net/ethernet/natsemi/ns83820.c:1207:11: warning: variable ‘tanar’ set but not used [-Wunused-but-set-variable]
 1207 |  u32 cfg, tanar, tbicr;
      |           ^~~~~
drivers/net/ethernet/marvell/mvneta.c: In function ‘mvneta_mib_counters_clear’:
drivers/net/ethernet/marvell/mvneta.c:754:6: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
  754 |  u32 dummy;
      |      ^~~~~
drivers/net/ethernet/neterion/vxge/vxge-traffic.c: In function ‘vxge_hw_vpath_intr_enable’:
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:33:6: warning: variable ‘val64’ set but not used [-Wunused-but-set-variable]
   33 |  u64 val64;
      |      ^~~~~
drivers/net/ethernet/neterion/vxge/vxge-traffic.c: In function ‘vxge_hw_vpath_intr_disable’:
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:160:6: warning: variable ‘val64’ set but not used [-Wunused-but-set-variable]
  160 |  u64 val64;
      |      ^~~~~
drivers/net/ethernet/neterion/vxge/vxge-traffic.c: In function ‘vxge_hw_device_flush_io’:
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:490:6: warning: variable ‘val32’ set but not used [-Wunused-but-set-variable]
  490 |  u32 val32;
      |      ^~~~~
drivers/net/ethernet/neterion/vxge/vxge-traffic.c: In function ‘vxge_hw_vpath_poll_rx’:
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:2378:6: warning: variable ‘val64’ set but not used [-Wunused-but-set-variable]
 2378 |  u64 val64 = 0;
      |      ^~~~~
drivers/net/ethernet/packetengines/yellowfin.c: In function ‘yellowfin_rx’:
drivers/net/ethernet/packetengines/yellowfin.c:1063:18: warning: variable ‘yf_size’ set but not used [-Wunused-but-set-variable]
 1063 |   int data_size, yf_size;
      |                  ^~~~~~~
drivers/net/ethernet/realtek/8139cp.c: In function ‘cp_tx_timeout’:
drivers/net/ethernet/realtek/8139cp.c:1242:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
 1242 |  int rc, i;
      |      ^~
drivers/net/ethernet/renesas/sh_eth.c:333:16: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[93]’)
drivers/net/ethernet/mellanox/mlx4/en_tx.c: In function ‘mlx4_en_xmit’:
drivers/net/ethernet/mellanox/mlx4/en_tx.c:858:6: warning: variable ‘ring_cons’ set but not used [-Wunused-but-set-variable]
  858 |  u32 ring_cons;
      |      ^~~~~~~~~
drivers/net/ethernet/sis/sis900.c: In function ‘sis900_set_capability’:
drivers/net/ethernet/sis/sis900.c:792:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
  792 |  u16 status;
      |      ^~~~~~
drivers/net/ethernet/sfc/falcon/farch.c: In function ‘ef4_farch_handle_rx_not_ok’:
drivers/net/ethernet/sfc/falcon/farch.c:878:11: warning: variable ‘rx_ev_pkt_type’ set but not used [-Wunused-but-set-variable]
  878 |  unsigned rx_ev_pkt_type;
      |           ^~~~~~~~~~~~~~
drivers/net/ethernet/sfc/falcon/farch.c:877:23: warning: variable ‘rx_ev_mcast_pkt’ set but not used [-Wunused-but-set-variable]
  877 |  bool rx_ev_hdr_type, rx_ev_mcast_pkt;
      |                       ^~~~~~~~~~~~~~~
drivers/net/ethernet/sfc/falcon/farch.c:877:7: warning: variable ‘rx_ev_hdr_type’ set but not used [-Wunused-but-set-variable]
  877 |  bool rx_ev_hdr_type, rx_ev_mcast_pkt;
      |       ^~~~~~~~~~~~~~
drivers/net/ethernet/sfc/falcon/farch.c:876:7: warning: variable ‘rx_ev_other_err’ set but not used [-Wunused-but-set-variable]
  876 |  bool rx_ev_other_err, rx_ev_pause_frm;
      |       ^~~~~~~~~~~~~~~
drivers/net/ethernet/sfc/falcon/farch.c: In function ‘ef4_farch_dimension_resources’:
drivers/net/ethernet/sfc/falcon/farch.c:1646:21: warning: variable ‘buftbl_min’ set but not used [-Wunused-but-set-variable]
 1646 |  unsigned vi_count, buftbl_min;
      |                     ^~~~~~~~~~
drivers/net/ethernet/sfc/falcon/farch.c: In function ‘ef4_farch_filter_remove_safe’:
drivers/net/ethernet/sfc/falcon/farch.c:2535:32: warning: variable ‘spec’ set but not used [-Wunused-but-set-variable]
 2535 |  struct ef4_farch_filter_spec *spec;
      |                                ^~~~
drivers/net/ethernet/via/via-velocity.c: In function ‘velocity_set_media_mode’:
drivers/net/ethernet/via/via-velocity.c:880:6: warning: variable ‘curr_status’ set but not used [-Wunused-but-set-variable]
  880 |  u32 curr_status;
      |      ^~~~~~~~~~~
drivers/net/ethernet/ti/tlan.c: In function ‘tlan_eisa_probe’:
drivers/net/ethernet/ti/tlan.c:656:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
  656 |  int rc = -ENODEV;
      |      ^~
drivers/net/ethernet/ti/davinci_emac.c: In function ‘emac_poll’:
drivers/net/ethernet/ti/davinci_emac.c:1230:6: warning: variable ‘num_tx_pkts’ set but not used [-Wunused-but-set-variable]
 1230 |  u32 num_tx_pkts = 0, num_rx_pkts = 0;
      |      ^~~~~~~~~~~
drivers/net/ethernet/synopsys/dwc-xlgmac-common.c: In function ‘xlgmac_print_all_hw_features’:
drivers/net/ethernet/synopsys/dwc-xlgmac-common.c:516:8: warning: variable ‘str’ set but not used [-Wunused-but-set-variable]
  516 |  char *str = NULL;
      |        ^~~
drivers/net/ethernet/ti/cpsw_new.c: In function ‘cpsw_dl_switch_mode_set’:
drivers/net/ethernet/ti/cpsw_new.c:1662:22: warning: variable ‘priv’ set but not used [-Wunused-but-set-variable]
 1662 |    struct cpsw_priv *priv;
      |                      ^~~~
---
 drivers/net/ethernet/brocade/bna/bnad.c       |  7 ++--
 drivers/net/ethernet/dec/tulip/de4x5.c        |  4 +--
 drivers/net/ethernet/dec/tulip/media.c        |  5 ---
 drivers/net/ethernet/dnet.c                   |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    |  2 +-
 drivers/net/ethernet/micrel/ksz884x.c         |  3 +-
 drivers/net/ethernet/microchip/lan743x_main.c |  6 ++--
 .../net/ethernet/neterion/vxge/vxge-traffic.c | 32 +++++++------------
 drivers/net/ethernet/sfc/falcon/farch.c       | 29 +++++++----------
 drivers/net/ethernet/sis/sis900.c             |  5 ++-
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  2 --
 drivers/net/ethernet/ti/davinci_emac.c        |  5 ++-
 drivers/net/ethernet/ti/tlan.c                |  4 +--
 drivers/net/ethernet/via/via-velocity.c       | 13 --------
 15 files changed, 37 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index cc80bbbefe87..7e4e831d720f 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3277,7 +3277,7 @@ bnad_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	int err, mtu;
 	struct bnad *bnad = netdev_priv(netdev);
-	u32 rx_count = 0, frame, new_frame;
+	u32 frame, new_frame;
 
 	mutex_lock(&bnad->conf_mutex);
 
@@ -3293,12 +3293,9 @@ bnad_change_mtu(struct net_device *netdev, int new_mtu)
 		/* only when transition is over 4K */
 		if ((frame <= 4096 && new_frame > 4096) ||
 		    (frame > 4096 && new_frame <= 4096))
-			rx_count = bnad_reinit_rx(bnad);
+			bnad_reinit_rx(bnad);
 	}
 
-	/* rx_count > 0 - new rx created
-	 *	- Linux set err = 0 and return
-	 */
 	err = bnad_mtu_set(bnad, new_frame);
 	if (err)
 		err = -EBUSY;
diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index f9dd1aa9f2da..683e328b5461 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -4925,11 +4925,11 @@ mii_get_oui(u_char phyaddr, u_long ioaddr)
 	u_char breg[2];
     } a;
     int i, r2, r3, ret=0;*/
-    int r2, r3;
+    int r2;
 
     /* Read r2 and r3 */
     r2 = mii_rd(MII_ID0, phyaddr, ioaddr);
-    r3 = mii_rd(MII_ID1, phyaddr, ioaddr);
+    mii_rd(MII_ID1, phyaddr, ioaddr);
                                                 /* SEEQ and Cypress way * /
     / * Shuffle r2 and r3 * /
     a.reg=0;
diff --git a/drivers/net/ethernet/dec/tulip/media.c b/drivers/net/ethernet/dec/tulip/media.c
index dcf21a36a9cf..011604787b8e 100644
--- a/drivers/net/ethernet/dec/tulip/media.c
+++ b/drivers/net/ethernet/dec/tulip/media.c
@@ -319,13 +319,8 @@ void tulip_select_media(struct net_device *dev, int startup)
 			break;
 		}
 		case 5: case 6: {
-			u16 setup[5];
-
 			new_csr6 = 0; /* FIXME */
 
-			for (i = 0; i < 5; i++)
-				setup[i] = get_u16(&p[i*2 + 1]);
-
 			if (startup && mtable->has_reset) {
 				struct medialeaf *rleaf = &mtable->mleaf[mtable->has_reset];
 				unsigned char *rst = rleaf->leafdata;
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 7f87b0f51404..48c6eb142dcc 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -507,10 +507,10 @@ static netdev_tx_t dnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 
 	struct dnet *bp = netdev_priv(dev);
-	u32 irq_enable;
 	unsigned int i, tx_cmd, wrsz;
 	unsigned long flags;
 	unsigned int *bufp;
+	u32 irq_enable;
 
 	dnet_readl(bp, TX_STATUS);
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index d55434449c0c..45869b29368f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -842,6 +842,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct mlx4_en_tx_desc *tx_desc;
 	struct mlx4_wqe_data_seg *data;
 	struct mlx4_en_tx_info *tx_info;
+	u32 __maybe_unused ring_cons;
 	int tx_ind;
 	int nr_txbb;
 	int desc_size;
@@ -855,7 +856,6 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	bool stop_queue;
 	bool inline_ok;
 	u8 data_offset;
-	u32 ring_cons;
 	bool bf_ok;
 
 	tx_ind = skb_get_queue_mapping(skb);
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index ac4cc509ae07..67d3d80b8366 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -1649,8 +1649,7 @@ static inline void set_tx_len(struct ksz_desc *desc, u32 len)
 
 #define HW_DELAY(hw, reg)			\
 	do {					\
-		u16 dummy;			\
-		dummy = readw(hw->io + reg);	\
+		readw(hw->io + reg);		\
 	} while (0)
 
 /**
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 7e236c9ee4b1..a1938842f828 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -158,9 +158,8 @@ static void lan743x_tx_isr(void *context, u32 int_sts, u32 flags)
 	struct lan743x_tx *tx = context;
 	struct lan743x_adapter *adapter = tx->adapter;
 	bool enable_flag = true;
-	u32 int_en = 0;
 
-	int_en = lan743x_csr_read(adapter, INT_EN_SET);
+	lan743x_csr_read(adapter, INT_EN_SET);
 	if (flags & LAN743X_VECTOR_FLAG_SOURCE_ENABLE_CLEAR) {
 		lan743x_csr_write(adapter, INT_EN_CLR,
 				  INT_BIT_DMA_TX_(tx->channel_number));
@@ -1699,10 +1698,9 @@ static int lan743x_tx_napi_poll(struct napi_struct *napi, int weight)
 	bool start_transmitter = false;
 	unsigned long irq_flags = 0;
 	u32 ioc_bit = 0;
-	u32 int_sts = 0;
 
 	ioc_bit = DMAC_INT_BIT_TX_IOC_(tx->channel_number);
-	int_sts = lan743x_csr_read(adapter, DMAC_INT_STS);
+	lan743x_csr_read(adapter, DMAC_INT_STS);
 	if (tx->vector_flags & LAN743X_VECTOR_FLAG_SOURCE_STATUS_W2C)
 		lan743x_csr_write(adapter, DMAC_INT_STS, ioc_bit);
 	spin_lock_irqsave(&tx->ring_lock, irq_flags);
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-traffic.c b/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
index 709d20d9938f..bd525e8eda10 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
@@ -30,8 +30,6 @@
  */
 enum vxge_hw_status vxge_hw_vpath_intr_enable(struct __vxge_hw_vpath_handle *vp)
 {
-	u64 val64;
-
 	struct __vxge_hw_virtualpath *vpath;
 	struct vxge_hw_vpath_reg __iomem *vp_reg;
 	enum vxge_hw_status status = VXGE_HW_OK;
@@ -84,7 +82,7 @@ enum vxge_hw_status vxge_hw_vpath_intr_enable(struct __vxge_hw_vpath_handle *vp)
 	__vxge_hw_pio_mem_write32_upper((u32)VXGE_HW_INTR_MASK_ALL,
 			&vp_reg->xgmac_vp_int_status);
 
-	val64 = readq(&vp_reg->vpath_general_int_status);
+	readq(&vp_reg->vpath_general_int_status);
 
 	/* Mask unwanted interrupts */
 
@@ -157,8 +155,6 @@ enum vxge_hw_status vxge_hw_vpath_intr_enable(struct __vxge_hw_vpath_handle *vp)
 enum vxge_hw_status vxge_hw_vpath_intr_disable(
 			struct __vxge_hw_vpath_handle *vp)
 {
-	u64 val64;
-
 	struct __vxge_hw_virtualpath *vpath;
 	enum vxge_hw_status status = VXGE_HW_OK;
 	struct vxge_hw_vpath_reg __iomem *vp_reg;
@@ -179,8 +175,6 @@ enum vxge_hw_status vxge_hw_vpath_intr_disable(
 		(u32)VXGE_HW_INTR_MASK_ALL,
 		&vp_reg->vpath_general_int_mask);
 
-	val64 = VXGE_HW_TIM_CLR_INT_EN_VP(1 << (16 - vpath->vp_id));
-
 	writeq(VXGE_HW_INTR_MASK_ALL, &vp_reg->kdfcctl_errors_mask);
 
 	__vxge_hw_pio_mem_write32_upper((u32)VXGE_HW_INTR_MASK_ALL,
@@ -487,9 +481,7 @@ void vxge_hw_device_unmask_all(struct __vxge_hw_device *hldev)
  */
 void vxge_hw_device_flush_io(struct __vxge_hw_device *hldev)
 {
-	u32 val32;
-
-	val32 = readl(&hldev->common_reg->titan_general_int_status);
+	readl(&hldev->common_reg->titan_general_int_status);
 }
 
 /**
@@ -1716,8 +1708,8 @@ void vxge_hw_fifo_txdl_free(struct __vxge_hw_fifo *fifo, void *txdlh)
 enum vxge_hw_status
 vxge_hw_vpath_mac_addr_add(
 	struct __vxge_hw_vpath_handle *vp,
-	u8 (macaddr)[ETH_ALEN],
-	u8 (macaddr_mask)[ETH_ALEN],
+	u8 *macaddr,
+	u8 *macaddr_mask,
 	enum vxge_hw_vpath_mac_addr_add_mode duplicate_mode)
 {
 	u32 i;
@@ -1779,8 +1771,8 @@ vxge_hw_vpath_mac_addr_add(
 enum vxge_hw_status
 vxge_hw_vpath_mac_addr_get(
 	struct __vxge_hw_vpath_handle *vp,
-	u8 (macaddr)[ETH_ALEN],
-	u8 (macaddr_mask)[ETH_ALEN])
+	u8 *macaddr,
+	u8 *macaddr_mask)
 {
 	u32 i;
 	u64 data1 = 0ULL;
@@ -1831,8 +1823,8 @@ vxge_hw_vpath_mac_addr_get(
 enum vxge_hw_status
 vxge_hw_vpath_mac_addr_get_next(
 	struct __vxge_hw_vpath_handle *vp,
-	u8 (macaddr)[ETH_ALEN],
-	u8 (macaddr_mask)[ETH_ALEN])
+	u8 *macaddr,
+	u8 *macaddr_mask)
 {
 	u32 i;
 	u64 data1 = 0ULL;
@@ -1884,8 +1876,8 @@ vxge_hw_vpath_mac_addr_get_next(
 enum vxge_hw_status
 vxge_hw_vpath_mac_addr_delete(
 	struct __vxge_hw_vpath_handle *vp,
-	u8 (macaddr)[ETH_ALEN],
-	u8 (macaddr_mask)[ETH_ALEN])
+	u8 *macaddr,
+	u8 *macaddr_mask)
 {
 	u32 i;
 	u64 data1 = 0ULL;
@@ -2375,7 +2367,6 @@ enum vxge_hw_status vxge_hw_vpath_poll_rx(struct __vxge_hw_ring *ring)
 	u8 t_code;
 	enum vxge_hw_status status = VXGE_HW_OK;
 	void *first_rxdh;
-	u64 val64 = 0;
 	int new_count = 0;
 
 	ring->cmpl_cnt = 0;
@@ -2403,8 +2394,7 @@ enum vxge_hw_status vxge_hw_vpath_poll_rx(struct __vxge_hw_ring *ring)
 			}
 			writeq(VXGE_HW_PRC_RXD_DOORBELL_NEW_QW_CNT(new_count),
 				&ring->vp_reg->prc_rxd_doorbell);
-			val64 =
-			  readl(&ring->common_reg->titan_general_int_status);
+			readl(&ring->common_reg->titan_general_int_status);
 			ring->doorbell_cnt = 0;
 		}
 	}
diff --git a/drivers/net/ethernet/sfc/falcon/farch.c b/drivers/net/ethernet/sfc/falcon/farch.c
index fa1ade856b10..2c91792cec01 100644
--- a/drivers/net/ethernet/sfc/falcon/farch.c
+++ b/drivers/net/ethernet/sfc/falcon/farch.c
@@ -870,17 +870,12 @@ static u16 ef4_farch_handle_rx_not_ok(struct ef4_rx_queue *rx_queue,
 {
 	struct ef4_channel *channel = ef4_rx_queue_channel(rx_queue);
 	struct ef4_nic *efx = rx_queue->efx;
-	bool rx_ev_buf_owner_id_err, rx_ev_ip_hdr_chksum_err;
+	bool __maybe_unused rx_ev_buf_owner_id_err, rx_ev_ip_hdr_chksum_err;
 	bool rx_ev_tcp_udp_chksum_err, rx_ev_eth_crc_err;
 	bool rx_ev_frm_trunc, rx_ev_drib_nib, rx_ev_tobe_disc;
-	bool rx_ev_other_err, rx_ev_pause_frm;
-	bool rx_ev_hdr_type, rx_ev_mcast_pkt;
-	unsigned rx_ev_pkt_type;
+	bool rx_ev_pause_frm;
 
-	rx_ev_hdr_type = EF4_QWORD_FIELD(*event, FSF_AZ_RX_EV_HDR_TYPE);
-	rx_ev_mcast_pkt = EF4_QWORD_FIELD(*event, FSF_AZ_RX_EV_MCAST_PKT);
 	rx_ev_tobe_disc = EF4_QWORD_FIELD(*event, FSF_AZ_RX_EV_TOBE_DISC);
-	rx_ev_pkt_type = EF4_QWORD_FIELD(*event, FSF_AZ_RX_EV_PKT_TYPE);
 	rx_ev_buf_owner_id_err = EF4_QWORD_FIELD(*event,
 						 FSF_AZ_RX_EV_BUF_OWNER_ID_ERR);
 	rx_ev_ip_hdr_chksum_err = EF4_QWORD_FIELD(*event,
@@ -893,10 +888,6 @@ static u16 ef4_farch_handle_rx_not_ok(struct ef4_rx_queue *rx_queue,
 			  0 : EF4_QWORD_FIELD(*event, FSF_AA_RX_EV_DRIB_NIB));
 	rx_ev_pause_frm = EF4_QWORD_FIELD(*event, FSF_AZ_RX_EV_PAUSE_FRM_ERR);
 
-	/* Every error apart from tobe_disc and pause_frm */
-	rx_ev_other_err = (rx_ev_drib_nib | rx_ev_tcp_udp_chksum_err |
-			   rx_ev_buf_owner_id_err | rx_ev_eth_crc_err |
-			   rx_ev_frm_trunc | rx_ev_ip_hdr_chksum_err);
 
 	/* Count errors that are not in MAC stats.  Ignore expected
 	 * checksum errors during self-test. */
@@ -916,6 +907,13 @@ static u16 ef4_farch_handle_rx_not_ok(struct ef4_rx_queue *rx_queue,
 	 * to a FIFO overflow.
 	 */
 #ifdef DEBUG
+	{
+	/* Every error apart from tobe_disc and pause_frm */
+
+	bool rx_ev_other_err = (rx_ev_drib_nib | rx_ev_tcp_udp_chksum_err |
+				rx_ev_buf_owner_id_err | rx_ev_eth_crc_err |
+				rx_ev_frm_trunc | rx_ev_ip_hdr_chksum_err);
+
 	if (rx_ev_other_err && net_ratelimit()) {
 		netif_dbg(efx, rx_err, efx->net_dev,
 			  " RX queue %d unexpected RX event "
@@ -932,6 +930,7 @@ static u16 ef4_farch_handle_rx_not_ok(struct ef4_rx_queue *rx_queue,
 			  rx_ev_tobe_disc ? " [TOBE_DISC]" : "",
 			  rx_ev_pause_frm ? " [PAUSE]" : "");
 	}
+	}
 #endif
 
 	/* The frame must be discarded if any of these are true. */
@@ -1643,15 +1642,11 @@ void ef4_farch_rx_push_indir_table(struct ef4_nic *efx)
  */
 void ef4_farch_dimension_resources(struct ef4_nic *efx, unsigned sram_lim_qw)
 {
-	unsigned vi_count, buftbl_min;
+	unsigned vi_count;
 
 	/* Account for the buffer table entries backing the datapath channels
 	 * and the descriptor caches for those channels.
 	 */
-	buftbl_min = ((efx->n_rx_channels * EF4_MAX_DMAQ_SIZE +
-		       efx->n_tx_channels * EF4_TXQ_TYPES * EF4_MAX_DMAQ_SIZE +
-		       efx->n_channels * EF4_MAX_EVQ_SIZE)
-		      * sizeof(ef4_qword_t) / EF4_BUF_SIZE);
 	vi_count = max(efx->n_channels, efx->n_tx_channels * EF4_TXQ_TYPES);
 
 	efx->tx_dc_base = sram_lim_qw - vi_count * TX_DC_ENTRIES;
@@ -2532,7 +2527,6 @@ int ef4_farch_filter_remove_safe(struct ef4_nic *efx,
 	enum ef4_farch_filter_table_id table_id;
 	struct ef4_farch_filter_table *table;
 	unsigned int filter_idx;
-	struct ef4_farch_filter_spec *spec;
 	int rc;
 
 	table_id = ef4_farch_filter_id_table_id(filter_id);
@@ -2543,7 +2537,6 @@ int ef4_farch_filter_remove_safe(struct ef4_nic *efx,
 	filter_idx = ef4_farch_filter_id_index(filter_id);
 	if (filter_idx >= table->size)
 		return -ENOENT;
-	spec = &table->spec[filter_idx];
 
 	spin_lock_bh(&efx->filter_lock);
 	rc = ef4_farch_filter_remove(efx, table, filter_idx, priority);
diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index cfa460c7db23..869b7618e2ba 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -789,10 +789,9 @@ static u16 sis900_default_phy(struct net_device * net_dev)
 static void sis900_set_capability(struct net_device *net_dev, struct mii_phy *phy)
 {
 	u16 cap;
-	u16 status;
 
-	status = mdio_read(net_dev, phy->phy_addr, MII_STATUS);
-	status = mdio_read(net_dev, phy->phy_addr, MII_STATUS);
+	mdio_read(net_dev, phy->phy_addr, MII_STATUS);
+	mdio_read(net_dev, phy->phy_addr, MII_STATUS);
 
 	cap = MII_NWAY_CSMA_CD |
 		((phy->status & MII_STAT_CAN_TX_FDX)? MII_NWAY_TX_FDX:0) |
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index eb1c6b03c329..df26cea45904 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -513,7 +513,7 @@ void xlgmac_get_all_hw_features(struct xlgmac_pdata *pdata)
 
 void xlgmac_print_all_hw_features(struct xlgmac_pdata *pdata)
 {
-	char *str = NULL;
+	char __maybe_unused *str = NULL;
 
 	XLGMAC_PR("\n");
 	XLGMAC_PR("=====================================================\n");
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 26073cd63e33..f779d2e1b5c5 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1660,12 +1660,10 @@ static int cpsw_dl_switch_mode_set(struct devlink *dl, u32 id,
 		for (i = 0; i < cpsw->data.slaves; i++) {
 			struct cpsw_slave *slave = &cpsw->slaves[i];
 			struct net_device *sl_ndev = slave->ndev;
-			struct cpsw_priv *priv;
 
 			if (!sl_ndev)
 				continue;
 
-			priv = netdev_priv(sl_ndev);
 			if (switch_en)
 				vlan = cpsw->data.default_vlan;
 			else
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index de282531f68b..b36d0e412d23 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1227,7 +1227,7 @@ static int emac_poll(struct napi_struct *napi, int budget)
 	struct net_device *ndev = priv->ndev;
 	struct device *emac_dev = &ndev->dev;
 	u32 status = 0;
-	u32 num_tx_pkts = 0, num_rx_pkts = 0;
+	u32 num_rx_pkts = 0;
 
 	/* Check interrupt vectors and call packet processing */
 	status = emac_read(EMAC_MACINVECTOR);
@@ -1238,8 +1238,7 @@ static int emac_poll(struct napi_struct *napi, int budget)
 		mask = EMAC_DM646X_MAC_IN_VECTOR_TX_INT_VEC;
 
 	if (status & mask) {
-		num_tx_pkts = cpdma_chan_process(priv->txchan,
-					      EMAC_DEF_TX_MAX_SERVICE);
+		cpdma_chan_process(priv->txchan, EMAC_DEF_TX_MAX_SERVICE);
 	} /* TX processing */
 
 	mask = EMAC_DM644X_MAC_IN_VECTOR_RX_INT_VEC;
diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 1203a3c0febb..317fad787d78 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -653,7 +653,6 @@ module_exit(tlan_exit);
 static void  __init tlan_eisa_probe(void)
 {
 	long	ioaddr;
-	int	rc = -ENODEV;
 	int	irq;
 	u16	device_id;
 
@@ -718,8 +717,7 @@ static void  __init tlan_eisa_probe(void)
 
 
 		/* Setup the newly found eisa adapter */
-		rc = tlan_probe1(NULL, ioaddr, irq,
-				 12, NULL);
+		tlan_probe1(NULL, ioaddr, irq, 12, NULL);
 		continue;
 
 out:
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 6d2a31488a74..722b44604ea8 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -877,26 +877,13 @@ static u32 check_connection_type(struct mac_regs __iomem *regs)
  */
 static int velocity_set_media_mode(struct velocity_info *vptr, u32 mii_status)
 {
-	u32 curr_status;
 	struct mac_regs __iomem *regs = vptr->mac_regs;
 
 	vptr->mii_status = mii_check_media_mode(vptr->mac_regs);
-	curr_status = vptr->mii_status & (~VELOCITY_LINK_FAIL);
 
 	/* Set mii link status */
 	set_mii_flow_control(vptr);
 
-	/*
-	   Check if new status is consistent with current status
-	   if (((mii_status & curr_status) & VELOCITY_AUTONEG_ENABLE) ||
-	       (mii_status==curr_status)) {
-	   vptr->mii_status=mii_check_media_mode(vptr->mac_regs);
-	   vptr->mii_status=check_connection_type(vptr->mac_regs);
-	   netdev_info(vptr->netdev, "Velocity link no change\n");
-	   return 0;
-	   }
-	 */
-
 	if (PHYID_GET_PHY_ID(vptr->phy_id) == PHYID_CICADA_CS8201)
 		MII_REG_BITS_ON(AUXCR_MDPPS, MII_NCONFIG, vptr->mac_regs);
 
-- 
2.25.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9079227941B
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgIYWZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbgIYWZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 18:25:02 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2364C0613D3
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:01 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id kk9so215558pjb.2
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X5/hgEufhuXujJXRBVi557fScNAZFWz1L4GP6Q9HQFE=;
        b=h2aFtug7ump4EfrHHpC8qKKo/ouOgJZxnXR83u+fdbGQ/VngInQJQV/nfV3MtA7r5J
         hVlPDqeRq7L4pbOiGL5EyWdqHKewX47y0k4zR45RJXhBz/Y9yVLuKZYln82YZT1aud/3
         hPqh/gRO+FDA77mZIxMzHOXVgFEqPC/UcrKeKYjAwFO2aetVdFruCvpLdksouAMVwvfm
         tqW4FL7SyoEQSKbpBfi8psrXHLdT7mm4eQXQLtaziKYnRS4mIkwI+21HCtPF5iZHnSjs
         U1OsvdvpDfd++MflsOnApavqF0lZEipXegoR2u4uKLYszUSBgio7v0aOOTy3v71Ecom2
         xKeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5/hgEufhuXujJXRBVi557fScNAZFWz1L4GP6Q9HQFE=;
        b=nwIzeOH0qYukbR7/hE+7pMtKZ8/r4fUa5ezXy3NRLTpGjlgkZe8wuvecXn8CmgcfPz
         IPIYEfn7mFgGl5CSRMpJzijRZRL99mm7ASI/V7ZcUs0UZ2xXZFcdqygr1FMoTCYP2AZO
         9CrwRBgZHPQa6G3oOiDJBVID8vqNQPuwWJGiL9wjzPMKX8ZUMfdmT3i/l/wvRhmK2pQ0
         eumxCy5C3ewxd85rvzWyFRrgFlZTBGE4Hv/U5YO8T93s5EYdB8LkG/fYGoFzcpixDods
         fV0E/YyLDm9zY8qd4XZvQUjd57qHUA6kk8zOoo9GU5O8eOeS9a4Eqqv4zsqkvzdmn0N6
         8bLA==
X-Gm-Message-State: AOAM533h0GuYWEDq0fadN70iuagl7zGRq/g8Npzk5CsQDwASX0ev+GcK
        aZ0MLFDVcqmLGmZbe6vWsX/70TU8SlqU79tu
X-Google-Smtp-Source: ABdhPJzRdBWpod1A6xDxlsencZuedWRHC2p3cVhlvcJNZHMibHmhfqE7P6vaKvDZsCRhO72Henqbpw==
X-Received: by 2002:a17:90b:3505:: with SMTP id ls5mr609752pjb.105.1601072699206;
        Fri, 25 Sep 2020 15:24:59 -0700 (PDT)
Received: from jesse-ThinkPad-T570.lan (50-39-107-76.bvtn.or.frontiernet.net. [50.39.107.76])
        by smtp.gmail.com with ESMTPSA id q15sm169343pje.29.2020.09.25.15.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 15:24:58 -0700 (PDT)
From:   Jesse Brandeburg <jesse.brandeburg@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [PATCH net-next v3 1/9] intel-ethernet: clean up W=1 warnings in kdoc
Date:   Fri, 25 Sep 2020 15:24:37 -0700
Message-Id: <20200925222445.74531-2-jesse.brandeburg@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
References: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

This takes care of all of the trivial W=1 fixes in the Intel
Ethernet drivers, which allows developers and maintainers to
build more of the networking tree with more complete warning
checks.

There are three classes of kdoc warnings fixed:
 - cannot understand function prototype: 'x'
 - Excess function parameter 'x' description in 'y'
 - Function parameter or member 'x' not described in 'y'

All of the changes were trivial comment updates on
function headers.

Inspired by Lee Jones' series of wireless work to do the same.
Compile tested only, and passes simple test of
$ git ls-files *.[ch] | egrep drivers/net/ethernet/intel | \
  xargs scripts/kernel-doc -none

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
---

v3: added tested-by, united previous v1,v2 patches to intel drivers
    into this patch.

Full list of warnings fixed:
git ls-files *.[ch] | egrep drivers/net/ethernet/intel | xargs scripts/kernel-doc -none
drivers/net/ethernet/intel/e100.c:391: warning: cannot understand function prototype: 'enum cb_command '
drivers/net/ethernet/intel/e1000/e1000_hw.c:1908: warning: Excess function parameter 'mii_reg' description in 'e1000_config_mac_to_phy'
drivers/net/ethernet/intel/e1000/e1000_hw.c:2931: warning: Function parameter or member 'phy_data' not described in 'e1000_write_phy_reg'
drivers/net/ethernet/intel/e1000/e1000_hw.c:2931: warning: Excess function parameter 'data' description in 'e1000_write_phy_reg'
drivers/net/ethernet/intel/e1000/e1000_hw.c:4789: warning: Excess function parameter 'tx_packets' description in 'e1000_update_adaptive'
drivers/net/ethernet/intel/e1000/e1000_hw.c:4789: warning: Excess function parameter 'total_collisions' description in 'e1000_update_adaptive'
drivers/net/ethernet/intel/e1000/e1000_hw.c:5080: warning: Excess function parameter 'downshift' description in 'e1000_check_downshift'
drivers/net/ethernet/intel/e1000/e1000_main.c:208: warning: Function parameter or member 'hw' not described in 'e1000_get_hw_dev'
drivers/net/ethernet/intel/e1000/e1000_main.c:361: warning: Function parameter or member 'adapter' not described in 'e1000_configure'
drivers/net/ethernet/intel/e1000/e1000_main.c:3495: warning: Function parameter or member 'txqueue' not described in 'e1000_tx_timeout'
drivers/net/ethernet/intel/e1000/e1000_main.c:3794: warning: Function parameter or member 'napi' not described in 'e1000_clean'
drivers/net/ethernet/intel/e1000/e1000_main.c:3794: warning: Function parameter or member 'budget' not described in 'e1000_clean'
drivers/net/ethernet/intel/e1000/e1000_main.c:3794: warning: Excess function parameter 'adapter' description in 'e1000_clean'
drivers/net/ethernet/intel/e1000/e1000_main.c:3825: warning: Function parameter or member 'tx_ring' not described in 'e1000_clean_tx_irq'
drivers/net/ethernet/intel/e1000/e1000_main.c:3941: warning: Function parameter or member 'skb' not described in 'e1000_rx_checksum'
drivers/net/ethernet/intel/e1000/e1000_main.c:3941: warning: Excess function parameter 'sk_buff' description in 'e1000_rx_checksum'
drivers/net/ethernet/intel/e1000/e1000_main.c:3977: warning: Function parameter or member 'bi' not described in 'e1000_consume_page'
drivers/net/ethernet/intel/e1000/e1000_main.c:3977: warning: Function parameter or member 'skb' not described in 'e1000_consume_page'
drivers/net/ethernet/intel/e1000/e1000_main.c:3977: warning: Function parameter or member 'length' not described in 'e1000_consume_page'
drivers/net/ethernet/intel/e1000/e1000_main.c:4015: warning: Function parameter or member 'stats' not described in 'e1000_tbi_adjust_stats'
drivers/net/ethernet/intel/e1000/e1000_main.c:4556: warning: Function parameter or member 'rx_ring' not described in 'e1000_alloc_rx_buffers'
drivers/net/ethernet/intel/e1000/e1000_main.c:4556: warning: Function parameter or member 'cleaned_count' not described in 'e1000_alloc_rx_buffers'
drivers/net/ethernet/intel/e1000/e1000_main.c:4669: warning: Function parameter or member 'adapter' not described in 'e1000_smartspeed'
drivers/net/ethernet/intel/e1000/e1000_main.c:4728: warning: Function parameter or member 'netdev' not described in 'e1000_ioctl'
drivers/net/ethernet/intel/e1000/e1000_main.c:4728: warning: Function parameter or member 'ifr' not described in 'e1000_ioctl'
drivers/net/ethernet/intel/e1000/e1000_main.c:4728: warning: Function parameter or member 'cmd' not described in 'e1000_ioctl'
drivers/net/ethernet/intel/e1000/e1000_main.c:4747: warning: Function parameter or member 'netdev' not described in 'e1000_mii_ioctl'
drivers/net/ethernet/intel/e1000/e1000_main.c:4747: warning: Function parameter or member 'ifr' not described in 'e1000_mii_ioctl'
drivers/net/ethernet/intel/e1000/e1000_main.c:4747: warning: Function parameter or member 'cmd' not described in 'e1000_mii_ioctl'
drivers/net/ethernet/intel/e1000e/80003es2lan.c:1082: warning: Excess function parameter 'duplex' description in 'e1000_cfg_on_link_up_80003es2lan'
drivers/net/ethernet/intel/e1000e/ich8lan.c:755: warning: Function parameter or member 'address' not described in '__e1000_access_emi_reg_locked'
drivers/net/ethernet/intel/e1000e/ich8lan.c:755: warning: Excess function parameter 'addr' description in '__e1000_access_emi_reg_locked'
drivers/net/ethernet/intel/e1000e/ich8lan.c:2278: warning: Function parameter or member 'k1_enable' not described in 'e1000_configure_k1_ich8lan'
drivers/net/ethernet/intel/e1000e/ich8lan.c:2278: warning: Excess function parameter 'enable' description in 'e1000_configure_k1_ich8lan'
drivers/net/ethernet/intel/e1000e/ich8lan.c:2413: warning: Function parameter or member 'hw' not described in 'e1000_hv_phy_workarounds_ich8lan'
drivers/net/ethernet/intel/e1000e/ich8lan.c:2702: warning: Function parameter or member 'hw' not described in 'e1000_lv_phy_workarounds_ich8lan'
drivers/net/ethernet/intel/e1000e/netdev.c:507: warning: Function parameter or member 'ring' not described in 'e1000_desc_unused'
drivers/net/ethernet/intel/e1000e/netdev.c:588: warning: Function parameter or member 'netdev' not described in 'e1000_receive_skb'
drivers/net/ethernet/intel/e1000e/netdev.c:610: warning: Function parameter or member 'skb' not described in 'e1000_rx_checksum'
drivers/net/ethernet/intel/e1000e/netdev.c:610: warning: Excess function parameter 'csum' description in 'e1000_rx_checksum'
drivers/net/ethernet/intel/e1000e/netdev.c:610: warning: Excess function parameter 'sk_buff' description in 'e1000_rx_checksum'
drivers/net/ethernet/intel/e1000e/netdev.c:680: warning: Function parameter or member 'cleaned_count' not described in 'e1000_alloc_rx_buffers'
drivers/net/ethernet/intel/e1000e/netdev.c:680: warning: Function parameter or member 'gfp' not described in 'e1000_alloc_rx_buffers'
drivers/net/ethernet/intel/e1000e/netdev.c:748: warning: Function parameter or member 'cleaned_count' not described in 'e1000_alloc_rx_buffers_ps'
drivers/net/ethernet/intel/e1000e/netdev.c:748: warning: Function parameter or member 'gfp' not described in 'e1000_alloc_rx_buffers_ps'
drivers/net/ethernet/intel/e1000e/netdev.c:852: warning: Function parameter or member 'gfp' not described in 'e1000_alloc_jumbo_rx_buffers'
drivers/net/ethernet/intel/e1000e/netdev.c:943: warning: Function parameter or member 'work_done' not described in 'e1000_clean_rx_irq'
drivers/net/ethernet/intel/e1000e/netdev.c:943: warning: Function parameter or member 'work_to_do' not described in 'e1000_clean_rx_irq'
drivers/net/ethernet/intel/e1000e/netdev.c:1337: warning: Function parameter or member 'work_done' not described in 'e1000_clean_rx_irq_ps'
drivers/net/ethernet/intel/e1000e/netdev.c:1337: warning: Function parameter or member 'work_to_do' not described in 'e1000_clean_rx_irq_ps'
drivers/net/ethernet/intel/e1000e/netdev.c:1526: warning: Function parameter or member 'bi' not described in 'e1000_consume_page'
drivers/net/ethernet/intel/e1000e/netdev.c:1526: warning: Function parameter or member 'skb' not described in 'e1000_consume_page'
drivers/net/ethernet/intel/e1000e/netdev.c:1526: warning: Function parameter or member 'length' not described in 'e1000_consume_page'
drivers/net/ethernet/intel/e1000e/netdev.c:1542: warning: Function parameter or member 'rx_ring' not described in 'e1000_clean_jumbo_rx_irq'
drivers/net/ethernet/intel/e1000e/netdev.c:1542: warning: Function parameter or member 'work_done' not described in 'e1000_clean_jumbo_rx_irq'
drivers/net/ethernet/intel/e1000e/netdev.c:1542: warning: Function parameter or member 'work_to_do' not described in 'e1000_clean_jumbo_rx_irq'
drivers/net/ethernet/intel/e1000e/netdev.c:1542: warning: Excess function parameter 'adapter' description in 'e1000_clean_jumbo_rx_irq'
drivers/net/ethernet/intel/e1000e/netdev.c:2003: warning: Function parameter or member 'adapter' not described in 'e1000_configure_msix'
drivers/net/ethernet/intel/e1000e/netdev.c:2081: warning: Function parameter or member 'adapter' not described in 'e1000e_set_interrupt_capability'
drivers/net/ethernet/intel/e1000e/netdev.c:2136: warning: Function parameter or member 'adapter' not described in 'e1000_request_msix'
drivers/net/ethernet/intel/e1000e/netdev.c:2189: warning: Function parameter or member 'adapter' not described in 'e1000_request_irq'
drivers/net/ethernet/intel/e1000e/netdev.c:2246: warning: Function parameter or member 'adapter' not described in 'e1000_irq_disable'
drivers/net/ethernet/intel/e1000e/netdev.c:2268: warning: Function parameter or member 'adapter' not described in 'e1000_irq_enable'
drivers/net/ethernet/intel/e1000e/netdev.c:2339: warning: Function parameter or member 'adapter' not described in 'e1000_alloc_ring_dma'
drivers/net/ethernet/intel/e1000e/netdev.c:2339: warning: Function parameter or member 'ring' not described in 'e1000_alloc_ring_dma'
drivers/net/ethernet/intel/e1000e/netdev.c:2526: warning: Excess function parameter 'adapter' description in 'e1000_update_itr'
drivers/net/ethernet/intel/e1000e/netdev.c:3058: warning: Function parameter or member 'S' not described in 'PAGE_USE_COUNT'
drivers/net/ethernet/intel/e1000e/netdev.c:3058: warning: Excess function parameter 'adapter' description in 'PAGE_USE_COUNT'
drivers/net/ethernet/intel/e1000e/netdev.c:3623: warning: Function parameter or member 'config' not described in 'e1000e_config_hwtstamp'
drivers/net/ethernet/intel/e1000e/netdev.c:3817: warning: Function parameter or member 'adapter' not described in 'e1000_power_down_phy'
drivers/net/ethernet/intel/e1000e/netdev.c:3831: warning: Function parameter or member 'adapter' not described in 'e1000_flush_tx_ring'
drivers/net/ethernet/intel/e1000e/netdev.c:3862: warning: Function parameter or member 'adapter' not described in 'e1000_flush_rx_ring'
drivers/net/ethernet/intel/e1000e/netdev.c:3900: warning: Function parameter or member 'adapter' not described in 'e1000_flush_desc_rings'
drivers/net/ethernet/intel/e1000e/netdev.c:3979: warning: Function parameter or member 'adapter' not described in 'e1000e_reset'
drivers/net/ethernet/intel/e1000e/netdev.c:4857: warning: Function parameter or member 't' not described in 'e1000_update_phy_info'
drivers/net/ethernet/intel/e1000e/netdev.c:4857: warning: Excess function parameter 'data' description in 'e1000_update_phy_info'
drivers/net/ethernet/intel/e1000e/netdev.c:5194: warning: Function parameter or member 't' not described in 'e1000_watchdog'
drivers/net/ethernet/intel/e1000e/netdev.c:5194: warning: Excess function parameter 'data' description in 'e1000_watchdog'
drivers/net/ethernet/intel/e1000e/netdev.c:5978: warning: Function parameter or member 'txqueue' not described in 'e1000_tx_timeout'
drivers/net/ethernet/intel/e1000e/netdev.c:6192: warning: Function parameter or member 'ifr' not described in 'e1000e_hwtstamp_set'
drivers/net/ethernet/intel/e1000e/netdev.c:6192: warning: Excess function parameter 'ifreq' description in 'e1000e_hwtstamp_set'
drivers/net/ethernet/intel/e1000e/phy.c:2319: warning: Function parameter or member 'reg' not described in 'e1000_get_phy_addr_for_bm_page'
drivers/net/ethernet/intel/e1000e/phy.c:2739: warning: Function parameter or member 'page_set' not described in '__e1000_read_phy_reg_hv'
drivers/net/ethernet/intel/e1000e/phy.c:2846: warning: Function parameter or member 'page_set' not described in '__e1000_write_phy_reg_hv'
drivers/net/ethernet/intel/e1000e/ptp.c:155: warning: Function parameter or member 'xtstamp' not described in 'e1000e_phc_getcrosststamp'
drivers/net/ethernet/intel/e1000e/ptp.c:155: warning: Excess function parameter 'cts' description in 'e1000e_phc_getcrosststamp'
drivers/net/ethernet/intel/i40e/i40e_adminq.h:93: warning: Function parameter or member 'aq_ret' not described in 'i40e_aq_rc_to_posix'
drivers/net/ethernet/intel/i40e/i40e_adminq.h:93: warning: Function parameter or member 'aq_rc' not described in 'i40e_aq_rc_to_posix'
drivers/net/ethernet/intel/i40e/i40e_client.c:287: warning: Excess function parameter 'client' description in 'i40e_client_add_instance'
drivers/net/ethernet/intel/i40e/i40e_client.c:287: warning: Excess function parameter 'existing' description in 'i40e_client_add_instance'
drivers/net/ethernet/intel/i40e/i40e_common.c:3779: warning: Excess function parameter 'buff' description in 'i40e_aq_start_lldp'
drivers/net/ethernet/intel/i40e/i40e_common.c:3779: warning: Excess function parameter 'buff_size' description in 'i40e_aq_start_lldp'
drivers/net/ethernet/intel/i40e/i40e_common.c:5414: warning: Function parameter or member 'page_change' not described in 'i40e_aq_set_phy_register_ext'
drivers/net/ethernet/intel/i40e/i40e_common.c:5458: warning: Function parameter or member 'page_change' not described in 'i40e_aq_get_phy_register_ext'
drivers/net/ethernet/intel/i40e/i40e_main.c:297: warning: Function parameter or member 'txqueue' not described in 'i40e_tx_timeout'
drivers/net/ethernet/intel/i40e/i40e_main.c:1616: warning: Function parameter or member 'lut' not described in 'i40e_config_rss_aq'
drivers/net/ethernet/intel/i40e/i40e_main.c:1616: warning: Function parameter or member 'lut_size' not described in 'i40e_config_rss_aq'
drivers/net/ethernet/intel/i40e/i40e_main.c:5828: warning: Excess function parameter 'vsi' description in 'i40e_channel_setup_queue_map'
drivers/net/ethernet/intel/i40e/i40e_main.c:6071: warning: Function parameter or member 'vsi' not described in 'i40e_setup_channel'
drivers/net/ethernet/intel/i40e/i40e_main.c:6071: warning: Excess function parameter 'type' description in 'i40e_setup_channel'
drivers/net/ethernet/intel/i40e/i40e_main.c:6071: warning: Excess function parameter 'uplink_seid' description in 'i40e_setup_channel'
drivers/net/ethernet/intel/i40e/i40e_main.c:7791: warning: Function parameter or member 'f' not described in 'i40e_parse_cls_flower'
drivers/net/ethernet/intel/i40e/i40e_main.c:7791: warning: Excess function parameter 'cls_flower' description in 'i40e_parse_cls_flower'
drivers/net/ethernet/intel/i40e/i40e_main.c:8170: warning: Function parameter or member 'np' not described in 'i40e_setup_tc_cls_flower'
drivers/net/ethernet/intel/i40e/i40e_main.c:8170: warning: Function parameter or member 'cls_flower' not described in 'i40e_setup_tc_cls_flower'
drivers/net/ethernet/intel/i40e/i40e_main.c:8170: warning: Excess function parameter 'netdev' description in 'i40e_setup_tc_cls_flower'
drivers/net/ethernet/intel/i40e/i40e_main.c:8170: warning: Excess function parameter 'type_data' description in 'i40e_setup_tc_cls_flower'
drivers/net/ethernet/intel/i40e/i40e_main.c:9593: warning: Function parameter or member 'list_type' not described in 'i40e_get_capabilities'
drivers/net/ethernet/intel/i40e/i40e_main.c:10554: warning: Function parameter or member 't' not described in 'i40e_service_timer'
drivers/net/ethernet/intel/i40e/i40e_main.c:10554: warning: Excess function parameter 'data' description in 'i40e_service_timer'
drivers/net/ethernet/intel/i40e/i40e_main.c:12384: warning: Function parameter or member 'extack' not described in 'i40e_ndo_fdb_add'
drivers/net/ethernet/intel/i40e/i40e_ptp.c:271: warning: Excess function parameter 'vsi' description in 'i40e_ptp_rx_hang'
drivers/net/ethernet/intel/i40e/i40e_trace.h:46: warning: Function parameter or member 'trace_name' not described in '_I40E_TRACE_NAME'
drivers/net/ethernet/intel/i40e/i40e_txrx.c:1767: warning: Excess function parameter 'rx_ptype' description in 'i40e_process_skb_fields'
drivers/net/ethernet/intel/i40e/i40e_txrx.c:3521: warning: Function parameter or member 'xdpf' not described in 'i40e_xmit_xdp_ring'
drivers/net/ethernet/intel/i40e/i40e_txrx.c:3521: warning: Excess function parameter 'xdp' description in 'i40e_xmit_xdp_ring'
drivers/net/ethernet/intel/i40e/i40e_txrx.c:3721: warning: Function parameter or member 'n' not described in 'i40e_xdp_xmit'
drivers/net/ethernet/intel/i40e/i40e_txrx.c:3721: warning: Function parameter or member 'frames' not described in 'i40e_xdp_xmit'
drivers/net/ethernet/intel/i40e/i40e_txrx.c:3721: warning: Function parameter or member 'flags' not described in 'i40e_xdp_xmit'
drivers/net/ethernet/intel/i40e/i40e_txrx.c:3721: warning: Excess function parameter 'xdp' description in 'i40e_xdp_xmit'
drivers/net/ethernet/intel/i40e/i40e_txrx.h:493: warning: Excess function parameter 'tx_ring' description in 'i40e_xmit_descriptor_count'
drivers/net/ethernet/intel/i40e/i40e_txrx_common.h:30: warning: Function parameter or member 'td_cmd' not described in 'build_ctob'
drivers/net/ethernet/intel/i40e/i40e_txrx_common.h:30: warning: Function parameter or member 'td_offset' not described in 'build_ctob'
drivers/net/ethernet/intel/i40e/i40e_txrx_common.h:30: warning: Function parameter or member 'size' not described in 'build_ctob'
drivers/net/ethernet/intel/i40e/i40e_txrx_common.h:30: warning: Function parameter or member 'td_tag' not described in 'build_ctob'
drivers/net/ethernet/intel/i40e/i40e_txrx_common.h:47: warning: Function parameter or member 'total_packets' not described in 'i40e_update_tx_stats'
drivers/net/ethernet/intel/i40e/i40e_txrx_common.h:47: warning: Excess function parameter 'total_packet' description in 'i40e_update_tx_stats'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:2246: warning: Function parameter or member 'vf' not described in 'i40e_validate_queue_map'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:3161: warning: Function parameter or member 'vf' not described in 'i40e_validate_cloud_filter'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:3161: warning: Function parameter or member 'tc_filter' not described in 'i40e_validate_cloud_filter'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:3161: warning: Excess function parameter 'mask' description in 'i40e_validate_cloud_filter'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:3161: warning: Excess function parameter 'data' description in 'i40e_validate_cloud_filter'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:3291: warning: Function parameter or member 'seid' not described in 'i40e_find_vsi_from_seid'
drivers/net/ethernet/intel/iavf/iavf_adminq.h:93: warning: Function parameter or member 'aq_ret' not described in 'iavf_aq_rc_to_posix'
drivers/net/ethernet/intel/iavf/iavf_adminq.h:93: warning: Function parameter or member 'aq_rc' not described in 'iavf_aq_rc_to_posix'
drivers/net/ethernet/intel/iavf/iavf_main.c:153: warning: Function parameter or member 'txqueue' not described in 'iavf_tx_timeout'
drivers/net/ethernet/intel/iavf/iavf_main.c:2580: warning: Function parameter or member 'adapter' not described in 'iavf_del_all_cloud_filters'
drivers/net/ethernet/intel/iavf/iavf_main.c:2605: warning: Function parameter or member 'type_data' not described in '__iavf_setup_tc'
drivers/net/ethernet/intel/iavf/iavf_main.c:2605: warning: Excess function parameter 'type_date' description in '__iavf_setup_tc'
drivers/net/ethernet/intel/iavf/iavf_main.c:2700: warning: Function parameter or member 'f' not described in 'iavf_parse_cls_flower'
drivers/net/ethernet/intel/iavf/iavf_main.c:2700: warning: Excess function parameter 'cls_flower' description in 'iavf_parse_cls_flower'
drivers/net/ethernet/intel/iavf/iavf_main.c:3073: warning: Function parameter or member 'adapter' not described in 'iavf_setup_tc_cls_flower'
drivers/net/ethernet/intel/iavf/iavf_main.c:3073: warning: Function parameter or member 'cls_flower' not described in 'iavf_setup_tc_cls_flower'
drivers/net/ethernet/intel/iavf/iavf_main.c:3073: warning: Excess function parameter 'netdev' description in 'iavf_setup_tc_cls_flower'
drivers/net/ethernet/intel/iavf/iavf_main.c:3073: warning: Excess function parameter 'type_data' description in 'iavf_setup_tc_cls_flower'
drivers/net/ethernet/intel/iavf/iavf_main.c:3125: warning: Function parameter or member 'type_data' not described in 'iavf_setup_tc'
drivers/net/ethernet/intel/iavf/iavf_main.c:3125: warning: Excess function parameter 'type_date' description in 'iavf_setup_tc'
drivers/net/ethernet/intel/iavf/iavf_main.c:3778: warning: Function parameter or member 'dev_d' not described in 'iavf_suspend'
drivers/net/ethernet/intel/iavf/iavf_main.c:3778: warning: Excess function parameter 'pdev' description in 'iavf_suspend'
drivers/net/ethernet/intel/iavf/iavf_main.c:3778: warning: Excess function parameter 'state' description in 'iavf_suspend'
drivers/net/ethernet/intel/iavf/iavf_main.c:3808: warning: Function parameter or member 'dev_d' not described in 'iavf_resume'
drivers/net/ethernet/intel/iavf/iavf_main.c:3808: warning: Excess function parameter 'pdev' description in 'iavf_resume'
drivers/net/ethernet/intel/iavf/iavf_trace.h:46: warning: Function parameter or member 'trace_name' not described in '_IAVF_TRACE_NAME'
drivers/net/ethernet/intel/iavf/iavf_txrx.h:465: warning: Excess function parameter 'tx_ring' description in 'iavf_xmit_descriptor_count'
drivers/net/ethernet/intel/iavf/iavf_txrx.h:518: warning: Cannot understand  * @ring: Tx ring to find the netdev equivalent of on line 518 - I thought it was a doc line
drivers/net/ethernet/intel/ice/ice.h:518: warning: Function parameter or member 'ring' not described in 'ice_xsk_pool'
drivers/net/ethernet/intel/ice/ice_adminq_cmd.h:1432: warning: cannot understand function prototype: 'struct ice_aqc_pf_vf_msg '
drivers/net/ethernet/intel/ice/ice_adminq_cmd.h:1899: warning: Function parameter or member 'cookie_high' not described in 'ice_aq_desc'
drivers/net/ethernet/intel/ice/ice_adminq_cmd.h:1899: warning: Function parameter or member 'cookie_low' not described in 'ice_aq_desc'
drivers/net/ethernet/intel/ice/ice_txrx.h:55: warning: Function parameter or member 'rx_buf_len' not described in 'ice_compute_pad'
drivers/net/ethernet/intel/igb/e1000_82575.c:2564: warning: Function parameter or member 'address' not described in '__igb_access_emi_reg'
drivers/net/ethernet/intel/igb/e1000_82575.c:2564: warning: Excess function parameter 'addr' description in '__igb_access_emi_reg'
drivers/net/ethernet/intel/igb/e1000_82575.c:2600: warning: Function parameter or member 'adv100M' not described in 'igb_set_eee_i350'
drivers/net/ethernet/intel/igb/e1000_82575.c:2600: warning: Excess function parameter 'adv100m' description in 'igb_set_eee_i350'
drivers/net/ethernet/intel/igb/e1000_82575.c:2656: warning: Function parameter or member 'adv100M' not described in 'igb_set_eee_i354'
drivers/net/ethernet/intel/igb/e1000_82575.c:2656: warning: Excess function parameter 'adv100m' description in 'igb_set_eee_i354'
drivers/net/ethernet/intel/igb/e1000_i210.c:368: warning: Function parameter or member 'offset' not described in 'igb_read_invm_i210'
drivers/net/ethernet/intel/igb/e1000_i210.c:368: warning: Function parameter or member '__always_unused' not described in 'igb_read_invm_i210'
drivers/net/ethernet/intel/igb/e1000_i210.c:368: warning: Excess function parameter 'words' description in 'igb_read_invm_i210'
drivers/net/ethernet/intel/igb/e1000_mac.c:176: warning: Function parameter or member 'vlvf_bypass' not described in 'igb_vfta_set'
drivers/net/ethernet/intel/igb/e1000_mbx.c:18: warning: Function parameter or member 'unlock' not described in 'igb_read_mbx'
drivers/net/ethernet/intel/igb/igb_main.c:559: warning: Function parameter or member 'data' not described in 'igb_get_i2c_data'
drivers/net/ethernet/intel/igb/igb_main.c:559: warning: Excess function parameter 'hw' description in 'igb_get_i2c_data'
drivers/net/ethernet/intel/igb/igb_main.c:559: warning: Excess function parameter 'i2cctl' description in 'igb_get_i2c_data'
drivers/net/ethernet/intel/igb/igb_main.c:3882: warning: Function parameter or member 'resuming' not described in '__igb_open'
drivers/net/ethernet/intel/igb/igb_main.c:3998: warning: Function parameter or member 'suspending' not described in '__igb_close'
drivers/net/ethernet/intel/igb/igb_main.c:5226: warning: Function parameter or member 't' not described in 'igb_watchdog'
drivers/net/ethernet/intel/igb/igb_main.c:5226: warning: Excess function parameter 'data' description in 'igb_watchdog'
drivers/net/ethernet/intel/igb/igb_main.c:6198: warning: Function parameter or member 'txqueue' not described in 'igb_tx_timeout'
drivers/net/ethernet/intel/igb/igb_main.c:8194: warning: Excess function parameter 'skb' description in 'igb_is_non_eop'
drivers/net/ethernet/intel/igb/igb_main.c:8468: warning: Function parameter or member 'rx_ring' not described in 'igb_alloc_rx_buffers'
drivers/net/ethernet/intel/igb/igb_main.c:8468: warning: Function parameter or member 'cleaned_count' not described in 'igb_alloc_rx_buffers'
drivers/net/ethernet/intel/igb/igb_main.c:8468: warning: Excess function parameter 'adapter' description in 'igb_alloc_rx_buffers'
drivers/net/ethernet/intel/igb/igb_main.c:8539: warning: Function parameter or member 'netdev' not described in 'igb_mii_ioctl'
drivers/net/ethernet/intel/igb/igb_main.c:8539: warning: Function parameter or member 'ifr' not described in 'igb_mii_ioctl'
drivers/net/ethernet/intel/igb/igb_main.c:8539: warning: Function parameter or member 'cmd' not described in 'igb_mii_ioctl'
drivers/net/ethernet/intel/igb/igb_main.c:8569: warning: Function parameter or member 'netdev' not described in 'igb_ioctl'
drivers/net/ethernet/intel/igb/igb_main.c:8569: warning: Function parameter or member 'ifr' not described in 'igb_ioctl'
drivers/net/ethernet/intel/igb/igb_main.c:8569: warning: Function parameter or member 'cmd' not described in 'igb_ioctl'
drivers/net/ethernet/intel/igb/igb_ptp.c:969: warning: Function parameter or member 'netdev' not described in 'igb_ptp_get_ts_config'
drivers/net/ethernet/intel/igb/igb_ptp.c:969: warning: Function parameter or member 'ifr' not described in 'igb_ptp_get_ts_config'
drivers/net/ethernet/intel/igb/igb_ptp.c:969: warning: Excess function parameter 'ifreq' description in 'igb_ptp_get_ts_config'
drivers/net/ethernet/intel/igb/igb_ptp.c:1150: warning: Function parameter or member 'netdev' not described in 'igb_ptp_set_ts_config'
drivers/net/ethernet/intel/igb/igb_ptp.c:1150: warning: Function parameter or member 'ifr' not described in 'igb_ptp_set_ts_config'
drivers/net/ethernet/intel/igb/igb_ptp.c:1150: warning: Excess function parameter 'ifreq' description in 'igb_ptp_set_ts_config'
drivers/net/ethernet/intel/igbvf/netdev.c:68: warning: Function parameter or member 'ring' not described in 'igbvf_desc_unused'
drivers/net/ethernet/intel/igbvf/netdev.c:68: warning: Excess function parameter 'rx_ring' description in 'igbvf_desc_unused'
drivers/net/ethernet/intel/igbvf/netdev.c:86: warning: Function parameter or member 'netdev' not described in 'igbvf_receive_skb'
drivers/net/ethernet/intel/igbvf/netdev.c:243: warning: Function parameter or member 'work_done' not described in 'igbvf_clean_rx_irq'
drivers/net/ethernet/intel/igbvf/netdev.c:243: warning: Function parameter or member 'work_to_do' not described in 'igbvf_clean_rx_irq'
drivers/net/ethernet/intel/igbvf/netdev.c:415: warning: Function parameter or member 'tx_ring' not described in 'igbvf_setup_tx_resources'
drivers/net/ethernet/intel/igbvf/netdev.c:453: warning: Function parameter or member 'rx_ring' not described in 'igbvf_setup_rx_resources'
drivers/net/ethernet/intel/igbvf/netdev.c:547: warning: Function parameter or member 'rx_ring' not described in 'igbvf_clean_rx_ring'
drivers/net/ethernet/intel/igbvf/netdev.c:547: warning: Excess function parameter 'adapter' description in 'igbvf_clean_rx_ring'
drivers/net/ethernet/intel/igbvf/netdev.c:769: warning: Function parameter or member 'tx_ring' not described in 'igbvf_clean_tx_irq'
drivers/net/ethernet/intel/igbvf/netdev.c:769: warning: Excess function parameter 'adapter' description in 'igbvf_clean_tx_irq'
drivers/net/ethernet/intel/igbvf/netdev.c:1898: warning: Function parameter or member 't' not described in 'igbvf_watchdog'
drivers/net/ethernet/intel/igbvf/netdev.c:1898: warning: Excess function parameter 'data' description in 'igbvf_watchdog'
drivers/net/ethernet/intel/igbvf/netdev.c:2378: warning: Function parameter or member 'txqueue' not described in 'igbvf_tx_timeout'
drivers/net/ethernet/intel/igc/igc_main.c:4661: warning: Function parameter or member 'ifr' not described in 'igc_ioctl'
drivers/net/ethernet/intel/igc/igc_main.c:4661: warning: Excess function parameter 'ifreq' description in 'igc_ioctl'
drivers/net/ethernet/intel/igc/igc_ptp.c:428: warning: Function parameter or member 'ifr' not described in 'igc_ptp_set_ts_config'
drivers/net/ethernet/intel/igc/igc_ptp.c:428: warning: Excess function parameter 'ifreq' description in 'igc_ptp_set_ts_config'
drivers/net/ethernet/intel/igc/igc_ptp.c:458: warning: Function parameter or member 'ifr' not described in 'igc_ptp_get_ts_config'
drivers/net/ethernet/intel/igc/igc_ptp.c:458: warning: Excess function parameter 'ifreq' description in 'igc_ptp_get_ts_config'
drivers/net/ethernet/intel/ixgb/ixgb_main.c:1118: warning: Function parameter or member 't' not described in 'ixgb_watchdog'
drivers/net/ethernet/intel/ixgb/ixgb_main.c:1118: warning: Excess function parameter 'data' description in 'ixgb_watchdog'
drivers/net/ethernet/intel/ixgb/ixgb_main.c:1539: warning: Function parameter or member 'txqueue' not described in 'ixgb_tx_timeout'
drivers/net/ethernet/intel/ixgb/ixgb_main.c:1755: warning: Function parameter or member 'napi' not described in 'ixgb_clean'
drivers/net/ethernet/intel/ixgb/ixgb_main.c:1755: warning: Function parameter or member 'budget' not described in 'ixgb_clean'
drivers/net/ethernet/intel/ixgb/ixgb_main.c:1755: warning: Excess function parameter 'adapter' description in 'ixgb_clean'
drivers/net/ethernet/intel/ixgb/ixgb_main.c:1876: warning: Function parameter or member 'skb' not described in 'ixgb_rx_checksum'
drivers/net/ethernet/intel/ixgb/ixgb_main.c:1876: warning: Excess function parameter 'sk_buff' description in 'ixgb_rx_checksum'
drivers/net/ethernet/intel/ixgb/ixgb_main.c:1931: warning: Function parameter or member 'work_done' not described in 'ixgb_clean_rx_irq'
drivers/net/ethernet/intel/ixgb/ixgb_main.c:1931: warning: Function parameter or member 'work_to_do' not described in 'ixgb_clean_rx_irq'
drivers/net/ethernet/intel/ixgb/ixgb_main.c:2050: warning: Function parameter or member 'cleaned_count' not described in 'ixgb_alloc_rx_buffers'
drivers/net/ethernet/intel/ixgb/ixgb_main.c:2223: warning: Function parameter or member 'pdev' not described in 'ixgb_io_slot_reset'
drivers/net/ethernet/intel/ixgb/ixgb_main.c:2270: warning: Function parameter or member 'pdev' not described in 'ixgb_io_resume'
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:6181: warning: Function parameter or member 'txqueue' not described in 'ixgbe_tx_timeout'
drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c:780: warning: Function parameter or member 'bus' not described in 'ixgbe_mii_bus_read'
drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c:780: warning: Excess function parameter 'hw' description in 'ixgbe_mii_bus_read'
drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c:797: warning: Function parameter or member 'bus' not described in 'ixgbe_mii_bus_write'
drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c:797: warning: Excess function parameter 'hw' description in 'ixgbe_mii_bus_write'
drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c:813: warning: Function parameter or member 'bus' not described in 'ixgbe_x550em_a_mii_bus_read'
drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c:813: warning: Excess function parameter 'hw' description in 'ixgbe_x550em_a_mii_bus_read'
drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c:831: warning: Function parameter or member 'bus' not described in 'ixgbe_x550em_a_mii_bus_write'
drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c:831: warning: Excess function parameter 'hw' description in 'ixgbe_x550em_a_mii_bus_write'
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:252: warning: Function parameter or member 'txqueue' not described in 'ixgbevf_tx_timeout'
---
 drivers/net/ethernet/intel/e100.c             |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_hw.c   |  7 +--
 drivers/net/ethernet/intel/e1000/e1000_main.c | 39 +++++++++------
 .../net/ethernet/intel/e1000e/80003es2lan.c   |  1 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c   | 16 +++---
 drivers/net/ethernet/intel/e1000e/netdev.c    | 50 ++++++++++++++-----
 drivers/net/ethernet/intel/e1000e/phy.c       |  3 ++
 drivers/net/ethernet/intel/e1000e/ptp.c       |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.h |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c |  2 -
 drivers/net/ethernet/intel/i40e/i40e_common.c |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 17 ++++---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    |  1 -
 drivers/net/ethernet/intel/i40e/i40e_trace.h  |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  7 +--
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  1 -
 .../ethernet/intel/i40e/i40e_txrx_common.h    |  6 +--
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |  9 ++--
 drivers/net/ethernet/intel/iavf/iavf_adminq.h |  4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 20 ++++----
 drivers/net/ethernet/intel/iavf/iavf_trace.h  |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.h   |  2 +-
 drivers/net/ethernet/intel/ice/ice.h          |  2 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  6 +--
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  2 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c  |  6 +--
 drivers/net/ethernet/intel/igb/e1000_i210.c   |  5 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c    |  1 +
 drivers/net/ethernet/intel/igb/e1000_mbx.c    |  1 +
 drivers/net/ethernet/intel/igb/igb_main.c     | 28 ++++++-----
 drivers/net/ethernet/intel/igb/igb_ptp.c      |  8 +--
 drivers/net/ethernet/intel/igbvf/netdev.c     | 17 +++++--
 drivers/net/ethernet/intel/igc/igc_main.c     |  2 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c      |  4 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   | 17 ++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c  |  8 +--
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  3 +-
 38 files changed, 185 insertions(+), 129 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 36da059388dc..79c7a92aed16 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -384,7 +384,7 @@ enum cb_status {
 	cb_ok       = 0x2000,
 };
 
-/**
+/*
  * cb_command - Command Block flags
  * @cb_tx_nc:  0: controller does CRC (normal),  1: CRC from skb memory
  */
diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index f1dbd7b8ee32..cf57403d88d2 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -1896,7 +1896,6 @@ void e1000_config_collision_dist(struct e1000_hw *hw)
 /**
  * e1000_config_mac_to_phy - sync phy and mac settings
  * @hw: Struct containing variables accessed by shared code
- * @mii_reg: data to write to the MII control register
  *
  * Sets MAC speed and duplex settings to reflect the those in the PHY
  * The contents of the PHY register containing the needed information need to
@@ -2921,7 +2920,7 @@ static s32 e1000_read_phy_reg_ex(struct e1000_hw *hw, u32 reg_addr,
  *
  * @hw: Struct containing variables accessed by shared code
  * @reg_addr: address of the PHY register to write
- * @data: data to write to the PHY
+ * @phy_data: data to write to the PHY
  *
  * Writes a value to a PHY register
  */
@@ -4777,8 +4776,6 @@ void e1000_reset_adaptive(struct e1000_hw *hw)
 /**
  * e1000_update_adaptive - update adaptive IFS
  * @hw: Struct containing variables accessed by shared code
- * @tx_packets: Number of transmits since last callback
- * @total_collisions: Number of collisions since last callback
  *
  * Called during the callback/watchdog routine to update IFS value based on
  * the ratio of transmits to collisions.
@@ -5063,8 +5060,6 @@ static s32 e1000_check_polarity(struct e1000_hw *hw,
 /**
  * e1000_check_downshift - Check if Downshift occurred
  * @hw: Struct containing variables accessed by shared code
- * @downshift: output parameter : 0 - No Downshift occurred.
- *                                1 - Downshift occurred.
  *
  * returns: - E1000_ERR_XXX
  *            E1000_SUCCESS
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 1e6ec081fd9d..906591614553 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -199,8 +199,10 @@ module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 
 /**
- * e1000_get_hw_dev - return device
- * used by hardware layer to print debugging information
+ * e1000_get_hw_dev - helper function for getting netdev
+ * @hw: pointer to HW struct
+ *
+ * return device used by hardware layer to print debugging information
  *
  **/
 struct net_device *e1000_get_hw_dev(struct e1000_hw *hw)
@@ -354,7 +356,7 @@ static void e1000_release_manageability(struct e1000_adapter *adapter)
 
 /**
  * e1000_configure - configure the hardware for RX and TX
- * @adapter = private board structure
+ * @adapter: private board structure
  **/
 static void e1000_configure(struct e1000_adapter *adapter)
 {
@@ -3489,8 +3491,9 @@ static void e1000_dump(struct e1000_adapter *adapter)
 /**
  * e1000_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: number of the Tx queue that hung (unused)
  **/
-static void e1000_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+static void e1000_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
@@ -3787,7 +3790,8 @@ static irqreturn_t e1000_intr(int irq, void *data)
 
 /**
  * e1000_clean - NAPI Rx polling callback
- * @adapter: board private structure
+ * @napi: napi struct containing references to driver info
+ * @budget: budget given to driver for receive packets
  **/
 static int e1000_clean(struct napi_struct *napi, int budget)
 {
@@ -3818,6 +3822,7 @@ static int e1000_clean(struct napi_struct *napi, int budget)
 /**
  * e1000_clean_tx_irq - Reclaim resources after transmit completes
  * @adapter: board private structure
+ * @tx_ring: ring to clean
  **/
 static bool e1000_clean_tx_irq(struct e1000_adapter *adapter,
 			       struct e1000_tx_ring *tx_ring)
@@ -3933,7 +3938,7 @@ static bool e1000_clean_tx_irq(struct e1000_adapter *adapter,
  * @adapter:     board private structure
  * @status_err:  receive descriptor status and error fields
  * @csum:        receive descriptor csum field
- * @sk_buff:     socket buffer with received data
+ * @skb:         socket buffer with received data
  **/
 static void e1000_rx_checksum(struct e1000_adapter *adapter, u32 status_err,
 			      u32 csum, struct sk_buff *skb)
@@ -3970,6 +3975,9 @@ static void e1000_rx_checksum(struct e1000_adapter *adapter, u32 status_err,
 
 /**
  * e1000_consume_page - helper function for jumbo Rx path
+ * @bi: software descriptor shadow data
+ * @skb: skb being modified
+ * @length: length of data being added
  **/
 static void e1000_consume_page(struct e1000_rx_buffer *bi, struct sk_buff *skb,
 			       u16 length)
@@ -4003,6 +4011,7 @@ static void e1000_receive_skb(struct e1000_adapter *adapter, u8 status,
 /**
  * e1000_tbi_adjust_stats
  * @hw: Struct containing variables accessed by shared code
+ * @stats: point to stats struct
  * @frame_len: The length of the frame in question
  * @mac_addr: The Ethernet destination address of the frame in question
  *
@@ -4548,6 +4557,8 @@ e1000_alloc_jumbo_rx_buffers(struct e1000_adapter *adapter,
 /**
  * e1000_alloc_rx_buffers - Replace used receive buffers; legacy & extended
  * @adapter: address of board private structure
+ * @rx_ring: pointer to ring struct
+ * @cleaned_count: number of new Rx buffers to try to allocate
  **/
 static void e1000_alloc_rx_buffers(struct e1000_adapter *adapter,
 				   struct e1000_rx_ring *rx_ring,
@@ -4662,7 +4673,7 @@ static void e1000_alloc_rx_buffers(struct e1000_adapter *adapter,
 
 /**
  * e1000_smartspeed - Workaround for SmartSpeed on 82541 and 82547 controllers.
- * @adapter:
+ * @adapter: address of board private structure
  **/
 static void e1000_smartspeed(struct e1000_adapter *adapter)
 {
@@ -4718,10 +4729,10 @@ static void e1000_smartspeed(struct e1000_adapter *adapter)
 }
 
 /**
- * e1000_ioctl -
- * @netdev:
- * @ifreq:
- * @cmd:
+ * e1000_ioctl - handle ioctl calls
+ * @netdev: pointer to our netdev
+ * @ifr: pointer to interface request structure
+ * @cmd: ioctl data
  **/
 static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 {
@@ -4737,9 +4748,9 @@ static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 
 /**
  * e1000_mii_ioctl -
- * @netdev:
- * @ifreq:
- * @cmd:
+ * @netdev: pointer to our netdev
+ * @ifr: pointer to interface request structure
+ * @cmd: ioctl data
  **/
 static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
 			   int cmd)
diff --git a/drivers/net/ethernet/intel/e1000e/80003es2lan.c b/drivers/net/ethernet/intel/e1000e/80003es2lan.c
index 4b103cca8a39..be9c695dde12 100644
--- a/drivers/net/ethernet/intel/e1000e/80003es2lan.c
+++ b/drivers/net/ethernet/intel/e1000e/80003es2lan.c
@@ -1072,7 +1072,6 @@ static s32 e1000_setup_copper_link_80003es2lan(struct e1000_hw *hw)
 /**
  *  e1000_cfg_on_link_up_80003es2lan - es2 link configuration after link-up
  *  @hw: pointer to the HW structure
- *  @duplex: current duplex setting
  *
  *  Configure the KMRN interface by applying last minute quirks for
  *  10/100 operation.
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index b2f2fcfdf732..ded74304e8cf 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -743,7 +743,7 @@ static s32 e1000_init_mac_params_ich8lan(struct e1000_hw *hw)
 /**
  *  __e1000_access_emi_reg_locked - Read/write EMI register
  *  @hw: pointer to the HW structure
- *  @addr: EMI address to program
+ *  @address: EMI address to program
  *  @data: pointer to value to read/write from/to the EMI address
  *  @read: boolean flag to indicate read or write
  *
@@ -2266,7 +2266,7 @@ static s32 e1000_k1_gig_workaround_hv(struct e1000_hw *hw, bool link)
 /**
  *  e1000_configure_k1_ich8lan - Configure K1 power state
  *  @hw: pointer to the HW structure
- *  @enable: K1 state to configure
+ *  @k1_enable: K1 state to configure
  *
  *  Configure the K1 power state based on the provided parameter.
  *  Assumes semaphore already acquired.
@@ -2405,8 +2405,10 @@ static s32 e1000_set_mdio_slow_mode_hv(struct e1000_hw *hw)
 }
 
 /**
- *  e1000_hv_phy_workarounds_ich8lan - A series of Phy workarounds to be
- *  done after every PHY reset.
+ *  e1000_hv_phy_workarounds_ich8lan - apply PHY workarounds
+ *  @hw: pointer to the HW structure
+ *
+ *  A series of PHY workarounds to be done after every PHY reset.
  **/
 static s32 e1000_hv_phy_workarounds_ich8lan(struct e1000_hw *hw)
 {
@@ -2694,8 +2696,10 @@ s32 e1000_lv_jumbo_workaround_ich8lan(struct e1000_hw *hw, bool enable)
 }
 
 /**
- *  e1000_lv_phy_workarounds_ich8lan - A series of Phy workarounds to be
- *  done after every PHY reset.
+ *  e1000_lv_phy_workarounds_ich8lan - apply ich8 specific workarounds
+ *  @hw: pointer to the HW structure
+ *
+ *  A series of PHY workarounds to be done after every PHY reset.
  **/
 static s32 e1000_lv_phy_workarounds_ich8lan(struct e1000_hw *hw)
 {
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 664e8ccc88d2..99f4ec9b5696 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -501,6 +501,7 @@ static void e1000e_dump(struct e1000_adapter *adapter)
 
 /**
  * e1000_desc_unused - calculate if we have unused descriptors
+ * @ring: pointer to ring struct to perform calculation on
  **/
 static int e1000_desc_unused(struct e1000_ring *ring)
 {
@@ -577,6 +578,7 @@ static void e1000e_rx_hwtstamp(struct e1000_adapter *adapter, u32 status,
 /**
  * e1000_receive_skb - helper function to handle Rx indications
  * @adapter: board private structure
+ * @netdev: pointer to netdev struct
  * @staterr: descriptor extended error and status field as written by hardware
  * @vlan: descriptor vlan field as written by hardware (no le/be conversion)
  * @skb: pointer to sk_buff to be indicated to stack
@@ -601,8 +603,7 @@ static void e1000_receive_skb(struct e1000_adapter *adapter,
  * e1000_rx_checksum - Receive Checksum Offload
  * @adapter: board private structure
  * @status_err: receive descriptor status and error fields
- * @csum: receive descriptor csum field
- * @sk_buff: socket buffer with received data
+ * @skb: socket buffer with received data
  **/
 static void e1000_rx_checksum(struct e1000_adapter *adapter, u32 status_err,
 			      struct sk_buff *skb)
@@ -673,6 +674,8 @@ static void e1000e_update_tdt_wa(struct e1000_ring *tx_ring, unsigned int i)
 /**
  * e1000_alloc_rx_buffers - Replace used receive buffers
  * @rx_ring: Rx descriptor ring
+ * @cleaned_count: number to reallocate
+ * @gfp: flags for allocation
  **/
 static void e1000_alloc_rx_buffers(struct e1000_ring *rx_ring,
 				   int cleaned_count, gfp_t gfp)
@@ -741,6 +744,8 @@ static void e1000_alloc_rx_buffers(struct e1000_ring *rx_ring,
 /**
  * e1000_alloc_rx_buffers_ps - Replace used receive buffers; packet split
  * @rx_ring: Rx descriptor ring
+ * @cleaned_count: number to reallocate
+ * @gfp: flags for allocation
  **/
 static void e1000_alloc_rx_buffers_ps(struct e1000_ring *rx_ring,
 				      int cleaned_count, gfp_t gfp)
@@ -844,6 +849,7 @@ static void e1000_alloc_rx_buffers_ps(struct e1000_ring *rx_ring,
  * e1000_alloc_jumbo_rx_buffers - Replace used jumbo receive buffers
  * @rx_ring: Rx descriptor ring
  * @cleaned_count: number of buffers to allocate this pass
+ * @gfp: flags for allocation
  **/
 
 static void e1000_alloc_jumbo_rx_buffers(struct e1000_ring *rx_ring,
@@ -933,6 +939,8 @@ static inline void e1000_rx_hash(struct net_device *netdev, __le32 rss,
 /**
  * e1000_clean_rx_irq - Send received data up the network stack
  * @rx_ring: Rx descriptor ring
+ * @work_done: output parameter for indicating completed work
+ * @work_to_do: how many packets we can clean
  *
  * the return value indicates whether actual cleaning was done, there
  * is no guarantee that everything was cleaned
@@ -1327,6 +1335,8 @@ static bool e1000_clean_tx_irq(struct e1000_ring *tx_ring)
 /**
  * e1000_clean_rx_irq_ps - Send received data up the network stack; packet split
  * @rx_ring: Rx descriptor ring
+ * @work_done: output parameter for indicating completed work
+ * @work_to_do: how many packets we can clean
  *
  * the return value indicates whether actual cleaning was done, there
  * is no guarantee that everything was cleaned
@@ -1517,9 +1527,6 @@ static bool e1000_clean_rx_irq_ps(struct e1000_ring *rx_ring, int *work_done,
 	return cleaned;
 }
 
-/**
- * e1000_consume_page - helper function
- **/
 static void e1000_consume_page(struct e1000_buffer *bi, struct sk_buff *skb,
 			       u16 length)
 {
@@ -1531,7 +1538,9 @@ static void e1000_consume_page(struct e1000_buffer *bi, struct sk_buff *skb,
 
 /**
  * e1000_clean_jumbo_rx_irq - Send received data up the network stack; legacy
- * @adapter: board private structure
+ * @rx_ring: Rx descriptor ring
+ * @work_done: output parameter for indicating completed work
+ * @work_to_do: how many packets we can clean
  *
  * the return value indicates whether actual cleaning was done, there
  * is no guarantee that everything was cleaned
@@ -1994,6 +2003,7 @@ static irqreturn_t e1000_intr_msix_rx(int __always_unused irq, void *data)
 
 /**
  * e1000_configure_msix - Configure MSI-X hardware
+ * @adapter: board private structure
  *
  * e1000_configure_msix sets up the hardware to properly
  * generate MSI-X interrupts.
@@ -2072,6 +2082,7 @@ void e1000e_reset_interrupt_capability(struct e1000_adapter *adapter)
 
 /**
  * e1000e_set_interrupt_capability - set MSI or MSI-X if supported
+ * @adapter: board private structure
  *
  * Attempt to configure interrupts using the best available
  * capabilities of the hardware and kernel.
@@ -2127,6 +2138,7 @@ void e1000e_set_interrupt_capability(struct e1000_adapter *adapter)
 
 /**
  * e1000_request_msix - Initialize MSI-X interrupts
+ * @adapter: board private structure
  *
  * e1000_request_msix allocates MSI-X vectors and requests interrupts from the
  * kernel.
@@ -2180,6 +2192,7 @@ static int e1000_request_msix(struct e1000_adapter *adapter)
 
 /**
  * e1000_request_irq - initialize interrupts
+ * @adapter: board private structure
  *
  * Attempts to configure interrupts using the best available
  * capabilities of the hardware and kernel.
@@ -2240,6 +2253,7 @@ static void e1000_free_irq(struct e1000_adapter *adapter)
 
 /**
  * e1000_irq_disable - Mask off interrupt generation on the NIC
+ * @adapter: board private structure
  **/
 static void e1000_irq_disable(struct e1000_adapter *adapter)
 {
@@ -2262,6 +2276,7 @@ static void e1000_irq_disable(struct e1000_adapter *adapter)
 
 /**
  * e1000_irq_enable - Enable default interrupt generation settings
+ * @adapter: board private structure
  **/
 static void e1000_irq_enable(struct e1000_adapter *adapter)
 {
@@ -2332,6 +2347,8 @@ void e1000e_release_hw_control(struct e1000_adapter *adapter)
 
 /**
  * e1000_alloc_ring_dma - allocate memory for a ring structure
+ * @adapter: board private structure
+ * @ring: ring struct for which to allocate dma
  **/
 static int e1000_alloc_ring_dma(struct e1000_adapter *adapter,
 				struct e1000_ring *ring)
@@ -2507,7 +2524,6 @@ void e1000e_free_rx_resources(struct e1000_ring *rx_ring)
 
 /**
  * e1000_update_itr - update the dynamic ITR value based on statistics
- * @adapter: pointer to adapter
  * @itr_setting: current adapter->itr
  * @packets: the number of packets during this measurement interval
  * @bytes: the number of bytes during this measurement interval
@@ -3049,12 +3065,13 @@ static void e1000_configure_tx(struct e1000_adapter *adapter)
 	}
 }
 
+#define PAGE_USE_COUNT(S) (((S) >> PAGE_SHIFT) + \
+			   (((S) & (PAGE_SIZE - 1)) ? 1 : 0))
+
 /**
  * e1000_setup_rctl - configure the receive control registers
  * @adapter: Board private structure
  **/
-#define PAGE_USE_COUNT(S) (((S) >> PAGE_SHIFT) + \
-			   (((S) & (PAGE_SIZE - 1)) ? 1 : 0))
 static void e1000_setup_rctl(struct e1000_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
@@ -3605,6 +3622,7 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
 /**
  * e1000e_config_hwtstamp - configure the hwtstamp registers and enable/disable
  * @adapter: board private structure
+ * @config: timestamp configuration
  *
  * Outgoing time stamping can be enabled and disabled. Play nice and
  * disable it when requested, although it shouldn't cause any overhead
@@ -3808,6 +3826,7 @@ void e1000e_power_up_phy(struct e1000_adapter *adapter)
 
 /**
  * e1000_power_down_phy - Power down the PHY
+ * @adapter: board private structure
  *
  * Power down the PHY so no link is implied when interface is down.
  * The PHY cannot be powered down if management or WoL is active.
@@ -3820,6 +3839,7 @@ static void e1000_power_down_phy(struct e1000_adapter *adapter)
 
 /**
  * e1000_flush_tx_ring - remove all descriptors from the tx_ring
+ * @adapter: board private structure
  *
  * We want to clear all pending descriptors from the TX ring.
  * zeroing happens when the HW reads the regs. We  assign the ring itself as
@@ -3854,6 +3874,7 @@ static void e1000_flush_tx_ring(struct e1000_adapter *adapter)
 
 /**
  * e1000_flush_rx_ring - remove all descriptors from the rx_ring
+ * @adapter: board private structure
  *
  * Mark all descriptors in the RX ring as consumed and disable the rx ring
  */
@@ -3886,6 +3907,7 @@ static void e1000_flush_rx_ring(struct e1000_adapter *adapter)
 
 /**
  * e1000_flush_desc_rings - remove all descriptors from the descriptor rings
+ * @adapter: board private structure
  *
  * In i219, the descriptor rings must be emptied before resetting the HW
  * or before changing the device state to D3 during runtime (runtime PM).
@@ -3968,6 +3990,7 @@ static void e1000e_systim_reset(struct e1000_adapter *adapter)
 
 /**
  * e1000e_reset - bring the hardware into a known good state
+ * @adapter: board private structure
  *
  * This function boots the hardware and enables some settings that
  * require a configuration cycle of the hardware - those cannot be
@@ -4847,7 +4870,7 @@ static void e1000e_update_phy_task(struct work_struct *work)
 
 /**
  * e1000_update_phy_info - timre call-back to update PHY info
- * @data: pointer to adapter cast into an unsigned long
+ * @t: pointer to timer_list containing private info adapter
  *
  * Need to wait a few seconds after link up to get diagnostic information from
  * the phy
@@ -5187,7 +5210,7 @@ static void e1000e_check_82574_phy_workaround(struct e1000_adapter *adapter)
 
 /**
  * e1000_watchdog - Timer Call-back
- * @data: pointer to adapter cast into an unsigned long
+ * @t: pointer to timer_list containing private info adapter
  **/
 static void e1000_watchdog(struct timer_list *t)
 {
@@ -5972,8 +5995,9 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 /**
  * e1000_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: index of the hung queue (unused)
  **/
-static void e1000_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+static void e1000_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
@@ -6174,7 +6198,7 @@ static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
 /**
  * e1000e_hwtstamp_ioctl - control hardware time stamping
  * @netdev: network interface device structure
- * @ifreq: interface request
+ * @ifr: interface request
  *
  * Outgoing time stamping can be enabled and disabled. Play nice and
  * disable it when requested, although it shouldn't cause any overhead
diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index e11c877595fb..bdd9dc163f15 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -2311,6 +2311,7 @@ s32 e1000e_determine_phy_address(struct e1000_hw *hw)
 /**
  *  e1000_get_phy_addr_for_bm_page - Retrieve PHY page address
  *  @page: page to access
+ *  @reg: register to check
  *
  *  Returns the phy address for the page requested.
  **/
@@ -2728,6 +2729,7 @@ void e1000_power_down_phy_copper(struct e1000_hw *hw)
  *  @offset: register offset to be read
  *  @data: pointer to the read data
  *  @locked: semaphore has already been acquired or not
+ *  @page_set: BM_WUC_PAGE already set and access enabled
  *
  *  Acquires semaphore, if necessary, then reads the PHY register at offset
  *  and stores the retrieved information in data.  Release any acquired
@@ -2836,6 +2838,7 @@ s32 e1000_read_phy_reg_page_hv(struct e1000_hw *hw, u32 offset, u16 *data)
  *  @offset: register offset to write to
  *  @data: data to write at register offset
  *  @locked: semaphore has already been acquired or not
+ *  @page_set: BM_WUC_PAGE already set and access enabled
  *
  *  Acquires semaphore, if necessary, then writes the data to PHY register
  *  at the offset.  Release any acquired semaphores before exiting.
diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index 34b988d70488..8d21bcb427ec 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -144,7 +144,7 @@ static int e1000e_phc_get_syncdevicetime(ktime_t *device,
 /**
  * e1000e_phc_getsynctime - Reads the current system/device cross timestamp
  * @ptp: ptp clock structure
- * @cts: structure containing timestamp
+ * @xtstamp: structure containing timestamp
  *
  * Read device and system (ART) clock simultaneously and return the scaled
  * clock values in ns.
diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.h b/drivers/net/ethernet/intel/i40e/i40e_adminq.h
index edec3df78971..ee394aacef4d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.h
@@ -85,8 +85,8 @@ struct i40e_adminq_info {
 
 /**
  * i40e_aq_rc_to_posix - convert errors to user-land codes
- * aq_ret: AdminQ handler error code can override aq_rc
- * aq_rc: AdminQ firmware error code to convert
+ * @aq_ret: AdminQ handler error code can override aq_rc
+ * @aq_rc: AdminQ firmware error code to convert
  **/
 static inline int i40e_aq_rc_to_posix(int aq_ret, int aq_rc)
 {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index befd3018183f..a2dba32383f6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -278,8 +278,6 @@ void i40e_client_update_msix_info(struct i40e_pf *pf)
 /**
  * i40e_client_add_instance - add a client instance struct to the instance list
  * @pf: pointer to the board struct
- * @client: pointer to a client struct in the client list.
- * @existing: if there was already an existing instance
  *
  **/
 static void i40e_client_add_instance(struct i40e_pf *pf)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 6ab52cbd697a..adc9e4fa4789 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -3766,9 +3766,7 @@ i40e_status i40e_aq_stop_lldp(struct i40e_hw *hw, bool shutdown_agent,
 /**
  * i40e_aq_start_lldp
  * @hw: pointer to the hw struct
- * @buff: buffer for result
  * @persist: True if start of LLDP should be persistent across power cycles
- * @buff_size: buffer size
  * @cmd_details: pointer to command details structure or NULL
  *
  * Start the embedded LLDP Agent on all ports.
@@ -5395,6 +5393,7 @@ static void i40e_mdio_if_number_selection(struct i40e_hw *hw, bool set_mdio,
  * @hw: pointer to the hw struct
  * @phy_select: select which phy should be accessed
  * @dev_addr: PHY device address
+ * @page_change: flag to indicate if phy page should be updated
  * @set_mdio: use MDIO I/F number specified by mdio_num
  * @mdio_num: MDIO I/F number
  * @reg_addr: PHY register address
@@ -5439,6 +5438,7 @@ enum i40e_status_code i40e_aq_set_phy_register_ext(struct i40e_hw *hw,
  * @hw: pointer to the hw struct
  * @phy_select: select which phy should be accessed
  * @dev_addr: PHY device address
+ * @page_change: flag to indicate if phy page should be updated
  * @set_mdio: use MDIO I/F number specified by mdio_num
  * @mdio_num: MDIO I/F number
  * @reg_addr: PHY register address
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 07207e21874f..cb366daa1ad7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -287,6 +287,7 @@ void i40e_service_event_schedule(struct i40e_pf *pf)
 /**
  * i40e_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: queue number timing out
  *
  * If any port has noticed a Tx timeout, it is likely that the whole
  * device is munged, not just the one netdev port, so go for the full
@@ -1609,6 +1610,8 @@ static int i40e_set_mac(struct net_device *netdev, void *p)
  * i40e_config_rss_aq - Prepare for RSS using AQ commands
  * @vsi: vsi structure
  * @seed: RSS hash seed
+ * @lut: pointer to lookup table of lut_size
+ * @lut_size: size of the lookup table
  **/
 static int i40e_config_rss_aq(struct i40e_vsi *vsi, const u8 *seed,
 			      u8 *lut, u16 lut_size)
@@ -5815,7 +5818,6 @@ static int i40e_vsi_reconfig_rss(struct i40e_vsi *vsi, u16 rss_size)
 /**
  * i40e_channel_setup_queue_map - Setup a channel queue map
  * @pf: ptr to PF device
- * @vsi: the VSI being setup
  * @ctxt: VSI context structure
  * @ch: ptr to channel structure
  *
@@ -6058,8 +6060,7 @@ static inline int i40e_setup_hw_channel(struct i40e_pf *pf,
 /**
  * i40e_setup_channel - setup new channel using uplink element
  * @pf: ptr to PF device
- * @type: type of channel to be created (VMDq2/VF)
- * @uplink_seid: underlying HW switching element (VEB) ID
+ * @vsi: pointer to the VSI to set up the channel within
  * @ch: ptr to channel structure
  *
  * Setup new channel (VSI) based on specified type (VMDq2/VF)
@@ -7780,7 +7781,7 @@ int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 /**
  * i40e_parse_cls_flower - Parse tc flower filters provided by kernel
  * @vsi: Pointer to VSI
- * @cls_flower: Pointer to struct flow_cls_offload
+ * @f: Pointer to struct flow_cls_offload
  * @filter: Pointer to cloud filter structure
  *
  **/
@@ -8161,8 +8162,8 @@ static int i40e_delete_clsflower(struct i40e_vsi *vsi,
 
 /**
  * i40e_setup_tc_cls_flower - flower classifier offloads
- * @netdev: net device to configure
- * @type_data: offload data
+ * @np: net device to configure
+ * @cls_flower: offload data
  **/
 static int i40e_setup_tc_cls_flower(struct i40e_netdev_priv *np,
 				    struct flow_cls_offload *cls_flower)
@@ -9586,6 +9587,7 @@ static int i40e_reconstitute_veb(struct i40e_veb *veb)
 /**
  * i40e_get_capabilities - get info about the HW
  * @pf: the PF struct
+ * @list_type: AQ capability to be queried
  **/
 static int i40e_get_capabilities(struct i40e_pf *pf,
 				 enum i40e_admin_queue_opc list_type)
@@ -10547,7 +10549,7 @@ static void i40e_service_task(struct work_struct *work)
 
 /**
  * i40e_service_timer - timer callback
- * @data: pointer to PF struct
+ * @t: timer list pointer
  **/
 static void i40e_service_timer(struct timer_list *t)
 {
@@ -12374,6 +12376,7 @@ static int i40e_get_phys_port_id(struct net_device *netdev,
  * @addr: the MAC address entry being added
  * @vid: VLAN ID
  * @flags: instructions from stack about fdb operation
+ * @extack: netlink extended ack, unused currently
  */
 static int i40e_ndo_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 			    struct net_device *dev,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index ff7b19c6bc73..7a879614ca55 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -259,7 +259,6 @@ static u32 i40e_ptp_get_rx_events(struct i40e_pf *pf)
 /**
  * i40e_ptp_rx_hang - Detect error case when Rx timestamp registers are hung
  * @pf: The PF private data structure
- * @vsi: The VSI with the rings relevant to 1588
  *
  * This watchdog task is scheduled to detect error case where hardware has
  * dropped an Rx packet that was timestamped when the ring is full. The
diff --git a/drivers/net/ethernet/intel/i40e/i40e_trace.h b/drivers/net/ethernet/intel/i40e/i40e_trace.h
index 983f8b98b275..b5b12299931f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_trace.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_trace.h
@@ -22,7 +22,7 @@
 
 #include <linux/tracepoint.h>
 
-/**
+/*
  * i40e_trace() macro enables shared code to refer to trace points
  * like:
  *
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 1606ba5318f7..d43ce13a93c9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1755,7 +1755,6 @@ static inline void i40e_rx_hash(struct i40e_ring *ring,
  * @rx_ring: rx descriptor ring packet is being transacted on
  * @rx_desc: pointer to the EOP Rx descriptor
  * @skb: pointer to current skb being populated
- * @rx_ptype: the packet type decoded by hardware
  *
  * This function checks the ring, descriptor, and packet information in
  * order to populate the hash, checksum, VLAN, protocol, and
@@ -3512,7 +3511,7 @@ static inline int i40e_tx_map(struct i40e_ring *tx_ring, struct sk_buff *skb,
 
 /**
  * i40e_xmit_xdp_ring - transmits an XDP buffer to an XDP Tx ring
- * @xdp: data to transmit
+ * @xdpf: data to transmit
  * @xdp_ring: XDP Tx ring
  **/
 static int i40e_xmit_xdp_ring(struct xdp_frame *xdpf,
@@ -3707,7 +3706,9 @@ netdev_tx_t i40e_lan_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 /**
  * i40e_xdp_xmit - Implements ndo_xdp_xmit
  * @dev: netdev
- * @xdp: XDP buffer
+ * @n: number of frames
+ * @frames: array of XDP buffer pointers
+ * @flags: XDP extra info
  *
  * Returns number of frames successfully sent. Frames that fail are
  * free'ed via XDP return API.
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 66c2b92c0d10..2feed920ef8a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -482,7 +482,6 @@ static inline u32 i40e_get_head(struct i40e_ring *tx_ring)
 /**
  * i40e_xmit_descriptor_count - calculate number of Tx descriptors needed
  * @skb:     send buffer
- * @tx_ring: ring to send buffer on
  *
  * Returns number of data descriptors needed for this skb. Returns 0 to indicate
  * there is not enough descriptors available in this ring since we need at least
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h b/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
index 1397dd3c1c57..19da3b22160f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
@@ -21,9 +21,9 @@ void i40e_release_rx_desc(struct i40e_ring *rx_ring, u32 val);
 #define I40E_XDP_TX		BIT(1)
 #define I40E_XDP_REDIR		BIT(2)
 
-/**
+/*
  * build_ctob - Builds the Tx descriptor (cmd, offset and type) qword
- **/
+ */
 static inline __le64 build_ctob(u32 td_cmd, u32 td_offset, unsigned int size,
 				u32 td_tag)
 {
@@ -37,7 +37,7 @@ static inline __le64 build_ctob(u32 td_cmd, u32 td_offset, unsigned int size,
 /**
  * i40e_update_tx_stats - Update the egress statistics for the Tx ring
  * @tx_ring: Tx ring to update
- * @total_packet: total packets sent
+ * @total_packets: total packets sent
  * @total_bytes: total bytes sent
  **/
 static inline void i40e_update_tx_stats(struct i40e_ring *tx_ring,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 47bfb2e95e2d..c96e2f2d4cba 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2244,7 +2244,8 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 }
 
 /**
- * i40e_validate_queue_map
+ * i40e_validate_queue_map - check queue map is valid
+ * @vf: the VF structure pointer
  * @vsi_id: vsi id
  * @queuemap: Tx or Rx queue map
  *
@@ -3160,8 +3161,8 @@ static int i40e_vc_disable_vlan_stripping(struct i40e_vf *vf, u8 *msg)
 
 /**
  * i40e_validate_cloud_filter
- * @mask: mask for TC filter
- * @data: data for TC filter
+ * @vf: pointer to VF structure
+ * @tc_filter: pointer to filter requested
  *
  * This function validates cloud filter programmed as TC filter for ADq
  **/
@@ -3294,7 +3295,7 @@ static int i40e_validate_cloud_filter(struct i40e_vf *vf,
 /**
  * i40e_find_vsi_from_seid - searches for the vsi with the given seid
  * @vf: pointer to the VF info
- * @seid - seid of the vsi it is searching for
+ * @seid: seid of the vsi it is searching for
  **/
 static struct i40e_vsi *i40e_find_vsi_from_seid(struct i40e_vf *vf, u16 seid)
 {
diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.h b/drivers/net/ethernet/intel/iavf/iavf_adminq.h
index baf2fe26f302..1f60518eb0e5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.h
@@ -85,8 +85,8 @@ struct iavf_adminq_info {
 
 /**
  * iavf_aq_rc_to_posix - convert errors to user-land codes
- * aq_ret: AdminQ handler error code can override aq_rc
- * aq_rc: AdminQ firmware error code to convert
+ * @aq_ret: AdminQ handler error code can override aq_rc
+ * @aq_rc: AdminQ firmware error code to convert
  **/
 static inline int iavf_aq_rc_to_posix(int aq_ret, int aq_rc)
 {
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index d870343cf689..08610a3f978a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -147,6 +147,7 @@ void iavf_schedule_reset(struct iavf_adapter *adapter)
 /**
  * iavf_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: queue number that is timing out
  **/
 static void iavf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
@@ -2572,8 +2573,8 @@ static int iavf_validate_ch_config(struct iavf_adapter *adapter,
 }
 
 /**
- * iavf_del_all_cloud_filters - delete all cloud filters
- * on the traffic classes
+ * iavf_del_all_cloud_filters - delete all cloud filters on the traffic classes
+ * @adapter: board private structure
  **/
 static void iavf_del_all_cloud_filters(struct iavf_adapter *adapter)
 {
@@ -2592,7 +2593,7 @@ static void iavf_del_all_cloud_filters(struct iavf_adapter *adapter)
 /**
  * __iavf_setup_tc - configure multiple traffic classes
  * @netdev: network interface device structure
- * @type_date: tc offload data
+ * @type_data: tc offload data
  *
  * This function processes the config information provided by the
  * user to configure traffic classes/queue channels and packages the
@@ -2690,7 +2691,7 @@ static int __iavf_setup_tc(struct net_device *netdev, void *type_data)
 /**
  * iavf_parse_cls_flower - Parse tc flower filters provided by kernel
  * @adapter: board private structure
- * @cls_flower: pointer to struct flow_cls_offload
+ * @f: pointer to struct flow_cls_offload
  * @filter: pointer to cloud filter structure
  */
 static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
@@ -3064,8 +3065,8 @@ static int iavf_delete_clsflower(struct iavf_adapter *adapter,
 
 /**
  * iavf_setup_tc_cls_flower - flower classifier offloads
- * @netdev: net device to configure
- * @type_data: offload data
+ * @adapter: board private structure
+ * @cls_flower: pointer to flow_cls_offload struct with flow info
  */
 static int iavf_setup_tc_cls_flower(struct iavf_adapter *adapter,
 				    struct flow_cls_offload *cls_flower)
@@ -3112,7 +3113,7 @@ static LIST_HEAD(iavf_block_cb_list);
  * iavf_setup_tc - configure multiple traffic classes
  * @netdev: network interface device structure
  * @type: type of offload
- * @type_date: tc offload data
+ * @type_data: tc offload data
  *
  * This function is the callback to ndo_setup_tc in the
  * netdev_ops.
@@ -3768,8 +3769,7 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 /**
  * iavf_suspend - Power management suspend routine
- * @pdev: PCI device information struct
- * @state: unused
+ * @dev_d: device info pointer
  *
  * Called when the system (VM) is entering sleep/suspend.
  **/
@@ -3799,7 +3799,7 @@ static int __maybe_unused iavf_suspend(struct device *dev_d)
 
 /**
  * iavf_resume - Power management resume routine
- * @pdev: PCI device information struct
+ * @dev_d: device info pointer
  *
  * Called when the system (VM) is resumed from sleep/suspend.
  **/
diff --git a/drivers/net/ethernet/intel/iavf/iavf_trace.h b/drivers/net/ethernet/intel/iavf/iavf_trace.h
index 1058e68a02b4..82fda6f5abf0 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_trace.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_trace.h
@@ -22,7 +22,7 @@
 
 #include <linux/tracepoint.h>
 
-/**
+/*
  * iavf_trace() macro enables shared code to refer to trace points
  * like:
  *
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.h b/drivers/net/ethernet/intel/iavf/iavf_txrx.h
index dd3348f9da9d..e5b9ba42dd00 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.h
@@ -454,7 +454,6 @@ bool __iavf_chk_linearize(struct sk_buff *skb);
 /**
  * iavf_xmit_descriptor_count - calculate number of Tx descriptors needed
  * @skb:     send buffer
- * @tx_ring: ring to send buffer on
  *
  * Returns number of data descriptors needed for this skb. Returns 0 to indicate
  * there is not enough descriptors available in this ring since we need at least
@@ -514,6 +513,7 @@ static inline bool iavf_chk_linearize(struct sk_buff *skb, int count)
 	return count != IAVF_MAX_BUFFER_TXD;
 }
 /**
+ * txring_txq - helper to convert from a ring to a queue
  * @ring: Tx ring to find the netdev equivalent of
  **/
 static inline struct netdev_queue *txring_txq(const struct iavf_ring *ring)
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 65583f0a1797..148f389b48a8 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -508,7 +508,7 @@ static inline void ice_set_ring_xdp(struct ice_ring *ring)
 
 /**
  * ice_xsk_pool - get XSK buffer pool bound to a ring
- * @ring - ring to use
+ * @ring: ring to use
  *
  * Returns a pointer to xdp_umem structure if there is a buffer pool present,
  * NULL otherwise.
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index ba9375218fef..b06fbe99d8e9 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1422,7 +1422,7 @@ struct ice_aqc_nvm_comp_tbl {
 	u8 cvs[]; /* Component Version String */
 } __packed;
 
-/**
+/*
  * Send to PF command (indirect 0x0801) ID is only used by PF
  *
  * Send to VF command (indirect 0x0802) ID is only used by PF
@@ -1826,8 +1826,8 @@ struct ice_aqc_event_lan_overflow {
  * @opcode: AQ command opcode
  * @datalen: length in bytes of indirect/external data buffer
  * @retval: return value from firmware
- * @cookie_h: opaque data high-half
- * @cookie_l: opaque data low-half
+ * @cookie_high: opaque data high-half
+ * @cookie_low: opaque data low-half
  * @params: command-specific parameters
  *
  * Descriptor format for commands the driver posts on the Admin Transmit Queue
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index e9f60d550fcb..ff1a1cbd078e 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -43,7 +43,7 @@
 
 /**
  * ice_compute_pad - compute the padding
- * rx_buf_len: buffer length
+ * @rx_buf_len: buffer length
  *
  * Figure out the size of half page based on given buffer length and
  * then subtract the skb_shared_info followed by subtraction of the
diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index a32391e82762..50863fd87d53 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -2554,7 +2554,7 @@ static s32 igb_update_nvm_checksum_i350(struct e1000_hw *hw)
 /**
  *  __igb_access_emi_reg - Read/write EMI register
  *  @hw: pointer to the HW structure
- *  @addr: EMI address to program
+ *  @address: EMI address to program
  *  @data: pointer to value to read/write from/to the EMI address
  *  @read: boolean flag to indicate read or write
  **/
@@ -2590,7 +2590,7 @@ s32 igb_read_emi_reg(struct e1000_hw *hw, u16 addr, u16 *data)
  *  igb_set_eee_i350 - Enable/disable EEE support
  *  @hw: pointer to the HW structure
  *  @adv1G: boolean flag enabling 1G EEE advertisement
- *  @adv100m: boolean flag enabling 100M EEE advertisement
+ *  @adv100M: boolean flag enabling 100M EEE advertisement
  *
  *  Enable/disable EEE based on setting in dev_spec structure.
  *
@@ -2646,7 +2646,7 @@ s32 igb_set_eee_i350(struct e1000_hw *hw, bool adv1G, bool adv100M)
  *  igb_set_eee_i354 - Enable/disable EEE support
  *  @hw: pointer to the HW structure
  *  @adv1G: boolean flag enabling 1G EEE advertisement
- *  @adv100m: boolean flag enabling 100M EEE advertisement
+ *  @adv100M: boolean flag enabling 100M EEE advertisement
  *
  *  Enable/disable EEE legacy mode based on setting in dev_spec structure.
  *
diff --git a/drivers/net/ethernet/intel/igb/e1000_i210.c b/drivers/net/ethernet/intel/igb/e1000_i210.c
index c393cb2c0f16..9265901455cd 100644
--- a/drivers/net/ethernet/intel/igb/e1000_i210.c
+++ b/drivers/net/ethernet/intel/igb/e1000_i210.c
@@ -357,13 +357,14 @@ static s32 igb_read_invm_word_i210(struct e1000_hw *hw, u8 address, u16 *data)
 /**
  * igb_read_invm_i210 - Read invm wrapper function for I210/I211
  *  @hw: pointer to the HW structure
- *  @words: number of words to read
+ *  @offset: offset to read from
+ *  @words: number of words to read (unused)
  *  @data: pointer to the data read
  *
  *  Wrapper function to return data formerly found in the NVM.
  **/
 static s32 igb_read_invm_i210(struct e1000_hw *hw, u16 offset,
-				u16 words __always_unused, u16 *data)
+				u16 __always_unused words, u16 *data)
 {
 	s32 ret_val = 0;
 
diff --git a/drivers/net/ethernet/intel/igb/e1000_mac.c b/drivers/net/ethernet/intel/igb/e1000_mac.c
index 3254737c07a3..fd8eb2f9ab9d 100644
--- a/drivers/net/ethernet/intel/igb/e1000_mac.c
+++ b/drivers/net/ethernet/intel/igb/e1000_mac.c
@@ -166,6 +166,7 @@ static s32 igb_find_vlvf_slot(struct e1000_hw *hw, u32 vlan, bool vlvf_bypass)
  *  @vlan: VLAN id to add or remove
  *  @vind: VMDq output index that maps queue to VLAN id
  *  @vlan_on: if true add filter, if false remove
+ *  @vlvf_bypass: skip VLVF if no match is found
  *
  *  Sets or clears a bit in the VLAN filter table array based on VLAN id
  *  and if we are adding or removing the filter
diff --git a/drivers/net/ethernet/intel/igb/e1000_mbx.c b/drivers/net/ethernet/intel/igb/e1000_mbx.c
index 46debd991bfe..33cceb77e960 100644
--- a/drivers/net/ethernet/intel/igb/e1000_mbx.c
+++ b/drivers/net/ethernet/intel/igb/e1000_mbx.c
@@ -9,6 +9,7 @@
  *  @msg: The message buffer
  *  @size: Length of buffer
  *  @mbx_id: id of mailbox to read
+ *  @unlock: skip locking or not
  *
  *  returns SUCCESS if it successfully read message from buffer
  **/
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index e1e37d0b7703..44157fcd3cf7 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -549,8 +549,7 @@ static void igb_dump(struct igb_adapter *adapter)
 
 /**
  *  igb_get_i2c_data - Reads the I2C SDA data bit
- *  @hw: pointer to hardware structure
- *  @i2cctl: Current value of I2CCTL register
+ *  @data: opaque pointer to adapter struct
  *
  *  Returns the I2C data bit value
  **/
@@ -3868,6 +3867,7 @@ static int igb_sw_init(struct igb_adapter *adapter)
 /**
  *  igb_open - Called when a network interface is made active
  *  @netdev: network interface device structure
+ *  @resuming: indicates whether we are in a resume call
  *
  *  Returns 0 on success, negative value on failure
  *
@@ -3985,6 +3985,7 @@ int igb_open(struct net_device *netdev)
 /**
  *  igb_close - Disables a network interface
  *  @netdev: network interface device structure
+ *  @suspending: indicates we are in a suspend call
  *
  *  Returns 0, this is not allowed to fail
  *
@@ -5219,7 +5220,7 @@ static void igb_check_lvmmc(struct igb_adapter *adapter)
 
 /**
  *  igb_watchdog - Timer Call-back
- *  @data: pointer to adapter cast into an unsigned long
+ *  @t: pointer to timer_list containing our private info pointer
  **/
 static void igb_watchdog(struct timer_list *t)
 {
@@ -6192,8 +6193,9 @@ static netdev_tx_t igb_xmit_frame(struct sk_buff *skb,
 /**
  *  igb_tx_timeout - Respond to a Tx Hang
  *  @netdev: network interface device structure
+ *  @txqueue: number of the Tx queue that hung (unused)
  **/
-static void igb_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+static void igb_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
@@ -8181,7 +8183,6 @@ static inline void igb_rx_hash(struct igb_ring *ring,
  *  igb_is_non_eop - process handling of non-EOP buffers
  *  @rx_ring: Rx ring being processed
  *  @rx_desc: Rx descriptor for current buffer
- *  @skb: current socket buffer containing buffer in progress
  *
  *  This function updates next to clean.  If the buffer is an EOP buffer
  *  this function exits returning false, otherwise it will place the
@@ -8460,8 +8461,9 @@ static bool igb_alloc_mapped_page(struct igb_ring *rx_ring,
 }
 
 /**
- *  igb_alloc_rx_buffers - Replace used receive buffers; packet split
- *  @adapter: address of board private structure
+ *  igb_alloc_rx_buffers - Replace used receive buffers
+ *  @rx_ring: rx descriptor ring to allocate new receive buffers
+ *  @cleaned_count: count of buffers to allocate
  **/
 void igb_alloc_rx_buffers(struct igb_ring *rx_ring, u16 cleaned_count)
 {
@@ -8530,9 +8532,9 @@ void igb_alloc_rx_buffers(struct igb_ring *rx_ring, u16 cleaned_count)
 
 /**
  * igb_mii_ioctl -
- * @netdev:
- * @ifreq:
- * @cmd:
+ * @netdev: pointer to netdev struct
+ * @ifr: interface structure
+ * @cmd: ioctl command to execute
  **/
 static int igb_mii_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 {
@@ -8560,9 +8562,9 @@ static int igb_mii_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 
 /**
  * igb_ioctl -
- * @netdev:
- * @ifreq:
- * @cmd:
+ * @netdev: pointer to netdev struct
+ * @ifr: interface structure
+ * @cmd: ioctl command to execute
  **/
 static int igb_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 {
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 490368d3d03c..7cc5428c3b3d 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -957,8 +957,8 @@ void igb_ptp_rx_rgtstamp(struct igb_q_vector *q_vector,
 
 /**
  * igb_ptp_get_ts_config - get hardware time stamping config
- * @netdev:
- * @ifreq:
+ * @netdev: netdev struct
+ * @ifr: interface struct
  *
  * Get the hwtstamp_config settings to return to the user. Rather than attempt
  * to deconstruct the settings from the registers, just return a shadow copy
@@ -1141,8 +1141,8 @@ static int igb_ptp_set_timestamp_mode(struct igb_adapter *adapter,
 
 /**
  * igb_ptp_set_ts_config - set hardware time stamping config
- * @netdev:
- * @ifreq:
+ * @netdev: netdev struct
+ * @ifr: interface struct
  *
  **/
 int igb_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr)
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 19269f5d52bc..ee9f8c1dca83 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -61,7 +61,7 @@ static const struct igbvf_info *igbvf_info_tbl[] = {
 
 /**
  * igbvf_desc_unused - calculate if we have unused descriptors
- * @rx_ring: address of receive ring structure
+ * @ring: address of receive ring structure
  **/
 static int igbvf_desc_unused(struct igbvf_ring *ring)
 {
@@ -74,6 +74,8 @@ static int igbvf_desc_unused(struct igbvf_ring *ring)
 /**
  * igbvf_receive_skb - helper function to handle Rx indications
  * @adapter: board private structure
+ * @netdev: pointer to netdev struct
+ * @skb: skb to indicate to stack
  * @status: descriptor status field as written by hardware
  * @vlan: descriptor vlan field as written by hardware (no le/be conversion)
  * @skb: pointer to sk_buff to be indicated to stack
@@ -233,6 +235,8 @@ static void igbvf_alloc_rx_buffers(struct igbvf_ring *rx_ring,
 /**
  * igbvf_clean_rx_irq - Send received data up the network stack; legacy
  * @adapter: board private structure
+ * @work_done: output parameter used to indicate completed work
+ * @work_to_do: input parameter setting limit of work
  *
  * the return value indicates whether actual cleaning was done, there
  * is no guarantee that everything was cleaned
@@ -406,6 +410,7 @@ static void igbvf_put_txbuf(struct igbvf_adapter *adapter,
 /**
  * igbvf_setup_tx_resources - allocate Tx resources (Descriptors)
  * @adapter: board private structure
+ * @tx_ring: ring being initialized
  *
  * Return 0 on success, negative on failure
  **/
@@ -444,6 +449,7 @@ int igbvf_setup_tx_resources(struct igbvf_adapter *adapter,
 /**
  * igbvf_setup_rx_resources - allocate Rx resources (Descriptors)
  * @adapter: board private structure
+ * @rx_ring: ring being initialized
  *
  * Returns 0 on success, negative on failure
  **/
@@ -540,7 +546,7 @@ void igbvf_free_tx_resources(struct igbvf_ring *tx_ring)
 
 /**
  * igbvf_clean_rx_ring - Free Rx Buffers per Queue
- * @adapter: board private structure
+ * @rx_ring: ring structure pointer to free buffers from
  **/
 static void igbvf_clean_rx_ring(struct igbvf_ring *rx_ring)
 {
@@ -760,7 +766,7 @@ static void igbvf_set_itr(struct igbvf_adapter *adapter)
 
 /**
  * igbvf_clean_tx_irq - Reclaim resources after transmit completes
- * @adapter: board private structure
+ * @tx_ring: ring structure to clean descriptors from
  *
  * returns true if ring is completely cleaned
  **/
@@ -1891,7 +1897,7 @@ static bool igbvf_has_link(struct igbvf_adapter *adapter)
 
 /**
  * igbvf_watchdog - Timer Call-back
- * @data: pointer to adapter cast into an unsigned long
+ * @t: timer list pointer containing private struct
  **/
 static void igbvf_watchdog(struct timer_list *t)
 {
@@ -2372,8 +2378,9 @@ static netdev_tx_t igbvf_xmit_frame(struct sk_buff *skb,
 /**
  * igbvf_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: queue timing out (unused)
  **/
-static void igbvf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+static void igbvf_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index c6968fdb6caa..3183150c7995 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4653,7 +4653,7 @@ int igc_close(struct net_device *netdev)
 /**
  * igc_ioctl - Access the hwtstamp interface
  * @netdev: network interface device structure
- * @ifreq: interface request data
+ * @ifr: interface request data
  * @cmd: ioctl command
  **/
 static int igc_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 6a9b5102aa55..e4b8f312f97c 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -439,7 +439,7 @@ static void igc_ptp_tx_work(struct work_struct *work)
 /**
  * igc_ptp_set_ts_config - set hardware time stamping config
  * @netdev: network interface device structure
- * @ifreq: interface request data
+ * @ifr: interface request data
  *
  **/
 int igc_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr)
@@ -466,7 +466,7 @@ int igc_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr)
 /**
  * igc_ptp_get_ts_config - get hardware time stamping config
  * @netdev: network interface device structure
- * @ifreq: interface request data
+ * @ifr: interface request data
  *
  * Get the hwtstamp_config settings to return to the user. Rather than attempt
  * to deconstruct the settings from the registers, just return a shadow copy
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 048351cf0e4a..1588376d4c67 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -1109,7 +1109,7 @@ ixgb_set_multi(struct net_device *netdev)
 
 /**
  * ixgb_watchdog - Timer Call-back
- * @data: pointer to netdev cast into an unsigned long
+ * @t: pointer to timer_list containing our private info pointer
  **/
 
 static void
@@ -1531,10 +1531,11 @@ ixgb_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 /**
  * ixgb_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: queue hanging (unused)
  **/
 
 static void
-ixgb_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+ixgb_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
 
@@ -1746,7 +1747,8 @@ ixgb_intr(int irq, void *data)
 
 /**
  * ixgb_clean - NAPI Rx polling callback
- * @adapter: board private structure
+ * @napi: napi struct pointer
+ * @budget: max number of receives to clean
  **/
 
 static int
@@ -1865,7 +1867,7 @@ ixgb_clean_tx_irq(struct ixgb_adapter *adapter)
  * ixgb_rx_checksum - Receive Checksum Offload for 82597.
  * @adapter: board private structure
  * @rx_desc: receive descriptor
- * @sk_buff: socket buffer with received data
+ * @skb: socket buffer with received data
  **/
 
 static void
@@ -1923,6 +1925,8 @@ static void ixgb_check_copybreak(struct napi_struct *napi,
 /**
  * ixgb_clean_rx_irq - Send received data up the network stack,
  * @adapter: board private structure
+ * @work_done: output pointer to amount of packets cleaned
+ * @work_to_do: how much work we can complete
  **/
 
 static bool
@@ -2042,6 +2046,7 @@ ixgb_clean_rx_irq(struct ixgb_adapter *adapter, int *work_done, int work_to_do)
 /**
  * ixgb_alloc_rx_buffers - Replace used receive buffers
  * @adapter: address of board private structure
+ * @cleaned_count: how many buffers to allocate
  **/
 
 static void
@@ -2211,7 +2216,7 @@ static pci_ers_result_t ixgb_io_error_detected(struct pci_dev *pdev,
 
 /**
  * ixgb_io_slot_reset - called after the pci bus has been reset.
- * @pdev    pointer to pci device with error
+ * @pdev: pointer to pci device with error
  *
  * This callback is called after the PCI bus has been reset.
  * Basically, this tries to restart the card from scratch.
@@ -2259,7 +2264,7 @@ static pci_ers_result_t ixgb_io_slot_reset(struct pci_dev *pdev)
 
 /**
  * ixgb_io_resume - called when its OK to resume normal operations
- * @pdev    pointer to pci device with error
+ * @pdev: pointer to pci device with error
  *
  * The error recovery driver tells us that its OK to resume
  * normal operation. Implementation resembles the second-half
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 0b675c34ce49..02899f79f0ff 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6175,8 +6175,9 @@ static void ixgbe_set_eee_capable(struct ixgbe_adapter *adapter)
 /**
  * ixgbe_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: queue number that timed out
  **/
-static void ixgbe_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+static void ixgbe_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
index 7980d7265e10..f77fa3e4fdd1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -771,7 +771,7 @@ static s32 ixgbe_mii_bus_write_generic(struct ixgbe_hw *hw, int addr,
 
 /**
  *  ixgbe_mii_bus_read - Read a clause 22/45 register
- *  @hw: pointer to hardware structure
+ *  @bus: pointer to mii_bus structure which points to our driver private
  *  @addr: address
  *  @regnum: register number
  **/
@@ -786,7 +786,7 @@ static s32 ixgbe_mii_bus_read(struct mii_bus *bus, int addr, int regnum)
 
 /**
  *  ixgbe_mii_bus_write - Write a clause 22/45 register
- *  @hw: pointer to hardware structure
+ *  @bus: pointer to mii_bus structure which points to our driver private
  *  @addr: address
  *  @regnum: register number
  *  @val: value to write
@@ -803,7 +803,7 @@ static s32 ixgbe_mii_bus_write(struct mii_bus *bus, int addr, int regnum,
 
 /**
  *  ixgbe_x550em_a_mii_bus_read - Read a clause 22/45 register on x550em_a
- *  @hw: pointer to hardware structure
+ *  @bus: pointer to mii_bus structure which points to our driver private
  *  @addr: address
  *  @regnum: register number
  **/
@@ -820,7 +820,7 @@ static s32 ixgbe_x550em_a_mii_bus_read(struct mii_bus *bus, int addr,
 
 /**
  *  ixgbe_x550em_a_mii_bus_write - Write a clause 22/45 register on x550em_a
- *  @hw: pointer to hardware structure
+ *  @bus: pointer to mii_bus structure which points to our driver private
  *  @addr: address
  *  @regnum: register number
  *  @val: value to write
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 50afec43e001..ba54c728aef2 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -246,8 +246,9 @@ static void ixgbevf_tx_timeout_reset(struct ixgbevf_adapter *adapter)
 /**
  * ixgbevf_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: transmit queue hanging (unused)
  **/
-static void ixgbevf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+static void ixgbevf_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 
-- 
2.25.4


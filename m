Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CFC509F1D
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 13:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381712AbiDUL65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 07:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376768AbiDUL65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 07:58:57 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE97252B8;
        Thu, 21 Apr 2022 04:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650542167; x=1682078167;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=JWj5fC4Zu4nqnzXYkRmMhPKM4GR0wGD9k3bpwt75vNQ=;
  b=PpQFVjigOa3CHHhqYQu6jO6Y6duFpskQqF3cnKurVhdKxvv4zcI2FGld
   Mg3Gzpo0kS3ffsUGkmOs5Uo/4ENcTl+K+3KSPL0w8NR8CbFHD+doeFbdB
   4feYS7KQc0k/IXgLm7oWkkTDglIwT0Ca/N9zvEPiP41m7Y5hRIl3rvaQw
   lmIbNnRMftuOtB6lGo/cvpKaO2QiO3Tugm0NF+r6SXqEBRKBAtXXIiDob
   YW/qEqEcklC+R68oHLk+Pm4qZOLjLayYrBSHpnBtVLQfN0JbCrcMALzLl
   50BRqb9gKnTxBAgWfsVPIZjyk8UUPxLCDZ1ay9OMftKSe3yMdv5Z1DkUx
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="244255317"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="244255317"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:56:06 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="530260508"
Received: from bpeddu-mobl.amr.corp.intel.com ([10.251.216.95])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:56:00 -0700
Date:   Thu, 21 Apr 2022 14:55:58 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v6 02/13] net: wwan: t7xx: Add control DMA
 interface
In-Reply-To: <20220407223629.21487-3-ricardo.martinez@linux.intel.com>
Message-ID: <735a12c8-384a-a2ca-cb84-da16eda81414@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-3-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1336994426-1650542166=:1673"
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1336994426-1650542166=:1673
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 7 Apr 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Cross Layer DMA (CLDMA) Hardware interface (HIF) enables the control
> path of Host-Modem data transfers. CLDMA HIF layer provides a common
> interface to the Port Layer.
> 
> CLDMA manages 8 independent RX/TX physical channels with data flow
> control in HW queues. CLDMA uses ring buffers of General Packet
> Descriptors (GPD) for TX/RX. GPDs can represent multiple or single
> data buffers (DB).
> 
> CLDMA HIF initializes GPD rings, registers ISR handlers for CLDMA
> interrupts, and initializes CLDMA HW registers.
> 
> CLDMA TX flow:
> 1. Port Layer write
> 2. Get DB address
> 3. Configure GPD
> 4. Triggering processing via HW register write
> 
> CLDMA RX flow:
> 1. CLDMA HW sends a RX "done" to host
> 2. Driver starts thread to safely read GPD
> 3. DB is sent to Port layer
> 4. Create a new buffer for GPD ring
> 
> Note: This patch does not enable compilation since it has dependencies
> such as t7xx_pcie_mac_clear_int()/t7xx_pcie_mac_set_int() and
> struct t7xx_pci_dev which are added by the core patch.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> 
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

> +struct cldma_tgpd {
> +	u8 gpd_flags;
> +	u8 not_used1;
> +	u8 not_used2;
> +	u8 debug_id;
> +	__le32 next_gpd_ptr_h;
> +	__le32 next_gpd_ptr_l;
> +	__le32 data_buff_bd_ptr_h;
> +	__le32 data_buff_bd_ptr_l;
> +	__le16 data_buff_len;
> +	__le16 not_used3;
> +};
> +
> +struct cldma_rgpd {
> +	u8 gpd_flags;
> +	u8 not_used1;
> +	__le16 data_allow_len;
> +	__le32 next_gpd_ptr_h;
> +	__le32 next_gpd_ptr_l;
> +	__le32 data_buff_bd_ptr_h;
> +	__le32 data_buff_bd_ptr_l;
> +	__le16 data_buff_len;
> +	u8 not_used2;
> +	u8 debug_id;
> +};

A small additional thing...

If you put next_gpd_ptr_h, next_gpd_ptr_l, data_buff_bd_ptr_h, and 
data_buff_bd_ptr_l into another struct inside these structs, 
t7xx_cldma_tgpd_set_data_ptr() and friends don't require duplicated 
versions for tgpd and rgpd.

-- 
 i.
--8323329-1336994426-1650542166=:1673--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E174C42D9
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238401AbiBYKzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiBYKzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:55:35 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1D91DAC41;
        Fri, 25 Feb 2022 02:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645786503; x=1677322503;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=4BpIOZPWBrtG9hTwo7JJcscMEu5Srr7gWO3cK+sXB6U=;
  b=fh8eueheOgxAV/iO4EJ8HNmrCy3RVMfVpPYXt6ObxipMpo+pdRRY/H28
   OEHlILmoSnQArG/FVdSlL8rE5v3gcUXdmeiMrpJXOwpifKB+iCCm8Gjda
   XM21QkFPq2T7Bwq1H3meYfO2W8NXQ9cW0knzZw5I6cgh/u6NJ0R3md72T
   BJ4QzzAhMB0tEm7ABnkYLP/t1uMRyOWRYXTvoTBZLu8IVV07ozIWD//tA
   /O3n8b3w7WTgWbJgaq+cAx7681rtYwa6Yt5GMwubZllT8lHLBPqlCN6Nt
   yJjXAqEm3lLUiCs4R5o3rnB7n9vVVw/2H/AcdD3yOBAwzCKlO/csZ8aRl
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="233099807"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="233099807"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 02:55:03 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="549219039"
Received: from grossi-mobl.ger.corp.intel.com ([10.252.47.60])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 02:54:33 -0800
Date:   Fri, 25 Feb 2022 12:54:26 +0200 (EET)
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
Subject: Re: [PATCH net-next v5 02/13] net: wwan: t7xx: Add control DMA
 interface
In-Reply-To: <20220223223326.28021-3-ricardo.martinez@linux.intel.com>
Message-ID: <3867a1ee-9ff2-9afd-faf-ca5c31c0151d@linux.intel.com>
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-3-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1743277692-1645717735=:1706"
Content-ID: <fffaf13d-b3bd-605f-9e3-ae1f3b4e2b11@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1743277692-1645717735=:1706
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <12195994-9fef-c5e-88bc-4aadde8255dd@linux.intel.com>

On Wed, 23 Feb 2022, Ricardo Martinez wrote:

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
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> ---

Since t7xx_pcie_mac_set_int and t7xx_pcie_mac_clear_int are
still not here, please note in your commit message there are
these dependencies between patches 02 and 03 (and I don't
promise somebody else wouldn't oppose).

> +{
...
> +	for (i = 0; i < ring->length; i++) {
...
> +		gpd = req->gpd;
...
> +	}
> +
> +	list_for_each_entry(req, &ring->gpd_ring, entry) {
> +		t7xx_cldma_rgpd_set_next_ptr(gpd, req->gpd_addr);
> +		gpd = req->gpd;

Despite being correct, this is bit of a trick. I'd add a comment
between the loops to help the reader to track where gpd points to.

> +/**
> + * t7xx_cldma_send_skb() - Send control data to modem.
> + * @md_ctrl: CLDMA context structure.
> + * @qno: Queue number.
> + * @skb: Socket buffer.
> + *
> + * Return:
...
> + * * -EBUSY	- Resource lock failure.

Leftover?


...with those addressed
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>


And kudos for rx_not_done -> pending_rx_int change. It was a minor
thing for me but the logic is so much easier to understand now with
that better name :-).

Some other nice cleanups compared with v4 also noted.


-- 
 i.
--8323329-1743277692-1645717735=:1706--

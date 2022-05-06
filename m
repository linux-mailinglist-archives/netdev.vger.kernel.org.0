Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCCE51D1E6
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 09:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388369AbiEFHIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 03:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388215AbiEFHID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 03:08:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B21F66CB5;
        Fri,  6 May 2022 00:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651820661; x=1683356661;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=ahupXr7F1TKCKZx611mgTItjhrFqAsv7itkHslX2hF8=;
  b=kN3kOrGdVv8mQ7fOQZ0JhTCsGndtan1Hn1OdW4WWdplYXzuGToRUNZoc
   30FPUMeLT9pdn9vOVj0aDaD8oO4I9xUA3zm/33ZvSTOmwiN4e6/YpwgZn
   gsxqmhkO/fDwBOmtMMJ/XdqtZw/GrtK53SS9m2icaPBOE+3PWOojK/pzc
   d9xGByOE7ktj8K/zzOMJG5QGYh+wUUfpNLhc0/yP73XEaxqbMOA9TncgQ
   tRJtcKToPPcZOcvI4hiHVDY8LbiOXq2+Q+N0cZOg4gQ58N0vb0WDfeTAc
   Qo0FRqIPVKbeEv6DuQ4KxkmV7ds0bbEs2DbrJPhK3NW5LniFPfKn74sdH
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248280842"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248280842"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 00:04:20 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="563670943"
Received: from psierako-mobl.ger.corp.intel.com ([10.252.32.230])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 00:04:14 -0700
Date:   Fri, 6 May 2022 10:04:12 +0300 (EEST)
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
Subject: Re: [PATCH net-next v7 09/14] net: wwan: t7xx: Add data path
 interface
In-Reply-To: <20220506011616.1774805-10-ricardo.martinez@linux.intel.com>
Message-ID: <fac95844-133-3caa-8e76-31784a0a96f@linux.intel.com>
References: <20220506011616.1774805-1-ricardo.martinez@linux.intel.com> <20220506011616.1774805-10-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-398194048-1651820660=:1550"
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-398194048-1651820660=:1550
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 5 May 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
> for initialization, ISR, control and event handling of TX/RX flows.
> 
> DPMAIF TX
> Exposes the 'dmpaif_tx_send_skb' function which can be used by the
> network device to transmit packets.
> The uplink data management uses a Descriptor Ring Buffer (DRB).
> First DRB entry is a message type that will be followed by 1 or more
> normal DRB entries. Message type DRB will hold the skb information
> and each normal DRB entry holds a pointer to the skb payload.
> 
> DPMAIF RX
> The downlink buffer management uses Buffer Address Table (BAT) and
> Packet Information Table (PIT) rings.
> The BAT ring holds the address of skb data buffer for the HW to use,
> while the PIT contains metadata about a whole network packet including
> a reference to the BAT entry holding the data buffer address.
> The driver reads the PIT and BAT entries written by the modem, when
> reaching a threshold, the driver will reload the PIT and BAT rings.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

-- 
 i.

--8323329-398194048-1651820660=:1550--

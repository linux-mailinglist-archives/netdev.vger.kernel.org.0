Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E153555F909
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiF2H2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiF2H2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:28:33 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4D81117B
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 00:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656487710; x=1688023710;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=cbRh0LB23DmDfzeMZF1qIjlqmJBtlY4pHrhlBoI8oTI=;
  b=RujbPmiBJD00FErU/O523yAGR0ZK5VafYGjqJWpjBA6Gy9N8tpzJi3cb
   gMoMXiRi6ZCynLFVZPvX+D9kWoQ3AngbFztNG3idv2zFBiS/iousCU4JY
   O32odDC8Rv2rENBnbcWo1wqzaTw0q7EHaeN5BJuZtgvRS55lIjTm8occz
   nuR0Bn6CMldnMk8n8H980FmG0WfCBPqn+eY/K0p8iDVJwd8VpN9M21gRj
   fWQ5/9gGrR7XkKwvDDs2JyB6h3UkdV50VBJCPY+Lxw42jN7zbs0jEkKVq
   fpIy+pZuqT9zeTzgT3M587h1aFuQqNDyYzgO8CrN6cETLtTf3bjFNDwEH
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="280712865"
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="280712865"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 00:28:30 -0700
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="595125233"
Received: from dsummer-mobl.ger.corp.intel.com ([10.252.38.121])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 00:28:25 -0700
Date:   Wed, 29 Jun 2022 10:28:20 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Moises Veleta <moises.veleta@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, ricardo.martinez@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, moises.veleta@intel.com,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
Subject: Re: [PATCH net-next v2 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS
 port
In-Reply-To: <20220628165024.25718-1-moises.veleta@linux.intel.com>
Message-ID: <8447d962-2a45-7487-ee7b-821c7b35eba9@linux.intel.com>
References: <20220628165024.25718-1-moises.veleta@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-861304416-1656487099=:1529"
Content-ID: <a092a6d2-cfba-3d6-94bf-c9c8ff3d5a1@linux.intel.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

--8323329-861304416-1656487099=:1529
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <6727b853-684b-c2c5-5966-d10a6e33146@linux.intel.com>

On Tue, 28 Jun 2022, Moises Veleta wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
> communicate with AP and Modem processors respectively. So far only
> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
> port which requires such channel.
> 
> GNSS AT control port allows Modem Manager to control GPS for:
> - Start/Stop GNSS sessions,
> - Configuration commands to support Assisted GNSS positioning
> - Crash & reboot (notifications when resetting device (AP) & host)
> - Settings to Enable/Disable GNSS solution
> - Geofencing
> 
> Rename small Application Processor (sAP) to AP.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

(I already gave that tag for v1, please carry rev-by over next time when 
sending new versions.)

-- 
 i.
--8323329-861304416-1656487099=:1529--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728AF54DE44
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 11:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiFPJhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 05:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiFPJhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 05:37:13 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00BB4CD7D
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 02:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655372232; x=1686908232;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=4aCvyEvP0KM2yxUPd5EcUKxtOQPCrqwKTpXBR5q8l10=;
  b=JJsDU/Ut0XXeAE5HbHeg7R+OuwlSvmumLWLEFW3V+of6hF7d7a1G5xn8
   N2LlAio18gDO9OZUllvomC0Rod9hlSzZEfu4011KnAJmaQk6sOWB/q7Ra
   CgYsgJ0wH4eDm4aeD2TouaRkR4WoLx0JhPlbj70VcPUdHdKd3wQsQ1IkY
   aYg7FAkoMCVLx3dCJ39prrGwW4oUcb9pfyb243jeZfWOOjOKXz71f88/6
   vDnOP8Jf32SxX2RFZQZjj8aK9M8rLFXHYQ2JswPzclDHgC3SfdUqN4xtR
   BF+Z334DAXuseAT76W+N9fjE0XoxpIJB960gFg2PAmFI6aVoIAL9tYDNm
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="343168046"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="343168046"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 02:37:12 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="641463485"
Received: from mngueron-mobl1.amr.corp.intel.com ([10.252.60.248])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 02:37:07 -0700
Date:   Thu, 16 Jun 2022 12:37:05 +0300 (EEST)
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
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS
 port
In-Reply-To: <20220614205756.6792-1-moises.veleta@linux.intel.com>
Message-ID: <bb56f67-7353-39c7-a3fa-a237e15f3b95@linux.intel.com>
References: <20220614205756.6792-1-moises.veleta@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-358325618-1655372231=:1693"
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

--8323329-358325618-1655372231=:1693
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 14 Jun 2022, Moises Veleta wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
> communicate with AP and Modem processors respectively. So far only
> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
> port which requires such channel.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
> ---

Look fine to me. One nit below.

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
> index dc4133eb433a..3d27f04e2a1f 100644
> --- a/drivers/net/wwan/t7xx/t7xx_port.h
> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
> @@ -36,9 +36,17 @@
>  /* Channel ID and Message ID definitions.
>   * The channel number consists of peer_id(15:12) , channel_id(11:0)
>   * peer_id:
> - * 0:reserved, 1: to sAP, 2: to MD
> + * 0:reserved, 1: to AP, 2: to MD
>   */
>  enum port_ch {
> +	/* to AP */
> +	PORT_CH_AP_CONTROL_RX = 0X1000,
> +	PORT_CH_AP_CONTROL_TX = 0X1001,

Please use lowercase x.


-- 
 i.

--8323329-358325618-1655372231=:1693--

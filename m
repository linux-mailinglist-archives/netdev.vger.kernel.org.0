Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A85E5EDA26
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 12:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiI1Ken (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 06:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbiI1Kel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 06:34:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A78AB1D2;
        Wed, 28 Sep 2022 03:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664361275; x=1695897275;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uUdZjM/O0ckF9ng08ULrkoN8fjainSglLhr4VF70z2k=;
  b=X86z+BKnLOQh9w2s/1NQedWpZTtUICmJmnncwQLH94U+hvrRikS+tcdh
   eY5LKyiSVR3vehfXwn2zss01S4jo0G6XfkP5O2+AdLSQngLPomjVYcB5F
   veSvD/l4z46sid3OEkgf9FDDIhQyEPFHCvoJCj3r7X/j0Ml87Qo9smzhV
   6FHmxudyxOkAuGBhZUVet0MZMpy8wCcFiN2YG0wFLSVgfFWQGzEP5i17t
   LHh4QqtY0NDEER5rrkOixMaUFBfWTe3a/ZoPzA66TSGqt2xA902uGo1gm
   aI4craCsrEhbE6rAZOmn5iF+lVWxA373Hb9snpo83kEWHKhaSVMZpR02M
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="175980659"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2022 03:34:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 28 Sep 2022 03:34:32 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 28 Sep 2022 03:34:32 -0700
Date:   Wed, 28 Sep 2022 12:39:00 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net V4] eth: lan743x: reject extts for non-pci11x1x
 devices
Message-ID: <20220928103900.bwtbtmfhnyhr5cnz@soft-dev3-1.localhost>
References: <20220928090311.93361-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220928090311.93361-1-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/28/2022 14:33, Raju Lakkaraju wrote:

Hi Raju,

I think there is a 24h waiting period before sending new patches for the
same series, just to give time for other people to review it.

> Remove PTP_PF_EXTTS support for non-PCI11x1x devices since they do not support
> the PTP-IO Input event triggered timestamping mechanisms added
> 
> Fixes: 60942c397af6 ("Add support for PTP-IO Event Input External  Timestamp (extts)")

This still fails for 2 reasons:
1. Empty lines around fixes tag
2. The subject line is still wrong. It doesn't match the SHA.

I would do something like:
---
Fixes: 60942c397af60 ("net: lan743x: Add support for PTP-IO Event Input External Timestamp (extts)")
Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---

As you noticed I have skipped Jakub's reviewed-by tag because I can't find
it where you get it. Because I can't see it that you received it in v2
and you already added in v3.

> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> ---
> Changes:
> ========
> V3 -> V4:
>   - Fix the Fixes tag line split
> 
> V2 -> V3:
>  - Correct the Fixes tag
> 
> V1 -> V2:
>  - Repost against net with a Fixes tag
> 
>  drivers/net/ethernet/microchip/lan743x_ptp.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
> index 6a11e2ceb013..da3ea905adbb 100644
> --- a/drivers/net/ethernet/microchip/lan743x_ptp.c
> +++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
> @@ -1049,6 +1049,10 @@ static int lan743x_ptpci_verify_pin_config(struct ptp_clock_info *ptp,
>  					   enum ptp_pin_function func,
>  					   unsigned int chan)
>  {
> +	struct lan743x_ptp *lan_ptp =
> +		container_of(ptp, struct lan743x_ptp, ptp_clock_info);
> +	struct lan743x_adapter *adapter =
> +		container_of(lan_ptp, struct lan743x_adapter, ptp);
>  	int result = 0;
>  
>  	/* Confirm the requested function is supported. Parameter
> @@ -1057,7 +1061,10 @@ static int lan743x_ptpci_verify_pin_config(struct ptp_clock_info *ptp,
>  	switch (func) {
>  	case PTP_PF_NONE:
>  	case PTP_PF_PEROUT:
> +		break;
>  	case PTP_PF_EXTTS:
> +		if (!adapter->is_pci11x1x)
> +			result = -1;
>  		break;
>  	case PTP_PF_PHYSYNC:
>  	default:
> -- 
> 2.25.1
> 

-- 
/Horatiu

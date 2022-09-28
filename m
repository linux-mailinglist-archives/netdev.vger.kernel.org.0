Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23EAB5ED606
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 09:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbiI1H1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 03:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiI1HZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 03:25:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8754BE1193;
        Wed, 28 Sep 2022 00:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664349799; x=1695885799;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bJ9QNJ3BHmOh0N77gr9size0L1ABS8z/Hgdq7Xfjzqo=;
  b=ikR0K9KBCgWWkJ9RAk10GP2Y5Ng/Jq0LhEM5oL/z3oY9Cc9jRlMcL2JP
   e7JpvWN8ZY/s5tJoNXgoAxJ7ij2xYGxE1OXp1E1UVvGQJUaNHFgX68XD0
   i5vFrel5rbw7hn+fWYONk2NTRjI9PzScQpZEuBDT7HeOg0oOsZQ1zrcrb
   9B0fOxQuFmPFVAHgN691TA0g5cN2ptkLIuk//zguyFkUXa0ThPg66zbxU
   BAjJpLqENOOZkTA6LEdzm49szi9OvsUY7Ih+1HqquWGOcGKvjnf202Ox7
   e9Dxozx+dTEKYEVolo1uupxQ34zvWR5PLxXnOpUQ1H0DSuJVQPFHZyA+w
   w==;
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="115771835"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2022 00:22:57 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 28 Sep 2022 00:22:57 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 28 Sep 2022 00:22:56 -0700
Date:   Wed, 28 Sep 2022 09:27:25 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net V3] eth: lan743x: reject extts for non-pci11x1x
 devices
Message-ID: <20220928072725.t7otq35ui5xw3kzq@soft-dev3-1.localhost>
References: <20220928070830.22517-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220928070830.22517-1-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/28/2022 12:38, Raju Lakkaraju wrote:

Hi Raju,

> Remove PTP_PF_EXTTS support for non-PCI11x1x devices since they do not support
> the PTP-IO Input event triggered timestamping mechanisms added
> 
> Fixes: 60942c397af6 ("Add support for PTP-IO Event Input External  Timestamp
>  (extts)")

The fixes tag should not spread over multiple lines. Also you have extra
spaces between External and Timestamp which doesn't appear in the actual
commit.

Also you have an empty line between Fixes and Reviewed-by tags.
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

I am not sure that Jakub gave his Reviewed-by, but maybe I have missed
that.

> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> ---
> Changes:                                                                        
> ========
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

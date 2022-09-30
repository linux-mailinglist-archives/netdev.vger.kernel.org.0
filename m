Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160F65F0AC4
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiI3Lk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiI3Lj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:39:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4194E006B;
        Fri, 30 Sep 2022 04:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664537525; x=1696073525;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ImQCoY9PCMjyxQSQDzGOcnu/XO/IJ0L8x+2PRz3QHs8=;
  b=MLe/GodphjFjhDprkYuAD6nJ6fOmVcv/2ws0Hm76L99Ln9Y2qSeRLJz+
   7sYQJoy6f/hZ0nQKTzIaAwbIftfAIK71rVf+fzZndJSN65fUzeeJleP+M
   kzc+dMIu3ks6MnCJ5a5oebcTjSaCwi/vhNyHw6yaZAbhtNVHFaULccLLE
   CqfVrev00DdmHdN11CyUZgLKEjUKCkVMyJLlVDtdwYglmvj5tyvYHZtc0
   HHuyDa5ROXhYKRp2Atfvx23BvOt5I3YSPyBu565WxHNQpyfp/BrL62GmY
   Aq6744CHI6QYlcADzE67HosE41RZpZqCB8DFaLfTY7VCHV2dxN1+yeUy2
   g==;
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="176426059"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Sep 2022 04:31:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 30 Sep 2022 04:31:39 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Fri, 30 Sep 2022 04:31:39 -0700
Date:   Fri, 30 Sep 2022 13:36:09 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net V5] eth: lan743x: reject extts for non-pci11x1x
 devices
Message-ID: <20220930113609.v5j75omqbbnsytss@soft-dev3-1.localhost>
References: <20220930092740.130924-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220930092740.130924-1-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/30/2022 14:57, Raju Lakkaraju wrote:
> Remove PTP_PF_EXTTS support for non-PCI11x1x devices since they do not support
> the PTP-IO Input event triggered timestamping mechanisms added
> 
> Fixes: 60942c397af6 ("net: lan743x: Add support for PTP-IO Event Input External Timestamp (extts)")
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> ---
> Changes:
> ========
> V4 -> V5:
>  - Remove the Reviewed-by tag added by me 
>  - Correct the Fixes tag subject line
> 
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

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547D13B5BD
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390238AbfFJNGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:06:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41290 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388848AbfFJNGK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 09:06:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IXqZ0CamQNSABbN4WKbG4dT+eLIR+6caKei2b9LUxqM=; b=WibeBIkoCwxn6A/navSv/fptTw
        JDCREiicdxXHKkc7HWJFa9VD6c+X0mZaO0NIsW8PmAFxaQC1ZfNGAouGtw3PBCAYWTqSbNn/6Vylh
        yreu1ASYZfLpueT5mRU2FojdHWFvTaHlbrqzLW22e9FRZ8tDpMw2X+WJEseCUakEBjqA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haJzt-0006Li-5Q; Mon, 10 Jun 2019 15:06:01 +0200
Date:   Mon, 10 Jun 2019 15:06:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] ptp: add QorIQ PTP support for DPAA2
Message-ID: <20190610130601.GD8247@lunn.ch>
References: <20190610032108.5791-1-yangbo.lu@nxp.com>
 <20190610032108.5791-2-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610032108.5791-2-yangbo.lu@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 11:21:03AM +0800, Yangbo Lu wrote:
> This patch is to add QorIQ PTP support for DPAA2.
> Although dpaa2-ptp.c driver is a fsl_mc_driver which
> is using MC APIs for register accessing, it's same
> IP block with eTSEC/DPAA/ENETC 1588 timer. We will
> convert to reuse ptp_qoriq driver by using register
> ioremap and dropping related MC APIs.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
>  drivers/ptp/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
> index 9b8fee5..b1b454f 100644
> --- a/drivers/ptp/Kconfig
> +++ b/drivers/ptp/Kconfig
> @@ -44,7 +44,7 @@ config PTP_1588_CLOCK_DTE
>  
>  config PTP_1588_CLOCK_QORIQ
>  	tristate "Freescale QorIQ 1588 timer as PTP clock"
> -	depends on GIANFAR || FSL_DPAA_ETH || FSL_ENETC || FSL_ENETC_VF
> +	depends on GIANFAR || FSL_DPAA_ETH || FSL_DPAA2_ETH || FSL_ENETC || FSL_ENETC_VF
>  	depends on PTP_1588_CLOCK

Hi Yangbo

Could COMPILE_TEST also be added?

Thanks
	Andrew

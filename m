Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE252A372B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgKBX2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgKBX2r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:28:47 -0500
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28AAE22280;
        Mon,  2 Nov 2020 23:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604359727;
        bh=4MjQMzBRiuQQCBZ/m2YpKQucOcQZa7hQO0Ry0R/PWLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GVqI/0xLl0PHdspUgvrvlEYBzXN3PNAvN+q70ACDQLBvKvTxOJ6TzR0ZoJ+NDPPQG
         a0olQwsE8XKIkqrfR2VV8fXgY7AxgLy5j5kogO6ts8+ZW5w9AbkbiOKFC+TxslySjE
         z6tb/dovnpfFNLkfRTfXHYx/9BfVysVqDmi+s13E=
Date:   Tue, 3 Nov 2020 07:28:41 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     mkl@pengutronix.de, robh+dt@kernel.org, s.hauer@pengutronix.de,
        kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 5/6] dt-bindings: firmware: add IMX_SC_R_CAN(x) macro
 for CAN
Message-ID: <20201102232840.GT31601@dragon>
References: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
 <20201021052437.3763-6-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021052437.3763-6-qiangqing.zhang@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 01:24:36PM +0800, Joakim Zhang wrote:
> Add IMX_SC_R_CAN(x) macro for CAN.
> 
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

Acked-by: Shawn Guo <shawnguo@kernel.org>

> ---
>  include/dt-bindings/firmware/imx/rsrc.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/dt-bindings/firmware/imx/rsrc.h b/include/dt-bindings/firmware/imx/rsrc.h
> index 54278d5c1856..43885056557c 100644
> --- a/include/dt-bindings/firmware/imx/rsrc.h
> +++ b/include/dt-bindings/firmware/imx/rsrc.h
> @@ -111,6 +111,7 @@
>  #define IMX_SC_R_CAN_0			105
>  #define IMX_SC_R_CAN_1			106
>  #define IMX_SC_R_CAN_2			107
> +#define IMX_SC_R_CAN(x)			(IMX_SC_R_CAN_0 + (x))
>  #define IMX_SC_R_DMA_1_CH0		108
>  #define IMX_SC_R_DMA_1_CH1		109
>  #define IMX_SC_R_DMA_1_CH2		110
> -- 
> 2.17.1
> 

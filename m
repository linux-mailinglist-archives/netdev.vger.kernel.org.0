Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99EB219BFB5
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 12:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387709AbgDBKyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 06:54:02 -0400
Received: from kernel.crashing.org ([76.164.61.194]:37758 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbgDBKyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 06:54:02 -0400
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2020 06:53:57 EDT
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 032Ah8n8028563
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 2 Apr 2020 05:43:12 -0500
Message-ID: <1947a3705a220ce14a2fda482c833b38a4d9fe9a.camel@kernel.crashing.org>
Subject: Re: [PATCH] net/faraday: fix grammar in function
 ftgmac100_setup_clk() in ftgmac100.c
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Hu Haowen <xianfengting221@163.com>, davem@davemloft.net,
        andrew@lunn.ch, mchehab+samsung@kernel.org, andrew@aj.id.au,
        corbet@lwn.net
Cc:     stfrench@microsoft.com, chris@chris-wilson.co.uk,
        xiubli@redhat.com, airlied@redhat.com, tglx@linutronix.de,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 02 Apr 2020 21:43:06 +1100
In-Reply-To: <20200401105624.17423-1-xianfengting221@163.com>
References: <20200401105624.17423-1-xianfengting221@163.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-04-01 at 18:56 +0800, Hu Haowen wrote:
> "its not" is wrong. The words should be "it's not".
> 
> Signed-off-by: Hu Haowen <xianfengting221@163.com>

Typo more than grammer :-)

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

 (the offender) 

> ---
>  drivers/net/ethernet/faraday/ftgmac100.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 835b7816e372..87236206366f 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1731,7 +1731,7 @@ static int ftgmac100_setup_clk(struct ftgmac100 *priv)
>  	if (rc)
>  		goto cleanup_clk;
>  
> -	/* RCLK is for RMII, typically used for NCSI. Optional because its not
> +	/* RCLK is for RMII, typically used for NCSI. Optional because it's not
>  	 * necessary if it's the AST2400 MAC, or the MAC is configured for
>  	 * RGMII, or the controller is not an ASPEED-based controller.
>  	 */


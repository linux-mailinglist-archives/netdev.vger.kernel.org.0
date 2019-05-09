Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0084A18CB8
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 17:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfEIPMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 11:12:51 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:51938 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726187AbfEIPMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 11:12:51 -0400
X-Greylist: delayed 2283 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2019 11:12:49 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LO3VrTrGlYE516i1lNPSOgxC42nxZCEfQI1ev+JTXKU=; b=Knr21vOqDLh6cdaLkjsOp+NSns
        xF3CdqsBau4JMok/YQdqrXnOcWZ0tc1UVReEphLNVxqlcCI5TJsgOe/dEsz058V3ZoWlXhBqWhOfz
        KlSlzNyY1Qbd94WKOBTQlY/hTgG1uuQKcY6qCsugbgovy0tZcUp+KgFzdi8NNPUTgikA=;
Received: from [92.247.155.176] (helo=carbon)
        by zztop.nucleusys.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <petkan@nucleusys.com>)
        id 1hOk89-00022e-VD; Thu, 09 May 2019 17:34:42 +0300
Date:   Thu, 9 May 2019 17:34:41 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] rtl8150: switch to BIT macro
Message-ID: <20190509143441.sm4zygbeasvyja3z@carbon>
References: <20190509090106.9065-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509090106.9065-1-oneukum@suse.com>
User-Agent: NeoMutt/20180716
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On 19-05-09 11:01:06, Oliver Neukum wrote: > A bit of housekeeping
    switching the driver to the BIT() > macro. Looks good. I hope you've at least
    compiled the driver? :) Acked-by: Petko Manolov <petkan@nucleusys.com> 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19-05-09 11:01:06, Oliver Neukum wrote:
> A bit of housekeeping switching the driver to the BIT()
> macro.

Looks good.  I hope you've at least compiled the driver? :)

Acked-by: Petko Manolov <petkan@nucleusys.com>


cheers,
Petko


> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> ---
>  drivers/net/usb/rtl8150.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> index 59dbdbb5feff..1ed85fba1a7c 100644
> --- a/drivers/net/usb/rtl8150.c
> +++ b/drivers/net/usb/rtl8150.c
> @@ -41,7 +41,7 @@
>  #define	ANLP			0x0146
>  #define	AER			0x0148
>  #define CSCR			0x014C  /* This one has the link status */
> -#define CSCR_LINK_STATUS	(1 << 3)
> +#define CSCR_LINK_STATUS	BIT(3)
>  
>  #define	IDR_EEPROM		0x1202
>  
> @@ -59,20 +59,20 @@
>  
>  
>  /* Transmit status register errors */
> -#define TSR_ECOL		(1<<5)
> -#define TSR_LCOL		(1<<4)
> -#define TSR_LOSS_CRS		(1<<3)
> -#define TSR_JBR			(1<<2)
> +#define TSR_ECOL		BIT(5)
> +#define TSR_LCOL		BIT(4)
> +#define TSR_LOSS_CRS		BIT(3)
> +#define TSR_JBR			BIT(2)
>  #define TSR_ERRORS		(TSR_ECOL | TSR_LCOL | TSR_LOSS_CRS | TSR_JBR)
>  /* Receive status register errors */
> -#define RSR_CRC			(1<<2)
> -#define RSR_FAE			(1<<1)
> +#define RSR_CRC			BIT(2)
> +#define RSR_FAE			BIT(1)
>  #define RSR_ERRORS		(RSR_CRC | RSR_FAE)
>  
>  /* Media status register definitions */
> -#define MSR_DUPLEX		(1<<4)
> -#define MSR_SPEED		(1<<3)
> -#define MSR_LINK		(1<<2)
> +#define MSR_DUPLEX		BIT(4)
> +#define MSR_SPEED		BIT(3)
> +#define MSR_LINK		BIT(2)
>  
>  /* Interrupt pipe data */
>  #define INT_TSR			0x00
> -- 
> 2.16.4
> 
> 

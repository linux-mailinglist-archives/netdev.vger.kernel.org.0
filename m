Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B312DCA1A
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgLQApw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:45:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbgLQApw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 19:45:52 -0500
Date:   Wed, 16 Dec 2020 16:45:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608165911;
        bh=Q66mg2D/d0TTX316HWqnvm49rlM0xf7I80MMYN+9C/I=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=bzhLTmnT8IXHgOry0RPcmTyPqf1B0hR3jqlG0bZHZI1Ofap942eMXwnq5VbpfxcnR
         Hp82hou9TZKWmN5VSh0eg5MHW12MLa9Uhr97moRLVRgyX4b5kUs0BYNON1PtriaesR
         xupSwZOvYLTDIIJHqQYFtARFvAXgXN9BiUJUakiUyXagsBTpRyr06MoXmADw0WxrB1
         mbHTL+qShhMJLgru1bL8UKaVz4VKQcbFjD78YGg1UQg0kEZYBFsNYkgPNUz1AFNXrJ
         YJI0GZKkXYqTWFtUy8SVMDOu4ljzL+5bVGiEOJnQAMVrY+aatvsFa4BaPI7K8QY2Vd
         Q0oLz0ToZMBfw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: ambassador: remove h from printk format specifier
Message-ID: <20201216164510.770454d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215142228.1847161-1-trix@redhat.com>
References: <20201215142228.1847161-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 06:22:28 -0800 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> See Documentation/core-api/printk-formats.rst.
> h should no longer be used in the format specifier for printk.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

That's for new code I assume?

What's the harm in leaving this ancient code be?

> diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
> index c039b8a4fefe..6b0fff8c0141 100644
> --- a/drivers/atm/ambassador.c
> +++ b/drivers/atm/ambassador.c
> @@ -2169,7 +2169,7 @@ static void setup_pci_dev(struct pci_dev *pci_dev)
>  		pci_lat = (lat < MIN_PCI_LATENCY) ? MIN_PCI_LATENCY : lat;
>  
>  	if (lat != pci_lat) {
> -		PRINTK (KERN_INFO, "Changing PCI latency timer from %hu to %hu",
> +		PRINTK (KERN_INFO, "Changing PCI latency timer from %u to %u",
>  			lat, pci_lat);
>  		pci_write_config_byte(pci_dev, PCI_LATENCY_TIMER, pci_lat);
>  	}
> @@ -2300,7 +2300,7 @@ static void __init amb_check_args (void) {
>    unsigned int max_rx_size;
>    
>  #ifdef DEBUG_AMBASSADOR
> -  PRINTK (KERN_NOTICE, "debug bitmap is %hx", debug &= DBG_MASK);
> +  PRINTK (KERN_NOTICE, "debug bitmap is %x", debug &= DBG_MASK);
>  #else
>    if (debug)
>      PRINTK (KERN_NOTICE, "no debugging support");


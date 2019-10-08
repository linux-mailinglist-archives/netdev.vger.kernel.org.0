Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 157E9CFEA1
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 18:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfJHQOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 12:14:09 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44995 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfJHQOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 12:14:09 -0400
Received: by mail-pg1-f196.google.com with SMTP id u12so2159918pgb.11;
        Tue, 08 Oct 2019 09:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h9OB7Yk9goI+UzOkxyLvvhXJ7MAQ379CvgaFUxSopZw=;
        b=Cvu49PSPRSV3frD32/kcP2m7fxOSMEyZJvINAWGErwan5nIXONWLGw3Vc8kN2tfWUk
         +3L8Dd8fosSyGosULR6NZJ8B+orK2EgxLTq2wDYIG4kgD4nY5oYtTDDmyy7AUEN6ffXi
         DUonMG6MCMsmI/GV36K2LZ6G9zvydnmg/oQ1cQ1UlABLucD2Z4DxyskXlqopKA5B4IBt
         PoKD14/W9zjUAh4rqsz2bAaRd72iBVuL5Q2kfhIQ1krF0VRfHeeuJRyrAShNPg8TOLhx
         AYE27kXmZ7gwRe/MSqfeOCJQ8Q0jBVqXL2xWGOdufq2XbQJy2t2uEEyorcoBIRoGI6UP
         UHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h9OB7Yk9goI+UzOkxyLvvhXJ7MAQ379CvgaFUxSopZw=;
        b=qJ9Pe+c+gSFQLYYZfYFXB7vmJJjaMZMO6W6QBPCen1ERoGlXYjp5yfEsffljoBZ4ty
         BK5Ieep+Tqvby2LjoIrWCNM7AjJpopb6RHEZLjnwlUJzmu67WDDqnRr5uMl9psaCHEGe
         fmgiUQ6kqLw/A1c0sMWYzG5yeAgyrBDRbVltonZhHhHEPabZQ4S9TaBF16RrU9nOFVa9
         wN5vaKXgphasb/jy8oPxj/iTgvJEYPneD1LyXvv870VClGOgEDVIlIhP/HqXUubDsCE3
         QOyoxawLDvx9EOk6Oj75+NELNCKD+db82Bx9h2ra656Os/1CBf1YCXuopN8hNkn6AJZ4
         5HYA==
X-Gm-Message-State: APjAAAXkjATckx2nwhnXTpVnBFxL+Hk1Jdvtn4m0yAYjHGMEv9rKGw6l
        kS5mrW5eL0GVbsffojqAMAuTO1wIsV0=
X-Google-Smtp-Source: APXvYqya6l4jN9TuA4DVxkJGnlOxcv4zyG07PBW6CGV79h86Mvid7dWhwDhjKRdC0nfv9qvD3evaPQ==
X-Received: by 2002:a63:1749:: with SMTP id 9mr5280034pgx.212.1570551248451;
        Tue, 08 Oct 2019 09:14:08 -0700 (PDT)
Received: from gmail.com (c-76-21-95-192.hsd1.ca.comcast.net. [76.21.95.192])
        by smtp.gmail.com with ESMTPSA id j24sm17416469pff.71.2019.10.08.09.14.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 09:14:07 -0700 (PDT)
Date:   Tue, 8 Oct 2019 09:14:03 -0700
From:   William Tu <u9012063@gmail.com>
To:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ip6erspan: remove the incorrect mtu limit for ip6erspan
Message-ID: <20191008161403.GB118819@gmail.com>
References: <1570528563-8062-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570528563-8062-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 05:56:03PM +0800, Haishuang Yan wrote:
> ip6erspan driver calls ether_setup(), after commit 61e84623ace3
> ("net: centralize net_device min/max MTU checking"), the range
> of mtu is [min_mtu, max_mtu], which is [68, 1500] by default.
> 
> It causes the dev mtu of the erspan device to not be greater
> than 1500, this limit value is not correct for ip6erspan tap
> device.
> 
> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

Thanks for the patch.

Acked-by: William Tu <u9012063@gmail.com>

> ---
>  net/ipv6/ip6_gre.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
> index d5779d6..787d9f2 100644
> --- a/net/ipv6/ip6_gre.c
> +++ b/net/ipv6/ip6_gre.c
> @@ -2192,6 +2192,7 @@ static void ip6erspan_tap_setup(struct net_device *dev)
>  {
>  	ether_setup(dev);
>  
> +	dev->max_mtu = 0;
>  	dev->netdev_ops = &ip6erspan_netdev_ops;
>  	dev->needs_free_netdev = true;
>  	dev->priv_destructor = ip6gre_dev_free;
> -- 
> 1.8.3.1
> 
> 
> 

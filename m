Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C1E3C157F
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 16:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhGHO4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 10:56:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46336 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbhGHO4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 10:56:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vIHPBqwcqnXKFoiXAeTxLbtZeNi6FhyW5PLWXOKYBHU=; b=hQvJBZ6FwAhKO33+4IGNIZcCL6
        rH/aqicIaKbbMjW89+BzXdEI3CcA/xdbJPL2nIhVqlNvls9pnWEPQAzw7Xp7o9edwlSaZMIvhoYqp
        KJmflrhr/CDNv0IxUGKj3l2axHK3ITB6c8LjioXQTPVN+U7RsrGn0wzhIX0OSK75wekw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m1VPQ-00CeQb-QP; Thu, 08 Jul 2021 16:53:48 +0200
Date:   Thu, 8 Jul 2021 16:53:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Carlos Bilbao <bilbao@vt.edu>
Cc:     gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        davem@davemloft.net, mchehab+huawei@kernel.org, kuba@kernel.org,
        James.Bottomley@hansenpartnership.com, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: Follow the indentation coding standard on
 printks
Message-ID: <YOcRfBtS/UJ81CFq@lunn.ch>
References: <2784471.e9J7NaK4W3@iron-maiden>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2784471.e9J7NaK4W3@iron-maiden>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/atm/suni.c
> +++ b/drivers/atm/suni.c
> @@ -328,8 +328,8 @@ static int suni_start(struct atm_dev *dev)
>  		timer_setup(&poll_timer, suni_hz, 0);
>  		poll_timer.expires = jiffies+HZ;
>  #if 0
> -printk(KERN_DEBUG "[u] p=0x%lx,n=0x%lx\n",(unsigned long) poll_timer.list.prev,
> -    (unsigned long) poll_timer.list.next);
> +	printk(KERN_DEBUG "[u] p=0x%lx,n=0x%lx\n",(unsigned long) poll_timer.list.prev,
> +	    (unsigned long) poll_timer.list.next);

Why not use DPRINTK(), defined at the start of suni.c?

    Andrew

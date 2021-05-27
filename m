Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D131439344B
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 18:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbhE0Qt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 12:49:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60478 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234169AbhE0Qt4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 12:49:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=26a4XWftGQUhRxijNkqt5uu1v1z8z89EZJ1+1CNulCE=; b=Sv
        2xBERnpWw+/kZwKZ1Kxr31lE7SS6PL2HrKUWgT9PEc2lpBo0KfsVtEElhAXBU8txrYesyMV46C8sG
        uKKBmtTjNRXh5ferScyD8a4ERMpCJE55UQ5eKM4yQLtZddlKL2HfWxa9hsFI9wrkUTaF6K35gVtKH
        +8R8UWA+CNYRskk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lmJBF-006Zuk-Bm; Thu, 27 May 2021 18:48:21 +0200
Date:   Thu, 27 May 2021 18:48:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     linux-leds@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH leds v1 3/5] leds: trigger: netdev: move trigger data
 structure to global include dir
Message-ID: <YK/NValApLWUEHYG@lunn.ch>
References: <20210526180020.13557-1-kabel@kernel.org>
 <20210526180020.13557-4-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210526180020.13557-4-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 08:00:18PM +0200, Marek Behún wrote:
> In preparation for HW offloading of netdev trigger, move struct
> led_trigger_data into global include directory, into file
> linux/ledtrig.h, so that drivers wanting to offload the trigger can see
> the requested settings.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  drivers/leds/trigger/ledtrig-netdev.c | 23 +---------------
>  include/linux/ledtrig.h               | 38 +++++++++++++++++++++++++++

I'm wondering how this is going to scale, if we have a lot of triggers
which can be offloaded. Rather than try to pack them all into
one header, would it make more sense to add

include/linux/led/ledtrig-netdev.h

	Andrew

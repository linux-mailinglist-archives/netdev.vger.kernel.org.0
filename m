Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B49217A40
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 15:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbfEHNTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 09:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727862AbfEHNTA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 09:19:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72CF620850;
        Wed,  8 May 2019 13:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557321538;
        bh=R3TjH0YJdscasMYMZYlof8TulS7fu3leM4eKW3RkjvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TmoJ0AL+BZaAX0RU4qiQ72Plldpus4mjIr4SdB6Um7klIduUN0lcI9hJjHn6iHzg2
         IdsKQlfLKruxXTlGhBIlhYfwgiN+JozxY2Z0yDSElIvSGv1ggxiLLDCA0Kz+5QcY9K
         USsnJL5aRGKJwejw9TuqJYviKaxl6Frf0mkRZF7s=
Date:   Wed, 8 May 2019 15:18:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 03/16] lib,treewide: add new match_string() helper/macro
Message-ID: <20190508131856.GB10138@kroah.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
 <20190508112842.11654-5-alexandru.ardelean@analog.com>
 <20190508131128.GL9224@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508131128.GL9224@smile.fi.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 04:11:28PM +0300, Andy Shevchenko wrote:
> On Wed, May 08, 2019 at 02:28:29PM +0300, Alexandru Ardelean wrote:
> > This change re-introduces `match_string()` as a macro that uses
> > ARRAY_SIZE() to compute the size of the array.
> > The macro is added in all the places that do
> > `match_string(_a, ARRAY_SIZE(_a), s)`, since the change is pretty
> > straightforward.
> 
> Can you split include/linux/ change from the rest?

That would break the build, why do you want it split out?  This makes
sense all as a single patch to me.

thanks,

greg k-h

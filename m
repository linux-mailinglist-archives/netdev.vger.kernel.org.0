Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C694279E8A
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 07:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730360AbgI0Fwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 01:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727614AbgI0Fwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 01:52:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 530A623A03;
        Sun, 27 Sep 2020 05:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601185950;
        bh=kHKLO/+ZkO726T7hWNZVIANgTTKBLmXVn8k2Klhf0Zw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0QJbvrqkmJolxgy2wlwYrkXJSfOpp/og/5ZVx9+anRgZ17PT4bEX+h1bh+mkvDula
         dsn2uBIaT4C0FjpS/jIlPXPMMy0yrcOuQaRoHVL4bFqyepdL5o4YOXDZFaRR9HcOUe
         pt8mW37ZeCYOi1VSzPikgqk2N18RtZx7Ip+EBPg4=
Date:   Sun, 27 Sep 2020 07:52:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 6/6] USB: cdc-acm: blacklist ETAS ES58X device
Message-ID: <20200927055226.GA701624@kroah.com>
References: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr>
 <20200926175810.278529-7-mailhol.vincent@wanadoo.fr>
 <20200927054520.GB699448@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200927054520.GB699448@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 27, 2020 at 07:45:20AM +0200, Greg Kroah-Hartman wrote:
> On Sun, Sep 27, 2020 at 02:57:56AM +0900, Vincent Mailhol wrote:
> > The ES58X devices are incorrectly recognized as USB Modem (CDC ACM),
> > preventing the etas-es58x module to load.
> > 
> > Thus, these have been added
> > to the ignore list in drivers/usb/class/cdc-acm.c
> > 
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > ---
> >  drivers/usb/class/cdc-acm.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> 
> Did you mean to send this twice?
> 
> And where are the 5 other patches in this series?
> 
> And finally, it's a good idea to include the output of 'lsusb -v' for
> devices that need quirks so we can figure things out later on, can you
> fix up your changelog to include that information?

Also, why is the device saying it is a cdc-acm compliant device when it
is not?  Why lie to the operating system like that?

thanks,

greg k-h

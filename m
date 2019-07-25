Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD2F74B1E
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 12:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbfGYKEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 06:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfGYKEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 06:04:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B39ED218D4;
        Thu, 25 Jul 2019 10:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564049083;
        bh=TEJk53LHFO9Ue4RAaS8/6tEcNjmL/kiPAgdMSNvmHdM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ywOOCxlu9NVt8/6cvytroviqXr15X52BbHOkT2Jx1tZ2imneLkIIzx61dTfnGd0bC
         BUzK1D2J5CDqmn8prpJFUCgjUG8R6McaXGYzqGh9hoVjueOfeYqB0YxfuVGEkVcmsb
         F+2knwpqkK8Z+yjlzjTsmO2ZGaQ1Fh6JkSdMZnJY=
Date:   Thu, 25 Jul 2019 12:04:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        netdev <netdev@vger.kernel.org>, linux-serial@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Trensch <MTrensch@hilscher.com>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Jiri Slaby <jslaby@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] serial: remove netx serial driver
Message-ID: <20190725100440.GC20445@kroah.com>
References: <20190722191552.252805-1-arnd@arndb.de>
 <20190722191552.252805-2-arnd@arndb.de>
 <CACRpkdbm5MpcNdm8EGTR=U8MpK2VPzEg=Us0-AxZzOZ=vVJSmQ@mail.gmail.com>
 <CAK8P3a1=Bnsxg-3RztGEL-c6muQjam-egyrsZfqc7_yjBzcGXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1=Bnsxg-3RztGEL-c6muQjam-egyrsZfqc7_yjBzcGXA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 10:43:05AM +0200, Arnd Bergmann wrote:
> On Tue, Jul 23, 2019 at 10:26 AM Linus Walleij <linus.walleij@linaro.org> wrote:
> >
> > On Mon, Jul 22, 2019 at 9:16 PM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > > The netx platform got removed, so this driver is now
> > > useless.
> > >
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >
> > We seem so overlap :)
> > https://marc.info/?l=linux-serial&m=156377843325488&w=2
> >
> > Anyways, the patches are identical except here:
> >
> > > -/* Hilscher netx */
> > > +/* Hilscher netx (removed) */
> > >  #define PORT_NETX      71
> >
> > Is there some reason for keeping the magical number around?
> > When I looked over the file there seemed to be more "holes"
> > in the list.
> 
> I looked at the same list and though I saw more obsolete entries
> than holes. The last ones that I saw getting removed were
> PORT_MFD in 2017 and PORT_V850E_UART in 2008.
> 
> It probably doesn't matter as we have precedence for both.

I want to just get rid of that whole list as I don't think it's ever
needed, but haven't spent the time digging through userspace code to
verify it.

I'll take Linus's patch as it came first, thanks.

greg k-h

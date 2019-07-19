Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B036E63D
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 15:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbfGSNUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 09:20:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52142 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbfGSNUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 09:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fGhjbD/ZLaMc/EQxPrDyzowQW6tcfV37E12zWwbgM6s=; b=CM6jDDiXi2sJnGUhAsCmIDEblF
        5TpzgPV/rrlWNatzmxJq5lDPUsMbeAbNPHvmBAPjLu3YAMDk39HmCkFNKkyZHXsfAEYwu3awMPcss
        +1dY/VWVpodHJX9EinVcRvwYIEk7F4vhdHRicxYZiYocIESZPM4eh3qX1mAj2KnwXtGg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hoSo9-0006eT-9B; Fri, 19 Jul 2019 15:20:21 +0200
Date:   Fri, 19 Jul 2019 15:20:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 0/5] PTP: add support for Intel's TGPIO controller
Message-ID: <20190719132021.GC24930@lunn.ch>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
 <20190718195040.GL25635@lunn.ch>
 <87h87isci5.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h87isci5.fsf@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 19, 2019 at 10:35:14AM +0300, Felipe Balbi wrote:
> 
> Hi,
> 
> Andrew Lunn <andrew@lunn.ch> writes:
> > On Tue, Jul 16, 2019 at 10:20:33AM +0300, Felipe Balbi wrote:
> >> TGPIO is a new IP which allows for time synchronization between systems
> >> without any other means of synchronization such as PTP or NTP. The
> >> driver is implemented as part of the PTP framework since its features
> >> covered most of what this controller can do.
> >
> > Hi Felipe
> >
> > Given the name TGPIO, can it also be used for plain old boring GPIO?
> 
> not really, no. This is a misnomer, IMHO :-) We can only assert output
> pulses at specified intervals or capture a timestamp of an external
> signal.

Hi Felipe

So i guess Intel Marketing wants to call it a GPIO, but between
engineers can we give it a better name?

> > Also, is this always embedded into a SoC? Or could it actually be in a
> > discrete NIC?
> 
> Technically, this could be done as a discrete, but it isn't. In any
> case, why does that matter? From a linux-point of view, we have a device
> driver either way.

I've seen a lot of i210 used with ARM SoCs. How necessary is the tsc
patch? Is there an architecture independent alternative?

       Andrew

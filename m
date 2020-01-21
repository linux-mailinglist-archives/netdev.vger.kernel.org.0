Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02D58144895
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 00:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgAUXxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 18:53:09 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:46712 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgAUXxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 18:53:09 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id EBB7122C30;
        Tue, 21 Jan 2020 18:53:05 -0500 (EST)
Date:   Wed, 22 Jan 2020 10:53:04 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Stephen Hemminger <stephen@networkplumber.org>
cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 05/12] net/sonic: Fix receive buffer handling
In-Reply-To: <20200121142356.2b17ad74@hermes.lan>
Message-ID: <alpine.LNX.2.21.1.2001221034510.8@nippy.intranet>
References: <cover.1579641728.git.fthain@telegraphics.com.au> <e20133bf43ec6f5967a3330dacaf38f653bf3061.1579641728.git.fthain@telegraphics.com.au> <20200121142356.2b17ad74@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jan 2020, Stephen Hemminger wrote:

> On Wed, 22 Jan 2020 08:22:08 +1100
> Finn Thain <fthain@telegraphics.com.au> wrote:
> 
> >  
> > +/* Return the array index corresponding to a given Receive Buffer pointer. */
> > +
> > +static inline int index_from_addr(struct sonic_local *lp, dma_addr_t addr,
> > +				  unsigned int last)
> 
> Why the blank line between comment and the start of the function?
> 

The driver mostly uses this style:

/*
 * We have a good packet(s), pass it/them up the network stack.
 */
static void sonic_rx(struct net_device *dev)
{
}

To my eyes, style I used is the closest readable approximation of the 
existing style that doesn't upset checkpatch.

Anyway, I will remove the blank lines.

> Also, the kernel standard is not to use the inline keyword on functions 
> and let the compiler decide to inline if it wants to.

OK.

Thanks for your review.

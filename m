Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E632835DB
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 14:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgJEMiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 08:38:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgJEMiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 08:38:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kPPkf-000DWm-Pu; Mon, 05 Oct 2020 14:38:01 +0200
Date:   Mon, 5 Oct 2020 14:38:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Samanta Navarro <ferivoz@riseup.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] man: fix typos
Message-ID: <20201005123801.GD15640@lunn.ch>
References: <20201004114259.nwnu3j4uuaryjvx4@localhost>
 <20201004153315.GE4183771@lunn.ch>
 <20201005111020.ggajtydayerg2j3u@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005111020.ggajtydayerg2j3u@localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 11:10:20AM +0000, Samanta Navarro wrote:
> ---
> Hello Andrew,
> 
> On Sun, Oct 04, 2020 at 05:33:15PM +0200, Andrew Lunn wrote:
> > On Sun, Oct 04, 2020 at 11:42:59AM +0000, Samanta Navarro wrote:
> > > @@ -392,7 +392,7 @@ packet the new device should accept.
> > >  .TP
> > >  .BI gso_max_segs " SEGMENTS "
> > >  specifies the recommended maximum number of a Generic Segment Offload
> > > -segments the new device should accept.
> > > +segment the new device should accept.
> > 
> > The original seems correct to me.
> 
> when I shorten the sentence, it states:
> "specifies the number of a segments the device should accept"
> 
> Either "a segment" or "segments" without "a" is correct.
> 
> After carefully evaluating the sentence in its context, I would agree
> that plural is supposed to be used there. The previous sentence in the
> manual page is almost identical. This is probably a copy&paste mistake.
> And this means that "a" should be removed instead.

Yes, i agree, please drop the 'a'.

     Andrew

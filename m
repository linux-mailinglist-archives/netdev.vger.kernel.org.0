Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE7125E187
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 20:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgIDSin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 14:38:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43630 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgIDSim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 14:38:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kEGba-00DEuJ-3F; Fri, 04 Sep 2020 20:38:34 +0200
Date:   Fri, 4 Sep 2020 20:38:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sunil Kovvuri Goutham <sgoutham@marvell.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Srujana Challa <schalla@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Suheil Chandran <schandran@marvell.com>,
        Narayana Prasad Raju Athreya <pathreya@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [EXT] Re: [PATCH v2 2/3] drivers: crypto: add support for
 OCTEONTX2 CPT engine
Message-ID: <20200904183834.GS3112546@lunn.ch>
References: <1596809360-12597-1-git-send-email-schalla@marvell.com>
 <1596809360-12597-3-git-send-email-schalla@marvell.com>
 <20200813005407.GB24593@gondor.apana.org.au>
 <BYAPR18MB2791C6451CDE93CA053E0208A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
 <20200904135044.GA2836@gondor.apana.org.au>
 <BYAPR18MB2791A52DA3BF1D7BE5574F99A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
 <20200904141744.GA3092@gondor.apana.org.au>
 <BY5PR18MB32984DAF0FDED5D9CD1BEB45C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR18MB32984DAF0FDED5D9CD1BEB45C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 04:36:29PM +0000, Sunil Kovvuri Goutham wrote:
> 
> 
> > -----Original Message-----
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Sent: Friday, September 4, 2020 7:48 PM
> > To: Srujana Challa <schalla@marvell.com>
> > Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-
> > crypto@vger.kernel.org; Suheil Chandran <schandran@marvell.com>;
> > Narayana Prasad Raju Athreya <pathreya@marvell.com>; Sunil Kovvuri
> > Goutham <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
> > Geethasowjanya Akula <gakula@marvell.com>; Jerin Jacob Kollanukkaran
> > <jerinj@marvell.com>; Ard Biesheuvel <ardb@kernel.org>
> > Subject: Re: [EXT] Re: [PATCH v2 2/3] drivers: crypto: add support for
> > OCTEONTX2 CPT engine
> > 
> > On Fri, Sep 04, 2020 at 02:14:34PM +0000, Srujana Challa wrote:
> > >
> > > Since LMT store is our platform specific, it cannot be generalized to all
> > ARM64.
> > 
> > I'm not asking you to generalise it to all of ARM64.  I'm asking you to move
> > this into a header file under arch/arm64 that can then be shared by both your
> > crypto driver and your network driver so you don't duplicate this
> > everywhere.
> > 
> 
> For ARM64 , except erratas other platform or machine dependent stuff are not allowed inside arch/arm64.
> Also an earlier attempt by us to add few APIs addressing 128bit operations were not allowed by ARM folks
> as they don't work in a generic way and are SOC specific.
> http://lkml.iu.edu/hypermail/linux/kernel/1801.3/02211.html

Maybe put it in include/linux/soc/ ?

      Andrew

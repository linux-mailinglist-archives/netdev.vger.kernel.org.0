Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F2B25DB34
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgIDOSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:18:22 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:43134 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730675AbgIDORv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 10:17:51 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kECXA-00084r-J2; Sat, 05 Sep 2020 00:17:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Sep 2020 00:17:44 +1000
Date:   Sat, 5 Sep 2020 00:17:44 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Srujana Challa <schalla@marvell.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Suheil Chandran <schandran@marvell.com>,
        Narayana Prasad Raju Athreya <pathreya@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [EXT] Re: [PATCH v2 2/3] drivers: crypto: add support for
 OCTEONTX2 CPT engine
Message-ID: <20200904141744.GA3092@gondor.apana.org.au>
References: <1596809360-12597-1-git-send-email-schalla@marvell.com>
 <1596809360-12597-3-git-send-email-schalla@marvell.com>
 <20200813005407.GB24593@gondor.apana.org.au>
 <BYAPR18MB2791C6451CDE93CA053E0208A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
 <20200904135044.GA2836@gondor.apana.org.au>
 <BYAPR18MB2791A52DA3BF1D7BE5574F99A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR18MB2791A52DA3BF1D7BE5574F99A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 02:14:34PM +0000, Srujana Challa wrote:
>
> Since LMT store is our platform specific, it cannot be generalized to all ARM64.

I'm not asking you to generalise it to all of ARM64.  I'm asking
you to move this into a header file under arch/arm64 that can then
be shared by both your crypto driver and your network driver so
you don't duplicate this everywhere.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

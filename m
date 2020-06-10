Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5BF1F585C
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 17:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgFJPxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 11:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728217AbgFJPxN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 11:53:13 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57E37206F4;
        Wed, 10 Jun 2020 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591804393;
        bh=jKyRFc09U4pc6AUdaO2U2v1JesKj0Dr9snvP7EDAh0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bdosIPAFrSzRJCwMhu1K7aaFtBFNSCDNT2zu6Kz4grWB28dgdF39lQvrWPn5dOyYb
         m6JzWoWKQorB50vbPDqgyPq31E0GWkANLhQMbvP9iNKijJA8jhYrG0GFIsVIXAdPwa
         87SarRnsucOIgiYJfTOZPuuXq8HdOJM2kkyuYFMk=
Date:   Wed, 10 Jun 2020 08:53:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tobias Brunner <tobias@strongswan.org>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net v3 3/3] esp, ah: modernize the crypto algorithm
 selections
Message-ID: <20200610155312.GB1339@sol.localdomain>
References: <20200610005402.152495-1-ebiggers@kernel.org>
 <20200610005402.152495-4-ebiggers@kernel.org>
 <c87f1edb-4130-a4a9-2915-ae5d55302f0a@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c87f1edb-4130-a4a9-2915-ae5d55302f0a@strongswan.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 11:03:55AM +0200, Tobias Brunner wrote:
> Hi Eric,
> 
> > +	  Note that RFC 8221 considers AH itself to be "NOT RECOMMENDED".  It is
> > +	  better to use ESP only, using an AEAD cipher such as AES-GCM.
> 
> What's NOT RECOMMENDED according to the RFC is the combination of ESP+AH
> (i.e. use ESP only for confidentiality and AH for authentication), not
> AH by itself (although the RFC keeps ENCR_NULL as a MUST because ESP
> with NULL encryption is generally preferred over AH due to NATs).
> 
> Regards,
> Tobias

Okay, I'll drop this paragraph.  I'm surprised that authentication-only is still
considered a valid use case though.

- Eric

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEE7402D65
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 19:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345578AbhIGREX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 13:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345620AbhIGRES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 13:04:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89B366056B;
        Tue,  7 Sep 2021 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631034191;
        bh=HLUPrG0uQnLOGXjzT2ESrMIg7IlO3ggx3WxRK+BTZ/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kEkGQ+DbZfcudvhNML2ZlFYKXc/6VnMA+rU98YC5u2YkJA2MiQmi9Khge06v2U87k
         XS+tkYzT1sKQrHjb4RFajm03DgUet7faeoiE8BcjZu/G2Y+xntMPmzokzjIi0pwMif
         YSXtSn4GOEndlBB8C3T/slCEBPyGNxnYyCUVesKU556dGQV+HOY2VnzET0JBMHcULX
         or2fPBWf2MDPV6ZnpHDJyavi1vV0epkxu07sxob6qNBZ2k02A/Z6dQwafZvh96QS9S
         pmYImoJRrkp3GP0ZyCyBrwHnbJCi2UXTDS9mrI7fal+V9jKwdz6JxZ7gf2hCFIsZdV
         yT2WxPh5dBvjQ==
Date:   Tue, 7 Sep 2021 10:03:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/15] nfc: pn533: drop unneeded debug prints
Message-ID: <20210907100310.0cdec18b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <35626061-ff2e-cb01-21ff-87a6f776dc28@canonical.com>
References: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
        <20210907121816.37750-6-krzysztof.kozlowski@canonical.com>
        <35626061-ff2e-cb01-21ff-87a6f776dc28@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Sep 2021 18:05:25 +0200 Krzysztof Kozlowski wrote:
> On 07/09/2021 14:18, Krzysztof Kozlowski wrote:
> > ftrace is a preferred and standard way to debug entering and exiting
> > functions so drop useless debug prints.
> > 
> > Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> > ---
> >  drivers/nfc/pn533/i2c.c   | 1 -
> >  drivers/nfc/pn533/pn533.c | 2 --
> >  2 files changed, 3 deletions(-)
> > 
> > diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
> > index e6bf8cfe3aa7..91d4a035eb63 100644
> > --- a/drivers/nfc/pn533/i2c.c
> > +++ b/drivers/nfc/pn533/i2c.c
> > @@ -138,7 +138,6 @@ static irqreturn_t pn533_i2c_irq_thread_fn(int irq, void *data)
> >  	}
> >  
> >  	client = phy->i2c_dev;  
> 
> This line should also be removed (reported by kbuild robot).
> 
> I will send a v2.

Dave marked the series as Deferred (although this patch is Changes
Requested, I'm guessing you did that, if so please don't change patch
states in netdev pw), please hold off:


# Form letter - net-next is closed

We have already sent the networking pull request for 5.15
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.15-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.

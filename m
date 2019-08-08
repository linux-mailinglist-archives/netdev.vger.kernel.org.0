Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56EE86740
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 18:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404015AbfHHQjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 12:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732760AbfHHQjJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 12:39:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1A4D217F4;
        Thu,  8 Aug 2019 16:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565282348;
        bh=mRyfVMwsOzYDrLMZknImpwFsUvSxDu1kZ2pgGFqnFgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AfT6bSTPiQ1sOIRhsY94itXzIintmnNzXfmefa5yG6JMi0HkBuGRy4SL0y+8puvyb
         SKo0vd2af9p+lEbrzuqrnDeI/NpaB0GuNiOoWY4MYB7V1QidVDQHFPKxJbqnBYmfQK
         9c8dptNYBC65HyHR5dbM6d8woLWkJBtdzHVJ7/HU=
Date:   Thu, 8 Aug 2019 18:39:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jose Carlos Cazarin Filho <joseespiriki@gmail.com>,
        isdn@linux-pingi.de, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: hysdn: Fix error spaces around '*'
Message-ID: <20190808163905.GA9224@kroah.com>
References: <20190802195602.28414-1-joseespiriki@gmail.com>
 <20190802145506.168b576b@hermes.lan>
 <2ecfbf8dda354fe47912446bf5c3fe30ca905aa0.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ecfbf8dda354fe47912446bf5c3fe30ca905aa0.camel@perches.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 03:05:05PM -0700, Joe Perches wrote:
> On Fri, 2019-08-02 at 14:55 -0700, Stephen Hemminger wrote:
> > On Fri,  2 Aug 2019 19:56:02 +0000
> > Jose Carlos Cazarin Filho <joseespiriki@gmail.com> wrote:
> > 
> > > Fix checkpath error:
> > > CHECK: spaces preferred around that '*' (ctx:WxV)
> > > +extern hysdn_card *card_root;        /* pointer to first card */
> > > 
> > > Signed-off-by: Jose Carlos Cazarin Filho <joseespiriki@gmail.com>
> > 
> > Read the TODO, these drivers are scheduled for removal, so changes
> > are not helpful at this time.
> 
> Maybe better to mark the MAINTAINERS entry obsolete so
> checkpatch bleats a message about unnecessary changes.
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 30bf852e6d6b..b5df91032574 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8628,7 +8628,7 @@ M:	Karsten Keil <isdn@linux-pingi.de>
>  L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
>  L:	netdev@vger.kernel.org
>  W:	http://www.isdn4linux.de
> -S:	Odd Fixes
> +S:	Obsolete
>  F:	Documentation/isdn/
>  F:	drivers/isdn/capi/
>  F:	drivers/staging/isdn/
> 

Good idea, will take this patch now, thanks.

greg k-h

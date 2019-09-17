Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1989B4D4C
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 13:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfIQL5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 07:57:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61698 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfIQL5q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 07:57:46 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 131653018FC5;
        Tue, 17 Sep 2019 11:57:46 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-116-43.ams2.redhat.com [10.36.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D1E275B6A5;
        Tue, 17 Sep 2019 11:57:44 +0000 (UTC)
Date:   Tue, 17 Sep 2019 13:57:43 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH ipsec-next v2 6/6] xfrm: add espintcp (RFC 8229)
Message-ID: <20190917115743.GA89567@bistromath.localdomain>
References: <cover.1568192824.git.sd@queasysnail.net>
 <ce5eb26c12fa07e905b9d83ef8c07485c5516ffe.1568192824.git.sd@queasysnail.net>
 <20190917112649.GE2879@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190917112649.GE2879@gauss3.secunet.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 17 Sep 2019 11:57:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-09-17, 13:26:49 +0200, Steffen Klassert wrote:
> On Wed, Sep 11, 2019 at 04:13:07PM +0200, Sabrina Dubroca wrote:
> ...
> > diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
> > index 51bb6018f3bf..e67044527fb7 100644
> > --- a/net/xfrm/Kconfig
> > +++ b/net/xfrm/Kconfig
> > @@ -73,6 +73,16 @@ config XFRM_IPCOMP
> >  	select CRYPTO
> >  	select CRYPTO_DEFLATE
> >  
> > +config XFRM_ESPINTCP
> > +	bool "ESP in TCP encapsulation (RFC 8229)"
> > +	depends on XFRM && INET_ESP
> > +	select STREAM_PARSER
> > +	select NET_SOCK_MSG
> > +	help
> > +	  Support for RFC 8229 encapsulation of ESP and IKE over TCP sockets.
> > +
> > +	  If unsure, say N.
> > +
> 
> One nitpick: This is IPv4 only, so please move this below the ESP
> section in net/ipv4/Kconfig and use the naming convention there.
> I.e. bool "IP: ESP in TCP encapsulation (RFC 8229)"

That's temporary, though, the next step will be to make it work for
both IPv4 and IPv6. Do you prefer I move it to net/ipv4/Kconfig for
now, and then back to net/xfrm/Kconfig when I add IPv6 support?

> Everything else looks very good!

Thanks!

-- 
Sabrina

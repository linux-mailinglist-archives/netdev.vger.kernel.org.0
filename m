Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A456391C
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 18:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfGIQO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 12:14:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60940 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbfGIQO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 12:14:57 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hkslc-0004cd-HB; Wed, 10 Jul 2019 00:14:56 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hkslY-0002UP-NI; Wed, 10 Jul 2019 00:14:52 +0800
Date:   Wed, 10 Jul 2019 00:14:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH] crypto: user - make NETLINK_CRYPTO work inside netns
Message-ID: <20190709161452.54gxs7fwif7hs7dx@gondor.apana.org.au>
References: <20190709111124.31127-1-omosnace@redhat.com>
 <20190709143832.hej23rahmb4basy6@gondor.apana.org.au>
 <CAFqZXNs2XysEWVzmfXSczH-+oX5iwwRC3+9fL3tWYEfDRbqLig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqZXNs2XysEWVzmfXSczH-+oX5iwwRC3+9fL3tWYEfDRbqLig@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 05:28:35PM +0200, Ondrej Mosnacek wrote:
>
> I admit I'm not an expert on Linux namespaces, but aren't you
> confusing network and user namespaces? Unless I'm mistaken, these
> changes only affect _network_ namespaces (which only isolate the
> network stuff itself) and the semantics of the netlink_capable(skb,
> CAP_NET_ADMIN) calls remain unchanged - they check if the opener of
> the socket has the CAP_NET_ADMIN capability within the global _user_
> namespace.

Good point.  I think your patch should be OK then.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

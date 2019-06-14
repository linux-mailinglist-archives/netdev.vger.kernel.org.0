Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 136A5463AC
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 18:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfFNQMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 12:12:01 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35134 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbfFNQMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 12:12:01 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hbonz-0007Xx-Gv; Sat, 15 Jun 2019 00:11:55 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hbons-0008UM-W7; Sat, 15 Jun 2019 00:11:49 +0800
Date:   Sat, 15 Jun 2019 00:11:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net,
        netdev@vger.kernel.org, Anirudh Gupta <anirudh.gupta@sophos.com>
Subject: Re: [PATCH ipsec] xfrm: fix sa selector validation
Message-ID: <20190614161148.vti6mhvnxfwweznc@gondor.apana.org.au>
References: <20190614091355.18852-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614091355.18852-1-nicolas.dichtel@6wind.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 11:13:55AM +0200, Nicolas Dichtel wrote:
> After commit b38ff4075a80, the following command does not work anymore:
> $ ip xfrm state add src 10.125.0.2 dst 10.125.0.1 proto esp spi 34 reqid 1 \
>   mode tunnel enc 'cbc(aes)' 0xb0abdba8b782ad9d364ec81e3a7d82a1 auth-trunc \
>   'hmac(sha1)' 0xe26609ebd00acb6a4d51fca13e49ea78a72c73e6 96 flag align4
> 
> In fact, the selector is not mandatory, allow the user to provide an empty
> selector.
> 
> Fixes: b38ff4075a80 ("xfrm: Fix xfrm sel prefix length validation")
> CC: Anirudh Gupta <anirudh.gupta@sophos.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Sorry for not catching this!

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

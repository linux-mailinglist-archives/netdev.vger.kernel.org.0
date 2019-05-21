Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4F624617
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 04:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfEUCtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 22:49:46 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54704 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726325AbfEUCtp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 22:49:45 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hSuqS-0005HR-40; Tue, 21 May 2019 10:49:40 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hSuqO-0002iz-Gf; Tue, 21 May 2019 10:49:36 +0800
Date:   Tue, 21 May 2019 10:49:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Anirudh Gupta <anirudhrudr@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Anirudh Gupta <anirudh.gupta@sophos.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] xfrm: Fix xfrm sel prefix length validation
Message-ID: <20190521024936.ou7gkfhb6hvhbi7j@gondor.apana.org.au>
References: <20190520093157.59825-1-anirudh.gupta@sophos.com>
 <20190520153219.oq3se5wvkasgbtkp@gondor.apana.org.au>
 <CAN2cbVe3WNj8cR1dLysCP46-LwiHZYMWRpowA+bzNpyZRexSaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN2cbVe3WNj8cR1dLysCP46-LwiHZYMWRpowA+bzNpyZRexSaA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 10:30:29PM +0530, Anirudh Gupta wrote:
> Yes, I notice that is the only verification of p->family from userspace.
> However, the underlying conditions added in commit '07bf7908950a',
> validates the selector src/dest prefix len.

You need to check both p->family and p->sel.family.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

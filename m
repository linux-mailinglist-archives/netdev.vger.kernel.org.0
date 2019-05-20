Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A4123CE3
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 18:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389184AbfETQIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 12:08:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50786 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387973AbfETQIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 12:08:01 -0400
X-Greylist: delayed 2127 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 May 2019 12:08:01 EDT
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hSkH4-00086s-4a; Mon, 20 May 2019 23:32:26 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hSkGx-00023C-KB; Mon, 20 May 2019 23:32:19 +0800
Date:   Mon, 20 May 2019 23:32:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Anirudh Gupta <anirudhrudr@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Anirudh Gupta <anirudh.gupta@sophos.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] xfrm: Fix xfrm sel prefix length validation
Message-ID: <20190520153219.oq3se5wvkasgbtkp@gondor.apana.org.au>
References: <20190520093157.59825-1-anirudh.gupta@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520093157.59825-1-anirudh.gupta@sophos.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 03:01:56PM +0530, Anirudh Gupta wrote:
>
> diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
> index eb8d14389601..fc2a8c08091b 100644
> --- a/net/xfrm/xfrm_user.c
> +++ b/net/xfrm/xfrm_user.c
> @@ -149,7 +149,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
>  	int err;
>  
>  	err = -EINVAL;
> -	switch (p->family) {
> +	switch (p->sel.family) {
>  	case AF_INET:
>  		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
>  			goto out;

You just removed the only verification of p->family...
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

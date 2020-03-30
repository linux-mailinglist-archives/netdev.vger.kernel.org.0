Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB34197185
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 02:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgC3Ato (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 20:49:44 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48608 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727742AbgC3Atn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 20:49:43 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jIicD-0007Fo-Kh; Mon, 30 Mar 2020 11:49:22 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 30 Mar 2020 11:49:21 +1100
Date:   Mon, 30 Mar 2020 11:49:21 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Linux Crypto List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: Re: linux-next: manual merge of the crypto tree with the net-next
 tree
Message-ID: <20200330004921.GA30111@gondor.apana.org.au>
References: <20200330114209.1c7d5d11@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330114209.1c7d5d11@canb.auug.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 11:42:09AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the crypto tree got a conflict in:
> 
>   drivers/crypto/chelsio/chcr_core.c
> 
> between commit:
> 
>   34aba2c45024 ("cxgb4/chcr : Register to tls add and del callback")
> 
> from the net-next tree and commit:
> 
>   53351bb96b6b ("crypto: chelsio/chcr - Fixes a deadlock between rtnl_lock and uld_mutex")
> 
> from the crypto tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Thanks for the heads up Stephen.

Ayush, I'm going to drop the two chelsio patches.  Going forward,
please send all chelsio patches via netdev.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

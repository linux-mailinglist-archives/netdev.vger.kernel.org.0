Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E60F22D56E
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 08:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgGYGUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 02:20:51 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42748 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgGYGUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 02:20:51 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jzDXu-0003IR-Hl; Sat, 25 Jul 2020 16:20:35 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 25 Jul 2020 16:20:34 +1000
Date:   Sat, 25 Jul 2020 16:20:34 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     ayush.sawal@chelsio.com, netdev@vger.kernel.org,
        secdev@chelsio.com, lkp@intel.com,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net V2] Crypto/chcr: Registering cxgb4 to xfrmdev_ops
Message-ID: <20200725062034.GA19493@gondor.apana.org.au>
References: <20200724084124.21651-1-ayush.sawal@chelsio.com>
 <20200724.170108.362782113011946610.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724.170108.362782113011946610.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 05:01:08PM -0700, David Miller wrote:
> 
> Please start submitting chcr patches to the crypto subsystem, where it
> belongs, instead of the networking GIT trees.

Hi Dave:

I think this patch belongs to the networking tree.  The reason is
that it's related to xfrm offload which has nothing to do with the
Crypto API.

Do xfrm offload drivers usually go through the networking tree or
would it be better directed through the xfrm tree?

There's really nobody on the crypto mailing list who could give
this the proper review that it deserves.

Of course I'm happy to continue taking anything that touches
chcr_algo.c as that resides wholly within the Crypto API.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C770E292169
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 05:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731408AbgJSDPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 23:15:09 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57606 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729093AbgJSDPI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 23:15:08 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kULdR-0003Ig-TP; Mon, 19 Oct 2020 14:14:59 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 Oct 2020 14:14:57 +1100
Date:   Mon, 19 Oct 2020 14:14:57 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     davem@davemloft.net, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-afs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: gssapi, crypto and afs/rxrpc
Message-ID: <20201019031457.GA551@gondor.apana.org.au>
References: <1444464.1602865106@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1444464.1602865106@warthog.procyon.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 05:18:26PM +0100, David Howells wrote:
>
> If I do this, should I create a "kerberos" crypto API for the data wrapping
> functions?  I'm not sure that it quite matches the existing APIs because the
> size of the input data will likely not match the size of the output data and
> it's "one shot" as it needs to deal with a checksum.

Generally it makes sense to create a Crypto API for an algorithm
if there are going to be at least two implementations of it.  In
particular, if there is hardware acceleration available then it'd
make sense.

Otherwise a library helper would be more appropriate.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

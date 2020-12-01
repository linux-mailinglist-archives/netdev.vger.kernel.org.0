Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178E92C99E3
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 09:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgLAIri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 03:47:38 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:48310 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727499AbgLAIri (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 03:47:38 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kk1J0-0006Rz-J0; Tue, 01 Dec 2020 19:46:39 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Dec 2020 19:46:38 +1100
Date:   Tue, 1 Dec 2020 19:46:38 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     bfields@fieldses.org, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
Message-ID: <20201201084638.GA27937@gondor.apana.org.au>
References: <20201127050701.GA22001@gondor.apana.org.au>
 <20201126063303.GA18366@gondor.apana.org.au>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <1976719.1606378781@warthog.procyon.org.uk>
 <4035245.1606812273@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4035245.1606812273@warthog.procyon.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 08:44:33AM +0000, David Howells wrote:
> Btw, would it be feasible to make it so that an extra parameter can be added
> to the cipher buffer-supplying functions, e.g.:
> 
> 	skcipher_request_set_crypt(req, input, ciphertext_sg, esize, iv);
> 
> such that we can pass in an offset into the output sg as well?

Couldn't you just change the output sg to include the offset?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

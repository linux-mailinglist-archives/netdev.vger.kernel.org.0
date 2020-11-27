Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7C32C5F73
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 06:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgK0FHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 00:07:14 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33038 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgK0FHN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 00:07:13 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kiVyH-00089n-Qz; Fri, 27 Nov 2020 16:07:02 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2020 16:07:01 +1100
Date:   Fri, 27 Nov 2020 16:07:01 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     bfields@fieldses.org, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
Message-ID: <20201127050701.GA22001@gondor.apana.org.au>
References: <20201126063303.GA18366@gondor.apana.org.au>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <1976719.1606378781@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1976719.1606378781@warthog.procyon.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 08:19:41AM +0000, David Howells wrote:
>
> I haven't done that yet.  Sorry, I should've been more explicit with what I
> was after.  I was wanting to find out if the nfs/nfsd people are okay with
> this (and if there are any gotchas I should know about - it turns out, if I
> understand it correctly, the relevant code may being being rewritten a bit
> anyway).
> 
> And from you, I was wanting to find out if you're okay with an interface of
> this kind in crypto/ where the code is just used directly - or whether I'll
> be required to wrap it up in the autoloading, module-handling mechanisms.

I don't have any problems with it living under crypto.  However,
I'd like to see what the sunrpc code looks like before going one
way or another.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

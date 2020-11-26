Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF572C4EBE
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 07:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388082AbgKZGdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 01:33:22 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:56720 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732715AbgKZGdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 01:33:21 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kiApz-000630-5s; Thu, 26 Nov 2020 17:33:04 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Nov 2020 17:33:03 +1100
Date:   Thu, 26 Nov 2020 17:33:03 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     bfields@fieldses.org, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
Message-ID: <20201126063303.GA18366@gondor.apana.org.au>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 12:57:45PM +0000, David Howells wrote:
> 
> Hi Herbert, Bruce,
> 
> Here's my first cut at a generic Kerberos crypto library in the kernel so
> that I can share code between rxrpc and sunrpc (and cifs?).

Hi David:

I can't find the bit where you are actually sharing this code with
sunrpc, am I missing something?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

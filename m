Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5761A2CF601
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 22:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgLDVJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 16:09:57 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33832 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgLDVJ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 16:09:56 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1klIJz-0006K8-Lg; Sat, 05 Dec 2020 08:08:56 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Dec 2020 08:08:55 +1100
Date:   Sat, 5 Dec 2020 08:08:55 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Bruce Fields <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org
Subject: Re: Why the auxiliary cipher in gss_krb5_crypto.c?
Message-ID: <20201204210855.GA3412@gondor.apana.org.au>
References: <20201204154626.GA26255@fieldses.org>
 <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <118876.1607093975@warthog.procyon.org.uk>
 <122997.1607097713@warthog.procyon.org.uk>
 <20201204160347.GA26933@fieldses.org>
 <125709.1607100601@warthog.procyon.org.uk>
 <CAMj1kXEOm_yh478i+dqPiz0eoBxp4eag3j2qHm5eBLe+2kihoQ@mail.gmail.com>
 <127458.1607102368@warthog.procyon.org.uk>
 <CAMj1kXFe50HvZLxG6Kh-oYBCf5uu51hhuh7mW5UQ62ZSqmu_xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFe50HvZLxG6Kh-oYBCf5uu51hhuh7mW5UQ62ZSqmu_xA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 06:35:48PM +0100, Ard Biesheuvel wrote:
>
> Herbert recently made some changes for MSG_MORE support in the AF_ALG
> code, which permits a skcipher encryption to be split into several
> invocations of the skcipher layer without the need for this complexity
> on the side of the caller. Maybe there is a way to reuse that here.
> Herbert?

Yes this was one of the reasons I was persuing the continuation
work.  It should allow us to kill the special case for CTS in the
krb5 code.

Hopefully I can get some time to restart work on this soon.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

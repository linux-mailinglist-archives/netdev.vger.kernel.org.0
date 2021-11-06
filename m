Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF28446C41
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 04:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhKFDqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 23:46:30 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56586 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhKFDq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 23:46:27 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mjCcD-00061h-Hx; Sat, 06 Nov 2021 11:43:37 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mjCcA-0004qM-GI; Sat, 06 Nov 2021 11:43:34 +0800
Date:   Sat, 6 Nov 2021 11:43:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "David S. Miller" <davem@davemloft.net>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 5/5] tcp/md5: Make more generic tcp_sig_pool
Message-ID: <20211106034334.GA18577@gondor.apana.org.au>
References: <20211105014953.972946-1-dima@arista.com>
 <20211105014953.972946-6-dima@arista.com>
 <88edb8ff-532e-5662-cda7-c00904c612b4@gmail.com>
 <11215b43-cd3f-6cdc-36da-44636ca11f51@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11215b43-cd3f-6cdc-36da-44636ca11f51@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 01:59:35PM +0000, Dmitry Safonov wrote:
> On 11/5/21 09:54, Leonard Crestez wrote:
>
> > This pool pattern is a workaround for crypto-api only being able to
> > allocate transforms from user context.
> >> It would be useful for this "one-transform-per-cpu" object to be part of
> > crypto api itself, there is nothing TCP-specific here other than the
> > size of scratch buffer.
> 
> Agree, it would be nice to have something like this as a part of crypto.
> The intention here is to reuse md5 sig pool, rather than introduce
> another similar one.

As I said before, I'm happy to see the ahash/shash interface modified
so that we allow the key to be in the request object in addition to the
tfm.  However, I don't really have the time to work on that and
nobody else from the crypto side seems interested in this.

So if you guys have the time and are willing to work on it then I'm
more than happy to help you.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

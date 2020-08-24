Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA61224FF0E
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 15:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgHXNjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 09:39:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727015AbgHXNi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 09:38:59 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E3E42177B;
        Mon, 24 Aug 2020 13:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598276339;
        bh=kEbqLgXtUbdCPrN4ICEl0OvR3tkJnudXGG5JsPUDVig=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MLII6vb04GJQ+J/FKHi16LG3O2tI047xpNLr7Yy6fqVE3od/oITTChvIRzwLwzRA9
         ThSwD0T8Bra0lEVUfDR7/JbGO0M4a6vV5K3RXBxP/6DbPK684u97use7vD3drZDdpE
         4WAgxNaLPWltVSlkzLsPv3CaMfgzNYYYwc719kAM=
Received: by mail-ot1-f53.google.com with SMTP id h22so7265270otq.11;
        Mon, 24 Aug 2020 06:38:59 -0700 (PDT)
X-Gm-Message-State: AOAM533ClwPx2f9BYgq3E4/uvggU1bB5zJyqBKpTqvAqH7S6HIU507ir
        zncR4vZTx0PAMjoC8TSNHaMkqVf/Ddr82L3WzLE=
X-Google-Smtp-Source: ABdhPJw1+FTr8NU33NPKN/I6Uh6X3jKuIjoVKrbJNixZCRN6rv3ElWe8BMm5ignE2b4v6a+Idlz15Bx3llj3ETTz3rU=
X-Received: by 2002:a9d:774d:: with SMTP id t13mr3396136otl.108.1598276338681;
 Mon, 24 Aug 2020 06:38:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200824133001.9546-1-ardb@kernel.org> <20200824133001.9546-8-ardb@kernel.org>
 <20200824133448.GA5019@gondor.apana.org.au>
In-Reply-To: <20200824133448.GA5019@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 24 Aug 2020 15:38:47 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFSuFfgYHfD69XQHpGMyA+vg0KqEg-ymix1-Vu=CfDDvQ@mail.gmail.com>
Message-ID: <CAMj1kXFSuFfgYHfD69XQHpGMyA+vg0KqEg-ymix1-Vu=CfDDvQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] crypto: arc4 - mark ecb(arc4) skcipher as obsolete
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, devel@driverdev.osuosl.org,
        linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Aug 2020 at 15:35, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Aug 24, 2020 at 03:30:01PM +0200, Ard Biesheuvel wrote:
> >
> > +config CRYPTO_USER_ENABLE_OBSOLETE
> > +     bool "Enable obsolete cryptographic algorithms for userspace"
> > +     depends on CRYPTO_USER
>
> That should be CRYPTO_USER_API which is the option for af_alg.
> CRYPTO_USER is the configuration interface which has nothing to
> do with af_alg.
>

OK, will fix.

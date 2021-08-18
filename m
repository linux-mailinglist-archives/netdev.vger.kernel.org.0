Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA063F03F9
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbhHRMtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:49:43 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53332 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235754AbhHRMtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:49:41 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mGL06-0000Hr-C2; Wed, 18 Aug 2021 20:48:58 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mGKzU-0005U2-FL; Wed, 18 Aug 2021 20:48:20 +0800
Date:   Wed, 18 Aug 2021 20:48:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        syzbot+b9cfd1cc5d57ee0a09ab@syzkaller.appspotmail.com,
        stable@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: xfrm: assign the per_cpu_ptr pointer before return
Message-ID: <20210818124820.GB20948@gondor.apana.org.au>
References: <20210818032554.283428-1-mudongliangabcd@gmail.com>
 <20210818033207.GA19350@gondor.apana.org.au>
 <CAD-N9QVRuBAER0o1H6eTre_YOU+4mbHuj3homHno0UHiJrXuUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD-N9QVRuBAER0o1H6eTre_YOU+4mbHuj3homHno0UHiJrXuUg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 06:39:25PM +0800, Dongliang Mu wrote:
>
> :\ Then I have no idea how this crash occurs. This crash report does
> not have any reproducer. It seems like a random crash, but I am not
> sure.
> 
> If you have any patch for this crash, please let me know.

I don't have any ideas either, sorry.  But my guess would be that
there is corruption somewhere else that's showing up in ipcomp.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CA240D397
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 09:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhIPHJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 03:09:29 -0400
Received: from mail.alarsen.net ([144.76.18.233]:52260 "EHLO mail.alarsen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232254AbhIPHJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 03:09:27 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2021 03:09:25 EDT
Received: from oscar.alarsen.net (unknown [IPv6:fd8b:531:bccf:96:39a7:83c1:5247:58d7])
        by joe.alarsen.net (Postfix) with ESMTPS id AAC7A180255;
        Thu, 16 Sep 2021 09:02:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alarsen.net; s=joe;
        t=1631775737; bh=oaWiy3941asGmQdU0t8Spdb3xrM4VKJq8AFtrBfhgJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FA8bIvnmYzDGl1DiFArlpFrsxGozZYdTiPu3FAjfQ8BBaJL01aFd1YVLlrzsz8TEn
         dv+GKlWr7ihbAGrWebwbn410wk8qOwdKRBK7xP0k6mB2I0HXtTuPbJCfnbgNIZytC4
         jPDPqG0ytTKEtbkfS0IX9JQSPfWvwSGyORQqGtaA=
Received: from oscar.localnet (localhost [IPv6:::1])
        by oscar.alarsen.net (Postfix) with ESMTP id 9AAD227C050D;
        Thu, 16 Sep 2021 09:02:17 +0200 (CEST)
From:   Anders Larsen <al@alarsen.net>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
Date:   Thu, 16 Sep 2021 09:02:17 +0200
Message-ID: <5497691.DvuYhMxLoT@alarsen.net>
In-Reply-To: <CAHk-=wjynK7SSgTOvW7tfpFZZ0pzo67BsOsqtVHYtvju8F_bng@mail.gmail.com>
References: <20210915035227.630204-1-linux@roeck-us.net> <CAHk-=whSkMh9mc7+OSBZZvpoEEJmS6qY7kX3qixEXTLKGc=wgw@mail.gmail.com> <CAHk-=wjynK7SSgTOvW7tfpFZZ0pzo67BsOsqtVHYtvju8F_bng@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, 2021-09-15 23:19 Linus Torvalds wrote:
> Ok, I didn't love any of the patches I saw for the qnx4 problem, so I
> silenced that warning with a new patch of my own. Like the sparc64
> case, the fix is to describe more extensively to the compiler what the
> code is actually doing.

thanks, looks good to me, too!

> Looking at the qnx4 code-base history, I don't think it has gotten any
> actual development outside of cleanups in the git history timeframe,
> which makes me suspect nobody uses this code.
> 
> But hey, maybe it just works so well for the very specialized user base ...

it's actually the latter (although I guess the user base is shrinking)

Cheers
Anders




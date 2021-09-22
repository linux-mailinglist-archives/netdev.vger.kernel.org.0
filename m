Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97BD4151A2
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 22:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237751AbhIVUwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 16:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237592AbhIVUwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 16:52:14 -0400
Received: from wp441.webpack.hosteurope.de (wp441.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:85d2::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2859FC061574;
        Wed, 22 Sep 2021 13:50:44 -0700 (PDT)
Received: from [2a03:7846:b79f:101:21c:c4ff:fe1f:fd93] (helo=valdese.nms.ulrich-teichert.org); authenticated
        by wp441.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1mT9CG-0005WO-MM; Wed, 22 Sep 2021 22:50:28 +0200
Received: from valdese.nms.ulrich-teichert.org (localhost [127.0.0.1])
        by valdese.nms.ulrich-teichert.org (8.15.2/8.15.2/Debian-8+deb9u1) with ESMTPS id 18MKoRqo007275
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 22:50:27 +0200
Received: (from ut@localhost)
        by valdese.nms.ulrich-teichert.org (8.15.2/8.15.2/Submit) id 18MKoNUh007272;
        Wed, 22 Sep 2021 22:50:23 +0200
Message-Id: <202109222050.18MKoNUh007272@valdese.nms.ulrich-teichert.org>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     torvalds@linux-foundation.org (Linus Torvalds)
Date:   Wed, 22 Sep 2021 22:50:23 +0200 (CEST)
Cc:     krypton@ulrich-teichert.org (Ulrich Teichert),
        mcree@orcon.net.nz (Michael Cree),
        linux@roeck-us.net (Guenter Roeck),
        rth@twiddle.net (Richard Henderson),
        ink@jurassic.park.msu.ru (Ivan Kokshaysky),
        mattst88@gmail.com (Matt Turner),
        James.Bottomley@hansenpartnership.com (James E . J . Bottomley),
        deller@gmx.de (Helge Deller),
        davem@davemloft.net (David S . Miller),
        kuba@kernel.org (Jakub Kicinski),
        linux-alpha@vger.kernel.org (alpha),
        geert@linux-m68k.org (Geert Uytterhoeven),
        linux-kernel@vger.kernel.org (Linux Kernel Mailing List),
        linux-parisc@vger.kernel.org (linux-parisc),
        netdev@vger.kernel.org (Netdev),
        linux-sparse@vger.kernel.org (Sparse Mailing-list)
In-Reply-To: <CAHk-=whwreptD=WByMRNsv-gfqR3oUu4v33i5Swd2dyeLObyRw@mail.gmail.com>
From:   Ulrich Teichert <krypton@ulrich-teichert.org>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;ut@ulrich-teichert.org;1632343844;1aa4b7df;
X-HE-SMSGID: 1mT9CG-0005WO-MM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> > I would try the SRM bootimage (make bootimage), but the build is broken:
> 
> The attached patch is too ugly for words, and there's no way I will
> commit anything like this.
> 
> But it at least builds for and seems to successfully make an alpha
> bootimage even when cross-compiling on x86-64.
> 
> So something to test, perhaps..

Sure, I burned it to a CDROM and booted from that per SRM. The screen
went black for a second, then the SRM console came back with:

?05 HLT INSTR
PC=00000000.20000014 PSL= 00000000.00000007

I wonder if we would be able to see more on a serial line - I can try
that perhaps tomorrow or at the weekend. To find out to what code the
PC is pointing to, I would need to understand to what point in memory SRM
loads the image into.... But this way, the process of loading the kernel
definitely worked - I still don't understand why aboot can load the
old kernel but not the new one. I'll have a look at the aboot sources,
perhaps there's a certain limit on kernel size?

I'm not sure if we can call this progress,
CU,
Uli
-- 
Dipl. Inf. Ulrich Teichert|e-mail: Ulrich.Teichert@gmx.de | Listening to:
Stormweg 24               |Eat Lipstick: Dirty Little Secret, The Baboon Show:
24539 Neumuenster, Germany|Work Work Work, The Bellrays: Bad Reaction

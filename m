Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5981D4107C7
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 19:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238442AbhIRRTY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 18 Sep 2021 13:19:24 -0400
Received: from lixid.tarent.de ([193.107.123.118]:57114 "EHLO mail.lixid.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238713AbhIRRTX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 13:19:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id A8248141123;
        Sat, 18 Sep 2021 19:17:56 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id hcvCekh7OY7L; Sat, 18 Sep 2021 19:17:51 +0200 (CEST)
Received: from tglase-nb.lan.tarent.de (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 952AE14094E;
        Sat, 18 Sep 2021 19:17:49 +0200 (CEST)
Received: by tglase-nb.lan.tarent.de (Postfix, from userid 1000)
        id 00B7B520523; Sat, 18 Sep 2021 19:17:48 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase-nb.lan.tarent.de (Postfix) with ESMTP id F1989520515;
        Sat, 18 Sep 2021 19:17:48 +0200 (CEST)
Date:   Sat, 18 Sep 2021 19:17:48 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     Ulrich Teichert <krypton@ulrich-teichert.org>,
        Michael Cree <mcree@orcon.net.nz>,
        Guenter Roeck <linux@roeck-us.net>,
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
In-Reply-To: <CAHk-=whY5mLggPSr2U00mqgUbRJYnYSxtNZm4FnEtQrHftYr8Q@mail.gmail.com>
Message-ID: <56956079-19c3-d67e-d3f-92e475c71f6b@tarent.de>
References: <20210918095134.GA5001@tower> <202109181311.18IDBKQB005215@valdese.nms.ulrich-teichert.org> <CAHk-=whY5mLggPSr2U00mqgUbRJYnYSxtNZm4FnEtQrHftYr8Q@mail.gmail.com>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Sep 2021, Linus Torvalds wrote:

> > > On Thu, Sep 16, 2021 at 11:35:36AM -0700, Linus Torvalds wrote:
> > > > Naah. I think the Jensen actually had an ISA slot. Came with a
> > > > whopping 8MB too, so the ISA DMA should work just fine.
> > > >
> > > > Or maybe it was EISA only? I really don't remember.
> >
> > It's EISA only. I've made some pictures of a somewhat dusty inside of

> So we do want CONFIG_ISA for alpha, even if not Jensen.

Considering you can actually put ISA cards, 8 and 16 bit both,
into EISA slots, I’d have assumed so. I don’t understand the
“EISA only” question above.

bye,
//mirabilos (not using an Alpha but still using x86 ISA cards)
-- 
<cnuke> den AGP stecker anfeilen, damit er in den slot aufm 440BX board passt…
oder netzteile, an die man auch den monitor angeschlossen hat und die dann für
ein elektrisch aufgeladenes gehäuse gesorgt haben […] für lacher gut auf jeder
LAN party │ <nvb> damals, als der pizzateig noch auf dem monior "gegangen" ist

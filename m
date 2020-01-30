Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F49014DA7C
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 13:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgA3MQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 07:16:05 -0500
Received: from edrik.securmail.fr ([45.91.125.3]:43034 "EHLO
        edrik.securmail.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgA3MQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 07:16:05 -0500
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jan 2020 07:16:04 EST
Received: by edrik.securmail.fr (Postfix, from userid 58)
        id 3926BB0D57; Thu, 30 Jan 2020 13:06:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=swordarmor.fr;
        s=swordarmor; t=1580385981;
        bh=+5oHzbslc2yfbbq2D+xtm6+1Z9AqDPE33dFjz6mCBqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=sRHeNIpqS4Bioxut5gv25J3ESs5tQ77OBzyFfeBvvSpIHXxF5SqS6phKFZw5AAzuo
         hfwgHbMOjusmX80zUVDvWXHuRwNlR4jPGcyzKTm/5sl+WCh0r06vzYJ8majF2wIw4y
         PlUM4yTNquFY2Y1V/wAcvCBTpu4V+UfwvLQ8HdnU=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on edrik.securmail.fr
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=5.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU autolearn=unavailable autolearn_force=no
        version=3.4.2
Received: from mew.swordarmor.fr (mew.swordarmor.fr [IPv6:2a00:5884:102:1::4])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: alarig@swordarmor.fr)
        by edrik.securmail.fr (Postfix) with ESMTPSA id 3BEADB0D3C;
        Thu, 30 Jan 2020 13:06:16 +0100 (CET)
Authentication-Results: edrik.securmail.fr/3BEADB0D3C; dmarc=none (p=none dis=none) header.from=swordarmor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=swordarmor.fr;
        s=swordarmor; t=1580385976;
        bh=+5oHzbslc2yfbbq2D+xtm6+1Z9AqDPE33dFjz6mCBqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=SggDMhG+xdMiYNdl/Ptd0O3jtK24XDgeQ6HazlNMiF2Vy747WE1HD2nerzRDetjkE
         zl/JjUBP9gIbE5TftQNXjSEareQl0HKqwrMPAb5iX878UlEYelRN3xJOj8blc7Gcz1
         orbBJIC1F/5iBRdkaESAF8jdj01pl568z8aprwMU=
Date:   Thu, 30 Jan 2020 13:06:59 +0100
From:   Alarig Le Lay <alarig@swordarmor.fr>
To:     Captain Wiggum <captwiggum@gmail.com>
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>,
        Levente <leventelist@gmail.com>, netdev <netdev@vger.kernel.org>
Subject: Re: IPv6 test fail
Message-ID: <20200130120659.b3dxp43mk74ahmqq@mew.swordarmor.fr>
References: <CACwWb3CYP9MENZJAzBt5buMNxkck7+Qig9yYG8nTYrdBw1fk5A@mail.gmail.com>
 <CAHapkUgCWS4DxGVL2qJsXmiAEq4rGY+sPTROx4iftO6mD_261g@mail.gmail.com>
 <CAB=W+o=-XEu_QZtrt6_Qt-HB4CUH+4nUs1o02tVFqJJkdi_bhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB=W+o=-XEu_QZtrt6_Qt-HB4CUH+4nUs1o02tVFqJJkdi_bhg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

It seems that I’m not here for enough time, I can’t find your thread.
What were your issues on IPv6? I hit some from migrating to 4.19 (from
4.4) on routers, so I’m still on 4.4 for now.

We discussed it a bit on bird ML:
https://bird.network.cz/pipermail/bird-users/2019-June/013509.html
https://bird.network.cz/pipermail/bird-users/2019-November/013992.html
https://bird.network.cz/pipermail/bird-users/2019-December/014011.html

(sorry for the multiple links, it seems that the archive is split by
months)

By chances, are we hitting the same bug?

Regards,
Alarig Le Lay

On mer. 29 janv. 15:31:20 2020, Captain Wiggum wrote:
> (resending without html.:)
> I started the thread.
> We are using 4.19.x and 4.9.x, but for reference I also tested then current 5.x.
> I believe we got it all worked out at the time.
> --John Masinter
> 
> 
> On Wed, Dec 18, 2019 at 2:00 PM Stephen Suryaputra <ssuryaextr@gmail.com> wrote:
> >
> > I am curious: what kernel version are you testing?
> > I recall that several months ago there is a thread on TAHI IPv6.
> > Including the person who started the thread.
> >
> > Stephen.
> >
> > On Thu, Oct 24, 2019 at 7:43 AM Levente <leventelist@gmail.com> wrote:
> > >
> > > Dear list,
> > >
> > >
> > > We are testing IPv6 again against the test specification of ipv6forum.
> > >
> > > https://www.ipv6ready.org/?page=documents&tag=ipv6-core-protocols
> > >
> > > The test house state that some certain packages doesn't arrive to the
> > > device under test. We fail test cases
> > >
> > > V6LC.1.2.2: No Next Header After Extension Header
> > > V6LC.1.2.3: Unreacognized Next Header in Extension Header - End Node
> > > V6LC.1.2.4: Extension Header Processing Order
> > > V6LC.1.2.5: Option Processing Order
> > > V6LC.1.2.8: Option Processing Destination Options Header
> > >
> > > The question is that is it possible that the this is the intended way
> > > of operation? I.e. the kernel swallows those malformed packages? We
> > > use tcpdump to log the traffic.
> > >
> > >
> > > Thank you for your help.
> > >
> > > Levente

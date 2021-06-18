Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1DA3AD07E
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbhFRQfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235534AbhFRQfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 12:35:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 110C8613D5;
        Fri, 18 Jun 2021 16:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624034004;
        bh=JO2gLgelUahEc1dNQVYz2I/ragI2iCfD3iyf0s0vVmc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gsyLR0OZOilo0EEdP29NRWHxpna2TcpNAh65/OuClP+XuPWLnj9OcMeqeYx7BXQ2X
         pZDWq3/0VwY1KSWIQKSZ7U+YlmUMx0i8xoW7NWyjgBrNe3L/HnVZi4Ku6LZrsAF2gF
         1DjKkgbUD46s25gdRbsthB9ZKHcwMD2Kz2hfYjvzp1KNNoJxbqMcNMmhEFO+Gr51pq
         ecUl9tZOzzQR6w9opI5NTaWVeIYwQYtlMu4LWKFyTF1MqXBW97fMF714JB/oWyeiO5
         rZxlsOqaJ73tSRcuGelVCZxhBg/fQvl3AVhF0At2f8PTHsdYX9KxL3Zb4UQcpmXyis
         eLd1k4eZDHnzA==
Date:   Fri, 18 Jun 2021 18:33:16 +0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Matthew Wilcox <willy@infradead.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Hildenbrand <david@redhat.com>, Greg KH <greg@kroah.com>,
        Christoph Lameter <cl@gentwo.de>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
Message-ID: <20210618183316.33766f1e@coco.lan>
In-Reply-To: <20210618113452.7ab0033e@oasis.local.home>
References: <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
        <20210610182318.jrxe3avfhkqq7xqn@nitro.local>
        <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
        <20210610152633.7e4a7304@oasis.local.home>
        <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
        <YMyjryXiAfKgS6BY@pendragon.ideasonboard.com>
        <cd7ffbe516255c30faab7a3ee3ee48f32e9aa797.camel@HansenPartnership.com>
        <CAMuHMdVcNfDvpPXHSkdL3VuLXCX5m=M_AQF-P8ZajSdXt8NdQg@mail.gmail.com>
        <20210618103214.0df292ec@oasis.local.home>
        <CAMuHMdWK4NPzanF68TMVuihLFdRzxhs0EkbZdaA=BUkZo-k6QQ@mail.gmail.com>
        <YMy4UjWH565ElFtZ@casper.infradead.org>
        <CAMuHMdWqUkfe7kdBO+eQdXHzhpygH=TivOBNqQJujyqP=wM5cw@mail.gmail.com>
        <20210618113452.7ab0033e@oasis.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, 18 Jun 2021 11:34:52 -0400
Steven Rostedt <rostedt@goodmis.org> escreveu:

> On Fri, 18 Jun 2021 17:29:04 +0200
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > W.r.t. the other speaker in the room, isn't that similar to the normal mic,
> > and can't that be handled at the receiving side?
> > There will be a bit more delay involved, though.  
> 
> How many times have you been in a conference where the normal mic and
> speaker caused a nasty feedback loop?

I never used, but there are some devices that can work as automatic feedback 
suppressors. They basically detect a feedback loop and add notch filter(s) to
the frequency(ies) that are looping. Some high-end digital mixers have this
feature embedded (but the operator may need to enable it).

Yet, you may still hear the feedback loop while the algorithm is detecting 
and correcting the issue, as it takes 100 ms to 400ms to detect and filter
a single feedback frequency.

> I'm not sure how well phone mics and room speakers will work.

I guess that this depends on how the environment is setup. A good
digital mixer can be set with a gate threshold. If the volume is below
the threshold, the mic will be muted. 

They can also be setup to have just one microphone group, where only
one microphone will have the volume raised on a given time. So, if
someone speaks on a mic, all the others are muted or attenuated.

Yet, I guess this is not the usual "package" provided by hotels.
Those setups may require extra devices and technical people that
knows now to use such features.

Thanks,
Mauro

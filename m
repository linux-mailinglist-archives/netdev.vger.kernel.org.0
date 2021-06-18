Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FFB3ACEFE
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 17:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbhFRPcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 11:32:09 -0400
Received: from mail-vk1-f171.google.com ([209.85.221.171]:36787 "EHLO
        mail-vk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbhFRPb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 11:31:28 -0400
Received: by mail-vk1-f171.google.com with SMTP id c17so2216360vke.3;
        Fri, 18 Jun 2021 08:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tbwA+IyCm/NwRqK4N5oJ3bfkUBqvAezf/1PBaQCP7JY=;
        b=JPsaYHjtczQ2SHwZ2VHowOAXSyd6k9c04k8lSMpJxNUNI3WOxuFTqXl0qvxLZ6BKDP
         bsjEBqOX4M7kBymcrCH7Tju5R32bSQs0VoBsYOFhC5H0P00N4OhjlDN36GajlvnA38U8
         zvXARxCKBuBYniU6geq+xqnjWJ3wL85FwESFQHmmagYijzIA/GSQW4hqx3TJjv3WwnEs
         7cQkCe9tpom/oid1ScqOwTj5tTwnF5IAVeIlt/yrCxiQhsOo3t35ayGwkdM3aGPELTAm
         chpvIMfrnzSzfVYAkTi3XEldIc7GiRbMKiV1qJTTTb+hPAErnr29GC/v878cxZ+DiCKy
         ihjQ==
X-Gm-Message-State: AOAM5335kupY3m9Nbb8oHdZJOtX7xhfsjG8OwFvgTe9EokKiss2yTO3x
        h9B8TNNVPMwqzXF3fyG3IEVK7GLP/X5ElLQixzI=
X-Google-Smtp-Source: ABdhPJxEmFJfAgHdVEc+LB6mHSUHXYmYvJXtX7mWpBI0zcQ/6Lnom0KNtzfTrxWWH15izbyVI9mkUGQnhQl2V6QtMjM=
X-Received: by 2002:a1f:1a41:: with SMTP id a62mr6774027vka.5.1624030156104;
 Fri, 18 Jun 2021 08:29:16 -0700 (PDT)
MIME-Version: 1.0
References: <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
 <20210610182318.jrxe3avfhkqq7xqn@nitro.local> <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
 <20210610152633.7e4a7304@oasis.local.home> <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
 <YMyjryXiAfKgS6BY@pendragon.ideasonboard.com> <cd7ffbe516255c30faab7a3ee3ee48f32e9aa797.camel@HansenPartnership.com>
 <CAMuHMdVcNfDvpPXHSkdL3VuLXCX5m=M_AQF-P8ZajSdXt8NdQg@mail.gmail.com>
 <20210618103214.0df292ec@oasis.local.home> <CAMuHMdWK4NPzanF68TMVuihLFdRzxhs0EkbZdaA=BUkZo-k6QQ@mail.gmail.com>
 <YMy4UjWH565ElFtZ@casper.infradead.org>
In-Reply-To: <YMy4UjWH565ElFtZ@casper.infradead.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 18 Jun 2021 17:29:04 +0200
Message-ID: <CAMuHMdWqUkfe7kdBO+eQdXHzhpygH=TivOBNqQJujyqP=wM5cw@mail.gmail.com>
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 5:15 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Fri, Jun 18, 2021 at 04:58:08PM +0200, Geert Uytterhoeven wrote:
> > On Fri, Jun 18, 2021 at 4:32 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > > On Fri, 18 Jun 2021 16:28:02 +0200
> > > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > >
> > > > What about letting people use the personal mic they're already
> > > > carrying, i.e. a phone?
> > >
> > > Interesting idea.
> > >
> > > I wonder how well that would work in practice. Are all phones good
> > > enough to prevent echo?
> >
> > I deliberately didn't say anything about a speaker ;-)
>
> There's usually a speaker in the room so everyone can hear the question
> ...

Oh IC.  I meant that not using the speaker on the phone, there cannot
be any feedback from the phone speaker to the phone mic.

W.r.t. the other speaker in the room, isn't that similar to the normal mic,
and can't that be handled at the receiving side?
There will be a bit more delay involved, though.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
